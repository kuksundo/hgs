{ -----------------------------------------------------------------------------
  Unit Name:  dlgSelectDatabaseU
  Author: Tristan Marlow
  Purpose: Progress Dialog.

  ----------------------------------------------------------------------------
  Copyright (c) 2007 Tristan David Marlow
  Copyright (c) 2007 ABit Consulting
  All Rights Reserved

  This product is protected by copyright and distributed under
  licenses restricting copying, distribution and decompilation

  ----------------------------------------------------------------------------

  History: 19/04/2007 - First Release.
  26/04/2007 - Thread Timer for dialog updates

  ----------------------------------------------------------------------------- }
unit frmMySQLBackupU;

interface

uses
  ProcessTimerU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvProgressBar, JvExControls,
  JvWaitingGradient, StdCtrls, ExtCtrls, ImgList, JvBmpAnimator, Buttons,
  System.ImageList;

type
  TfrmMySQLBackup = class(TForm)
    pnlProgress: TPanel;
    lblCaption: TLabel;
    progressTotal: TJvProgressBar;
    lblTimeRemaining: TLabel;
    lblTimeElapsed: TLabel;
    imgProgress: TJvBmpAnimator;
    ImageListProgress: TImageList;
    btnCancel: TBitBtn;
    progressDatabase: TJvProgressBar;
    progressItem: TJvProgressBar;
    lblDatabaseProgress: TLabel;
    lblItemProgress: TLabel;
    imgMySQLLogo: TImage;
    Bevel1: TBevel;
    memoLog: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FCancelled: boolean;
    FProcessTimer: TProcessTimer;
    FLastUpdate: TDateTime;
  public
    procedure Show(ACaption: string); reintroduce;
    procedure TotalProgress(ASender: TObject; AProgress: integer;
      AMessage: string; var ACancel: boolean);
    procedure DatabaseProgress(ASender: TObject; AProgress: integer;
      AMessage: string; var ACancel: boolean);
    procedure ItemProgress(ASender: TObject; AProgress: integer;
      AMessage: string; var ACancel: boolean);
    procedure Log(ASender: TObject; AMessage: string);
    procedure Debug(ASender: TObject; AProcedure, AMessage: string);
    procedure Update; override;
    procedure UpdateTimeRemaining(AEstimatedTime, AElapsedTime: TDateTime);
  published
  end;

implementation

uses DateUtils;

{$R *.dfm}

procedure TfrmMySQLBackup.Show(ACaption: string);
begin
  FCancelled := False;
  FLastUpdate := 0;
  progressTotal.Position := 0;
  progressDatabase.Position := 0;
  progressItem.Position := 0;
  lblCaption.Caption := ACaption;
  lblDatabaseProgress.Caption := '';
  lblItemProgress.Caption := '';
  lblTimeRemaining.Caption := '';
  lblTimeElapsed.Caption := '';
  UpdateTimeRemaining(0, 0);
  FProcessTimer.Start(progressTotal.Max);
  inherited Show;
  Application.ProcessMessages;
end;

procedure TfrmMySQLBackup.Update;
begin
  inherited Update;
  Application.ProcessMessages;
end;

procedure TfrmMySQLBackup.FormCreate(Sender: TObject);
begin
  FProcessTimer := TProcessTimer.Create;
end;

procedure TfrmMySQLBackup.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FProcessTimer);
end;

procedure TfrmMySQLBackup.FormHide(Sender: TObject);
begin
  imgProgress.Active := False;
end;

procedure TfrmMySQLBackup.FormShow(Sender: TObject);
begin
  imgProgress.Active := True;
end;

procedure TfrmMySQLBackup.TotalProgress(ASender: TObject; AProgress: integer;
  AMessage: string; var ACancel: boolean);
begin
  if AMessage <> '' then
    lblCaption.Caption := AMessage + ' (' + IntToStr(AProgress) + '%)';
  // 05/05/2007 - FIX: Vista TProgressBar not completing issue
  // if (Win32MajorVersion = 6) then
  // begin
  // progressTotal.Position := AProgress + 2;
  // end;
  progressTotal.Position := AProgress;
  Application.ProcessMessages;
  FProcessTimer.UpdateProgress(AProgress);
  UpdateTimeRemaining(FProcessTimer.EstimatedTime, FProcessTimer.ElapsedTime);
  ACancel := FCancelled;
  Application.ProcessMessages;
end;

procedure TfrmMySQLBackup.DatabaseProgress(ASender: TObject; AProgress: integer;
  AMessage: string; var ACancel: boolean);
begin
  if AMessage <> '' then
    lblDatabaseProgress.Caption := AMessage + ' (' + IntToStr(AProgress) + '%)';
  // 05/05/2007 - FIX: Vista TProgressBar not completing issue
//  if (Win32MajorVersion = 6) then
//  begin
//    progressDatabase.Position := AProgress + 2;
//  end;
  progressDatabase.Position := AProgress;
  Application.ProcessMessages;
  ACancel := FCancelled;
  Application.ProcessMessages;
end;

procedure TfrmMySQLBackup.ItemProgress(ASender: TObject; AProgress: integer;
  AMessage: string; var ACancel: boolean);
begin
  if (progressItem.Position <> AProgress) or
    (SecondsBetween(Now, FLastUpdate) > 5) then
  begin
    if AMessage <> '' then
      lblItemProgress.Caption := AMessage + ' (' + IntToStr(AProgress) + '%)';
    // 05/05/2007 - FIX: Vista TProgressBar not completing issue
    // if (Win32MajorVersion = 6) then
    // begin
    // progressItem.Position := AProgress + 2;
    // end;
    progressItem.Position := AProgress;
    Application.ProcessMessages;
    UpdateTimeRemaining(FProcessTimer.EstimatedTime, FProcessTimer.ElapsedTime);
    ACancel := FCancelled;
    FLastUpdate := Now;
    Application.ProcessMessages;
  end;

end;

procedure TfrmMySQLBackup.Log(ASender: TObject; AMessage: string);
begin
  memoLog.Lines.Insert(0, AMessage);
  Application.ProcessMessages;
end;

procedure TfrmMySQLBackup.Debug(ASender: TObject; AProcedure, AMessage: string);
begin
  // Log(ASender, AProcedure + ': ' + AMessage);
end;

procedure TfrmMySQLBackup.btnCancelClick(Sender: TObject);
begin
  if (MessageDlg('Cancel backup?', mtWarning, [mbYes, mbOK], 0) = mrYes) then
  begin
    FCancelled := True;
  end;
end;

procedure TfrmMySQLBackup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  imgProgress.Active := False;
  FProcessTimer.Stop;
  Action := caFree;
end;

procedure TfrmMySQLBackup.UpdateTimeRemaining(AEstimatedTime,
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
