unit UnitVesselData;

interface

uses System.Classes, UnitEnumHelper;

type
  TVesselQueryDateType = (vqdtNull, vqdtDockingSurveyDate, vqdtSpecialSurveyDate,
    vqdtDeliveryDate, vqdtGuaranteePeriod, vqdtFinal);

  TVesselStatus = (vsNull, vsInServiceCommission, vsBrokenUp, vsToBeBrokenUp,
    vsInCasualtyOrRepairing, vsLauched, vsKeelLaid, vsUnderConstruction,
    vsLaidUp, vsOnOrder, vsCancelled, vsTotalLoss, vsFinal);

  TShipProductType = (shptNull, shptME, shptGE, shptCB, shptTR, shptGEN, shptAMS,
  shptSWBD, shptMOTOR,
//KF23     KF25      KF21      KH2S      KD21           KF27  (Usage)
  shptSCR, shptBWTS, shptFGSS, shptCOPT, shptPROPELLER, shptEGR, shptVDR, shptFinal);
  TShipProductTypes = Set of TShipProductType;

const
  R_VesselQueryDateType : array[Low(TVesselQueryDateType)..High(TVesselQueryDateType)] of string =
    ('', 'Docking Survey date', 'Special Survey date', 'Delivery date',
      'Guarantee Period' ,'');

  R_VesselStatus : array[Low(TVesselStatus)..High(TVesselStatus)] of string =
    ('', 'In Service/Commission', 'Broken Up', 'To Be Broken Up', 'In Casualty Or Repairing',
      'Launched', 'Keel Laid', 'Under Construction', 'Laid-Up', 'On Order/Not Commenced',
      'Cancelled Before Construction', 'Total Loss', '');

  R_ShipProductType : array[Low(TShipProductType)..High(TShipProductType)] of string =
         ('',
         'Main Engine',
         'Generator Engine',
         'Circuit Breaker',
         'Transformer',
         'Generator',
         'AMS',
         'Switch Board',
         'MOTOR',
         'SCR',
         'BWTS',
         'FGSS',
         'COPT',
         'PROPELLER',
         'EGR',
         'VDR',
         ''
         );

  R_ShipProductCode : array[Low(TShipProductType)..High(TShipProductType)] of string =
         ('',
         'ME',
         'GE',
         'CB',
         'TR',
         'AT',
         'AMS',
         'SB',
         'MOTOR',
         'SCR',
         'BWTS',
         'FGSS',
         'COPT',
         'PROPELLER',
         'EGR',
         'VDR',
         ''
         );

procedure ShipProductType2List(AList:TStrings);
function TShipProductType_SetToInt(ss : TShipProductTypes) : integer;
function IntToTShipProductType_Set(mask : integer) : TShipProductTypes;

var
  g_VesselQueryDateType: TLabelledEnum<TVesselQueryDateType>;
  g_VesselStatus: TLabelledEnum<TVesselStatus>;
  g_ShipProductType: TLabelledEnum<TShipProductType>;
  g_ShipProductCode: TLabelledEnum<TShipProductType>;

implementation

procedure ShipProductType2List(AList:TStrings);
var Li: TShipProductType;
//var
//  LStrList: TStrings;
begin
  AList.Clear;

  for Li := Succ(Low(TShipProductType)) to Pred(High(TShipProductType)) do
  begin
    AList.Add(R_ShipProductType[Li]);
  end;
//  LStrList := g_ShipProductType.GetTypeLabels(True);
//  try
//    AList.Assign(LStrList);
//  finally
//    LStrList.Free;
//  end;
end;

function TShipProductType_SetToInt(ss : TShipProductTypes) : integer;
//var intset : TIntegerSet;
//    s : TShipProductType;
begin
//  intSet := [];
//  for s in ss do
//    include(intSet, ord(s));
//  result := integer(intSet);
  Result := SetToInt(ss, SizeOf(ss));
end;

function IntToTShipProductType_Set(mask : integer) : TShipProductTypes;
//var intSet : TIntegerSet;
//    b : byte;
begin
//  intSet := TIntegerSet(mask);
//  result := [];
//  for b in intSet do
//    include(result, TShipProductType(b));
  IntToSet(mask, Result, SizeOf(mask));
end;

initialization
  g_VesselQueryDateType.InitArrayRecord(R_VesselQueryDateType);
  g_VesselStatus.InitArrayRecord(R_VesselStatus);
  g_ShipProductType.InitArrayRecord(R_ShipProductType);
  g_ShipProductCode.InitArrayRecord(R_ShipProductCode);

finalization

end.
