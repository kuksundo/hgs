unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, ActnList, StdCtrls, ExtCtrls, syncobjs,
  DeviceView,
  framChennelRSClasses,framChennelTCPClasses,
  ChennelClasses,
  MBDeviceClasses;

type

  { TfrmMain }

  TfrmMain = class(TForm)
     actFileLoadConf   : TAction;
     actFileSaveConf   : TAction;
     actExit           : TAction;
     actDevAdd         : TAction;
     actDevDel         : TAction;
     actDevClearList   : TAction;
     actDevView        : TAction;
     actChennelAdd     : TAction;
     actChennelDel     : TAction;
     actChennelClose   : TAction;
     actChennelOpen    : TAction;
     actChennelDelAll  : TAction;
     actChennelCloseAll: TAction;
     actChennelOpenAll : TAction;
     actChennelEdit    : TAction;
     actDevEdit        : TAction;
     actLogSave        : TAction;
     actLogClear       : TAction;
     actlMain          : TActionList;
     btLogClear        : TButton;
     btLogSave         : TButton;
     btChannelAdd      : TButton;
     btChannelClerList : TButton;
     btChanelStartAll  : TButton;
     btChannelCloseAll : TButton;
     btChennelDel      : TButton;
     cbLogDebug        : TCheckBox;
     cbLogInfo         : TCheckBox;
     cbLogWarn         : TCheckBox;
     cbLogError        : TCheckBox;
     cmbLogLineCount   : TComboBox;
     ImgListAct        : TImageList;
     lbChennelList     : TLabel;
     lbDeviceList      : TListBox;
     libChennelList    : TListBox;
     memLog            : TMemo;
     mmpiAddChennal    : TMenuItem;
     mmpiLogSave       : TMenuItem;
     mmpiLogClear      : TMenuItem;
     mmpiDevEdit       : TMenuItem;
     mmpiDevView       : TMenuItem;
     mmpiDevDel        : TMenuItem;
     mmpiDevClearList  : TMenuItem;
     mmpiDevAdd        : TMenuItem;
     mmDevEditDev      : TMenuItem;
     mppiEditChennal   : TMenuItem;
     mppiOpenChennal   : TMenuItem;
     mppiCloseChennal  : TMenuItem;
     mppiDelChennal    : TMenuItem;
     mmChannelDel      : TMenuItem;
     mmChannelOpen     : TMenuItem;
     mmChannelClose    : TMenuItem;
     mmChannelOpenAll  : TMenuItem;
     mmChannelStopAll  : TMenuItem;
     mmChannelDelAll   : TMenuItem;
     mmChannelAdd      : TMenuItem;
     mmChannels        : TMenuItem;
     mmLogSave         : TMenuItem;
     mmLogClear        : TMenuItem;
     mmLog             : TMenuItem;
     mmDevView         : TMenuItem;
     mmDevClearDevList : TMenuItem;
     mmDevDelDev       : TMenuItem;
     mmDevAddDev       : TMenuItem;
     mmExit            : TMenuItem;
     mmFileSaveConf    : TMenuItem;
     mmFileLoadConf    : TMenuItem;
     mmDevices         : TMenuItem;
     mmFiles           : TMenuItem;
     mMenu             : TMainMenu;
     odConf            : TOpenDialog;
     ppmLogOperations  : TPopupMenu;
     ppmDevOperations  : TPopupMenu;
     ppmChennalOperations : TPopupMenu;
     scrbChennelParams : TScrollBox;
     sdConf            : TSaveDialog;
     sdLog             : TSaveDialog;
     sbMainClientSpace : TScrollBox;
     Splitter1         : TSplitter;
     StatusBar1        : TStatusBar;
     tbMain            : TToolBar;
     tbFileLoadConf    : TToolButton;
     tbFileSaveConf    : TToolButton;
     tbFileExit        : TToolButton;
     tbSepor1          : TToolButton;
     tbDevAddDev       : TToolButton;
     tbDevDelDev       : TToolButton;
     tbDevClearDevList : TToolButton;
     tbSplitter2       : TToolButton;
     tbLogSave         : TToolButton;
     tbLogClear        : TToolButton;
     tbSplitter3       : TToolButton;
     tbChannelAdd      : TToolButton;
     tbChamnnelDel     : TToolButton;
     tbChannelClose    : TToolButton;
     tbChannelOpen     : TToolButton;
     tbChannelDelAll   : TToolButton;
     tbChannelCloseAll : TToolButton;
     tbChannelOpenAll  : TToolButton;
     tbDevEditDev      : TToolButton;
     tbDevViewDev      : TToolButton;
     procedure actChennelAddExecute(Sender: TObject);
     procedure actChennelCloseAllExecute(Sender: TObject);
     procedure actChennelCloseExecute(Sender: TObject);
     procedure actChennelDelAllExecute(Sender: TObject);
     procedure actChennelDelExecute(Sender: TObject);
     procedure actChennelEditExecute(Sender : TObject);
     procedure actChennelOpenAllExecute(Sender: TObject);
     procedure actChennelOpenExecute(Sender: TObject);
     procedure actDevAddExecute(Sender : TObject);
     procedure actDevClearListExecute(Sender : TObject);
     procedure actDevDelExecute(Sender : TObject);
     procedure actDevEditExecute(Sender : TObject);
     procedure actDevViewExecute(Sender : TObject);
     procedure actExitExecute(Sender : TObject);
     procedure actFileLoadConfExecute(Sender : TObject);
     procedure actFileSaveConfExecute(Sender : TObject);
     procedure actLogClearExecute(Sender: TObject);
     procedure actLogSaveExecute(Sender: TObject);
     procedure cbLogDebugChange(Sender: TObject);
     procedure cbLogErrorChange(Sender: TObject);
     procedure cbLogInfoChange(Sender: TObject);
     procedure cbLogWarnChange(Sender: TObject);
     procedure cmbLogLineCountChange(Sender: TObject);
     procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
     procedure FormCreate(Sender: TObject);
     procedure FormShow(Sender: TObject);
     procedure lbDeviceListDblClick(Sender : TObject);
     procedure libChennelListSelectionChange(Sender : TObject; User : boolean);
     procedure memLogChange(Sender: TObject);
   private
     FDevArray     : TDeviceArray;
     FDevForms     : TDevFormArray;

     FIsConfModify : Boolean;
     FCSection     : TCriticalSection;
     FChenRSFrame  : TframeChennelRS;
     FChenTCPFrame : TframeChennelTCP;

     procedure ClearDevices;
     procedure ClearFrames;
     procedure ClearChennals;
     procedure Lock;
     procedure UnLock;
     procedure SetChennelFrame(AChennel : TChennelBase);
     procedure OnDevChangeProc(ASender : TObject);
   public
  end;

