{ main unit for the dynode project }
unit dnMain;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, ImgList, ToolWin, ComCtrls,
  dnProcessRunner, SynEdit, VirtualTrees, ActnList;

const
  FDynodeProjectsFolder: string = 'D:\dynode\projects';

type
  TfrmMain = class(TForm)
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuEdit: TMenuItem;
    mnuSearch: TMenuItem;
    mnuView: TMenuItem;
    mnuProject: TMenuItem;
    mnuComponent: TMenuItem;
    mnuDatabase: TMenuItem;
    mnuTools: TMenuItem;
    mnuWindow: TMenuItem;
    mnuHelp: TMenuItem;
    mnuNew: TMenuItem;
    mnuOpen: TMenuItem;
    ilMain: TImageList;
    mnuOpenProject: TMenuItem;
    mnuReopen: TMenuItem;
    N1: TMenuItem;
    mnuSave: TMenuItem;
    mnuSaveAs: TMenuItem;
    mnuSaveProjectAs: TMenuItem;
    mnuSaveAll: TMenuItem;
    mnuClose: TMenuItem;
    mnuCloseAll: TMenuItem;
    N2: TMenuItem;
    mnuUseUnit: TMenuItem;
    N3: TMenuItem;
    mnuPrint: TMenuItem;
    N4: TMenuItem;
    mnuExit: TMenuItem;
    mnuAddtoProject: TMenuItem;
    mnuRemovefromProject: TMenuItem;
    mnuViewSource: TMenuItem;
    N5: TMenuItem;
    mnuSyntaxcheck: TMenuItem;
    N6: TMenuItem;
    mnuCompileAllProjects: TMenuItem;
    mnuBuildAllProjects: TMenuItem;
    N7: TMenuItem;
    mnuOptions: TMenuItem;
    cbButtons: TCoolBar;
    tbStandard: TToolBar;
    btnNewItems: TToolButton;
    tbView: TToolBar;
    btnViewUnit: TToolButton;
    btnOpen: TToolButton;
    btnSave: TToolButton;
    T1: TToolButton;
    btnSaveAll: TToolButton;
    btnOpenProject: TToolButton;
    T2: TToolButton;
    btnAddFile: TToolButton;
    btnRemoveFile: TToolButton;
    pnlLeft: TPanel;
    vstObjects: TVirtualStringTree;
    splVer1: TSplitter;
    vstProperties: TVirtualStringTree;
    splHor1: TSplitter;
    sbMain: TStatusBar;
    splHor2: TSplitter;
    pcProjects: TPageControl;
    tsProject: TTabSheet;
    sneCode: TSynEdit;
    tcDebug: TTabControl;
    mmDebug: TMemo;
    btnViewForm: TToolButton;
    btnToggleViewForm: TToolButton;
    btnNewForm: TToolButton;
    T3: TToolButton;
    tbRun: TToolBar;
    btnRun: TToolButton;
    Run1: TMenuItem;
    mnuRun: TMenuItem;
    mnuAttachToProcess: TMenuItem;
    mnuParameters: TMenuItem;
    N8: TMenuItem;
    mnuStepover: TMenuItem;
    mnuTraceInto: TMenuItem;
    mnuTraceNextSL: TMenuItem;
    mnuRuntoCursor: TMenuItem;
    mnuRunUntilReturn: TMenuItem;
    mnuShowExecutionPoint: TMenuItem;
    mnuProgramPause: TMenuItem;
    mnuProgramReset: TMenuItem;
    N9: TMenuItem;
    mnuInspect: TMenuItem;
    mnuEvaluateModify: TMenuItem;
    mnuAddWatch: TMenuItem;
    mnuAddBreakpoint: TMenuItem;
    mnuEditorOptions: TMenuItem;
    mnuDebuggerOptions: TMenuItem;
    mnuRepository: TMenuItem;
    mnuConfigureTools: TMenuItem;
    N10: TMenuItem;
    mnuSQLTool: TMenuItem;
    mnuImageEditor: TMenuItem;
    mnuUndo: TMenuItem;
    mnuRedo: TMenuItem;
    N11: TMenuItem;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    mnuDelete: TMenuItem;
    mnuSelectAll: TMenuItem;
    mnuFind: TMenuItem;
    mnuFindinFiles: TMenuItem;
    mnuReplace: TMenuItem;
    mnuSearchAgain: TMenuItem;
    mnuIncrementalSearch: TMenuItem;
    N12: TMenuItem;
    mnuGotoLineNumber: TMenuItem;
    mnuFindError: TMenuItem;
    N13: TMenuItem;
    mnuBrowseSymbol: TMenuItem;
    mnuProjectManager: TMenuItem;
    mnuObjectInspector: TMenuItem;
    mnuAlignmentPalette: TMenuItem;
    mnuBrowser: TMenuItem;
    mnuCodeExplorer: TMenuItem;
    N14: TMenuItem;
    mnuToggle: TMenuItem;
    mnuViewUnits: TMenuItem;
    mnuViewForms: TMenuItem;
    N15: TMenuItem;
    mnuNewEditWindow: TMenuItem;
    N16: TMenuItem;
    mnuToolbars: TMenuItem;
    mnuTbrStandard: TMenuItem;
    btnPause: TToolButton;
    T4: TToolButton;
    btnTraceInto: TToolButton;
    btnStepOver: TToolButton;
    pnlRgt: TPanel;
    vstStructure: TVirtualStringTree;
    vstProjectMngr: TVirtualStringTree;
    splVer2: TSplitter;
    alActions: TActionList;
    acFileOpen: TAction;
    acFileNew: TAction;
    acBuild: TAction;
    mnuBuild: TMenuItem;
    acCompile: TAction;
    mnuCompile: TMenuItem;
    bla1: TMenuItem;
    bla2: TMenuItem;
    bla3: TMenuItem;
    bla4: TMenuItem;
    acNewApplication: TAction;
    Application: TMenuItem;
    acNewForm: TAction;
    Form: TMenuItem;
    acNewUnit: TAction;
    acNewUnit1: TMenuItem;
    acOpenProject: TAction;
    acFileSave: TAction;
    acEnvironmentOptions: TAction;
    acProjectOptions: TAction;
    acCompileAll: TAction;
    acSyntaxCheck: TAction;
    acViewSource: TAction;
    acAddToProject: TAction;
    acRemoveFromProject: TAction;
    acBuildAll: TAction;
    procedure FormShow(Sender: TObject);
    procedure acBuildExecute(Sender: TObject);
    procedure acCompileExecute(Sender: TObject);
    procedure acFileNewExecute(Sender: TObject);
    procedure acFileOpenExecute(Sender: TObject);
    procedure acEnvironmentOptionsExecute(Sender: TObject);
    procedure acProjectOptionsExecute(Sender: TObject);
    procedure acCompileAllExecute(Sender: TObject);
    procedure acSyntaxCheckExecute(Sender: TObject);
    procedure acViewSourceExecute(Sender: TObject);
    procedure acAddToProjectExecute(Sender: TObject);
    procedure acRemoveFromProjectExecute(Sender: TObject);
    procedure acBuildAllExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses frmProjectOptions, frmEnvironmentOptions;

