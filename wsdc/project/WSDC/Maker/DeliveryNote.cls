/// 次から作成されました: http://MACBETH:52773/csp/WSDEMO/WSDC.Service.Maker.CLS?WSDL=1
Class WSDC.Maker.DeliveryNote Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "DeliveryNote";

Parameter XMLSEQUENCE = 1;

Property オーダ番号 As %String(MAXLEN = "", XMLNAME = "オーダ番号");

Property オーダ日付 As %Date(XMLNAME = "オーダ日付");

Property 配送予定日付 As %Date(XMLNAME = "配送予定日付");

Property 配送日付 As %Date(XMLNAME = "配送日付");

Property 商品コード As %String(MAXLEN = "", XMLNAME = "商品コード");

Property 数量 As %Numeric(XMLNAME = "数量");

Property メーカ出荷番号 As %String(MAXLEN = "", XMLNAME = "メーカ出荷番号");

Storage Default
{
<Data name="DeliveryNoteDefaultData">
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
</Data>
<DataLocation>^WSDC.Maker.DeliveryNoteD</DataLocation>
<DefaultData>DeliveryNoteDefaultData</DefaultData>
<IdLocation>^WSDC.Maker.DeliveryNoteD</IdLocation>
<IndexLocation>^WSDC.Maker.DeliveryNoteI</IndexLocation>
<StreamLocation>^WSDC.Maker.DeliveryNoteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
