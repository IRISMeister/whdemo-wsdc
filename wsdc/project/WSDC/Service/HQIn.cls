Include (CommonInc, Ensemble)

Class WSDC.Service.HQIn Extends Ens.BusinessService
{

/// 本部から入荷オーダ受信
Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Status
{
	Set %response.ContentType="application/json"
	Set %response.CharSet=%request.CharSet

	Set tSC=$$$OK
	Set resultContainer={}
	Set resultContainer.Messages=[]
	Set resultContainer.Count=0
	Try {
		Set st=$ZH
		Set req={}.%FromJSON(%request.Content)
		Set sql(1)="INSERT INTO WSDC_Data.ReceivingOrder (オーダ番号,オーダ日付,配送予定日付,商品コード,数量) VALUES (?,?,?,?,?)"
		Set sql(2)="UPDATE WSDC_Data.Inventory Set 入荷ｵｰﾀﾞ数量=入荷ｵｰﾀﾞ数量+?,発注数=発注数-? WHERE 商品コード=?"
		For i=1:1:2 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			$$$ThrowOnError(tSC)
		}
		
		Set index=req.Count-1
		For i=0:1:index {
			Set order=req.Messages.%Get(i)
			Set オーダ番号=order.オーダ番号
			Set オーダ日付=order.オーダ日付
			Set 配送予定日付=order.配送予定日付
			Set 商品コード=order.商品コード
			Set 数量=order.数量

			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(オーダ番号,オーダ日付,配送予定日付,商品コード,数量))
			
			Set rs(2)=stmt(2).%Execute(数量,数量,商品コード) 
			If rs(2).%SQLCODE=100 {
				$$$LOGERROR("該当商品が存在しません 商品コード:"_商品コード)
			}
			If rs(2).%SQLCODE=-110 {
				$$$LOGERROR("Lock競合発生 商品コード:"_商品コード_" SQLCODE:"_rs(2).SQLCODE_" "_rs(2).%Message)
				#;ToDo:Pendingレコードに退避する？
			}
			Else {
				#;上記以外は例外を送出
				$$$DSQLERRCHECK(rs(2))
			}
		}

		Set en=$ZH
		$$$LOGINFO("本部から入荷オーダファイル受信:"_req.Count_"件 経過(秒):"_(en-st))

	}
	Catch e {
		$$$CATCH(e)
	}
	Set resultContainer.Status=tSC
	Do resultContainer.%ToJSON()
	
	Return tSC
}

}
