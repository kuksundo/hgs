unit w_SourceFile;

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
  StdCtrls,
  Mask,
  JvExMask,
  JvToolEdit,
  JvComponentBase,
  JvFormPlacement;

type
  Tf_SourceFile = class(TForm)
    fe_SourceFile: TJvFilenameEdit;
    l_DbPassword: TLabel;
    TheFormStorage: TJvFormStorage;
    chk_IncludeData: TCheckBox;
    chk_MakeAutoInc: TCheckBox;
    chk_ConsolidateIndices: TCheckBox;
    ed_DbPassword: TEdit;
    procedure FormResize(Sender: TObject);
  private
  public
  end;

implementation

{$R *.DFM}

procedure Tf_SourceFile.FormResize(Sender: TObject);
begin
  fe_SourceFile.Width := self.ClientWidth;
  ed_DbPassword.Width := self.ClientWidth;
end;

end.

