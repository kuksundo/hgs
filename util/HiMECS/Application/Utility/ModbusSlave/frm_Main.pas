{===============================================================================

The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above. If you wish to
allow use of your version of this file only under the terms of the GPL and not
to allow others to use your version of this file under the MPL, indicate your
decision by deleting the provisions above and replace them with the notice and
other provisions required by the GPL. If you do not delete the provisions
above, a recipient may use your version of this file under either the MPL or
the GPL.

$Id: frm_Main.pas,v 1.6 2010/09/14 10:02:50 plpolak Exp $

===============================================================================}

unit frm_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdModBusServer, Grids, ExtCtrls,
  StdCtrls, Buttons, IdContext, IdCustomTCPServer, ModbusTypes,
  UnitFrameIPCMonitorAll, ModbusSlave_ConfigUnit, iniFiles, TimerPool, Vcl.Menus,
  AdvObj, BaseGrid, AdvGrid, EngineParameterClass;

type
  TfrmMain = class(TForm)
    pnlInput: TPanel;
    btnStart: TBitBtn;
    Label1: TLabel;
    edtFirstReg: TEdit;
    edtLastReg: TEdit;
    Label2: TLabel;
    pnlMain: TPanel;
    mmoErrorLog: TMemo;
    Splitter1: TSplitter;
    msrPLC: TIdModBusServer;
    TFrameIPCMonitorAll1: TFrameIPCMonitorAll;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    FILE1: TMenuItem;
    Close1: TMenuItem;
    HELP1: TMenuItem;
    Option1: TMenuItem;
    Help2: TMenuItem;
    About1: TMenuItem;
    sgdRegisters: TAdvStringGrid;
    procedure msrPLCReadHoldingRegisters(const Sender: TIdContext; const RegNr,
      Count: Integer; var Data: TModRegisterData;
      const RequestBuffer: TModBusRequestBuffer; var ErrorCode: Byte);
    procedure msrPLCWriteRegisters(const Sender: TIdContext;
      const RegNr, Count: Integer; const Data: TModRegisterData;
      const RequestBuffer: TModBusRequestBuffer);
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sgdRegistersSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure msrPLCConnect(AContext: TIdContext);
    procedure msrPLCReadInputRegisters(const Sender: TIdContext; const RegNr,
      Count: Integer; var Data: TModRegisterData;
      const RequestBuffer: TModBusRequestBuffer; var ErrorCode: Byte);
    procedure Option1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FFirstReg: Integer;
    FLastReg: Integer;
    FRegisterValues: array of double;
    FFilePath: string;

    FPJHTimerPool: TPJHTimerPool;
    FParameterSourceList,
    FParameterOriginalList: TStringList;

    SAVEINIFILENAME : string;
    FMapFileName: string;
    FParamFileName: string;
    FConfigModified: Boolean;

    FEngParamEncrypt: Boolean;
    FEngParamFileFormat: integer;
    FTimerHandle: integer;
    FUpdateInterval: integer;

    procedure ClearRegisters;
    procedure FillRegisters;
    procedure FillHeaderRegisters;
    procedure Convert(const Index: Integer);
    procedure SetRegisterValue(const RegNo: Integer; const Value: string);
    function GetRegisterValue(const RegNo: Integer): Word;
  protected
    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                                AEPIndex: integer);
    procedure OnUpdateRegister(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    procedure InitVar;
    procedure IPCAll_Init;
    procedure IPCAll_Final;
  public
    //ini 파일 설정과 저장을 위한 함수 선언부
    procedure LoadConfigDataini2Form(FSaveConfigF: TFrmModbusSlaveConfig);
    procedure SaveConfigDataForm2ini(FSaveConfigF: TFrmModbusSlaveConfig);
    procedure LoadConfigDataini2Var;
    procedure AdjustConfigData(AParamModified: Boolean = True);
    procedure MakeParamList;

    procedure DisplayMessage(msg: string);
  end;

  const
    MODBUS_SLAVE_SECTION = 'Modbus Slave';
    PARAM_SECTION = 'Parameter List';
var
  frmMain: TfrmMain;

implementation

uses HiMECSConst;

{$R *.dfm}

function IntToBinary(const Value: Int64; const ALength: Integer): String;
var
  iWork: Int64;
begin
  Result := '';
  iWork := Value;
  while (iWork > 0) do
  begin
    Result := IntToStr(iWork mod 2) + Result;
    iWork := iWork div 2;
  end;
  while (Length(Result) < ALength) do
    Result := '0' + Result;
end;


procedure TfrmMain.msrPLCConnect(AContext: TIdContext);
begin
  DisplayMessage('Connected');
end;

procedure TfrmMain.msrPLCReadHoldingRegisters(const Sender: TIdContext;
  const RegNr, Count: Integer; var Data: TModRegisterData;
  const RequestBuffer: TModBusRequestBuffer; var ErrorCode: Byte);
var
  i: Integer;
begin
  for i := 0 to (Count - 1) do
    Data[i] := GetRegisterValue(RegNr + i);
end;


procedure TfrmMain.msrPLCReadInputRegisters(const Sender: TIdContext;
  const RegNr, Count: Integer; var Data: TModRegisterData;
  const RequestBuffer: TModBusRequestBuffer; var ErrorCode: Byte);
var
  i: Integer;
begin
  for i := 0 to (Count - 1) do
    Data[i] := GetRegisterValue(RegNr + i);
end;

procedure TfrmMain.msrPLCWriteRegisters(const Sender: TIdContext;
  const RegNr, Count: Integer; const Data: TModRegisterData;
  const RequestBuffer: TModBusRequestBuffer);
var
  i: Integer;
begin
  //for i := 0 to (Count - 1) do
  //  SetRegisterValue(RegNr + i, Data[i]);
end;


procedure TfrmMain.OnUpdateRegister(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin

end;

procedure TfrmMain.Option1Click(Sender: TObject);
var
  FSaveConfigF: TFrmModbusSlaveConfig;
begin
  FSaveConfigF := TFrmModbusSlaveConfig.Create(Application);
  FPJHTimerPool.Enabled[FTimerHandle] := False;

  try
    with FSaveConfigF do
    begin
      msrPLC.Active := False;
      LoadConfigDataini2Form(FSaveConfigF);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(FSaveConfigF);
        LoadConfigDataini2Var;
        AdjustConfigData(FConfigModified);
        IPCAll_Final;
        IPCAll_Init;
        btnStartClick(nil);
      end;
    end;
  finally
    FSaveConfigF.Free;
    FPJHTimerPool.Enabled[FTimerHandle] := True;
  end;
end;

procedure TfrmMain.AdjustConfigData(AParamModified: Boolean);
begin
  if AParamModified then //Parameter File Name이 변경 되었을 경우에만 True
  begin
    if FileExists(FParamFileName) then
    begin
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
      if FEngParamFileFormat = 0 then //XML File Format
        TFrameIPCMonitorAll1.FEngineParameter.LoadFromFile(FParamFileName, ExtractFileName(FParamFileName), FEngParamEncrypt)
      else
      if FEngParamFileFormat = 1 then //JSON File Format
        TFrameIPCMonitorAll1.FEngineParameter.LoadFromJSONFile(FParamFileName, ExtractFileName(FParamFileName), FEngParamEncrypt);

      MakeParamList;
    end
    else
      ShowMessage('Not exist parameter file: ' + FParamFileName);
  end;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  if msrPLC.Active then
  begin
    msrPLC.Active := False;
    edtFirstReg.Enabled := True;
    edtLastReg.Enabled := True;
    btnStart.Caption := '&Start';
    ClearRegisters;
    FPJHTimerPool.RemoveAll;
  end
  else
  begin
    //FFirstReg := StrToInt(edtFirstReg.Text);
    //FLastReg := StrToInt(edtLastReg.Text);
    msrPLC.MinRegister := FFirstReg;
    msrPLC.MaxRegister := FLastReg;
    btnStart.Caption := '&Stop';
    msrPLC.Active := True;
    FillHeaderRegisters;
    FillRegisters;
    FTimerHandle := FPJHTimerPool.Add(OnUpdateRegister, FUpdateInterval);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨

  FFirstReg := 0;
  FLastReg := 0;
{ Set grid headers titles }
  sgdRegisters.Cells[0, 0] := 'Items';
  sgdRegisters.Cells[1, 0] := 'RegNo';
  sgdRegisters.Cells[2, 0] := 'Decimal';
  sgdRegisters.Cells[3, 0] := 'Hex.';
  sgdRegisters.Cells[4, 0] := 'Binary';
{ Set the column width }
  sgdRegisters.ColWidths[3] := 120;

  InitVar;
end;

procedure TfrmMain.ClearRegisters;
var
  i: Integer;
begin
  sgdRegisters.RowCount := 2;
  for i := 0 to (sgdRegisters.ColCount - 1) do
    sgdRegisters.Cells[i, 1] := '';
end;

procedure TfrmMain.FillHeaderRegisters;
var
  i,j: Integer;
begin
  ClearRegisters;

  if (FLastReg >= FFirstReg) then
  begin
    sgdRegisters.RowCount := (FLastReg - FFirstReg) + 2;

    j := 0;
    for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) = 'DUMMY' then
        continue;

      sgdRegisters.Cells[0, j + 1] :=
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description;
      sgdRegisters.Cells[1, j + 1] := IntToStr(i+1);
      inc(j);
    end;
  end;
end;

procedure TfrmMain.FillRegisters;
var
  i,j: Integer;
begin
  if (FLastReg >= FFirstReg) then
  begin
    //for i := FFirstReg to FLastReg do
    j := 1;
    for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) = 'DUMMY' then
        continue;

      SetRegisterValue(j,
        TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value);
      inc(j);
    end;
  end;
