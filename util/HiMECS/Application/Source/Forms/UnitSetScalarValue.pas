unit UnitSetScalarValue;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, AdvEdit,
  UnitIPCClientMonitor, ModbusComConst_endurance, IPC_ModbusComm_Const, HiMECSConst,
  IPC_HIC_Const,
  iComponent, iVCLComponent,
  iCustomComponent, iSwitchLed, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ImgList, NxEdit;

type
  TSetScalarValueF = class(TForm)
    ScalarValueEdit: TAdvEdit;
    XLabel: TLabel;
    BitBtn1: TBitBtn;
    FrameCnM: TFrameClientMonitor;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton6: TToolButton;
    btnSave: TToolButton;
    btnOpen: TToolButton;
    ToolButton2: TToolButton;
    iSwitchLed1: TiSwitchLed;
    iSwitchLed2: TiSwitchLed;
    DataEditCB: TNxCheckBox;
    StatusBar1: TStatusBar;
    WriteConfirmCB: TNxCheckBox;
    BitBtn2: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DataEditCBChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure iSwitchLed1ChangeUser(Sender: TObject);
    procedure iSwitchLed2Change(Sender: TObject);
    procedure ScalarValueEditChange(Sender: TObject);
    procedure WriteConfirmCBChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    procedure UpdateTrace_ScalarValue(var Msg: TEventData_HIC); message WM_EVENT_SCALARVALUE_COMM;
  public
    FMainFormHandle: integer;
    FParamItemIndex: integer;
    FDataEditable: Boolean; //True = Data 편집 가능
    FUseConfirmWrite: Boolean;//True = Write Confirm send 함.

    procedure WriteScalarValue;
    procedure ConfirmWrite;
    procedure Matrix_OnSignal(Data: TEventData_HIC);
    procedure MoveParameter2Component;
    procedure ReqReadConfigData;
    procedure AnalogValue2Screen;
    function GetConfirmAddress: string;
  end;

var
  SetScalarValueF: TSetScalarValueF;

implementation

{$R *.dfm}

procedure TSetScalarValueF.AnalogValue2Screen;
begin
  ScalarValueEdit.Text := IntToStr(FrameCnM.FMatrixCommData.InpDataBuf[0]);
end;

procedure TSetScalarValueF.BitBtn1Click(Sender: TObject);
begin
  WriteScalarValue;
end;

procedure TSetScalarValueF.BitBtn2Click(Sender: TObject);
begin
  ConfirmWrite;
end;

procedure TSetScalarValueF.ConfirmWrite;
var
  AData: TConfigData_ModbusComm;
  LStr: string;
