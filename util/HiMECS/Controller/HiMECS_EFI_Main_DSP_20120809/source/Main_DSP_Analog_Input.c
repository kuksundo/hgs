// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_Analog_Input.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for 32-channel 4~20mA Analog Input sensor 
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-09-29:	Draft
// ====================================================================== //




// ====================================================================== //
//	Includes
// ====================================================================== //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"
#include "Main_DSP_External_Interface.h"
#include "Main_DSP_Analog_Input.h"



// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function: ADC_CS
//		- ADC_CS Control (Refer to 'Main_DSP_External_Interface.h") 
// ---------------------------------------------------------------------- //
void ADC_CS (unsigned char ch)
{
	// Check the ADC CS chip is valid.
	if (ch<1 || ch>4)
	{
		// ADC CS chip is NOT valid, Do Nothing.
		return;
	}

	// ADC CS chip is valid.
	u_AD_DA_Ctrl.bit.AD_CS = ch-1;
	
	// ADC CS Control	
	AD_DA_CTRL = u_AD_DA_Ctrl.all;
}
// ====================================================================== //




// ====================================================================== //
//	Function: ADC_Tx_Data
//		- McBSP send 8-bit data to AD7739
// ---------------------------------------------------------------------- //
void ADC_Tx_Data(unsigned char data)
{
	Uint16 temp = 0;
	Uint16 Wait_count = 0;
	
	// Tx Data
    McbspaRegs.DXR1.all=(Uint16)data;

	// Wait util get dummy data from RTD.
	while (McbspaRegs.SPCR1.bit.RRDY == 0)
	{
		if (Wait_count > 1000)
		{
			return;
		}
		Wait_count++;		
	}
		
	// Get a dummy data from RTD.
	temp = McbspaRegs.DRR1.all;
	temp = temp & 0xFF;

	return;
}
// ====================================================================== //



// ====================================================================== //
//	Function:	ADC_Rx_Data
//		- Rx Data to RTD using SPI
// ---------------------------------------------------------------------- //
unsigned char ADC_Rx_Data (void)
{
	Uint16 temp = 0;
	Uint16 Wait_count = 0;

	// Tx Data
	McbspaRegs.DXR1.all = 0x00;

	// Wait util get Rx data from McBSP.
	while (McbspaRegs.SPCR1.bit.RRDY == 0)
	{
		if (Wait_count > 1000)
		{
			return 0xFF;
		}
		Wait_count++;		
	}
		
	// Get a Rx data from McBSP.
	temp = McbspaRegs.DRR1.all;
	temp = temp & 0xFF;

	return (unsigned char)temp;
}
// ====================================================================== //



// ====================================================================== //
//	Function:	ADC_Reset
//		- Software Reset for AD7739
// ---------------------------------------------------------------------- //
void ADC_Reset (unsigned char ch)
{
	// Select ADC Chip;
	ADC_CS(ch);

	// Software Reset Procedure.
	ADC_Tx_Data(0x00);
	DELAY_US(1);
	ADC_Tx_Data(0xFF);
	DELAY_US(1);
	ADC_Tx_Data(0xFF);
	DELAY_US(1);
	ADC_Tx_Data(0xFF);
	DELAY_US(1);
	ADC_Tx_Data(0xFF);
	DELAY_US(1);
	ADC_Tx_Data(0xFF);

	DELAY_US(5);
}
// ====================================================================== //



