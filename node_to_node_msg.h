#ifndef NODE_TO_NODE_MSG_H
#define NODE_TO_NODE_MSG_H


typedef nx_struct NodeToNodeMsg { 
	nx_uint16_t NodeID;
	nx_uint8_t Data;
} NodeToNodeMsg;


//define constant by using enum in C
enum 
{
	AM_RADIO_TYPE = 6
};


#endif