// ====================================================================== //
//						HIMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_Modbus485.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for Slave DSP Modbus-485 Communication
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2013-01-15:	Draft
// ====================================================================== //



// ====================================================================== //
//	Includes 
// ---------------------------------------------------------------------- //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"

#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

#include "Slave_DSP_Parameter.h"
#include "Slave_DSP_Modbus485.h"
// ====================================================================== //



// ====================================================================== //
//	Global Variables 
// ---------------------------------------------------------------------- //

// Table of CRC values for high.order byte 
const unsigned char auchCRCHi[] = {
0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01,
0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81,
0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01,
0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01,
0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01,
0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
0x40};


// Table of CRC values for low.order byte 
const unsigned char auchCRCLo[] = {
0x00, 0xC0, 0xC1, 0x01, 0xC3, 0x03, 0x02, 0xC2, 0xC6, 0x06, 0x07, 0xC7, 0x05, 0xC5, 0xC4,
0x04, 0xCC, 0x0C, 0x0D, 0xCD, 0x0F, 0xCF, 0xCE, 0x0E, 0x0A, 0xCA, 0xCB, 0x0B, 0xC9, 0x09,
0x08, 0xC8, 0xD8, 0x18, 0x19, 0xD9, 0x1B, 0xDB, 0xDA, 0x1A, 0x1E, 0xDE, 0xDF, 0x1F, 0xDD,
0x1D, 0x1C, 0xDC, 0x14, 0xD4, 0xD5, 0x15, 0xD7, 0x17, 0x16, 0xD6, 0xD2, 0x12, 0x13, 0xD3,
0x11, 0xD1, 0xD0, 0x10, 0xF0, 0x30, 0x31, 0xF1, 0x33, 0xF3, 0xF2, 0x32, 0x36, 0xF6, 0xF7,
0x37, 0xF5, 0x35, 0x34, 0xF4, 0x3C, 0xFC, 0xFD, 0x3D, 0xFF, 0x3F, 0x3E, 0xFE, 0xFA, 0x3A,
0x3B, 0xFB, 0x39, 0xF9, 0xF8, 0x38, 0x28, 0xE8, 0xE9, 0x29, 0xEB, 0x2B, 0x2A, 0xEA, 0xEE,
0x2E, 0x2F, 0xEF, 0x2D, 0xED, 0xEC, 0x2C, 0xE4, 0x24, 0x25, 0xE5, 0x27, 0xE7, 0xE6, 0x26,
0x22, 0xE2, 0xE3, 0x23, 0xE1, 0x21, 0x20, 0xE0, 0xA0, 0x60, 0x61, 0xA1, 0x63, 0xA3, 0xA2,
0x62, 0x66, 0xA6, 0xA7, 0x67, 0xA5, 0x65, 0x64, 0xA4, 0x6C, 0xAC, 0xAD, 0x6D, 0xAF, 0x6F,
0x6E, 0xAE, 0xAA, 0x6A, 0x6B, 0xAB, 0x69, 0xA9, 0xA8, 0x68, 0x78, 0xB8, 0xB9, 0x79, 0xBB,
0x7B, 0x7A, 0xBA, 0xBE, 0x7E, 0x7F, 0xBF, 0x7D, 0xBD, 0xBC, 0x7C, 0xB4, 0x74, 0x75, 0xB5,
0x77, 0xB7, 0xB6, 0x76, 0x72, 0xB2, 0xB3, 0x73, 0xB1, 0x71, 0x70, 0xB0, 0x50, 0x90, 0x91,
0x51, 0x93, 0x53, 0x52, 0x92, 0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54, 0x9C, 0x5C,
0x5D, 0x9D, 0x5F, 0x9F, 0x9E, 0x5E, 0x5A, 0x9A, 0x9B, 0x5B, 0x99, 0x59, 0x58, 0x98, 0x88,
0x48, 0x49, 0x89, 0x4B, 0x8B, 0x8A, 0x4A, 0x4E, 0x8E, 0x8F, 0x4F, 0x8D, 0x4D, 0x4C, 0x8C,
0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42, 0x43, 0x83, 0x41, 0x81, 0x80,
0x40};

