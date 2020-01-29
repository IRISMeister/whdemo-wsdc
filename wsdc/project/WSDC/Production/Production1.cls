Class WSDC.Production.Production1 Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="WSDC.Production.Production1" TestingEnabled="false" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Adapter" Name="AlertNotificationManager">Ens.Alerting.NotificationManager</Setting>
  <Setting Target="Adapter" Name="AlertNotificationRecipients">appuser</Setting>
  <Setting Target="Adapter" Name="AlertNotificationOperation">WSDC.Operation.DefaultAlert</Setting>
  <Item Name="InitiateReceiving" Category="" ClassName="WSDC.Service.InitiateReceiving" PoolSize="1" Enabled="true" Foreground="false" Comment="検品処理" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="InitiateShipping" Category="" ClassName="WSDC.Service.InitiateShipping" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="InitiatePurchase" Category="" ClassName="WSDC.Service.InitiatePurchase" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="InitiateUpdateStats" Category="" ClassName="WSDC.Service.InitiateUpdateStats" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">30</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <!-- Item Name="WSDC.Service.HQ" Category="" ClassName="WSDC.Service.HQ" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item -->
  <Item Name="WSDC.Service.Maker" Category="" ClassName="WSDC.Service.Maker" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="Ens.Activity.Operation.Local" Category="" ClassName="Ens.Activity.Operation.Local" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="StorageNamespace">WSDC</Setting>
  </Item>
  <Item Name="HQIn" Category="" ClassName="WSDC.Service.HQIn" PoolSize="0" Enabled="true" Foreground="false" Comment="本部から入荷オーダ受信" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HQOut" Category="" ClassName="WSDC.Service.HQOut" PoolSize="0" Enabled="true" Foreground="false" Comment="本部から出荷オーダ受信" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HQ" Category="" ClassName="WSDC.Operation.HQ" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ReplyCodeActions">E=RD</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Adapter" Name="HTTPPort">52773</Setting>
    <Setting Target="Adapter" Name="HTTPServer">wshq</Setting>
    <Setting Target="Adapter" Name="URL">/csp/wshq/dispatcher/Receive</Setting>
    <Setting Target="Adapter" Name="Credentials">default</Setting>
  </Item>
  <Item Name="PickingCart" Category="" ClassName="WSDC.Operation.PickingCart" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E=RD</Setting>
  </Item>
  <Item Name="MHE" Category="" ClassName="WSDC.Operation.MHE" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E=RD</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="Alert" ClassName="Ens.Alerting.AlertManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="CreateManagedAlertRule">WSDC.Rule.ManagedAlert</Setting>
  </Item>
  <Item Name="Ens.Alerting.NotificationManager" Category="Alert" ClassName="Ens.Alerting.NotificationManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="NotificationTransform">WSDC.Transform.AlertNotify</Setting>
  </Item>
  <Item Name="WSDC.Operation.DefaultAlert" Category="Alert" ClassName="WSDC.Operation.DefaultAlert" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="EnsLib.EMail.AlertOperation" Category="Alert" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SMTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="Credentials">ensemble-email</Setting>
    <Setting Target="Host" Name="IncludeDetails">1</Setting>
    <Setting Target="Host" Name="IncludeNodeinSubject">1</Setting>
    <Setting Target="Adapter" Name="From">ensemble-production@localdomain.localhost</Setting>
    <Setting Target="Adapter" Name="Recipient">reciveall@localdomain.localhost</Setting>
    <Setting Target="Host" Name="IncludeManagedAlertHistory">2</Setting>
  </Item>
</Production>
}

}
