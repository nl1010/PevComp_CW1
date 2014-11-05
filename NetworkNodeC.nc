//#include "Timer.h"
#include "initial.h"
//#include "node_to_node_msg.h"

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
  uint8_t ready_to_sent_data; //helper


//main events 
  event void Boot.booted()
  {
 
   // call Timer0.startPeriodic(500);
    //call Timer1.startPeriodic(250);
    //TurnOnLed();

    //dbg("Led","Led0 on \n");
    dbg("System","Mote Booted.\n");

    call AMControl.start(); //enable the radio chip
   // dbg("Boot","Module:AMControl->Starting...\n");
  }


//implemented event from interfaces  

//AMSend has an event named 'sendDone' ,this will triggered when sending is completed  
  event void AMSend.sendDone(message_t *msg,error_t error){
    //check send message msg == _packet => send the right data , switch off _radioBusy flag
    if (msg == &_packet){
      _radioBusy = FALSE;
      //dbg("Boot","Message sended \n");

    }else {
      dbg("System","message sended but not correct.\n");
    }
    
  }

//AMControl has an event named 'startDone', will triggered AMControl is started , use to check if AMControl is really started 
  event void AMControl.startDone(error_t error){
    if (error == SUCCESS) {
      //=====SEND RADIO PACKET when start done
      //*****1.CREATING RADIO PACKET******
       //dbg("Boot","Module:AMControl->Started\n");
      if (TOS_NODE_ID == INITIAL_NODE){
      NodeToNodeMsg* msg =(NodeToNodeMsg*) call Packet.getPayload(&_packet,sizeof(NodeToNodeMsg));
      msg->NodeID = TOS_NODE_ID;
      msg->Data = (uint8_t)888; 
     // dbg("Boot","Module:AMControl->Message assignment complete,Node ID->%d , Data->%d ready to sent.\n",msg->NodeID,msg->Data);


      //*****2.SEND RADIO PACKET******
      if (call AMSend.send(AM_BROADCAST_ADDR,&_packet,sizeof(NodeToNodeMsg)) == SUCCESS) {
       _radioBusy = TRUE;
       //dbg("Boot","Module:AMControl->Msg Sending. Node ID->%d , Data->%d\n",msg->NodeID,msg->Data);
        dbg("Channel","%s SND %hhu \n",sim_time_string(),msg->Data);

        ready_to_sent_data = msg->Data;
      }       
    }
  }
    else {
      call AMControl.start();
      dbg("System","AMControl cannot boot, retry\n"); 
    }
  }

//check it's really stoped or not 
  event void AMControl.stopDone(error_t error){
  }


//if the node received a parkage then execute this event 
  event message_t* Receive.receive(message_t* msg,void* payload,uint8_t len){
    //check if it's the right packet 
        //dbg("Boot","Received\n"); 

    if (len == sizeof (NodeToNodeMsg)){
      //dbg("Boot","Checked\n"); 
      NodeToNodeMsg* incomingPacket = (NodeToNodeMsg*) payload;
      uint8_t data = incomingPacket -> Data;
      uint16_t node_id = incomingPacket -> NodeID;
        dbg("Channel","%s RCV %hhu %hhu \n",sim_time_string(),data,node_id);
        return msg;  //avoid segmentation fault 
    } else {
      dbg("System","Incorrect message received\n");
        return msg;
    }

  }


}
