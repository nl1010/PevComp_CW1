#ifndef INITIAL_H
#define INITIAL_H

typedef nx_struc NodeToNodeMsg
{
 //radio packet that have contains NodeID and Data 
	nx_uint16_t NodeID;
	nx_uint8 Data;
}
NodeToNodeMsg_t;


//define constant by using enum in C
enum 
{
	AM_RADIO = 6
}


#define INITIAL_NODE_1
#endif