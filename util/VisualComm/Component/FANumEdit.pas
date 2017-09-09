unit FANumEdit;

{**************************OpenFAVCL PROJECT***********************************}
//  VCL NAME  : F.A NumberEdit(TFANumberEdit)
//  Copyright : Hwang Kwang IL(c) by 1998.2 ~ 2000.7
//  NOTE      :
//            - 이 모델을 이용하여 상업용 소프트웨어를 제작하고 판매하는 방식으로
//              이윤을 획득하는 행위에 대해서는 일체 금함.
//            - 이 모델을 이용하여 프로젝트에 사용하는 것은 허가함.
//            - 이 모델을 바탕으로 코드를 수정하는 것은 제작자에게 통보해주는
//              조건 하에서 허가함(소스관리적 차원)
//            - TNumberEdit 에서 변경한 것임(델마당 공모전)
//  URL       : http://myhome.shinbiro.com/~opencomm
//  Email     : opencomm@shinbiro.com
//
{******************************************************************************}
//  B U G     F I X E D    &    M O D I F I E D      L I S T
//==============================================================================
//  1. 2000.7.10  by 김순렬 (ksl@namyangmetals.co.kr)
//------------------------------------------------------------------------------
//     1) 최소값이 0 이상일 때 오동작 FIXED.
//------------------------------------------------------------------------------
//        변경전:   v := (FFAMemMan.GetR(FMemIndex) * abs(FAnalogMax-FAnalogMin) / FPlcMax) - (abs(0 - FAnalogMin))
//        변경후:   v := (FFAMemMan.GetR(FMemIndex) * (FAnalogMax-FAnalogMin) / FPlcMax) + FAnalogMin
//------------------------------------------------------------------------------
//        변경전:
//                  R_MEM : FFAMemMan.SetR(FDestMemIndex, (Trunc(v+abs(0.-FAnalogMin)) * FPlcMax) div Trunc((FAnalogMax - FAnalogMin)) );
//                  W_MEM : FFAMemMan.SetW(FDestMemIndex, (Trunc(v+abs(0.-FAnalogMin)) * FPlcMax) div Trunc((FAnalogMax - FAnalogMin)) );
//                  A_MEM : FFAMemMan.SetA(FDestMemIndex, (v * abs(FAnalogMax-FAnalogMin) / FPlcMax) - ( abs(0 - FAnalogMin)) );
//                  F_MEM : FFAMemMan.SetF(FDestMemIndex, (v * abs(FAnalogMax-FAnalogMin) / FPlcMax) - ( abs(0 - FAnalogMin)) );
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//                  R_MEM : FFAMemMan.SetR(FDestMemIndex, (Trunc(v+abs(0.-FAnalogMin)) * FPlcMax) div Trunc((FAnalogMax - FAnalogMin)) );
//                                                                                                ~~~
//                                                                                                이것 때문에 정확한 값이 나오질 않음
//------------------------------------------------------------------------------
//        변경후:
//                  R_MEM : FFAMemMan.SetR( FDestMemIndex, trunc(((v-FAnalogMin) * FPlcMax) / (FAnalogMax - FAnalogMin)) );
//                  W_MEM : FFAMemMan.SetW( FDestMemIndex, trunc(((v-FAnalogMin) * FPlcMax) / (FAnalogMax - FAnalogMin)) );
//                  A_MEM : FFAMemMan.SetA( FDestMemIndex, (v * (FAnalogMax-FAnalogMin) / FPlcMax) + FAnalogMin );
//                  F_MEM : FFAMemMan.SetF( FDestMemIndex, (v * (FAnalogMax-FAnalogMin) / FPlcMax) + FAnalogMin );
//==============================================================================
//  2. 2000.7.17  by 김순렬 (ksl@namyangmetals.co.kr)
//------------------------------------------------------------------------------
//     1) 데이타 이동(FADestMemName) 기능 사용시 보내는값을 Value값이 아닌, Memory값을 사용하도록 ThisToMemManValue함수에 기능추가
//        수정전에는 PLC의 데이타를 Convert해서 가져온 경우 그 값을 다른 메모리에 보낼때 또 Convert하면 엉둥한 값이된다
//        Convert하지 않고 보내면 되지만 원래의 PLC에서 가져온 값을 다른 메모리로 자동 이동 시킬수 없다
//        Memory값을 사용하도록 수정하면 그냥 보내면 PLC값을 보내고 Convert하면 Convert된 값을 보낼수 있다
//     2) SetDestMemConvert로 Convert여부(True,False) 지정시 무조건 FDestMemName := NONE 으로 만든것을 FDestMemName을 그대로 두도록 수정
//     3) Memory Type선택할때 올바르게 지정 가능토록 수정 (SetDestMemConvert, SetMemName, SetDestMemName)
//     4) SetMemName - 3)번의 기능을 위해서 추가한 함수
//     5) fmin, fmax값을 최소값 및 최대값을 가지도록 수정
//        FAnalogMax,FAnalogMin값 변경시 그 값이 FMax,FMin에 반영하지 않도록 수정
//        수정전에는 원해서 지정한 FMax,FMin값이 프로그램 실행때 FAAnalogMax,FAAnalogMin값으로 바꿔져 버린다
//     6) 이름변경 : SetDestMem -> SetDestMemName , SetMemMan -> SetFAMemMan
//                   ...SrcConvert -> ...Convert, ...Convert -> ...DestMemConvert
//     7) Convert의 역활 확정
//        R_MEM, W_MEM에는 PLC의 값(word)을 보관,  A_MEM, F_MEM에는 엔지니어링값(double)을 보관
//        따라서, Convert는 Convert대상 메모리가 어떤것인가에 따라 PLC값으로 또는 엔지니어링값으로 변환된다
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FAMemMan_pjh, SyncObjs;

type
  TFANumberEdit = class(TEdit)
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

    Sect : TCriticalSection;

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
    procedure DoExit; override;
    procedure DoEnter; override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;

    procedure Change; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure SetFAMemMan(mm:TpjhFAMemMan);
    procedure MemManValueToThis;
    procedure ThisToMemManValue;
  public
    { Public declarations }
    constructor Create (AOwner : TComponent);override;
    destructor Destroy; override;
    procedure Update; override;
    procedure ApplyUpdate;
    function SafeCallException(ExceptObject: TObject;
      ExceptAddr: Pointer): HResult; override;
  published
    { Published declarations }
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


constructor TFANumberEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Sect := TCriticalSection.Create;
  FFormatString := '%5.1n';
  fdec := decimalseparator;
  fdigits := 0;
  fmin := -999999999.0;
  fmax := 999999999.0;
  fertext := notext;
  FPlcMax := 2000;
  FAAnalogMax := 100;
  Tabstop := False;
  setvalue(0.0);
end;

destructor TFANumberEdit.Destroy;
begin
  if FFAMemMan <> nil then
    FFAMemMan.KickOutNewsMember(Self);
  Sect.Free;
  inherited Destroy;
end;

procedure TFANumberEdit.setvalue(Newvalue : extended);
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
  Text := floattostrf(newvalue,ffNumber,18,fdigits);
end;

procedure TFANumberEdit.SetFormat(const Value: string);
begin
  FFormatString := Value;
end;

function TFANumberEdit.GetFormat: string;
begin
  result := FFormatString;
end;

function TFANumberEdit.getvalue : extended;
var
  ts : string;
begin
  ts := text;
  if (ts = '-') or (ts = fdec) or (ts = '') then  ts := '0';
  try
    result := strtoNumber(ts);
  except
    result := fmin;
  end;

  if result < fmin then  result := fmin;
  if result > fmax then  result := fmax;
end;

procedure TFANumberEdit.setdigits;
begin
  if fdigits <> newValue then
  begin
    if newvalue > 18 then newvalue := 18;
    fdigits := newvalue;
    setvalue(getvalue);
  end;
end;

procedure TFANumberEdit.setmin;
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

procedure TFANumberEdit.setmax;
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

procedure TFANumberEdit.KeyPress;
var
  ts     : string;
  result : extended;
  ThisForm : TCustomForm;
