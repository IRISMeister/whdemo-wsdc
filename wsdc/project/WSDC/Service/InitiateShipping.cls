Include CommonInc

/// 出荷処理
Class WSDC.Service.InitiateShipping Extends Ens.BusinessMetric
{

/// 出荷検品
/// 出荷作業後に、実行されることを想定。現在はServiceから定期実行。
/// 出荷オーダファイル(当日分)=ShippingOrderを読みながら、
/// 1.送り状=ShippingDeliveryNoteを作成
/// 2.当日出荷ファイル=CurrentShippingを作成
/// 3.出荷オーダファイル(当日分)=ShippingOrderから削除
/// 4.在庫管理台帳を更新
/// 前日出荷オーダ残ファイル=BackOrder を読みながら、1-4と同じことを実行。
Method OnCalculateMetrics() As %Status
{
	#dim rslt as %SQL.StatementResult
	Set tSC=$$$OK
	
	Try {
		Set st=$ZH,cnt=0

		Set sql(1)="INSERT INTO WSDC_Data.ShippingDeliveryNote (オーダ番号,出荷番号,オーダ日付,商品コード ,数量,出荷先コード,出荷予定日付) VALUES (?,?,?,?,?,?,?)"
		Set sql(2)="INSERT INTO WSDC_Data.Shipping (オーダ番号,出荷番号,オーダ日付,商品コード ,数量,出荷先コード,出荷日付,商品原価,商品売価,商品分類,出荷時実在庫数) VALUES (?,?,?,?,?,?,?,?,?,?,?)"
		Set sql(3)="DELETE FROM WSDC_Data.ShippingOrder WHERE ID=?" 
		Set sql(4)="SELECT 1" 
		Set sql(5)="SELECT 1"
		Set sql(6)="UPDATE WSDC_Data.Inventory Set 出荷数量=出荷数量+? WHERE 商品コード=?"
		Set sql(7)="SELECT * FROM Common.ProductMaster WHERE 商品コード=?"
		Set sql(8)="SELECT * FROM WSDC_Data.Inventory WHERE 商品コード=?"

		For i=1:1:8 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
		}

		Set rs=##class(%SQL.Statement).%ExecDirect(,"SET TRANSACTION ISOLATION LEVEL READ COMMITTED")

		Set today=##class(Common.Util).GetToday()
		Set sql="SELECT * FROM WSDC_Data.ShippingOrder WHERE 出荷予定日付<=?"
		$$$SQLDIRECTQUERY(rs,sql,$$$SQLARGS(today))
		If rs.%SQLCODE=100 {
			Set en=$ZH
			$$$LOGINFO("出荷検品(当日):0件 経過(秒):"_(en-st))
			Quit
		}

		Kill RowSet
		#;カート、マテハンへのデータ送信のためのメッセージ
		Set pcContainer=##class(WSDC.Req.PickingCartContainer).%New()
		Set mheContainer=##class(WSDC.Req.MHEContainer).%New()

		Set st2=$ZH
		Set rs0=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")
		Do {
			Set id=rs.ID
			Set オーダ番号=rs.オーダ番号
			Set オーダ日付=rs.オーダ日付
			Set 商品コード=rs.商品コード
			Set 数量=rs.数量
			Set 出荷予定日付=rs.出荷予定日付
			Set 出荷先コード=rs.出荷先コード
			Set 出荷番号=rs.出荷番号
			#;w cnt_") "_オーダ番号,!
			
			#;送り状
			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(オーダ番号,出荷番号,オーダ日付,商品コード ,数量,出荷先コード,出荷予定日付))

			#;現在の在庫数を取得
			$$$SQLPREQUERY(rs(8),stmt(8),$$$SQLARGS(商品コード))
			Set 出荷時実在庫数=rs(8).実在庫

			$$$SQLPREQUERY(rs(7),stmt(7),$$$SQLARGS(商品コード))
			Set 原価=rs(7).原価
			Set 売価=rs(7).売価
			Set 分類=rs(7).分類
			
			#;出荷履歴
			$$$SQLPREUPD(rs(2),stmt(2),$$$SQLARGS(オーダ番号,出荷番号,オーダ日付,商品コード ,数量,出荷先コード,出荷予定日付,原価,売価,分類,出荷時実在庫数))

			#;処理済みレコードを出荷オーダファイル(当日分)から削除
			Set RowSet(id)=""

			#;在庫管理台帳の出荷数量を更新
			$$$SQLPREUPD(rs(6),stmt(6),$$$SQLARGS(数量,商品コード))
			If rs(6).%SQLCODE=100 { $$$LOGERROR("shouldn't happen!!!")}

			Set pc=##class(WSDC.Req.PickingCart).%New()
			Set pc."オーダ番号"=オーダ番号
			Do pcContainer.Reqs.Insert(pc)

			Set mhe=##class(WSDC.Req.MHE).%New()
			Set mhe."オーダ番号"=オーダ番号
			Do mheContainer.Reqs.Insert(mhe)

			Set cnt=cnt+1
		} While (rs.%Next()) 

		Set rs="",rs(6)="",rs(7)="",rs(8)=""   // read commited では、カーソルを閉じないとsharedLockが残る。

		Set rs0=##class(%SQL.Statement).%ExecDirect(,"COMMIT")
		$$$DSQLERRCHECK(rs0)
		Set en2=$ZH
		$$$LOGINFO("出荷検品トランザクション:"_cnt_"件 経過(秒):"_(en2-st2))

		#;Do ..DebugDumpLocks("After main loop")
		
		#;送信失敗に備えて、Operationの再送機能を使用することを想定している。ReplyCodeActions: E=RD。再試行間隔,再試行タイムアウトを調整すること。
		Set tSC=..SendRequestSync("PickingCart",pcContainer,.response) 	//カートに情報を送信
		If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
		Set tSC=..SendRequestSync("MHE",mheContainer,.response) 	//マテハンに情報を送信
		If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }

		#;カート、マテハン双方へのデータ送信が成功した場合のみ、出荷オーダを削除する。		
		$$$LOGINFO("出荷オーダを削除")
		Set id="" For {
			Set id=$O(RowSet(id)) Q:id=""
			$$$SQLPREUPD(rs(3),stmt(3),$$$SQLARGS(id))
		}

		#;Do ..DebugDumpLocks("After delete")

		Set en=$ZH
		$$$LOGINFO("出荷検品:"_cnt_"件 経過(秒):"_(en-st))

	}
	Catch e {
		#;掛け捨てのロールバック
		Set rs0=##class(%SQL.Statement).%ExecDirect(,"ROLLBACK")
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))

		Set en=$ZH
		$$$LOGERROR("出荷検品エラー:"_cnt_"件 経過(秒):"_(en-st))
	}
	Set rs=##class(%SQL.Statement).%ExecDirect(,"SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED")
	Return tSC
}

ClassMethod DebugDumpLocks(text)
{
  SET lname=""
  FOR I=1:1 {
      SET lname=$ORDER(^$LOCK(lname))
      QUIT:lname=""
      Set owner=^$LOCK(lname,"OWNER")
      If owner'=$J Continue
      If $E(lname,1,$L("^Ens.JobLock"))="^Ens.JobLock" Continue
      If $E(lname,1,$L("^IRIS.Temp"))="^IRIS.Temp" Continue
      Set mode=^$LOCK(lname,"MODE")
      $$$LOGINFO(text_": the lock name is: "_lname_" Mode:"_mode_" Owner:"_owner_" $TL="_$TL)
  }
}

}
