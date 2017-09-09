unit FAMemMan_pjh;

{******************************************************************************}
//  VCL NAME  : F.A Memory Manager(TFAMemMan)
//  Copyright : Hwang Kwang IL(c) by 1998.2 ~ 2000.7
//  NOTE      :
//            - 이 모델을 이용하여 상업용 소프트웨어를 제작하고 판매하는 방식으로
//              이윤을 획득하는 행위에 대해서는 일체 금함.
//            - 이 모델을 이용하여 프로젝트에 사용하는 것은 허가함.
//            - 이 모델을 바탕으로 코드를 수정하는 것은 제작자에게 통보해주는
//              조건 하에서 허가함(소스관리적 차원)
//  URL       : http://myhome.shinbiro.com/~opencomm
//  Email     : opencomm@shinbiro.com
{******************************************************************************}
//  B U G     F I X E D    &    M O D I F I E D      L I S T
//==============================================================================
//  1. 2000.7.10  by 김순렬 (ksl@namyangmetals.co.kr)
//------------------------------------------------------------------------------
//     1) 메모리 값 변경 이벤트 추가.(OnRMemChange/OnWMemChange/OnAMemChange/OnFMemChange)
//     2) procedure TFAMemMan.ApplyUpdate 함수 최적화.
//==============================================================================
//  2. 2000.7.11  by 김순렬 (ksl@namyangmetals.co.kr)
//------------------------------------------------------------------------------
//     1) A 와 F 메모리에 데이타 보관시 정확한 값을 보관토록 TYPE을 변경
//        예) 변경전 : A : TSingleArray;   -->   A : TDoubleArray;
{******************************************************************************}
//==============================================================================
//  3. 2001.7.22  by 황광일 (opencomm@shinbiro.com)
//------------------------------------------------------------------------------
//     1) TDoubleArray와 TSmallIntArray는 MxArrays.dcu의 클래스를 이용한 것이어서
//        Standard, Pro버전에서는 사용불가하였음.
//     2) WindowsAPI Memory Mapped File을 사용하는 것으로 변경.
//     3) TFAMemMan을 사용하는 프로그램들은 TFAMemMan의 name 만 같게 지정하면
//        외부프로그램에서 동일한 메모리와 값을 쓰거나 읽어올 수 있게 되었고
//        같은 메모리를 억세스할 때 가끔 일어나는 VXD 프로그램 충돌을 방지할 수
//        있게 되었음.
//        기존 TSmallIntArray 와 같이 Heap을 사용하여 메모리를 할당하였을 때는
//        TCriticalSection 처리를 잘해야만 치명적인 VXD 에러를 모면할 수 있다는
//        것을 몇번의 실제 프로젝트에서 알 수 있게 되었음.
//        이는 멀티 쓰레드에서 동일 변수에 대해 동일 시간에 억세스 할 경우
//        발생할 수 있는 치명적인 모든 에러에 대해 근본적으로 대처하고자 함.
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Syncobjs, Buttons, pjhClasses;

type
  TMemName = (NONE, A_MEM, F_MEM, R_MEM, W_MEM);

  TAMemChangeEvent = procedure(Sender: TObject; Index: Smallint; preValue, Value: Double) of object;
  TFMemChangeEvent = procedure(Sender: TObject; Index: Smallint; preValue, Value: Double) of object;
  TRMemChangeEvent = procedure(Sender: TObject; Index, preValue, Value: Smallint) of object;
  TWMemChangeEvent = procedure(Sender: TObject; Index, preValue, Value: Smallint) of object;

  TpjhFAMemMan = class;
{  TMyWatchThread = class;
 }
  TNewsMember = class
    FComponent: TComponent;
    FMemName: TMemName;
    FMemIndex: Smallint;
    constructor Create;
    procedure ApplyUpdate(sm: TpjhFAMemMan);
  end;

  TpjhFAMemMan = class(TWrapperControl)//TSpeedButton)
  private
{    FWatchThread: TMyWatchThread;
    FServer: Boolean;
 }
    { Private declarations }
    FOnAMemChange: TAMemChangeEvent;
    FOnFMemChange: TFMemChangeEvent;
    FOnRMemChange: TRMemChangeEvent;
    FOnWMemChange: TWMemChangeEvent;

    FNewsMembers: TList;                //연결된 컴포넌트 목록...

    FAMemoryCount: SmallInt;
    FFMemoryCount: SmallInt;
    FRMemoryCount: SmallInt;
    FWMemoryCount: SmallInt;

    //사용메모리...
    A: THandle;
    F: THandle;
    R: THandle;
    W: THandle;
    lpDataA: LPSTR;
    lpDataF: LPSTR;
    lpDataR: LPSTR;
    lpDataW: LPSTR;
    Sect: TCriticalSection;

