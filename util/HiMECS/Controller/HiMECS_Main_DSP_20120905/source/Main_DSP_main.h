// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_main.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for Main Operation Program 
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-04-19:	Draft
// ====================================================================== //

#ifndef MAIN_DSP_MAIN_H
#define MAIN_DSP_MAIN_H


#ifdef __cplusplus
extern "C" {
#endif


// ====================================================================== //
//		Include
// ---------------------------------------------------------------------- //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"


#include "Main_DSP_GPIO.h"
#include "Main_DSP_Parameter.h"
#include "Main_DSP_External_Interface.h"
#include "Main_DSP_BIT.h"
#include "Main_DSP_Debug_SCI.h"
#include "Main_DSP_Modbus.h"
#include "Main_DSP_Sensor_Monitor.h"
#include "Main_DSP_Digital_IO.h"
#include "Main_DSP_I2C.h"
#include "Main_DSP_McBSP.h"
#include "Main_DSP_Analog_Input.h"
#include "Main_DSP_Analog_Output.h"
#include "Main_DSP_RTC.h"
// ====================================================================== //

////////////////////////////////////////////////////////////////////////////
//  Engine Mode 
#define MODE_INIT  			0x0000
#define MODE_READY  		0x0001
#define MODE_STOP			0x0002
#define MODE_START	 		0x0004
#define MODE_RUN  			0x0008
#define MODE_LOAD			0x0010
#define MODE_UNLOAD			0x0020
#define MODE_SHUTDOWN		0x0040
#define MODE_EMERGENCY		0x0080


////////////////////////////////////////////////////////////////////////////
//  Engine Fuel Mode 
// DF에서 사용되며 기동 및 연료 전환 시컨스 용임
#define FUEL_BACKUP  				0x0001
#define FUEL_DIESEL					0x0002  //(gavernor+P.I)
#define FUEL_GAS	 				0x0004
#define FUEL_GAS_DIESEL				0x0008  //gas and Diesel , DF
#define FUEL_DIESEL2GAS				0x0010  
#define FUEL_GAS2DIESEL				0x0020   // gas trip 
#define FUEL_DIESEL2BACKUP			0x0040   // backup 
#define FUEL_TRANSFER_LFO_HFO		0x0080
//#define FUEL_TEST					0x0100  //Test OP 
//#define FUEL_ACTUATOR_CMD			0x0200  //Actuator op test 
//의미가 없음. 

////////////////////////////////////////////////////////////////////////////
//  Engine Type
#define TYPE_BACKUP  			0x0001
#define TYPE_DIESELCR  			0x0002
#define TYPE_GAS  				0x0004
#define TYPE_GASPI				0x0008
#define TYPE_DF					0x0010  //gas and Diesel
#define TYPE_DFPI				0x0020  // gas and diesel engine with pilot injection
#define TYPE_NORMAL				0x0040  // normal engine(??)
#define TYPE_V					0x0080  // V-type engine 

////////////////////////////////////////////////////////////////////////////
//  Engine Running mode Type
#define RUN_NORMAL  			0x0000
#define RUN_BLACKSTART 			0x0001
#define RUN_OVERRIDE			0x0002  // 구체적인 내용은 없음 
#define RUN_LIMP				0x0004  // 구체적인 내용은 없음 
#define RUN_TEST				0x0010  // engine Test mode  


////////////////////////////////////////////////////////////////////////////
//  Engine Speed control mode Type  !!!!
//  구체적인 알고리즘은 고민 할 것 
//uiVelocityMode
#define CON_S_DROOP	  			0x0001   // Constant Speed Droop control mode 
#define CON_ISOCHRO 			0x0002	//  Constant ISOCHRO mode 
#define CON_POWER				0x0004  //  Constant Power control mode 
#define CON_L_S					0x0008  // 구체적인 내용은 없음 
#define CON_TEST				0x0010  // engine Test mode  
///////////////////////////////////////////////////////////////////////
//  Analog input
//  


///////////////////////////////////////////////////////////////////////
//  Digital output
//  for valve control, 나중에 확인 할 것!!!!

#define OPEN		1
#define CLOSE		0


////////////////////////////////////////////////////////////////////////////
//  Gain Type
#define PGain		0x01
#define IGain		0x02
#define DGain		0x03
////////////////////////////////////////////////////////////////////////////
//  DP Memory Address  +0X10 --> REAL DPRAM ADDRESS 
//  DP Upload memory  C1 --> TCP , ANALOG INPUT
#define DPRAM_C1_TCP_FUEL_ACTUATOR_AI  						0x0000
#define DPRAM_C1_TCP_MAIN_FO_PRESSURE_FILTER_IN  			0x0001
#define DPRAM_C1_TCP_MAIN_FO_PRESSURE_ENGINE_IN  			0x0002
#define DPRAM_C1_TCP_STARTING_AIR_PRESSURE		  			0x0003
#define DPRAM_C1_TCP_CONTROL_AIR_PRESSURE		  			0x0004
#define DPRAM_C1_TCP_INSTRUMENT_AIR_PRESSURE				0x0005
#define DPRAM_C1_TCP_LO_PRESSURE_FILTER_INLET				0x0006
#define DPRAM_C1_TCP_LO_PRESSURE_ENGINE_INLET				0x0007
#define DPRAM_C1_TCP_LO_PRESSURE_ENGINE_INLET_BACKUP		0x0008
#define DPRAM_C1_TCP_LO_PRESSURE_TC_INLET					0x0009
#define DPRAM_C1_TCP_LO_PRESSURE_PILOT_FUEL_PUMP_INLET		0x000A
#define DPRAM_C1_TCP_HT_WATER_PRESSURE_JACKET_INLET			0x000B
#define DPRAM_C1_TCP_LT_WATER_PRESSURE_CAC_INLET			0x000C
#define DPRAM_C1_TCP_LT_CONTROL_VALVE_ACTUAL_POSITION		0x000D
#define DPRAM_C1_TCP_HT_CONTROL_VALVE_ACTUAL_POSITION		0x000E
#define DPRAM_C1_TCP_NOZZLE_COOLING_WATER_PRESSURE_ENGINE_INLET		0x000F
#define DPRAM_C1_TCP_EXHAUST_WG_VALVE_POSITION				0x0010
#define DPRAM_C1_TCP_CA_PRESSURE_ENGINE_INLET1				0x0011
#define DPRAM_C1_TCP_CA_PRESSURE_ENGINE_INLET2				0x0012
#define DPRAM_C1_TCP_MAIN_GAS_PRESSURE						0x0013
#define DPRAM_C1_TCP_PT81_GAS_SUPPLY_PRESSURE				0x0014
#define DPRAM_C1_TCP_FT50_GAS_FLOW							0x0015
#define DPRAM_C1_TCP_PT52_GAS_PRESSURE_ENGINE_INLET			0x0016
#define DPRAM_C1_TCP_PT57_GVU_CONTROL_AIR_PRESSURE			0x0017
#define DPRAM_C1_TCP_INERT_GAS_PRESSURE						0x0018
#define DPRAM_C1_TCP_LOAD_SIGNAL							0x0019
#define DPRAM_C1_TCP_CRANKCASE_PRESSURE						0x001A
#define DPRAM_C1_TCP_THROTTLE_VALVE_POSITION				0x001B
#define DPRAM_C1_TCP_AI1									0x001C
#define DPRAM_C1_TCP_AI2									0x001D



//  DP Upload memory  C1 --> TCP , ANALOG OUTPUT
#define DPRAM_C1_TCP_FUEL_ACTUATOR_AO  						0x001E
#define DPRAM_C1_TCP_IP_CONVERTER_FOR_WG_AO		  			0x001F
#define DPRAM_C1_TCP_MAIN_GAS_PRESSURE_CONTROL_AO  			0x0020
#define DPRAM_C1_TCP_LT_CONTROL_VALVE_SET_VALUE_AO 			0x0021
#define DPRAM_C1_TCP_HT_CONTROL_VALVE_SET_VALUE_AO			0x0022
#define DPRAM_C1_TCP_THROTTLE_VALVE_SET_VALUE_AO			0x0023
#define DPRAM_C1_TCP_MAX_AVAILABLE_LOAD_TO_PMS_AO			0x0024
#define DPRAM_C1_TCP_ENGINE_SPEED_AO						0x0025
#define DPRAM_C1_TCP_MONITORING_LO_PRESSURE_ENGINE_INLET_AO		0x0026
#define DPRAM_C1_TCP_MONITORING_HT_WATER_TEMP_JACKET_INLET_AO	0x0027
#define DPRAM_C1_TCP_MONITORING_ENGINE_SPEED_AO				0x0028
#define DPRAM_C1_TCP_SPAIR_AO_1								0x0029
#define DPRAM_C1_TCP_SPAIR_AO_2								0x002A
#define DPRAM_C1_TCP_SPAIR_AO_3								0x002B
#define DPRAM_C1_TCP_SPAIR_AO_4								0x002C

//  DP Upload memory  C1 --> TCP , DIGITAL OUTPUT
#define DPRAM_C1_TCP_DIGITAL_OUTPUT_1								0x002D
#define DPRAM_C1_TCP_DIGITAL_OUTPUT_2								0x002E

//  DP Upload memory  C1 --> TCP , DIGITAL INPUT
#define DPRAM_C1_TCP_DIGITAL_INPUT_1								0x002F
#define DPRAM_C1_TCP_DIGITAL_INPUT_2								0x0030


//  DP Upload memory  C1 --> TCP , C1 SUB THERMO
#define DPRAM_C1_TCP_MAIN_BEARING_TEMP_1								0x0040
#define DPRAM_C1_TCP_MAIN_BEARING_TEMP_2								0x0041
#define DPRAM_C1_TCP_MAIN_BEARING_TEMP_3								0x0042
#define DPRAM_C1_TCP_MAIN_BEARING_TEMP_4								0x0043
#define DPRAM_C1_TCP_MAIN_BEARING_TEMP_5								0x0044
#define DPRAM_C1_TCP_MAIN_BEARING_TEMP_6								0x0045
#define DPRAM_C1_TCP_MAIN_BEARING_TEMP_7								0x0046
#define DPRAM_C1_TCP_MAIN_BEARING_TEMP_8								0x0047
#define DPRAM_C1_TCP_MAIN_BEARING_TEMP_9								0x0048
#define DPRAM_C1_TCP_MAIN_BEARING_TEMP_10								0x0049
#define DPRAM_C1_TCP_THRUST_BEARING_TEMP								0x004A
#define DPRAM_C1_TCP_THERMO_COUPLE_SPARE_1								0x004B
#define DPRAM_C1_TCP_THERMO_COUPLE_SPARE_2								0x004C
#define DPRAM_C1_TCP_THERMO_COUPLE_SPARE_3								0x004D
#define DPRAM_C1_TCP_THERMO_COUPLE_SPARE_4								0x004E
#define DPRAM_C1_TCP_THERMO_COUPLE_SPARE_5								0x004F
#define DPRAM_C1_TCP_BOARD_INTERNAL_TEMP								0x0050

//  DP Upload memory  C1 --> TCP , C1 SUB ANALOG INPUT
#define DPRAM_C1_TCP_LO_PRESSURE_FILTER_INLET_VENGINE					0x0051
#define DPRAM_C1_TCP_LO_PRESSURE_ENGINE_INLET_VENGINE					0x0052
#define DPRAM_C1_TCP_LO_PRESSURE_ENGINE_INLET_BACKUP_VENGINE			0x0053
#define DPRAM_C1_TCP_LO_PRESSURE_TC_INLET_VENGINE						0x0054
#define DPRAM_C1_TCP_LO_PRESSURE_PILOT_FUEL_PUMP_INLET_VENGINE			0x0055



///////////////////////////////////////////////////////////////////////////
// Analog input address for MC1 main
//
#define  C1_FUEL_ACTUATOR_AI  						0x0000
#define  C1_TCP_MAIN_FO_PRESSURE_FILTER_IN  			0x0001
#define  C1_MAIN_FO_PRESSURE_ENGINE_IN  			0x0002
#define  C1_STARTING_AIR_PRESSURE		  			0x0003
#define  C1_CONTROL_AIR_PRESSURE		  			0x0004
#define  C1_INSTRUMENT_AIR_PRESSURE				0x0005
#define  C1_LO_PRESSURE_FILTER_INLET				0x0006
#define  C1_LO_PRESSURE_ENGINE_INLET				0x0007
#define  C1_LO_PRESSURE_ENGINE_INLET_BACKUP		0x0008
#define  C1_LO_PRESSURE_TC_INLET					0x0009
#define  C1_LO_PRESSURE_PILOT_FUEL_PUMP_INLET		0x000A
#define  C1_HT_WATER_PRESSURE_JACKET_INLET			0x000B
#define  C1_LT_WATER_PRESSURE_CAC_INLET			0x000C
#define  C1_LT_CONTROL_VALVE_ACTUAL_POSITION		0x000D
#define  C1_HT_CONTROL_VALVE_ACTUAL_POSITION		0x000E
#define  C1_NOZZLE_COOLING_WATER_PRESSURE_ENGINE_INLET		0x000F
#define  C1_EXHAUST_WG_VALVE_POSITION				0x0010
#define  C1_CA_PRESSURE_ENGINE_INLET1				0x0011
#define  C1_CA_PRESSURE_ENGINE_INLET2				0x0012
#define  C1_MAIN_GAS_PRESSURE						0x0013
#define  C1_PT81_GAS_SUPPLY_PRESSURE				0x0014
#define  C1_FT50_GAS_FLOW							0x0015
#define  C1_PT52_GAS_PRESSURE_ENGINE_INLET			0x0016
#define  C1_PT57_GVU_CONTROL_AIR_PRESSURE			0x0017
#define  C1_INERT_GAS_PRESSURE						0x0018
#define  C1_LOAD_SIGNAL							0x0019
#define  C1_CRANKCASE_PRESSURE						0x001A
#define  C1_THROTTLE_VALVE_POSITION				0x001B
#define  C1_AI1									0x001C
#define  C1_AI2									0x001D

///////////////////////////////////////////////////////////////////////////
// Analog output address for MC1 main
//

//fDA_Data
#define  C1_FUEL_ACTUATOR_AO  						0x0000
#define  C1_IP_CONVERTER_FOR_WG_AO		  			0x0001
#define  C1_MAIN_GAS_PRESSURE_CONTROL_AO  			0x0002
#define  C1_LT_CONTROL_VALVE_SET_VALUE_AO  			0x0003
#define  C1_HT_CONTROL_VALVE_SET_VALUE_AO  			0x0004
#define  C1_THROTTLE_VALVE_SET_VALUE_AO				0x0005
#define  C1_MAX_AVAILABLE_LOAD_TO_PMS_AO			0x0006
#define  C1_ENGINE_SPEED_AO							0x0007
#define  C1_MONITORING_LO_PRESSURE_ENGINE_INLET_AO	0x0008
#define  C1_MONITORING_HT_WATER_TEMP_JACKET_AO		0x0009
#define  C1_MONITORING_ENGINE_SPEED_AO				0x000A


//DPRAM for arm processor
#define DP_UP_BASE_ADDR 0x400  //arm dpram upload address
#define DP_DOWN_BASE_ADDR 0x000  // arm dpram download address
#define DP_UP_SIZE 0x400		//arm dpram upload size
#define DP_DOWN_SIZE 0x400		//arm dpram download size
//DPRAM for slave DSP processor
#define DP_UP_SLAVE_ADDR 0x400
#define DP_DOWN_SLAVE_ADDR 0x000
#define DP_UP_SLAVE_SIZE 0x400
#define DP_DOWN_SLAVE_SIZE 0x400
//DPRAM for 2808 DSP processor
#define DP_UP_2808_ADDR 0x180
#define DP_DOWN_2808_ADDR 0x080
#define DP_UP_2808_SIZE 0x20
#define DP_DOWN_2808_SIZE 0x12


// DPRAM UP from C1 to TCP
#define DP_UP_SUB_FEEDBACK  0x0050  // 		//arm dpram upload M1C2 Feedback signal 
#define DP_UP_CAN_FEEDBACK  0x0080  // 		//arm dpram upload M1C3-CAN Feedback signal
#define DP_UP_C1_FEEDBACK  0x00A0  // 		//arm dpram upload M1C3-CAN Feedback signal
// DPRAM DOWM from TCP to  C1

#define DP_DOWN_ALARM_SETUP_BASE  0x1310  //0x54ef-0x5310		//arm dpram download alarm setup
#define DP_DOWN_AO_SETUP_BASE  0x1432  //0x5432-0x5451		//arm dpram download for AO setup
#define DP_DOWN_ALARM_SETUP_SUB_BASE  0x1470  //0x5470-0x547B		//arm dpram download for AO setup
#define DP_DOWN_ALARM_SETUP_CAN_BASE  0x1490  //0x5490-0x54ED		//arm dpram download for AO setup

#define DP_DOWN_ENGINE_SETUP_BASE  0x1300  //0x530f-0x5300		//arm dpram download engine setup
#define DP_DOWN_PID_GAIN_BASE2  0x1170  //0x529f-0x5170		//arm dpram download PID GAIN 1 -- pump pid gain 1
#define DP_DOWN_PID_GAIN_BASE  0x1040  //0x516f-0x5040		//arm dpram download PID GAIN 2 -- pump pid gain 2
#define DP_DOWN_PID_GAIN_SET  0x12A1  //0x52A1-0x52AA		//arm dpram download PID GAIN SETTING - 
#define DP_DOWN_CMD_BASE  0x1001  //0x501f-0x5001		//arm dpram download Cmd
#define DP_DOWN_CMD  0x0600  //0x501f-0x5001		//arm dpram download Cmd
#define DP_DOWN_SOGAV_TEST_BASE  0x12B0  //0x52B0-0x52C9		//arm dpram download for SOGAV test flag


#define DP_DOWN_ALARM_SETUP_SIZE  0x01df  //0x54ef-0x5310		//arm dpram download size
#define DP_DOWN_ENGINE_SETUP_SIZE  0x000f  //0x530f-0x5300		//arm dpram download size
#define DP_DOWN_PID_GAIN_SIZE  0x012f  //0x529f-0x5170 , 0x516f-0x5040		//arm dpram download size
#define DP_DOWN_CMD_SIZE  0x001e  //0x501f-0x5001		//arm dpram download size

#define MAX_PID_GROUP 2


typedef struct _pidv {

	unsigned char 	fault;		// fault indicator
	int				demand_old;

	float		output;

	float		integral_limit_pos;
	float		integral_limit_neg;
         

	float 	error;
	float 	error_old;
	int		error_limit;		// setup every new target set   
	int		error_sum;

	unsigned char	ref_cross_flag;
	unsigned char	anti_hunt_cnt;
	unsigned int	tracking_time;
	unsigned int 	stick_time;
	unsigned int   _window_time_cnt;
	unsigned int 	WindowTime;
} pidv;

pidv		mPid;

volatile float 		Measured_Speed; // Main_DSP_SensorMonitor.h  
volatile float 		Measured_Speed_temp;
volatile float 		Speed_Reference;        // PID speed Reference
volatile float 		Speed_Command;        // PID speed command
volatile float 		Speed_Command_Delta;   // PID speed command delta 
//volatile float      Speed_error;  // PID speed error
volatile float 		control_value;  // PID control value
volatile float 		control_value_old;  // PID control value
//volatile int 		Init_flag;    
volatile long 		Period_time_b1;
volatile int 		Test_value;
volatile int 		Control_flag;    
volatile long		Flywheel_M_ISR_Count_before;
volatile long		Flywheel_M_ISR_Count;
volatile int		Flywheel_ISR_SAME_status;
int 		Measured_Load;
int 		Measured_Load_Old;
int 		actual_x;
int 		actual_y; 
int 		LoadDeviation;



//-------------- Crank Angle 계산 관련 Variables---------------------------
volatile double Crank_angle ;             // Present cranck angle
volatile unsigned char TDC_start_flag ;   // TDC interrupt가 활성화 되었다는 신호, 각도 보정을 위해서 사용함
volatile float delta_theta;               // 픽업센서 한 펄스에 해당하는 각도 (degree)
volatile int No_of_cylinder;  
volatile float theta_zero_modify; 	      // TDC 펄스와 픽업 펄스간의 초기 각도 차이 
volatile float SOGAV_duration=20.0;

volatile unsigned int Phase_Count_Old;
volatile unsigned int Phase_Count;
extern Uint32 Phase_M_ISR_Count;
// 실린더별 SOGAV 밸브 제어 시작 각도(degree)
volatile float SOGAV_start_angle[12] = {15,71,131.5,193,254,315,376,437,498,559,611,675.2};      
//volatile float SOGAV_start_angle[12] = {1.2,7.2,19.2,25.2,254,315,376,437,498,559,611,675.2};      
// 실린더별 SOGAV 밸브 제어 끝 각도 (degree)
volatile float SOGAV_end_angle[12] = {40,100,160,220,280,340,400,460,520,580,640,700};        
//volatile float SOGAV_end_angle[12];
volatile int SOGAV_start_order[12] = {3,4,5,6,7,8,9,10,11,12,1,2};
volatile int SOGAV_end_order[12] = {3,4,5,6,7,8,9,10,11,12,1,2};

volatile long Calculated_temp[12] = {0,0,0,0,0,0,0,0,0,0,0,0};

volatile long Calculated_time;
volatile unsigned char Set_SOGAV_status;  // SOGAV 밸브를 on/off 할지를 결정하는 변수, on : TRUE, off : FALSE
volatile int SOGAV_start_index[12] = {0,0,0,0,0,0,0,0,0,0,0,0};
volatile int SOGAV_end_index[12] = {0,0,0,0,0,0,0,0,0,0,0,0};
volatile int cal_i; 
volatile int cal_j;
//volatile int TRUE;
//volatile int FALSE;  
volatile int SOGAV_No_of_cal_start; 
volatile int SOGAV_No_of_cal_end;
//volatile int No_pickup_tooth; 
volatile float open_angle;

//-------------------------------------------------------------------------
// ====================================================================== //
// Gain Schedule parameters 
// ====================================================================== //
float Q11, Q12, Q21, Q22;
float x2,x1,y2,y1;
float x_value,y_value;
 // actual_x : diff. of rpm, actual_y : rpm
float temp1, temp2, temp3, temp4;
float Updated_P_Gain, Updated_I_Gain, Updated_D_Gain;
 

float fTmpP,fTmpI,fTmpD,fTmpKc; 
int Gain_range_X_P[No_of_PGain],Gain_range_Y_P[No_of_PGain];
int Gain_range_X_I[No_of_IGain],Gain_range_Y_I[No_of_IGain];
int Gain_range_X_D[No_of_DGain],Gain_range_Y_D[No_of_DGain];


//int max_rpm_P, min_rpm_P;
//int max_differ_rpm_I, min_differ_rpm_I;
//int max_rpm_I, min_rpm_I;
//int max_differ_rpm_D, min_differ_rpm_D;
//int max_rpm_D, min_rpm_D;
// ====================================================================== //
// 		Global Structure  
// ---------------------------------------------------------------------- //
volatile struct 	Main_Digital_IO		s_Main_DIO;				// Main_DSP_Digital_IO.h
volatile struct 	s_Debug_buffer 		s_Debug_buffer;			// Main_DSP_Debug_SCI.h
volatile struct 	s_Modbus_buffer 	s_Modbus_buffer;		// Main_DSP_Modbus.h
volatile struct 	s_BIT_Infomation 	s_BIT_Info;				// Main_DSP_BIT.h
volatile union 		AD_DA_Control		u_AD_DA_Ctrl;			// Main_DSP_External_Interface.h
volatile struct 	Analog_Input_Info 	s_ADC_In;				// Main_DSP_Analog_Input.h
volatile struct 	DAC_Info 			s_DAC;					// Main_DSP_Analog_Ouput.h
volatile struct 	RTC_Time 			s_RTC;					// Main_DSP_RTC.h
volatile struct 	Analog_Input_Value 	st_ADC_Value[0x20];   	// Main_DSP_Digital_IO.h

volatile struct Digital_Input_Value st_DI_Value[0x20];     		// Main_DSP_Digital_IO.h


volatile struct 	alarmSetup 			st_AlarmSetup,st_AlarmSetupFlash;
volatile struct 	AOSetup 			st_AOSetupC1,st_AOSetupC1Flash;
volatile struct 	alarmSetupC1_Sub 	st_AlarmSetupC1_Sub,st_AlarmSetupC1_SubFlash;
volatile struct 	alarmSetupC1_Can 	st_AlarmSetupC1_Can,st_AlarmSetupC1_CanFlash;
volatile struct  	SOGAV_FLAG 			stSogavFlag;  //stSogavFlag

volatile int  FlashNumber;

//#pragma DATA_SECTION(st_EngineSetupFlash,"FramData");
volatile struct 	EngineCmdParameter 		st_EngineCmdParameter;  // EngineSetup Parameter was saved at Fram Area


///  for C1 Controller
#pragma DATA_SECTION(st_AlarmSetupFlash,"FramData");
#pragma DATA_SECTION(st_AOSetupC1Flash,"FramData");
#pragma DATA_SECTION(st_AlarmSetupC1_SubFlash,"FramData");
#pragma DATA_SECTION(st_AlarmSetupC1_CanFlash,"FramData");
#pragma DATA_SECTION(FlashNumber,"FramData");
#pragma DATA_SECTION(stGovernorGainFlash,"FramData");
#pragma DATA_SECTION(stGasPressureGainFlash,"FramData");//stSetup
#pragma DATA_SECTION(stSetupFlash,"FramData");//stSetup
#pragma DATA_SECTION(stSpeedFlash,"FramData");//stSetup


volatile struct  PIDGainArray stGovernorGain,stGovernorGainFlash;
volatile struct  PIDGainArray stGasPressureGain,stGasPressureGainFlash;//stSetup
volatile struct  SetUpParameter stSetup,stSetupFlash;
volatile struct  PIDGainSetting stPidGainSet,stPidGainSetFlash;

volatile struct	SpeedParameter stSpeed, stSpeedFlash;

volatile struct  C1SUBFB st_C1SubFeedback;
volatile struct 	C1CANFB st_C1CanFeedback;
volatile struct 	C1FEEBBACK  st_C1Feedback;

volatile C1SubDO1 SubDOCmd;  // sub dsp DO control value 
//volatile union BITBYTEVAR stErrorReg[20];
// ====================================================================== //
volatile MCDI1		Main_di1;
volatile MCDI2		Main_di2;

volatile MCDO1		Main_do1;
volatile MCDO2		Main_do2;

unsigned int uiDeviceID;   // board id from main dsp' Digital input 
unsigned int uiEngineMode; //Engine OP mode
unsigned int uiSubMode; //Engine OP sub mode
unsigned int uiFuelMode; //Engine Fuel mode
unsigned int uiOperationMode; //Engine Running mode for debug and test
unsigned int uiVelocityMode;// Engine Speed, Power control mode  !!! 구체적으로 정의할 것

unsigned int uiErrGrp;
unsigned int uiErrBit;
unsigned int uiErrorReg[20];
 


unsigned int uiLocalOpmode;  // operation at local or remote 

unsigned int uiEngineReady;
unsigned int uiEngineStart;

float fDA_Data[0x20];
void FlashWrite (int uiCmd);
#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of MAIN_DSP_MAIN_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //


