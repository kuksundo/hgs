unit w_LogWindow;

{$i globaldef.inc}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  eu.icd.components.grids.LogDisplay;

type
  Tf_LogWindow = class(TForm)
    ld_LogDisplay: THkLogDisplay;
  private
  public
  end;

implementation

{$R *.DFM}

end.

