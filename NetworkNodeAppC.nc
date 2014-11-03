//App- configuration file 

configuration NetworkNodeAppC
{
	//do nothing 
}
implementation
{ //interface : boot , leds => add components according to the interface 

  components MainC; //singleton
  components LedsC; //singleton 
  
  components new TimerMilliC() as Timer0;

//app component 
  components NetworkNodeC as Node1; //must define project component, can have multiple instance , keyword 'as'

  //Wiring , wire 'physical' component(boot,leds) to the code (mainC,LedsC)
  Node1.Boot -> MainC;
  Node1.Leds -> LedsC;
  Node1.Timer0 -> Timer0;

}