// ====================================================================== //
//	Function:	ADC_Reg_Write
//		- Write AD7739 Register
// ---------------------------------------------------------------------- //
void ADC_Reg_Write (unsigned char ch, unsigned char Addr, Uint32 data)
{
	Uint16 i = 0;
	Uint16 Data_Length = 0;
	Uint32 temp = 0;
	
	// Check the ADC CS chip is valid.
	if (ch<1 || ch>4)
	{
		// ADC CS chip is NOT valid, Do Nothing.
		return;
	}

	// Check the Address is valid, and Asign data length to write.
	if (Addr==IO_PORT_REG)
	{
		Data_Length = 1;		// 1-byte
	}
	else if (Addr==CHKSUM_REG)
	{
		Data_Length = 2;		// 2-bytes
	}
	else if (Addr==ADC_ZERO_CAL_REG || Addr==ADC_FULL_CAL_REG)
	{
		Data_Length = 3;		// 3-bytes
	}
	else if ( Addr>=CH_ZERO_CAL_REG_BASE && Addr<=(CH_ZERO_CAL_REG_BASE+7) )
	{
		Data_Length = 3;		// 3-bytes
	}
	else if ( Addr>=CH_FULL_CAL_REG_BASE && Addr<=(CH_FULL_CAL_REG_BASE+7) )
	{
		Data_Length = 3;		// 3-bytes
	}
	else if ( Addr>=CH_SETUP_REG_BASE && Addr<=(CH_SETUP_REG_BASE+7) )
	{
		Data_Length = 1;		// 1-bytes
	}
	else if ( Addr>=CH_CONV_REG_BASE && Addr<=(CH_CONV_REG_BASE+7) )
	{
		Data_Length = 1;		// 1-byte
	}
	else if ( Addr>=MODE_REG_BASE && Addr<=(MODE_REG_BASE+7) )
	{
		Data_Length = 1;		// 1-byte
	}
	else 
	{
		// Wrong Address, Do Nothing.
		return;
	}

	// ADC Chip Select Trigger.
	ADC_CS(ch);

	s_ADC_In.Comm_Reg.all= 0x00;
	s_ADC_In.Comm_Reg.bit.RnW = 0;
	s_ADC_In.Comm_Reg.bit.Addr = (Uint16)Addr;

	// McBSP Send Write Commnad.
	ADC_Tx_Data(s_ADC_In.Comm_Reg.all);

	// McBSP Send the write data.
	for (i=1; i<=Data_Length; i++)
	{
		temp = (data >> (8*(Data_Length-i))) & 0x000000FF;
		ADC_Tx_Data((unsigned char)temp);
	}

	return;
}
// ====================================================================== //



// ====================================================================== //
//	Function:	ADC_Reg_Read
//		- Read AD7739 Register
// ---------------------------------------------------------------------- //
Uint32 ADC_Reg_Read (unsigned char ch, unsigned char Addr)
{
	Uint16 i = 0;
	Uint16 Data_Length = 0;
	Uint32 data = 0;
	
	// Check the ADC CS chip is valid.
	if (ch<1 || ch>4)
	{
		// ADC CS chip is NOT valid, Do Nothing.
		return 0xFFFFFFFF;
	}

	// Check the Address is valid, and Asign data length to write.
	if (Addr==IO_PORT_REG || Addr==REV_REG || Addr==ADC_STATUS_REG)
	{
		Data_Length = 1;		// 1-byte
	}
	else if (Addr==CHKSUM_REG)
	{
		Data_Length = 2;		// 2-bytes
	}
	else if (Addr== TEST_REG || Addr==ADC_ZERO_CAL_REG || Addr==ADC_FULL_CAL_REG)
	{
		Data_Length = 3;		// 3-bytes
	}
	else if ( Addr>=CH_DATA_REG_BASE && Addr<=(CH_DATA_REG_BASE+7) )
	{
		Data_Length = 2;		// 2-bytes
	}
	else if ( Addr>=CH_ZERO_CAL_REG_BASE && Addr<=(CH_ZERO_CAL_REG_BASE+7) )
	{
		Data_Length = 3;		// 3-bytes
	}
	else if ( Addr>=CH_FULL_CAL_REG_BASE && Addr<=(CH_FULL_CAL_REG_BASE+7) )
	{
		Data_Length = 3;		// 3-bytes
	}
	else if ( Addr>=CH_STATUS_REG_BASE && Addr<=(CH_STATUS_REG_BASE+7) )
	{
		Data_Length = 1;		// 1-bytes
	}
	else if ( Addr>=CH_SETUP_REG_BASE && Addr<=(CH_SETUP_REG_BASE+7) )
	{
		Data_Length = 1;		// 1-bytes
	}
	else if ( Addr>=CH_CONV_REG_BASE && Addr<=(CH_CONV_REG_BASE+7) )
	{
		Data_Length = 1;		// 1-byte
	}
	else if ( Addr>=MODE_REG_BASE && Addr<=(MODE_REG_BASE+7) )
	{
		Data_Length = 1;		// 1-byte
	}
	else 
	{
		// Wrong Address, Do Nothing.
		return 0xFFFFFFFF;
	}

	// ADC Chip Select Trigger.
	ADC_CS(ch);

	s_ADC_In.Comm_Reg.all= 0x00;
	s_ADC_In.Comm_Reg.bit.RnW = 1;
	s_ADC_In.Comm_Reg.bit.Addr = (Uint16)Addr;

	// McBSP Send Write Commnad.
	ADC_Tx_Data(s_ADC_In.Comm_Reg.all);

	// McBSP Send the write data.
	// Get a data from AD7793
	for (i=0; i<Data_Length; i++)
	{
		data = data << 8;
		data = data + (Uint32)ADC_Rx_Data();
	}
	ADC_Rx_Data();

	return data;
}



// ====================================================================== //
//	Function:	ADC_In_Init
//		- Initialize AD7739 Registers
// ---------------------------------------------------------------------- //
void ADC_Init (void)
{
	unsigned char i = 0;
	unsigned char ch = 0;

	ADC_Structure_Init();

	for (i=1; i<=4; i++)
	{
		// ADC Chip Select
		ADC_CS(i);

		// ADC Reset
		ADC_Reset(i);

		// Configure ADC Channel registers.
		for (ch=0; ch<8; ch++)
		{
			// AD7739 Set Channel Conversion Time Register
			s_ADC_In.Ch_Conv_Time_Reg[ch].all = 0;
			s_ADC_In.Ch_Conv_Time_Reg[ch].bit.CHOP = 1;
			s_ADC_In.Ch_Conv_Time_Reg[ch].bit.FW = 46;
			ADC_Reg_Write(i, (CH_CONV_REG_BASE+ch), s_ADC_In.Ch_Conv_Time_Reg[ch].all);	// CHOP=1, FW=56

			// AD7739 Set Chnnel Setup Register
			s_ADC_In.Ch_Setup_Reg[ch].all = 0;
			s_ADC_In.Ch_Setup_Reg[ch].bit.BUFOFF = 0;	// Internal Buffer is enabled.
			s_ADC_In.Ch_Setup_Reg[ch].bit.COM = 0;		// AIN - AINCOM
			s_ADC_In.Ch_Setup_Reg[ch].bit.Stat_OPT = 0;	// Same value with RDY signal 
			s_ADC_In.Ch_Setup_Reg[ch].bit.Enable = 1;	// Channel Enable.
			s_ADC_In.Ch_Setup_Reg[ch].bit.RNG = 4;		// Norminal Input range = +-2.5V
			ADC_Reg_Write(i, (CH_SETUP_REG_BASE+ch), s_ADC_In.Ch_Setup_Reg[ch].all);
		}

		// Configure IO Register.
		s_ADC_In.IO_Port_Reg.all = 0x00;
		s_ADC_In.IO_Port_Reg.bit.P0= 0;
		s_ADC_In.IO_Port_Reg.bit.P1 =0;
		s_ADC_In.IO_Port_Reg.bit.P0_DIR = 1;
		s_ADC_In.IO_Port_Reg.bit.P1_DIR = 1;
		s_ADC_In.IO_Port_Reg.bit.RDYFN = 1;
		s_ADC_In.IO_Port_Reg.bit.REDWR = 0;
		s_ADC_In.IO_Port_Reg.bit.Zero = 0;
		s_ADC_In.IO_Port_Reg.bit.SYNC = 0;

		ADC_Reg_Write(i, IO_PORT_REG, s_ADC_In.IO_Port_Reg.all);


		// ADC Start
		ADC_Start();
	}	
}
// ====================================================================== //


