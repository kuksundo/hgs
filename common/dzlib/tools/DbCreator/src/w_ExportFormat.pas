unit w_ExportFormat;

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
  ExtCtrls,
  Buttons, Mask, JvExMask, JvToolEdit;

type
  TExportFormat = (efDelphi, efVisualBasic, efOracle, efMsSql, efAccess, efXml,
    efGraphViz, efHtml);
  TExportFormatSet = set of TExportFormat;

const
  EXPORT_FORMAT_NAMES: array[TExportFormat] of string = (
    'Delphi Code', 'VB Code', 'Oracle', 'MS SQL', 'MS Access', 'XML', 'GraphViz',
    'HTML'
    );

type
  Tf_ExportFormat = class(TForm)
    chk_DelphiCode: TCheckBox;
    chk_VbCode: TCheckBox;
    chk_Oracle: TCheckBox;
    chk_MsSql: TCheckBox;
    chk_Access: TCheckBox;
    chk_Xml: TCheckBox;
    chk_GraphViz: TCheckBox;
    chk_Html: TCheckBox;
    ed_DelphiFile: TJvFilenameEdit;
    ed_VbFile: TJvFilenameEdit;
    ed_OracleFile: TJvFilenameEdit;
    ed_MsSqlFile: TJvFilenameEdit;
    ed_AccessFile: TJvFilenameEdit;
    ed_XmlFile: TJvFilenameEdit;
    ed_GraphVizFile: TJvFilenameEdit;
    ed_HtmlFile: TJvFilenameEdit;
    procedure chk_CheckboxClick(Sender: TObject);
  private
  public
    procedure SetBaseFilename(const _BaseFilename: string);
    function GetFormat: TExportFormatSet;
    function GetFilename(_ExportFormat: TExportFormat): string;
  end;

implementation

{$R *.DFM}

{ Tf_ExportFormat }

function Tf_ExportFormat.GetFormat: TExportFormatSet;
begin
  Result := [];
  if chk_DelphiCode.Checked then
    Include(Result, efDelphi);
  if chk_VbCode.Checked then
    Include(Result, efVisualBasic);
  if chk_Oracle.Checked then
    Include(Result, efOracle);
  if chk_MsSql.Checked then
    Include(Result, efMsSql);
  if chk_Access.Checked then
    Include(Result, efAccess);
  if chk_Xml.Checked then
    Include(Result, efXml);
  if chk_GraphViz.Checked then
    Include(Result, efGraphViz);
  if chk_Html.Checked then
    Include(Result, efHtml);
end;

procedure Tf_ExportFormat.chk_CheckboxClick(Sender: TObject);
var
  i: integer;
  Tag: integer;
  Comp: TComponent;
begin
  Tag := (Sender as TCheckBox).Tag;
  for i := 0 to self.ComponentCount - 1 do
    begin
      Comp := self.Components[i];
      if (Comp.Tag = Tag) and ((Comp is TEdit) or (Comp is TJvFilenameEdit)) then
        (Comp as TControl).Enabled := (Sender as TCheckbox).Checked;
    end;
end;

function Tf_ExportFormat.GetFilename(_ExportFormat: TExportFormat): string;
begin
  case _ExportFormat of
    efDelphi: Result := ed_DelphiFile.Text;
    efVisualBasic: Result := ed_VbFile.Text;
    efOracle: Result := ed_OracleFile.Text;
    efMsSql: Result := ed_MsSqlFile.Text;
    efAccess: Result := ed_AccessFile.Text;
    efXml: Result := ed_XmlFile.Text;
    efGraphViz: Result := ed_GraphVizFile.Text;
    efHtml: Result := ed_HtmlFile.Text;
  else
    Result := '';
  end;
end;

procedure Tf_ExportFormat.SetBaseFilename(const _BaseFilename: string);
var
  s: string;
begin
  s := ChangeFileExt(_BaseFilename, '');
  ed_DelphiFile.Text := s + '.pas';
  ed_VbFile.Text := s + '.bas';
  ed_OracleFile.Text := s + '-oracle.xml';
  ed_MsSqlFile.Text := s + '-mssql.xml';
  ed_AccessFile.Text := s + '.mdb';
  ed_XmlFile.Text := s + '.xml';
  ed_GraphVizFile.Text := s + '.dot';
  ed_HtmlFile.Text := s + '.html';
end;

end.

