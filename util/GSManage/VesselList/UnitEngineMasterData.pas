unit UnitEngineMasterData;

interface

uses System.Classes, UnitEnumHelper;

type
  THimsenWearingSpareRec = record
    fHullNo,
    fEngineType,
    fTCModel,
    fRunningHour,
    fCylCount,
    fRatedRPM,
    fMainBearingMaker
    : string;
    fTierStep,
    fUsage: integer;
    fIsRetrofit: Boolean;
  end;

  TEngineMasterQueryDateType = (emdtNull, emdtProductDeliveryDate, emdtShipDeliveryDate,
    emdtWarrantyDueDate, emdtFinal);

  TEngineProductType = (vepteNull, vepte2StrokeEngine, vepte4StrokeEngine,
    vepteSternPost, veptePowerPlant, vepteEcoMachine, vepteGearBox, vepteVesselPump,
    vepteTurbine, veptePump, vepteFinal);

  TEngine2SProductType = (en2ptNull, en2ptStartingBox, en2ptEngineController, en2ptFinal);//2 Stroke Engine
  TEngine2SProductTypes = set of TEngine2SProductType;

  TEngine4SProductType = (en4ptNull, en4ptStartingBox, en4ptEngineController, en4ptLCP, en4ptFinal);//4 Stroke Engine
  TEngine4SProductTypes = set of TEngine4SProductType;

  TTierNo = (tnNull, tnTierI, tnTierII, tnTierIII, tnFinal);
  TEngineModel = (emNull, emH1728, emH1728U, emH1728E, emH2132, emH2533, emH2533V, emH3240, emH3240V,
    emH22DF, emH27DF, emH35DF, emH54DF, emH35G, emH54G, emFinal);
  TEngineModel_TierI = (et1Null, et1H1728, et1H1728U, et1H1728E, et1H2132, et1H2533, et1H3240, et1Final);
  TEngineModel_TierII = (et2Null, et2H1728, et2H1728U, et2H1728E, et2H2132, et2H2533V, et2H3240V, et2Final);
  TEngineModel_TierIII = (et3Null, et3H22DF, et3H27DF, et3H35DF, et3H54DF, et3H35G, et3H54G, et3Final);

  TTCModel_TierI = (tt1Null, tt1HPR3000, tt1HPR4000, tt1HPR5000, tt1HPR6000,
    tt1TPS44, tt1TPS48, tt1TPS52, tt1TPS57, tt1TPS61, tt1TPL67, tt1Final);
  TTCModel_TierII = (tt2Null, tt2ST3, tt2ST4, tt2ST5, tt2ST6, tt2ST7, tt2A130,
    tt2A135, tt2A140, tt2A145, tt2A150, tt2A155, tt2TPL65, tt2TPL67, tt2Final);
  TTCModel_TierIII = (tt3Null, tt3ST7, tt3A150, tt3A155, tt3Final);

  TTCModel_All = (tmaNull, tmaHPR3000, tmaHPR4000, tmaHPR5000, tmaHPR6000,
    tmaST3, tmaST4, tmaST5, tmaST6, tmaST7,
    tmaTPS44, tmaTPS48, tmaTPS52, tmaTPS57, tmaTPS61, tmaTPL65, tmaTPL67,
    tmaA130, tmaA135, tmaA140, tmaA145, tmaA150, tmaA155, tmaA170, tmaA175, tmaA180,
    tma30SRC, tmaSRC, tmaFinal);

  TEngineUsage = (euNull, euMarine, euStatinoary, euPropulsion, euFinal);
  TMainBearingMaker = (mmbNull, mbmMiba, mbmDaido, mbmFinal);
  TEngineFuelKind = (efkNull, efkMGO, efkMDO, efkHFO, efkGas, efkFinal);
  TEngineFuelKind2 = (efk2Null, efk2Diesel, efk2Gas, efk2Final);
  TEngineFuelGasKind = (efgkNull, efgkLNG, efgkLPG, efgkEthan, efgkFinal);
  TGovernorKind = (gkNull, gkUG8D, gkUG25, gkHeinz, gkEuropa, gkFinal);
  TAdditionalEquipKind = (aekNull, aekDVT, aekSOM, aekNOx, aekSOx, aekFinal);
  TAdditionalEquipKinds = set of TAdditionalEquipKind;
  TEngineOperationMode = (eomNull, eomDiesel, eomDiesel2Gas, eomGas, eomGas2Diesel, eomBackUp, eomEmcy, eomFinal);

  TCsvFileSource = (cfsNull, cfsHiMEMS, cfsISS, cfsDATS, cfsFinal);
  TEngineMaker = (emkNull, emkMAN, emkWinGD, emkWartsila, emkHHI, emkFinal);
  TEngine2SModel1 = (e2sm1Null, e2sm1Final); //MAN
  TEngine2SModel2 = (e2sm2Null, e2sm2Final); //WinGD
