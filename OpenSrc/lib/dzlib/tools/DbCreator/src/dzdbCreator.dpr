program dzdbCreator;

uses
  Forms,
  u_dzDbCreatorReadAccessDb in '..\..\..\dbcreator\u_dzDbCreatorReadAccessDb.pas',
  w_dbCreatorWizard in 'w_dbCreatorWizard.pas' {f_dbCreatorWizard},
  w_AddUser in 'w_AddUser.pas' {f_AddUser},
  w_DestFile in 'w_DestFile.pas' {f_DestFile},
  w_ExportFormat in 'w_ExportFormat.pas' {f_ExportFormat},
  w_Options in 'w_Options.pas' {f_Options},
  w_SourceFile in 'w_SourceFile.pas' {f_SourceFile},
  u_dzDbCreatorBase in '..\..\..\dbcreator\u_dzDbCreatorBase.pas',
  u_dzDbCreatorCreateAccess in '..\..\..\dbcreator\u_dzDbCreatorCreateAccess.pas',
  u_dzDbCreatorCreateDelphi in '..\..\..\dbcreator\u_dzDbCreatorCreateDelphi.pas',
  u_dzVariableDescList in '..\..\..\dbcreator\u_dzVariableDescList.pas',
  u_dzDbCreatorCreateGraphViz in '..\..\..\dbcreator\u_dzDbCreatorCreateGraphViz.pas',
  u_dzDbCreatorCreateHtml in '..\..\..\dbcreator\u_dzDbCreatorCreateHtml.pas',
  u_dzDbCreatorCreateMsSql in '..\..\..\dbcreator\u_dzDbCreatorCreateMsSql.pas',
  u_dzDbCreatorCreateOracle in '..\..\..\dbcreator\u_dzDbCreatorCreateOracle.pas',
  u_dzDbCreatorCreateXml in '..\..\..\dbcreator\u_dzDbCreatorCreateXml.pas',
  u_dzDbCreatorDescription in '..\..\..\dbcreator\u_dzDbCreatorDescription.pas',
  u_dzDbCreatorReadXml in '..\..\..\dbcreator\u_dzDbCreatorReadXml.pas',
  u_dzSqlScriptWriter in '..\..\..\dbcreator\u_dzSqlScriptWriter.pas',
  DAO_TLB in '..\..\..\adodb\DAO_TLB.pas',
  adodb_tlb in '..\..\..\adodb\adodb_tlb.pas',
  adox_tlb in '..\..\..\adodb\adox_tlb.pas',
  w_dzWizard in '..\..\..\forms\w_dzWizard.pas',
  u_dzLogConsole in '..\..\..\src\u_dzLogConsole.pas',
  u_dzScriptPositionList in '..\..\..\dbcreator\u_dzScriptPositionList.pas',
  u_dzNameValueList in '..\..\..\dbcreator\u_dzNameValueList.pas',
  u_dzConfigSettingList in '..\..\..\dbcreator\u_dzConfigSettingList.pas',
  u_dzXmlWriter in '..\..\..\dbcreator\u_dzXmlWriter.pas',
  u_dzXmlWriterInterface in '..\..\..\dbcreator\u_dzXmlWriterInterface.pas',
  u_dzXmlUtils in '..\..\..\dbcreator\u_dzXmlUtils.pas',
  u_dzFileStreams in '..\..\..\src\u_dzFileStreams.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tf_dbCreatorWizard, f_dbCreatorWizard);
  Application.Run;
end.
