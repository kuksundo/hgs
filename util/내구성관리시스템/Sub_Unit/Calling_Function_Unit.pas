unit Calling_Function_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, AdvScrollBox,
  IdContext, IdThreadComponent, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer;

type
  TCalling_Function_Frm = class(TForm)
    AdvScrollBox1: TAdvScrollBox;
    Label2: TLabel;
    edit1: TEdit;
    Panel28: TPanel;
    Button1: TButton;
    IdTCPServer1: TIdTCPServer;
    IdThreadComponent1: TIdThreadComponent;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Calling_Function_Frm: TCalling_Function_Frm;

implementation
uses
DataModule_Unit;

{$R *.dfm}

end.
