program VideoCoDecDemo;

{%File 'Defines.inc'}

uses
  Forms,
  SysUtils,
  Windows,
  VideoCoDec in 'VideoCoDec.pas',
  AviFileHandler in 'AviFileHandler.pas',
  dmMainU in 'dmMainU.pas' {dmMain: TDataModule},
  DisplayU in 'DisplayU.pas' {DisplayF},
  SettingsU in 'SettingsU.pas' {SettingsF},
  CommonU in 'CommonU.pas',
  Preview in 'Preview.pas' {frmPreview},
  ClientDM in 'ClientDM.pas' {dmClient: TDataModule};

{$R *.res}


begin
  with Application do
  begin
    Initialize;
    CreateForm(TdmMain, dmMain);
    CreateForm(TdmClient, dmClient);
    CreateForm(TDisplayF, DisplayF);
    CreateForm(TfrmPreview, frmPreview);
    Run;
  end;
end.

