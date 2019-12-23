Include (CommonInc, Ensemble)

Class WSDC.Service.HQ Extends EnsLib.SOAP.Service
{

Parameter ADAPTER;

Parameter SERVICENAME = "WSDC.HQ";

Parameter NAMESPACE = "http://tempuri.org";

Parameter USECLASSNAMESPACES = 1;

/// 本部から入荷オーダ受信
Method ReceiveInbound(req As WSDC.WS.ReceivingOrderContainer) As %Status [ WebMethod ]
{
#dim msg as WSDC.WS.ReceivingOrder
	Set tSC=$$$OK

	Try {
		Set st=$ZH
		Set sql(1)="INSERT INTO WSDC_Data.ReceivingOrder (オーダ番号,オーダ日付,配送予定日付,商品コード,数量) VALUES (?,?,?,?,?)"
		Set sql(2)="UPDATE WSDC_Data.Inventory Set 入荷ｵｰﾀﾞ数量=入荷ｵｰﾀﾞ数量+?,発注数=発注数-? WHERE 商品コード=?"
		For i=1:1:2 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
		}
		
		Set count=req.Messages.Count()
		For i=1:1:count {
			Set order=req.Messages.GetAt(i)
			Set オーダ番号=order.オーダ番号
			Set オーダ日付=order."オーダ日付"
			Set 配送予定日付=order."配送予定日付"
			Set 商品コード=order."商品コード"
			Set 数量=order."数量"

			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(オーダ番号,オーダ日付,配送予定日付,商品コード,数量))
			
			Set rs(2)=stmt(2).%Execute(数量,数量,商品コード) 
			If rs(2).%SQLCODE=100 {
				$$$LOGERROR("該当商品が存在しません 商品コード:"_商品コード)
			}
			If rs(2).%SQLCODE=-110 {
				$$$LOGERROR("Lock競合発生 商品コード:"_商品コード_" SQLCODE:"_rs(2).SQLCODE_" "_rs(2).%Message)
				#;ToDo:Pendingレコードに退避する？
			}
			Else {
				$$$DSQLERRCHECK(rs(2))
			}

		}

		Set en=$ZH
		$$$LOGINFO("本部から入荷オーダファイル受信:"_count_"件 経過(秒):"_(en-st))

	}
	Catch e {
		#;掛け捨てのロールバック
		Set rs=##class(%SQL.Statement).%ExecDirect(,"ROLLBACK")
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))
	}
	
	Return tSC
}

/// 本部から出荷オーダ受信
Method ReceiveOutbound(req As WSDC.WS.ShippingOrderContainer) As %Status [ WebMethod ]
{
#dim msg as WSDC.WS.ShippingOrder
	Try {
		Set st=$ZH
		Set sql(1)="INSERT INTO WSDC_Data.ShippingOrder (オーダ番号,出荷番号,オーダ日付,出荷予定日付,商品コード,数量,出荷先コード) VALUES (?,?,?,?,?,?,?)"
		Set sql(2)="UPDATE WSDC_Data.Inventory Set 出荷ｵｰﾀﾞ数量=出荷ｵｰﾀﾞ数量+? WHERE 商品コード=?"
		For i=1:1:2 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
		}
		
		Set count=req.Messages.Count()
		For i=1:1:count {
			Set order=req.Messages.GetAt(i)
			Set オーダ番号=order.オーダ番号
			Set 出荷番号=order.出荷番号
			Set オーダ日付=order."オーダ日付"
			Set 出荷予定日付=order."出荷予定日付"
			Set 商品コード=order."商品コード"
			Set 数量=order."数量"
			Set 出荷先コード=order.出荷先コード

			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(オーダ番号,出荷番号,オーダ日付,出荷予定日付,商品コード,数量,出荷先コード))

			Set rs(2)=stmt(2).%Execute(数量,商品コード) 
			If rs(2).%SQLCODE=100 {
				$$$LOGERROR("該当商品が存在しません 商品コード:"_商品コード)
			}
			If rs(2).%SQLCODE=-110 {
				$$$LOGERROR("Lock競合発生 商品コード:"_商品コード_" SQLCODE:"_rs(2).SQLCODE_" "_rs(2).%Message)
				#;ToDo:Pendingレコードに退避する？
			}
			Else {
				$$$DSQLERRCHECK(rs(2))
			}
			
		}

		Set en=$ZH
		$$$LOGINFO("本部から出荷オーダファイル(当日分)受信:"_count_"件 経過(秒):"_(en-st))

	}
	Catch e {
		#;掛け捨てのロールバック
		Set rs=##class(%SQL.Statement).%ExecDirect(,"ROLLBACK")
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))
	}
	
	Return tSC
}

}
