unit FrmDisplayAnsiDeviceDesc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, JvExControls, JvLabel;

type
  TAnsiDeviceDescF = class(TForm)
    Panel1: TPanel;
    RichEdit1: TRichEdit;
    BitBtn1: TBitBtn;
    JvLabel19: TJvLabel;
    DeviceNoEdit: TEdit;
    JvLabel1: TJvLabel;
    DeviceNameEdit: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function CreateAnsiDeviceDescForm(ADeviceNo, ADeviceName, ADesc: string): integer;

var
  AnsiDeviceDescF: TAnsiDeviceDescF;

implementation

{$R *.dfm}

function CreateAnsiDeviceDescForm(ADeviceNo, ADeviceName, ADesc: string): integer;
var
  LAnsiDeviceDescF: TAnsiDeviceDescF;
begin
  LAnsiDeviceDescF := TAnsiDeviceDescF.Create(nil);
  try
    LAnsiDeviceDescF.DeviceNoEdit.Text := ADeviceNo;
    LAnsiDeviceDescF.DeviceNameEdit.Text := ADeviceName;
    LAnsiDeviceDescF.RichEdit1.Lines.Text := ADesc;

    Result := LAnsiDeviceDescF.ShowModal;

    if Result = mrOK then
    begin
    end;
  finally
    LAnsiDeviceDescF.Free;
  end;
end;

end.
