Class WSDC.WSDCSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method ClearAll() [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("ClearAll")).Invoke($this,"http://tempuri.org/WSDC.Task.ClearAll")
}

Method Test() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Test").Invoke($this,"http://tempuri.org/WSDC.Task.Test")
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://macbeth:52773/csp/WSDEMO/WSDC.Task.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// This is the name of the Service
Parameter SERVICENAME = "WSDC";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
