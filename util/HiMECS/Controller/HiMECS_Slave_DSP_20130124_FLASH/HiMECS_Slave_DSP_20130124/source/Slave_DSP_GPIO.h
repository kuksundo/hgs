// ====================================================================== //
//				HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_GPIO.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for GPIO Setting and Operation
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-04-19:	Draft
// ====================================================================== //


#ifndef SLAVE_DSP_GPIO_H
#define SLAVE_DSP_GPIO_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void GPIO_Init (void);
void L_DSP_RUN_LED_Toggle (void);
// ====================================================================== //




#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of SLAVE_DSP_GPIO_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //

