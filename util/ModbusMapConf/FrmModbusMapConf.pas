unit FrmModbusMapConf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, NxEdit, ComCtrls,
  ToolWin, ExtCtrls, Menus, EngineParameterClass, SynCommons, mORMot,
  HiMECSConst, ClipBrd, Data.DB, ComObj, OleCtrls,// MemDS, DBAccess, Ora, OraCall,
  UnitEnumHelper, UnitEngineParamRecord, UnitEngineParamConst, NxGridView6,
  NxColumns6, NxControls6, NxCustomGrid6, NxVirtualGrid6, NxGrid6, NxCells6,
  JvExControls, JvLabel, DragDrop, DropSource, DragDropText,
  DragDropRecord, UnitParameterManager;//, superobject

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
//    OraSession1: TOraSession;
//    OraQuery1: TOraQuery;
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
    NextGrid1: TNextGrid6;
    ParamNoFilterEdit: TEdit;
    JvLabel8: TJvLabel;
    NxReportGridView61: TNxReportGridView6;
    EngParamSource: TDropTextSource;
    Properties1: TMenuItem;
    N12: TMenuItem;
    CreateEPItemincfile1: TMenuItem;
    N13: TMenuItem;
    UpdateFieldsFromDBMapDBModbusTagNameDescFieldUpdate1: TMenuItem;
    OpenFromExcelofMap1: TMenuItem;
    CompareDescFromDBbyAddress1: TMenuItem;
    AdjustDummyFieldFromDBbyAddress1: TMenuItem;
    CopyFieldsFromTagName1: TMenuItem;
    CopyFieldsFromGridIndex1: TMenuItem;
    N14: TMenuItem;
    ool1: TMenuItem;
    N15: TMenuItem;
    ResetCellColorFromLevelIndex1: TMenuItem;
    ResetCellColorFromLevelIndex2: TMenuItem;
    SetCellColorFromAddress1: TMenuItem;
    OpenFromExcelofDFA2LM1: TMenuItem;
    AddDummy2Grid1: TMenuItem;
    SetParameterCatetorybyDersc1: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
    procedure ParamNoFilterEditChange(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure NextGrid1EditEnter(Sender: TObject; ACol, ARow: Integer);
    procedure NextGrid1EditExit(Sender: TObject; ACol, ARow: Integer);
    procedure NextGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Properties1Click(Sender: TObject);
    procedure CreateEPItemincfile1Click(Sender: TObject);
    procedure UpdateFieldsFromDBMapDBModbusTagNameDescFieldUpdate1Click(
      Sender: TObject);
    procedure OpenFromExcelofMap1Click(Sender: TObject);
    procedure CompareDescFromDBbyAddress1Click(Sender: TObject);
    procedure AdjustDummyFieldFromDBbyAddress1Click(Sender: TObject);
    procedure CopyFieldsFromTagName1Click(Sender: TObject);
    procedure CopyFieldsFromGridIndex1Click(Sender: TObject);
    procedure ResetCellColorFromLevelIndex1Click(Sender: TObject);
    procedure ResetCellColorFromLevelIndex2Click(Sender: TObject);
    procedure SetCellColorFromAddress1Click(Sender: TObject);
    procedure OpenFromExcelofDFA2LM1Click(Sender: TObject);
    procedure AddDummy2Grid1Click(Sender: TObject);
    procedure SetParameterCatetorybyDersc1Click(Sender: TObject);
  private
    FEngineParameter: TEngineParameter;
    FEngineParameterItemRecord: TEngineParameterItemRecord; //Watch폼에 값 전달시 사용
    FClipBdStrData: TClipBrdGridData;
    //FEngineParameter2: TEngineParameter2;
    FNextGridEditMode: Boolean;//Cell Edit Enter 시에 True, Exit시에 False, Row 복사시에 사용됨
    FMousePoint: TPoint;
    FEngParamSource: TEngineParameterDataFormat;
    FKeyBdShiftState: TShiftState;
    FParamCopyMode: integer;//Ord(TParamDragCopyMode)가 저장 됨
    FPM: TParameterManager;

    procedure WMDrawClipboard(var Msg: TMessage); message WM_DRAWCLIPBOARD;
    procedure WMChangeCBChain(var Msg: TMessage); message WM_CHANGECBCHAIN;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;

    procedure Data2XML;
    procedure MakeGridData2Parameter; //Modbus Map txt File을 읽어서 수정할때 쓰임
    procedure MakeGridData2Parameter2(AIsSqlite: Boolean = False);//JSON File 을 읽어서 수정할때 쓰임
    procedure ConvertToBase(AType, AAddrIndex: integer);
    function GetSelectedRow2Text: string;
    function GetSelectedRow2List: TStringList;
    procedure AddGridRowFromClipBrd(AClipBrdData: string);
    procedure ShowProperties;
    procedure SetConfigEngParamItemData(AIndex: Integer; AIsNew: Boolean);
    procedure ChangeRowColorFromLevelIndex(ARowIndex: integer; AIsReset: Boolean=False);
    procedure SetRowColorFromLevelIndex(AIsReset: Boolean=False);
    function GetCellColorFromLevelIndex(ARowIndex: integer; AIsReset: Boolean=False): TColor;
    procedure CheckAddressAscending;
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
    function GetTagNameFromGridIndex(ARowIndex: integer): string;
    procedure GetEngineTypeFromDB(ACombo: TComboBox);
    function GetMeasureTableFromDB(AEngType: string): string;
    procedure SetAlarmEnable(AEnable: Boolean);
    procedure SetContact(AContact: integer);
    procedure SetParamCatetoryFromDesc();

    procedure SetMatrix;
    procedure DeleteItems;
    procedure DeleteEngineParamterFromGrid(AIndex: integer);

    procedure OpenDataFromExcel;
    function OpenModbusDataFromExcel: integer;
    function OpenModbusDataFromExcel2: integer;
    procedure RemoveDummy;
    procedure AddDummyByAddress;
    procedure AppendProjEngNo2TagName;
    procedure MakeTagNameFromAddress;

    procedure UpdateFieldsFromDB(ADBName: string='');
    procedure CompareDescFromDBByAddrNSave2File(AIsAdjustDummy: Boolean);
    //현재 Load된 data와 읽어온 DB의 Address를 비교하여 신규 Item 이면  FEngineParamter에 추가함
    procedure AddNewAddrItem(ANewItem: TEngineParameterItem);
    procedure CopyFieldsFromGridIndex2SelectedRow(AIdx: integer);
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
  UnitEngineMasterData, CopyData, FrmIntInputEdit, UnitStringUtil, UnitNextGrid6Util,
  UnitArrayUtil;

{$R *.dfm}

//공유메모리의 위치정보(배열Index)를 Absolute Index에 저장함.
//Bit Mode의 경우(Func Code 1 or 2) 16Bit가 공유메모리 배열 한개의 자리를 차지함(1 word).
//때문에 Bit Mode의 경우 Absolute Index는 16개 Item 마다 1씩 증가함
//(Wago D-type Param 참조 할 것-E:\pjh\project\util\HiMECS\Application\Bin\Doc\7H2132\D_Type_Modbus_Map.param)
//Binary 의 경우 32Bit내 위치정보를 Radix Position에 저장함.
//Binary를 Radix Position에 저장할 경우 Address가 동일 해야 함.
//Sumulation Mode시 모든 Data를 전송하므로 Block No에 관계없이 Node Index에 저장함.
procedure TForm1.CalcAbsoluteIndex;
var
  i,PrevAddrHex, CurAddrHex,
  PrevBlockNo, CurIndex,
  PrevAddrHex2, CurRadixIndex,
  CurNodeIndex, LAddrHex: integer;
  LAddr: string;
begin
  with NextGrid1 do
  begin
    PrevBlockNo := -1;
    CurIndex := 0;
    PrevAddrHex := 0;
    CurRadixIndex := 0;
    PrevAddrHex2 := 0;
    CurNodeIndex := -1;

    for i := 0 to RowCount-1 do
    begin
      LAddr := CellBy['Address',i].AsString;

      if LAddr = '' then
        LAddr := '0';

      LAddrHex := HexToint(LAddr);

      if PrevBlockNo <> CellBy['BlockNo',i].AsInteger then
      begin
        PrevBlockNo := CellBy['BlockNo',i].AsInteger;
        CurIndex := 0;
        PrevAddrHex := LAddrHex;
        Inc(CurNodeIndex);
      end;

      if UpperCase(CellBy['Alarm',i].AsString) <> 'TRUE' then
//      if UpperCase(CellBy['ParameterType',i].AsString) = 'DIGITAL' then
        if PrevAddrHex2 <> LAddrHex then
          CurRadixIndex := 0;

      CurAddrHex := LAddrHex;
      CurIndex := CurIndex + (CurAddrHex - PrevAddrHex);//Dummmy 가 있을경우 Index를 Dummy 갯수 만큼 증가 시킴
      CellBy['AbsoluteIndex',i].AsInteger := CurIndex;
      CurNodeIndex := CurNodeIndex + (CurAddrHex - PrevAddrHex);//Dummmy 가 있을경우 Index를 Dummy 갯수 만큼 증가 시킴
      CellBy['NodeIndex',i].AsInteger := i;//CurNodeIndex;
      //Inc(CurIndex);
      PrevAddrHex := LAddrHex;

      if UpperCase(CellBy['Alarm',i].AsString) <> 'TRUE' then
//      if UpperCase(CellBy['ParameterType',i].AsString) = 'DIGITAL' then
      begin
        PrevAddrHex2 := LAddrHex;
        CellBy['BitIndex',i].AsInteger := CurRadixIndex;
        Inc(CurRadixIndex);
      end;
    end;
  end;//with
end;

procedure TForm1.ChangeRowColorFromLevelIndex(ARowIndex: integer; AIsReset: Boolean);
var
  LStr: string;
  LColor: TColor;
begin
  LColor := GetCellColorFromLevelIndex(ARowIndex, AIsReset);
  ChangeRowColorByIndex(NextGrid1, ARowIndex, LColor);
end;

procedure TForm1.CheckAddressAscending;
var
  i: integer;
  LAddr, LFCode, LBlockNo: integer;
  LPrevAddr, LPrevFCode, LPrevBlockNo: integer;
  LIsAscending: Boolean;
  LColor: TColor;
begin
  LPrevAddr := -1;
  LPrevFCode := -1;
  LPrevBlockNo := -1;

  with NextGrid1 do
  begin
    BeginUpdate;
    try
      for i := 0 to RowCount-1 do
      begin
        LAddr := HexToInt(CellBy['Address', i].AsString);
        LFCode := CellBy['FCode', i].AsInteger;
        LBlockNo := CellBy['BlockNo', i].AsInteger;

        if LPrevAddr = -1 then
        begin
          LPrevBlockNo := LBlockNo;
          LPrevFCode := LFCode;
          LPrevAddr := LAddr;
        end;

        if LPrevAddr = LAddr then
          Continue;

        if LBlockNo = LPrevBlockNo then
        begin
          if LPrevFCode = LFCode then
          begin
            LIsAscending := LAddr = LPrevAddr + 1;

            if not LIsAscending then
            begin
              ChangeRowColorByIndex(NextGrid1, i, clYellow);
            end;

            if LPrevAddr <> LAddr then
              LPrevAddr := LAddr;
          end
          else
          begin
            LPrevFCode := LFCode;
          end;
        end
        else
        begin
          LPrevBlockNo := LBlockNo;
          LPrevAddr := -1;
        end;
      end;//for
    finally
      EndUpdate;
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
  NextGrid1.Columns[NextGrid1.SelectedCol].Alignment := taLeftJustify;
end;

procedure TForm1.btnCenterAlignmentClick(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedCol].Alignment := taCenter;
end;

procedure TForm1.btnRightAlignmentClick(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedCol].Alignment := taRightJustify;
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedCol].VerticalAlignment := taAlignTop;
end;

