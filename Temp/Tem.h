#ifndef Tem_H
#define Tem_H

typedef nx_struct TempMsg
{
nx_uint16_t NodeId;
nx_uint16_t Data;

}TempMsg_t;

enum 
{
  AM_RADIO = 6
};

#endif ///*Temp_H /*
