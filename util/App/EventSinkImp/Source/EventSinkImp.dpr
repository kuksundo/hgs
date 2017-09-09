//******************************************************************************
//
// EventSinkImp
//
// Copyright ?1999-2000 Binh Ly
// All Rights Reserved
//
// bly@techvanguards.com
// http://www.techvanguards.com
//******************************************************************************
program EventSinkImp;

uses
  Forms,
  Utils in 'Utils.pas',
  SinkEventsFrm in 'SinkEventsFrm.pas' {frmSinkEvents},
  AboutFrm in 'AboutFrm.pas' {frmAbout},
  EventSinkParser in 'EventSinkParser.pas',
  OptionsFrm in 'OptionsFrm.pas' {frmOptions},
  EventSinkOptions in 'EventSinkOptions.pas',
  SinkComponentAsync in 'SinkComponentAsync.pas',
  SinkComponent in 'SinkComponent.pas',
  SinkObject in 'SinkObject.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSinkEvents, frmSinkEvents);
  Application.Run;
end.