var frmMain: TfrmMain;

implementation

{$R *.lfm}

uses DeviceAdd,
     ChennelRSClasses, ChennelTCPClasses,
     formChennelAdd,
     formChennelTCPAdd, {$IFDEF UNIX }formChennelRSLinuxAdd,{$ELSE}formChennelRSWindowsAdd,{$ENDIF}
     ModbusEmuResStr, MBDefine,
     LoggerLazarusGtkApplication,
     LoggerItf,
     ExceptionsTypes,
     MBEmuLoaderClasses;

{ TfrmMain }

procedure TfrmMain.OnDevChangeProc(ASender : TObject);
begin
  FIsConfModify := True;
end;

procedure TfrmMain.actFileLoadConfExecute(Sender : TObject);
var TempLoader : TMBEmuLoader;
begin
  if FIsConfModify then // предварительно сохранить текущие изменения
   begin
    if MessageDlg(rsSaveConf1,rsLoader9,mtConfirmation,[mbOK, mbCancel],0) = mrOK then
     begin
      actFileSaveConfExecute(Self);
     end;
   end;

  if not odConf.Execute then Exit;

  TempLoader := TMBEmuLoader.Create(lbDeviceList.Items,@FDevArray,@FDevForms,libChennelList.Items,FCSection,@OnDevChangeProc);
  TempLoader.Logger := LoggerObj as IDLogger;
  try
   try
    TempLoader.LoadConfig(odConf.FileName);
    if libChennelList.Items.Count > 0 then libChennelList.ItemIndex := 0;
    if lbDeviceList.Items.Count >0 then lbDeviceList.ItemIndex := 0;
    FIsConfModify := False;
   except
    on E : Exception do
     begin
      LoggerObj.error(rsLoadConf1,Format(rsLoadConf2,[E.Message,odConf.FileName]));
     end;
   end;
  finally
   FreeAndNil(TempLoader);
  end;
  LoggerObj.info(rsLoadConf1,Format(rsLoadConf3,[odConf.FileName]));
end;

procedure TfrmMain.actFileSaveConfExecute(Sender : TObject);
var TempLoader : TMBEmuLoader;
begin
  if not sdConf.Execute then Exit;

  TempLoader := TMBEmuLoader.Create(lbDeviceList.Items,@FDevArray,@FDevForms,libChennelList.Items,FCSection,@OnDevChangeProc);
  TempLoader.Logger := LoggerObj as IDLogger;
  try
   try
    TempLoader.SaveConfig(sdConf.FileName);
    FIsConfModify := False;
   except
    on E : Exception do
     begin
      LoggerObj.error(rsSaveConf1,Format(rsSaveConf2,[E.Message,sdConf.FileName]));
     end;
   end;
  finally
   FreeAndNil(TempLoader);
  end;
  LoggerObj.info(rsSaveConf1,Format(rsSaveConf3,[sdConf.FileName]));
end;

procedure TfrmMain.actChennelAddExecute(Sender: TObject);
var TempFrm : TformChenAdd;
    TempIndex : Integer;
    TempRes  : TModalResult;
begin
  TempFrm := TformChenAdd.Create(Self);
  try
    TempFrm.Logger := LoggerObj as IDLogger;
    TempFrm.ChennelList := libChennelList.Items;
    TempFrm.DevArray := @FDevArray;
    TempRes := TempFrm.ShowModal;
    TempIndex := TempFrm.Tag;
  finally
   FreeAndNil(TempFrm);
  end;
  if TempRes <> mrOK then Exit;
  if TempIndex = -1 then Exit;
  libChennelList.ItemIndex := TempIndex;
  OnDevChangeProc(Self);
end;

procedure TfrmMain.actChennelDelExecute(Sender: TObject);
var TempChen : TObject;
    TempChenName : String;
begin
  if libChennelList.ItemIndex = -1 then
   begin
    libChennelList.SetFocus;
    raise Exception.Create(rsDelChannel1);
   end;
  TempChen := libChennelList.Items.Objects[libChennelList.ItemIndex];
  TempChenName := libChennelList.Items.Strings[libChennelList.ItemIndex];
  if not Assigned(TempChen) then Exit;
  libChennelList.Items.Objects[libChennelList.ItemIndex] := nil;
  libChennelList.Items.Delete(libChennelList.ItemIndex);
  FreeAndNil(TempChen);
  if libChennelList.Items.Count > 0 then libChennelList.ItemIndex := 0
   else libChennelList.ItemIndex := -1;
  LoggerObj.info(rsDelChannel2,Format(rsDelChannel3,[TempChenName]));
  OnDevChangeProc(Self);
end;

procedure TfrmMain.actChennelEditExecute(Sender : TObject);
var TempChen     : TChennelBase;
    TempChenName : String;
    TempForm     : TForm;
begin
  if libChennelList.ItemIndex = -1 then
   begin
    libChennelList.SetFocus;
    raise Exception.Create(rsDelChannel1);
   end;
  TempChen     := TChennelBase(libChennelList.Items.Objects[libChennelList.ItemIndex]);
  TempChenName := libChennelList.Items.Strings[libChennelList.ItemIndex];

  if TempChen.ClassType = TChennelTCP then
   begin
    TempForm := TfrmChennelTCPAdd.Create(nil);
    try
     TfrmChennelTCPAdd(TempForm).Logger        := LoggerObj as IDLogger;
     TfrmChennelTCPAdd(TempForm).IsChennalEdit := True;
     TfrmChennelTCPAdd(TempForm).ChennelList   := libChennelList.Items;
     TfrmChennelTCPAdd(TempForm).DevArray      := @FDevArray;
     TfrmChennelTCPAdd(TempForm).ChennalName   := TempChenName;
     TfrmChennelTCPAdd(TempForm).ChennalObj    := TempChen;

     TempForm.ShowModal;
     if TempForm.ModalResult = mrOK then
      begin
       libChennelList.Items.Strings[libChennelList.ItemIndex] := TfrmChennelTCPAdd(TempForm).ChennalName;
       if TempChen.Active then
        begin
         TempChen.Active := False;
         TempChen.Active := True;
        end;
       if Assigned(FChenTCPFrame) then FChenTCPFrame.UpdateChenInfo;
       OnDevChangeProc(Self);
      end;
    finally
     FreeAndNil(TempForm);
    end;
   end;

  if TempChen.ClassType = TChennelRS then
   begin
    TempForm := {$IFDEF UNIX}TfrmChennelRSAdd{$ELSE}TfrmChennelRSAddWin{$ENDIF}.Create(nil);
    try
     {$IFDEF UNIX}TfrmChennelRSAdd{$ELSE}TfrmChennelRSAddWin{$ENDIF}(TempForm).Logger         := LoggerObj as IDLogger;
     {$IFDEF UNIX}TfrmChennelRSAdd{$ELSE}TfrmChennelRSAddWin{$ENDIF}(TempForm).IsChennalEdit  := True;
     {$IFDEF UNIX}TfrmChennelRSAdd{$ELSE}TfrmChennelRSAddWin{$ENDIF}(TempForm).ChennelList    := libChennelList.Items;
     {$IFDEF UNIX}TfrmChennelRSAdd{$ELSE}TfrmChennelRSAddWin{$ENDIF}(TempForm).DevArray       := @FDevArray;
     {$IFDEF UNIX}TfrmChennelRSAdd{$ELSE}TfrmChennelRSAddWin{$ENDIF}(TempForm).ChennalName    := TempChenName;
     {$IFDEF UNIX}TfrmChennelRSAdd{$ELSE}TfrmChennelRSAddWin{$ENDIF}(TempForm).ChennalObj     := TempChen;

     TempForm.ShowModal;
     if TempForm.ModalResult = mrOK then
      begin
       libChennelList.Items.Strings[libChennelList.ItemIndex] := {$IFDEF UNIX}TfrmChennelRSAdd{$ELSE}TfrmChennelRSAddWin{$ENDIF}(TempForm).ChennalName;
       if TempChen.Active then
        begin
         TempChen.Active := False;
         TempChen.Active := True;
        end;
       if Assigned(FChenRSFrame) then FChenRSFrame.UpdateChenInfo;
       OnDevChangeProc(Self);
      end;
    finally
     FreeAndNil(TempForm);
    end;
   end;
end;

procedure TfrmMain.actChennelOpenExecute(Sender: TObject);
var TempChen  : TChennelBase;
    TempChenName : String;
begin
  if libChennelList.ItemIndex = -1 then
   begin
    libChennelList.SetFocus;
    raise Exception.Create(rsOpenChennel1);
   end;

  TempChen := TChennelBase(libChennelList.Items.Objects[libChennelList.ItemIndex]);
  if not Assigned(TempChen) then
   begin
    LoggerObj.info(rsOpenChennel2,'Канал не существует');
    Exit;
   end;

  TempChen.Active := True;
  TempChenName :=libChennelList.Items.Strings[libChennelList.ItemIndex];
  if TempChen.Active then LoggerObj.info(rsOpenChennel2,Format(rsOpenChennel3,[TempChenName]))
   else LoggerObj.info(rsOpenChennel2,Format(rsOpenChennel4,[TempChenName]));

  LoggerObj.debug(rsOpenChennel2,'6');
end;

procedure TfrmMain.actChennelCloseExecute(Sender: TObject);
var TempChen  : TChennelBase;
    TempChenName : String;
begin
  if libChennelList.ItemIndex = -1 then
   begin
    libChennelList.SetFocus;
    raise Exception.Create(rsCloseChennel1);
   end;
  TempChen := TChennelBase(libChennelList.Items.Objects[libChennelList.ItemIndex]);
  if not Assigned(TempChen) then Exit;
  TempChen.Active := False;
  TempChenName :=libChennelList.Items.Strings[libChennelList.ItemIndex];

  if TempChen.Active then LoggerObj.info(rsCloseChennel2,Format(rsCloseChennel3,[TempChenName]))
   else LoggerObj.info(rsCloseChennel2,Format(rsCloseChennel4,[TempChenName]));
end;

procedure TfrmMain.actChennelOpenAllExecute(Sender: TObject);
var TempChen  : TChennelBase;
    i, Count  : Integer;
begin
  Count := libChennelList.Items.Count-1;
  for i := 0 to Count do
   begin
    TempChen := TChennelBase(libChennelList.Items.Objects[i]);
    if not Assigned(TempChen) then Continue;
    TempChen.Active := True;
   end;
  LoggerObj.info(rsOpenChennelAll1,rsOpenChennelAll2);
end;

procedure TfrmMain.actChennelCloseAllExecute(Sender: TObject);
var TempChen  : TChennelBase;
    i, Count  : Integer;
begin
  Count := libChennelList.Items.Count-1;
  for i := 0 to Count do
   begin
    TempChen := TChennelBase(libChennelList.Items.Objects[i]);
    if not Assigned(TempChen) then Continue;
    TempChen.Active := False;
   end;
  LoggerObj.info(rsCloseChennelAll1,rsCloseChennelAll2);
end;

procedure TfrmMain.actChennelDelAllExecute(Sender: TObject);
var i, Count : Integer;
begin
  if Assigned(FChenRSFrame) then FChenRSFrame.Parent := nil;
  if Assigned(FChenTCPFrame) then FChenTCPFrame.Parent := nil;
  Count := libChennelList.Items.Count-1;
  if Count = -1 then Exit;
  for i := Count downto 0 do if Assigned(libChennelList.Items.Objects[i]) then libChennelList.Items.Objects[i].Free;
  libChennelList.ItemIndex := -1;
  libChennelList.Items.Clear;
  LoggerObj.info(rsDelChennelAll1,rsDelChennelAll2);
  OnDevChangeProc(Self);
end;

procedure TfrmMain.actLogClearExecute(Sender: TObject);
begin
  memLog.Lines.Clear;
end;

procedure TfrmMain.actLogSaveExecute(Sender: TObject);
begin
  if not sdLog.Execute then Exit;
  memLog.Lines.SaveToFile(sdLog.FileName);
end;

procedure TfrmMain.libChennelListSelectionChange(Sender : TObject; User : boolean);
var TempChen  : TChennelBase;
    TempIndex : Integer;
begin
  TempIndex := libChennelList.ItemIndex;
  if TempIndex = -1 then
   begin
    if Assigned(FChenRSFrame) then FChenRSFrame.Parent := nil;
    if Assigned(FChenTCPFrame) then FChenTCPFrame.Parent := nil;
    Exit;
   end;
  TempChen := TChennelBase(libChennelList.Items.Objects[TempIndex]);
  if not Assigned(TempChen) then Exit;
  SetChennelFrame(TempChen);
end;

