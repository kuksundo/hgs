program RSSAddressEditor;

uses
  Vcl.Forms,
  UnitRSSAddrEdit in '..\Common\UnitRSSAddrEdit.pas' {RSSAddressEditF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TRSSAddressEditF, RSSAddressEditF);
  Application.Run;
end.
