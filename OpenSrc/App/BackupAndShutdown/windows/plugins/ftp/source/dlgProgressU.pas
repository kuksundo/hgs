{-----------------------------------------------------------------------------
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

-----------------------------------------------------------------------------}
unit dlgProgressU;

interface

uses
  SystemDetailsU, ProcessTimerU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvProgressBar, JvExControls, JvComponent,
  JvWaitingGradient, StdCtrls, ExtCtrls, ImgList, JvBmpAnimator;

type
  TProgressStyle = (psNone,psNormal,psWaiting);

type
  TdlgProgress = class(TForm)
    pnlProgress: TPanel;
    lblCaption: TLabel;
    progressWaiting: TJvWaitingGradient;
    progressNormal: TJvProgressBar;
    lblTimeRemaining: TLabel;
    lblTimeElapsed: TLabel;
    imgProgress: TJvBmpAnimator;
    ImageListProgress: TImageList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    FShowEstimatedTime : Boolean;
    FProcessTimer : TProcessTimer;
  public
    procedure Show(ACaption : String; AProgressStyle : TProgressStyle); reintroduce;
    procedure Progress(AProgress : Integer; ACaption : String = '');
    procedure Update; override;
    procedure UpdateTimeRemaining(AEstimatedTime, AElapsedTime : TDateTime);
  published
    property ShowEstimatedTime : Boolean read FShowEstimatedTime write FShowEstimatedTime;
  end;

implementation

uses DateUtils;

{$R *.dfm}

procedure TdlgProgress.Show(ACaption : String; AProgressStyle : TProgressStyle);
begin
  lblCaption.Caption := ACaption;
  lblTimeElapsed.Visible := False;
  lblTimeRemaining.Visible := False;
  progressWaiting.Visible := False;
  progressWaiting.Active := False;
  progressNormal.Visible := False;
  progressNormal.Position := 100;
  case AProgressStyle of
    psNone :
      begin
      end;
    psNormal :
      begin
        progressNormal.Visible := True;
        progressNormal.Position := 0;
        if FShowEstimatedTime then
          begin
            lblTimeElapsed.Visible := True;
            lblTimeRemaining.Visible := True;
            UpdateTimeRemaining(0,0);
            FProcessTimer.Start(progressNormal.Max);
          end;
      end;
    psWaiting :
      begin
        progressWaiting.Visible := True;
        progressWaiting.Active := True;
      end;
  end;
  inherited Show;
  Application.ProcessMessages;
end;

procedure TdlgProgress.Update;
begin
  inherited Update;
  Application.ProcessMessages;
end;

procedure TdlgProgress.FormCreate(Sender: TObject);
begin
   FProcessTimer := TProcessTimer.Create;
end;

procedure TdlgProgress.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FProcessTimer);
end;

procedure TdlgProgress.FormHide(Sender: TObject);
begin
  imgProgress.Active := False;
end;

procedure TdlgProgress.FormShow(Sender: TObject);
begin
  imgProgress.Active := True;
end;

procedure TdlgProgress.Progress(AProgress : Integer; ACaption : String = '');
begin
  if ACaption <> '' then lblCaption.Caption := ACaption;
  // 05/05/2007 - FIX: Vista TProgressBar not completing issue
  if GetWindowsVersion = osWinVista then
    begin
      progressNormal.Position := AProgress + 2;
    end;
  if FShowEstimatedTime then
    begin
      FProcessTimer.UpdateProgress(AProgress);
      UpdateTimeRemaining(FProcessTimer.EstimatedTime,FProcessTimer.ElapsedTime);
    end;
  progressNormal.Position := AProgress;
  Application.ProcessMessages;
end;

procedure TdlgProgress.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  imgProgress.Active := False;
  progressWaiting.Active := False;
  Action := caFree;
end;

procedure TdlgProgress.UpdateTimeRemaining(AEstimatedTime, AElapsedTime : TDateTime);
var
  EstimatedTime : String;
  ElapsedTime : String;
begin
  if AEstimatedTime <> 0 then
    begin
      EstimatedTime := 'Estimated: ';
      if HourOf(AEstimatedTime) > 0 then
        begin
          if HourOf(AEstimatedTime) = 1 then
            begin
              EstimatedTime := EstimatedTime + FormatDateTime('h "hour "',AEstimatedTime);
            end else
            begin
              EstimatedTime := EstimatedTime + FormatDateTime('h "hours "',AEstimatedTime);
            end;
        end;
      if MinuteOf(AEstimatedTime) > 0 then
        begin
          if MinuteOf(AEstimatedTime) = 1 then
            begin
              EstimatedTime := EstimatedTime + FormatDateTime('n "minute "',AEstimatedTime);
            end else
            begin
              EstimatedTime := EstimatedTime + FormatDateTime('n "minutes "',AEstimatedTime);
            end;
        end;
      if (MinuteOf(AEstimatedTime) = 0) and (HourOf(AEstimatedTime) = 0) then
        begin
          EstimatedTime := 'Less than a minute...';
          //EstimatedTime := EstimatedTime + FormatDateTime('s "seconds "',AEstimatedTime);
        end;
    end else
    begin
      EstimatedTime := 'Calculating...';
    end;
  ElapsedTime := 'Elapsed: ';
  if HourOf(AElapsedTime) > 0 then
    begin
      ElapsedTime := ElapsedTime + FormatDateTime('h "hour(s) "',AElapsedTime);
    end;
  if MinuteOf(AElapsedTime) > 0 then
    begin
      ElapsedTime := ElapsedTime + FormatDateTime('n "minute(s) "',AElapsedTime);
    end;
  ElapsedTime := ElapsedTime + FormatDateTime('s "seconds "',AElapsedTime);
  lblTimeRemaining.Caption := EstimatedTime;
  lblTimeElapsed.Caption := ElapsedTime;
end;

end.