const
  R_EngineMasterQueryDateType : array[Low(TEngineMasterQueryDateType)..High(TEngineMasterQueryDateType)] of string =
    ('', 'Product Delivery Date', 'Ship Delivery Date', 'Warranty Due Date', '');

  R_EngineProductType : array[Low(TEngineProductType)..High(TEngineProductType)] of string =
    ('', '대형엔진', '중형엔진', '선미재', '엔진발전', '환경기계', '기어박스',
      '박용펌프', '터빈', 'PUMP', '');

  R_Engine2SProductType : array[Low(TEngine2SProductType)..High(TEngine2SProductType)] of string =
  (
    '',
    '(2행정)전계장-Starting Box',
    '(2행정)전자제어 제어기',
    ''
  );

  R_Engine4SProductType : array[Low(TEngine4SProductType)..High(TEngine4SProductType)] of string =
  (
    '',
    '(4행정)전계장-Starting Box',
    '(4행정)전자제어 제어기',
    '(4행정)LCP',
    ''
  );

  R_TierNo : array[Low(TTierNo)..High(TTierNo)] of string =
  (
    '',
    'Tier I',
    'Tier II',
    'Tier III',
    ''
  );

  R_EngineModel : array[Low(TEngineModel)..High(TEngineModel)] of string =
  (
    '',
    'H17/28',
    'H17/28U',
    'H17/28E',
    'H21/32',
    'H25/33',
    'H25/33(V)',
    'H32/40',
    'H32/40(V)',
    'H22DF',
    'H27DF(V)',
    'H35DF(V)',
    'H54DF(V)',
    'H35G',
    'H54G',
    ''
  );

  R_EngineModel_TierI : array[Low(TEngineModel_TierI)..High(TEngineModel_TierI)] of string =
  (
    '',
    'H17/28',
    'H17/28U',
    'H17/28E',
    'H21/32',
    'H25/33',
    'H32/40',
    ''
  );

  R_EngineModel_TierII : array[Low(TEngineModel_TierII)..High(TEngineModel_TierII)] of string =
  (
    '',
    'H17/28',
    'H17/28U',
    'H17/28E',
    'H21/32',
    'H25/33(V)',
    'H32/40(V)',
    ''
  );

  R_EngineModel_TierIII : array[Low(TEngineModel_TierIII)..High(TEngineModel_TierIII)] of string =
  (
    '',
    'H22DF',
    'H27DF(V)',
    'H35DF(V)',
    'H54DF(V)',
    'H35G',
    'H54G',
    ''
  );

  R_TCModel_TierI : array[Low(TTCModel_TierI)..High(TTCModel_TierI)] of string =
  (
    '',
    'HPR3000',
    'HPR4000',
    'HPR5000',
    'HPR6000',
    'TPS44',
    'TPS48',
    'TPS52',
    'TPS57',
    'TPS61',
    'TPL67',
    ''
  );

  R_TCModel_TierII : array[Low(TTCModel_TierII)..High(TTCModel_TierII)] of string =
  (
    '',
    'ST3',
    'ST4',
    'ST5',
    'ST6',
    'ST7',
    'A130',
    'A135',
    'A140',
    'A145',
    'A150',
    'A155',
    'TPL65',
    'TPL67',
    ''
  );

  R_TCModel_TierIII : array[Low(TTCModel_TierIII)..High(TTCModel_TierIII)] of string =
  (
    '',
    'ST7',
    'A150',
    'A155',
    ''
  );

  R_TCModel_All : array[Low(TTCModel_All)..High(TTCModel_All)] of string =
  (
    '',
    //KBB
    'HPR3000',
    'HPR4000',
    'HPR5000',
    'HPR6000',
    'ST3',
    'ST4',
    'ST5',
    'ST6',
    'ST7',
    //ABB
    'TPS44',
    'TPS48',
    'TPS52',
    'TPS57',
    'TPS61',
    'TPL65',
    'TPL67',
    'A130',
    'A135',
    'A140',
    'A145',
    'A150',
    'A155',
    'A170',
    'A175',
    'A180',
    //MHI
    '30SRC',
    '37SRC',
    ''
  );

  R_EngineUsage : array[Low(TEngineUsage)..High(TEngineUsage)] of string =
  (
    '',
    'Marine',
    'Stationary',
    'Propulsion',
    ''
  );

  R_MainBearingMaker : array[Low(TMainBearingMaker)..High(TMainBearingMaker)] of string =
  (
    '',
    'Miba',
    'Daido',
    ''
  );

  R_EngineFuelKind : array[Low(TEngineFuelKind)..High(TEngineFuelKind)] of string =
  (
    '',
    'MGO',
    'MDO',
    'HFO',
    'GAS',
    ''
  );

  R_EngineFuelKind2 : array[Low(TEngineFuelKind2)..High(TEngineFuelKind2)] of string =
  (
    '',
    'DIESEL',
    'GAS',
    ''
  );

  R_GovernorKind : array[Low(TGovernorKind)..High(TGovernorKind)] of string =
  (
    '',
    'UG8D',
    'UG25',
    'Heinzmann',
    'Europa',
    ''
  );

  R_AdditionalEquipKind : array[Low(TAdditionalEquipKind)..High(TAdditionalEquipKind)] of string =
  (
    '',
    'DVT',
    'SOM',
    'NOx',
    'SOx',
    ''
  );

  R_EngineOperationMode : array[Low(TEngineOperationMode)..High(TEngineOperationMode)] of string =
  (
    '',
    'Diesel Mode',
    'Diesel To Tranfer Gas Mode',
    'Gas Mode',
    'Gas To Transfer Diesel Mode',
    'BackUp Mode',
    'Emergency Mode',
    ''
  );

  R_CsvFileSource : array[Low(TCsvFileSource)..High(TCsvFileSource)] of string =
  (
    '',
    'HiEMS',
    'ISS',
    'DATS',
    ''
  );

  R_EngineMaker : array[Low(TEngineMaker)..High(TEngineMaker)] of string =
  (
    '',
    'MAN',
    'WinGD',
    'Wartsila',
    'HHI',
    ''
  );

  R_Engine2SModel1 : array[Low(TEngine2SModel1)..High(TEngine2SModel1)] of string =
  (
    '',
    ''
  );

  R_Engine2SModel2 : array[Low(TEngine2SModel2)..High(TEngine2SModel2)] of string =
  (
    '',
    ''
  );

