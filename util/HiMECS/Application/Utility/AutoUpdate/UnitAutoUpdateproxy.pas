unit UnitAutoUpdateproxy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Tproxy = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  proxy: Tproxy;

implementation

{$R *.DFM}

procedure Tproxy.Button1Click(Sender: TObject);
begin
 self.ModalResult := mrOk;
end;

procedure Tproxy.Button2Click(Sender: TObject);
begin
 self.modalresult:=mrCancel;
end;

end.
