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



// ====================================================================== //
//	Includes
// ====================================================================== //
#include "Main_DSP_main.h"
// ====================================================================== //



// ====================================================================== //
//	Macro
// ====================================================================== //

// ====================================================================== //



// ====================================================================== //
//	Global Variables
// ====================================================================== //
Uint32 Timer0TickCount = 0;	// Counter Timer0 ISR execution
Uint16 Main_LoopCount = 0;

// EFI Control
Uint16 EFI_CMD_Data  = 1;		// EFI Control Starts at First Cylinder.

int EFI_All_Control_Time = 0;
int Padding_Time[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

// EFI Cynlinder On Time (us -> User can control by Timer0 ISR frequency - parameter.h)
int EFI_CMD_Time = 0;
int Lead_EFI_Time = 0;
int EFI_On_Control_Time[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int EFI_Off_Control_Time[12] = {38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38};


// Memory BIT 
int mem_test_result1 = 0;
int mem_test_result2 = 0;
int mem_test_result3 = 0;
int mem_test_result4 = 0;
int mem_test_result5 = 0;
int mem_test_result6 = 0;
int mem_test_result7 = 0;

// RTC Test 
int RTC_Write = 0;

// DAC Test
float data_mA = 10.0;
float  data_V = 0;

// Board Channel Test
Uint16 Board_Ch = 0;
// ====================================================================== //



// ====================================================================== //
//	Function Declararion
// ====================================================================== //
void Main_DSP_Init (void);
interrupt void Timer0_ISR(void);
// ====================================================================== //



// ====================================================================== //
//	Main Function
// ---------------------------------------------------------------------- //
void main (void)
{
	// ====================================================================== //
	//	Local Variables
	// ---------------------------------------------------------------------- //
	Uint16 i = 0;
	// ====================================================================== //

	
	// ====================================================================== //
	//	Initialize Main DSP
	// ---------------------------------------------------------------------- //
	Main_DSP_Init();
	// ====================================================================== //
	

	// ====================================================================== //
	//	Infinite Loop
	// ---------------------------------------------------------------------- //

	// Memory BIT Error Count Reset.
	s_BIT_Info.Mem_BIT_Err_Count = 0;

	Printf("\n\r\n\r ===== Main DSP Program Running ===== \n\r ");

	for(;;)
	{
		Main_LoopCount++;

		Board_Ch = KEY_IN;

		DELAY_US(100000);

		STATUS_LED = ~Main_LoopCount;

		DELAY_US(100000);

		
		// ====================================================================== //
		//	Memory BIT(Built In Test)
		// ---------------------------------------------------------------------- //
		Printf("\n\r- Test Count: %d", Main_LoopCount);
		Printf("\n\r- Total Error Count: %d", s_BIT_Info.Mem_BIT_Err_Count);
		
		
		// SRAM Test
		mem_test_result1 = Memory_BIT(SRAM_BASE, SRAM_SIZE);

		// DPRAM Test
		mem_test_result2 = Memory_BIT(DPRAM_STR_BASE, DPRAM_STR_SIZE);
		mem_test_result3 = Memory_BIT(DPRAM_M_BASE, DPRAM_M_SIZE);
		mem_test_result4 = Memory_BIT(DPRAM_2808_BASE, DPRAM_2808_SIZE);		

		// Speed RAM is NOT implemented yet.
		//mem_test_result5 = Memory_BIT(SPEED_BASE, SPEED_SIZE);
		

		// Flash memory can be written only about 10,000 times. 
		// Therefore, DO NOT test FRAM BIT many times.
		//mem_test_result6 = Memory_BIT(FRAM1_BASE, FRAM_SIZE);
		//mem_test_result7 = Memory_BIT(FRAM2_BASE, FRAM_SIZE);

		
		if ( (mem_test_result1 + mem_test_result2 + mem_test_result3 + mem_test_result4 +\
			mem_test_result5 + mem_test_result6 + mem_test_result7) != 0)
		{
			Printf("\n\r- Test Result = FAIL!!!\n\r");
		}
		else
		{
			Printf("\n\r- Test Result = PASS!!!\n\r");
		}
		// ====================================================================== //
		

		/*
		// ====================================================================== //
		//	ADC In Test
		// ---------------------------------------------------------------------- //
		ADC_Update();
		DELAY_US(6000);
		// ====================================================================== //
		*/


		
		// ====================================================================== //
		//	ADC Out Test
		// ---------------------------------------------------------------------- //
		//AD_DA_CTRL = 0xFFFF;
		//AD_DA_CTRL = 0x0000;
		//DAC_Trigger(ch);
		//DAC_CS(1);
		//DAC_Out (ch, data);
		for(i=1; i<=15; i++)
		{
			DAC_Out_mA (i, data_mA);
		}

		DAC_Out_V(data_V);
		// ====================================================================== //
		

		

		
		// ====================================================================== //
		//	RTC Test
		// ---------------------------------------------------------------------- //
		if (RTC_Write == 1)
		{
			Write_RTC();
			DELAY_US(100);
		}
		else
		{
			Read_RTC();
		}
		// ====================================================================== //
		
		

		/*
		// ====================================================================== //
		//	DI/DO Test
		// ---------------------------------------------------------------------- //
		DI_Update();
		DO_Update();
		// ====================================================================== //
		*/
		
	}
	// ====================================================================== //
}
// ====================================================================== //




// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function:	Timer0_ISR
//		- Interrupt Service Routine of Timer0 
//		- User can adjust Timer0 interupt frequency by editing 
//		  TIMER0_ISR_FREQUENCY macro in Main_DSP_Parameter.h. 				
// ---------------------------------------------------------------------- //
interrupt void Timer0_ISR(void)
{
	Uint16 Injection_Cycle = 0;
	int i = 0;
	int j = 0;
	
	// 100us Timer0 interrupt 
	Timer0TickCount++;
	
	
	// ====================================================================== //
	// EFI Injection Control
	// ---------------------------------------------------------------------- //

	// Calculate Padding time for each injection cycle.
	for (i=0; i<12 ;i++ )
	{
		Padding_Time[i] = 0;
		for (j=0; j<i; j++)
		{
			// Before Decide the EFI off time, EFI off time shuld NOT be before the EFI On time.
			// If User setting Wrong EFI off time value, the EFI Off time will be zero(0).
			if ( (EFI_On_Control_Time[j] + EFI_Off_Control_Time[j]) < 0)
			{
				EFI_Off_Control_Time[j] = 0;
			}

			// Padding Time is Sum of EFI On/Off Time util last injection cycle.
			Padding_Time[i] = Padding_Time[i] + EFI_On_Control_Time[j] +  EFI_Off_Control_Time[j];
		}
	}

	// Change the injection cycle.
	for (Injection_Cycle=0; Injection_Cycle<12; Injection_Cycle++ )
	{
		// Setting EFI Injection control by Timer0.
		if ( EFI_CMD_Time < Padding_Time[Injection_Cycle] )
		{
			// Clear the EFI injection bit to turn off the cycle.
			EFI_CMD_Data = (EFI_CMD_Data & (0xFFFF - (1<<Injection_Cycle)));
		}
		else if ( (EFI_CMD_Time >= Padding_Time[Injection_Cycle]) && \
					(EFI_CMD_Time < (Padding_Time[Injection_Cycle]+ EFI_On_Control_Time[Injection_Cycle])) )
		{
			// Set the EFI Injection bit to turn on the cycle.
			EFI_CMD_Data = (EFI_CMD_Data | (1<<Injection_Cycle) );
		}
		else if ( (EFI_Off_Control_Time[11]) < 0 && (Injection_Cycle == 1))
		{
			if ( EFI_CMD_Time >= (Padding_Time[11] + EFI_On_Control_Time[11] + EFI_Off_Control_Time[11]) )
			{
				EFI_CMD_Data = EFI_CMD_Data | 1;
				Lead_EFI_Time++;
			}
		}
		else
		{
			// Clear the EFI injection bit to turn off the cycle.
			EFI_CMD_Data = (EFI_CMD_Data & (0xFFFF - (1<<Injection_Cycle)));
		}
	}

	// Control EFI Injection Cylinder.
	EFI_CMD = EFI_CMD_Data;

	// Increase EFI Command Time.
	EFI_CMD_Time++;

	// If the EFI Command Time is over than whole EFI control time, set 0.
	EFI_All_Control_Time = 0;

	for (i=0; i<11 ;i++)
	{
		EFI_All_Control_Time = EFI_All_Control_Time + EFI_On_Control_Time[i] +  EFI_Off_Control_Time[i];
	}

	if ( EFI_Off_Control_Time[11] < 0 )
	{
		EFI_All_Control_Time = EFI_All_Control_Time + EFI_On_Control_Time[11];
	}
	else
	{
		EFI_All_Control_Time = EFI_All_Control_Time + EFI_On_Control_Time[11] +  EFI_Off_Control_Time[11];
	}


	if (EFI_CMD_Time >= EFI_All_Control_Time)
	{
		EFI_CMD_Time = Lead_EFI_Time;
		Lead_EFI_Time = 0;
	}
	// ====================================================================== //
	


	// ====================================================================== //
	// Main DSP Run LED Blink
	// ---------------------------------------------------------------------- //
	if (Timer0TickCount > 2500)
	{
		Timer0TickCount = 0;
		M_DSP_RUN_LED_Toggle();
	}
	// ====================================================================== //

	// Timer0 Interrupt Acknowledge.
	PieCtrlRegs.PIEACK.bit.ACK1 = 1;
}
// ====================================================================== //




// ====================================================================== //
//	Function: Main_DSP_Init
//		- Initialization Main DSP
// ---------------------------------------------------------------------- //
void Main_DSP_Init (void)
{
	// ====================================================================== //
	// Disable Global Interrupt
	// ---------------------------------------------------------------------- //
	DINT;
	IER = 0x0000;
	IFR = 0x0000;
	// ====================================================================== //

	// ====================================================================== //
	//	System Control Initialization
	// ---------------------------------------------------------------------- //
	// PLL, WatchDog, enable Peripheral Clock Initialization
	// DSP280x_SysCtrl.c
	//		1 Disables the watchdog
	//		2 Set the PLLCR for proper SYSCLKOUT frequency 
	//		3 Set the pre-scaler for the high and low frequency peripheral clocks
	//			( HISPCP = 0x0001 => High Peripheral clock = System Clock/2 = 75Mhz
	//			  LOSPCP = 0x0002 => Low Peripheral clock = System Clock/4	= 37.5Mhz)
	//		4 Enable the clocks to the peripherals
	// ---------------------------------------------------------------------- //
	InitSysCtrl();
	// ====================================================================== //
	

	// ====================================================================== //
	//	Initialize Interrupt
	// ---------------------------------------------------------------------- //
	InitPieCtrl();			// Initialize Peripheral Interrupt Expansion circuit
	InitPieVectTable();		// Pie Vector Table Re-allocation
	// ====================================================================== //

	
	// ====================================================================== //
	//	Interrupt and ISR setting
	// ---------------------------------------------------------------------- //
	EALLOW;
	// Timer0 ISR setting	
	PieVectTable.TINT0 = &Timer0_ISR;

	// Timer0 Interrupt vector setting
	PieCtrlRegs.PIEIER1.bit.INTx7 = 1;
	
	IER |= M_INT1;		// PIEIER1 Enable.
	EDIS;	
	// ====================================================================== //
	

	// ====================================================================== //
	//	Timer Initialization.
	// ---------------------------------------------------------------------- //
	InitCpuTimers(); 
	ConfigCpuTimer(&CpuTimer0, SYSTEM_FREQUENCY, (int)(1000000/TIMER0_ISR_FREQUENCY));
	StartCpuTimer0();
	// ====================================================================== //


	// ====================================================================== //
	// GPIO Initialization
	// ---------------------------------------------------------------------- //
	GPIO_Init();
	// ====================================================================== //


	// ====================================================================== //
	// External Interface Initialization
	// ---------------------------------------------------------------------- //
	External_Interface_Init();
	// ====================================================================== //
	
	
	// ====================================================================== //
	// TDC, Phase, Speed Sensor Monitor Initialization
	// ---------------------------------------------------------------------- //
	Sensor_Monitor_Init();
	// ====================================================================== //

	
	// ====================================================================== //
	// Debug COM Initialization
	// ---------------------------------------------------------------------- //
	Debug_SCI_Init(DEFAULT_SCI_C_BAUD);
	Debug_SCI_Interrupt_Init();
	// ====================================================================== //

	
	// ====================================================================== //
	// McBSP Communication Initialization.
	// ---------------------------------------------------------------------- //
	McBSP_Init_SPI();
	// ====================================================================== //
	

	
	// ====================================================================== //
	// ADC and DAC Initialization.
	// ---------------------------------------------------------------------- //
	u_AD_DA_Ctrl.all = 0xFFFF;
	AD_DA_CTRL = u_AD_DA_Ctrl.all;	// All ADC and DAC CS should be High when they are initialized.
	
	ADC_Init();
	DAC_Init();
	// ====================================================================== //
	
	

	
	// ====================================================================== //
	// I2C Initialization
	// ---------------------------------------------------------------------- //
	Init_I2CA();
	// ====================================================================== //
	


	
	// ====================================================================== //
	// I2C Initialization
	// ---------------------------------------------------------------------- //
	RTC_Init();
	// ====================================================================== //
	

	
	// ====================================================================== //
	// DI/DO Initialization
	// ---------------------------------------------------------------------- // 
	s_Main_DIO.DI.M1.all = 0x0000;
	s_Main_DIO.DI.M2.all = 0x0000;
	s_Main_DIO.DO.M1.all = 0x0000;
	s_Main_DIO.DO.M2.all = 0x0000;
	DI_Update();
	DO_Update();
	// ====================================================================== //
	
	
	// ====================================================================== //
	// Enable global Interrupts and higher priority real-time debug events:
	// ---------------------------------------------------------------------- //
	EINT;   // Enable Global interrupt INTM
	ERTM;   // Enable Global realtime interrupt DBGM
	// ====================================================================== //
	
}
// ====================================================================== //




// ====================================================================== //
// End of file.
// ====================================================================== //


