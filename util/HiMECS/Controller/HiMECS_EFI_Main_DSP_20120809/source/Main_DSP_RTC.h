// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_RTC.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for RTC(FM31L278) using I2C.
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-08-29:	Draft
// ====================================================================== //


#ifndef MAIN_DSP_RTC_H
#define MAIN_DSP_RTC_H


#ifdef __cplusplus
extern "C" {
#endif


// ====================================================================== //
// 		Macro 
// ---------------------------------------------------------------------- //
#define BCDTOBIN(val) ( ( ( val ) & 0x0f ) + ( ( val ) >> 4 ) * 10 )
#define BINTOBCD(val) ( ( ( ( val ) / 10 ) << 4 ) + ( val ) % 10 )


#define FM31L278_RTC_CONTROL		(0x0)
#define FM31L278_CAL_CONTROL		(0x1)
#define FM31L278_RTC_SECONDS		(0x2)
#define FM31L278_RTC_MINUTES		(0x3)
#define FM31L278_RTC_HOURS			(0x4)
#define FM31L278_RTC_DAY			(0x5)
#define FM31L278_RTC_DATE			(0x6)
#define FM31L278_RTC_MONTHS			(0x7)
#define FM31L278_RTC_YEARS			(0x8)

#define FM31L278_SERIAL_NUMBYTE0 	(0x11)
#define FM31L278_SERIAL_NUMBYTE1 	(0x12)
#define FM31L278_SERIAL_NUMBYTE2 	(0x13)
#define FM31L278_SERIAL_NUMBYTE3 	(0x14)
#define FM31L278_SERIAL_NUMBYTE4 	(0x15)
#define FM31L278_SERIAL_NUMBYTE5 	(0x16)
#define FM31L278_SERIAL_NUMBYTE6 	(0x17)
#define FM31L278_SERIAL_NUMBYTE7	(0x18)

#define FM31L278_CAL_CONTROL_BIT_nOSCEN		(1 << 7) // Osciallator enabled 
#define FM31L278_RTC_CONTROL_BIT_CF			(1 << 6) // Century overflow 
#define FM31L278_RTC_CONTROL_BIT_CAL		(1 << 2) // Calibration mode 
#define FM31L278_RTC_CONTROL_BIT_WRITE		(1 << 1) // W=1 -> write mode W=0 normal 
#define FM31L278_RTC_CONTROL_BIT_READ		(1 << 0) // R=1 -> read mode R=0 normal

#define FM31L278_CLOCK_REGS 		7
#define FM31L278_COUNTER_REGS 		4
#define FM31L278_SERIAL_REGS 		8

#define FM31L278_MODE_NORMAL		0
#define FM31L278_MODE_WRITE			1
#define FM31L278_MODE_READ			2
// ====================================================================== //


// ====================================================================== //
// 		Global Structure 
// ---------------------------------------------------------------------- //
struct RTC_Time{
	unsigned char sec;
	unsigned char min;
	unsigned char hour;
	unsigned char week_day;
	unsigned char day;
	unsigned char month;
	unsigned char year;
};

extern volatile struct RTC_Time s_RTC;
// ====================================================================== //

// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void FM31L278_WriteRTC(Uint16 slave_addr, Uint16 addr, Uint16 data);
void FM31L278_ReadRTC(Uint16 slave_addr, Uint16 addr, unsigned char* pData);
void FM31L278_ReadRTCs(Uint16 slave_addr, Uint16 addr, Uint16 nbyte, unsigned char* pData);
void FM31L278_ModeRTC(Uint16 mode);
void FM31L278_ReadByte(Uint16 addr, unsigned char* pData);
void FM31L278_WriteByte(Uint16 addr, unsigned char *pdata);

void Read_RTC(void);
void Write_RTC (void);
void RTC_Init (void);
// ====================================================================== //



	
#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of MAIN_DSP_RTC_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //

