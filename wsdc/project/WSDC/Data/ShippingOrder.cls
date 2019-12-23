/// 出荷オーダファイル(当日分)
Class WSDC.Data.ShippingOrder Extends %Persistent
{

Property オーダ番号 As %String;

Property 出荷番号 As %String;

Property オーダ日付 As %Date;

Property 出荷予定日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0);

Property 出荷先コード As %String;

Property オーダ受信日時 As %TimeStamp [ InitialExpression = {$ZDATETIME($H,3)} ];

Index idxオーダ番号 On オーダ番号 [ PrimaryKey, Unique ];

Index idx出荷予定日付 On 出荷予定日付;

Index idx出荷番号 On 出荷番号;

Storage Default
{
<Data name="ShippingOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>オーダ番号</Value>
</Value>
<Value name="3">
<Value>出荷番号</Value>
</Value>
<Value name="4">
<Value>オーダ日付</Value>
</Value>
<Value name="5">
<Value>出荷予定日付</Value>
</Value>
<Value name="6">
<Value>商品コード</Value>
</Value>
<Value name="7">
<Value>数量</Value>
</Value>
<Value name="8">
<Value>出荷先コード</Value>
</Value>
<Value name="9">
<Value>オーダ受信日時</Value>
</Value>
</Data>
<DataLocation>^WSDC.Data.ShippingOrderD</DataLocation>
<DefaultData>ShippingOrderDefaultData</DefaultData>
<IdLocation>^WSDC.Data.ShippingOrderD</IdLocation>
<IndexLocation>^WSDC.Data.ShippingOrderI</IndexLocation>
<StreamLocation>^WSDC.Data.ShippingOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
