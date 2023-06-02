unit UnitElecMasterData;

interface

uses System.Classes, System.SysUtils, UnitEnumHelper;

type
  TElecMasterQueryDateType = (emdtNull, emdtProductDeliveryDate, emdtShipDeliveryDate,
    emdtWarrantyDueDate, emdtFinal);
  TElecProductType = (eptNull, eptEB, eptEC, eptEG, eptEM, eptER, eptFinal);
  TElecProductTypes = set of TElecProductType;
  TElecProductDetailType = (epdtNull, epdtACB, epdtVCB, epdtMCCB, epdtHIMAP_BC,
    epdtHIMAP_F, epdtHIMAP_FI, epdtHIMAP_M, epdtHIMAP_T, epdtGenerator,
    epdtBowThruster, epdtMSBD, epdtESBD, epdtACONIS, epdtHiWMS, epdtHiVDR, epdtA2KPMS,
    epdtPMS, epdtBWTS, epdtStarterPanel, epdtFinal);
  TElecProductDetailTypes = set of TElecProductDetailType;

const
  R_ElecMasterQueryDateType : array[Low(TElecMasterQueryDateType)..High(TElecMasterQueryDateType)] of string =
    ('', 'Product Delivery Date', 'Ship Delivery Date', 'Warranty Due Date', '');
  R_ElecProductType : array[Low(TElecProductType)..High(TElecProductType)] of string =
    ('', '차단기', '선박자동화', '몰드변압기', '배전반', '발전기', '');

  R_ElecProductDetailType : array[Low(TElecProductDetailType)..High(TElecProductDetailType)] of string =
    ('', 'ACB', 'VCB', 'MCCB', 'HIMAP-BC(G)', 'HIMAP-F', 'HIMAP-FI',
      'HIMAP-M', 'HIMAP-T', 'Generator', 'Bow Thruster', 'MSBD', 'ESBD', 'ACONIS',
      'HiWMS', 'HiVDR', 'A2K-PMS', 'PMS', 'BWTS', 'Starter Panel', '');

function TElecProductDetailType_SetToInt(ss : TElecProductDetailTypes) : integer;
function IntToTElecProductDetailType_Set(mask : integer) : TElecProductDetailTypes;
function IsInFromInt2TElecProductDetailType(mask : integer; ss: TElecProductDetailType): Boolean;
function IsInFromElecProductDetailTypes2TElecProductDetailType(mask : TElecProductDetailTypes; ss: TElecProductDetailType): Boolean;
function IsInFromElecProductDetailTypes2TElecProductDetailTypes(mask : TElecProductDetailTypes; ss: TElecProductDetailTypes): Boolean;
function GetElecProductDetailTypes2String(AElecProductDetailTypes: TElecProductDetailTypes): string;
function GetElecProductDetailTypesFromCommaString(ACommaStr: string): TElecProductDetailTypes;

var
  g_ElecMasterQueryDateType: TLabelledEnum<TElecMasterQueryDateType>;
  g_ElecProductType: TLabelledEnum<TElecProductType>;
  g_ElecProductDetailType: TLabelledEnum<TElecProductDetailType>;

implementation

function TElecProductDetailType_SetToInt(ss : TElecProductDetailTypes) : integer;
var intset : TIntegerSet;
    s : TElecProductDetailType;
begin
  intSet := [];
  for s in ss do
    include(intSet, ord(s));
  result := integer(intSet);
end;

function IntToTElecProductDetailType_Set(mask : integer) : TElecProductDetailTypes;
var intSet : TIntegerSet;
    b : byte;
begin
  intSet := TIntegerSet(mask);
  result := [];
  for b in intSet do
    include(result, TElecProductDetailType(b));
end;

function IsInFromInt2TElecProductDetailType(mask : integer; ss: TElecProductDetailType): Boolean;
var intSet : TIntegerSet;
    b : byte;
begin
  intSet := TIntegerSet(mask);

  for b in intSet do
  begin
    Result := TElecProductDetailType(b) = ss;

    if Result then
      break;
  end;
end;

function IsInFromElecProductDetailTypes2TElecProductDetailType(mask : TElecProductDetailTypes; ss: TElecProductDetailType): Boolean;
var
  i: integer;
begin
  i := TElecProductDetailType_SetToInt(mask);
  Result := IsInFromInt2TElecProductDetailType(i, ss);
end;

function IsInFromElecProductDetailTypes2TElecProductDetailTypes(mask : TElecProductDetailTypes; ss: TElecProductDetailTypes): Boolean;
var
  intSet : TIntegerSet;
  b : byte;
  LBa, LBa2: TElecProductDetailType;
begin
  Result := False;

  for LBa in ss do
  begin
    for LBa2 in mask do
    begin
      Result := LBa2 = LBa;

      if Result then
        exit;
    end;
  end;
end;

function GetElecProductDetailTypes2String(AElecProductDetailTypes: TElecProductDetailTypes): string;
var
  LCt: TElecProductDetailType;
begin
  Result := '';

  for LCt in AElecProductDetailTypes do
  begin
    Result := Result + g_ElecProductDetailType.ToString(LCt) + ',';
  end;

  Delete(Result, Length(Result), 1); //마지막 ';' 삭제
end;

function GetElecProductDetailTypesFromCommaString(ACommaStr: string): TElecProductDetailTypes;
var
  LStrList: TStringList;
  LElecProductDetailType: TElecProductDetailType;
  i: integer;
begin
  Result := [];
  LStrList := TStringList.Create;
  try
    LStrList.CommaText := ACommaStr;

    for i := 0 to LStrList.Count - 1 do
    begin
      LElecProductDetailType := g_ElecProductDetailType.ToType(LStrList.Strings[i]);
      Result := Result + [LElecProductDetailType];
    end;
  finally
    LStrList.Free;
  end;
end;

initialization
  g_ElecMasterQueryDateType.InitArrayRecord(R_ElecMasterQueryDateType);
//  g_ElecProductType.InitArrayRecord(R_ElecProductType);
//  g_ElecProductDetailType.InitArrayRecord(R_ElecProductDetailType);

end.