// ====================================================================== //
//	Function:	ADC_Start
//		- Start AD Conversion
// ---------------------------------------------------------------------- //
void ADC_Start (void)
{
	unsigned char i = 0;

	for (i=1; i<=4; i++)
	{
		s_ADC_In.Mode_Reg.all = 0x00;
		
		s_ADC_In.Mode_Reg.bit.MD = 1;		// Continuous Conversion.
		s_ADC_In.Mode_Reg.bit.CLKDIS = 0;	// Master Clock Output Enable.
		s_ADC_In.Mode_Reg.bit.DUMP = 0;		// Dump mode off.
		s_ADC_In.Mode_Reg.bit.Cont_RD = 1;	// AD7739 operates in the Continuous Read Mode.
		s_ADC_In.Mode_Reg.bit.Bit16_24 = 0;	// Data Register is 16-Bit wide.
		s_ADC_In.Mode_Reg.bit.CLAMP = 0;	// Even input is out of range, AD7739 reflect the value.

		ADC_Reg_Write(i, MODE_REG_BASE, s_ADC_In.Mode_Reg.all);		
	}
}
// ====================================================================== //



// ====================================================================== //
//	Function:	ADC_Stop
//		- Stop AD Conversion
// ---------------------------------------------------------------------- //
void ADC_Stop (void)
{
	unsigned char i = 0;

	for (i=1; i<=4; i++)
	{
		s_ADC_In.Mode_Reg.all = 0x00;
		
		s_ADC_In.Mode_Reg.bit.MD = 3;		// Power-Down(Standby).
		s_ADC_In.Mode_Reg.bit.CLKDIS = 0;	// Master Clock Output Enable.
		s_ADC_In.Mode_Reg.bit.DUMP = 0;		// Dump mode off.
		s_ADC_In.Mode_Reg.bit.Cont_RD = 0;	
		s_ADC_In.Mode_Reg.bit.Bit16_24 = 0;	// Data Register is 16-Bit wide.
		s_ADC_In.Mode_Reg.bit.CLAMP = 0;	// Even input is out of range, AD7739 reflect the value.

		ADC_Reg_Write(i, MODE_REG_BASE, s_ADC_In.Mode_Reg.all);		
	}
}
// ====================================================================== //



// ====================================================================== //
//	Function:	ADC_Update
//		- Update ADC Data
// ---------------------------------------------------------------------- //
void ADC_Update (void)
{
	unsigned char i = 1;
	unsigned char ch = 0;

	float A_Cal_slope = 1308.2;
	float A_Cal_offset = 20.25;

	float V_Cal_slope = 6524.25;
	float V_Cal_offset = 38.75;

	// ADC Stop
	ADC_Stop();

	// Save the ADC Data.
	for (i=1; i<=4; i++)
	{
		for (ch=0; ch<8; ch++)
		{
			// 0~5V input
			if ( (i==4) && (ch>=6) && (ch<8) )
			{
				s_ADC_In.ADC_Data[ch+(8*(i-1))] = ((float)ADC_Reg_Read(i,CH_DATA_REG_BASE+ch)-V_Cal_offset)/V_Cal_slope;				
			}
			else
			{
				// 4~20mA Input
				s_ADC_In.ADC_Data[ch+(8*(i-1))] = ((float)ADC_Reg_Read(i,CH_DATA_REG_BASE+ch)-A_Cal_offset)/A_Cal_slope;

			}
		}
	}

	// ADC Start again
	ADC_Start();
}
// ====================================================================== //



// ====================================================================== //
//	Function:	ADC_Update
//		- Update ADC Data
// ---------------------------------------------------------------------- //
void ADC_Structure_Init (void)
{
	unsigned char i = 0;

	for (i=0; i<32; i++)
	{
		s_ADC_In.ADC_Data[i] = 0;
	}
}
// ====================================================================== //


// ====================================================================== //



// ====================================================================== //
// End of file.
// ====================================================================== //




