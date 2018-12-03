program SimulateParamServer;

uses
  Vcl.Forms,
  {$IfDef USE_REGCODE}
  UnitRegistrationUtil,
  {$EndIf USE_REGCODE}
  SynSqlite3Static,
  FrmParamManage in 'FrmParamManage.pas' {ParamManageF},
  UnitSimulateParamRecord in 'UnitSimulateParamRecord.pas',
  VarRecUtils in '..\..\..\..\..\common\openarr\source\VarRecUtils.pas',
  UnitVesselData in '..\..\..\..\GSManage\VesselList\UnitVesselData.pas',
  UnitHGSCurriculumData in '..\..\..\..\GSManage\CertManage\UnitHGSCurriculumData.pas',
  FrameGSFileList in '..\..\..\..\..\common\Frames\FrameGSFileList.pas',
  UnitGSFileRecord in '..\..\..\..\GSManage\UnitGSFileRecord.pas',
  FrmFileSelect in '..\..\..\..\GSManage\FrmFileSelect.pas',
  UnitElecServiceData in '..\..\..\..\GSManage\UnitElecServiceData.pas',
  FrmSimulateParamEdit in '..\Watch2\FrmSimulateParamEdit.pas',
  UnitIPCClientAll in '..\CommonFrame\UnitIPCClientAll.pas',
  UnitGSFileData in '..\..\..\..\GSManage\UnitGSFileData.pas',
  UnitCommandLineUtil in '..\..\..\..\..\common\UnitCommandLineUtil.pas',
  GpCommandLineParser in '..\..\..\..\..\common\GpDelphiUnit\src\GpCommandLineParser.pas',
  UnitSimulateParamCommandLineOption in 'UnitSimulateParamCommandLineOption.pas',
  UnitFGSSData in '..\..\..\..\GSManage\FGSSManage\UnitFGSSData.pas',
  UnitBase64Util in '..\..\..\..\..\common\UnitBase64Util.pas';

{$R *.res}

  function ProcessCommandLineParse: Boolean;
  var
    LCLO: TpjhCommandLine<TSimulateParamCLO>;
    LStr: string;
  begin
    Result := False;
    LCLO := TpjhCommandLine<TSimulateParamCLO>.Create;
    try
      LCLO.CommandLineParse(LStr);

      Result := (LCLO.FCommandLine.JsonParamCollect <> '') and
        (LCLO.FCommandLine.CSVValues <> '');

      if Result then
      begin
        CreateParamManageR(LCLO.FCommandLine.JsonParamCollect,
          LCLO.FCommandLine.CSVValues);
      end;
    finally
      LCLO.Free;
    end;
  end;
begin

  {$IfDef USE_REGCODE}
    //UnitCryptUtil.EncryptString_Syn('{F821E37C-3396-4116-BA75-44584EC5E60B}', True)
    CheckRegistration('z6ebxalCblfdZrR/ApkRClfTbECFVKR11jxj2zkeuvyU6sDairtQ7GjIot1YfkL3KAWz9IBfP3M94xrYl1JcJg==', [crmHTTP]);
  {$EndIf USE_REGCODE}

  if ProcessCommandLineParse then
    halt(0);

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TParamManageF, ParamManageF);
  Application.Run;
end.
