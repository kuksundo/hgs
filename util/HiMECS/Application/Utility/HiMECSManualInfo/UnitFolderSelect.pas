unit UnitFolderSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  JvExMask, JvToolEdit;

type
  TFolderSelectF = class(TForm)
    Label1: TLabel;
    JvDirectoryEdit1: TJvDirectoryEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FolderSelectF: TFolderSelectF;

implementation

{$R *.dfm}

end.
