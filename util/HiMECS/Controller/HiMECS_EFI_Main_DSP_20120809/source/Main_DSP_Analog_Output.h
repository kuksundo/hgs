// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_Analog_Input.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for 32-channel 4~20mA Analog Input sensor
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-09-29:	Draft
// ====================================================================== //


#ifndef MAIN_DSP_ANALOG_OUTPUT_H
#define MAIN_DSP_ANALOG_OUTPUT_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
// 		Macro
// ---------------------------------------------------------------------- //
// TLV5630 Register Address
#define 	CTRL0		8
#define		CTRL1		9
#define		PRESET		10

// DAC Channel
#define 	CUR_H1		19
#define		CUR_H2		20
// ====================================================================== //




// ====================================================================== //
// 		Global Structure 
// ---------------------------------------------------------------------- //
struct DAC_Reg_Data_Bits {
	Uint16	Data	:12;	// Channel Data.
	Uint16	Addr	:4;		// Channel Address.
}; 

union DAC_Reg_Data {
	Uint16								all;
	struct		DAC_Reg_Data_Bits		bit;
};

struct DAC_Info {
	union 		DAC_Reg_Data 		DAC_Reg_Data;
	Uint16							DAC_Data[20];
};

extern volatile struct DAC_Info s_DAC;
// ====================================================================== //



// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void DAC_CS (Uint16 ch);
void DAC_Trigger (Uint16 ch);
void DAC_Tx_Data(Uint16 data);
void DAC_Init (void);
void DAC_Out (Uint16 ch, Uint16 data);
void DAC_Out_mA (Uint16 ch, float Output_mA);
void DAC_Out_V (float Output_V);
// ====================================================================== //



#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of MAIN_DSP_ANALOG_OUTPUT_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //


