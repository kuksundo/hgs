unit CustomLogicType;

interface

uses Classes, pjhClasses, CustomLogic;

type
  TExpression = (eEqual, eLessThan, eLessThanEqual, eGreaterThan, eGreaterThanEqual);
  //cdtInteger, cdtBoolean, cdtFloat, cdtBCD, cdtDate, cdtTime, cdtDateTime,
  TCommDataType = (cdtString, cdtDecimal, cdtHexaDecimal);
  //수신 조건           일정크기,특정문자수신여부,일정시간,조건없음
  TCommDataCondition = (cdcSize, cdcChar, cdcInterval, cdcDontCare);
  TDelimiter = (delCR, delLF, delComma, delSemiColon, delColon, delNotUse);
  TpjhFileAction = (faRead, faWrite);

  TCompareData = class(TPersistent)
  private
    FDataType: TCommDataType;
    FData: string;
    //FByteData: TByteArray2;

  protected
    procedure SetData(Value: string);
  published
    property DataType: TCommDataType read FDataType write FDataType;
    property Data: string read FData write SetData;
  end;

  TDataFile = class(TPersistent)
  private
    FEnabled: Boolean;
    FFileName: TFileNameDlgClass;
    FFileAction: TpjhFileAction;

  protected
    function GetFileName: TFileNameDlgClass;
    procedure SetFileName(const Value: TFileNameDlgClass);
  published
    property Enabled: Boolean read FEnabled write FEnabled;
    property FileName: TFileNameDlgClass read GetFileName write SetFileName;
    property FileAction: TpjhFileAction read FFileAction write FFileAction;
  end;

  TpjhProcess = class(TCustomLogicNode)
  private
  published
    property NextStep;
  end;

  TpjhProcess2 = class(TCustomLogicTransition)
  private
  published
    property FromStep;
    property ToStep;
  end;

implementation

{ TDataFile }

function TDataFile.GetFileName: TFileNameDlgClass;
begin
  Result := TFileNameDlgClass(FFileName);
end;

procedure TDataFile.SetFileName(const Value: TFileNameDlgClass);
begin
  FFileName := String(Value);
end;

{ TCompareData }

procedure TCompareData.SetData(Value: string);
begin
  case FDataType of
    cdtString,
    cdtDecimal,
    cdtHexaDecimal: FData := Value;
  end;//case
end;

end.


