{*******************************************************}
{                                                       }
{       Report Designer                                 }
{       Extension Library example of                    }
{       TELDesigner, TELDesignPanel                     }
{                                                       }
{       (c) 2001, Balabuyev Yevgeny                     }
{       E-mail: stalcer@rambler.ru                      }
{                                                       }
{*******************************************************}

unit frmPropsUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ELDsgnr, Buttons, ExtCtrls, ComCtrls,// QRPrntr,
  Grids, ELPropInsp, TypInfo, ELD5_Adds, pjhPropInsp;

type
  //THack = class(TPanel); //protected 속성인 canvas를 사용하기 위해 상속을 함.

  TfrmProps = class(TForm)
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    PropInsp: TELPropertyInspector;
    Panel1: TPanel;
    ComponentList: TComboBox;
    procedure PropInspModified(Sender: TObject);
    procedure PropInspFilterProp(Sender: TObject; AInstance: TPersistent;
      APropInfo: PPropInfo; var AIncludeProp: Boolean);
    procedure PropInspGetComponentNames(Sender: TObject;
      AClass: TComponentClass; AResult: TStrings);
    procedure PropInspGetComponent(Sender: TObject;
      const AComponentName: String; var AComponent: TComponent);
    procedure ComponentListChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PropInspUpdateParam(Sender: TObject;
      AELPropertyInspectorItem: TELPropertyInspectorItem;
      AELPropEditor: TELPropEditor; var ADisplay: Boolean);
  private
    FDoc: TForm;
    FDisplayPropList: TStringList;

    procedure SetDoc(const Value: TForm);
    function AdjustTextWidth(AName, AClassName: string): string;
    { Private declarations }
  public
    procedure FillObjList2Combo;
		procedure RefreshObjListOfCombo(SelectedObj: TControl = nil);
    procedure ClearObjOfCombo;
    procedure FillDisplayPropName;

    property Doc: TForm read FDoc write SetDoc;
  end;

var
  frmProps: TfrmProps;

implementation

uses frmDocUnit, frmMainUnit;

{$R *.dfm}

{ TfrmProps }

procedure TfrmProps.SetDoc(const Value: TForm);
begin
  FDoc := Value;
end;

procedure TfrmProps.PropInspModified(Sender: TObject);
begin
  if FDoc <> nil then
    TfrmDoc(FDoc).Modify;
end;

procedure TfrmProps.PropInspFilterProp(Sender: TObject;
  AInstance: TPersistent; APropInfo: PPropInfo; var AIncludeProp: Boolean);
begin
{
  if (APropInfo.PropType^.Kind = tkClass) and
    (GetTypeData(APropInfo.PropType^).ClassType.InheritsFrom(TDataSet) or
    GetTypeData(APropInfo.PropType^).ClassType.InheritsFrom(TQuickRepBands)) then
    AIncludeProp := False;
}
end;

//Property Inspector에서 Control 속성의 Combo를 Drop down할때 실행되는 함수
//폼위의 control 객체들을 리스트업 한다.
procedure TfrmProps.PropInspGetComponentNames(Sender: TObject;
  AClass: TComponentClass; AResult: TStrings);
var i: integer;
begin
  if FDoc <> nil then
  begin
    with TfrmDoc(FDoc) do
    begin
      for i := 0 to ComponentCount - 1 do
      begin
        if Components[i].InheritsFrom(AClass) then
          if Components[i].Name <>
                            frmMain.Designer.SelectedControls.DefaultControl.Name then
            AResult.Add(TfrmDoc(FDoc).Components[i].Name);
      end;//for
    end;//with
  end;//if

end;

procedure TfrmProps.PropInspGetComponent(Sender: TObject;
  const AComponentName: String; var AComponent: TComponent);
begin
  AComponent := TfrmDoc(FDoc).FindComponent(AComponentName);
end;

procedure TfrmProps.FillObjList2Combo;
var i: integer;
    tmpForm: TForm;
begin
  if frmMain.Designer.DesignControl = nil then
    exit;
    
  tmpForm := TForm(frmMain.Designer.DesignControl);
	ComponentList.Clear;
	ComponentList.Items.AddObject(AdjustTextWidth(tmpForm.Name,tmpForm.ClassName),
                              tmpForm);
	//ComponentList.Items.AddObject (Format ('%s: %s', [tmpForm.Name,tmpForm.ClassName]),
  //                            tmpForm);

	for i := 0 to tmpForm.ComponentCount - 1 do
		ComponentList.Items.AddObject(AdjustTextWidth(tmpForm.Components[i].Name,
        tmpForm.Components[i].ClassName), tmpForm.Components[i]);
end;

procedure TfrmProps.RefreshObjListOfCombo(SelectedObj: TControl);
begin
	if SelectedObj = nil then
		ComponentList.ItemIndex := -1
	else
		ComponentList.ItemIndex := ComponentList.Items.IndexOfObject(SelectedObj);
end;

procedure TfrmProps.ComponentListChange(Sender: TObject);
var
	ctrl : TControl;
begin
	if TComboBox(Sender).ItemIndex = -1 then Exit;
	ctrl := TControl(TComboBox(Sender).Items.Objects[TComboBox(Sender).ItemIndex]);

  //Object Inspector combobox에서 component 선택시에 실제 디자인 폼에도
  //포커스가 옮겨지게 하는 기능
  if frmMain.Designer.Active then
  begin
  	frmMain.Designer.SelectedControls.Clear;
	  frmMain.Designer.SelectedControls.Add(ctrl);
  end;
end;

procedure TfrmProps.FormShow(Sender: TObject);
begin
  FillObjList2Combo();
end;

procedure TfrmProps.FormCreate(Sender: TObject);
begin
  ComponentList.Align := alTop;
  FDisplayPropList := TStringList.Create;
  FillDisplayPropName();  
end;

procedure TfrmProps.FormDestroy(Sender: TObject);
begin
  FDisplayPropList.Free;
  FDisplayPropList := nil;
end;

procedure TfrmProps.ClearObjOfCombo;
begin
  ComponentList.Clear;
end;

function TfrmProps.AdjustTextWidth(AName, AClassName: string): string;
var
  LS: String;
  i,w: integer;
begin
  LS := AName;
  i := ComponentList.Canvas.TextWidth(LS);
  //단추 부분을 제외한 ComboBox를 2등분한 값
  w := (ComponentList.Width Div 2) - GetSystemMetrics(SM_CXHTHUMB) - 1;
  while i < w do
  begin
    LS := LS + ' ';
    i := ComponentList.Canvas.TextWidth(LS);
  end;//while

  Result := LS + AClassName;
end;

procedure TfrmProps.PropInspUpdateParam(Sender: TObject;
  AELPropertyInspectorItem: TELPropertyInspectorItem;
  AELPropEditor: TELPropEditor; var ADisplay: Boolean);
begin
  ADisplay := False;
  if FDisplayPropList.IndexOf(AELPropEditor.PropName) > -1 then
    ADisplay := True;

end;

procedure TfrmProps.FillDisplayPropName;
begin
  FDisplayPropList.Add('Active');
  FDisplayPropList.Add('Align');
  FDisplayPropList.Add('Caption');
  FDisplayPropList.Add('Color');
  FDisplayPropList.Add('Font');
  FDisplayPropList.Add('Comport');
  FDisplayPropList.Add('NextStep');
  FDisplayPropList.Add('FromStep');
  FDisplayPropList.Add('ToStep');
  FDisplayPropList.Add('TrueStep');
  FDisplayPropList.Add('FalseStep');
  FDisplayPropList.Add('VarControl');
  FDisplayPropList.Add('Expression');
  FDisplayPropList.Add('StartIndex');
  FDisplayPropList.Add('Count');
  FDisplayPropList.Add('CompareData');
  FDisplayPropList.Add('Direction');
  FDisplayPropList.Add('Delimiter');
  FDisplayPropList.Add('WriteDataType');
  FDisplayPropList.Add('WriteData');
  FDisplayPropList.Add('BufClearB4Enter');
  FDisplayPropList.Add('DataCondition');
  FDisplayPropList.Add('DisplayFormName');
  FDisplayPropList.Add('ReadDataType');
  FDisplayPropList.Add('ReadData');
  FDisplayPropList.Add('ReadDataCount');
  FDisplayPropList.Add('Name');
  FDisplayPropList.Add('StartPoint');
end;

end.
