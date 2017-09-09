// ====================================================================== //
//						HIMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_Modbus485.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for Slave DSP Modbus-485 Communication
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2013-01-15:	Draft
// ====================================================================== //


#ifndef SLAVE_DSP_MODBUS485_H
#define SLAVE_DSP_MODBUS485_H


#ifdef __cplusplus
extern "C" {
#endif



// ====================================================================== //
//	Macros
// ---------------------------------------------------------------------- //
// Modbus SCI Register Setting - Parity Enable
#define PARITY_DISABLE			0
#define PARITY_ENABLE			1

// Modbus SCI Register Setting - Parity Type
#define ODD_PARITY				0
#define EVEN_PARITY				1

// Modbus SCI Regster Setting - STOP bit
#define ONE_STOP_BIT			0
#define TWO_STOP_BIT			1


// RTS Delay Bits
#define RTS_DELAY_BITS 			20

// Modbus Buffer Size
#define MODBUS_RX_BUFF_SIZE		300
#define	MODBUS_TX_BUFF_SIZE		300

// Modbus Register Size
#define MODBUS_REGISTER_SIZE	300

// Modbus RTS Control - HIMECS ver2.0 is connected GPIO11 to RS-485 RTS.
#define MODBUS_RTS(VAL)			GpioDataRegs.GPADAT.bit.GPIO11 = (VAL);
#define MODBUS_RTS_OFF			GpioDataRegs.GPACLEAR.bit.GPIO11 = 1;
#define MODBUS_RTS_ON			GpioDataRegs.GPASET.bit.GPIO11 = 1;


// FRAM Address for Modbus Setting
#define MODBUS_SET_FLAG_ADDR		220
#define MODBUS_BAUD_ADDR			221		// 4bytes
#define	MODBUS_PARITY_EN_ADDR		225
#define MODBUS_PARITY_TYPE_ADDR		226
#define	MODBUS_STOP_BIT_ADDR		227

// ====================================================================== //



// ====================================================================== //
//	Global Structure 
//		- These Structure declaration should be in Main_DSP_Main.h
// ---------------------------------------------------------------------- //
struct s_Modbus_buffer {
	// Slave Self Address
	Uint8 Salve_Self_Addr;
	
	// Buffer Index
	int rx_buff_index;
	int tx_buff_index;

	// Buffer
	unsigned char rx_buffer[MODBUS_RX_BUFF_SIZE];
	unsigned char tx_buffer[MODBUS_TX_BUFF_SIZE];

	// Register
	Uint16 Register[MODBUS_REGISTER_SIZE];

	// Rx Inverval Time0 Tick
	Uint32 Interval_Time_Tick;		// Tick/100us

	// Rx Interval Time Limit
	Uint32 Rx_Time_Limit;		// Rx Interval Time Limit = Rx_Time_Limit * 100us

	// Rx Buffer Overflow flag
	int Rx_Buffer_Overflow;

	// Rx START of Frame flag
	int Rx_SOF_flag;
	
	// Rx END of Frame Flag
	int Rx_EOF_flag;

	// Modbus Tx flag
	int Tx_Start_flag;

	// Modbus Communication Baudrate
	Uint32	Baudrate;
};

extern volatile struct s_Modbus_buffer s_Modbus_buffer;
// ====================================================================== //




// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void Modbus_GPIO_Init (void);
void Modbus_Reg_Init (Uint32 baud_rate, Uint16 Parity_Enable, Uint16 Parity_Type, Uint16 Stop_bits);
void Modbus_FIFO_Init (void);
void Modbus_Structure_Init (Uint8 Address, Uint32 Baudrate);
void Modbus_Init (void);
unsigned char Modbus_Rx (void);
void Modbus_Tx_byte(unsigned char data);
void Modbus_Tx(void);
interrupt void Modbus_Rx_ISR (void);
void Modbus_Interrupt_Init(void);

void Modbus_Rx_Process (void);
void Read_Holding_Register (void);
void Preset_Single_Register (void);
void Preset_Multiple_Register (void);
Uint16 Check_Rx_CRC (Uint16 Data_Length);
Uint16 Make_Tx_CRC (Uint16 Data_Length);

// ====================================================================== //




#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of SLAVE_DSP_MODBUS485_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //



