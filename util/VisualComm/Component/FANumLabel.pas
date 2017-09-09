unit FANumLabel;

{**************************OpenFAVCL PROJECT***********************************}
//  VCL NAME  : F.A Number Label(TFANumLabel)
//  Copyright : Hwang Kwang IL(c) by 1998.2 ~ 2000.7
//  NOTE      :
//            - 이 모델을 이용하여 상업용 소프트웨어를 제작하고 판매하는 방식으로
//              이윤을 획득하는 행위에 대해서는 일체 금함.
//            - 이 모델을 이용하여 프로젝트에 사용하는 것은 허가함.
//            - 이 모델을 바탕으로 코드를 수정하는 것은 제작자에게 통보해주는
//              조건 하에서 허가함(소스관리적 차원)
//            - TLabel에서 상속.
//  URL       : http://myhome.shinbiro.com/~opencomm
//  Email     : opencomm@shinbiro.com
//
{******************************************************************************}
//  B U G     F I X E D    &    M O D I F I E D      L I S T
//==============================================================================
//  1. 2000.7.17  by 김순렬 (ksl@namyangmetals.co.kr)
//     1) FANumEdit.pas에서 2000.7.17까지의 문제 해결 반영
//------------------------------------------------------------------------------
//  2. 2000.7.23  by 황광일 (opencomm@shinbiro.com)
//     1) TFANumLabel은 Label이므로 입력포커스가 없으므로...
//        ThisToMemMan 프로시져는 의미가 없어서 삭제...
//     2) Alignment 속성이 Create에서  taRightJustify 로 규정됨에 따라
//        taLeft, taCenter 속성이 런타임에서 무효화 됨. => 수정.
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FAMemMan_pjh;

type
  TFANumLabel = class(TLabel)
  private
    { Private declarations }
    FDigits   : byte;
    FFormatString : string;
    FMin,FMax : extended;
    fdec      : char;
    Fertext   : string;

    FFAMemMan : TpjhFAMemMan;
    FPlcMax   : SmallInt;
    FAnalogMin: Single;
    FAnalogMax: Single;
    FMemConvert : boolean;     // PLC에서 가져와서 지정된 메모리에 보관시 Convert할지 여부
    FMemIndex : integer;       // PLC에서 가져온 데이타를 보관할 메모리 위치
    FMemName  : TMemName;      //                  "                    종류
    FDestMemConvert : boolean; // 지정된 메모리에있는값을 다른 메모리에 복사시 Convert할지 여부
    FDestMemIndex: Integer;    // FMemName,FMemIndex로 복사가 되어질곳의 메모리 위치
    FDestMemName : TMemName;   //                  "                            종류

    procedure SetAnalogMax(A: single);
    procedure SetAnalogMin(A: single);
    procedure SetMemConvert(A: boolean);
    procedure SetMemName(A: TMemName);
    procedure SetDestMemConvert(A: boolean);
    procedure SetDestMemName(A: TMemName);
  protected
    { Protected declarations }
    function GetFormat: string;
    procedure SetFormat(const Value: string);
    procedure setvalue(Newvalue : extended);
    procedure setmin(Newvalue : extended);
    procedure setmax(Newvalue : extended);
    procedure setdigits(Newvalue : byte);
    function getvalue : extended;
    Function StrToNumber(s:String) : Extended;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure SetFAMemMan(mm:TpjhFAMemMan);
    procedure MemManValueToThis;
  public
    { Public declarations }
    constructor Create (AOwner : TComponent);override;
    destructor Destroy; override;
    procedure ApplyUpdate;
    function SafeCallException(ExceptObject: TObject;
      ExceptAddr: Pointer): HResult; override;
  published
    { Published declarations }
    property Alignment;
    property Digits : byte read FDigits write setDigits;
    property Value : extended read getvalue write setValue;
    property Min : extended read Fmin write setMin;
    property Max : extended read Fmax write setmax;
    property ErrorMessage :string read fertext write fertext;
    property FormatStr : string read GetFormat write SetFormat;

    property FAMemoryManager: TpjhFAMemMan read FFAMemMan write SetFAMemMan;
    property FAMemName: TMemName read FMemName write SetMemName;
    property FAMemIndex: Integer read FMemIndex write FMemIndex;
    property FAMemConvert: boolean read FMemConvert write SetMemConvert;
    property FADestMemName: TMemName read FDestMemName write SetDestMemName;
    property FADestMemIndex: Integer read FDestMemIndex write FDestMemIndex;
    property FADestMemConvert: boolean read FDestMemConvert write SetDestMemConvert;
    property FAPLCAnalogRangeMax: smallint read FPlcMax write FPlcMax default 2000;
    property FAAnalogMax: single read FAnalogMax write SetAnalogMax;
    property FAAnalogMin: single read FAnalogMin write SetAnalogMin;
  end;

const
    notext       = '[No Text]';


implementation


constructor TFANumLabel.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFormatString := '%5.1n';
  Font.Name := '굴림';
  Font.Size := 9;
  Font.Style := [fsBold];
  AutoSize := False;
  Width := 100;
  fdec := decimalseparator;
  FDigits := 1;
  fmin := -999999999.0;
  fmax :=  999999999.0;
  Fertext := notext;
  FPlcMax := 2000;
  FAAnalogMax := 100;
  setvalue(0.0);
end;

destructor TFANumLabel.Destroy;
begin
  if FFAMemMan <> nil then
    FFAMemMan.KickOutNewsMember(Self);
  inherited Destroy;
end;

procedure TFANumLabel.setvalue(Newvalue : extended);
begin
  if newvalue > fmax then
  begin
    if fertext <> notext then
      showmessage(fertext);
    newvalue := fmax;
  end;
  if newvalue < fmin then
  begin
    if fertext <> notext then
      showmessage(fertext);
    newvalue := fmin;
  end;
  Caption := floattostrf(newvalue,ffNumber,18,fdigits);

end;

procedure TFANumLabel.SetFormat(const Value: string);
begin
  FFormatString := Value;
end;

function TFANumLabel.GetFormat: string;
begin
  result := FFormatString;
end;

function TFANumLabel.getvalue : extended;
var
  ts : string;
begin
  ts := Caption;
  if (ts = '-') or (ts = fdec) or (ts = '') then  ts := '0';
  try
    result := strtoNumber(ts);
  except
    result := fmin;
  end;

  if result < fmin then  result := fmin;
  if result > fmax then  result := fmax;
end;

procedure TFANumLabel.setdigits;
begin
  if fdigits <> newValue then
  begin
    if newvalue > 18 then newvalue := 18;
    fdigits := newvalue;
    setvalue(getvalue);
  end;
end;

procedure TFANumLabel.setmin;
begin
  if fmin <> newValue then
  begin
    if fmin > fmax then
    begin
      showmessage('Min-Value has to be less than or equal to Max-Value !');
      newvalue := fmax;
    end;
    fmin := newvalue;
    setvalue(getvalue);
  end;
end;

procedure TFANumLabel.setmax;
begin
  if fmax <> newValue then
  begin
    if fmin > fmax then
    begin
      showmessage('Max-Value has to be greater than or equal to Min-Value !');
      newvalue := fmin;
    end;
    fmax := newvalue;
    setvalue(getvalue);
  end;
end;

Function TFANumLabel.StrToNumber(s:String) : Extended;
var
  r : Extended;
  i : integer;
  v : string;
begin
  v := '';
  for i := 1 to Length(s) do
  begin
    if s[i] in ['-','.','0'..'9'] then
       v := v + s[i]
    else if (s[i]<>',') and (s[i]<>' ') then
         begin
           StrToNumber := 0;
           exit;
         end;
  end;

  Val(v,r,i);

  if i = 0 then
    StrToNumber := r
  else
    StrToNumber := 0;
end;

//****************************************************************************//

procedure TFANumLabel.SetAnalogMax(A: Single);
begin
  if A <> FAnalogMax then
  begin
    FAnalogMax := A;
//    FMax := Trunc(A);
  end;
end;

procedure TFANumLabel.SetAnalogMin(A: Single);
begin
  if A <> FAnalogMin then
  begin
    FAnalogMin := A;
//    FMin := Trunc(A);
  end;
end;

procedure TFANumLabel.SetMemConvert(A: boolean);
begin
  if A <> FMemConvert then
  begin
    FMemConvert := A;
  end;
end;

procedure TFANumLabel.SetMemName(A : TMemName);
begin
  if FMemName <> A then
  begin
    FMemName := A;
    SetDestMemName( FDestMemName );
  end;
end;

procedure TFANumLabel.SetDestMemConvert(A: boolean);
begin
  if A <> FDestMemConvert then
  begin
    FDestMemConvert := A;
    if not FDestMemConvert then
      //FDestMemName := NONE
    else
      if FDestMemName <> NONE then
        SetDestMemName( FDestMemName );
  end;
end;

