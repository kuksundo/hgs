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
unit frmFTPTransferU;

interface

uses
  SystemDetailsU, ProcessTimerU, PluginSettingsU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvProgressBar, JvExControls, JvComponent,
  JvWaitingGradient, StdCtrls, ExtCtrls, ImgList, JvBmpAnimator,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, System.UITypes, System.ImageList;

type
  TProgressStyle = (psNone, psNormal, psWaiting);

type
  TfrmFTPTransfer = class(TForm)
    pnlProgress: TPanel;
    lblCaption: TLabel;
    progressNormal: TJvProgressBar;
    lblTimeRemaining: TLabel;
    lblTimeElapsed: TLabel;
    imgProgress: TJvBmpAnimator;
    ImageListProgress: TImageList;
    IdFTP: TIdFTP;
    memoLog: TMemo;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure IdFTPWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdFTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdFTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
  private
    FWorkCountMax: Integer;
    FPluginSettings: TPluginSettings;
    FProcessTimer: TProcessTimer;
    procedure Log(AMessage: String);
    function FTPUploadFileList(AFileList: TStrings; AFTPServer: String;
      AFTPPort: Integer; AFTPRemotePath, AFTPUserName, AFTPPassword,
      AFTPUMASK: String; AFTPPassive: Boolean): Boolean;
    procedure Progress(AProgress: Integer; ACaption: String = '');
    procedure UpdateTimeRemaining(AEstimatedTime, AElapsedTime: TDateTime);
  public
    procedure FTPUpload(AProfileName: String; AZIPFiles: TStrings;
      ALogFileName: String);
  published
  end;

implementation

uses DateUtils;

{$R *.dfm}

procedure TfrmFTPTransfer.FTPUpload(AProfileName: String; AZIPFiles: TStrings;
  ALogFileName: String);
begin
  try
    with FPluginSettings do
    begin
      ProfileName := AProfileName;
      LoadSettings;
      if Enabled then
      begin
        try
          Self.Show;
          if not FTPUploadFileList(AZIPFiles, FTPServer, FTPPort, FTPRemotePath,
            FTPUsername, FTPPassword, FTPUMask, FTPPassive) then
          begin
            MessageDlg('FTP upload failed.', mtError, [mbOK], 0);
          end;
        finally
          Self.Hide;
        end;
      end;
    end;
  finally
  end;
end;

procedure TfrmFTPTransfer.Log(AMessage: String);
begin
  memoLog.Lines.Insert(0, AMessage);
  Application.ProcessMessages;
end;

function TfrmFTPTransfer.FTPUploadFileList(AFileList: TStrings;
  AFTPServer: String; AFTPPort: Integer; AFTPRemotePath, AFTPUserName,
  AFTPPassword, AFTPUMASK: String; AFTPPassive: Boolean): Boolean;
var
  FileIdx: Integer;
  OldFile, NewFile: String;
begin
  Result := False;
  with IdFTP do
  begin
    Host := AFTPServer;
    Port := AFTPPort;
    Passive := AFTPPassive;
    Username := AFTPUserName;
    Password := AFTPPassword;
    try
      Log(Format('Connecting to %s:%d...', [Host, Port]));
      IdFTP.Connect;
      if Connected then
      begin
        Log(Format('Directory %s', [AFTPRemotePath]));
        ChangeDir(AFTPRemotePath);
        if Length(AFTPUMASK) > 0 then
        begin
          Site('UMASK ' + AFTPUMASK); // 002
        end;
        Log(Format('Uploading %d file(s)', [AFileList.Count]));
        For FileIdx := 0 to Pred(AFileList.Count) do
        begin
          try
            OldFile := AFileList[FileIdx];
            NewFile := ExtractFileName(OldFile);
            if FileExists(OldFile) then
            begin
              Log(Format('Uploading %s -> %s', [OldFile, NewFile]));
              Progress(0, Format('Uploading %s', [NewFile]));
              Put(OldFile, NewFile);
              Result := True;
            end
            else
            begin
              Log(Format('Unable to locate %s', [OldFile]));
            end;
          except
            on E: Exception do
            begin
              Log('FTP Error: ' + E.Message);
            end;
          end;
        end;
        Progress(100, 'Upload Complete');
      end
      else
      begin
        Log('Connection failed.');
      end;
      // Quit;
      Disconnect;
    except
      on E: Exception do
      begin
        Log('FTP: ' + E.Message);
      end;
    end;
  end;
end;

procedure TfrmFTPTransfer.IdFTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  Progress(CalculatePercentage(AWorkCount, FWorkCountMax));
end;

procedure TfrmFTPTransfer.IdFTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  FProcessTimer.Start(100);
  FWorkCountMax := AWorkCountMax;
end;

procedure TfrmFTPTransfer.IdFTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  Progress(100);
  FProcessTimer.Stop;
end;

procedure TfrmFTPTransfer.FormCreate(Sender: TObject);
begin
  FProcessTimer := TProcessTimer.Create;
  FPluginSettings := TPluginSettings.Create;
  with FPluginSettings do
  begin
    RootKey := HKEY_CURRENT_USER;
    SettingsKey := APPLICATION_REGISTRY_STORAGE;
  end;
end;

procedure TfrmFTPTransfer.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FProcessTimer);
  FreeAndNil(FPluginSettings);
end;

procedure TfrmFTPTransfer.FormHide(Sender: TObject);
begin
  imgProgress.Active := False;
end;

procedure TfrmFTPTransfer.FormShow(Sender: TObject);
begin
  imgProgress.Active := True;
end;

procedure TfrmFTPTransfer.Progress(AProgress: Integer; ACaption: String = '');
begin
  if ACaption <> '' then
    lblCaption.Caption := ACaption;
  // 05/05/2007 - FIX: Vista TProgressBar not completing issue
  if GetWindowsVersion = osWinVista then
  begin
    progressNormal.Position := AProgress + 2;
  end;
  FProcessTimer.UpdateProgress(AProgress);
  UpdateTimeRemaining(FProcessTimer.EstimatedTime, FProcessTimer.ElapsedTime);
  progressNormal.Position := AProgress;
  Application.ProcessMessages;
end;

procedure TfrmFTPTransfer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  imgProgress.Active := False;
end;

procedure TfrmFTPTransfer.UpdateTimeRemaining(AEstimatedTime,
  AElapsedTime: TDateTime);
var
  EstimatedTime: String;
  ElapsedTime: String;
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
