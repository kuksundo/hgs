// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_BIT.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for Main DSP Built In Test
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-04-21:	Draft
// ====================================================================== //


#ifndef MAIN_DSP_BIT_H
#define MAIN_DSP_BIT_H


#ifdef __cplusplus
extern "C" {
#endif


// ====================================================================== //
//	Global Structure 
//		- These Structure declaration should be in Main_DSP_Main.h
// ---------------------------------------------------------------------- //
struct s_BIT_Infomation {
	Uint16 Mem_BIT_Err_Count;
};

extern volatile struct s_BIT_Infomation s_BIT_Info;
// ====================================================================== //



// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void System_Hold (void);
int Memory_BIT (Uint32 base_address, Uint32 memory_size);
void Memory_Save_Count (Uint32 base_address, Uint32 memory_size);
int Memory_Count_Test (Uint32 base_address, Uint32 memory_size);
void Print_Memory_Error (Uint32 Address, Uint16 Data_WR, Uint16 Data_RD);
// ====================================================================== //





#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of MAIN_DSP_BIT_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //

