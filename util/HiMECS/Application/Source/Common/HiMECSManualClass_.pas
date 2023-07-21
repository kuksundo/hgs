unit HiMECSManualClass;

interface

uses System.SysUtils, Classes, Vcl.ComCtrls, Generics.Legacy, BaseConfigCollect,
  HiMECSConst, SynCommons, mORMot, UnitHiMECSManualRecord, UnitEngineMasterData;

type
  THiMECSOpManualItem = class(TCollectionItem)
  public
    procedure Assign(Source: TPersistent); override;
{$I HiMECSManual.inc}
  end;

  THiMECSOpManualCollect<T: THiMECSOpManualItem> = class(Generics.Legacy.TCollection<T>)
  private
    FManualLanguage: TManualLanguage;
  public
  published
    property ManualLanguage: TManualLanguage read FManualLanguage write FManualLanguage;
  end;

  THiMECSMaintenanceManualItem = class(TCollectionItem)
  private
  public
  published
  end;

  TMaintenanceManualCollect<T: THiMECSMaintenanceManualItem> = class(Generics.Legacy.TCollection<T>)
  private
    FManualLanguage: TManualLanguage;
  public
  published
    property ManualLanguage: TManualLanguage read FManualLanguage write FManualLanguage;
  end;

  THiMECSDrawingItem = class(TCollectionItem)
  public
    procedure Assign(Source: TPersistent); override;
{$I HiMECSManual.inc}
  end;

  TDrawingCollect<T: THiMECSDrawingItem> = class(Generics.Legacy.TCollection<T>)
  private
    FDrawingLanguage: TManualLanguage;
  public
  published
    property DrawingLanguage: TManualLanguage read FDrawingLanguage write FDrawingLanguage;
  end;

  THiMECSManualInfo = class(TpjhBase)
  private
    FOpManualCollect: THiMECSOpManualCollect<THiMECSOpManualItem>;
    FMaintenanceManualCollect: TMaintenanceManualCollect<THiMECSMaintenanceManualItem>;
    FDrawingCollect: TDrawingCollect<THiMECSDrawingItem>;
    //ConfigJSONClass를 이용하여 환경설정 폼을 편집 시에 현재 CollectItem Index를 저장하기 위함
    FConfigItemIndex:integer;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(ASource: TPersistent); override;

    function LoadFromSqliteFile(ADBFileName: string): integer; override;
    function SaveToSqliteFile(ADBFileName: string; AItemIndex: integer=-1): integer; override;
    function LoadFromJSONArray(AJsonArray: RawUTF8; AIsAdd: Boolean=False): integer;
    procedure SetDescFromSecNo(const AFileName, ASecNo: string;
      AHiMECSOpManualItem: THiMECSOpManualItem);
    procedure SetRelFilePathBothOpmanualNDrawings(const AEngType: string);

    procedure ManualInfo2ListView(AListView: TListView);
    procedure AddManualItem2ListView(AManualItem: THiMECSOpManualItem; AListView: TListView);
    procedure DrawingInfo2ListView(AListView: TListView);
    procedure AddDrawItem2ListView(ADrawItem: THiMECSDrawingItem; AListView: TListView);

    property ConfigItemIndex: integer read FConfigItemIndex write FConfigItemIndex;
  published
    property OpManual: THiMECSOpManualCollect<THiMECSOpManualItem> read FOpManualCollect write FOpManualCollect;
    property ServiceManual: TMaintenanceManualCollect<THiMECSMaintenanceManualItem> read FMaintenanceManualCollect write FMaintenanceManualCollect;
    property Drawings: TDrawingCollect<THiMECSDrawingItem> read FDrawingCollect write FDrawingCollect;
  end;

implementation

uses UnitRttiUtil;

{ THiMECSManualInfo }

procedure THiMECSManualInfo.AddDrawItem2ListView(ADrawItem: THiMECSDrawingItem;
  AListView: TListView);
var
  LListItem: TListItem;
begin
  AListView.Items.BeginUpdate;
  try
    LListItem:= AListView.Items.Add;
    LListItem.Data := ADrawItem;
    LListItem.Caption:= ADrawItem.FileName;
    LListItem.SubItems.Add(ADrawItem.SectionNo);
    LListItem.SubItems.Add(ADrawItem.RevNo);
    LListItem.SubItems.Add(ADrawItem.Category_No);
    LListItem.SubItems.Add(ADrawItem.SystemDesc_Eng);
    LListItem.SubItems.Add(ADrawItem.SystemDesc_Kor);
    LListItem.SubItems.Add(ADrawItem.PartDesc_Eng);
    LListItem.SubItems.Add(ADrawItem.PartDesc_Kor);
    LListItem.SubItems.Add(ADrawItem.FilePath);
    LListItem.SubItems.Add(ADrawItem.RelFilePath);
    LListItem.MakeVisible(False);
  finally
    AListView.Items.EndUpdate;
  end;
end;

procedure THiMECSManualInfo.AddManualItem2ListView(
  AManualItem: THiMECSOpManualItem; AListView: TListView);
var
  LListItem: TListItem;
begin
  AListView.Items.BeginUpdate;
  try
    LListItem:= AListView.Items.Add;
    LListItem.Data := AManualItem;
    LListItem.Caption:= AManualItem.FileName;
    LListItem.SubItems.Add(AManualItem.SectionNo);
    LListItem.SubItems.Add(AManualItem.RevNo);
    LListItem.SubItems.Add(AManualItem.Category_No);
    LListItem.SubItems.Add(AManualItem.SystemDesc_Eng);
    LListItem.SubItems.Add(AManualItem.SystemDesc_Kor);
    LListItem.SubItems.Add(AManualItem.PartDesc_Eng);
    LListItem.SubItems.Add(AManualItem.PartDesc_Kor);
    LListItem.SubItems.Add(AManualItem.FilePath);
    LListItem.SubItems.Add(AManualItem.RelFilePath);
    LListItem.MakeVisible(False);
  finally
    AListView.Items.EndUpdate;
  end;
end;

procedure THiMECSManualInfo.Assign(ASource: TPersistent);
var
  i: integer;
begin
  if ASource is THiMECSManualInfo then
  begin
    if Assigned(OpManual) then
      OpManual.Clear;

    for i := 0 to THiMECSManualInfo(ASource).OpManual.Count - 1 do
      with OpManual.Add do
        Assign(THiMECSManualInfo(ASource).OpManual.Items[i]);
  end;
end;

procedure THiMECSManualInfo.Clear;
begin

end;

constructor THiMECSManualInfo.Create(AOwner: TComponent);
begin
  FOpManualCollect := THiMECSOpManualCollect<THiMECSOpManualItem>.Create;
  FMaintenanceManualCollect := TMaintenanceManualCollect<THiMECSMaintenanceManualItem>.Create;
  FDrawingCollect := TDrawingCollect<THiMECSDrawingItem>.Create;
end;

destructor THiMECSManualInfo.Destroy;
begin
  inherited;

  FDrawingCollect.Free;
  FMaintenanceManualCollect.Free;
  FOpManualCollect.Free;
end;

procedure THiMECSManualInfo.DrawingInfo2ListView(AListView: TListView);
var
  i: integer;
begin
  for i := 0 to Drawings.Count - 1 do
    AddDrawItem2ListView(Drawings.Items[i], AListView);
end;

function THiMECSManualInfo.LoadFromJSONArray(AJsonArray: RawUTF8;
  AIsAdd: Boolean): integer;
var
  LItem: TObject;
  LDocData: TDocVariantData;
  LVar: variant;
  LStr: string;
  i, LRow: integer;
begin
  //AJsonArray = [] 형식의 Engine Parameter List임
  LDocData.InitJSON(AJsonArray);
  try
    if Assigned(OpManual) then
    begin
      if not AIsAdd then
        OpManual.Clear;

      for i := 0 to LDocData.Count - 1 do
      begin
        LVar := _JSON(LDocData.Value[i]);
        LStr := LVar.Category_No;

        if LStr = '' then
        begin
