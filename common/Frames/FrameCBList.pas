unit FrameCBList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvBaseDlg,
  JvSelectDirectory, Vcl.ExtCtrls, AdvSmoothSplashScreen, Vcl.Menus,
  Vcl.ImgList, NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, SBPro, AdvOfficeTabSet, pjhComboBox, Vcl.StdCtrls,
  AeroButtons, Vcl.ComCtrls, AdvGroupBox, AdvOfficeButtons, JvExControls,
  JvLabel, CurvyControls, FrameDragDropOutlook, DragDrop, DragDropFile,
  mORMot,
  UnitBaseRecord;

type
  TMakeJson = function(var AFileName: string): string of object;

  TFrame2 = class(TFrame)
    TaskTab: TAdvOfficeTabSet;
    StatusBarPro1: TStatusBarPro;
    NextGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    HullNo: TNxTextColumn;
    ShipName: TNxTextColumn;
    ImoNo: TNxTextColumn;
    DeliveryDate: TNxTextColumn;
    SpecialSurveyDueDate: TNxTextColumn;
    DockingSurveyDueDate: TNxTextColumn;
    LastDryDockDate: TNxTextColumn;
    ShipType: TNxTextColumn;
    OwnerName: TNxTextColumn;
    TechManagerName: TNxTextColumn;
    TechManagerCountry: TNxTextColumn;
    ShipTypeDesc: TNxTextColumn;
    SClass1: TNxTextColumn;
    ShipBuilderName: TNxTextColumn;
    VesselStatus: TNxTextColumn;
    UpdatedDate: TNxTextColumn;
    SClass2: TNxTextColumn;
    TaskID: TNxTextColumn;
    imagelist24x24: TImageList;
    ImageList16x16: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    ImportFromFile1: TMenuItem;
    ImportVesselDeliveryDateFromXlsFile1: TMenuItem;
    ImportVesselGPandDeliveryFromXlsFile1: TMenuItem;
    ImportVesselDeliveryFromXlsFile1: TMenuItem;
    ImportAnsiDeviceFromXlsFile1: TMenuItem;
    AddNationListFromXls1: TMenuItem;
    ImportNationNameENFromXls1: TMenuItem;
    ImportNationFlagFromFolder1: TMenuItem;
    ImportNationFlagImageFromFolder1: TMenuItem;
    ImportEngineMasterFromXls1: TMenuItem;
    ImportGeneratorMasterFromXlsFile1: TMenuItem;
    N2: TMenuItem;
    Close1: TMenuItem;
    View1: TMenuItem;
    ShowAnsiDeviceNoList1: TMenuItem;
    GetVesselInfoFromWeb1: TMenuItem;
    GetVesselInfoFromText1: TMenuItem;
    ShowNationCode1: TMenuItem;
    InstalledProduct2: TMenuItem;
    Engine3: TMenuItem;
    Electric3: TMenuItem;
    DataBase1: TMenuItem;
    UpdateDockSurveyDateFrom1: TMenuItem;
    AddVesselInfoFromSeaWebDB1: TMenuItem;
    UpdateInstalledProductInVesselMasterFromEngineMaster1: TMenuItem;
    RemoveGEFromInstalledProductInVesselMaster1: TMenuItem;
    ools1: TMenuItem;
    QuotationManager1: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Electric1: TMenuItem;
    HiMAP1: TMenuItem;
    SWBD1: TMenuItem;
    VCBACB1: TMenuItem;
    ransformer1: TMenuItem;
    Motor1: TMenuItem;
    Generator1: TMenuItem;
    Engine1: TMenuItem;
    N2Stroke1: TMenuItem;
    N4Stroke1: TMenuItem;
    InstalledProduct1: TMenuItem;
    Engine2: TMenuItem;
    Electric2: TMenuItem;
    ImageList32x32: TImageList;
    SplashScreen1: TAdvSmoothSplashScreen;
    Timer1: TTimer;
    JvSelectDirectory1: TJvSelectDirectory;
    TDragOLF: TDragOutlookFrame;
    procedure NextGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    function SaveCurrentTask2File(AFileName: string = '') : string;
    function MakeFileEmailAttached(var AFileName: string): string;
  public
    FTaskJson: string;
    FProcMakeJson: TMakeJson;

    procedure SetProcMakeJson(AProc: TMakeJson);
  end;

implementation

{$R *.dfm}

function TFrame2.MakeFileEmailAttached(var AFileName: string): string;
var
  LID: TID;
begin
  NextGrid.Cells['TaskID', NextGrid.SelectedRow];
end;

procedure TFrame2.NextGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  LFileName: string;
begin
  if not PtInRect(NextGrid.GetRowRect(NextGrid.SelectedRow), Point(X,Y)) then
    exit;

  if (DragDetectPlus(NextGrid.Handle, Point(X,Y))) then
  begin
    if NextGrid.SelectedRow = -1 then
      exit;

    TVirtualFileStreamDataFormat(TDragOLF.DataFormatAdapter2.DataFormat).FileNames.Clear;
    LFileName := SaveCurrentTask2File;

    if LFileName <> '' then
      //파일 이름에 공란이 들어가면 OnGetStream 함수를 안 탐
      TVirtualFileStreamDataFormat(TDragOLF.DataFormatAdapter2.DataFormat).
            FileNames.Add(LFileName);

    TDragOLF.DropEmptySource1.Execute;
  end;
end;

function TFrame2.SaveCurrentTask2File(AFileName: string): string;
var
//  LTask: TSQLBaseRecord;
  LFileName, LStr: string;
begin
  Result := '';

  if Assigned(FProcMakeJson) then
  begin
    FTaskJson := FProcMakeJson(LFileName);

    if AFileName = '' then
      AFileName := LFileName;

    Result := AFileName;
  end;

//  LTask := TDTF.GetTask;
//  try
//    if LTask.IsUpdate then
//    begin
//
//    end;
//  finally
//    LTask.Free;
//  end;
end;

procedure TFrame2.SetProcMakeJson(AProc: TMakeJson);
begin
  FProcMakeJson := AProc;
end;

end.
