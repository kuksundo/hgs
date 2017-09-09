unit UnitHiMECSEngineInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxPropertyItems, NxPropertyItemClasses,
  NxScrollControl, NxInspector, UnitEngineBaseClassUtil, EngineBaseClass_Old, EngineBaseClass,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus;

type
  TForm2 = class(TForm)
    EngineInfoInspector: TNextInspector;
    SelectEngineCombo: TNxComboBoxItem;
    NxTextItem1: TNxTextItem;
    NxTextItem2: TNxTextItem;
    NxTextItem3: TNxTextItem;
    NxTextItem4: TNxTextItem;
    FComponents: TNxTextItem;
    NxTextItem5: TNxTextItem;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    RadioGroup1: TRadioGroup;
    SaveDialog1: TSaveDialog;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    AddPart1: TMenuItem;
    GetManualFromMSNo1: TMenuItem;
    N1: TMenuItem;
    DeleteSelectedPart1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure EngineInfoInspectorChange(Sender: TObject; Item: TNxPropertyItem;
      Value: WideString);
    procedure AddPart1Click(Sender: TObject);
  private
    FEngineInfo: TICEngine;
    FEngineInfo_Old: TInternalCombustionEngine;
    FIsFileLoading: Boolean;
  public
    procedure OpenEngineInfoFromFile(AFileName: string);
    procedure SaveEngineInfoToFile(AFileName: string);
  end;

var
  Form2: TForm2;

implementation

uses EngineConst, UnitHiMECSAddPart;

{$R *.dfm}

{ TForm2 }

procedure TForm2.AddPart1Click(Sender: TObject);
var
  LAddPartF: TAddPartF;
  LPartName: string;
begin
  LAddPartF := TAddPartF.Create(nil);
  try
    if LAddPartF.ShowModal = mrOK then
      LPartName := LAddPartF.Edit1.Text;
  finally
    LAddPartF.Free;
  end;

  AddNullComponentToInspector(FEngineInfo, EngineInfoInspector, LPartName);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
      OpenEngineInfoFromFile(OpenDialog1.FileName);
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    if SaveDialog1.FileName <> '' then
      SaveEngineInfoToFile(SaveDialog1.FileName);
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  AssignOldToNewClass(FEngineInfo_Old,FEngineInfo);
end;

procedure TForm2.EngineInfoInspectorChange(Sender: TObject;
  Item: TNxPropertyItem; Value: WideString);
begin
  if FIsFileLoading then
    exit;

  if (Item.Name = 'FuelType') or (Item.Name = 'CylinderCount') or (Item.Name = 'CylinderConfiguration') or
    (Item.Name = 'Bore') or (Item.Name = 'Stroke') then
  begin
    FEngineInfo.SetEngineType(
      EngineInfoInspector.items.ItemByName['CylinderCount'].AsInteger,
      EngineInfoInspector.items.ItemByName['Bore'].AsInteger,
      EngineInfoInspector.items.ItemByName['Stroke'].AsInteger,
      Ord(String2FuelType(EngineInfoInspector.items.ItemByName['FuelType'].AsString)),
      Ord(String2CylinderConfiguration(EngineInfoInspector.items.ItemByName['CylinderConfiguration'].AsString)));
    EngineInfoInspector.items.ItemByName['EngineType'].AsString := FEngineInfo.GetEngineType;
  end;

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FEngineInfo := TICEngine.Create(nil);
  FEngineInfo_Old := TInternalCombustionEngine.Create(nil);
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FEngineInfo.Free;
  FEngineInfo_Old.Free;
end;

procedure TForm2.OpenEngineInfoFromFile(AFileName: string);
begin
  FIsFileLoading := True;
  try
    case RadioGroup1.ItemIndex of
      0:begin
        FEngineInfo_Old.Clear;
        FEngineInfo_Old.LoadFromFile(AFileName);
        EngineInfoClass2Inspector_Old(FEngineInfo_Old, EngineInfoInspector, 0 ,nil);
      end;

      1:begin
        FEngineInfo.Clear;
        FEngineInfo.LoadFromJsonFile(AFileName);
        EngineInfoClass2Inspector(FEngineInfo, EngineInfoInspector, 0 ,nil);
      end;
    end;
  finally
    FIsFileLoading := False;
  end;
end;

procedure TForm2.SaveEngineInfoToFile(AFileName: string);
begin
  case RadioGroup1.ItemIndex of
    0:begin
      FEngineInfo_Old.SaveToFile(AFileName);
    end;

    1:begin
      EngineInfoInspector2Class(EngineInfoInspector, FEngineInfo, True);
      FEngineInfo.SaveToJSONFile(AFileName);
    end;
  end;
end;

end.
