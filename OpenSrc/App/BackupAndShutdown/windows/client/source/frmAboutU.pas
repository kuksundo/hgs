{ -----------------------------------------------------------------------------
  Unit Name: frmAboutU
  Author: Tristan Marlow
  Purpose: About Dialog

  ----------------------------------------------------------------------------
  Copyright (c) 2006 Tristan David Marlow
  Copyright (c) 2006 Little Earth Solutions
  All Rights Reserved

  This product is protected by copyright and distributed under
  licenses restricting copying, distribution and decompilation

  ----------------------------------------------------------------------------

  History: 01/01/2006 - First Release.

  ----------------------------------------------------------------------------- }
unit frmAboutU;

interface

uses
  CommonU, FileVersionInformationU,
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Messages, JvLabel, JvScrollText,
  Dialogs, ComCtrls, ImgList, JvExControls, JvProgressDialog, jpeg;

type
  TfrmAbout = class(TForm)
    pnlMain: TPanel;
    pnlBottom: TPanel;
    PageControlMain: TPageControl;
    tabAbout: TTabSheet;
    tabVersionHistory: TTabSheet;
    OKBtn: TButton;
    ImageListAbout: TImageList;
    lblCopyright: TLabel;
    pnlAbout: TPanel;
    ScrollText: TJvScrollText;
    imgAbout: TImage;
    pnlVersionHistory: TPanel;
    VersionHistory: TRichEdit;
    GroupBoxPoweredBy: TGroupBox;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image1: TImage;
    Image5: TImage;
    tabLicenseInformation: TTabSheet;
    pnlLicenseInformation: TPanel;
    LicenseInformation: TRichEdit;
    tabSupportInformation: TTabSheet;
    pnlSupportInformation: TPanel;
    SupportInformation: TRichEdit;
    lblVersionDetails: TLabel;
    Image7: TImage;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgAboutMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Image2Click(Sender: TObject);
  private
    FReleaseNotes: TFileName;
    FLicenseInformation: TFileName;
    FSupportInformation: TFileName;
  public
    function Execute(AReleaseNotes: TFileName = '';
      ALicenseInformation: TFileName = '';
      ASupportInformation: TFileName = ''): boolean;
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.OKBtnClick(Sender: TObject);
begin
  Self.ModalResult := mrOk;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
var
  ApplicationVersionInfo: TApplicationVersionInfo;
begin
  PageControlMain.ActivePageIndex := 0;
  ApplicationVersionInfo := TApplicationVersionInfo.Create;
  try
    with ApplicationVersionInfo do
    begin
      lblVersionDetails.Caption := FileVersion;
      lblCopyright.Caption := LegalCopyright;
      if IsSystemX64 then
      begin
        lblVersionDetails.Caption := lblVersionDetails.Caption + ' x64';
      end
      else
      begin
        lblVersionDetails.Caption := lblVersionDetails.Caption + ' x86';
      end;
    end;
  finally
    FreeAndNil(ApplicationVersionInfo);
  end;
end;

procedure TfrmAbout.FormShow(Sender: TObject);
begin
  PageControlMain.ActivePageIndex := 0;
  tabVersionHistory.TabVisible := False;
  tabLicenseInformation.TabVisible := False;
  tabSupportInformation.TabVisible := False;
  try
    if FileExists(FReleaseNotes) then
    begin
      VersionHistory.Lines.LoadFromFile(FReleaseNotes);
      tabVersionHistory.TabVisible := True;
    end;
    if FileExists(FLicenseInformation) then
    begin
      LicenseInformation.Lines.LoadFromFile(FLicenseInformation);
      tabLicenseInformation.TabVisible := True;
    end;
    if FileExists(FSupportInformation) then
    begin
      SupportInformation.Lines.LoadFromFile(FSupportInformation);
      tabSupportInformation.TabVisible := True;
    end;
  finally
    ScrollText.Active := True;
  end;
end;

procedure TfrmAbout.Image2Click(Sender: TObject);
begin
  if (Sender is TImage) then
  begin
    OpenDefaultBrowser((Sender as TImage).Hint);
  end;
end;

procedure TfrmAbout.imgAboutMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
const
  SC_DRAGMOVE = $F012;
begin
  if Button = mbleft then
  begin
    ReleaseCapture;
    Self.Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

function TfrmAbout.Execute(AReleaseNotes: TFileName = '';
  ALicenseInformation: TFileName = '';
  ASupportInformation: TFileName = ''): boolean;
begin
  FReleaseNotes := AReleaseNotes;
  FLicenseInformation := ALicenseInformation;
  FSupportInformation := ASupportInformation;
  if not Self.Visible then
  begin
    Self.ShowModal;
  end
  else
  begin
    Application.BringToFront;
  end;
  Result := True;
end;

end.
