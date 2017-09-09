{ -----------------------------------------------------------------------------
  Unit Name: dlgUpdateInformationU
  Author: Tristan Marlow
  Purpose: Displays release notes and support information

  ----------------------------------------------------------------------------
  License
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU Library General Public License as
  published by the Free Software Foundation; either version 2 of
  the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Library General Public License for more details.
  ----------------------------------------------------------------------------

  History: 04/05/2007 - First Release.

  ----------------------------------------------------------------------------- }
unit dlgUpdateInformationU;

interface

uses
  FileVersionInformationU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ActnList, JvXPCore,
  JvXPButtons, ImgList, Buttons, jpeg, System.Actions,
  System.UITypes;

type
  TdlgUpdateInformation = class(TForm)
    pnlFooter: TPanel;
    ActionList: TActionList;
    ActionClose: TAction;
    pnlHeader: TPanel;
    imgHeader: TImage;
    lblHeader: TLabel;
    lblApplicationVersion: TLabel;
    TimerAllowClose: TTimer;
    PageControlUpdate: TPageControl;
    tabReleaseNotes: TTabSheet;
    tabSupportInformation: TTabSheet;
    memoReleaseNotes: TRichEdit;
    memoSupportInformation: TRichEdit;
    tabLicenseInformation: TTabSheet;
    ImageListUpdateInformation: TImageList;
    memoLicenseInformation: TRichEdit;
    JvXPButton1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ActionCloseUpdate(Sender: TObject);
    procedure ActionCloseExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TimerAllowCloseTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lblHeaderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FReleaseNotes: TFileName;
    FSupportInformation: TFileName;
    FLicenseInformation: TFileName;
    FCanClose: Boolean;
    FTimer: Integer;
  public
    function Execute(AReleaseNotes: TFileName = '';
      ALicenseInformation: TFileName = ''; ASupportInformation: TFileName = '';
      ACloseTimeout: Integer = 15): Boolean;
  end;

implementation

{$R *.dfm}

procedure TdlgUpdateInformation.FormShow(Sender: TObject);
var
  VersionInfo: TApplicationVersionInfo;
begin
  FCanClose := False;
  VersionInfo := TApplicationVersionInfo.Create;
  try
    PageControlUpdate.ActivePageIndex := 0;
    memoReleaseNotes.SetFocus;

    lblHeader.Caption := Format('"%s" has been updated successfully.',
      [VersionInfo.ProductName]);
    lblApplicationVersion.Caption := VersionInfo.FileVersion;
    memoReleaseNotes.Lines.Clear;
    if FileExists(FReleaseNotes) then
    begin
      memoReleaseNotes.Lines.LoadFromFile(FReleaseNotes);
    end
    else
    begin
      memoReleaseNotes.Lines.Add(Format('"%s" does not exist.',
        [FReleaseNotes]));
    end;
    if FileExists(FSupportInformation) then
    begin
      tabSupportInformation.TabVisible := True;
      memoSupportInformation.Lines.LoadFromFile(FSupportInformation);
    end
    else
    begin
      tabSupportInformation.TabVisible := False;
      memoSupportInformation.Lines.Add(Format('"%s" does not exist.',
        [FSupportInformation]));
    end;
    if FileExists(FLicenseInformation) then
    begin
      tabLicenseInformation.TabVisible := True;
      memoLicenseInformation.Lines.LoadFromFile(FLicenseInformation);
    end
    else
    begin
      tabLicenseInformation.TabVisible := False;
      memoLicenseInformation.Lines.Add(Format('"%s" does not exist.',
        [FLicenseInformation]));
    end;
    TimerAllowClose.Enabled := True;
  finally
    FreeAndNil(VersionInfo);
  end;
end;

procedure TdlgUpdateInformation.lblHeaderMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (ssShift in Shift) then
  begin
    FCanClose := True;
    Self.Close;
  end;
end;

procedure TdlgUpdateInformation.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  TimerAllowClose.Enabled := False;
end;

procedure TdlgUpdateInformation.TimerAllowCloseTimer(Sender: TObject);
begin
  if FTimer > 0 then
  begin
    ActionClose.Caption := Format('Close (%d)', [FTimer]);
    Dec(FTimer);
    FCanClose := False;
  end
  else
  begin
    ActionClose.Caption := 'Close';
    FCanClose := True;
    TimerAllowClose.Enabled := False;
  end;
end;

procedure TdlgUpdateInformation.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FCanClose;
  if not CanClose then
  begin
    MessageDlg
      ('Please review the release notes, there is important and helpful information about changes to the application.',
      mtWarning, [mbOK], 0);
  end;
end;

function TdlgUpdateInformation.Execute(AReleaseNotes: TFileName = '';
  ALicenseInformation: TFileName = ''; ASupportInformation: TFileName = '';
  ACloseTimeout: Integer = 15): Boolean;
begin
  FSupportInformation := ASupportInformation;
  FReleaseNotes := AReleaseNotes;
  FLicenseInformation := ALicenseInformation;
  FTimer := ACloseTimeout;
  Self.ShowModal;
  Result := True;
end;

procedure TdlgUpdateInformation.ActionCloseExecute(Sender: TObject);
begin
  Self.Close;
end;

procedure TdlgUpdateInformation.ActionCloseUpdate(Sender: TObject);
begin
  ActionClose.Enabled := FCanClose;
end;

procedure TdlgUpdateInformation.FormCreate(Sender: TObject);
begin
  FTimer := 30;
  FCanClose := False;
end;

end.
