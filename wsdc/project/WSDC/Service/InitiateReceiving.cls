Include CommonInc

/// 入荷処理(検品処理)
Class WSDC.Service.InitiateReceiving Extends Ens.BusinessMetric
{

Method OnCalculateMetrics() As %Status
{
	#dim rslt as %SQL.StatementResult
	Set tSC=$$$OK
	
	Try {
		Set st=$ZH,cnt=0

		Set sql(1)="delete from WSDC_Data.ReceivingOrder where オーダ番号=?"
		Set sql(2)="INSERT INTO WSDC_Data.Receiving (オーダ番号,オーダ日付,商品コード ,数量,入荷時実在庫数,入荷時理論在庫数) VALUES (?,?,?,?,?,?)"
		Set sql(3)="SELECT 1"
		Set sql(4)="DELETE FROM WSDC_Data.ReceivingDeliveryNote WHERE ID=?" 
		Set sql(5)="SELECT 1"
		Set sql(6)="UPDATE WSDC_Data.Inventory Set 入荷数量=入荷数量+? WHERE 商品コード=?"
		Set sql(7)="SELECT 実在庫,理論在庫 FROM WSDC_Data.Inventory WHERE 商品コード=?"

		For i=1:1:7 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			$$$ThrowOnError(tSC)
		}

		Set rs=##class(%SQL.Statement).%ExecDirect(,"SET TRANSACTION ISOLATION LEVEL READ COMMITTED")

		#;(メーカから受け取った商品に添付されている)納品書からの全件読み込み
		#;本来このマッチングは実際の検品作業結果との照合を伴うはずだが、省略。
		Set sql="SELECT * FROM WSDC_Data.ReceivingDeliveryNote WHERE 配送日付<=?"

		Set today=##class(Common.Util).GetToday()
		$$$SQLDIRECTQUERY(rs,sql,$$$SQLARGS(today))
		If rs.%SQLCODE=100 Quit

		Set container=##class(WSHQ.DC.ReceivingOrderContainer).%New()
		#;WSDCNameはoperationで設定しているのでここでは不要。
		Kill RowSet
		Set st2=$ZH
		Set rs0=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")
		Do {
			Set order=##class(WSHQ.DC.ReceivingOrder).%New()
			Set id=rs.ID
			Set オーダ番号=rs.オーダ番号
			Set オーダ日付=rs.オーダ日付
			Set 商品コード=rs.商品コード
			Set 数量=rs.数量
			Set オーダ受信日時=rs.オーダ受信日時
			#;w cnt_") "_オーダ番号,!
			Set order."オーダ番号"=オーダ番号
			Set order."オーダ日付"=オーダ日付
			Set order."商品コード"=商品コード
			Set order."数量"=数量
			Set order."配送予定日付"=rs.配送日付
			;Set order.オーダ受信日時=オーダ受信日時
			Do container.Messages.Insert(order)
			
			#;見つかったレコードに合致するレコードを入荷オーダファイル(当日分)から消しこむ
			Set RowSet("R1",オーダ番号)=""

			/*
			#;遅れて到着した分を、前日入荷オーダ残ファイルから消しこむ
			$$$SQLPREUPD(rs0,stmt(3),$$$SQLARGS(オーダ番号))
			*/
			
			#;ここでlock取得タイムアウトが発生することがある。
			#;エラー #5540: SQLCODE: -114 メッセージ: Unable to acquire shared lock on table WSDC_Data.Inventory for RowID value: 13
			$$$SQLPREQUERY(rs(7),stmt(7),$$$SQLARGS(商品コード))
			Set 実在庫=rs(7).実在庫
			Set 理論在庫=rs(7).理論在庫

			#;入荷分は入荷履歴に追加する
			$$$SQLPREUPD(rs0,stmt(2),$$$SQLARGS(オーダ番号,オーダ日付,商品コード ,数量,実在庫,理論在庫))

			#;在庫管理台帳の当日入荷数量を更新
			$$$SQLPREUPD(rs(6),stmt(6),$$$SQLARGS(数量,商品コード))
			If rs(6).%SQLCODE=100 { $$$LOGERROR("shouldn't happen!!!")}

			#;処理済みレコードを納品書から削除
			Set RowSet("R2",id)=""

			Set cnt=cnt+1
		} While (rs.%Next()) 

		Set rs="",rs(7)="" // read commited では、カーソルを閉じないとsharedLockが残る。
		Set rs0=##class(%SQL.Statement).%ExecDirect(,"COMMIT")
		Set en2=$ZH
		$$$LOGINFO("入荷検品処理トランザクション:"_container.Messages.Count()_"件 経過(秒):"_(en2-st2))

		#;WSHQに入荷確定情報を送信
		If container.Messages.Count()>0 {
			Set tSC=..SendRequestAsync("HQ",container)
			$$$ThrowOnError(tSC)
		}

		#;見つかったレコードに合致するレコードを入荷オーダファイルから消しこむ
		Set オーダ番号="" For {
			Set オーダ番号=$O(RowSet("R1",オーダ番号)) Q:オーダ番号=""
			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(オーダ番号))
		}

		#;処理済みレコードを納品書から削除
		Set id="" For {
			Set id=$O(RowSet("R2",id)) Q:id=""
			$$$SQLPREUPD(rs(4),stmt(4),$$$SQLARGS(id)) 
		}
		
		#;Do ##class(WSDC.Service.InitiateShipping).DebugDumpLocks("After delete")

		Set en=$ZH
		$$$LOGINFO("入荷検品処理実施:"_container.Messages.Count()_"件 経過(秒):"_(en-st))
	}
	Catch e {
		$$$CATCH(e,tSC)
	}

	Set rs=##class(%SQL.Statement).%ExecDirect(,"SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED")
	Return tSC
}

}
