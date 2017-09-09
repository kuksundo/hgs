// ====================================================================== //
//				HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_Thermocouple.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for Thermo Couple sensor using AD7793.
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2012-07-02:	Draft
// ====================================================================== //



// ====================================================================== //
//	Includes
// ====================================================================== //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"

#include "Slave_DSP_Parameter.h"
#include "Slave_DSP_External_Interface.h"
#include "Slave_DSP_AD7793.h"
// ====================================================================== //



// ====================================================================== //
//	Global Variables
// ====================================================================== //

// ====================================================================== //



// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function:	AD7793_Tx_Data
//		- Tx Data to AD7793 using SPI
// ---------------------------------------------------------------------- //
Uint16 AD7793_Tx_Data (Uint16 data)
{
	Uint16 temp = 0;
	Uint16 Wait_count = 0;

	// Tx Data
	SpiaRegs.SPITXBUF = data<<8;

	// Wait util get dummy data from AD7793.
	while (SpiaRegs.SPIFFRX.bit.RXFFST == 0)
	{
		if (Wait_count > 1000)
		{
			// Waiting time is too long.
			break;
		}
		Wait_count++;		
	}
		
	// Get a dummy data from AD7793.
	while (SpiaRegs.SPIFFRX.bit.RXFFST != 0)
	{
		temp = SpiaRegs.SPIRXBUF;
	}	

	return temp;
}
// ====================================================================== //



// ====================================================================== //
//	Function:	AD7793_Rx_Data
//		- Rx Data from AD7793 using SPI
// ---------------------------------------------------------------------- //
Uint16 AD7793_Rx_Data (void)
{
	Uint16 temp = 0;
	Uint16 Wait_count = 0;

	// Tx dummy Data
	SpiaRegs.SPITXBUF = 0x00;

	// Wait util get Rx data from AD7793.
	while (SpiaRegs.SPIFFRX.bit.RXFFST == 0)
	{
		if (Wait_count > 1000)
		{
			// Waiting time is too long.
			break;
		}
		Wait_count++;		
	}
		
	// Get Rx data from AD7793.
	while (SpiaRegs.SPIFFRX.bit.RXFFST != 0)
	{
		temp = SpiaRegs.SPIRXBUF;
	}	

	return temp;
}
// ====================================================================== //



// ====================================================================== //
//	Function:	AD7793_Write_Reg
//		- Write data to AD7793 register
//		- ex: 	RTD_reg = Register Address, Data = Write Data value
// ---------------------------------------------------------------------- //
void AD7793_Write_Reg (Uint8 Reg_Addr, Uint32 data)
{
	int i = 0;
	Uint16 Data_length = 0;		// bytes
	int fault = PASS;
	Uint32 temp = 0;

	// Check the register.
	switch (Reg_Addr)
	{
		case MODE_REG:
			Data_length = 2;	// 2byte
			break;

		case CONFIG_REG:
			Data_length = 2;	// 2byte
			break;

		case IO_REG:
			Data_length = 1;	// 1byte
			break;

		case OFFSET_REG:
			Data_length = 3;	// 3byte
			break;

		case FULL_SCALE_REG:
			Data_length = 3;	// 3byte
			break;

		default:
			// Wrong Register.
			fault = FAIL;
			break;
	}

	// Only RTD Channel and Register are valid, excute read operation.
	if (fault == FAIL)
	{
		return;
	}
	
	// Set Communication Register structure.
	s_AD7793.Comm_Reg.all = 0x0000;
	s_AD7793.Comm_Reg.bit.RnW = 0;
	s_AD7793.Comm_Reg.bit.RS = Reg_Addr;
	
	// Tx Communication Register set
	AD7793_Tx_Data(s_AD7793.Comm_Reg.all);

	// Send Write Data
	for (i=1; i<=Data_length; i++)
	{
		temp = (data >> (8*(Data_length-i))) & 0x000000FF;
		AD7793_Tx_Data((Uint16)temp);
	}	
}
// ====================================================================== //



