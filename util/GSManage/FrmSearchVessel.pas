unit FrmSearchVessel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  JvExControls, JvLabel, Vcl.Buttons, Vcl.ExtCtrls, SynCommons,
  UnitVesselMasterRecord;

type
  TSearchVesselF = class(TForm)
    Panel1: TPanel;
    SearchButton: TButton;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    JvLabel5: TJvLabel;
    HullNoEdit: TEdit;
    JvLabel6: TJvLabel;
    ShipNameEdit: TEdit;
    JvLabel9: TJvLabel;
    ImoNoEdit: TEdit;
    VesselListGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    HullNo: TNxTextColumn;
    ShipName: TNxTextColumn;
    ImoNo: TNxTextColumn;
    SClass1: TNxTextColumn;
    ShipType: TNxTextColumn;
    OwnerName: TNxTextColumn;
    DeliveryDate: TNxTextColumn;
    ShipBuilderName: TNxTextColumn;
    ShipTypeDesc: TNxTextColumn;
    VesselStatus: TNxTextColumn;
    DockingSurveyDueDate: TNxDateColumn;
    SpecialSurveyDueDate: TNxDateColumn;
    LastDryDockDate: TNxTextColumn;
    SClass2: TNxTextColumn;
    OwnerID: TNxTextColumn;
    TechManagerCountry: TNxTextColumn;
    TechManagerID: TNxTextColumn;
    OperatorID: TNxTextColumn;
    BuyingCompanyCountry: TNxTextColumn;
    BuyingCompanyID: TNxTextColumn;
    procedure VesselListGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure SearchButtonClick(Sender: TObject);
    procedure HullNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure ShipNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure ImoNoEditKeyPress(Sender: TObject; var Key: Char);
  private
    procedure DestroyList4VesselMaster;
    procedure ExecuteSearch(Key: Char);
  public
    procedure GetVesselListFromVariant2Grid(ADoc: Variant);
    procedure GetVesselSearchParam2Rec(var AVesselSearchParamRec: TVesselSearchParamRec);
    procedure GetVesselList2Grid;
  end;

var
  SearchVesselF: TSearchVesselF;

implementation

uses CommonData, UnitVesselData, UnitFolderUtil;

{$R *.dfm}

{ TSearchVesselF }

procedure TSearchVesselF.DestroyList4VesselMaster;
var
  LRow: integer;
begin
  for LRow := 0 to VesselListGrid.RowCount - 1 do
  begin
    TList4VesselMaster(VesselListGrid.Row[LRow].Data).Free;
  end;
end;

procedure TSearchVesselF.ExecuteSearch(Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    SearchButtonClick(nil);
end;

procedure TSearchVesselF.GetVesselList2Grid;
var
  LSQLVesselMaster: TSQLVesselMaster;
  LVesselSearchParamRec: TVesselSearchParamRec;
  LDoc: Variant;
  LStr: string;
begin
  if not Assigned(g_VesselMasterDB) then
  begin
    LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
    InitVesselMasterClient(LStr+'VesselList.sqlite');
  end;

  VesselListGrid.BeginUpdate;
  try
    VesselListGrid.ClearRows;
    GetVesselSearchParam2Rec(LVesselSearchParamRec);
    LSQLVesselMaster := GetVesselMasterFromSearchRec(LVesselSearchParamRec);

    if LSQLVesselMaster.IsUpdate then
    begin
      DestroyList4VesselMaster;

      LDoc := GetVariantFromVesselMaster(LSQLVesselMaster);
      GetVesselListFromVariant2Grid(LDoc);

      while LSQLVesselMaster.FillOne do
      begin
        LDoc := GetVariantFromVesselMaster(LSQLVesselMaster);
        GetVesselListFromVariant2Grid(LDoc);
      end;//while
    end;
  finally
    VesselListGrid.EndUpdate;
  end;
end;

procedure TSearchVesselF.GetVesselListFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
begin
  LRow := VesselListGrid.AddRow;

  VesselListGrid.Row[LRow].Data := TList4VesselMaster.Create;
  TList4VesselMaster(VesselListGrid.Row[LRow].Data).TaskId := ADoc.TaskID;
  TList4VesselMaster(VesselListGrid.Row[LRow].Data).HullNo := ADoc.HullNo;
  TList4VesselMaster(VesselListGrid.Row[LRow].Data).ShipName := ADoc.ShipName;
  TList4VesselMaster(VesselListGrid.Row[LRow].Data).ImoNo := ADoc.ImoNo;

  VesselListGrid.CellsByName['HullNo', LRow] := ADoc.HullNo;
  VesselListGrid.CellsByName['ShipName', LRow] := ADoc.ShipName;
  VesselListGrid.CellsByName['ImoNo', LRow] := ADoc.ImoNo;
  VesselListGrid.CellsByName['SClass1', LRow] := ADoc.SClass1;
  VesselListGrid.CellsByName['ShipType', LRow] := ADoc.ShipType;
  VesselListGrid.CellsByName['OwnerName', LRow] := ADoc.OwnerName;
  VesselListGrid.CellsByName['ShipBuilderName', LRow] := ADoc.ShipBuilderName;
  VesselListGrid.CellsByName['VesselStatus', LRow] := ADoc.VesselStatus;
  VesselListGrid.CellsByName['SClass2', LRow] := ADoc.SClass2;
  VesselListGrid.CellsByName['OwnerID', LRow] := ADoc.OwnerID;
  VesselListGrid.CellsByName['TechManagerCountry', LRow] := ADoc.TechManagerCountry;
  VesselListGrid.CellsByName['TechManagerID', LRow] := ADoc.TechManagerID;
  VesselListGrid.CellsByName['OperatorID', LRow] := ADoc.OperatorID;
  VesselListGrid.CellsByName['BuyingCompanyCountry', LRow] := ADoc.BuyingCompanyCountry;
  VesselListGrid.CellsByName['BuyingCompanyID', LRow] := ADoc.BuyingCompanyID;
  VesselListGrid.CellsByName['DeliveryDate', LRow] := DateTimeToStr(TimeLogToDateTime(ADoc.DeliveryDate));
  VesselListGrid.CellsByName['LastDryDockDate', LRow] := ADoc.LastDryDockDate;
  VesselListGrid.CellsByName['ShipTypeDesc', LRow] := ADoc.ShipTypeDesc;
  VesselListGrid.CellByName['SpecialSurveyDueDate', LRow].AsDateTime := TimeLogToDateTime(ADoc.SpecialSurveyDueDate);
  VesselListGrid.CellByName['DockingSurveyDueDate', LRow].AsDateTime := TimeLogToDateTime(ADoc.DockingSurveyDueDate);
end;

procedure TSearchVesselF.GetVesselSearchParam2Rec(
  var AVesselSearchParamRec: TVesselSearchParamRec);
begin
  AVesselSearchParamRec.fQueryDate := vqdtNull;
  AVesselSearchParamRec.fHullNo := HullNoEdit.Text;
  AVesselSearchParamRec.fShipName := ShipNameEdit.Text;
  AVesselSearchParamRec.fIMONo := ImoNoEdit.Text;
end;

procedure TSearchVesselF.HullNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TSearchVesselF.ImoNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TSearchVesselF.SearchButtonClick(Sender: TObject);
begin
  GetVesselList2Grid;
end;

procedure TSearchVesselF.ShipNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TSearchVesselF.VesselListGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  ModalResult := mrOK;
end;

end.
