unit NetAbout;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, ExtCtrls;

type
  TAboutDialog = class(TForm)
    btnOk: TButton;
    imgProgram: TImage;
    lblVersion: TLabel;
    lblCopyright: TLabel;
    lblName: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAboutDialog(AOwner: TComponent);

var
  AboutDialog: TAboutDialog;

implementation

uses NetUtils, ShellAPI;

{$R *.dfm}

procedure ShowAboutDialog(AOwner: TComponent);
var
  I: Integer;
begin
  for I := 0 to Screen.FormCount - 1 do
    if Screen.Forms[I].ClassType = TAboutDialog then
      Exit;
  with TAboutDialog.Create(AOwner) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TAboutDialog.FormCreate(Sender: TObject);
var
  Version, Build: string;
begin
  Caption := Format('%s %s', [Caption, Application.Title]);
  imgProgram.Picture.Icon.Handle := LoadImage(HInstance, 'MAINICON', IMAGE_ICON,
    48, 48, LR_DEFAULTCOLOR);
  lblName.Caption := Application.Title;
  GetFileVersion(Application.ExeName, Version, Build);
  lblVersion.Caption := Format(lblVersion.Caption, [Version, Build]);
  lblCopyright.Caption := Format(lblCopyright.Caption, [FormatDateTime('yyyy', Now)]);
  if not Application.MainForm.Visible then
    Position := poScreenCenter;
end;

end.
