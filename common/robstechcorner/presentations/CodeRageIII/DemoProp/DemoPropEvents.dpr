program DemoPropEvents;

uses
  Forms,
  frmMainTwo in 'frmMainTwo.pas' {frmPropEvents},
  frmMainone in 'frmMainone.pas' {frmProperties};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPropEvents, frmPropEvents);
  Application.CreateForm(TfrmProperties, frmProperties);
  Application.Run;
end.
