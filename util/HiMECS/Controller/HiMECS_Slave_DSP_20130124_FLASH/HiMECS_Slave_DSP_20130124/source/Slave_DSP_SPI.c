// ====================================================================== //
//						HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_SPI.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for SPI Device Driver.
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2012-07-03:	Draft
// ====================================================================== //



// ====================================================================== //
//	Includes
// ====================================================================== //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"

#include "Slave_DSP_Parameter.h"
#include "Slave_DSP_SPI.h"
// ====================================================================== //



// ====================================================================== //
//	Global Variables
// ====================================================================== //

// ====================================================================== //



// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//		SPI-A GPIO Initialization Fuctions 
// ---------------------------------------------------------------------- //
void Init_SPI_GPIO(void)
{
	EALLOW;
	
	// Enable internal pull-up for the selected pins //
	// Pull-ups can be enabled or disabled by the user.  
	// This will enable the pullups for the specified pins.
	// Comment out other unwanted lines.
	GpioCtrlRegs.GPBPUD.bit.GPIO54 = 0;   	// Enable pull-up on GPIO54 (SPISIMOA)
	GpioCtrlRegs.GPBPUD.bit.GPIO55 = 0;   	// Enable pull-up on GPIO55 (SPISOMIA)
	GpioCtrlRegs.GPBPUD.bit.GPIO56 = 0;   	// Enable pull-up on GPIO56 (SPICLKA)
	//GpioCtrlRegs.GPBPUD.bit.GPIO57 = 0;   	// Enable pull-up on GPIO57 (SPISTEA)


	// Set qualification for selected pins to asynch only //
	// This will select asynch (no qualification) for the selected pins.
	// Comment out other unwanted lines.
	GpioCtrlRegs.GPBQSEL2.bit.GPIO54 = 3; 	// Asynch input GPIO54 (SPISIMOA)
	GpioCtrlRegs.GPBQSEL2.bit.GPIO55 = 3; 	// Asynch input GPIO55 (SPISOMIA)
	GpioCtrlRegs.GPBQSEL2.bit.GPIO56 = 3; 	// Asynch input GPIO56 (SPICLKA)
	//GpioCtrlRegs.GPBQSEL2.bit.GPIO57 = 3; 	// Asynch input GPIO57 (SPISTEA)


	// Configure SPI-A pins using GPIO regs //
	// This specifies which of the possible GPIO pins will be SPI functional pins.
	// Comment out other unwanted lines.
	GpioCtrlRegs.GPBMUX2.bit.GPIO54 = 1; 	// Configure GPIO54 as SPISIMOA
	GpioCtrlRegs.GPBMUX2.bit.GPIO55 = 1; 	// Configure GPIO55 as SPISOMIA
	GpioCtrlRegs.GPBMUX2.bit.GPIO56 = 1; 	// Configure GPIO56 as SPICLKA
	//GpioCtrlRegs.GPBMUX2.bit.GPIO57 = 1; 	// Configure GPIO57 as SPISTEA

	EDIS;
}
// ====================================================================== //


// ====================================================================== //
//		SPI-A FIFO Initialization Fuctions 
// ---------------------------------------------------------------------- //
void SPI_FIFO_Init(void)										
{
	EALLOW;
	
	// Initialize SPI TX FIFO register
	SpiaRegs.SPIFFTX.bit.SPIRST = 1;		// SPI FIFO Reset.
	SpiaRegs.SPIFFTX.bit.SPIFFENA = 1;		// SPI FiFO Enhancement Enable.
	SpiaRegs.SPIFFTX.bit.TXFIFO = 1;		// TX FIFO Reset.
	SpiaRegs.SPIFFTX.bit.TXFFST = 0;		// Transmit FIFO Status = empty.
	SpiaRegs.SPIFFTX.bit.TXFFINT = 0;		// TX FIFO Interrupt has NOT Occurred. (Read Only)
	SpiaRegs.SPIFFTX.bit.TXFFINTCLR = 1;	// TX FIFO Clear: TX Interrupt Flag Clear.
	SpiaRegs.SPIFFTX.bit.TXFFIENA = 0;		// TX FIFO Interrupt Disable.
	SpiaRegs.SPIFFTX.bit.TXFFIL = 0xF;		// TX FIFO Interrupt level TXFFIL >= TXFFST, then interrupt will occur.
	
	// Initialize SPI RX FIFO register
	SpiaRegs.SPIFFRX.bit.RXFFOVF = 0;		// RX FIFO Overflow Flag - RX FIFO has not overflowed.
	SpiaRegs.SPIFFRX.bit.RXFFOVFCLR = 1;	// RX FIFO Overflow Clear.
	SpiaRegs.SPIFFRX.bit.RXFIFORESET = 1;	// RX FIFO Reset.
	SpiaRegs.SPIFFRX.bit.RXFFST = 0;		// RX FIFO Empty.
	SpiaRegs.SPIFFRX.bit.RXFFINT = 0;		// RX FIFO Interrupt has NOT Occurred. (Read Only)
	SpiaRegs.SPIFFRX.bit.RXFFINTCLR = 1;	// RX FIFO Interrupt Flag Clear.
	SpiaRegs.SPIFFRX.bit.RXFFIENA = 0;		// RX FIFO Interrupt Disable.
	SpiaRegs.SPIFFRX.bit.RXFFIL = 0xF;		// RX FIFO Interrupt level RXFFIL >= RSFFST, then Interrupt will occur.

	// Initialize SPI FIFO Control Register 
	SpiaRegs.SPIFFCT.all=0x0;

	EDIS;
} 
// ====================================================================== //




