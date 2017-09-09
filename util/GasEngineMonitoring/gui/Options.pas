{******************************************************************

                   Gas Engine Options Properties

 Copyright (C) 2010 HHI

 Original author: J.H.Park [kuksundo@hhi.co.kr]

 The contents of this file are used with permission, subject to
 the Mozilla Public License Version 1.1 (the "License"); you may  
 not use this file except in compliance with the License. You may 
 obtain a copy of the License at
 http://www.mozilla.org/MPL/MPL-1_1Final.html

 Software distributed under the License is distributed on an
 "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   
 implied. See the License for the specific language governing
 rights and limitations under the License.

******************************************************************}

unit Options;

interface

uses
  Classes, SysUtils, BaseConfigCollect;

type
  TOptionCollect = class;
  TOptionItem = class;

  TOptionComponent = class(TpjhBase)
  private
    FOption: TOptionCollect;
    FFooter: string;
    FHeader: string;  //Engine Type
    FFileName: string;

    FEfficiency: double;
    FLCV: integer;
    FStoichiometricRatio: double;//(kg/kg) 이론 공연비(연료에 따라 다름)

    //=====MEP=====
    FBore: integer;
    FStroke: integer;
    FCylinderCount: integer;
    FMCR: integer;
    FRatedPower: Double; //(kW)
    FGeneratorOutput: Double; //Measured(kW/h)
    FEngineSpeed: integer; //Measured(rpm)
    FGasFlow: double;  //Gas Flow(m³/h)
    FGasTemp,
    FGasPress: double;

    //=====Ambient=====
    FIntakeAirTemp: double;//Intake Air Temp.
    FSVP: double;// Saturation Vapour Press.(kPa)
    FSAP: double;// Scavange Air Pressure(kg/cm²)
    FSAT: double;// Scavange Air Temperature(°C)
    FBP: double;// Barometric Pressure(kPa)

    //=====Governor=====
    FIAH: double;//Intake Air Humidity(%)
    FIAH2: double;// Intake Air Humidity(g/kg)
    FIART: double;// Intecooled Air Ref. Temperature(°C)
    FCWIT: double;// C.W. Inlet Temp.(°C)
    FCWOT: double;// C.W. Outlet Temp.(°C)

    //=====Fuel=====
    FFC: double;//Fuel Consumption(kg/h)
    FUFC: double;// Uncorrected Fuel Consumption(g/kwh)

    //=====Gaseous=====  계측값이 아닌 연료조성비 %임
    FCH4: double;
    FC2H6: double;
    FC3H8: double;
    FC4H10: double;
    FC5H12: double;
    
    FCarbon: double;
    FHydrogen: double;
    FNitrogen: double;
    FOxygen: double;
    FSulfur: double;
    FUseInputDensity: boolean;
    FDensity: double;
    FViscosity: double;
    FC_residue: double;
    FWater: double;

    //=====NOx=====
    FNhtCF: double;  //Nox humidity/temp. Correction Factor
    FDWCFE: double;//Dry/Wet Correction Factor Exhaust:
    FEGF: double; //Exhaust Gas Flow(kg/h)
    FAF1: double; //Air Flow (kg/h)
    FAF2: double; //Air Flow (kg/kwh)
    FAF3: double; //Air Flow (kg/s)
    FAF_Measured: double; //Measured Air Flow (kg/h):MT210
    FUseMT210Data: boolean;
    FRealtimeKnockData: boolean; //Display real time knock data
    FRealtimeMisfireData: boolean; //Display real time misfire data

    //======Etc=====
    FCloseTCPClient: boolean;//Close TCP Client Program when main form is closed;
    //Turbo Charger Count(Air Flow Nozzle sensor 개수가 한개일 경우 공기량 계산시 곱하기 위함)
    FTCCount: integer;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure AddDefautProperties;
  published
    property Header: string read FHeader write FHeader;
    property FileName: string read FFileName write FFileName;
    property Option: TOptionCollect read FOption write FOption;
    property Footer: string read FFooter write FFooter;

    property Bore: integer read FBore write FBore;
    property Stroke: integer read FStroke write FStroke;
    property CylinderCount: integer read FCylinderCount write FCylinderCount;
    property MCR: integer read FMCR write FMCR;
    property RatedPower: Double read FRatedPower write FRatedPower;
    property GeneratorOutput: Double read FGeneratorOutput write FGeneratorOutput;
    property EngineSpeed: integer read FEngineSpeed write FEngineSpeed;

    property IntakeAirTemp: double read FIntakeAirTemp write FIntakeAirTemp;
    property SVP: double read FSVP write FSVP;
    property SAP: double read FSAP write FSAP;
    property SAT: double read FSAT write FSAT;
    property BP: double read FBP write FBP;

    property IAH: double read FIAH write FIAH;
    property IAH2: double read FIAH2 write FIAH2;
    property IART: double read FIART write FIART;
    property CWIT: double read FCWIT write FCWIT;
    property CWOT: double read FCWOT write FCWOT;

    property FC: double read FFC write FFC;
    property LCV: integer read FLCV write FLCV;
    property UFC: double read FUFC write FUFC;

    property CH4: double read FCH4 write FCH4;
    property C2H6: double read FC2H6 write FC2H6;
    property C3H8: double read FC3H8 write FC3H8;
    property C4H10: double read FC4H10 write FC4H10;
    property C5H12: double read FC5H12 write FC5H12;

    property Carbon: double read FCarbon write FCarbon;
    property Hydrogen: double read FHydrogen write FHydrogen;
    property Nitrogen: double read FNitrogen write FNitrogen;
    property Oxygen: double read FOxygen write FOxygen;
    property Sulfur: double read FSulfur write FSulfur;
    property Density: double read FDensity write FDensity;
    property UseInputDensity: boolean read FUseInputDensity write FUseInputDensity;
    property Viscosity: double read FViscosity write FViscosity;
    property C_residue: double read FC_residue write FC_residue;
    property Water: double read FWater write FWater;

    property NhtCF: double read FNhtCF write FNhtCF;
    property DWCFE: double read FDWCFE write FDWCFE;
    property EGF: double read FEGF write FEGF;
    property AF1: double read FAF1 write FAF1;
    property AF2: double read FAF2 write FAF2;
    property AF3: double read FAF3 write FAF3;
    property AF_Measured: double read FAF_Measured write FAF_Measured;
    property UseMT210Data: boolean read FUseMT210Data write FUseMT210Data;
    property RealtimeKnockData: boolean read FRealtimeKnockData write FRealtimeKnockData;
    property RealtimeMisfireData: boolean read FRealtimeMisfireData write FRealtimeMisfireData;

    property StoichiometricRatio: double read FStoichiometricRatio write FStoichiometricRatio;
    property Efficiency: double read FEfficiency write FEfficiency;
    property GasFlow: double read FGasFlow write FGasFlow;
    property GasTemp: double read FGasTemp write FGasTemp;
    property GasPress: double read FGasPress write FGasPress;

    property CloseTCPClient: Boolean read FCloseTCPClient write FCloseTCPClient;
    property TCCount: integer read FTCCount write FTCCount;
  end;

  TOptionItem = class(TCollectionItem)
  private
    FEngineLoad: integer; //(%)
    FEngineOutput: double;//(kW)
    FGenEfficiency: double;//(%/100)
    FGenOutput: double;//(kW)
  published
    property EngineLoad: integer read FEngineLoad write FEngineLoad;
    property EngineOutput: double read FEngineOutput write FEngineOutput;
    property GenEfficiency: double read FGenEfficiency write FGenEfficiency;
    property GenOutput: double read FGenOutput write FGenOutput;
  end;

  TOptionCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TOptionItem;
    procedure SetItem(Index: Integer; const Value: TOptionItem);
  public
    function  Add: TOptionItem;
    function Insert(Index: Integer): TOptionItem;
    property Items[Index: Integer]: TOptionItem read GetItem  write SetItem; default;
  end;

implementation

uses ConfigUtil;

{ TOptionItem }

function TOptionCollect.Add: TOptionItem;
begin
  Result := TOptionItem(inherited Add);
end;

function TOptionCollect.GetItem(Index: Integer): TOptionItem;
begin
  Result := TOptionItem(inherited Items[Index]);
end;

function TOptionCollect.Insert(Index: Integer): TOptionItem;
begin
  Result := TOptionItem(inherited Insert(Index));
end;

procedure TOptionCollect.SetItem(Index: Integer; const Value: TOptionItem);
begin
  Items[Index].Assign(Value);
end;

{ TOptionItem }

procedure TOptionComponent.AddDefautProperties;
begin
//  with FOption.Add do
//  begin
//  end;//with

end;

constructor TOptionComponent.Create(AOwner: TComponent);
begin
  FOption := TOptionCollect.Create(TOptionItem);
end;

destructor TOptionComponent.Destroy;
begin
  inherited Destroy;
  FOption.Free;
end;

end.