procedure TfrmMain.SetChennelFrame(AChennel : TChennelBase);
begin
  if AChennel.ClassType = TChennelRS then
   begin
    if not Assigned(FChenRSFrame) then
     begin
      FChenRSFrame := TframeChennelRS.Create(Self);
      FChenRSFrame.btEdit.Action := actChennelEdit;
     end;
    if Assigned(FChenTCPFrame) then FChenTCPFrame.Parent := nil;
    FChenRSFrame.Chennel := AChennel;
    FChenRSFrame.Parent  := scrbChennelParams;
   end;

  if AChennel.ClassType = TChennelTCP then
   begin
    if not Assigned(FChenTCPFrame) then
     begin
      FChenTCPFrame := TframeChennelTCP.Create(Self);
      FChenTCPFrame.btEdit.Action := actChennelEdit;
     end;
    if Assigned(FChenRSFrame) then FChenRSFrame.Parent := nil;
    FChenTCPFrame.Chennel := AChennel;
    FChenTCPFrame.Parent  := scrbChennelParams;
   end;
end;

procedure TfrmMain.cbLogDebugChange(Sender: TObject);
begin
  LoggerObj.EnableDebug := cbLogDebug.Checked;
end;

procedure TfrmMain.cbLogErrorChange(Sender: TObject);
begin
  LoggerObj.EnableError := cbLogError.Checked;
end;

procedure TfrmMain.cbLogInfoChange(Sender: TObject);
begin
  LoggerObj.EnableInfo := cbLogInfo.Checked;
end;

procedure TfrmMain.cbLogWarnChange(Sender: TObject);
begin
  LoggerObj.EnableWarn := cbLogWarn.Checked;
end;

procedure TfrmMain.cmbLogLineCountChange(Sender: TObject);
begin
  OnDevChangeProc(Self);
end;

procedure TfrmMain.actDevAddExecute(Sender : TObject);
var TempAddForm : TfrmAddDevice;
    TempDevNum  : Integer;
    TempStr     : String;
begin
  TempAddForm := TfrmAddDevice.Create(Self);
  try
   if TempAddForm.ShowModal <> mrOK then Exit;
   TempDevNum := TempAddForm.speDevNumber.Value;

   if Assigned(FDevArray[TempDevNum]) then Exit;
   Lock;
   try
    TempStr := Format(rsDevAdd13,[TempDevNum]);

    FDevArray[TempDevNum] := TMBDevice.Create(nil);
    FDevArray[TempDevNum].DeviceNum := TempDevNum;
    FDevArray[TempDevNum].DefCoil    := Boolean(TempAddForm.cbCoilsDefValue.ItemIndex);
    FDevArray[TempDevNum].DefDiscret := Boolean(TempAddForm.cbDiscretDefValue.ItemIndex);
    FDevArray[TempDevNum].DefHolding := Word(TempAddForm.speHoldingDefValue.Value);
    FDevArray[TempDevNum].DefInput   := Word(TempAddForm.speInputDefValue.Value);

    if TempAddForm.cgFunctions.Checked[0] then // функция 1
     begin
      FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn01];
      FDevArray[TempDevNum].AddRegisters(rgCoils,0,10000);
      TempStr := Format(rsDevAdd14,[TempStr]);
     end;
    if TempAddForm.cgFunctions.Checked[1] then // функция 2
     begin
      FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn02];
      FDevArray[TempDevNum].AddRegisters(rgDiscrete,0,10000);
      TempStr := Format(rsDevAdd3,[TempStr]);
     end;
    if TempAddForm.cgFunctions.Checked[2] then // функция 3
     begin
      FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn03];
      FDevArray[TempDevNum].AddRegisters(rgHolding,0,10000);
      TempStr := Format(rsDevAdd4,[TempStr]);
     end;
    if TempAddForm.cgFunctions.Checked[3] then // функция 4
     begin
      FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn04];
      FDevArray[TempDevNum].AddRegisters(rgInput,0,10000);
      TempStr := Format(rsDevAdd5,[TempStr]);
     end;
    if TempAddForm.cgFunctions.Checked[4] then // функция 5
     begin
      FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn05];
      TempStr := Format(rsDevAdd6,[TempStr]);
      if not(fn01 in FDevArray[TempDevNum].DeviceFunctions) then
       begin
        FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn01];
        FDevArray[TempDevNum].AddRegisters(rgCoils,0,10000);
       end;
     end;
    if TempAddForm.cgFunctions.Checked[5] then // функция 6
     begin
      FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn06];
      TempStr := Format(rsDevAdd7,[TempStr]);
      if not(fn03 in FDevArray[TempDevNum].DeviceFunctions) then
       begin
        FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn03];
        FDevArray[TempDevNum].AddRegisters(rgHolding,0,10000);
       end;
     end;
    if TempAddForm.cgFunctions.Checked[6] then // функция 15
     begin
      FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn15];
      TempStr := Format(rsDevAdd8,[TempStr]);
      if not(fn01 in FDevArray[TempDevNum].DeviceFunctions) then
       begin
        FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn01];
        FDevArray[TempDevNum].AddRegisters(rgCoils,0,10000);
       end;
     end;
    if TempAddForm.cgFunctions.Checked[7] then // функция 16
     begin
      FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn16];
      TempStr := Format(rsDevAdd9,[TempStr]);
      if not(fn03 in FDevArray[TempDevNum].DeviceFunctions) then
       begin
        FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn03];
        FDevArray[TempDevNum].AddRegisters(rgHolding,0,10000);
       end;
     end;
    if TempAddForm.cgFunctions.Checked[8] then // функция 23
     begin
      FDevArray[TempDevNum].DeviceFunctions := FDevArray[TempDevNum].DeviceFunctions+[fn23];
      TempStr := Format(rsDevAdd10,[TempStr]);
     end;

    FDevArray[TempDevNum].InitializeDevice;

    FDevForms[TempDevNum] := TfrmDeviceView.Create(Self);
    FDevForms[TempDevNum].Logger      := LoggerObj as IDLogger;
    FDevForms[TempDevNum].CSection    := FCSection;
    FDevForms[TempDevNum].Device      := FDevArray[TempDevNum];
    FDevForms[TempDevNum].OnDevChange := @OnDevChangeProc;

    LoggerObj.info(rsDevAdd11,Format(rsDevAdd12,[TempStr]));
   finally
    UnLock;
   end;
   TempDevNum := lbDeviceList.Items.AddObject(Format(rsDevAdd2,[TempDevNum]),FDevArray[TempDevNum]);
   lbDeviceList.ItemIndex := TempDevNum;
   OnDevChangeProc(Self);
  finally
    FreeAndNil(TempAddForm);
  end;
