program FuzzyTextEncode;

uses
  Forms,
  FuzzyTextEncodeForms in 'FuzzyTextEncodeForms.pas' {frmEncode},
  BlockCiphers in '..\..\..\..\Examples\blockcyphers\BlockCiphers.pas',
  HardwRegs in '..\HardwRegs.pas' {frmAuthorise: TFrame},
  uODDskInfo in '..\..\..\Testout\diskinfo\uODDskInfo.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmEncode, frmEncode);
  Application.Run;
end.
