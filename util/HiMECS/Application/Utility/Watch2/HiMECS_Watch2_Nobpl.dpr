program HiMECS_Watch2_Nobpl;

uses
  Vcl.Forms,
  HiMECS_Watch2 in 'HiMECS_Watch2.pas' {WatchF2},
  frmDesignManagerDockUnit in '..\..\..\..\VisualComm\frmDesignManagerDockUnit.pas' {frmDesignManagerDock},
  pjhObjectInspectorBpl in '..\..\..\..\VisualComm\pjhObjectInspectorBpl.pas' {frmProps};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TWatchF2, WatchF2);
  Application.CreateForm(TfrmDesignManagerDock, frmDesignManagerDock);
  Application.Run;
end.
