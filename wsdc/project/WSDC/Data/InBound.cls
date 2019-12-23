/// 発注履歴。WSDCからWSHQへのオーダ送信時に生成。(履歴)
Class WSDC.Data.InBound Extends %Persistent
{

Property オーダ番号 As %String;

Property オーダ日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 発注時実在庫数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 発注時理論在庫数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Index idxオーダ番号 On オーダ番号 [ PrimaryKey, Unique ];

ClassMethod Stats()
{
	//SELECT 商品コード,AVG(発注時実在庫数),STDDEV_POP(発注時実在庫数) FROM WSDC_Data.InBound group by 商品コード 
	//ここで標準偏差が小さいほど、「在庫数が安定している」ので良い=>というのが現時点の理解。
	//在庫数の記録タイミングが発注時になっているので、上記傾向があるのは当然か。定点観測のほうが良いかもしれない。
}

Storage Default
{
<Data name="InBoundDefaultData">
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
<Value>発注時実在庫数</Value>
</Value>
<Value name="7">
<Value>発注時理論在庫数</Value>
</Value>
</Data>
<DataLocation>^WSDC.Data.InBoundD</DataLocation>
<DefaultData>InBoundDefaultData</DefaultData>
<IdLocation>^WSDC.Data.InBoundD</IdLocation>
<IndexLocation>^WSDC.Data.InBoundI</IndexLocation>
<StreamLocation>^WSDC.Data.InBoundS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
