#include "Timer.h"

module NetworkNodeC 
{

  uses //general
  {
  uses interface Timer<TMilli> as Timer0;
  uses interface Timer<TMilli> as Timer1;
  uses interface Boot; 
  uses interface Leds;
  
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
  bool _radioBusy = FALSE; //_xxx indicates variables , habbit 
  message_t _packet;


// //functions 
//     void TurnOnLed()
//     {
//       call Leds.led0On();
//       dbg("Led","Led0 on \n");

//     }

//events 





  event void Boot.booted()
  {

   // call Timer0.startPeriodic(500);
    //call Timer1.startPeriodic(250);
    //TurnOnLed();

    //dbg("Led","Led0 on \n");
    //dbg("Boot","Application Booted.\n");

    call Notify.enable(); //ASA booted , enable the notify for the user button
    call AMControl.start(); //enable the radio chip

  }





//events implemented 

//AMSend has an event named 'sendDone' ,this will triggered when sending is completed  
  event void AMSend.sendDone(message_t *msg,error_t error){

  }

//AMControl has an event named 'startDone', will triggered AMControl is started , use to check if AMControl is really started 
  event void AMControl.startDone(error_t error){
    if (error == SUCCESS) {
      dbg("AMControl","AMControl online\n");

      //send radio packet here 
      //1.creating radio packet 
     // NodeToNode
    }
    else {
      call AMControl.start();
      dbg("AMControl","AMControl cannot boot, retry\n"); 
    }
  }

//check it's really stoped or not 
  event void AMControl.stopDone(error_t error){

  }

  event message_t * Receive.recevie(message_t *msg,void *payload,uint8_t len){
    return msg;
  }







  // event void Timer0.fired()
  // {
  //   call Leds.led0Toggle(); //switch off the led 
  //   dbg("Led","Led0 off  \n");
  // }

  // event void Timer1.fired(){
  //   TurnOnLed();
  // }
  
}
