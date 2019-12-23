/// マテハンへの要求を送信するためのメッセージ
Class WSDC.Req.MHE Extends Ens.Request
{

Property オーダ番号 As %String;

Storage Default
{
<Data name="MHEDefaultData">
<Subscript>"MHE"</Subscript>
<Value name="1">
<Value>オーダ番号</Value>
</Value>
</Data>
<DefaultData>MHEDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
