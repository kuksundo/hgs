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

unit pjhObjectInspectorBpl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, Vcl.ActnList,System.Math,
  Grids, TypInfo, ELD5_Adds, pjhPropInsp, pjhClasses, pjhOIInterface
 {$IFDEF USECODESITE} ,CodeSiteLogging {$ENDIF};

type
  //THack = class(TPanel); //protected 속성인 canvas를 사용하기 위해 상속을 함.
  TfrmProps = class(TForm, IbplOIInterface)
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    ComponentList: TComboBox;
    PropInsp: TpjhPropertyInspector;
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
    procedure PropInspUpdateParam(Sender: TObject;
      AELPropertyInspectorItem: TELPropertyInspectorItem;
      AELPropEditor: TELPropEditor; var ADisplay: Boolean; var AUseDisplay: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function PropInspEditorEdit(Sender: TObject; ATagList,
      ADescList: TStringList): Integer;
  private
    FDoc: TWincontrol;
    FMainForm: TForm;
    FDisplayPropList,//Property Item중에 Display할 Item list
    FDisplayCompList: TStringList; ////FDisplayPropList를 적용할 컴포넌트 이름 list
    FDeleteControlName: String;//삭제되는 컨트롤 이름
    FIsNormalWork: Boolean; //변수 MainForm에 값이 할당 되면 True(폼생성시 Stack Overflow 때문에 추가함)

    //IbplOIInterface
    function GetMainForm: TForm;
    procedure SetMainForm(const Value: TForm);
    function GetDoc: TWincontrol;
    procedure SetDoc(const Value: TWincontrol);
    function GetOIVisible: Boolean;
    procedure SetOIVisible(const Value: Boolean);
    function GetDeleteControlName: string;
    procedure SetDeleteControlName(const Value: string);
    function GetIsOnDelete: Boolean;
    procedure SetIsOnDelete(const Value: Boolean);
    function GetPropInspComp: TpjhPropertyInspector;
    function GetIsNormalWork: Boolean;
    procedure SetIsNormalWork(const Value: Boolean);
    //IbplOIInterface

    function AdjustTextWidth(AName, AClassName: string): string;
    { Private declarations }
  public
    FIsOnDelete: Boolean; //컨트롤이 삭제되는 동안 True

    //IbplOIInterface
    procedure ClearObjOfCombo;
    procedure FillObjList2Combo;
		procedure RefreshObjListOfCombo(SelectedObj: TControl = nil);
    procedure FillDisplayPropName(DisplayCompList, DisplayPropList: TStrings);
    procedure OI_AssignObjects(AObjects: TList);
    procedure OI_Modified;
    procedure SetDesigner4PropInsp(ADesigner: Pointer);

    property MainForm: TForm read GetMainForm write SetMainForm;
    property Doc: TWincontrol read GetDoc write SetDoc;
    property OIVisible: Boolean read GetOIVisible write SetOIVisible;
    property DeleteControlName: string read GetDeleteControlName write SetDeleteControlName;
    property IsOnDelete: Boolean read GetIsOnDelete write SetIsOnDelete;
    property PropInspComp: TpjhPropertyInspector read GetPropInspComp;
    property IsNormalWork: Boolean read GetIsNormalWork write SetIsNormalWork;
    //IbplOIInterface

    procedure CreateParams(var Params: TCreateParams); override;
    function  IsNonVisualComponent(Component: TComponent): Boolean;
  end;

var
  frmProps: TfrmProps;

implementation

uses frmMainInterface, frmDocInterface, pjhFormDesigner;

{$R *.dfm}

type
  TRGB = record
      R: Integer;
      G: Integer;
      B: Integer;
  end;

  THSV = record
      H: Integer;
      S: Integer;
      V: Integer;
  end;

function HueShift(const AHue, AHueAngle : integer): integer;
begin
  Result := AHue + AHueAngle;

  while (Result >= 360) do
    Result := Result - 360;

  while (Result < 0) do
    Result := Result + 360;

end;

function ColorToRGB2(AColor: TColor): TRGBTriple;
begin
  Result.rgbtRed := GetRValue(AColor);
  Result.rgbtGreen := GetGValue(AColor);
  Result.rgbtBlue := GetBValue(AColor)
end;

function RGBTripleToHSV (CONST RGBTriple: TRGBTriple): THSV; {r, g and b IN [0..255]}
VAR                                                      {h IN 0..359; s,v IN 0..255}
  Delta:  INTEGER;
  Min  :  INTEGER;
BEGIN
  WITH RGBTriple DO
  BEGIN
    Min := MinIntValue( [rgbtRed, rgbtGreen, rgbtBlue] );
    Result.V   := MaxIntValue( [rgbtRed, rgbtGreen, rgbtBlue] )
  END;

  Delta := Result.V - Min;

  // Calculate saturation:  saturation is 0 if r, g and b are all 0
  IF   Result.V =  0
  THEN Result.S := 0
  ELSE Result.S := MulDiv(Delta, 255, Result.V);

  IF   Result.S  = 0
  THEN Result.H := 0   // Achromatic:  When s = 0, h is undefined but assigned the value 0
  ELSE BEGIN    // Chromatic

    WITH RGBTriple DO
    BEGIN
      IF   rgbtRed = Result.V
      THEN  // degrees -- between yellow and magenta
            Result.H := MulDiv(rgbtGreen - rgbtBlue, 60, Delta)
      ELSE
        IF   rgbtGreen = Result.V
        THEN // between cyan and yellow
             Result.H := 120 + MulDiv(rgbtBlue-rgbtRed, 60, Delta)
        ELSE
          IF  rgbtBlue = Result.V
          THEN // between magenta and cyan
               Result.H := 240 + MulDiv(rgbtRed-rgbtGreen, 60, Delta);
    END;

    IF   Result.H < 0
    THEN Result.H := Result.H + 360;

  END
END {RGBTripleToHSV};

FUNCTION RGBtoRGBTriple(CONST red, green, blue:  BYTE):  TRGBTriple;
BEGIN
  WITH RESULT DO
  BEGIN
    rgbtRed   := red;
    rgbtGreen := green;
    rgbtBlue  := blue
  END
END {RGBTriple};

FUNCTION HSVToRGBTriple (CONST AHSV: THSV):  TRGBTriple;
CONST
  divisor:  INTEGER = 255*60;
VAR
  f    :  INTEGER;
  hTemp:  INTEGER;
  p,q,t:  INTEGER;
  VS   :  INTEGER;
BEGIN
  IF   AHSV.S = 0
  THEN RESULT := RGBtoRGBTriple(AHSV.V, AHSV.V, AHSV.V)  // achromatic:  shades of gray
  ELSE BEGIN                              // chromatic color
    IF   AHSV.H = 360
    THEN hTemp := 0
    ELSE hTemp := AHSV.H;

    f     := hTemp MOD 60;     // f is IN [0, 59]
    hTemp := hTemp DIV 60;     // h is now IN [0,6)

    VS := AHSV.V*AHSV.S;
    p := AHSV.V - VS DIV 255;                 // p = v * (1 - s)
    q := AHSV.V - (VS*f) DIV divisor;         // q = v * (1 - s*f)
    t := AHSV.V - (VS*(60 - f)) DIV divisor;  // t = v * (1 - s * (1 - f))

    CASE hTemp OF
      0:   RESULT := RGBtoRGBTriple(AHSV.V, t, p);
      1:   RESULT := RGBtoRGBTriple(q, AHSV.V, p);
      2:   RESULT := RGBtoRGBTriple(p, AHSV.V, t);
      3:   RESULT := RGBtoRGBTriple(p, q, AHSV.V);
      4:   RESULT := RGBtoRGBTriple(t, p, AHSV.V);
      5:   RESULT := RGBtoRGBTriple(AHSV.V, p, q);
      ELSE RESULT := RGBtoRGBTriple(0,0,0)  // should never happen;
                                            // avoid compiler warning
    END
  END
END; {HSVtoRGBTriple}

function RGBToCol2(PRGB: TRGBTriple): TColor;
begin
  Result := RGB(PRGB.rgbtRed,PRGB.rgbtGreen,PRGB.rgbtBlue);
end;

//유채색(Chromatic)이면 True 반환
function IsChromatic(const AColor: TColor): Boolean;
var
  LRGB: TRGBTriple;
begin
  Result := True;
  LRGB := ColorToRGB2(AColor);

  if (LRGB.rgbtBlue = LRGB.rgbtGreen) and (LRGB.rgbtGreen = LRGB.rgbtRed) then
    Result := False;
end;

function CalcComplementalColor(AColor: TColor): TColor;
var
  LRGB: TRGBTriple;
  LHSV: THSV;
begin
  {$IFDEF USECODESITE}
  CodeSite.EnterMethod('CalcComplementalColor');
  try
    CodeSite.Send('AColor', AColor);
  {$ENDIF}

  if not IsChromatic(AColor) then
  begin
    if AColor < $808080 then
      Result := $FFFFFF
    else
      Result := $000000;
    exit;
  end;

  LRGB := ColorToRGB2(AColor);
  LHSV := RGBTripleToHSV(LRGB);

  LHSV.H := HueShift(LHSV.H, 180);

  LRGB := HSVToRGBTriple(LHSV);
  Result := RGBToCol2(LRGB);

  {$IFDEF USECODESITE}
    CodeSite.Send('Result', Result);
  finally
    CodeSite.ExitMethod('CalcComplementalColor');
  end;
  {$ENDIF}
end;

function Create_ObjectInspector(AOwner: TComponent): TForm;
begin
  Result := TForm(TfrmProps.Create(AOwner));
end;

{ TfrmProps }

procedure TfrmProps.SetDeleteControlName(const Value: string);
begin
  FDeleteControlName := Value;
end;

procedure TfrmProps.SetDesigner4PropInsp(ADesigner: Pointer);
begin
  PropInsp.Designer := ADesigner;
end;

procedure TfrmProps.SetDoc(const Value: TWincontrol);
begin
  FDoc := Value;
end;

procedure TfrmProps.SetIsNormalWork(const Value: Boolean);
begin
  FIsNormalWork := Value;
end;

procedure TfrmProps.SetIsOnDelete(const Value: Boolean);
begin
  FIsOnDelete := Value;
end;

procedure TfrmProps.SetMainForm(const Value: TForm);
begin
  FMainForm := Value;
end;

procedure TfrmProps.SetOIVisible(const Value: Boolean);
begin
  if Visible <> Value then
    Visible := Value;

  //if Value then
  //  Show;
end;

procedure TfrmProps.PropInspModified(Sender: TObject);
var
  IbDI : IbplDocInterface;
begin
  if FDoc <> nil then
    if Supports(FDoc, IbplDocInterface, IbDI) then
      IbDI.Modify;

  if PropInsp.Designer <> nil then
  begin
    {$IFDEF USECODESITE}
    CodeSite.EnterMethod('PropInspModified');
    try
    {$ENDIF}
      //TELDesigner(PropInsp.Designer).DesignPanel.Color := TELDesigner(PropInsp.Designer).DesignControl.Brush.Color;
      //TELDesigner(PropInsp.Designer).Grid.Color :=
        //CalcComplementalColor(TELDesigner(PropInsp.Designer).DesignControl.Brush.Color);
        //CalcComplementalColor(TELDesigner(PropInsp.Designer).DesignPanel.GetPanelColor);
    {$IFDEF USECODESITE}
      CodeSite.Send('TELDesigner(PropInsp.Designer).DesignControl', TELDesigner(PropInsp.Designer).DesignControl);
      CodeSite.Send('Designer1', PropInsp.Designer);
    {$ENDIF}

      if TELDesigner(PropInsp.Designer).Active then
      begin
        TELDesigner(PropInsp.Designer).DesignPanel.FormRefresh;
        TELDesigner(PropInsp.Designer).DesignControlRefresh;
    {$IFDEF USECODESITE}
        CodeSite.Send('Designer Active', PropInsp.Designer);
    {$ENDIF}
      end;
    {$IFDEF USECODESITE}
    finally
      CodeSite.ExitMethod('PropInspModified');
    end;
    {$ENDIF}
  end;
  //TfrmDoc(FDoc).Modify;
end;

function TfrmProps.PropInspEditorEdit(Sender: TObject; ATagList,
  ADescList: TStringList): Integer;
var
  IbMI : IbplMainInterface;
begin
  if Assigned(MainForm) then
  begin
    if Supports(MainForm, IbplMainInterface, IbMI) then
    begin
      IbMI.GetTagNames(ATagList, ADescList);
    end;
  end;
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
var
  i: integer;
  IbMI : IbplMainInterface;
begin
  if Assigned(MainForm) then
  begin
    if Supports(MainForm, IbplMainInterface, IbMI) then
    begin
      if FDoc <> nil then
      begin
        with FDoc do
        begin
          for i := 0 to ComponentCount - 1 do
          begin
            if Components[i].InheritsFrom(AClass) then
            begin
              //자기 자신은 리스트에서 제외
              if Components[i].Name <>
                        IbMI.Designer.SelectedControls.DefaultControl.Name then
                AResult.Add(Components[i].Name);
            end
            else
            begin
              if Components[i].ClassType = TWrapperControl then
              begin
                if TWrapperControl(Components[i]).Component.InheritsFrom(AClass) then
                  //자기 자신은 리스트에서 제외
                  if Components[i].Name <>
                          IbMI.Designer.SelectedControls.DefaultControl.Name then
                    AResult.Add(TWrapperControl(Components[i]).Component.Name);
              end;
            end;
          end;//for
        end;//with
      end;//if
    end;
  end;
end;

//ObjectInspector에서 속성값으로 Component를 선택할 때 실행 되는 함수
procedure TfrmProps.PropInspGetComponent(Sender: TObject;
  const AComponentName: String; var AComponent: TComponent);
var i: integer;
begin
  AComponent := FDoc.FindComponent(AComponentName);

  if not Assigned(AComponent) then
  begin
    with FDoc do
    begin
      for i := 0 to ComponentCount - 1 do
      begin
        if Components[i].ClassType = TWrapperControl then
        begin
          if TWrapperControl(Components[i]).Component.Name = AComponentName then
            AComponent := TWrapperControl(Components[i]).Component;
        end;
      end;//for
    end;//with
  end;//if
end;

procedure TfrmProps.FillObjList2Combo;
var
  i: integer;
  tmpForm: TForm;
  LString: String;
  IbMI : IbplMainInterface;
begin
  if Assigned(MainForm) then
  begin
    if Supports(MainForm, IbplMainInterface, IbMI) then
    begin
      if IbMI.Designer.DesignControl = nil then
        exit;

      tmpForm := TForm(IbMI.Designer.DesignControl);
    end;
  end;

	ComponentList.Clear;
  //Main Form 정보 추가
  LString := AdjustTextWidth(tmpForm.Name,tmpForm.ClassName);
	ComponentList.Items.AddObject(LString, tmpForm);
	//ComponentList.Items.AddObject (Format ('%s: %s', [tmpForm.Name,tmpForm.ClassName]),
  //                            tmpForm);
  //폼위의 Component 추가
	for i := 0 to tmpForm.ComponentCount - 1 do
  begin
    if tmpForm.Components[i].ClassType = TWrapperControl then
    begin
      if Assigned(TWrapperControl(tmpForm.Components[i]).Component) then
        LString := AdjustTextWidth(TWrapperControl(tmpForm.Components[i]).Component.Name,
                          TWrapperControl(tmpForm.Components[i]).Component.ClassName)
      else
        Continue;
    end
    else
      LString := AdjustTextWidth(tmpForm.Components[i].Name, tmpForm.Components[i].ClassName);
    //Case Senstive 함 주의할것, Parent를 nil로 함으로써 이 문장 불필요함
    //if tmpForm.Components[i].ClassName <> 'TPJHTimerPool' then
  		ComponentList.Items.AddObject(LString, tmpForm.Components[i]);
    //if tmpForm.Components[i].Owner.ClassType = TWrapperControl then
    //  ShowMessage('aaa');
  end;//for
end;

procedure TfrmProps.RefreshObjListOfCombo(SelectedObj: TControl);
begin
	if SelectedObj = nil then
		ComponentList.ItemIndex := -1
	else
  begin
    //if SelectedObj.ClassType = TWrapperControl then
    //  ComponentList.ItemIndex := ComponentList.Items.IndexOfObject(TWrapperControl(SelectedObj).Component)
    //else
      ComponentList.ItemIndex := ComponentList.Items.IndexOfObject(SelectedObj);
  end;
end;

procedure TfrmProps.ComponentListChange(Sender: TObject);
var
	ctrl : TControl;
  Comp : TComponent;
  IbMI : IbplMainInterface;
begin
	if TComboBox(Sender).ItemIndex = -1 then
    Exit;
	ctrl := TControl(TComboBox(Sender).Items.Objects[TComboBox(Sender).ItemIndex]);
	//Comp := TComponent(TComboBox(Sender).Items.Objects[TComboBox(Sender).ItemIndex]);

  //if Comp.Owner is TWrapperControl then
  //  ctrl := TControl(Comp.Owner)
  //else
  //  ctrl := TControl(Comp);
  //Object Inspector combobox에서 component 선택시에 실제 디자인 폼에도
  //포커스가 옮겨지게 하는 기능
  if Assigned(MainForm) then
  begin
    if Supports(MainForm, IbplMainInterface, IbMI) then
    begin
      if IbMI.Designer.Active then
      begin
        IbMI.Designer.SelectedControls.Clear;
        IbMI.Designer.SelectedControls.Add(ctrl);
      end;
    end;
  end;
end;

procedure TfrmProps.FormShow(Sender: TObject);
begin
  if FIsNormalWork then
    FillObjList2Combo();
end;

function TfrmProps.GetDeleteControlName: string;
begin
  Result := FDeleteControlName;
end;

function TfrmProps.GetDoc: TWincontrol;
begin
  Result := TWincontrol(FDoc);
end;

function TfrmProps.GetIsNormalWork: Boolean;
begin
  Result := FIsNormalWork;
end;

function TfrmProps.GetIsOnDelete: Boolean;
begin
  Result := FIsOnDelete;
end;

function TfrmProps.GetMainForm: TForm;
begin
  Result := FMainForm;
end;

function TfrmProps.GetOIVisible: Boolean;
begin
  Result := Visible;
end;

function TfrmProps.GetPropInspComp: TpjhPropertyInspector;
begin
  Result := PropInsp;
end;

procedure TfrmProps.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	ComponentList.Clear;
  FDisplayPropList.Free;
  FDisplayPropList := nil;

  FDisplayCompList.Free;
  FDisplayCompList := nil;
end;

procedure TfrmProps.FormCreate(Sender: TObject);
begin
  FIsNormalWork := False;

  ComponentList.Align := alTop;
  FDisplayPropList := TStringList.Create;
  FDisplayCompList := TStringList.Create;
  //FillDisplayPropName(FDisplayCompList, FDisplayCompList);
  //frmMain.RegisterDefaultComponent;
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

procedure TfrmProps.FillDisplayPropName(DisplayCompList, DisplayPropList: TStrings);
var i: integer;
begin
  if Assigned(DisplayCompList) then
    for i := 0 to DisplayCompList.Count - 1 do
      FDisplayCompList.AddStrings(DisplayCompList);

  if Assigned(DisplayPropList) then
    for i := 0 to DisplayPropList.Count - 1 do
      FDisplayPropList.Add(DisplayPropList.Strings[i]);

  FDisplayCompList.Add('TfrmDoc');
  FDisplayCompList.Add('TpjhLogicPanel');
  FDisplayCompList.Add('TpjhProcess');
  FDisplayCompList.Add('TpjhProcess2');
  FDisplayCompList.Add('TpjhIfControl');
  FDisplayCompList.Add('TpjhGotoControl');
  FDisplayCompList.Add('TpjhStartControl');
  FDisplayCompList.Add('TpjhStopControl');
  FDisplayCompList.Add('TpjhStartButton');
  FDisplayCompList.Add('TPjhComLed');
  FDisplayCompList.Add('TpjhWriteComport');
  FDisplayCompList.Add('TpjhReadComport');
  FDisplayCompList.Add('TpjhDelay');
  FDisplayCompList.Add('TpjhWriteFile');
  FDisplayCompList.Add('TpjhWriteFAMem');
  FDisplayCompList.Add('TpjhSetTimer');
  FDisplayCompList.Add('TpjhIFTimer');

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
  FDisplayPropList.Add('ReadDataBuf');
  FDisplayPropList.Add('ReadDataCount');
  FDisplayPropList.Add('Name');
  FDisplayPropList.Add('Path');
  FDisplayPropList.Add('Offset');
  FDisplayPropList.Add('Connectors');
  FDisplayPropList.Add('StartPoint');
  FDisplayPropList.Add('LogicControl');
  FDisplayPropList.Add('SingleStep');
  FDisplayPropList.Add('AutoReset');
  FDisplayPropList.Add('BeforeDelay');
  FDisplayPropList.Add('AfterDelay');
  FDisplayPropList.Add('DataFile');
  FDisplayPropList.Add('Text');
  //FDisplayPropList.Add('Start');
  FDisplayPropList.Add('Timeout');
  FDisplayPropList.Add('TimeLimit');
  FDisplayPropList.Add('DataCount');
  FDisplayPropList.Add('DataIndex');
end;

procedure TfrmProps.PropInspUpdateParam(Sender: TObject;
  AELPropertyInspectorItem: TELPropertyInspectorItem;
  AELPropEditor: TELPropEditor; var ADisplay: Boolean; var AUseDisplay: Boolean);
var
  LStr: String;
  IbMI : IbplMainInterface;
begin
  ADisplay := True;
  AUseDisplay := False;

  if FDisplayCompList.Count <= 0 then
    exit;

  if Assigned(MainForm) then
  begin
    if Supports(MainForm, IbplMainInterface, IbMI) then
    begin
      if FDisplayCompList.IndexOf(IbMI.Designer.SelectedControls.DefaultControl.ClassName) > -1 then
        AUseDisplay := True;
    end;
  end;

  if FDisplayPropList.Count <= 0 then
    exit;

  ADisplay := False;

  if FDisplayPropList.IndexOf(AELPropEditor.PropName) > -1 then
  begin
    if (FIsOnDelete) and (FDeleteControlName <> '') then
    begin
      //컴포넌트를 삭제한 경우 삭제한 컴포넌트가 다른 컴포넌트의 파라미터값으로
      //설정 되어 있을때, 해당 컴포넌트를 선택하면 Access Violation 발생하는 버그 해결
      //Designer의 OnControlDeleting에서 호출됨
      LStr := AELPropEditor.Value;
      if AELPropEditor.PropTypeInfo.Kind = tkClass then
        //구조체 변수등은 제외함 '(' 로 시작함
        if (LStr <> '') and (Pos('(', LStr) = 0) and (FDeleteControlName = LStr) then
          //if Doc.FindComponent(LStr) = nil then
            AELPropEditor.Value := '';
    end;
    ADisplay := True;
  end;
end;

procedure TfrmProps.FormActivate(Sender: TObject);
var
  IbMI : IbplMainInterface;
begin
//  if IsNormalWork then
//    if Assigned(MainForm) then
//      if Supports(MainForm, IbplMainInterface, IbMI) then
//        IbMI.ActionList.State := asSuspended;
end;

procedure TfrmProps.FormDeactivate(Sender: TObject);
var
  IbMI : IbplMainInterface;
begin
//  if Assigned(MainForm) then
//    if Supports(MainForm, IbplMainInterface, IbMI) then
//      IbMI.ActionList.State := asNormal;
end;

function TfrmProps.IsNonVisualComponent(Component: TComponent): Boolean;
begin
  Result:= False;
  if (Component is TWrapperControl) then
    Result:= True;
end;

procedure TfrmProps.OI_AssignObjects(AObjects: TList);
begin
  PropInsp.AssignObjects(AObjects);
end;

procedure TfrmProps.OI_Modified;
begin
  PropInsp.Modified;
end;

procedure TfrmProps.CreateParams(var Params: TCreateParams);
var
  IbMI : IbplMainInterface;
begin
  inherited;

  //if Assigned(MainForm) then
  //  if Supports(MainForm, IbplMainInterface, IbMI) then
  //    Params.WndParent := IbMI.MainHandle;
end;

exports //The export name is Case Sensitive
  Create_ObjectInspector;

initialization
  RegisterClasses([TfrmProps]);

finalization
  UnRegisterClasses([TfrmProps]);

end.


