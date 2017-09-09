// ====================================================================== //
//				HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_Thermocouple.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for 6-channel 4~20mA and 2-channel 0~5V Analog Input
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2012-07-02:	Draft
// ====================================================================== //


#ifndef SLAVE_DSP_AD7793_H
#define SLAVE_DSP_AD7793_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
// 		Macro
// ---------------------------------------------------------------------- //


// ----- AD7794 ADC Resolution option -----
// !!! CAUTION !!! - User MUST choose only one resolution option.
//#define 	AD7793_RESOLUTION_24BIT
#define		AD7793_RESOLUTION_16BIT

// ----- AD7793 Registers ------
#define 	COMM_REG			0x00
#define 	STATUS_REG			0x00
#define 	MODE_REG			0x01
#define 	CONFIG_REG			0x02
#define 	DATA_REG			0x03
#define 	ID_REG				0x04
#define 	IO_REG				0x05
#define 	OFFSET_REG 			0x06
#define 	FULL_SCALE_REG		0x07


// ----- AD7793 Mode Register -----
// Mode
#define 	CONTINUOUS_MODE						0
#define 	SINGLE_MODE							1
#define 	IDLE_MODE							2
#define 	POWER_DOWN_MODE						3
#define 	INTERNAL_ZERO_SCALE_CALIBRATION		4
#define 	INTERNAL_FULL_SCALE_CALIBRATION		5
#define 	SYSTEM_ZERO_SCALE_CALIBRATION		6
#define 	SYSTEM_FULL_SCALE_CALIBRATION		7

// Update Rates 
#define 	FREQ_ADC_470HZ			1
#define 	FREQ_ADC_242HZ			2
#define 	FREQ_ADC_123HZ			3
#define 	FREQ_ADC_62HZ			4
#define 	FREQ_ADC_50HZ			5
#define 	FREQ_ADC_39HZ			6
#define 	FREQ_ADC_33HZ			7
#define 	FREQ_ADC_20HZ_90DB		8
#define 	FREQ_ADC_17HZ_80DB		9
#define 	FREQ_ADC_17HZ_65DB		10
#define 	FREQ_ADC_12HZ_66DB		11
#define 	FREQ_ADC_10HZ_69DB		12
#define 	FREQ_ADC_8HZ_70DB		13
#define 	FREQ_ADC_6HZ_72DB		14
#define 	FREQ_ADC_4HZ_74DB		15	


// ----- AD7793 Configuration Register -----
// Bias Voltage Generator
#define 	VBIA_DISABLE		0
#define		VBIA_AIN1			1
#define		VBIA_AIN2			2

// Unipolar or Bipolar
#define		UNIPOLAR		1
#define		BIPOLAR			0

// Gain
#define		GAIN_1			0
#define		GAIN_2			1
#define		GAIN_4			2
#define		GAIN_8			3
#define		GAIN_16			4
#define		GAIN_32			5
#define		GAIN_64			6
#define		GAIN_128		7

// Reference Select 
#define 	EXTERNAL_REF		0
#define		INTERNAL_REF		1

// Channel Select
#define		AIN1_AIN1			0
#define		AIN2_AIN2			1
#define		AIN3_AIN3			2
#define		AIN1_N_AIN1_N		3
#define		TEMP_SENSOR			6
#define		AVDD_MONITOR		7


// ----- AD7793 IO Register -----
// Current Source Direction
#define		IEXC1_IOUT1_IEXC2_IOUT2		0
#define		IEXC1_IOUT2_IEXC2_IOUT1		1
#define		IEXC_IOUT1_ONLY				2
#define		IEXC_IOUT2_ONLY				3

// Current Source Value
#define		EXC_DISABLE			0
#define		EXC_10UA			1
#define		EXC_210UA			2
#define		EXC_1MA				3
// ====================================================================== //



// ====================================================================== //
// 		Global Structure 
// ---------------------------------------------------------------------- //

// ====================================================================== //
//		AD7793 Registers
// ====================================================================== //
// Communication Register (8bit Write Only, RS-0,0,0)
struct Communication_Register_Bits {
	Uint16 CR0			:1;		// CR0 - This bits Must be 0.
	Uint16 CR1			:1;		// CR1 - This bits Must be 0.
	Uint16 CREAD		:1;		// CR2 - CREAD (Continuous Read)
	Uint16 RS			:3;		// CR3~CR5 - RS0~RS2 (Register Address)
	Uint16 RnW			:1;		// CR6 - RW (Read or Write(low active))
	Uint16 nWEN			:1;		// CR7 - nWEN (Low Active)
	Uint16 reserved		:8;		// reserved (Do NOT use these bits.)
};

union Communication_Registers {
	Uint16									all;
	struct	Communication_Register_Bits		bit;				
};


