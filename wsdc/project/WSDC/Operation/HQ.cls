Include CommonInc

Class WSDC.Operation.HQ Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Property Adapter As EnsLib.SOAP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Property WSDCName As %String;

/// メーカへの発注オーダをWSHQに送信
Method DoInboundOrder(pRequest As WSHQ.DC.InboundOrderContainer, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Try {
		Set st=$ZH
		Set pRequest.WSDCName=..WSDCName
		Set tSC=..Adapter.InvokeMethod("ReceiveInboundOrder",.WSResult,pRequest)
		$$$THROWIFERROR(tSC)

		Set en=$ZH
		$$$LOGINFO("本部に発注情報を送信:"_pRequest.Messages.Count()_"件 経過(秒):"_(en-st))
	}
	Catch e {
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))
	}
	Return tSC
}

/// 入荷検品作業後に、実行されることを想定。入荷情報をWSHQに送信する。
Method DoReceivingOrder(pRequest As WSHQ.DC.ReceivingOrderContainer, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Try {
		Set st=$ZH
		Set pRequest.WSDCName=..WSDCName
		Set tSC=..Adapter.InvokeMethod("ReceiveReceivingOrder",.WSResult,pRequest)
		$$$THROWIFERROR(tSC)
		
		Set en=$ZH
		$$$LOGINFO("本部に入荷確定情報を送信:"_pRequest.Messages.Count()_"件 経過(秒):"_(en-st))
	}
	Catch e {
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))
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
