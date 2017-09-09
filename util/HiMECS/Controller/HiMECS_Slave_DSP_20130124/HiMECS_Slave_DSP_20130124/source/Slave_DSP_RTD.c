// ====================================================================== //
//				HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_RTD.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for Slave DSP Built In Test
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-08-14:	Draft
// ====================================================================== //


// ====================================================================== //
//	Includes
// ====================================================================== //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"

#include "Slave_DSP_Parameter.h"
#include "Slave_DSP_RTD.h"
#include "Slave_DSP_CAN.h"

// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	RTD_Update
// 	- It will be excuted at CAN Rx Interrupt Service routine.
// ---------------------------------------------------------------------- //
void RTD_Update(Uint16 CAN_Rx_Ch)
{
	Uint16 temp1 = 0;
	Uint16 temp2 = 0;
	float temp_RTD1 = 0.0;
	float temp_RTD2 = 0.0;

	temp1 = (Uint16)(s_CAN.CAN_MBOX_Data_L[CAN_Rx_Ch] & 0x0000FFFF);
	temp2 = (Uint16)(s_CAN.CAN_MBOX_Data_L[CAN_Rx_Ch] >> 16);

	temp_RTD1 = ((float)(temp1))/10;
	temp_RTD2 = ((float)(temp2))/10;

	s_RTD.Temperature[CAN_Rx_Ch*4] = temp_RTD1;
	s_RTD.Temperature[(CAN_Rx_Ch*4)+1] = temp_RTD2;

	temp1 = (Uint16)(s_CAN.CAN_MBOX_Data_H[CAN_Rx_Ch] & 0x0000FFFF);
	temp2 = (Uint16)(s_CAN.CAN_MBOX_Data_H[CAN_Rx_Ch] >> 16);

	temp_RTD1 = ((float)(temp1))/10;
	temp_RTD2 = ((float)(temp2))/10;

	s_RTD.Temperature[(CAN_Rx_Ch*4)+2] = temp_RTD1;
	s_RTD.Temperature[(CAN_Rx_Ch*4)+3] = temp_RTD2;
}
// ====================================================================== //



// ====================================================================== //



// ====================================================================== //
// End of file.
// ====================================================================== //