procedure TFANumLabel.SetDestMemName(A : TMemName);
begin
  FDestMemName := NONE;  // 초기화 (SetDestMemConvert에서 호출때 적용)
  // DestMemConvert 가 True이면
  if FDestMemConvert then
  begin
    if (FMemName = A_MEM) or (FMemName = F_MEM) then
      if (A = R_MEM) or (A = W_MEM) then
        FDestMemName := A
      else
        ShowMessage('DestMemConvert가 True일때 FAMemName이 A,F_MEM이면'+chr(13)+chr(13)+'FADestMemName는 R,W_MEM으로 지정되어야 함');
    if (FMemName = R_MEM) or (FMemName = W_MEM) then
      if (A = A_MEM) or (A = F_MEM) then
        FDestMemName := A
      else
        ShowMessage('DestMemConvert가 True일때 FAMemName이 R,W_MEM이면'+chr(13)+chr(13)+'FADestMemName는 A,F_MEM으로 지정되어야 함');
  end
  else
    FDestMemName := A;
end;

//------------------------------------------------------------------------------
// 상위 TFAMemoryManager 와 통신을 위한 프로시져들
//------------------------------------------------------------------------------

// TpjhFAMemMan VCL을 등록할 때 ....
procedure TFANumLabel.SeTFAMemMan(mm:TpjhFAMemMan);
begin
  FFAMemMan := mm;
end;

// The Notification method is called automatically when the component specified
// by AComponent is about to be inserted or removed. --> online help.
procedure TFANumLabel.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  // 참조된 TFAMemMan이 제거 되었음을 통지 받았다면..
  if (Operation=opRemove) and (AComponent=FFAMemMan) then
    FFAMemMan := nil;
end;

procedure TFANumLabel.Loaded;
begin
  inherited Loaded;
  // TFAMemMan로부터 메모리 변경시 통보받기 위하여 이 컴포넌트를 TFAMemMan에 등록한다.
  if FFAMemMan<>nil then
    FFAMemMan.RegisterNewsMember(Self, FAMemName, FAMemIndex);
end;

// TFAMemMan의 값을 이 컴포넌트에 대입...
procedure TFANumLabel.MemManValueToThis;
var
  v: extended;
begin
  if (csDesigning in ComponentState) then
    Exit;

  v := 0; //초기화..
  // TFAMemMan이 본 컴포넌트에 지정되었다면..
  if FFAMemMan<>nil then
  begin
    // TFAMemMan의 값을 가져와 Casting한다..
    if FMemConvert then
    begin
      case FMemName of
        {PLC의 아날로그값(word) --> 엔지니어링값(double)}
        R_MEM : v := (FFAMemMan.GetR(FMemIndex) * (FAnalogMax-FAnalogMin) / FPlcMax) + FAnalogMin;
        W_MEM : v := (FFAMemMan.GetW(FMemIndex) * (FAnalogMax-FAnalogMin) / FPlcMax) + FAnalogMin;
        {엔지니어링값(double) --> PLC의 아날로그값(word)}
        A_MEM : v := trunc(((FFAMemMan.GetA(FMemIndex)-FAnalogMin) * FPlcMax) / (FAnalogMax - FAnalogMin));
        F_MEM : v := trunc(((FFAMemMan.GetF(FMemIndex)-FAnalogMin) * FPlcMax) / (FAnalogMax - FAnalogMin));
      end;
    end
    else
    begin
      case FMemName of
        R_MEM : v := FFAMemMan.GetR(FMemIndex);
        W_MEM : v := FFAMemMan.GetW(FMemIndex);
        A_MEM : v := FFAMemMan.GetA(FMemIndex);
        F_MEM : v := FFAMemMan.GetF(FMemIndex);
      end;
    end;
    // 값을 VCL에 반영.....
    Value := v;
  end;
end;


// 이 함수는 TFAMemMan과의 통신을 위하여 임의로 조작되었음..
// 사용에 주의하기 바람..
function TFANumLabel.SafeCallException(ExceptObject: TObject;
      ExceptAddr: Pointer): HResult;
var
  bFromMemMan: boolean;
begin
  // TpjhFAMemMan 에서 호출된 것인지를 확인하는 과정..
  bFromMemMan := False;

  if FFAMemMan<>nil then
  begin
    if (FFAMemMan = ExceptObject) and (ExceptAddr=nil) then
      bFromMemMan := True;
  end;

  // TFAMemMan에서 호출된 것이 확실하다면..
  if bFromMemMan then
  begin
    Result := 0;
    ApplyUpdate; // 강제 갱신 지시...
  end
  else
  begin
    // 원래의 용도로 호출된것이라면... 조상 함수를 Call..
    Result := inherited SafeCallException(ExceptObject,ExceptAddr);
  end;
end;

// 프로그램 상에서 혹은 TpjhFAMemMan 에 의해서 호출된다..
procedure TFANumLabel.ApplyUpdate;
begin
  // 메모리 변경값을 반영..
  MemManValueToThis;
end;

end.
