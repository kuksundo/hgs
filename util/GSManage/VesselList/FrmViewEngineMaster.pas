unit FrmViewEngineMaster;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList, Vcl.ComCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.StdCtrls, AeroButtons, Vcl.ExtCtrls,
  UnitEngineMasterRecord, SynCommons, AdvGroupBox, AdvOfficeButtons,
  CurvyControls, JvExControls, JvLabel, Vcl.Menus, CommonData, UnitEngineMasterData;

type
  TViewEngineMasterF = class(TForm)
    Panel1: TPanel;
    btn_Close: TAeroButton;
    EngineMasterGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    ProjectName: TNxTextColumn;
    ProductModel: TNxTextColumn;
    ProductType: TNxTextColumn;
    Class1: TNxTextColumn;
    Class2: TNxTextColumn;
    StatusBar1: TStatusBar;
    ImageList32x32: TImageList;
    FlagImageList: TImageList;
    ProjectNo: TNxTextColumn;
    InstalledCount: TNxTextColumn;
    JvLabel2: TJvLabel;
    PeriodPanel: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    ComboBox1: TComboBox;
    JvLabel5: TJvLabel;
    HullNoEdit: TEdit;
    JvLabel7: TJvLabel;
    btn_Search: TAeroButton;
    AeroButton1: TAeroButton;
    JvLabel1: TJvLabel;
    ProjectNoEdit: TEdit;
    JvLabel3: TJvLabel;
    ProductModelEdit: TEdit;
    JvLabel4: TJvLabel;
    ProjectNameEdit: TEdit;
    JvLabel6: TJvLabel;
    Class1Edit: TEdit;
    ProductTypeCB: TComboBox;
    HullNo: TNxTextColumn;
    ProductDeliveryDate: TNxTextColumn;
    ShipDeliveryDate: TNxTextColumn;
    WarrantyDueDate: TNxTextColumn;
    PopupMenu1: TPopupMenu;
    Quotation1: TMenuItem;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure Quotation1Click(Sender: TObject);
  private
    procedure GetEngineMaster2Grid(AHullNo: string);
    procedure GetEngineMasterSearchParam2Rec(var AEngineSearchParamRec: TEngineSearchParamRec);
    procedure GetEngineMasterFromVariant2Grid(ADoc: Variant);
  public
    procedure GetEngineMasterFromSearchRec2Grid;
  end;

function CreateViewEngineMasterFormFromDB(AHullNo: string): integer;
function GetEngineMasterListFromViewForm(AHullNo:string = ''; AProdType: TEngineProductType = vepteNull): TStringList;

var
  ViewEngineMasterF: TViewEngineMasterF;

implementation

uses UnitProcessUtil;

{$R *.dfm}

function CreateViewEngineMasterFormFromDB(AHullNo: string): integer;
var
  LViewEngineMasterF: TViewEngineMasterF;
begin
  LViewEngineMasterF := TViewEngineMasterF.Create(nil);
  try
    LViewEngineMasterF.GetEngineMaster2Grid(AHullNo);

    LViewEngineMasterF.ShowModal;
  finally
    LViewEngineMasterF.Free;
  end;
end;

function GetEngineMasterListFromViewForm(AHullNo:string; AProdType: TEngineProductType): TStringList;
var
  LSQLEngineMaster:TSQLEngineMaster;
  LViewEngineMasterF: TViewEngineMasterF;
  LStr: string;
  i: integer;
begin
  Result := TStringList.Create;
  Result.Sorted := True;
  LViewEngineMasterF := TViewEngineMasterF.Create(nil);
  try
    with LViewEngineMasterF do
    begin
      if AHullNo <> '' then
      begin
        if AProdType <> vepteNull then
        begin
          HullNoEdit.Text := AHullNo;
          ProductTypeCB.ItemIndex := Ord(AProdType);
          GetEngineMasterFromSearchRec2Grid;
        end;
      end;

      if ShowModal = mrOK then
      begin
        if EngineMasterGrid.RowCount > 0 then
        begin
          for i := 0 to EngineMasterGrid.RowCount - 1 do
          begin
            LStr := EngineMasterGrid.CellsByName['HullNo', i];

            if LStr <> '' then
              if Result.IndexOf(LStr) = -1 then
                Result.Add(LStr);
          end;
        end;
      end;
    end;
  finally
    LViewEngineMasterF.Free;
  end;
end;

{ TViewEngineMasterF }

procedure TViewEngineMasterF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TViewEngineMasterF.btn_SearchClick(Sender: TObject);
begin
  GetEngineMasterFromSearchRec2Grid;
end;

procedure TViewEngineMasterF.FormCreate(Sender: TObject);
begin
  g_EngineProductType.SetType2Combo(ProductTypeCB);
end;

procedure TViewEngineMasterF.GetEngineMaster2Grid(AHullNo: string);
var
  LSQLEngineMaster:TSQLEngineMaster;
  LDoc: Variant;
