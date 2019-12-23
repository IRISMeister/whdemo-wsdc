/// カート制御用のOperation
Class WSDC.Operation.PickingCart Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method Exec(pRequest As WSDC.Req.PickingCartContainer, Output pResponse As Ens.Response) As %Status
{
	#;カートを制御するための何か
	Set pResponse=##class(Ens.Response).%New()
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="WSDC.Req.PickingCartContainer"> 
		<Method>Exec</Method>
	</MapItem>
</MapItems>
}

}
