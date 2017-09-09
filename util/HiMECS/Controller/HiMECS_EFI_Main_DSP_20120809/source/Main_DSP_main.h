// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_main.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for Main Operation Program 
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-04-19:	Draft
// ====================================================================== //

#ifndef MAIN_DSP_MAIN_H
#define MAIN_DSP_MAIN_H


#ifdef __cplusplus
extern "C" {
#endif


// ====================================================================== //
//		Include
// ---------------------------------------------------------------------- //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"


#include "Main_DSP_GPIO.h"
#include "Main_DSP_Parameter.h"
#include "Main_DSP_External_Interface.h"
#include "Main_DSP_BIT.h"
#include "Main_DSP_Debug_SCI.h"
#include "Main_DSP_Modbus.h"
#include "Main_DSP_Sensor_Monitor.h"
#include "Main_DSP_Digital_IO.h"
#include "Main_DSP_I2C.h"
#include "Main_DSP_McBSP.h"
#include "Main_DSP_Analog_Input.h"
#include "Main_DSP_Analog_Output.h"
#include "Main_DSP_RTC.h"
// ====================================================================== //



// ====================================================================== //
// 		Global Structure  
// ---------------------------------------------------------------------- //
volatile struct 	Main_Digital_IO		s_Main_DIO;				// Main_DSP_Digital_IO.h
volatile struct 	s_Debug_buffer 		s_Debug_buffer;			// Main_DSP_Debug_SCI.h
volatile struct 	s_Modbus_buffer 	s_Modbus_buffer;		// Main_DSP_Modbus.h
volatile struct 	s_BIT_Infomation 	s_BIT_Info;				// Main_DSP_BIT.h
volatile union 		AD_DA_Control		u_AD_DA_Ctrl;			// Main_DSP_External_Interface.h
volatile struct 	Analog_Input_Info 	s_ADC_In;				// Main_DSP_Analog_Input.h
volatile struct 	DAC_Info 			s_DAC;					// Main_DSP_Analog_Ouput.h
volatile struct 	RTC_Time 			s_RTC;					// Main_DSP_RTC.h
// ====================================================================== //




#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of MAIN_DSP_MAIN_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //


