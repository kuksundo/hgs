unit w_Options;

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
  ExtCtrls,
  JvExMask,
  JvSpin,
  JvFormPlacement,
  JvComponentBase;

type
  Tf_Options = class(TForm)
    Label1: TLabel;
    ed_Prefix: TEdit;
    grp_Checksum: TGroupBox;
    chk_AddChecksum: TCheckBox;
    TheFormStorage: TJvFormStorage;
    chk_RemoveChksum: TCheckBox;
    Label2: TLabel;
    grp_GraphViz: TGroupBox;
    chk_ReferencedColumnsOnly: TCheckBox;
    chk_ReferencedTablesOnly: TCheckBox;
    grp_HtmlOptions: TGroupBox;
    l_HeadingStartlevel: TLabel;
    sed_HeadingStartLevel: TJvSpinEdit;
    rg_AccessOptions: TRadioGroup;
    procedure chk_AddChecksumClick(Sender: TObject);
    procedure chk_RemoveChksumClick(Sender: TObject);
  private
  public
    ///<summary> returns 4 for Access 97 and and 5 for Access 2000 </summary>
    function AccessVersion: integer;
  end;

implementation

{$R *.DFM}

function Tf_Options.AccessVersion: integer;
begin
  if rg_AccessOptions.ItemIndex = 0 then
    Result := 4
  else
    Result := 5;
end;

procedure Tf_Options.chk_AddChecksumClick(Sender: TObject);
begin
  if chk_AddChecksum.Checked then
    chk_RemoveChksum.Checked := false;
end;

procedure Tf_Options.chk_RemoveChksumClick(Sender: TObject);
begin
  if chk_RemoveChksum.Checked then
    chk_AddChecksum.Checked := false;
end;

end.