function GetEngineUsageChar(AIndex: integer): string;
procedure EngineProductType2List(AList:TStrings);

function SetStr2AdditionalEquipKinds(ASetStr: string): TAdditionalEquipKinds;
function AdditionalEquipKindSetStr2Int(ASetStr: string): integer;
function AdditionalEquipKindSetStrFromInt(const ASet: integer): string;
function AdditionalEquipKindSet2CommaStr(const ASet: TAdditionalEquipKinds): string;
function AdditionalEquipKindSet2Int(const ASet: TAdditionalEquipKinds): integer;
function Int2AdditionalEquipKindSet(const ASet: integer): TAdditionalEquipKinds;

var
  g_EngineMasterQueryDateType: TLabelledEnum<TEngineMasterQueryDateType>;
  g_EngineProductType: TLabelledEnum<TEngineProductType>;
  g_Engine2SProductType: TLabelledEnum<TEngine2SProductType>;
  g_Engine4SProductType: TLabelledEnum<TEngine4SProductType>;
  g_TierNo: TLabelledEnum<TTierNo>;
  g_EngineModel: TLabelledEnum<TEngineModel>;
  g_EngineTier1: TLabelledEnum<TEngineModel_TierI>;
  g_EngineTier2: TLabelledEnum<TEngineModel_TierII>;
  g_EngineTier3: TLabelledEnum<TEngineModel_TierIII>;
  g_TCModelTier1: TLabelledEnum<TTCModel_TierI>;
  g_TCModelTier2: TLabelledEnum<TTCModel_TierII>;
  g_TCModelTier3: TLabelledEnum<TTCModel_TierIII>;
  g_TCModelAll: TLabelledEnum<TTCModel_All>;
  g_EngineUsage: TLabelledEnum<TEngineUsage>;
  g_MainBearingMaker: TLabelledEnum<TMainBearingMaker>;
  g_EngineFuelKind: TLabelledEnum<TEngineFuelKind>;
  g_EngineFuelKind2: TLabelledEnum<TEngineFuelKind2>;
  g_GovernorKind: TLabelledEnum<TGovernorKind>;
  g_AdditionalEquipKind: TLabelledEnum<TAdditionalEquipKind>;
  g_EngineOperationMode: TLabelledEnum<TEngineOperationMode>;
  g_CsvFileSource: TLabelledEnum<TCsvFileSource>;
  g_EngineMaker: TLabelledEnum<TEngineMaker>;
  g_Engine2SModel1: TLabelledEnum<TEngine2SModel1>;
  g_Engine2SModel2: TLabelledEnum<TEngine2SModel2>;

