unit ModbusMapConfUint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NxColumns, NxColumnClasses, ImgList, NxEdit, ComCtrls,
  ToolWin, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, NxCells,
  ExtCtrls, Menus, NxClasses, EngineParameterClass, SynCommons,
  HiMECSConst, ClipBrd, Data.DB, MemDS, DBAccess, Ora, ComObj, OleCtrls, OraCall,
  UnitEnumHelper, UnitEngineParamRecord, UnitEngineParamConst;//, superobject

type
  TClipBrdGridData = record
    FGridData : string[255];
  end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    Button1: TButton;
    EncryptCB: TCheckBox;
    RGConvert: TRadioGroup;
    Panel2: TPanel;
    Panel3: TPanel;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    btnLeftAlignment: TToolButton;
    btnCenterAlignment: TToolButton;
    btnRightAlignment: TToolButton;
    ToolButton6: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    btnAddRow: TToolButton;
    btnAddCol: TToolButton;
    ToolButton10: TToolButton;
    ToolButton13: TToolButton;
    ToolButton12: TToolButton;
    ToolButton14: TToolButton;
    ToolButton16: TToolButton;
    ToolButton15: TToolButton;
    ToolButton8: TToolButton;
    ToolButton17: TToolButton;
    ToolButton20: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton9: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton1: TToolButton;
    btnBold: TToolButton;
    btnItalic: TToolButton;
    btnUnderline: TToolButton;
    ToolButton2: TToolButton;
    ColorPickerEditor1: TNxColorPicker;
    ToolButton11: TToolButton;
    Panel4: TPanel;
    NextGrid1: TNextGrid;
    Button2: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    ConvertTagtoAddress1: TMenuItem;
    N1: TMenuItem;
    SystemClose1: TMenuItem;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    RGModeSelect: TRadioGroup;
    SaveDialog2: TSaveDialog;
    Button3: TButton;
    Button4: TButton;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    CopyRow1: TMenuItem;
    N11: TMenuItem;
    Button5: TButton;
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    N4: TMenuItem;
    EditMatrixData1: TMenuItem;
    FileAppend1: TMenuItem;
    SetAlarmEnable1: TMenuItem;
    SetAlarmDisable1: TMenuItem;
    N5: TMenuItem;
    SetContacttoA1: TMenuItem;
    SetContacttoB1: TMenuItem;
    agNameCalculated1: TMenuItem;
    N6: TMenuItem;
    SetFormula1: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    Label1: TLabel;
    FormulaEdit: TEdit;
    Etc1: TMenuItem;
    ClearClipBoard1: TMenuItem;
    Button6: TButton;
    FileOpenFromExcel1: TMenuItem;
    SaveToCSV1: TMenuItem;
    N10: TMenuItem;
    Button7: TButton;
    Button8: TButton;
    procedure Close1Click(Sender: TObject);
    procedure btnLeftAlignmentClick(Sender: TObject);
    procedure btnCenterAlignmentClick(Sender: TObject);
    procedure btnRightAlignmentClick(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure btnAddRowClick(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure ToolButton18Click(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
    procedure ToolButton21Click(Sender: TObject);
    procedure ToolButton22Click(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure ColorPickerEditor1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ConvertTagtoAddress1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure CopyRow1Click(Sender: TObject);
    procedure NextGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NextGrid1EditEnter(Sender: TObject);
    procedure NextGrid1EditExit(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure EditMatrixData1Click(Sender: TObject);
    procedure FileAppend1Click(Sender: TObject);
    procedure SetAlarmEnable1Click(Sender: TObject);
    procedure SetAlarmDisable1Click(Sender: TObject);
    procedure SetContacttoA1Click(Sender: TObject);
    procedure SetContacttoB1Click(Sender: TObject);
    procedure agNameCalculated1Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure ClearClipBoard1Click(Sender: TObject);
    procedure FileOpenFromExcel1Click(Sender: TObject);
    procedure SaveToCSV1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure NextGrid1CellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure NextGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button7Click(Sender: TObject);
  private
    FEngineParameter: TEngineParameter;
    FClipBdStrData: TClipBrdGridData;
    //FEngineParameter2: TEngineParameter2;
    FNextGridEditMode: Boolean;//Cell Edit Enter 시에 True, Exit시에 False, Row 복사시에 사용됨
    FMousePoint: TPoint;

    procedure WMDrawClipboard(var Msg: TMessage); message WM_DRAWCLIPBOARD;
    procedure WMChangeCBChain(var Msg: TMessage); message WM_CHANGECBCHAIN;

    procedure Data2XML;
    procedure MakeGridData2Parameter; //Modbus Map txt File을 읽어서 수정할때 쓰임
    procedure MakeGridData2Parameter2(AIsSqlite: Boolean = False);//JSON File 을 읽어서 수정할때 쓰임
    procedure ConvertToBase(AType, AAddrIndex: integer);
    function GetSelectedRow2Text: string;
    function GetSelectedRow2List: TStringList;
    procedure AddGridRowFromClipBrd(AClipBrdData: string);
    procedure ShowProperties;
    procedure SetConfigEngParamItemData(AIndex: Integer);
  public
    procedure TextFile_Open;
    procedure XMLFile_Open;
    procedure JSONFile_Open;
    procedure JSONFile_S7_Open;
    procedure Sqlite_Open;
    procedure AddGridColumn4Parameter(AIsSqlite: Boolean = False);
    procedure AddGridColumn4TxtFile;
    procedure AddParameter2Grid(AIsSqlite: Boolean = False);
    procedure AddParamItem2Grid(AIndex: integer; AEngineParameterItem: TEngineParameterItem);
    function GetTextHeader: string;
    procedure AddGridColumn4S7;
    procedure AppendParameterFromFile(AFileName: string);
    function MakeFormulaFromSelected(AOperator: string): string;

    procedure Data_2_TextFile;
    procedure Param_2_TextFile;
    procedure Data_2_ParamFile;
    procedure Data_2_ParamFile2;
    procedure Data_2_ParamFile_JSON(AFromGridData: Boolean);
    procedure Data_2_S7ParamFile_JSON;
    procedure Data_2_Sqlite;
    function GetParamType(AType: string): TParameterType;
    procedure CalcAbsoluteIndex;
    procedure ConnectDB;
    procedure GetTagNameFromDB(ATableName: string);
    procedure GetEngineTypeFromDB(ACombo: TComboBox);
    function GetMeasureTableFromDB(AEngType: string): string;
    procedure SetAlarmEnable(AEnable: Boolean);
    procedure SetContact(AContact: integer);

    procedure SetMatrix;
    procedure DeleteItems;
    procedure DeleteEngineParamterFromGrid(AIndex: integer);

    procedure OpenDataFromExcel;
    procedure RemoveDummy;
    procedure AppendProjEngNo2TagName;
  end;

var
  Form1: TForm1;
  NextInChain  : THandle;
  DelphiGuide  : TClipBrdGridData;
  OurFormat    : Integer;
  MemberHandle : THandle;
  ClipStrList: TStringList;
implementation

uses String_Func, DBSelectUint, UnitSetMatrix, UnitEngParamConfig, UnitRttiUtil,
  UnitEngineMasterData;

{$R *.dfm}

//공유메모리의 위치정보(배열Index)를 Absolute Index에 저장함.
//Binary 의 경우 32Bit내 위치정보를 Radix Position에 저장함.
procedure TForm1.CalcAbsoluteIndex;
var
  i,PrevAddrHex, CurAddrHex,
  PrevBlockNo, CurIndex,
  PrevAddrHex2, CurRadixIndex: integer;
begin
  with NextGrid1 do
  begin
    PrevBlockNo := -1;
    CurIndex := 0;
    PrevAddrHex := 0;
    CurRadixIndex := 0;
    PrevAddrHex2 := 0;

    for i := 0 to RowCount-1 do
    begin
      if PrevBlockNo <> CellByName['BlockNo',i].AsInteger then
      begin
        PrevBlockNo := CellByName['BlockNo',i].AsInteger;
        CurIndex := 0;
        PrevAddrHex := HexToint(CellByName['Address',i].AsString);
      end;

      if UpperCase(CellByName['Alarm',i].AsString) = 'FALSE' then
        if PrevAddrHex2 <> HexToInt(CellByName['Address',i].AsString) then
          CurRadixIndex := 0;

      CurAddrHex := HexToint(CellByName['Address',i].AsString);
      CurIndex := CurIndex + (CurAddrHex - PrevAddrHex);//Dummmy 가 있을경우 Index를 Dummy 갯수 만큼 증가 시킴
      CellByName['AbsoluteIndex',i].AsInteger := CurIndex;
      //Inc(CurIndex);
      PrevAddrHex := HexToint(CellByName['Address',i].AsString);

      if UpperCase(CellByName['Alarm',i].AsString) = 'FALSE' then
      begin
        PrevAddrHex2 := HexToInt(CellByName['Address',i].AsString);
        CellByName['BitIndex',i].AsInteger := CurRadixIndex;
        Inc(CurRadixIndex);
      end;
    end;
  end;//with
end;

procedure TForm1.ClearClipBoard1Click(Sender: TObject);
begin
  ClipStrList.Clear;
  EmptyClipBoard;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  if RGModeSelect.ItemIndex = 0 then
    TextFile_Open
  else
  if RGModeSelect.ItemIndex = 1 then
    XMLFile_Open
  else
  if RGModeSelect.ItemIndex = 2 then
    JSONFile_Open
  else
  if RGModeSelect.ItemIndex = 3 then
    JSONFile_S7_Open
  else
  if RGModeSelect.ItemIndex = 4 then
    Sqlite_Open;
end;

procedure TForm1.btnLeftAlignmentClick(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].Alignment := taLeftJustify;
end;

procedure TForm1.btnCenterAlignmentClick(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].Alignment := taCenter;
end;

procedure TForm1.btnRightAlignmentClick(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].Alignment := taRightJustify;
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].VerticalAlignment := taAlignTop;
end;

procedure TForm1.ToolButton4Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].VerticalAlignment := taVerticalCenter;
end;

procedure TForm1.ToolButton5Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].VerticalAlignment := taAlignBottom;
end;

procedure TForm1.AddGridColumn4Parameter(AIsSqlite: Boolean);
var
  LnxTextColumn: TnxTextColumn;
  LNxComboBoxColumn: TNxComboBoxColumn;
begin
  with NextGrid1 do
  begin
    ClearRows;
    Columns.Clear;

    Columns.Add(TnxIncrementColumn,'No.');

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'LevelIndex(ZAxis Size)'));
    LnxTextColumn.Name := 'LevelIndex';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'NodeIndex(TMatrixItem Index)'));
    LnxTextColumn.Name := 'NodeIndex';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'AbsoluteIndex'));
    LnxTextColumn.Name := 'AbsoluteIndex';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'MaxValue(XAxis Size)'));
    LnxTextColumn.Name := 'MaxValue';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Contact(YAxis Size)'));
    LnxTextColumn.Name := 'Contact';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'TagName'));
    LnxTextColumn.Name := 'TagName';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Description'));
    LnxTextColumn.Name := 'Description';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Address'));
    LnxTextColumn.Name := 'Address';
    LnxTextColumn.Options := [coCanClick,coCanInput,coCanSort,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Alarm'));
    LnxTextColumn.Name := 'Alarm';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Func Code'));
    LnxTextColumn.Name := 'FCode';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'FFUnit'));
    LnxTextColumn.Name := 'FFUnit';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'SensorType'));
    LNxComboBoxColumn.Name := 'SensorType';
    g_SensorType.SetType2List(LNxComboBoxColumn.Items);
    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'ParameterCatetory'));
    LNxComboBoxColumn.Name := 'ParameterCatetory';
    ParameterCatetory2Strings(LNxComboBoxColumn.Items);
    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    if AIsSqlite then
    begin
      LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'ParameterCatetory4AVAT2'));
      LNxComboBoxColumn.Name := 'ParameterCatetory4AVAT2';
      g_ParameterCatetory4AVAT2.SetType2List(LNxComboBoxColumn.Items);
      LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'DFAlarmKind'));
      LNxComboBoxColumn.Name := 'DFAlarmKind';
      g_DFAlarmKind.SetType2List(LNxComboBoxColumn.Items);
      LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'EngineUsage'));
      LNxComboBoxColumn.Name := 'EngineUsage';
      g_EngineUsage.SetType2List(LNxComboBoxColumn.Items);
      LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'DFCommissioningItem'));
      LNxComboBoxColumn.Name := 'DFCommissioningItem';
      g_DFCommissioningItem.SetType2List(LNxComboBoxColumn.Items);
      LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'ParamNo'));
      LnxTextColumn.Name := 'ParamNo';
      LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Description_Eng'));
      LnxTextColumn.Name := 'Description_Eng';
      LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Description_Kor'));
      LnxTextColumn.Name := 'Description_Kor';
      LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
    end;

    LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'ParameterType'));
    LNxComboBoxColumn.Name := 'ParameterType';
    ParameterType2Strings(LNxComboBoxColumn.Items);
    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'ParameterSource'));
    LNxComboBoxColumn.Name := 'ParameterSource';
    ParameterSource2Strings(LNxComboBoxColumn.Items);
    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'SharedMemName'));
    LnxTextColumn.Name := 'SharedName';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Block No'));
    LnxTextColumn.Name := 'BlockNo';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Radix Position(Bit Index)'));
    LnxTextColumn.Name := 'BitIndex';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Value(Manual Input)'));
    LnxTextColumn.Name := 'Value';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Alarm Enable'));
    LnxTextColumn.Name := 'AlarmEnable';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Proj. No'));
    LnxTextColumn.Name := 'ProjNo';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Eng. No'));
    LnxTextColumn.Name := 'EngNo';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
  end;
end;

procedure TForm1.AddGridColumn4S7;
var
  LnxTextColumn: TnxTextColumn;
  LNxComboBoxColumn: TNxComboBoxColumn;
begin
  with NextGrid1 do
  begin
    ClearRows;
    Columns.Clear;

    Columns.Add(TnxIncrementColumn,'No.');

    LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'Area'));
    LNxComboBoxColumn.Name := 'Area';
    S7Area2Strings(LNxComboBoxColumn.Items);
    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'DB'));
    LnxTextColumn.Name := 'DB';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'DataType'));
    LNxComboBoxColumn.Name := 'DataType';
    S7DataType2Strings(LNxComboBoxColumn.Items);
    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Offset'));
    LnxTextColumn.Name := 'Offset';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Contact'));
    LnxTextColumn.Name := 'Contact';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'TagName'));
    LnxTextColumn.Name := 'TagName';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Description'));
    LnxTextColumn.Name := 'Description';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Address'));
    LnxTextColumn.Name := 'Address';
    LnxTextColumn.Options := [coCanClick,coCanInput,coCanSort,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Alarm'));
    LnxTextColumn.Name := 'Alarm';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Func Code'));
    LnxTextColumn.Name := 'FCode';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'FFUnit'));
    LnxTextColumn.Name := 'FFUnit';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'SensorType'));
    LNxComboBoxColumn.Name := 'SensorType';
    g_SensorType.SetType2List(LNxComboBoxColumn.Items);
    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'ParameterCatetory'));
    LNxComboBoxColumn.Name := 'ParameterCatetory';
    ParameterCatetory2Strings(LNxComboBoxColumn.Items);
    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'ParameterType'));
    LNxComboBoxColumn.Name := 'ParameterType';
    ParameterType2Strings(LNxComboBoxColumn.Items);
    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn(Columns.Add(TNxComboBoxColumn,'ParameterSource'));
    LNxComboBoxColumn.Name := 'ParameterSource';
    ParameterSource2Strings(LNxComboBoxColumn.Items);
    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'SharedMemName'));
    LnxTextColumn.Name := 'SharedName';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Block No'));
    LnxTextColumn.Name := 'CNT';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
  end;
end;

procedure TForm1.AddGridColumn4TxtFile;
var
  LnxTextColumn: TnxTextColumn;
  LNxComboBoxColumn: TNxComboBoxColumn;
begin
  with NextGrid1 do
  begin
    ClearRows;
    Columns.Clear;

    Columns.Add(TnxIncrementColumn,'No.');

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'TAG_NAME'));
    LnxTextColumn.Name := 'TAG_NAME';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'DESCRIPT'));
    LnxTextColumn.Name := 'DESCRIPT';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'SID'));
    LnxTextColumn.Name := 'SID';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'ADDR'));
    LnxTextColumn.Name := 'ADDR';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'CNT'));
    LnxTextColumn.Name := 'CNT';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'ALARM'));
    LnxTextColumn.Name := 'ALARM';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'MAXVAL'));
    LnxTextColumn.Name := 'MAXVAL';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'CONTACT'));
    LnxTextColumn.Name := 'CONTACT';
    LnxTextColumn.Options := [coCanClick,coCanInput,coCanSort,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
  end;
end;

procedure TForm1.AddGridRowFromClipBrd(AClipBrdData: string);
var
  LStr: string;
  i: integer;
begin
  if AClipBrdData <> '' then
  begin
    if NextGrid1.Columns.Count = 0 then
    begin
      if RGModeSelect.ItemIndex = 3 then
        AddGridColumn4S7
      else
        AddGridColumn4Parameter;
    end;

    while True do
    begin
      if AClipBrdData = '' then
        break;

      LStr := GetToken(AClipBrdData,';');

      if LStr = sLineBreak then
        LStr := GetToken(AClipBrdData,';');

      if (LStr <> '') and (LStr <> sLineBreak) then
      begin
        NextGrid1.AddRow();

        for i := 0 to NextGrid1.Columns.Count - 1 do
        begin
          NextGrid1.Cell[i, NextGrid1.RowCount-1].AsString := LStr;
          LStr := GetToken(AClipBrdData,';');
        end;
      end;
    end;
  end;
end;

procedure TForm1.AddParameter2Grid(AIsSqlite: Boolean = False);
var
  i: integer;
begin
  with NextGrid1, FEngineParameter do
  begin
    for i := 0 to EngineParameterCollect.Count - 1 do
    begin
      AddRow();

      CellByName['LevelIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].LevelIndex);
      CellByName['NodeIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].NodeIndex);
      CellByName['AbsoluteIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].AbsoluteIndex);
      CellByName['MaxValue', i].AsString := IntToStr(EngineParameterCollect.Items[i].MaxValue);
      CellByName['Contact', i].AsString := IntToStr(EngineParameterCollect.Items[i].Contact);
      CellByName['TagName', i].AsString := EngineParameterCollect.Items[i].TagName;
      CellByName['Description', i].AsString := EngineParameterCollect.Items[i].Description;
      CellByName['Address', i].AsString := EngineParameterCollect.Items[i].Address;
      CellByName['Alarm', i].AsString := BoolToStr(EngineParameterCollect.Items[i].Alarm, true);
      CellByName['FCode', i].AsString := EngineParameterCollect.Items[i].FCode;
      CellByName['FFUnit', i].AsString := EngineParameterCollect.Items[i].FFUnit;
      CellByName['SensorType', i].AsString := g_SensorType.ToString(EngineParameterCollect.Items[i].SensorType);
      CellByName['ParameterCatetory', i].AsString := ParameterCatetory2String(EngineParameterCollect.Items[i].ParameterCatetory);
      CellByName['ParameterType', i].AsString := ParameterType2String(EngineParameterCollect.Items[i].ParameterType);
      CellByName['ParameterSource', i].AsString := ParameterSource2String(EngineParameterCollect.Items[i].ParameterSource);
      CellByName['SharedName', i].AsString := EngineParameterCollect.Items[i].SharedName;
      CellByName['BlockNo', i].AsString := IntToStr(EngineParameterCollect.Items[i].BlockNo);
      CellByName['BitIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].RadixPosition);
      CellByName['Value', i].AsString := EngineParameterCollect.Items[i].Value;
      CellByName['AlarmEnable', i].AsString := BoolToStr(EngineParameterCollect.Items[i].AlarmEnable, True);
      CellByName['ProjNo', i].AsString := EngineParameterCollect.Items[i].ProjNo;
      CellByName['EngNo', i].AsString := EngineParameterCollect.Items[i].EngNo;

      if AIsSqlite then
      begin
        CellByName['ParameterCatetory4AVAT2', i].AsString := g_ParameterCatetory4AVAT2.ToString(EngineParameterCollect.Items[i].ParameterCatetory4AVAT2);
        CellByName['DFAlarmKind', i].AsString := g_DFAlarmKind.ToString(EngineParameterCollect.Items[i].DFAlarmKind);
        CellByName['EngineUsage', i].AsString := g_EngineUsage.ToString(EngineParameterCollect.Items[i].EngineUsage);
        CellByName['DFCommissioningItem', i].AsString := g_DFCommissioningItem.ToString(EngineParameterCollect.Items[i].DFCommissioningItem);
        CellByName['ParamNo', i].AsString := EngineParameterCollect.Items[i].ParamNo;
        CellByName['Description_Eng', i].AsString := EngineParameterCollect.Items[i].Description_Eng;
        CellByName['Description_Kor', i].AsString := EngineParameterCollect.Items[i].Description_Kor;
      end;
    end;//for
  end;//with
end;

procedure TForm1.AddParamItem2Grid(AIndex: integer;
  AEngineParameterItem: TEngineParameterItem);
begin
  with NextGrid1 do
  begin
    Cells[1, AIndex] := IntToStr(AEngineParameterItem.LevelIndex);
    Cells[2, AIndex] := IntToStr(AEngineParameterItem.NodeIndex);
    Cells[3, AIndex] := IntToStr(AEngineParameterItem.AbsoluteIndex);
    Cells[4, AIndex] := IntToStr(AEngineParameterItem.MaxValue);
    Cells[5, AIndex] := IntToStr(AEngineParameterItem.Contact);
    Cells[6, AIndex] := AEngineParameterItem.TagName;
    Cells[7, AIndex] := AEngineParameterItem.Description;
    Cells[8, AIndex] := AEngineParameterItem.Address;
    Cells[9, AIndex] := BoolToStr(AEngineParameterItem.Alarm, true);
    Cells[10, AIndex] := AEngineParameterItem.FCode;
    Cells[11, AIndex] := AEngineParameterItem.FFUnit;
    Cells[12, AIndex] := g_SensorType.ToString(AEngineParameterItem.SensorType);
    Cells[13, AIndex] := ParameterCatetory2String(AEngineParameterItem.ParameterCatetory);
    Cells[14, AIndex] := ParameterType2String(AEngineParameterItem.ParameterType);
    Cells[15, AIndex] := ParameterSource2String(AEngineParameterItem.ParameterSource);
    Cells[16, AIndex] := AEngineParameterItem.SharedName;
    Cells[17, AIndex] := IntToStr(AEngineParameterItem.BlockNo);
    Cells[18, AIndex] := IntToStr(AEngineParameterItem.RadixPosition);
    Cells[19, AIndex] := AEngineParameterItem.Value;
    Cells[20, AIndex] := BoolToStr(AEngineParameterItem.AlarmEnable, True);
  end;
end;

procedure TForm1.agNameCalculated1Click(Sender: TObject);
var
  LItem: TEngineParameterItem;
  i: integer;
begin
  i := NextGrid1.SelectedRow;

  if i > 0  then
  begin
    with NextGrid1 do
    begin
      if (Cell[6,i].AsString = '') and
        (g_SensorType.ToType(Cell[12,i].AsString) = stCalculated) and
        (String2ParameterSource(Cell[15,i].AsString) = psManualInput)then
        Cell[6,i].AsString := 'V_' + formatDateTime('yyyymmddhhnnss',now)
    end;
  end;
end;

procedure TForm1.AppendParameterFromFile(AFileName: string);
var
  LParam: TEngineParameter;
  i: integer;
begin
  LParam := TEngineParameter.Create(nil);
  try
    LParam.LoadFromJSONFile(AFileName, ExtractFileName(AFileName), EncryptCB.Checked);

    for i := 0 to LParam.EngineParameterCollect.Count - 1 do
      FEngineParameter.EngineParameterCollect.AddEngineParameterItem(LParam.EngineParameterCollect.Items[i]);

    for i := 0 to LParam.MatrixCollect.Count - 1 do
      FEngineParameter.MatrixCollect.AddMatrixItem(LParam.MatrixCollect.Items[i]);
  finally
    LParam.Free;
  end;
end;

procedure TForm1.AppendProjEngNo2TagName;
var
  i: integer;
  LStr: string;
begin
  NextGrid1.BeginUpdate;

  try
    for i := NextGrid1.RowCount - 1 downto 0 do
    begin
      if UpperCase(NextGrid1.CellByName['TagName',i].AsString) <> 'DUMMY' then
      begin
        LStr := NextGrid1.CellByName['ProjNo',i].AsString + '_' +
          NextGrid1.CellByName['EngNo',i].AsString + '_' +
          NextGrid1.CellByName['TagName',i].AsString;
        NextGrid1.CellByName['TagName',i].AsString := LStr;
      end;
    end;
  finally
    NextGrid1.EndUpdate;
  end;
end;

procedure TForm1.btnAddRowClick(Sender: TObject);
begin
  if NextGrid1.Columns.Count = 0 then
  begin
    if RGModeSelect.ItemIndex = 3 then
      AddGridColumn4S7
    else
      AddGridColumn4Parameter;
  end;

  NextGrid1.AddRow;
  NextGrid1.SelectLastRow;
end;

procedure TForm1.ToolButton13Click(Sender: TObject);
var
  Li: integer;
  LRow: integer;
begin
  LRow := NextGrid1.AddRow;

  for Li := 0 to 8 do
    NextGrid1.Cells[Li, LRow] := NextGrid1.Cells[Li, NextGrid1.SelectedRow];

  NextGrid1.SelectLastRow;
end;

procedure TForm1.ToolButton14Click(Sender: TObject);
begin
  DeleteItems;
  //NextGrid1.DeleteRow(NextGrid1.SelectedRow);
  //FEngineParameter.EngineParameterCollect.Delete(NextGrid1.SelectedRow);
end;

procedure TForm1.ToolButton16Click(Sender: TObject);
begin
  NextGrid1.Columns.Delete(NextGrid1.SelectedColumn);
end;

procedure TForm1.ToolButton8Click(Sender: TObject);
var
  i: integer;
begin
  if NextGrid1.SelectedCount > 0 then
  begin
    if NextGrid1.SelectedCount = 1 then
    begin
      NextGrid1.MoveRow(NextGrid1.SelectedRow, NextGrid1.SelectedRow - 1);
      NextGrid1.SelectedRow := NextGrid1.SelectedRow - 1;
    end
    else
    begin
      for i := 1 to NextGrid1.RowCount - 1 do
      begin
        if NextGrid1.Selected[i] then
        begin
          NextGrid1.MoveRow(i, i - 1);
          NextGrid1.Selected[i] := False;
          NextGrid1.Selected[i-1] := True;
        end;
      end;

    end;
  end;
end;

//Store the next window along in the chain to forward message
procedure TForm1.WMChangeCBChain(var Msg: TMessage);
var
  Remove, Next: THandle;
begin
  Remove := Msg.WParam;
  Next := Msg.LParam;

  with Msg do
  begin
    if NextInChain = Remove then
      NextInChain := Next
    else if NextInChain <> 0 then
      SendMessage(NextInChain, WM_ChangeCBChain, Remove, Next)
  end;
end;

//When a cliboard change occurs, WM_DrawClipboard message is notified
procedure TForm1.WMDrawClipboard(var Msg: TMessage);
var
  MemberPointer : Pointer;//^TClipBrdGridData;
  //MemberInClip  : THandle;
  MemberHandle  : THandle;
  LStr: string;
  LSize: integer;
  LPointer: Pointer;
  //AMember       : TClipBrdGridData;
  LStream: TStream;
  i: integer;
begin
  if Clipboard.HasFormat(OurFormat) then
  begin
    //if OpenClipboard(Handle) then
    //begin
    {  MemberInClip:=GetClipboardData(OurFormat);
      LSize := GlobalSize(MemberInClip);
      MemberPointer := AllocMem(LSize);
      LPointer := GlobalLock(MemberInClip);

      //CopyMemory(MemberPointer, LPointer, LSize);
      MoveMemory(MemberPointer, LPointer, LSize);
      FClipBdStrData.FGridData := MemberPointer^.FGridData;

      GlobalUnLock(MemberInClip);}

      MemberHandle := Clipboard.GetAsHandle(OurFormat);
      if MemberHandle <> 0 then
      begin
        MemberPointer := Windows.GlobalLock(MemberHandle);
        if MemberPointer <> nil then
        begin
          try
            LStream := TMemoryStream.Create;
            try
              LStream.WriteBuffer(MemberPointer^, GlobalSize(MemberHandle));
              LStream.Position := 0;
              ClipStrList.Clear;
              {-- Read your data from the stream. --}
              try
                ClipStrList.LoadFromStream(LStream);
                //for i := 0 to ClipStrList.Count - 1 do
                //  AddGridRowFromClipBrd(ClipStrList.Strings[i]);
              finally
                //LStrList.Free;
              end;
            finally
               LStream.Free;
            end;
          finally
             Windows.GlobalUnlock(MemberHandle);
          end;
        end;
      end;

      //CloseClipboard();
    //end;

  end;
//    FClipBdStrData := ClipBoard.AsText;

  if NextInChain <> 0 then
    SendMessage(NextInChain, WM_DrawClipboard, 0, 0)
end;

procedure TForm1.XMLFile_Open;
var
  i: integer;
begin
  OpenDialog1.Filter := 'Engine Parameter|*.param';
  OpenDialog1.FileName := '';

  if OpenDialog1.Execute then
  begin
    FEngineParameter.EngineParameterCollect.Clear;
    if OpenDialog1.FileName <> '' then
    begin
      Caption := OpenDialog1.FileName;

      FEngineParameter.LoadFromFile(OpenDialog1.FileName,
                  ExtractFileName(OpenDialog1.FileName),EncryptCB.Checked);

      AddGridColumn4Parameter;

      with NextGrid1, FEngineParameter do
      begin
        for i := 0 to EngineParameterCollect.Count - 1 do
        begin
          AddRow();

//          Cells[1, i] := IntToStr(EngineParameterCollect.Items[i].LevelIndex);
//          Cells[2, i] := IntToStr(EngineParameterCollect.Items[i].NodeIndex);
//          Cells[3, i] := IntToStr(EngineParameterCollect.Items[i].AbsoluteIndex);
//          Cells[4, i] := IntToStr(EngineParameterCollect.Items[i].MaxValue);
//          Cells[5, i] := IntToStr(EngineParameterCollect.Items[i].Contact);
//          Cells[6, i] := EngineParameterCollect.Items[i].TagName;
//          Cells[7, i] := EngineParameterCollect.Items[i].Description;
//          Cells[8, i] := EngineParameterCollect.Items[i].Address;
//          Cells[9, i] := BoolToStr(EngineParameterCollect.Items[i].Alarm, true);
//          Cells[10, i] := EngineParameterCollect.Items[i].FCode;
//          Cells[11, i] := EngineParameterCollect.Items[i].FFUnit;
//          Cells[12, i] := SensorType2String(EngineParameterCollect.Items[i].SensorType);
//          Cells[13, i] := ParameterCatetory2String(EngineParameterCollect.Items[i].ParameterCatetory);
//          Cells[14, i] := ParameterType2String(EngineParameterCollect.Items[i].ParameterType);
//          Cells[15, i] := ParameterSource2String(EngineParameterCollect.Items[i].ParameterSource);
//          Cells[16, i] := EngineParameterCollect.Items[i].SharedName;
//          Cells[17, i] := IntToStr(EngineParameterCollect.Items[i].BlockNo);

          CellByName['LevelIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].LevelIndex);
          CellByName['NodeIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].NodeIndex);
          CellByName['AbsoluteIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].AbsoluteIndex);
          CellByName['MaxValue', i].AsString := IntToStr(EngineParameterCollect.Items[i].MaxValue);
          CellByName['Contact', i].AsString := IntToStr(EngineParameterCollect.Items[i].Contact);
          CellByName['TagName', i].AsString := EngineParameterCollect.Items[i].TagName;
          CellByName['Description', i].AsString := EngineParameterCollect.Items[i].Description;
          CellByName['Address', i].AsString := EngineParameterCollect.Items[i].Address;
          CellByName['Alarm', i].AsString := BoolToStr(EngineParameterCollect.Items[i].Alarm, true);
          CellByName['FCode', i].AsString := EngineParameterCollect.Items[i].FCode;
          CellByName['FFUnit', i].AsString := EngineParameterCollect.Items[i].FFUnit;
          CellByName['SensorType', i].AsString := g_SensorType.ToString(EngineParameterCollect.Items[i].SensorType);
          CellByName['ParameterCatetory', i].AsString := ParameterCatetory2String(EngineParameterCollect.Items[i].ParameterCatetory);
          CellByName['ParameterType', i].AsString := ParameterType2String(EngineParameterCollect.Items[i].ParameterType);
          CellByName['ParameterSource', i].AsString := ParameterSource2String(EngineParameterCollect.Items[i].ParameterSource);
          CellByName['SharedName', i].AsString := EngineParameterCollect.Items[i].SharedName;
          CellByName['BlockNo', i].AsString := IntToStr(EngineParameterCollect.Items[i].BlockNo);
          CellByName['BitIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].RadixPosition);
          CellByName['Value', i].AsString := EngineParameterCollect.Items[i].Value;
          CellByName['AlarmEnable', i].AsString := BoolToStr(EngineParameterCollect.Items[i].AlarmEnable, True);
        end;//for
      end;//with
    end;
  end;

end;

procedure TForm1.JSONFile_Open;
var
  i: integer;
begin
  OpenDialog1.Filter := 'Engine Parameter|*.param|All Files|*.*';
  OpenDialog1.FileName := '';

  if OpenDialog1.Execute then
  begin
    FEngineParameter.EngineParameterCollect.Clear;
    if OpenDialog1.FileName <> '' then
    begin

      FEngineParameter.LoadFromJSONFile(OpenDialog1.FileName,
                  ExtractFileName(OpenDialog1.FileName),EncryptCB.Checked);

      AddGridColumn4Parameter;
      AddParameter2Grid;
      Caption := OpenDialog1.FileName;
    end;
  end;

end;

procedure TForm1.JSONFile_S7_Open;
var
  i: integer;
begin
  OpenDialog1.Filter := 'S7 PLC Comm Conf|*.s7conf';
  OpenDialog1.FileName := '';

  if OpenDialog1.Execute then
  begin
    FEngineParameter.EngineParameterCollect.Clear;
    if OpenDialog1.FileName <> '' then
    begin
      Caption := OpenDialog1.FileName;

      FEngineParameter.LoadFromJSONFile(OpenDialog1.FileName,
                  ExtractFileName(OpenDialog1.FileName),EncryptCB.Checked);

      AddGridColumn4S7;

      with NextGrid1, FEngineParameter do
      begin
        for i := 0 to EngineParameterCollect.Count - 1 do
        begin
          AddRow();
//
//          Cells[1, i] := S7Area2String(TS7Area(EngineParameterCollect.Items[i].LevelIndex));
//          Cells[2, i] := IntToStr(EngineParameterCollect.Items[i].NodeIndex);
//          Cells[3, i] := S7DataType2String(TS7DataType(EngineParameterCollect.Items[i].AbsoluteIndex));
//          Cells[4, i] := IntToStr(EngineParameterCollect.Items[i].MaxValue);
//          Cells[5, i] := IntToStr(EngineParameterCollect.Items[i].Contact);
//          Cells[6, i] := EngineParameterCollect.Items[i].TagName;
//          Cells[7, i] := EngineParameterCollect.Items[i].Description;
//          Cells[8, i] := EngineParameterCollect.Items[i].Address;
//          Cells[9, i] := BoolToStr(EngineParameterCollect.Items[i].Alarm, true);
//          Cells[10, i] := EngineParameterCollect.Items[i].FCode;
//          Cells[11, i] := EngineParameterCollect.Items[i].FFUnit;
//          Cells[12, i] := SensorType2String(EngineParameterCollect.Items[i].SensorType);
//          Cells[13, i] := ParameterCatetory2String(EngineParameterCollect.Items[i].ParameterCatetory);
//          Cells[14, i] := ParameterType2String(EngineParameterCollect.Items[i].ParameterType);
//          Cells[15, i] := ParameterSource2String(EngineParameterCollect.Items[i].ParameterSource);
//          Cells[16, i] := EngineParameterCollect.Items[i].SharedName;
//          Cells[17, i] := IntToStr(EngineParameterCollect.Items[i].BlockNo);

          CellByName['LevelIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].LevelIndex);
          CellByName['NodeIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].NodeIndex);
          CellByName['AbsoluteIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].AbsoluteIndex);
          CellByName['MaxValue', i].AsString := IntToStr(EngineParameterCollect.Items[i].MaxValue);
          CellByName['Contact', i].AsString := IntToStr(EngineParameterCollect.Items[i].Contact);
          CellByName['TagName', i].AsString := EngineParameterCollect.Items[i].TagName;
          CellByName['Description', i].AsString := EngineParameterCollect.Items[i].Description;
          CellByName['Address', i].AsString := EngineParameterCollect.Items[i].Address;
          CellByName['Alarm', i].AsString := BoolToStr(EngineParameterCollect.Items[i].Alarm, true);
          CellByName['FCode', i].AsString := EngineParameterCollect.Items[i].FCode;
          CellByName['FFUnit', i].AsString := EngineParameterCollect.Items[i].FFUnit;
          CellByName['SensorType', i].AsString := g_SensorType.ToString(EngineParameterCollect.Items[i].SensorType);
          CellByName['ParameterCatetory', i].AsString := ParameterCatetory2String(EngineParameterCollect.Items[i].ParameterCatetory);
          CellByName['ParameterType', i].AsString := ParameterType2String(EngineParameterCollect.Items[i].ParameterType);
          CellByName['ParameterSource', i].AsString := ParameterSource2String(EngineParameterCollect.Items[i].ParameterSource);
          CellByName['SharedName', i].AsString := EngineParameterCollect.Items[i].SharedName;
          CellByName['BlockNo', i].AsString := IntToStr(EngineParameterCollect.Items[i].BlockNo);
          CellByName['BitIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].RadixPosition);
          CellByName['Value', i].AsString := EngineParameterCollect.Items[i].Value;
          CellByName['AlarmEnable', i].AsString := BoolToStr(EngineParameterCollect.Items[i].AlarmEnable, True);
        end;//for
      end;//with
    end;
  end;
end;

procedure TForm1.ToolButton17Click(Sender: TObject);
begin
  NextGrid1.MoveRow(NextGrid1.SelectedRow, NextGrid1.SelectedRow + 1);
  NextGrid1.SelectedRow := NextGrid1.SelectedRow + 1;
end;

procedure TForm1.ToolButton18Click(Sender: TObject);
var
  o, n: Integer;
begin
  o := NextGrid1.Columns[NextGrid1.SelectedColumn].Position;
  if o = 0 then Exit;
  n := o - 1;
  NextGrid1.Columns.ChangePosition(o, n);
end;

procedure TForm1.ToolButton19Click(Sender: TObject);
var
  o, n: Integer;
begin
  o := NextGrid1.Columns[NextGrid1.SelectedColumn].Position;
  n := o + 1;
  NextGrid1.Columns.ChangePosition(o, n);
end;

procedure TForm1.ToolButton21Click(Sender: TObject);
begin
  if RGModeSelect.ItemIndex = 0 then
    Data_2_TextFile
  else
    Param_2_TextFile;
end;

procedure TForm1.ToolButton22Click(Sender: TObject);
begin
  TextFile_Open;
end;

procedure TForm1.btnBoldClick(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle + [fsBold]
        else Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle - [fsBold];
end;

procedure TForm1.btnItalicClick(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle + [fsItalic]
        else Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle - [fsItalic];
end;

procedure TForm1.btnUnderlineClick(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle + [fsUnderline]
        else Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle - [fsUnderline];
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if RGModeSelect.ItemIndex = 0 then
    Data2XML
  else
  if RGModeSelect.ItemIndex = 1 then
    Data_2_ParamFile
  else
  if RGModeSelect.ItemIndex = 2 then
    Data_2_ParamFile2
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if RGModeSelect.ItemIndex = 0 then
    ConvertToBase(RGConvert.ItemIndex,4)
  else
    ConvertToBase(RGConvert.ItemIndex,8);

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if RGModeSelect.ItemIndex = 0 then
    Data_2_ParamFile_JSON(True)
  else
  if RGModeSelect.ItemIndex = 2 then
    Data_2_ParamFile_JSON(False)
  else
  if RGModeSelect.ItemIndex = 3 then
    Data_2_S7ParamFile_JSON
  else
  if RGModeSelect.ItemIndex = 4 then
    Data_2_Sqlite;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if MessageDlg('Address가 Hex값이어야 합니다.' + #13#10 + '"Dec <-> Hex Convert" 버튼을 눌렀습니까?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    CalcAbsoluteIndex;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  LDBSelectForm: TDBSelectForm;
  LStr: string;
begin
  if NextGrid1.RowCount = 0 then
  begin
    ShowMessage('Load Config file, First!');
    exit;
  end;

  ConnectDB;

  LDBSelectForm := TDBSelectForm.Create(self);
  try
    with LDBSelectForm do
    begin
      GetEngineTypeFromDB(ComboBox1);//Engine Type 가져오기

      if ShowModal = mrOK then
      begin
        if ComboBox1.Text <> '' then
        begin
          LStr := ComboBox1.Text;
          LStr := Copy(LStr, 0, Pos('-', LStr)-1);
          LStr := GetMeasureTableFromDB(LStr); //저장 data table 명 가져오기

          if LStr <> '' then
          begin
            GetTagNameFromDB(LStr);
          end;
        end;
      end;
    end;
  finally
    LDBSelectForm.Free;
  end;

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  RemoveDummy;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  AppendProjEngNo2TagName;
end;

procedure TForm1.ColorPickerEditor1Change(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
    begin
      if ColorPickerEditor1.SelectedColor = clNone
        then Cell[SelectedColumn, SelectedRow].Color := Color
        else Cell[SelectedColumn, SelectedRow].Color := ColorPickerEditor1.SelectedColor;
    end;
end;

//AType: 0 = Hexa to Decimal
//       1 = Decimal to Hexa
procedure TForm1.ConnectDB;
begin
  OraSession1.Username := 'TBACS';
  OraSession1.Password := 'TBACS';
  OraSession1.Server := '10.100.23.114:1521:TBACS';

  if not OraSession1.Connected then
    OraSession1.Connected := True;
end;

procedure TForm1.ConvertTagtoAddress1Click(Sender: TObject);
begin
  if RGModeSelect.ItemIndex = 0 then
    ConvertToBase(RGConvert.ItemIndex,1);
end;

procedure TForm1.ConvertToBase(AType, AAddrIndex: integer);
var
  li: integer;
  LStr1: string;
begin
  for li := 0 to NextGrid1.RowCount-1 do
  begin
    LStr1 := NextGrid1.Cells[AAddrIndex,li];
    if AType = 0 then //to Decimal
      NextGrid1.Cells[AAddrIndex,li] := Format('%.4d',[HexToInt(LStr1)])
    else  //to Hexa
      NextGrid1.Cells[AAddrIndex,li] := Format('%.4x',[StrToIntDef(LStr1,0)]);
  end;//for
end;

procedure TForm1.CopyRow1Click(Sender: TObject);
var
  LRow: TRow;
begin
  //LRow := NextGrid1.Row[NextGrid1.SelectedRow];
  //ClipBoard.Assign(LRow);
end;

procedure TForm1.TextFile_Open;
var
  li : integer; //loop count
  ls : integer; //

  LList : TStringList;
  LStr, LStr1 : String;
  LnxTextColumn: TnxTextColumn;
begin
  OpenDialog1.Filter := 'Modbus Map File|*.txt';
  OpenDialog1.FileName := '';

  if OpenDialog1.Execute then
  begin
    Try
      LList := TStringList.Create;
      LList.LoadFromFile(OpenDialog1.FileName);
      Caption := OpenDialog1.FileName;

      with NextGrid1 do
      begin
        ClearRows;
        Columns.Clear;

        Columns.Add(TnxIncrementColumn,'No.');
        for li := 0 to LList.Count -1 do
        begin
          LStr := LList.Strings[li];
          if not(li = 0) then addRow(1);

          for ls := 0 to 8 do
          begin
            if LStr = '' then Break;
            LStr1 := GetToken(LStr,';');

            if not(li = 0) then
            begin
              Cells[ls+1,li-1] := LStr1;
            end
            else
            begin
              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,LStr1));
              LnxTextColumn.Name := LStr1;
              LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
            end;
          end;//for

          if (li = 0) then
          begin
            LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'DataType'));
            LnxTextColumn.Name := 'DataType';
            LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
            //LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Unit'));
            //LnxTextColumn.Options := [coCanClick,coCanInput,coCanSort,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
          end;

        end;//for
      end;//with
    finally
      LList.Free;
    end;//finally
  end;//if
end;

procedure TForm1.Data2XML;
var
  li,ls,ll : integer;
  sFileName : string;
  LStr : String;
  LAlarm: string;
begin
  if RGModeSelect.ItemIndex <> 0 then
  begin
    Dialogs.messagedlg('Eneing Parameter를 저장할 수 없습니다.', mtConfirmation, [mbok], 0, mbok);
    exit;
  end;

  if SaveDialog2.Execute then
  begin
    sFileName := SaveDialog2.FileName;
    if NextGrid1.RowCount <= 0 then
    begin
      Dialogs.messagedlg('만들자료(그리드)가 존재하지 않습니다', mtConfirmation, [mbok], 0, mbok);
      Exit;
    end;

    try
      if FileExists(sFileName) then
      begin
        if MessageDlg('이전에 작업한자료가 있습니다. 덮어쓰시겠습니까? No를 누르면 추가됨.',
        mtConfirmation, [mbYes, mbNo], 0)=mrNo then
          ;
      end;

      MakeGridData2Parameter;

      FEngineParameter.SaveToFile(sFileName, ExtractFileName(sFileName), EncryptCB.Checked);
    finally
    end;
  end;
end;

procedure TForm1.Data_2_ParamFile;
var
  i,ls : integer;
  sFileName, LStr, LStr2 : string;
  F : TextFile;
begin
  SaveDialog1.Filter := 'Engine Parameter File|*.param';

  if SaveDialog1.Execute then
  begin
    sFileName := SaveDialog1.FileName;

    if NextGrid1.RowCount <= 0 then
    begin
      messagedlg('만들자료(그리드)가 존재하지 않습니다', mtConfirmation, [mbok], 0);
      Exit;
    end;

    try
      if NextGrid1.RowCount > 0 then
        FEngineParameter.EngineParameterCollect.Clear;

      if FileExists(sFileName) then
      begin

        if MessageDlg('이전에 작업한자료가 있습니다. 덮어쓰시겠습니까? No를 누르면 기존자료에 추가됨.',
        mtConfirmation, [mbYes, mbNo], 0)=mrNo then
          FEngineParameter.LoadFromFile(sFileName, ExtractFileName(sFileName),EncryptCB.Checked)
        //Append(F)
        else
        begin
          AssignFile(F, sFileName);
          Rewrite(F);
          CloseFile(F);
        end;
      end;

      with NextGrid1 do
      begin
        for i := 0 to RowCount-1 do
        begin
          with FEngineParameter.EngineParameterCollect.Add do
          begin
            LStr2 := CellByName['FCode', i].AsString;
            if LStr2 = '' then
            begin
              LStr := UpperCase(CellByName['Alarm', i].AsString);
              if LStr = 'FALSE' then
              begin
                Alarm := False;
                fcode := '1';
              end
              else if LStr = 'TRUE4' then
              begin
                Alarm := True;
                fcode := '4';
              end
              else if LStr = 'TRUE' then
              begin
                Alarm := True;
                fcode := '3';
              end
              else if LStr = 'FALSE3' then
              begin
                Alarm := False;
                fcode := '3';
              end;
            end
            else
              fcode := LStr2;

            LevelIndex := CellByName['LevelIndex', i].AsInteger;
            NodeIndex := CellByName['NodeIndex', i].AsInteger;
            AbsoluteIndex := CellByName['AbsoluteIndex', i].AsInteger;
            MaxValue := CellByName['MaxValue', i].AsInteger;
            Contact := CellByName['Contact', i].AsInteger;
            SharedName := CellByName['SharedName', i].AsString;
            TagName := CellByName['TagName', i].AsString;
            Description := CellByName['Description', i].AsString;
            Address := CellByName['Address', i].AsString;
            FFUnit := CellByName['FFUnit', i].AsString;
            SensorType := g_SensorType.ToType(CellByName['SensorType', i].AsString);
            ParameterCatetory :=String2ParameterCatetory(CellByName['ParameterCatetory', i].AsString);
            ParameterType :=String2ParameterType(CellByName['ParameterType', i].AsString);
            ParameterSource := String2ParameterSource(CellByName['ParameterSource', i].AsString);
          end;//with
        end;//for
      end;//with

    finally
      FEngineParameter.SaveToFile(sFileName, ExtractFileName(sFileName),EncryptCB.Checked);
      //CloseFile(F);
    end;
  end;
end;

procedure TForm1.Data_2_ParamFile2;
var
  i,ls : integer;
  sFileName, LStr, LStr2 : string;
  F : TextFile;
begin
{  SaveDialog1.Filter := 'Engine Parameter File|*.param';

  if SaveDialog1.Execute then
  begin
    sFileName := SaveDialog1.FileName;

    if NextGrid1.RowCount <= 0 then
    begin
      messagedlg('만들자료(그리드)가 존재하지 않습니다', mtConfirmation, [mbok], 0);
      Exit;
    end;

    try
      if NextGrid1.RowCount > 0 then
        FEngineParameter2.EngineParameterCollect.Clear;

      if FileExists(sFileName) then
      begin

        if MessageDlg('이전에 작업한자료가 있습니다. 덮어쓰시겠습니까? No를 누르면 기존자료에 추가됨.',
        mtConfirmation, [mbYes, mbNo], 0)=mrNo then
          FEngineParameter2.LoadFromFile(sFileName, ExtractFileName(sFileName),EncryptCB.Checked)
        //Append(F)
        else
        begin
          AssignFile(F, sFileName);
          Rewrite(F);
          CloseFile(F);
        end;
      end;

      with NextGrid1 do
      begin
        for i := 0 to RowCount-1 do
        begin
          with FEngineParameter2.EngineParameterCollect.Add do
          begin
            LStr2 := CellByName['FCode', i].AsString;
            if LStr2 = '' then
            begin
              LStr := UpperCase(CellByName['Alarm', i].AsString);
              if LStr = 'FALSE' then
              begin
                Alarm := False;
                fcode := '1';
              end
              else if LStr = 'TRUE4' then
              begin
                Alarm := True;
                fcode := '4';
              end
              else if LStr = 'TRUE' then
              begin
                Alarm := True;
                fcode := '3';
              end
              else if LStr = 'FALSE3' then
              begin
                Alarm := False;
                fcode := '3';
              end;
            end
            else
              fcode := LStr2;

            LevelIndex := CellByName['LevelIndex', i].AsInteger;
            NodeIndex := CellByName['NodeIndex', i].AsInteger;
            AbsoluteIndex := CellByName['AbsoluteIndex', i].AsInteger;
            MaxValue := CellByName['MaxValue', i].AsInteger;
            Contact := CellByName['Contact', i].AsInteger;
            SharedName := CellByName['SharedName', i].AsString;
            TagName := CellByName['TagName', i].AsString;
            Description := CellByName['Description', i].AsString;
            Address := CellByName['Address', i].AsString;
            FFUnit := CellByName['FFUnit', i].AsString;
            SensorType := String2SensorType(CellByName['SensorType', i].AsString);
            ParameterCatetory :=String2ParameterCatetory(CellByName['ParameterCatetory', i].AsString);
            ParameterType :=String2ParameterType(CellByName['ParameterType', i].AsString);
            ParameterSource := String2ParameterSource(CellByName['ParameterSource', i].AsString);
          end;//with
        end;//for
      end;//with

    finally
      FEngineParameter2.SaveToFile(sFileName, ExtractFileName(sFileName),EncryptCB.Checked);
      //CloseFile(F);
    end;
  end;   }
end;

procedure TForm1.Data_2_ParamFile_JSON(AFromGridData: Boolean);
var
  sFileName: string;
begin
  if AFromGridData then
    MakeGridData2Parameter
  else
    MakeGridData2Parameter2;

  if SaveDialog1.Execute then
  begin
    sFileName := SaveDialog1.FileName;

    FEngineParameter.SaveToJSONFile(sFileName,
                                ExtractFileName(sFileName),EncryptCB.Checked);
  end;
end;

procedure TForm1.Data_2_S7ParamFile_JSON;
begin
  FEngineParameter.EngineParameterCollect.Clear;
  Data_2_ParamFile_JSON(False);
end;

procedure TForm1.Data_2_Sqlite;
var
  LDoc: variant;
  i: integer;
begin
  FEngineParameter.EngineParameterCollect.Clear;
  MakeGridData2Parameter2(True);
  TDocVariant.New(LDoc);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    LoadRecordPropertyToVariant(FEngineParameter.EngineParameterCollect.Items[i], LDoc);
    AddOrUpdateEngParamFromVariant(LDoc, True)
  end;
end;

procedure TForm1.Data_2_TextFile;
var
  li,ls : integer;
  sFileName : string;
  F : TextFile;
  LStr : String;
begin
  SaveDialog1.Filter := 'Modbus Map File|*.txt';

  if SaveDialog1.Execute then
  begin
    sFileName := SaveDialog1.FileName;
  //  nRow := NextGrid1.RowCount;

    if NextGrid1.RowCount <= 0 then
    begin
      messagedlg('만들자료(그리드)가 존재하지 않습니다', mtConfirmation, [mbok], 0);
      Exit;
    end;

    AssignFile(F, sFileName);
    try
      if FileExists(sFileName) then
      begin
        if MessageDlg('이전에 작업한자료가 있습니다. 덮어쓰시겠습니까? No를 누르면 추가됨.',
        mtConfirmation, [mbYes, mbNo], 0)=mrNo then
        Append(F)
      else
        Rewrite(F);
      end;

      with NextGrid1 do
      begin
        for li := 1 to Columns.count - 2 do
        begin
          if not (li = Columns.Count -2) then
            LStr := LStr + Columns[li].Header.caption  + ';'
          else
            LStr := LStr + Columns[li].Header.caption;
        end;
        Rewrite(F);
        Writeln(F,LStr);

        for li := 0 to RowCount-1 do
        begin
          LStr := '';
          for ls := 1 to Columns.Count - 2 do
          begin
            if not (ls = Columns.Count -2) then
              LStr := LStr + Cells[ls,li] + ';'
            else
              LStr := LStr + Cells[ls,li];
          end;//for
          Writeln(F,LStr);
        end;//for
      end;
    finally
      CloseFile(F);
    end;
  end;
end;

procedure TForm1.DeleteEngineParamterFromGrid(AIndex: integer);
var
  i,j: integer;
begin
  //TMatrix Item Index를 가져옴
  i := FEngineParameter.EngineParameterCollect.Items[AIndex].MatrixItemIndex;

  if i <> -1 then
  begin
    case FEngineParameter.EngineParameterCollect.Items[AIndex].ParameterType of
      ptMatrix1,ptMatrix2,ptMatrix3,ptMatrix1f,ptMatrix2f,ptMatrix3f: begin
        if i <= (FEngineParameter.MatrixCollect.Count - 1) then
        begin
          FEngineParameter.MatrixCollect.Delete(i);

          for j := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
          begin
            case FEngineParameter.EngineParameterCollect.Items[j].ParameterType of
              ptMatrix1,ptMatrix2,ptMatrix3,ptMatrix1f,ptMatrix2f,ptMatrix3f:;
            else
              continue;
            end;

            if FEngineParameter.EngineParameterCollect.Items[j].MatrixItemIndex > i then
            begin
              FEngineParameter.EngineParameterCollect.Items[j].MatrixItemIndex :=
                FEngineParameter.EngineParameterCollect.Items[j].MatrixItemIndex - 1;
              NextGrid1.CellByName['NodeIndex', j].AsInteger :=
                FEngineParameter.EngineParameterCollect.Items[j].MatrixItemIndex;
            end;
          end;
        end;
      end
    else
      ;
    end;
  end;

  NextGrid1.DeleteRow(AIndex);
  FEngineParameter.EngineParameterCollect.Delete(AIndex);
end;

procedure TForm1.DeleteItems;
var
  i: integer;
begin
  if messagedlg('Are you sure deleting items(s).', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    for i := NextGrid1.RowCount - 1 Downto 0 do
      if NextGrid1.Row[i].Selected then
        DeleteEngineParamterFromGrid(i);
  end;
end;

procedure TForm1.EditMatrixData1Click(Sender: TObject);
begin
  SetMatrix;
end;

procedure TForm1.FileAppend1Click(Sender: TObject);
begin
  OpenDialog1.Filter := 'Engine Parameter|*.param';
  OpenDialog1.FileName := '';

  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      AppendParameterFromFile(OpenDialog1.FileName);
      NextGrid1.ClearRows;
      AddParameter2Grid;
    end;
  end;
end;

procedure TForm1.FileOpenFromExcel1Click(Sender: TObject);
begin
  OpenDataFromExcel;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GlobalFree(MemberHandle);
  ChangeClipboardChain(Handle, NextInChain);
  ClipStrList.Free;

  FEngineParameter.Free;
  //FEngineParameter2.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FEngineParameter := TEngineParameter.Create(Self);

  NextInChain:=SetClipboardViewer(Handle);
  OurFormat:=RegisterClipboardFormat('CF_TClipBrdGridData');
  ClipStrList := TStringList.Create;

  //FEngineParameter2 := TEngineParameter2.Create(Self);
end;

procedure TForm1.GetEngineTypeFromDB(ACombo: TComboBox);
var
  i: integer;
  LType: string;
begin
  with Oraquery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HimsenInfo');
    Open;

    ACombo.Items.Clear;

    if RecordCount > 0 then
    begin
      for i := 0 to RecordCount - 1 do
      begin
        LType := FieldByName('ProjNo').AsString + '-' + FieldByName('EngType').AsString;
        ACombo.Items.Add(LType);
        Next;
      end;
    end;
  end;
end;

//AEngType: 공사번호(ex: YE0589)
function TForm1.GetMeasureTableFromDB(AEngType: string): string;
var
  i: integer;
  LType: string;
begin
  Result := '';

  with Oraquery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_SS_TABLE_INFO where PROJNO = :EngType');
    ParamByName('EngType').AsString := AEngType;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('TABLENAME').AsString;
    end;
  end;
end;

function TForm1.GetParamType(AType: string): TParameterType;
begin
  if AType = 'A' then
    Result := ptAnalog
  else if AType = 'D' then
    Result := ptDigital
  else if AType = 'B' then
    Result := ptBool
  else if AType = 'M2' then
    Result := ptMatrix2
  else if AType = 'M3' then
    Result := ptMatrix3
  else
    Result := ptDefault;
end;

function TForm1.GetSelectedRow2List: TStringList;
var
  i,j: integer;
  LStr: string;
begin
  //Result := TStringList.Create;
  Result := ClipStrList;

  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    if NextGrid1.Row[i].Selected then
    begin
      for j := 0 to NextGrid1.Columns.Count - 1 do
      begin
        LStr := LStr + NextGrid1.Cell[j,i].AsString + ';';
      end;

      Result.Add(LStr + sLineBreak);
      LStr := '';
    end;
  end;
end;

function TForm1.GetSelectedRow2Text: string;
var
  i,j: integer;
begin
  Result := '';

  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    if NextGrid1.Row[i].Selected then
    begin
      for j := 0 to NextGrid1.Columns.Count - 1 do
      begin
        Result := Result + NextGrid1.Cell[j,i].AsString + ';';
      end;
      Result := Result + sLineBreak;
    end;
  end;
end;

procedure TForm1.GetTagNameFromDB(ATableName: string);
var
  i: integer;
begin
  if OraSession1.Connected then
  begin
    OraQuery1.Close;
    OraQuery1.SQL.Clear;
    OraQuery1.SQL.Text := 'select * from HIMSEN_SS_META where TABLE_NAME = :tablename order by COLUMN_ID';
    OraQuery1.ParamByName('tablename').AsString := ATableName;
    OraQuery1.Open;

    i := 0;

    while not OraQuery1.Eof do
    begin
      if UpperCase(NextGrid1.Cells[6,i]) <> 'DUMMY' then
        NextGrid1.Cells[6,i] := OraQuery1.FieldByName('TAGNAME').AsString;
      inc(i);
      OraQuery1.Next;
    end;
  end;
end;

function TForm1.GetTextHeader: string;
begin
  Result := '';

  Result := Result + 'TAG_NAME;';
  Result := Result + 'DESCRIPT;';
  Result := Result + 'SID;';
  Result := Result + 'ADDR;';
  Result := Result + 'CNT;';
  Result := Result + 'ALARM;';
  Result := Result + 'MAXVAL;';
  Result := Result + 'CONTACT;';
end;

function TForm1.MakeFormulaFromSelected(AOperator: string): string;
var
  li: integer;
  LFormula: string;
  LItem: TEngineParameterItem;
begin
  Result := '';

  with NextGrid1 do
  begin
    for li := 0 to RowCount - 1 do
    begin
      if not Selected[li] then
        continue;

      if li > FEngineParameter.EngineParameterCollect.Count - 1 then
        LItem := FEngineParameter.EngineParameterCollect.Add
      else
        LItem := FEngineParameter.EngineParameterCollect.Items[li];

      with LItem do
      begin
        //if (String2SensorType(Cell[12,li].AsString) = stCalculated) and
        //  (String2ParameterSource(Cell[15,li].AsString) = psManualInput)then
        //begin
          if Result = '' then
            Result := Cell[6,li].AsString//Tagname
          else
            Result := Result + AOperator + Cell[6,li].AsString;
        //end;
      end;//with
    end;
  end;//with
end;

procedure TForm1.MakeGridData2Parameter;
var
  li,ls,ll : integer;
  sFileName : string;
  LStr : String;
  LAlarm: string;
begin
  with NextGrid1 do
  begin
    FEngineParameter.EngineParameterCollect.Clear;
    ls := -1;
    ll := 0;

    for li := 0 to RowCount-1 do
    begin
      with FEngineParameter.EngineParameterCollect.Add do
      begin
        if ls <> CellByName['CNT', li].AsInteger then
        begin
          ls := CellByName['CNT', li].AsInteger;
          ll := -1;
        end;

        inc(ll);

        BlockNo := ls;
        AbsoluteIndex := ll; //TEventDataxxx 의 InpDataBuf[]의 Index
        TagName := CellByName['TAG_NAME', li].AsString;//Cells[1,li];
        Description := CellByName['DESCRIPT', li].AsString;//Cells[2,li];
        Address := CellByName['ADDR', li].AsString;//Cells[4,li];
        ParameterType := GetParamType(CellByName['DataType', li].AsString);//Cells[9,li]);
        //FFUnit := Cells[10,li];
        LAlarm := CellByName['ALARM', li].AsString;//Cells[6,li];

        if LAlarm = 'FALSE' then
        begin
          Alarm := False;
          fcode := '1';
        end
        else if LAlarm = 'TRUE4' then
        begin
          Alarm := True;
          fcode := '4';
        end
        else if LAlarm = 'TRUE' then
        begin
          Alarm := True;
          fcode := '3';
        end
        else if LAlarm = 'FALSE3' then
        begin
          Alarm := False;
          fcode := '3';
        end;

        if fcode = '4' then
          MaxValue_real := CellByName['MAXVAL', li].AsFloat
        else
          MaxValue := CellByName['MAXVAL', li].AsInteger;

        if Pos('PRESS', TagName) > 0 then
          SensorType := stmA
        else if (Pos('TEMP', TagName) > 0) and (MaxValue <= 200) then
          SensorType := stRTD
        else if (System.Pos('RPM', TagName) > 0) and (System.Pos('PICKUP', UpperCase(Description)) > 0) then
        begin
          SensorType := stPickup;
        end
        else if ((Pos('EXH', TagName) > 0) or (Pos('MAINBER', TagName) > 0))
                                         and (MaxValue >= 600) then
          SensorType := stTC
        else if ((Pos('DI_', TagName) > 0) and (LAlarm = 'FALSE')) then
          SensorType := stDI
        else if ((Pos('DO_', TagName) > 0) and (LAlarm = 'FALSE')) then
          SensorType := stDO;

        if (Pos('LUB', UpperCase(Description)) > 0) and (LAlarm = 'TRUE') then
          ParameterCatetory := pcLOSystem
        else if (Pos('WATER', UpperCase(Description)) > 0) and (LAlarm = 'TRUE') then
          ParameterCatetory := pcCWSystem
        else if (Pos('EXH', UpperCase(Description)) > 0) and (LAlarm = 'TRUE') then
          ParameterCatetory := pcExhSystem
        else if ((Pos('FUEL OIL', UpperCase(Description)) > 0) or
           (Pos('F.O', UpperCase(Description)) > 0))  and (LAlarm = 'TRUE') then
          ParameterCatetory := pcFOSystem
        else if (Pos('AIR', UpperCase(Description)) > 0) and (LAlarm = 'TRUE') then
          ParameterCatetory := pcCAirSystem
        else if (Pos('DI_READYTOSTART', TagName) > 0) or
                (Pos('DI_TURNGEARENGAGED', TagName) > 0) or
                (Pos('DI_PRELUBPRESSLOW', TagName) > 0) or
                (Pos('DI_COMMONSHUTDOWN', TagName) > 0) or
                (Pos('DI_ENGINERUNNING', TagName) > 0) then
          ParameterCatetory := pcReadyToStart
        else if (Pos('DI_TRIPCIRCUITFAIL', TagName) > 0) or
                (Pos('DI_STARTFAIL', TagName) > 0) or
                (Pos('DI_STOPFAIL', TagName) > 0) or
                (Pos('DI_LOCAL', TagName) > 0) or
                (Pos('DI_REMOTE', TagName) > 0) then
          ParameterCatetory := pcEngineStatus
        else if (Pos('SHUTDOWN', TagName) > 0) then
          ParameterCatetory := pcEngineShutdown
        else if(Pos('MAINBERG', TagName) > 0) then
          ParameterCatetory := pcMainBearing
        else if (Pos('RPM', TagName) > 0) then
          ParameterCatetory := pcSpeed
        else
          ParameterCatetory := pcEtc;
      end;//with
    end;//for
  end;//with
end;

procedure TForm1.MakeGridData2Parameter2(AIsSqlite: Boolean);
var
  li,ls,ll : integer;
  sFileName : string;
  LStr : String;
  LAlarm: string;
  LItem: TEngineParameterItem;
begin
  with NextGrid1 do
  begin
    for li := 0 to RowCount-1 do
    begin
      if li > FEngineParameter.EngineParameterCollect.Count - 1 then
        LItem := FEngineParameter.EngineParameterCollect.Add
      else
        LItem := FEngineParameter.EngineParameterCollect.Items[li];

      with LItem do
      begin
        if RGModeSelect.ItemIndex = 3 then
        begin
          LevelIndex := Ord(String2S7Area(CellByName['LevelIndex',li].AsString)); //Area
          AbsoluteIndex := Ord(String2S7DataType(CellByName['AbsoluteIndex',li].AsString));//Data Type
        end
        else
        begin
          LevelIndex := CellByName['LevelIndex',li].AsInteger;
          AbsoluteIndex := CellByName['AbsoluteIndex',li].AsInteger;
        end;

        NodeIndex := CellByName['NodeIndex',li].AsInteger;
        MaxValue := CellByName['MaxValue',li].AsInteger;
        Contact := CellByName['Contact',li].AsInteger;
        Description := CellByName['Description',li].AsString;
        Address := CellByName['Address',li].AsString;
        Alarm := CellByName['Alarm',li].AsBoolean;
        fcode := CellByName['FCode',li].AsString;
        FFUnit := CellByName['FFUnit',li].AsString;
        SensorType := g_SensorType.ToType(CellByName['SensorType',li].AsString);
        //압력은 소수점 두자리 표시
        if SensorType = stmA then
          RadixPosition := 2;

        ParameterCatetory := String2ParameterCatetory(CellByName['ParameterCatetory',li].AsString);
        ParameterType := String2ParameterType(CellByName['ParameterType',li].AsString);
        ParameterSource := String2ParameterSource(CellByName['ParameterSource',li].AsString);

        if (TagName = '') and
          (SensorType = stCalculated) and
          (ParameterSource = psManualInput)then
          TagName := 'V_' + formatDateTime('yyyymmddhhnnss',now)
        else
          TagName := CellByName['TagName',li].AsString;

        SharedName := CellByName['SharedName',li].AsString;

        if Description = '' then
          Description := SharedName;

        BlockNo := StrToIntDef(CellByName['BlockNo',li].AsString,0);
        RadixPosition := StrToIntDef(CellByName['BitIndex',li].AsString,0);
        Value := CellByName['Value',li].AsString;
        LItem.AlarmEnable := StrToBool(CellByName['AlarmEnable',li].AsString);
        ProjNo := CellByName['ProjNo',li].AsString;
        EngNo := CellByName['EngNo',li].AsString;

        if AIsSqlite then
        begin
          ParameterCatetory4AVAT2 := g_ParameterCatetory4AVAT2.ToType(CellsByName['ParameterCatetory4AVAT2', li]);
          DFCommissioningItem := g_DFCommissioningItem.toType(CellsByName['DFCommissioningItem', li]);
        end;

        if LItem.IsMatrixData then
        begin
          MatrixItemIndex := CellByName['NodeIndex',li].AsInteger;
          XAxisSize := CellByName['MaxValue',li].AsInteger;
          YAxisSize := CellByName['Contact',li].AsInteger;
          ZAxisSize := CellByName['LevelIndex',li].AsInteger; //Area
        end;
      end;//with
    end;//for
  end;//with
end;

procedure TForm1.N11Click(Sender: TObject);
var
  r,c,i,v: integer;
begin
  c := NextGrid1.SelectedColumn;
  r := NextGrid1.SelectedRow;

  v := NextGrid1.Cell[c,r].AsInteger;
  for i := r + 1 to NextGrid1.RowCount - 1 do
  begin
    Inc(v);
    NextGrid1.Cell[c,i].AsString := IntToStr(v);
  end;
end;

procedure TForm1.N2Click(Sender: TObject);
var
  r,c: integer;
begin
  c := NextGrid1.SelectedColumn;

  for r := 1 to NextGrid1.RowCount - 1 do
  begin
    NextGrid1.Cell[c,r].AsString := NextGrid1.Cell[c,0].AsString;
  end;
end;

procedure TForm1.N3Click(Sender: TObject);
var
  r,c,i: integer;
begin
  c := NextGrid1.SelectedColumn;
  r := NextGrid1.SelectedRow;

  for i := r + 1 to NextGrid1.RowCount - 1 do
  begin
    NextGrid1.Cell[c,i].AsString := NextGrid1.Cell[c,r].AsString;
  end;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  FormulaEdit.Text := MakeFormulaFromSelected(N7.Caption);
end;

procedure TForm1.N8Click(Sender: TObject);
begin
  FormulaEdit.Text := MakeFormulaFromSelected(N8.Caption);
end;

procedure TForm1.N9Click(Sender: TObject);
begin
  FormulaEdit.Text := MakeFormulaFromSelected(N9.Caption);
end;

procedure TForm1.NextGrid1CellDblClick(Sender: TObject; ACol, ARow: Integer);
var
  LRect: TRect;
begin
  LRect := NextGrid1.GetHeaderRect;

  if PtInRect(LRect, FMousePoint) then
    exit;

  ShowProperties;
end;

procedure TForm1.NextGrid1EditEnter(Sender: TObject);
begin
  FNextGridEditMode := True;
end;

procedure TForm1.NextGrid1EditExit(Sender: TObject);
begin
  FNextGridEditMode := False;
end;

procedure TForm1.NextGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LStr: string;
  MemberPointer  : Pointer;//^TClipBrdGridData;
  LStrList: TStringList;
  LStream: TMemoryStream;
  i: integer;
begin
  if ssCtrl in Shift then
  begin
    if UpCase(Char(Key)) = 'C' then //'c'
    begin
      if FNextGridEditMode then
        exit;

      LStrList := GetSelectedRow2List;
      LStream := TMemoryStream.Create;
      try
        LStrList.SaveToStream(LStream);

        if OpenClipboard(Handle) then
        begin
          EmptyClipboard;
          MemberHandle := GlobalAlloc(GMEM_DDESHARE or GMEM_MOVEABLE, LStream.Size);
          Win32Check(MemberHandle <> 0);

          MemberPointer := Windows.GlobalLock(MemberHandle);
          try
            Win32Check(MemberPointer <> nil);

            Move(LStream.Memory^, MemberPointer^, LStream.size);
            //Clipboard.SetAsHandle(OurFormat, MemberHandle);
          finally
            Windows.GlobalUnLock(MemberHandle);
            SetClipboardData(OurFormat,MemberHandle);
            CloseClipboard();
          end;
        end;
      finally
        LStream.Free;
      end;

      {FClipBdStrData.FGridData := GetSelectedRow2Text;

      if OpenClipboard(Handle) then
      begin
        EmptyClipboard;
        MemberHandle := GlobalAlloc(GMEM_DDESHARE or GMEM_MOVEABLE, SizeOf(FClipBdStrData));
        Win32Check(MemberHandle <> 0);

        MemberPointer := GlobalLock(MemberHandle);
        Win32Check(MemberPointer <> nil);

        CopyMemory(MemberPointer, @FClipBdStrData, SizeOf(FClipBdStrData));

        GlobalUnLock(MemberHandle);
        SetClipboardData(OurFormat,MemberHandle);
        CloseClipboard();
      end;

      //Clipboard.AsText := LStr;
    }
    end
    else
    if UpCase(Char(Key)) = 'V' then
    begin
      for i := 0 to ClipStrList.Count - 1 do
        AddGridRowFromClipBrd(ClipStrList.Strings[i]);

      {if FClipBdStrData.FGridData <> '' then
      begin
        AddGridRowFromClipBrd(FClipBdStrData.FGridData);
      end;
      }
    end;
  end;
end;

procedure TForm1.NextGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  FMousePoint.X := X;
  FMousePoint.Y := Y;
end;

procedure TForm1.OpenDataFromExcel;
const
  ldec = 64;//Ascii Code
var
  XL, oWB, oSheet, oRng : variant;
  xlRowCount, xlColCount,

  LRow,i,j,s : Integer;
  lColumn, range : string;
begin
  OpenDialog1.Filter := 'Excel File|*.xls|ExcelX File|*.xlsx|All Files|*.*';

  if OpenDialog1.Execute then
  begin

//    XLApp               := CreateOleObject('Excel.Application');      //# 엑셀프로그램 존재체크
//    XLApp.DisplayAlerts := False;                                     //# 메시지 표시 않기.
//    XLApp.Visible       := False;                                     //# 엑셀프로그램 숨김
//    XLBook              := XLApp.WorkBooks.Open(szFileName);          //# 엑셀파일 오픈
//    XLSheet             := XLBook.Sheets['Sheet1'];                   //# 엑셀시트 오픈
//    XLRows              := XLApp.ActiveSheet.UsedRange.Rows.Count;    //# 총 Rows 수 구함


    XL := CreateOleObject('Excel.Application');
    XL.DisplayAlerts := False;
    XL.visible := False;
    try
      oWB := XL.WorkBooks.Add(OpenDialog1.FileName);
      oSheet := oWB.ActiveSheet;

      xlRowCount := oSheet.UsedRange.Rows.Count;
      xlColCount := oSheet.UsedRange.Columns.Count;

      with NextGrid1 do
      begin
        BeginUpdate;
        try
          AddGridColumn4Parameter;

          for i := 2 to xlRowCount do
          begin
            LRow := AddRow;
            for j := 1 to xlColCount do
            begin
              lColumn := Chr(ldec+j);
              range := lColumn + IntToStr(i);
              XL.Range[range].Select;
//              XL.ActiveCell.FormulaR1C1 := Columns.Item[i].Header.Caption;
              Cells[j,LRow] := XL.ActiveCell.FormulaR1C1;
              if Cells[j,LRow] = '' then
                Cells[j,LRow] := '0';
            end;
          end;
        finally
          oWB.Close;
          XL.Quit;
          EndUpdate;
        end;
      end;
    except
      MessageDlg('Excel이 설치되어 있지 않습니다.'+#13+
        '이 기능을 이용하시려면 반드시 MS오피스 엑셀이 설치되어 있어야 합니다.- ' ,
        MtWarning, [mbok], 0);
      XL.quit;
      XL := Unassigned;
    end;
  end;
end;

procedure TForm1.Param_2_TextFile;
var
  li,ls : integer;
  sFileName : string;
  F : TextFile;
  LStr : String;
begin
  SaveDialog1.Filter := 'Modbus Map File|*.txt';

  if SaveDialog1.Execute then
  begin
    sFileName := SaveDialog1.FileName;

    if NextGrid1.RowCount <= 0 then
    begin
      messagedlg('만들자료(그리드)가 존재하지 않습니다', mtConfirmation, [mbok], 0);
      Exit;
    end;

    AssignFile(F, sFileName);
    try
      if FileExists(sFileName) then
      begin
        if MessageDlg('이전에 작업한자료가 있습니다. 덮어쓰시겠습니까? No를 누르면 추가됨.',
        mtConfirmation, [mbYes, mbNo], 0)=mrNo then
        Append(F)
      else
        Rewrite(F);
      end;

      with NextGrid1 do
      begin

        LStr := GetTextHeader;

        Rewrite(F);
        Writeln(F,LStr);

        for li := 0 to RowCount-1 do
        begin
          LStr := '';
          // 6,7,sid,8,17,9,4,5
          ls := 6;
          LStr := LStr + Cells[ls,li] + ';';

          ls := 7;
          LStr := LStr + Cells[ls,li] + ';';

          LStr := LStr + IntToStr(li) + ';';

          ls := 8;
          LStr := LStr + Cells[ls,li] + ';' ;

          ls := 17;
          LStr := LStr + Cells[ls,li] + ';';

          ls := 9;
          LStr := LStr + Cells[ls,li] + ';';

          if Cells[15,li] = 'S7 Siemens PLC' then
            ls := 5
          else
            ls := 4;

          LStr := LStr + Cells[ls,li] + ';';

          if Cells[15,li] = 'S7 Siemens PLC' then
          begin
            LStr := LStr + '0;';
          end
          else
          begin
            ls := 5;
            LStr := LStr + Cells[ls,li] + ';';
          end;

          Writeln(F,LStr);
        end;//for
      end;
    finally
      CloseFile(F);
    end;
  end;
end;

procedure TForm1.RemoveDummy;
var
  i: integer;
begin
  NextGrid1.BeginUpdate;

  try
    for i := NextGrid1.RowCount - 1 downto 0 do
    begin
      if UpperCase(NextGrid1.CellByName['TagName',i].AsString) = 'DUMMY' then
        NextGrid1.DeleteRow(i);
    end;
  finally
    NextGrid1.EndUpdate;
  end;
end;

procedure TForm1.SaveToCSV1Click(Sender: TObject);
begin
  if SaveDialog2.Execute then
  begin
    if NextGrid1.RowCount <= 0 then
    begin
      Dialogs.messagedlg('만들자료(그리드)가 존재하지 않습니다', mtConfirmation, [mbok], 0, mbok);
      Exit;
    end;

    try
      if FileExists(SaveDialog2.FileName) then
      begin
        if MessageDlg('이전에 작업한자료가 있습니다. 덮어쓰시겠습니까? No를 누르면 추가됨.',
        mtConfirmation, [mbYes, mbNo], 0)=mrNo then
          ;
      end;

      NextGrid1.SaveToTextFile(SaveDialog2.FileName, ',', #13);
    finally
    end;
  end;
end;

procedure TForm1.SetAlarmDisable1Click(Sender: TObject);
begin
  SetAlarmEnable(False);
end;

procedure TForm1.SetAlarmEnable(AEnable: Boolean);
var
  i: integer;
begin
  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    if NextGrid1.Row[i].Selected then
      NextGrid1.Cell[20,i].AsString := BoolToStr(AEnable, True);
  end;
end;

procedure TForm1.SetAlarmEnable1Click(Sender: TObject);
begin
  SetAlarmEnable(True);
end;

procedure TForm1.SetConfigEngParamItemData(AIndex: Integer);
var
  ConfigData: TEngParamItemConfigForm;
  LEngineParameterItem: TEngineParameterItem;
  Li: integer;
begin
  ConfigData := nil;
  ConfigData := TEngParamItemConfigForm.Create(Self);
  LEngineParameterItem := FEngineParameter.EngineParameterCollect.Items[AIndex];

  try
    with ConfigData do
    begin
      LoadConfigEngParamItem2Form(LEngineParameterItem);
      if ShowModal = mrOK then
      begin
        Li := LoadConfigForm2EngParamItem(FEngineParameter, LEngineParameterItem);
        if Li <> -1 then
        begin
          AddParamItem2Grid(AIndex, FEngineParameter.EngineParameterCollect.Items[Li]);

          if FEngineParameter.EngineParameterCollect.Items[Li].ParameterSource = psManualInput then
            NextGrid1.CellByName['Value', AIndex].AsString := FEngineParameter.EngineParameterCollect.Items[Li].Value;

          if FEngineParameter.EngineParameterCollect.Items[Li].SensorType = stCalculated then
            NextGrid1.CellByName['Description', AIndex].AsString := FEngineParameter.EngineParameterCollect.Items[Li].Description;
        end;

      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

procedure TForm1.SetContact(AContact: integer);
var
  i: integer;
begin
  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    if NextGrid1.Row[i].Selected then
      NextGrid1.Cell[5,i].AsString := IntToStr(AContact);
  end;
end;

procedure TForm1.SetContacttoA1Click(Sender: TObject);
begin
  SetContact(1);
end;

procedure TForm1.SetContacttoB1Click(Sender: TObject);
begin
  SetContact(2);
end;

procedure TForm1.SetMatrix;
var
  LSetMatrixForm: TSetMatrixForm;
  i,j: integer;
  LStr: string;
begin
  i := NextGrid1.SelectedRow;
  if not FEngineParameter.EngineParameterCollect.Items[i].IsMatrixData then
  begin
    ShowMessage('ParameterType should be one of Matrix types!');
    exit;
  end;

  LSetMatrixForm := TSetMatrixForm.Create(Self);
  try
    LSetMatrixForm.FParamItemIndex := i;
    LSetMatrixForm.FEngineParameter.Assign(FEngineParameter);
    LSetMatrixForm.MoveParameter2Grid;
    LSetMatrixForm.SetDisplay;
    LSetMatrixForm.ShowModal;
  finally
    j := FEngineParameter.ComparePublicMatrix(LSetMatrixForm.FEngineParameter);

    if j <> 0 then
    begin
      LStr := 'Parameter data is modified. Do you want to accept?'+#13#10#13#10+
          'Yes: Adapt to current parameter on memory, No: discard changed.';
      if MessageDlg(LStr, mtConfirmation, [mbYes, mbNo], 0)= mrYes then
      begin
        FEngineParameter.EngineParameterCollect.Clear;
        FEngineParameter.MatrixCollect.Clear;
        FEngineParameter.Assign(LSetMatrixForm.FEngineParameter);
      end;
    end;

    FreeAndNil(LSetMatrixForm);
  end;
end;

procedure TForm1.ShowProperties;
var
  Li: integer;
begin
  if NextGrid1.SelectedCount > 1 then
  begin
    ShowMessage('This function allows when selected only one row!');
    exit;
  end;

  if NextGrid1.SelectedCount = 1 then
  begin
    Li := NextGrid1.SelectedRow;
    if Li > FEngineParameter.EngineParameterCollect.Count - 1 then
    begin
      ShowMessage('Selected Row Index is greater than Parameter Collect Index');
      exit;
    end;

    SetConfigEngParamItemData(Li);
  end;
end;

procedure TForm1.Sqlite_Open;
var
  i: integer;
  LEngParamList: RawUtf8;
begin
  OpenDialog1.Filter := 'Sqlite|*.sqlite';
  OpenDialog1.FileName := '';

  if OpenDialog1.Execute then
  begin
    FEngineParameter.EngineParameterCollect.Clear;
    if OpenDialog1.FileName <> '' then
    begin
      Caption := OpenDialog1.FileName;

      InitEngineParamClient('E:\pjh\project\util\HiMECS\Application\Bin\db\'+ENG_PARAM_DB_NAME);
      LEngParamList := GetEngParamList2JSONArrayFromSensorType(stParam);
      FEngineParameter.LoadFromJSONArray(LEngParamList);

      AddGridColumn4Parameter(True);
      AddParameter2Grid(True);
    end;
  end;
end;

end.

