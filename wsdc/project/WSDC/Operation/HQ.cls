Include CommonInc

Class WSDC.Operation.HQ Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Parameter INVOCATION = "Queue";

Property WSDCName As %String;

/// メーカへの発注オーダをWSHQに送信
Method DoInboundOrder(pRequest As WSHQ.DC.InboundOrderContainer, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Try {
		Set st=$ZH
		Set container={}
		Set container.Messages=[]
		Set container.Count=0
		Set container.WSDCName=..WSDCName

		#;copy pReuqest contents into container here
		Set count=pRequest.Messages.Count()
		For i=1:1:count {
			Set container.Count=container.Count+1
			Set order=pRequest.Messages.GetAt(i)
			Set jsonorder={}
			Set jsonorder.オーダ番号=order.オーダ番号
			Set jsonorder.オーダ日付=order.オーダ日付
			Set jsonorder.商品コード=order.商品コード
			Set jsonorder.数量=order.数量
			Do container.Messages.%Push(jsonorder)
		}

		;Set tSC=..Adapter.InvokeMethod("ReceiveInboundOrder",.WSResult,pRequest)
		Set httpreq=##class(%Net.HttpRequest).%New()
		Set httpreq.ContentType="application/json; charset=UTF-8"
		Set tempurl=..Adapter.URL,..Adapter.URL=..Adapter.URL_"/IN"
		Set tSC=..Adapter.SendFormData(.HttpResponse,"POST",httpreq,,container.%ToJSON())
		Set ..Adapter.URL=tempurl
		$$$ThrowOnError(tSC)

		Set en=$ZH
		$$$LOGINFO("本部に発注情報を送信:"_pRequest.Messages.Count()_"件 経過(秒):"_(en-st))
	}
	Catch e {
		$$$CATCH(e)
	}
	Return tSC
}

/// 入荷検品作業後に、実行されることを想定。入荷情報をWSHQに送信する。
Method DoReceivingOrder(pRequest As WSHQ.DC.ReceivingOrderContainer, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Try {
		Set st=$ZH
		Set container={}
		Set container.Messages=[]
		Set container.Count=0
		Set container.WSDCName=..WSDCName

		#;copy pReuqest contents into container here
		Set count=pRequest.Messages.Count()
		For i=1:1:count {
			Set container.Count=container.Count+1
			Set order=pRequest.Messages.GetAt(i)
			Set jsonorder={}
			Set jsonorder.オーダ番号=order.オーダ番号
			Set jsonorder.オーダ日付=order.オーダ日付
			Set jsonorder.配送予定日付=order.配送予定日付
			Set jsonorder.商品コード=order.商品コード
			Set jsonorder.数量=order.数量
			Do container.Messages.%Push(jsonorder)
		}

		;Set tSC=..Adapter.InvokeMethod("ReceiveReceivingOrder",.WSResult,pRequest)
		Set httpreq=##class(%Net.HttpRequest).%New()
		Set httpreq.ContentType="application/json; charset=UTF-8"
		Set tempurl=..Adapter.URL,..Adapter.URL=..Adapter.URL_"/RECV"
		Set tSC=..Adapter.SendFormData(.HttpResponse,"POST",httpreq,,container.%ToJSON())
		Set ..Adapter.URL=tempurl
		$$$ThrowOnError(tSC)
		
		Set en=$ZH
		$$$LOGINFO("本部に入荷確定情報を送信:"_pRequest.Messages.Count()_"件 経過(秒):"_(en-st))
	}
	Catch e {
		$$$CATCH(e)
	}
	Return tSC
}

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
	Set ..WSDCName=$ZCVT($SYSTEM.INetInfo.LocalHostName(),"U") // ^WSDC.SiteName
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="WSHQ.DC.InboundOrderContainer"> 
		<Method>DoInboundOrder</Method>
	</MapItem>
	<MapItem MessageType="WSHQ.DC.ReceivingOrderContainer"> 
		<Method>DoReceivingOrder</Method>
	</MapItem>
</MapItems>
}

}
