// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_Sensor_Monitor.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		1. Source file for Engine Sensor monitoring.
//		2. TDC, Phase, Speed sensors use external interrupts.
//		3. Flywheel position sensors use eCAP module.
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-05-02:	Draft
// ====================================================================== //


// ====================================================================== //
//	Includes
// ---------------------------------------------------------------------- //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"

#include "Main_DSP_External_Interface.h"
#include "Main_DSP_Sensor_Monitor.h"
#include "Main_DSP_Analog_Input.h"   
//#include "Main_DSP_Parameter.h" 
// ====================================================================== //

// ====================================================================== //
//	Global Variables
// ---------------------------------------------------------------------- //
Uint32 TDC_M_ISR_Count = 0;
Uint32 TDC_R_ISR_Count = 0;
Uint32 Phase_M_ISR_Count = 0;
Uint32 Phase_R_ISR_Count = 0;
Uint32 Speed_INT_ISR_Count = 0;

//Uint32 Flywheel_M_ISR_Count = 0;
Uint32 Flywheel_R_ISR_Count = 0;

float store_speed[50];
long sub_speed[8];
float temp_speed = 0.0;
long temp_sub_speed = 0.0;
long real_speed = 0.0;


Uint16 index1 = 0;
Uint16 index2 = 0;
Uint16 size = 50;
Uint16 i;
Uint16 j;
Uint16 z = 0;
Uint16 flag = 0;

long SOGAV_M_ISR_OPEN_Count=0;
long SOGAV_M_ISR_CLOSE_Count=0;

int status_phase_m = 0;
int test = 0;
int test_count_1 = 0;
int test_count_2 = 0;
int Moving_average_ready = 0;
int Moving_average_factor =30;
volatile float Speed_Average = 0.0;
// ====================================================================== //

extern void Set_SOGAV_command(void);

// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function: Sensor_Monitor_GPIO_Init
//		- Initialization GPIO port for Sensor Monitoring
// ---------------------------------------------------------------------- //
void Sensor_Monitor_GPIO_Init (void)
{
	EALLOW;

	// TDC Major sensor pin is connected DSP GPIO 27
	GpioCtrlRegs.GPAMUX2.bit.GPIO27 = 0;		// GPIO27
	GpioDataRegs.GPADAT.bit.GPIO27 = 0;			// GPIO 07 = 0
	GpioCtrlRegs.GPADIR.bit.GPIO27 = 0;			// input
	GpioCtrlRegs.GPAQSEL2.bit.GPIO27 = 2;		// XINT1 Qualification using 6samples (6.67ns*6 = 40ns)

	// TDC Redundancy sensor pin is connected DSP GPIO 54
	GpioCtrlRegs.GPBMUX2.bit.GPIO54 = 0;		// GPIO54
	GpioDataRegs.GPBDAT.bit.GPIO54 = 0;			// GPIO 54 = 0
	GpioCtrlRegs.GPBDIR.bit.GPIO54 = 0;			// input
	GpioCtrlRegs.GPBQSEL2.bit.GPIO54 = 0;		// XINT3 Qualification using 6samples (6.67ns*6 = 40ns)

	// Phase Major sensor pin is connected DSP GPIO 55
	GpioCtrlRegs.GPBMUX2.bit.GPIO55 = 0;		// GPIO55
	GpioDataRegs.GPBDAT.bit.GPIO55 = 0;			// GPIO 55 = 0
	GpioCtrlRegs.GPBDIR.bit.GPIO55 = 0;			// input
	GpioCtrlRegs.GPBQSEL2.bit.GPIO55 = 2;		// XINT4 Qualification using 6samples (6.67ns*6 = 40ns)

	// Phase Redundancy sensor pin is connected DSP GPIO 56
	GpioCtrlRegs.GPBMUX2.bit.GPIO56 = 0;		// GPIO56
	GpioDataRegs.GPBDAT.bit.GPIO56 = 0;			// GPIO 56 = 0
	GpioCtrlRegs.GPBDIR.bit.GPIO56 = 0;			// input
	GpioCtrlRegs.GPBQSEL2.bit.GPIO56 = 2;		// XINT5 Qualification using 6samples (6.67ns*6 = 40ns)

	// Speed Interrupt pin is connected DSP GPIO 57
	GpioCtrlRegs.GPBMUX2.bit.GPIO57 = 0;		// GPIO57
	GpioDataRegs.GPBDAT.bit.GPIO57 = 0;			// GPIO 57 = 0
	GpioCtrlRegs.GPBDIR.bit.GPIO57 = 0;			// input
	GpioCtrlRegs.GPBQSEL2.bit.GPIO57 = 2;		// XINT5 Qualification using 6samples (6.67ns*6 = 40ns)

	// Flywheel Major Position sensor pin is Connected DSP GPIO 48 (eCAP5)
	GpioCtrlRegs.GPBMUX2.bit.GPIO48 = 1;		// eCAP5
	GpioDataRegs.GPBDAT.bit.GPIO48 = 0;			// GPIO 48 = 0
	GpioCtrlRegs.GPBDIR.bit.GPIO48 = 0;			// input

	// Flywheel Redundancy Position sensor pin is connected DSP GPIO 49 (eCAP6)
	GpioCtrlRegs.GPBMUX2.bit.GPIO49 = 1;		// eCAP6
	GpioDataRegs.GPBDAT.bit.GPIO49 = 0;			// GPIO 49 = 0
	GpioCtrlRegs.GPBDIR.bit.GPIO49 = 0;			// input
	
	EDIS;	
}
// ====================================================================== //




