unit UnitHiMECSProjInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxPropertyItems, NxPropertyItemClasses,
  NxScrollControl, NxInspector,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, NxCollection, AeroButtons,
  Vcl.ComCtrls, AdvGroupBox, AdvOfficeButtons, JvExControls, JvLabel,
  CurvyControls, AdvOfficePager, NxCustomGridControl, NxCustomGrid, NxGrid,
  VesselBaseClass, EngineBaseClass, NxColumns, NxColumnClasses;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PopupMenu1: TPopupMenu;
    GetManualFromMSNo1: TMenuItem;
    Panel2: TPanel;
    Panel3: TPanel;
    ProjInfoInspector: TNextInspector;
    NxExpandPanel1: TNxExpandPanel;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    CurvyPanel1: TCurvyPanel;
    JvLabel4: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel5: TJvLabel;
    CurvyPanel2: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    cb_ShipNo: TComboBox;
    cb_ProjNo: TComboBox;
    AeroButton3: TAeroButton;
    cb_engType: TComboBox;
    Panel5: TPanel;
    JvLabel2: TJvLabel;
    cb_SearchMode: TComboBox;
    CB_ExProcess: TCheckBox;
    AeroButton1: TAeroButton;
    AdvOfficePager12: TAdvOfficePage;
    NxSplitter3: TNxSplitter;
    NextGrid1: TNextGrid;
    ShipNo: TNxTextColumn;
    ProjNo: TNxTextColumn;
    RevNo: TNxTextColumn;
    ProjName: TNxTextColumn;
    ShipOwner: TNxTextColumn;
    ShipClass: TNxTextColumn;
    DeliveryDate: TNxTextColumn;
    EngType: TNxTextColumn;
    MCR: TNxTextColumn;
    EngCount: TNxTextColumn;
    RPM: TNxTextColumn;
    EngUse: TNxTextColumn;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ProjInfoInspectorChange(Sender: TObject; Item: TNxPropertyItem;
      Value: WideString);
    procedure AeroButton3Click(Sender: TObject);
  private
    FVesselInfo: TVesselInfo;
    FIsFileLoading: Boolean;

    procedure ProjectInfoClass2Inspector(AClass: TVesselInfo;
      AInspector: TNextInspector; AProjIndex: integer;
      AEvent: TNxItemNotifyEvent);
    procedure InitProjectInfoInspector(AInspector: TNextInspector);
  public
    procedure OpenProjInfoFromFile(AFileName: string);
    procedure SaveProjInfoToFile(AFileName: string);
  end;

var
  Form2: TForm2;

implementation

uses UnitProjDM;

{$R *.dfm}

{ TForm2 }

procedure TForm2.AeroButton3Click(Sender: TObject);
begin
  DM1.GetProjInfoFromODAC(NextGrid1, cb_ShipNo.Text);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
      OpenProjInfoFromFile(OpenDialog1.FileName);
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    if SaveDialog1.FileName <> '' then
      SaveProjInfoToFile(SaveDialog1.FileName);
  end;
end;

procedure TForm2.ProjInfoInspectorChange(Sender: TObject;
  Item: TNxPropertyItem; Value: WideString);
begin
  if FIsFileLoading then
    exit;

  if (Item.Name = 'FuelType') or (Item.Name = 'CylinderCount') or (Item.Name = 'CylinderConfiguration') or
    (Item.Name = 'Bore') or (Item.Name = 'Stroke') then
  begin
//    FEngineInfo.SetEngineType(
//      EngineInfoInspector.items.ItemByName['CylinderCount'].AsInteger,
//      EngineInfoInspector.items.ItemByName['Bore'].AsInteger,
//      EngineInfoInspector.items.ItemByName['Stroke'].AsInteger,
//      Ord(String2FuelType(EngineInfoInspector.items.ItemByName['FuelType'].AsString)),
//      Ord(String2CylinderConfiguration(EngineInfoInspector.items.ItemByName['CylinderConfiguration'].AsString)));
//    EngineInfoInspector.items.ItemByName['EngineType'].AsString := FEngineInfo.GetEngineType;
  end;

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FVesselInfo := TVesselInfo.Create(nil);
  InitProjectInfoInspector(ProjInfoInspector);

  NextGrid1.DoubleBuffered := False;
  ProjInfoInspector.DoubleBuffered := False;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FVesselInfo.Free;
end;

procedure TForm2.InitProjectInfoInspector(AInspector: TNextInspector);
var
  LPropertyItem: TNxPropertyItem;
  i: integer;
begin
  //TNxComboBoxItem 를 동적으로 생성하면 화면에 안보이므로 TNxComboBoxItem를 제외한 나머지 Item 삭제
  for i := AInspector.Items.Count - 1 downto 1 do
    AInspector.Items.Delete(i);

  LPropertyItem := AInspector.Items.AddChild(nil, TNxTextItem, 'Vessel Info');
  LPropertyItem.Name := 'Vessel';
  LPropertyItem := AInspector.Items.AddChild(nil, TNxTextItem, 'Customer Info');
  LPropertyItem.Name := 'Customer';
  LPropertyItem := AInspector.Items.AddChild(nil, TNxTextItem, 'Project Info');
  LPropertyItem.Name := 'Project';
  LPropertyItem := AInspector.Items.AddChild(nil, TNxTextItem, 'Engine Info');
  LPropertyItem.Name := 'Engine';
end;

procedure TForm2.OpenProjInfoFromFile(AFileName: string);
begin
  FIsFileLoading := True;
  try
    FVesselInfo.Clear;
    FVesselInfo.LoadFromJsonFile(AFileName);
    ProjectInfoClass2Inspector(FVesselInfo, ProjInfoInspector, 0 ,nil);
  finally
    FIsFileLoading := False;
  end;
end;

procedure TForm2.ProjectInfoClass2Inspector(AClass: TVesselInfo;
  AInspector: TNextInspector; AProjIndex: integer; AEvent: TNxItemNotifyEvent);
begin

end;

procedure TForm2.SaveProjInfoToFile(AFileName: string);
begin
//  EngineInfoInspector2Class(EngineInfoInspector, FProjectInfo, True);
//  FProjectInfo.SaveToJSONFile(AFileName);
end;

end.