{    procedure SetServer(Value: Boolean);}

    procedure SetAMemoryCount(Cnt: SmallInt);
    procedure SetFMemoryCount(Cnt: SmallInt);
    procedure SetRMemoryCount(Cnt: SmallInt);
    procedure SetWMemoryCount(Cnt: SmallInt);
  protected
    { Protected declarations }
    procedure loaded; override;
    procedure DestroyNewsMembers;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    //외부 메쏘드
    function GetA(Index: SmallInt): Double;
    function GetF(Index: SmallInt): Double;
    function GetR(Index: SmallInt): SmallInt;
    function GetW(Index: SmallInt): SmallInt;

    procedure SetA(Index: SmallInt; Value: Double);
    procedure SetF(Index: SmallInt; Value: Double);
    procedure SetR(Index: SmallInt; Value: SmallInt);
    procedure SetW(Index: SmallInt; Value: SmallInt);

    procedure RegisterNewsMember(AComponent: TComponent; AMemName: TMemName; AMemIndex: Smallint);
    procedure KickOutNewsMember(AComponent: TComponent);
    procedure ApplyUpdate(AMemName: TMemName; AMemIndex: Smallint);
  published
    { Published declarations }
{    property IsServer: Boolean read FServer write SetServer;}

    property FA_A_Count: SmallInt read FAMemoryCount write SetAMemoryCount default 100;
    property FA_F_Count: SmallInt read FFMemoryCount write SetFMemoryCount default 100;
    property FA_R_Count: SmallInt read FRMemoryCount write SetRMemoryCount default 100;
    property FA_W_Count: SmallInt read FWMemoryCount write SetWMemoryCount default 100;

    property OnAMemChange: TAMemChangeEvent read FOnAMemChange write FOnAMemChange;
    property OnFMemChange: TFMemChangeEvent read FOnFMemChange write FOnFMemChange;
    property OnRMemChange: TRMemChangeEvent read FOnRMemChange write FOnRMemChange;
    property OnWMemChange: TWMemChangeEvent read FOnWMemChange write FOnWMemChange;
  end;

{  TMyWatchThread = class(TThread)
  protected
    FWatchEvent: TEvent;
    FOwner: TpjhFAMemMan;

    procedure Execute; override;
  public
    FCurrentMemName: TMemName;
    FCurrentMemIndex: SmallInt;

    constructor Create(AOwner: TpjhFAMemMan);
    destructor Destroy; override;
  end;
}
implementation

constructor TpjhFAMemMan.Create(AOwner: TComponent);
begin
  inherited Create(AOWner);

  Visible := False;
  
  FNewsMembers := TList.Create;
  FAMemoryCount := 1000;
  FFMemoryCount := 1000;
  FRMemoryCount := 1000;
  FWMemoryCount := 1000;
  Sect := TCriticalSection.Create;
  //Self.Glyph.LoadFromResourceName(HInstance, PChar(String(ClassName)));
end;

destructor TpjhFAMemMan.Destroy;
begin
  Sect.Free;
  UnMapViewOfFile(lpDataA);
  UnMapViewOfFile(lpDataF);
  UnMapViewOfFile(lpDataR);
  UnMapViewOfFile(lpDataW);

  CloseHandle(A);
  CloseHandle(F);
  CloseHandle(R);
  CloseHandle(W);

  if Assigned(FNewsMembers) then
    DestroyNewsMembers;
  FNewsMembers.Free;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TpjhFAMemMan.loaded;
begin
  try
    A :=
      CreateFileMapping(
      $FFFFFFFF,                        // 파일 연동 안함.
      nil,                              // 보안문제 신경 안 씀.
      PAGE_READWRITE,                   // 읽고 쓸 것임.
      0,                                // 크기 상위 DWORD
      (FA_A_Count - 1) * SizeOf(Double), // 크기 하위 DWORD
      PChar(Name + '_A')                // 메맵 파일의 이름
      );

    if (A = 0) and (GetLastError() = ERROR_ALREADY_EXISTS) then
      A := OpenFileMapping(PAGE_READWRITE, True, PChar(Name + '_A'));

    F :=
      CreateFileMapping(
      $FFFFFFFF,                        // 파일 연동 안함.
      nil,                              // 보안문제 신경 안 씀.
      PAGE_READWRITE,                   // 읽고 쓸 것임.
      0,                                // 크기 상위 DWORD
      (FA_F_Count - 1) * SizeOf(Double), // 크기 하위 DWORD
      PChar(Name + '_F')                // 메맵 파일의 이름
      );

    if (A = 0) and (GetLastError() = ERROR_ALREADY_EXISTS) then
      A := OpenFileMapping(PAGE_READWRITE, True, PChar(Name + '_F'));

    R :=
      CreateFileMapping(
      $FFFFFFFF,                        // 파일 연동 안함.
      nil,                              // 보안문제 신경 안 씀.
      PAGE_READWRITE,                   // 읽고 쓸 것임.
      0,                                // 크기 상위 DWORD
      (FA_R_Count - 1) * SizeOf(SmallInt), // 크기 하위 DWORD
      PChar(Name + '_R')                // 메맵 파일의 이름
      );

    if (A = 0) and (GetLastError() = ERROR_ALREADY_EXISTS) then
      A := OpenFileMapping(PAGE_READWRITE, True, PChar(Name + '_R'));

    W :=
      CreateFileMapping(
      $FFFFFFFF,                        // 파일 연동 안함.
      nil,                              // 보안문제 신경 안 씀.
      PAGE_READWRITE,                   // 읽고 쓸 것임.
      0,                                // 크기 상위 DWORD
      (FA_R_Count - 1) * SizeOf(SmallInt), // 크기 하위 DWORD
      PChar(Name + '_W')                // 메맵 파일의 이름
      );

    if (A = 0) and (GetLastError() = ERROR_ALREADY_EXISTS) then
      A := OpenFileMapping(PAGE_READWRITE, True, PChar(Name + '_W'));

    lpDataA := MapViewOfFile(A, FILE_MAP_WRITE, 0, 0, 0);
    lpDataF := MapViewOfFile(F, FILE_MAP_WRITE, 0, 0, 0);
    lpDataR := MapViewOfFile(R, FILE_MAP_WRITE, 0, 0, 0);
    lpDataW := MapViewOfFile(W, FILE_MAP_WRITE, 0, 0, 0);

  except
    ShowMessage('메모리 할당 에러');
  end;
end;


procedure TpjhFAMemMan.SetAMemoryCount(Cnt: SmallInt);
begin
  if FAMemoryCount <> Cnt then
    FAMemoryCount := Cnt;
end;

procedure TpjhFAMemMan.SetFMemoryCount(Cnt: SmallInt);
begin
  if FFMemoryCount <> Cnt then
    FFMemoryCount := Cnt;
end;

procedure TpjhFAMemMan.SetRMemoryCount(Cnt: SmallInt);
begin
  if FRMemoryCount <> Cnt then
    FRMemoryCount := Cnt;
end;

procedure TpjhFAMemMan.SetWMemoryCount(Cnt: SmallInt);
begin
  if FWMemoryCount <> Cnt then
    FWMemoryCount := Cnt;
end;

function TpjhFAMemMan.GetA(Index: SmallInt): Double;
var
  val               : Double;
begin
  if Index > FAMemoryCount - 1 then
  begin
    raise Exception.Create('Allocation Count를 초과하는 Index입니다.');
    Result := 0;
    Exit;
  end;
  //Sect.Enter;
  try
    val := 0;
    Move(lpDataA[Index * (SizeOf(Double))], val, SizeOf(Double));
    Result := val;
  finally
    //Sect.Leave;
  end;
end;

function TpjhFAMemMan.GetF(Index: SmallInt): Double;
var
  val               : Double;
begin
  if Index > FFMemoryCount - 1 then
  begin
    raise Exception.Create('Allocation Count를 초과하는 Index입니다.');
    Result := 0;
    Exit;
  end;
  //Sect.Enter;
  try
    val := 0;
    Move(lpDataF[Index * (SizeOf(Double))], val, SizeOf(Double));
    Result := val;
  finally
   // Sect.Leave;
  end;
end;

function TpjhFAMemMan.GetR(Index: SmallInt): smallint;
var
  val               : SmallInt;
begin
  if Index > FRMemoryCount - 1 then
  begin
    raise Exception.Create('Allocation Count를 초과하는 Index입니다.');
    Result := 0;
    Exit;
  end;
//  Sect.Enter;
  try
    val := 0;
    Move(lpDataR[Index * (SizeOf(SmallInt))], val, SizeOf(SmallInt));
    Result := val;
  finally
   // Sect.Leave;
  end;
end;

function TpjhFAMemMan.GetW(Index: SmallInt): smallint;
var
  val               : SmallInt;
begin
  if Index > FWMemoryCount - 1 then
  begin
    raise Exception.Create('Allocation Count를 초과하는 Index입니다.');
    Result := 0;
    Exit;
  end;
  //Sect.Enter;
  try
    val := 0;
    Move(lpDataW[Index * (SizeOf(SmallInt))], val, SizeOf(SmallInt));
    Result := val;
  finally
   // Sect.Leave;
  end;
end;

//------------------------------------------------------------------------------

procedure TpjhFAMemMan.SetA(Index: smallInt; Value: Double);
var
  pre_val           : Double;
begin
  if Index > FAMemoryCount - 1 then
  begin
    raise Exception.Create('Allocation Count를 초과하는 Index입니다.');
    Exit;
  end;
 // Sect.Enter;
  try
    pre_val := GetA(Index);             //--+
    Move(Value, lpDataA[Index * SizeOf(Double)], SizeOf(Value));

    if Assigned(FOnAMemChange) and (pre_val <> Value) then //--+ Change Event용
      FOnAMemChange(Self, Index, pre_val, Value); //--+
    ApplyUpdate(A_MEM, Index);          //등록된 외부 컴포넌트에게 데이터를 가져가라고 통보...
  finally
   // Sect.Leave;
  end;
end;

procedure TpjhFAMemMan.SetF(Index: smallInt; Value: Double);
var
  pre_val           : Double;
begin
  if Index > FFMemoryCount - 1 then
  begin
    raise Exception.Create('Allocation Count를 초과하는 Index입니다.');
    Exit;
  end;
  //Sect.Enter;
  try
    pre_val := GetF(Index);             //--+
    Move(Value, lpDataF[Index * SizeOf(Double)], SizeOf(Value));

    if Assigned(FOnFMemChange) and (pre_val <> Value) then //--+ Change Event용
      FOnFMemChange(Self, Index, pre_val, Value); //--+
    ApplyUpdate(F_MEM, Index);          //등록된 외부 컴포넌트에게 데이터를 가져가라고 통보...
  finally
    //Sect.Leave;
  end;
end;

procedure TpjhFAMemMan.SetR(Index: smallInt; Value: SmallInt);
var
  pre_val           : SmallInt;
begin
  if Index > FRMemoryCount - 1 then
  begin
    raise Exception.Create('Allocation Count를 초과하는 Index입니다.');
    Exit;
  end;
  //Sect.Enter;
  try
    pre_val := GetR(Index);             //--+
    Move(Value, lpDataR[Index * SizeOf(SmallInt)], SizeOf(Value));

    if Assigned(FOnRMemChange) and (pre_val <> Value) then //--+ Change Event용
      FOnRMemChange(Self, Index, pre_val, Value); //--+
    ApplyUpdate(R_MEM, Index);          //등록된 외부 컴포넌트에게 데이터를 가져가라고 통보...
  finally
    //Sect.Leave;
  end;
end;

procedure TpjhFAMemMan.SetW(Index: smallInt; Value: SmallInt);
var
  pre_val           : SmallInt;
begin
  if Index > FWMemoryCount - 1 then
  begin
    raise Exception.Create('Allocation Count를 초과하는 Index입니다.');
    Exit;
  end;
  //Sect.Enter;
  try
    pre_val := GetW(Index);             //--+
    Move(Value, lpDataW[Index * SizeOf(SmallInt)], SizeOf(Value));

    if Assigned(FOnWMemChange) and (pre_val <> Value) then //--+ Change Event용
      FOnWMemChange(Self, Index, pre_val, Value); //--+
    ApplyUpdate(W_MEM, Index);          //등록된 외부 컴포넌트에게 데이터를 가져가라고 통보...
  finally
    //Sect.Leave;
  end;
end;

//------------------------------------------------------------------------------
//  메모리 변경을 보고 받을 컴포턴트 목록 관리 Class
//------------------------------------------------------------------------------

constructor TNewsMember.Create;
begin
  FComponent := nil;
end;

