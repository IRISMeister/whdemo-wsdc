/// 次から作成されました: http://MACBETH:52773/csp/WSDEMO/WSDC.Service.Maker.CLS?WSDL=1
Class WSDC.Maker.DeliveryNoteContainer Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "DeliveryNoteContainer";

Parameter XMLSEQUENCE = 1;

Property Messages As list Of WSDC.Maker.DeliveryNote(XMLITEMNAME = "DeliveryNote", XMLNAME = "Messages", XMLPROJECTION = "COLLECTION");

Property DestWSDC As %String(MAXLEN = "", XMLNAME = "DestWSDC");

Storage Default
{
<Data name="DeliveryNoteContainerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Messages</Value>
</Value>
<Value name="3">
<Value>DestWSDC</Value>
</Value>
</Data>
<DataLocation>^WSDC.Maker.DeliveryNotA9F5D</DataLocation>
<DefaultData>DeliveryNoteContainerDefaultData</DefaultData>
<IdLocation>^WSDC.Maker.DeliveryNotA9F5D</IdLocation>
<IndexLocation>^WSDC.Maker.DeliveryNotA9F5I</IndexLocation>
<StreamLocation>^WSDC.Maker.DeliveryNotA9F5S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
