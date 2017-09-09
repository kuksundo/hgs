// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_Digital_IO.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for Main DSP Digital Input/Ouput Control
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-08-16:	Draft
// ====================================================================== //


#ifndef MAIN_DSP_DIGITAL_IO_H
#define MAIN_DSP_DIGITAL_IO_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
// 		Global Structure 
// ---------------------------------------------------------------------- //
struct DIO_M1	{
	Uint16	Bit_01	:1;
	Uint16	Bit_02	:1;
	Uint16	Bit_03	:1;
	Uint16	Bit_04	:1;
	Uint16	Bit_05	:1;
	Uint16	Bit_06	:1;
	Uint16	Bit_07	:1;
	Uint16	Bit_08	:1;
	Uint16	Bit_09	:1;
	Uint16	Bit_10	:1;
	Uint16	Bit_11	:1;
	Uint16	Bit_12	:1;
	Uint16	Bit_13	:1;
	Uint16	Bit_14	:1;
	Uint16	Bit_15	:1;
	Uint16	Bit_16	:1;
};

union Bits_M1 {
	Uint16					all;
	struct	DIO_M1			bit;
};


struct DIO_M2	{
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

union Bits_M2 {
	Uint16					all;
	struct	DIO_M2			bit;
};


struct DIO_Reg {
	union 	Bits_M1			M1;
	union 	Bits_M2			M2;
};


// DI/DO Control Structure
struct Main_Digital_IO {
	struct DIO_Reg			DI;
	struct DIO_Reg			DO;
};

extern volatile struct Main_Digital_IO		s_Main_DIO;
// ====================================================================== //



// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void DI_Update (void);
void DO_Update (void);
// ====================================================================== //



#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of MAIN_DSP_DIGITAL_IO_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //


