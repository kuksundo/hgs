unit UnitRegCodeConst;

interface

uses
  SynCommons,
  mORMot, OnGuard, OgUtil, Registry , Winapi.Windows, Vcl.StdCtrls
  ;

type
  TPassWordType = (pwtString, pwtNumber, pwtBoth);
  TPassWordInsertChar = (pwicNone, pwicDash, pwicUnderScore);
  TMyCodeTypes = Set of TCodeType;
  TQueryDateType = (qdtNull, qdtExpireDate, qdtRegDate, qdtFinal);

const
  EncryptionKey : TKey = ($EA, $8B, $8C, $DD, $9E, $CF, $A4, $D8,
                          $1F, $FE, $6D, $8C, $AB, $FA, $DF, $B4);
  DEFAULT_ENCRYPT_KEY = '{D7A49DB5-B32B-483A-B750-F71C00A8887C}';
  DEFAULT_TRIAL_STRING = '_Trial';
  DEFAULT_SERIAL_FILE_EXT = '.SerialNo';

  R_QueryDateType : array[qdtNull..qdtFinal] of record
    Description : string;
    Value       : TQueryDateType;
  end = ((Description : '';                        Value : qdtNull),
         (Description : '기간만료일 기준';         Value : qdtExpireDate),
         (Description : '등록일 기준';             Value : qdtRegDate),
         (Description : '';                        Value : qdtFinal)
         );

  R_CodeType : array[ctDate..ctUnknown] of record
    Description : string;
    Value       : TCodeType;
  end = ((Description : '기간만료일';           Value : ctDate),
         (Description : '설치후일수';           Value : ctDays),
         (Description : '등록코드';             Value : ctRegistration),
         (Description : '시리얼코드';           Value : ctSerialNumber),
         (Description : '사용횟수';             Value : ctUsage),
         (Description : '네크워크';             Value : ctNetwork),
         (Description : '특수용도';             Value : ctSpecial),
         (Description : '알수없음';             Value : ctUnknown)
         );

function QueryDateType2String(AQueryDateType:TQueryDateType) : string;
function String2QueryDateType(AQueryDateType:string): TQueryDateType;
procedure QueryDateType2Combo(AComboBox:TComboBox);
function CodeType2String(ACodeType:TCodeType) : string;
function String2CodeType(ACodeType:string): TCodeType;
procedure CodeType2Combo(AComboBox:TComboBox);
function CodeTypesToInt(ACodeTypes: TMyCodeTypes): integer;
function IntToCodeTypes(AInt: Integer): TMyCodeTypes;

implementation

function QueryDateType2String(AQueryDateType:TQueryDateType) : string;
begin
  if AQueryDateType <= High(TQueryDateType) then
    Result := R_QueryDateType[AQueryDateType].Description;
end;

function String2QueryDateType(AQueryDateType:string): TQueryDateType;
var Li: TQueryDateType;
begin
  for Li := qdtNull to qdtFinal do
  begin
    if R_QueryDateType[Li].Description = AQueryDateType then
    begin
      Result := R_QueryDateType[Li].Value;
      exit;
    end;
  end;
end;

procedure QueryDateType2Combo(AComboBox:TComboBox);
var Li: TQueryDateType;
begin
  AComboBox.Clear;

  for Li := qdtNull to Pred(qdtFinal) do
  begin
    AComboBox.Items.Add(R_QueryDateType[Li].Description);
  end;
end;

function CodeType2String(ACodeType:TCodeType) : string;
begin
  if ACodeType <= High(TCodeType) then
    Result := R_CodeType[ACodeType].Description;
end;

function String2CodeType(ACodeType:string): TCodeType;
var Li: TCodeType;
begin
  for Li := ctDate to ctUnknown do
  begin
    if R_CodeType[Li].Description = ACodeType then
    begin
      Result := R_CodeType[Li].Value;
      exit;
    end;
  end;
end;

procedure CodeType2Combo(AComboBox:TComboBox);
var Li: TCodeType;
begin
  AComboBox.Clear;

  for Li := ctDate to ctUnknown do
  begin
    AComboBox.Items.Add(R_CodeType[Li].Description);
  end;
end;

function CodeTypesToInt(ACodeTypes: TMyCodeTypes): integer;
var
  LCodeType: TCodeType;
begin
  Result := 0;

  for LCodeType := Low(TCodeType) to High(TCodeType) do
    if (LCodeType in ACodeTypes) then
      Result := Result or (1 shl Ord(LCodeType));
end;

function IntToCodeTypes(AInt: Integer): TMyCodeTypes;
var
  i: integer;
begin
  Result := [];

  for i := 0 to Ord(High(TCodeType)) do
    if AInt and (1 shl i) <> 0 then
      Result := Result + [TCodeType(i)];
end;

end.
