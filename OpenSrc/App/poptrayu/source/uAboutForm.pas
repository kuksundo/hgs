unit uAboutForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Buttons, PngBitBtn,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TAboutForm = class(TForm)
    panAbout: TPanel;
    lblVersion: TLabel;
    imgPTU: TImage;
    labelAppName: TLabel;
    panAboutBottom: TPanel;
    btnCheckUpdate: TButton;
    btnHelp: TPngBitBtn;
    AboutTabs: TPageControl;
    TabAboutPTU: TTabSheet;
    lblHomepage: TLabel;
    lblCopyright: TLabel;
    lblDerivative: TLabel;
    imgPopTrayLogo: TImage;
    TabCredits: TTabSheet;
    lvCredits: TListView;
    TabTranslate: TTabSheet;
    lvVolunteers: TListView;
    tabImageCred: TTabSheet;
    lvImageCredits: TListView;
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCheckUpdateClick(Sender: TObject);
    procedure AboutTabsResize(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateFonts();
  end;

var
  AboutForm: TAboutForm;

implementation
uses uRCUtils, uGlobal, Math, IdGlobal, uProtocol, uTranslate;

{$R *.dfm}

procedure TAboutForm.AboutTabsResize(Sender: TObject);
const
  hMargin : integer = 8;
var
  lineHeight : Integer;
begin
  inherited;
  lineHeight := Options.GlobalFont.Height;
  if (lineHeight < 0) then begin
    // approximate margins for ascenders and descenders
    lineHeight := lineHeight * -3 div 2;
  end;

  lblCopyright.Left := hMargin;
  lblCopyright.Width := TabAboutPTU.Width - (hMargin * 2);
  lblCopyright.Height := lineHeight * 3;

  lblHomepage.Top := lblCopyright.Top + lblCopyright.Height;
  lblHomepage.Height := lineHeight * 2;
  lblHomepage.Left := hMargin;
  lblHomepage.Width := TabAboutPTU.Width - (hMargin * 2);

  imgPopTrayLogo.Top := lblHomepage.Top + lblHomepage.Height + 3;

  lblDerivative.Top := imgPopTrayLogo.Top - 3;
  lblDerivative.Left := hMargin + imgPopTrayLogo.Width;
  lblDerivative.Width := TabAboutPTU.Width - (hMargin * 3) - imgPopTrayLogo.Width;

end;

procedure TAboutForm.btnCheckUpdateClick(Sender: TObject);
var
  ver : string;
  verParts : TStrings;
begin
  ver := GetAppVersionStr();
  verParts := TStringList.Create;
  try
  ExtractStrings(['.'], [], PChar(ver), verParts);
  ExecuteFile('http://poptrayu.sourceforge.net/checkupdate.php?major='+
              verParts[0]+'&minor='+verParts[1]+'&release='+verParts[2]
              ,'','',SW_RESTORE);
  finally
    verParts.Free;
  end;
  //ExecuteFile('http://poptrayu.sourceforge.net/checkupdate.php?major='+
  //            MajorVersion+'&minor='+MinorVersion+'&release='+ReleaseVersion+
  //            '&beta='+BetaVersion,'','',SW_RESTORE);
end;

procedure TAboutForm.FormCreate(Sender: TObject);
const
  indyIdx = 1;
  openSSLIdx = 2;
begin
  // Set version info

  //  lblVersion.Caption := Translate('version')+' '+MajorVersion+'.'+MinorVersion;
  //  if ReleaseVersion <> '0' then
  //    lblVersion.Caption := lblVersion.Caption + '.' + ReleaseVersion;
  //  if BetaVersion <> '0' then
  //  begin
  //    if Copy(BetaVersion,1,2) = '0.' then
  //      lblVersion.Caption := lblVersion.Caption + ' (pre-beta ' + BetaVersion +')'
  //    else
  //      lblVersion.Caption := lblVersion.Caption + ' (beta ' + BetaVersion +')'
  //  end;
  //  if ReleaseCandidate <> '' then
  //    lblVersion.Caption := lblVersion.Caption + '  ' + ReleaseCandidate;

  lblVersion.Caption := GetAppVersionStr();

  // Populate version for Indy
  lvCredits.Items[indyIdx].SubItems[0] :=
    // Indy Version from IdGlobal unit
    IntToStr(gsIdVersionMajor) + '.' +
    IntToStr(gsIdVersionMinor) + '.' +
    IntToStr(gsIdVersionRelease) + '.' +
    IntToStr(gsIdVersionBuild);

  TProtocol.InitOpenSSL; //populates SSL Version String
  lvCredits.Items[openSSLIdx].SubItems[0] := Translate(TProtocol.sslVersionString);

end;

procedure TAboutForm.FormResize(Sender: TObject);
var
  w1,headerTextWidth : integer;
begin
  // header
  labelAppName.Font.Size := lblVersion.Font.Size + 8;
  headerTextWidth := Max(lblVersion.Width, labelAppName.Width);
  w1 := headerTextWidth + imgPTU.Width + 16;
  imgPTU.Left := (panAbout.Width - w1) div 2;
  lblVersion.Left := (imgPTU.Left + imgPTU.Width + 16) +
    ((headerTextWidth - lblVersion.Width) div 2);
  labelAppName.Left := (imgPTU.Left + imgPTU.Width + 16) +
    ((headerTextWidth - labelAppName.Width) div 2);
  lblVersion.Top := labelAppName.Top + labelAppName.Height;

  AboutTabs.Top := Max(lblVersion.Top + lblVersion.Height + 8, 60);
  AboutTabs.Width := panAbout.ClientWidth - 16;
  AboutTabs.Left := 8;


  // buttons
  btnHelp.ClientHeight := Max(lblVersion.Height, 25);
  btnHelp.ClientWidth := Canvas.TextWidth(btnHelp.Caption) + 25;

  btnCheckUpdate.Height := btnHelp.Height;
  Canvas.Font := btnCheckUpdate.Font;
  btnCheckUpdate.Width := Max( Canvas.TextWidth(btnCheckUpdate.Caption) + 25 + 8, 250);
  btnCheckUpdate.Left := btnHelp.Left + btnHelp.Width + 8;
  btnCheckUpdate.Top := btnHelp.Top;

  panAboutBottom.Height := btnHelp.Height + 8;


  AboutTabs.Height := panAboutBottom.Top - AboutTabs.Top - 8;

end;

procedure TAboutForm.lblHomepageClick(Sender: TObject);
begin
  ExecuteFile('http://sourceforge.net/projects/poptrayu/','','',SW_RESTORE);
end;

procedure TAboutForm.lblHomepageMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Style := [fsUnderline];
end;

procedure TAboutForm.lblHomepageMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Style := [];
end;

procedure TAboutForm.UpdateFonts();
//var
//  font : TFont;
begin
  Self.Font.Assign(Options.GlobalFont);

  // Blue (Fake hyperlink)
  AboutForm.lblHomepage.Font.Assign(Options.GlobalFont);
  AboutForm.lblHomepage.Font.Color := clBlue;

  AboutForm.FormResize(self);
end;

end.

