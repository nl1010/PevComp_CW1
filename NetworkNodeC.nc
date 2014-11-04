//#include "Timer.h"
#include "initial.h"

module NetworkNodeC 
{

  uses //general
  {
  //interface Timer<TMilli> as Timer0;
  //interface Timer<TMilli> as Timer1;
  interface Boot; 
  //interface Leds;
  }
  

  uses //raido
  {
    interface Packet;  //extract data from packet
    interface AMPacket; //used by Active Messenger interface
    interface AMSend; //send active message packets
    //AMSend has an event named 'sendDone' ,this will triggered when sending is completed  
    interface SplitControl as AMControl; //SplitControl is general interface allows you to do some data extractions on data, here used for controlling the active messanger
    interface Receive; //recevie radio packets
  }
}

implementation
{

//global variables 
  bool _radioBusy = FALSE; //indicates radio status , prevent clash  
  message_t _packet;


//main events 
  event void Boot.booted()
  {
 
   // call Timer0.startPeriodic(500);
    //call Timer1.startPeriodic(250);
    //TurnOnLed();

    //dbg("Led","Led0 on \n");
    //dbg("Boot","Application Booted.\n");

    call AMControl.start(); //enable the radio chip

  }





//implemented event from interfaces  

//AMSend has an event named 'sendDone' ,this will triggered when sending is completed  
  event void AMSend.sendDone(message_t *msg,error_t error){
    //check send message msg == _packet => send the right data , switch off _radioBusy flag

  }

//AMControl has an event named 'startDone', will triggered AMControl is started , use to check if AMControl is really started 
  event void AMControl.startDone(error_t error){
    if (error == SUCCESS) {
      dbg("AMControl","Module online: AMControl\n");

      //send radio packet here 
      //*****1.CREATING RADIO PACKET******
      //NodeToNodeMsg_t* msg = call Packet.getPayload(&_packet,sizeof(NodeToNodeMsg_t));
      //msg->NodeID = TOS_NODE_ID;
      //msg->Data = (uint8_t) 123;


      //*****2.SEND RADIO PACKET******
      //if (call AMSend.send xxxx == true) { _radioBusy = TRUE;}       
    }
    else {
      call AMControl.start();
      dbg("AMControl","AMControl cannot boot, retry\n"); 
    }
  }

//check it's really stoped or not 
  event void AMControl.stopDone(error_t error){

  }


//if the node received a parkage 
  event message_t * Receive.receive(message_t *msg,void *payload,uint8_t len){
    //check if it's the right packet 
  /*
    if (len == sizeof (NodeToNodeMsg_t)){
      NodeToNode * incomingPacket = (NodeToNodeMsg_t *) payload;

      uint8_t data = incomingPacket -> Data;
      if (data == xx ){
        do ... 
      }
    }
  */
  }


}
