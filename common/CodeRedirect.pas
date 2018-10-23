{$WEAKPACKAGEUNIT ON}
unit CodeRedirect;

interface

type
  TCodeRedirect = class(TObject)
  private
    type
      TInjectRec = packed record
        Jump: Byte;
        Offset: Integer;
      end;

      PWin9xDebugThunk = ^TWin9xDebugThunk;
      TWin9xDebugThunk = packed record
        PUSH: Byte;
        Addr: Pointer;
        JMP: Byte;
        Offset: Integer;
      end;

      PAbsoluteIndirectJmp = ^TAbsoluteIndirectJmp;
      TAbsoluteIndirectJmp = packed record
        OpCode: Word;   //$FF25(Jmp, FF /4)
        Addr: ^Pointer;
      end;
  private
    FSourceProc: Pointer;
    FNewProc: Pointer;
    FInjectRec: TInjectRec;
  public
    constructor Create(const aProc, aNewProc: Pointer);
    procedure BeforeDestruction; override;
    procedure Disable;
    procedure Enable;
    class function GetActualAddr(Proc: Pointer): Pointer;
    class function GetAddressOf(aMethodAddr: pointer; aSignature: array of byte): Pointer;
  end;

implementation

uses SysUtils, Windows;

class function TCodeRedirect.GetActualAddr(Proc: Pointer): Pointer;

  function IsWin9xDebugThunk(AAddr: Pointer): Boolean;
  begin
    Result := (AAddr <> nil) and
              (PWin9xDebugThunk(AAddr).PUSH = $68) and
              (PWin9xDebugThunk(AAddr).JMP = $E9);
  end;

begin
  if Proc <> nil then begin
    if (Win32Platform <> VER_PLATFORM_WIN32_NT) and IsWin9xDebugThunk(Proc) then
      Proc := PWin9xDebugThunk(Proc).Addr;
    if (PAbsoluteIndirectJmp(Proc).OpCode = $25FF) then
      Result := PAbsoluteIndirectJmp(Proc).Addr^
    else
      Result := Proc;
  end else
    Result := nil;
end;

procedure TCodeRedirect.BeforeDestruction;
begin
  inherited;
  Disable;
end;

constructor TCodeRedirect.Create(const aProc, aNewProc: Pointer);
begin
  inherited Create;
  FSourceProc := aProc;
  FNewProc := aNewProc;
  Enable;
end;

procedure TCodeRedirect.Disable;
var n: DWORD;
begin
  if FInjectRec.Jump <> 0 then
    WriteProcessMemory(GetCurrentProcess, GetActualAddr(FSourceProc), @FInjectRec, SizeOf(FInjectRec), n);
end;

procedure TCodeRedirect.Enable;
var OldProtect: Cardinal;
    P: pointer;
begin
  if Assigned(FSourceProc)then begin
    P := GetActualAddr(FSourceProc);
    if VirtualProtect(P, SizeOf(TInjectRec), PAGE_EXECUTE_READWRITE, OldProtect) then begin
      FInjectRec := TInjectRec(P^);
      TInjectRec(P^).Jump := $E9;
      TInjectRec(P^).Offset := Integer(FNewProc) - (Integer(P) + SizeOf(TInjectRec));
      VirtualProtect(P, SizeOf(TInjectRec), OldProtect, @OldProtect);
      FlushInstructionCache(GetCurrentProcess, P, SizeOf(TInjectRec));
    end;
  end;
end;

class function TCodeRedirect.GetAddressOf(aMethodAddr: pointer;
  aSignature: array of byte): Pointer;
var P: PByteArray;
begin
  P := GetActualAddr(aMethodAddr);
  while not CompareMem(P, @aSignature, Length(aSignature)) do
    Inc(PByte(P));
  Result := Pointer(Integer(@P[5]) + PInteger(@P[1])^);
end;

end.

