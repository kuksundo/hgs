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
#include "TMR.h"
#include "pid_reg3.h"
#include "test.h"
// ====================================================================== //

#define DelayTimeConstant  100

// ====================================================================== //
//	Macro
// ====================================================================== //

///////////////////////////////////////////////////
// DPRAM 
Uint16 ui10msTimer=false;		// 10ms flag for process control
Uint16 uiCheckProcess=false;  // process check at the every sampling time

Uint16 isDPDown=false;
Uint16 isDPUp=false;

Uint16 iWriteCount;
Uint16 iReadCount;

Uint16 isDPDown2808=false;
Uint16 isDPUp2808=false;

Uint16 iWriteCount2808;
Uint16 iReadCount2808;

Uint16 isDPDownSlave=false;
Uint16 isDPUpSlave=false;

Uint16 iWriteCountSlave;
Uint16 iReadCountSlave;

Uint16 uReadStatus=0;
//Uint16 uiBoardID =0;

Uint16 bFlashWrite=0;

Uint16	SubHealth= 0;
Uint16	SubID= 0;




// error flag for error check
Uint16	flag_GasTrip =false;
Uint16	flag_Alarm =false;
Uint16	flag_ShuntDown =false;
Uint16	flag_StartBlock =false;

Uint16  uiCurrentLoad=0;

Uint16  KickDownTime=0;
Uint16  flag_KickDown= false;  // Kick down op flag 
//Uint16 DPDownAlarmSetup[DP_DOWN_ALARM_SETUP_SIZE];
//Uint16 DPDownEngineSetup[DP_DOWN_ENGINE_SETUP_SIZE];
//Uint16 DPDownPIDGainSet[3][DP_DOWN_PID_GAIN_SIZE];
//Uint16 DPDownCmd[DP_DOWN_CMD_SIZE];


//Uint16 DPDownMem[DP_DOWN_SIZE];
//Uint16 DPUpMem[DP_UP_SIZE];
//Uint16 DPDownMemSlave[DP_DOWN_SIZE];
//Uint16 DPUpMemSlave[DP_UP_SIZE];
//Uint16 DPDownMem2808[DP_DOWN_SIZE];
//Uint16 DPUpMem2808[DP_UP_SIZE];

int RTC_Write = 0;

#define SOGAV_MAX   180.0
#define SOGAV_MIN    10.0


BYTE flag_search_gain= 0;    // =FALSE ¼öÁ¤

int Gain_node[4];

long Set_SOGAV_command_count=0; 
long Test_Count=0;


float fGasPressure=0.;
float fGasPressureOld=0.;



float fOverspeed_Setting=0.;
float fK_constant =0.;
float fK1=0.;
float fK2=0.;
///////////
//  speed droop 
//
//
float fDroop=5.0;

int iTestValue=0;
//float fIdle_Speed=0.;
//float fEngine_Speed_Ref=0.;



#define MaxStartFail	3  // test code for tmp.
int iStartFailCnt=0;    // start fail check count, if iStartFailCnt > MaxCnt then goto Emergency 

unsigned char bExhaustGasVentilation =0;
unsigned char bGasLeakageTestMode=0;
unsigned char bVentilationMode=0;
unsigned char bGasLeakageTestResult =0;


//unsigned char T1TimeOut=false;  // software time out 1
//unsigned char T2TimeOut=false;  // software time out 2

unsigned int uiTestCh=1;
unsigned int uiCmdOutCh=11;
float fTestValue =5.0;
unsigned int uiTestFlag=false;
// test code for hardware 
//

//unsigned int uiTest=0;
//unsigned int uiAOCh=0;
unsigned int uiEFIValue=0x00;
unsigned char bPID_Enable=false;
unsigned char bPID_Timer=false;  // software time out for PID controller

unsigned int uiAnticipatorBias=0;
unsigned int uiAnticipatorDuration=0;
unsigned char bAnticipator=0;
unsigned char bAnticipatorIndex=0;

unsigned char bTimer1=0;
// ====================================================================== //
//flash write


#if (STANDALONE)

// CPU Timer0/1/2ÀÇ Interrupt Service Function ¼±¾ð
#pragma CODE_SECTION(MemCopy, "ramfuncs");
#pragma CODE_SECTION(DPDownTCP, "ramfuncs");
#pragma CODE_SECTION(DPDownSub, "ramfuncs");
#pragma CODE_SECTION(DPDownCan, "ramfuncs");
#pragma CODE_SECTION(DPUpTcp, "ramfuncs");
#pragma CODE_SECTION(AO_Update, "ramfuncs");
#pragma CODE_SECTION(ErrorCoding, "ramfuncs");
#pragma CODE_SECTION(ErrorDecoding, "ramfuncs");
#pragma CODE_SECTION(ErrorCheckDI, "ramfuncs");
#pragma CODE_SECTION(ErrorCheckAI, "ramfuncs");
#pragma CODE_SECTION(AI_Update, "ramfuncs");
#pragma CODE_SECTION(Check_StartBlock, "ramfuncs");
#pragma CODE_SECTION(DI_Process, "ramfuncs");
#pragma CODE_SECTION(Check_Process, "ramfuncs");
//#pragma CODE_SECTION(Governor_Gain_Range_Set, "ramfuncs");
#pragma CODE_SECTION(search_gain, "ramfuncs");
#pragma CODE_SECTION(Update_Gain, "ramfuncs");
#pragma CODE_SECTION(PID_Calculate, "ramfuncs");
#pragma CODE_SECTION(Parameter_Reset, "ramfuncs");
 
//Governor_Gain_Range_Set
// ====================================================================== //

// These are defined by the linker (see FLASH.cmd)
// ÀÌ º¯¼ö´Â ¸ÞÀÎ ÇÔ¼öÀÇ ÃÊ±âÈ­ ·çÆ¾¿¡¼­ "ramfuncs" ÀÌ¶ó°í Á¤ÀÇµÈ ÄÚµå ¼½¼ÇÀ»
// ³»ºÎ Flash¿¡¼­ RAM¿µ¿ªÀ¸·Î º¹»çÇÏ±â À§ÇÑ MemCopy ÇÔ¼ö¿¡¼­ »ç¿ëµÊ.
extern Uint16 RamfuncsLoadStart;
extern Uint16 RamfuncsLoadEnd;
extern Uint16 RamfuncsRunStart;
#endif


// ====================================================================== //
//	Global Variables
// ====================================================================== //
Uint32 Timer0TickCount = 0;	// Counter Timer0 ISR execution
Uint32 Timer1TickCount = 0;	// Counter Timer1 ISR execution
//Uint32 Timer2TickCount = 0;	// Counter Timer2 ISR execution
Uint16 Main_LoopCount = 0;
Uint16 HeartBeat =0;
Uint32 Tmr0TimeOutCnt =0;
Uint32 Tmr1TimeOutCnt =0;
Uint32 Tmr2TimeOutCnt =0;


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
// int mem_test_result1 = 0;
//int mem_test_result2 = 0;
//int mem_test_result3 = 0;
//int mem_test_result4 = 0;
//int mem_test_result5 = 0;
//int mem_test_result6 = 0;
//int mem_test_result7 = 0;

unsigned long *p_Speed= (unsigned long *)(SPEED_BASE);
unsigned long lpcnt=0;
// RTD Test
volatile unsigned int *p_address;
//Uint16 RTD_Data[19] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
//float RTD_Temperature[19]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};


// DAC Test
//float data_mA = 10.0;
// ====================================================================== //
Uint16 uiHealthCAN=0;

// PID 
PIDREG3 pid1_Engine=PIDREG3_DEFAULTS;
PIDREG3 pid_Sogav=PIDREG3_DEFAULTS;
 
Uint16 uiCmd=0; 
//////////////////////
// error check

//Uint16 const ErrorMapTbl[]={ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,1,2,3,4,5,6,7,8,9,10,11,12};

//Uint16 const ErrorBitMapTbl[]={ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,1,2,3,4,5,6,7,8,9,10,11,12};
// ====================================================================== //
//	Function Declararion
// ====================================================================== //
void Main_DSP_Init (void);
void Main_Parameter_Init(void);
interrupt void Timer1_ISR(void);
//interrupt void Timer2_ISR(void);

void Tmr0TimeOutFnct(void *arg);  // software timer 0 ms timer
void Tmr1TimeOutFnct(void *arg);  // software timer 1
void Tmr2TimeOutFnct(void *arg);  // software timer 2

//void Governor_Gain_Range_Set(void);
Uint16 CopyFlash (Uint32 base_address);
void Parameter_Reset(void);
int Calculate_KickDownTime(void);
void Set_SOGAV_command(void);
void PID_Calculate(void);

void Check_Anticipator(void);
unsigned int Calculate_Anticipator_Bias(int flag);
unsigned int Calculate_Anticipator_Duration(int flag);
void SogavTimer(void);
// ====================================================================== //

// for DPRAM 

//Uint16 DPUp (Uint32 base_address, Uint32 memory_size,int index);
Uint16 DPDown (Uint32 base_address, Uint32 memory_size,int index);
Uint16 DPUpTcp(Uint32 base_address);
Uint16 DPDownTCP (Uint32 base_address);
Uint16 DPUpSlave(Uint32 base_address);
// ====================================================================== //

void MemCopy(unsigned int *SourceAddr, unsigned int *SourceEndAddr, unsigned int *DestAddr)
{
    while(SourceAddr < SourceEndAddr)
    { 
       *(DestAddr++) = *(SourceAddr++);
//	   DestAddr++;
//	   SourceAddr++;
    }
    return;
}

void MemClear(unsigned int *SourceAddr, unsigned int *SourceEndAddr)
{
    while(SourceAddr < SourceEndAddr)
    { 
        *(SourceAddr++)=0x0000;
     }
    return;
}

// ====================================================================== //
//	Function: DPDown
//		- Download from DPRAM 
// ---------------------------------------------------------------------- //
Uint16 DPDownTCP (Uint32 base_address)
{

	unsigned int *p_address  = (unsigned int *)(base_address);

 	unsigned int *p_dest;// =(unsigned int *)&st_AlarmSetup;
//if (uiDeviceID ==MAIN_BOARD) // Main Controll C1 
//{

	uReadStatus =	uiCmd = *(p_address+0x1000-1);//*(p_address+0x1000);
 
	p_address = (unsigned int *)(base_address+DP_DOWN_CMD); //stEngineSetup
	p_dest =(unsigned int *)&st_EngineCmdParameter;
	MemCopy(p_address,p_address+sizeof(st_EngineCmdParameter),p_dest);  
 
	if (uiCmd & 0x0001) //read all
	{
		p_address = (unsigned int *)(base_address+DP_DOWN_CMD_BASE);  //stSetup
		p_dest =(unsigned int *)&stSetup;
		MemCopy(p_address,p_address+sizeof(stSetup),p_dest);  
 
 
		p_address = (unsigned int *)(base_address+DP_DOWN_PID_GAIN_BASE); //stEngineSetup
		p_dest =(unsigned int *)&stGovernorGain;
		MemCopy(p_address,p_address+sizeof(stGovernorGain),p_dest);  

		p_address = (unsigned int *)(base_address+DP_DOWN_PID_GAIN_SET); //stEngineSetup
		p_dest =(unsigned int *)&stPidGainSet;
		MemCopy(p_address,p_address+sizeof(stPidGainSet),p_dest);  


	//	volatile struct  PIDGainSetting stPidGainSet,stPidGainSetFlash;
 
		p_address = (unsigned int *)(base_address+DP_DOWN_PID_GAIN_BASE2); //stEngineSetup
		p_dest =(unsigned int *)&stGasPressureGain;
		MemCopy(p_address,p_address+sizeof(stGasPressureGain),p_dest);  
  	
		p_address = (unsigned int *)(base_address+DP_DOWN_ALARM_SETUP_BASE);  //DP_DOWN_AO_SETUP_BASE
		p_dest =(unsigned int *)&st_AlarmSetup;
		//added by 2012.03.19. alarm setup is a structure, and memcpy is done. // check for the value exchange???
		MemCopy(p_address,p_address+sizeof(st_AlarmSetup),p_dest);  


		p_address = (unsigned int *)(base_address+DP_DOWN_AO_SETUP_BASE);  //1432
		p_dest =(unsigned int *)&st_AOSetupC1;//st_AlarmSetupC1_Sub;
		//added by 2012.03.19. alarm setup is a structure, and memcpy is done. // check for the value exchange???
		MemCopy(p_address,p_address+sizeof(st_AOSetupC1),p_dest);  

		p_address = (unsigned int *)(base_address+DP_DOWN_ALARM_SETUP_SUB_BASE);  //1432
		p_dest =(unsigned int *)&st_AlarmSetupC1_Sub;//st_AlarmSetupC1_Sub;
		//added by 2012.03.19. alarm setup is a structure, and memcpy is done. // check for the value exchange???
		MemCopy(p_address,p_address+sizeof(st_AlarmSetupC1_Sub),p_dest);  

		p_address = (unsigned int *)(base_address+DP_DOWN_ALARM_SETUP_CAN_BASE);  //1432
		p_dest =(unsigned int *)&st_AlarmSetupC1_Can;//st_AlarmSetupC1_Sub;
		//added by 2012.03.19. alarm setup is a structure, and memcpy is done. // check for the value exchange???
		MemCopy(p_address,p_address+sizeof(st_AlarmSetupC1_Can),p_dest);  

		//sogav test flag
		p_address = (unsigned int *)(base_address+DP_DOWN_SOGAV_TEST_BASE);  //12B0
		p_dest =(unsigned int *)&stSogavFlag;//st_AlarmSetupC1_Sub;
	 
		MemCopy(p_address,p_address+sizeof(stSogavFlag),p_dest);  

 

 	
	}
	else if (uiCmd & 0x0002) //read command
	{
		p_address = (unsigned int *)(base_address+DP_DOWN_CMD_BASE);
		p_dest =(unsigned int *)&stSetup;
		MemCopy(p_address,p_address+sizeof(stSetup),p_dest);  

	

		Speed_Reference =	stSetup.IdleSpeedRef;
	}
	else if (uiCmd & 0x0004) //read gavornor PID gain 1
 	{
		p_address = (unsigned int *)(base_address+DP_DOWN_PID_GAIN_BASE); //stEngineSetup
		p_dest =(unsigned int *)&stGovernorGain;
		MemCopy(p_address,p_address+sizeof(stGovernorGain),p_dest);  
//		Governor_Gain_Range_Set();

		p_address = (unsigned int *)(base_address+DP_DOWN_PID_GAIN_SET); //stEngineSetup
		p_dest =(unsigned int *)&stPidGainSet;
		MemCopy(p_address,p_address+sizeof(stPidGainSet),p_dest);  


	//	volatile struct  PIDGainSetting stPidGainSet,stPidGainSetFlash;
 
	}
	else if (uiCmd & 0x0008) //read pump pid gain
	{
 
		p_address = (unsigned int *)(base_address+DP_DOWN_PID_GAIN_BASE2); //stEngineSetup
		p_dest =(unsigned int *)&stGasPressureGain;
		MemCopy(p_address,p_address+sizeof(stGasPressureGain),p_dest);  
 
	}
	else if (uiCmd & 0x0010) //read engine status 
	{
//		p_address = (unsigned int *)(base_address+DP_DOWN_ENGINE_SETUP_BASE); //stEngineSetup
//		p_dest =(unsigned int *)&st_EngineSetup;
//		MemCopy(p_address,p_address+sizeof(st_EngineSetup),p_dest);  
	}
	else if (uiCmd & 0x0020) //read alarm status setup
	{
		p_address = (unsigned int *)(base_address+DP_DOWN_ALARM_SETUP_BASE);  //DP_DOWN_AO_SETUP_BASE
		p_dest =(unsigned int *)&st_AlarmSetup;
 
		MemCopy(p_address,p_address+sizeof(st_AlarmSetup),p_dest);  
 
	}
	 p_address  = (unsigned int *)(base_address);
	 *(p_address+0x1000-1) =0x00;

		if (uiCmd >0) 
		{
	 		FlashWrite(uiCmd);// write all
	 		CopyFlash(DPRAM_STR_BASE);//update DPRAM from Flash memory ,  
		}
	return TRUE;
}
// ====================================================================== //
// ====================================================================== //
//	Function: DPDownSub
//		- Download from DPRAM 
// ---------------------------------------------------------------------- //
Uint16 DPDownSub (Uint32 base_address)
{
	unsigned int *p_address  = (unsigned int *)(base_address);

 
	unsigned int *p_dest;// =(unsigned int *)&st_AlarmSetup;
	SubHealth= *(p_address);
	SubID= *(p_address+0x10);

	p_address = (unsigned int *)(base_address+0x20); //st_C1SubFeedback  0x230010
	p_dest =(unsigned int *)&st_C1SubFeedback;
	//added by 2012.03.19. alarm setup is a structure, and memcpy is done. // check for the value exchange???
	MemCopy(p_address,p_address+sizeof(st_C1SubFeedback),p_dest);  

	//added by 2012.09.05. RTD data from Sub controller via can comm. 
	p_address = (unsigned int *)(base_address+0x40); //st_C1CanFeedback  0x230040
	p_dest =(unsigned int *)&st_C1CanFeedback;
	
	MemCopy(p_address,p_address+sizeof(st_C1CanFeedback),p_dest);  


	return TRUE;
}

// ====================================================================== //
// ====================================================================== //
//	Function: DPDownSub
//		- Download from DPRAM 
// ---------------------------------------------------------------------- //
Uint16 DPDownCan (Uint32 base_address)
{
//	unsigned int *p_address  = (unsigned int *)(base_address+0x20);
	unsigned int *p_Health = (unsigned int *)(base_address);
 
//	unsigned int *p_dest;// =(unsigned int *)&st_AlarmSetup;
	uiHealthCAN = *p_Health;
//	p_dest =(unsigned int *)&st_C1CanFeedback;
	//added by 2012.03.19. alarm setup is a structure, and memcpy is done. // check for the value exchange???
//	MemCopy(p_address,p_address+sizeof(st_C1CanFeedback),p_dest);  

	return TRUE;
}



// ====================================================================== //

// ====================================================================== //
//	Function: DP_Clear
//		- Clear DPRAM Memory
// ---------------------------------------------------------------------- //
Uint16 DP_Clear(Uint32 base_address)
{
	// ====================================================================== //
	// Disable Global Interrupt
	// ---------------------------------------------------------------------- //
	int i=0;
		 
 
 
	unsigned int *p_dest= (unsigned int *)(base_address+0x1000); 


	for(i=0; i<=1500; i++)
	{
 		*(p_dest+i) =0x00;
	}

	 

	return TRUE;
}
// ====================================================================== //



// ====================================================================== //
//	Function: DPUp
//		- Upload to DPRAM 
// ---------------------------------------------------------------------- //
Uint16 DPUpTcp(Uint32 base_address)
{
	// ====================================================================== //
	// Disable Global Interrupt
	// ---------------------------------------------------------------------- //
	int i=0;
		 
 	unsigned int *p_address;  

 
	unsigned int *p_dest= (unsigned int *)(base_address); 

	*(p_dest) = HeartBeat;
	*(p_dest+1) = uiDeviceID;

	for(i=0; i<=29; i++)
	{
 		*(p_dest+10+i) =st_ADC_Value[i].value;
	}

	for(i=1; i<=15; i++)
	{
		*(p_dest+0x2D+i) =fDA_Data[i];//AO parameter Update 
	}

	*(p_dest+0x3D) =	Main_do1.all;  // MAIN DO 1 update
	*(p_dest+0x3E) =	Main_do2.all;  // MAIN DO 2 update
	*(p_dest+0x3F) =	Main_di1.all;  // MAIN DI 1 update
	*(p_dest+0x40) =	Main_di2.all;  // MAIN DI 2 update

	// Measured_Speed°ªÀ» Dpram¿¡ ¾´´Ù ¹Ý¿Ã¸² °è»ê ÇÑ °ªÀ¸·Î ÀúÀåÇÔ. 
	*(p_dest+0x35) =(int)((Measured_Speed+0.05)*10.0);  

	// control_value°ªÀ» Dpram¿¡ ¾´´Ù
	*(p_dest+0x2E) =	(control_value - 4)*6.25*10;   //	4-20mA  => 0-100% º¯È¯


	p_dest= (unsigned int *)(base_address+DP_UP_SUB_FEEDBACK);  //DP_UP C2 feedback signal. 
	p_address =(unsigned int *)&st_C1SubFeedback;

	MemCopy(p_address,p_address+sizeof(st_C1SubFeedback),p_dest);  


	p_dest= (unsigned int *)(base_address+DP_UP_CAN_FEEDBACK);  //DP_UP C3(CAN) feedback signal. 
	p_address =(unsigned int *)&st_C1CanFeedback;

	MemCopy(p_address,p_address+sizeof(st_C1CanFeedback),p_dest);  
///////   Ãß°¡ÇØ¾ßÇÒ °Í ,  0x40A0, controller internal signals.
	st_C1Feedback.EngineMode =uiEngineMode;
	st_C1Feedback.uiSubMode =uiSubMode;
	st_C1Feedback.iUp =(int)(pid1_Engine.Up*1000.0); // calculated P sum 
	st_C1Feedback.iUi =(int)(pid1_Engine.Ui*10.0); // calculated I sum 
	st_C1Feedback.iUd =(int)(pid1_Engine.Ud*1000.0); // calculated d sum 
	st_C1Feedback.iTotalPid =(int)((pid1_Engine.Up+pid1_Engine.Ui+pid1_Engine.Ud)*10.0); // calculated PID total sum
	st_C1Feedback.ip_gain =(int)(pid1_Engine.Kp*10.0);
	st_C1Feedback.ii_gain =(int)(pid1_Engine.Ki*10.0);
	st_C1Feedback.id_gain =(int)(pid1_Engine.Kd*10.0);
	st_C1Feedback.iControl =(int)((control_value - 4)*6.25*10.0); // calculated Fuel amount
	st_C1Feedback.uiLoad=	(int)(Measured_Load*10.0);

	for (i=0;i<13;i++)
	st_C1Feedback.uiErrorCode[i]=uiErrorReg[i+1];

	p_dest= (unsigned int *)(base_address+DP_UP_C1_FEEDBACK);  //DP_UP C3(CAN) feedback signal. 
	p_address =(unsigned int *)&st_C1Feedback;

	MemCopy(p_address,p_address+sizeof(st_C1Feedback),p_dest);  


/*		 
	*(p_dest+0xA0) =uiEngineMode; // Engine control mode at Now
	*(p_dest+0xA1) =uiSubMode; // Temp.  // sub controller start/stop ??? 
	*(p_dest+0xA2) =(int)(pid1_Engine.Up*10.0); // calculated P gain
	*(p_dest+0xA3) =(int)(pid1_Engine.Ui*10.0); // calculated I gain
	*(p_dest+0xA4) =(int)(pid1_Engine.Up*10.0); // calculated D gain
	*(p_dest+0xA5) =(int)(pid1_Engine.Up*10.0); // calculated P term sum
	iTestValue =(int)(pid1_Engine.Ui*10.0); // calculated I term sum
	*(p_dest+0xA6) =(unsigned int)iTestValue;//(int)(pid1_Engine.Ui*10.0); // calculated I term sum
	*(p_dest+0xA7) =(int)(pid1_Engine.Ud*10.0); // calculated D term sum
	*(p_dest+0xA8) =(int)((pid1_Engine.Up+pid1_Engine.Ui+pid1_Engine.Ud)*10.0); // calculated PID total sum
	*(p_dest+0xA9) =(int)((control_value - 4)*6.25*10.0); // calculated Fuel amount


	for (i=0;i<13;i++)
	*(p_dest+0xAA) =uiErrorReg[i];  // error code from 0x40AA~0x40B6


//	*(p_dest+0xB9) =uiSubMode; // calculated Fuel amount
*/

	return TRUE;
}
// ====================================================================== //

// ====================================================================== //
//	Function: DPUpSlave
//		- Upload to DPRAM for Slave DSP
// ---------------------------------------------------------------------- //
Uint16 DPUpSlave(Uint32 base_address)
{
	// ====================================================================== //
	// Disable Global Interrupt
	// ---------------------------------------------------------------------- //
	int i=0;
		 
// 	unsigned int *p_address;  

 
	unsigned int *p_dest= (unsigned int *)(base_address); 

 
	for(i=0; i<=29; i++)
	{
 		*(p_dest+i) =st_ADC_Value[i].value;
	}

	for(i=1; i<=15; i++)
	{
		*(p_dest+ 0x1e +i) =fDA_Data[i];//AO parameter Update 
	}

	*(p_dest+0x2E) =	Main_do1.all;  // MAIN DO 1 update
	*(p_dest+0x2F) =	Main_do2.all;  // MAIN DO 2 update
	*(p_dest+0x30) =	Main_di1.all;  // MAIN DI 1 update
	*(p_dest+0x31) =	Main_di2.all;  // MAIN DI 2 update
	*(p_dest+0x32) =    uiDeviceID;
	*(p_dest+0x33) =    HeartBeat;

	*(p_dest+0x34) = SubDOCmd.all;
	return TRUE;
}
// ====================================================================== //


// ====================================================================== //
//	Function: DPUp
//		- Upload to DPRAM 
// ---------------------------------------------------------------------- //
/*

Uint16 DPUp (Uint32 base_address, Uint32 memory_size,int index)
{
	// ====================================================================== //
	// Disable Global Interrupt
	// ---------------------------------------------------------------------- //
int i=0;
	 
	volatile unsigned int *p_address = (unsigned int *)(base_address);
	 switch(index)
	 {
		case 0: //arm
		for (i=0; i<=memory_size; i++)
		{
			*p_address =   DPUpMem[i];
	 	}
		break;
		case 1: //slave
		for (i=0; i<=memory_size; i++)
		{
			*p_address =   DPUpMemSlave[i];
	 	}
		break;
		case 2: //2808
			for (i=0; i<=memory_size; i++)
		{
			*p_address =   DPUpMem2808[i];
	 	}
		break;
		default: //slave
			return FALSE;
  //		break;
		}
	return TRUE;
}

*/
// ====================================================================== //


// ====================================================================== //
//	Function: AO_Update
//		- Read AD converter value and write DA value
// ---------------------------------------------------------------------- //
void AO_Update(void)
{
int i=0;  

 	for(i=1; i<=10; i++)
	{
		DAC_Out_mA (i, fDA_Data[i]);//AO data 
	}

}

// ====================================================================== //
//	Function: ErrorCoding
//		- Check Coding for AI, DI
// ---------------------------------------------------------------------- //
void ErrorCoding(void)
{
	uiErrorReg[uiErrGrp]|= (0x0001 << uiErrBit);
}

// ====================================================================== //
//	Function: ErrorCoding
//		- Check Coding for AI, DI
// ---------------------------------------------------------------------- //
Uint16 ErrorDecoding(unsigned int Grp, unsigned int Bit)
{
Uint16 rtn=0;
	rtn =uiErrorReg[Grp] & (0x0001 << Bit);
	if (rtn) return 1;
	else return 0; 
}

// ====================================================================== //
//	Function: ErrorCheck
//		- Check Error for  DI
// ---------------------------------------------------------------------- //
void ErrorCheckDI(void)
{

int i=0;
		Main_di1.all = DIN1;
		Main_di2.all = DIN2;
	

	if (Main_di1.bit.TurningGearEngaged) // 
	{
		if (uiEngineMode == MODE_READY) 
		{
		
			if (st_DI_Value[i].flagStartBlock)
			{
				st_DI_Value[i].delay_cnt_StartBlock++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_StartBlock > 0.5*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=12;
					uiErrBit =8;
					ErrorCoding();   
				}
			}
			else st_DI_Value[i].flagStartBlock=true;
	//		flag_StartBlock = true;


		}
		else if ((uiEngineMode > MODE_READY) && (uiEngineMode != MODE_START))
		{
			if (st_DI_Value[i].flagAlarm)
			{
				st_DI_Value[i].delay_cnt_Alarm++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_Alarm > 0.5*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=10;
					uiErrBit =6;
					ErrorCoding();   
				}
			}
			else st_DI_Value[i].flagAlarm=true;  
		}
	}


		i=8;
	//  DI 8 Filter diff. pressure at GVU inlet
	if (Main_di1.bit.FilterDifPressGVUIn) // 
	{
		if ((uiEngineMode == MODE_RUN) && (uiFuelMode == FUEL_GAS)) 
		{
		//	 flag_StartBlock = true;

			if (st_DI_Value[i].flagGT)
			{
				st_DI_Value[i].delay_cnt_GT++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_GT > 0.5*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=12;
					uiErrBit =8;
					ErrorCoding();   
				}
			}
			else st_DI_Value[i].flagGT=true;
		}
	 
	}
	else
	{
		if (st_DI_Value[i].flagGT)
		{
			st_DI_Value[i].flagGT=false;
			st_DI_Value[i].delay_cnt_GT =0;
		}
	}


			i=9;
	//  DI 9 Filter diff. pressure at Engine inlet
	if (Main_di1.bit.FilterDifPressEngIn) // 
	{
		if ((uiEngineMode == MODE_RUN) && (uiFuelMode == FUEL_GAS)) 
		{
		//	 flag_StartBlock = true;

			if (st_DI_Value[i].flagGT)
			{
				st_DI_Value[i].delay_cnt_GT++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_GT > 0.5*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=12;
					uiErrBit =9;
					ErrorCoding();   
				}
			}
			else st_DI_Value[i].flagGT=true;
		}
	 
	}
	else
	{
		if (st_DI_Value[i].flagGT)
		{
			st_DI_Value[i].flagGT=false;
			st_DI_Value[i].delay_cnt_GT =0;
		}
	}

			i=11;
	//  DI 11 Stop lever in stop position
	if (Main_di1.bit.StopLeverStopPos) // 
	{
		if (uiEngineMode <= MODE_READY)
		{
		// start block 
			uiErrGrp=16;
			uiErrBit =0;
			ErrorCoding();   
		}
		else if (uiEngineMode > MODE_READY)
		{  
		// ¾î¶»°Ô ÇÏÁö ????
		// shut down  
			uiErrGrp=16;
			uiErrBit =1;
			ErrorCoding();   
		}
		
	 
	}
	else
	{
		if (st_DI_Value[i].flagAlarm)
		{
			st_DI_Value[i].flagAlarm=false;
			st_DI_Value[i].delay_cnt_Alarm =0;
		}
	}



			i=14;
	//  DI 14 Gas Detection
	if (Main_di1.bit.GasDetectionAlarm) // 
	{

			if (st_DI_Value[i].flagAlarm)
			{
				st_DI_Value[i].delay_cnt_Alarm++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_Alarm > 0.1*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=15;
					uiErrBit =12;
					ErrorCoding();   
				}
			}
			else st_DI_Value[i].flagGT=true;
	 
	}
	else
	{
		if (st_DI_Value[i].flagAlarm)
		{
			st_DI_Value[i].flagAlarm=false;
			st_DI_Value[i].delay_cnt_Alarm =0;
		}
	}

 
	///  ±â´ÉÀÌ ¸íÈ®ÇÏÁö ¾ÊÀ½. DI Process¿¡¼­ Ã³¸®ÇÏ´Â °Ô ³ºÀ» µíÇÑµ¥....

			i=15;
	//  DI 15 Gas trip request from external 
	if ((Main_di1.bit.GasTripReq1) || (Main_di1.bit.GasTripReq2))  // 
	{
		if ((uiEngineMode == MODE_RUN) && (uiFuelMode == FUEL_GAS)) 
		{
		//	 flag_StartBlock = true;

			if (st_DI_Value[i].flagGT)
			{
				st_DI_Value[i].delay_cnt_GT++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_GT > 0.5*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=17;
					uiErrBit =0;
					ErrorCoding();   

					///  Gas Trip routine ±¸ÇöÇÒ °Í!!!!!
				}
			}
			else st_DI_Value[i].flagGT=true;
		}
	 
	}
	else
	{
		if (st_DI_Value[i].flagGT)
		{
			st_DI_Value[i].flagGT=false;
			st_DI_Value[i].delay_cnt_GT =0;
		}
	}


				i=5;
	//  DI 5 Local Stop Requeset 
	if (Main_di1.bit.Stop)
	{
		if (uiEngineMode >= MODE_START)
		{
		//	 flag_StartBlock = true;

			if (st_DI_Value[i].flagWarn)
			{
				st_DI_Value[i].delay_cnt_warn++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_warn > 0.1*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=17;
					uiErrBit =5;
					ErrorCoding();   

					///  sHUT DOWM routine ±¸ÇöÇÒ °Í!!!!!

					uiEngineMode =MODE_SHUTDOWN;
					uiSubMode =0x00;
				}
			}
			else st_DI_Value[i].flagGT=true;
		}
	 
	}
	else
	{
		if (st_DI_Value[i].flagGT)
		{
			st_DI_Value[i].flagGT=false;
			st_DI_Value[i].delay_cnt_GT =0;
		}
	}
 
 


		i=26;
	//  DI 26 Exh. vent valve fault
	if (Main_di2.bit.ExhVentFanFault) // 
	{
		if (uiEngineMode == MODE_READY)
		{
			 flag_StartBlock = true;

			if (st_DI_Value[i].flagStartBlock)
			{
				st_DI_Value[i].delay_cnt_StartBlock++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_StartBlock > 0.5*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=10;
					uiErrBit =6;
					ErrorCoding();   
				}
			}
			else st_DI_Value[i].flagStartBlock=true;



		}
		else if (uiEngineMode > MODE_READY) 
		{

			if (st_DI_Value[i].flagAlarm)
			{
				st_DI_Value[i].delay_cnt_Alarm++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_Alarm > 0.5*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=10;
					uiErrBit =6;
					ErrorCoding();   
				}
			}
			else st_DI_Value[i].flagAlarm=true;
		}
	}


		i=25;
	//  DI 25  Exh. vent fan alarm
	if (Main_di2.bit.ExhVentFanAlarm) // 
	{
		if (uiEngineMode == MODE_READY)
		{
		//	 flag_StartBlock = true;

			if (st_DI_Value[i].flagStartBlock)
			{
				st_DI_Value[i].delay_cnt_StartBlock++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_StartBlock > 0.5*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=10;
					uiErrBit =7;
					ErrorCoding();   
				}
			}
			else st_DI_Value[i].flagStartBlock=true;



		}
		else if (uiEngineMode > MODE_READY) 
		{

			if (st_DI_Value[i].flagAlarm)
			{
				st_DI_Value[i].delay_cnt_Alarm++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_Alarm > 0.5*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=10;
					uiErrBit =6;
					ErrorCoding();   
				}
			}
			else st_DI_Value[i].flagAlarm=true;
		}
	}


		i=29;
	//  DI 29  Exh. gas vent valve air flow
	if (Main_di2.bit.GasVentValveAirFlow) // 
	{
		if ((uiEngineMode == MODE_RUN) && (uiFuelMode == FUEL_GAS)) 
		{
		//	 flag_StartBlock = true;

			if (st_DI_Value[i].flagGT)
			{
				st_DI_Value[i].delay_cnt_GT++; /// delay time is correct???
				if (st_DI_Value[i].delay_cnt_GT > 0.5*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=10;
					uiErrBit =8;
					ErrorCoding();   
				}
			}
			else st_DI_Value[i].flagGT=true;
		}
	 
	}
	else
	{
		if (st_DI_Value[i].flagGT)
		{
			st_DI_Value[i].flagGT=false;
			st_DI_Value[i].delay_cnt_GT =0;
		}
	}




	///////////////////////////////////////
   //  ±¸Ã¼ÀûÀ¸·Î Á¤ÀÇ µÇÁö ¾Ê¾ÒÀ½. 
   //  HFO ·Î ¿îÀü ÈÄ¿¡ LFO·Î ¿îÀüÇÏÁö ¾Ê´Â °æ¿ì ¾Ë¶÷À» ¾î¶»°Ô ¹ß»ý½ÃÅ°³ª?????
	if (Main_di2.bit.LFO_HFOSelect) // 
	{


	}


}


// ====================================================================== //
//	Function: CheckLoad
//		- Check Load for  DI
// ---------------------------------------------------------------------- //
Uint16 CheckLoad(float fArg)
{

	int i=0;
// 0 , 20, 40, 60, 80, 100, 110 

	for (i=1;i<7;i++)
	{
		if ((st_AlarmSetup.Load_Signal.LoadSet[i-1]<=fArg) && (st_AlarmSetup.Load_Signal.LoadSet[i]>fArg))
		{
			return i;
		}
	}

	return 0;

}


// ====================================================================== //
//	Function: ErrorCheck
//		- Check Error for AI 
// ---------------------------------------------------------------------- //
void ErrorCheckAI(void)
{
int i=0;  



	i=25;
	// AI 26 : Load Signal   --> ÀÌÈÄ¿¡ »ç¿ëµÇ´Â °ªÀÌ¹Ç·Î Á¦ÀÏ ¸ÕÀú Ã³¸®ÇÔ 
// Load signalÀÇ °íÀå¿¡ ´ëÇÑ ÆÇ´Ü ¹æ¹ýÀÌ ¸íÈ®ÇÏÁö ¾ÊÀ½
/*
	if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
	{
		if (st_ADC_Value[i].flagLowHigh)
		{
			st_ADC_Value[i].delay_cnt_lowhigh++; /// delay time is correct???
			if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
			{
				uiErrGrp=13;
				uiErrBit =2;
				ErrorCoding();   
			}
		}
		else st_ADC_Value[i].flagLowHigh=true;

	}
	else 
	{
		st_ADC_Value[i].flagLowHigh=false;
		st_ADC_Value[i].delay_cnt_lowhigh=0;
	}
*/

	uiCurrentLoad = CheckLoad(st_ADC_Value[i].value);

	//////////////////////////////////////////////////////////////
	///  load¿¡ ´ëÇÑ ¿¡·¯ ³¸® ¾Ë°í¸®Áò Ãß°¡ÇÒ °Í
	///  ±¸Çö ¹æ¹ýÀº????
	//////////////////////////////////////////////////////////////




	// AI sensor low input or high input value check

	//  AI 3  MainFOEngine  ¹è¿­¿¡´Â 1°³ ÀÛÀº °ªÀÌ ÇÒ´çµÊ.

		i=2;
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=3;
					uiErrBit =5;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
//			if (uiFuelMode == FUEL_DIESEL)
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

		// Gas mode or Diesel to Gas mode change 
		if ((uiFuelMode == FUEL_GAS) || (uiFuelMode == FUEL_DIESEL2GAS))
		{
			if ((st_ADC_Value[i].value < st_AlarmSetup.MainFOEngine.LowAlarmGT))
			{
				if (st_ADC_Value[i].flagGT)
				{
					st_ADC_Value[i].delay_cnt_GT++;
					if (st_ADC_Value[i].delay_cnt_GT >st_AlarmSetup.MainFOEngine.LowAlarmGTDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=3;
						uiErrBit =8;
						ErrorCoding();
						flag_GasTrip =true;
					}
				}
				else st_ADC_Value[i].flagGT=true;
			}
			else 
			{
				st_ADC_Value[i].delay_cnt_GT=false;
				st_ADC_Value[i].flagGT=0;
			}
		}

		if ((uiEngineMode >= MODE_READY) && (uiEngineMode < MODE_SHUTDOWN))  // Ready, Run, Load ÀÎ °æ¿ì¸¸ µ¿ÀÛ ??
		{
			if (Main_di2.bit.LFO_HFOSelect ==1) //LFO(MDO)  is High(engine start and stop), HFO is low(normal)
			{

				if ((st_ADC_Value[i].value < st_AlarmSetup.MainFOEngine.LowAlarmMDO))
				{
					if (st_ADC_Value[i].flagWarn)
					{
						st_ADC_Value[i].delay_cnt_warn++;
						if (st_ADC_Value[i].delay_cnt_warn >st_AlarmSetup.MainFOEngine.LowAlarmMDODelay*DelayTimeConstant) //error flag on  
						{
							uiErrGrp=3;
							uiErrBit =7;
							ErrorCoding();
						}
					}
					else st_ADC_Value[i].flagWarn=true;

				}
				else 
				{
				
					st_ADC_Value[i].delay_cnt_warn=false;
					st_ADC_Value[i].flagWarn=0;
				}
			}
			else
			{
				if ((st_ADC_Value[i].value < st_AlarmSetup.MainFOEngine.LowAlarmMDO))
				{
					if (st_ADC_Value[i].flagWarn)
					{
						st_ADC_Value[i].delay_cnt_warn++;
						if (st_ADC_Value[i].delay_cnt_warn >st_AlarmSetup.MainFOEngine.LowAlarmHFODelay*DelayTimeConstant) //error flag on  
						{
							uiErrGrp=3;
							uiErrBit =6;
							ErrorCoding();
						}
					}
					else st_ADC_Value[i].flagWarn=true;

				}
				else 
				{
				
					st_ADC_Value[i].delay_cnt_warn=false;
					st_ADC_Value[i].flagWarn=0;
				}
			}

		}



		// AI sensor high input value check
		i=3;
		// AI 4 : Starting air pressure, engine inlet
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=2;
					uiErrBit =2;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}
		// alarm for low pressure of starting air 
		if ((st_ADC_Value[i].value < st_AlarmSetup.StartingAirPressure.AlarmSetPoint))
		{
			if (st_ADC_Value[i].flagWarn)
			{
				st_ADC_Value[i].delay_cnt_warn++;
				if (st_ADC_Value[i].delay_cnt_warn >st_AlarmSetup.StartingAirPressure.AlarmSetDelay*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=2;
					uiErrBit =3;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagWarn=true;

		}
		else 
		{
		
			st_ADC_Value[i].delay_cnt_warn=false;
			st_ADC_Value[i].flagWarn=0;
		}

			i=4;
		// AI 5 : control air pressure, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=2;
					uiErrBit =4;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

			// alarm for low pressure of control air 
		if ((st_ADC_Value[i].value < st_AlarmSetup.ControlAirPressure.LowAlarmSetPoint))
		{
			if (st_ADC_Value[i].flagWarn)
			{
				st_ADC_Value[i].delay_cnt_warn++;
				if (st_ADC_Value[i].delay_cnt_warn >st_AlarmSetup.ControlAirPressure.LowAlarmSetDelay*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=2;
					uiErrBit =5;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagWarn=true;

		}
		else 
		{
		
			st_ADC_Value[i].delay_cnt_warn=false;
			st_ADC_Value[i].flagWarn=0;
		}

			// Shutdown for low pressure of control air 
		if ((st_ADC_Value[i].value < st_AlarmSetup.ControlAirPressure.LowShutdownSetPoint))
		{
			if (st_ADC_Value[i].flagErr)
			{
				st_ADC_Value[i].delay_cnt++;
				if (st_ADC_Value[i].delay_cnt >st_AlarmSetup.ControlAirPressure.LowShutdownSetDelay*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=2;
					uiErrBit =6;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagWarn=true;

		}
		else 
		{
		
			st_ADC_Value[i].delay_cnt=0;
			st_ADC_Value[i].flagErr=0;
		}

				i=5;
		// AI 6 : Instrument air press, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=2;
					uiErrBit =7;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

			// alarm for low pressure of instrument air 
		if ((st_ADC_Value[i].value < st_AlarmSetup.InstrumentAirPressure.LowAlarmSetPoint))
		{
			if (st_ADC_Value[i].flagWarn)
			{
				st_ADC_Value[i].delay_cnt_warn++;
				if (st_ADC_Value[i].delay_cnt_warn >st_AlarmSetup.InstrumentAirPressure.LowAlarmSetDelay*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=2;
					uiErrBit =8;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagWarn=true;

		}
		else 
		{
		
			st_ADC_Value[i].delay_cnt_warn=false;
			st_ADC_Value[i].flagWarn=0;
		}

			// Shutdown for low pressure of control air 

	// Gas mode or Diesel to Gas mode change 
		if ((uiFuelMode == FUEL_GAS) || (uiFuelMode == FUEL_DIESEL2GAS))
		{

			if ((st_ADC_Value[i].value < st_AlarmSetup.InstrumentAirPressure.LowGasTripSetPoint))
			{
				if (st_ADC_Value[i].flagGT)
				{
					st_ADC_Value[i].delay_cnt_GT++;
					if (st_ADC_Value[i].delay_cnt_GT >st_AlarmSetup.InstrumentAirPressure.LowGasTripSetDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=2;
						uiErrBit =9;
						ErrorCoding();

						flag_GasTrip =true;
					}
				}
				else st_ADC_Value[i].flagGT=true;

			}
			else 
			{
			
				st_ADC_Value[i].delay_cnt_GT=0;
				st_ADC_Value[i].flagGT=0;
			}

		}
	


				i=6;
		// AI 7 : LO PressureFilterInlet, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=6;
					uiErrBit =2;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}


		if ((uiEngineMode == MODE_START) || (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))
		{
				// alarm for High/Low pressure of LO
			if ((st_ADC_Value[i].value < st_AlarmSetup.LO_PressureFilterInlet.LowAlarmByLoad[uiCurrentLoad]) || (st_ADC_Value[i].value > st_AlarmSetup.LO_PressureFilterInlet.HighAlarmByLoad[uiCurrentLoad]))
			{
				if (st_ADC_Value[i].flagWarn)
				{
					st_ADC_Value[i].delay_cnt_warn++;
					if (st_ADC_Value[i].delay_cnt_warn >st_AlarmSetup.LO_PressureFilterInlet.LowAlarmDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=6;
						uiErrBit =0;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagWarn=true;

			}
			else 
			{
			
				st_ADC_Value[i].delay_cnt_warn=false;
				st_ADC_Value[i].flagWarn=0;
			}

			// shutdown for High/Low pressure of LO
			if (st_ADC_Value[i].value < st_AlarmSetup.LO_PressureFilterInlet.LowSDByLoad[uiCurrentLoad])
			{
				if (st_ADC_Value[i].flagErr)
				{
					st_ADC_Value[i].delay_cnt++;
					if (st_ADC_Value[i].delay_cnt >st_AlarmSetup.LO_PressureFilterInlet.LowSDDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=6;
						uiErrBit =1;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagErr=true;

			}
			else 
			{
			
				st_ADC_Value[i].delay_cnt=0;
				st_ADC_Value[i].flagErr=0;
			}

		}//		if ((uiEngineMode == MODE_START) || (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))


/*   //////????????????????
   		// Alarm for  for High/Low pressure of LO
		if ((st_ADC_Value[i].value < st_AlarmSetup.LO_PressureFilterInlet.[uiCurrentLoad]))
		{
			if (st_ADC_Value[i].flagWarn)
			{
				st_ADC_Value[i].delay_cnt_warn++;
				if (st_ADC_Value[i].delay_cnt_warn >st_AlarmSetup.LO_PressureFilterInlet.HighAlarmDelay*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=6;
					uiErrBit =3;
					ErrorCoding();

					flag_GasTrip =true;
				}
			}
			else st_ADC_Value[i].flagGT=true;

		}
		else 
		{
		
			st_ADC_Value[i].delay_cnt_GT=0;
			st_ADC_Value[i].flagGT=0;
		}
*/


		i=7;
		// AI 8 : LO Pressure Engine Inlet, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=5;
					uiErrBit =6;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

		if ((uiEngineMode == MODE_START) || (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_UNLOAD))
		{
				// alarm for High/Low pressure of LO
			if ((st_ADC_Value[i].value < st_AlarmSetup.LO_PressureEngineInlet.LowAlarmByLoad[uiCurrentLoad]) || (st_ADC_Value[i].value > st_AlarmSetup.LO_PressureEngineInlet.HighAlarmByLoad[uiCurrentLoad]))
			{
				if (st_ADC_Value[i].flagWarn)
				{
					st_ADC_Value[i].delay_cnt_warn++;
					if (st_ADC_Value[i].delay_cnt_warn >st_AlarmSetup.LO_PressureEngineInlet.HighAlarmDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=5;
						uiErrBit =8;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagWarn=true;

			}
			else 
			{
			
				st_ADC_Value[i].delay_cnt_warn=false;
				st_ADC_Value[i].flagWarn=0;
			}

		}//		if ((uiEngineMode == MODE_START) || (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))

		if ((uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_UNLOAD))
		{
		

			// shutdown for High/Low pressure of LO
			if ((st_ADC_Value[i].value < st_AlarmSetup.LO_PressureEngineInlet.LowSDByLoad[uiCurrentLoad]) || (st_ADC_Value[i].value > st_AlarmSetup.LO_PressureEngineInlet.HighSDByLoad[uiCurrentLoad]))
			{
				if (st_ADC_Value[i].flagErr)
				{
					st_ADC_Value[i].delay_cnt++;
					if (st_ADC_Value[i].delay_cnt >st_AlarmSetup.LO_PressureEngineInlet.LowSDDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=5;
						uiErrBit =9;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagErr=true;

			}
			else 
			{
			
				st_ADC_Value[i].delay_cnt=0;
				st_ADC_Value[i].flagErr=0;
			}

		}//		if ( (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))



		i=8;
		// AI 9 : LO Pressure Engine Inlet, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=5;
					uiErrBit =6;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

		if ((uiEngineMode == MODE_START) || (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_UNLOAD))
		{
				// alarm for High/Low pressure of LO
			if ((st_ADC_Value[i].value < st_AlarmSetup.LO_PressureEngineInlet.LowAlarmByLoad[uiCurrentLoad]) || (st_ADC_Value[i].value > st_AlarmSetup.LO_PressureEngineInlet.HighAlarmByLoad[uiCurrentLoad]))
			{
				if (st_ADC_Value[i].flagWarn)
				{
					st_ADC_Value[i].delay_cnt_warn++;
					if (st_ADC_Value[i].delay_cnt_warn >st_AlarmSetup.LO_PressureEngineInlet.HighAlarmDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=5;
						uiErrBit =8;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagWarn=true;

			}
			else 
			{
			
				st_ADC_Value[i].delay_cnt_warn=false;
				st_ADC_Value[i].flagWarn=0;
			}

		}//		if ((uiEngineMode == MODE_START) || (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))

		if ((uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_UNLOAD))
		{
		

			// shutdown for High/Low pressure of LO
			if ((st_ADC_Value[i].value < st_AlarmSetup.LO_PressureEngineInlet.LowSDByLoad[uiCurrentLoad]) || (st_ADC_Value[i].value > st_AlarmSetup.LO_PressureEngineInlet.HighSDByLoad[uiCurrentLoad]))
			{
				if (st_ADC_Value[i].flagErr)
				{
					st_ADC_Value[i].delay_cnt++;
					if (st_ADC_Value[i].delay_cnt >st_AlarmSetup.LO_PressureEngineInlet.LowSDDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=5;
						uiErrBit =9;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagErr=true;

			}
			else 
			{
			
				st_ADC_Value[i].delay_cnt=0;
				st_ADC_Value[i].flagErr=0;
			}

		}//		if ( (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))

	
	

		i=9;
		// AI 10 : LO Pressure TCA Inlet, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=6;
					uiErrBit =4;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}


		if ((uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_UNLOAD))
		{
		

			// Low Pressure of LO  
			if ((st_ADC_Value[i].value < st_AlarmSetup.LO_PressureTCInlet.LowAlarmSetPoint))
			{
				if (st_ADC_Value[i].flagWarn)
				{
					st_ADC_Value[i].delay_cnt_warn++;
					if (st_ADC_Value[i].delay_cnt_warn >st_AlarmSetup.LO_PressureTCInlet.LowAlarmSetDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=6;
						uiErrBit =6;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagWarn=true;

			}
			else 
			{
			
				st_ADC_Value[i].delay_cnt_warn=0;
				st_ADC_Value[i].flagWarn=0;
			}

		}//		if ( (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))


		i=10;
		// AI 11 : LO Pressure Pilot Fuel Pump Inlet, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=6;
					uiErrBit =10;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

/*  /////////////////?????????????????  ¼³Á¤µÈ º¯¼ö¿Í ¿¡·¯ ¸®½ºÆ®°¡ ÀÏÄ¡ÇÏÁö ¾ÊÀ½.
	
	// ÇÁ·Î±×·¥ Ãß°¡ µÇ¾î¾ß ÇÔ. 
*/

	i=11;
		// AI 12 : HT water press Jacket Inlet, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=7;
					uiErrBit =9;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

		if ((uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_UNLOAD))
		{
		

			// Low Pressure of HT water alarm by map   
			if ((st_ADC_Value[i].value < st_AlarmSetup.HT_WaterPressureInlet.LowAlarmByLoad[uiCurrentLoad]))
			{
				if (st_ADC_Value[i].flagAlarm)
				{
					st_ADC_Value[i].delay_cnt_Alarm++;
					if (st_ADC_Value[i].delay_cnt_Alarm >st_AlarmSetup.HT_WaterPressureInlet.LowAlarmByLoadDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=7;
						uiErrBit =11;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagAlarm=true;

			}
			else 
			{
			
				st_ADC_Value[i].delay_cnt_Alarm=0;
				st_ADC_Value[i].flagAlarm=0;
			}

			//  Pressure Variance of HT water alarm by map   
			if (fabs(st_ADC_Value[i].value - st_ADC_Value[i].value_old)> st_AlarmSetup.HT_WaterPressureInlet.HighVarianceAlarm)
			{
				if (st_ADC_Value[i].flagWarn)
				{
					st_ADC_Value[i].delay_cnt_warn++;
					if (st_ADC_Value[i].delay_cnt_warn >st_AlarmSetup.HT_WaterPressureInlet.LowAlarmByLoadDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=7;
						uiErrBit =10;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagWarn=true;

			}
			else 
			{
			
				st_ADC_Value[i].delay_cnt_warn=0;
				st_ADC_Value[i].flagWarn=0;
			}

			/*   ///////////////////////ÇÁ·Î±×·¥ÀÌ Ãß°¡µÇ¾î¾ß ÇÔ. 



			*/


		}//		if ( (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))


			i=12;
		// AI 13 : LT water press, LT CAC Inlet, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=8;
					uiErrBit =3;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}


		if ((uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))
		{
	
			// Low Pressure of LT water alarm by map   
			if ((st_ADC_Value[i].value < st_AlarmSetup.LT_WaterPressureInlet.LowLRByLoad[uiCurrentLoad]))
			{
				if (st_ADC_Value[i].flagAlarm)
				{
					st_ADC_Value[i].delay_cnt_Alarm++;
					if (st_ADC_Value[i].delay_cnt_Alarm >st_AlarmSetup.LT_WaterPressureInlet.LowLRByLoadDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=8;
						uiErrBit =4;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagAlarm=true;

			}
			else 
			{
			
				st_ADC_Value[i].delay_cnt_Alarm=0;
				st_ADC_Value[i].flagAlarm=0;
			}

		}//		if ( (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))


		i=13;
		// AI 14 : LT control valve position, sensor error 

		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=8;
					uiErrBit =9;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

		if ((uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))
		{
	/////////////////////////////////  reference value ¸¦ Á¤ÀÇÇØ¼­ Ö¾îÁÖ¾î¾ß ÇÔ ??? 
			if (fabs(st_ADC_Value[i].value- st_ADC_Value[i].value_old) > st_AlarmSetup.LT_ControlValveActualPos.HighDeviationAlarmSetPoint)
			{
				if (st_ADC_Value[i].flagAlarm)
				{
					st_ADC_Value[i].delay_cnt_Alarm++;
					if (st_ADC_Value[i].delay_cnt_Alarm > st_AlarmSetup.LT_ControlValveActualPos.HighDeviationAlarmSetPointDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=8;
						uiErrBit =10;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagAlarm=true;

			}
			else 
			{
				st_ADC_Value[i].flagAlarm=false;
				st_ADC_Value[i].delay_cnt_Alarm=0;
			}

		}//		if ( (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))

		i=14;
		// AI 15 : HT control valve position, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=8;
					uiErrBit =11;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}


		if ((uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))
		{
	/////////////////////////////////  reference value ¸¦ Á¤ÀÇÇØ¼­ ³Ö¾îÁÖ¾î¾ß ÇÔ ???   ¾ÆÁ÷ Á¤ÀÇ µÇÁö ¾Ê¾ÒÀ½...
			if (fabs(st_ADC_Value[i].value- st_ADC_Value[i].value_old) > st_AlarmSetup.HT_ControlValveActualPos.HighDeviationAlarmSetPoint)
			{
				if (st_ADC_Value[i].flagAlarm)
				{
					st_ADC_Value[i].delay_cnt_Alarm++;
					if (st_ADC_Value[i].delay_cnt_Alarm > st_AlarmSetup.HT_ControlValveActualPos.HighDeviationAlarmSetPointDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=8;
						uiErrBit =12;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagAlarm=true;

			}
			else 
			{
				st_ADC_Value[i].flagAlarm=false;
				st_ADC_Value[i].delay_cnt_Alarm=0;
			}

		}//		if ( (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))


	    	i=15;
		// AI 16 : Nozzle Cooling water pressure engine inlet, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=8;
					uiErrBit =5;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

		if ((uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))
		{
	/////////////////////////////////  reference value ¸¦ Á¤ÀÇÇØ¼­ ³Ö¾îÁÖ¾î¾ß ÇÔ ??? 
			if (st_ADC_Value[i].value < st_AlarmSetup.NozzleCoolWaterPressure.AlarmSetPoint)
			{
				if (st_ADC_Value[i].flagAlarm)
				{
					st_ADC_Value[i].delay_cnt_Alarm++;
					if (st_ADC_Value[i].delay_cnt_Alarm > st_AlarmSetup.NozzleCoolWaterPressure.AlarmSetDelay*DelayTimeConstant) //error flag on  
					{
						uiErrGrp=8;
						uiErrBit =6;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagAlarm=true;

			}
			else 
			{
				st_ADC_Value[i].flagAlarm=false;
				st_ADC_Value[i].delay_cnt_Alarm=0;
			}

		}//		if ( (uiEngineMode == MODE_RUN)  || (uiEngineMode == MODE_LOAD))

	   	i=16;
		// AI 17 : Exh. WG Valve position, sensor error 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=11;
					uiErrBit =0;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}
/////////////////////   reference value ¿Í Â÷ÀÌ¸¦ °è»êÇØ¾ß ÇÏ´Â°¡??
		if (st_ADC_Value[i].value < st_AlarmSetup.ExhaustWGValve.HighVarianceAlarm)
		{
			if (st_ADC_Value[i].flagAlarm)
			{
				st_ADC_Value[i].delay_cnt_Alarm++;
				if (st_ADC_Value[i].delay_cnt_Alarm > st_AlarmSetup.ExhaustWGValve.HighVarianceAlarmDelay*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=11;
					uiErrBit =1;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagAlarm=true;

		}
		else 
		{
			st_ADC_Value[i].flagAlarm=false;
			st_ADC_Value[i].delay_cnt_Alarm=0;
		}


		i=17;
		// AI 18 : Charge Air pressure engine inlet, sensor error, main
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=11;
					uiErrBit =4;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

		i=18;
		// AI 19 : Charge Air pressure engine inlet, sensor error, backup sensor
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=11;
					uiErrBit =8;
					ErrorCoding();
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

// main sensor and backup sensor fail 
		if (ErrorDecoding(11,4) & ErrorDecoding(11,8))
		{
			if (uiFuelMode == FUEL_DIESEL) 
			{
				if (st_ADC_Value[i].flagAlarm)
				{
					st_ADC_Value[i].delay_cnt_Alarm++;
					if (st_ADC_Value[i].delay_cnt_Alarm > 5*DelayTimeConstant) //error flag on    //0.5sec by programmer ??
					{
						uiErrGrp=11;
						uiErrBit =9;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagAlarm=true;

			}
			else if ((uiFuelMode == FUEL_GAS) || (uiFuelMode == FUEL_DIESEL2GAS))
			{
				if (st_ADC_Value[i].flagGT)
				{
					st_ADC_Value[i].delay_cnt_GT++;
					if (st_ADC_Value[i].delay_cnt_GT > 5*DelayTimeConstant) //error flag on    //0.5sec by programmer ??
					{
						uiErrGrp=11;
						uiErrBit =9;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagGT=true;
			}

			/// think point 
			// ¿¡·¯ ÇìÁ¦ ·çÆ¾¿¡ ´ëÇÑ °í¹ÎÀÌ ÇÊ¿äÇÔ???
			// ¾î¶»°Ô ÇØ¾ß µÉ±î¿ä???
		}

		i=19;
		// AI 20 : Main gas pressure , sensor error, main
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{

		// Gas mode  ÀÎ °æ¿ì¸¸ µ¿ÀÛÇØ¾ß ÇÏ´Â°¡???
		//
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++;
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=12;
					uiErrBit =0;
					ErrorCoding();   
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}

		if ((uiFuelMode == FUEL_GAS) & (uiEngineMode == MODE_RUN))
		{

			if  (fabs(st_ADC_Value[i].value -st_AlarmSetup.Main_GasPressure.GasReferenceByLoad[uiCurrentLoad]) >  st_AlarmSetup.Main_GasPressure.HighDeviationAlarm) 
			{
				if (st_ADC_Value[i].flagAlarm)
				{
					st_ADC_Value[i].delay_cnt_Alarm++;
					if (st_ADC_Value[i].delay_cnt_Alarm > st_AlarmSetup.Main_GasPressure.HighDeviationAlarmDelay*DelayTimeConstant) //error flag on    //0.5sec by programmer ??
					{
						uiErrGrp=12;
						uiErrBit =1;
						ErrorCoding();
					}
				}
				else st_ADC_Value[i].flagAlarm=true;
			}
			else
			{
				st_ADC_Value[i].flagAlarm=false;
				st_ADC_Value[i].delay_cnt_Alarm =0;
			}
		}

		//////////////////  Ãß°¡ÇÒ °Í...
		//// error No 12. 3, 4, 5





		i=20;
		// AI 21 : Gas supply pressure , sensor error, main
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++; /// delay time is correct???
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=12;
					uiErrBit =6;
					ErrorCoding();   
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}


		if ((uiFuelMode == FUEL_GAS)) 
		{
			if (uiEngineMode == MODE_RUN)
			{
				if  (st_ADC_Value[i].value > st_AlarmSetup.Gas_SupplyPressure.HighGasTripSetPoint) 
				{
					if (st_ADC_Value[i].flagGT)
					{
						st_ADC_Value[i].delay_cnt_GT++;
						if (st_ADC_Value[i].delay_cnt_GT > st_AlarmSetup.Gas_SupplyPressure.HighGasTripSetDelay*DelayTimeConstant) //error flag on    //0.5sec by programmer ??
						{
							uiErrGrp=12;
							uiErrBit =7;
							ErrorCoding();
							// Gas trip
						}
					}
					else st_ADC_Value[i].flagGT=true;
				}
				else
				{
					st_ADC_Value[i].flagGT=false;
					st_ADC_Value[i].delay_cnt_GT =0;
				}
			}
			else
			{  // run ¸ðµå°¡ ¾Æ´Ï¸é ±×³É ¾Ë¶÷À» ¹æ»ý½ÃÅ´
				if  (st_ADC_Value[i].value > st_AlarmSetup.Gas_SupplyPressure.HighAlarmSetPoint) 
				{
					if (st_ADC_Value[i].flagAlarm)
					{
						st_ADC_Value[i].delay_cnt_Alarm++;
						if (st_ADC_Value[i].delay_cnt_Alarm > st_AlarmSetup.Gas_SupplyPressure.HighAlarmSetDelay*DelayTimeConstant) //error flag on    //0.5sec by programmer ??
						{
							uiErrGrp=12;
							uiErrBit =7;
							ErrorCoding();
							// Gas trip
						}
					}
					else st_ADC_Value[i].flagAlarm=true;
				}
				else
				{
					st_ADC_Value[i].flagAlarm=false;
					st_ADC_Value[i].delay_cnt_Alarm =0;
				}
			}
		}


		i=21;
		// AI 22 : FT50 Gas flow 
		//////////ÇÏ´Â ¿ªÇÒÀÌ ¾ø³×¿ä??????
/*
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++; /// delay time is correct???
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=12;
					uiErrBit =6;
					ErrorCoding();   
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}
*/


	i=22;
		// AI 23 : Gas Pressure, engine inlet 1 
 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++; /// delay time is correct???
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=13;
					uiErrBit =0;
					ErrorCoding();   
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}
 
		if (uiFuelMode == FUEL_GAS) 
		{
			if (uiEngineMode == MODE_RUN)
			{
				if  (fabs(st_ADC_Value[i].value - st_AlarmSetup.Gas_PressureEngineInlet.RefByLoad[uiCurrentLoad])>st_AlarmSetup.Gas_PressureEngineInlet.HighVarianceAlarm) 
				{
					if (st_ADC_Value[i].flagGT)
					{
						st_ADC_Value[i].delay_cnt_GT++;
						if (st_ADC_Value[i].delay_cnt_GT > st_AlarmSetup.Gas_PressureEngineInlet.HighVarianceAlarmDelay*DelayTimeConstant) //error flag on    //0.5sec by programmer ??
						{
							uiErrGrp=13;
							uiErrBit =1;
							ErrorCoding();
							// Gas trip
						}
					}
					else st_ADC_Value[i].flagGT=true;
				}
				else
				{
					st_ADC_Value[i].flagGT=false;
					st_ADC_Value[i].delay_cnt_GT =0;
				}
			}
		}
	

		i=23;
		// AI 24 : GVU Control Air Pressure
 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++; /// delay time is correct???
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=13;
					uiErrBit =2;
					ErrorCoding();   
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}
 
		if (uiFuelMode == FUEL_GAS) 
		{
			if (uiEngineMode == MODE_RUN)
			{
				if (st_ADC_Value[i].value < st_AlarmSetup.GVU_ControlAirPressure.LowGasTripSetPoint) 
				{
					if (st_ADC_Value[i].flagGT)
					{
						st_ADC_Value[i].delay_cnt_GT++;
						if (st_ADC_Value[i].delay_cnt_GT > st_AlarmSetup.Gas_PressureEngineInlet.HighVarianceAlarmDelay*DelayTimeConstant) //error flag on    //0.5sec by programmer ??
						{
							uiErrGrp=13;
							uiErrBit =1;
							ErrorCoding();
							// Gas trip
						}
					}
					else st_ADC_Value[i].flagGT=true;
				}
				else
				{
					st_ADC_Value[i].flagGT=false;
					st_ADC_Value[i].delay_cnt_GT =0;
				}
			}
 		}


/*   //////////// ¿¡·¯ ÄÚµå¿¡ Á¤ÀÇ µÈ°ÍÀÌ ¾øÀ½?????

	i=24;
		// AI 25 : Inert Gas Pressure  
 
		if ((st_ADC_Value[i].value < st_ADC_Value[i].Min) || (st_ADC_Value[i].value > st_ADC_Value[i].Max))
		{
			if (st_ADC_Value[i].flagLowHigh)
			{
				st_ADC_Value[i].delay_cnt_lowhigh++; /// delay time is correct???
				if (st_ADC_Value[i].delay_cnt_lowhigh > 3*DelayTimeConstant) //error flag on  
				{
					uiErrGrp=13;
					uiErrBit =2;
					ErrorCoding();   
				}
			}
			else st_ADC_Value[i].flagLowHigh=true;

		}
		else 
		{
			st_ADC_Value[i].flagLowHigh=false;
			st_ADC_Value[i].delay_cnt_lowhigh=0;
		}
*/



 
	//	st_ADC_Value[i].value_old =st_ADC_Value[i].value;
	

}


// ====================================================================== //
//	Function: AI_Update
//		- Read AD converter value and write DA value
// ---------------------------------------------------------------------- //
void AI_Update(void)
{
int i=0;  

	ADC_Update();

	for(i=0; i<=29; i++)
	{
//		DPUpMem[i]=s_ADC_In.ADC_Data[i];
		st_ADC_Value[i].value_old =st_ADC_Value[i].value;
		st_ADC_Value[i].value =s_ADC_In.ADC_Data[i];
	}

	Measured_Load = (int)((st_ADC_Value[25].value-3.98)*6.25); 
	if (Measured_Load < 0) Measured_Load=0;
}


// ====================================================================== //
//	Function: Gas Leakage Test_Process
//		- Process for the gas mode operation, 
// ---------------------------------------------------------------------- //
// ¸®ÅÏ°ª¿¡ ´ëÇØ °í¹ÎÇØ º¼°Í.. °ú¿¬ ÇÊ¿äÇÒ±î??
unsigned char GasLeakageTest(void)
{
	switch  (bGasLeakageTestMode)
	{
	case 0x00:
		if ((Main_do1.bit.SV54_1GasValve1 == CLOSE) && (Main_do1.bit.SV54_2GasValve2 == CLOSE) && (Main_do1.bit.SV55_1GasVent1 == CLOSE) && (Main_do1.bit.SV55_2GasVent2 == CLOSE) && (Main_do1.bit.SV55_3GasVent3 == CLOSE) )
		{
			bGasLeakageTestMode = 0x02;
		}
		else
		{
			Main_do1.bit.SV54_1GasValve1 = CLOSE;
			Main_do1.bit.SV54_2GasValve2 = CLOSE;
			Main_do1.bit.SV55_1GasVent1 = CLOSE ;
			Main_do1.bit.SV55_2GasVent2 = CLOSE;
			Main_do1.bit.SV55_3GasVent3 = CLOSE;


			TmrSetT(0, 5000);  //5 sec timer for gas Leakage Test sequence 1

			TmrStart(0);

			bGasLeakageTestMode = 0x01;
		}
 	


	break;
	case 0x01: //wait timer time out 

	break;
	case 0x02:
		Main_do1.bit.SV55_3GasVent3 = CLOSE;// VV3 Open
		TmrSetT(0, 5000);  //5 sec timer for gas Leakage Test sequence 2

	    TmrStart(0);
		// save current pressure PT0 to compare with later pressure. 
		fGasPressureOld =st_ADC_Value[C1_PT52_GAS_PRESSURE_ENGINE_INLET].value;  // Á¤È®ÇÑ °ªÀ» È®ÀÎÇÒ °Í!!!!

		bGasLeakageTestMode =( bGasLeakageTestMode <<1); // mode change to 0x04 

	break;
	case 0x04: //wait timer time out 
	// 5sec µ¿¾È °ªÀ» À¯Áö 

	break;
	case 0x08: //end of Ventilation 
		fGasPressure =st_ADC_Value[C1_PT52_GAS_PRESSURE_ENGINE_INLET].value;  // Á¤È®ÇÑ °ªÀ» È®ÀÎÇÒ °Í!!!!

		if (fabs(fGasPressure-fGasPressureOld) < 1.0)  // ¾Ð·ÂÂ÷°¡ 1 bar ÀÌÇÏ¸é Á¤»ó 
		{
			Main_do1.bit.SV54_1GasValve1 = OPEN;// SV1 open  //
			
			TmrSetT(0, 5000);  //5 sec timer for gas Leakage Test sequence 3

	    	TmrStart(0);

			bGasLeakageTestMode =( bGasLeakageTestMode <<1); // mode change to 0x10 
		}
		else
		{
			return FALSE;
		}
	break;
	case 0x10: //wait timer leakage test 2 time out 


	break;
	case 0x20: //check that gas pressure is increased  
		fGasPressure =st_ADC_Value[C1_PT52_GAS_PRESSURE_ENGINE_INLET].value;  // Á¤È®ÇÑ °ªÀ» È®ÀÎÇÒ °Í!!!!

		if (fabs(fGasPressure-fGasPressureOld) > 1.0)  // ¾Ð·ÂÂ÷°¡ 1 bar ÀÌÇÏ¸é Á¤»ó 
		{
			Main_do1.bit.SV54_1GasValve1 = CLOSE;// SV1 open  //
			
			TmrSetT(0, 5000);  //5 sec timer for gas Leakage Test sequence 3

	    	TmrStart(0);
			fGasPressureOld =fGasPressure;

			bGasLeakageTestMode =( bGasLeakageTestMode <<1); // mode change to 0x40 
		}
		else
		{
			return FALSE;
		}

	break;
	case 0x40: //wait timer leakage test 3 time out 


	break;
	case 0x80: //check that gas pressure is increased  
		fGasPressure =st_ADC_Value[C1_PT52_GAS_PRESSURE_ENGINE_INLET].value;  // Á¤È®ÇÑ °ªÀ» È®ÀÎÇÒ °Í!!!!

		if (fabs(fGasPressure-fGasPressureOld) > 1.0)  // ¾Ð·ÂÂ÷°¡ 1 bar ÀÌÇÏ¸é Á¤»ó 
		{// gas leakage test ok. 
			Main_do1.bit.SV55_3GasVent3 = CLOSE;// SV1 open  //

			bGasLeakageTestMode =0x00; // mode clear
			return TRUE; 
		}
		else
		{
			return FALSE;
		}

//	break;

	default: //wait timer time out 

	break;

	}

	return FALSE;
}

// ====================================================================== //
//	Function: Exhaust Gas Ventilation_Process
//		- Process for the gas mode operation, 
// ---------------------------------------------------------------------- //

unsigned char Ventilation(void)
{
	switch  (bVentilationMode)
	{
	case 0x00:
		if (Measured_Speed < 1)  // 1 RPMÀÌÇÏ¸é µ¿ÀÛ 
		{
			TmrSetT(0, 10000);  //10 sec timer for gas ventilation sequence 1
			TmrStart(0);
			bVentilationMode = 0x01;
		}

	break;
	case 0x01: //wait timer time out 

	break;
	case 0x02:

		Main_do1.bit.SV54_1GasValve1 = CLOSE;
		Main_do1.bit.SV54_2GasValve2 = CLOSE;

		Main_do1.bit.SV55_1GasVent1 = CLOSE;
		Main_do1.bit.SV55_2GasVent2 = CLOSE;
		Main_do1.bit.SV55_3GasVent3 = CLOSE;


	
		bVentilationMode = 	0x00; // mode clear
		return TRUE;
		 

  //	break;

	default: //wait timer time out 

	break;

	}

	return FALSE;
}

// ====================================================================== //
//	Function: Exhaust Gas Ventilation Check_Process
//		- Process for the gas mode operation, 
// ---------------------------------------------------------------------- //

unsigned char ExhaustGasVent(void)
{
	switch  (uiSubMode)
	{
	case 0x00:
	Main_do1.bit.SV54_1GasValve1 = CLOSE;
	Main_do1.bit.SV54_2GasValve2 = CLOSE;

	Main_do1.bit.SV55_1GasVent1 = OPEN;
	Main_do1.bit.SV55_2GasVent2 = OPEN;
	Main_do1.bit.SV55_3GasVent3 = OPEN;

	TmrSetT(0, 10000);  //10 sec timer for gas ventilation sequence 1

 	TmrStart(0);

	uiSubMode = 0x01;

	break;
	case 0x01: //wait timer time out 

	break;
	case 0x02:
		Main_do1.bit.SV55_1GasVent1 = CLOSE;// VV1 close 
		TmrSetT(0, 10000);  //10 sec timer for gas ventilation sequence 2

	    TmrStart(0);
		uiSubMode = 	(uiSubMode<<1); // mode change to 0x04 

	break;
	case 0x04: //wait timer time out 

	break;
	case 0x08: //end of Ventilation 
		Main_do1.bit.SV55_3GasVent3 = CLOSE;// VV3 close  //
		uiSubMode = 0x00;  // mode clear
		return TRUE;
	//break;
	default: //wait timer time out 

	break;

	}

	return FALSE;
}

// ====================================================================== //
//	Function: Start_Block_Check_Process
//		- Process for the start block
// ---------------------------------------------------------------------- //
unsigned char Check_StartBlock(void)
{
	if (!Main_di1.bit.StopLeverStopPos)  // stop lever is in stop pos? 1= stop Pos, 0= no
	{
		if (!Main_di1.bit.TurningGearEngaged)  // Turning Gear is engaged? 1 = yes, 0= no
		{ 
			if (Main_di2.bit.StandbyFromPMS)  //stanby signal from PMS 
			{
				if (!Main_di2.bit.StartBlockFromPMS)  //start block signal  from PMS 
				{   // Pre-lubrication pressure check (AI 7)
					if (st_ADC_Value[C1_LO_PRESSURE_ENGINE_INLET].value>st_AlarmSetup.LO_PressureEngineInlet.LowStartBlock)
					{
					// HT-water Temp. RTD3
						if (st_C1CanFeedback.HTWaterTempJacketIn >st_AlarmSetupC1_Can.HT_WaterTempInlet.LowAlarmSetPoint) // 45 or 50 degree 
						{
							if (Measured_Speed < 1)// below 1rpm, engine is stopped
							{
								if (uiEngineMode < MODE_STOP) // engine mode is not stop
								{
									if (!Main_di2.bit.LFO_HFOSelect)  //HFO select signal =0, for engine start
									{
										if (uiFuelMode == FUEL_GAS)// °¡½º ±âµ¿ ¸ðµåÀÎ °æ¿ì 
										{
											if (bExhaustGasVentilation) // ExhaustGasVentilation 
											{// Fuel oil temp. from RTD 1 
													if (st_C1CanFeedback.MainFOTempEngineIn < st_AlarmSetupC1_Can.FO_Temp.HighStartBlock)
													return true;
													else 
													{
														uiErrGrp=3;
														uiErrBit =4;
														ErrorCoding();  
														return false;
													}
											}
											else 
												{  //GasVentilation error  ??????
													uiErrGrp=3;
													uiErrBit =4;
													ErrorCoding();  
													return false;
												}

										}
										else  // gas ±âµ¿ ¸ðµå°¡ ¾Æ´Ñ °æ¿ì 
										{
											return true;
										}

									}
									else  //if (!Main_di2.bit.LFO_HFOSelect)
									{// LFO selected
									//	uiErrGrp=3;
									//	uiErrBit =4;
									//	ErrorCoding(); 
										return false;
									}

								}
								else  //if (uiEngineMode < MODE_STOP) // engine mode is not stop
								{// LFO selected
								//	uiErrGrp=3;
								//	uiErrBit =4;
								//	ErrorCoding(); 
									return false;
								}

							}
							else 	//if (Measured_Speed < 1)// below 1rpm, engine is stopped
							{// No stop at ready state
							 	uiErrGrp=1;
							 	uiErrBit =7;
							 	ErrorCoding(); 
								return false;
							}

						}
						else
						//	 if (st_C1CanFeedback.HTWaterTempJacketIn >st_AlarmSetupC1_Can.HT_WaterTempInlet.LowAlarmSetPoint) // 45 or 50 degree 
						{// // HT-water Temp. RTD3 Low temperature of HT water <50 degree
							uiErrGrp=7;
							uiErrBit =2;
							ErrorCoding(); 
							return false;
						}
				
						
					}
					else 
					//	 if (st_ADC_Value[C1_LO_PRESSURE_ENGINE_INLET].value>st_AlarmSetup.LO_PressureEngineInlet.LowStartBlock)
					{ //Low pressure of LO <0.5 bar
						uiErrGrp=5;
						uiErrBit =10;
						ErrorCoding(); 
						return false;
					}
				}
				else 
			//	 	if (!Main_di2.bit.StartBlockFromPMS)  //start block signal  from PMS 
				{// Remote start blocking request
				 	uiErrGrp=17;
				 	uiErrBit =3;
				 	ErrorCoding(); 
					return false;
				}
			}
			else 
			//	if (Main_di2.bit.StandbyFromPMS)  //stanby signal from PMS
			{// // HT-water Temp. RTD3
			//	uiErrGrp=3;
			//	uiErrBit =4;
			//	ErrorCoding(); 
				return false;
			}
		}
		else 
		//		if (!Main_di1.bit.TurningGearEngaged)  // Turning Gear is engaged? 1 = yes, 0= no
		{// // HT-water Temp. RTD3
			uiErrGrp=2;
			uiErrBit =11;
		 	ErrorCoding(); 
			return false;
		}
	}
	else 
	//	if (!Main_di1.bit.StopLeverStopPos)  // stop lever is in stop pos? 1= stop Pos, 0= no
	{// Stop lever in stop position
 		uiErrGrp=16;
		uiErrBit =0;
	 	ErrorCoding(); 
		return false;
	}
//	return false;
}

// ====================================================================== //
//	Function: DI_Process
//		- Process according to the digital input
// ---------------------------------------------------------------------- //
void DI_Process(void)
{

	if (uiDeviceID ==MAIN_BOARD) // Main Controll C1 
	{
	 
		Main_di1.all = s_Main_DIO.DI.M1.all = DIN1;
		Main_di2.all = s_Main_DIO.DI.M2.all = DIN2;

		uiLocalOpmode =	Main_di1.bit.LocalSW; 
		if (uiLocalOpmode)  //  Local Operation Mode = 1, check local op parameter
		{
			if ((uiEngineMode ==MODE_RUN ) || (uiEngineMode ==MODE_LOAD )) //¿£ÁøÀÌ Á¤»ó ¿îÀü ÁßÀÎ °æ¿ì¿¡¸¸ µ¿ÀÛ 
			{	
				if (Main_di1.bit.SpeedInc)  // engine speed reference increase 
				{
					Speed_Reference+=10;// 10 RPM Áõ°¡ 
					if (Speed_Reference> stSetup.StartSpeed4)// 10 RPM Áõ°¡ 
					Speed_Reference=stSetup.StartSpeed4;// 10 RPM Áõ°¡ 
				}

				if (Main_di1.bit.SpeedDec)  // engine speed reference decrease 
				{
					Speed_Reference-=10;// 10 RPM °¨¼Ò  
					if (Speed_Reference< stSetup.StartSpeed2)// ÃÖ¼Ò µ¿ÀÛ ¼Óµµ
					Speed_Reference=stSetup.StartSpeed2;// 10 RPM Áõ°¡ 
				}
			}

			if (uiEngineMode == MODE_READY) // ¿îÀü ´ë±âÁßÀÎ °æ¿ì¿¡¸¸ start enable
			{
				if (Main_di1.bit.Start) // engine start 
				{// engine start 
					uiEngineStart = TRUE;
				}
			}

			if (uiEngineMode == MODE_RUN) // ¹«ºÎÇÏ ¿îÀü ÁßÀÎ °æ¿ì¿¡¸¸ start stop
			{
				if (Main_di1.bit.Stop) // engine stop 
				{// engine stop
					 uiEngineMode=MODE_SHUTDOWN;
					 uiSubMode=0x01;
				}
			}

			if ((uiEngineMode > MODE_STOP) && (uiEngineMode < MODE_EMERGENCY))
			{
				if (Main_di1.bit.EmcyStop)  // engine emergency stop
				{
					 uiEngineMode=MODE_SHUTDOWN;
					 uiSubMode=0x01;
				}
			} 
		} // end of local op mode bit
		// signal from PMS 
		// Fuel Mode check routine is needed?!!!
		if (Main_di2.bit.BlackoutmodeFromPMS)
		{
			uiFuelMode = FUEL_BACKUP;
		}
		if (Main_di2.bit.DieselOPmodeFromPMS)
		{
			uiFuelMode = FUEL_DIESEL;
		}
		if (Main_di2.bit.GasOPmodeFromPMS)
		{
			uiFuelMode = FUEL_GAS;
		}

		if (Main_di2.bit.EngineSDfromPMS) // engine shutdown signal from PMS
		{
			 uiEngineMode=MODE_SHUTDOWN;
			 uiSubMode=0x01;
		}

		// start block check 
//		if (uiFuelMode>FUEL_BACKUP) 
//			if (uiEngineMode==MODE_INIT)
//				uiEngineReady= Check_StartBlock();


//		if ((uiFuelMode == FUEL_GAS) && (uiEngineReady))
//		{// check fuel oil temp. is less than 70deg. 
		 //	if (s_ADC_In.ADC_Data[   if (bExhaustGasVentilation)

//		}


	}



}

// ====================================================================== //
//	Function: State_Diesel
//		- gas & diesel engine , fuel mode = diesel,  check state  
// state : uiEngineMode, uiSubMode
// ---------------------------------------------------------------------- //
void State_Diesel(void)
{
	if (uiEngineMode == MODE_INIT) //¿£ÁøÀÌ Á¤ÁöÇÏ°í ÀÖ´Â µ¿¾È¿¡¸¸ ½ÃÀÛ ½ÃÄÁ½º¸¦ È®ÀÎÇÔ. 
	{
		uiEngineReady= Check_StartBlock();
		if (uiEngineReady) 
		{
			uiEngineMode = MODE_READY;
			uiSubMode =0x01;
		}
	}
	else if (uiEngineMode == MODE_READY)
	{

		if (uiEngineStart)// wait for engine start sig.
		{
			uiEngineMode = MODE_START;
			uiSubMode=0x00;
		}

	}
	else if (uiEngineMode == MODE_START)
	{

		switch (uiSubMode)
		{
			case 0x00:  // slow turning on
					TmrSetT(0, 10000);  //10 sec timer for start sequence 1 

			 		TmrStart(0);

					Phase_Count_Old =Phase_M_ISR_Count;  // phase count memorize to compare for 2 rotation
					Main_do1.bit.SlowTurningValve =1; // slow turning on
					uiSubMode =0x01;

			break;
			case 0x01:

				Phase_Count =Phase_M_ISR_Count;  // phase count memorize to compare for 2 rotation
				if (fabs(Phase_Count-Phase_Count_Old)>=2)
				{
					Main_do1.bit.StartValve =1;  // starting valve on
					uiSubMode = (uiSubMode <<1);  // 0x02  
				}

			break;
			case 0x02:
				if (Measured_Speed > stSetup.StartSpeed1)  //  Check Engine speed in the start_up sequence.   //30RPMÀÌ»óÀÌ¸é ¿£Áö ½Ãµ¿ÁßÀ¸·Î ÀÎ½ÄÇÔ.
				{
					//init some parameter
					Parameter_Reset();

					SubDOCmd.bit.EngineControlLamp =1;
					SubDOCmd.bit.RunningLamp =1;
					// ÇöÀç idle Rate setting value 
					if (Main_di2.bit.RatedIdleSelect)
					Speed_Reference =stSetup.RatedSpeedRef;
					else Speed_Reference =stSetup.IdleSpeedRef;

					TmrSetT(1, 30000);  //30 sec timer for start sequence 1 
 				    TmrStart(1);
			 	  
					control_value = stSetup.StartFuelRef*(20.-4.)/100.+4. ;					// 25% ¿¬·á·¢ ¿ÀÇÂ
					DAC_Out_mA(uiCmdOutCh, control_value);
					uiSubMode= (uiSubMode <<1);  // 0x04   

				}

			break;
			case 0x04:
				if (Measured_Speed > stSetup.StartSpeed2)  //  Check Engine speed in the start_up sequence.   //80RPMÀÌ»óÀÌ¸é ¿£Áö ½Ãµ¿ÁßÀ¸·Î ÀÎ½ÄÇÔ.
				{
					Main_do1.bit.SlowTurningValve =0; // slow turning off
					Main_do1.bit.StartValve =0;  // starting valve off
					uiSubMode= (uiSubMode <<1);  // 0x08 
				}
			break;
			case 0x08:
				if (Measured_Speed > stSetup.StartSpeed3)  //  Check Engine speed in the start_up sequence.   //160RPMÀÌ»óÀÌ¸é ¿£Áö ½Ãµ¿ÁßÀ¸·Î ÀÎ½ÄÇÔ.
				{// fuel rack close, pilot injection check, sequence start
					control_value = 4. ;					// 0% ¿¬·á·¢ close
					DAC_Out_mA(uiCmdOutCh, control_value);
					// sequence modify!!! 
//					Send_Can_Message();  // send can data to pilot injection 
					uiSubMode= (uiSubMode <<1);  // 0x10 
				}
			break;
			case 0x10://½Ç¸°´õ ¹è±â°¡½º ¿Âµµ > HT water jacket inlet temp.+20 degree check
				if (st_C1CanFeedback.CATempEngineIn >(st_C1CanFeedback.HTWaterTempJacketIn+20.0))
				{// pilot injection check sequence end, pilot injection normal mode start
				// main fuel rack control start
					uiSubMode= (uiSubMode <<1);  // 0x20 
					Speed_Command=Speed_Reference;
		 
//					PID_Calculate();
					bPID_Enable =true;

				}
			break;
			case 0x20://velocity check 
//					PID_Calculate();
					bPID_Enable =true;
				if (Measured_Speed > stSetup.StartSpeed4)  //  Check Engine speed in the start_up sequence.   //160RPMÀÌ»óÀÌ¸é ¿£Áö ½Ãµ¿ÁßÀ¸·Î ÀÎ½ÄÇÔ.
				{
					uiEngineMode = MODE_RUN;
					uiSubMode=0x01;
				}


			break;

			default:

			break;
		}


	}
	else if (uiEngineMode == MODE_RUN)
	{
		Speed_Command=Speed_Reference;
		// PID Output calculate 
//		PID_Calculate();
		bPID_Enable =true;
		
		SubDOCmd.bit.RunningLamp =1;	
		SubDOCmd.bit.EngineRunning2MSB =1;	


			switch (uiSubMode)
		{
			case 0x01:// parameter initial 
			mPid._window_time_cnt=0;
			mPid.tracking_time=0;
			uiSubMode= (uiSubMode <<1);  // 0x02 

			break;
			case 0x02:// check for speed =0
				if( Measured_Speed<= stSetup.StartSpeed1) 
				{
					if(mPid._window_time_cnt > mPid.WindowTime) 
					{
						// run mode change 
						uiEngineMode =MODE_SHUTDOWN;
						uiSubMode =0x01;
					}
					else mPid._window_time_cnt++;
				} 
				else 
				{
	 
					mPid._window_time_cnt = 0;
				}
				///  Gas change mode Ãß°¡ÇØ¾ß ÇÔ. !!!!

			break;
			default:


			break;
		}
	}
	else if (uiEngineMode == MODE_SHUTDOWN) 	 // Engine shut down mode 
	{
		control_value = 4.;
		DAC_Out_mA(uiCmdOutCh, control_value);
		bPID_Enable =false;

		SubDOCmd.bit.RunningLamp =0;
		SubDOCmd.bit.EngineRunning2MSB =0;
		switch (uiSubMode)
		{
			case 0x01:  // timer setting for 30 sec delay 
			// check for start fail count, if start fail count > limit then stop on ??? °ú¿¬ ÇÊ¿äÇÑ°¡??
			mPid._window_time_cnt =0;
			mPid.tracking_time=0;

			iStartFailCnt++;

			// ±âµ¿ ½ÇÆÐ È½¼ö°¡ ÃÖ´ë Á¦ÇÑ È½¼ö º¸´Ù Å« °æ¿ì¿¡ 
			if (iStartFailCnt > MaxStartFail)
			{
				uiEngineMode =MODE_EMERGENCY;
				uiSubMode = 0x01;
			}


			uiSubMode = (1<<1);
			break;
			
			case 0x02:

			if (Measured_Speed < 1.0)  // measured speed < 1 --> engine stopped
			{// engine speed <1 for 10 sec then engine is stopped. 
					if(mPid._window_time_cnt > mPid.WindowTime) 
					{
						// run mode change 
			
						uiSubMode =(uiSubMode<<1);
					}
					else mPid._window_time_cnt++;
			} 
			else 
			{
				mPid._window_time_cnt = 0;
			}

			mPid.tracking_time++;
			if ( mPid.tracking_time > 30*100 )	// 30ÃÊ°¡ Áö³¯ µ¿¾È¿¡µµ 3ÃÊ ÀÌ»ó 5%ÀÌ³» À¯Áö°¡ ¾ÈµÉ °æ¿ì				
			{
			// change to shut down mode 
				// run mode change 
					uiEngineMode =MODE_EMERGENCY;
					uiSubMode =0x01;
			}
			
			break; 	
			case 0x04:
				 	TmrSetT(0, 3000);//30000);  //30 sec timer for start sequence 1 

 				    TmrStart(0);
					uiSubMode =(uiSubMode<<1);
			break;
			case 0x08:// wait for timer event 
			
			// do nothing 
			break;
			default:


			break;

			}

//		if (velocity < 1RPM ) // engine is stopped then start restart timer
	}
	else if (uiEngineMode == MODE_EMERGENCY) 	 // Engine shut down mode 
	{
		
		uiEngineMode =0;
		uiSubMode=1;
		bPID_Enable =false;
		control_value = 4.0;
		DAC_Out_mA(uiCmdOutCh, control_value);
	}
	else
	{//uiTestFlag
		control_value = 4.0;
		DAC_Out_mA(uiCmdOutCh, control_value);
		bPID_Enable =false;
		uiSubMode=1;
	// parameter initial for restart
//		Speed_Command = 200;
	}



}


// ====================================================================== //
//	Function: State_DieselGas
//		- DF, gas engine , check state  
// state : uiEngineMode, uiSubMode
// ---------------------------------------------------------------------- //
void State_DieselGas(void)
{
	if (uiEngineMode == MODE_INIT) //¿£ÁøÀÌ Á¤ÁöÇÏ°í ÀÖ´Â µ¿¾È¿¡¸¸ ½ÃÀÛ ½ÃÄÁ½º¸¦ È®ÀÎÇÔ. 
	{
		uiEngineReady= Check_StartBlock();
		if (uiEngineReady) 
		{
			uiEngineMode = MODE_READY;
			uiSubMode =0x01;
		}
	}
	else if (uiEngineMode == MODE_READY)
	{

		if (uiEngineStart)// wait for engine start sig.
		{
			uiEngineMode = MODE_START;
			uiSubMode=0x00;
			bGasLeakageTestMode=0x00; // Gas LeakageTest Mode init

			bGasLeakageTestResult =0x00;
		}

	}
	else if (uiEngineMode == MODE_START)
	{

		switch (uiSubMode)
		{
			case 0x00:  // gas leakage test
				bGasLeakageTestResult =GasLeakageTest();
				if (bGasLeakageTestResult)
				{
					uiSubMode =0x01;
					TmrSetT(0, 10000);  //10 sec timer for start sequence 1 

			 		TmrStart(0);

					Phase_Count_Old =Phase_M_ISR_Count;  // phase count memorize to compare for 2 rotation
					Main_do1.bit.SlowTurningValve =1; // slow turning on
				}

			break;
			case 0x01:

				Phase_Count =Phase_M_ISR_Count;  // phase count memorize to compare for 2 rotation
				if (fabs(Phase_Count-Phase_Count_Old)>=2)
				{
					Main_do1.bit.StartValve =1;  // starting valve on
					uiSubMode = (uiSubMode <<1);  // 0x02  
				}

			break;
			case 0x02:
				if (Measured_Speed > stSetup.StartSpeed1)  //  Check Engine speed in the start_up sequence.   //30RPMÀÌ»óÀÌ¸é ¿£Áö ½Ãµ¿ÁßÀ¸·Î ÀÎ½ÄÇÔ.
				{
					//init some parameter
					Parameter_Reset();

					SubDOCmd.bit.EngineControlLamp =1;
					SubDOCmd.bit.RunningLamp =1;
					// ÇöÀç idle Rate setting value 
					if (Main_di2.bit.RatedIdleSelect)
					Speed_Reference =stSetup.RatedSpeedRef;
					else Speed_Reference =stSetup.IdleSpeedRef;

					TmrSetT(1, 30000);  //30 sec timer for start sequence 1 
 				    TmrStart(1);
			 	  
					control_value = stSetup.StartFuelRef*(20.-4.)/100.+4. ;					// 25% ¿¬·á·¢ ¿ÀÇÂ
					DAC_Out_mA(uiCmdOutCh, control_value);
					uiSubMode= (uiSubMode <<1);  // 0x04   

				}

			break;
			case 0x04:
				if (Measured_Speed > stSetup.StartSpeed2)  //  Check Engine speed in the start_up sequence.   //80RPMÀÌ»óÀÌ¸é ¿£Áö ½Ãµ¿ÁßÀ¸·Î ÀÎ½ÄÇÔ.
				{
					Main_do1.bit.SlowTurningValve =0; // slow turning off
					Main_do1.bit.StartValve =0;  // starting valve off
					uiSubMode= (uiSubMode <<1);  // 0x08 
				}
			break;
			case 0x08:
				if (Measured_Speed > stSetup.StartSpeed3)  //  Check Engine speed in the start_up sequence.   //160RPMÀÌ»óÀÌ¸é ¿£Áö ½Ãµ¿ÁßÀ¸·Î ÀÎ½ÄÇÔ.
				{// fuel rack close, pilot injection check, sequence start
					control_value = 4. ;					// 0% ¿¬·á·¢ close
					DAC_Out_mA(uiCmdOutCh, control_value);
					// sequence modify!!! 
//					Send_Can_Message();  // send can data to pilot injection 
					uiSubMode= (uiSubMode <<1);  // 0x10 
				}
			break;
			case 0x10://½Ç¸°´õ ¹è±â°¡½º ¿Âµµ > HT water jacket inlet temp.+20 degree check
				if (st_C1CanFeedback.CATempEngineIn >(st_C1CanFeedback.HTWaterTempJacketIn+20.0))
				{// pilot injection check sequence end, pilot injection normal mode start
				// main fuel rack control start
					uiSubMode= (uiSubMode <<1);  // 0x20 
					Speed_Command=Speed_Reference;
		 
//					PID_Calculate();
					bPID_Enable =true;

				}
			break;
			case 0x20://velocity check 
//					PID_Calculate();
					bPID_Enable =true;
				if (Measured_Speed > ((float)stSetup.StartSpeed4))  //  Check Engine speed in the start_up sequence.   //160RPMÀÌ»óÀÌ¸é ¿£Áö ½Ãµ¿ÁßÀ¸·Î ÀÎ½ÄÇÔ.
				{
					uiEngineMode = MODE_RUN;
					uiSubMode=0x01;
				}


			break;

			default:

			break;
		}


	}
	else if (uiEngineMode == MODE_RUN)
	{
		Speed_Command=Speed_Reference;
		// PID Output calculate 
//		PID_Calculate();
			bPID_Enable =true;
		
		SubDOCmd.bit.RunningLamp =1;	
		SubDOCmd.bit.EngineRunning2MSB =1;	


			switch (uiSubMode)
		{
			case 0x01:// parameter initial 
			mPid._window_time_cnt=0;
			mPid.tracking_time=0;
			uiSubMode= (uiSubMode <<1);  // 0x02 

			break;
			case 0x02:// check for speed =0
				if( Measured_Speed<= ((float)stSetup.StartSpeed1) ) 
				{
					if(mPid._window_time_cnt > mPid.WindowTime) 
					{
						// run mode change 
						uiEngineMode =MODE_SHUTDOWN;
						uiSubMode =0x01;
					}
					else mPid._window_time_cnt++;
				} 
				else 
				{
	 
					mPid._window_time_cnt = 0;
				}
				///  Gas change mode Ãß°¡ÇØ¾ß ÇÔ. !!!!

			break;
			default:


			break;
		}
	}
	else if (uiEngineMode == MODE_SHUTDOWN) 	 // Engine shut down mode 
	{
		control_value = 4.;
		DAC_Out_mA(uiCmdOutCh, control_value);

		bPID_Enable =false;
		SubDOCmd.bit.RunningLamp =0;
		SubDOCmd.bit.EngineRunning2MSB =0;
		switch (uiSubMode)
		{
			case 0x01:  // timer setting for 30 sec delay 
			// check for start fail count, if start fail count > limit then stop on ??? °ú¿¬ ÇÊ¿äÇÑ°¡??
			mPid._window_time_cnt =0;
			mPid.tracking_time=0;

			iStartFailCnt++;

			// ±âµ¿ ½ÇÆÐ È½¼ö°¡ ÃÖ´ë Á¦ÇÑ È½¼ö º¸´Ù Å« °æ¿ì¿¡ 
			if (iStartFailCnt > MaxStartFail)
			{
				uiEngineMode =MODE_EMERGENCY;
				uiSubMode = 0x01;
			}


			uiSubMode = (1<<1);
			break;
			
			case 0x02:

			if (Measured_Speed < 1.0)  // measured speed < 1 --> engine stopped
			{// engine speed <1 for 10 sec then engine is stopped. 
					if(mPid._window_time_cnt > mPid.WindowTime) 
					{
						// run mode change 
			
						uiSubMode =(uiSubMode<<1);
					}
					else mPid._window_time_cnt++;
			} 
			else 
			{
				mPid._window_time_cnt = 0;
			}

			mPid.tracking_time++;
			if ( mPid.tracking_time > 30*100 )	// 30ÃÊ°¡ Áö³¯ µ¿¾È¿¡µµ 3ÃÊ ÀÌ»ó 5%ÀÌ³» À¯Áö°¡ ¾ÈµÉ °æ¿ì				
			{
			// change to shut down mode 
				// run mode change 
					uiEngineMode =MODE_EMERGENCY;
					uiSubMode =0x01;
			}
			
			break; 	
			case 0x04:
				 	TmrSetT(0, 3000);//30000);  //30 sec timer for start sequence 1 

 				    TmrStart(0);
					uiSubMode =(uiSubMode<<1);
			break;
			case 0x08:// wait for timer event 
			
			// do nothing 
			break;
			default:


			break;

			}

//		if (velocity < 1RPM ) // engine is stopped then start restart timer
	}
	else if (uiEngineMode == MODE_EMERGENCY) 	 // Engine shut down mode 
	{
		
		uiEngineMode =0;
		uiSubMode=1;
		bPID_Enable =false;
		control_value = 4.0;
		DAC_Out_mA(uiCmdOutCh, control_value);
	}
	else
	{//uiTestFlag
		bPID_Enable =false;
		control_value = 4.0;
		DAC_Out_mA(uiCmdOutCh, control_value);
		uiSubMode=1;
	// parameter initial for restart
//		Speed_Command = 200;
	}

}


// ====================================================================== //
//	Function: State_Backup
//		- backup mode, check state  
// state : uiEngineMode, uiSubMode
// original governor controll 
// ---------------------------------------------------------------------- //
void State_Backup(void)
{
	if (uiEngineMode == MODE_READY) //¿£ÁøÀÌ Á¤ÁöÇÏ°í ÀÖ´Â µ¿¾È¿¡¸¸ ½ÃÀÛ ½ÃÄÁ½º¸¦ È®ÀÎÇÔ. 
	{
		if (Measured_Speed > ((float)stSetup.StartSpeed1))  //  Crank speed Engine is in the start_up sequence.   //30RPMÀÌ»óÀÌ¸é ¿£Áö ½Ãµ¿ÁßÀ¸·Î ÀÎ½ÄÇÔ.
		{

		// ÀÌ°Ô ¿Ö ÇÊ¿äÇÏÁö?? »óÅÂµµ·Î ´Ù½Ã È®ÀÎ ÇÒ°Í 
		//	TmrSetT(0, 10000);  //10 sec timer for start sequence 1 

 		  //  TmrStart(0);
		
			//init some parameter
			Parameter_Reset();

			uiEngineMode =MODE_START;
			uiSubMode=0x01;
			SubDOCmd.bit.EngineControlLamp =1;
			SubDOCmd.bit.RunningLamp =1;
			// ÇöÀç idle Rate setting value 
			if (Main_di2.bit.RatedIdleSelect)
			Speed_Reference =stSetup.RatedSpeedRef;
			else Speed_Reference =stSetup.IdleSpeedRef;
				
			////////////////////////////////////////////////
			// test code 
			g_testBufferIndex=0;

		
		}
		control_value = 4.0;
		DAC_Out_mA(uiCmdOutCh, control_value);
	}
	else if (uiEngineMode == MODE_START) 								 // Engine Start Sequence ½ÃÀÛ
	{
		switch (uiSubMode)
		{
			case 0x01:   // measured speed   	// 200rpm±îÁö 15% ¿¬·á·¢ ¿ÀÇÂ
			//	if( Measured_Speed >= stSetup.StartSpeed1 )					 // Speed0(30.0) º¸´Ù Å©¸é Å¸ÀÌ¸Ó Á¤Áö  
					TmrSetT(1, 30000);  //30 sec timer for start sequence 1 
 				    TmrStart(1);
			 	 // stop software timer 
					control_value = stSetup.StartFuelRef*(20.-4.)/100.+4. ;					// 25% ¿¬·á·¢ ¿ÀÇÂ
					DAC_Out_mA(uiCmdOutCh, control_value);
					uiSubMode= (uiSubMode <<1);  // 0x02   
			break;

			case 0x02:										
				if( Measured_Speed >= ((float)stSetup.StartSpeed2) )					// 200rpmº¸´Ù ÀÛÀ¸¸é Å¸ÀÌ¸Ó ½ÃÀÛ
				{
			 		TmrStop(1); 

					uiSubMode= (uiSubMode <<1);  // 0x04 
					if (stSetup.Start2RefDelayTime >0)
					Speed_Command_Delta=(Speed_Reference  -stSetup.StartSpeed2)/(stSetup.Start2RefDelayTime*100.0);
					// speed_diff/sampling_count, sampling_count=stSetup.Start2RefDelayTime*sampling_frequency(100,10msec=100Hz)
					else Speed_Command_Delta=0.0;
					Speed_Command = Measured_Speed;
				}
			break;

			case 0x04:											// 200rpm µÈ ÈÄ Speed Command ¼øÂ÷Áõ°¡ - PID ¼Óµµ Á¦¾î ½ÃÀÛ (20 msec ÁÖ±â)
				if (stSetup.Start2RefDelayTime >0)
				Speed_Command +=Speed_Command_Delta;
				else Speed_Command =Speed_Reference;

				if (Speed_Command >Speed_Reference) Speed_Command=Speed_Reference;

				// PID Output calculate 
	 
//					PID_Calculate();
				bPID_Enable =true;

	 

		 	// speed°¡ reference ¸¦ ÃÊ°úÇÏ´Â °æ¿ì ´ÙÀ½ state·Î ÀÌµ¿ 
				if (Measured_Speed >Speed_Reference) 	
				{
					uiSubMode= (uiSubMode <<1);  // 0x08 
					TmrStop(0);
				}

			break;

			case 0x08:												// 720rpmÀÌ µÇ¾úÀ» ¶§  
				Speed_Command=Speed_Reference;
					// PID Output calculate 
//					PID_Calculate();
					bPID_Enable =true;

		 				
				// ¼ÓµµÁö·É°ú °èÃø°ª Â÷ÀÌ°¡ 5%ÀÌ³»¿¡ 3ÃÊÀÌ»ó µé¾î¿À´ÂÁö ÆÇ´ÜÇÏ´Â State ( 5% = 36rpm )
				// ¿¡·¯ÄÚµå2ÀÇ ¹ß»ý¿©ºÎ¸¸ °áÁ¤

				mPid.error = abs(Speed_Command - Measured_Speed);

				if(mPid.error  <= Speed_Command*5./100.) 
				{
					if(mPid._window_time_cnt > mPid.WindowTime) 
					{
						// run mode change 
						uiEngineMode =MODE_RUN;
						uiSubMode =0x01;
					}
					else mPid._window_time_cnt++;
				} 
				else 
				{
	 
					mPid._window_time_cnt = 0;
				}

				mPid.tracking_time++;
				if ( mPid.tracking_time > 30*100 )	// 30ÃÊ°¡ Áö³¯ µ¿¾È¿¡µµ 3ÃÊ ÀÌ»ó 5%ÀÌ³» À¯Áö°¡ ¾ÈµÉ °æ¿ì				
				{
				// change to shut down mode 
					// run mode change 
						uiEngineMode =MODE_SHUTDOWN;
						uiSubMode =0x01;
				}

			break;

		default:  // state error 
			
			break;
		}
	}
	else if (uiEngineMode == MODE_RUN) 	 // Engine run mode 
	{
	
			Speed_Command=Speed_Reference;
		// PID Output calculate 
//			PID_Calculate();
			bPID_Enable =true;

	 
		if (stSpeed.FuelLimitBit.bit.LoadAnticipator)
		{
			Check_Anticipator();

		}
			
	 	if (Measured_Load ==0)
			{
				if (Measured_Load_Old>0)
				{
					if (stSpeed.FuelLimitBit.bit.KickDown)
					{
						if (!flag_KickDown)
						{
							KickDownTime=Calculate_KickDownTime();
							flag_KickDown= true;
							TmrSetT(1, KickDownTime*100);  //30 sec timer for start sequence 1 
	 				    	TmrStart(1);
						}
					}
				}
			}
		
		SubDOCmd.bit.RunningLamp =1;	
		SubDOCmd.bit.EngineRunning2MSB =1;	
			switch (uiSubMode)
		{
			case 0x01:// parameter initial 
			mPid._window_time_cnt=0;
			mPid.tracking_time=0;
			uiSubMode= (uiSubMode <<1);  // 0x02 

			break;
			case 0x02:// check for speed =0
				if( Measured_Speed<= ((float)stSetup.StartSpeed1) ) 
				{
					if(mPid._window_time_cnt > mPid.WindowTime) 
					{
						// run mode change 
						uiEngineMode =MODE_SHUTDOWN;
						uiSubMode =0x01;
					}
					else mPid._window_time_cnt++;
				} 
				else 
				{
	 
					mPid._window_time_cnt = 0;
				}

//				if (Main_di2.bit.GCB_Closed) 

			 //	if ((Measured_Load > 5) || (Main_di2.bit.GCB_Closed))
				if (Main_di2.bit.GCB_Closed)
				{
					uiEngineMode =MODE_LOAD; 
					uiSubMode =0x01;

				}
	 
			break;
			default:


			break;
		}
	}
	else if (uiEngineMode == MODE_LOAD) 	 // Load run mode  
	{
	

		if (Measured_Load ==0)
		{
			if (Measured_Load_Old>0)
			{
				if (stSpeed.FuelLimitBit.bit.KickDown)
				{
					if (!flag_KickDown)
					{
						KickDownTime=Calculate_KickDownTime();
						flag_KickDown= true;
						TmrSetT(1, KickDownTime*100);  //30 sec timer for start sequence 1 
 				    	TmrStart(1);
					}
				}
			}
		}

		


		if (uiVelocityMode == CON_S_DROOP) // speed control (droop)
		{
			Speed_Command=Speed_Reference*(1+fDroop*(100.-Measured_Load)/10000.);
			// PID Output calculate 
//			PID_Calculate();
			bPID_Enable =true;

		}
		else 
		{
			Speed_Command=Speed_Reference;
		// PID Output calculate 
//			PID_Calculate();
			bPID_Enable =true;
		}

		//safety code for engine speed
		// this code will be transfered to safety check routine
		if( Measured_Speed<= ((float)stSetup.StartSpeed1) ) 
		{
			if(mPid._window_time_cnt > mPid.WindowTime) 
			{
				// run mode change 
				uiEngineMode =MODE_SHUTDOWN;
				uiSubMode =0x01;
			}
			else mPid._window_time_cnt++;
		} 
		else 
		{

			mPid._window_time_cnt = 0;
		}

		if  (!Main_di2.bit.GCB_Closed)
		{
			uiEngineMode =MODE_RUN; 
			uiSubMode =0x01;

		}


	}
	else if (uiEngineMode == MODE_SHUTDOWN) 	 // Engine shut down mode 
	{
		bPID_Enable =false;
		control_value = 4.;
		DAC_Out_mA(uiCmdOutCh, control_value);
		SubDOCmd.bit.RunningLamp =0;
		SubDOCmd.bit.EngineRunning2MSB =0;
		switch (uiSubMode)
		{
			case 0x01:  // timer setting for 30 sec delay 
			// check for start fail count, if start fail count > limit then stop on ??? °ú¿¬ ÇÊ¿äÇÑ°¡??
			mPid._window_time_cnt =0;
			mPid.tracking_time=0;

			iStartFailCnt++;

			// ±âµ¿ ½ÇÆÐ È½¼ö°¡ ÃÖ´ë Á¦ÇÑ È½¼ö º¸´Ù Å« °æ¿ì¿¡ 
			if (iStartFailCnt > MaxStartFail)
			{
				uiEngineMode =MODE_EMERGENCY;
				uiSubMode = 0x01;
			}


			uiSubMode = (1<<1);
			break;
			
			case 0x02:

			if (Measured_Speed < 1.0)  // measured speed < 1 --> engine stopped
			{// engine speed <1 for 10 sec then engine is stopped. 
					if(mPid._window_time_cnt > mPid.WindowTime) 
					{
						// run mode change 
			
						uiSubMode =(uiSubMode<<1);
					}
					else mPid._window_time_cnt++;
			} 
			else 
			{
				mPid._window_time_cnt = 0;
			}

			mPid.tracking_time++;
			if ( mPid.tracking_time > 30*100 )	// 30ÃÊ°¡ Áö³¯ µ¿¾È¿¡µµ 3ÃÊ ÀÌ»ó 5%ÀÌ³» À¯Áö°¡ ¾ÈµÉ °æ¿ì				
			{
			// change to shut down mode 
				// run mode change 
					uiEngineMode =MODE_EMERGENCY;
					uiSubMode =0x01;
			}
			
			break; 	
			case 0x04:
				 	TmrSetT(0, 3000);//30000);  //30 sec timer for start sequence 1 

 				    TmrStart(0);
					uiSubMode =(uiSubMode<<1);
			break;
			case 0x08:// wait for timer event 
			
			// do nothing 
			break;
			default:


			break;

			}

//		if (velocity < 1RPM ) // engine is stopped then start restart timer
	}
	else if (uiEngineMode == MODE_EMERGENCY) 	 // Engine shut down mode 
	{
		bPID_Enable =false;
		uiEngineMode =0;
		uiSubMode=1;
		control_value = 4.0;
		DAC_Out_mA(uiCmdOutCh, control_value);
	}
	else
	{//uiTestFlag
		bPID_Enable =false;
		control_value = 4.0;
		DAC_Out_mA(uiCmdOutCh, control_value);
		uiSubMode=1;
	// parameter initial for restart
//		Speed_Command = 200;
	}
///////////////////////////////////////////////////////
//  test code for debug
///////////////////////////////////////////////////////
	if (uiEngineMode > MODE_READY )
		{
			SaveLogData();
		}

	Measured_Load_Old =Measured_Load;
///////////////////////////////////////////////////////
//  test code for debug end

}

// ====================================================================== //
//	Function: Check_Anticipator
//		- load anticipator value check
// ¿£Áø Á¾·ù º°·Î ´Ù¸¥ »óÅÂ È®ÀÎ ·çÆ¾ÀÌ ÇÊ¿äÇÔ. 
// ---------------------------------------------------------------------- //
void Check_Anticipator(void)
{

// for test 	
//	LoadDeviation= Measured_Load-Measured_Load_Old;
	if (LoadDeviation>0)
	{
		if (LoadDeviation >stSpeed.UpThreshold)
		{


			uiAnticipatorBias=Calculate_Anticipator_Bias(1);
			uiAnticipatorDuration=Calculate_Anticipator_Duration(1);
			TmrSetT(1, uiAnticipatorDuration*100);  //5 sec timer for gas Leakage Test sequence 1

			TmrStart(1);
			bAnticipator=1;
		
		}	
	}
	else
	{
		if (abs(LoadDeviation) >stSpeed.DownThreshold)
		{
			uiAnticipatorBias=Calculate_Anticipator_Bias(0);
			uiAnticipatorDuration=Calculate_Anticipator_Duration(0);
			TmrSetT(1, uiAnticipatorDuration*100);  //5 sec timer for gas Leakage Test sequence 1

			TmrStart(1);
			bAnticipator=1;		
		}	

	}

	
}

// ====================================================================== //
//	Function: Calculate_Anticipator_Bias
//		- bias value is calculated from 5 point data 
// flag =1; up deviation, =0 ; down deviation
// ---------------------------------------------------------------------- //
unsigned int Calculate_Anticipator_Bias(int flag)
{
float a=0.;
float b=0.;
int index=0;

unsigned int ret=0;
int iTmp=0;
unsigned int uiLoadDeviation=0;

	if (flag)  // up deviation
	{
		index=0;
		do
		{	
			iTmp=stSpeed.UpBiasLoadDevi[index];
			index+=1;

		}while((iTmp<LoadDeviation) && (index<5));

		switch(index)
		{
		case 1: // 20% below
		a =(float)(stSpeed.UpBias[index]-stSpeed.UpBias[index-1])/(float)(stSpeed.UpBiasLoadDevi[index]-stSpeed.UpBiasLoadDevi[index-1]);
		b= stSpeed.UpBias[index]-a*stSpeed.KickDownGenLoad[index];
 
		break;
		default:
		a =(float)(stSpeed.UpBias[index-1]-stSpeed.UpBias[index-2])/(float)(stSpeed.UpBiasLoadDevi[index-1]-stSpeed.UpBiasLoadDevi[index-2]);
		b= stSpeed.UpBias[index-1]-a*stSpeed.UpBiasLoadDevi[index-1];
 
		break;
		}
 

		ret =(unsigned int)(a*(float)LoadDeviation+b);


	}
	else  // down deviation
	{
		index=0;
		uiLoadDeviation=abs(LoadDeviation);
		do
		{	
			iTmp=stSpeed.DownBiasLoadDevi[index];
			index+=1;

		}while((iTmp<uiLoadDeviation) && (index<5));
	
		switch(index)
		{
		case 1: // 20% below
		a =(float)(stSpeed.DownBias[index]-stSpeed.DownBias[index-1])/(float)(stSpeed.DownBiasLoadDevi[index]-stSpeed.DownBiasLoadDevi[index-1]);
		b= stSpeed.DownBias[index]-a*stSpeed.KickDownGenLoad[index];
 
		break;
		default:
		a =(float)(stSpeed.DownBias[index-1]-stSpeed.DownBias[index-2])/(float)(stSpeed.DownBiasLoadDevi[index-1]-stSpeed.DownBiasLoadDevi[index-2]);
		b= stSpeed.DownBias[index-1]-a*stSpeed.DownBiasLoadDevi[index-1];
 
		break;
		}
	 
		ret =(unsigned int)(a*(float)uiLoadDeviation+b);


	}
	return ret;
}


// ====================================================================== //
//	Function: Calculate_Anticipator_Duration
//		- Duration value is calculated from 5 point data 
// flag =1; up deviation, =0 ; down deviation
// ---------------------------------------------------------------------- //
unsigned int Calculate_Anticipator_Duration(int flag)
{
float a=0.;
float b=0.;
int index=0;

unsigned int ret=0;
int iTmp=0;
unsigned int uiLoadDeviation=0;

	if (flag)  // up deviation
	{
		index=0;
	 
		do
		{	
			iTmp=stSpeed.UpDurationLoadDevi[index];
			index+=1;

		}while((iTmp< LoadDeviation) && (index<5));

		switch(index)
		{
		case 1: // 20% below
		a =(float)(stSpeed.UpDuration[index]-stSpeed.UpDuration[index-1])/(float)(stSpeed.UpDurationLoadDevi[index]-stSpeed.UpDurationLoadDevi[index-1]);
		b= stSpeed.UpDuration[index]-a*stSpeed.UpDurationLoadDevi[index];
 
		break;
		default:
		a =(float)(stSpeed.UpDuration[index-1]-stSpeed.UpDuration[index-2])/(float)(stSpeed.UpDurationLoadDevi[index-1]-stSpeed.UpDurationLoadDevi[index-2]);
		b= stSpeed.UpDuration[index-1]-a*stSpeed.UpDurationLoadDevi[index-1];
 
		break;
		}
	

		ret =(unsigned int)(a*(float)LoadDeviation+b);


	}
	else  // down deviation
	{
		index=0;
		uiLoadDeviation=abs(LoadDeviation);
		do
		{	
			iTmp=stSpeed.DownDurationLoadDevi[index];
			index+=1;

		}while((iTmp<uiLoadDeviation) && (index<5));
	
		switch(index)
		{
		case 1: // 20% below
		a =(float)(stSpeed.DownDuration[index]-stSpeed.DownDuration[index-1])/(float)(stSpeed.DownDurationLoadDevi[index]-stSpeed.DownDurationLoadDevi[index-1]);
		b= stSpeed.DownDuration[index]-a*stSpeed.KickDownGenLoad[index];
 
		break;
		default:
		a =(float)(stSpeed.DownDuration[index-1]-stSpeed.DownDuration[index-2])/(float)(stSpeed.DownDurationLoadDevi[index-1]-stSpeed.DownDurationLoadDevi[index-2]);
		b= stSpeed.DownDuration[index-1]-a*stSpeed.DownDurationLoadDevi[index-1];
 
		break;
		}
	
		ret =(unsigned int)(a*(float)uiLoadDeviation+b);


	}
	return ret;
}

// ====================================================================== //
//	Function: Calculate Kickdown time
//		- State check for every 10 msec
// ¿£Áø Á¾·ù º°·Î ´Ù¸¥ »óÅÂ È®ÀÎ ·çÆ¾ÀÌ ÇÊ¿äÇÔ. 
// ---------------------------------------------------------------------- //
int Calculate_KickDownTime(void)
{
float a=0.;
float b=0.;

int ret=0;
	if (Measured_Load_Old <= stSpeed.KickDownGenLoad[1])
	{
		a =(float)(stSpeed.KickDownDuration[1]-stSpeed.KickDownDuration[0])/(float)(stSpeed.KickDownGenLoad[1]-stSpeed.KickDownGenLoad[0]);
		b= stSpeed.KickDownDuration[1]-a*stSpeed.KickDownGenLoad[1];
		ret =(int)(a*(float)Measured_Load_Old+b);
	}
	else 
	{
		a =(float)(stSpeed.KickDownDuration[2]-stSpeed.KickDownDuration[1])/(float)(stSpeed.KickDownGenLoad[2]-stSpeed.KickDownGenLoad[1]);
		b= stSpeed.KickDownDuration[1]-a*stSpeed.KickDownGenLoad[1];
		ret =(int)(a*(float)Measured_Load_Old+b);


	}
	return ret;
	
}


// ====================================================================== //
//	Function: Check_State
//		- State check for every 10 msec
// ¿£Áø Á¾·ù º°·Î ´Ù¸¥ »óÅÂ È®ÀÎ ·çÆ¾ÀÌ ÇÊ¿äÇÔ. 
// ---------------------------------------------------------------------- //


void Check_State(void)
{
	if (stSetup.EngineType == TYPE_BACKUP )
	State_Backup();
	else if (stSetup.EngineType == TYPE_DF )
	{
		if (uiFuelMode == FUEL_BACKUP )
		State_Backup();
		else if (uiFuelMode == FUEL_DIESEL )
		State_Diesel();
		else if (uiFuelMode == FUEL_GAS_DIESEL )
		State_DieselGas();
	}

}



// ====================================================================== //
//	Function: Check_Process
//		- Process check for every 10ms(??) 
// ---------------------------------------------------------------------- //
void Check_Process(void)
{
 
	ErrorCheckAI();
	ErrorCheckDI();

	// over speed error 
	if (Measured_Speed > ((float)(stSetup.RatedSpeedRef*stSpeed.OverSpeedSet)/100.) )  //  overspeed
	{
		if (uiEngineMode <MODE_SHUTDOWN)
		uiEngineMode = MODE_SHUTDOWN;


	}

	if (stSetup.EngineType >TYPE_BACKUP)  // Diesel mode ÀÎ °æ¿ì¿¡´Â DI ÀÔ·ÂÀÌ º°µµ·Ï ¾øÀ½ .. 
	{

		if (uiFuelMode == FUEL_GAS)//
		{// check fuel oil temp. is less than 70deg. 
		   if (!bExhaustGasVentilation)
		   bExhaustGasVentilation =ExhaustGasVent();

		}

		DI_Process();   //ready to start check 

	}
	else
	{	if (uiEngineMode == MODE_INIT)
		{
			uiEngineReady =true;
			uiEngineMode =MODE_READY;
//			Main_do2.bit.BackupMode2PMS=1;
		}
	}

	if ((isDPDown == TRUE) && (isDPDownSlave == TRUE) && (isDPDown2808 == TRUE))
	{
		// DPRam data is received !!!


	}

	Check_State();
	///////////////////////////////////////////////////////////////////////
	//
	//  st_EngineSetup.uiEngineType =TYPE_DIESEL
	///////////////////////////////////////////////////////////////////////


	DO_Update();
	AO_Update();
}



// ====================================================================== //
//	Function: Gain_Range_Set
//		- Gain Range setting  
// ---------------------------------------------------------------------- //
/* 
void Governor_Gain_Range_Set(void)
{
  //  int i;
   // int init_rpm_diff=-100;//, init_actual_rpm=0;
	
 
	max_differ_rpm_P = stGovernorGain.P.xDirRange[stGovernorGain.P.xDirNum-1]; 
	min_differ_rpm_P = stGovernorGain.P.xDirRange[0];
    max_rpm_P = stGovernorGain.P.yDirRange[stGovernorGain.P.yDirNum-1]; 
    min_rpm_P = stGovernorGain.P.yDirRange[0];

	max_differ_rpm_I = stGovernorGain.I.xDirRange[stGovernorGain.I.xDirNum-1]; 
	min_differ_rpm_I = stGovernorGain.I.xDirRange[0];
    max_rpm_I = stGovernorGain.I.yDirRange[stGovernorGain.I.yDirNum-1]; 
    min_rpm_I = stGovernorGain.I.yDirRange[0];


	max_differ_rpm_D = stGovernorGain.D.xDirRange[stGovernorGain.D.xDirNum-1]; 
	min_differ_rpm_D = stGovernorGain.D.xDirRange[0];
    max_rpm_D = stGovernorGain.D.yDirRange[stGovernorGain.D.yDirNum-1]; 
    min_rpm_D = stGovernorGain.D.yDirRange[0];

}

*/

// modified search_gain at 2012.11.30.

int search_gain(int *Q_node, BYTE GAIN,BYTE Type)
{
    int i;
    int x1_node, x2_node, y1_node, y2_node;
	unsigned int success1, success2;
	int No_Of_GainX,No_Of_GainY;
	int max_differ_rpm, min_differ_rpm;
	int max_rpm, min_rpm;
	volatile struct  PIDGainArray *stGainArray;
	
	if (Type ==1)
	stGainArray =&stGovernorGain;
	else stGainArray=&stGasPressureGain;

	success1 = FALSE; 	success2 = FALSE;

   
   	if(GAIN == PGain) {

 	

		No_Of_GainX = 	stGainArray->P.xDirNum;	//stGovernorGain.P.xDirNum;
		No_Of_GainY = stGainArray->P.yDirNum;

		max_differ_rpm = stGainArray->P.xDirRange[No_Of_GainX-1]; 
		min_differ_rpm = stGainArray->P.xDirRange[0];
   		max_rpm = stGainArray->P.yDirRange[No_Of_GainY-1]; 
    	min_rpm = stGainArray->P.yDirRange[0];


    // check input range whether these vale are beyoud pre-defined range
    	if(actual_x >= max_differ_rpm) actual_x=max_differ_rpm;
		if(actual_x <= min_differ_rpm) actual_x=min_differ_rpm;
		if(Measured_Load >= max_rpm) actual_y=max_rpm;
		if(Measured_Load <= min_rpm) actual_y=min_rpm;

	
		
		for(i=0;i<No_Of_GainX-1;i++) 
		   if(actual_x >=stGainArray->P.xDirRange[i] && actual_x <=stGainArray->P.xDirRange[i+1]) 
		   { 
			   x1_node = i;
			   x2_node = i+1;
			   success1 = TRUE;
			   break;
			}

		for(i=0;i<No_Of_GainY-1;i++) 
		   if(Measured_Load >=stGainArray->P.yDirRange[i] && Measured_Load <=stGainArray->P.yDirRange[i+1]) 
		   { 
			   y1_node = i;
			   y2_node = i+1;
			   success2 = TRUE;
			   break;
			}
		
			
  	}
  	else if(GAIN == IGain){
		No_Of_GainX = stGainArray->I.xDirNum;
		No_Of_GainY = stGainArray->I.yDirNum;

		max_differ_rpm = stGainArray->I.xDirRange[No_Of_GainX-1]; 
		min_differ_rpm = stGainArray->I.xDirRange[0];
	    max_rpm = stGainArray->I.yDirRange[No_Of_GainY-1]; 
	    min_rpm = stGainArray->I.yDirRange[0];




  		if(actual_x >= max_differ_rpm) actual_x=max_differ_rpm;
		if(actual_x <= min_differ_rpm) actual_x=min_differ_rpm;
		if(Measured_Load >= max_rpm) actual_y=max_rpm;
		if(Measured_Load <= min_rpm) actual_y=min_rpm;
	
	

		for(i=0;i<No_Of_GainX-1;i++) 
		   if(actual_x >=stGainArray->I.xDirRange[i] && actual_x <=stGainArray->I.xDirRange[i+1]) 
		   { 
			   x1_node = i;
			   x2_node = i+1;
			   success1 = TRUE;
			   break;
			}

		for(i=0;i<No_Of_GainY-1;i++) 
		   if(Measured_Load >=stGainArray->I.yDirRange[i] && Measured_Load <=stGainArray->I.yDirRange[i+1]) 
		   { 
			   y1_node = i;
			   y2_node = i+1;
			   success2 = TRUE;
			   break;
			}
			
	}  
	else {
		No_Of_GainX = stGainArray->D.xDirNum;
		No_Of_GainY = stGainArray->D.yDirNum;	

		max_differ_rpm = stGainArray->D.xDirRange[No_Of_GainX-1]; 
		min_differ_rpm = stGainArray->D.xDirRange[0];
	    max_rpm = stGainArray->D.yDirRange[No_Of_GainY-1]; 
	    min_rpm = stGainArray->D.yDirRange[0];


   		if(actual_x >= max_differ_rpm) actual_x=max_differ_rpm;
		if(actual_x <= min_differ_rpm) actual_x=min_differ_rpm;
		if(Measured_Load >= max_rpm) actual_y=max_rpm;
		if(Measured_Load <= min_rpm) actual_y=min_rpm; 	
	  	
		
		for(i=0;i<No_Of_GainX-1;i++) 
		   if(actual_x >=stGainArray->D.xDirRange[i] && actual_x <=stGainArray->D.xDirRange[i+1]) 
		   { 
			   x1_node = i;
			   x2_node = i+1;
			   success1 = TRUE;
			   break;
			}

		for(i=0;i<No_Of_GainY-1;i++) 
		   if(Measured_Load >=stGainArray->D.yDirRange[i] && Measured_Load <=stGainArray->D.yDirRange[i+1]) 
		   { 
			   y1_node = i;
			   y2_node = i+1;
			   success2 = TRUE;
			   break;
			}
			


	}

 

	Q_node[0] = x1_node;
	Q_node[1] = x2_node;
	Q_node[2] = y1_node;
	Q_node[3] = y2_node;       
       
    if( success1 == TRUE &&  success2 == TRUE)
	{
		if(GAIN == PGain){

		 	x1 = (float)stGainArray->P.xDirRange[Q_node[0]];
			x2 = (float)stGainArray->P.xDirRange[Q_node[1]];
			y1 = (float)stGainArray->P.yDirRange[Q_node[2]];
			y2 = (float)stGainArray->P.yDirRange[Q_node[3]];

			Q11 = (float)stGainArray->P.Gain[Q_node[2]][Q_node[0]];
			Q21 = (float)stGainArray->P.Gain[Q_node[2]][Q_node[1]];
			Q12 = (float)stGainArray->P.Gain[Q_node[3]][Q_node[0]];
			Q22 = (float)stGainArray->P.Gain[Q_node[3]][Q_node[1]];
		}
		
		else if(GAIN == IGain){
			x1 = (float)stGainArray->I.xDirRange[Q_node[0]];
			x2 = (float)stGainArray->I.xDirRange[Q_node[1]];
			y1 = (float)stGainArray->I.yDirRange[Q_node[2]];
			y2 = (float)stGainArray->I.yDirRange[Q_node[3]];

			Q11 = (float)stGainArray->I.Gain[Q_node[2]][Q_node[0]];
			Q21 = (float)stGainArray->I.Gain[Q_node[2]][Q_node[1]];
			Q12 = (float)stGainArray->I.Gain[Q_node[3]][Q_node[0]];
			Q22 = (float)stGainArray->I.Gain[Q_node[3]][Q_node[1]];
		}	
		else{
			x1 = (float)stGainArray->D.xDirRange[Q_node[0]];
			x2 = (float)stGainArray->D.xDirRange[Q_node[1]];
			y1 = (float)stGainArray->D.yDirRange[Q_node[2]];
			y2 = (float)stGainArray->D.yDirRange[Q_node[3]];

			Q11 = (float)stGainArray->D.Gain[Q_node[2]][Q_node[0]];
			Q21 = (float)stGainArray->D.Gain[Q_node[2]][Q_node[1]];
			Q12 = (float)stGainArray->D.Gain[Q_node[3]][Q_node[0]];
			Q22 = (float)stGainArray->D.Gain[Q_node[3]][Q_node[1]];
			//for(k=0;k<No_of_DRange;k++) D_Gain[k][0][0] = (k+1)*100;		
		}

		return(1);


	}
	else return(0);
}

/*
// search_gain original function

int search_gain(int *Q_node, BYTE gaintype)
{
    int i;
    int x1_node, x2_node, y1_node, y2_node;
	unsigned int success1, success2;
	int No_Of_GainX,No_Of_GainY;
	int max_differ_rpm, min_differ_rpm;
	int max_rpm, min_rpm;
 
	success1 = FALSE; 	success2 = FALSE;

   
   	if(gaintype == PGain) {

	

		No_Of_GainX = stGovernorGain.P.xDirNum;
		No_Of_GainY = stGovernorGain.P.yDirNum;

		max_differ_rpm = stGovernorGain.P.xDirRange[No_Of_GainX-1]; 
		min_differ_rpm = stGovernorGain.P.xDirRange[0];
   		max_rpm = stGovernorGain.P.yDirRange[No_Of_GainY-1]; 
    	min_rpm = stGovernorGain.P.yDirRange[0];


    // check input range whether these vale are beyoud pre-defined range
    	if(actual_x >= max_differ_rpm) actual_x=max_differ_rpm;
		if(actual_x <= min_differ_rpm) actual_x=min_differ_rpm;
		if(Measured_Load >= max_rpm) actual_y=max_rpm;
		if(Measured_Load <= min_rpm) actual_y=min_rpm;

	
		
		for(i=0;i<No_Of_GainX-1;i++) 
		   if(actual_x >=stGovernorGain.P.xDirRange[i] && actual_x <=stGovernorGain.P.xDirRange[i+1]) 
		   { 
			   x1_node = i;
			   x2_node = i+1;
			   success1 = TRUE;
			   break;
			}

		for(i=0;i<No_Of_GainY-1;i++) 
		   if(Measured_Load >=stGovernorGain.P.yDirRange[i] && Measured_Load <=stGovernorGain.P.yDirRange[i+1]) 
		   { 
			   y1_node = i;
			   y2_node = i+1;
			   success2 = TRUE;
			   break;
			}
		
			
  	}
  	else if(gaintype == IGain){
		No_Of_GainX = stGovernorGain.I.xDirNum;
		No_Of_GainY = stGovernorGain.I.yDirNum;

		max_differ_rpm = stGovernorGain.I.xDirRange[stGovernorGain.I.xDirNum-1]; 
		min_differ_rpm = stGovernorGain.I.xDirRange[0];
	    max_rpm = stGovernorGain.I.yDirRange[stGovernorGain.I.yDirNum-1]; 
	    min_rpm = stGovernorGain.I.yDirRange[0];




  		if(actual_x >= max_differ_rpm) actual_x=max_differ_rpm;
		if(actual_x <= min_differ_rpm) actual_x=min_differ_rpm;
		if(Measured_Load >= max_rpm) actual_y=max_rpm;
		if(Measured_Load <= min_rpm) actual_y=min_rpm;
	
	

		for(i=0;i<No_Of_GainX-1;i++) 
		   if(actual_x >=stGovernorGain.I.xDirRange[i] && actual_x <=stGovernorGain.I.xDirRange[i+1]) 
		   { 
			   x1_node = i;
			   x2_node = i+1;
			   success1 = TRUE;
			   break;
			}

		for(i=0;i<No_Of_GainY-1;i++) 
		   if(Measured_Load >=stGovernorGain.I.yDirRange[i] && Measured_Load <=stGovernorGain.I.yDirRange[i+1]) 
		   { 
			   y1_node = i;
			   y2_node = i+1;
			   success2 = TRUE;
			   break;
			}
			
	}  
	else {
		No_Of_GainX = stGovernorGain.D.xDirNum;
		No_Of_GainY = stGovernorGain.D.yDirNum;	

		max_differ_rpm = stGovernorGain.D.xDirRange[stGovernorGain.D.xDirNum-1]; 
		min_differ_rpm = stGovernorGain.D.xDirRange[0];
	    max_rpm = stGovernorGain.D.yDirRange[stGovernorGain.D.yDirNum-1]; 
	    min_rpm = stGovernorGain.D.yDirRange[0];


   		if(actual_x >= max_differ_rpm) actual_x=max_differ_rpm;
		if(actual_x <= min_differ_rpm) actual_x=min_differ_rpm;
		if(Measured_Load >= max_rpm) actual_y=max_rpm;
		if(Measured_Load <= min_rpm) actual_y=min_rpm; 	
	  	
		
		for(i=0;i<No_Of_GainX-1;i++) 
		   if(actual_x >=stGovernorGain.D.xDirRange[i] && actual_x <=stGovernorGain.D.xDirRange[i+1]) 
		   { 
			   x1_node = i;
			   x2_node = i+1;
			   success1 = TRUE;
			   break;
			}

		for(i=0;i<No_Of_GainY-1;i++) 
		   if(Measured_Load >=stGovernorGain.D.yDirRange[i] && Measured_Load <=stGovernorGain.D.yDirRange[i+1]) 
		   { 
			   y1_node = i;
			   y2_node = i+1;
			   success2 = TRUE;
			   break;
			}
			


	}

 

	Q_node[0] = x1_node;
	Q_node[1] = x2_node;
	Q_node[2] = y1_node;
	Q_node[3] = y2_node;       
       
    if( success1 == TRUE &&  success2 == TRUE)
		return(1);
	else return(0);
}

*/



float Update_Gain( BYTE GAIN_TYPE,BYTE Type)
{   
 
 
    float final_updated_gain;  //ÃÖÁ¾ ¼öÁ¤ÇÒ °ÔÀÎ °ª ÀÓ½Ã ÀúÀå

	BYTE GAIN =GAIN_TYPE;

    flag_search_gain = search_gain(&Gain_node[0], GAIN,Type); 

    if (flag_search_gain) // gainÀ» Ã£Àº æ¿ì¿¡¸¸ ¾÷µ¥ÀÌÆ®¸¦ ÇÏµµ·Ï ÇÔ. ¸ø Ã£Àº °æ¿ì¿¡´Â???
	{
	
/*	if(GAIN == PGain){

	 	x1 = (float)stGovernorGain.P.xDirRange[Gain_node[0]];
		x2 = (float)stGovernorGain.P.xDirRange[Gain_node[1]];
		y1 = (float)stGovernorGain.P.yDirRange[Gain_node[2]];
		y2 = (float)stGovernorGain.P.yDirRange[Gain_node[3]];

		Q11 = (float)stGovernorGain.P.Gain[Gain_node[2]][Gain_node[0]];
		Q21 = (float)stGovernorGain.P.Gain[Gain_node[2]][Gain_node[1]];
		Q12 = (float)stGovernorGain.P.Gain[Gain_node[3]][Gain_node[0]];
		Q22 = (float)stGovernorGain.P.Gain[Gain_node[3]][Gain_node[1]];
	}
	
	else if(GAIN == IGain){
		x1 = (float)stGovernorGain.I.xDirRange[Gain_node[0]];
		x2 = (float)stGovernorGain.I.xDirRange[Gain_node[1]];
		y1 = (float)stGovernorGain.I.yDirRange[Gain_node[2]];
		y2 = (float)stGovernorGain.I.yDirRange[Gain_node[3]];

		Q11 = (float)stGovernorGain.I.Gain[Gain_node[2]][Gain_node[0]];
		Q21 = (float)stGovernorGain.I.Gain[Gain_node[2]][Gain_node[1]];
		Q12 = (float)stGovernorGain.I.Gain[Gain_node[3]][Gain_node[0]];
		Q22 = (float)stGovernorGain.I.Gain[Gain_node[3]][Gain_node[1]];
	}	
	else{
		x1 = (float)stGovernorGain.D.xDirRange[Gain_node[0]];
		x2 = (float)stGovernorGain.D.xDirRange[Gain_node[1]];
		y1 = (float)stGovernorGain.D.yDirRange[Gain_node[2]];
		y2 = (float)stGovernorGain.D.yDirRange[Gain_node[3]];

		Q11 = (float)stGovernorGain.D.Gain[Gain_node[2]][Gain_node[0]];
		Q21 = (float)stGovernorGain.D.Gain[Gain_node[2]][Gain_node[1]];
		Q12 = (float)stGovernorGain.D.Gain[Gain_node[3]][Gain_node[0]];
		Q22 = (float)stGovernorGain.D.Gain[Gain_node[3]][Gain_node[1]];
		//for(k=0;k<No_of_DRange;k++) D_Gain[k][0][0] = (k+1)*100;		
	}
*/
	x_value = (float)actual_x;
	y_value = (float)Measured_Load;
    
    temp1 = (float)(Q11*(x2-1.0*x_value)*(y2-1.0*y_value))/((x2-1.0*x1)*(y2-1.0*y1));
	temp2 = (Q21*(x_value-1.*x1)*(y2-1.*y_value))/((x2-1.*x1)*(y2-1.*y1));
	temp3 = (Q12*(x2-1.*x_value)*(y_value-1.*y1))/((x2-1.*x1)*(y2-1.*y1));
	temp4 = (Q22*(x_value-1.*x1)*(y_value-1.*y1))/((x2-1.*x1)*(y2-1.*y1));

	final_updated_gain = temp1+temp2+temp3+temp4;

	}
	else //gain search failed
	{
		if(GAIN == PGain){
			if (Type ==1)
		 	final_updated_gain = (float)stGovernorGain.P.Gain[0][0];
			else
			final_updated_gain = (float)stGasPressureGain.P.Gain[0][0];
		 
		}
		
		else if(GAIN == IGain){
			if (Type ==1)
			final_updated_gain = (float)stGovernorGain.I.Gain[0][0];
				else
			final_updated_gain = (float)stGasPressureGain.I.Gain[0][0];
		 
		}	
		else{
			if (Type ==1)
			final_updated_gain = (float)stGovernorGain.D.Gain[0][0];
			else
			final_updated_gain = (float)stGasPressureGain.D.Gain[0][0];
		 
		}


	}
  
	return(final_updated_gain);

}



void PID_Calculate(void)
{
  
    if (stPidGainSet.GainSet1 == 0x01)  // single gain 
	{

		pid1_Engine.Kp =stPidGainSet.SingleP1/1000.0;
		pid1_Engine.Ki = stPidGainSet.SingleI1/10000.0;
		pid1_Engine.Kd = stPidGainSet.SingleD1/10000.0;
		pid1_Engine.Kc = stPidGainSet.SingleKc1/1000.0;

	}
	else
	{
		actual_x =(int)( Speed_Command-Measured_Speed);  //speed error
	    actual_y =(int)( Measured_Load);  // load  AD input 25
			// PID Output calculate 
			
		if (actual_y <0.0) actual_y =0.0;

		// pid gain update 
		pid1_Engine.Kp = Update_Gain(PGain,1)/1000.0;
		pid1_Engine.Ki = Update_Gain(IGain,1)/10000.0;
		pid1_Engine.Kd = Update_Gain(DGain,1)/10000.0;


	}
 
	pid1_Engine.Ref = (float32)Speed_Command;   		// reference value 
	pid1_Engine.Fdb = (float32)Measured_Speed;   		// feedback value
	pid1_Engine.calc(&pid1_Engine);

			//	control_value = (pid1_Engine.Out*0.15) + 4;
	if (flag_KickDown)
	{
		control_value = 0;
		DAC_Out_mA(uiCmdOutCh, control_value);
					
	}
	else
	{ 
		if (bAnticipator==1)
		{
			DAC_Out_mA(uiCmdOutCh, ((float)uiAnticipatorBias)*(20.-4.)/100.+4.);

		}
		else if (bAnticipator==2)
		{


		}
		else
		{
			control_value = pid1_Engine.Out;
			DAC_Out_mA(uiCmdOutCh, control_value);
		}
	}

	control_value_old= control_value;

}

/////////////////////////////////////////////////////////
///  sogav pid calculation algorithm
//
//  2012.11.30. 
/////////////////////////////////////////////////////////

void PID_Calculate_Sogav(void)
{
  
    if (stPidGainSet.GainSet1 == 0x01)  // single gain 
	{

		pid_Sogav.Kp =stPidGainSet.SingleP1/1000.0;
		pid_Sogav.Ki = stPidGainSet.SingleI1/10000.0;
		pid_Sogav.Kd = stPidGainSet.SingleD1/10000.0;
		pid_Sogav.Kc = stPidGainSet.SingleKc1/1000.0;

	}
	else
	{
		actual_x =(int)( Speed_Command-Measured_Speed);  //speed error
	    actual_y =(int)( Measured_Load);  // load  AD input 25
			// PID Output calculate 
			
		if (actual_y <0.0) actual_y =0.0;

		// pid gain update 
		pid_Sogav.Kp = Update_Gain(PGain,2)/1000.0;
		pid_Sogav.Ki = Update_Gain(IGain,2)/10000.0;
		pid_Sogav.Kd = Update_Gain(DGain,2)/10000.0;


	}
 
	pid_Sogav.Ref = (float32)Speed_Command;   		// reference value 
	pid_Sogav.Fdb = (float32)Measured_Speed;   		// feedback value
	pid_Sogav.calc(&pid_Sogav);

	// calculate duration ???
	// for sogav 

/*			//	control_value = (pid1_Engine.Out*0.15) + 4;
	if (flag_KickDown)
	{
		control_value = 0;
		DAC_Out_mA(uiCmdOutCh, control_value);
					
	}
	else
	{ 
		if (bAnticipator==1)
		{
			DAC_Out_mA(uiCmdOutCh, ((float)uiAnticipatorBias)*(20.-4.)/100.+4.);

		}
		else if (bAnticipator==2)
		{


		}
		else
		{
			control_value = pid1_Engine.Out;
			DAC_Out_mA(uiCmdOutCh, control_value);
		}
	}

	control_value_old= control_value;
*/
}

////////////////////////////////////////////////////////////////
///
/// Parameter reset during the operation for PID calculation.
///

void Parameter_Reset(void)
{
		//mPid parameter initial
	mPid.ref_cross_flag = 0;
	mPid.anti_hunt_cnt = 0;
	mPid.tracking_time = 0;
	mPid._window_time_cnt =0;
	mPid.WindowTime =3*100; // 10msec 

	// pid gain initial 
//	pid1_Engine=PIDREG3_DEFAULTS;
 
	pid1_Engine.Kp=fTmpP;//1.0;
	pid1_Engine.Ki=fTmpI;////0.02;
	pid1_Engine.Kd=fTmpD;
	pid1_Engine.Kc=fTmpKc;//0.5; 
	pid1_Engine.OutMax=20.0; 
	pid1_Engine.OutMin=4.0;  

	pid1_Engine.SatErr =0.;
	pid1_Engine.Err =0.;
	pid1_Engine.Ud =0.;
	pid1_Engine.Ui =0.;
	pid1_Engine.Up =0.;
	pid1_Engine.Up1 =0.;

	bPID_Enable =false;

}

 
// ====================================================================== //
//	TEST LED Function for time check
// ---------------------------------------------------------------------- //

void TestLEDOn(void)
{

	Main_do2.bit.Spare2 =1;
	DOUT2 = Main_do2.all;//s_Main_DIO.DO.M2.all;

	DO_LED2 = ~Main_do2.all;
}


void TestLEDOff(void)
{

	Main_do2.bit.Spare2 =0;
	DOUT2 = Main_do2.all;//s_Main_DIO.DO.M2.all;

	DO_LED2 = ~Main_do2.all;
}

void TestLEDToggle(void)
{
	
	Main_do2.bit.Spare2 =~Main_do2.bit.Spare2;
	DOUT2 = Main_do2.all;//s_Main_DIO.DO.M2.all;

	DO_LED2 = ~Main_do2.all;
}


// ====================================================================== //
//	Main Function
// ---------------------------------------------------------------------- //
void main (void)
{
	// ====================================================================== //
	//	Local Variables
	// ---------------------------------------------------------------------- //
  //	Uint16 i = 0;
	// ====================================================================== //


	// ====================================================================== //
	//	Initialize Main DSP
	// ---------------------------------------------------------------------- //
	Main_DSP_Init();
	// ====================================================================== //

#if (STANDALONE)
	// FLASH Code Copy and ÃÊ±âÈ­ ·çÆ¾ --------------------------------------------
	// Copy time critical code and Flash setup code to RAM
	// The  RamfuncsLoadStart, RamfuncsLoadEnd, and RamfuncsRunStart
	// symbols are created by the linker. Refer to the FLASH.cmd file.
	MemCopy(&RamfuncsLoadStart, &RamfuncsLoadEnd, &RamfuncsRunStart);
	
	// Call Flash Initialization to setup flash waitstates
	// This function must reside in RAM
	InitFlash();
	//-----------------------------------------------------------------------------
#endif

	
	// ====================================================================== //
	//	Initialize Main DSP Parameter
	// ---------------------------------------------------------------------- //
	Main_Parameter_Init();
	// ====================================================================== //





	// ====================================================================== //
	//	Infinite Loop
	// ---------------------------------------------------------------------- //
	ADC_Start();
	// Memory BIT Error Count Reset.
//	s_BIT_Info.Mem_BIT_Err_Count = 0;
	uiDeviceID =(*(Uint16 *)0x004080) & 0x00ff;


//	Printf("\n\r\n\r ===== Main DSP Program Running ===== \n\r ");
	if (uiDeviceID == 0x01) // SOGAV, EFI Controller
	{
 		ConfigCpuTimer(&CpuTimer1, 150, 100);//100us timer, 
	 
	 	StartCpuTimer1();
	}

	
 	TmrStart(2); // start PID timer

	Read_RTC();
	for(;;)
	{
	
	//	Main_LoopCount++;
	
		
		// every 2 ms timer
		if (bPID_Timer)
		{
			if (bPID_Enable)
				PID_Calculate();
				
				bPID_Timer=false;
		}

		if (bTimer1)
		{
			SogavTimer();
			bTimer1=false;
		}
 
		// every 10ms timer 
		if (ui10msTimer)
		{
	
		//	TestLEDOn();
			AI_Update();
			DI_Update();

	//			EFI_CMD = HeartBeat;
			HeartBeat++;
			STATUS_LED = ~HeartBeat;

			lpcnt = *p_Speed;

			if (lpcnt >19999900)  
			{
				Measured_Speed_temp=0;
				Measured_Speed=0;
			
			}

			ui10msTimer =false;
			uiCheckProcess =true; // after the input signal processing, enable process check routin 
		// ====================================================================== //
			// Main DSP Run LED Blink
			// ---------------------------------------------------------------------- //
			if (Timer0TickCount > 100)  // 10ms x 100 = 1000, 1 sec  
			{
				Timer0TickCount = 0;
				M_DSP_RUN_LED_Toggle();
			//	TestLEDToggle();

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
			}

		if (uiTestFlag)
		{
//			LoadDeviation=
			Check_Anticipator();
//		 fDA_Data[uiTestCh]=fTestValue;
 		

	///		EFI_CMD= uiEFIValue;
			uiTestFlag=0;

		}
	//			TestLEDOff();
	
		}
		// Read DPRam data 

		if(isDPDown == FALSE) 
		{//DPRAM_STR_BASE
 
			isDPDown = DPDownTCP(DPRAM_STR_BASE+DP_DOWN_BASE_ADDR);
			if(isDPDown == TRUE) 
			{
			// do act when dpram data is downloaded 
				iReadCount++;
			}
		}

		//Slave DSP DPRAM down
		if(isDPDownSlave == FALSE) 
		{
			isDPDownSlave = DPDownSub(DPRAM_M_BASE+DP_DOWN_BASE_ADDR);
			if(isDPDownSlave == TRUE) 
			{
			// do act when dpram data is downloaded 
			iReadCountSlave++;
			}
		}

		//2808 DSP DPRAM down
/*		if(isDPDown2808 == FALSE) 
		{
			isDPDown2808 = DPDownCan(DPRAM_2808_BASE);
			if(isDPDown2808 == TRUE) 
			{
			// do act when dpram data is downloaded 
				iReadCount2808++;
			}
		}
*/
		// added for dpram data process
		if (uiCheckProcess)
		{
			Check_Process();
			uiCheckProcess =false;
		}
 
		if(isDPUp == FALSE) {
			isDPUp = DPUpTcp(DPRAM_STR_BASE);
			if(isDPUp == TRUE)
				iWriteCount++;				
		}

		if(isDPUpSlave == FALSE) {
			isDPUpSlave = DPUpSlave(DPRAM_M_BASE+0x0100);
			if(isDPUpSlave == TRUE)
				iWriteCountSlave++;				
		 			
		}
/*
		if(isDPUp2808 == FALSE) {
			isDPUp2808 = DPUp(DPRAM_2808_BASE+DP_UP_BASE_ADDR,0x100,2);
			if(isDPUp2808 == TRUE)
				iWriteCount2808++;				
		 			
		}
*/

 	if (bFlashWrite) 
 		{
 			FlashWrite(0x01);// write all
			CopyFlash(DPRAM_STR_BASE);//update DPRAM from Flash memory ,  
 			bFlashWrite =0;
 		}
	
		// ====================================================================== //
	}
	// ====================================================================== //
}
// ====================================================================== //




//============================================================//
// SOGAV valve on & off  command function  start
//
void Set_SOGAV_command(void)
{
	
	Set_SOGAV_command_count++;

	if(Set_SOGAV_status==TRUE)
	{
		EFI_CMD_Data = EFI_CMD_Data | (1<<(SOGAV_start_order[SOGAV_No_of_cal_start]-1));
		EFI_CMD = EFI_CMD_Data ;
		DO_LED1 = EFI_CMD_Data ;
		SOGAV_No_of_cal_start=SOGAV_No_of_cal_start+1;
		if(SOGAV_No_of_cal_start==No_of_cylinder) SOGAV_No_of_cal_start = 0;	
	}
	else if(Set_SOGAV_status==FALSE)
	{
		EFI_CMD_Data = (EFI_CMD_Data & (0xFFFF - (1<<(SOGAV_end_order[SOGAV_No_of_cal_end]-1))));
		EFI_CMD = EFI_CMD_Data ;
		DO_LED1 = EFI_CMD_Data ;
		SOGAV_No_of_cal_end = SOGAV_No_of_cal_end +1;
		if(SOGAV_No_of_cal_end==No_of_cylinder)SOGAV_No_of_cal_end = 0;
		Test_Count++;
	}
	
}

// SOGAV valve on & off  command function  end
//=================================================


//--------------------- Edited by Automation Dep. ----------------------- //
//==========================================================================
void SOGAV_time_calculate(void)  // ÀÏÁ¾ÀÇ SimulationÀÓ
{
	Crank_angle = 0.0;
	for( cal_j=0 ; cal_j<12 ; cal_j++ ) // 12°³ÀÇ ½Ç¸°´õ 
	{
		for( cal_i=0 ; cal_i<2*stSetup.PickupToothNo ; cal_i++ )  // No_pickup_tooth = 300
		{
			// delta_theta °íÁ¤°ª : 360/300 = 1.2, theta_zero_modify ±âº»°ª : 0
			Crank_angle = cal_i*delta_theta + theta_zero_modify;   
			
			// 0ÀÌÇÏ ÀÏ ¶§ Ã³¸® ·çÆ¾ ÇÊ¿ä

			// SOGAV Start ½ÃÁ¡ °è»ê
			if( (Crank_angle <= SOGAV_start_angle[cal_j])&&( SOGAV_start_angle[cal_j] < Crank_angle + delta_theta) )
			{
				SOGAV_start_index[cal_j] = cal_i + 1;		
			}
			
			// SOGAV End ½ÃÁ¡ °è»ê
			if( (Crank_angle < SOGAV_end_angle[cal_j])&&( SOGAV_end_angle[cal_j] < Crank_angle + delta_theta) )
			{
				SOGAV_end_index[cal_j] = cal_i + 1;		
			}	
		}	
	}	
}
//==========================================================================



// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function:	Timer0_ISR
//		- Interrupt Service Routine of Timer2 
//		- User can adjust Timer0 interupt frequency by editing 
//		  TIMER0_ISR_FREQUENCY macro in Main_DSP_Parameter.h. 				
// ---------------------------------------------------------------------- //

interrupt void Timer0_ISR(void)
{
 
// 10ms timer 
	Timer0TickCount++;
  
	isDPDown=FALSE;
	isDPUp= FALSE;
	isDPDownSlave=FALSE;
	isDPUpSlave= FALSE;
	isDPDown2808=FALSE;
	isDPUp2808= FALSE;

	ui10msTimer =true;
 
	// Timer0 Interrupt Acknowledge.
	PieCtrlRegs.PIEACK.bit.ACK1 = 1;
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
interrupt void Timer1_ISR(void)
{
	// 100us Timer0 interrupt 
	Timer1TickCount++;
	bTimer1=true;

// Timer1 Interrupt Acknowledge.
//	PieCtrlRegs.PIEACK.ACK1 = 1;
}
// ====================================================================== //


// ====================================================================== //
//	Function: SogavTimer
//		- Sogav Timer Interrupt Routine 100us 
// ---------------------------------------------------------------------- //

void SogavTimer(void)
{
	Uint16 Injection_Cycle = 0;
	int i = 0;
	int j = 0;
	
	 

//	if (uiDeviceID >=SLAVE_BOARD_1)  // EFI controlll
	if (uiDeviceID == 1)  // EFI controlll
	{
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
	}

	
}
// ====================================================================== //
//	Function: DPUp for DB
//		- Upload to DPRAM at the boot sequence
// ---------------------------------------------------------------------- //
Uint16 CopyFlash (Uint32 base_address)
{

	unsigned int *p_dest  = (unsigned int *)(base_address);

	unsigned int *p_address;//  
 
		p_dest= (unsigned int *)(base_address+DP_DOWN_CMD_BASE);  //stSetup
		p_address =(unsigned int *)&stSetup;
		MemCopy(p_address,p_address+sizeof(stSetup),p_dest);  
 
		p_dest = (unsigned int *)(base_address+DP_DOWN_PID_GAIN_BASE); //stEngineSetup
		p_address =(unsigned int *)&stGovernorGain;
		MemCopy(p_address,p_address+sizeof(stGovernorGain),p_dest);  
 
		p_dest = (unsigned int *)(base_address+DP_DOWN_PID_GAIN_BASE2); //stEngineSetup
		p_address =(unsigned int *)&stGasPressureGain;
		MemCopy(p_address,p_address+sizeof(stGasPressureGain),p_dest);  
 
		p_address = (unsigned int *)(base_address+DP_DOWN_PID_GAIN_SET); //stEngineSetup
		p_dest =(unsigned int *)&stPidGainSet;
		MemCopy(p_address,p_address+sizeof(stPidGainSet),p_dest);  


	//	volatile struct  PIDGainSetting stPidGainSet,stPidGainSetFlash;
 
 //		p_dest = (unsigned int *)(base_address+DP_DOWN_ENGINE_SETUP_BASE); //stEngineSetup
//		p_address =(unsigned int *)&st_EngineSetup;
//		MemCopy(p_address,p_address+sizeof(st_EngineSetup),p_dest);  
 
		p_dest = (unsigned int *)(base_address+DP_DOWN_ALARM_SETUP_BASE);  //DP_DOWN_AO_SETUP_BASE
		p_address =(unsigned int *)&st_AlarmSetup;
		MemCopy(p_address,p_address+sizeof(st_AlarmSetup),p_dest);  


		p_dest = (unsigned int *)(base_address+DP_DOWN_AO_SETUP_BASE);  //1432
		p_address =(unsigned int *)&st_AOSetupC1;//st_AlarmSetupC1_Sub;
		MemCopy(p_address,p_address+sizeof(st_AOSetupC1),p_dest);  

		p_dest = (unsigned int *)(base_address+DP_DOWN_ALARM_SETUP_SUB_BASE);  //1432
		p_address =(unsigned int *)&st_AlarmSetupC1_Sub;//st_AlarmSetupC1_Sub;
		MemCopy(p_address,p_address+sizeof(st_AlarmSetupC1_Sub),p_dest);  

		p_dest = (unsigned int *)(base_address+DP_DOWN_ALARM_SETUP_CAN_BASE);  //1432
		p_address =(unsigned int *)&st_AlarmSetupC1_Can;//st_AlarmSetupC1_Sub;
	
		MemCopy(p_address,p_address+sizeof(st_AlarmSetupC1_Can),p_dest);  

	return TRUE;
}

// ====================================================================== //
//	Function: FlashRead
//		- Read Flash Data
// ---------------------------------------------------------------------- //
void FlashRead (void)
{

	unsigned int *p_address  = (unsigned int *)(FRAM1_BASE);
	unsigned int *p_dest;
 
unsigned int	uiCmd = 0x00; 

	uiCmd= *p_address ;

	if (uiCmd == 0x123)
	{
		p_address = (unsigned int *)&stSetupFlash;//(FRAM1_BASE+DP_DOWN_CMD_BASE);  //stSetup
		p_dest =(unsigned int *)&stSetup;
		MemCopy(p_address,p_address+sizeof(stSetup),p_dest);  

		p_address = (unsigned int *)&stGovernorGainFlash;//(FRAM1_BASE+DP_DOWN_PID_GAIN_BASE); //stEngineSetup
		p_dest =(unsigned int *)&stGovernorGain;
		MemCopy(p_address,p_address+sizeof(stGovernorGain),p_dest);  
 
		p_address = (unsigned int *)&stGasPressureGainFlash;//(FRAM1_BASE+DP_DOWN_PID_GAIN_BASE2); //stEngineSetup
		p_dest =(unsigned int *)&stGasPressureGain;
		MemCopy(p_address,p_address+sizeof(stGasPressureGain),p_dest);  
 
		p_address= (unsigned int *)(&stPidGainSetFlash); //stEngineSetup
		p_dest =(unsigned int *)&stPidGainSet;
		MemCopy(p_address,p_address+sizeof(stPidGainSet),p_dest);  

 //		p_address = (unsigned int *)&st_EngineSetupFlash;//(FRAM1_BASE+DP_DOWN_ENGINE_SETUP_BASE); //stEngineSetup
//		p_dest =(unsigned int *)&st_EngineSetup;
//		MemCopy(p_address,p_address+sizeof(st_EngineSetup),p_dest);  
 
		p_address = (unsigned int *)&st_AlarmSetupFlash;//(FRAM1_BASE+DP_DOWN_ALARM_SETUP_BASE);  //DP_DOWN_AO_SETUP_BASE
		p_dest =(unsigned int *)&st_AlarmSetup;

		MemCopy(p_address,p_address+sizeof(st_AlarmSetup),p_dest);  


		p_address = (unsigned int *)&st_AOSetupC1Flash;//(FRAM1_BASE+DP_DOWN_AO_SETUP_BASE);  //1432
		p_dest =(unsigned int *)&st_AOSetupC1;//st_AlarmSetupC1_Sub;

		MemCopy(p_address,p_address+sizeof(st_AOSetupC1),p_dest);  

		p_address = (unsigned int *)&st_AlarmSetupC1_SubFlash;//(FRAM1_BASE+DP_DOWN_ALARM_SETUP_SUB_BASE);  //1432
		p_dest =(unsigned int *)&st_AlarmSetupC1_Sub;//st_AlarmSetupC1_Sub;

		MemCopy(p_address,p_address+sizeof(st_AlarmSetupC1_Sub),p_dest);  

		p_address = (unsigned int *)&st_AlarmSetupC1_CanFlash;//(FRAM1_BASE+DP_DOWN_ALARM_SETUP_CAN_BASE);  //1432
		p_dest =(unsigned int *)&st_AlarmSetupC1_Can;//st_AlarmSetupC1_Sub;

		MemCopy(p_address,p_address+sizeof(st_AlarmSetupC1_Can),p_dest);  

		CopyFlash(DPRAM_STR_BASE);//update DPRAM from Flash memory ,  

	}


}

// ====================================================================== //
//	Function: FlashWrite
//		- Write Flash Data
// ---------------------------------------------------------------------- //
void FlashWrite (int uiCmd)
{

	unsigned int *p_address  = (unsigned int *)(FRAM1_BASE);

 
	unsigned int *p_dest;

	if (uiCmd >0)
	{
	 
	if (uiCmd & 0x0001) //write all
	{
	//	stSetupFlash.CylinderNo =stSetup.CylinderNo;
	//	stSetupFlash.Diesel2GasTransferTime =stSetup.Diesel2GasTransferTime;
		 
		p_dest = (unsigned int *)(&stSetupFlash);  //stSetup
		p_address =(unsigned int *)&stSetup;
		MemCopy(p_address,p_address+sizeof(stSetup),p_dest);  

		p_dest = (unsigned int *)(&stGovernorGainFlash); //stEngineSetup
		p_address =(unsigned int *)&stGovernorGain;
		MemCopy(p_address,p_address+sizeof(stGovernorGain),p_dest);  
 
		p_dest = (unsigned int *)(&stGasPressureGainFlash); //stEngineSetup
		p_address =(unsigned int *)&stGasPressureGain;
		MemCopy(p_address,p_address+sizeof(stGasPressureGain),p_dest);  
 
		p_dest = (unsigned int *)(&stPidGainSetFlash); //stEngineSetup
		p_address =(unsigned int *)&stPidGainSet;
		MemCopy(p_address,p_address+sizeof(stPidGainSet),p_dest);  

	 
 //		p_dest = (unsigned int *)(&st_EngineSetupFlash); //stEngineSetup
//		p_address =(unsigned int *)&st_EngineSetup;
//		MemCopy(p_address,p_address+sizeof(st_EngineSetup),p_dest);  
 
		p_dest = (unsigned int *)(&st_AlarmSetupFlash);  //DP_DOWN_AO_SETUP_BASE
		p_address =(unsigned int *)&st_AlarmSetup;
 
		MemCopy(p_address,p_address+sizeof(st_AlarmSetup),p_dest);  


		p_dest = (unsigned int *)&st_AOSetupC1Flash;//(FRAM1_BASE+DP_DOWN_AO_SETUP_BASE);  //1432
		p_address =(unsigned int *)&st_AOSetupC1;//st_AlarmSetupC1_Sub;
 
		MemCopy(p_address,p_address+sizeof(st_AOSetupC1),p_dest);  

		p_dest = (unsigned int *)&st_AlarmSetupC1_SubFlash;//(FRAM1_BASE+DP_DOWN_ALARM_SETUP_SUB_BASE);  //1432
		p_address =(unsigned int *)&st_AlarmSetupC1_Sub;//st_AlarmSetupC1_Sub;
 
		MemCopy(p_address,p_address+sizeof(st_AlarmSetupC1_Sub),p_dest);  

		p_dest = (unsigned int *)&st_AlarmSetupC1_CanFlash;//(FRAM1_BASE+DP_DOWN_ALARM_SETUP_CAN_BASE);  //1432
		p_address =(unsigned int *)&st_AlarmSetupC1_Can;//st_AlarmSetupC1_Sub;
 
		MemCopy(p_address,p_address+sizeof(st_AlarmSetupC1_Can),p_dest);  

	}
	else if (uiCmd & 0x0002) //read command
	{
		p_dest = (unsigned int *)(FRAM1_BASE+DP_DOWN_CMD_BASE);  //stSetup
		p_address =(unsigned int *)&stSetup;
		MemCopy(p_address,p_address+sizeof(stSetup),p_dest);  

	  
	}
	else if (uiCmd & 0x0004) //read gavornor PID gain 1
 	{
		p_dest = (unsigned int *)(FRAM1_BASE+DP_DOWN_PID_GAIN_BASE); //stEngineSetup
		p_address =(unsigned int *)&stGovernorGain;
		MemCopy(p_address,p_address+sizeof(stGovernorGain),p_dest);  
 
	}
	else if (uiCmd & 0x0008) //read pump pid gain
 	{

		p_dest = (unsigned int *)(FRAM1_BASE+DP_DOWN_PID_GAIN_BASE2); //stEngineSetup
		p_address =(unsigned int *)&stGasPressureGain;
		MemCopy(p_address,p_address+sizeof(stGasPressureGain),p_dest);  
  	}
	else if (uiCmd & 0x0010) //read engine status 
	{
// 		p_dest = (unsigned int *)(FRAM1_BASE+DP_DOWN_ENGINE_SETUP_BASE); //stEngineSetup
//		p_address =(unsigned int *)&st_EngineSetup;
//		MemCopy(p_address,p_address+sizeof(st_EngineSetup),p_dest);  
 
	}
	else if (uiCmd & 0x0020) //read alarm status setup
 	{
 
		p_dest = (unsigned int *)(FRAM1_BASE+DP_DOWN_ALARM_SETUP_BASE);  //DP_DOWN_AO_SETUP_BASE
		p_address =(unsigned int *)&st_AlarmSetup;
 
		MemCopy(p_address,p_address+sizeof(st_AlarmSetup),p_dest);  


		p_dest = (unsigned int *)(FRAM1_BASE+DP_DOWN_AO_SETUP_BASE);  //1432
		p_address =(unsigned int *)&st_AOSetupC1;//st_AlarmSetupC1_Sub;
 
		MemCopy(p_address,p_address+sizeof(st_AOSetupC1),p_dest);  

		p_dest = (unsigned int *)(FRAM1_BASE+DP_DOWN_ALARM_SETUP_SUB_BASE);  //1432
		p_address =(unsigned int *)&st_AlarmSetupC1_Sub;//st_AlarmSetupC1_Sub;
 
		MemCopy(p_address,p_address+sizeof(st_AlarmSetupC1_Sub),p_dest);  

		p_dest = (unsigned int *)(FRAM1_BASE+DP_DOWN_ALARM_SETUP_CAN_BASE);  //1432
		p_address =(unsigned int *)&st_AlarmSetupC1_Can;//st_AlarmSetupC1_Sub;
 
		MemCopy(p_address,p_address+sizeof(st_AlarmSetupC1_Can),p_dest);  
	}
	FlashNumber =0x123;
 	 p_address  = (unsigned int *)(FRAM1_BASE);
 	 *(p_address) =0x123;

	 }
}
// ====================================================================== //


// ====================================================================== //
//	Function: Main_Parameter_Init
//		- Initialization Main DSP Parameter
// ---------------------------------------------------------------------- //
void Main_Parameter_Init (void)
{
int i=0;
//int j=0;

	unsigned int *p_address ;// = (unsigned int *)(DPRAM_STR_BASE+DP_DOWN_CMD);

 	unsigned int *p_dest= (unsigned int *)(DPRAM_STR_BASE+DP_DOWN_CMD);
 
	p_address =(unsigned int *)&st_EngineCmdParameter;

	MemClear(p_address,p_address+sizeof(st_EngineCmdParameter));

	MemCopy(p_address,p_address+sizeof(st_EngineCmdParameter),p_dest);  
 
	// ====================================================================== //
	//  parameter initial routine

	uiDeviceID =MAIN_BOARD; //MainBoard

	uiEngineMode = MODE_INIT;//0x00
	uiSubMode = MODE_INIT; //0x00

	uiFuelMode = FUEL_BACKUP; //0x00
	uiOperationMode =RUN_NORMAL;// 0x00 Normal Operation
	uiVelocityMode =CON_S_DROOP; //0x01 Default

	uiLocalOpmode =0x00;

	uiEngineReady =0x00;
	uiEngineStart =0x00;

	Measured_Load =0;
	Measured_Load_Old=0;
	LoadDeviation=0;
	control_value =0;
	control_value_old=0;

//	stSetup.EngineType =TYPE_DIESEL;///default value for initial 
//	stSetup.CylinderNo =7;
//	stSetup.RatedSpeedRef =750;
//	stSetup.Diesel2GasTransferTime =100;// ms ??
//	stSetup.Idle2LoadDelayTime =100;//ms ??

	fK_constant =6.;
	fK1 =1./(1.+fK_constant);
	fK2 =fK_constant/(1.+fK_constant);

	for (i=0;i<0x20;i++)
	{
//	memset(
		st_ADC_Value[i].value_old=0.0;
		st_ADC_Value[i].flagLowHigh =false;
		st_ADC_Value[i].Min = 2048.0*0.05;
		st_ADC_Value[i].Max = 2048.0*0.95;
	}


	for (i=0;i<0x20;i++)
	fDA_Data[i]=0.0;

	fOverspeed_Setting=(((float)stSetup.RatedSpeedRef)*1.20);//104  920RPM  ///1.15

	// pid gain initial 
//	pid1_Engine=PIDREG3_DEFAULTS;

	fTmpP=0.23;
	fTmpI=0.013;
	fTmpD= 0.013;
	fTmpKc=0.5;
	pid1_Engine.Kp=fTmpP;//1.0;
	pid1_Engine.Ki=fTmpI;////0.02;
	pid1_Engine.Kd=fTmpD;
	pid1_Engine.Kc=fTmpKc;//0.5;  
	pid1_Engine.OutMax=20.0; 
	pid1_Engine.OutMin=4.0;  


	pid_Sogav.Kp=fTmpP;
	pid_Sogav.Kp=fTmpP;//1.0;
	pid_Sogav.Ki=fTmpI;////0.02;
	pid_Sogav.Kd=fTmpD;
	pid_Sogav.Kc=fTmpKc;//0.5;  
	pid_Sogav.OutMax=100.0; 
	pid_Sogav.OutMin=0.0;  

	DP_Clear(DPRAM_STR_BASE);
	FlashRead();

	////////////////////////////////
	// TEST CODE FOR stSpeed

	stSpeed.IdleRatedRate =20;
	stSpeed.StartRate =60;
	stSpeed.FastStartRate =60;
	stSpeed.CriticalBandLow =350;
	stSpeed.CriticalBandHigh =450;
	stSpeed.RateInCritical =30;  // RPM/sec
	stSpeed.MaxSpeedSet =110;
	stSpeed.OverSpeedSet =116;
	stSpeed.MaxInOverspeedTestSet =118;
	stSpeed.SyncRate =1;
	stSpeed.LoadRate = 2; 
	stSpeed.FuelLimitBit.bit.StartFuelLimitCurve=1;
	stSpeed.FuelLimitBit.bit.MaxFuelLimit=1;
	stSpeed.FuelLimitBit.bit.BoostPressureFuelLimit=1;
	stSpeed.FuelLimitBit.bit.LoadAnticipator=1;
	stSpeed.FuelLimitBit.bit.KickDown=1;

	stSpeed.StartFuelLimitOffset =0;
	stSpeed.StartFuelLimit[0]=50;
	stSpeed.StartFuelLimit[1]=40;
	stSpeed.StartFuelLimit[2]=40;
	stSpeed.StartFuelLimit[3]=40;
	stSpeed.StartFuelLimitSpeed[0]=200;
	stSpeed.StartFuelLimitSpeed[1]=300;
	stSpeed.StartFuelLimitSpeed[2]=400;
	stSpeed.StartFuelLimitSpeed[3]=500;

	stSpeed.MaxFuelLimiter =105;
	stSpeed.BoostLimiterOffset =0;
	stSpeed.BoostPressure[0]=100;
	stSpeed.BoostPressure[1]=120;
	stSpeed.BoostPressure[2]=140;
	stSpeed.BoostPressure[3]=160;
	stSpeed.BoostPressure[4]=180;
	
	stSpeed.BoostPressureLimit[0]=101;
	stSpeed.BoostPressureLimit[1]=101;
	stSpeed.BoostPressureLimit[2]=101;
	stSpeed.BoostPressureLimit[3]=101;
	stSpeed.BoostPressureLimit[4]=101;
 
	stSpeed.KickDownGenLoad[0]=0;
	stSpeed.KickDownGenLoad[1]=50;
	stSpeed.KickDownGenLoad[2]=100;

	stSpeed.KickDownDuration[0]=5; 
	stSpeed.KickDownDuration[1]=5; 
	stSpeed.KickDownDuration[2]=5; 

	stSpeed.UpThreshold =10;
	stSpeed.DownThreshold =10;

	stSpeed.UpBiasLoadDevi[0]=20;
	stSpeed.UpBiasLoadDevi[1]=40;
	stSpeed.UpBiasLoadDevi[2]=60;
	stSpeed.UpBiasLoadDevi[3]=80;
	stSpeed.UpBiasLoadDevi[4]=100;

	stSpeed.UpBias[0]=20;
	stSpeed.UpBias[1]=25;
	stSpeed.UpBias[2]=30;
	stSpeed.UpBias[3]=35;
	stSpeed.UpBias[4]=40;

	stSpeed.DownBiasLoadDevi[0]=20;
	stSpeed.DownBiasLoadDevi[1]=40;
	stSpeed.DownBiasLoadDevi[2]=60;
	stSpeed.DownBiasLoadDevi[3]=80;
	stSpeed.DownBiasLoadDevi[4]=100;

	stSpeed.DownBias[0]=20;
	stSpeed.DownBias[1]=25;
	stSpeed.DownBias[2]=30;
	stSpeed.DownBias[3]=35;
	stSpeed.DownBias[4]=40;

	stSpeed.UpDurationLoadDevi[0]=20;
	stSpeed.UpDurationLoadDevi[1]=40;
	stSpeed.UpDurationLoadDevi[2]=60;
	stSpeed.UpDurationLoadDevi[3]=80;
	stSpeed.UpDurationLoadDevi[4]=100;

	stSpeed.UpDuration[0]=10;
	stSpeed.UpDuration[1]=20;
	stSpeed.UpDuration[2]=30;
	stSpeed.UpDuration[3]=40;
	stSpeed.UpDuration[4]=50;

	stSpeed.DownDurationLoadDevi[0]=20;
	stSpeed.DownDurationLoadDevi[1]=40;
	stSpeed.DownDurationLoadDevi[2]=60;
	stSpeed.DownDurationLoadDevi[3]=80;
	stSpeed.DownDurationLoadDevi[4]=100;

	stSpeed.DownDuration[0]=10;
	stSpeed.DownDuration[1]=20;
	stSpeed.DownDuration[2]=30;
	stSpeed.DownDuration[3]=40;
	stSpeed.DownDuration[4]=50;

	stSpeed.BiasReturnRate =10;

	stSpeed.LSS =0;
///////////////////////////////////////////
//  test code for pid gain set
/*	stGovernorGain.P.xDirNum=7;
	stGovernorGain.P.yDirNum =6;

	stGovernorGain.I.xDirNum=7;
	stGovernorGain.I.yDirNum =6;

	stGovernorGain.D.xDirNum=7;
	stGovernorGain.D.yDirNum =6;


	stGovernorGain.P.xDirRange[0]=-100;
	stGovernorGain.P.xDirRange[1]=-30;
	stGovernorGain.P.xDirRange[2]=-5;
	stGovernorGain.P.xDirRange[3]=0;
	stGovernorGain.P.xDirRange[4]=5;
	stGovernorGain.P.xDirRange[5]=30;
	stGovernorGain.P.xDirRange[6]=100;

	stGovernorGain.I.xDirRange[0]=-100;
	stGovernorGain.I.xDirRange[1]=-30;
	stGovernorGain.I.xDirRange[2]=-5;
	stGovernorGain.I.xDirRange[3]=0;
	stGovernorGain.I.xDirRange[4]=5;
	stGovernorGain.I.xDirRange[5]=30;
	stGovernorGain.I.xDirRange[6]=100;

	stGovernorGain.D.xDirRange[0]=-100;
	stGovernorGain.D.xDirRange[1]=-30;
	stGovernorGain.D.xDirRange[2]=-5;
	stGovernorGain.D.xDirRange[3]=0;
	stGovernorGain.D.xDirRange[4]=5;
	stGovernorGain.D.xDirRange[5]=30;
	stGovernorGain.D.xDirRange[6]=100;

	for (i=0;i<6;i++)
	{
//		stGovernorGain.P.xDirRange[i]=i*20+10;
		stGovernorGain.P.yDirRange[i]=i*20;

//		stGovernorGain.I.xDirRange[i]=i*10+10;
		stGovernorGain.I.yDirRange[i]=i*20;

//		stGovernorGain.D.xDirRange[i]=i*10+10;
		stGovernorGain.D.yDirRange[i]=i*20;
	}
 
	for (i=0;i<stGovernorGain.P.xDirNum;i++)
		for (j=0;j<stGovernorGain.P.yDirNum;j++)
		{
				if (j<3)
					{
						stGovernorGain.P.Gain[j][i]=25;

						stGovernorGain.I.Gain[j][i]=250;
						stGovernorGain.D.Gain[j][i]=500;
						
					}
					else if ((j>=3) && (j<5))
					{
						stGovernorGain.P.Gain[j][i]=18;

						stGovernorGain.I.Gain[j][i]=280;
						stGovernorGain.D.Gain[j][i]=300;
						
					}
					else
					{
						stGovernorGain.P.Gain[j][i]=10;

						stGovernorGain.I.Gain[j][i]=200;
						stGovernorGain.D.Gain[j][i]=100;
						
					}	
		}
		
		*/
//////////////////////////////////////////////////////

//	Governor_Gain_Range_Set();
	SubDOCmd.all=0x0000;
 

}
// ====================================================================== //


 
// ====================================================================== //
//	Function: Tmr0TimeOutFnct
//		- Software Timer for sequence control
// ---------------------------------------------------------------------- //

void Tmr0TimeOutFnct(void *arg)
{
	if (stSetup.EngineType == TYPE_BACKUP)
	{
		if (uiEngineMode == MODE_START)  // 10sec  ÀÌ³»¿¡ ±âµ¿ ¸ðµå·Î ÀüÈ¯µÇÁö ¸øÇÔ??
		{


		}
		else if (uiEngineMode == MODE_SHUTDOWN)  // 30sec  µ¿¾È ±â´Ù¸² 
		{

			uiEngineMode=MODE_INIT;  // reset Engine mode 
			uiSubMode =0x01;


		}
		
		
	}
	else if (stSetup.EngineType == TYPE_GAS)
	{
		if (uiEngineMode ==MODE_INIT) // gas ventilation sequence
		{
			if (uiSubMode == 0x01) // wait for time out 
			uiSubMode =	(uiSubMode<<1); // mode change 0x02					
			else if (uiSubMode == 0x04) // wait for time out 	
			uiSubMode =	(uiSubMode<<1); // mode change 0x08					
			
		}
		else
		{// gas leakage test mode È®ÀÎÇÒ °Í!!!
			if (bGasLeakageTestMode == 0x04)
			{
				bGasLeakageTestMode =(bGasLeakageTestMode<<1);  // mode change to 0x08	

			}
			else if (bGasLeakageTestMode == 0x10) // wait for 5 sec time delay
			{
				bGasLeakageTestMode =(bGasLeakageTestMode<<1);  // mode change to 0x20	

			}
			else if (bGasLeakageTestMode == 0x40) // wait for 5 sec time delay
			{
				bGasLeakageTestMode =(bGasLeakageTestMode<<1);  // mode change to 0x80	

			}

			if (bVentilationMode == 0x01)
			bVentilationMode = (bVentilationMode <<1);
			
			
		}
	}
	Tmr0TimeOutCnt++;
 	TmrReset(0);
}


// ====================================================================== //
//	Function: Tmr1TimeOutFnct
//		- Software Timer for sequence control
// ---------------------------------------------------------------------- //

void Tmr1TimeOutFnct(void *arg)
{
	if (stSetup.EngineType == TYPE_BACKUP)
	{
		if (uiEngineMode == MODE_START)  // 30sec  ÀÌ³»¿¡ ±âµ¿ ¸ðµå·Î ÀüÈ¯µÇÁö ¸øÇÔ??
		{

			if (uiSubMode == 0x02)  // 30sec  ÀÌ³»¿¡ ±âµ¿ ¸ðµå·Î ÀüÈ¯µÇÁö ¸øÇÔ??
			{	// engine shut down 
				uiEngineMode =MODE_SHUTDOWN;
				uiSubMode =0x00; //start fail
			}
		}
		
		if (flag_KickDown)
		{
			flag_KickDown=false;
			uiEngineMode =MODE_RUN;
			uiSubMode =0x01; //start fail
			
		}
		if (bAnticipator==1)  //anticipator timeout for calculated duration
		{
			bAnticipator=2;
		}
	}

	Tmr1TimeOutCnt++;
 	TmrReset(1);
}

// ====================================================================== //
//	Function: Tmr2TimeOutFnct
//		- Software Timer for sequence control
// ---------------------------------------------------------------------- //

void Tmr2TimeOutFnct(void *arg)
{
	bPID_Timer= true;
	Tmr2TimeOutCnt++;
 	TmrReset(2);
 	TmrStart(2);
}


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
    PieVectTable.XINT13 = &Timer1_ISR;
//	PieVectTable.TINT2 = &Timer2_ISR;

	// Timer0 Interrupt vector setting
	PieCtrlRegs.PIEIER1.bit.INTx7 = 1;
	
	IER |= M_INT1;		// PIEIER1 Enable.
    IER |= M_INT13;				// CPU timer 1
  //  IER |= M_INT14;					// CPU timer 2
	EDIS;	
	// ====================================================================== //
	

	// ====================================================================== //
	//	Timer Initialization.
	// ---------------------------------------------------------------------- //
	InitCpuTimers(); 
	ConfigCpuTimer(&CpuTimer1, SYSTEM_FREQUENCY, (int)(1000000/TIMER0_ISR_FREQUENCY));//100us timer, 10000
	ConfigCpuTimer(&CpuTimer0, 150, 10000); //us input, 10 ms timer=10,000

//	CpuTimer2Regs.TCR.all = 0x4001; // Use write-only instruction to set TSS bit = 0
 	StartCpuTimer0();
//	StartCpuTimer1();
	// ====================================================================== //

	TmrInit();
	TmrCfgFnct(0, Tmr0TimeOutFnct, (void *)0);
 	
	TmrCfgFnct(1, Tmr1TimeOutFnct, (void *)0);

 
	TmrCfgFnct(2, Tmr2TimeOutFnct, (void *)0);
	
	TmrSetT(2, 2);  //2 msec timer for PID Control
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
	Main_di1.all = 0x0000;
	Main_di2.all = 0x0000;
	Main_do1.all = 0x0000;
	Main_do2.all = 0x0000;
	DI_Update();
	DO_Update();


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


