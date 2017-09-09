unit frmClassReg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TBase = class abstract (TPersistent)
  public
    function GetMessage : String; virtual; abstract;
  end;

  THelloWorld = class(TBase)
  public
    function GetMessage : String; override;
  end;

  TDelphiLive = class(TBase)
    function GetMessage : String; override;
  end;

  TBaseClass = class of TBase;

  TForm3 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  Test : TBase;
begin
  Test := TBaseClass(FindClass(Edit1.Text)).Create;
  try
    Label1.Caption := Test.GetMessage;
  finally
    Test.Free;
  end;
end;

{ THelloWorld }

function THelloWorld.GetMessage : string;
begin
  Result := 'Hello World';
end;

{ TCodeRage }

function TDelphiLive.GetMessage : String;
begin
  result := 'DelphiLive Rocks!';
end;

initialization
  RegisterClass(TDelphiLive);
  RegisterClass(THelloWorld);
end.