// ====================================================================== //
//		SPI-A Initialization Fuctions 
// ---------------------------------------------------------------------- //
void SPI_Init(void)
{    
	// SPI GPIO Configuration.
	Init_SPI_GPIO();

	EALLOW;
	// SPI Configuration Control Register Setting.
	SpiaRegs.SPICCR.bit.SPISWRESET = 0;			// Before SPI configuration, SW Reset bit should be CLEAR.
	SpiaRegs.SPICCR.bit.CLKPOLARITY = 1;		// Data is output on Falling edge for communication.
	SpiaRegs.SPICCR.bit.SPILBK = 0;				// SPI Loopback mode is Disable.
	SpiaRegs.SPICCR.bit.SPICHAR = CHAR_8BIT; 	// SPI character length is 16.

	// SPI Operation Control Register Setting.
	SpiaRegs.SPICTL.bit.OVERRUNINTENA = 0;		// Overrun interrupt Disable.
	SpiaRegs.SPICTL.bit.CLK_PHASE = 0; 			// Without delay SPI Clock Scheme.
	SpiaRegs.SPICTL.bit.TALK = 1;				// Master and Slave Transmission Enable.
	SpiaRegs.SPICTL.bit.SPIINTENA	= 0;		// SPI RX/TX Interrupt Disable.

	// SPI Master/Slave mode Setting
	SpiaRegs.SPICTL.bit.MASTER_SLAVE = 1;		// Set Master mode.

	// SPI Baud Rate Register Setting.
	SpiaRegs.SPIBRR = 7;						// SPI Baud Rate = LSPCLK/(SPIBRR+1) -> 37.5/7+1= 4.6875Mhz
												// The minimum value is 3.

	// SPI Software Reset Setting.
	SpiaRegs.SPICCR.bit.SPISWRESET = 1;			// Relinquish SPI from Reset   

	// SPI Priority Control register Setting.
	SpiaRegs.SPIPRI.bit.FREE = 1;				// Set so breakpoints don't disturb xmission.
	EDIS;
	
	SPI_FIFO_Init();
}
// ====================================================================== //




// ====================================================================== //
//		SPI-A Tx Fuctions 
// ---------------------------------------------------------------------- //
void SPI_Xmit (Uint16 msg)
{
	SpiaRegs.SPITXBUF=msg;
}
// ====================================================================== //

// ====================================================================== //
//		SPI-A Rx Fuctions 
// ---------------------------------------------------------------------- //
Uint16 SPI_Receive (void)
{
	Uint16 temp_rx = 0;
	
	while (SpiaRegs.SPIFFRX.bit.RXFFST !=0 )
	{
		temp_rx = SpiaRegs.SPIRXBUF;
	}

	return temp_rx;
}
// ====================================================================== //


// ===========================================================================================
//		SPI-A Loopback Test Fuctions 
// -------------------------------------------------------------------------------------------
int SPI_Loopback_Test (void)
{
	Uint16 Test_Msg = 0x01;
	Uint16 temp = 0;
	int i = 0;
	int result = 0;

	// SPI Registers setting for Loopback Test.
	EALLOW;
	// SPI Configuration Control Register Setting.
	SpiaRegs.SPICCR.bit.SPISWRESET = 0;			// Before SPI configuration, SW Reset bit should be CLEAR.
	SpiaRegs.SPICCR.bit.CLKPOLARITY = 1;		// Data is output on Rising edge for communication.
	SpiaRegs.SPICCR.bit.SPILBK = 1;				// SPI Loopback mode is Enable.
	SpiaRegs.SPICCR.bit.SPICHAR = CHAR_8BIT; 	// SPI character length is 8.

	// SPI Operation Control Register Setting.
	SpiaRegs.SPICTL.bit.OVERRUNINTENA = 0;		// Overrun interrupt Disable.
	SpiaRegs.SPICTL.bit.CLK_PHASE = 0; 			// Normal SPI Clock Scheme.
	SpiaRegs.SPICTL.bit.TALK = 1;				// Master and Slave Transmission Enable.
	SpiaRegs.SPICTL.bit.SPIINTENA	= 0;		// SPI RX/TX Interrupt Disable.

	// SPI Master/Slave mode Setting
	SpiaRegs.SPICTL.bit.MASTER_SLAVE = 1;		// Set Master mode.

	// SPI Baud Rate Register Setting.
	SpiaRegs.SPIBRR = 7;						// SPI Baud Rate = LSPCLK/(SPIBRR+1) -> 35.7/4+1= 5Mhz

	// SPI Software Reset Setting.
	SpiaRegs.SPICCR.bit.SPISWRESET = 1;			// Relinquish SPI from Reset   

	// SPI Priority Control register Setting.
	SpiaRegs.SPIPRI.bit.FREE = 1;				// Set so breakpoints don't disturb xmission.

	EDIS;
	
	// Loopback Test
	for (i=0;i<1;i++)
	{
		// Transmit data
		SPI_Xmit(Test_Msg<<8);
		// Wait until data is received
    	 while(SpiaRegs.SPIFFRX.bit.RXFFST !=1){}
     	// Get the message from RX FIFO
      	temp = SpiaRegs.SPIRXBUF;
		// Check the message
		if ( temp == Test_Msg)
		{
			// Loop Test is PASS.
			result = PASS;
		}
		else
		{
			result = FAIL;
		}
		Test_Msg++;
	}

	// Restore SPI Setting.
	SPI_Init();
		
	// Return Loopback Test Result.
	return result;
}
// ===========================================================================================




// ====================================================================== //



// ====================================================================== //
// End of file.
// ====================================================================== //