begin
  EngineMasterGrid.BeginUpdate;
  try
    EngineMasterGrid.ClearRows;
    LSQLEngineMaster := GetEngineMasterFromHullNoStrict(AHullNo);
    try
      if LSQLEngineMaster.IsUpdate then
      begin
        HullNoEdit.Text := AHullNo;
        LSQLEngineMaster.FillRewind;

        while LSQLEngineMaster.FillOne do
        begin
          LDoc := GetVariantFromEngineMaster(LSQLEngineMaster);
          GetEngineMasterFromVariant2Grid(LDoc);
        end;//while

        StatusBar1.Panels[1].Text := IntToStr(EngineMasterGrid.RowCount);
      end;
    finally
      LSQLEngineMaster.Free;
    end;
  finally
    EngineMasterGrid.EndUpdate;
  end;
end;

procedure TViewEngineMasterF.GetEngineMasterFromSearchRec2Grid;
var
  LSQLEngineMaster: TSQLEngineMaster;
  LEngineSearchParamRec: TEngineSearchParamRec;
  LDoc: Variant;
begin
  EngineMasterGrid.BeginUpdate;
  try
    EngineMasterGrid.ClearRows;
    GetEngineMasterSearchParam2Rec(LEngineSearchParamRec);
    LSQLEngineMaster := GetEngineMasterFromSearchRec(LEngineSearchParamRec);

    if LSQLEngineMaster.IsUpdate then
    begin
      LSQLEngineMaster.FillRewind;

      while LSQLEngineMaster.FillOne do
      begin
        LDoc := GetVariantFromEngineMaster(LSQLEngineMaster);
        GetEngineMasterFromVariant2Grid(LDoc);
      end;//while

      StatusBar1.Panels[1].Text := IntToStr(EngineMasterGrid.RowCount);
    end;
  finally
    EngineMasterGrid.EndUpdate;
  end;
end;

procedure TViewEngineMasterF.GetEngineMasterFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
  LDate: TTimeLog;
begin
  LRow := EngineMasterGrid.AddRow;

//  Caption := Caption + '(' + ADoc.HullNo + ')';
  EngineMasterGrid.CellsByName['HullNo', LRow] := ADoc.HullNo;
  EngineMasterGrid.CellsByName['ProjectNo', LRow] := ADoc.ProjectNo;
  EngineMasterGrid.CellsByName['ProjectName', LRow] := ADoc.ProjectName;
  EngineMasterGrid.CellsByName['ProductModel', LRow] := ADoc.ProductModel;
  EngineMasterGrid.CellsByName['ProductType', LRow] := g_EngineProductType.ToString(ADoc.ProductType);
  EngineMasterGrid.CellsByName['Class1', LRow] := ADoc.Class1;
  EngineMasterGrid.CellsByName['Class2', LRow] := ADoc.Class2;
  EngineMasterGrid.CellsByName['InstalledCount', LRow] := ADoc.InstalledCount;

  LDate := ADoc.ProductDeliveryDate;
  if LDate <> 0 then
    EngineMasterGrid.CellsByName['ProductDeliveryDate', LRow] := DateToStr(TimeLogToDateTime(LDate));

  LDate := ADoc.ShipDeliveryDate;
  if LDate <> 0 then
    EngineMasterGrid.CellsByName['ShipDeliveryDate', LRow] := DateToStr(TimeLogToDateTime(LDate));

  LDate := ADoc.WarrantyDueDate;
  if LDate <> 0 then
    EngineMasterGrid.CellsByName['WarrantyDueDate', LRow] := DateToStr(TimeLogToDateTime(LDate));
end;

procedure TViewEngineMasterF.GetEngineMasterSearchParam2Rec(
  var AEngineSearchParamRec: TEngineSearchParamRec);
var
  LEngineMasterQueryDateType: TEngineMasterQueryDateType;
begin
  if ComboBox1.ItemIndex = -1 then
    LEngineMasterQueryDateType := emdtNull
  else
    LEngineMasterQueryDateType := g_EngineMasterQueryDateType.ToType(ComboBox1.ItemIndex);

  AEngineSearchParamRec.QueryDate := g_EngineMasterQueryDateType.ToString(LEngineMasterQueryDateType);
  AEngineSearchParamRec.FFrom := dt_Begin.Date;
  AEngineSearchParamRec.FTo := dt_end.Date;
  AEngineSearchParamRec.HullNo := HullNoEdit.Text;
  AEngineSearchParamRec.Class1 := Class1Edit.Text;
  AEngineSearchParamRec.ProductType := ProductTypeCB.Text;
  AEngineSearchParamRec.ProductModel := ProductModelEdit.Text;
  AEngineSearchParamRec.ProjectName := ProjectNameEdit.Text;
  AEngineSearchParamRec.ProjectNo := ProjectNoEdit.Text;
end;

procedure TViewEngineMasterF.Quotation1Click(Sender: TObject);
var
  LStr, LPath: string;
  LRow: integer;
begin
  LRow := EngineMasterGrid.SelectedRow;

  if LRow <> -1 then
  begin
    LPath := ExtractFilePath(Application.ExeName);
    LStr := '/m' + EngineMasterGrid.CellsByName['ProductModel', LRow];
    LStr := LStr + ' /aM';
    LPath := GetCylCountFromEngineModel(EngineMasterGrid.CellsByName['ProductModel', LRow]);

    if LPath <> '' then
      LStr := LStr + ' /c'+ LPath;

    ExecNewProcess2(LPath+QUOTATION_MANAGE_EXE_NAME, LStr);
  end;
end;

end.
