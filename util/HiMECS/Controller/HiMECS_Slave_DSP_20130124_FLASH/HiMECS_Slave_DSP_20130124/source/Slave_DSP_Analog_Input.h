// ====================================================================== //
//				HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_Analog_Input.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for 6-channel 4~20mA and 2-channel 0~5V Analog Input
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2012-07-02:	Draft
// ====================================================================== //


#ifndef SLAVE_DSP_ANALOG_INPUT_H
#define SLAVE_DSP_ANALOG_INPUT_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
// 		Macro
// ---------------------------------------------------------------------- //
// AD7739 Register Address
#define	COMM_REG					0x00
#define	IO_PORT_REG					0x01
#define	REV_REG						0x02
#define TEST_REG					0x03
#define	ADC_STATUS_REG				0x04
#define CHKSUM_REG					0x05
#define	ADC_ZERO_CAL_REG			0x06
#define	ADC_FULL_CAL_REG			0x07
#define	CH_DATA_REG_BASE			0x08
#define	CH_ZERO_CAL_REG_BASE		0x10
#define CH_FULL_CAL_REG_BASE		0x18
#define CH_STATUS_REG_BASE			0x20
#define CH_SETUP_REG_BASE			0x28
#define CH_CONV_REG_BASE			0x30
#define MODE_REG_BASE				0x38
// ====================================================================== //




// ====================================================================== //
// 		Global Structure 
// ---------------------------------------------------------------------- //

// ====================================================================== //
//		AD7739 Registers
// ====================================================================== //
// ---------------------------------------------------------------------- //
// Communication Register (8bit Write Only, Address:0x00)
// ---------------------------------------------------------------------- //
struct Communication_Reg_Bits {
	Uint16 Addr			:6;		// 6-Bit Register Address
	Uint16 RnW			:1;		// RW (Read or Write(low active))
	Uint16 Zero			:1;		// 0 - This bit MUST be 0 for proper operation.
	Uint16 reserved		:9;		// reserved (Do NOT use these bits.)
};

union Communication_Register {
	Uint16								all;
	struct	Communication_Reg_Bits		bit;				
};
// ---------------------------------------------------------------------- //


// ---------------------------------------------------------------------- //
// IO Register (8bit R/W, Address:0x01)
// ---------------------------------------------------------------------- //
struct IO_Port_Reg_Bits {
	Uint16 SYNC			:1;		// Enable nSYNC pin function.
	Uint16 Zero			:1;		// 0 - This bit MUST be 0 for proper operation.
	Uint16 REDWR		:1;		// Reduced Power mode (0:Disable, 1:Enable)
	Uint16 RDYFN		:1;		// Enable nRDY function.
	Uint16 P1_DIR		:1;		// P1 pin Direction.(0:Output, 1:Input)
	Uint16 P0_DIR		:1;		// P0 pin Direction.(0:Output, 1:Input)
	Uint16 P1			:1;		// P1 Level
	Uint16 P0			:1;		// P0 Level	
	Uint16 reserved		:8;		// reserved (Do NOT user these bits.)
};

union IO_Port_Register {
	Uint16							all;
	struct	IO_Port_Reg_Bits		bit;				
};
// ---------------------------------------------------------------------- //


// ---------------------------------------------------------------------- //
// Revision Register (8bit Read Only, Address:0x02)
// ---------------------------------------------------------------------- //
struct Revision_Reg_Bits {
	Uint16 Chip_Generic_Code	:4;		// AD7739 = 0x09
	Uint16 Chip_Revision_Code	:4;		// 4-bit Factory Chip Revision Code.
	Uint16 reserved				:8;		// reserved (Do NOT user these bits.)
};

union Revision_Register {
	Uint16							all;
	struct	Revision_Reg_Bits		bit;				
};
// ---------------------------------------------------------------------- //


// ---------------------------------------------------------------------- //
// Channel Status Register (8bit, Read-Only, Address:0x20~0x27)
// ---------------------------------------------------------------------- //
struct Channel_Status_Reg_Bits {
	Uint16	OVR					:1;		// Input is over/under range.
	Uint16	SIGN				:1;		// Voltage Polarity (0:Positive, 1:Negative)
	Uint16	NOREF				:1;		// Reference Input Status.
	Uint16	RDY_P1				:1;		// Status Option1 (0:RDY Status, 1:P1 Status)
	Uint16	P0_0				:1;		// Status Option0 (0:Read 0, 1:P0 Status)
	Uint16	CH					:3;		// Channel number
	Uint16	reserved			:8;		// reserved (Do NOT user these bits.)
};

union Channel_Status_Register {
	Uint16								all;
	struct	Channel_Status_Reg_Bits		bit;				
};
// ---------------------------------------------------------------------- //