//          ShowMessage('Category_No field is null');
          exit;
        end
        else if LStr = 'OM' then
          LItem := TObject(OpManual.Add)
        else if LStr = 'DR' then
          LItem := TObject(Drawings.Add);

        LoadRecordPropertyFromVariant(LItem, LVar);
      end;
    end;
  finally
    Result := LDocData.Count;
  end;
end;

function THiMECSManualInfo.LoadFromSqliteFile(ADBFileName: string): integer;
var
  LUtf8: RawUtf8;
begin
  InitHiMECSManualClient(ADBFileName);
  LUtf8 := GetHiMECSManualList2JSONArrayFromProductModel;//(stParam)
  LoadFromJSONArray(LUtf8);
end;

procedure THiMECSManualInfo.ManualInfo2ListView(AListView: TListView);
var
  i: integer;
begin
  for i := 0 to OpManual.Count - 1 do
    AddManualItem2ListView(OpManual.Items[i], AListView);
end;

function THiMECSManualInfo.SaveToSqliteFile(ADBFileName: string; AItemIndex: integer): integer;
var
  LUtf8: RawUTF8;
  LDoc: variant;
  i: integer;
  LSQLRestClientURI: TSQLRestClientURI;
  LHiMECSManualModel: TSQLModel;
begin
//  if Not FileExists(AFileName) then
//    exit;

  TDocVariant.New(LDoc);
  LSQLRestClientURI := InitHiMECSManualClient2(ADBFileName, LHiMECSManualModel);
  try
    for i := 0 to OpManual.Count - 1 do
    begin
      LoadRecordPropertyToVariant(OpManual.Items[i], LDoc);
      AddOrUpdateHiMECSManualFromVariant(LDoc, False, LSQLRestClientURI);
    end;
  finally
    LHiMECSManualModel.Free;
    LSQLRestClientURI.Free;
  end;
end;

procedure THiMECSManualInfo.SetDescFromSecNo(const AFileName, ASecNo: string;
  AHiMECSOpManualItem: THiMECSOpManualItem);
var
  LHiMECSManualRecord: THiMECSManualRecord;
begin
  InitHiMECSManualClient(AFileName);
  LHiMECSManualRecord := GetHiMECSManualFromSectionNo(ASecNo);

  if LHiMECSManualRecord.IsUpdate then
  begin
    AHiMECSOpManualItem.SystemDesc_Eng := LHiMECSManualRecord.SystemDesc_Eng;
    AHiMECSOpManualItem.SystemDesc_Kor := LHiMECSManualRecord.SystemDesc_Kor;
    AHiMECSOpManualItem.PartDesc_Eng := LHiMECSManualRecord.PartDesc_Eng;
    AHiMECSOpManualItem.PartDesc_Kor := LHiMECSManualRecord.PartDesc_Kor;
  end;
end;

procedure THiMECSManualInfo.SetRelFilePathBothOpmanualNDrawings(const AEngType: string);
var
  i: integer;
  LManualItem: THiMECSOpManualItem;
  LDrawingItem: THiMECSDrawingItem;
begin
  for i := 0 to OpManual.Count - 1 do
  begin
    LManualItem := OpManual.Items[i];
    LManualItem.RelFilePath := AEngType;
  end;

  for i := 0 to Drawings.Count - 1 do
  begin
    LDrawingItem := Drawings.Items[i];
    LDrawingItem.RelFilePath := AEngType;
  end;
end;

{ THiMECSOpManualItem }

procedure THiMECSOpManualItem.Assign(Source: TPersistent);
begin
{$I AssignHiMECSManualItem.inc}
end;

{ THiMECSDrawingItem }

procedure THiMECSDrawingItem.Assign(Source: TPersistent);
begin
{$I AssignHiMECSManualItem.inc}
end;

end.
