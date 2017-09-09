// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_Analog_Input.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for McBSP Communication as SPI.
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-09-29:	Draft
// ====================================================================== //


#ifndef MAIN_DSP_MCBSP_H
#define MAIN_DSP_MCBSP_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
// 		Define
// ---------------------------------------------------------------------- //
#define CPU_SPD              150E6
#define MCBSP_SRG_FREQ       CPU_SPD/4
#define CLKGDV_VAL           1
#define MCBSP_INIT_DELAY     2*(CPU_SPD/MCBSP_SRG_FREQ)                  // # of CPU cycles in 2 SRG cycles-init delay
#define MCBSP_CLKG_DELAY     2*(CPU_SPD/(MCBSP_SRG_FREQ/(1+CLKGDV_VAL))) // # of CPU cycles in 2 CLKG cycles-init delay
// ====================================================================== //



// ====================================================================== //
// 		Global Structure 
// ---------------------------------------------------------------------- //

// ====================================================================== //



// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void McBSP_A_GPIO_Init(void);
void McBSP_B_GPIO_Init(void);
void McBSP_Init_SPI(void);
void McBSP_A_Tx_Data(unsigned char data);
unsigned char McBSP_A_Rx_Data (void);
void McBSP_B_Tx_Data(Uint16 data);
Uint16 McBSP_B_Rx_Data (void);
void McBSP_delay_loop(void);
// ====================================================================== //



#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of MAIN_DSP_MCBSP_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //



