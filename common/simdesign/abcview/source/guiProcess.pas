{ unit guiProcess

  A form showing the current processes and implementation of the process
  base class.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiProcess;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SyncObjs, ExtCtrls, StdCtrls, Buttons, ImgList, ComCtrls, ActnList,
  RXSpin, Contnrs, sdProcessThread, sdAbcTypes;

type

  // A form that displays a list of processes
  TfrmProcesses = class(TForm)
    tmrProcesses: TTimer;
    lvProcesses: TListView;
    ilProcesses: TImageList;
    btnStop: TBitBtn;
    btnPause: TBitBtn;
    btnCont: TBitBtn;
    BitBtn1: TBitBtn;
    btnOK: TBitBtn;
    lblProcesses: TLabel;
    ActionList1: TActionList;
    StopProcess: TAction;
    PauseProcess: TAction;
    ContProcess: TAction;
    Label1: TLabel;
    sbPriority: TRxSpinButton;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure tmrProcessesTimer(Sender: TObject);
    procedure lvProcessesData(Sender: TObject; Item: TListItem);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopProcessExecute(Sender: TObject);
    procedure PauseProcessExecute(Sender: TObject);
    procedure ContProcessExecute(Sender: TObject);
    procedure sbPriorityTopClick(Sender: TObject);
    procedure sbPriorityBottomClick(Sender: TObject);
  private
    FProcesses: TProcessList;
    function ActiveProcess: TProcess;
  public
    property Processes: TProcessList read FProcesses write FProcesses;
  end;

var
  frmProcesses: TfrmProcesses;

implementation

{$R *.DFM}

{ TfrmProcesses }

procedure TfrmProcesses.FormShow(Sender: TObject);
begin
  tmrProcesses.Enabled := True;
end;

procedure TfrmProcesses.FormHide(Sender: TObject);
begin
  tmrProcesses.Enabled := False;
end;

procedure TfrmProcesses.tmrProcessesTimer(Sender: TObject);
var
  i, ActiveCount: integer;
  EnableStop,
  EnablePause,
  EnableCont: boolean;
  Process: TProcess;
begin
  if not Visible then exit;
  // button states
  EnableStop := False;
  EnablePause := False;
  EnableCont := False;
  if assigned(FProcesses) then
  begin
    // We will check the list for updates
    if lvProcesses.Items.Count <> FProcesses.Count then
      lvProcesses.Items.Count := FProcesses.Count;

    // Label
    ActiveCount := 0;
    for i := 0 to FProcesses.Count - 1 do
      if FProcesses[i].Status = psRun then
        inc(ActiveCount);
    if FProcesses.Count = 0 then
      lblProcesses.Caption := 'No background processes'
    else
      lblProcesses.Caption := format('%d background processes (%d active)',
        [FProcesses.Count, ActiveCount]);

    // The control is made doublebuffered so we won't have flicker
    lvProcesses.Invalidate;
    for i := 0 to lvProcesses.Items.Count - 1 do
      if lvProcesses.Items[i].Selected then
      begin
        Process := FProcesses[i];
        if assigned(Process) then
          case Process.Status of
          psRun:
            begin
              EnableStop := True;
              EnablePause := True;
            end;
          psPaused:
            begin
              EnableStop := True;
              EnableCont := True;
            end;
          end;//case
      end;
  end;

  StopProcess.Enabled := EnableStop;
  PauseProcess.Enabled := EnablePause;
  ContProcess.Enabled := EnableCont;
end;

procedure TfrmProcesses.lvProcessesData(Sender: TObject; Item: TListItem);
var
  Process: TProcess;
begin
  if assigned(FProcesses) then
  begin
    Process := FProcesses[Item.Index];
    // Process name and status
    if assigned(Process) then
    begin
      Item.Caption := Process.Name;
      Item.ImageIndex := cStatusImage[Process.Status];
      Item.SubItems.Add(cStatusText[Process.Status]);
      Item.SubItems.Add(Process.Task);
      Item.SubItems.Add(cPrioText[Process.Priority]);
    end;
  end;
end;

procedure TfrmProcesses.btnOKClick(Sender: TObject);
begin
  Hide;
end;

procedure TfrmProcesses.FormCreate(Sender: TObject);
begin
  lvProcesses.DoubleBuffered := True;
end;

procedure TfrmProcesses.StopProcessExecute(Sender: TObject);
var
  i: integer;
begin
  // Try to stop the selected processes
  with lvProcesses do
    for i := 0 to Items.Count - 1 do
      if Items[i].Selected then
        if assigned(FProcesses) then with FProcesses do
          if assigned(Items[i]) then
            if (poAllowStop in Items[i].Options) then
              Items[i].Terminate
            else
              ShowMessage(format('Process %s cannot be stopped.', [Items[i].Name]));
end;

procedure TfrmProcesses.PauseProcessExecute(Sender: TObject);
var
  i: integer;
begin
  // Try to pause the selected processes
  with lvProcesses do
    for i := 0 to Items.Count - 1 do
      if Items[i].Selected then
        if assigned(FProcesses) then with FProcesses do
          if assigned(Items[i]) then
            if (poAllowPause in Items[i].Options) then
              Items[i].Status := psPausing
            else
              ShowMessage(format('Process %s cannot be paused.', [Items[i].Name]));
end;

procedure TfrmProcesses.ContProcessExecute(Sender: TObject);
var
  i: integer;
begin
  // Try to continue the selected processes
  with lvProcesses do
    for i := 0 to Items.Count - 1 do
      if Items[i].Selected then
        if assigned(FProcesses) then with FProcesses do
          if assigned(Items[i]) then
            Items[i].Status := psRun;
end;

procedure TfrmProcesses.sbPriorityTopClick(Sender: TObject);
var
  Process: TProcess;
begin
  Process := ActiveProcess;
  if not assigned(Process) then exit;
  // Priority up the selected processes
  if Process.Priority < tpHighest then
    Process.Priority := succ(Process.Priority);
end;

procedure TfrmProcesses.sbPriorityBottomClick(Sender: TObject);
var
  Process: TProcess;
begin
  Process := ActiveProcess;
  if not assigned(Process) then exit;
  // Priority down the selected processes
  if Process.Priority > tpLowest then
    Process.Priority := pred(Process.Priority);
end;

function TfrmProcesses.ActiveProcess: TProcess;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to lvProcesses.Items.Count - 1 do
    if lvProcesses.Items[i].Selected then
      if assigned(FProcesses) then
        Result := FProcesses[i];
end;

end.
