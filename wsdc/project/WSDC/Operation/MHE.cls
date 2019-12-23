/// マテハン制御用のOperation
Class WSDC.Operation.MHE Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method Exec(pRequest As WSDC.Req.PickingCartContainer, Output pResponse As Ens.Response) As %Status
{
	#;マテハンを制御するための何か
	Set pResponse=##class(Ens.Response).%New()
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="WSDC.Req.MHEContainer"> 
		<Method>Exec</Method>
	</MapItem>
</MapItems>
}

}
