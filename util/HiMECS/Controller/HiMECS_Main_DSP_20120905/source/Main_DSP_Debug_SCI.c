// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_Debug_SCI.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for Main DSP Debug Serial Communication Interface (SCI)
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-04-22:	Draft
// ====================================================================== //


// ====================================================================== //
//	Includes
// ====================================================================== //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"

#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

#include "Main_DSP_Parameter.h"
#include "Main_DSP_Debug_SCI.h"



// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function: Debug_SCI_GPIO_Init
//		- Initialize SCI-C GPIO(62, 63) for Debug SCI.
// ---------------------------------------------------------------------- //
void Debug_SCI_GPIO_Init (void)
{
	 EALLOW;

	/* Enable internal pull-up for the selected pins */
	// Pull-ups can be enabled or disabled disabled by the user.  
	// This will enable the pullups for the specified pins.

	GpioCtrlRegs.GPBPUD.bit.GPIO62 = 0;    // Enable pull-up for GPIO62 (SCIRXDC)
	GpioCtrlRegs.GPBPUD.bit.GPIO63 = 0;	   // Enable pull-up for GPIO63 (SCITXDC)

	/* Set qualification for selected pins to asynch only */
	// Inputs are synchronized to SYSCLKOUT by default.  
	// This will select asynch (no qualification) for the selected pins.

	GpioCtrlRegs.GPBQSEL2.bit.GPIO62 = 3;  // Asynch input GPIO62 (SCIRXDC)

	/* Configure SCI-C pins using GPIO regs*/
	// This specifies which of the possible GPIO pins will be SCI functional pins.

	GpioCtrlRegs.GPBMUX2.bit.GPIO62 = 1;   // Configure GPIO62 for SCIRXDC operation
	GpioCtrlRegs.GPBMUX2.bit.GPIO63 = 1;   // Configure GPIO63 for SCITXDC operation
	
	 EDIS;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Debug_SCI_Reg_Init
//		- Initialize SCI-C for Debug COM.
// ---------------------------------------------------------------------- //
void Debug_SCI_Reg_Init (Uint32 baud_rate)
{
	// BRR bit 
	Uint32 BRR = 243;	// default 19200bps

	// BRR value
	Uint16 BRR_H = 0;
	Uint16 BRR_L = 243;
	
	EALLOW;
	
	// SCI-C Communication Control Register Initialization.
	ScicRegs.SCICCR.bit.SCICHAR = 7;				// 111b = 8bits char
	ScicRegs.SCICCR.bit.ADDRIDLE_MODE = 0;			// Idle-line mode Protocol.
	ScicRegs.SCICCR.bit.LOOPBKENA = DISABLE;		// No Loopback mode.
	//ScicRegs.SCICCR.bit.PARITYENA = ENABLE;		// Parity is Enable.
	ScicRegs.SCICCR.bit.PARITYENA = DISABLE;		// Parity is DISABLE.
	ScicRegs.SCICCR.bit.PARITY = 0;					// Odd Parity
	ScicRegs.SCICCR.bit.STOPBITS = 0;				// Stop bits = 1

	// SCI-C Control Register 1 Initialization.
	ScicRegs.SCICTL1.bit.RXENA = ENABLE;			// RX Enable.
	ScicRegs.SCICTL1.bit.TXENA = ENABLE; 			// TX Enable.
	ScicRegs.SCICTL1.bit.SLEEP = DISABLE;			// Sleep mode Disable.
	ScicRegs.SCICTL1.bit.TXWAKE = DISABLE;			// Tx wake-up mode Disable.
	ScicRegs.SCICTL1.bit.SWRESET = 0;				// SCI reset condition.
	ScicRegs.SCICTL1.bit.RXERRINTENA =ENABLE;		// RX Error Interrupt Enable.

	// SCI-C Control Register 2 Initialization.
	ScicRegs.SCICTL2.bit.TXINTENA = DISABLE;		// TX Ready interrupt Disable.
	ScicRegs.SCICTL2.bit.RXBKINTENA = ENABLE;		// RX Ready Interrupt Enable.

	// SCI-C Baud Select Register Initialization.
	// Baud rate = (LSPCLK=37.5Mhz)/(BRR+1)*8 
	// BRR = (LSPCLK/(Baudrate*8))-1

	BRR = (Uint32)(LSP_CLK/(baud_rate*8))-1;

	BRR_H = (Uint16)((BRR & 0xFF00)>>8);
	BRR_L = (Uint16)(BRR & 0x00FF);
	
	ScicRegs.SCIHBAUD = BRR_H;	
	ScicRegs.SCILBAUD = BRR_L;

	// SCI-C Re-Enable 
	ScicRegs.SCICTL1.bit.SWRESET = 1;

	EDIS;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Debug_SCI_FIFO_Init
//		- Initialize SCI-C FIFO for Debug COM.
// ---------------------------------------------------------------------- //
void Debug_SCI_FIFO_Init (void)
{
	EALLOW;
		
	// SCI-C TX FIFO Intialization.
	ScicRegs.SCIFFTX.bit.SCIRST = 0;				// SCI-C FIFO Reset.
	ScicRegs.SCIFFTX.bit.TXFFIL = 0;				// Tx FIFO Interrupt Level = default. 
													// (Interrupt occurs when FIFO level is less then FIFO Status)
	ScicRegs.SCIFFTX.bit.TXFFIENA = DISABLE;		// Tx FIFO Interrupt Disable.
	ScicRegs.SCIFFTX.bit.TXFFINTCLR = 1;			// Tx FIFO Clear.
	ScicRegs.SCIFFTX.bit.TXFIFOXRESET = 1;			// Transmit FIFO Reset.
	ScicRegs.SCIFFTX.bit.SCIFFENA = 1;				// SCI-C FIFO Enable.
	ScicRegs.SCIFFTX.bit.SCIRST = 1;				// SCI-C SCI resume.

	// SCI-C RX FIFO Intialization.
	ScicRegs.SCIFFRX.bit.RXFFIL = 0x01;				// Rx FIFO interrupt Leverl = 1ea.
	ScicRegs.SCIFFRX.bit.RXFFIENA = ENABLE;			// Rx FIFO Interrupt Disable.
	ScicRegs.SCIFFRX.bit.RXFFINTCLR = 1;			// Rx FIFO Interrupt Clear.
	ScicRegs.SCIFFRX.bit.RXFIFORESET = 1;			// Rx FIFO Reset.
	ScicRegs.SCIFFRX.bit.RXFFOVRCLR = 0;			// Rx FIFO Overflow Don't Clear.
	ScicRegs.SCIFFRX.bit.RXFFOVF = 0;				// Rx FIfO Overflow Flag.

	// SCI-C FIFO Control Register Initialization.
	ScicRegs.SCIFFCT.bit.FFTXDLY = 0;				// FIFO Tx Delay = 0;
	ScicRegs.SCIFFCT.bit.CDC = DISABLE;				// Disable auto-baud alignment.
	ScicRegs.SCIFFCT.bit.ABDCLR = 0;				// ABD Don't Clear.

	EDIS;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Debug_SCI_Init
//		- Execute SCI-C intialization procedure.
// ---------------------------------------------------------------------- //
void Debug_SCI_Init (Uint32 baud_rate)
{
	int i = 0;
	
	Debug_SCI_GPIO_Init();
	Debug_SCI_FIFO_Init();
	Debug_SCI_Reg_Init(baud_rate);

	// Reset Debug SCI Global Structure
	s_Debug_buffer.rx_buff_index = 0;

	for (i=0; i<DEBUG_RX_BUFF_SIZE; i++)
	{
		s_Debug_buffer.rx_buffer[i] = '\0';
	}

	s_Debug_buffer.tx_buff_index = 0;

	for (i=0; i<DEBUG_TX_BUFF_SIZE; i++)
	{
		s_Debug_buffer.tx_buffer[i] = '\0';
	}	
}
// ====================================================================== //


// ====================================================================== //
//	Function: Debug_SCI_Rx
//		- Get a character(8-bit) from SCI-C buffer.
// ---------------------------------------------------------------------- //
unsigned char Debug_SCI_Rx (void)
{
	unsigned char data;

	data = ScicRegs.SCIRXBUF.bit.RXDT;

	return data;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Debug_SCI_Tx
//		- Send a charactor(8-bit) through SCI-C
// ---------------------------------------------------------------------- //
void Debug_SCI_Tx(unsigned char data)
{
	// Check TX FIFO Buffer
	// Wait until TX_buffer has empty space.
	while ( ScicRegs.SCIFFTX.bit.TXFFST >= 15);
	
	// Send a character message.
	ScicRegs.SCITXBUF=data;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Debug_SCI_Init
//		- SCI-C Interrupt Service Routine.
// ---------------------------------------------------------------------- //
interrupt void Debug_SCI_Rx_ISR (void)
{
	unsigned char data;

	// Check RX Buffer Overflow (SCIFFRX)
	if ( ScicRegs.SCIFFRX.bit.RXFFOVF == 1 )
	{
		// Clear Rx Buffer Overflow flag.
		ScicRegs.SCIFFRX.bit.RXFFOVRCLR = 1;

		// SCI-C Reset and Initialization.
		Debug_SCI_Init(DEFAULT_SCI_C_BAUD);
	}
	
	// Check Rx Error (SCIRXST)
	else if ( ScicRegs.SCIRXST.bit.RXERROR == 1 )
	{
		// SCI-C Reset and Initialization. (SW Reset only can clear RX Error interrupt flag.)
		Debug_SCI_Init(DEFAULT_SCI_C_BAUD);
	}

	// Get a data from SCI-C buffer and echo the received data.
	else
	{
		// Save the rx data in Rx buffer.
		data = Debug_SCI_Rx();

		// Echo the rx data.
		Debug_SCI_Tx(data);
	}

	// Clear Rx Buffer Interrupt flag.
	ScicRegs.SCIFFRX.bit.RXFFINTCLR = 1;
	// Interrupt Ack Bit Set.
	PieCtrlRegs.PIEACK.bit.ACK8 = 1;
}
// ===========================================================================================



// ====================================================================== //
//	Function: Debug_SCI_Interrupt_Init
//		- Initialize SCI-C Rx ISR interrupt vector.
// ---------------------------------------------------------------------- //
void Debug_SCI_Interrupt_Init(void)
{
	EALLOW;
	
	PieVectTable.SCIRXINTC = &Debug_SCI_Rx_ISR;
	
	// SCI-C RX Interrupt vector setting
	PieCtrlRegs.PIEIER8.bit.INTx5 = 1;
	
	IER |= M_INT8;	// PIEIER8 Enable.
	
	EDIS;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Printf
//		- User can use Debug Com like using printf function.
//		- CAUTION!!: It DO NOT support printing float point variable. 
//					 User should be careful about the range of variable.
//					 This function can print ONLY 16-bit variables or less than 16-bit.
// ---------------------------------------------------------------------- //
int Printf(char *form, ... )
{
	char buff[100];
	int i=0,len=0;
	unsigned char data = 0;
	va_list  argptr;					

	buff[0] = 0x0;
	buff[1] = 0x0;
	va_start( argptr, form );	
	len = vsprintf(buff, form, argptr );	
	va_end( argptr );	


	if( (len < 0 ) || (len >= 100) )
	{
		return FAIL;
	}
	else
	{

		for(i = 0; i < len; i++)
		{
			data = buff[i];
			Debug_SCI_Tx(data);		// COM1 Tx 
		}
	}
	return(i);
}
// ====================================================================== //







// ====================================================================== //



// ====================================================================== //
// End of file.
// ====================================================================== //




