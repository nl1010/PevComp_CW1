#include "Timer.h"

module NetworkNodeC 
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Timer<TMilli> as Timer1;
  uses interface Boot; 
  uses interface Leds;
}

implementation
{

//functions 
    void TurnOnLed()
    {
      call Leds.led0On();
      dbg("Led","Led0 on \n");

    }

//events 
  event void Boot.booted()
  {

    call Timer0.startPeriodic(500);
    call Timer1.startPeriodic(250);
    TurnOnLed();
    dbg("Led","Led0 on \n");
    dbg("Boot","Application Booted.\n");
  }

  event void Timer0.fired()
  {
    call Leds.led0Toggle(); //switch off the led 
    dbg("Led","Led0 off  \n");
  }

  event void Timer1.fired(){
    TurnOnLed();
  }
  
}