// ====================================================================== //
//	Function: eCAP_Reg_Init
//		- eCAP register initialization for flywheel position sensors.
// ---------------------------------------------------------------------- //
void eCAP_Reg_Init(unsigned int prescale) // prescale value MUST be even number between 0 ~ 62.
{
	EALLOW;

	// ----- eCAP5 Reg Initialization ----- //
	ECap5Regs.ECEINT.all = 0x0000;								// Disable all capture interrupts
	ECap5Regs.ECCLR.all = 0xFFFF;								// Clear all CAP interrupt flags
	ECap5Regs.ECCTL1.bit.CAPLDEN = ECAP_DISABLE;    			// Disable CAP1-CAP4 register loads
	ECap5Regs.ECCTL2.bit.TSCTRSTOP = ECAP_STOP;					// Make sure the counter is stopped

	// Configure peripheral registers
	ECap5Regs.ECCTL1.bit.PRESCALE = ECAP_PRESCALE(prescale);	// Event filter presclae

	ECap5Regs.ECCTL2.bit.CAP_APWM = ECAP_CAP_MODE;				// Capture mode
	ECap5Regs.ECCTL2.bit.CONT_ONESHT = ECAP_CONTINUOUS;			// Continuous mode

	ECap5Regs.CAP1 = 0;											// Reset CAP1 value
	ECap5Regs.CAP2 = 0;											// Reset CAP2 value
	ECap5Regs.CAP3 = 0;											// Reset CAP3 value
	ECap5Regs.CAP4 = 0;											// Reset CAP4 value	
	
	ECap5Regs.ECCTL1.bit.CAP1POL = ECAP_RISING_EDGE;			// Rising edge
	ECap5Regs.ECCTL1.bit.CAP2POL = ECAP_RISING_EDGE;			// Rising edge
	ECap5Regs.ECCTL1.bit.CAP3POL = ECAP_RISING_EDGE;			// Rising edge
	ECap5Regs.ECCTL1.bit.CAP4POL = ECAP_RISING_EDGE;			// Rising edge
	
	ECap5Regs.ECCTL1.bit.CTRRST1 = ECAP_DIFFERENCE_MODE;		// Difference Mode         
	ECap5Regs.ECCTL1.bit.CTRRST2 = ECAP_DIFFERENCE_MODE;		// Difference Mode         
	ECap5Regs.ECCTL1.bit.CTRRST3 = ECAP_DIFFERENCE_MODE;		// Difference Mode         
	ECap5Regs.ECCTL1.bit.CTRRST4 = ECAP_DIFFERENCE_MODE;		// Difference Mode   
	
	ECap5Regs.ECEINT.bit.CEVT1 = ECAP_INT_ENABLE;				// Capture event 1 occurs eCAP interrupt
	ECap5Regs.ECEINT.bit.CEVT2 = ECAP_INT_ENABLE;				// Capture event 2 occurs eCAP interrupt
	ECap5Regs.ECEINT.bit.CEVT3 = ECAP_INT_ENABLE;				// Capture event 3 occurs eCAP interrupt
	ECap5Regs.ECEINT.bit.CEVT4 = ECAP_INT_ENABLE;				// Capture event 4 occurs eCAP interrupt
	
	ECap5Regs.ECCTL2.bit.SYNCI_EN = ECAP_SYNC_IN_DISABLE;		// Disable sync in
	ECap5Regs.ECCTL2.bit.SYNCO_SEL = ECAP_SYNC_OUT_DISABLE;		// Disable sync out


	// ----- eCAP6 Reg Initialization ----- //
	ECap6Regs.ECEINT.all = 0x0000;								// Disable all capture interrupts
	ECap6Regs.ECCLR.all = 0xFFFF;								// Clear all CAP interrupt flags
	ECap6Regs.ECCTL1.bit.CAPLDEN = ECAP_DISABLE;    			// Disable CAP1-CAP4 register loads
	ECap6Regs.ECCTL2.bit.TSCTRSTOP = ECAP_STOP;					// Make sure the counter is stopped

	// Configure peripheral registers
	ECap6Regs.ECCTL1.bit.PRESCALE = ECAP_PRESCALE(prescale);	// Event filter presclae

	ECap6Regs.ECCTL2.bit.CAP_APWM = ECAP_CAP_MODE;				// Capture mode
	ECap6Regs.ECCTL2.bit.CONT_ONESHT = ECAP_CONTINUOUS;			// Continuous mode

	ECap6Regs.CAP1 = 0;											// Reset CAP1 value
	ECap6Regs.CAP2 = 0;											// Reset CAP2 value
	ECap6Regs.CAP3 = 0;											// Reset CAP3 value
	ECap6Regs.CAP4 = 0;											// Reset CAP4 value	
	
	ECap6Regs.ECCTL1.bit.CAP1POL = ECAP_RISING_EDGE;			// Rising edge
	ECap6Regs.ECCTL1.bit.CAP2POL = ECAP_RISING_EDGE;			// Rising edge
	ECap6Regs.ECCTL1.bit.CAP3POL = ECAP_RISING_EDGE;			// Rising edge
	ECap6Regs.ECCTL1.bit.CAP4POL = ECAP_RISING_EDGE;			// Rising edge
	
	ECap6Regs.ECCTL1.bit.CTRRST1 = ECAP_DIFFERENCE_MODE;		// Difference Mode         
	ECap6Regs.ECCTL1.bit.CTRRST2 = ECAP_DIFFERENCE_MODE;		// Difference Mode         
	ECap6Regs.ECCTL1.bit.CTRRST3 = ECAP_DIFFERENCE_MODE;		// Difference Mode         
	ECap6Regs.ECCTL1.bit.CTRRST4 = ECAP_DIFFERENCE_MODE;		// Difference Mode   
	
	ECap6Regs.ECEINT.bit.CEVT1 = ECAP_INT_ENABLE;				// Capture event 1 occurs eCAP interrupt
	ECap6Regs.ECEINT.bit.CEVT2 = ECAP_INT_ENABLE;				// Capture event 2 occurs eCAP interrupt
	ECap6Regs.ECEINT.bit.CEVT3 = ECAP_INT_ENABLE;				// Capture event 3 occurs eCAP interrupt
	ECap6Regs.ECEINT.bit.CEVT4 = ECAP_INT_ENABLE;				// Capture event 4 occurs eCAP interrupt
	
	ECap6Regs.ECCTL2.bit.SYNCI_EN = ECAP_SYNC_IN_DISABLE;		// Disable sync in
	ECap6Regs.ECCTL2.bit.SYNCO_SEL = ECAP_SYNC_OUT_DISABLE;		// Disable sync-out


	// ----- eCAP5 Start ----- //
	ECap5Regs.ECCTL2.bit.TSCTRSTOP = ECAP_FREE_RUN;				// Start Counter
	ECap5Regs.ECCTL1.bit.CAPLDEN = ECAP_ENABLE;					// Enable CAP1-CAP4 register loads

	// ----- eCAP6 Start ----- //
	ECap6Regs.ECCTL2.bit.TSCTRSTOP = ECAP_FREE_RUN;				// Start Counter
	ECap6Regs.ECCTL1.bit.CAPLDEN = ECAP_ENABLE;					// Enable CAP1-CAP4 register loads

	EDIS;
}
// ====================================================================== //



