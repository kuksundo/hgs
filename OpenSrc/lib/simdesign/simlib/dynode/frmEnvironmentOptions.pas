unit frmEnvironmentOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TdlgEnvironmentOptions = class(TForm)
    pcEnvironmentOptions: TPageControl;
    tsPreferences: TTabSheet;
    tsDesigner: TTabSheet;
    tsObjectInspector: TTabSheet;
    tsPalette: TTabSheet;
    tsLibrary: TTabSheet;
    tsExplorer: TTabSheet;
    tsTypeLibrary: TTabSheet;
    tsEnvironmVariables: TTabSheet;
    tsDynodeDirect: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgEnvironmentOptions: TdlgEnvironmentOptions;

implementation

{$R *.dfm}

end.
