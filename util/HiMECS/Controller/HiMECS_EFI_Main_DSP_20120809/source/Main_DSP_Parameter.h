// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_main.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for Main Operation Program 
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-04-19:	Draft
// ====================================================================== //

#ifndef MAIN_DSP_PARAMETER_H
#define MAIN_DSP_PARAMETER_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
// 		Macro 
// ---------------------------------------------------------------------- //

// Define System frequency (MHz) 
#define SYSTEM_FREQUENCY		150

// Define System Clock (clock/sec)
#define SYSCLKOUT				150000000

// Define System High Speed Peripheral Clock (clock/sec)
//	!!CAUTION!!	User MUST check function:InitPeripheralClocks in DSP2833x_SysCtrl.c
//				SysCtrlRegs.HISPCP.all value can change this parameter.
#define HSP_CLK					75000000

// Define System Low Speed Peripheral Clock (clock/sec)
//	!!CAUTION!!	User MUST check function:InitPeripheralClocks in DSP2833x_SysCtrl.c
//				SysCtrlRegs.LOSPCP.all value can change this parameter.
#define LSP_CLK					37500000


// Define Timer0 ISR frequency (Hz), 
// !!CAUTION!! TIMER0 ISR Frequency should be less than 10^6
#define TIMER0_ISR_FREQUENCY	10000

// Default Debug SCI Baud rate
#define DEFAULT_SCI_C_BAUD		115200

// Default Modbus Baud rate
#define DEFAULT_MODBUS_BAUD		19200


// Logic Define 
#define PASS		0
#define FAIL		-1

#define ENABLE		1
#define DISABLE		0

#define ON			1
#define OFF			0

// ====================================================================== //



#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // End of MAIN_DSP_PARAMETER_H definition

// ====================================================================== //
//		End of file.
// ====================================================================== //




