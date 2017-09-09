// ====================================================================== //
//				HiMECS Main DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Main_DSP_Digital_IO.h
// ---------------------------------------------------------------------- //
//	- Description: 
//		Header file for Main DSP Digital Input/Ouput Control
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-08-16:	Draft
// ====================================================================== //


#ifndef MAIN_DSP_DIGITAL_IO_H
#define MAIN_DSP_DIGITAL_IO_H


#ifdef __cplusplus
extern "C" {
#endif

// board ID
#define MAIN_BOARD  	0x01    //Main Control board
#define SLAVE_BOARD_1  	0x10  	//Slave BoardPilot Injection 1
#define SLAVE_BOARD_2  	0x20   	//SOGAV 1
#define SLAVE_BOARD_3  	0x30 	//Pilot Injection 2
#define SLAVE_BOARD_4  	0x40	//SOGAV 2

#define No_of_PGain   9
#define No_of_IGain   9
#define No_of_DGain   9
 
// ====================================================================== //
// 		Global Structure 
// ---------------------------------------------------------------------- //
struct DIO_M1	{
	Uint16	Bit_01	:1;
	Uint16	Bit_02	:1;
	Uint16	Bit_03	:1;
	Uint16	Bit_04	:1;
	Uint16	Bit_05	:1;
	Uint16	Bit_06	:1;
	Uint16	Bit_07	:1;
	Uint16	Bit_08	:1;
	Uint16	Bit_09	:1;
	Uint16	Bit_10	:1;
	Uint16	Bit_11	:1;
	Uint16	Bit_12	:1;
	Uint16	Bit_13	:1;
	Uint16	Bit_14	:1;
	Uint16	Bit_15	:1;
	Uint16	Bit_16	:1;
};

union Bits_M1 {
	Uint16					all;
	struct	DIO_M1			bit;
};


struct DIO_M2	{
	Uint16	Bit_17	:1;
	Uint16	Bit_18	:1;
	Uint16	Bit_19	:1;
	Uint16	Bit_20	:1;
	Uint16	Bit_21	:1;
	Uint16	Bit_22	:1;
	Uint16	Bit_23	:1;
	Uint16	Bit_24	:1;
	Uint16	Bit_25	:1;
	Uint16	Bit_26	:1;
	Uint16	Bit_27	:1;
	Uint16	Bit_28	:1;
	Uint16	Bit_29	:1;
	Uint16	Bit_30	:1;
	Uint16	Bit_31	:1;
	Uint16	Bit_32	:1;
};

union Bits_M2 {
	Uint16					all;
	struct	DIO_M2			bit;
};


struct DIO_Reg {
	union 	Bits_M1			M1;
	union 	Bits_M2			M2;
};


// DI/DO Control Structure
struct Main_Digital_IO {
	struct DIO_Reg			DI;
	struct DIO_Reg			DO;
};

extern volatile struct Main_Digital_IO		s_Main_DIO;



// Digital input for C1 Main No 1
typedef struct tag_DI_MC1	
{
	Uint16	LocalSW	:1;   // 1
	Uint16	SpeedInc	:1;   //2
	Uint16	SpeedDec	:1;  //3
	Uint16	Start	:1;		//4
	Uint16	Stop	:1;		//5
	Uint16	Reset	:1;		// 6
	Uint16	EmcyStop	:1;		//7
	Uint16	FilterDifPressGVUIn	:1;		//8
	Uint16	FilterDifPressEngIn	:1;		//9
	Uint16	SafetyValveClosed	:1;		//10
	Uint16	StopLeverStopPos	:1;		//11
	Uint16	TurningGearEngaged	:1;		//12
	Uint16	EmcySDfromFDS	:1;			//13
	Uint16	GasDetectionAlarm	:1;		//14
	Uint16	GasTripReq1	:1;				//15
	Uint16	GasTripReq2	:1;				//16
}DI_MC1,*LP_DI_MC1;

typedef union Bits_MCDI1 {
	Uint16					all;
	DI_MC1			bit;
}MCDI1,* LP_MCDI1;
// ====================================================================== //
extern volatile MCDI1		Main_di1;

typedef struct tag_DI_MC2	
{
	Uint16	EngineSDfromPMS	:1;  //17
	Uint16	StandbyFromPMS	:1;  //18
	Uint16	DieselOPmodeFromPMS	:1;   //19
	Uint16	GasOPmodeFromPMS	:1;   //20
	Uint16	BlackoutmodeFromPMS	:1;   //21
	Uint16	StartBlockFromPMS	:1;   //22
	Uint16	ExhVentFanRun	:1; 		//23
	Uint16	ExhVentFanAvailable	:1;   //24
	Uint16	ExhVentFanAlarm	:1;			//25
	Uint16	ExhVentFanFault	:1;			//26
	Uint16	GasVentValveOpen	:1;		//27
	Uint16	GasVentValveClose	:1;		//28
	Uint16	GasVentValveAirFlow	:1;		//29
	Uint16	LFO_HFOSelect	:1;		//30
	Uint16	RatedIdleSelect	:1;			//31
	Uint16	GCB_Closed	:1;		//32
}DI_MC2,*LP_DI_MC2;

typedef union Bits_MCDI2 {
	Uint16					all;
	DI_MC2			bit;
}MCDI2,* LP_MCDI2;
// ====================================================================== //
extern volatile MCDI2		Main_di2;


typedef struct tag_Do_MC1	
{
	Uint16	StopValve1	:1;
	Uint16	StopValve2	:1;
	Uint16	StartValve	:1;
	Uint16	SlowTurningValve	:1;
	Uint16	JetAssist	:1;
	Uint16	SV54_1GasValve1	:1;
	Uint16	SV54_2GasValve2	:1;
	Uint16	SV55_1GasVent1	:1;
	Uint16	SV55_2GasVent2	:1;
	Uint16	SV55_3GasVent3	:1;
	Uint16	InertGasValve	:1;
	Uint16	PrelubricationPumpStart	:1;
	Uint16	CoolingWaterPreHeatStart	:1;
	Uint16	ExhVentValveOpen	:1;
	Uint16	ExhVentValveClose	:1;
	Uint16	ExhVentFanStart	:1;
}DO_MC1,*LP_DO_MC1;

typedef union Bits_MCDO1 {
	Uint16					all;
	DO_MC1			bit;
}MCDO1,* LP_MCDO1;
// ====================================================================== //
extern volatile MCDO1		Main_do1;


typedef struct tag_Do_MC2	
{
	Uint16	DeGasingValve	:1;
	Uint16	EnableCB2PMS	:1;
	Uint16	EngineReadyForStart2PMS	:1;
	Uint16	DieselMode2PMS	:1;
	Uint16	GasMode2PMS	:1;
	Uint16	BackupMode2PMS	:1;
	Uint16	LoadReductionRequest	:1;
	Uint16	ShutdownPreWarning2PMS	:1;
	Uint16	EngineReadyForGasOP	:1;
	Uint16	EngineCommonAlarm	:1;
	Uint16	ECSMinorAlarm	:1;
	Uint16	ECSMajorAlarm	:1;
	Uint16	EngineShutdown	:1;
	Uint16	SlowTurningPrewarning	:1;
	Uint16	Spare	:1;
	Uint16	Spare2	:1;
}DO_MC2,*LP_DO_MC2;

typedef union Bits_MCDO2 {
	Uint16					all;
	DO_MC2			bit;
}MCDO2,* LP_MCDO2;


typedef struct tag_PickupInform	
{
	Uint16	FlyWheelPickup1	:1;
	Uint16	FlyWheelPickup2	:1;
	Uint16	TDCPickup1		:1;
	Uint16	TDCPickup2		:1;
	Uint16	PhasePickup1		:1;
	Uint16	PhasePickup2		:1;
	Uint16	TCpickup1	:1;
	Uint16	TCpickup2	:1;
	Uint16	spare1	:1;
	Uint16	spare2	:1;
	Uint16	spare3	:1;
	Uint16	spare4	:1;
	Uint16	spare5	:1;
	Uint16	spare6	:1;
	Uint16	spare7	:1;
	Uint16	spare8	:1;
	Uint16	Spare	:1;
}tag_PickupInform;

typedef union tag_Pickup {
	Uint16				all;
	tag_PickupInform	bit;
}PickupInform;


typedef struct tag_CmdInform	
{
	Uint16	Start	:1;
	Uint16	Stop	:1;
	Uint16	Shutdown		:1;   //0:Idle speed  , 1: load speed
	Uint16	Emergency		:1;
	Uint16	bit4		:1;
	Uint16	bit5		:1;
	Uint16	bit6	:1;
	Uint16	spare0	:1;
	Uint16	spare1	:1;
	Uint16	spare2	:1;
	Uint16	spare3	:1;
	Uint16	spare4	:1;
	Uint16	spare5	:1;
	Uint16	spare6	:1;
	Uint16	spare7	:1;
	Uint16	spare8	:1;
}tag_CmdInform;

typedef union tag_CmdInfo {
	Uint16				all;
	tag_CmdInform	bit;
}CmdInform;


typedef struct tag_CmdOperationMode	
{
	Uint16	Normal	:1;
	Uint16	BlackStart	:1;
	Uint16	Override		:1;   //0:Idle speed  , 1: load speed
	Uint16	Limp		:1;
	Uint16	Test		:1;
	Uint16	bit5		:1;
	Uint16	bit6	:1;
	Uint16	bit7	:1;
	Uint16	spare1	:1;
	Uint16	spare2	:1;
	Uint16	spare3	:1;
	Uint16	spare4	:1;
	Uint16	spare5	:1;
	Uint16	spare6	:1;
	Uint16	spare7	:1;
	Uint16	spare8	:1;
}tag_CmdOperationMode;

typedef union tag_CmdOPMode {
	Uint16				all;
	tag_CmdOperationMode	bit;
}CmdOPMode;


typedef struct tag_FuelLimitSelect	
{
	Uint16	StartFuelLimitCurve	:1;   // using start fuel limit by 4 point curve or 1 parameter
	Uint16	MaxFuelLimit	:1;    // using maximum fuel limit when engine is running at 95% or higher of rated speed in diesel mode
	Uint16	BoostPressureFuelLimit		:1;   //using boost pressure fuel limit
	Uint16	LoadAnticipator		:1;  // using Load Anticipator control
	Uint16	KickDown		:1;  	//  using Kick Down    
	Uint16	bit5		:1;
	Uint16	bit6	:1;
	Uint16	bit7	:1;
	Uint16	spare1	:1;
	Uint16	spare2	:1;
	Uint16	spare3	:1;
	Uint16	spare4	:1;
	Uint16	spare5	:1;
	Uint16	spare6	:1;
	Uint16	spare7	:1;
	Uint16	spare8	:1;
}tag_FuelLimitSelectMode;

typedef union tag_FuelLimit {
	Uint16				all;
	tag_FuelLimitSelectMode	bit;
}FuelLimitFlag;
// ====================================================================== //
extern volatile MCDO2		Main_do2;

typedef struct tagAO2Mem
{
	Uint16 Min;
	Uint16 Max;
} AO2MEM;

typedef struct tagAO4Mem
{
	Uint16 Min;
	Uint16 Max;
	Uint16 Limit1;
	Uint16 Limit2;
} AO4MEM;

typedef struct tagAlarm2Mem
{
	Uint16 Min;
	Uint16 Max;
} AL2MEM;

typedef struct tagAlarm4Mem
{
	Uint16 Min;
	Uint16 Max;
	Uint16 StartHoldReference;
	Uint16 MaxHoldReference;
} AL4MEM, * LP_AL4MEM;

typedef struct tagAlarm4MemLA  // low alarm 
{
	Uint16 Min;
	Uint16 Max;
	Uint16 AlarmSetPoint;
	Uint16 AlarmSetDelay;
} AL4MEMLA, * LP_AL4MEMLA;

typedef struct tagAlarm4MemGT  // low GasTrip 
{
	Uint16 Min;
	Uint16 Max;
	Uint16 LowGasTripSetPoint;
	Uint16 LowGasTripSetDelay;
} AL4MEMGT, * LP_AL4MEMGT;

typedef struct tagAlarm4MemHD  // High Deviation alarm 
{
	Uint16 Min;
	Uint16 Max;
	Uint16 HighDeviationAlarmSetPoint;
	Uint16 HighDeviationAlarmSetPointDelay;
} AL4MEMHD, * LP_AL4MEMHD;	

typedef struct tagAlarm4MemHL  // High Limit
{
	Uint16 Min;
	Uint16 Max;
	Uint16 HighLimit1;
	Uint16 HighLimit2;
} AL4MEMHL, * LP_AL4MEMHL;	

typedef struct tagAlarm4MemByLoad
{
	Uint16 Min;
	Uint16 Max;
  	Uint16 LowLRByLoad[7];
	Uint16 LowLRByLoadDelay;
} AL4MEMLOAD, * LP_AL4MEMLOAD;


typedef struct tagAlarm5MemByLoad
{
	Uint16 Min;
	Uint16 Max;
	Uint16 Use;
	Uint16 HighVarianceAlarm;
	Uint16 HighVarianceAlarmDelay;
	Uint16 LowLRByLoad[7];
} AL5MEMLOAD;

typedef struct tagAlarm6MemLAST  // low alarm Shut down
{
	Uint16 Min;
	Uint16 Max;
	Uint16 LowAlarmSetPoint;
	Uint16 LowAlarmSetDelay;
	Uint16 LowShutdownSetPoint;
	Uint16 LowShutdownSetDelay;
} AL6MEMLAST, * LP_AL6MEMLAST;	

typedef struct tagAlarm6MemLAGT  // low alarm Gas Trip
{
	Uint16 Min;
	Uint16 Max;
	Uint16 LowAlarmSetPoint;
	Uint16 LowAlarmSetDelay;
	Uint16 LowGasTripSetPoint;
	Uint16 LowGasTripSetDelay;
} AL6MEMLAGT, * LP_AL6MEMLAGT;

typedef struct tagAlarm6MemHAGT  // High alarm Gas Trip
{
	Uint16 Min;
	Uint16 Max;
	Uint16 HighAlarmSetPoint;
	Uint16 HighAlarmSetDelay;
	Uint16 HighGasTripSetPoint;
	Uint16 HighGasTripSetDelay;
} AL6MEMHAGT, * LP_AL6MEMHAGT;

typedef struct tagAlarm6MemHALR  // High alarm Load Reduction
{
	Uint16 Min;
	Uint16 Max;
	Uint16 HighAlarmSetPoint;
	Uint16 HighAlarmSetDelay;
	Uint16 HighLoadReductionSetPoint;
	Uint16 HighLoadReductionSetDelay;
} AL6MEMHALR;	

typedef struct tagAlarm6MemByLoadHD
{
	Uint16 Min;
	Uint16 Max;
	Uint16 HighVarianceAlarm;
	Uint16 HighVarianceAlarmDelay;
 	Uint16 RefByLoad[7];
 } AL6MEMLOADHD, * LP_AL6MEMLOADHD;

typedef struct tagAlarm6MemByLoad
{
	Uint16 Min;
	Uint16 Max;
	Uint16 HighVarianceAlarm;
	Uint16 HighVarianceAlarmDelay;
	Uint16 LowAlarmByLoad[7];
	Uint16 LowAlarmByLoadDelay;
	Uint16 LowLR;
	Uint16 LowLRDelay;
} AL6MEMLOAD, * LP_AL6MEMLOAD;

typedef struct tagAlarm6MemByLoadGT
{
	Uint16 Min;
	Uint16 Max;
	Uint16 HighLoadReduction;
	Uint16 HighLoadReductionDelay;
	Uint16 HighGTByLoad[7];
	Uint16 HighGTByLoadDelay;
} AL6MEMLOADGT;

typedef struct tagAlarm6MemByLoadLHA
{
	Uint16 Min;
	Uint16 Max;
	Uint16 LowAlarmByLoad[7];
	Uint16 LowAlarmDelay;
	Uint16 HighAlarmByLoad[7];
	Uint16 HighAlarmDelay;
} AL6MEMLOADLHA;	


typedef struct tagAlarm8Mem
{
	Uint16 Min;
	Uint16 Max;
	Uint16 LowAlarmMDO;
	Uint16 LowAlarmMDODelay;
	Uint16 LowAlarmHFO;
	Uint16 LowAlarmHFODelay;
	Uint16 LowAlarmGT;
	Uint16 LowAlarmGTDelay;
} AL8MEM, * LP_AL8MEM;	

typedef struct tagAlarm8MemHA
{
	Uint16 Min;
	Uint16 Max;
	Uint16 HighAlarm;
	Uint16 HighAlarmDelay;
	Uint16 HighGT;
	Uint16 HighGTDelay;
	Uint16 HighSD;
	Uint16 HighSDDelay;
} AL8MEMHA;	


typedef struct tagAlarm8MemByLoadRef
{
	Uint16 Min;
	Uint16 Max;
	Uint16 HighAlarm;
	Uint16 HighAlarmDelay;
	Uint16 HighVarianceAlarm;
	Uint16 HighVarianceAlarmDelay;
	Uint16 DieselReferenceByLoad[7];
	Uint16 GasReferenceByLoad[7];
 } AL8MEMLOADREF, * LP_AL8MEMLOADREF;

 typedef struct tagAlarm8MemByLoadRef2
{
	Uint16 Min;
	Uint16 Max;
	Uint16 HighDeviationAlarm;
	Uint16 HighDeviationAlarmDelay;
	Uint16 HighDeviationGT;
	Uint16 HighDeviationGTDelay;
	Uint16 StableTimeGTAtStart;
	Uint16 StableTimeGTAtFuelChange;
	Uint16 HighDeviationGTfromCA;
	Uint16 HighDeviationGTfromCADelay;
	Uint16 DegassingFailPressureAtSD;
	Uint16 DegassingFailPressureAtSDDelay;
	Uint16 GasReferenceByLoad[7];
 } AL8MEMLOADREF2, * LP_AL8MEMLOADREF2;

typedef struct tagAlarm8MemByLoad
{
	Uint16 Min;
	Uint16 Max;
	Uint16 LowAlarmByLoad[7];
	Uint16 LowAlarmDelay;
	Uint16 LowSDByLoad[7];
	Uint16 LowSDDelay;
	Uint16 HighAlarmByLoad[7];
	Uint16 HighAlarmDelay;
} AL8MEMLOAD, * LP_AL8MEMLOAD;	

typedef struct tagAlarm8MemByLoadST
{
	Uint16 Min;
	Uint16 Max;
	Uint16 LowStartBlock;
	Uint16 LowAlarmByLoad[7];
	Uint16 LowAlarmDelay;
	Uint16 LowSDByLoad[7];
	Uint16 LowSDDelay;
	Uint16 HighAlarmByLoad[7];
	Uint16 HighAlarmDelay;
	Uint16 HighSDByLoad[7];
	Uint16 HighSDDelay;
} AL8MEMLOADST, * LP_AL8MEMLOADST;	

typedef struct tagAlarm10Mem
{
	Uint16 Min;
	Uint16 Max;
	Uint16 OSCHighGT;
	Uint16 OSCHighGTDelay;
	Uint16 LowLoadOPTime;
	Uint16 LowLoadOPTimeDelay;
	Uint16 OverLoadOPTime;
	Uint16 OverLoadOPTimeDelay;
	Uint16 HighGasTrip;
	Uint16 HighGasTripDelay;
	Uint16 Load100;
	Uint16 LoadSet[7];
} AL10MEM;

typedef struct tagAlarm10MemHA
{
	Uint16 Min;
	Uint16 Max;
	Uint16 LowAlarmMDO;
	Uint16 LowAlarmMDODelay;
	Uint16 HighStartBlock;
	Uint16 HighStartBlockDelay;
	Uint16 HighAlarmMDO;
	Uint16 HighAlarmMDODelay;
	Uint16 HighAlarmHFO;
	Uint16 HighAlarmHFODelay;
} AL10MEMHA;

typedef struct tagAlarm10MemLSBHA
{
	Uint16 Min;
	Uint16 Max;
	Uint16 LowStartBlock;
	Uint16 LowStartBlockDelay;
	Uint16 HighAlarm;
	Uint16 HighAlarmDelay;
	Uint16 HighLoadReduction;
	Uint16 HighLoadReductionDelay;
	Uint16 HighSD;
	Uint16 HighSDDelay;
} AL10MEMLSBHA;


typedef struct tagAlarm10MemByLoadST
{
	Uint16 Low1Start;
	Uint16 Low1StartDelay;
	Uint16 Low2Start;
	Uint16 Low2StartDelay;
	Uint16 UnStableST;
	Uint16 UnStableSTDelay;
	Uint16 OverSpeedAlarm;
	Uint16 OverSpeedAlarmDelay;
	Uint16 OverSpeedST;
	Uint16 OverSpeedSTDelay;
	Uint16 LargeDeviationGT;
	Uint16 LargeDeviationGTDelay;
	Uint16 TooLongNotReached;
	Uint16 TooLongNotReachedDelay;
	Uint16 MaxLoadLD[5];
	Uint16 MaxLoadLDDelay;
} AL10MEMLOADST, * LP_AL10MEMLOADST;	


struct alarmSetup
{
	AL10MEMLOADST SpeedAlarm;  // SpeedAlarm
	AL4MEM FuelActuator;		//  AI 1
	AL8MEM MainFOFilterInlet;		//AI 2
	AL8MEM MainFOEngine;		//  AI 3
	AL4MEMLA StartingAirPressure;   //AI 4
	AL6MEMLAST ControlAirPressure;  // AI 5
	AL6MEMLAGT InstrumentAirPressure;  // AI 6
	AL8MEMLOAD LO_PressureFilterInlet;  // AI 7, c1_sub A1_1
	AL8MEMLOADST LO_PressureEngineInlet;  // AI 8,9 C1_sub_AI2,3C
	AL6MEMLAST LO_PressureTCInlet;  // AI 10 , C1_sub_AI 4
	AL8MEMLOAD LO_PressurePilotFuelInlet;  // AI 11, C1_sub_AI_5
	AL6MEMLOAD HT_WaterPressureInlet;   // AI 12
	AL4MEMLOAD LT_WaterPressureInlet;  // AI 13
	AL4MEMHD LT_ControlValveActualPos;  // AI 14
	AL4MEMHD HT_ControlValveActualPos;  // AI 15
	AL4MEMLA NozzleCoolWaterPressure;  // AI 16
	AL6MEMLOADHD ExhaustWGValve;  //AI 17
	AL8MEMLOADREF CA_Pressure;  //AI 18,19
	AL8MEMLOADREF2 Main_GasPressure;  // AI 20
	AL6MEMHAGT Gas_SupplyPressure;  // AI 21
	AL4MEMHL Gas_Flow;  // AI 22
	AL6MEMLOADHD Gas_PressureEngineInlet;  //AI 23
	AL4MEMGT GVU_ControlAirPressure;	// AI 24
	AL2MEM 		Inert_GasPressure;  // AI 25
	AL10MEM		Load_Signal;  // AI 26
	AL6MEMHAGT 	Crankcase_Pressure;  // AI 27
	AL5MEMLOAD	Throttle_Position;// AI 28
};


struct AOSetup
{	
	AO4MEM 	Fuel_ActuatorCmd; // AO 1
	AO4MEM 	IP_Conver4WGCmd; // AO 2
	AO4MEM 	Main_GasPressureCmd; // AO 3
	AO4MEM 	LT_ControlValveCmd; // AO 4
	AO4MEM 	HT_ControlValveCmd; // AO 5
	AO4MEM 	Throttle_ValveCmd; // AO 6
	AO2MEM	Available_Load; // AO 7
	AO2MEM 	Engine_Speed;//  AO 8
	AO2MEM 	LO_Pressure;//  AO 9
	AO2MEM 	HT_WaterTemp;//  AO 10
};

struct alarmSetupC1_Sub
{
	AL8MEMHA	Bearing_CylinderTemp;  // for Sub 
	AL4MEMLA	Thrust_BearingTemp;  // Thrust bearing temp
};


struct alarmSetupC1_Can
{
	AL10MEMHA	FO_Temp;  // for CAN RTD1
	AL6MEMHALR	LO_Temp; // RTD 2
	AL6MEMLAST	HT_WaterTempInlet; // RTD 3
	AL10MEMLSBHA	HT_WaterTempOutlet;	//RTD 4,5
	AL4MEMLA	HT_WaterTempCACInlet;  //RTD 6
	AL4MEMLA	LT_WaterTempCACInlet;  //RTD 7
	AL4MEMLA	Nozzle_CoolingWaterTemp;  //RTD 8
	AL4MEMLA	Air_TempTCInlet;  //RTD 9
	AL6MEMLOADGT	CA_TempEngineInlet; // RTD 10 
	AL6MEMLOADLHA	Gas_Temp;/// RTD 11
	AL4MEMLA		Generator_windingTemp;// RTD 12~14
	AL4MEMLA		Generator_bearingTemp; // RTD 15
	AL4MEMLA		Generator_CoolingAirTemp; // RTD 16
	AL4MEMLA		LO_TempTCOutlet;// RTD 17, 18
};



struct GainArray  // Engine Setup Parameter
{
	Uint16 xDirNum;
	Uint16 yDirNum;
	int xDirRange[9]; 
	Uint16 yDirRange[9]; 
	Uint16 Gain[9][9]; 
};

struct PIDGainArray  // Engine Setup Parameter
{
	struct GainArray P;
	struct GainArray I;	 
	struct GainArray D;	 
	Uint16 Windup;
};

struct PIDGainSetting  // Engine Setup Parameter
{
	Uint16 GainSet1;
	Uint16 SingleP1;
	Uint16 SingleI1;
	Uint16 SingleD1;
	Uint16 SingleKc1; // anti windup gain
	Uint16 GainSet2;
	Uint16 SingleP2;
	Uint16 SingleI2;
	Uint16 SingleD2;
	Uint16 SingleKc2; // anti windup gain};
};

struct SetUpParameter  // Engine Setup Parameter
{
	Uint16 StartSpeed1;    // engine start speed 1 
	Uint16 StartSpeed2; 
	Uint16 StartSpeed3; 
	Uint16 StartSpeed4;
	Uint16 Start2RefDelayTime;
	Uint16 StartFuelRef;
	Uint16 Idle2LoadDelayTime; 
	Uint16 Load2IdleDelayTime; 
	Uint16 Diesel2GasTransferTime; 
	Uint16 Gas2DieselTransferTime;
	Uint16 EngineType;
	Uint16 PickupToothNo; 
	Uint16 PickupInfo; 
	Uint16 CylinderNo;
	Uint16 IdleSpeedRef;
	Uint16 RatedSpeedRef;
};

struct EngineCmdParameter  // Engine Command Parameter
{
	CmdInform MauualCmd;    // engine start speed 1 
	CmdOPMode OPModeCmd;    // engine start speed 1 
	Uint16 SpeedReference; 
	Uint16 PumpValveReference; 
	Uint16 MainGasPressureReference;
	Uint16 FuelActuatorCommand;
	Uint16 WG_IP_ConverterCommand;
	Uint16 LT_ControlValveCommand; 
	Uint16 HT_ControlValveCommand; 
	Uint16 ThrottleValveCommand; 
	MCDO1 MCDO1Cmd;
	MCDO2 MCDO2Cmd;
 };

struct SpeedParameter  // Engine Speed control Parameter
{
	Uint16 IdleRatedRate;    // Idle2Rate change rate RPM/sec 
	Uint16 StartRate;    // start to idle speed  rate RPM/sec 
	Uint16 FastStartRate;    // start to rated speed at fast start, rate RPM/sec 
	Uint16 CriticalBandLow; // Critical Band low speed   RPM
	Uint16 CriticalBandHigh; //Critical Band High Speed  RPM
	Uint16 RateInCritical;  // RPM rate in Critical band  RPM/sec
	Uint16 MaxSpeedSet;     //  set the speed raise speed limit  % rated speed
	Uint16 OverSpeedSet;    //  set the overspeed trip limit % rated speed
	Uint16 MaxInOverspeedTestSet;  //set the speed raise limit in overspeed test mode % rated speed 
	Uint16 SyncRate; 				// set the rate that engine speed increase/decrease in synchronization at rated speed
	Uint16 LoadRate;				// set the rate that loading/unloading rate by external Inc. Dec. after GCB closed  RMP/sec 
	FuelLimitFlag FuelLimitBit;    // fuel limit select flag
	Uint16 StartFuelLimitOffset;   // offset value for start fuel limiter curve
	Uint16 StartFuelLimitSpeed[4];  // start fuel limit reference speed 4 
	Uint16 StartFuelLimit[4];   // start fuel limit  
	Uint16 MaxFuelLimiter;   // Maximum fuel limit when engine is running at 95% or higher of rated speed
	Uint16 BoostLimiterOffset;   // offset values for boost limit curve
	Uint16 BoostPressure[5];   // boost pressure reference 5
	Uint16 BoostPressureLimit[5];   //boost fuel limit by 5 point curve
	Uint16 KickDownGenLoad[3]; 		// Kick down ref. load
	Uint16 KickDownDuration[3]; 		// Kick down duration sec*10 , 5 = 0.5 sec 
	Uint16 UpThreshold;  // load anticipator up deviation for enable 
	Uint16 DownThreshold;  // load anticipator down deviation for enable 
	Uint16 UpBiasLoadDevi[5];//up bias load deviation
	Uint16 UpBias[5]; // up bias value 
	Uint16 DownBiasLoadDevi[5];//Down bias load deviation
	Uint16 DownBias[5]; // Down bias value 
	Uint16 UpDurationLoadDevi[5];//up Duration load deviation
	Uint16 UpDuration[5]; // up Duration value 
	Uint16 DownDurationLoadDevi[5];//Down Duration load deviation
	Uint16 DownDuration[5]; // Down Duration value 
	Uint16 BiasReturnRate;  //from anticipator bias value to normal value
	Uint16 LSS;  // offset value for what???
};


typedef struct tag_C1SubDI1	
{
	Uint16	Local_RemoteSW	:1;
	Uint16	SpeedIncSW	:1;
	Uint16	SpeedDecSW	:1;
	Uint16	Diesel_GasFuelMode	:1;  //1 diesel, 0 = Gas
	Uint16	StandbySignalIn	:1;
	Uint16	StartBtn	:1;
	Uint16	StopBtn	:1;
	Uint16	ResetBtn	:1;
	Uint16	LampTestBtn	:1;
	Uint16	EmergencyStopBtn	:1;
	Uint16	LevelSWinLeakageFuelOil		:1;
	Uint16	LOFilterDiffSW		:1;
	Uint16	LOFilterDiffSW4V		:1;
	Uint16	DILubeOilLevelMin		:1;
	Uint16	DILubeOilLevelMax	:1;
	Uint16	OilMistDetectorHighLevel	:1;
}tag_C1SubDI1;

typedef union u_C1SubDI1 {
	Uint16				all;
	tag_C1SubDI1	bit;
}C1SubDI1;


typedef struct tag_C1SubDI2	
{
	Uint16	OilMistInCrankcaseAlarm	:1;
	Uint16	OilMistInCrankcaseFail	:1;
	Uint16	WaterLeakageDetect1		:1;
	Uint16	WaterLeakageDetect2		:1;
	Uint16	RemoteSpeedLoadInc		:1;
	Uint16	RemoteSpeedLoadDec		:1;
	Uint16	RemoteStartSig	:1;
	Uint16	RemoteStopSig	:1;
	Uint16	StartBlockingSig	:1;
	Uint16	GAfromMSB	:1;
	Uint16	SDfromMSB	:1;
	Uint16	CircuitBreakerClosed	:1;
	Uint16	IslandOperation	:1;  //1 diesel, 0 = Gas
	Uint16	ControllerVoltageLow	:1;
	Uint16	DriverVoltageLow	:1;
	Uint16	Spare1	:1;
}tag_C1SubDI2;

typedef union u_C1SubDI2 {
	Uint16				all;
	tag_C1SubDI2	bit;
}C1SubDI2;
// ===============

typedef struct tag_C1SubDO1	
{
	Uint16	EngineControlLamp	:1;
	Uint16	LocalControlLamp	:1;
	Uint16	RemoteControlLamp		:1;
	Uint16	Ready4StartLamp		:1;
	Uint16	RunningLamp		:1;
	Uint16	StoppingLamp		:1;
	Uint16	BackupOperationLamp	:1;
	Uint16	CircuitBreakerClosedLamp	:1;
	Uint16	GasOperationMode	:1;
	Uint16	EnableCB2MSB	:1;
	Uint16	EnableReady4Start2MSB	:1;
	Uint16	EngineRunning2MSB	:1;
	Uint16	IndicationRemoteControl	:1;  //1 diesel, 0 = Gas
	Uint16	Spare1	:1;
	Uint16	Spare2	:1;
	Uint16	Spare3	:1;
}tag_C1SubDO1;

typedef union u_C1SubDO1 {
	Uint16				all;
	tag_C1SubDO1	bit;
}C1SubDO1;
// ===============

struct C1SUBFB  // C1 SUB feedback data
{
	Uint16 BearingTemp[0x10];
	Uint16 ThrustBearing;
	Uint16 ThermoCouple[5];
	Uint16 BoardThermo;
	Uint16 LO_PressureFilterIn; 
	Uint16 LO_PressureEngineInBackup;
	Uint16 LO_PressureEngineIn;
	Uint16 LO_PressureTCIn;
	Uint16 LO_PressurePilotFuelPumpIn;
	Uint16 LO_PressureSpare;  //0x36
	C1SubDI1 SubDI1;
	C1SubDI2 SubDI2;
	C1SubDO1 SubDO1;
};




// ===============

struct SOGAV_FLAG  // Sogav test flag
{
	Uint16 SogavTestCmd;//sogav test command 0bit to 11bit
	Uint16 SogavStartAngle[12];//sogav start angle for 12 cylinder
	Uint16 SogavOpenDurationOffset[12];
	Uint16 SogavTestDurationAngle;
};



struct C1CANFB  // C1 CAN feedback data
{
	Uint16 MainFOTempEngineIn;
	Uint16 LOTempEngineIn; 
	Uint16 HTWaterTempJacketIn;
	Uint16 HTWaterTempJacketOut;
	Uint16 HTWaterTempJacketOutBackup;
	Uint16 HTWaterTempCACIn;
	Uint16 LTWaterTempCACIn;
	Uint16 NozzleCoolingWaterTempIn;
	Uint16 AirTempTCIn;
	Uint16 CATempEngineIn;
	Uint16 GasTemp;
	Uint16 GeneratorWindingU;  //0x36
	Uint16 GeneratorWindingV;  //0x36
	Uint16 GeneratorWindingW;  //0x3
	Uint16 GeneratorBearing1;  //0x1e
	Uint16 GeneratorBearing2;  //0x1f
	Uint16 GeneratorCoolingAir;  //0x20
	Uint16 LO_TempTCOut;  //0x21
	Uint16 LO_TempTCOut4V;  //0x22
};


struct C1FEEBBACK  // C1 Main feedback data
{
	Uint16 EngineMode;
	Uint16 uiSubMode;
	int ip_gain;
	int ii_gain;
	int id_gain; 
	int iUp;
	int iUi;
	int iUd; 
	int iTotalPid;
	Uint16 iControl;  //0x36
	Uint16 uiErrorCode[13];
	Uint16 uiTCSpeedA;
	Uint16 uiTCSpeedB;
	Uint16 uiLoad;
};
//////////////modifing....//////////////////////


extern volatile struct alarmSetup st_AlarmSetup;
extern volatile struct AOSetup st_AOSetupC1;
extern volatile struct alarmSetupC1_Sub st_AlarmSetupC1_Sub;
extern volatile struct alarmSetupC1_Can st_AlarmSetupC1_Can;
extern volatile struct setupEngine stEngineSetup;

extern volatile struct  PIDGainArray stGovernorGain;
extern volatile struct  PIDGainArray stGasPressureGain;
extern volatile struct  PIDGainSetting stPidGainSet;
extern volatile struct  SetUpParameter stSetup;

extern volatile struct	SpeedParameter stSpeed;
extern volatile struct  SOGAV_FLAG stSogavFlag;

extern volatile struct 	EngineCmdParameter 		st_EngineCmdParameter;  // EngineSetup Parameter was saved at Fram Area
///////////////////////////////////////////////////////////////
//  for C1Sub DPRAM
extern volatile struct  C1SUBFB st_C1SubFeedback;

extern volatile struct 	C1CANFB st_C1CanFeedback;

extern volatile C1SubDO1 SubDOCmd;

// ====================================================================== //
//	Function Declaration
// ---------------------------------------------------------------------- //
void DI_Update (void);
void DO_Update (void);
// ====================================================================== //



#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of MAIN_DSP_DIGITAL_IO_H definition

// ====================================================================== //
// End of file.
// ====================================================================== //


