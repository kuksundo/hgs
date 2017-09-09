// ====================================================================== //
//				HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_main.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for Slave Operation Program 
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-04-19:	Draft
// ====================================================================== //

#ifndef SLAVE_DSP_MAIN_H
#define SLAVE_DSP_MAIN_H


#ifdef __cplusplus
extern "C" {
#endif


// ====================================================================== //
//		Include
// ---------------------------------------------------------------------- //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"


#include "Slave_DSP_GPIO.h"
#include "Slave_DSP_Parameter.h"
#include "Slave_DSP_External_Interface.h"
#include "Slave_DSP_BIT.h"
#include "Slave_DSP_Debug_SCI.h"
#include "Slave_DSP_Digital_IO.h"
#include "Slave_DSP_I2C.h"
#include "Slave_DSP_Internal_Thermo.h"
#include "Slave_DSP_McBSP.h"
#include "Slave_DSP_Analog_Input.h"
#include "Slave_DSP_SPI.h"
#include "Slave_DSP_AD7793.h"
#include "Slave_DSP_Thermocouple.h"
#include "Slave_DSP_CAN.h"
#include "Slave_DSP_RTD.h"
#include "Slave_DSP_Modbus485.h"
// ====================================================================== //



// ====================================================================== //
// 		Global Structure  
// ---------------------------------------------------------------------- //
volatile struct Slave_Digital_IO		Slave_DIO;				// Slave_DSP_Digital_IO.h
volatile struct s_Debug_buffer 			s_Debug_buffer;			// Slave_DSP_Debug_SCI.h
volatile struct s_BIT_Infomation 		s_BIT_Info;				// Slave_DSP_BIT.h
volatile struct Analog_Input_Info 		s_ADC_In;				// Slave_DSP_Analog_Input.h
volatile struct AD7793_Info				s_AD7793;				// Slave_DSP_AD7793.h
volatile struct Thermo_Couple_Info		s_Thermo_Couple;		// Slave_DSP_Thermocouple.h
volatile struct CAN_Structure 			s_CAN;					// Slave_DSP_CAN.h
volatile struct RTD_Info 				s_RTD;					// Slave_DSP_RTD.h
volatile struct s_Modbus_buffer 		s_Modbus_buffer;		// Slave_DSP_Modbus485.h
// ====================================================================== //




#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of SLAVE_DSP_MAIN_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //


