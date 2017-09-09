// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_Sensor_Monitor.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for Engine Sensor monitoring.
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-05-02:	Draft
//		2011-05-20: XINT1,3,4,5,6 Register and ISR added (TDC, Phase, Speed)
//		2011-05-23: eCAP5, eCAP6 Register Setting and ISR added. (Flywheel)
// ====================================================================== //


#ifndef MAIN_DSP_SENSOR_MONITOR_H
#define MAIN_DSP_SENSOR_MONITOR_H


#ifdef __cplusplus
extern "C" {
#endif


// ====================================================================== //
// 		Macro 
// ---------------------------------------------------------------------- //


// ----- eCAP register control -----

//	1. ECCTL1	(eCAP Control Register 1)
//		CAPxPOL		(Capture Event Polarity)
#define ECAP_RISING_EDGE			0x0
#define ECAP_FALLING_EDGE			0x1

//		CTRRSTx 	(Counter Reset on Capture Event)
#define ECAP_ABSOLUTE_MODE			0x0
#define ECAP_DIFFERENCE_MODE		0x1

//		PRESCALE	(Event Filter Prescale)
#define ECAP_PRESCALE(VAL)			(unsigned int)(VAL>>1)

//	2. ECCTL2 (eCAP Control Register 2)
//		CONT/ONESHT	(Continuous or One-shot mode control)
#define ECAP_CONTINUOUS				0x0
#define ECAP_ONESHOT				0x1

//		STOP_WRAP	(Stop value for One-shot mode)
#define ECAP_EVENT1					0x0
#define ECAP_EVENT2					0x1
#define ECAP_EVENT3					0x2
#define ECAP_EVENT4					0x3

//		RE-ARM		(One-shot Re-Arming Control)
#define ECAP_RE_ARM					0x1

//		TSCTRSTOP	(Time Stamp(TSCTR) Counter Stop (freeze) Control)
#define ECAP_STOP					0x0
#define ECAP_FREE_RUN				0x1

//		SYNCI_EN	(Counter (TSCTR) Sync-In)
#define ECAP_SYNC_IN_DISABLE		0x0
#define ECAP_SYNC_IN_ENABLE			0x1

//		SYNCO_SEL	(Sync-Out)
#define ECAP_SYNC_IN				0x0
#define ECAP_CTR_PRD				0x1
#define ECAP_SYNC_OUT_DISABLE		0x2

// 		CAP/APWM	(Capture/APWM operating mode)
#define ECAP_CAP_MODE				0x0
#define ECAP_APWM_MODE				0x1

//		APWMPOL		(APWM output polarity)
#define EC_ACTV_HI 					0x0
#define EC_ACTV_LO					0x1

//	3. ECAP Generic
#define ECAP_DISABLE				0x0
#define ECAP_ENABLE					0x1
#define ECAP_FORCE					0x1
#define ECAP_INT_ENABLE				0x1

		
// ====================================================================== //





// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void Sensor_Monitor_GPIO_Init (void);
void eCAP_Reg_Init(unsigned int prescale);
interrupt void TDC_Major_ISR (void);
interrupt void TDC_Redundancy_ISR (void);
interrupt void Phase_Major_ISR (void);
interrupt void Phase_Redundancy_ISR (void);
interrupt void Speed_INT_ISR (void);
void Sensor_Monitor_Interrupt_Init (void);
void Sensor_Monitor_Init (void);
void XINT_Reg_Init (void);
// ====================================================================== //



	
#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of MAIN_DSP_SENSOR_MONITOR_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //

