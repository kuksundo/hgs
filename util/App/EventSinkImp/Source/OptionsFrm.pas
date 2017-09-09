//******************************************************************************
//
// EventSinkImp
//
// Copyright © 1999-2000 Binh Ly
// All Rights Reserved
//
// bly@techvanguards.com
// http://www.techvanguards.com
//******************************************************************************
unit OptionsFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, EventSinkOptions;

type
  TfrmOptions = class(TForm)
    Button1: TButton;
    Button2: TButton;
    rgUsesImportMode: TRadioGroup;
    GroupBox1: TGroupBox;
    lbxSinkTemplates: TListBox;
    GroupBox2: TGroupBox;
    edtComponentPage: TEdit;
    GroupBox3: TGroupBox;
    cbxTLibImpAutoFind: TCheckBox;
    edtTLibImpFile: TEdit;
    btnTLibImpFile: TButton;
    GroupBox4: TGroupBox;
    edtUserDefinedUses: TEdit;
    dlgOpenTLibImpFile: TOpenDialog;
    GroupBox5: TGroupBox;
    cbxRemoveUnderscores: TCheckBox;
    cbxFullyQualify: TCheckBox;
    Button3: TButton;
    procedure rgUsesImportModeClick(Sender: TObject);
    procedure edtComponentPageChange(Sender: TObject);
    procedure lbxSinkTemplatesClick(Sender: TObject);
    procedure edtUserDefinedUsesChange(Sender: TObject);
    procedure cbxTLibImpAutoFindClick(Sender: TObject);
    procedure edtTLibImpFileChange(Sender: TObject);
    procedure btnTLibImpFileClick(Sender: TObject);
    procedure cbxRemoveUnderscoresClick(Sender: TObject);
    procedure cbxFullyQualifyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    FOptions : TEventSinkOptions;
    procedure LoadOptions;
  public
    function Execute (eso : TEventSinkOptions) : integer;
  end;

implementation

{$R *.DFM}

uses
  Utils;

procedure TfrmOptions.LoadOptions;
var
  i : integer;
begin
  with FOptions do
  begin
    rgUsesImportMode.ItemIndex := Ord (UsesImportMode);
    edtComponentPage.Text := SinkPage;

    lbxSinkTemplates.Items.Clear;
    with SinkTemplates do
      for i := 0 to Count - 1 do
        lbxSinkTemplates.Items.Add (Format ('%s (%s)', [Names [i], Values [Names [i]]]));
    lbxSinkTemplates.ItemIndex := SinkTemplate;

    edtUserDefinedUses.Text := UserDefinedUses;
    cbxTLibImpAutoFind.Checked := TLibImpAutoFind;
    edtTLibImpFile.Text := TLibImpFile;
    cbxRemoveUnderscores.Checked := RemoveUnderscores;
    cbxFullyQualify.Checked := FullyQualify;
  end;  { with }
end;

function TfrmOptions.Execute (eso : TEventSinkOptions) : integer;
begin
  Assert (eso <> NIL);
  FOptions := eso;
  LoadOptions;
  Result := ShowModal;
end;

procedure TfrmOptions.rgUsesImportModeClick(Sender: TObject);
begin
  FOptions.UsesImportMode := TUsesImportMode (rgUsesImportMode.ItemIndex);
end;

procedure TfrmOptions.edtComponentPageChange(Sender: TObject);
begin
  FOptions.SinkPage := edtComponentPage.Text;
end;

procedure TfrmOptions.lbxSinkTemplatesClick(Sender: TObject);
begin
  FOptions.SinkTemplate := lbxSinkTemplates.ItemIndex;
end;

procedure TfrmOptions.edtUserDefinedUsesChange(Sender: TObject);
begin
  FOptions.UserDefinedUses := edtUserDefinedUses.Text;
end;

procedure TfrmOptions.cbxTLibImpAutoFindClick(Sender: TObject);
begin
  FOptions.TLibImpAutoFind := cbxTLibImpAutoFind.Checked;
  edtTLibImpFile.Enabled := not (cbxTLibImpAutoFind.Checked);
  btnTLibImpFile.Enabled := not (cbxTLibImpAutoFind.Checked);
end;

procedure TfrmOptions.edtTLibImpFileChange(Sender: TObject);
begin
  FOptions.TLibImpFile := edtTLibImpFile.Text;
end;

procedure TfrmOptions.btnTLibImpFileClick(Sender: TObject);
begin
  with dlgOpenTLibImpFile do
  begin
    if not (Execute) then Exit;
    edtTLibImpFile.Text := Filename;
  end;  { with }
end;

procedure TfrmOptions.cbxRemoveUnderscoresClick(Sender: TObject);
begin
  FOptions.RemoveUnderscores := cbxRemoveUnderscores.Checked;
end;

procedure TfrmOptions.cbxFullyQualifyClick(Sender: TObject);
begin
  FOptions.FullyQualify := cbxFullyQualify.Checked;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  HelpContext := HC_OPTIONS;
end;

procedure TfrmOptions.Button3Click(Sender: TObject);
begin
  Application.HelpContext (HC_OPTIONS);
end;

end.