begin
  if FrameCnM.FMatrixCommData.ErrorCode <> 9999 then
  begin
    StatusBar1.SimplePanel := True;
    LStr := '********'''+ FrameCnM.FMatrixCommData.ModBusAddress + ''', Write Error!' + #13#10;
    LStr := LStr + 'Error Code = (' + IntToStr(FrameCnM.FMatrixCommData.ErrorCode) + ')';
    StatusBar1.SimpleText := LStr;
    exit;
  end;

  if FrameCnM.FMatrixCommData.DataMode = 4 then
  begin
    StatusBar1.SimplePanel := True;
    LStr := '********'''+ FrameCnM.FMatrixCommData.ModBusAddress + ''', Confirm Write OK!' + #13#10;
    StatusBar1.SimpleText := LStr;
    exit;
  end;

  case FrameCnM.FMatrixCommData.ModBusFunctionCode of
    16: begin
      FillChar(AData, SizeOf(AData), #0);

      with AData do
      begin
        NumOfData := 1;
        ModBusFunctionCode := 16; //mbfWriteRegs in ModbusConsts
        ModBusAddress := GetConfirmAddress;//'0032';
        if ModBusAddress = '' then
          ModBusAddress := '0001';
        ParameterType := 2;//ptAnalog
        ModbusMode := 1;//RTU Mode
        CommMode := 3;// Only One Write for Confirm

        DataBuf[0] := 1234;
      end;

      AData.Termination := False;
      FrameCnM.FIPCClient_HIC.PulseMonitor(AData);
      StatusBar1.SimplePanel := True;
      StatusBar1.SimpleText := '********'''+ AData.ModBusAddress + ''', Write Confirm OK!';
    end;//16
  end;//case
end;

procedure TSetScalarValueF.DataEditCBChange(Sender: TObject);
begin
  ScalarValueEdit.ReadOnly := not DataEditCB.Checked;
end;

procedure TSetScalarValueF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SendMessage(FMainFormHandle, WM_SCALARFORMCLOSE, Handle, 0);
end;

procedure TSetScalarValueF.FormCreate(Sender: TObject);
begin
  FrameCnM.InitVar;
  FUseConfirmWrite := True;
end;

procedure TSetScalarValueF.FormDestroy(Sender: TObject);
begin
  FrameCnM.DestroyVar;
end;

function TSetScalarValueF.GetConfirmAddress: string;
var
  i: integer;
begin
  Result := '';

  for i := 0 to FrameCnM.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FrameCnM.FEngineParameter.EngineParameterCollect.Items[i].TagName = 'PARAM_CONFIRM' then
    begin
      Result := FrameCnM.FEngineParameter.EngineParameterCollect.Items[i].Address;
      break;
    end;
  end;
end;

procedure TSetScalarValueF.iSwitchLed1ChangeUser(Sender: TObject);
begin
  FrameCnM.FUseOnlineData := iSwitchLed1.Active;

  if FrameCnM.FUseOnlineData then
  begin
    iSwitchLed2.Active := False;
    ReqReadConfigData;
  end;
end;

procedure TSetScalarValueF.iSwitchLed2Change(Sender: TObject);
begin
  if iSwitchLed2.Active then
  begin
    iSwitchLed1.Active := False;
    MoveParameter2Component;
  end;
end;

procedure TSetScalarValueF.Matrix_OnSignal(Data: TEventData_HIC);
begin
  if Data.DataMode = 0 then//CM_DATA_READ
    exit
  else
  if Data.DataMode = 1 then//CM_CONFIG_READ
  begin
    if not FrameCnM.FUseOnlineData then
      exit;
  end
  else //CM_DATA_WRITE, CM_CONFIG_WRITE, CM_CONFIG_WRITE_CONFIRM
  begin

  end;

  System.Move(Data, FrameCnM.FMatrixCommData, Sizeof(Data));
  SendMessage(Handle, WM_EVENT_SCALARVALUE_COMM, 0,0);
end;

procedure TSetScalarValueF.MoveParameter2Component;
begin
  ScalarValueEdit.Text := FrameCnM.FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Value;
end;

procedure TSetScalarValueF.ReqReadConfigData;
var
  LConfigData: TConfigData_ModbusComm;
  LParameterType: TParameterType;
  LStr: string;
begin
  FillChar(LConfigData, SizeOf(LConfigData), #0);

  LConfigData.SlaveNo := 1;
  LConfigData.ModBusFunctionCode := StrToIntDef(FrameCnM.FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].FCode,3);
  LConfigData.ModBusAddress := FrameCnM.FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Address;

  LConfigData.NumOfData := 1;
  LConfigData.ParameterType := Ord(LParameterType);
  //0: Repeat Read, 1: Only One read, 2: Only One Write
  LConfigData.CommMode := 1;
  LConfigData.Termination := False;
  FrameCnM.FIPCClient_HIC.PulseMonitor(LConfigData);
  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := '********'''+ LConfigData.ModBusAddress + ''', Send OK!';
end;

procedure TSetScalarValueF.ScalarValueEditChange(Sender: TObject);
begin
  if not FrameCnM.FUseOnlineData then
  begin
    FrameCnM.FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Value :=
                                                ScalarValueEdit.Text;
  end
  else
    FrameCnM.FUseOnlineData := False;
end;

procedure TSetScalarValueF.UpdateTrace_ScalarValue(var Msg: TEventData_HIC);
var
  i: integer;
begin
  //CM_DATA_READ, CM_CONFIG_READ, CM_DATA_WRITE, CM_CONFIG_WRITE, CM_CONFIG_WRITE_CONFIRM
  case TCommMode(FrameCnM.FMatrixCommData.DataMode) of
    CM_CONFIG_READ: AnalogValue2Screen;
    CM_DATA_WRITE,
    CM_CONFIG_WRITE,
    CM_CONFIG_WRITE_CONFIRM: if FUseConfirmWrite then ConfirmWrite;
  end;
end;

procedure TSetScalarValueF.WriteConfirmCBChange(Sender: TObject);
begin
  FUseConfirmWrite := WriteConfirmCB.Checked;
end;

procedure TSetScalarValueF.WriteScalarValue;
var
  i,j: integer;
  LData: TConfigData_ModbusComm;
begin
  FillChar(LData, SizeOf(LData), #0);

  with LData do
  begin
    NumOfData := 1;
    ModBusFunctionCode := 16; //mbfWriteRegs in ModbusConsts
    ModBusAddress := FrameCnM.FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Address;
    ParameterType := 2;//ptAnalog
    ModbusMode := 1;//RTU Mode
    CommMode := 2;// Only One Write
    SlaveNo := 0;
    DataBuf[0] := StrToIntDef(FrameCnM.FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Value,-1);
  end;

  LData.Termination := False;
  FrameCnM.FIPCClient_HIC.PulseMonitor(LData);
  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := '********'''+ LData.ModBusAddress + ''', Write Request OK!';

end;

end.
