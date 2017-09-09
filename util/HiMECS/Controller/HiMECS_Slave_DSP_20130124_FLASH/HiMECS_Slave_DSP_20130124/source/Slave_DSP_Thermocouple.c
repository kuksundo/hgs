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
#include "Slave_DSP_ThermoCouple.h"
// ====================================================================== //



// ====================================================================== //
//	Global Variables
// ====================================================================== //

// ====================================================================== //



// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function:	Thermo_Struct_Init
//		- Thermocouple Sturucture Initialization.
// ---------------------------------------------------------------------- //
void Thermo_Struct_Init(void)
{
	int i = 0;
	for (i=0; i<16; i++)
	{
		s_Thermo_Couple.ADC_Data[i] = 0;
		s_Thermo_Couple.TC_Voltage[i] = 0;
		s_Thermo_Couple.Temperature[i] = 0;
	}			
}
// ====================================================================== //



// ====================================================================== //
//	Function:	Thermocouple_Init
//		- Thermocouple Sturucture Initialization.
// ---------------------------------------------------------------------- //
void Thermocouple_Init (void)
{
	Uint16 i = 0;
	volatile Uint32 temp = 0;
	
	// AD7793 Structure Init
	AD7793_Struct_Init();

	// Thermocouple Structure Init
	Thermo_Struct_Init();

	for(i=0; i<16; i++)
	{
		// Control Chip Select
		THERMO_CH(i);
		DELAY_US(10);

		AD7793_Reset();
		DELAY_US(10);
		
		// Set Configuration Register
		s_AD7793.Config_Reg.all = 0x00;
		s_AD7793.Config_Reg.bit.UnB = UNIPOLAR;
		s_AD7793.Config_Reg.bit.REFSEL =  INTERNAL_REF;
		s_AD7793.Config_Reg.bit.GAIN = GAIN_1;
		s_AD7793.Config_Reg.bit.CH = AIN1_AIN1;
		AD7793_Write_Reg(CONFIG_REG, s_AD7793.Config_Reg.all);
		DELAY_US(5000);

		// Set IO Register
		s_AD7793.IO_Reg.all = 0x00;
		s_AD7793.IO_Reg.bit.IEXCDIR = IEXC1_IOUT1_IEXC2_IOUT2;
		s_AD7793.IO_Reg.bit.IEXCEN = EXC_10UA;
		AD7793_Write_Reg(IO_REG, s_AD7793.IO_Reg.all);
		DELAY_US(5000);

		// Set Mode Register 
		/*
		s_AD7793.Mode_Reg.all = 0x00;
		s_AD7793.Mode_Reg.bit.MD = CONTINUOUS_MODE;
		s_AD7793.Mode_Reg.bit.FS = FREQ_ADC_17HZ_65DB;
		AD7793_Write_Reg(MODE_REG, s_AD7793.Mode_Reg.all);
		DELAY_US(5000);
		*/
		
		s_AD7793.Mode_Reg.all = 0x00;
		s_AD7793.Mode_Reg.bit.MD = INTERNAL_ZERO_SCALE_CALIBRATION;
		s_AD7793.Mode_Reg.bit.FS = FREQ_ADC_17HZ_65DB;
		AD7793_Write_Reg(MODE_REG, s_AD7793.Mode_Reg.all);
		DELAY_US(5000);

		temp = AD7793_Read_Reg(STATUS_REG);

		while ( temp & 0x80 )
		{
			temp = AD7793_Read_Reg(STATUS_REG);
			DELAY_US(10);
		}
	}
}
// ====================================================================== //



// ====================================================================== //
//	Function:	Thermo_Get_Data1
//		- Get Thermocouple A/D conversion Data.
// ---------------------------------------------------------------------- //
void Thermo_Get_Data1 (Uint16 ch)
{
	// Thermocople Chip Select
	THERMO_CH(ch);
	DELAY_US(10);
	
	// Set Mode Register Single Conversion Mode.
	s_AD7793.Mode_Reg.all = 0x00;
	s_AD7793.Mode_Reg.bit.MD = SINGLE_MODE;
	s_AD7793.Mode_Reg.bit.FS = FREQ_ADC_17HZ_65DB;
	
	AD7793_Write_Reg(MODE_REG, s_AD7793.Mode_Reg.all);
}
// ====================================================================== //



// ====================================================================== //
//	Function:	RTD_Get_Data2
//		- Get Thermocouple A/D conversion Data.
// ---------------------------------------------------------------------- //
int Thermo_Get_Data2 (Uint16 ch)
{
	Uint32 temp = 0;
	Uint32 data = 0;

	// Thermocople Chip Select
	THERMO_CH(ch);
	DELAY_US(10);
	
	// Wait for finising A/D Conversion.
	temp = AD7793_Read_Reg(STATUS_REG);

	if ((temp&0x80)==0)
	{
		// After finishing ADC, read the data.
		data = AD7793_Read_Reg(DATA_REG);	

		s_Thermo_Couple.ADC_Data[ch] = data;

		return PASS;
	}
	else
	{
		return FAIL;
	}		
}
// ====================================================================== //



// ====================================================================== //
//	Function:	Thermo_Get_Data
//		- Get Thermocouple A/D conversion Data.
// ---------------------------------------------------------------------- //
int Thermo_Get_Data (Uint16 ch)
{
	Uint32 temp = 0;
	Uint32 data = 0;
	Uint32 Wait_Count = 0;
	
	// Thermocople Chip Select
	THERMO_CH(ch);
	DELAY_US(10);
	
	// Set Mode Register Single Conversion Mode.
	s_AD7793.Mode_Reg.all = 0x00;
	s_AD7793.Mode_Reg.bit.MD = SINGLE_MODE;
	s_AD7793.Mode_Reg.bit.FS = FREQ_ADC_17HZ_65DB;
	
	AD7793_Write_Reg(MODE_REG, s_AD7793.Mode_Reg.all);

	// Wait for finising A/D Conversion.
	temp = AD7793_Read_Reg(STATUS_REG);

	while (temp & 0x80)
	{
		// If ADC time is too long, reset RTD.
		if (Wait_Count > 150000)
		{
			Thermocouple_Init();
			return FAIL;
		}
		temp = AD7793_Read_Reg(STATUS_REG);
		Wait_Count++;
	}
	// After finishing ADC, read the data.
	data = AD7793_Read_Reg(DATA_REG);	
	
	s_Thermo_Couple.ADC_Data[ch] = data;

	return PASS;
}
// ====================================================================== //



// ====================================================================== //




// ====================================================================== //
// End of file.
// ====================================================================== //


