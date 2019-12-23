/// 入荷履歴
Class WSDC.Data.Receiving Extends %Persistent
{

Property オーダ番号 As %String;

Property オーダ日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 入荷時実在庫数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 入荷時理論在庫数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Index idxオーダ番号 On オーダ番号 [ PrimaryKey, Unique ];

Storage Default
{
<Data name="ReceivingDefaultData">
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
<Value>商品コード</Value>
</Value>
<Value name="5">
<Value>数量</Value>
</Value>
<Value name="6">
<Value>入荷時実在庫数</Value>
</Value>
<Value name="7">
<Value>入荷時理論在庫数</Value>
</Value>
</Data>
<DataLocation>^WSDC.Data.ReceivingD</DataLocation>
<DefaultData>ReceivingDefaultData</DefaultData>
<IdLocation>^WSDC.Data.ReceivingD</IdLocation>
<IndexLocation>^WSDC.Data.ReceivingI</IndexLocation>
<StreamLocation>^WSDC.Data.ReceivingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
