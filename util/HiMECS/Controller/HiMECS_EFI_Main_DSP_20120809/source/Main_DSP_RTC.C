// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_RTC.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for RTC(FM31L278) using I2C.		
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
#include "Main_DSP_RTC.h"


// ====================================================================== //
//	Functions
// ====================================================================== //

void FM31L278_WriteRTC(Uint16 slave_addr, Uint16 addr, Uint16 data)
{
	addr = addr & 0x1f;
	while(I2caRegs.I2CMDR.bit.STP == 1);
	
	// Wait until bus-free status
	while(I2caRegs.I2CSTR.bit.BB == 1);
	
	// Set Device(Slave) Address
	I2caRegs.I2CSAR = slave_addr;
	
	// Setup number of byters to send
	I2caRegs.I2CCNT = 2;

	// Setup data to send
	I2caRegs.I2CDXR = addr; 						// Data Address
	I2caRegs.I2CDXR = data;							// Write Data
	
	// Send start as master transmitter with STT(=1), STP(=1), XA(=0), RM(=0) 
	I2caRegs.I2CMDR.all = 0x6E20;
	
	// Wait until STOP condition is detected and clear STOP condition bit
	while(I2caRegs.I2CSTR.bit.SCD == 0);
	I2caRegs.I2CSTR.bit.SCD = 1;
}



void FM31L278_ReadRTC(Uint16 slave_addr, Uint16 addr, unsigned char* pData)
{	
	slave_addr = 0x0068;
	addr = addr & 0x1f;
	 
	// Wait until the STP bit is cleared from any previous master communication.
	while(I2caRegs.I2CMDR.bit.STP == 1);
	
	// Wait until bus-free status
	while(I2caRegs.I2CSTR.bit.BB == 1);
	
	// Set Device(Slave) Address
	I2caRegs.I2CSAR = slave_addr;
	
	// Setup number of bytes to send
	I2caRegs.I2CCNT = 1;

	I2caRegs.I2CDXR = addr; 		// Data Address (one byte)
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
	*(pData) = (unsigned char)(I2caRegs.I2CDRR & 0xff);  
}



void FM31L278_ReadRTCs(Uint16 slave_addr, Uint16 addr, Uint16 nbyte, unsigned char* pData)
{
	Uint16 i;
	addr = addr & 0x1f;
	 
	// Wait until the STP bit is cleared from any previous master communication.
	while(I2caRegs.I2CMDR.bit.STP == 1);
	
	// Wait until bus-free status
	while(I2caRegs.I2CSTR.bit.BB == 1);
	
	// Set Device(Slave) Address
	I2caRegs.I2CSAR = slave_addr;
	
	// Setup number of bytes to send
	I2caRegs.I2CCNT = 1;

	I2caRegs.I2CDXR = addr; 		// Data Address LSB
	
	// Send start as master transmitter with STT(=1), STP(=0), XA(=0), RM(=0) 
	I2caRegs.I2CMDR.all = 0x2620;
	
	// Wait until ARDY status bit is set
	while(I2caRegs.I2CSTR.bit.ARDY == 0);
	
	// Wait until the STP bit is cleared
	while(I2caRegs.I2CMDR.bit.STP == 1);
	
	// Set Device(Slave) Address
	I2caRegs.I2CSAR = slave_addr;

	// Setup number of bytes to read
	I2caRegs.I2CCNT = nbyte;
	
	// Send start as master receiver with STT(=1), STP(=1), XA(=0), RM(=0) 
	I2caRegs.I2CMDR.all = 0x2C20;
	
	// Wait until STOP condition is detected and clear STOP condition bit
	while(I2caRegs.I2CSTR.bit.SCD == 0);

	I2caRegs.I2CSTR.bit.SCD = 1;

	for(i=0; i<nbyte; i++) 
	{
		*(pData+i) = (unsigned char)(I2caRegs.I2CDRR & 0xff);  
		DELAY_US(1000);
	}
}



void FM31L278_ModeRTC(Uint16 mode)
{
	static unsigned char tmp_int = 0x40;

	FM31L278_ReadRTC(0x0068,0,&tmp_int);

	switch (mode) {
		case FM31L278_MODE_NORMAL:
			tmp_int &= ~(FM31L278_RTC_CONTROL_BIT_WRITE | FM31L278_RTC_CONTROL_BIT_READ);
			break;
		case FM31L278_MODE_WRITE:
			tmp_int |= FM31L278_RTC_CONTROL_BIT_WRITE;
			break;
		case FM31L278_MODE_READ:
			tmp_int |= FM31L278_RTC_CONTROL_BIT_READ;
			break;
		default:
			break;
	}
	FM31L278_WriteRTC(0x0068,0,tmp_int);

}



void FM31L278_ReadByte(Uint16 addr, unsigned char* pData)
{
	Read_I2C_Data(0x0050,addr, pData);
}



void FM31L278_WriteByte(Uint16 addr, unsigned char *pdata)
{
	Write_I2C_Data(0x0050,addr,*pdata);
}



void Read_RTC(void)
{
	unsigned char buffer[7];

	FM31L278_ModeRTC(2);
	FM31L278_ReadRTCs(0x0068,0x2,7,buffer);
	FM31L278_ModeRTC(0);

	s_RTC.sec = BCDTOBIN(buffer[0]);
	s_RTC.min = BCDTOBIN(buffer[1]);
	s_RTC.hour = BCDTOBIN(buffer[2]);
	s_RTC.week_day = BCDTOBIN(buffer[3]);
	s_RTC.day = BCDTOBIN(buffer[4]);
	s_RTC.month = BCDTOBIN(buffer[5]);
	s_RTC.year = BCDTOBIN(buffer[6]);
}


void Write_RTC (void)
{
	FM31L278_ModeRTC(1);
	FM31L278_WriteRTC(0x0068,0x02,(Uint16)BINTOBCD(s_RTC.sec));
	FM31L278_WriteRTC(0x0068,0x03,(Uint16)BINTOBCD(s_RTC.min));
	FM31L278_WriteRTC(0x0068,0x04,(Uint16)BINTOBCD(s_RTC.hour));
	FM31L278_WriteRTC(0x0068,0x05,(Uint16)BINTOBCD(s_RTC.week_day));
	FM31L278_WriteRTC(0x0068,0x06,(Uint16)BINTOBCD(s_RTC.day));
	FM31L278_WriteRTC(0x0068,0x07,(Uint16)BINTOBCD(s_RTC.month));
	FM31L278_WriteRTC(0x0068,0x08,(Uint16)BINTOBCD(s_RTC.year));
	FM31L278_ModeRTC(0);
}


void RTC_Init (void)
{
	// RTC Clock Enable
	FM31L278_ModeRTC(1);
	FM31L278_WriteRTC(0x0068,0x1,0x00);
	FM31L278_ModeRTC(0);
}

// ====================================================================== //




// ====================================================================== //
// End of file.
// ====================================================================== //











