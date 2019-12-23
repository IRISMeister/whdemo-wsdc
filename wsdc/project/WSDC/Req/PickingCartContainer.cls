/// Cartへの要求を送信するためのメッセージ
Class WSDC.Req.PickingCartContainer Extends Ens.Request
{

Property Reqs As list Of WSDC.Req.PickingCart;

Storage Default
{
<Data name="PickingCartContainerDefaultData">
<Subscript>"PickingCartContainer"</Subscript>
<Value name="1">
<Value>Reqs</Value>
</Value>
</Data>
<DefaultData>PickingCartContainerDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