// ====================================================================== //
//	Function: XINT_Reg_Init
//		- External Interrupt initialization.
// ---------------------------------------------------------------------- //
void XINT_Reg_Init (void)
{
	EALLOW;	

	// Step 4. Assign External Interrupt Pins.
	GpioIntRegs.GPIOXINT1SEL.bit.GPIOSEL = 27;	// GPIO 27 is XINT1
	GpioIntRegs.GPIOXINT3SEL.bit.GPIOSEL = 54;	// GPIO 54 is XINT3
	GpioIntRegs.GPIOXINT4SEL.bit.GPIOSEL = 55;	// GPIO 55 is XINT4
	GpioIntRegs.GPIOXINT5SEL.bit.GPIOSEL = 56;	// GPIO 56 is XINT5
	GpioIntRegs.GPIOXINT6SEL.bit.GPIOSEL = 57;	// GPIO 57 is XINT5

	// Step 5. Setting Event Conditions of XINT1, XINT3, XINT4, XINT5 and XINT6.
	XIntruptRegs.XINT1CR.bit.POLARITY = 1;		// XINT1 is Rising edge Interrupt
	XIntruptRegs.XINT3CR.bit.POLARITY = 1;		// XINT3 is Rising edge Interrupt
	XIntruptRegs.XINT4CR.bit.POLARITY = 1;		// XINT4 is Rising edge Interrupt
	XIntruptRegs.XINT5CR.bit.POLARITY = 1;		// XINT5 is Rising edge Interrupt
	XIntruptRegs.XINT6CR.bit.POLARITY = 1;		// XINT6 is Rising edge Interrupt


	// Step 6. Enable XINT1, XINT3, XINT4, XINT5 and XINT6.
	XIntruptRegs.XINT1CR.bit.ENABLE = 1;        // Enable XINT1
	XIntruptRegs.XINT3CR.bit.ENABLE = 1;        // Enable XINT3
	XIntruptRegs.XINT4CR.bit.ENABLE = 1;        // Enable XINT4
	XIntruptRegs.XINT5CR.bit.ENABLE = 1;        // Enable XINT5
	XIntruptRegs.XINT6CR.bit.ENABLE = 1;        // Enable XINT6

	EDIS;
}
// ====================================================================== //


