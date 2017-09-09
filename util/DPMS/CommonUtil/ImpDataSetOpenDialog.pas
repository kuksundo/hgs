// TImpDataSetOpenDialog   by Jeehoon Imp Park
//   누구나, 어떤 목적으로든 자유롭게 사용할 수 있으나,
//   원저작자인 박지훈.임프 외에는 누구도 다른 커뮤니티, 자료실 등 공개적인 곳에 배포할 수 없습니다.
//   You can use this freely for any purpose,
//   but can not distribute this file to any other public sites.

unit ImpDataSetOpenDialog;

interface

uses
  Classes, SysUtils, Windows, Messages, Controls, Forms, StdCtrls, ExtCtrls, DB;

const
  WM_DIALOGEXECUTE = WM_USER + 101;
  WM_EXECUTETHREADS = WM_USER + 102;

type
  TImpDataSetOpenForm = class;
  TDataSetCollection = class;

  TImpDataSetOpenDialog = class(TComponent)
  private
    FDataSets: TDataSetCollection;
    FTitle: string;
    FForm: TImpDataSetOpenForm;
    FOnDataSetOpen: TDataSetNotifyEvent;
    FShowHideButton: boolean;
    FShowCaption: boolean;
    procedure SetDataSets(const Value: TDataSetCollection);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute(ADataSet: TDataSet=nil; ATitle: string='');
    procedure CloseAll;
  published
    property DataSets: TDataSetCollection read FDataSets write SetDataSets;
    property Title: string read FTitle write FTitle;
    property ShowHideButton: boolean read FShowHideButton write FShowHideButton default false;
    property ShowCaption: boolean read FShowCaption write FShowCaption default false;
    property OnDataSetOpen: TDataSetNotifyEvent read FOnDataSetOpen write FOnDataSetOpen;

  end;

  TImpDataSetThread = class;

  TDataSetItem = class(TCollectionItem)
  private
    FOwner: TDataSetCollection;
    FDataSet: TDataSet;
    FEnabled: boolean;
    FThread: TImpDataSetThread;
    FTitle: string;
    FPriority: integer;
    procedure SetDataSet(const Value: TDataSet);
    procedure SetPriority(const Value: integer);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(AOwner: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property Enabled: boolean read FEnabled write FEnabled default true;
    property Title: string read FTitle write FTitle;
    property Priority: integer read FPriority write SetPriority default 0;
  end;

  TDataSetCollection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TDataSetItem;
    procedure SetItem(Index: Integer; Value: TDataSetItem);
  protected
  public
    FOwnerDialog: TImpDataSetOpenDialog;
    constructor Create(AOwner: TImpDataSetOpenDialog);
    procedure AddDataSet(ADataSet: TDataSet; AEnabled: boolean=true; APriority: integer=0; ATitle: string='');
    procedure DeleteDataSet(ADataSet: TDataSet);
    property Items[Index: Integer]: TDataSetItem read GetItem write SetItem; default;
  end;

  TImpDataSetOpenForm = class(TForm)
  private
    FOwnerDialog: TImpDataSetOpenDialog;
    FActiveCount: integer;
    lblMessage: TLabel;
    lblTime: TLabel;
    FTimer: TTimer;
    StartTime: TTime;
    FOnlyDataSet: TDataSet;
    FOpenTitle: string;
    FThread: TImpDataSetThread;
    FMinPriority, FMaxPriority, FCurPriority: integer;
    ExceptionMessages: TStringList;
    IsFormModal: boolean;
    procedure FTimerTimer(Sender: TObject);
    procedure HideClick(Sender: TObject);
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMDialogExecute(var Msg: TMessage); message WM_DIALOGEXECUTE;
    procedure WMExecuteThreads(var Msg: TMessage); message WM_EXECUTETHREADS;
  protected
    procedure Activate; override;
    procedure ThreadTerminated(ADataSet: TDataSet; bSucceeded: boolean);
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor CreateNew(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
    function ShowFormModal(ModalParent: TCustomForm): integer;
    procedure Close;
    function CloseQuery: boolean; override;
  end;

  TImpDataSetThread = class(TThread)
  private
    FOwnerDialogComp: TImpDataSetOpenDialog;
    FDataSet: TDataSet;
    FExceptionMessage: string;
    procedure DoSuccess;
    procedure DoException;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwnerDialogComp: TImpDataSetOpenDialog; ADataSet: TDataSet);
  end;

procedure Register;

implementation

uses Dialogs;

const
  sTitle = ' 가져오기';
  sMessage = ' 데이터를 가져오는 중입니다.';
  sTimeProgress = ' 진행중...';

procedure Register;
begin
  RegisterComponents('Samples', [TImpDataSetOpenDialog]);
end;

{ TImpDataSetOpenDialog }

constructor TImpDataSetOpenDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //FDataSet := nil;
  FDataSets := TDataSetCollection.Create(self);
  FShowHideButton := false;
  FShowCaption := false;
end;

destructor TImpDataSetOpenDialog.Destroy;
begin
  FDataSets.Free;
  inherited Destroy;
end;

procedure TImpDataSetOpenDialog.CloseAll;
var
  I: integer;
begin
  for I:=0 to FDataSets.Count-1 do
    if Assigned(FDataSets.Items[I].DataSet) and FDataSets.Items[I].DataSet.Active then
      FDataSets.Items[I].DataSet.Close;
end;

procedure TImpDataSetOpenDialog.Execute(ADataSet: TDataSet; ATitle: string);

  function GetParentForm: TCustomForm;
  var
    Comp: TComponent;
    Control: TControl;
  begin
    Comp := self;
    while (Comp<>nil) and not(Comp is TControl) do
      Comp := Comp.Owner;
    if Comp = nil then
      result := nil
    else
    begin
      Control := TControl(Comp);
      if Control is TCustomForm then
        result := TCustomForm(Control)
      else
      begin
        Control := Control.Parent;
        while (Control<>nil) and not(Control is TCustomForm) do
          Control := Control.Parent;
        if Control = nil then result := nil
        else                  result := TCustomForm(Control);
      end;
    end;
  end;

var
  I, iCnt: integer;
  ModalParent: TCustomForm;
begin
  if ATitle<>'' then FTitle := ATitle;
  if Assigned(ADataSet) then
    ADataSet.DisableControls
  else
  begin
    iCnt := 0;
    for I:=0 to FDataSets.Count-1 do
      if FDataSets.Items[I].Enabled and Assigned(FDataSets.Items[I].DataSet) then
      begin
        FDataSets.Items[I].DataSet.DisableControls;
        Inc(iCnt);
      end;
    if iCnt = 0 then exit;
  end;
  FForm := TImpDataSetOpenForm.CreateNew(self);
  with FForm do
    try
      FOnlyDataSet := ADataSet;
      FOpenTitle := FTitle;

      ModalParent := GetParentForm;
      if Assigned(ModalParent) then
        ShowFormModal(ModalParent)
      else
        ShowModal;
    finally
      if ExceptionMessages.Count > 0 then
        ShowMessage(ExceptionMessages.Text);
      Free;
      if Assigned(ADataSet) then
        ADataSet.EnableControls
      else
        for I:=0 to FDataSets.Count-1 do
          if FDataSets.Items[I].Enabled and Assigned(FDataSets.Items[I].DataSet) then
            FDataSets.Items[I].DataSet.EnableControls;
    end;
end;

procedure TImpDataSetOpenDialog.Notification(AComponent: TComponent; Operation: TOperation);
var
  I: integer;
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
    for I:=0 to FDataSets.Count-1 do
      if FDataSets.Items[I].FDataSet = AComponent then
      begin
        FDataSets.Items[I].FDataSet := nil;
        break;
      end;
end;

procedure TImpDataSetOpenDialog.SetDataSets(const Value: TDataSetCollection);
begin
  FDataSets.Assign(Value);
end;

{ TDataSetItem }

constructor TDataSetItem.Create(AOwner: TCollection);
begin
  inherited Create(AOwner);
  FOwner := TDataSetCollection(AOwner);
  FDataSet := nil;
  FEnabled := true;
  FTitle := '';
  FPriority := 0;
end;

destructor TDataSetItem.Destroy;
begin
  inherited Destroy;
end;

function TDataSetItem.GetDisplayName: string;
begin
  if Assigned(FDataSet) then result := FDataSet.Name
  else                       result := inherited GetDisplayName;
end;

procedure TDataSetItem.Assign(Source: TPersistent);
var
  SrcDataSetItem: TDataSetItem;
begin
  if Source is TDataSetItem then
  begin
    SrcDataSetItem := TDataSetItem(Source);
    DataSet := SrcDataSetItem.DataSet;
  end;
end;

procedure TDataSetItem.SetDataSet(const Value: TDataSet);

  procedure CheckForDuplicated;
  var
    I: integer;
  begin
    with FOwner do
      for I:=0 to Count-1 do
        if Items[I].FDataSet = Value then
          raise Exception.Create(Value.Name + ' 데이터셋은 이미 리스트에 있습니다.');
  end;

begin
  if FDataSet = Value then exit;
  CheckForDuplicated;
  if Assigned(FDataSet) then
    FDataSet.RemoveFreeNotification(FOwner.FOwnerDialog);
  FDataSet := Value;
  if Assigned(FDataSet) then
    FDataSet.FreeNotification(FOwner.FOwnerDialog);
end;

procedure TDataSetItem.SetPriority(const Value: integer);
begin
  if (FPriority = Value) or (Value < 0) then exit;
  FPriority := Value;
end;

{ TDataSetCollection }

constructor TDataSetCollection.Create(AOwner: TImpDataSetOpenDialog);
begin
  inherited Create(AOwner, TDataSetItem);
  FOwnerDialog := AOwner;
end;

procedure TDataSetCollection.AddDataSet(ADataSet: TDataSet; AEnabled: boolean; APriority: integer; ATitle: string);
begin
  with TDataSetItem(Add) do
  begin
    DataSet := ADataSet;
    Enabled := AEnabled;
    Title := ATitle;
    Priority := APriority;
  end;
end;

procedure TDataSetCollection.DeleteDataSet(ADataSet: TDataSet);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].DataSet=ADataSet then
    begin
      Items[I].DataSet := nil;
      Delete(I);
      break;
    end;
end;

function TDataSetCollection.GetItem(Index: Integer): TDataSetItem;
begin
  result := TDataSetItem(inherited GetItem(Index));
end;

procedure TDataSetCollection.SetItem(Index: Integer; Value: TDataSetItem);
begin
  inherited SetItem(Index, Value);
end;

{ TImpDataSetOpenForm }

constructor TImpDataSetOpenForm.CreateNew(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  FOwnerDialog := TImpDataSetOpenDialog(AOwner);
  FOnlyDataSet := nil;
  FThread := nil;
  ExceptionMessages := TStringList.Create;

  ClientWidth  := 370;
  ClientHeight := 70;
  Position := poScreenCenter;
  BorderStyle := bsDialog;
  Font.Charset := HANGEUL_CHARSET;
  Font.Size := 8;
  Font.Name := 'Tahoma';
  Font.Style := [];

  lblMessage := TLabel.Create(self);
  lblMessage.Parent := self;
  lblMessage.setBounds(14, 15, 10, 10);

  lblTime := TLabel.Create(self);
  lblTime.Parent := self;
  lblTime.setBounds(14, 42, 10, 10);

  FTimer := TTimer.Create(self);
  FTimer.Interval := 200;
  FTimer.Enabled := false;
  FTimer.OnTimer := FTimerTimer;

  IsFormModal := false;

  if FOwnerDialog.ShowHideButton then
    with TButton.Create(self) do
    begin
      Parent := self;
      SetBounds(284, 35, 75, 25);
      Cancel := true;
      Caption := '숨기기';
      ModalResult := mrCancel;
      OnClick := HideClick;
    end;
end;

procedure TImpDataSetOpenForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WindowClass.Style := CS_NOCLOSE;
  if not FOwnerDialog.ShowCaption then
    Params.Style := (Params.Style or WS_POPUP) and not WS_DLGFRAME;
end;

destructor TImpDataSetOpenForm.Destroy;
begin
  ExceptionMessages.Free;
  inherited Destroy;
end;

procedure TImpDataSetOpenForm.Activate;
begin
  inherited Activate;
  Caption := FOpenTitle + sTitle;
  lblMessage.Caption := FOpenTitle + sMessage;
  lblTime.Caption := sTimeProgress;

  PostMessage(Handle, WM_DIALOGEXECUTE, 0, 0);
end;

// http://www.assu-assist.nl/pgg/417.shtml+showformmodal&hl=ko&ct=clnk&cd=3
function TImpDataSetOpenForm.ShowFormModal(ModalParent: TCustomForm): integer;
begin
  IsFormModal := true;
  try
    ModalParent.Enabled := false;
    Show;
    repeat
      Application.HandleMessage;
      if Application.Terminated then
        ModalResult := mrCancel;
    until ModalResult <> mrNone;
    result := ModalResult;
    ModalParent.Enabled := true;
    Close;
    //ModalParent.BringToFront;
  finally
    IsFormModal := false;
  end;
end;

procedure TImpDataSetOpenForm.WMSysCommand(var Message: TWMSysCommand);
begin
  if IsFormModal and ((Message.CmdType and $FFF0) = SC_CLOSE) then
    ModalResult := mrCancel
  else
    inherited;
end;

procedure TImpDataSetOpenForm.Close;
begin
  if IsFormModal and (ModalResult=mrNone) then ModalResult := mrCancel;
  inherited Close;
  FOwnerDialog.FForm := nil;
end;

function TImpDataSetOpenForm.CloseQuery: boolean;
begin
  result := FActiveCount=0;
end;

procedure TImpDataSetOpenForm.WMDialogExecute(var Msg: TMessage);
var
  I: integer;
begin
  if Assigned(FOnlyDataSet) then
  begin
    FActiveCount := 1;
    FMinPriority := 0;
    FMaxPriority := 0;
    FCurPriority := 0;
    FThread := TImpDataSetThread.Create(FOwnerDialog, FOnlyDataSet);
  end
  else
    with FOwnerDialog.DataSets do
    begin
      FActiveCount := 0;

      FMinPriority := High(Integer);
      FMaxPriority := 0;
      for I:=0 to Count-1 do
      begin
        if Items[I].Priority > FMaxPriority then FMaxPriority := Items[I].Priority;
        if Items[I].Priority < FMinPriority then FMinPriority := Items[I].Priority;
      end;
      FCurPriority := FMinPriority;
      PostMessage(self.Handle, WM_EXECUTETHREADS, 0, 0);
    end;
  StartTime := Time;
  FTimerTimer(FTimer);
  FTimer.Enabled := true;
end;

procedure TImpDataSetOpenForm.WMExecuteThreads(var Msg: TMessage);
var
  I: integer;
begin
  with FOwnerDialog.DataSets do
    for I:=0 to Count-1 do
      if (Items[I].Enabled) and Assigned(Items[I].FDataSet) and (Items[I].Priority=FCurPriority) then
      begin
        Inc(FActiveCount);
        Items[I].FThread := TImpDataSetThread.Create(FOwnerDialog, Items[I].FDataSet);
      end;
end;

procedure TImpDataSetOpenForm.ThreadTerminated(ADataSet: TDataSet; bSucceeded: boolean);
begin
  if Assigned(FOwnerDialog.FOnDataSetOpen) then
    FOwnerDialog.FOnDataSetOpen(ADataSet);
  Dec(FActiveCount);
  if FActiveCount=0 then
    if FCurPriority = FMaxPriority then
      ModalResult := mrOk
    else
    begin
      Inc(FCurPriority);
      PostMessage(self.Handle, WM_EXECUTETHREADS, 0, 0);
    end;
end;

procedure TImpDataSetOpenForm.FTimerTimer(Sender: TObject);
var
  Hour, Min, Sec, MSec: word;
  TimeStr: string;
begin
  DecodeTime(Now-StartTime, Hour, Min, Sec, MSec);
  TimeStr := '';
  if Hour > 0 then TimeStr := IntToStr(Hour) + '시간 ';
  if Min > 0 then TimeStr := TimeStr + IntToStr(Min) + '분 ';
  TimeStr := TimeStr + IntToStr(Sec) + '초';

  lblTime.Caption := TimeStr + STimeProgress;
  //lblTime.Caption := FormatDateTime('hh시간 n분 s초', PassedTime) + ' 진행중';
end;

procedure TImpDataSetOpenForm.HideClick(Sender: TObject);
begin
  FThread.Terminate; // Close;
end;

{ TImpDataSetThread }

constructor TImpDataSetThread.Create(AOwnerDialogComp: TImpDataSetOpenDialog; ADataSet: TDataSet);
begin
  inherited Create(false);
  FOwnerDialogComp := AOwnerDialogComp;
  FDataSet := ADataSet;
  FreeOnTerminate := true;
end;

procedure TImpDataSetThread.Execute;
begin
  try
    FDataSet.Open;
    Synchronize(DoSuccess);
  except
    on E: Exception do
    begin
      FExceptionMessage := E.Message;
      Synchronize(DoException);
    end;
  end;
end;

procedure TImpDataSetThread.DoSuccess;
begin
  if Assigned(FOwnerDialogComp) and Assigned(FOwnerDialogComp.FForm) then
    FOwnerDialogComp.FForm.ThreadTerminated(FDataSet, true);
end;

procedure TImpDataSetThread.DoException;
begin
  if Assigned(FOwnerDialogComp) and Assigned(FOwnerDialogComp.FForm) then
  begin
    FOwnerDialogComp.FForm.ThreadTerminated(FDataSet, false);
    FOwnerDialogComp.FForm.ExceptionMessages.Add(FExceptionMessage);
  end;
end;

end.
