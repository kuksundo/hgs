{ -----------------------------------------------------------------------------
  Unit Name: frmAutoUpdateU
  Author: Tristan Marlow
  Purpose: Automatic update form

  Requires: AutoUpdateU

  ----------------------------------------------------------------------------
  Copyright (c) 2006 Tristan David Marlow
  Copyright (c) 2006 Little Earth Solutions
  All Rights Reserved

  This product is protected by copyright and distributed under
  licenses restricting copying, distribution and decompilation

  ----------------------------------------------------------------------------

  History: 01/01/2006 - First Release.

  ----------------------------------------------------------------------------- }
unit frmAutoUpdateU;

interface

uses
  ProcessTimerU, ProgramSettingsU, AutoUpdateU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, ActnList, jpeg,
  System.UITypes, System.Actions;

type
  TOnAutoUpdateMessage = procedure(ASender: TObject; AMessage: string)
    of object;

type
  TfrmAutoUpdate = class(TForm)
    pnlMain: TPanel;
    ActionListMain: TActionList;
    ActionCancel: TAction;
    pnlHeader: TPanel;
    imgHeader: TImage;
    pnlProgress: TPanel;
    lblStatus: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    ProgressBar: TProgressBar;
    Panel2: TPanel;
    lblTimeRemaining: TLabel;
    lblTimeElapsed: TLabel;
    btnCancel: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActionCancelExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure SetActive(AValue: boolean);
    function GetActive: boolean;
  private
    FOnUpdateMessage: TOnAutoUpdateMessage;
    FProgramSettings: TProgramSettings;
    FAutoUpdate: TAutoUpdate;
    FProcessTimer: TProcessTimer;
    procedure UpdateAvailable(ASender: TObject; AApplicationName, ANewVersion,
      AOldVersion: string; var AStartUpdate: boolean);
    procedure UpdateBegin(ASender: TObject);
    procedure UpdateProgress(ASender: TObject; AMessage: string;
      AProgress: integer; var ACancel: boolean);
    procedure UpdateMessage(ASender: TObject; AMessage: string);
    procedure UpdateEnd(ASender: TObject; ASuccess: boolean; AMessage: string;
      AUpdateFileName: TFileName; AUpdateParameters: string);
    procedure UpdateExecute(ASender: TObject; var AExecute: boolean;
      AUpdateFileName: TFileName; AUpdateParameters: string);
    procedure SetProgress(AMessage: string; AProgress: integer;
      var Cancel: boolean);
    procedure UpdateTimeRemaining(AEstimatedTime, AElapsedTime: TDateTime);
  public
    procedure CheckForUpdates;
  published
    property AutoUpdateEnabled: boolean Read GetActive Write SetActive;
    property ProgramSettings: TProgramSettings Read FProgramSettings
      Write FProgramSettings;
    property OnUpdateMessage: TOnAutoUpdateMessage read FOnUpdateMessage
      write FOnUpdateMessage;
  end;

implementation

{$R *.dfm}

uses DateUtils;

procedure TfrmAutoUpdate.SetActive(AValue: boolean);
begin
  if Assigned(FProgramSettings) then
  begin
    if FAutoUpdate.Active <> AValue then
    begin
      if AValue then
      begin
        FAutoUpdate.ProgramSettings := FProgramSettings;
        FAutoUpdate.LoadSettings;
        FAutoUpdate.Active := True;
      end
      else
      begin
        FAutoUpdate.Active := False;
        FAutoUpdate.ProgramSettings := nil;
      end;
    end;
  end
  else
  begin
    raise Exception.Create
      ('TfrmAutoUpdate: Property "ProgramSettings" has not been assigned.');
  end;
end;

function TfrmAutoUpdate.GetActive: boolean;
begin
  Result := FAutoUpdate.Active;
end;

procedure TfrmAutoUpdate.SetProgress(AMessage: string; AProgress: integer;
  var Cancel: boolean);
begin
  lblStatus.Caption := AMessage;
  ProgressBar.Position := AProgress;
  Application.ProcessMessages;
end;

procedure TfrmAutoUpdate.ActionCancelExecute(Sender: TObject);
begin
  FAutoUpdate.Cancel;
end;

procedure TfrmAutoUpdate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FProcessTimer.Stop;
end;

procedure TfrmAutoUpdate.FormCreate(Sender: TObject);
begin
  FProcessTimer := TProcessTimer.Create;
  FAutoUpdate := TAutoUpdate.Create(Self);
  with FAutoUpdate do
  begin
    OnUpdateAvailable := UpdateAvailable;
    OnUpdateBegin := UpdateBegin;
    OnUpdateProgress := UpdateProgress;
    OnUpdateEnd := UpdateEnd;
    OnUpdateExecute := UpdateExecute;
    OnLog := UpdateMessage;
  end;
