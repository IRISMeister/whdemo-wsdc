/// 納品書
Class MAKER.WS.DeliveryNote Extends (%RegisteredObject, %XML.Adaptor)
{

Property オーダ番号 As %String;

Property オーダ日付 As %Date;

Property 配送予定日付 As %Date;

Property 配送日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0);

/// メーカの出荷作業(納品書の送付)の単位で割り振られるユニーク番号
Property メーカ出荷番号 As %String;

}