// ---------------------------------------------------------------------- //
// Channel Setup Register (8bit, R/W, Address:0x28~0x2F)
// ---------------------------------------------------------------------- //
struct Channel_Setup_Reg_Bits {
	Uint16	RNG					:3;		// Channel Input Voltage Range.
	Uint16	Enable				:1;		// Channel Enable. (0:Disable, 1:Enable - Only Continuous mode)
	Uint16	Stat_OPT			:1;		// Status Option. (0:RDY, 1:P0&P1 reflects Channel Status Reg)
	Uint16	COM					:2;		// Analog Input Configuration.
	Uint16	BUFOFF				:1;		// Buffer Off. (0:Interanl Buffer Enable) - Only Enable Recommanded!.
	Uint16	reserved			:8;		// reserved (Do NOT user these bits.)
};

union Channel_Setup_Register {
	Uint16								all;
	struct	Channel_Setup_Reg_Bits		bit;				
};
// ---------------------------------------------------------------------- //


// ---------------------------------------------------------------------- //
// Channel Conversion Time Register (8bit, R/W, Address:0x30~0x37)
// ---------------------------------------------------------------------- //
struct Channel_Conv_Time_Reg_Bits {
	Uint16	FW					:7;		// 7-bit Filter Word
	Uint16	CHOP				:1;		// Chopping Enable. (0:Disable, 1:Enable)
	Uint16	reserved			:8;		// reserved (Do NOT user these bits.)
};

union Channel_Conv_Time_Register {
	Uint16									all;
	struct	Channel_Conv_Time_Reg_Bits		bit;				
};
// ---------------------------------------------------------------------- //



// ---------------------------------------------------------------------- //
// Mode Register (8bit, R/W, Address:0x30~0x37)
// ---------------------------------------------------------------------- //
struct Mode_Reg_Bits {
	Uint16	CLAMP				:1;		// 0:out of range voltage ok, 1: when voltage is out of range, data will be all 0.
	Uint16	Bit16_24			:1;		// Data Resolution (0:16-bit, 1:24-bit)
	Uint16	Cont_RD				:1;		// Continuous read mode (0:Disable, 1:Enable)
	Uint16	DUMP				:1;		// Dump Mode (0:Disable, 1:Enable)
	Uint16	CLKDIS				:1;		// Master Clock Output Diable (0:Enable, 1:Disable)
	Uint16	MD					:3;		// Mode	
	Uint16	reserved			:8;		// reserved (Do NOT user these bits.)
};

union Mode_Register {
	Uint16									all;
	struct	Mode_Reg_Bits					bit;				
};
// ---------------------------------------------------------------------- //



// ---------------------------------------------------------------------- //
// Analog Input Information
// ---------------------------------------------------------------------- //
struct Analog_Input_Info {
	// Register value
	union 	Communication_Register		Comm_Reg;				// Communication Register	
	union	IO_Port_Register			IO_Port_Reg;			// I/O Port Register
	union	Revision_Register			Rev_Reg;				// Revision Register
	Uint32								Test_Reg;				// 24-bit Test Reg (DO NOT Change default value!)
	Uint16 								ADC_Status_Reg;			// ADC Status Reg (8bit, Read only, Addr:0x04)
	Uint16								Checksum_Reg;			// Checksum Register
	Uint32 								ADC_Zero_Cal_Reg;		// ADC Zero-Scale Calibration Register
	Uint32								ADC_FULL_Cal_Reg;		// ADC Full-Scale Calibration Register
	Uint16 								Ch_Data_Reg[8];			// Channel Data Register (16bit/24bit, 8ch) 
	Uint32								Ch_Zero_Cal_Reg[8];		// Channel Zero-Scale Calibration Register
	Uint32								Ch_Full_Cal_Reg[8];		// Channel Full-Scale Calibration Register
	union	Channel_Status_Register		Ch_Status_Reg[8];		// Channel Status Register
	union	Channel_Conv_Time_Register	Ch_Conv_Time_Reg[8];	// Channel Conversion Time Register
	union	Channel_Setup_Register		Ch_Setup_Reg[8];		// Channel Setup Register
	union	Mode_Register				Mode_Reg;				// Mode Register	

	float								ADC_Data[8];			// ADC Data
};
// ---------------------------------------------------------------------- //

extern volatile struct Analog_Input_Info s_ADC_In;
// ====================================================================== //



// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void ADC_Tx_Data(unsigned char data);
unsigned char ADC_Rx_Data (void);
void ADC_Reset (void);
void ADC_Reg_Write (unsigned char Addr, Uint32 data);
Uint32 ADC_Reg_Read (unsigned char Addr);
void ADC_Init (void);
void ADC_Start (void);
void ADC_Stop (void);
void ADC_Update (void);
void ADC_Structure_Init (void);
// ====================================================================== //



#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of SLAVE_DSP_ANALOG_INPUT_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //


