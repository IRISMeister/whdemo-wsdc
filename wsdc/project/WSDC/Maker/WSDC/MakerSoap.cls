Class WSDC.Maker.WSDC.MakerSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method ReceiveDeliveryNote(req As WSDC.Maker.DeliveryNoteContainer) As %xsd.base64Binary [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("ReceiveDeliveryNote").Invoke($this,"http://tempuri.org/WSDC.Service.Maker.ReceiveDeliveryNote",.req)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://macbeth:52773/csp/WSDEMO/WSDC.Service.Maker.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// This is the name of the Service
Parameter SERVICENAME = "WSDC.Maker";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