procedure TForm1.ToolButton4Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedCol].VerticalAlignment := taVerticalCenter;
end;

procedure TForm1.ToolButton5Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedCol].VerticalAlignment := taAlignBottom;
end;

procedure TForm1.AddDummy2Grid1Click(Sender: TObject);
begin
  AddDummyByAddress();
end;

procedure TForm1.AddDummyByAddress;
var
  i, LMissingNum, LRow: integer;
  LAry: TArray<Integer>;
  LStrList: TStringList;
begin
  SetLength(LAry, NextGrid1.RowCount);

  NextGrid1.BeginUpdate;
  try
    for i := 0 to NextGrid1.RowCount - 1 do
      LAry[i] := StrToIntDef(NextGrid1.CellBy['Address',i].AsString, -1);

    LStrList := FindMissingNumbers2List(LAry);
    try
//      for i := LStrList.Count - 1 downto 0 do
      for i := 0 to LStrList.Count - 1 do
      begin
        LMissingNum := Integer(LStrList.Objects[i]);
        LRow := NextGrid1.InsertRow(LMissingNum).Index;
        NextGrid1.CellBy['Address',LRow].AsString := Format('%.4d',[StrToInt(LStrList.Strings[i])]);
        NextGrid1.CellBy['Description',LRow].AsString := 'DUMMY';
        NextGrid1.CellBy['BlockNo',LRow].AsString := NextGrid1.CellBy['BlockNo',LRow-1].AsString;
        NextGrid1.CellBy['FCode',LRow].AsString := NextGrid1.CellBy['FCode',LRow-1].AsString;
      end;
    finally
      LStrList.Free;
    end;

  finally
    NextGrid1.EndUpdate;
  end;
end;

procedure TForm1.AddGridColumn4Parameter(AIsSqlite: Boolean);
var
  LnxTextColumn: TnxTextColumn6;
  LNxComboBoxColumn: TNxComboBoxColumn6;
begin
  with NextGrid1 do
  begin
    ClearRows;
    Columns.Clear;

    Columns.Add(TnxIncrementColumn6,'No.');

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'LevelIndex(ZAxis Size)'));
    LnxTextColumn.Name := 'LevelIndex';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'NodeIndex(TMatrixItem Index)'));
    LnxTextColumn.Name := 'NodeIndex';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'AbsoluteIndex'));
    LnxTextColumn.Name := 'AbsoluteIndex';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'MaxValue(XAxis Size)'));
    LnxTextColumn.Name := 'MaxValue';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Contact(YAxis Size)'));
    LnxTextColumn.Name := 'Contact';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'TagName'));
    LnxTextColumn.Name := 'TagName';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Description'));
    LnxTextColumn.Name := 'Description';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Address'));
    LnxTextColumn.Name := 'Address';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coCanSort,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Alarm'));
    LnxTextColumn.Name := 'Alarm';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Func Code'));
    LnxTextColumn.Name := 'FCode';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'FFUnit'));
    LnxTextColumn.Name := 'FFUnit';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'SensorType'));
    LNxComboBoxColumn.Name := 'SensorType';
    LNxComboBoxColumn.Editing := True;
    g_SensorType.SetType2List(LNxComboBoxColumn.Items);
//    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'ParameterCatetory'));
    LNxComboBoxColumn.Name := 'ParameterCatetory';
    LNxComboBoxColumn.Editing := True;
    ParameterCatetory2Strings(LNxComboBoxColumn.Items);
//    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'ParameterType'));
    LNxComboBoxColumn.Name := 'ParameterType';
    LNxComboBoxColumn.Editing := True;
    ParameterType2Strings(LNxComboBoxColumn.Items);
//    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'ParameterSource'));
    LNxComboBoxColumn.Name := 'ParameterSource';
    LNxComboBoxColumn.Editing := True;
    ParameterSource2Strings(LNxComboBoxColumn.Items);
//    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'SharedMemName'));
    LnxTextColumn.Name := 'SharedName';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Block No'));
    LnxTextColumn.Name := 'BlockNo';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Radix Position(Bit Index)'));
    LnxTextColumn.Name := 'BitIndex';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Value(Manual Input)'));
    LnxTextColumn.Name := 'Value';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Alarm Enable'));
    LnxTextColumn.Name := 'AlarmEnable';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Proj. No'));
    LnxTextColumn.Name := 'ProjNo';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Eng. No'));
    LnxTextColumn.Name := 'EngNo';
    LnxTextColumn.Editing := True;
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    if AIsSqlite then
    begin
      LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Scale'));
      LnxTextColumn.Name := 'Scale';
      LnxTextColumn.Editing := True;

      LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'AlarmKind'));
      LNxComboBoxColumn.Name := 'AlarmKind';
      LNxComboBoxColumn.Editing := True;
      g_AlarmKind4AVAT2.SetType2List(LNxComboBoxColumn.Items);

      LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'AlarmLimit'));
      LNxComboBoxColumn.Name := 'AlarmLimit';
      LNxComboBoxColumn.Editing := True;
      g_AlarmLimit4AVAT2.SetType2List(LNxComboBoxColumn.Items);

      LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'ParameterCatetory4AVAT2'));
      LNxComboBoxColumn.Name := 'ParameterCatetory4AVAT2';
      LNxComboBoxColumn.Editing := True;
      g_ParameterCategory4AVAT2.SetType2List(LNxComboBoxColumn.Items);
//      LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'DFAlarmKind'));
      LNxComboBoxColumn.Name := 'DFAlarmKind';
      LNxComboBoxColumn.Editing := True;
      g_DFAlarmKind.SetType2List(LNxComboBoxColumn.Items);
//      LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'EngineUsage'));
      LNxComboBoxColumn.Name := 'EngineUsage';
      LNxComboBoxColumn.Editing := True;
      g_EngineUsage.SetType2List(LNxComboBoxColumn.Items);
//      LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'DFCommissioningItem'));
      LNxComboBoxColumn.Name := 'DFCommissioningItem';
      LNxComboBoxColumn.Editing := True;
      g_DFCommissioningItem.SetType2List(LNxComboBoxColumn.Items);
//      LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'ParamNo'));
      LnxTextColumn.Name := 'ParamNo';
      LnxTextColumn.FilterEnabled := True;

//      LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Description_Eng'));
      LnxTextColumn.Name := 'Description_Eng';
      LnxTextColumn.Editing := True;
//      LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

      LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Description_Kor'));
      LnxTextColumn.Name := 'Description_Kor';
      LnxTextColumn.Editing := True;
//      LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
    end;
  end;
end;

procedure TForm1.AddGridColumn4S7;
var
  LnxTextColumn: TnxTextColumn6;
  LNxComboBoxColumn: TNxComboBoxColumn6;
begin
  with NextGrid1 do
  begin
    ClearRows;
    Columns.Clear;

    Columns.Add(TnxIncrementColumn6,'No.');

    LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'Area'));
    LNxComboBoxColumn.Name := 'Area';
    S7Area2Strings(LNxComboBoxColumn.Items);
//    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'DB'));
    LnxTextColumn.Name := 'DB';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'DataType'));
    LNxComboBoxColumn.Name := 'DataType';
    S7DataType2Strings(LNxComboBoxColumn.Items);
//    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Offset'));
    LnxTextColumn.Name := 'Offset';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Contact'));
    LnxTextColumn.Name := 'Contact';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'TagName'));
    LnxTextColumn.Name := 'TagName';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Description'));
    LnxTextColumn.Name := 'Description';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Address'));
    LnxTextColumn.Name := 'Address';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coCanSort,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Alarm'));
    LnxTextColumn.Name := 'Alarm';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Func Code'));
    LnxTextColumn.Name := 'FCode';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'FFUnit'));
    LnxTextColumn.Name := 'FFUnit';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'SensorType'));
    LNxComboBoxColumn.Name := 'SensorType';
    g_SensorType.SetType2List(LNxComboBoxColumn.Items);
//    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'ParameterCatetory'));
    LNxComboBoxColumn.Name := 'ParameterCatetory';
    ParameterCatetory2Strings(LNxComboBoxColumn.Items);
//    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'ParameterType'));
    LNxComboBoxColumn.Name := 'ParameterType';
    ParameterType2Strings(LNxComboBoxColumn.Items);
//    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LNxComboBoxColumn := TNxComboBoxColumn6(Columns.Add(TNxComboBoxColumn6,'ParameterSource'));
    LNxComboBoxColumn.Name := 'ParameterSource';
    ParameterSource2Strings(LNxComboBoxColumn.Items);
//    LNxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'SharedMemName'));
    LnxTextColumn.Name := 'SharedName';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Block No'));
    LnxTextColumn.Name := 'CNT';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
  end;
end;

procedure TForm1.AddGridColumn4TxtFile;
var
  LnxTextColumn: TnxTextColumn6;
  LNxComboBoxColumn: TNxComboBoxColumn6;
begin
  with NextGrid1 do
  begin
    ClearRows;
    Columns.Clear;

    Columns.Add(TnxIncrementColumn6,'No.');

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'TAG_NAME'));
    LnxTextColumn.Name := 'TAG_NAME';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'DESCRIPT'));
    LnxTextColumn.Name := 'DESCRIPT';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'SID'));
    LnxTextColumn.Name := 'SID';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'ADDR'));
    LnxTextColumn.Name := 'ADDR';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'CNT'));
    LnxTextColumn.Name := 'CNT';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'ALARM'));
    LnxTextColumn.Name := 'ALARM';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'MAXVAL'));
    LnxTextColumn.Name := 'MAXVAL';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'CONTACT'));
    LnxTextColumn.Name := 'CONTACT';
//    LnxTextColumn.Options := [coCanClick,coCanInput,coCanSort,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
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

procedure TForm1.AddNewAddrItem(ANewItem: TEngineParameterItem);
var
  i, LLastFCIdx: integer;
  LDestItem, LNewItem: TEngineParameterItem;
  LIsInsSuccess: Boolean;
begin
  LIsInsSuccess := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    LDestItem := FEngineParameter.EngineParameterCollect[i];

    if LDestItem.FCode = ANewItem.FCode then
    begin
      //Address 중간에 Insert함
      if LDestItem.Address > ANewItem.Address then
      begin
        LNewItem := FEngineParameter.EngineParameterCollect.Insert(i);
        LNewItem.Assign(ANewItem);
        LNewItem.LevelIndex := 1;//신규 추가인 경우 1로 표시함
        LIsInsSuccess := True;
        Break;
      end
      else
      begin
        LLastFCIdx := i;
      end;
    end;
  end;//for

  if not LIsInsSuccess then
  begin
    LNewItem := FEngineParameter.EngineParameterCollect.Insert(LLastFCIdx+1);
    LNewItem.Assign(ANewItem);
    LNewItem.LevelIndex := 1;//신규 추가인 경우 1로 표시함
  end;
end;

procedure TForm1.AddParameter2Grid(AIsSqlite: Boolean = False);
var
  i: integer;
begin
  with NextGrid1, FEngineParameter do
  begin
    BeginUpdate;
    ClearRows;
    try
      for i := 0 to EngineParameterCollect.Count - 1 do
      begin
        AddRow();

        CellBy['LevelIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].LevelIndex);
        CellBy['NodeIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].NodeIndex);
        CellBy['AbsoluteIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].AbsoluteIndex);
        CellBy['MaxValue', i].AsString := IntToStr(EngineParameterCollect.Items[i].MaxValue);
        CellBy['Contact', i].AsString := IntToStr(EngineParameterCollect.Items[i].Contact);
        CellBy['TagName', i].AsString := EngineParameterCollect.Items[i].TagName;
        CellBy['Description', i].AsString := EngineParameterCollect.Items[i].Description;
        CellBy['Address', i].AsString := EngineParameterCollect.Items[i].Address;
        CellBy['Alarm', i].AsString := BoolToStr(EngineParameterCollect.Items[i].Alarm, true);
        CellBy['FCode', i].AsString := EngineParameterCollect.Items[i].FCode;
        CellBy['FFUnit', i].AsString := EngineParameterCollect.Items[i].FUnit;
        CellBy['SensorType', i].AsString := g_SensorType.ToString(EngineParameterCollect.Items[i].SensorType);
        CellBy['ParameterCatetory', i].AsString := ParameterCatetory2String(EngineParameterCollect.Items[i].ParameterCatetory);
        CellBy['ParameterType', i].AsString := ParameterType2String(EngineParameterCollect.Items[i].ParameterType);
        CellBy['ParameterSource', i].AsString := ParameterSource2String(EngineParameterCollect.Items[i].ParameterSource);
        CellBy['SharedName', i].AsString := EngineParameterCollect.Items[i].SharedName;
        CellBy['BlockNo', i].AsString := IntToStr(EngineParameterCollect.Items[i].BlockNo);
        CellBy['BitIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].RadixPosition);
        CellBy['Value', i].AsString := EngineParameterCollect.Items[i].Value;
        CellBy['AlarmEnable', i].AsString := BoolToStr(EngineParameterCollect.Items[i].AlarmEnable, True);
        CellBy['ProjNo', i].AsString := EngineParameterCollect.Items[i].ProjNo;
        CellBy['EngNo', i].AsString := EngineParameterCollect.Items[i].EngNo;

        if AIsSqlite then
        begin
          CellBy['Scale', i].AsString := EngineParameterCollect.Items[i].Scale;
          CellBy['ParameterCatetory4AVAT2', i].AsString := g_ParameterCategory4AVAT2.ToString(EngineParameterCollect.Items[i].ParameterCatetory4AVAT2);
          CellBy['DFAlarmKind', i].AsString := g_DFAlarmKind.ToString(EngineParameterCollect.Items[i].DFAlarmKind);
          CellBy['EngineUsage', i].AsString := g_EngineUsage.ToString(EngineParameterCollect.Items[i].EngineUsage);
          CellBy['DFCommissioningItem', i].AsString := g_DFCommissioningItem.ToString(EngineParameterCollect.Items[i].DFCommissioningItem);
          CellBy['ParamNo', i].AsString := EngineParameterCollect.Items[i].ParamNo;
          CellBy['Description_Eng', i].AsString := EngineParameterCollect.Items[i].Description_Eng;
          CellBy['Description_Kor', i].AsString := EngineParameterCollect.Items[i].Description_Kor;
          CellBy['AlarmKind', i].AsString := g_AlarmKind4AVAT2.ToString(EngineParameterCollect.Items[i].AlarmKind4AVAT2);
          CellBy['AlarmLimit', i].AsString := g_AlarmLimit4AVAT2.ToString(EngineParameterCollect.Items[i].AlarmLimit4AVAT2);
        end;

        ChangeRowColorFromLevelIndex(i);
      end;//for
    finally
      EndUpdate;
    end;
  end;//with
end;

procedure TForm1.AddParamItem2Grid(AIndex: integer;
  AEngineParameterItem: TEngineParameterItem);
begin
  with NextGrid1 do
  begin
    CellBy['LevelIndex', AIndex].AsString := IntToStr(AEngineParameterItem.LevelIndex);
    CellBy['NodeIndex', AIndex].AsString := IntToStr(AEngineParameterItem.NodeIndex);
    CellBy['AbsoluteIndex', AIndex].AsString := IntToStr(AEngineParameterItem.AbsoluteIndex);
    CellBy['MaxValue', AIndex].AsString := IntToStr(AEngineParameterItem.MaxValue);
    CellBy['Contact', AIndex].AsString := IntToStr(AEngineParameterItem.Contact);
    CellBy['TagName', AIndex].AsString := AEngineParameterItem.TagName;
    CellBy['Description', AIndex].AsString := AEngineParameterItem.Description;
    CellBy['Address', AIndex].AsString := AEngineParameterItem.Address;
    CellBy['Alarm', AIndex].AsString := BoolToStr(AEngineParameterItem.Alarm, true);
    CellBy['FCode', AIndex].AsString := AEngineParameterItem.FCode;
    CellBy['FFUnit', AIndex].AsString := AEngineParameterItem.FUnit;
    CellBy['SensorType', AIndex].AsString := g_SensorType.ToString(AEngineParameterItem.SensorType);
    CellBy['ParameterCatetory', AIndex].AsString := ParameterCatetory2String(AEngineParameterItem.ParameterCatetory);
    CellBy['ParameterType', AIndex].AsString := ParameterType2String(AEngineParameterItem.ParameterType);
    CellBy['ParameterSource', AIndex].AsString := ParameterSource2String(AEngineParameterItem.ParameterSource);
    CellBy['SharedName', AIndex].AsString := AEngineParameterItem.SharedName;
    CellBy['BlockNo', AIndex].AsString := IntToStr(AEngineParameterItem.BlockNo);
    CellBy['BitIndex', AIndex].AsString := IntToStr(AEngineParameterItem.RadixPosition);
    CellBy['Value', AIndex].AsString := AEngineParameterItem.Value;
    CellBy['AlarmEnable', AIndex].AsString := BoolToStr(AEngineParameterItem.AlarmEnable, True);
    CellBy['ProjNo', AIndex].AsString := AEngineParameterItem.ProjNo;
    CellBy['AlarmKind', AIndex].AsString := g_AlarmKind4AVAT2.ToString(AEngineParameterItem.AlarmKind4AVAT2);
    CellBy['AlarmLimit', AIndex].AsString := g_AlarmLimit4AVAT2.ToString(AEngineParameterItem.AlarmLimit4AVAT2);
    CellBy['ParameterCatetory4AVAT2', AIndex].AsString := g_ParameterCategory4AVAT2.ToString(AEngineParameterItem.ParameterCatetory4AVAT2);
    CellBy['DFAlarmKind', AIndex].AsString := g_DFAlarmKind.ToString(AEngineParameterItem.DFAlarmKind);
    CellBy['EngineUsage', AIndex].AsString := g_EngineUsage.ToString(AEngineParameterItem.EngineUsage);
    CellBy['DFCommissioningItem', AIndex].AsString := g_DFCommissioningItem.ToString(AEngineParameterItem.DFCommissioningItem);
    CellBy['ParamNo', AIndex].AsString := AEngineParameterItem.ParamNo;
    CellBy['Description_Eng', AIndex].AsString := AEngineParameterItem.Description_Eng;
    CellBy['Description_Kor', AIndex].AsString := AEngineParameterItem.Description_Kor;
  end;
end;

procedure TForm1.AdjustDummyFieldFromDBbyAddress1Click(Sender: TObject);
begin
  CompareDescFromDBByAddrNSave2File(True);
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
    LParam.FDBName := AFileName;
//    LParam.LoadFromJSONFile(AFileName, ExtractFileName(AFileName), EncryptCB.Checked);
    LParam.LoadFromFile(AFileName, ExtractFileName(AFileName), EncryptCB.Checked);

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
  LStr, LFC: string;
begin
  NextGrid1.BeginUpdate;

  try
    for i := NextGrid1.RowCount - 1 downto 0 do
    begin
      if UpperCase(NextGrid1.CellBy['TagName',i].AsString) <> 'DUMMY' then
      begin
        if (NextGrid1.CellBy['ProjNo',i].AsString <> '') and
          (NextGrid1.CellBy['ProjNo',i].AsString <> '0') then
        begin
          LStr := NextGrid1.CellBy['ProjNo',i].AsString + '_' +
            NextGrid1.CellBy['EngNo',i].AsString + '_' +
            NextGrid1.CellBy['TagName',i].AsString;
          NextGrid1.CellBy['TagName',i].AsString := LStr;
        end;

        if NextGrid1.CellBy['TagName',i].AsString = '0' then
        begin
          LStr := NextGrid1.CellBy['SensorType',i].AsString + '_' +
            NextGrid1.CellBy['Address',i].AsString;
          LFC := NextGrid1.CellBy['FCode',i].AsString;

          if ((LFC = '3') or (LFC = '4')) and
            (UpperCase(NextGrid1.CellBy['Alarm', i].AsString) <> 'TRUE') then
            LStr := LStr + '_' + NextGrid1.CellBy['BitIndex', i].AsString;

          NextGrid1.CellBy['TagName',i].AsString := LStr;
        end;
      end;
    end;
  finally
    NextGrid1.EndUpdate;
  end;
end;

procedure TForm1.btnAddRowClick(Sender: TObject);
var
  LBool: Boolean;
begin
  if NextGrid1.Columns.Count = 0 then
  begin
    if RGModeSelect.ItemIndex = 3 then
      AddGridColumn4S7
    else
    begin
      LBool := RGModeSelect.ItemIndex = 4;
      AddGridColumn4Parameter(LBool);
    end;
  end;

  NextGrid1.BeginUpdate();
  try
    if (NextGrid1.SelectedRow = -1) or (NextGrid1.SelectedRow = NextGrid1.RowCount - 1) then
    begin
      NextGrid1.AddRow;
      NextGrid1.SelectLastAddedRow;
    end
    else
    begin
      NextGrid1.InsertRow(NextGrid1.SelectedRow);
      NextGrid1.Row[NextGrid1.SelectedRow+1].Selected := False;
      NextGrid1.Row[NextGrid1.SelectedRow].Selected := True;
    end;
  finally
    NextGrid1.EndUpdate();
  end;
end;

procedure TForm1.ToolButton13Click(Sender: TObject);
var
  Li: integer;
  LRow: INxCellsRow;
begin
  LRow := NextGrid1.AddRow;

  for Li := 0 to 8 do
    NextGrid1.Cells[Li, LRow.Index] := NextGrid1.Cells[Li, NextGrid1.SelectedRow];

  NextGrid1.SelectLastAddedRow;
end;

procedure TForm1.ToolButton14Click(Sender: TObject);
begin
  DeleteItems;
  //NextGrid1.DeleteRow(NextGrid1.SelectedRow);
  //FEngineParameter.EngineParameterCollect.Delete(NextGrid1.SelectedRow);
end;

procedure TForm1.ToolButton16Click(Sender: TObject);
begin
  NextGrid1.Columns.Delete(NextGrid1.SelectedCol);
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

procedure TForm1.UpdateFieldsFromDB(ADBName: string);
var
  i: integer;
  LDBName: string;
  LSQLModel: TSQLModel;
  LSQLRestClientURI: TSQLRestClientURI;
  LSrcEngParameter: TEngineParameter;
  LEngParamList: RawUtf8;
begin
  LDBName := ADBName;

  if LDBName = '' then
  begin
    OpenDialog1.Filter := 'Sqlite|*.sqlite';
    OpenDialog1.FileName := '';

    if OpenDialog1.Execute then
    begin
      if OpenDialog1.FileName <> '' then
      begin
        LDBName := OpenDialog1.FileName;
      end;
    end;
  end;

  LSrcEngParameter := TEngineParameter.Create(nil);

  try
    LSQLRestClientURI := InitEngineParamClient2(LDBName, LSQLModel);
    try
      LEngParamList := GetEngParamList2JSONArrayFromSensorType(LSQLRestClientURI, stNull, True);
      LSrcEngParameter.LoadFromJSONArray(LEngParamList);
      LSrcEngParameter.EngineParameterCollect.UpdateTagNameFromAddress4Collect(FEngineParameter.EngineParameterCollect);
      LSrcEngParameter.EngineParameterCollect.UpdateEngineParameterCollectByTagName(FEngineParameter.EngineParameterCollect);
    finally
      LSQLModel.Free;
      LSQLRestClientURI.Free;
    end;

  finally
    LSrcEngParameter.Free;
  end;
end;

procedure TForm1.UpdateFieldsFromDBMapDBModbusTagNameDescFieldUpdate1Click(
  Sender: TObject);
begin
  UpdateFieldsFromDB();
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

procedure TForm1.WMCopyData(var Msg: TMessage);
var
  i, LHandle: integer;
  LEngineParameterItem: TEngineParameterItem;
begin
  case Msg.WParam of
    WParam_REQMULTIRECORD: begin//Handle 수신 OK
      FKeyBdShiftState := PKbdShiftRec(PCopyDataStruct(Msg.LParam)^.lpData)^.FKbdShift;
      FParamCopyMode := PKbdShiftRec(PCopyDataStruct(Msg.LParam)^.lpData)^.ParamDragMode;
      FEngineParameterItemRecord.FParamDragCopyMode := TParamDragCopyMode(FParamCopyMode);
      LHandle := PKbdShiftRec(PCopyDataStruct(Msg.LParam)^.lpData)^.MyHandle;
      SendMessage(LHandle, WM_MULTICOPY_BEGIN, 0, 0);

      for i := 0 to NextGrid1.RowCount - 1 do
      begin
        if NextGrid1.Row[i].Selected then
        begin
          LEngineParameterItem := FEngineParameter.EngineParameterCollect.Items[i];
          LEngineParameterItem.AssignTo(FEngineParameterItemRecord);
          FPM.SendEPCopyData(Handle, LHandle,FEngineParameterItemRecord)
        end;
      end;

      SendMessage(LHandle, WM_MULTICOPY_END, 0, 0);
      FKeyBdShiftState := [];
      FParamCopyMode := Ord(dcmCopyCancel);
      FEngineParameterItemRecord.FParamDragCopyMode := dcmCopyCancel;
    end;
    WParam_DISPLAYMSG: begin//MDI Child Caption 수신
    end;
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

          CellBy['LevelIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].LevelIndex);
          CellBy['NodeIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].NodeIndex);
          CellBy['AbsoluteIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].AbsoluteIndex);
          CellBy['MaxValue', i].AsString := IntToStr(EngineParameterCollect.Items[i].MaxValue);
          CellBy['Contact', i].AsString := IntToStr(EngineParameterCollect.Items[i].Contact);
          CellBy['TagName', i].AsString := EngineParameterCollect.Items[i].TagName;
          CellBy['Description', i].AsString := EngineParameterCollect.Items[i].Description;
          CellBy['Address', i].AsString := EngineParameterCollect.Items[i].Address;
          CellBy['Alarm', i].AsString := BoolToStr(EngineParameterCollect.Items[i].Alarm, true);
          CellBy['FCode', i].AsString := EngineParameterCollect.Items[i].FCode;
          CellBy['FFUnit', i].AsString := EngineParameterCollect.Items[i].FUnit;
          CellBy['SensorType', i].AsString := g_SensorType.ToString(EngineParameterCollect.Items[i].SensorType);
          CellBy['ParameterCatetory', i].AsString := ParameterCatetory2String(EngineParameterCollect.Items[i].ParameterCatetory);
          CellBy['ParameterType', i].AsString := ParameterType2String(EngineParameterCollect.Items[i].ParameterType);
          CellBy['ParameterSource', i].AsString := ParameterSource2String(EngineParameterCollect.Items[i].ParameterSource);
          CellBy['SharedName', i].AsString := EngineParameterCollect.Items[i].SharedName;
          CellBy['BlockNo', i].AsString := IntToStr(EngineParameterCollect.Items[i].BlockNo);
          CellBy['BitIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].RadixPosition);
          CellBy['Value', i].AsString := EngineParameterCollect.Items[i].Value;
          CellBy['AlarmEnable', i].AsString := BoolToStr(EngineParameterCollect.Items[i].AlarmEnable, True);
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

          CellBy['LevelIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].LevelIndex);
          CellBy['NodeIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].NodeIndex);
          CellBy['AbsoluteIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].AbsoluteIndex);
          CellBy['MaxValue', i].AsString := IntToStr(EngineParameterCollect.Items[i].MaxValue);
          CellBy['Contact', i].AsString := IntToStr(EngineParameterCollect.Items[i].Contact);
          CellBy['TagName', i].AsString := EngineParameterCollect.Items[i].TagName;
          CellBy['Description', i].AsString := EngineParameterCollect.Items[i].Description;
          CellBy['Address', i].AsString := EngineParameterCollect.Items[i].Address;
          CellBy['Alarm', i].AsString := BoolToStr(EngineParameterCollect.Items[i].Alarm, true);
          CellBy['FCode', i].AsString := EngineParameterCollect.Items[i].FCode;
          CellBy['FFUnit', i].AsString := EngineParameterCollect.Items[i].FUnit;
          CellBy['SensorType', i].AsString := g_SensorType.ToString(EngineParameterCollect.Items[i].SensorType);
          CellBy['ParameterCatetory', i].AsString := ParameterCatetory2String(EngineParameterCollect.Items[i].ParameterCatetory);
          CellBy['ParameterType', i].AsString := ParameterType2String(EngineParameterCollect.Items[i].ParameterType);
          CellBy['ParameterSource', i].AsString := ParameterSource2String(EngineParameterCollect.Items[i].ParameterSource);
          CellBy['SharedName', i].AsString := EngineParameterCollect.Items[i].SharedName;
          CellBy['BlockNo', i].AsString := IntToStr(EngineParameterCollect.Items[i].BlockNo);
          CellBy['BitIndex', i].AsString := IntToStr(EngineParameterCollect.Items[i].RadixPosition);
          CellBy['Value', i].AsString := EngineParameterCollect.Items[i].Value;
          CellBy['AlarmEnable', i].AsString := BoolToStr(EngineParameterCollect.Items[i].AlarmEnable, True);
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
  o := NextGrid1.Columns[NextGrid1.SelectedCol].Position;
  if o = 0 then Exit;
  n := o - 1;
  NextGrid1.Columns.Move(o, n);
end;

procedure TForm1.ToolButton19Click(Sender: TObject);
var
  o, n: Integer;
begin
  o := NextGrid1.Columns[NextGrid1.SelectedCol].Position;
  n := o + 1;
  NextGrid1.Columns.Move(o, n);
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
    if CheckCell(SelectedCol, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedCol, SelectedRow].Font.Style := Cell[SelectedCol, SelectedRow].Font.Style + [fsBold]
        else Cell[SelectedCol, SelectedRow].Font.Style := Cell[SelectedCol, SelectedRow].Font.Style - [fsBold];
end;

procedure TForm1.btnItalicClick(Sender: TObject);
begin
  with NextGrid1 do
    if CheckCell(SelectedCol, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedCol, SelectedRow].Font.Style := Cell[SelectedCol, SelectedRow].Font.Style + [fsItalic]
        else Cell[SelectedCol, SelectedRow].Font.Style := Cell[SelectedCol, SelectedRow].Font.Style - [fsItalic];
end;

procedure TForm1.btnUnderlineClick(Sender: TObject);
begin
  with NextGrid1 do
    if CheckCell(SelectedCol, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedCol, SelectedRow].Font.Style := Cell[SelectedCol, SelectedRow].Font.Style + [fsUnderline]
        else Cell[SelectedCol, SelectedRow].Font.Style := Cell[SelectedCol, SelectedRow].Font.Style - [fsUnderline];
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

procedure TForm1.Button8Click(Sender: TObject);
begin
  Data_2_Sqlite;
end;

procedure TForm1.ColorPickerEditor1Change(Sender: TObject);
begin
  with NextGrid1 do
    if CheckCell(SelectedCol, SelectedRow) then
    begin
      if ColorPickerEditor1.SelectedColor = clNone
        then Cell[SelectedCol, SelectedRow].Color := Color
        else Cell[SelectedCol, SelectedRow].Color := ColorPickerEditor1.SelectedColor;
    end;
end;

procedure TForm1.CompareDescFromDBbyAddress1Click(Sender: TObject);
begin
  CompareDescFromDBByAddrNSave2File(False);
end;

procedure TForm1.CompareDescFromDBByAddrNSave2File(AIsAdjustDummy: Boolean);
var
  LDBName: string;
  LSQLModel: TSQLModel;
  LSQLRestClientURI: TSQLRestClientURI;
  LSrcEngParameter: TEngineParameter;
  LEngParamList: RawUtf8;
  i,j: integer;
  LDescDiffList, LNewAddrList, LDummyList: TStringList;
  LIsAddrExist: Boolean;
  LSrcEngItem, LDestEngItem: TEngineParameterItem;
begin
  OpenDialog1.Filter := 'Sqlite|*.sqlite';
  OpenDialog1.FileName := '';

  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      LDBName := OpenDialog1.FileName;
    end;
  end;

  LSrcEngParameter := TEngineParameter.Create(nil);
  LDescDiffList := TStringList.Create;
  LNewAddrList := TStringList.Create;
  LDummyList := TStringList.Create;
  try
    LSQLRestClientURI := InitEngineParamClient2(LDBName, LSQLModel);
    try
      LEngParamList := GetEngParamList2JSONArrayFromSensorType(LSQLRestClientURI, stNull, True);
      LSrcEngParameter.LoadFromJSONArray(LEngParamList);

      for j := 0 to LSrcEngParameter.EngineParameterCollect.Count - 1 do
      begin
        LIsAddrExist := False;
        LSrcEngItem := LSrcEngParameter.EngineParameterCollect[j];

        for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
        begin
          LDestEngItem := FEngineParameter.EngineParameterCollect[i];

          if (LSrcEngItem.FCode = LDestEngItem.FCode) and
            (LSrcEngItem.Address = LDestEngItem.Address) then
          begin
            LIsAddrExist := True;

            if LSrcEngItem.Description <> LDestEngItem.Description then
            begin
              if AIsAdjustDummy then
              begin
                if LDestEngItem.Description = 'DUMMY' then
                begin
                  LDestEngItem.TagName := 'M_'+LSrcEngItem.Address;
                  LDestEngItem.Description := LSrcEngItem.Description;
                  LDestEngItem.Scale := LSrcEngItem.Scale;
                  LDestEngItem.AlarmKind4AVAT2 := LSrcEngItem.AlarmKind4AVAT2;
                  LDestEngItem.AlarmLimit4AVAT2 := LSrcEngItem.AlarmLimit4AVAT2;
                  LDestEngItem.LevelIndex := 2;//Dummy Field를 수정한 경우 2로 표시함

                  LDummyList.Add('('+LSrcEngItem.FCode+')'+
                    LSrcEngItem.Address);
                  LDummyList.Add('--------------------------------------------------');
                  LDummyList.Add('('+LSrcEngItem.Description+') ===>'+ #13#10 +
                    LDestEngItem.Description);
                  LDummyList.Add('--------------------------------------------------');
                end;
              end
              else
              begin
                if (LDestEngItem.Description <> 'DUMMY') and
                  (LDestEngItem.Description <> '') and (LDestEngItem.Description <> '...') then
                begin
                  LDestEngItem.Description := LSrcEngItem.Description;
                  LDestEngItem.Scale := LSrcEngItem.Scale;
                  LDestEngItem.AlarmKind4AVAT2 := LSrcEngItem.AlarmKind4AVAT2;
                  LDestEngItem.AlarmLimit4AVAT2 := LSrcEngItem.AlarmLimit4AVAT2;
                  LDestEngItem.LevelIndex := 3;//기존 주소의 Filed가 변경 되었을 경우 3으로 표시
                end;

                LDescDiffList.Add('('+LSrcEngItem.FCode+')'+
                  LSrcEngItem.Address);
                LDescDiffList.Add('--------------------------------------------------');
                LDescDiffList.Add('('+LSrcEngItem.Description+') ===>'+ #13#10 +
                  LDestEngItem.Description);
                LDescDiffList.Add('--------------------------------------------------');
              end;

              Break;
            end;
          end;
        end;//for i

        if AIsAdjustDummy then
        begin
        end
        else
        begin
          if not LIsAddrExist then
          begin
            AddNewAddrItem(LSrcEngItem);
            LNewAddrList.Add('('+LSrcEngItem.FCode + ')'+LSrcEngItem.Address+ ' ==>' + LSrcEngItem.Description);
          end;
        end;
      end;//for j
    finally
      LSQLModel.Free;
      LSQLRestClientURI.Free;
    end;

  finally
    if AIsAdjustDummy then
      LDummyList.SaveToFile('c:\temp\DummyList.txt')
    else
    begin
      LDescDiffList.SaveToFile('c:\temp\DescDiffList.txt');
      LNewAddrList.SaveToFile('c:\temp\NewAddrList.txt');
    end;

    LSrcEngParameter.Free;
    LDescDiffList.Free;
    LNewAddrList.Free;
    LDummyList.Free;

//    if AIsAdjustDummy then
      AddParameter2Grid(True);
  end;
end;

//AType: 0 = Hexa to Decimal
//       1 = Decimal to Hexa
procedure TForm1.ConnectDB;
begin
//  OraSession1.Username := 'TBACS';
//  OraSession1.Password := 'TBACS';
//  OraSession1.Server := '10.100.23.114:1521:TBACS';
//
//  if not OraSession1.Connected then
//    OraSession1.Connected := True;
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

procedure TForm1.CopyFieldsFromGridIndex1Click(Sender: TObject);
var
  i: integer;
begin
  i := CreateIntInputEditForm;
  CopyFieldsFromGridIndex2SelectedRow(i-1);
end;

procedure TForm1.CopyFieldsFromGridIndex2SelectedRow(AIdx: integer);
var
  LSrcEngItem, LDestEngItem, LTempEngItem: TEngineParameterItem;
  i, LSelectedCount: integer;
begin
  if AIdx > -1 then
  begin
    LTempEngItem := TEngineParameterItem.Create(nil);
    try
      LSrcEngItem := FEngineParameter.EngineParameterCollect[AIdx];
      LSelectedCount := NextGrid1.SelectedCount;

      for i := 0 to NextGrid1.RowCount - 1 do
      begin
        if NextGrid1.Row[i].Selected then
        begin
          LDestEngItem := FEngineParameter.EngineParameterCollect[i];

          LTempEngItem.Address := LDestEngItem.Address;
          LTempEngItem.TagName := LDestEngItem.TagName;
          LTempEngItem.Description := LDestEngItem.Description;
          LTempEngItem.Scale := LDestEngItem.Scale;
          LTempEngItem.AlarmKind4AVAT2 := LDestEngItem.AlarmKind4AVAT2;
          LTempEngItem.AlarmLimit4AVAT2 := LDestEngItem.AlarmLimit4AVAT2;

          LDestEngItem.Assign(LSrcEngItem);

          LDestEngItem.Address := LTempEngItem.Address;
          LDestEngItem.TagName := LTempEngItem.TagName;
          LDestEngItem.Description := LTempEngItem.Description;
          LDestEngItem.Scale := LTempEngItem.Scale;
          LDestEngItem.AlarmKind4AVAT2 := LTempEngItem.AlarmKind4AVAT2;
          LDestEngItem.AlarmLimit4AVAT2 := LTempEngItem.AlarmLimit4AVAT2;

          AddParamItem2Grid(i, LDestEngItem);
        end;
      end;
    finally
      LTempEngItem.Free;
    end;

  end;
end;

procedure TForm1.CopyFieldsFromTagName1Click(Sender: TObject);
var
  i: integer;
begin
   i := CreateIntInputEditForm;
   CopyFieldsFromGridIndex2SelectedRow(i-1);
end;

procedure TForm1.CopyRow1Click(Sender: TObject);
//var
//  LRow: TRow;
begin
  //LRow := NextGrid1.Row[NextGrid1.SelectedRow];
  //ClipBoard.Assign(LRow);
end;

procedure TForm1.CreateEPItemincfile1Click(Sender: TObject);
var
  LStr: string;
begin
  LStr := 'E:\pjh\project\util\HiMECS\Application\Source\Common\AssignEPItem.inc';

  if FEngineParameter.EngineParameterCollect.Count > 0 then
  begin
    CreatePersistentAssignFile(FEngineParameter.EngineParameterCollect.Items[0],
      LStr);
    ShowMessage('"' + LStr + '" is saved sucessfully!');
  end;
end;

procedure TForm1.TextFile_Open;
var
  li : integer; //loop count
  ls : integer; //

  LList : TStringList;
  LStr, LStr1 : String;
  LnxTextColumn: TnxTextColumn6;
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

        Columns.Add(TnxIncrementColumn6,'No.');
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
              LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,LStr1));
              LnxTextColumn.Name := LStr1;
//              LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
            end;
          end;//for

          if (li = 0) then
          begin
            LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'DataType'));
            LnxTextColumn.Name := 'DataType';
//            LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
            //LnxTextColumn := TnxTextColumn6(Columns.Add(TnxTextColumn6,'Unit'));
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
            LStr2 := CellBy['FCode', i].AsString;
            if LStr2 = '' then
            begin
              LStr := UpperCase(CellBy['Alarm', i].AsString);
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

            LevelIndex := CellBy['LevelIndex', i].AsInteger;
            NodeIndex := CellBy['NodeIndex', i].AsInteger;
            AbsoluteIndex := CellBy['AbsoluteIndex', i].AsInteger;
            MaxValue := CellBy['MaxValue', i].AsInteger;
            Contact := CellBy['Contact', i].AsInteger;
            SharedName := CellBy['SharedName', i].AsString;
            TagName := CellBy['TagName', i].AsString;
            Description := CellBy['Description', i].AsString;
            Address := CellBy['Address', i].AsString;
            FUnit := CellBy['FFUnit', i].AsString;
            SensorType := g_SensorType.ToType(CellBy['SensorType', i].AsString);
            ParameterCatetory :=String2ParameterCatetory(CellBy['ParameterCatetory', i].AsString);
            ParameterType :=String2ParameterType(CellBy['ParameterType', i].AsString);
            ParameterSource := String2ParameterSource(CellBy['ParameterSource', i].AsString);
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
            LStr2 := CellBy['FCode', i].AsString;
            if LStr2 = '' then
            begin
              LStr := UpperCase(CellBy['Alarm', i].AsString);
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

            LevelIndex := CellBy['LevelIndex', i].AsInteger;
            NodeIndex := CellBy['NodeIndex', i].AsInteger;
            AbsoluteIndex := CellBy['AbsoluteIndex', i].AsInteger;
            MaxValue := CellBy['MaxValue', i].AsInteger;
            Contact := CellBy['Contact', i].AsInteger;
            SharedName := CellBy['SharedName', i].AsString;
            TagName := CellBy['TagName', i].AsString;
            Description := CellBy['Description', i].AsString;
            Address := CellBy['Address', i].AsString;
            FFUnit := CellBy['FFUnit', i].AsString;
            SensorType := String2SensorType(CellBy['SensorType', i].AsString);
            ParameterCatetory :=String2ParameterCatetory(CellBy['ParameterCatetory', i].AsString);
            ParameterType :=String2ParameterType(CellBy['ParameterType', i].AsString);
            ParameterSource := String2ParameterSource(CellBy['ParameterSource', i].AsString);
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
  LSQLModel: TSQLModel;
  LSQLRestClientURI: TSQLRestClientURI;
begin
  OpenDialog1.Filter := 'Sqlite|*.sqlite';
  OpenDialog1.FileName := '';

  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      Caption := OpenDialog1.FileName;
      FEngineParameter.EngineParameterCollect.Clear;
      MakeGridData2Parameter2(True);
      TDocVariant.New(LDoc);
      LSQLRestClientURI := InitEngineParamClient2(OpenDialog1.FileName, LSQLModel);
      try
//      InitEngineParamClient('E:\pjh\project\util\HiMECS\Application\Bin\db\'+ENG_PARAM_DB_NAME);

        for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
        begin
          LoadRecordPropertyToVariant(FEngineParameter.EngineParameterCollect.Items[i], LDoc);
          AddOrUpdateEngParamRecFromVariant(LDoc,False,LSQLRestClientURI);
        end;
      finally
        LSQLModel.Free;
        LSQLRestClientURI.Free;
      end;
    end;
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
              NextGrid1.CellBy['NodeIndex', j].AsInteger :=
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
var
  LIsSqlite: Boolean;
  LExt: string;
begin
//  OpenDialog1.Filter := 'Engine Parameter|*.param';
  OpenDialog1.FileName := '';

  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      LExt := ExtractFileExt(OpenDialog1.FileName);
      LExt := UpperCase(LExt);
      LIsSqlite := (LExt = '.DB') or (LExt = '.DB3') or (LExt = '.SQLITE');

      AppendParameterFromFile(OpenDialog1.FileName);
      NextGrid1.ClearRows;

      AddParameter2Grid(LIsSqlite);
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
  FPM.Free;

  if Assigned(FEngParamSource) then
    FreeAndNil(FEngParamSource);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FEngineParameter := TEngineParameter.Create(Self);
  FEngParamSource := TEngineParameterDataFormat.Create(EngParamSource);
  FPM := TParameterManager.Create;

  NextInChain:=SetClipboardViewer(Handle);
  OurFormat:=RegisterClipboardFormat('CF_TClipBrdGridData');
  g_EngineUsage.InitArrayRecord(R_EngineUsage);
  g_AlarmKind4AVAT2.InitArrayRecord(R_AlarmKind4AVAT2);
  g_AlarmLimit4AVAT2.InitArrayRecord(R_AlarmLimit4AVAT2);
  g_ParameterCategory4AVAT2.InitArrayRecord(R_ParameterCategory4AVAT2);
  g_DFCommissioningItem.InitArrayRecord(R_DFCommissioningItem);
  g_AlarmKind4AVAT2Code.InitArrayRecord(R_AlarmKind4AVAT2Code);

  ClipStrList := TStringList.Create;
end;

function TForm1.GetCellColorFromLevelIndex(ARowIndex: integer; AIsReset: Boolean): TColor;
var
  LStr: string;
begin
  if AIsReset then
  begin
    Result := clWindow;
    exit;
  end;

  LStr := NextGrid1.CellBy['LevelIndex', ARowIndex].AsString;

  if LStr = '1' then//신규 추가인 경우 1로 표시함
    Result := clYellow
  else if LStr = '2' then//Dummy Field를 수정한 경우 2로 표시함
    Result := clLime
  else if LStr = '3' then//기존 주소의 Filed가 변경 되었을 경우 3으로 표시
    Result := clAqua
  else
    Result := clWindow;
end;

procedure TForm1.GetEngineTypeFromDB(ACombo: TComboBox);
var
  i: integer;
  LType: string;
begin
//  with Oraquery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('select * from HimsenInfo');
//    Open;
//
//    ACombo.Items.Clear;
//
//    if RecordCount > 0 then
//    begin
//      for i := 0 to RecordCount - 1 do
//      begin
//        LType := FieldByName('ProjNo').AsString + '-' + FieldByName('EngType').AsString;
//        ACombo.Items.Add(LType);
//        Next;
//      end;
//    end;
//  end;
end;

//AEngType: 공사번호(ex: YE0589)
function TForm1.GetMeasureTableFromDB(AEngType: string): string;
var
  i: integer;
  LType: string;
begin
  Result := '';

//  with Oraquery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('select * from HIMSEN_SS_TABLE_INFO where PROJNO = :EngType');
//    ParamByName('EngType').AsString := AEngType;
//    Open;
//
//    if RecordCount > 0 then
//    begin
//      Result := FieldByName('TABLENAME').AsString;
//    end;
//  end;
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
//  if OraSession1.Connected then
//  begin
//    OraQuery1.Close;
//    OraQuery1.SQL.Clear;
//    OraQuery1.SQL.Text := 'select * from HIMSEN_SS_META where TABLE_NAME = :tablename order by COLUMN_ID';
//    OraQuery1.ParamByName('tablename').AsString := ATableName;
//    OraQuery1.Open;
//
//    i := 0;
//
//    while not OraQuery1.Eof do
//    begin
//      if UpperCase(NextGrid1.Cells[6,i]) <> 'DUMMY' then
//        NextGrid1.Cells[6,i] := OraQuery1.FieldByName('TAGNAME').AsString;
//      inc(i);
//      OraQuery1.Next;
//    end;
//  end;
end;

function TForm1.GetTagNameFromGridIndex(ARowIndex: integer): string;
begin
  Result := NextGrid1.CellBy['TagName',ARowIndex].AsString;
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
        if ls <> CellBy['CNT', li].AsInteger then
        begin
          ls := CellBy['CNT', li].AsInteger;
          ll := -1;
        end;

        inc(ll);

        BlockNo := ls;
        AbsoluteIndex := ll; //TEventDataxxx 의 InpDataBuf[]의 Index
        TagName := CellBy['TAG_NAME', li].AsString;//Cells[1,li];
        Description := CellBy['DESCRIPT', li].AsString;//Cells[2,li];
        Address := CellBy['ADDR', li].AsString;//Cells[4,li];
        ParameterType := GetParamType(CellBy['DataType', li].AsString);//Cells[9,li]);
        //FFUnit := Cells[10,li];
        LAlarm := CellBy['ALARM', li].AsString;//Cells[6,li];

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
          MaxValue_real := CellBy['MAXVAL', li].AsFloat
        else
          MaxValue := CellBy['MAXVAL', li].AsInteger;

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
          LevelIndex := Ord(String2S7Area(CellBy['LevelIndex',li].AsString)); //Area
          AbsoluteIndex := Ord(String2S7DataType(CellBy['AbsoluteIndex',li].AsString));//Data Type
        end
        else
        begin
          LevelIndex := CellBy['LevelIndex',li].AsInteger;
          AbsoluteIndex := CellBy['AbsoluteIndex',li].AsInteger;
        end;

        NodeIndex := CellBy['NodeIndex',li].AsInteger;
        MaxValue := CellBy['MaxValue',li].AsInteger;
        Contact := CellBy['Contact',li].AsInteger;
        Description := CellBy['Description',li].AsString;
        Address := CellBy['Address',li].AsString;
        Alarm := CellBy['Alarm',li].AsBoolean;
        fcode := CellBy['FCode',li].AsString;
        FUnit := CellBy['FFUnit',li].AsString;
        SensorType := g_SensorType.ToType(CellBy['SensorType',li].AsString);
        //압력은 소수점 두자리 표시
        if SensorType = stmA then
          RadixPosition := 2;

        ParameterCatetory := String2ParameterCatetory(CellBy['ParameterCatetory',li].AsString);
        ParameterType := String2ParameterType(CellBy['ParameterType',li].AsString);
        ParameterSource := String2ParameterSource(CellBy['ParameterSource',li].AsString);

        if (TagName = '') and
          (SensorType = stCalculated) and
          (ParameterSource = psManualInput)then
          TagName := 'V_' + formatDateTime('yyyymmddhhnnss',now)
        else
          TagName := CellBy['TagName',li].AsString;

        SharedName := CellBy['SharedName',li].AsString;

        if Description = '' then
          Description := SharedName;

        BlockNo := StrToIntDef(CellBy['BlockNo',li].AsString,0);
        RadixPosition := StrToIntDef(CellBy['BitIndex',li].AsString,0);
        Value := CellBy['Value',li].AsString;
        LItem.AlarmEnable := StrToBoolDef(CellBy['AlarmEnable',li].AsString, False);
        ProjNo := CellBy['ProjNo',li].AsString;
        EngNo := CellBy['EngNo',li].AsString;

        if AIsSqlite then
        begin
          ParameterCatetory4AVAT2 := g_ParameterCategory4AVAT2.ToType(CellBy['ParameterCatetory4AVAT2', li].AsString);
          DFCommissioningItem := g_DFCommissioningItem.toType(CellBy['DFCommissioningItem', li].AsString);
          DFAlarmKind := g_DFAlarmKind.ToType(CellBy['DFAlarmKind', li].AsString);
          EngineUsage := g_EngineUsage.ToType(CellBy['EngineUsage', li].AsString);
          ParamNo := CellBy['ParamNo', li].AsString;
          Description_Eng := CellBy['Description_Eng', li].AsString;
          Description_Kor := CellBy['Description_Kor', li].AsString;
          Scale := CellBy['Scale', li].AsString;
          AlarmKind4AVAT2 := g_AlarmKind4AVAT2.ToType(CellBy['AlarmKind', li].AsString);
          AlarmLimit4AVAT2 := g_AlarmLimit4AVAT2.ToType(CellBy['AlarmLimit', li].AsString);
        end;

        if LItem.IsMatrixData then
        begin
          MatrixItemIndex := CellBy['NodeIndex',li].AsInteger;
          XAxisSize := CellBy['MaxValue',li].AsInteger;
          YAxisSize := CellBy['Contact',li].AsInteger;
          ZAxisSize := CellBy['LevelIndex',li].AsInteger; //Area
        end;
      end;//with
    end;//for
  end;//with
end;

procedure TForm1.MakeTagNameFromAddress;
var
  i: integer;
  LStr: string;
begin
  NextGrid1.BeginUpdate;
  try
    for i := 0 to NextGrid1.RowCount - 1 do
    begin
      LStr := NextGrid1.CellBy['TagName',i].AsString;

      if LStr = '' then
      begin
        LStr := NextGrid1.CellBy['SensorType',i].AsString;

        if g_SensorType.ToType(LStr) = stParam then
          LStr := 'P_'
        else
          LStr := 'A';

        NextGrid1.CellBy['TagName',i].AsString := LStr + NextGrid1.CellBy['Address',i].AsString;
      end;
    end;
  finally
    NextGrid1.EndUpdate;
  end;
end;

procedure TForm1.N11Click(Sender: TObject);
var
  r,c,i,v: integer;
begin
  c := NextGrid1.SelectedCol;
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
  c := NextGrid1.SelectedCol;

  for r := 1 to NextGrid1.RowCount - 1 do
  begin
    NextGrid1.Cell[c,r].AsString := NextGrid1.Cell[c,0].AsString;
  end;
end;

procedure TForm1.N3Click(Sender: TObject);
var
  r,c,i: integer;
begin
  c := NextGrid1.SelectedCol;
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
//var
//  LRect: TRect;
begin
//  LRect := NextGrid1.Cell.;
//
//  if PtInRect(LRect, FMousePoint) then
//    exit;

  if NextGrid1.CheckCell(ACol,ARow) then
    ShowProperties;
end;

procedure TForm1.NextGrid1EditEnter(Sender: TObject; ACol, ARow: Integer);
begin
  FNextGridEditMode := True;
end;

procedure TForm1.NextGrid1EditExit(Sender: TObject; ACol, ARow: Integer);
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

procedure TForm1.NextGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  LEngineParameterItem: TEngineParameterItem;
  LRect: TRect;
  LPoint: TPoint;
  LEPD: TEngineParameter_DragDrop;
begin
  LRect := NxReportGridView61.HeaderRect;
  LPoint.X := X;
  LPoint.Y := Y;
  if PtInRect(LRect, LPoint) then
    exit;

  if NextGrid1.SelectedCount > 0 then
  begin
    if (DragDetectPlus(TWinControl(Sender).Handle, Point(X,Y))) then
    begin
      LEPD.FEPItem := Default(TEngineParameterItemRecord);

      if NextGrid1.SelectedCount = 1 then
      begin
        if FEngineParameter.EngineParameterCollect.Count >= NextGrid1.SelectedRow then
        begin
          LEngineParameterItem := FEngineParameter.EngineParameterCollect.Items[NextGrid1.SelectedRow];
          LEngineParameterItem.AssignTo(LEPD.FEPItem);
          LEPD.FDragDataType := dddtSingleRecord;
          LEPD.FShiftState := Shift;//FKeyBdShiftState;
          FEngParamSource.EPD := LEPD;
          EngParamSource.Execute;
        end;
      end
      else
      begin
        LEPD.FSourceHandle := Handle;
        LEPD.FShiftState := Shift;//FKeyBdShiftState;
        LEPD.FDragDataType := dddtMultiRecord;
        FEngParamSource.EPD := LEPD;
        EngParamSource.Execute;
      end;
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
  LRow: INxCellsRow;
  xlRowCount, xlColCount,
  i,j,s : Integer;
  lColumn, range : string;
begin
  OpenDialog1.Filter := 'Excel File|*.xls|ExcelX File|*.xlsx|All Files|*.*';
  RGModeSelect.ItemIndex := 4;

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
          AddGridColumn4Parameter(RGModeSelect.ItemIndex = 4);

          for i := 2 to xlRowCount do
          begin
            LRow := AddRow;
            for j := 1 to xlColCount do
            begin
              lColumn := Chr(ldec+j);
              range := lColumn + IntToStr(i);
              XL.Range[range].Select;
//              XL.ActiveCell.FormulaR1C1 := Columns.Item[i].Header.Caption;
              Cells[j,LRow.Index] := XL.ActiveCell.FormulaR1C1;
              if Cells[j,LRow.Index] = '' then
                Cells[j,LRow.Index] := '0';
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

procedure TForm1.OpenFromExcelofDFA2LM1Click(Sender: TObject);
begin
  OpenModbusDataFromExcel2;
end;

procedure TForm1.OpenFromExcelofMap1Click(Sender: TObject);
begin
  OpenModbusDataFromExcel();
end;

//HiMECS-DF-A2_Modbus address.xls파일은 Sheet를
//"Input Register", "Holding Register", "Input Status", "Input Coil" 순으로 배치한다
//각 Sheet의 Adress 시작 행을 5로 맞춘 후 아래 함수를 실행 할 것
function TForm1.OpenModbusDataFromExcel: integer;
var
  XL, oWB, oSheet, oRng : variant;
  LRow: INxCellsRow;
  xlRowCount, xlColCount,
  i,j,s, LSheetCount : Integer;
  lColumn, range, LStr : string;
begin
  OpenDialog1.Filter := 'Excel File|*.xls|ExcelX File|*.xlsx|All Files|*.*';
  RGModeSelect.ItemIndex := 4;

  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName = '' then
      exit;

    XL := CreateOleObject('Excel.Application');
    XL.DisplayAlerts := False;
    XL.visible := False;
    try
      oWB := XL.WorkBooks.Add(OpenDialog1.FileName);
      LSheetCount := oWB.Sheets.Count;

      with NextGrid1 do
      begin
        BeginUpdate;

        try
          AddGridColumn4Parameter(RGModeSelect.ItemIndex = 4);

          for s := 1 to LSheetCount do
          begin
            oSheet := oWB.WorkSheets[s];
            oSheet.Select;

            xlRowCount := oSheet.UsedRange.Rows.Count;
            xlColCount := oSheet.UsedRange.Columns.Count;

            for i := 5 to xlRowCount do
            begin
              LRow := AddRow;

              for j := 1 to 5 do //Column No
              begin
                lColumn := Chr(64+j);
                range := lColumn + IntToStr(i);
                XL.Range[range].Select;

                case j of
                  1: begin
                    LStr := XL.ActiveCell.FormulaR1C1;  //Address

                    if not StrIsNumeric(LStr) then
                    begin
                      DeleteLastRow();
                      Break;
                    end;

                    Cells[8,LRow.Index] := Copy(LStr,2,4);//address
                  end;
                  2: begin
                    if s = 3 then //Input Status Sheet
                    begin
                      Cells[24,LRow.Index] := XL.ActiveCell.FormulaR1C1;//AlarmKind4AVAT2
                    end
                    else
                      Cells[7,LRow.Index] := XL.ActiveCell.FormulaR1C1;//Description
                  end;
                  3: begin
                    if s = 1 then//Input Register Sheet
                    begin
                      Cells[11,LRow.Index] := XL.ActiveCell.FormulaR1C1;//FUnit
                    end
                    else if s = 3 then //Input Status Sheet
                    begin
                      Cells[7,LRow.Index] := XL.ActiveCell.FormulaR1C1;//Description
                    end
                    else if s = 4 then //Input Coil
                    begin
                       //Timeout
                    end;
                  end;
                  4: begin
                    if s = 1 then//Input Register Sheet
                    begin
                      Cells[23,LRow.Index] := XL.ActiveCell.FormulaR1C1;//Scale
                    end
                    else if s = 3 then //Input Status Sheet
                    begin
                      Cells[25,LRow.Index] := XL.ActiveCell.FormulaR1C1;//AlarmLimit4AVAT2
                    end;
                  end;
                  5: begin
                    if s = 3 then //Input Status Sheet
                    begin
                      LStr := XL.ActiveCell.FormulaR1C1;

                      if LStr <> '' then
                        Cells[25,LRow.Index] := LStr;//AlarmLimit4AVAT2-Sensor failure
                    end;
                  end;
                end;//case j

                case s of
                  1: begin//Input Register Sheet
                    Cells[9,LRow.Index] := 'TRUE';//Alarm (Analog)
                    Cells[10,LRow.Index] := '4';//Function Code
                  end;
                  2: begin//Holding Register Sheet
                    Cells[9,LRow.Index] := 'TRUE';//Alarm (Analog)
                    Cells[10,LRow.Index] := '3';//Function Code
                  end;
                  3: begin//Input Status Sheet
                    Cells[9,LRow.Index] := 'FALSE';//Alarm (Analog)
                    Cells[10,LRow.Index] := '2';//Function Code
                  end;
                  4: begin//Input Coil Sheet
                    Cells[9,LRow.Index] := 'FALSE';//Alarm (Analog)
                    Cells[10,LRow.Index] := '1';//Function Code
                  end;
                end;

//                if Cells[j,LRow.Index] = '' then
//                  Cells[j,LRow.Index] := '0';
              end;
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

function TForm1.OpenModbusDataFromExcel2: integer;
var
  XL, oWB, oSheet, oRng : variant;
  LRow: INxCellsRow;
  xlRowCount, xlColCount,
  i,j,s, LSheetCount, LRowStart, LColCount : Integer;
  lColumn, range, LStr, LFirstCol, LAddressHead, LFilterCol : string;
begin
  OpenDialog1.Filter := 'Excel File|*.xls|ExcelX File|*.xlsx|All Files|*.*';
  RGModeSelect.ItemIndex := 4;

  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName = '' then
      exit;

    XL := CreateOleObject('Excel.Application');
    XL.DisplayAlerts := False;
    XL.visible := False;
    try
      oWB := XL.WorkBooks.Add(OpenDialog1.FileName);
      LSheetCount := oWB.Sheets.Count;

      with NextGrid1 do
      begin
        BeginUpdate;

        try
          AddGridColumn4Parameter(RGModeSelect.ItemIndex = 4);

          for s := LSheetCount downto 1 do
          begin
            oSheet := oWB.WorkSheets[s];

            if oSheet.Visible then
//            begin
//              ShowMessage(oSheet.Name);
              oSheet.Select;
//            end;

            if not ((oSheet.Name = 'MSG') or (oSheet.Name = 'DI') or (oSheet.Name = 'AI')) then
              continue;

            xlRowCount := oSheet.UsedRange.Rows.Count;
            xlColCount := oSheet.UsedRange.Columns.Count;

            if oSheet.Name = 'MSG' then
            begin
              LRowStart := 3;
              LFirstCol := 'A';
              LFilterCol := 'A';
            end
            else
            if oSheet.Name = 'DI' then
            begin
              LRowStart := 6;
              LFirstCol := 'E';
              LFilterCol := 'E';
            end
            else
            if oSheet.Name = 'AI' then
            begin
              LRowStart := 5;
              LFirstCol := 'B';
              LFilterCol := 'B';
              LColCount := 8;
            end;

            for i := LRowStart to xlRowCount do
            begin
              range := LFilterCol + IntToStr(i);
              XL.Range[range].Select;
              LStr := XL.ActiveCell.FormulaR1C1;  //Filter Column

//              if oSheet.Name = 'MSG' then
//              begin
//                if LStr <> '' then
//                  Continue;
//              end
//              else
//              if oSheet.Name = 'DI' then
//              begin
//                if (SysUtils.UpperCase(LStr) = 'C') or ((SysUtils.UpperCase(LStr) = 'X'))then
//                  Continue;
//              end
//              else
//              if oSheet.Name = 'AI' then
//              begin
//                if LStr <> '' then
//                  Continue;
//              end;

              LRow := AddRow;

              for j := 1 to LColCount do //Column No
              begin
                lColumn := Chr(Ord(LFirstCol[1])+j);
                range := lColumn + IntToStr(i);
                XL.Range[range].Select;
                LStr := XL.ActiveCell.FormulaR1C1;  //Address

                case j of
                  1: begin
                    if not StrIsNumeric(LStr) then
                    begin
                      DeleteLastRow();
                      Break;
                    end;

                    Cells[8,LRow.Index] := Copy(LStr,2,4);//address
                    LAddressHead := Copy(LStr,1,1); //Adddress의 첫문자로 Function code 판단하기 위함
                  end;
                  2: begin
                    case StrToIntDef(LAddressHead,0) of
                      1: begin//Read discrete inputs(DI/MSG)
                        if oSheet.Name = 'DI' then
                        begin
                          CellBy['AlarmKind',LRow.Index].AsString := LStr;//AlarmKind4AVAT2
                        end
                        else
                        if oSheet.Name = 'MSG' then
                        begin
                          CellBy['AlarmKind',LRow.Index].AsString := g_AlarmKind4AVAT2Code.ToString(g_AlarmKind4AVAT2.ToType(LStr));//AlarmKind4AVAT2
                        end;
                      end;
                      2: begin
                      end;
                      3: begin//Read input register(AI)
                        CellBy['TagName',LRow.Index].AsString := LStr;//TagName
                      end;
                      4: begin//Read holding register
                      end;
                    end;
                  end;
                  3: begin
                    case StrToIntDef(LAddressHead,0) of
                      1: begin//Read discrete inputs(DI/MSG)
                        if oSheet.Name = 'DI' then
                        begin
                          CellBy['Description',LRow.Index].AsString := LStr;//Description
                        end
                        else
                        if oSheet.Name = 'MSG' then
                        begin
                          CellBy['Description',LRow.Index].AsString := LStr;//Description
                        end;
                      end;
                      2: begin
                      end;
                      3: begin//Read input register(AI)
                        CellBy['Description',LRow.Index].AsString := LStr;//Description
                      end;
                      4: begin//Read holding register
                      end;
                    end;
                  end;
                  4: begin
                    case StrToIntDef(LAddressHead,0) of
                      1: begin//Read discrete inputs(DI/MSG)
                        if oSheet.Name = 'DI' then
                        begin
                          CellBy['TagName',LRow.Index].AsString := LStr;//TagName
                        end;
                      end;
                      2: begin
                      end;
                      3: begin//Read input register(AI)
                        CellBy['FFUnit',LRow.Index].AsString := LStr;//FFUnit
                      end;
                      4: begin//Read holding register
                      end;
                    end;
                  end;
                  5: begin
                    case StrToIntDef(LAddressHead,0) of
                      1: begin//Read discrete inputs(DI/MSG)
                      end;
                      2: begin
                      end;
                      3: begin//Read input register(AI)
                        CellBy['Scale',LRow.Index].AsString := LStr;//Scale
                      end;
                      4: begin//Read holding register
                      end;
                    end;
                  end;
                  6: begin
                    case StrToIntDef(LAddressHead,0) of
                      1: begin//Read discrete inputs(DI/MSG)
                      end;
                      2: begin
                      end;
                      3: begin//Read input register(AI)-Failure Value
                      end;
                      4: begin//Read holding register
                      end;
                    end;
                  end;
                  7: begin
                    case StrToIntDef(LAddressHead,0) of
                      1: begin//Read discrete inputs(DI/MSG)
                        if oSheet.Name = 'MSG' then
                        begin
                          CellBy['AlarmLimit',LRow.Index].AsString := LStr;//AlarmLimit
                        end;
                      end;
                      2: begin
                      end;
                      3: begin//Read input register(AI)-Range
                      end;
                      4: begin//Read holding register
                      end;
                    end;
                  end;
                  8: begin
                    case StrToIntDef(LAddressHead,0) of
                      1: begin//Read discrete inputs(DI/MSG)
                        if oSheet.Name = 'MSG' then
                        begin
                          CellBy['AlarmLimit',LRow.Index].AsString := LStr;//AlarmLimit
                        end;
                      end;
                      2: begin
                      end;
                      3: begin//Read input register(AI)-Remark
                      end;
                      4: begin//Read holding register
                      end;
                    end;
                  end;
                end;//case j

                case StrToIntDef(LAddressHead,0) of
                  1: begin//Reak discrete inputs
                    Cells[9,LRow.Index] := 'FALSE';//Alarm (Analog)
                    Cells[10,LRow.Index] := '2';//Function Code
                  end;
                  2: begin
                  end;
                  3: begin//Read input register
                    Cells[9,LRow.Index] := 'TRUE';//Alarm (Analog)
                    Cells[10,LRow.Index] := '4';//Function Code
                  end;
                  4: begin//Read holding register
                    Cells[9,LRow.Index] := 'TRUE';//Alarm (Analog)
                    Cells[10,LRow.Index] := '3';//Function Code
                  end;
                end;

//                if Cells[j,LRow.Index] = '' then
//                  Cells[j,LRow.Index] := '0';
              end;
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

procedure TForm1.ParamNoFilterEditChange(Sender: TObject);
var
  LnxTextColumn: TnxTextColumn6;
begin
  LnxTextColumn := TnxTextColumn6(NextGrid1.Columns.ItemBy['ParamNo']);
  LnxTextColumn.Filter := ParamNoFilterEdit.Text;
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

procedure TForm1.Properties1Click(Sender: TObject);
begin
  if NextGrid1.CheckCell(NextGrid1.SelectedCol, NextGrid1.SelectedRow) then
    ShowProperties;
end;

procedure TForm1.RemoveDummy;
var
  i: integer;
begin
  NextGrid1.BeginUpdate;

  try
    for i := NextGrid1.RowCount - 1 downto 0 do
    begin
      if UpperCase(NextGrid1.CellBy['TagName',i].AsString) = 'DUMMY' then
        NextGrid1.DeleteRow(i);
    end;
  finally
    NextGrid1.EndUpdate;
  end;
end;

procedure TForm1.ResetCellColorFromLevelIndex1Click(Sender: TObject);
begin
  SetRowColorFromLevelIndex(True);
end;

procedure TForm1.ResetCellColorFromLevelIndex2Click(Sender: TObject);
begin
  SetRowColorFromLevelIndex(False);
end;

procedure TForm1.SetRowColorFromLevelIndex(AIsReset: Boolean);
var
  i: integer;
  LColor: TColor;
begin
  with NextGrid1 do
  begin
    BeginUpdate;
    try
      for i := 0 to RowCount-1 do
      begin
        ChangeRowColorFromLevelIndex(i, AIsReset);
      end;//for
    finally
      EndUpdate;
    end;
  end;//with
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

      NextGrid1.Serialize.SeparatorChar := ',';
      NextGrid1.Serialize.MultiLineChar := #13;
      NextGrid1.Serialize.SaveToCSV(SaveDialog2.FileName);
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

procedure TForm1.SetCellColorFromAddress1Click(Sender: TObject);
begin
  CheckAddressAscending;
end;

procedure TForm1.SetConfigEngParamItemData(AIndex: Integer; AIsNew: Boolean);
var
  ConfigData: TEngParamItemConfigForm;
  LEngineParameterItem: TEngineParameterItem;
begin
  ConfigData := nil;
  ConfigData := TEngParamItemConfigForm.Create(Self);

  try
    with ConfigData do
    begin
      if AIsNew then
        LEngineParameterItem := FEngineParameter.EngineParameterCollect.Insert(AIndex)
      else
      begin
        LEngineParameterItem := FEngineParameter.EngineParameterCollect.Items[AIndex];
        LoadConfigEngParamItem2Form(LEngineParameterItem);
      end;

      if ShowModal = mrOK then
      begin
        LoadConfigForm2EngParamItem(LEngineParameterItem);
        AddParamItem2Grid(AIndex, LEngineParameterItem);

        if LEngineParameterItem.ParameterSource = psManualInput then
          NextGrid1.CellBy['Value', AIndex].AsString := LEngineParameterItem.Value;

        if LEngineParameterItem.SensorType = stCalculated then
          NextGrid1.CellBy['Description', AIndex].AsString := LEngineParameterItem.Description;
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

procedure TForm1.SetParamCatetoryFromDesc;
var
  i: integer;
  LFC, LDesc: string;
  LParamCategory: TParameterCategory;
begin
  NextGrid1.BeginUpdate;
  try
    for i := 0 to NextGrid1.RowCount - 1 do
    begin
      LFC := NextGrid1.CellBy['FCode',i].AsString;
      LDesc := NextGrid1.CellBy['Description',i].AsString;
      LParamCategory := GetParamCatetoryFromDesc(LFC, LDesc);
      NextGrid1.CellBy['ParameterCatetory',i].AsString := ParameterCatetory2String(LParamCategory);
    end;
  finally
    NextGrid1.EndUpdate;
  end;

end;

procedure TForm1.SetParameterCatetorybyDersc1Click(Sender: TObject);
begin
  SetParamCatetoryFromDesc();
end;

procedure TForm1.ShowProperties;
var
  Li: integer;
  LIsNew: Boolean;
begin
  if NextGrid1.SelectedCount > 1 then
  begin
    ShowMessage('This function allows when selected only one row!');
    exit;
  end;

  LIsNew := False;

  if NextGrid1.SelectedCount = 1 then
  begin
    Li := NextGrid1.SelectedRow;

    if GetTagNameFromGridIndex(Li) = '' then
    begin
      LIsNew := True;
    end
    else
    begin
      if Li > FEngineParameter.EngineParameterCollect.Count - 1 then
      begin
        ShowMessage('Selected Row Index is greater than Parameter Collect Index');
        exit;
      end;
    end;

    SetConfigEngParamItemData(Li, LIsNew);
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

//      InitEngineParamClient('E:\pjh\project\util\HiMECS\Application\Bin\db\'+ENG_PARAM_DB_NAME);
      InitEngineParamClient(OpenDialog1.FileName);
      LEngParamList := GetEngParamList2JSONArrayFromSensorType(g_EngineParamDB, stNull, True);
      FEngineParameter.LoadFromJSONArray(LEngParamList);

      AddGridColumn4Parameter(True);
      AddParameter2Grid(True);
    end;
  end;
end;

end.