implementation

function GetEngineUsageChar(AIndex: integer): string;
begin
  case AIndex of
    1: Result := 'M';
    2: Result := 'S';
    3: Result := 'P';
  end;
end;

procedure EngineProductType2List(AList:TStrings);
var Li: TEngineProductType;
begin
  AList.Clear;

  for Li := Succ(Low(TEngineProductType)) to Pred(High(TEngineProductType)) do
  begin
    AList.Add(R_EngineProductType[Li]);
  end;
end;

function SetStr2AdditionalEquipKinds(ASetStr: string): TAdditionalEquipKinds;
var
  LAdditionalEquipKind: TAdditionalEquipKind;
  LStrList: TStrings;
  i: integer;
begin
  Result := [];

  LStrList := TStringList.Create;
  try
    LStrList.Delimiter := ',';
    LStrList.StrictDelimiter := True;
    LStrList.DelimitedText := ASetStr;

    if not g_AdditionalEquipKind.IsInitArray then
      g_AdditionalEquipKind.InitArrayRecord(R_AdditionalEquipKind);

    for i := 0 to LStrList.Count - 1 do
    begin
//      if g_AdditionalEquipKind.IsExistStrInArray(LStrList.Strings[i]) then
      LAdditionalEquipKind := g_AdditionalEquipKind.ToType(LStrList.Strings[i]);

      if LAdditionalEquipKind > aekNull then
        Result := Result + [LAdditionalEquipKind];
    end;
  finally
    LStrList.Free;
  end;
end;

function AdditionalEquipKindSetStr2Int(ASetStr: string): integer;
var
  LSet: TAdditionalEquipKinds;
