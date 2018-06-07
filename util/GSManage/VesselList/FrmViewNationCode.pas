unit FrmViewNationCode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, CommCtrl, Vcl.Imaging.pngimage,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.StdCtrls, AeroButtons, Vcl.ImgList, JvExControls, JvLabel,
  UnitNationRecord, UnitNationData, SynGdiPlus, SynCommons, mORMot, PngImageList;

type
  TViewNationCodeF = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    NationGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    FlagImage: TNxImageColumn;
    NationName_KO: TNxTextColumn;
    NationAlpha2: TNxTextColumn;
    NationAlpha3: TNxTextColumn;
    NationNumeric: TNxTextColumn;
    Continent: TNxTextColumn;
    JvLabel5: TJvLabel;
    NationName_KOEdit: TEdit;
    JvLabel7: TJvLabel;
    CodeAlpha2Edit: TEdit;
    JvLabel1: TJvLabel;
    CodeAlpha3Edit: TEdit;
    ImageList32x32: TImageList;
    btn_Search: TAeroButton;
    btn_Close: TAeroButton;
    JvLabel2: TJvLabel;
    ContinentEdit: TEdit;
    JvLabel3: TJvLabel;
    NationName_ENEdit: TEdit;
    FlagIcon: TNxImageColumn;
    FlagImageList: TImageList;
    PngImageList1: TPngImageList;
    NationName_EN: TNxTextColumn;
    UpdateDate: TNxDateColumn;
    procedure NationName_KOEditKeyPress(Sender: TObject; var Key: Char);
    procedure CodeAlpha2EditKeyPress(Sender: TObject; var Key: Char);
    procedure ContinentEditKeyPress(Sender: TObject; var Key: Char);
    procedure btn_SearchClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure NationGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
  private
    procedure GetNationList2Grid;
    procedure GetNationSearchParam2Rec(var ANationSearchParamRec: TNationSearchParamRec);
    procedure ExecuteSearch(Key: Char);
    procedure GetNationListFromVariant2Grid(ADoc: Variant);
    procedure FlagView(ARow: integer);
  public
    { Public declarations }
  end;

function CreateViewNationCodeFormFromDB(ANationName, ANationAlpha2, ANationAlpha3: string): integer;

var
  ViewNationCodeF: TViewNationCodeF;

implementation

uses UnitBase64Util, FrmViewFlag;

{$R *.dfm}

{ TViewNationCodeF }

function CreateViewNationCodeFormFromDB(ANationName, ANationAlpha2, ANationAlpha3: string): integer;
var
  LViewNationCodeF: TViewNationCodeF;
begin
  LViewNationCodeF := TViewNationCodeF.Create(nil);
  try

    LViewNationCodeF.ShowModal;
  finally
    LViewNationCodeF.Free;
  end;
end;

procedure TViewNationCodeF.ContinentEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TViewNationCodeF.ExecuteSearch(Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    btn_SearchClick(nil);
end;

procedure TViewNationCodeF.FlagView(ARow: integer);
var
  LAlpha2: string;
  LSQLNationRecord: TSQLNationRecord;
  LImage: TSQLRawBlob;
  LDoc: variant;
begin
  LAlpha2 := NationGrid.CellsByName['NationAlpha2',ARow];
  LSQLNationRecord := GetNationFromNationAlpha2(LAlpha2);
  try
    if LSQLNationRecord.FillOne then
    begin
      TDocVariant.New(LDoc);
      g_NationDB.RetrieveBlob(TSQLNationRecord, LSQLNationRecord.ID, 'FlagImage', LImage);
      LDoc.FlagImage := MakeRawByteStringToBin64(LImage, False);
      DisplayFlagView(LDoc);
    end;
  finally
    LSQLNationRecord.Free;
  end;
end;

procedure TViewNationCodeF.GetNationList2Grid;
var
  LSQLNationRecord: TSQLNationRecord;
  LNationSearchParamRec: TNationSearchParamRec;
  LDoc: Variant;
begin
  NationGrid.BeginUpdate;
  try
    NationGrid.ClearRows;
    GetNationSearchParam2Rec(LNationSearchParamRec);
    LSQLNationRecord := GetNationFromSearchRec(LNationSearchParamRec);

    if LSQLNationRecord.IsUpdate then
    begin
      PngImageList1.Clear;
      LSQLNationRecord.FillRewind;

      while LSQLNationRecord.FillOne do
      begin
        LDoc := GetVariantFromNationRecord(LSQLNationRecord);
        GetNationListFromVariant2Grid(LDoc);
      end;//while

      StatusBar1.Panels[1].Text := IntToStr(NationGrid.RowCount);
    end;
  finally
    NationGrid.EndUpdate;
  end;
end;

procedure TViewNationCodeF.GetNationListFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
  LPngImage: Vcl.Imaging.pngimage.TPngImage;
  LStream: TSynMemoryStream;
  LUtf8: RawByteString;
  i: integer;
begin
//  FlagImageList.Clear;
  LPngImage := Vcl.Imaging.pngimage.TPngImage.Create;
  try
    LUtf8 := ADoc.FlagICon;
    i := -1;

    if LUtf8 <> '' then
    begin
      LUtf8 := MakeBase64ToUTF8(LUtf8, False);
      LStream := TSynMemoryStream.Create(LUtf8);
      try
        LPngImage.LoadFromStream(LStream);
        i := PngImageList1.AddPng(LPngImage);
      finally
        LStream.Free;
      end;
    end;

    LRow := NationGrid.AddRow;

    NationGrid.CellsByName['NationName_KO', LRow] := ADoc.NationName_KO;
    NationGrid.CellsByName['NationName_EN', LRow] := ADoc.NationName_EN;
    NationGrid.CellsByName['NationNumeric', LRow] := ADoc.NationNumeric;
    NationGrid.CellsByName['NationAlpha2', LRow] := ADoc.NationAlpha2;
    NationGrid.CellsByName['NationAlpha3', LRow] := ADoc.NationAlpha3;
    NationGrid.CellsByName['Continent', LRow] := ADoc.Continent;
  //  NationGrid.CellsByName['FlagImage', LRow] := ADoc.FlagImage;
    NationGrid.CellByName['FlagIcon', LRow].AsInteger := i;
    NationGrid.CellByName['UpdateDate', LRow].AsDateTime := TimeLogToDateTime(ADoc.UpdateDate);
  finally
    LPngImage.Free;
  end;
end;

procedure TViewNationCodeF.GetNationSearchParam2Rec(
  var ANationSearchParamRec: TNationSearchParamRec);
begin
  ANationSearchParamRec.NationName_KO := NationName_KOEdit.Text;
  ANationSearchParamRec.NationName_EN := NationName_ENEdit.Text;
  ANationSearchParamRec.NationAlpha2 := CodeAlpha2Edit.Text;
  ANationSearchParamRec.NationAlpha3 := CodeAlpha3Edit.Text;
  ANationSearchParamRec.Continent := ContinentEdit.Text;
//  ANationSearchParamRec.NationNumeric := NationNameEdit.Text;
end;

procedure TViewNationCodeF.NationGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  FlagView(ARow);
end;

procedure TViewNationCodeF.NationName_KOEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TViewNationCodeF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TViewNationCodeF.btn_SearchClick(Sender: TObject);
begin
  GetNationList2Grid;
end;

procedure TViewNationCodeF.CodeAlpha2EditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

initialization
  Gdip.RegisterPictures;

end.
