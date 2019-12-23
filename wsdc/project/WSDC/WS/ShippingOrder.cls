/// 出荷オーダファイル(当日分)
Class WSDC.WS.ShippingOrder Extends (%RegisteredObject, %XML.Adaptor)
{

Property オーダ番号 As %String;

Property 出荷番号 As %String;

Property オーダ日付 As %Date;

Property 出荷予定日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0);

Property 出荷先コード As %String;

}
