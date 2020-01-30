Include (CommonInc, Ensemble)

Class WSDC.Service.Maker Extends EnsLib.SOAP.Service
{

Parameter ADAPTER;

Parameter SERVICENAME = "WSDC.Maker";

Parameter NAMESPACE = "http://tempuri.org";

Parameter USECLASSNAMESPACES = 1;

/// メーカから納品書を受信
Method ReceiveDeliveryNote(req As MAKER.WS.DeliveryNoteContainer) As %Status [ WebMethod ]
{
#dim msg as MAKER.WS.DeliveryNote
	Set tSC=$$$OK

	Try {
		Set st=$ZH
		Set sql(1)="INSERT INTO WSDC_Data.ReceivingDeliveryNote (メーカ出荷番号,オーダ番号,オーダ日付,配送予定日付,配送日付,商品コード,数量) VALUES (?,?,?,?,?,?,?)"
		For i=1:1:1 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			$$$ThrowOnError(tSC)
		}
		Set rs=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")

		Set count=req.Messages.Count()
		For i=1:1:count {
			Set order=req.Messages.GetAt(i)
			Set オーダ番号=order.オーダ番号
			Set オーダ日付=order."オーダ日付"
			Set 配送予定日付=order."配送予定日付"
			Set 配送日付=order."配送日付"
			Set 商品コード=order."商品コード"
			Set 数量=order."数量"
			Set メーカ出荷番号=order.メーカ出荷番号
			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(メーカ出荷番号,オーダ番号,オーダ日付,配送予定日付,配送日付,商品コード,数量))
		}

		Set rs=##class(%SQL.Statement).%ExecDirect(,"COMMIT")
		Set en=$ZH
		$$$LOGINFO("メーカから納品書を受信:"_count_"件 経過(秒):"_(en-st))
		
	}
	Catch e {
		$$$CATCH(e,tSC)
	}
	
	Return tSC
}

}
