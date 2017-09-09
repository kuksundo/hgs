program SerialFileTransferP;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {SerialFileTransferF},
  SFTStruct in 'SFTStruct.pas',
  SFTConst in 'SFTConst.pas',
  ComPortThread in 'ComPortThread.pas',
  SFTConfig in 'SFTConfig.pas' {SFTConfigF},
  SFTConfigCollect in 'SFTConfigCollect.pas',
  FileConfirm in 'FileConfirm.pas' {Form3},
  unitForm05 in 'unitForm05.pas' {Form5},
  unitForm04 in 'unitForm04.pas' {Form4},
  CPort_pjh in 'common\CPort_pjh.pas';

{$R *.res}
{$R additional.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSerialFileTransferF, SerialFileTransferF);
  Application.CreateForm(TSFTConfigF, SFTConfigF);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
