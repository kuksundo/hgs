// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_I2C.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for control I2C Interface.
//		Main DSP can control 64kb serial FRAM(FM24cl64-S) and RTC(FM31L278) using I2C.
//		
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-05-16:	Draft
// ====================================================================== //


// ====================================================================== //
//	Includes
// ====================================================================== //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"
#include "Main_DSP_Parameter.h"
#include "Main_DSP_I2C.h"



// ====================================================================== //
//	Functions
// ====================================================================== //

// Initialize I2C 
void Init_I2CA(void)
{
	// Setting GPIO for I2C
	EALLOW;
	/* Enable internal pull-up for the selected pins */
	GpioCtrlRegs.GPBPUD.bit.GPIO32 = 0;    // Enable pull-up for GPIO32 (SDAA)
	GpioCtrlRegs.GPBPUD.bit.GPIO33 = 0;	   // Enable pull-up for GPIO33 (SCLA)
	
	/* Set qualification for selected pins to asynch only */
	GpioCtrlRegs.GPBQSEL1.bit.GPIO32 = 3;  // Asynch input GPIO32 (SDAA)
	GpioCtrlRegs.GPBQSEL1.bit.GPIO33 = 3;  // Asynch input GPIO33 (SCLA)
	
	/* Configure I2C pins using GPIO regs*/
	// This specifies which of the possible GPIO pins will be I2C functional pins.
	GpioCtrlRegs.GPBMUX1.bit.GPIO32 = 1;   // Configure GPIO32 for SDAA operation
	GpioCtrlRegs.GPBMUX1.bit.GPIO33 = 1;   // Configure GPIO33 for SCLA operation
	EDIS;
	
	// Initialize I2C interface
	// Put I2C module in the reset state
	I2caRegs.I2CMDR.bit.IRS = 0;
	
	// Set Slave Address according to AT24C16 device
	I2caRegs.I2CSAR = 0x0068; //eeprom slave address

	// Set I2C module clock input
	I2caRegs.I2CPSC.all = 14; // need 7-12 Mhz on module clk (150/15 = 10MHz)
	
	// 400KHz clock speed in SCL for master mode(2.5us period)
	// Clock Pulse Width Low  : 1.5us
	// Clock Pulse Width High : 1.0us
	// F28335의 I2C User Guide에서 Master Clock 주기를 구하는 공식을 참조바람.
	I2caRegs.I2CCLKL = 10;
	I2caRegs.I2CCLKH = 5;
	
	// Disable I2C interrupt
	I2caRegs.I2CIER.all = 0x0;
	
	// Enable TX and RX FIFO in I2C module
	I2caRegs.I2CFFTX.all = 0x6000; // Enable FIFO mode and TXFIFO
	I2caRegs.I2CFFRX.all = 0x2040; // Enable RXFIFO, clear RXFFINT

	// Enable I2C module
	I2caRegs.I2CMDR.all = 0x20; 
}


// refer to single byte write mode.
void Write_I2C_Data(Uint16 slave_addr, Uint16 addr, Uint16 data)
{
  	Uint16 data_addr_msb, data_addr_lsb;

	data_addr_msb = addr>>8 & 0xff;
	data_addr_lsb = addr & 0xff;

	// Wait until the STP bit is cleared from any previous master communication.
	while(I2caRegs.I2CMDR.bit.STP == 1);
	
	// Wait until bus-free status
	while(I2caRegs.I2CSTR.bit.BB == 1);
	
	// Set Device(Slave) Address
	I2caRegs.I2CSAR = slave_addr;
	
	// Setup number of byters to send
	I2caRegs.I2CCNT = 3;


	// Setup data to send
	I2caRegs.I2CDXR = data_addr_msb; 		// Data Address MSB
	I2caRegs.I2CDXR = data_addr_lsb; 		// Data Address LSB
	I2caRegs.I2CDXR = data;							// Write Data
	
	// Send start as master transmitter with STT(=1), STP(=1), XA(=0), RM(=0) 
	I2caRegs.I2CMDR.all = 0x6E20;
	
	// Wait until STOP condition is detected and clear STOP condition bit
	while(I2caRegs.I2CSTR.bit.SCD == 0);
	I2caRegs.I2CSTR.bit.SCD = 1;
}


// refer to single byte random read mode.
void Read_I2C_Data(Uint16 slave_addr, Uint16 addr, unsigned char* pData)
{
 	Uint16 data_addr_msb, data_addr_lsb;
	
	data_addr_msb = addr>>8 & 0xff;
	data_addr_lsb = addr & 0xff;
	 
	// Wait until the STP bit is cleared from any previous master communication.
	while(I2caRegs.I2CMDR.bit.STP == 1);
	
	// Wait until bus-free status
	while(I2caRegs.I2CSTR.bit.BB == 1);
	
	// Set Device(Slave) Address
	I2caRegs.I2CSAR = slave_addr;
	
	// Setup number of bytes to send
	I2caRegs.I2CCNT = 2;

	// Setup data to send
	I2caRegs.I2CDXR = data_addr_msb; 		// Data Address MSB
	I2caRegs.I2CDXR = data_addr_lsb; 		// Data Address LSB
	
	// Send start as master transmitter with STT(=1), STP(=0), XA(=0), RM(=0) 
	I2caRegs.I2CMDR.all = 0x2620;
	
	// Wait until ARDY status bit is set
	while(I2caRegs.I2CSTR.bit.ARDY == 0);
	
	// Wait until the STP bit is cleared
	while(I2caRegs.I2CMDR.bit.STP == 1);
	
	// Set Device(Slave) Address
	I2caRegs.I2CSAR = slave_addr;

	// Setup number of bytes to read
	I2caRegs.I2CCNT = 1;
	
	// Send start as master receiver with STT(=1), STP(=1), XA(=0), RM(=0) 
	I2caRegs.I2CMDR.all = 0x2C20;
	
	// Wait until STOP condition is detected and clear STOP condition bit
	while(I2caRegs.I2CSTR.bit.SCD == 0);
	I2caRegs.I2CSTR.bit.SCD = 1;
	
	*pData = (unsigned char)(I2caRegs.I2CDRR & 0xff);  
}

// ====================================================================== //




// ====================================================================== //
// End of file.
// ====================================================================== //