end;

procedure TfrmMain.actDevDelExecute(Sender : TObject);
var TempDev : TMBDevice;
begin
  if lbDeviceList.ItemIndex = -1 then Exit;
  TempDev := TMBDevice(lbDeviceList.Items.Objects[lbDeviceList.ItemIndex]);

  FDevForms[TempDev.DeviceNum].Free;
  FDevForms[TempDev.DeviceNum] := nil;

  lbDeviceList.Items.Objects[lbDeviceList.ItemIndex] := nil;
  lbDeviceList.Items.Delete(lbDeviceList.ItemIndex);
  if lbDeviceList.Items.Count > 0 then lbDeviceList.ItemIndex := 0;
  Lock;
  try
   FDevArray[TempDev.DeviceNum] := nil;
   FreeAndNil(TempDev);
  finally
   UnLock;
  end;
  OnDevChangeProc(Self);
end;

procedure TfrmMain.actDevEditExecute(Sender : TObject);
var TempDev     : TMBDevice;
    TempAddForm : TfrmAddDevice;
    OldCaption  : String;
    TempIndex   : Integer;
    TempForm    : TfrmDeviceView;
begin
  if lbDeviceList.ItemIndex = -1 then Exit;
  TempIndex := lbDeviceList.ItemIndex;
  TempDev := TMBDevice(lbDeviceList.Items.Objects[TempIndex]);
  if not Assigned(TempDev) then Exit;
  TempAddForm := TfrmAddDevice.Create(Self);
  try
   OldCaption := lbDeviceList.Items.Strings[TempIndex];
   TempAddForm.Caption := actDevEdit.Caption;

   TempAddForm.speDevNumber.Value := TempDev.DeviceNum;
   if fn01 in TempDev.DeviceFunctions then TempAddForm.cgFunctions.Checked[0] := True
    else TempAddForm.cgFunctions.Checked[0] := False;

   if fn02 in TempDev.DeviceFunctions then TempAddForm.cgFunctions.Checked[1] := True
    else TempAddForm.cgFunctions.Checked[1] := False;

   if fn03 in TempDev.DeviceFunctions then TempAddForm.cgFunctions.Checked[2] := True
    else TempAddForm.cgFunctions.Checked[2] := False;

   if fn04 in TempDev.DeviceFunctions then TempAddForm.cgFunctions.Checked[3] := True
    else TempAddForm.cgFunctions.Checked[3] := False;

   if fn05 in TempDev.DeviceFunctions then TempAddForm.cgFunctions.Checked[4] := True
    else TempAddForm.cgFunctions.Checked[4] := False;

   if fn06 in TempDev.DeviceFunctions then TempAddForm.cgFunctions.Checked[5] := True
    else TempAddForm.cgFunctions.Checked[5] := False;

   if fn15 in TempDev.DeviceFunctions then TempAddForm.cgFunctions.Checked[6] := True
    else TempAddForm.cgFunctions.Checked[6] := False;

   if fn16 in TempDev.DeviceFunctions then TempAddForm.cgFunctions.Checked[7] := True
    else TempAddForm.cgFunctions.Checked[7] := False;

   if fn23 in TempDev.DeviceFunctions then TempAddForm.cgFunctions.Checked[8] := True
    else TempAddForm.cgFunctions.Checked[8] := False;

   if TempDev.DefCoil then TempAddForm.cbCoilsDefValue.ItemIndex := 1
    else TempAddForm.cbCoilsDefValue.ItemIndex := 0;

   if TempDev.DefDiscret then TempAddForm.cbDiscretDefValue.ItemIndex := 1
    else TempAddForm.cbDiscretDefValue.ItemIndex := 0;

   TempAddForm.speHoldingDefValue.Value := TempDev.DefHolding;
   TempAddForm.speInputDefValue.Value   := TempDev.DefInput;

   if TempAddForm.ShowModal <> mrOK then Exit;
   Lock;
   try
    TempForm := FDevForms[TempDev.DeviceNum];
    if TempAddForm.speDevNumber.Value <> TempDev.DeviceNum then // изменен номер устройства
     begin
       if Assigned(FDevArray[TempAddForm.speDevNumber.Value]) then raise EAddDevAlreadyExists.Create(TempAddForm.speDevNumber.Value);
       lbDeviceList.Items.Strings[TempIndex] := Format(rsDevAdd2,[TempAddForm.speDevNumber.Value]);
       FDevForms[TempDev.DeviceNum] := nil;
       FDevArray[TempDev.DeviceNum] := nil;
       TempDev.DeviceNum := TempAddForm.speDevNumber.Value;
       FDevArray[TempAddForm.speDevNumber.Value] := TempDev;
       FDevForms[TempAddForm.speDevNumber.Value] := TempForm;
     end;

    TempDev.DefCoil    := Boolean(TempAddForm.cbCoilsDefValue.ItemIndex);
    TempDev.DefDiscret := Boolean(TempAddForm.cbDiscretDefValue.ItemIndex);
    TempDev.DefHolding := TempAddForm.speHoldingDefValue.Value;
    TempDev.DefInput   := TempAddForm.speInputDefValue.Value;

    if TempAddForm.cgFunctions.Checked[0] then // установлена функция 1
     begin
      if not (fn01 in TempDev.DeviceFunctions) then  // новая функция
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn01];
        TempDev.AddRegisters(rgCoils,0,10000);
        TempDev.InitializeCoils;
       end;
     end
    else
     begin // снята функция
      if fn01 in TempDev.DeviceFunctions then
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions - [fn01];
        TempDev.ClearCoils;
       end;
     end;

    if TempAddForm.cgFunctions.Checked[1] then // установлена функция 2
     begin
      if not (fn02 in TempDev.DeviceFunctions) then  // новая функция
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn02];
        TempDev.AddRegisters(rgDiscrete,0,10000);
        TempDev.InitializeDiscrets;
       end;
     end
    else
     begin // снята функция
      if fn02 in TempDev.DeviceFunctions then
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions - [fn02];
        TempDev.ClearDiscrets;
       end;
     end;

    if TempAddForm.cgFunctions.Checked[2] then // установлена функция 3
     begin
      if not (fn03 in TempDev.DeviceFunctions) then  // новая функция
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn03];
        TempDev.AddRegisters(rgHolding,0,10000);
        TempDev.InitializeHoldings;
       end;
     end
    else
     begin // снята функция
      if fn03 in TempDev.DeviceFunctions then
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions - [fn03];
        TempDev.ClearHoldings;
       end;
     end;

    if TempAddForm.cgFunctions.Checked[3] then // установлена функция 4
     begin
      if not (fn04 in TempDev.DeviceFunctions) then  // новая функция
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn04];
        TempDev.AddRegisters(rgInput,0,10000);
        TempDev.InitializeInputs;
       end;
     end
    else
     begin // снята функция
      if fn04 in TempDev.DeviceFunctions then
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions - [fn04];
        TempDev.ClearInputs;
       end;
     end;

    if TempAddForm.cgFunctions.Checked[4] then // установлена функция 5
     begin
      if not (fn05 in TempDev.DeviceFunctions) then  // новая функция
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn05];
        if TempDev.CoilCount = 0 then // если забыли добавить функцию чтения
         begin
          TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn01];
          TempDev.AddRegisters(rgCoils,0,10000);
          TempDev.InitializeCoils;
         end;
       end;
     end
    else
     begin // снята функция
      if fn05 in TempDev.DeviceFunctions then TempDev.DeviceFunctions := TempDev.DeviceFunctions - [fn05];
     end;

    if TempAddForm.cgFunctions.Checked[5] then // установлена функция 6
     begin
      if not (fn06 in TempDev.DeviceFunctions) then  // новая функция
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn06];
        if TempDev.HoldingCount = 0 then // если забыли добавить функцию чтения
         begin
          TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn03];
          TempDev.AddRegisters(rgHolding,0,10000);
          TempDev.InitializeHoldings;
         end;
       end;
     end
    else
     begin // снята функция
      if fn06 in TempDev.DeviceFunctions then TempDev.DeviceFunctions := TempDev.DeviceFunctions - [fn06];
     end;

    if TempAddForm.cgFunctions.Checked[6] then // установлена функция 15
     begin
      if not (fn15 in TempDev.DeviceFunctions) then  // новая функция
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn15];
        if TempDev.CoilCount = 0 then // если забыли добавить функцию чтения
         begin
          TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn01];
          TempDev.AddRegisters(rgCoils,0,10000);
          TempDev.InitializeCoils;
         end;
       end;
     end
    else
     begin // снята функция
      if fn15 in TempDev.DeviceFunctions then TempDev.DeviceFunctions := TempDev.DeviceFunctions - [fn15];
     end;

    if TempAddForm.cgFunctions.Checked[7] then // установлена функция 16
     begin
      if not (fn16 in TempDev.DeviceFunctions) then  // новая функция
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn16];
        if TempDev.HoldingCount = 0 then // если забыли добавить функцию чтения
         begin
          TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn03];
          TempDev.AddRegisters(rgHolding,0,10000);
          TempDev.InitializeHoldings;
         end;
       end;
     end
    else
     begin // снята функция
      if fn16 in TempDev.DeviceFunctions then TempDev.DeviceFunctions := TempDev.DeviceFunctions - [fn16];
     end;

    if TempAddForm.cgFunctions.Checked[8] then // установлена функция 23
     begin
      if not (fn23 in TempDev.DeviceFunctions) then  // новая функция
       begin
        TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn23];
        if TempDev.HoldingCount = 0 then // если забыли добавить функцию чтения
         begin
          TempDev.DeviceFunctions := TempDev.DeviceFunctions + [fn03];
          TempDev.AddRegisters(rgHolding,0,10000);
          TempDev.InitializeHoldings;
         end;
       end;
     end
    else
     begin // снята функция
      if fn23 in TempDev.DeviceFunctions then TempDev.DeviceFunctions := TempDev.DeviceFunctions - [fn23];
     end;

    TempForm.Device := TempDev;

    OnDevChangeProc(Self);

    if TempDev.DeviceFunctions = [] then raise ENeitherFunctioIsNotSet.Create;

    LoggerObj.info(rsDevEdit2, Format(rsDevEdit1,[OldCaption]));

   finally
    UnLock;
   end;
  finally
   FreeAndNil(TempAddForm);
  end;
end;

procedure TfrmMain.actDevViewExecute(Sender : TObject);
var TempDev : TMBDevice;
begin
  if lbDeviceList.ItemIndex = -1 then Exit;

  TempDev := TMBDevice(lbDeviceList.Items.Objects[lbDeviceList.ItemIndex]);

  FDevForms[TempDev.DeviceNum].Show;
end;

procedure TfrmMain.actDevClearListExecute(Sender : TObject);
begin
  lbDeviceList.Clear;
  ClearDevices;
  OnDevChangeProc(Self);
end;

procedure TfrmMain.ClearDevices;
var i : Integer;
begin
 Lock;
 try
  for i := 0 to 255 do
   begin
    if Assigned(FDevForms[i]) then
     begin
      FDevForms[i].Free;
      FDevForms[i] := nil;
     end;
    if Assigned(FDevArray[i]) then
     begin
      FDevArray[i].Free;
      FDevArray[i] := nil;
     end;
   end;

  OnDevChangeProc(Self);
 finally
  UnLock;
 end;
end;

procedure TfrmMain.ClearFrames;
begin
  if Assigned(FChenTCPFrame) then
   begin
    FChenTCPFrame.Chennel := nil;
    FChenTCPFrame.Parent := nil;
    FreeAndNil(FChenTCPFrame);
   end;
  if Assigned(FChenRSFrame) then
   begin
    FChenRSFrame.Chennel := nil;
    FChenRSFrame.Parent := nil;
    FreeAndNil(FChenRSFrame);
   end;
