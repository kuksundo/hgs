unit adxtAboutFrm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellAPI, Vcl.Imaging.jpeg;

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Label4: TLabel;
    lblHost: TLabel;
    lblVersion: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    lblUrl: TLabel;
    lblADXVer: TLabel;
    ProgramIcon: TImage;
    Label6: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    procedure lblUrlClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure adxtAboutDlg(const HostName, Version, ADXVersion: string);

implementation

{$R *.dfm}

procedure adxtAboutDlg(const HostName, Version, ADXVersion: string);
var
  f: TfrmAbout;
begin
  f := TfrmAbout.Create(nil);
  f.lblHost.Caption := Format(f.lblHost.Caption, [HostName]);
  f.lblVersion.Caption := Format(f.lblVersion.Caption, [Version]);
  f.lblAdxVer.Caption := Format(f.lblADXVer.Caption, [ADXVersion]);
  try
    f.ShowModal;
  finally
    f.Free;
  end;
end;

procedure TfrmAbout.lblUrlClick(Sender: TObject);
begin
  ShellExecute(Application.Handle , 'open' , PChar(TControl(Sender).Hint),
    nil , nil , SW_RESTORE);
end;

end.

