<<<<<<< .mine
program RMIS_Server;

uses
  Vcl.Forms,
  UnitRMISServerMain in 'UnitRMISServerMain.pas' {Form1},
  UnitBWQueryInterface in '..\Common\UnitBWQueryInterface.pas',
  UnitBWQueryConfig in 'UnitBWQueryConfig.pas' {ConfigF},
  BW_Query_Class in '..\Common\BW_Query_Class.pas',
  UnitDataView in 'UnitDataView.pas' {DataViewF},
  UnitHhiOfficeNewsInterface in '..\Common\UnitHhiOfficeNewsInterface.pas',
  UnitDM in 'UnitDM.pas' {DM1: TDataModule},
  UnitDPMSInfoClass in '..\Common\UnitDPMSInfoClass.pas',
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  UnitRMISSessionInterface in '..\Common\UnitRMISSessionInterface.pas',
  UnitExtraMHInfoClass in '..\Common\UnitExtraMHInfoClass.pas',
  UnitBWQuery in 'UnitBWQuery.pas',
  UnitDPMS in 'UnitDPMS.pas',
  UnitExtraMH in 'UnitExtraMH.pas',
  Generics.Legacy in '..\..\..\common\Generics.Legacy.pas',
  UnitDPMSInfoInterface in '..\Common\UnitDPMSInfoInterface.pas',
  UnitHHIOfficeNews in 'UnitHHIOfficeNews.pas',
  RMISConst in '..\Common\RMISConst.pas',
  UnitRMISSessionClass in '..\Common\UnitRMISSessionClass.pas',
  UnitExtraMHInfoInterface in '..\Common\UnitExtraMHInfoInterface.pas',
  VarRecUtils in '..\..\..\common\VarRecUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
=======
program RMIS_Server;

uses
  Vcl.Forms,
  UnitRMISServerMain in 'UnitRMISServerMain.pas' {Form1},
  UnitBWQueryInterface in '..\Common\UnitBWQueryInterface.pas',
  UnitBWQueryConfig in 'UnitBWQueryConfig.pas' {ConfigF},
  BW_Query_Class in '..\Common\BW_Query_Class.pas',
  UnitDataView in 'UnitDataView.pas' {DataViewF},
  UnitHhiOfficeNewsInterface in '..\Common\UnitHhiOfficeNewsInterface.pas',
  UnitDM in 'UnitDM.pas' {DM1: TDataModule},
  UnitDPMSInfoClass in '..\Common\UnitDPMSInfoClass.pas',
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  UnitRMISSessionInterface in '..\Common\UnitRMISSessionInterface.pas',
  UnitExtraMHInfoClass in '..\Common\UnitExtraMHInfoClass.pas',
  UnitBWQuery in 'UnitBWQuery.pas',
  UnitDPMS in 'UnitDPMS.pas',
  UnitExtraMH in 'UnitExtraMH.pas',
  Generics.Legacy in '..\..\..\common\Generics.Legacy.pas',
  UnitDPMSInfoInterface in '..\Common\UnitDPMSInfoInterface.pas',
  UnitExtraMHInfoInterface in '..\Common\UnitExtraMHInfoInterface.pas',
  UnitHHIOfficeNews in 'UnitHHIOfficeNews.pas',
  RMISConst in '..\Common\RMISConst.pas',
  UnitRMISSessionClass in '..\Common\UnitRMISSessionClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
>>>>>>> .r1752
