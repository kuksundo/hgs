// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_External_Interface.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for External Interface Setting and Operation
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-04-19:	Draft
// ====================================================================== //


#ifndef MAIN_DSP_EXTERNAL_INTERFACE_H
#define MAIN_DSP_EXTERNAL_INTERFACE_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
// 		Macro 
// ---------------------------------------------------------------------- //
#define	PWORD(ADDRESS)			   (*(unsigned int *)ADDRESS) 

// Memory Base Address - Zone0
#define XZCS0_BASE			PWORD(0x004000)

#define KEY_IN				PWORD(0x004080)

#define EFI_CMD				PWORD(0x004100)

#define DIN1				PWORD(0x004180)
#define DIN2				PWORD(0x004200)
#define DIN3				PWORD(0x004280)

#define DOUT1				PWORD(0x004300)
#define DOUT2				PWORD(0x004380)

#define AD_DA_CTRL			PWORD(0x004400)

#define DI_LED1				PWORD(0x004480)
#define DI_LED2				PWORD(0x004500)

#define DO_LED1				PWORD(0x004580)
#define DO_LED2				PWORD(0x004600)

#define STATUS_LED			PWORD(0x004680)

#define SPEED_READ			PWORD(0x004700)


// Memory Base Address - Zone6 (0x100000 ~ 0x1FFFFF)
// FRAM1_CS			0x100000 ~ 0x13FFFF
// FRAM2_CS			0x140000 ~ 0x17FFFF
#define XZCS6_BASE			0x100000
#define FRAM1_BASE			0x140000
#define FRAM2_BASE			0x180000

#define FRAM_SIZE			0x3FFFF


// Memory Base Address - Zone7 (0x200000 ~ 0x300000)
// XZCS7_BASE		0x200000
// SPEED_CS			0x210000 ~ 0x21007F
// DPRAM_2808_CS	0x220000 ~ 0x223FFF
// DPRAM_M_CS		0x230000 ~ 0x233FFF
// DPRAM_STR_CS		0x254000 ~ 0x257FFF
// SRAM_CS			0x280000 ~ 0x2FFFFF
#define XZCS7_BASE			0x200000
#define SRAM_BASE			0x280000
//#define DPRAM_STR_BASE		0x250000
#define DPRAM_STR_BASE		0x254000
#define DPRAM_M_BASE		0x230000
#define DPRAM_2808_BASE		0x220000
#define SPEED_BASE			0x210000	

#define SRAM_SIZE			0x7FFFF
//#define DPRAM_STR_SIZE		0x07FFF
#define DPRAM_STR_SIZE		0x03FFF
#define DPRAM_M_SIZE		0x03FFF
#define DPRAM_2808_SIZE		0x03FFF
#define SPEED_SIZE			0x0007F
// ====================================================================== //



// ====================================================================== //
// 		Global Structure 
// ---------------------------------------------------------------------- //

// Main DSP Analog Input/Output Control
struct AD_DA_Control_Bits	{
	Uint16 DACFS			:3;		// DAC CS
	Uint16 LDAC				:3;		// Latch Trigger of DAC 
	Uint16 reserved1		:1;		// Reserved Bits (Don't care bits.)
	Uint16 AD_CS			:2;		// ADC CS: 4-ch ADC
	Uint16 reserved2		:7;		// Reserved Bits (Don't care bits.)
};

union AD_DA_Control {
	Uint16								all;
	struct	AD_DA_Control_Bits			bit;
};


extern volatile union AD_DA_Control		u_AD_DA_Ctrl;
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

#endif  // end of MAIN_DSP_EXTERNAL_INTERFACE_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //


