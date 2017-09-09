Unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  ExtCtrls, StdCtrls, Buttons, frmConst;

type
  TAboutF = class(TForm)
    Image1: TImage;
    VersionLabel: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Button1: TButton;
    StaticText1: TStaticText;
    Image2: TImage;
    Image3: TImage;
    Bevel1: TBevel;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutF: TAboutF;

implementation

{$R *.DFM}

procedure TAboutF.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TAboutF.FormActivate(Sender: TObject);
begin
  VersionLabel.Caption := VERSION;
end;

end.