end;

procedure TfrmAutoUpdate.FormDestroy(Sender: TObject);
begin
  with FAutoUpdate do
  begin
    Active := False;
  end;
  FreeAndNil(FAutoUpdate);
  FreeAndNil(FProcessTimer);
end;

procedure TfrmAutoUpdate.UpdateAvailable(ASender: TObject;
  AApplicationName, ANewVersion, AOldVersion: string;
  var AStartUpdate: boolean);
begin
  AStartUpdate := MessageDlg
    (Format('Version %s of "%s" is available, would you like to update now?',
    [ANewVersion, AApplicationName]), mtInformation, [mbYes, mbNo], 0) = mrYes;
  if AStartUpdate then
    Self.Show;
end;

procedure TfrmAutoUpdate.UpdateBegin(ASender: TObject);
begin
  FProcessTimer.Start(ProgressBar.Max);
end;

procedure TfrmAutoUpdate.UpdateProgress(ASender: TObject; AMessage: string;
  AProgress: integer; var ACancel: boolean);
begin
  Self.SetProgress(AMessage, AProgress, ACancel);
  FProcessTimer.UpdateProgress(AProgress);
  UpdateTimeRemaining(FProcessTimer.EstimatedTime, FProcessTimer.ElapsedTime);
end;

procedure TfrmAutoUpdate.UpdateMessage(ASender: TObject; AMessage: string);
begin
  if Assigned(FOnUpdateMessage) then
  begin
    FOnUpdateMessage(ASender, AMessage);
  end;
end;

procedure TfrmAutoUpdate.UpdateEnd(ASender: TObject; ASuccess: boolean;
  AMessage: string; AUpdateFileName: TFileName; AUpdateParameters: string);
begin
  if (not ASuccess) and (Trim(AMessage) <> '') then
  begin
    MessageDlg(AMessage, mtError, [mbOK], 0);
  end;
  Self.Hide;
end;

procedure TfrmAutoUpdate.UpdateExecute(ASender: TObject; var AExecute: boolean;
  AUpdateFileName: TFileName; AUpdateParameters: string);
begin
  AExecute := True;
end;

procedure TfrmAutoUpdate.CheckForUpdates;
begin
  if Assigned(FAutoUpdate) then
  begin
    FAutoUpdate.Execute;
  end;
end;

procedure TfrmAutoUpdate.UpdateTimeRemaining(AEstimatedTime,
  AElapsedTime: TDateTime);
var
  EstimatedTime: string;
  ElapsedTime: string;
begin
  if AEstimatedTime <> 0 then
  begin
    EstimatedTime := 'Estimated: ';
    if HourOf(AEstimatedTime) > 0 then
    begin
      if HourOf(AEstimatedTime) = 1 then
      begin
        EstimatedTime := EstimatedTime + FormatDateTime('h "hour "',
          AEstimatedTime);
      end
      else
      begin
        EstimatedTime := EstimatedTime + FormatDateTime('h "hours "',
          AEstimatedTime);
      end;
    end;
    if MinuteOf(AEstimatedTime) > 0 then
    begin
      if MinuteOf(AEstimatedTime) = 1 then
      begin
        EstimatedTime := EstimatedTime + FormatDateTime('n "minute "',
          AEstimatedTime);
      end
      else
      begin
        EstimatedTime := EstimatedTime + FormatDateTime('n "minutes "',
          AEstimatedTime);
      end;
    end;
    if (MinuteOf(AEstimatedTime) = 0) and (HourOf(AEstimatedTime) = 0) then
    begin
      EstimatedTime := 'Less than a minute...';
      // EstimatedTime := EstimatedTime + FormatDateTime('s "seconds "',AEstimatedTime);
    end;
  end
  else
  begin
    EstimatedTime := 'Calculating...';
  end;
  ElapsedTime := 'Elapsed: ';
  if HourOf(AElapsedTime) > 0 then
  begin
    ElapsedTime := ElapsedTime + FormatDateTime('h "hour(s) "', AElapsedTime);
  end;
  if MinuteOf(AElapsedTime) > 0 then
  begin
    ElapsedTime := ElapsedTime + FormatDateTime('n "minute(s) "', AElapsedTime);
  end;
  ElapsedTime := ElapsedTime + FormatDateTime('s "seconds "', AElapsedTime);
  lblTimeRemaining.Caption := EstimatedTime;
  lblTimeElapsed.Caption := ElapsedTime;
end;

end.
