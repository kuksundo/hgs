    FEngineModel: TEngineModel;
    FGas_Factor_Pmax_CA: double;
    FGas_Factor_Pmax_Air: double;//외기
    FGas_Factor_CAPress_CA : double;
    FGas_Factor_CAPress_Air : double;//외기
    FGas_Factor_ExhTemp_CA: double;
    FGas_Factor_ExhTemp_Air: double;
    FGas_Factor_ExhTempTCInlet_CA: double;
    FGas_Factor_ExhTempTCInlet_Air: double;//외기
    FGas_Factor_ExhTempTCOutlet_CA: double;
    FGas_Factor_ExhTempTCOutlet_Air: double;//외기

    FDiesel_Factor_Pmax_Load1: double;
    FDiesel_Factor_Pmax_Load2: double;
    FDiesel_Factor_Pmax_Load3: double;
    FDiesel_Factor_Pmax_Load4: double;

    FDiesel_Factor_CAPress_Load1: double;
    FDiesel_Factor_CAPress_Load2: double;
    FDiesel_Factor_CAPress_Load3: double;
    FDiesel_Factor_CAPress_Load4: double;

    FDiesel_Factor_ExhTemp_Load1: double;
    FDiesel_Factor_ExhTemp_Load2: double;
    FDiesel_Factor_ExhTemp_Load3: double;
    FDiesel_Factor_ExhTemp_Load4: double;

    FDiesel_Factor_ExhTempTCInlet_Load1: double;
    FDiesel_Factor_ExhTempTCInlet_Load2: double;
    FDiesel_Factor_ExhTempTCInlet_Load3: double;
    FDiesel_Factor_ExhTempTCInlet_Load4: double;

    FDiesel_Factor_ExhTempTCOutlet_Load1: double;
    FDiesel_Factor_ExhTempTCOutlet_Load2: double;
    FDiesel_Factor_ExhTempTCOutlet_Load3: double;
    FDiesel_Factor_ExhTempTCOutlet_Load4: double;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property EngineModel: TEngineModel read FEngineModel write FEngineModel;

    property Gas_Factor_Pmax_CA: double read FGas_Factor_Pmax_CA write FGas_Factor_Pmax_CA;
    property Gas_Factor_Pmax_Air: double read FGas_Factor_Pmax_Air write FGas_Factor_Pmax_Air;
    property Gas_Factor_CAPress_CA: double read FGas_Factor_CAPress_CA write FGas_Factor_CAPress_CA;
    property Gas_Factor_CAPress_Air: double read FGas_Factor_CAPress_Air write FGas_Factor_CAPress_Air;
    property Gas_Factor_ExhTemp_CA: double read FGas_Factor_ExhTemp_CA write FGas_Factor_ExhTemp_CA;
    property Gas_Factor_ExhTemp_Air: double read FGas_Factor_ExhTemp_Air write FGas_Factor_ExhTemp_Air;
    property Gas_Factor_ExhTempTCInlet_CA: double read FGas_Factor_ExhTempTCInlet_CA write FGas_Factor_ExhTempTCInlet_CA;
    property Gas_Factor_ExhTempTCInlet_Air: double read FGas_Factor_ExhTempTCInlet_Air write FGas_Factor_ExhTempTCInlet_Air;
    property Gas_Factor_ExhTempTCOutlet_CA: double read FGas_Factor_ExhTempTCOutlet_CA write FGas_Factor_ExhTempTCOutlet_CA;
    property Gas_Factor_ExhTempTCOutlet_Air: double read FGas_Factor_ExhTempTCOutlet_Air write FGas_Factor_ExhTempTCOutlet_Air;

    property Diesel_Factor_Pmax_Load1: double read FDiesel_Factor_Pmax_Load1 write FDiesel_Factor_Pmax_Load1;
    property Diesel_Factor_Pmax_Load2: double read FDiesel_Factor_Pmax_Load2 write FDiesel_Factor_Pmax_Load2;
    property Diesel_Factor_Pmax_Load3: double read FDiesel_Factor_Pmax_Load3 write FDiesel_Factor_Pmax_Load3;
    property Diesel_Factor_Pmax_Load4: double read FDiesel_Factor_Pmax_Load4 write FDiesel_Factor_Pmax_Load4;

    property Diesel_Factor_CAPress_Load1: double read FDiesel_Factor_CAPress_Load1 write FDiesel_Factor_CAPress_Load1;
    property Diesel_Factor_CAPress_Load2: double read FDiesel_Factor_CAPress_Load2 write FDiesel_Factor_CAPress_Load2;
    property Diesel_Factor_CAPress_Load3: double read FDiesel_Factor_CAPress_Load3 write FDiesel_Factor_CAPress_Load3;
    property Diesel_Factor_CAPress_Load4: double read FDiesel_Factor_CAPress_Load4 write FDiesel_Factor_CAPress_Load4;

    property Diesel_Factor_ExhTemp_Load1: double read FDiesel_Factor_ExhTemp_Load1 write FDiesel_Factor_ExhTemp_Load1;
    property Diesel_Factor_ExhTemp_Load2: double read FDiesel_Factor_ExhTemp_Load2 write FDiesel_Factor_ExhTemp_Load2;
    property Diesel_Factor_ExhTemp_Load3: double read FDiesel_Factor_ExhTemp_Load3 write FDiesel_Factor_ExhTemp_Load3;
    property Diesel_Factor_ExhTemp_Load4: double read FDiesel_Factor_ExhTemp_Load4 write FDiesel_Factor_ExhTemp_Load4;

    property Diesel_Factor_ExhTempTCInlet_Load1: double read FDiesel_Factor_ExhTempTCInlet_Load1 write FDiesel_Factor_ExhTempTCInlet_Load1;
    property Diesel_Factor_ExhTempTCInlet_Load2: double read FDiesel_Factor_ExhTempTCInlet_Load2 write FDiesel_Factor_ExhTempTCInlet_Load2;
    property Diesel_Factor_ExhTempTCInlet_Load3: double read FDiesel_Factor_ExhTempTCInlet_Load3 write FDiesel_Factor_ExhTempTCInlet_Load3;
    property Diesel_Factor_ExhTempTCInlet_Load4: double read FDiesel_Factor_ExhTempTCInlet_Load4 write FDiesel_Factor_ExhTempTCInlet_Load4;

    property Diesel_Factor_ExhTempTCOutlet_Load1: double read FDiesel_Factor_ExhTempTCOutlet_Load1 write FDiesel_Factor_ExhTempTCOutlet_Load1;
    property Diesel_Factor_ExhTempTCOutlet_Load2: double read FDiesel_Factor_ExhTempTCOutlet_Load2 write FDiesel_Factor_ExhTempTCOutlet_Load2;
    property Diesel_Factor_ExhTempTCOutlet_Load3: double read FDiesel_Factor_ExhTempTCOutlet_Load3 write FDiesel_Factor_ExhTempTCOutlet_Load3;
    property Diesel_Factor_ExhTempTCOutlet_Load4: double read FDiesel_Factor_ExhTempTCOutlet_Load4 write FDiesel_Factor_ExhTempTCOutlet_Load4;
