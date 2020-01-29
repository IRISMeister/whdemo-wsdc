Include CommonInc

/// メーカへの発注処理
Class WSDC.Service.InitiatePurchase Extends Ens.BusinessMetric
{

Method OnCalculateMetrics() As %Status
{
	#dim rslt as %SQL.StatementResult
	Set tSC=$$$OK
	
	Try {
		Set st=$ZH
		Set sql(1)="UPDATE WSDC_Data.Inventory Set 発注日=?,発注日時=?,発注回数=発注回数+1,発注数=発注数+?,発注時入荷数量=入荷数量,発注時入荷ｵｰﾀﾞ数量=入荷ｵｰﾀﾞ数量,発注時出荷数量=出荷数量,発注時出荷ｵｰﾀﾞ数量=出荷ｵｰﾀﾞ数量,発注時実在庫=実在庫,発注時理論在庫=理論在庫 WHERE 商品コード=?"
		Set sql(2)="INSERT INTO WSDC_Data.InBound (オーダ番号,オーダ日付,商品コード,数量,発注時実在庫数,発注時理論在庫数) VALUES (?,?,?,?,?,?)"

		For i=1:1:2 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			$$$ThrowOnError(tSC)
		}

		Set pResponse=##class(Ens.Response).%New()
		
		#;Set sql="SELECT * FROM WSDC_Data.Inventory" 
		#; ++扱う商品種類数を制限するため、暫定的にSQLを変更++
		Set maxid=$$$NumOfItems*5
		Set sql="SELECT * FROM WSDC_Data.Inventory i,Common.ProductMaster p where i.商品コード=p.商品コード and p.ID<"_maxid 
		#; --扱う商品種類数を制限するため、暫定的にSQLを変更--

 		Set rs=##class(%SQL.Statement).%ExecDirect(,sql) Do rs.%Next() 
 		If rs.%SQLCODE'=0,rs.%SQLCODE'=100 Throw ##class(%Exception.SQL).CreateFromSQLCODE(rs.SQLCODE,rs.%Message)

		Set today=##class(Common.Util).GetToday()
		Set container=##class(WSHQ.DC.InboundOrderContainer).%New()

		Set st2=$ZH
		Set rs0=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")
		Do {
			Set 商品コード=rs.商品コード
			Set 平均出庫量=rs.平均出庫量			
			Set 出庫量標準偏差=rs.出庫量標準偏差	
			Set リードタイム=rs.リードタイム
			If 出庫量標準偏差=0 { Set 安全在庫数=平均出庫量/2 }  		//過去データが無いときの目安は平均出庫量/2で良い？
			Else {
				Set 安全在庫数=$NUMBER(1.65*出庫量標準偏差*$ZSQR(リードタイム),0)    //95% service level
			}
			Set 発注点在庫量=平均出庫量*(リードタイム+1)+安全在庫数  
			Set 理論在庫=rs.理論在庫
			Set 実在庫=rs.実在庫
			Set 発注数=rs.発注数
			
			;$$$LOGINFO("商品コード:"_商品コード_" 理論在庫+発注数:"_(理論在庫+発注数)_" 平均出庫量:"_平均出庫量_" リードタイム:"_リードタイム_" 発注点在庫量:"_発注点在庫量_" 安全在庫数:"_安全在庫数_" 発注数量:"_(発注点在庫量+安全在庫数)-(理論在庫+発注数))

			#;(理論在庫+発注数)が(発注点在庫量)以下になったら発注する
			If ((実在庫+発注数)<発注点在庫量){
				Set order=##class(WSHQ.DC.InboundOrder).%New()
				Set オーダ番号=..GetNewOrderNo()
				Set オーダ日付=today
				#;Set 数量=発注点在庫量-(実在庫+発注数)    ;試験的に変更中。注文が欠品になると出荷数に反映されないため、常に不足気味なるのを試験的に回避。
				Set 数量=発注点在庫量-発注数
				Set order."オーダ番号"=オーダ番号
				Set order."オーダ日付"=オーダ日付
				Set order."商品コード"=商品コード
				Set order."数量"=数量
				Do container.Messages.Insert(order)
				#;$$$LOGINFO("発注オーダ作成 商品コード:"_商品コード_" 理論在庫+発注数:"_(理論在庫+発注数)_" 実在庫+発注数:"_(実在庫+発注数)_" 平均出庫量:"_平均出庫量_" リードタイム:"_リードタイム_" 発注点在庫量:"_発注点在庫量_" 安全在庫数:"_安全在庫数_" 発注数量:"_数量)
				
				#;ここでlock取得タイムアウトが発生することがある。
				#;エラー #5540: SQLCODE: -110 メッセージ: テーブル 'WSDC_Data.Inventory' の UPDATE のための RowID = '68' に対するロックが取得できません
				#;該当商品の在庫管理台帳を更新
				$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(today,$ZDATETIME($H,3),数量,商品コード))

				#;発注の履歴を追加
				$$$SQLPREUPD(rs(2),stmt(2),$$$SQLARGS(オーダ番号,オーダ日付,商品コード,数量,実在庫,理論在庫))

			}

		} While (rs.%Next()) 

		Set rs0=##class(%SQL.Statement).%ExecDirect(,"COMMIT")
		Set en2=$ZH
		$$$LOGINFO("発注オーダ作成 :"_container.Messages.Count()_"件 経過(秒):"_(en2-st2))
		
		#;WSHQに発注オーダを送信するためのOperationを呼び出す。
		#;ここで送信失敗すると(WSHQがとまってるとか)、発注がロストする。
		#;送信失敗した発注オーダを(復旧後の)WSHQに再送するために、Operationの再送機能を使用することを想定している。ReplyCodeActions: E=RD。再試行間隔,再試行タイムアウトを調整すること。
		If container.Messages.Count()>0 {
			Set tSC=..SendRequestAsync("HQ",container)
			$$$ThrowOnError(tSC)
			Set en=$ZH
			$$$LOGINFO("発注オーダ送信 :"_container.Messages.Count()_"件 経過(秒):"_(en-st))
		}

	}
	Catch e {
		$$$CATCH(e)
	}

	 Return tSC
}

ClassMethod GetNewOrderNo()
{
	Set o=$INCREMENT(^WSDC.InboundOrder)
	Return "IO"_$REPLACE($J(o,8)," ","0")
}

ClassMethod DumpShipCountStats()
{
	Set sql=
	"SELECT 商品コード,ROUND(AVG(N),0) AS AVGN,ROUND(STDDEV_POP(N),0) AS STDN FROM ("_
		"SELECT 商品コード,出荷日付,SUM(数量) AS N FROM WSDC_Data.Shipping group by 商品コード,出荷日付 having 出荷日付<?"_
	") group by 商品コード"
	Set today=##class(Common.Util).GetToday()
	Set rs=##class(%SQL.Statement).%ExecDirect(,sql,today) 
	Do rs.%Display()
}

}