begin
  if Key = #13 then                  // [Enter] Key 경우 다음항목으로
  begin
    ThisForm := GetParentForm( Self );
    if not (ThisForm = nil ) then
       SendMessage(ThisForm.Handle, WM_NEXTDLGCTL, 0, 0);
    Key := #0;
  end;

  if key < #32 then
  begin
    inherited;
    exit;
  end;

  ts := copy(text,1,selstart)+copy(text,selstart+sellength+1,500);

  if (key <'0') or (key > '9') then
     if (key <> fdec) and (key <> '-') then
     begin
       inherited;
       key := #0;
       exit;
     end;
  if key = fdec then
     if pos(fdec,ts) <> 0 then
     begin
       inherited;
       key := #0;
       exit;
     end;
  if key = '-' then
     if pos('-',ts) <> 0 then
     begin
       inherited;
       key := #0;
       exit;
     end;
  if key = '-' then
     if fmin >= 0 then
     begin
       inherited;
       key := #0;
       exit;
     end;
  if key = fdec then
     if fdigits = 0 then
     begin
       inherited;
       key := #0;
       exit;
     end;

  ts := copy(text,1,selstart)+key+copy(text,selstart+sellength+1,500);

  if key > #32 then if pos(fdec,ts)<> 0 then
  begin
    if length(ts)-pos(fdec,ts) > fdigits then
    begin
      inherited;
      key := #0;
      exit;
    end;
  end;

  if key = '-' then
     if pos('-',ts) <> 1 then
     begin
       inherited;
       key := #0;
       exit;
     end;

  if ts ='' then
  begin
    inherited;key := #0;
    text := floattostrf(fmin,ffNumber,18,fdigits);selectall;
    // 변경내용을 TLinkMem에 반영...
    ThisToMemManValue;
    exit;
  end;

  if ts = '-' then
  begin
    inherited;key:=#0;
    text := '-0';selstart := 1;sellength:=1;
    ThisToMemManValue;
    exit;
  end;

  if ts = fdec then
  begin
    inherited;key:=#0;
    text := '0'+fdec+'0';
    selstart :=2;
    sellength:=1;
    ThisToMemManValue;
    exit;
  end;

  try
     result := strtoNumber(ts);
  except
     if fertext <> notext then showmessage(fertext);
     inherited;
     key := #0;
     text := floattostrf(fmin,ffNumber,18,fdigits);
     selectall;
     ThisToMemManValue;
     exit;
  end;

  if result < fmin then
  begin
    inherited;
    key := #0;
    if fertext <> notext then showmessage(fertext);
    text := floattostrf(fmin,ffNumber,18,fdigits);
    selectall;
    ThisToMemManValue;
    exit;
  end;

  if result > fmax then
  begin
    inherited;key := #0;
    if fertext <> notext then showmessage(fertext);
    text := floattostrf(fmax,ffNumber,18,fdigits);
    selectall;
    ThisToMemManValue;
    exit;
  end;
  inherited;
end;

Function TFANumberEdit.StrToNumber(s:String) : Extended;
var
  r : Extended;
  i : integer;
  v : string;
Begin
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
End;

procedure TFANumberEdit.DoExit;
begin
  Text := floattostrf(value,ffNumber,18,fdigits);
  inherited;
  ThisToMemManValue;
end;

procedure TFANumberEdit.Change;
begin
  inherited;
  ThisToMemManValue;
end;

procedure TFANumberEdit.Update;
begin
  inherited;
  ThisToMemManValue;
end;

procedure TFANumberEdit.DoEnter;
begin
  Text := FloatToStrF(value,ffFixed,18,fdigits);
  SelStart  := 0;
  SelLength := Length(Text);
  inherited;
end;

procedure TFANumberEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or (ES_RIGHT or ES_MULTILINE);
end;

//****************************************************************************//

procedure TFANumberEdit.SetAnalogMax(A: Single);
begin
  if A <> FAnalogMax then
  begin
    FAnalogMax := A;
//    FMax := Trunc(A);
  end;
end;

procedure TFANumberEdit.SetAnalogMin(A: Single);
begin
  if A <> FAnalogMin then
  begin
    FAnalogMin := A;
//    FMin := Trunc(A);
  end;
end;

procedure TFANumberEdit.SetMemConvert(A: boolean);
begin
  if A <> FMemConvert then
  begin
    FMemConvert := A;
  end;
end;

procedure TFANumberEdit.SetMemName(A : TMemName);
begin
  if FMemName <> A then
  begin
    FMemName := A;
    SetDestMemName( FDestMemName );
  end;
end;

procedure TFANumberEdit.SetDestMemConvert(A: boolean);
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

procedure TFANumberEdit.SetDestMemName(A : TMemName);
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
procedure TFANumberEdit.SetFAMemMan(mm:TpjhFAMemMan);
begin
  FFAMemMan := mm;
end;

// The Notification method is called automatically when the component specified
// by AComponent is about to be inserted or removed. --> online help.
procedure TFANumberEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  // 참조된 TFAMemMan이 제거 되었음을 통지 받았다면..
  if (Operation=opRemove) and (AComponent=FFAMemMan) then
    FFAMemMan := nil;
end;

procedure TFANumberEdit.Loaded;
begin
  inherited Loaded;
  // TFAMemMan로부터 메모리 변경시 통보받기 위하여 이 컴포넌트를 TFAMemMan에 등록한다.
  if FFAMemMan<>nil then
    FFAMemMan.RegisterNewsMember(Self, FAMemName, FAMemIndex);
end;

// TFAMemMan의 값을 이 컴포넌트에 대입...
procedure TFANumberEdit.MemManValueToThis;
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

// 이 컴포넌트의 값을 TFAMemMan에 반영시킨다.
procedure TFANumberEdit.ThisToMemManValue;
var
  v : extended;
begin
  if (csDesigning in ComponentState) then
    Exit;

  // TFAMemMan이 본 컴포넌트에 지정되었다면..
  if FFAMemMan<>nil then
  begin
    // 데이타 이동(FADestMemName) 기능 사용시 보내는값을 Value값이 아닌, Memory값을 사용
    v := 0;
    Sect.Enter;
    case FMemName of
      R_MEM : v := FFAMemMan.GetR(FMemIndex);
      W_MEM : v := FFAMemMan.GetW(FMemIndex);
      A_MEM : v := FFAMemMan.GetA(FMemIndex);
      F_MEM : v := FFAMemMan.GetF(FMemIndex);
    end;
    if FDestMemConvert then
    begin
      case FDestMemName of
        {엔지니어링값(double) --> PLC의 아날로그값(word)}
        R_MEM : FFAMemMan.SetR( FDestMemIndex, trunc(((v-FAnalogMin) * FPlcMax) / (FAnalogMax - FAnalogMin)) );
        W_MEM : FFAMemMan.SetW( FDestMemIndex, trunc(((v-FAnalogMin) * FPlcMax) / (FAnalogMax - FAnalogMin)) );
        {PLC의 아날로그값(word) --> 엔지니어링값(double)}
        A_MEM : FFAMemMan.SetA( FDestMemIndex, (v * (FAnalogMax-FAnalogMin) / FPlcMax) + FAnalogMin );
        F_MEM : FFAMemMan.SetF( FDestMemIndex, (v * (FAnalogMax-FAnalogMin) / FPlcMax) + FAnalogMin );
      end;
    end
    else
    begin
      case FDestMemName of
        R_MEM : FFAMemMan.SetR( FDestMemIndex, trunc(v) );
        W_MEM : FFAMemMan.SetW( FDestMemIndex, trunc(v) );
        A_MEM : FFAMemMan.SetA( FDestMemIndex, v );
        F_MEM : FFAMemMan.SetF( FDestMemIndex, v );
      end;
    end;
    Sect.Leave;
  end;
end;

// 이 함수는 TFAMemMan과의 통신을 위하여 임의로 조작되었음..
// 사용에 주의하기 바람..
function TFANumberEdit.SafeCallException(ExceptObject: TObject;
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
procedure TFANumberEdit.ApplyUpdate;
begin
  // 메모리 변경값을 반영..
  Sect.Enter;
  MemManValueToThis;
  Sect.Leave;
end;

end.
