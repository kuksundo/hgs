program WT1600Demop;

uses
  Vcl.Forms,
  WT1600Demo in 'WT1600Demo.pas' {Form1},
  tmctl_h in '..\tmctl_h.pas',
  WT1600Connection in '..\WT1600Connection.pas',
  WT1600_Util in '..\common\WT1600_Util.pas',
  WT1600Const in '..\common\WT1600Const.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
