Include CommonInc

/// 在庫管理台帳
Class WSDC.Data.Inventory Extends %Persistent
{

Property 商品コード As %String;

/// 最終発注時点の在庫
Property 発注時実在庫 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 発注時理論在庫 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

/// 発注に使用する統計情報
Property 平均出庫量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

/// 発注に使用する統計情報
Property 出庫量標準偏差 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

/// 総発注回数
Property 発注回数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

/// 発注数。入荷されることで減ざれる。自動発注のロジックで使用。
Property 発注数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

/// 主にデバッグ用のタイムスタンプ
Property 発注日時 As %TimeStamp;

/// 最終発注日
Property 発注日 As %Date;

/// 発注時に入荷数量の値をコピーして保持
Property 発注時入荷数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

/// 発注時に入荷ｵｰﾀﾞ数量の値をコピーして保持
Property 発注時入荷ｵｰﾀﾞ数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

/// 発注時に出荷数量の値をコピーして保持
Property 発注時出荷数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

/// 発注時に出荷ｵｰﾀﾞ数量の値をコピーして保持
Property 発注時出荷ｵｰﾀﾞ数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 発注後入荷数量 As %Numeric(SCALE = 0) [ Calculated, SqlComputeCode = { Set {発注後入荷数量} ={入荷数量}-{発注時入荷数量} }, SqlComputed ];

Property 発注後出荷数量 As %Numeric(SCALE = 0) [ Calculated, SqlComputeCode = { Set {発注後出荷数量} ={出荷数量}-{発注時出荷数量} }, SqlComputed ];

Property 入荷ｵｰﾀﾞ数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 入荷数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 出荷ｵｰﾀﾞ数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 出荷数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 入荷ｵｰﾀﾞ残累計 As %Numeric(SCALE = 0) [ Calculated, SqlComputeCode = { Set {入荷ｵｰﾀﾞ残累計} ={入荷ｵｰﾀﾞ数量}-{入荷数量} }, SqlComputed ];

Property 出荷ｵｰﾀﾞ残累計 As %Numeric(SCALE = 0) [ Calculated, SqlComputeCode = { Set {出荷ｵｰﾀﾞ残累計} =  {出荷ｵｰﾀﾞ数量}-{出荷数量}}, SqlComputed ];

Property 理論在庫 As %Numeric(SCALE = 0) [ Calculated, SqlComputeCode = { Set {理論在庫} = {入荷ｵｰﾀﾞ数量}-{出荷ｵｰﾀﾞ数量} }, SqlComputed ];

Property 実在庫 As %Numeric(SCALE = 0) [ Calculated, SqlComputeCode = { Set {実在庫} = {入荷数量}-{出荷数量} }, SqlComputed ];

Index idx商品コード On 商品コード [ PrimaryKey, Unique ];

ClassMethod Init()
{
#define DECODE(%x) $ZSTRIP(%x,"<>P")
	
	Set file="/home/irisowner/MEDIS20130628.TXT"
	Try {
		Set sql1="INSERT INTO WSDC_Data.Inventory (商品コード,平均出庫量,発注時実在庫,発注日,入荷数量,入荷ｵｰﾀﾞ数量) VALUES (?,?,?,?,?,?)"
		Set stmt1=##class(%SQL.Statement).%New()
		Set tSC=stmt1.%Prepare(sql1)
		If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }


		Set fs=##class(%Stream.FileCharacter).%New()
		Set fs.Filename=file
		Set rec=fs.ReadLine()  //skip header line

		Set today=$ZDATEH("2001-01-01",3,,,,,,,"err")  // ##class(Common.Util).GetToday()
		Set 平均出庫量=1000  //とりあえず固定で一律。WSHQのWSHQ.Data.Inventoryの初期値(Init()内)と合わせる事。
		Set 安全在庫数=平均出庫量/2
		Set 発注時実在庫=0
		Set 発注日=today
		Set cnt=0

		While ('fs.AtEnd) {
			Set rec=fs.ReadLine()
			Set cnt=cnt+1 If cnt>1000 { Quit }
			Set 基準番号=$$$DECODE($P(rec,",",1))
			Set リードタイム=(基準番号#3)+5
			Set 商品コード=基準番号
			Set リードタイム=リードタイム
			Set 入荷数量=平均出庫量*(リードタイム+1)+安全在庫数  // *100
			Set 入荷ｵｰﾀﾞ数量=入荷数量
 			Set rs1=stmt1.%Execute(商品コード,平均出庫量,発注時実在庫,発注日,入荷数量,入荷ｵｰﾀﾞ数量) 
 			If rs1.%SQLCODE'=0,rs1.%SQLCODE'=100 Write !,"SQLCODE:",rs1.%SQLCODE," Error:",rs1.%Message ;Throw ##class(%Exception.SQL).CreateFromSQLCODE(rs1.SQLCODE,rs1.%Message)
		}

		/*
		Do {
			Set 商品コード=rs.商品コード
			Set リードタイム=rs.リードタイム
			#;初期の在庫数 (純粋な需要をはかるために一時的に100倍)
			Set 入荷数量=平均出庫量*(リードタイム+1)+安全在庫数  // *100
			Set 入荷ｵｰﾀﾞ数量=入荷数量
 			Set rs1=stmt1.%Execute(商品コード,平均出庫量,発注時実在庫,発注日,入荷数量,入荷ｵｰﾀﾞ数量) 
 			If rs1.%SQLCODE'=0,rs1.%SQLCODE'=100 Write !,"SQLCODE:",rs1.%SQLCODE," Error:",rs1.%Message ;Throw ##class(%Exception.SQL).CreateFromSQLCODE(rs1.SQLCODE,rs1.%Message)

		} While (rs.%Next()) 
		*/
	}
	Catch e {
		Do e.Log()
		Set tSC = e.AsStatus()
		zw e
	}
}

/// 発注に使用する統計情報の更新
/// 今の実装では、データが蓄積するとリニアに遅くなっていくので、もう一工夫必要。
ClassMethod UpdateShipCountStats()
{
	Set tSC=$$$OK
	Try {

		Set sql(1)="UPDATE WSDC_Data.Inventory Set 平均出庫量=?,出庫量標準偏差=? WHERE 商品コード=?"
		For i=1:1:1 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
		}

		#;today(当日)の集計はまだ未完了なので除く
		Set sql=
		"SELECT 商品コード,ROUND(AVG(N),0) AS AVGN,ROUND(STDDEV_POP(N),0) AS STDN FROM ("_
			"SELECT 商品コード,出荷日付,SUM(数量) AS N FROM WSDC_Data.Shipping group by 商品コード,出荷日付 having 出荷日付<?"_
		") group by 商品コード"

		Set today=##class(Common.Util).GetToday()
		$$$SQLDIRECTQUERY(rs,sql,$$$SQLARGS(today)) 
		If rs.%SQLCODE=100 Quit
		Do {
			Set 平均出庫量=rs.AVGN
			Set 出庫量標準偏差=rs.STDN
			Set 商品コード=rs.商品コード
			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(平均出庫量,出庫量標準偏差,商品コード))
		} While (rs.%Next())
	}
	Catch e {
		Do e.Log()
		Set tSC = e.AsStatus()
		zw e
	}

	 Return tSC
}

