unit UnitEngineMasterData;

interface

uses System.Classes, UnitEnumHelper;

type
  TEngineMasterQueryDateType = (emdtNull, emdtProductDeliveryDate, emdtShipDeliveryDate,
    emdtWarrantyDueDate, emdtFinal);

  TEngineProductType = (vepteNull, vepte2StrokeEngine, vepte4StrokeEngine,
    vepteSternPost, veptePowerPlant, vepteEcoMachine, vepteGearBox, vepteVesselPump,
    vepteTurbine, veptePump, vepteFinal);

  TEngine2SProductType = (en2ptNull, en2ptStartingBox, en2ptEngineController, en2ptFinal);//2 Stroke Engine
  TEngine2SProductTypes = set of TEngine2SProductType;

  TEngine4SProductType = (en4ptNull, en4ptStartingBox, en4ptEngineController, en4ptLCP, en4ptFinal);//4 Stroke Engine
  TEngine4SProductTypes = set of TEngine4SProductType;

  TEngineModel_TierI = (et1Null, et1H1728, et1H1728U, et1H1728E, et1H2132, et1H2533, et1H3240, et1Final);
  TEngineModel_TierII = (et2Null, et2H1728, et2H1728U, et2H1728E, et2H2132, et2H2533V, et2H3240V, et2Final);
  TEngineModel_TierIII = (et3Null, et3H22DF, et3H27DF, et3H35DF, et3H54DF, et3H35G, et3H54G, et3Final);

  TTCModel_TierI = (tt1Null, tt1HPR3000, tt1HPR4000, tt1HPR5000, tt1HPR6000,
    tt1TPS44, tt1TPS48, tt1TPS52, tt1TPS57, tt1TPS61, tt1TPL67, tt1Final);
  TTCModel_TierII = (tt2Null, tt2ST3, tt2ST4, tt2ST5, tt2ST6, tt2ST7, tt2A130,
    tt2A135, tt2A140, tt2A145, tt2A150, tt2A155, tt2TPL65, tt2TPL67, tt2Final);
  TTCModel_TierIII = (tt3Null, tt3Final);

  TEngineUsage = (euNull, euMarine, euStatinoary, euPropulsion, euFinal);

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

function GetEngineUsageChar(AIndex: integer): string;

var
  g_EngineMasterQueryDateType: TLabelledEnum<TEngineMasterQueryDateType>;
  g_EngineProductType: TLabelledEnum<TEngineProductType>;
  g_Engine2SProductType: TLabelledEnum<TEngine2SProductType>;
  g_Engine4SProductType: TLabelledEnum<TEngine4SProductType>;
  g_EngineTier1: TLabelledEnum<TEngineModel_TierI>;
  g_EngineTier2: TLabelledEnum<TEngineModel_TierII>;
  g_EngineTier3: TLabelledEnum<TEngineModel_TierIII>;
  g_TCModelTier1: TLabelledEnum<TTCModel_TierI>;
  g_TCModelTier2: TLabelledEnum<TTCModel_TierII>;
  g_TCModelTier3: TLabelledEnum<TTCModel_TierIII>;
  g_EngineUsage: TLabelledEnum<TEngineUsage>;

implementation

function GetEngineUsageChar(AIndex: integer): string;
begin
  case AIndex of
    1: Result := 'M';
    2: Result := 'S';
    3: Result := 'P';
  end;
end;

initialization
  g_EngineMasterQueryDateType.InitArrayRecord(R_EngineMasterQueryDateType);
  g_EngineProductType.InitArrayRecord(R_EngineProductType);
  g_Engine2SProductType.InitArrayRecord(R_Engine2SProductType);
  g_Engine4SProductType.InitArrayRecord(R_Engine4SProductType);
  g_EngineTier1.InitArrayRecord(R_EngineModel_TierI);
  g_EngineTier2.InitArrayRecord(R_EngineModel_TierII);
  g_EngineTier3.InitArrayRecord(R_EngineModel_TierII);
  g_TCModelTier1.InitArrayRecord(R_TCModel_TierI);
  g_TCModelTier2.InitArrayRecord(R_TCModel_TierII);
  g_TCModelTier3.InitArrayRecord(R_TCModel_TierIII);
  g_EngineUsage.InitArrayRecord(R_EngineUsage);

finalization

end.
