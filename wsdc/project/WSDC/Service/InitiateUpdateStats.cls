Include CommonInc

/// 統計情報更新。WSDC.Data.Inventoryの平均出荷数や標準偏差を計算し格納。
Class WSDC.Service.InitiateUpdateStats Extends Ens.BusinessMetric
{

Method OnCalculateMetrics() As %Status
{
	Set tSC=$$$OK
	
	 Try {
		Set st=$ZH
		Do ##class(WSDC.Data.Inventory).UpdateShipCountStats()
		Set en=$ZH
		$$$LOGINFO("統計情報更新 経過(秒):"_(en-st))
	 }
	 Catch e {
		$$$CATCH(e)
	 }
	 
	 Return tSC
}

}
