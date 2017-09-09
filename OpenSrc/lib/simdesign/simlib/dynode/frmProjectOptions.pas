unit frmProjectOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TdlgProjectOptions = class(TForm)
    cbDefault: TCheckBox;
    mnuOK: TButton;
    mnuCancel: TButton;
    mnuHelp: TButton;
    PageControl1: TPageControl;
    tsDirectories: TTabSheet;
    tsVersionInfo: TTabSheet;
    tsPackages: TTabSheet;
    tsForms: TTabSheet;
    tsApplication: TTabSheet;
    tsCompiler: TTabSheet;
    tsCompilerMessages: TTabSheet;
    tsLinker: TTabSheet;
    gbDirectories: TGroupBox;
    cbbOutputFolder: TComboBox;
    lbOutputFolder: TLabel;
    btnOutputFolder: TButton;
    cbbUnitOutputFolder: TComboBox;
    lbUnitOutputFolder: TLabel;
    btnUnitOutputFolder: TButton;
    lbSearchPath: TLabel;
    cbbSearchPath: TComboBox;
    btnSearchPath: TButton;
    lbDebugSourcePath: TLabel;
    cbbDebugSourcePath: TComboBox;
    btnDebugSourcePath: TButton;
    lbDPLOutputFolder: TLabel;
    cbbDPLOutputFolder: TComboBox;
    btnDPLOutputFolder: TButton;
    lbDCPOutputFolder: TLabel;
    cbbDCPOutputFolder: TComboBox;
    btnDCPOutputFolder: TButton;
    gbConditionals: TGroupBox;
    lbConditionalDefines: TLabel;
    cbbConditionalDefines: TComboBox;
    btnConditionalDefines: TButton;
    gbAliases: TGroupBox;
    lbUnitAliases: TLabel;
    cbbUnitAliases: TComboBox;
    btnUnitAliases: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgProjectOptions: TdlgProjectOptions;

implementation

{$R *.dfm}

end.