end;

procedure TfrmMain.Convert(const Index: Integer);
begin
  sgdRegisters.Cells[3, Index + 1] := IntToHex(Round(FRegisterValues[Index]), 4);
  sgdRegisters.Cells[4, Index + 1] := IntToBinary(Round(FRegisterValues[Index]), 16);
end;

procedure TfrmMain.DisplayMessage(msg: string);
begin
  with mmoErrorLog do
  begin
    if Lines.Count > 100 then
      Clear;

    Lines.Add(msg);
  end;//with
end;

procedure TfrmMain.SaveConfigDataForm2ini(FSaveConfigF: TFrmModbusSlaveConfig);
var
  iniFile: TIniFile;
  LStr: string;
  LBool: Boolean;
  i: integer;
begin
  SetCurrentDir(FFilePath);
  DisplayMessage(#13#10+'System configuration changed'+#13#10);

  iniFile := nil;
  iniFile := TInifile.create(SAVEINIFILENAME);
  try
    with iniFile, FSaveConfigF do
    begin
      WriteString(MODBUS_SLAVE_SECTION, 'Modbus Map File Name1', MapFilenameEdit.FileName);
      WriteString(MODBUS_SLAVE_SECTION, 'Parameter File Name', ParaFilenameEdit.FileName);

      WriteBool(MODBUS_SLAVE_SECTION, 'Parameter Encrypt', EngParamEncryptCB.Checked);
      WriteInteger(MODBUS_SLAVE_SECTION, 'Param File Format', ConfFileFormatRG.ItemIndex);

      for i := 0 to ParamSourceCLB.Items.Count - 1 do
      begin
        WriteBool(PARAM_SECTION, ParamSourceCLB.Items.Strings[i], ParamSourceCLB.Checked[i]);
      end;
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TfrmMain.SetRegisterValue(const RegNo: Integer; const Value: string);
var
  Index: Integer;
begin
  if (RegNo >= FFirstReg) and (RegNo <= FLastReg) then
  begin
    Index := RegNo - FFirstReg;
    if (Index >= Length(FRegisterValues)) then
      SetLength(FRegisterValues, (Index+1) * 2);
    FRegisterValues[Index] := StrToFloatDef(Value,0);
    sgdRegisters.Cells[2, Index+1] := Value;
    Convert(Index);
  end;
end;

function TfrmMain.GetRegisterValue(const RegNo: Integer): Word;

 function WordRange(const i: Integer):Word;
 begin
   if (i < 0) and (i >= -32767) then
     Result := Word(i)
   else if (i <= MAXWORD) then
     Result := Word(i)
   else
     Result := MAXWORD;
 end;
 
var
  Index: Integer;
begin
  if (RegNo >= FFirstReg) and (RegNo <= FLastReg) then
  begin
    Index := RegNo - FFirstReg;
    Assert(Index >= 0);
    Assert(Index < Length(FRegisterValues));
    if (Index >= 0) and (Index < Length(FRegisterValues)) then
      Result := WordRange(Round(FRegisterValues[Index]))
    else
      Result := 0;
  end
  else
    Result := 0;
end;

procedure TfrmMain.InitVar;
begin
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FParameterOriginalList := TStringList.Create;
  FParameterSourceList := TStringList.Create;

  SAVEINIFILENAME := ChangeFileExt(Application.ExeName,'.ini');
end;

procedure TfrmMain.IPCAll_Final;
begin
  TFrameIPCMonitorAll1.DestroyIPCMonitorAll;
  DisplayMessage('All IPCMonitor is destroyed.');
end;

procedure TfrmMain.IPCAll_Init;
var
  LStr: string;
  i: integer;
  LEPItem: TEngineParameterItem;
begin
  for i := 0 to FParameterSourceList.Count - 1 do
  begin
    LEPItem := TEngineParameterItem(FParameterSourceList.Objects[i]);
    if (LEPItem.ParameterSource = psECS_AVAT) or
      (LEPItem.ParameterSource = psECS_kumo) then
    begin
      if FMapFileName <> '' then
        TFrameIPCMonitorAll1.SetModbusMapFileName(FMapFileName, LEPItem.ParameterSource);
    end;

    LStr := TFrameIPCMonitorAll1.CreateIPCMonitor_xx(LEPItem.ParameterSource, LEPItem.SharedName);
    DisplayMessage(LStr + ' Created.');
  end;
end;

procedure TfrmMain.LoadConfigDataini2Form(FSaveConfigF: TFrmModbusSlaveConfig);
var
  iniFile: TIniFile;
  LStr: string;
  i: integer;
  LStrList: TStringList;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(SAVEINIFILENAME);
  try
    with iniFile, FSaveConfigF do
    begin
      MapFilenameEdit.FileName := ReadString(MODBUS_SLAVE_SECTION, 'Modbus Map File Name1', '');
      ParaFilenameEdit.FileName := ReadString(MODBUS_SLAVE_SECTION, 'Parameter File Name', '');
      EngParamEncryptCB.Checked := ReadBool(MODBUS_SLAVE_SECTION, 'Parameter Encrypt', False);
      ConfFileFormatRG.ItemIndex := ReadInteger(MODBUS_SLAVE_SECTION, 'Param File Format', 0);

      //parameter file에서 Item을 읽은 후 존재하는 Item Check Box만 Enable 함
      LStrList := TStringList.Create;
      try
        ParameterSource2Strings(LStrList);
        ParamSourceCLB.Items.AddStrings(LStrList);

        for i := 0 to ParamSourceCLB.Items.Count - 1 do
        begin
          if FParameterOriginalList.IndexOf(ParamSourceCLB.Items.Strings[i]) = -1 then
            ParamSourceCLB.ItemEnabled[i] := False;

          if ParamSourceCLB.ItemEnabled[i] then
            ParamSourceCLB.Checked[i] := ReadBool(PARAM_SECTION, ParamSourceCLB.Items.Strings[i], False);
        end;
      finally
        LStrList.Free;
      end;
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TfrmMain.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
  LStr: string;
  i,j: integer;
  LBool: Boolean;
  LStrList: TStringList;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(SAVEINIFILENAME);
  try
    with iniFile do
    begin
      FMapFileName := ReadString(MODBUS_SLAVE_SECTION, 'Modbus Map File Name1', '');
      LStr := ReadString(MODBUS_SLAVE_SECTION, 'Parameter File Name', '');
      FConfigModified := False;
      if FParamFileName <> LStr then
      begin
        FParamFileName := LStr;
        FConfigModified := True;
      end;

      FEngParamEncrypt := ReadBool(MODBUS_SLAVE_SECTION, 'Parameter Encrypt', false);
      FEngParamFileFormat := ReadInteger(MODBUS_SLAVE_SECTION, 'Param File Format', 0);

      AdjustConfigData(FConfigModified);

      //Parameter File 내 ParameterSource를 모두 가져옴
      TFrameIPCMonitorAll1.GetParameterSourceList(FParameterSourceList);

      LStrList := TStringList.Create;
      try
        ReadSectionValues(PARAM_SECTION, LStrList);
        //Ini File에서 True 인 Parameter Source만 FParameterSourceList에 남겨두고 나머지 제거
        for i := 0 to LStrList.Count - 1 do
        begin
          if not StrToBool(LStrList.ValueFromIndex[i]) then
          begin
            j := FParameterSourceList.IndexOf(LStrList.Names[i]);
            if j <> -1 then
              FParameterSourceList.Delete(j);
          end;
        end;
      finally
        LStrList.Free;
      end;
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TfrmMain.MakeParamList;
var
  i,j: integer;
  LName: string;
begin
  j := 0;

  for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) = 'DUMMY' then
      continue;

    LName := ParameterSource2String(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource);

    if FParameterOriginalList.IndexOf(LName) = -1 then
      FParameterOriginalList.AddObject(LName,TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i]);

    inc(j);
  end;

  FFirstReg := 1;
  FLastReg := j;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  msrPLC.Pause := True;
  if msrPLC.Active then
    btnStartClick(Sender);

  FParameterSourceList.Free;
  FParameterOriginalList.Free;
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
end;

procedure TfrmMain.sgdRegistersSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  Index: Integer;
begin
  if (ACol = 1) then
  begin
    Index := ARow - 1;
    FRegisterValues[Index] := StrToIntDef(Value, 0);
    Convert(Index);
  end;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  TFrameIPCMonitorAll1.InitVar;//FConfigOption을 먼저 생성 후
  TFrameIPCMonitorAll1.SetValue2ScreenEvent(WatchValue2Screen_Analog,nil);
  LoadConfigDataini2Var; //FConfigOption.ModbusMapFileName 할당함
  AdjustConfigData;

  IPCAll_Init;
  btnStartClick(Sender);
end;

procedure TfrmMain.WatchValue2Screen_Analog(Name, AValue: string;
  AEPIndex: integer);
begin
  FillRegisters;
end;

end.
