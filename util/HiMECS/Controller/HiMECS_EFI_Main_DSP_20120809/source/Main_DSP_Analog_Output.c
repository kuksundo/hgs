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
#include "Main_DSP_Analog_Output.h"



// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function: DAC_CS
//		- DAC_CS Control (Refer to 'Main_DSP_External_Interface.h") 
// ---------------------------------------------------------------------- //
void DAC_CS (Uint16 ch)
{
	// Check the DAC CS chip is valid.
	if (ch<1 || ch>3)
	{
		// ADC CS chip is NOT valid, Do Nothing.
		u_AD_DA_Ctrl.bit.DACFS = 0x7;
		// DAC CS Control	
		AD_DA_CTRL = u_AD_DA_Ctrl.all;
		return;
	}

	// Assign DAC CS
	u_AD_DA_Ctrl.bit.DACFS = ch-1;
	
	// DAC CS Control	
	AD_DA_CTRL = u_AD_DA_Ctrl.all;
}
// ====================================================================== //



// ====================================================================== //
//	Function: DAC_Trigger
//		- DAC Trigger Control
// ---------------------------------------------------------------------- //
void DAC_Trigger (Uint16 ch)
{
	// Check the DAC chip is valid.
	if (ch<1 || ch>3)
	{
		// ADC CS chip is NOT valid, Do Nothing.
		return;
	}

	// Assign DAC Trigger
	u_AD_DA_Ctrl.bit.LDAC = ch-1;
	
	// DAC Trigger Control - Low
	AD_DA_CTRL = u_AD_DA_Ctrl.all;

	// DAC Trigger are all High
	u_AD_DA_Ctrl.bit.LDAC = 0x7;

	// DAC Trigger Control - High
	AD_DA_CTRL = u_AD_DA_Ctrl.all;	
}
// ====================================================================== //




// ====================================================================== //
//	Function: DAC_Tx_Data
//		- McBSP send 16-bit data to AD7739
// ---------------------------------------------------------------------- //
void DAC_Tx_Data(Uint16 data)
{
	Uint16 temp = 0;
	Uint16 Wait_count = 0;
	
	// Tx Data
    McbspbRegs.DXR1.all=data;

	// Wait util get dummy data from RTD.
	while (McbspbRegs.SPCR1.bit.RRDY == 0)
	{
		if (Wait_count > 1000)
		{
			return;
		}
		Wait_count++;		
	}
		
	// Get a dummy data from RTD.
	temp = McbspbRegs.DRR1.all;
	temp = temp & 0xFFFF;

	return;
}
// ====================================================================== //



// ====================================================================== //
//	Function: DAC_Init
//		- Initialize DAC(TLV5630) Registers.
// ---------------------------------------------------------------------- //
void DAC_Init (void)
{
	Uint16 i = 0;

	for(i=1; i<=3; i++)
	{
		// DAC CS Select.
		DAC_CS(i);

		// Control 0 Init
		s_DAC.DAC_Reg_Data.bit.Addr = CTRL0;
		s_DAC.DAC_Reg_Data.bit.Data = 0x06;
		DAC_Tx_Data(s_DAC.DAC_Reg_Data.all);
		DAC_Tx_Data(0x0000);

		// CTRL 1 Init
		s_DAC.DAC_Reg_Data.bit.Addr = CTRL1;
		s_DAC.DAC_Reg_Data.bit.Data = 0x00;
		DAC_Tx_Data(s_DAC.DAC_Reg_Data.all);
		DAC_Tx_Data(0x0000);

		// Preset Init
		s_DAC.DAC_Reg_Data.bit.Addr = PRESET;
		s_DAC.DAC_Reg_Data.bit.Data = 0x00;
		DAC_Tx_Data(s_DAC.DAC_Reg_Data.all);
		DAC_Tx_Data(0x0000);
	}
}
// ====================================================================== //



// ====================================================================== //
//	Function: DAC_Out
//		- DAC(TLV5630) Output.
// ---------------------------------------------------------------------- //
void DAC_Out (Uint16 ch, Uint16 data)
{
	Uint16 Chip_Num = 0;
	
	// DAC Chip select as DAC Channel.
	if (ch == CUR_H1)
	{
		// DAC #1
		Chip_Num = 1;
		s_DAC.DAC_Reg_Data.bit.Addr = 0;
	}
	
	else if (ch == CUR_H2)
	{
		// DAC #1
		Chip_Num = 1;
		s_DAC.DAC_Reg_Data.bit.Addr = 1;	
	}
	else if (ch>=3 && ch<=8 )
	{
		// DAC #1
		Chip_Num = 1;
		s_DAC.DAC_Reg_Data.bit.Addr = ch-1;
	}
	else if (ch>=9 && ch<=16)
	{
		// DAC #2
		Chip_Num = 2;
		s_DAC.DAC_Reg_Data.bit.Addr = ch-9;
	}
	else if (ch==17 || ch==18) 
	{
		// DAC #3
		Chip_Num = 3;
		s_DAC.DAC_Reg_Data.bit.Addr = ch-17;
	}
	else if (ch==1 || ch==2 )
	{
		// DAC #3
		Chip_Num = 3;
		s_DAC.DAC_Reg_Data.bit.Addr = ch+1;
	}
	else 
	{
		// Channel is NOT valid, Do Nothing.
		return;
	}

	// CHip Select Control
	DAC_CS(Chip_Num);

	// Asign DAC Value.
	s_DAC.DAC_Reg_Data.bit.Data = (data & 0x0FFF);

	// Set DAC Out Register.
	DAC_Tx_Data(s_DAC.DAC_Reg_Data.all);

	DAC_CS(0);

	// DAC_Trigger
	DAC_Trigger(Chip_Num);
}
// ====================================================================== //



// ====================================================================== //
//	Function: DAC_Out_mA
//		- DAC(TLV5630) mA Output.
// ---------------------------------------------------------------------- //
void DAC_Out_mA (Uint16 ch, float Output_mA)
{
	float A_Cal_slope = 0.005927;
	float A_Cal_offset = 0.024276;
	Uint16 data = 0;

	data = (Uint16)((Output_mA-A_Cal_offset)/A_Cal_slope);

	// Data should be 12-bits range.
	data = data & 0x0FFF;

	DAC_Out(ch,data);
}
// ====================================================================== //




// ====================================================================== //
//	Function: DAC_Out_V
//		- DAC(TLV5630) Voltage Output.
// ---------------------------------------------------------------------- //
void DAC_Out_V (float Output_V)
{
	Uint16 data = 0;
	
	// Data should be 12-bits range.
	data = (Uint16)(Output_V*819);
	data = (Uint16)data & 0x0FFF;

	DAC_Out(19,data);
}
// ====================================================================== //



// ====================================================================== //


// ====================================================================== //
// End of file.
// ====================================================================== //