// ====================================================================== //
//	Function:	AD7793_Read_Reg
//		- Read data in AD7793 register
//		- ex: 	RTD_reg = Register Address
//		- Return value: 32bit Data.
// ---------------------------------------------------------------------- //
Uint32 AD7793_Read_Reg (Uint8 Reg_Addr)
{
	int i = 0;
	volatile Uint32 data = 0;	// getting data.
	Uint16 Data_length = 0;		// bytes
	int fault = PASS;

	// Check the register.
	switch (Reg_Addr)
	{
		case STATUS_REG:
			Data_length = 1;	// 1byte
			break;

		case MODE_REG:
			Data_length = 2;	// 2byte
			break;

		case CONFIG_REG:
			Data_length = 2;	// 2byte
			break;

		case DATA_REG:

			#ifdef	AD7793_RESOLUTION_24BIT
			Data_length = 3;	// 3byte
			#endif

			#ifdef	AD7793_RESOLUTION_16BIT
			Data_length = 2;	// 2byte
			#endif
			
			break;

		case ID_REG:
			Data_length = 1;	// 1byte
			break;

		case IO_REG:
			Data_length = 1;	// 1byte
			break;

		case OFFSET_REG:
			Data_length = 3;	// 3byte
			break;

		case FULL_SCALE_REG:
			Data_length = 3;	// 3byte
			break;

		default:
			// Wrong Register.
			fault = FAIL;
			break;
	}


	// Only RTD Channel and Register are valid, excute read operation.
	if (fault == FAIL)
	{
		return 0xFFFFFFFF;
	}
	
	// Set Communication Register structure.
	s_AD7793.Comm_Reg.all = 0x0000;
	s_AD7793.Comm_Reg.bit.RnW = 1;
	s_AD7793.Comm_Reg.bit.RS = Reg_Addr;
	
	// Tx Communication Register set
	AD7793_Tx_Data(s_AD7793.Comm_Reg.all);

	// Get a data from AD7793
	for (i=0; i<Data_length; i++)
	{
		data = data << 8;
		data = data + (Uint32)AD7793_Rx_Data();
	}
	AD7793_Rx_Data();

	// Save the register value.
	switch (Reg_Addr)
	{
		case STATUS_REG:
			s_AD7793.Status_Reg.all = (Uint16)data;		// 1byte.
			break;

		case MODE_REG:
			s_AD7793.Mode_Reg.all = (Uint16)data;		// 2byte.
			break;

		case CONFIG_REG:
			s_AD7793.Config_Reg.all = (Uint16)data;		// 2byte
			break;

		case DATA_REG:
			#ifdef	AD7793_RESOLUTION_24BIT
			s_AD7793.Data_Reg = data & 0x00FFFFFF;		// 3byte
			#endif
			
			#ifdef	AD7793_RESOLUTION_16BIT
			s_AD7793.Data_Reg = (Uint16)data;			// 2byte
			#endif
			
			break;

		case ID_REG:
			s_AD7793.ID_Reg = (Uint16)data;				// 1byte.
			break;

		case IO_REG:
			s_AD7793.IO_Reg.all = (Uint16)data;			// 1byte
			break;

		case OFFSET_REG:
			s_AD7793.Offset_Reg = data;					// 3byte
			break;

		case FULL_SCALE_REG:
			s_AD7793.Full_Scale_Reg = data;				// 3byte
			break;

		default:
			// Wrong Register.
			fault = FAIL;
			break;
	}

	// Only Register are valid, excute read operation.
	if (fault == FAIL)
	{
		return 0xFFFFFFFF;
	}
	
	return data;	
}
// ====================================================================== //




// ====================================================================== //
//	Function:	AD7793_Reset
//		- AD7793 Software Reset.
// ---------------------------------------------------------------------- //
void AD7793_Reset (void)
{
	int i = 0;
	
	AD7793_Tx_Data(0x00);
	
	for (i=0;i<10;i++)
	{
		AD7793_Tx_Data(0xFF);
		DELAY_US(1);
	}		
	
	DELAY_US(10000);
}
// ====================================================================== //



// ====================================================================== //
//	Function:	AD7793_Struct_Init
//		- Thermocouple Sturucture Initialization.
// ---------------------------------------------------------------------- //
void AD7793_Struct_Init(void)
{
	s_AD7793.Comm_Reg.all = 0;
	s_AD7793.Status_Reg.all = 0;
	s_AD7793.Mode_Reg.all = 0;
	s_AD7793.Config_Reg.all = 0;
	s_AD7793.Data_Reg = 0;
	s_AD7793.ID_Reg = 0;
	s_AD7793.IO_Reg.all = 0;
	s_AD7793.Offset_Reg = 0;
	s_AD7793.Full_Scale_Reg = 0;
}
// ====================================================================== //



// ====================================================================== //


// ====================================================================== //
// End of file.
// ====================================================================== //


