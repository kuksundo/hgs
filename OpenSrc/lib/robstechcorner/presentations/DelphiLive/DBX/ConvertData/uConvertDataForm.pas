unit uConvertDataForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Menus;

type
  TfrmBDEToDBX = class(TForm)
    cbxAlias: TComboBox;
    Label1: TLabel;
    clbTables: TCheckListBox;
    Label2: TLabel;
    Label3: TLabel;
    cbxConnName: TComboBox;
    lstStatus: TListBox;
    btnConvert: TButton;
    chkMetaDataOnly: TCheckBox;
    cbxDriverName: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    mnuTables: TPopupMenu;
    SelectAll1: TMenuItem;
    SelectNone1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure cbxAliasChange(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure SelectNone1Click(Sender: TObject);
    procedure cbxDriverNameChange(Sender: TObject);
    procedure btnConvertClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateConvertProgress(ProgressStatement : String);
  end;

var
  frmBDEToDBX: TfrmBDEToDBX;

implementation

uses uConvertDataModule;

{$R *.dfm}

procedure TfrmBDEToDBX.btnConvertClick(Sender: TObject);
var
 SL : TStringList;
 I  : Integer;
begin
 SL := TStringList.Create;
 try
   // Clear Previous Status
   lstStatus.Items.Clear;

   // Make List of only the selected tables
   for I := 0 to clbTables.Count - 1 do
   begin
     if clbTables.Checked[I] then
        SL.Add(clbTables.Items[I])
   end;

   // Set Callback Status Event
   dmConvert.OnConvertProgress := UpdateConvertProgress;

   // Perform Conversion
   dmConvert.ConvertTables(SL,cbxDriverName.Text,cbxConnName.text,chkMetaDataOnly.Checked);


 finally
   SL.Free;
 end;
end;

procedure TfrmBDEToDBX.cbxAliasChange(Sender: TObject);
begin
  if cbxAlias.ItemIndex >= 0 then
  begin
     dmConvert.BDEdb.AliasName := cbxAlias.Text;
     dmConvert.BDEdb.Connected := true;
     dmConvert.PopulateTableNames(clbTables.Items);
     dmConvert.BDEdb.Connected := false;
  end
  else
  begin
    clbTables.Items.Clear;
  end;
end;

procedure TfrmBDEToDBX.cbxDriverNameChange(Sender: TObject);
begin
  if cbxDriverName.ItemIndex >= 0 then
  begin
     dmConvert.PopulateDBXConnections(cbxDriverName.Text,cbxConnName.Items);
  end
  else
  begin
     cbxConnName.Items.Clear;
  end;

end;

procedure TfrmBDEToDBX.FormShow(Sender: TObject);
begin
  dmConvert.PopulateBDEAliasList(cbxAlias.Items);
  dmConvert.PopulateDbxDriverNames(cbxDriverName.Items);
end;

procedure TfrmBDEToDBX.SelectAll1Click(Sender: TObject);
var
  I : Integer;
begin
  for I := 0 to clbTables.Items.Count - 1 do
    clbTables.Checked[I] := True;
end;

procedure TfrmBDEToDBX.SelectNone1Click(Sender: TObject);
var
  I : Integer;
begin
  for I := 0 to clbTables.Items.Count - 1 do
    clbTables.Checked[I] := False;
end;

procedure TfrmBDEToDBX.UpdateConvertProgress(ProgressStatement: String);
begin
  lstStatus.Items.Add(ProgressStatement);
end;

end.
