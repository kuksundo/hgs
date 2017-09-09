// ====================================================================== //
//				HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_Thermocouple.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for 6-channel 4~20mA and 2-channel 0~5V Analog Input
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2012-07-02:	Draft
// ====================================================================== //


#ifndef SLAVE_DSP_THERMOCOUPLE_H
#define SLAVE_DSP_THERMOCOUPLE_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
// 		Macro
// ---------------------------------------------------------------------- //
// Thermocouple Chip Select Macro
#define 	THERMO_CH(CH)		THERMO_CS=(1 << CH)
// ====================================================================== //



// ====================================================================== //
// 		Global Structure 
// ---------------------------------------------------------------------- //
// Thermo Couple 
struct Thermo_Couple_Info {
	// ADC Raw Data Buffer
	Uint32 	ADC_Data[16];
	float 	TC_Voltage[16];
	float 	Temperature[16];
};

extern volatile struct Thermo_Couple_Info	s_Thermo_Couple;
// ====================================================================== //



// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void Thermo_Struct_Init(void);
void Thermocouple_Init (void);
void Thermo_Get_Data1 (Uint16 ch);
int Thermo_Get_Data2 (Uint16 ch);
int Thermo_Get_Data (Uint16 ch);
// ====================================================================== //



#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of SLAVE_DSP_THERMOCOUPLE_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //



