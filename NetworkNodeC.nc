#include "Timer.h"
#include "initial.h"
//#include "node_to_node_msg.h"

module NetworkNodeC 
{

  uses //general
  {
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

  uses //Dissemination 
  {
    interface Timer<TMilli> as DisseminationTriggerTimer;
  }
}

implementation
{

//global variables 
  bool _radioBusy = FALSE; //indicates radio status , prevent clash  
  message_t _packet;
  uint8_t flag_package_hold = FALSE; //indicates if the mote holded the package , initially not holded , after received a vaild message this will set to be TRUE
  int flag_forward_limit = 1 ; //the number of change a node can forward message agian , if the environment condition unchange , 1 is a suitable value to reduce total messages generated in the network.
  uint16_t _holded_data;
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
      flag_forward_limit = flag_forward_limit-1;  //if forward limit = 0 , cannot resend again 
      dbg("Flag","forward limit:%i \n",flag_forward_limit);
      //dbg("Boot","Message sended \n");

    }else {
      dbg("System","message sended but not correct.\n");
    }
    
  }

//AMControl has an event named 'startDone', will triggered AMControl is started , use to check if AMControl is really started 
  event void AMControl.startDone(error_t error){
    if (error == SUCCESS) {
      //=====SEND RADIO PACKET when start done
       //dbg("Boot","Module:AMControl->Started\n");
      call DisseminationTriggerTimer.startPeriodic(1000); // when fired ,check if hold packet && if still have chance to forward message , if true then send it agian

      if (TOS_NODE_ID == INITIAL_NODE){
        //*****1.CREATING RADIO PACKET******
        NodeToNodeMsg* msg =(NodeToNodeMsg*) call Packet.getPayload(&_packet,sizeof(NodeToNodeMsg));
        msg->NodeID = TOS_NODE_ID;
        msg->Data = (uint16_t)TOS_NODE_ID; 
        //dbg("Boot","Module:AMControl->Message assignment complete,Node ID->%d , Data->%d ready to sent.\n",msg->NodeID,msg->Data);


      //*****2.SEND RADIO PACKET******
        if (call AMSend.send(AM_BROADCAST_ADDR,&_packet,sizeof(NodeToNodeMsg)) == SUCCESS) {
         _radioBusy = TRUE;
       //dbg("Boot","Module:AMControl->Msg Sending. Node ID->%d , Data->%d\n",msg->NodeID,msg->Data);
         dbg("Channel","%s SND %hhu \n",sim_time_string(),msg->Data);

       } 
     }
   }
   else {
    call AMControl.start();
    dbg("System","AMControl cannot boot, retry\n"); 
  }
}


  //TIMER FIRED ==> forward 
  event void DisseminationTriggerTimer.fired(){

    if (flag_package_hold == TRUE && flag_forward_limit >0 ) {

      //1.forward the package 
      NodeToNodeMsg* msg =(NodeToNodeMsg*) call Packet.getPayload(&_packet,sizeof(NodeToNodeMsg));
      msg->NodeID = TOS_NODE_ID;
      msg->Data = _holded_data; 

      
      if (call AMSend.send(AM_BROADCAST_ADDR,&_packet,sizeof(NodeToNodeMsg)) == SUCCESS) {
         _radioBusy = TRUE;
         dbg("Channel","%s FWD %hhu \n",sim_time_string(),msg->Data);

      } 
      


      //2.reduce the forward limit 
        flag_forward_limit = flag_forward_limit-1 ;
    } 
  }






//check it's really stoped or not 
event void AMControl.stopDone(error_t error){
}


//if the node received a parkage then execute this event 
event message_t* Receive.receive(message_t* msg,void* payload,uint8_t len){
    //check if it's the right packet 
        //dbg("Boot","Received\n"); 
  if (flag_package_hold == FALSE){
    if (len == sizeof (NodeToNodeMsg)){
        //dbg("Boot","Checked\n"); 
      NodeToNodeMsg* incomingPacket = (NodeToNodeMsg*) payload;
      uint16_t data = incomingPacket -> Data;

      uint16_t node_id = incomingPacket -> NodeID;
      flag_package_hold = TRUE; //set flag as parckage holded
      dbg("Channel","%s RCV %hhu %hhu \n",sim_time_string(),data,node_id);
      dbg("Flag","Package holded\n"); 
      _holded_data = data; //store to the device for forwarding
          return msg;  //avoid segmentation fault 
        

        } else {
          dbg("System","Incorrect message received\n");
          return msg;
        }
      }

  }


  }
