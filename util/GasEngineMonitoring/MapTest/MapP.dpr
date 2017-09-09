program MapP;

uses
  Forms,
  MapUnit in 'MapUnit.pas' {Form3},
  DeCAL_pjh in '..\gui\common\DeCAL_pjh.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
