#ifndef INITIAL_H
#define INITIAL_H


typedef nx_struct NodeToNodeMsg_t { 
	nx_uint16_t NodeID;
	nx_uint8_t Data;
} NodeToNodeMsg_t;


//define constant by using enum in C
enum 
{
	AM_RADIO_TYPE = 6
};

#define INITIAL_NODE_1
#endif