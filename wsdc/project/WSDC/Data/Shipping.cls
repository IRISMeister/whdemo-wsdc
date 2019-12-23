/// 当日出荷ファイル->出荷ファイル(履歴)
Class WSDC.Data.Shipping Extends %Persistent
{

Property オーダ番号 As %String;

Property 出荷番号 As %String;

Property オーダ日付 As %Date;

Property 出荷日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0);

Property 出荷先コード As %String;

Property 商品原価 As %Numeric(SCALE = 0);

Property 商品売価 As %Numeric(SCALE = 0);

Property 商品分類 As %String;

Property 出荷時実在庫数 As %Numeric(SCALE = 0);

Index idxオーダ番号 On オーダ番号 [ PrimaryKey, Unique ];

Index idx出荷番号 On 出荷番号;

Index idx商品コード On 商品コード;

Index idx出荷日付 On 出荷日付;

Storage Default
{
<Data name="ShippingDefaultData">
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
<Value>出荷日付</Value>
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
<Value>商品原価</Value>
</Value>
<Value name="10">
<Value>商品売価</Value>
</Value>
<Value name="11">
<Value>商品分類</Value>
</Value>
<Value name="12">
<Value>出荷時実在庫数</Value>
</Value>
</Data>
<DataLocation>^WSDC.Data.ShippingD</DataLocation>
<DefaultData>ShippingDefaultData</DefaultData>
<IdLocation>^WSDC.Data.ShippingD</IdLocation>
<IndexLocation>^WSDC.Data.ShippingI</IndexLocation>
<StreamLocation>^WSDC.Data.ShippingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
