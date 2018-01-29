unit FrmAnsiDeviceNoList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SBPro, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, AdvOfficeTabSet,
  Vcl.ExtCtrls, Vcl.StdCtrls, AeroButtons, JvExControls, JvLabel, CurvyControls,
  Vcl.Menus, Vcl.ImgList, UnitAnsiDeviceRecord;

type
  TAnsiDeviceNoF = class(TForm)
    imagelist24x24: TImageList;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    ImportFromFile1: TMenuItem;
    ImportAnsiDeviceFromXlsFile1: TMenuItem;
    N2: TMenuItem;
    Close1: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Electric1: TMenuItem;
    HiMAP1: TMenuItem;
    SWBD1: TMenuItem;
    VCBACB1: TMenuItem;
    Engine1: TMenuItem;
    N2Stroke1: TMenuItem;
    N4Stroke1: TMenuItem;
    CurvyPanel1: TCurvyPanel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    AnsiDeviceNoEdit: TEdit;
    DeviceNameEngEdit: TEdit;
    Panel1: TPanel;
    btn_Search: TAeroButton;
    btn_Close: TAeroButton;
    Splitter1: TSplitter;
    TaskTab: TAdvOfficeTabSet;
    AnsiDeviceNoGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    DeviceNo: TNxTextColumn;
    DeviceDesc_Kor: TNxTextColumn;
    DeviceName_Eng: TNxTextColumn;
    StatusBarPro1: TStatusBarPro;
    JvLabel1: TJvLabel;
    DeviceDescEngEdit: TEdit;
    JvLabel2: TJvLabel;
    DeviceNameKorEdit: TEdit;
    JvLabel3: TJvLabel;
    DeviceDescKorEdit: TEdit;
    DeviceName_Kor: TNxTextColumn;
    DeviceDesc_Eng: TNxMemoColumn;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure DeviceDesc_EngButtonClick(Sender: TObject);
  private
    procedure GetAnsiDeviceNoSearchParam2Rec(var AAnsiDeviceNoSearchRec: TAnsiDeviceNoSearchRec);
    procedure GetAnsiDeviceNoList2Grid;
    procedure GetAnsiDeviceFromVariant2Grid(ADoc: Variant);
  public
    { Public declarations }
  end;

  function CreateAnsiDeviceNoForm: integer;

var
  AnsiDeviceNoF: TAnsiDeviceNoF;

implementation

uses FrmDisplayAnsiDeviceDesc;

{$R *.dfm}

function CreateAnsiDeviceNoForm: integer;
var
  LAnsiDeviceNoF: TAnsiDeviceNoF;
  LSQLAnsiDeviceRecord: TSQLAnsiDeviceRecord;
  LDoc: variant;
begin
  LAnsiDeviceNoF := TAnsiDeviceNoF.Create(nil);
  try
    LAnsiDeviceNoF.GetAnsiDeviceNoList2Grid;

    Result := LAnsiDeviceNoF.ShowModal;

    if Result = mrOK then
    begin
    end;
  finally
    LAnsiDeviceNoF.Free;
  end;
end;

procedure TAnsiDeviceNoF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TAnsiDeviceNoF.btn_SearchClick(Sender: TObject);
begin
  GetAnsiDeviceNoList2Grid;
end;

procedure TAnsiDeviceNoF.DeviceDesc_EngButtonClick(Sender: TObject);
begin
  if AnsiDeviceNoGrid.SelectedRow = -1 then
    exit;

  CreateAnsiDeviceDescForm(
    AnsiDeviceNoGrid.CellsByName['DeviceNo', AnsiDeviceNoGrid.SelectedRow],
    AnsiDeviceNoGrid.CellsByName['DeviceName_Eng', AnsiDeviceNoGrid.SelectedRow],
    AnsiDeviceNoGrid.CellsByName['DeviceDesc_Eng', AnsiDeviceNoGrid.SelectedRow]);
end;

procedure TAnsiDeviceNoF.GetAnsiDeviceFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
begin
  LRow := AnsiDeviceNoGrid.AddRow;

  AnsiDeviceNoGrid.CellsByName['DeviceNo', LRow] := ADoc.AnsiDeviceNo;
  AnsiDeviceNoGrid.CellsByName['DeviceName_Eng', LRow] := ADoc.AnsiDeviceName_Eng;
  AnsiDeviceNoGrid.CellsByName['DeviceName_Kor', LRow] := ADoc.AnsiDeviceName_Kor;
  AnsiDeviceNoGrid.CellsByName['DeviceDesc_Eng', LRow] := ADoc.AnsiDeviceDesc_Eng;
  AnsiDeviceNoGrid.CellsByName['DeviceDesc_Kor', LRow] := ADoc.AnsiDeviceDesc_Kor;
end;

procedure TAnsiDeviceNoF.GetAnsiDeviceNoList2Grid;
var
  LSQLAnsiDevice: TSQLAnsiDeviceRecord;
  LAnsiDeviceNoSearchRec: TAnsiDeviceNoSearchRec;
  LDoc: Variant;
begin
  AnsiDeviceNoGrid.BeginUpdate;
  try
    AnsiDeviceNoGrid.ClearRows;
    GetAnsiDeviceNoSearchParam2Rec(LAnsiDeviceNoSearchRec);
    LSQLAnsiDevice := GetAnsiDeviceFromSearchRec(LAnsiDeviceNoSearchRec);

    if LSQLAnsiDevice.IsUpdate then
    begin
      LDoc := GetVariantFromAnsiDeviceRecord(LSQLAnsiDevice);
      GetAnsiDeviceFromVariant2Grid(LDoc);

      while LSQLAnsiDevice.FillOne do
      begin
        LDoc := GetVariantFromAnsiDeviceRecord(LSQLAnsiDevice);
        GetAnsiDeviceFromVariant2Grid(LDoc);
      end;//while
    end;
  finally
    AnsiDeviceNoGrid.EndUpdate;
  end;
end;

procedure TAnsiDeviceNoF.GetAnsiDeviceNoSearchParam2Rec(
  var AAnsiDeviceNoSearchRec: TAnsiDeviceNoSearchRec);
begin
  AAnsiDeviceNoSearchRec.fAnsiDeviceNo := AnsiDeviceNoEdit.Text;
  AAnsiDeviceNoSearchRec.fDeviceName_Eng := DeviceNameEngEdit.Text;
  AAnsiDeviceNoSearchRec.fDeviceName_Kor := DeviceNameKorEdit.Text;
  AAnsiDeviceNoSearchRec.fDeviceDesc_Eng := DeviceDescEngEdit.Text;
  AAnsiDeviceNoSearchRec.fDeviceDesc_Kor := DeviceDescKorEdit.Text;
end;

end.
