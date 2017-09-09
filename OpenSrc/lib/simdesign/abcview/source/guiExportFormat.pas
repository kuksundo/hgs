{ unit ExportFormats

  Implementation of the export wizard

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiExportFormat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Mask, rxToolEdit, RXCtrls;

type
  TfrmExport = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    btnPrev: TButton;
    btnNext: TButton;
    BitBtn2: TBitBtn;
    nbExport: TNotebook;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    rbSelected: TRadioButton;
    rbCurrentView: TRadioButton;
    rbAllItems: TRadioButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    cbbFormat: TComboBox;
    lbSubFormat: TLabel;
    cbbSubFormat: TComboBox;
    fsExport: TSaveDialog;
    Label4: TLabel;
    Label5: TLabel;
    deBaseFolder: TDirectoryEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    clbFiles: TRxCheckListBox;
    RxCheckListBox2: TRxCheckListBox;
    RxCheckListBox3: TRxCheckListBox;
    RxCheckListBox4: TRxCheckListBox;
    chbFiles: TCheckBox;
    chbFolders: TCheckBox;
    chbSeries: TCheckBox;
    chbGroups: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    rbDelimComma: TRadioButton;
    rbDelimTab: TRadioButton;
    rbDelimCustom: TRadioButton;
    edDelimiter: TEdit;
    chbUseQuotes: TCheckBox;
    Label13: TLabel;
    Label14: TLabel;
    procedure cbbFormatChange(Sender: TObject);
  private
    { Private declarations }
  public
    FSelectedCount: integer;
    FViewCount: integer;
    FAllItemsCount: integer;
    procedure DoExportWizard;
    procedure DoStep1(Sender: TObject);
    procedure Step1Next(Sender: TObject);
    procedure DoSelectFields(Sender: TObject);
    procedure SelectFieldsNext(Sender: TObject);
    procedure DoStep3(Sender: TObject);
    procedure DoDelimiters(Sender: TObject);
    procedure DelimitersNext(Sender: TObject);
    procedure DoStep4(Sender: TObject);
    procedure Step4Next(Sender: TObject);
  end;

const

  // Export status constants

  esOK        = 0;  // Export OK
  esInitError = 1;  // Initialisation error

implementation

uses
  guiMain, sdRoots, ExportCSVs, ExportXMLs, guiFeedback;

{$R *.DFM}

procedure TfrmExport.DoExportWizard;
begin
  DoStep1(Self);
  if ShowModal = mrOK then begin
  end;
end;

procedure TfrmExport.DoStep1(Sender: TObject);
begin
  // Welcome + select export type screen
  nbExport.ActivePage := 'Step1';

  // Set buttons
  btnNext.Enabled := True;
  btnNext.Caption := 'Next >';
  btnNext.OnClick := Step1Next;
  btnPrev.Enabled := False;
  btnPrev.OnClick := nil;

  // Count export items
  FSelectedCount := 0;
  if assigned(frmMain.SelectedItems) then
    FSelectedCount := frmMain.SelectedItems.Count;
  FViewCount := 0;
  if assigned(frmMain.View) then
    FViewCount := frmMain.View.ItemList.Count;
  FAllItemsCount := 0;
  if assigned(frmMain.Root) then
    FAllItemsCount := frmMain.Root.Count;

  // Set values in controls
  rbSelected.Caption := Format('The selected items (%d items)' , [FSelectedCount]);
  rbSelected.Enabled := (FSelectedCount > 0);
  rbCurrentView.Caption := Format('The current view (%d items)' , [FViewCount]);
  rbCurrentView.Enabled := (FViewCount > 0);
  rbAllItems.Caption := Format('All items in the catalog (%d items)' , [FAllItemsCount]);
  rbAllItems.Enabled := (FAllItemsCount > 0);

  // Set comboboxes
  if cbbFormat.ItemIndex < 0 then
    cbbFormat.ItemIndex := 1;

  case cbbFormat.ItemIndex of
  0: // ABC-View export
    begin
      lbSubFormat.Visible := False;
      cbbSubFormat.Visible := False;
    end;
  1: // CSV export
    begin
      lbSubFormat.Visible := True;
      cbbSubFormat.Visible := True;
      cbbSubFormat.Items.Text :=
        'Hunter CSV scheme'#13#10'Custom CSV scheme';
      if cbbSubformat.ItemIndex < 0 then
        cbbSubformat.ItemIndex := 0;
    end;
  2: // XML export
    begin
      lbSubFormat.Visible := False;
      cbbSubFormat.Visible := False;
    end;
  end;//case
end;

procedure TfrmExport.Step1Next(Sender: TObject);
procedure NotSupported;
begin
  // No support yet
  MessageDlg('This format is not yet supported in this version of ABC-View Manager.',
    mtInformation, [mbOK, mbHelp], 0);
end;
begin
  case cbbFormat.ItemIndex of
  1: // CSV
    begin
      case cbbSubFormat.ItemIndex of
      0: // Hunter CSV files
        begin
          fsExport.Filter := 'Hunter CSV files (*.csv)|*.csv';
          fsExport.DefaultExt := 'csv';
          btnPrev.Enabled := True;
          btnPrev.OnClick := DoStep1;
          DoStep3(Sender);
        end;
      1: // Custom style
        begin
          fsExport.Filter := 'Custom CSV files (*.csv)|*.csv';
          fsExport.DefaultExt := 'csv';
          btnPrev.Enabled := True;
          btnPrev.OnClick := DoStep1;
          DoSelectFields(Sender);
        end;
      else
        NotSupported;
      end;
    end;
  2: // XML
    begin
      fsExport.Filter := 'XML files (*.xml)|*.xml';
      fsExport.DefaultExt := 'xml';
      btnPrev.Enabled := True;
      btnPrev.OnClick := DoStep1;
      DoSelectFields(Sender);
    end;
  else
    NotSupported;
  end;//case
end;

procedure TfrmExport.DoSelectFields(Sender: TObject);
begin
  // Export Fields
  nbExport.ActivePage := 'SelectFields';

  // Set buttons
  btnNext.Enabled := True;
  btnNext.Caption := 'Next >';
  btnNext.OnClick := SelectFieldsNext;

end;

procedure TfrmExport.SelectFieldsNext(Sender: TObject);
begin
  btnPrev.Enabled := True;
  btnPrev.OnClick := DoSelectFields;
  // Custom CSV requires one more screen
  if (cbbFormat.ItemIndex = 1) and (cbbSubFormat.ItemIndex = 1) then begin
    DoDelimiters(Sender);
  end else begin
    DoStep4(Sender);
  end;
end;

procedure TfrmExport.DoDelimiters(Sender: TObject);
begin
  nbExport.ActivePage := 'Delimiters';
  btnNext.OnClick := DelimitersNext;
end;

procedure TfrmExport.DelimitersNext(Sender: TObject);
begin
  btnPrev.OnClick := DoDelimiters;
  DoStep4(Sender);
end;

procedure TfrmExport.DoStep3(Sender: TObject);
begin
  // Ask user for base folder
  nbExport.ActivePage := 'Step3';

  // Set buttons
  btnNext.Enabled := True;
  btnNext.Caption := 'Next >';
  btnNext.OnClick := DoStep4;
end;

procedure TfrmExport.DoStep4(Sender: TObject);
var
  i: integer;
  ExportList: TList;
  OutFile: TStream;
  CSVOptions: TCSVOptions;
  XMLOptions: TXMLOptions;
begin
  if fsExport.Execute then begin

    // Create the export list
    ExportList := TList.Create;
    try

      // Make a copy of the selected list
      if rbSelected.Checked and assigned(frmMain.SelectedItems) then
        for i := 0 to frmMain.SelectedItems.Count - 1 do
          ExportList.Add(frmMain.SelectedItems[i]);

      // Make a copy of the view list
      if rbCurrentView.Checked and assigned(frmMain.View) then
        for i := 0 to frmMain.View.ItemList.Count - 1 do
          ExportList.Add(frmMain.View.ItemList[i]);

      // Make a copy of the view list
      if rbAllItems.Checked and assigned(frmMain.Root) then
        for i := 0 to frmMain.Root.Count - 1 do
          ExportList.Add(frmMain.Root[i]);

      // Save the file in the selected format
      try
        OutFile := TFileStream.Create(fsExport.FileName, fmCreate or fmShareDenyWrite);
        Feedback.Start;
        try
          case cbbFormat.ItemIndex of
          1:
            begin
              // Export to CSV
              Feedback.Add(Format('CSV export to %s',[fsExport.FileName]));
              // Load the options
              with CSVOptions do begin
                FSubFormat := cbbSubFormat.ItemIndex;
                FBaseFolder := IncludeTrailingPathDelimiter(deBaseFolder.Text);
                FFiles := clbFiles;
                if rbDelimComma.Checked then FDelim := ',';
                if rbDelimTab.Checked then FDelim := #9;
                if rbDelimCustom.Checked then FDelim := edDelimiter.Text;
                FUseQuotes := chbUseQuotes.Checked;
              end;
              ExportCSVReportToFile(OutFile, ExportList, CSVOptions, Feedback);
            end;
          2:
            begin
              Feedback.Add(Format('XML export to %s',[fsExport.FileName]));
              XMLOptions.Files := clbFiles;
              ExportXMLReportToFile(OutFile, ExportList, XMLOptions, Feedback);
            end;
          end;//case
        finally
          Feedback.Finish;
          OutFile.Free;
        end;
      except
        ShowMessage(Format('Unable to create %s',[fsExport.FileName]));
      end;
    finally
      ExportList.Free;
    end;

    if Feedback.Tasks[0].Status = tsCompleted then begin

      // Show "Success" page
      nbExport.ActivePage := 'Step4';

      // Set buttons
      btnNext.Enabled := True;
      btnNext.Caption := 'Finish!';
      btnNext.OnClick := Step4Next;
      btnPrev.Enabled := True;
      btnPrev.OnClick := DoStep3;
    end;

  end;
end;

procedure TfrmExport.Step4Next(Sender: TObject);
begin
  // Result is OK
  ModalResult := mrOK;
end;

procedure TfrmExport.cbbFormatChange(Sender: TObject);
begin
  DoStep1(Sender);
end;

end.
