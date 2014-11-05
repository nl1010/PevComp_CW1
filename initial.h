#ifndef INITIAL_H
#define INITIAL_H

typedef nx_struct NodeToNodeMsg { 
	nx_uint16_t NodeID;
	nx_uint16_t Data;
} NodeToNodeMsg;


//define constant by using enum in C
enum 
{
	AM_RADIO_TYPE = 6
};

#define INITIAL_NODE 1

#endif