begin
  LSet := SetStr2AdditionalEquipKinds(ASetStr);
  Result := AdditionalEquipKindSet2Int(LSet);
end;

function AdditionalEquipKindSetStrFromInt(const ASet: integer): string;
var
  LSet: TAdditionalEquipKinds;
begin
  LSet := Int2AdditionalEquipKindSet(ASet);
  Result := AdditionalEquipKindSet2CommaStr(LSet);
end;

function AdditionalEquipKindSet2CommaStr(const ASet: TAdditionalEquipKinds): string;
var
  LSet: TAdditionalEquipKind;
begin
  Result := '';

  if not g_AdditionalEquipKind.IsInitArray then
    g_AdditionalEquipKind.InitArrayRecord(R_AdditionalEquipKind);

  for LSet := Low(TAdditionalEquipKind) to High(TAdditionalEquipKind) do
  begin
    if (LSet in ASet) then
    begin
      if Result = '' then
        Result := g_AdditionalEquipKind.ToString(LSet)
      else
        Result := Result + ',' + g_AdditionalEquipKind.ToString(LSet);
    end;
  end;

end;

function AdditionalEquipKindSet2Int(const ASet: TAdditionalEquipKinds): integer;
var
  LSet: TAdditionalEquipKind;
begin
  Result := 0;

  for LSet := Low(TAdditionalEquipKind) to High(TAdditionalEquipKind) do
    if (LSet in ASet) then
      Result := Result or (1 shl Ord(LSet));
end;

function Int2AdditionalEquipKindSet(const ASet: integer): TAdditionalEquipKinds;
var
  i: integer;
begin
  Result := [];

  for i := 0 to Ord(High(TAdditionalEquipKind)) do
    if ASet and (1 shl i) <> 0 then
      Result := Result + [TAdditionalEquipKind(i)];
end;

initialization
//  g_EngineMasterQueryDateType.InitArrayRecord(R_EngineMasterQueryDateType);
//  g_EngineProductType.InitArrayRecord(R_EngineProductType);
//  g_Engine2SProductType.InitArrayRecord(R_Engine2SProductType);
//  g_Engine4SProductType.InitArrayRecord(R_Engine4SProductType);
//  g_TierNo.InitArrayRecord(R_TierNo);
//  g_EngineModel.InitArrayRecord(R_EngineModel);
//  g_EngineTier1.InitArrayRecord(R_EngineModel_TierI);
//  g_EngineTier2.InitArrayRecord(R_EngineModel_TierII);
//  g_EngineTier3.InitArrayRecord(R_EngineModel_TierIII);
//  g_TCModelTier1.InitArrayRecord(R_TCModel_TierI);
//  g_TCModelTier2.InitArrayRecord(R_TCModel_TierII);
//  g_TCModelTier3.InitArrayRecord(R_TCModel_TierIII);
//  g_TCModelAll.InitArrayRecord(R_TCModel_All);
//  g_EngineUsage.InitArrayRecord(R_EngineUsage);
//  g_MainBearingMaker.InitArrayRecord(R_MainBearingMaker);
//  g_EngineFuelKind.InitArrayRecord(R_EngineFuelKind);
//  g_EngineFuelKind2.InitArrayRecord(R_EngineFuelKind2);
//  g_GovernorKind.InitArrayRecord(R_GovernorKind);
//  g_AdditionalEquipKind.InitArrayRecord(R_AdditionalEquipKind);
//  g_EngineOperationMode.InitArrayRecord(R_EngineOperationMode);
//  g_CsvFileSource.InitArrayRecord(R_EngineOperationMode);
//  g_EngineMaker.InitArrayRecord(R_EngineMaker);
//  g_Engine2SModel1.InitArrayRecord(R_Engine2SModel1);
//  g_Engine2SModel2.InitArrayRecord(R_Engine2SModel2);

finalization

end.
