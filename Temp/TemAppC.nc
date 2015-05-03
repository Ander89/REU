configuration TemAppC
{

}

implementation
{

components TemC as App;
components MainC, LedsC;
components new TimerMilliC();

App.Boot -> MainC;
App.Leds -> LedsC;
App.Timer -> TimerMilliC;


//For temperature
components new TempC() as TempSensor;
components PrintfC, SerialStartC;
App.TempRead -> TempSensor;

//Radio Communication
components ActiveMessageC;
components new AMSenderC(AM_RADIO);
components new AMReceiverC(AM_RADIO);

App.Packet->AMSenderC;
App.AMPacket->AMSenderC;
App.AMSend ->AMSenderC;
App.AMControl ->ActiveMessageC;
App.Receive -> AMReceiverC;

}