end;

procedure TfrmMain.ClearChennals;
begin
  actChennelDelAll.Execute;
end;

procedure TfrmMain.Lock;
begin
  FCSection.Enter;
end;

procedure TfrmMain.UnLock;
begin
  FCSection.Leave;
end;

procedure TfrmMain.actExitExecute(Sender : TObject);
begin
  Close;
end;

procedure TfrmMain.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  if FIsConfModify then // предварительно сохранить текущие изменения
   begin
    if MessageDlg(rsSaveConf1,rsLoader9,mtConfirmation,[mbOK, mbCancel],0) = mrOK then
     begin
      actFileSaveConfExecute(Self);
     end;
   end;

  ClearChennals;
  ClearFrames;
  ClearDevices;
  FreeAndNil(FCSection);
  CloseAction := caFree;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FCSection := TCriticalSection.Create;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  LoggerObj.LoggerStrings := memLog.Lines;
  LoggerObj.EnableInfo    := cbLogInfo.Checked;
  LoggerObj.EnableWarn    := cbLogWarn.Checked;
  LoggerObj.EnableError   := cbLogError.Checked;
  LoggerObj.EnableDebug   := cbLogDebug.Checked;
end;

procedure TfrmMain.lbDeviceListDblClick(Sender : TObject);
begin
  actDevViewExecute(Self);
end;

procedure TfrmMain.memLogChange(Sender: TObject);
begin
  if memLog.Lines.Count <= StrToInt(cmbLogLineCount.Items[cmbLogLineCount.ItemIndex]) then Exit;
  memLog.Lines.Delete(0);
end;

end.

