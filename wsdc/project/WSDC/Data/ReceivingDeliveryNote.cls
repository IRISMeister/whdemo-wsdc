/// 納品書(メーカからの納品書)
Class WSDC.Data.ReceivingDeliveryNote Extends %Persistent
{

Property オーダ番号 As %String;

Property オーダ日付 As %Date;

Property 配送予定日付 As %Date;

Property 配送日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

/// メーカの出荷作業(納品書の送付)の単位で割り振られるユニーク番号
Property メーカ出荷番号 As %String;

Property オーダ受信日時 As %TimeStamp [ InitialExpression = {$ZDATETIME($H,3)} ];

Index idx配送日付 On 配送日付;

Index idxオーダ番号 On オーダ番号 [ PrimaryKey, Unique ];

Storage Default
{
<Data name="ReceivingDeliveryNoteDefaultData">
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
<Value>配送日付</Value>
</Value>
<Value name="6">
<Value>商品コード</Value>
</Value>
<Value name="7">
<Value>数量</Value>
</Value>
<Value name="8">
<Value>メーカ出荷番号</Value>
</Value>
<Value name="9">
<Value>オーダ受信日時</Value>
</Value>
</Data>
<DataLocation>^WSDC.Data.ReceivingDe5801D</DataLocation>
<DefaultData>ReceivingDeliveryNoteDefaultData</DefaultData>
<IdLocation>^WSDC.Data.ReceivingDe5801D</IdLocation>
<IndexLocation>^WSDC.Data.ReceivingDe5801I</IndexLocation>
<StreamLocation>^WSDC.Data.ReceivingDe5801S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
