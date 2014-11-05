#include "initial.h"
#include "node_to_node_msg.h"
configuration NetworkNodeAppC
{
}

implementation
{

  //GENERAL 
    components NetworkNodeC;
    components MainC;
    //components new TimerMilliC() as Timer0;

    NetworkNodeC-> MainC.Boot;
  //NetworkNodeC.Timer0 -> Timer0;


    //Radio Function 
    components ActiveMessageC; //Active message is singleton components and can only deploy once 
    components new AMSenderC(AM_RADIO_TYPE);
    components new AMReceiverC(AM_RADIO_TYPE);

    NetworkNodeC.Packet -> AMSenderC;
    NetworkNodeC.AMPacket -> AMSenderC;
    NetworkNodeC.AMSend -> AMSenderC;
    NetworkNodeC.AMControl -> ActiveMessageC;
    NetworkNodeC.Receive -> AMReceiverC;
}

