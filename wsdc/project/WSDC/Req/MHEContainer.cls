/// マテハンへの要求を送信するためのメッセージ
Class WSDC.Req.MHEContainer Extends Ens.Request
{

Property Reqs As list Of WSDC.Req.MHE;

Storage Default
{
<Data name="MHEContainerDefaultData">
<Subscript>"MHEContainer"</Subscript>
<Value name="1">
<Value>Reqs</Value>
</Value>
</Data>
<DefaultData>MHEContainerDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