{$R *.dfm}
procedure TfrmMain.FormShow(Sender: TObject);
var
  HasDebugInfo: boolean;
begin
  // debugging information
  HasDebugInfo := {False;}True;

  // tcDebug normally not visible, only when debug info available
  tcDebug.Visible := HasDebugInfo;
end;

procedure TfrmMain.acBuildExecute(Sender: TObject);
var
  Res: integer;
  FPCDemoFolder: string;
  FPCBuildCmd: string;
begin
  // fpc stuff
  FPCDemoFolder := 'D:\fpc\2.6.2\win32\demo\win32';
  FPCBuildCmd :=  '';

//  Res := ExecuteAndWait(FPCDemoFolder + '\' + 'fp.exe', 0, 1000, True);

end;

procedure TfrmMain.acCompileExecute(Sender: TObject);
var
  FProcess: TdnDirectProcess;
  FApplication: Utf8String;
  FProcessFolder, FCompilerFolder, FArgumentName, FCompilerName: Utf8String;
  Res: integer;
begin

  // folders
  FProcessFolder := 'D:\fpc\2.6.2\win32\demo\win32';
  FCompilerFolder := 'D:\fpc\2.6.2\win32\bin\i386-win32';
  FCompilerName := 'ppc386.exe';
  FArgumentName := 'winhello.pp';

  // Create a direct process with a command and reply file
  FProcess := TdnDirectProcess.Create;
  try
    // command file
    FProcess.CommandFile := 'bla';
    // reply file
    FProcess.ReplyFile := 'bla';

    // Application
    FApplication := FCompilerFolder + FCompilerName + ' ' + FProcessFolder + FArgumentName;

    // Now run the compiler..
    Res := FProcess.Run(FApplication);



  finally
    // free the process
    FProcess.Free;
  end;
end;

procedure TfrmMain.acFileNewExecute(Sender: TObject);
begin
//
end;

procedure TfrmMain.acFileOpenExecute(Sender: TObject);
var
  Dlg: TOpenDialog;
begin
  Dlg := TOpenDialog.Create(Self);
  try
    Dlg.Title := 'open source file';
    Dlg.InitialDir := FDynodeProjectsFolder;
    Dlg.Options := [ofFileMustExist];
    if Dlg.Execute then
    begin
      sneCode.Lines.LoadFromFile(Dlg.FileName);
      tsProject.Caption := '[' + Dlg.FileName + ']';
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TfrmMain.acEnvironmentOptionsExecute(Sender: TObject);
begin
  // invoke environment options
  dlgEnvironmentOptions.Show;
end;

procedure TfrmMain.acProjectOptionsExecute(Sender: TObject);
begin
  // invoke the project options
  dlgProjectOptions.Show;
end;

procedure TfrmMain.acCompileAllExecute(Sender: TObject);
begin
//
end;

procedure TfrmMain.acSyntaxCheckExecute(Sender: TObject);
begin
//
end;

procedure TfrmMain.acViewSourceExecute(Sender: TObject);
begin
//
end;

procedure TfrmMain.acAddToProjectExecute(Sender: TObject);
begin
//
end;

procedure TfrmMain.acRemoveFromProjectExecute(Sender: TObject);
begin
//
end;

procedure TfrmMain.acBuildAllExecute(Sender: TObject);
begin
//
end;

end.

