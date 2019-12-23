Class WSDC.Util Extends %RegisteredObject
{

ClassMethod ClearAll()
{
	Do ##class(WSDC.Data.Receiving).%KillExtent()
	Do ##class(WSDC.Data.Shipping).%KillExtent()
	Do ##class(WSDC.Data.InBound).%KillExtent()
	Do ##class(WSDC.Data.ReceivingDeliveryNote).%KillExtent()
	Do ##class(WSDC.Data.ShippingDeliveryNote).%KillExtent()
	Do ##class(WSDC.Data.Inventory).%KillExtent()
	Do ##class(WSDC.Data.ReceivingOrder).%KillExtent()
	Do ##class(WSDC.Data.ShippingOrder).%KillExtent()
	
	Do ##class(WSHQ.DC.InboundOrder).%KillExtent()
	Do ##class(WSHQ.DC.InboundOrderContainer).%KillExtent()
	Do ##class(WSHQ.DC.ReceivingOrder).%KillExtent()
	Do ##class(WSHQ.DC.ReceivingOrderContainer).%KillExtent()
	
	K ^WSDC.InboundOrder
	//Set host=$SYSTEM.INetInfo.LocalHostName()
	//If host="wsdc1" Set ^WSDC.SiteName="WSDC1"
	//If host="wsdc2" Set ^WSDC.SiteName="WSDC2"

	Do ##class(WSDC.Data.Inventory).Init()		
	
	Do ##class(Ens.Purge).PurgeAll(.tDeletedCount,0,0,1)
	Do ##class(Ens.Director).CleanProduction()
}

}