// Status Register (8bit Read Only, RS-0,0,0, Reset => 0x88)
struct Status_Reg_Bits {
	Uint16 CH			:3;		// SR0~SR2 - ADC channel.
	Uint16 SR3			:1;		// SR3 - always set(1) AD7793
	Uint16 SR4			:1;		// SR4 - always clear(0).
	Uint16 SR5			:1;		// SR5 - always clear(0).
	Uint16 ERR			:1;		// SR6 - ERR (Sensed underrange or overrange)
	Uint16 nRDY			:1;		// SR7 - nRDY (Low Active, ADC Data Ready.)	
	Uint16 reserved		:8;		// reserved (Do NOT user these bits.)
};

union Status_Register {
	Uint16							all;
	struct	Status_Reg_Bits			bit;				
};


// Mode Register (16bit R/W, RS-0,0,1, Reset => 0x000A)
struct Mode_Register_Bits {
	Uint16 FS			:4;		// MR0~MR3 - FS0~FS3 (Filter update rate select bits)
	Uint16 MR4			:1;		// MR4 - This bits Must be 0.
	Uint16 MR5			:1;		// MR5 - This bits Must be 0.
	Uint16 CLK			:2;		// MR6~MR7 - CLK0~CLK1 (Select Clk source.)
	Uint16 MR8			:1;		// MR8 - This bits Must be 0.
	Uint16 MR9			:1;		// MR9 - This bits Must be 0.
	Uint16 MR10			:1;		// MR10 - This bits Must be 0.
	Uint16 MR11			:1;		// MR11 - This bits Must be 0.
	Uint16 MR12			:1;		// MR12 - This bits Must be 0.
	Uint16 MD			:3;		// MR13~MR15 - MD0~MD2 (Mode Select bits.)
};

union Mode_Registers {
	Uint16								all;
	struct	Mode_Register_Bits			bit;				
};


// Configuration Register (16bit R/W, RS-0,1,0, Reset => 0x0710)
struct Configurarion_Reg_Bits {
	Uint16 CH			:3;		// CON0~CON2 - CH0~CH2 (ADC Channel Select bits.)
	Uint16 CON3			:1;		// CON3 - This bits Must be 0.
	Uint16 BUF			:1;		// CON4 - BUF (0:unbufferd, 1:buffered)
	Uint16 CON5			:1;		// CON5 - This bits Must be 0.
	Uint16 CON6			:1;		// CON6 - This bits Must be 0.
	Uint16 REFSEL		:1;		// CON7 - REFSEL (Reference Select Bit. 0:Extern Ref 1:Internal Ref)
	Uint16 GAIN			:3;		// CON8~CON10 - G0~G2(Gain Select bits.)
	Uint16 BOOST		:1;		// CON11 - BOOST (Conjunction with the VBIAS1 and VBIAS0)
	Uint16 UnB			:1;		// CON12 - UnB (Unipolar/Bipolar bit. 0:Bipolar, 1:Unipolar)
	Uint16 BO			:1;		// CON13 - BO (Bunout Current Enable bit. 0:Disalbe, 1:Enable)
	Uint16 VBIAS		:2;		// CON14~CON15 - VBIAS0~VBIAS1 (Bias Voltage Genrator Enable)
};

union Configurarion_Register {
	Uint16							all;
	struct	Configurarion_Reg_Bits	bit;				
};


// IO Register (8bit R/W, RS-1,0,1, Reset => 0x00)
struct IO_Reg_Bits {
	Uint16 IEXCEN		:2;		// IO0~IO1 - IEXCEN0~IEXCEN1 (Select Excitation current.)
	Uint16 IEXCDIR		:2;		// IO2~IO3 - IEXCDIR0~IEXCDIR1 (Select direction of current source.)
	Uint16 IO4			:1;		// IO4 - This bits Must be 0.
	Uint16 IO5			:1;		// IO5 - This bits Must be 0.
	Uint16 IO6			:1;		// IO6 - This bits Must be 0.
	Uint16 IO7			:1;		// IO7 - This bits Must be 0.
	Uint16 reserved		:8;		// reserved (Do NOT user these bits.)
};

union IO_Register {
	Uint16							all;
	struct	IO_Reg_Bits				bit;				
};



// AD7793 Information
struct AD7793_Info {
	// Register value
	union 	Communication_Registers		Comm_Reg;			// Communication Register	
	union 	Status_Register				Status_Reg;			// Status Register
	union 	Mode_Registers				Mode_Reg;			// Mode Register
	union 	Configurarion_Register		Config_Reg;			// Config Register
	Uint32								Data_Reg;			// Data Register
	Uint16								ID_Reg;				// ID Register
	union 	IO_Register					IO_Reg;				// Io Register
	Uint32								Offset_Reg;			// Offset Register
	Uint32								Full_Scale_Reg;		// Full Scale Register
};

extern volatile struct AD7793_Info			s_AD7793;
// ====================================================================== //


// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
Uint16 AD7793_Tx_Data (Uint16 data);
Uint16 AD7793_Rx_Data (void);
void AD7793_Write_Reg (Uint8 Reg_Addr, Uint32 data);
Uint32 AD7793_Read_Reg (Uint8 Reg_Addr);
void AD7793_Reset (void);
void AD7793_Struct_Init(void);
// ====================================================================== //



#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of SLAVE_DSP_AD7793_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //



