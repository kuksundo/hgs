// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_Debug_Modbus.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for Main DSP Modbus Communication 
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-05-02:	Draft
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

 
#include "Main_DSP_Modbus.h"

#include "Main_DSP_Parameter.h"
 



 // ====================================================================== //

#if (STANDALONE)

// CPU Timer0/1/2ÀÇ Interrupt Service Function ¼±¾ð
#pragma CODE_SECTION(Modbus_GPIO_Init, "ramfuncs");
#pragma CODE_SECTION(Modbus_Reg_Init, "ramfuncs");
#pragma CODE_SECTION(Modbus_FIFO_Init, "ramfuncs");
#pragma CODE_SECTION(Modbus_Init, "ramfuncs");
#pragma CODE_SECTION(Modbus_Rx, "ramfuncs");
#pragma CODE_SECTION(Modbus_Tx_byte, "ramfuncs");
#pragma CODE_SECTION(Modbus_Tx, "ramfuncs");
#pragma CODE_SECTION(Modbus_Rx_ISR, "ramfuncs");
#pragma CODE_SECTION(Modbus_Interrupt_Init, "ramfuncs");
 
#endif
// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function: Modbus_GPIO_Init
//		- Initialize SCI-B GPIO(Rx-23, Tx-09, RTS-11) for Modbus.
// ---------------------------------------------------------------------- //
void Modbus_GPIO_Init (void)
{
	EALLOW;

	// --- Modbus RTS --- //
	GpioCtrlRegs.GPAMUX1.bit.GPIO11 = 0;		
	GpioCtrlRegs.GPADIR.bit.GPIO11 = 1;		
	GpioDataRegs.GPADAT.bit.GPIO11 = 0;		// 0:Rx Enable, 1:Tx Enable
   	

	// --- SCI-B RXD and TXD --- //
	
	/* Enable internal pull-up for the selected pins */
	// Pull-ups can be enabled or disabled disabled by the user.  
	// This will enable the pullups for the specified pins.

	GpioCtrlRegs.GPAPUD.bit.GPIO9 = 0;     // Enable pull-up for GPIO9  (SCITXDB)
	GpioCtrlRegs.GPAPUD.bit.GPIO23 = 0;    // Enable pull-up for GPIO23 (SCIRXDB)

	/* Set qualification for selected pins to asynch only */
	// This will select asynch (no qualification) for the selected pins.

	GpioCtrlRegs.GPAQSEL2.bit.GPIO23 = 3;  // Asynch input GPIO23 (SCIRXDB)

	/* Configure SCI-B pins using GPIO regs*/
	// This specifies which of the possible GPIO pins will be SCI functional pins.

	GpioCtrlRegs.GPAMUX1.bit.GPIO9 = 2;    // Configure GPIO9 for SCITXDB operation
	GpioCtrlRegs.GPAMUX2.bit.GPIO23 = 3;   // Configure GPIO23 for SCIRXDB operation	
	
	EDIS;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Modbus_Reg_Init
//		- Initialize SCI-B registers for Modbus.
// ---------------------------------------------------------------------- //
void Modbus_Reg_Init (Uint32 baud_rate)
{
	// BRR bit 
	Uint32 BRR = 243;	// default 19200bps

	// BRR value
	Uint16 BRR_H = 0;
	Uint16 BRR_L = 243;
	
	EALLOW;
	
	// SCI-B Communication Control Register Initialization.
	ScibRegs.SCICCR.bit.SCICHAR = 7;				// 111b = 8bits char
	ScibRegs.SCICCR.bit.ADDRIDLE_MODE = 0;			// Idle-line mode Protocol.
	ScibRegs.SCICCR.bit.LOOPBKENA = DISABLE;		// No Loopback mode.
	//ScibRegs.SCICCR.bit.PARITYENA = ENABLE;		// Parity is Enable.
	ScibRegs.SCICCR.bit.PARITYENA = DISABLE;		// Parity is DISABLE.
	ScibRegs.SCICCR.bit.PARITY = 0;					// Odd Parity
	ScibRegs.SCICCR.bit.STOPBITS = 0;				// Stop bits = 1

	// SCI-B Control Register 1 Initialization.
	ScibRegs.SCICTL1.bit.RXENA = ENABLE;			// RX Enable.
	ScibRegs.SCICTL1.bit.TXENA = ENABLE; 			// TX Enable.
	ScibRegs.SCICTL1.bit.SLEEP = DISABLE;			// Sleep mode Disable.
	ScibRegs.SCICTL1.bit.TXWAKE = DISABLE;			// Tx wake-up mode Disable.
	ScibRegs.SCICTL1.bit.SWRESET = 0;				// SCI reset condition.
	ScibRegs.SCICTL1.bit.RXERRINTENA =ENABLE;		// RX Error Interrupt Enable.

	// SCI-B Control Register 2 Initialization.
	ScibRegs.SCICTL2.bit.TXINTENA = DISABLE;		// TX Ready interrupt Disable.
	ScibRegs.SCICTL2.bit.RXBKINTENA = ENABLE;		// RX Ready Interrupt Enable.

	// SCI-B Baud Select Register Initialization.
	// Baud rate = (LSPCLK=37.5Mhz)/(BRR+1)*8 
	// BRR = (LSPCLK/(Baudrate*8))-1

	BRR = (Uint32)(LSP_CLK/(baud_rate*8))-1;

	BRR_H = (Uint16)((BRR & 0xFF00)>>8);
	BRR_L = (Uint16)(BRR & 0x00FF);
	
	ScibRegs.SCIHBAUD = BRR_H;	
	ScibRegs.SCILBAUD = BRR_L;

	// SCI-B Re-Enable 
	ScibRegs.SCICTL1.bit.SWRESET = 1;

	EDIS;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Modbus_FIFO_Init
//		- Initialize SCI-B FIFO for Modbus.
// ---------------------------------------------------------------------- //
void Modbus_FIFO_Init (void)
{
	EALLOW;
		
	// SCI-B TX FIFO Intialization.
	ScibRegs.SCIFFTX.bit.SCIRST = 0;				// SCI-B FIFO Reset.
	ScibRegs.SCIFFTX.bit.TXFFIL = 0;				// Tx FIFO Interrupt Level = default. 
													// (Interrupt occurs when FIFO level is less then FIFO Status)
	ScibRegs.SCIFFTX.bit.TXFFIENA = DISABLE;		// Tx FIFO Interrupt Disable.
	ScibRegs.SCIFFTX.bit.TXFFINTCLR = 1;			// Tx FIFO Clear.
	ScibRegs.SCIFFTX.bit.TXFIFOXRESET = 1;			// Transmit FIFO Reset.
	ScibRegs.SCIFFTX.bit.SCIFFENA = 1;				// SCI-B FIFO Enable.
	ScibRegs.SCIFFTX.bit.SCIRST = 1;				// SCI-B SCI resume.

	// SCI-B RX FIFO Intialization.
	ScibRegs.SCIFFRX.bit.RXFFIL = 0x01;				// Rx FIFO interrupt Leverl = 1ea.
	ScibRegs.SCIFFRX.bit.RXFFIENA = ENABLE;			// Rx FIFO Interrupt Disable.
	ScibRegs.SCIFFRX.bit.RXFFINTCLR = 1;			// Rx FIFO Interrupt Clear.
	ScibRegs.SCIFFRX.bit.RXFIFORESET = 1;			// Rx FIFO Reset.
	ScibRegs.SCIFFRX.bit.RXFFOVRCLR = 0;			// Rx FIFO Overflow Don't Clear.
	ScibRegs.SCIFFRX.bit.RXFFOVF = 0;				// Rx FIfO Overflow Flag.

	// SCI-B FIFO Control Register Initialization.
	ScibRegs.SCIFFCT.bit.FFTXDLY = 0;				// FIFO Tx Delay = 0;
	ScibRegs.SCIFFCT.bit.CDC = DISABLE;				// Disable auto-baud alignment.
	ScibRegs.SCIFFCT.bit.ABDCLR = 0;				// ABD Don't Clear.

	EDIS;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Modbus_Init
//		- Execute Modbus intialization procedure.
// ---------------------------------------------------------------------- //
void Modbus_Init (Uint32 baud_rate)
{
	Modbus_GPIO_Init();
	Modbus_FIFO_Init();
	Modbus_Reg_Init(baud_rate);
}
// ====================================================================== //



// ====================================================================== //
//	Function: Modbus_Rx
//		- Get a character(8-bit) from SCI-B buffer.
// ---------------------------------------------------------------------- //
unsigned char Modbus_Rx (void)
{
	unsigned char data;

	data = ScibRegs.SCIRXBUF.bit.RXDT;

	return data;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Modbus_Tx_byte
//		- Send a charactor(8-bit) through SCI-B
// ---------------------------------------------------------------------- //
void Modbus_Tx_byte(unsigned char data)
{
	// Check TX FIFO Buffer
	// Wait until TX_buffer has empty space.
	while ( ScibRegs.SCIFFTX.bit.TXFFST >= 15);
	
	// Send a character message.
	ScibRegs.SCITXBUF=data;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Modbus_Tx
//		- Send all charates in Modbus Tx buffer.
// ---------------------------------------------------------------------- //
void Modbus_Tx(void)
{
	int i = 0;
	
	// Get a number of tx buffer size.
	int num_send_byte = s_Modbus_buffer.tx_buff_index;

	// RTS = High -> Tx mode Start (Rx mode end.)
	MODBUS_RTS(ON);

	// Tx all of characters in Modbus Tx buffer
	for ( i=0; i<num_send_byte; i++)
	{
		Modbus_Tx_byte(s_Modbus_buffer.tx_buffer[i]);
	}

	// RTS = Low -> Rx mode Start (Tx mode end.)
	MODBUS_RTS(OFF);	
}
// ====================================================================== //



// ====================================================================== //
//	Function: Modbus_Rx_ISR
//		- SCI-B Rx Interrupt Service routine.
// ---------------------------------------------------------------------- //
interrupt void Modbus_Rx_ISR (void)
{
	// Check RX Buffer Overflow (SCIFFRX)
	if ( ScibRegs.SCIFFRX.bit.RXFFOVF == 1 )
	{
		// Clear Rx Buffer Overflow flag.
		ScibRegs.SCIFFRX.bit.RXFFOVRCLR = 1;

		// SCI-C Reset and Initialization.
		Modbus_Init(DEFAULT_MODBUS_BAUD);
	}
	
	// Check Rx Error (SCIRXST)
	else if ( ScibRegs.SCIRXST.bit.RXERROR == 1 )
	{
		// SCI-C Reset and Initialization. (SW Reset only can clear RX Error interrupt flag.)
		Modbus_Init(DEFAULT_MODBUS_BAUD);
	}


	// Get a data from SCI-B buffer and echo the received data.
	else
	{
		// !!!!!!!!!!!!!!!! 
	}

	// Clear Rx Buffer Interrupt flag.
	ScibRegs.SCIFFRX.bit.RXFFINTCLR = 1;
	// Interrupt Ack Bit Set.
	PieCtrlRegs.PIEACK.bit.ACK9 = 1;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Modbus_Interrupt_Init
//		- Initialize SCI-B Rx ISR interrupt vector.
// ---------------------------------------------------------------------- //
void Modbus_Interrupt_Init(void)
{
	EALLOW;
	
	PieVectTable.SCIRXINTC = &Modbus_Rx_ISR;
	
	// SCI-C RX Interrupt vector setting
	PieCtrlRegs.PIEIER9.bit.INTx3 = 1;
	
	IER |= M_INT9;	// PIEIER8 Enable.
	
	EDIS;
}
// ====================================================================== //







// ====================================================================== //



// ====================================================================== //
// End of file.
// ====================================================================== //





