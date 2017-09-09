{ unit uTestReg

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit uTestReg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    btnHWKey: TButton;
    Label1: TLabel;
    Label2: TLabel;
    lbSerial: TLabel;
    lbHWKey: TLabel;
    procedure btnHWKeyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uODDskInfo;

{$R *.DFM}

procedure TForm1.btnHWKeyClick(Sender: TObject);
var
  i: integer;
  DInfo: TODVolumeInformation;
  Serial, HWKey: dword;
begin
  // Get the hardware key
  GetVolumeInformation('D', DInfo);
  // Hassle
  Serial := DInfo.VolumeSerialNumber;
  HWKey := 0;
  for i := 0 to 3 do begin
    HWKey := HWKey shl 8;
    HWKey := HWKey + (Serial and $FF) xor $FF;
    Serial := Serial shr 8;
  end;
  // Output
  lbSerial.Caption := Format('%u', [DInfo.VolumeSerialNumber]);
  lbHWKey.Caption  := Format('%x', [HWKey]);;
end;

end.
