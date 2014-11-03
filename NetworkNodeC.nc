#include "Timer.h"

module NetworkNodeC 
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Boot; 
  uses interface Leds;
}

implementation
{

//functions 
    void TurnOnLed()
    {
      call Leds.led0On();
    }

//events 
  event void Boot.booted()
  {

    call Timer0.startPeriodic(500);
    TurnOnLed();
    dbg("Led","Led0 on \n");
    dbg("Boot","Application Booted.\n");
  }

  event void Timer0.fired()
  {
    call Leds.led0Toggle();
    dbg("Led","Led0 Toggled \n");
  }
  
}
