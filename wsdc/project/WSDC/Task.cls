Include (CommonInc, Ensemble)

Class WSDC.Task Extends %SOAP.WebService
{

Parameter ADAPTER;

Parameter SERVICENAME = "WSDC";

Parameter NAMESPACE = "http://tempuri.org";

Parameter USECLASSNAMESPACES = 1;

Method Test() As %String [ WebMethod ]
{
	Return $ZDATETIME($h)
}

Method ClearAll() As %Status [ WebMethod ]
{
	Do ##class(WSDC.Util).ClearAll()
	
	#;初期在庫の作成
	Do ##class(WSDC.Data.Inventory).Init()
	Return $$$OK
}

ClassMethod StartProduction() As %Status [ WebMethod ]
{
	Return ##class(Ens.Director).StartProduction("WSDC.Production.Production1")
}

ClassMethod StopProduction() As %Status [ WebMethod ]
{
	Return ##class(Ens.Director).StopProduction(,1)
}

}
