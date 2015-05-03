#include <Timer.h>
#include "printf.h"
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "Tem.h"

module TemC
{
	uses
	{
		
		interface Boot;
		interface Leds;
		interface Timer<TMilli>;
		interface SplitControl as AMControl;
		interface Receive;
		interface Packet;
		interface AMPacket;
		interface AMSend;
		
		//read
		interface Read<uint16_t> as TempRead;
		
	}
}

implementation
{
	uint16_t centigrade;
	bool radioBusy = FALSE;
	message_t _packet;
	TempMsg_t* incomingPacket;
	uint16_t data;
 	uint16_t threshold=24;
	
	event void Boot.booted()
	{
		call Timer.startPeriodic(1000);
		call Leds.led1On();
		call AMControl.start();

	}
	
	event void Timer.fired()
	{
		call TempRead.read();
	}
	
	event void AMSend.sendDone(message_t *msg, error_t error)
	{
	  if(msg == &_packet)
	  {
		  radioBusy = FALSE;
		  //Toggles led 0 everytime it finishes sending a packet
		  call Leds.led0Toggle();
	  }
	}
	
	event void AMControl.startDone(error_t error)
	{
	  if(error==SUCCESS)
	  {
	    call Leds.led0Toggle();
	    
	  }
	  else
	  {
	    call AMControl.start();
	  }
	}
	
	event void AMControl.stopDone(error_t error)
	{
	  
	}
	
	event message_t * Receive.receive(message_t *msg, void *payload, uint8_t len)
	{
		//Toggles everytime it recieves a packet
                call Leds.led2Toggle();
		if(len == sizeof(TempMsg_t))
		{
		      
 		 incomingPacket = (TempMsg_t*)payload;

				 data = incomingPacket->Data;				
 				
 				if(data >= threshold)
 				{
 				printf("The temperature that this mote recieved is: %d\r\n",data);  
 				printf("Temp is above %d degress celsius\r\n\n",threshold);
 				}
 				if(data <= threshold)
				{
 				printf("The temperature that this mote recieved is: %d\r\n",data);  
 				printf("Temp is below %d degress celsius\r\n\n",threshold);
 				}
		}
		
	  return msg;
	}
	
	
 	event void TempRead.readDone(error_t result, uint16_t val)
 	{
 		if(result == SUCCESS)
 		{
			if(radioBusy == FALSE)
			{
			  
		//creating packet
	        TempMsg_t* msg = call Packet.getPayload(& _packet, sizeof(TempMsg_t));
		centigrade = (-41.6 + (.01 )*(12* val));
		msg->NodeId = TOS_NODE_ID;
		msg->Data   =  centigrade;
 		
			//Sending the packet
			if(call AMSend.send(AM_BROADCAST_ADDR,& _packet, sizeof(TempMsg_t))==SUCCESS)
			{
				radioBusy = TRUE;
			}
			
			}
			printf("The temperature that is going to be sent is: %d \r\n", centigrade); 			
 			
 		}
 		else
 		{
 			printf("Error reading from sensor! \r\n");
		}
	}
}
