// ====================================================================== //
//				HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_Digital_IO.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for Slave DSP Digital Input/Ouput Control
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-08-16:	Draft
// ====================================================================== //


#ifndef SLAVE_DSP_DIGITAL_IO_H
#define SLAVE_DSP_DIGITAL_IO_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
// 		Global Structure
// ---------------------------------------------------------------------- //
struct DI_L1_Bit	{
	Uint16	Bit_01	:1;
	Uint16	Bit_02	:1;
	Uint16	Bit_03	:1;
	Uint16	Bit_04	:1;
	Uint16	Bit_05	:1;
	Uint16	Bit_06	:1;
	Uint16	Bit_07	:1;
	Uint16	Bit_08	:1;
	Uint16	Bit_09 	:1;
	Uint16	Bit_10	:1;
	Uint16	Bit_11	:1;
	Uint16	Bit_12	:1;
	Uint16	Bit_13	:1;
	Uint16	Bit_14	:1;
	Uint16	Bit_15	:1;
	Uint16	Bit_16	:1;
};

union DI_L1 {
	Uint16					all;
	struct	DI_L1_Bit		bit;
};


struct DI_L2_Bit	{
	Uint16	Bit_17	:1;
	Uint16	Bit_18	:1;
	Uint16	Bit_19	:1;
	Uint16	Bit_20	:1;
	Uint16	Bit_21	:1;
	Uint16	Bit_22	:1;
	Uint16	Bit_23	:1;
	Uint16	Bit_24	:1;
	Uint16	Bit_25	:1;
	Uint16	Bit_26	:1;
	Uint16	Bit_27	:1;
	Uint16	Bit_28	:1;
	Uint16	Bit_29	:1;
	Uint16	Bit_30	:1;
	Uint16	Bit_31	:1;
	Uint16	Bit_32	:1;
};

union DI_L2 {
	Uint16					all;
	struct	DI_L2_Bit		bit;
};


struct DI_Reg {
	union 	DI_L1			L1;
	union 	DI_L2			L2;
};


struct DO_Bit	{
	Uint16	Bit_01		:1;
	Uint16	Bit_02		:1;
	Uint16	Bit_03		:1;
	Uint16	Bit_04		:1;
	Uint16	Bit_05		:1;
	Uint16	Bit_06		:1;
	Uint16	Bit_07		:1;
	Uint16	Bit_08		:1;
	Uint16	Bit_09		:1;
	Uint16	Bit_10		:1;
	Uint16	Bit_11		:1;
	Uint16	Bit_12		:1;
	Uint16	reserved	:4;
};

union DO_Reg {
	Uint16					all;
	struct	DO_Bit			bit;
};

struct Slave_Digital_IO {
	struct	DI_Reg		DI;
	union	DO_Reg		DO;
};


extern volatile struct Slave_Digital_IO		Slave_DIO;
// ====================================================================== //



// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void DI_Update(void);
void DO_Update(void);
// ====================================================================== //



#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of SLAVE_DSP_DIGITAL_IO_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //


