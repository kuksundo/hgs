// ====================================================================== //
//				HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_External_Interface.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for External Interface Setting and Operation
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-04-19:	Draft
// ====================================================================== //


#ifndef SLAVE_DSP_EXTERNAL_INTERFACE_H
#define SLAVE_DSP_EXTERNAL_INTERFACE_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
// 		Macro 
// ---------------------------------------------------------------------- //

#define	PWORD(ADDRESS)			   (*(unsigned int *)ADDRESS) 

// Memory Base Address - Zone0

#define DI1					PWORD(0x004380)
#define DI2					PWORD(0x004400)
#define DO1					PWORD(0x004180)

#define STATUS_LED			PWORD(0x004200)
#define DI_LED2				PWORD(0x004280)
#define DI_LED1				PWORD(0x004300)


// Thermocople Chip Select Control 
#define THERMO_CS			PWORD(0x004100)


// Memory Base Address - Zone6 (0x100000 ~ 0x1FFFFF)
// FRAM1_CS			0x100000 ~ 0x13FFFF
// FRAM2_CS			0x140000 ~ 0x17FFFF
#define XZCS6_BASE			0x100000
#define FRAM1_BASE			0x140000
#define FRAM2_BASE			0x180000

#define FRAM_SIZE			0x3FFFF


// Memory Base Address - Zone7 (0x200000 ~ 0x300000)
// XZCS7_BASE		0x200000
// DPRAM_M_CS		0x210000 ~ 0x233FFF
// SRAM_CS			0x280000 ~ 0x2FFFFF
#define XZCS7_BASE			0x200000
#define SRAM_BASE			0x280000
#define DPRAM_M_BASE		0x210000
	

#define SRAM_SIZE			0x7FFFF
#define DPRAM_M_SIZE		0x03FFF



// ====================================================================== //



// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //

void External_Interface_Init (void);
void External_Interface_GPIO_Init(void);

// ====================================================================== //




#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of SLAVE_DSP_EXTERNAL_INTERFACE_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //


