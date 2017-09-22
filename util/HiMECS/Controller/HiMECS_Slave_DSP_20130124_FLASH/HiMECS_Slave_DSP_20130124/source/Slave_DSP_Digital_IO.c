// ====================================================================== //
//				HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_Digital_IO.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for Slave DSP Digital Input/Output control
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-08-16:	Draft
// ====================================================================== //

// ====================================================================== //
//	Includes
// ====================================================================== //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"
#include "Slave_DSP_External_Interface.h"
#include "Slave_DSP_Digital_IO.h"


// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function: DI_Update
//		- Get Digital Input Data, User can access the data through Slace_DIO structure.
// ---------------------------------------------------------------------- //
void DI_Update (void)
{
	Slave_DIO.DI.L1.all = DI1;
	Slave_DIO.DI.L2.all = DI2;
	DI_LED1 = ~Slave_DIO.DI.L1.all;
	DI_LED2 = ~Slave_DIO.DI.L2.all;
}
// ====================================================================== //


// ====================================================================== //
//	Function: DO_Update
//		- Output Digital Output Data, User can control DO through Slace_DIO structure.
// ---------------------------------------------------------------------- //
void DO_Update (void)
{
	// Slave DSP has only 12 DO, therefore higher 4bits should be clear.
	Slave_DIO.DO.all = (Slave_DIO.DO.all & 0x0FFF);
	DO1 = (Slave_DIO.DO.all & 0x0FFF);
}
// ====================================================================== //



// ====================================================================== //
// End of file.
// ====================================================================== //



