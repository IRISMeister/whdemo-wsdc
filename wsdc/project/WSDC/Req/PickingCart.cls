/// Cartへの要求を送信するためのメッセージ
Class WSDC.Req.PickingCart Extends Ens.Request
{

Property オーダ番号 As %String;

Storage Default
{
<Data name="PickingCartDefaultData">
<Subscript>"PickingCart"</Subscript>
<Value name="1">
<Value>オーダ番号</Value>
</Value>
</Data>
<DefaultData>PickingCartDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