// ====================================================================== //



// ====================================================================== //
//	Functions
// ---------------------------------------------------------------------- //


// ====================================================================== //
//	Function: Modbus_GPIO_Init
//		- Initialize SCI-B GPIO(Rx-23, Tx-9, RTS-11) for Modbus-485.
// ---------------------------------------------------------------------- //
void Modbus_GPIO_Init (void)
{
	EALLOW;

	// --- Modbus RTS --- //
	GpioCtrlRegs.GPAMUX1.bit.GPIO11= 0;		
	GpioCtrlRegs.GPADIR.bit.GPIO11 = 1;		
	GpioDataRegs.GPADAT.bit.GPIO11 = 0;
   	

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
void Modbus_Reg_Init (Uint32 baud_rate, Uint16 Parity_Enable, Uint16 Parity_Type, Uint16 Stop_bits)
{
	// BRR bit 
	Uint32 BRR = 121;	// default 38400bps

	// BRR value
	Uint16 BRR_H = 0;
	Uint16 BRR_L = 121;
	
	EALLOW;
	
	// SCI-B Communication Control Register Initialization.
	ScibRegs.SCICCR.bit.SCICHAR = 7;				// 111b = 8bits char
	ScibRegs.SCICCR.bit.ADDRIDLE_MODE = 0;			// Idle-line mode Protocol.
	ScibRegs.SCICCR.bit.LOOPBKENA = DISABLE;		// No Loopback mode.
	ScibRegs.SCICCR.bit.PARITYENA = Parity_Enable;	// Parity is Enable/Disable
	ScibRegs.SCICCR.bit.PARITY = Parity_Type;		// 0=Odd Parity, 1=Even Parity
	ScibRegs.SCICCR.bit.STOPBITS = Stop_bits;		// 0=Onw Stop bit, 1=Two Stop bits

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
	ScibRegs.SCIFFTX.bit.SCIFFENA = 0;				// SCI-B FIFO Enable.
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
//	Function: Modbus_Structure_Init
//		- Initializa Modbus data structure.
// ---------------------------------------------------------------------- //
void Modbus_Structure_Init (Uint8 Address, Uint32 Baudrate)
{
	Uint16 i = 0;

	// Buffer Index Initialization
	s_Modbus_buffer.rx_buff_index = 0;
	s_Modbus_buffer.tx_buff_index = 0;

	// Buffer initialization
	for (i=0; i<MODBUS_RX_BUFF_SIZE; i++)
	{
		s_Modbus_buffer.rx_buffer[i] = 0;
	}

	for (i=0; i<MODBUS_TX_BUFF_SIZE; i++)
	{
		s_Modbus_buffer.tx_buffer[i] = 0;
	}

	// Initialaztion Last Time tick of Rx ISR
	s_Modbus_buffer.Interval_Time_Tick = 0;

	// Modbus Rx Interval Time Limit Initialization
	// 1sec = 10^6 usec
	// Tx time of 1bit = 10^6 / Baudrate (usec)
	// Rx Interval Limit time (Modbus Standard) = Time of 3.5 packet.
	// Timer0 ISR Time Tick = 100us
	// Round up = +1
	s_Modbus_buffer.Rx_Time_Limit = (Uint16)(((1000000/Baudrate)*35/100)+1);	// 100us

	// Rx Buffer Start of Frame flag
	s_Modbus_buffer.Rx_SOF_flag = ON;
	
	// Rx Buffer End of Frame flag 
	s_Modbus_buffer.Rx_EOF_flag = OFF;

	// Rx Buffer Overflow flag is clear.
	s_Modbus_buffer.Rx_Buffer_Overflow = OFF;

	// Get Thermo-Module Self Address ID
	s_Modbus_buffer.Salve_Self_Addr = Address;

	// Tx Start Flag Clear
	s_Modbus_buffer.Tx_Start_flag = OFF;

	// Set Modbus Baudrate
	s_Modbus_buffer.Baudrate = Baudrate;
}
// ====================================================================== //


// ====================================================================== //
//	Function: Modbus_Init
//		- Execute Modbus intialization procedure.
// ---------------------------------------------------------------------- //
void Modbus_Init (void)
{
	Uint32 Baudrate = DEFAULT_MODBUS_BAUD;
	Uint16 Parity_Enable = PARITY_DISABLE;
	Uint16 Parity_Type = ODD_PARITY;
	Uint16 Stop_bits = 1;

	Uint8 Address = DEFAULT_MODBUS_ADDR;	

	// Set SCI-B GPIO Registers
	Modbus_GPIO_Init();

	// Set SCI-B FIFO Registers
	Modbus_FIFO_Init();

	// Set SCI-B Registers
	Modbus_Reg_Init(Baudrate, Parity_Enable, Parity_Type, Stop_bits);

	// Initialize Modbus buffer and variables.
	Modbus_Structure_Init(Address, Baudrate);
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
	// Check TX FIFO Buffer has empty space.
	while (ScibRegs.SCICTL2.bit.TXRDY == 0);

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
	Uint32 RTS_Delay = 0;

	// Get a number of tx buffer size.
	int num_send_byte = s_Modbus_buffer.tx_buff_index;

	
	if (s_Modbus_buffer.Tx_Start_flag == ON)
	{
		// Assign TX RTS Delay (us)
		RTS_Delay = (1000000/s_Modbus_buffer.Baudrate)*RTS_DELAY_BITS;

		// RTS = High -> Tx mode Start (Rx mode end.)
		MODBUS_RTS(ON);
		
		DELAY_US(30);

		// Tx all of characters in Modbus Tx buffer
		for ( i=0; i<num_send_byte; i++)
		{
			Modbus_Tx_byte(s_Modbus_buffer.tx_buffer[i]);
		}

		// Check the TX Ready to send data.
		while (ScibRegs.SCICTL2.bit.TXRDY == 0);

		// Wait for finishing trasfer data.
		DELAY_US(RTS_Delay);

		// RTS = Low -> Rx mode Start (Tx mode end.)
		MODBUS_RTS(OFF);

		s_Modbus_buffer.Tx_Start_flag = OFF;
	}
}
// ====================================================================== //


// ====================================================================== //
//	Function: Modbus_Rx_ISR
//		- SCI-B Rx Interrupt Service routine.
// ---------------------------------------------------------------------- //
interrupt void Modbus_Rx_ISR (void)
{
	unsigned char Rx_data = 0;
	
	// Check RX Buffer Overflow (SCIFFRX)
	if ( ScibRegs.SCIFFRX.bit.RXFFOVF == 1 )
	{
		// Clear Rx Buffer Overflow flag.
		ScibRegs.SCIFFRX.bit.RXFFOVRCLR = 1;

		// SCI-B Reset and Initialization.
		Modbus_Init();
	}
	
	// Check Rx Error (SCIRXST)
	else if ( ScibRegs.SCIRXST.bit.RXERROR == 1 )
	{
		// SCI-B Reset and Initialization. (SW Reset only can clear RX Error interrupt flag.)
		Modbus_Init();
	}

	// Get a data from SCI-B buffer and echo the received data.
	else
	{			
		// Step 1. Reset the interval of Rx interval time tick
		s_Modbus_buffer.Interval_Time_Tick = 0;
		
		// Step 2. Check the Rx data is the first data of new packet.
		if (s_Modbus_buffer.Rx_SOF_flag == ON)
		{
			// Set Rx Buffer Index = 0
			s_Modbus_buffer.rx_buff_index = 0;

			// It is NEW packet, so buffer overflow flag should be clear.
			s_Modbus_buffer.Rx_Buffer_Overflow = OFF;

			// Clear Start of Frame Flag.
			s_Modbus_buffer.Rx_SOF_flag = OFF;

			// Clear End of Frame Flag.
			s_Modbus_buffer.Rx_EOF_flag = OFF;
		}
		
		// Step 3. Save the received data in Modbus Rx buffer.
		Rx_data = Modbus_Rx();

		// Check the Status of Rx buffer is overflow.
		if (s_Modbus_buffer.Rx_Buffer_Overflow == OFF)
		{
			s_Modbus_buffer.rx_buffer[s_Modbus_buffer.rx_buff_index] = Rx_data;

			// Increase Rx buffer index
			s_Modbus_buffer.rx_buff_index++;
		}

		// Check the Rx buffer Overflow.
		if (s_Modbus_buffer.rx_buff_index >= MODBUS_RX_BUFF_SIZE)
		{
			s_Modbus_buffer.rx_buff_index = 0;
			s_Modbus_buffer.Rx_Buffer_Overflow = ON;
		}
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
	
	PieVectTable.SCIRXINTB = &Modbus_Rx_ISR;
	
	// SCI-B RX Interrupt vector setting
	PieCtrlRegs.PIEIER9.bit.INTx3 = 1;
	
	IER |= M_INT9;	// PIEIER8 Enable.
	
	EDIS;
}
// ====================================================================== //


// ====================================================================== //
//	Function: Modbus_Rx_Process
//		- Process received buffer
// ---------------------------------------------------------------------- //
void Modbus_Rx_Process (void)
{
	Uint16 Received_CRC = 0;
	Uint16 Calulated_CRC = 0;
	Uint16 temp_CRC = 0;
// test code 
/*	int i=0;
	if (s_Modbus_buffer.rx_buff_index > 0)
		{
			// ----- Process the Rx data (Modbus-485) ----- //
			// Clear Tx Buffer Index
			//s_Modbus_buffer.tx_buff_index = 0;
			s_Modbus_buffer.tx_buff_index  =s_Modbus_buffer.rx_buff_index;
			for (i=0;i<s_Modbus_buffer.tx_buff_index;i++)
			{
				s_Modbus_buffer.tx_buffer[i]=s_Modbus_buffer.rx_buffer[i];
			}
			s_Modbus_buffer.Tx_Start_flag=1;

		}*/
	// Check the Rx frame is completed.
	if (s_Modbus_buffer.Rx_EOF_flag == ON)
	{
		// Check the Rx buffer has valid data
		if (s_Modbus_buffer.rx_buff_index > 0)
		{ 
/*			s_Modbus_buffer.tx_buff_index  =s_Modbus_buffer.rx_buff_index;
			for (i=0;i<s_Modbus_buffer.tx_buff_index;i++)
			{
				s_Modbus_buffer.tx_buffer[i]=s_Modbus_buffer.rx_buffer[i];
			}
			s_Modbus_buffer.Tx_Start_flag=1;
*/
			// ----- Process the Rx data (Modbus-485) ----- //
			// Clear Tx Buffer Index
			//s_Modbus_buffer.tx_buff_index = 0;
// test code 
	/*		s_Modbus_buffer.tx_buff_index  =s_Modbus_buffer.rx_buff_index;
			for (i=0;i<s_Modbus_buffer.tx_buff_index;i++)
			{
				s_Modbus_buffer.tx_buffer[i]=s_Modbus_buffer.rx_buffer[i];
			}
			s_Modbus_buffer.Tx_Start_flag=1;
*/
			
			// Check Slave Self Address
			if (s_Modbus_buffer.rx_buffer[0] == s_Modbus_buffer.Salve_Self_Addr)
			{
				// ----- Read Holding Register (Function 0x03) ----- //
				
				// Check Function Code 
				if (s_Modbus_buffer.rx_buffer[1] == 0x03)
				{
					// Check the Rx Data length
					if (s_Modbus_buffer.rx_buff_index == 8)
					{
						// Check CRC
						Received_CRC = ((Uint16)s_Modbus_buffer.rx_buffer[6] << 8) \
										| ((Uint16)s_Modbus_buffer.rx_buffer[7]);
						Calulated_CRC = Check_Rx_CRC(6);


						// Only CRC Test is passed, peocess the Rx data packet.
						if (Received_CRC == Calulated_CRC)
						{
							Read_Holding_Register();
						}
					}
					else 
					{
						// Wrong data length Do nothing.
					}
				}
				else if (s_Modbus_buffer.rx_buffer[1] == 0x06)
				{
					// ----- Preset Single Register (Function 0x06) ----- //

					// Check the Rx Data length
					if (s_Modbus_buffer.rx_buff_index == 8)
					{
						// Check CRC
						Received_CRC = ((Uint16)s_Modbus_buffer.rx_buffer[6] << 8) \
										| ((Uint16)s_Modbus_buffer.rx_buffer[7]);
						Calulated_CRC = Check_Rx_CRC(6);
						// Only CRC Test is passed, peocess the Rx data packet.
						if (Received_CRC == Calulated_CRC)
						{
							Preset_Single_Register();
						}
					}
				}
				else if (s_Modbus_buffer.rx_buffer[1] == 0x10)
				{
					// ----- Preset Multiple Register (0x10) -----
					// Check CRC
					Received_CRC = ((Uint16)s_Modbus_buffer.rx_buffer[s_Modbus_buffer.rx_buff_index-2] << 8) \
									| ((Uint16)s_Modbus_buffer.rx_buffer[s_Modbus_buffer.rx_buff_index-1]);
					Calulated_CRC = Check_Rx_CRC(s_Modbus_buffer.rx_buff_index-2);

					if (Received_CRC == Calulated_CRC)
					{
						Preset_Multiple_Register();
					}
				}
				else
				{
					// ----- Make Modbus Exception Packet (Illegal Data Address Code:02) -----
					// Slave Address
					s_Modbus_buffer.tx_buffer[0] = s_Modbus_buffer.Salve_Self_Addr;

					// Function Code (Exception Response)
					s_Modbus_buffer.tx_buffer[1] = 0x81;

					// Error Code
					s_Modbus_buffer.tx_buffer[2] = 0x01;

					// CRC
					temp_CRC = Make_Tx_CRC(3);

					s_Modbus_buffer.tx_buffer[3] = (Uint8)(temp_CRC >> 8);
					s_Modbus_buffer.tx_buffer[4] = (Uint8)(temp_CRC & 0xFF);


					// Assign Tx Index
					s_Modbus_buffer.tx_buff_index = 5;

					
					// Tx Packet Flag ON.
					s_Modbus_buffer.Tx_Start_flag = ON;	
				}	
			}
			// --------------------------------------------- //
		}
		else
		{
			// Data Packet has wrong address, ignore data packet.
		}
		
		// After finishing process the Rx data, Change the flags
		s_Modbus_buffer.Rx_SOF_flag = ON;
		s_Modbus_buffer.Rx_EOF_flag = OFF;
		s_Modbus_buffer.rx_buff_index =0;
	}
}
// ====================================================================== //


// ====================================================================== //
//	Function: Read_Holding_Register
//		- Process Modbus-485 Function Read Holding Register(0x03)
// ---------------------------------------------------------------------- //
void Read_Holding_Register (void)
{
	Uint16 i = 0;
	Uint16 Starting_addr = 0;
	Uint16 Num_Data = 0;
	Uint16 temp_data = 0;
	Uint16 temp_CRC = 0;

	// Get Starting Address
	Starting_addr = ((Uint16)(s_Modbus_buffer.rx_buffer[2] << 8)) | ((Uint16)(s_Modbus_buffer.rx_buffer[3]));

	// Get Number of Register to read.
	Num_Data = ((Uint16)(s_Modbus_buffer.rx_buffer[4] << 8)) | ((Uint16)(s_Modbus_buffer.rx_buffer[5]));

	// Check the address is valid value.
	if (Starting_addr+Num_Data < MODBUS_REGISTER_SIZE)
	{
		// ----- Make Modbus Response Packet (0x03)-----

		// Slave Address
		s_Modbus_buffer.tx_buffer[0] = s_Modbus_buffer.Salve_Self_Addr;

		// Function Code
		s_Modbus_buffer.tx_buffer[1] = 0x03;

		// Byte Count
		s_Modbus_buffer.tx_buffer[2] = (Uint8)(Num_Data*2);


		// Data
		for(i=0; i<Num_Data; i++)
		{
			temp_data = s_Modbus_buffer.Register[Starting_addr+i];

			s_Modbus_buffer.tx_buffer[3+(i*2)] = (Uint8)(temp_data >> 8);
			s_Modbus_buffer.tx_buffer[3+(i*2)+1] = (Uint8)(temp_data & 0xFF);
			
		}

		// CRC
		temp_CRC = Make_Tx_CRC(3 + (Num_Data*2));

		s_Modbus_buffer.tx_buffer[3 + (Num_Data*2) ] = (Uint8)(temp_CRC >> 8);
		s_Modbus_buffer.tx_buffer[3 + (Num_Data*2) + 1] = (Uint8)(temp_CRC & 0xFF);


		// Assign Tx Index
		s_Modbus_buffer.tx_buff_index = (3 + (Num_Data*2) + 2);

		
		// Tx Packet Flag ON.
		s_Modbus_buffer.Tx_Start_flag = ON;
	}
	else 
	{
		// Address is NOT valid value, Do NOTHING.
	}
}
// ====================================================================== //



// ====================================================================== //
//	Function: Read_Holding_Register
//		- Process Modbus-485 Function Preset Single Register(0x06)
// ---------------------------------------------------------------------- //
void Preset_Single_Register (void)
{
	Uint16 Register_addr = 0;
	Uint16 Preset_Data = 0;
	Uint16 temp_CRC = 0;

	// Get Target Address
	Register_addr = ((Uint16)(s_Modbus_buffer.rx_buffer[2] << 8)) | ((Uint16)(s_Modbus_buffer.rx_buffer[3]));

	// Get data of Register to write.
	Preset_Data = ((Uint16)(s_Modbus_buffer.rx_buffer[4] << 8)) | ((Uint16)(s_Modbus_buffer.rx_buffer[5]));

	// Check the address is valid value.
	if (Register_addr < MODBUS_REGISTER_SIZE)
	{
		// Preset Single Register
		s_Modbus_buffer.Register[Register_addr] = Preset_Data;

						
		// ----- Make Modbus Response Packet (0x06) -----
		// Slave Address
		s_Modbus_buffer.tx_buffer[0] = s_Modbus_buffer.Salve_Self_Addr;

		// Function Code
		s_Modbus_buffer.tx_buffer[1] = 0x06;

		// Register Address
		s_Modbus_buffer.tx_buffer[2] = (Uint8)(Register_addr >> 8);
		s_Modbus_buffer.tx_buffer[3] = (Uint8)(Register_addr & 0xFF);

		// Preset Data
		s_Modbus_buffer.tx_buffer[4] = (Uint8)(Preset_Data >> 8);
		s_Modbus_buffer.tx_buffer[5] = (Uint8)(Preset_Data & 0xFF);
		
		// CRC
		temp_CRC = Make_Tx_CRC(6);

		s_Modbus_buffer.tx_buffer[6] = (Uint8)(temp_CRC >> 8);
		s_Modbus_buffer.tx_buffer[7] = (Uint8)(temp_CRC & 0xFF);


		// Assign Tx Index
		s_Modbus_buffer.tx_buff_index = 8;

		
		// Tx Packet Flag ON.
		s_Modbus_buffer.Tx_Start_flag = ON;
	}
	else 
	{
		// ----- Make Modbus Exception Packet (Illegal Data Address Code:02) -----
		// Slave Address
		s_Modbus_buffer.tx_buffer[0] = s_Modbus_buffer.Salve_Self_Addr;

		// Function Code (Exception Response)
		s_Modbus_buffer.tx_buffer[1] = 0x81;

		// Error Code
		s_Modbus_buffer.tx_buffer[2] = 0x02;

		// CRC
		temp_CRC = Make_Tx_CRC(3);

		s_Modbus_buffer.tx_buffer[3] = (Uint8)(temp_CRC >> 8);
		s_Modbus_buffer.tx_buffer[4] = (Uint8)(temp_CRC & 0xFF);


		// Assign Tx Index
		s_Modbus_buffer.tx_buff_index = 5;

		
		// Tx Packet Flag ON.
		s_Modbus_buffer.Tx_Start_flag = ON;
	}
}
// ====================================================================== //




// ====================================================================== //
//	Function: Read_Holding_Register
//		- Process Modbus-485 Function Preset Single Register(0x10)
// ---------------------------------------------------------------------- //
void Preset_Multiple_Register (void)
{
	Uint16 i = 0;
	
	Uint16 Starting_addr = 0;
	Uint16 No_Registers = 0;
	Uint16 Byte_Count = 0;
	Uint16 Data[128];
	Uint16 temp_CRC = 0;

	// Get Starting Address
	Starting_addr = ((Uint16)(s_Modbus_buffer.rx_buffer[2] << 8)) | ((Uint16)(s_Modbus_buffer.rx_buffer[3]));

	// Get Number of Register to Write.
	No_Registers = ((Uint16)(s_Modbus_buffer.rx_buffer[4] << 8)) | ((Uint16)(s_Modbus_buffer.rx_buffer[5]));

	// Get Byte count to write.
	Byte_Count = (Uint16)(s_Modbus_buffer.rx_buffer[6]);

	
	// Check the address is valid value.
	if ( (Starting_addr+No_Registers) < MODBUS_REGISTER_SIZE )
	{
		// Check the No. Registers is valid value.
		if ((Byte_Count == No_Registers*2) && (No_Registers <= 127))
		{
			// Preset Single Register
			for(i=0; i<No_Registers; i++)
			{
				Data[i] = ((Uint16)(s_Modbus_buffer.rx_buffer[7+(i*2)] << 8)) | ((Uint16)(s_Modbus_buffer.rx_buffer[8+(i*2)]));
				s_Modbus_buffer.Register[Starting_addr+i] = Data[i];
			}
					
			// ----- Make Modbus Response Packet (0x06) -----
			// Slave Address
			s_Modbus_buffer.tx_buffer[0] = s_Modbus_buffer.Salve_Self_Addr;

			// Function Code
			s_Modbus_buffer.tx_buffer[1] = 0x10;

			// Starting Address
			s_Modbus_buffer.tx_buffer[2] = (Uint8)(Starting_addr >> 8);
			s_Modbus_buffer.tx_buffer[3] = (Uint8)(Starting_addr & 0xFF);

			// Number of Registers
			s_Modbus_buffer.tx_buffer[4] = (Uint8)(No_Registers >> 8);
			s_Modbus_buffer.tx_buffer[5] = (Uint8)(No_Registers & 0xFF);
			
			// CRC
			temp_CRC = Make_Tx_CRC(6);

			s_Modbus_buffer.tx_buffer[6] = (Uint8)(temp_CRC >> 8);
			s_Modbus_buffer.tx_buffer[7] = (Uint8)(temp_CRC & 0xFF);


			// Assign Tx Index
			s_Modbus_buffer.tx_buff_index = 8;

			
			// Tx Packet Flag ON.
			s_Modbus_buffer.Tx_Start_flag = ON;
		}
		else
		{
			// ----- Make Modbus Exception Packet (Illegal Data Address Code:02) -----
			// Slave Address
			s_Modbus_buffer.tx_buffer[0] = s_Modbus_buffer.Salve_Self_Addr;

			// Function Code (Exception Response)
			s_Modbus_buffer.tx_buffer[1] = 0x81;

			// Error Code
			s_Modbus_buffer.tx_buffer[2] = 0x02;

			// CRC
			temp_CRC = Make_Tx_CRC(3);

			s_Modbus_buffer.tx_buffer[3] = (Uint8)(temp_CRC >> 8);
			s_Modbus_buffer.tx_buffer[4] = (Uint8)(temp_CRC & 0xFF);


			// Assign Tx Index
			s_Modbus_buffer.tx_buff_index = 5;

			
			// Tx Packet Flag ON.
			s_Modbus_buffer.Tx_Start_flag = ON;			
		}
	}
	else 
	{
		// Address is NOT valid value.
		// ----- Make Modbus Exception Packet (Illegal Data Address Code:02) -----
		// Slave Address
		s_Modbus_buffer.tx_buffer[0] = s_Modbus_buffer.Salve_Self_Addr;

		// Function Code (Exception Response)
		s_Modbus_buffer.tx_buffer[1] = 0x81;

		// Error Code
		s_Modbus_buffer.tx_buffer[2] = 0x02;

		// CRC
		temp_CRC = Make_Tx_CRC(3);

		s_Modbus_buffer.tx_buffer[3] = (Uint8)(temp_CRC >> 8);
		s_Modbus_buffer.tx_buffer[4] = (Uint8)(temp_CRC & 0xFF);


		// Assign Tx Index
		s_Modbus_buffer.tx_buff_index = 5;

		
		// Tx Packet Flag ON.
		s_Modbus_buffer.Tx_Start_flag = ON;	
	}
}
// ====================================================================== //



// ====================================================================== //
//	Function: Check_Rx_CRC
//		- CRC Check 
// ---------------------------------------------------------------------- //
Uint16 Check_Rx_CRC (Uint16 Data_Length)
{
	unsigned char uchCRCHi = 0xFF;
	unsigned char uchCRCLo = 0xFF;
	Uint16 uIndex = 0;

	int i = 0;
	
	for (i=0; i<Data_Length; i++)
	{
		uIndex = uchCRCHi ^ (s_Modbus_buffer.rx_buffer[i] & 0xff);
		uchCRCHi = uchCRCLo ^ auchCRCHi[uIndex];
		uchCRCLo = auchCRCLo[uIndex];
	}
	
	return (Uint16)(((Uint16)(uchCRCHi)) << 8 | uchCRCLo);
}
// ====================================================================== //


// ====================================================================== //
//	Function: Make_Tx_CRC
//		- CRC Check 
// ---------------------------------------------------------------------- //
Uint16 Make_Tx_CRC (Uint16 Data_Length)
{
	unsigned char uchCRCHi = 0xFF;
	unsigned char uchCRCLo = 0xFF;
	Uint16 uIndex = 0;

	int i = 0;
	
	for (i=0; i<Data_Length; i++)
	{
		uIndex = uchCRCHi ^ (s_Modbus_buffer.tx_buffer[i] & 0xff);
		uchCRCHi = uchCRCLo ^ auchCRCHi[uIndex];
		uchCRCLo = auchCRCLo[uIndex];
	}
	
	return (Uint16)(((Uint16)(uchCRCHi)) << 8 | uchCRCLo);
}
// ====================================================================== //


// ====================================================================== //



// ====================================================================== //
// End of file.
// ====================================================================== //