// ====================================================================== //
//	Function: TDC_Major_ISR
//		- Interrupt Service routine of XINT1
// ---------------------------------------------------------------------- //
interrupt void TDC_Major_ISR (void)
{
	// !!!!! Do Somthing..... !!!!! - for Test//
//	DI_LED1 = 0xff;

	TDC_M_ISR_Count++;

	// ===============================================================
	// TDC 신호는 360도에 한번 들어오므로 720도 기준으로 사용하기 위해서
	// phase 신호를 활용하는 루틴임. 현재는 phase 신호가 없어서 임의로 만듬
	// 차후에는 phase 신호를 활용함.
	// Crank_angle 초기화 루틴.
	//
	if(status_phase_m == TRUE)
	{
		status_phase_m = FALSE;
//			DI_LED1 = 0xff;          //TDC 신호 확인용 LED ON/OFF

		Crank_angle = 0;             //Crank_angle initialization
		Flywheel_M_ISR_Count = 0;  // 초기화
		TDC_start_flag = TRUE ;     // TDC 와  flywheel 간의 각도차 보정 루틴을 위한 flag
	}
	else
	{
		status_phase_m = TRUE;
//			DI_LED1 = 0x00;
	}
	//-----------------------------------------------------------------

	// XINT1 Interrupt Acknowledge.
	PieCtrlRegs.PIEACK.bit.ACK1 = 1;
}
// ====================================================================== //