Storage Default
{
<Data name="InventoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>商品コード</Value>
</Value>
<Value name="3">
<Value>発注時実在庫</Value>
</Value>
<Value name="4">
<Value>発注時理論在庫</Value>
</Value>
<Value name="5">
<Value>平均出庫量</Value>
</Value>
<Value name="6">
<Value>出庫量標準偏差</Value>
</Value>
<Value name="7">
<Value>発注回数</Value>
</Value>
<Value name="8">
<Value>発注数</Value>
</Value>
<Value name="9">
<Value>発注日時</Value>
</Value>
<Value name="10">
<Value>発注日</Value>
</Value>
<Value name="11">
<Value>発注時入荷数量</Value>
</Value>
<Value name="12">
<Value>発注時入荷ｵｰﾀﾞ数量</Value>
</Value>
<Value name="13">
<Value>発注時出荷数量</Value>
</Value>
<Value name="14">
<Value>発注時出荷ｵｰﾀﾞ数量</Value>
</Value>
<Value name="15">
<Value>入荷ｵｰﾀﾞ数量</Value>
</Value>
<Value name="16">
<Value>入荷数量</Value>
</Value>
<Value name="17">
<Value>出荷ｵｰﾀﾞ数量</Value>
</Value>
<Value name="18">
<Value>出荷数量</Value>
</Value>
</Data>
<DataLocation>^WSDC.Data.InventoryD</DataLocation>
<DefaultData>InventoryDefaultData</DefaultData>
<IdLocation>^WSDC.Data.InventoryD</IdLocation>
<IndexLocation>^WSDC.Data.InventoryI</IndexLocation>
<StreamLocation>^WSDC.Data.InventoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
