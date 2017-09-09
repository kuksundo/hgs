// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_Debug_SCI.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for Main DSP Debug Serial Communication Interface (SCI)
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-04-25:	Draft
// ====================================================================== //


#ifndef MAIN_DSP_DEBUG_SCI_H
#define MAIN_DSP_DEBUG_SCI_H


#ifdef __cplusplus
extern "C" {
#endif




// ====================================================================== //
// 		Macro 
// ---------------------------------------------------------------------- //
#define DEBUG_RX_BUFF_SIZE		100
#define DEBUG_TX_BUFF_SIZE		100

// ====================================================================== //




// ====================================================================== //
//	Global Structure 
//		- These Structure declaration should be in Main_DSP_Main.h
// ---------------------------------------------------------------------- //
struct s_Debug_buffer {
	int rx_buff_index;
	int tx_buff_index;
	unsigned char rx_buffer[DEBUG_RX_BUFF_SIZE];
	unsigned char tx_buffer[DEBUG_TX_BUFF_SIZE];
};

extern volatile struct s_Debug_buffer s_Debug_buffer;
// ====================================================================== //


// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void Debug_SCI_GPIO_Init (void);
void Debug_SCI_Reg_Init (Uint32 baud_rate);
void Debug_SCI_FIFO_Init (void);
void Debug_SCI_Init (Uint32 baud_rate);
unsigned char Debug_SCI_Rx (void);
void Debug_SCI_Tx(unsigned char data);
interrupt void Debug_SCI_Rx_ISR (void);
void Debug_SCI_Interrupt_Init(void);
int Printf(char *form, ... );

// ====================================================================== //




#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of MAIN_DSP_DEBUG_SCI_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //



