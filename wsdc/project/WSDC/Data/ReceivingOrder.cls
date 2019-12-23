/// 入荷オーダファイル(当日分)
Class WSDC.Data.ReceivingOrder Extends %Persistent
{

Property オーダ番号 As %String;

Property オーダ日付 As %Date;

Property 配送予定日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property オーダ受信日時 As %TimeStamp [ InitialExpression = {$ZDATETIME($H,3)} ];

Index idxオーダ番号 On オーダ番号 [ PrimaryKey, Unique ];

Storage Default
{
<Data name="ReceivingOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>オーダ番号</Value>
</Value>
<Value name="3">
<Value>オーダ日付</Value>
</Value>
<Value name="4">
<Value>配送予定日付</Value>
</Value>
<Value name="5">
<Value>商品コード</Value>
</Value>
<Value name="6">
<Value>数量</Value>
</Value>
<Value name="7">
<Value>オーダ受信日時</Value>
</Value>
</Data>
<DataLocation>^WSDC.Data.ReceivingOrderD</DataLocation>
<DefaultData>ReceivingOrderDefaultData</DefaultData>
<IdLocation>^WSDC.Data.ReceivingOrderD</IdLocation>
<IndexLocation>^WSDC.Data.ReceivingOrderI</IndexLocation>
<StreamLocation>^WSDC.Data.ReceivingOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