procedure TNewsMember.ApplyUpdate(sm: TpjhFAMemMan);
begin
  // 재귀적 호출을 위하여 채용한 가상메쏘드.
  FComponent.SafeCallException(sm, nil);
end;

// 변경통지용 목록 전체를 삭제..

procedure TpjhFAMemMan.DestroyNewsMembers;
var
  item              : TNewsMember;
begin
  while FNewsMembers.Count > 0 do
  begin
    item := FNewsMembers.Last;
    FNewsMembers.Remove(item);
    item.Free;
  end;
end;

// 외부에서 호출하여 TFAMemMan의 변경여부를 보고 받을
// 외부 VCL을 스스로 등록하도록 하는 함수...

procedure TpjhFAMemMan.RegisterNewsMember(AComponent: TComponent; AMemName: TMemName; AMemIndex: Smallint);
var
  n, nCount         : integer;
  item              : TNewsMember;
begin
  nCount := FNewsMembers.Count;
  if nCount > 0 then
    for n := 0 to nCount - 1 do
    begin
      item := TNewsMember(FNewsMembers.Items[n]);
    // 같은 컴포넌트가 이미 등록되어있다면 기냥 나가고...
      if (item.FComponent = AComponent) then
      begin
        item.FMemName := AMemName;
        item.FMemIndex := AMemIndex;
        Exit;
      end;
    end;
  item := TNewsMember.Create;
  item.FComponent := AComponent;
  item.FMemName := AMemName;
  item.FMemIndex := AMemIndex;
  // 자신을 등록...
  FNewsMembers.Add(item);
end;

// 더 이상 TFAMemMan과 관계없는 컴포넌트만 삭제.
// 외부에서 호출- 나좀 빼줘~~~~~~~~~~

procedure TpjhFAMemMan.KickOutNewsMember(AComponent: TComponent);
var
  n, nCount         : integer;
  item              : TNewsMember;
begin
  nCount := FNewsMembers.Count;
  if nCount > 0 then
    for n := 0 to nCount - 1 do
    begin
      item := TNewsMember(FNewsMembers.Items[n]);
      if (item.FComponent = AComponent) then
      begin
        FNewsMembers.Remove(item);
        item.Free;
        Exit;
      end;
    end;
end;

// 외부 혹은 내부에서 호출된다.
// TFAMemMan의 변경 내용을 이와 연결된 다른 컴포넌트들로 통보.
// 나~~~~~~ 바뀠다~~~~~~~~~~~

procedure TpjhFAMemMan.ApplyUpdate(AMemName: TMemName; AMemIndex: Smallint);
var
  n, nCount         : integer;
  item              : TNewsMember;
begin
  nCount := FNewsMembers.Count;
  if nCount > 0 then
    for n := 0 to nCount - 1 do
    begin
      item := TNewsMember(FNewsMembers.Items[n]);
      if (item.FMemName = AMemName) and (item.FMemIndex = AMemIndex) then
      begin
        Sect.Enter;
        item.ApplyUpdate(Self);
        Sect.Leave;
      // 같은 조건이 여러개 존재할수 있으므로 여기에 Exit;를 사용하면 않됨
      end;
    end;

{  if FServer then
    FWatchThread.FWatchEvent.SetEvent
  else
  begin
    FCurrentMemName := AMemName;
    FCurrentMemIndex:= AMemIndex;
  end
}
end;

{procedure TpjhFAMemMan.SetServer(Value: Boolean);
begin
  if FServer <> Value then
  begin
    if Value then
    begin
      if not Assigned(FWatchThread) then
        FWatchThread := TMyWatchThread.Create(Self);
    end//if
    else
    begin
      FWatchThread.Terminate;
      FWatchThread.FWatchEvent.SetEvent;
    end;
  end;
end;
}
{ TMyWatchThread }

{constructor TMyWatchThread.Create(AOwner: TpjhFAMemMan);
begin
  inherited Create(True);

  FOwner := AOwner;
  FWatchEvent := TEvent.Create(nil, False, True, FOwner.Name + '_Event');
  FreeOnTerminate := True;
end;

destructor TMyWatchThread.Destroy;
begin
  FreeAndNil(FWatchEvent);
  
  inherited;
end;

procedure TMyWatchThread.Execute;
begin
  while not Terminated do
  begin
    if WaitForSingleObject(FWatchEvent.Handle, INFINITE) <> WAIT_OBJECT_0 then
      Break;

    FOwner.ApplyUpdate(FOwner);
  end;//while

end;
}
end.