// ====================================================================== //
//	Function: TDC_Redundancy_ISR
//		- Interrupt Service routine of XINT3
// ---------------------------------------------------------------------- //
interrupt void TDC_Redundancy_ISR (void)
{
	// !!!!! Do Somthing..... !!!!! - for Test//
//	DI_LED2 = 0xff;

	TDC_R_ISR_Count++;
	
	// XINT4 Interrupt Acknowledge.
	PieCtrlRegs.PIEACK.bit.ACK12 = 1;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Phase_Major_ISR
//		- Interrupt Service routine of XINT4
// ---------------------------------------------------------------------- //
interrupt void Phase_Major_ISR (void)
{
	// !!!!! Do Somthing..... !!!!! - for Test//
//	DO_LED1 = 0xff;

	//---------------------- Edited by Automation Dep. ------------------ //
	//======================================================================
	TDC_start_flag = TRUE;   // TDC 인터럽트 활성화
	//======================================================================

	Phase_M_ISR_Count++;
	
	// XINT4 Interrupt Acknowledge.
	PieCtrlRegs.PIEACK.bit.ACK12 = 1;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Phase_Redundancy_ISR
//		- Interrupt Service routine of XINT5
// ---------------------------------------------------------------------- //
interrupt void Phase_Redundancy_ISR (void)
{
	// !!!!! Do Somthing..... !!!!! - for Test//
//	DO_LED2 = 0xff;

	Phase_R_ISR_Count++;
	
	// XINT5 Interrupt Acknowledge.
	PieCtrlRegs.PIEACK.bit.ACK12 = 1;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Speed_INT_ISR
//		- Interrupt Service routine of XINT6
// ---------------------------------------------------------------------- //
interrupt void Speed_INT_ISR (void)
{
	// !!!!! Do Somthing..... !!!!! - for Test//
//	DI_LED1 = 0x00;
//	DI_LED2 = 0x00;
//	DO_LED1 = 0x00;
//	DO_LED2 = 0x00;

	Speed_INT_ISR_Count++;
	
	// XINT6 Interrupt Acknowledge.
	PieCtrlRegs.PIEACK.bit.ACK12 = 1;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Flywheel_Major_ISR
//		- Interrupt Service routine of eCAP5
// ---------------------------------------------------------------------- //
interrupt void Flywheel_Major_ISR (void)
{
		unsigned long * ip;
	unsigned long temp;

	ip = (unsigned long *)(SPEED_BASE);

	temp = *ip;

	// 직전 타임  속도 카운터 값 (20MHz pulse count x2) - 
/// 	Period_time_b1 = temp*2;			// Period_time_b1 : 직전 타임 펄스 주기 카운터 수, 20MHz임
	Period_time_b1 = temp;			// Period_time_b1 : 직전 타임 펄스 주기 카운터 수, 20MHz임
			
		//Measured_Speed = (float)((int32)4000000/(int32)Period_time_b1);
	Measured_Speed_temp = (60.0*20000000.0)/(Period_time_b1*stSetup.PickupToothNo);//(1.0/Period_time_b1*0.000000005)*stSetup.PickupToothNo;

 
 // Moving average 알고리즘 : 50개 평균값 루틴   // 수정해야 할 항목 
//	for( z=49 ; z>0 ; z-- )
//	{
//		store_speed[z] = store_speed[z-1];
//	}
	store_speed[Moving_average_ready%Moving_average_factor] =Measured_Speed_temp;

	Moving_average_ready++;
	if( Moving_average_ready >= Moving_average_factor )		// 최초 12msec는 Speed_Average값이 무의미함 
	{
		temp_speed = 0.0;
		for( z=0 ; z<Moving_average_factor ; z++ )
		{
			temp_speed += store_speed[z];   // 저장된 50개의 속도값 모두 더한다.
		}
		Speed_Average =( temp_speed*1.0/((float)Moving_average_factor));  // 50개의 평균을 계산한다.

		Measured_Speed =Speed_Average;
		if (Moving_average_ready > 5000) Moving_average_ready=Moving_average_factor;

	}
	else Measured_Speed=Measured_Speed_temp;


	// !!!!! Do Somthing..... !!!!! - for Test//
	Flywheel_M_ISR_Count++;

	// Clear Intrrupt eCAP5 Flag
	if (ECap5Regs.ECFLG.bit.CEVT1 == 1)
	{
		ECap5Regs.ECCLR.bit.CEVT1 = 1;
	}
	else if (ECap5Regs.ECFLG.bit.CEVT2 == 1)
	{
		ECap5Regs.ECCLR.bit.CEVT2 = 1;
	}
	else if (ECap5Regs.ECFLG.bit.CEVT3 == 1)
	{
		ECap5Regs.ECCLR.bit.CEVT3 = 1;
	}
	else if (ECap5Regs.ECFLG.bit.CEVT4 == 1)
	{
		ECap5Regs.ECCLR.bit.CEVT4 = 1;
	}
	
	ECap5Regs.ECCLR.bit.INT = 1;


	if (uiDeviceID == 1)  // SOGAV controlll
	{
		//--------------------- Edited by Automation Dep. ----------------------- //
		//==========================================================================
		//------- SOGAV 밸브 제어 시간 계산 루틴 시작------------------------------------------------------------

		if(TDC_start_flag==TRUE)      //Crank_angle 계산 루틴임. TDC와 flywheel 간의 각도차이 보상루틴.
		{
			Crank_angle= Crank_angle + theta_zero_modify;   
			//theta_zero_modify : TDC와 flywheel 간의 각도차(degree) => 0으로 고정
			TDC_start_flag = FALSE;
		}
		else
		{
			Crank_angle=Crank_angle+delta_theta;   // delta_theta : 고정된 값임
		}

	    // SOGAV 밸브 start시점 판단 및 계산 루틴 - 각종 변수들은 Main_DSP_common.h에 선언되어 있음
		// Crank_angle과 SOGAV 밸브 오픈 각도가 불행히 같을 경우 실행 루틴
		if(fabs(Crank_angle - SOGAV_start_angle[SOGAV_No_of_cal_start]) < 0.00000001)  
		{	
			test_count_1++;
			Set_SOGAV_status = TRUE ;
			Set_SOGAV_command();
		}
		else if( Flywheel_M_ISR_Count == SOGAV_start_index[SOGAV_No_of_cal_start] )  // Flywheel_M_ISR_Count은 TDC발생 시 0으로 초기화됨
		{		
			test_count_2++;
			SOGAV_M_ISR_OPEN_Count++;
			
			//Calculated_time = (SOGAV_start_angle[SOGAV_No_of_cal_start]-Crank_angle)/delta_theta*Period_time_b1;    //직전 주기를 현재 주기와 같다고 놓고 계산한 식임.
			Calculated_time = (SOGAV_start_angle[SOGAV_No_of_cal_start]-Crank_angle)*0.833333*Period_time_b1;    //직전 주기를 현재 주기와 같다고 놓고 계산한 식임.
			Calculated_temp[SOGAV_No_of_cal_start] = Calculated_time;
			ConfigCpuTimer(&CpuTimer1, 150, (Calculated_time*0.05));    //계산된 밸브 오픈 까지의 시간에 따른 timer1 셋팅 
			// 150 = SYSTEM_FREQUENCY
			Set_SOGAV_status = TRUE;      //Set_SOGAV_status : SOGAV 밸브를 오픈해야 된다는 것을 알려주는 flag
			StartCpuTimer1();		
		} 

		 // SOGAV 밸브 close 시점 판단 및 계산 루틴 //
		if( Flywheel_M_ISR_Count == SOGAV_end_index[SOGAV_No_of_cal_end] )
		{
			//Calculated_time = (SOGAV_end_angle[SOGAV_No_of_cal_end]-Crank_angle)/delta_theta*Period_time_b1;
			Calculated_time = (SOGAV_end_angle[SOGAV_No_of_cal_end]-Crank_angle)*0.833333*Period_time_b1;
			ConfigCpuTimer(&CpuTimer1, 150, (Calculated_time*0.05));
			// 150 = SYSTEM_FREQUENCY
			Set_SOGAV_status = FALSE;
			StartCpuTimer1();
			SOGAV_M_ISR_CLOSE_Count++;
		}
		else if(Crank_angle == SOGAV_end_angle[SOGAV_No_of_cal_end])
		{
			Set_SOGAV_status = FALSE;
			Set_SOGAV_command();
		}
		//------- SOGAV 밸브 제어 시간 계산 루틴 끝------------------------------------------------------------
		//==========================================================================
	}

	// eCAP5 Interrupt Acknowledge.
	PieCtrlRegs.PIEACK.bit.ACK4 = 1;
}
// ====================================================================== //


// ====================================================================== //
//	Function: Flywheel_Redundancy_ISR
//		- Interrupt Service routine of eCAP6
// ---------------------------------------------------------------------- //
interrupt void Flywheel_Redundancy_ISR (void)
{
	// !!!!! Do Somthing..... !!!!! - for Test//
	Flywheel_R_ISR_Count++;


	// Clear Intrrupt eCAP6 Flag
	if (ECap6Regs.ECFLG.bit.CEVT1 == 1)
	{
		ECap6Regs.ECCLR.bit.CEVT1 = 1;
	}
	else if (ECap6Regs.ECFLG.bit.CEVT2 == 1)
	{
		ECap6Regs.ECCLR.bit.CEVT2 = 1;
	}
	else if (ECap6Regs.ECFLG.bit.CEVT3 == 1)
	{
		ECap6Regs.ECCLR.bit.CEVT3 = 1;
	}
	else if (ECap6Regs.ECFLG.bit.CEVT4 == 1)
	{
		ECap6Regs.ECCLR.bit.CEVT4 = 1;
	}
	
	ECap6Regs.ECCLR.bit.INT = 1;
	
	// eCAP6 Interrupt Acknowledge.
	PieCtrlRegs.PIEACK.bit.ACK4 = 1;
}
// ====================================================================== //




// ====================================================================== //
//	Function: Sensor_Monitor_Interrupt_Init
//		- Initialization interrupt setting for sensor monitoring
// ---------------------------------------------------------------------- //
void Sensor_Monitor_Interrupt_Init (void)
{
	EALLOW;

	// Step 1. XINT1, XINT3, XINT4 and XINT5 ISR Setting.
	PieVectTable.XINT1 = &TDC_Major_ISR;
	PieVectTable.XINT3 = &TDC_Redundancy_ISR;
	PieVectTable.XINT4 = &Phase_Major_ISR;
	PieVectTable.XINT5 = &Phase_Redundancy_ISR;
	PieVectTable.XINT6 = &Speed_INT_ISR;

	// Step 2. XINT1, XINT3, XINT4, XINT5 and XINT6 Interrupt vector Setting
	PieCtrlRegs.PIEIER1.bit.INTx4 = 1;		// XINT1
	PieCtrlRegs.PIEIER12.bit.INTx1 = 1;		// XINT3
	PieCtrlRegs.PIEIER12.bit.INTx2 = 1;		// XINT4
	PieCtrlRegs.PIEIER12.bit.INTx3 = 1;		// XINT5
	PieCtrlRegs.PIEIER12.bit.INTx4 = 1;		// XINT6

	// Step 3. PIEIER1 and PIEIER12 Enable.
	IER |= M_INT1;
	IER |= M_INT12;
	
	// Step 4. eCAP5, eCAP6 ISR Setting
	PieVectTable.ECAP5_INT = &Flywheel_Major_ISR;
	PieVectTable.ECAP6_INT = &Flywheel_Redundancy_ISR;

	// Step 5. eCAP5, eCAP6 Interrupt vector Setting
	PieCtrlRegs.PIEIER4.bit.INTx5 = 1;		// eCAP5
	PieCtrlRegs.PIEIER4.bit.INTx6 = 1;		// eCAP6

	// Step 6. PIEIER4 Enable.
	IER |= M_INT4;
	
	EDIS;	
}
// ====================================================================== //




// ====================================================================== //
//	Function: Sendor_Monitor_Init
//		- Initialization Sensor Monitor
// ---------------------------------------------------------------------- //
void Sensor_Monitor_Init (void)
{
	Sensor_Monitor_GPIO_Init();
	eCAP_Reg_Init(0);
	XINT_Reg_Init();
	Sensor_Monitor_Interrupt_Init();
}
// ====================================================================== //




// ====================================================================== //
// End of file.
// ====================================================================== //








