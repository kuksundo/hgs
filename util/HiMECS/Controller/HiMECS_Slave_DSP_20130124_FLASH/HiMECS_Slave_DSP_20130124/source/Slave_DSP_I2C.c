// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_I2C.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for control I2C Interface.
//		Slave DSP controls Internal Themo-Sensor using I2C.
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-10-20:	Draft
// ====================================================================== //


// ====================================================================== //
//	Includes
// ====================================================================== //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"
#include "Slave_DSP_Parameter.h"
#include "Slave_DSP_I2C.h"



// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function: I2C_Init
//		- Initialization I2C Interface.
// ---------------------------------------------------------------------- //
void I2C_Init(void)
{
	// Setting GPIO for I2C
	EALLOW;
	// Enable internal pull-up for the selected pins 
	GpioCtrlRegs.GPBPUD.bit.GPIO32 = 0;    // Enable pull-up for GPIO32 (SDAA)
	GpioCtrlRegs.GPBPUD.bit.GPIO33 = 0;	   // Enable pull-up for GPIO33 (SCLA)
	
	// Set qualification for selected pins to asynch only 
	GpioCtrlRegs.GPBQSEL1.bit.GPIO32 = 3;  // Asynch input GPIO32 (SDAA)
	GpioCtrlRegs.GPBQSEL1.bit.GPIO33 = 3;  // Asynch input GPIO33 (SCLA)
	
	// Configure I2C pins using GPIO regs
	// This specifies which of the possible GPIO pins will be I2C functional pins.
	GpioCtrlRegs.GPBMUX1.bit.GPIO32 = 1;   // Configure GPIO32 for SDAA operation
	GpioCtrlRegs.GPBMUX1.bit.GPIO33 = 1;   // Configure GPIO33 for SCLA operation
	EDIS;
	
	// Initialize I2C interface
	// Put I2C module in the Reset state.
	I2caRegs.I2CMDR.bit.IRS = 0;
	
	// Set Slave Address according to TSC2003
	I2caRegs.I2CSAR = 0x48;		// Internal Thermo-Sensor Slave Address.

	// Set I2C module clock input
	I2caRegs.I2CPSC.all = 14; 		// need 7-12 Mhz on module clk (150/15 = 10MHz)
	
	// 400KHz clock speed in SCL for master mode(Standard-10us, Fast-2.5us period)
	// Clock Pulse Width Low  : Standard-4.7us, Fast-1.3us
	// Clock Pulse Width High : Standard-4.0us, Fast-0.6us
	I2caRegs.I2CCLKL = 45;  // Module Clk * (CCLKL+5) = 5us
	I2caRegs.I2CCLKH = 45;	// Module Clk * (CCLkL+5) = 5us
	
	// Disable I2C interrupt
	I2caRegs.I2CIER.all = 0x0;
	
	// Enable TX and RX FIFO in I2C module
	I2caRegs.I2CFFTX.all = 0x6000; // Enable FIFO mode and TXFIFO
	I2caRegs.I2CFFRX.all = 0x2040; // Enable RXFIFO, clear RXFFINT

	// Enable I2C module
	I2caRegs.I2CMDR.all = 0x20; 
}
// ====================================================================== //



// ====================================================================== //
//	Function: Write_I2C_Data
//		- Write Command to TSC2003
// ---------------------------------------------------------------------- //
void Write_I2C_Data(unsigned char Slave_Addr, unsigned char Command)
{
	// Wait until the STP bit is cleared from any previous master communication.
	while(I2caRegs.I2CMDR.bit.STP == 1);
	
	// Wait until bus-free status
	while(I2caRegs.I2CSTR.bit.BB == 1);
	
	// Set Device(Slave) Address
	I2caRegs.I2CSAR = (Uint16)Slave_Addr;
	
	// Setup number of byters to send
	I2caRegs.I2CCNT = 1;

	// Setup data to send
	I2caRegs.I2CDXR = Command;
	
	// Send start as master transmitter with STT(=1), STP(=1), XA(=0), RM(=0) 
	I2caRegs.I2CMDR.all = 0x6E20;
	
	// Wait until STOP condition is detected and clear STOP condition bit
	while(I2caRegs.I2CSTR.bit.SCD == 0);
	I2caRegs.I2CSTR.bit.SCD = 1;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Read_I2C_Data
//		- Read Command to TSC2003
// ---------------------------------------------------------------------- //
Uint16 Read_I2C_Data(unsigned char Slave_addr)
{
	Uint16 data = 0;
	
	// Wait until the STP bit is cleared from any previous master communication.
	while(I2caRegs.I2CMDR.bit.STP == 1);
	
	// Wait until bus-free status
	while(I2caRegs.I2CSTR.bit.BB == 1);
	
	// Set Device(Slave) Address
	I2caRegs.I2CSAR = (Uint16)Slave_addr;

	// Setup number of bytes to read
	I2caRegs.I2CCNT = 2;
	
	// Send start as master receiver with STT(=1), STP(=1), XA(=0), RM(=0) 
	I2caRegs.I2CMDR.all = 0x2C20;
	
	// Wait until STOP condition is detected and clear STOP condition bit
	while(I2caRegs.I2CSTR.bit.SCD == 0);
	I2caRegs.I2CSTR.bit.SCD = 1;
	
	data = ((I2caRegs.I2CDRR & 0xff)<<8);  
	data = data + (I2caRegs.I2CDRR & 0xff);

	return data;	
}
// ====================================================================== //





// ====================================================================== //




// ====================================================================== //
// End of file.
// ====================================================================== //











