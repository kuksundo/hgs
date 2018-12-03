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
    Attachments: TNxButtonColumn;
    Files: TNxTextColumn;
    procedure SearchButtonClick(Sender: TObject);
    procedure VDRListGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure HullNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure ShipNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure ImoNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure VDRSerialNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure AttachmentsButtonClick(Sender: TObject);
  private
    procedure ExecuteSearch(Key: Char);
    procedure ShowFileListForm;
  public
    procedure GetVDRListFromVariant2Grid(ADoc: Variant);
    procedure GetVDRSearchParam2Rec(var AVDRSearchParamRec: TVDRSearchParamRec);
    procedure GetVDRList2Grid;
  end;

function CreateSearchVDRFrom(AVDRSerialNo, AImoNo, AHullNo, AShipName: string): TVDRSearchParamRec;

var
  SearchVDRF: TSearchVDRF;

implementation

uses CommonData, UnitHGSVDRData, UnitFolderUtil, SynCommons,
  UnitVariantJsonUtil, FrmGSFileList, UnitGSFileData;

{$R *.dfm}

function CreateSearchVDRFrom(AVDRSerialNo, AImoNo, AHullNo, AShipName: string): TVDRSearchParamRec;
var
  LSearchVDRF: TSearchVDRF;
begin
  LSearchVDRF := TSearchVDRF.Create(nil);
  try
    LSearchVDRF.VDRSerialNoEdit.Text := AVDRSerialNo;

    if AImoNo <> '' then
      LSearchVDRF.ImoNoEdit.Text := AImoNo
    else
    if AHullNo <> '' then
      LSearchVDRF.HullNoEdit.Text := AHullNo
    else
    if AShipName <> '' then
      LSearchVDRF.ShipNameEdit.Text := AShipName;

    if (LSearchVDRF.ImoNoEdit.Text <> '') or (AHullNo <> '')
                                          or (AShipName <> '') then
      LSearchVDRF.SearchButtonClick(nil);

    if LSearchVDRF.ShowModal = mrOK then
    begin
      if LSearchVDRF.VDRListGrid.SelectedRow <> -1 then
      begin
        Result := Default(TVDRSearchParamRec);
        Result.fVDRSerialNo := LSearchVDRF.VDRListGrid.CellsByName['VDRSerialNo',LSearchVDRF.VDRListGrid.SelectedRow];
        Result.fVDRType := LSearchVDRF.VDRListGrid.CellsByName['VDRType',LSearchVDRF.VDRListGrid.SelectedRow];
        Result.fVDRConfig := LSearchVDRF.VDRListGrid.CellsByName['VDRConfig',LSearchVDRF.VDRListGrid.SelectedRow];

        if AHullNo = '' then
          Result.fHullNo := LSearchVDRF.VDRListGrid.CellsByName['HullNo',LSearchVDRF.VDRListGrid.SelectedRow];

        if AShipName = '' then
          Result.fShipName := LSearchVDRF.VDRListGrid.CellsByName['ShipName',LSearchVDRF.VDRListGrid.SelectedRow];

        if AImoNo = '' then
          Result.fIMONo := LSearchVDRF.VDRListGrid.CellsByName['ImoNo',LSearchVDRF.VDRListGrid.SelectedRow];
      end;
    end;
  finally
    LSearchVDRF.Free;
//    DisplayEditPosition;
  end;
end;

procedure TSearchVDRF.AttachmentsButtonClick(Sender: TObject);
var
  LGSFileRecsJson, LImoNo:string;
  LFileCount: integer;
begin
  if VDRListGrid.SelectedRow <> -1 then
  begin
    LGSFileRecsJson := VDRListGrid.CellsByName['Files', VDRListGrid.SelectedRow];
    LImoNo := VDRListGrid.CellsByName['IMONo', VDRListGrid.SelectedRow];

    LFileCount := CreateGSFileListFormFromJSON(LGSFileRecsJson);

    if LFileCount <> -1 then
    begin//LGSFileRecsJson에 변경된 file list가 [{},{}] 형식으로 반환 됨
      VDRListGrid.CellsByName['Files', VDRListGrid.SelectedRow] := LGSFileRecsJson;
      TNxButtonColumn(VDRListGrid.ColumnByName['Attachments']).Editor.Text := IntToStr(LFileCount);
      UpdateHGSVDRAttachments(LImoNo, LGSFileRecsJson);
    end;
  end;
end;

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
//    LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
    InitHGSVDRClient('HGSVDRList.sqlite');
  end;

  VDRListGrid.BeginUpdate;
  try
    VDRListGrid.ClearRows;
    GetVDRSearchParam2Rec(LVDRSearchParamRec);
    LSQLHGSVDRRecord := GetHGSVDRRecordFromSearchRec(LVDRSearchParamRec);
    try
      if LSQLHGSVDRRecord.IsUpdate then
      begin
  //      LDoc := GetVariantFromHGSVDRRecord(LSQLHGSVDRRecord);
  //      GetVDRListFromVariant2Grid(LDoc);
        LSQLHGSVDRRecord.FillRewind;

        while LSQLHGSVDRRecord.FillOne do
        begin
          LDoc := GetVariantFromHGSVDRRecord(LSQLHGSVDRRecord);
          LDoc.Attachments := MakeGSFileRecs2JSON(LSQLHGSVDRRecord.Attachments);
          LDoc.FileCount := High(LSQLHGSVDRRecord.Attachments) + 1;
          GetVDRListFromVariant2Grid(LDoc);
        end;//while
      end;
    finally
      LSQLHGSVDRRecord.Free;
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
  VDRListGrid.CellsByName['Attachments', LRow] := ADoc.FileCount;
  VDRListGrid.CellsByName['Files', LRow] := ADoc.Attachments;

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

procedure TSearchVDRF.ShowFileListForm;
begin
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
