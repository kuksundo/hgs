unit UnitLampTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, AdvScrollBox, QLite;

type
  TLampTestF = class(TForm)
    AdvScrollBox1: TAdvScrollBox;
    Label2: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel2: TPanel;
    Panel9: TPanel;
    Panel4: TPanel;
    Panel3: TPanel;
    Panel10: TPanel;
    Panel6: TPanel;
    Panel5: TPanel;
    Panel11: TPanel;
    Panel7: TPanel;
    Panel1: TPanel;
    Image1: TImage;
    Panel8: TPanel;
    Image2: TImage;
    Panel12: TPanel;
    Image3: TImage;
    Panel13: TPanel;
    Image4: TImage;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel20: TPanel;
    Button5: TButton;
    Panel21: TPanel;
    Button4: TButton;
    Panel22: TPanel;
    Button6: TButton;
    Panel23: TPanel;
    Button2: TButton;
    edit1: TEdit;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel28: TPanel;
    procedure Panel2Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel9Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel10Click(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Panel11Click(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LampTestF: TLampTestF;

implementation

{$R *.dfm}

procedure TLampTestF.Button2Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,0);
end;

procedure TLampTestF.Image1Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,1);
end;

procedure TLampTestF.Image2Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,2);
end;

procedure TLampTestF.Image3Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,3);
end;

procedure TLampTestF.Image4Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,4);
end;

procedure TLampTestF.Panel10Click(Sender: TObject);
begin
  _SetLamp(0,2,0,0,0);
end;

procedure TLampTestF.Panel11Click(Sender: TObject);
begin
  _SetLamp(0,0,2,0,0);
end;

procedure TLampTestF.Panel2Click(Sender: TObject);
begin
  _SetLamp(1,0,0,0,0);
end;

procedure TLampTestF.Panel3Click(Sender: TObject);
begin
  _SetLamp(0,1,0,0,0);
end;

procedure TLampTestF.Panel4Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,0);
end;

procedure TLampTestF.Panel5Click(Sender: TObject);
begin
  _SetLamp(0,0,1,0,0);
end;

procedure TLampTestF.Panel6Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,0);
end;

procedure TLampTestF.Panel7Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,0);
end;

procedure TLampTestF.Panel9Click(Sender: TObject);
begin
  _SetLamp(2,0,0,0,0);
end;

end.
