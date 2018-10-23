unit FrmSearchVDR;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.Buttons,
  Vcl.StdCtrls, JvExControls, JvLabel, Vcl.ExtCtrls, UnitHGSVDRRecord;

type
  TSearchVDRF = class(TForm)
    Panel1: TPanel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel9: TJvLabel;
    SearchButton: TButton;
    HullNoEdit: TEdit;
    ShipNameEdit: TEdit;
    ImoNoEdit: TEdit;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    VDRListGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    HullNo: TNxTextColumn;
    ShipName: TNxTextColumn;
    ImoNo: TNxTextColumn;
    ProjectNo: TNxTextColumn;
    VDRSerialNo: TNxTextColumn;
    MainBoard: TNxTextColumn;
    Video: TNxTextColumn;
    HDD: TNxTextColumn;
    HINEI: TNxTextColumn;
    VDRType: TNxTextColumn;
    DeliveryDate: TNxDateColumn;
    UpdateDate: TNxDateColumn;
    VCSType: TNxTextColumn;
    CapsuleType: TNxTextColumn;
    Remark: TNxTextColumn;
    JvLabel1: TJvLabel;
    VDRSerialNoEdit: TEdit;
    VDRConfig: TNxTextColumn;
    procedure SearchButtonClick(Sender: TObject);
    procedure VDRListGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure HullNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure ShipNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure ImoNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure VDRSerialNoEditKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ExecuteSearch(Key: Char);
  public
    procedure GetVDRListFromVariant2Grid(ADoc: Variant);
    procedure GetVDRSearchParam2Rec(var AVDRSearchParamRec: TVDRSearchParamRec);
    procedure GetVDRList2Grid;
  end;

var
  SearchVDRF: TSearchVDRF;

implementation

uses CommonData, UnitHGSVDRData, UnitFolderUtil, SynCommons;

{$R *.dfm}

procedure TSearchVDRF.ExecuteSearch(Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    SearchButtonClick(nil);
end;

procedure TSearchVDRF.GetVDRList2Grid;
var
  LSQLHGSVDRRecord: TSQLHGSVDRRecord;
  LVDRSearchParamRec: TVDRSearchParamRec;
  LDoc: Variant;
  LStr: string;
begin
  if not Assigned(g_HGSVDRDB) then
  begin
    LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
    InitHGSVDRClient(LStr+'VDRList.sqlite');
  end;

  VDRListGrid.BeginUpdate;
  try
    VDRListGrid.ClearRows;
    GetVDRSearchParam2Rec(LVDRSearchParamRec);
    LSQLHGSVDRRecord := GetHGSVDRRecordFromSearchRec(LVDRSearchParamRec);

    if LSQLHGSVDRRecord.IsUpdate then
    begin
      LDoc := GetVariantFromHGSVDRRecord(LSQLHGSVDRRecord);
      GetVDRListFromVariant2Grid(LDoc);

      while LSQLHGSVDRRecord.FillOne do
      begin
        LDoc := GetVariantFromHGSVDRRecord(LSQLHGSVDRRecord);
        GetVDRListFromVariant2Grid(LDoc);
      end;//while
    end;
  finally
    VDRListGrid.EndUpdate;
  end;
end;

procedure TSearchVDRF.GetVDRListFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
begin
  LRow := VDRListGrid.AddRow;

  VDRListGrid.CellsByName['HullNo', LRow] := ADoc.HullNo;
  VDRListGrid.CellsByName['ShipName', LRow] := ADoc.ShipName;
  VDRListGrid.CellsByName['ImoNo', LRow] := ADoc.ImoNo;
  VDRListGrid.CellsByName['ProjectNo', LRow] := ADoc.ProjectNo;
  VDRListGrid.CellsByName['VDRSerialNo', LRow] := ADoc.VDRSerialNo;
  VDRListGrid.CellsByName['MainBoard', LRow] := ADoc.MainBoard;
  VDRListGrid.CellsByName['Video', LRow] := ADoc.Video;
  VDRListGrid.CellsByName['HDD', LRow] := ADoc.HDD;
  VDRListGrid.CellsByName['HINEI', LRow] := ADoc.HINEI;
  VDRListGrid.CellsByName['VDRType', LRow] := ADoc.VDRType;
  VDRListGrid.CellsByName['VCSType', LRow] := ADoc.VCSType;
  VDRListGrid.CellsByName['CapsuleType', LRow] := ADoc.CapsuleType;

  VDRListGrid.CellsByName['Remark', LRow] := ADoc.Remark;
  VDRListGrid.CellsByName['VDRConfig', LRow] := ADoc.VDRConfig;
  VDRListGrid.CellsByName['DeliveryDate', LRow] := DateTimeToStr(TimeLogToDateTime(ADoc.DeliveryDate));
  VDRListGrid.CellsByName['UpdateDate', LRow] := DateTimeToStr(TimeLogToDateTime(ADoc.UpdateDate));
end;

procedure TSearchVDRF.GetVDRSearchParam2Rec(
  var AVDRSearchParamRec: TVDRSearchParamRec);
begin
  AVDRSearchParamRec := Default(TVDRSearchParamRec);
  AVDRSearchParamRec.fHullNo := HullNoEdit.Text;
  AVDRSearchParamRec.fShipName := ShipNameEdit.Text;
  AVDRSearchParamRec.fIMONo := ImoNoEdit.Text;
  AVDRSearchParamRec.fVDRSerialNo := VDRSerialNoEdit.Text;
end;

procedure TSearchVDRF.HullNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TSearchVDRF.ImoNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TSearchVDRF.SearchButtonClick(Sender: TObject);
begin
  GetVDRList2Grid;
end;

procedure TSearchVDRF.ShipNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TSearchVDRF.VDRListGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  ModalResult := mrOK;
end;

procedure TSearchVDRF.VDRSerialNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

end.
