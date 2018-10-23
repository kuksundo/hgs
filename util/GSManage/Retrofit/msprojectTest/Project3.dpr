program Project3;

uses
  Vcl.Forms,
  Unit4 in 'Unit4.pas' {Form4},
  UnitMSProjectUtil in '..\..\..\..\common\UnitMSProjectUtil.pas',
  MSProject_TLB in 'C:\Users\Administrator\Documents\RAD Studio\12.0\Imports\MSProject_TLB.pas',
  MSHTML_TLB in 'C:\Users\Administrator\Documents\RAD Studio\12.0\Imports\MSHTML_TLB.pas',
  Office_TLB in 'C:\Users\Administrator\Documents\RAD Studio\12.0\Imports\Office_TLB.pas',
  VBIDE_TLB in 'C:\Users\Administrator\Documents\RAD Studio\12.0\Imports\VBIDE_TLB.pas';

{$R *.res}

begin
  Vcl.Forms.Application.Initialize;
  Vcl.Forms.Application.MainFormOnTaskbar := True;
  Vcl.Forms.Application.CreateForm(TForm4, Form4);
  Vcl.Forms.Application.Run;
end.
