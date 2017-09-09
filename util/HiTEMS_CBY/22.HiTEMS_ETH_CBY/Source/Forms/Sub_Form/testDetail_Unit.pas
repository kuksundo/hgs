unit testDetail_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvPageControl, Vcl.ComCtrls,
  NxCollection, NxColumnClasses, NxColumns, NxScrollControl,Ora,DB,
  NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, AdvObj, BaseGrid, AdvGrid, GradientLabel, AdvOfficeStatusBar,
  DBAdvGrid, JvExStdCtrls, JvEdit, DBAccess, MemDS, OraSmart, NxDBGrid,
  Vcl.ImgList, tmsAdvGridExcel, Vcl.DBGrids, System.Generics.Collections,
  StrUtils;
type
  TExportThread = class(TThread)
    procedure Execute; Override;
  end;

type
  TtestDetail_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    AdvPageControl1: TAdvPageControl;
    AdvTabSheet1: TAdvTabSheet;
    AdvTabSheet2: TAdvTabSheet;
    AdvTabSheet3: TAdvTabSheet;
    AdvTabSheet4: TAdvTabSheet;
    GradientLabel1: TGradientLabel;
    op_fip: TAdvStringGrid;
    GradientLabel2: TGradientLabel;
    op_fiv: TAdvStringGrid;
    OILGRID: TAdvStringGrid;
    GradientLabel3: TGradientLabel;
    mbGrid: TAdvStringGrid;
    GradientLabel4: TGradientLabel;
    Label1: TLabel;
    Panel2: TPanel;
    Button10: TButton;
    Panel1: TPanel;
    Button3: TButton;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    Panel3: TPanel;
    engType: TJvEdit;
    crGrid: TAdvStringGrid;
    Panel4: TPanel;
    Button1: TButton;
    Label2: TLabel;
    OraDataSource1: TOraDataSource;
    OraQuery1: TOraQuery;
    OraQuery2: TOraQuery;
    OraDataSource2: TOraDataSource;
    Button4: TButton;
    Button5: TButton;
    ImageList1: TImageList;
    Button2: TButton;
    Button6: TButton;
    AdvGridExcelIO1: TAdvGridExcelIO;
    SaveDialog1: TSaveDialog;
    Label3: TLabel;
    DBGrid2: TDBGrid;
    DBGrid1: TDBGrid;
    procedure op_fipCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure op_fipGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure op_fipKeyPress(Sender: TObject; var Key: Char);
    procedure op_fivCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure op_fivGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure op_fivKeyPress(Sender: TObject; var Key: Char);
    procedure mbGridCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure mbGridGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure mbGridKeyPress(Sender: TObject; var Key: Char);
    procedure crGridCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure crGridGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure crGridKeyPress(Sender: TObject; var Key: Char);
    procedure OILGRIDCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure OILGRIDGetEditorProp(Sender: TObject; ACol, ARow: Integer;
      AEditLink: TEditLink);
    procedure OILGRIDGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure OILGRIDKeyPress(Sender: TObject; var Key: Char);
    procedure OILGRIDSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure op_fipSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure op_fivSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure mbGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure crGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBAdvGrid1GetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure DBAdvGrid2GetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure op_fivGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    FxRow,FxCol : Integer;
    FHeaders : TDictionary<String,String>;
    FExportThread : TExportThread;

  public
    { Public declarations }
    FCurrentProjNo,
    FCurrentEngType,
    FCurrentTestNo : String;
    FTestStart,
    FTestEnd : String;

    procedure Set_spec_Table(aEngType:String);
    procedure Init_;

    procedure Save_HITEMS_ETH_FIE(aTestNo:String);
    procedure Save_HITEMS_ETH_BEARING(aTestNo:String);
    procedure Save_HITEMS_ETH_USEDOIL(aTestNo:String);

    procedure Load_Measure_Data(aTestNo:String);
    procedure Load_HITEMS_ETH_LDS(aTestNo,aProjNo : String);
    procedure Load_HITEMS_ETH_FIE(aTestNo:String);
    procedure Load_HITEMS_ETH_BEARING(aTestNo:String);
    procedure Load_HITEMS_ETH_USEDOIL(aTestNo:String);

    function Return_Code_Name(aCode:Double) : String;
    function Return_Code_(aCodeName: String): String;


    procedure Get_Table_Header(aDBGrid:TDBGrid);


    procedure to_Excel(aGrid:String);

  end;

var
  testDetail_Frm: TtestDetail_Frm;
  procedure Create_testDetail_Frm(aCaption,aEngType,aTestNo:String);



implementation
uses
  HiTEMS_ETH_COMMON,
  progress_Unit,
  analysis_Unit,
  DataModule_Unit;

{$R *.dfm}

{ TtestDetail_Frm }

procedure Create_testDetail_Frm(aCaption,aEngType,aTestNo:String);
var
  li : integer;
begin
  testDetail_Frm := TtestDetail_Frm.Create(Application);
  try
    with testDetail_Frm do
    begin
      Caption := aCaption;
      FCurrentTestNo := aTestNo;
      engType.Text := aEngType;
      if engType.Text <> '' then
      begin
        li := pos('-',engType.Text);
        FCurrentProjNo := Copy(engType.Text,0,li-1);
        FCurrentEngType  := Copy(engType.Text,li+1,Length(engType.Text)-li);
      end;

      Init_;

      Show;

    end;

  finally
//    FreeAndNil(testDetail_Frm);
  end;
end;

procedure TtestDetail_Frm.Button10Click(Sender: TObject);
begin
  Load_HITEMS_ETH_LDS(FCurrentTestNo,FCurrentProjNo);
end;

procedure TtestDetail_Frm.Button1Click(Sender: TObject);
begin
  DM1.OraTransaction1.StartTransaction;
  try
    Save_HITEMS_ETH_USEDOIL(FCurrentTestNo);

    DM1.OraTransaction1.Commit;
    ShowMessage('유류정보 저장 성공!');
  except
    DM1.OraTransaction1.Rollback;
  end;
end;

procedure TtestDetail_Frm.Button2Click(Sender: TObject);
begin
  to_Excel('DBAdvGrid1');
end;

procedure TtestDetail_Frm.Button3Click(Sender: TObject);
begin
  DM1.OraTransaction1.StartTransaction;
  try
    Save_HITEMS_ETH_FIE(FCurrentTestNo);
    Save_HITEMS_ETH_BEARING(FCurrentTestNo);

    DM1.OraTransaction1.Commit;
    ShowMessage('세부사항 저장 성공!');
  except
    DM1.OraTransaction1.Rollback;
  end;
end;

procedure TtestDetail_Frm.Button5Click(Sender: TObject);
var
  LForm : Tanalysis_Frm;
begin
  LForm := Tanalysis_Frm.Create(Self);
  with LForm do
  begin
    FOwner := Self;
    FProjNo := Self.FCurrentProjNo;
    Set_trend_Parameters;
    Show;

  end;
end;

procedure TtestDetail_Frm.Button6Click(Sender: TObject);
begin
  to_Excel('DBAdvGrid2');
end;

procedure TtestDetail_Frm.crGridCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if (ARow > 0) and (ACol > 0) then
    CanEdit := True
  else
    CanEdit := False;
end;

procedure TtestDetail_Frm.crGridGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if (ACol > 0) and (ARow > 0) then
    AEditor := edNormal;
end;

procedure TtestDetail_Frm.crGridKeyPress(Sender: TObject; var Key: Char);
var
  lRow,lCol : Integer;
  lNext : Integer;
begin
  if key = #$D then
  begin
    lRow := FxRow;
    lCol := FxCol;
    with crGrid do
    begin
      if (lRow > 0) and (lCol > 0) then
      begin
        lCol := lCol+1;
        if lCol > ColCount-1 then
        begin
          lCol := 1;
          lRow := lRow+1;

          if lRow > RowCount-1 then
            lRow := 1;
        end;
        SelectRange(lCol,lCol,lRow,lRow);
        SetFocus;
      end;
    end;
  end;
end;

procedure TtestDetail_Frm.crGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  FxRow := ARow;
  FxCol := ACol;
end;

procedure TtestDetail_Frm.DBAdvGrid1GetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TtestDetail_Frm.DBAdvGrid2GetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TtestDetail_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FHeaders) then
    FHeaders.Free;

  if Assigned(testDetail_Frm) then
    FreeAndNil(testDetail_Frm);

end;

procedure TtestDetail_Frm.FormCreate(Sender: TObject);
begin
  FHeaders := TDictionary<String,String>.Create;


end;

procedure TtestDetail_Frm.Get_Table_Header(aDBGrid: TDBGrid);
var
  OraQuery : TOraQuery;
  lTable : String;
  li : Integer;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    OraQuery.FetchAll := True;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TBACS.HITEMS_MON_STANDARD ' +
              'WHERE ENG_PROJNO = :param1 ');
      ParamByName('param1').AsString := FCurrentProjNo;
      Open;

      if not(RecordCount = 0) then
        lTable := FieldByName('TABLE_NAME').AsString;

      if not(lTable = '') then
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.COLUMN_NAME, COMMENTS FROM ALL_TAB_COLUMNS A, ALL_COL_COMMENTS B ' +
                'WHERE A.OWNER = B.OWNER ' +
                'AND A.TABLE_NAME = B.TABLE_NAME ' +
                'AND A.COLUMN_NAME = B.COLUMN_NAME ' +
                'AND A.TABLE_NAME = :param1 ' +
                'ORDER BY A.COLUMN_ID ');
        ParamByName('param1').AsString := lTable;
        Open;

        if RecordCount <> 0 then
        begin
          FHeaders.Clear;
          while not eof do
          begin
            FHeaders.Add(FieldByName('COLUMN_NAME').AsString,FieldByName('COMMENTS').AsString);
            Next;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtestDetail_Frm.Init_;
var
  litem : TStringList;
begin
  AdvPageControl1.ActivePageIndex := 0;

  Set_spec_Table(FCurrentEngType);

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM HITEMS_ETH_HISTORY ' +
            'WHERE TEST_NO = '+FCurrentTestNo);
    Open;

    if not(RecordCount = 0) then
    begin
      FTestStart := FormatDateTime('YYYY-MM-DD HH:mm', FieldByName('T_RST_BEGIN').AsDateTime);
      FTestEnd   := FormatDateTime('YYYY-MM-DD HH:mm', FieldByName('T_RST_END').AsDateTime);
      Label2.Caption := '시험기간 : '+FTestStart+' ~ '+FTestEnd;
    end
    else
    begin
      Label2.Caption := '시험기간 : ';
    end;
  end;

  Load_Measure_Data(FCurrentTestNo);
  Load_HITEMS_ETH_LDS(FCurrentTestNo,FCurrentProjNo);
  Load_HITEMS_ETH_FIE(FCurrentTestNo);
  Load_HITEMS_ETH_BEARING(FCurrentTestNo);
  Load_HITEMS_ETH_USEDOIL(FCurrentTestNo);
end;

procedure TtestDetail_Frm.Load_HITEMS_ETH_BEARING(aTestNo: String);
var
  li,le : integer;
begin
  with mbGrid do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HITEMS_ETH_BEARING ' +
                'where TEST_NO = :param1 '+
                'and FLAG = :param2 '+
                'order by BEARINGNUM');
        ParamByName('param1').AsString := aTestNo;
        ParamByName('param2').AsString := 'MB';
        Open;

        if not(RecordCount = 0) then
        begin
          for le := 0 to RecordCount-1 do
          begin
            Cells[le+1,1] := Fieldbyname('MAKER').AsString;
            Cells[le+1,1] := Fieldbyname('TYPE').AsString;
            Cells[le+1,1] := Fieldbyname('SERIAL').AsString;
            Cells[le+1,1] := Fieldbyname('PARTNUM').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;

  with crGrid do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_TEST_BEARING ' +
                'where TEST_NO = :param1 '+
                'and FLAG = :param2 '+
                'order by BEARINGNUM');
        ParamByName('param1').AsString := aTestNo;
        ParamByName('param2').AsString := 'CR';
        Open;

        if not(RecordCount = 0) then
        begin
          for le := 0 to RecordCount-1 do
          begin
            Cells[le+1,1] := Fieldbyname('MAKER').AsString;
            Cells[le+1,1] := Fieldbyname('TYPE').AsString;
            Cells[le+1,1] := Fieldbyname('SERIAL').AsString;
            Cells[le+1,1] := Fieldbyname('PARTNUM').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestDetail_Frm.Load_HITEMS_ETH_FIE(aTestNo: String);
var
  li,le : integer;
begin
  with op_fip do
  begin
    BeginUpdate;
    try
      for li := 1 to 3 do
      begin
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from HITEMS_ETH_FIE ' +
                  'where TEST_NO = :param1'+
                  ' and FLAG = :param2 '+
                  ' and ITEM = :param3 '+
                  ' order by ITEM, CYLNUM');

          ParamByName('param1').AsString := aTestNo;
          ParamByName('param2').AsString := 'FIP';
          ParamByName('param3').AsString := Cells[0,li];
          Open;

          if not(RecordCount = 0) then
          begin
            for le := 0 to RecordCount-1 do
            begin
              Cells[le+1,li] := Fieldbyname('Values_').AsString;
              Next;
            end;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;

  with op_fiv do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HITEMS_ETH_FIE ' +
                'where TEST_NO = :param1 '+
                'and FLAG = :param2 '+
                'and ITEM = :param3 '+
                'order by ITEM, CYLNUM');

          ParamByName('param1').AsString := aTestNo;
          ParamByName('param2').AsString := 'FIV';
          ParamByName('param3').AsString := Cells[0,li];
        Open;

        if not(RecordCount = 0) then
        begin
          for le := 0 to RecordCount-1 do
          begin
            Cells[le+1,1] := Fieldbyname('Values_').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestDetail_Frm.Load_HITEMS_ETH_USEDOIL(aTestNo: String);
var
  li : integer;
  lCol : integer;
begin
  with oilGrid do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HITEMS_ETH_USEDOIL ' +
                'where TEST_NO = :param1 '+
                ' order by NUM_OIL');
        ParamByName('param1').AsString := aTestNo;
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            lCol := FieldByName('NUM_OIL').AsInteger;

            Cells[lCol,1] := FieldByName('KIND_OIL').AsString;
            Cells[lCol,2] := FieldByName('GRAVITY').AsString;
            Cells[lCol,3] := FieldByName('FLASH').AsString;
            Cells[lCol,4] := FieldByName('VISCO50').AsString;
            Cells[lCol,5] := FieldByName('VISCO40').AsString;
            Cells[lCol,6] := FieldByName('RECARBON').AsString;
            Cells[lCol,7] := FieldByName('ASH').AsString;
            Cells[lCol,8] := FieldByName('WATER').AsString;
            Cells[lCol,9] := FieldByName('SULFER').AsString;
            Cells[lCol,10] := FieldByName('LCV').AsString;
            Cells[lCol,11] := FieldByName('NETCAL').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestDetail_Frm.mbGridCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if (ARow > 0) and (ACol > 0) then
    CanEdit := True
  else
    CanEdit := False;
end;

procedure TtestDetail_Frm.mbGridGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if (ACol > 0) and (ARow > 0) then
    AEditor := edNormal;
end;

procedure TtestDetail_Frm.mbGridKeyPress(Sender: TObject; var Key: Char);
var
  lRow,lCol : Integer;
  lNext : Integer;
begin
  if key = #$D then
  begin
    lRow := FxRow;
    lCol := FxCol;
    with mbGrid do
    begin
      if (lRow > 0) and (lCol > 0) then
      begin
        lCol := lCol+1;
        if lCol > ColCount-1 then
        begin
          lCol := 1;
          lRow := lRow+1;

          if lRow > RowCount-1 then
            lRow := 1;
        end;
        SelectRange(lCol,lCol,lRow,lRow);
        SetFocus;
      end;
    end;
  end;
end;

procedure TtestDetail_Frm.mbGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  FxRow := ARow;
  FxCol := ACol;
end;

procedure TtestDetail_Frm.OILGRIDCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if (ACol > 0) and (ARow > 0) then
    CanEdit := True;
end;

procedure TtestDetail_Frm.OILGRIDGetEditorProp(Sender: TObject; ACol,
  ARow: Integer; AEditLink: TEditLink);
var
  lRoot : String;
begin
  if (ARow > 0) and (ACol > 0) then
  begin
    with oilgrid do
    begin
      BeginUpdate;
      try
        case ACol of
          1..3 : lRoot := '63484450756551';
          4    : lRoot := '63484450772582';
        end;

        ClearComboString;

        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from HITEMS_CODE_GROUP_V ' +
                  'where CDGRP = '+lRoot+' '+
                  'order by sortno');
          Open;

          while not eof do
          begin
            AddComboString(FieldByName('CODENAME').AsString);
            Next;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TtestDetail_Frm.OILGRIDGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if (ACol > 0) and (ARow > 0)then
  begin
    if not(ARow > 1) then
    begin
      AEditor := edComboEdit;
      oilGrid.Combobox.ButtonWidth := 23;
    end
    else
      AEditor := edFloat;
  end;
end;

procedure TtestDetail_Frm.OILGRIDKeyPress(Sender: TObject; var Key: Char);
var
  lRow,lCol : Integer;
  lNext : Integer;
begin
  if (key = #$D) then
  begin
    lRow := FxRow;
    lCol := FxCol;
    with oilGrid do
    begin
      if (lRow > 0) and (lCol > 0) then
      begin
        lRow := lRow+1;
        if lRow > RowCount-1 then
        begin
          lRow := 1;
          lCol := lCol+1;

          if lCol > ColCount-1 then
            lCol := 1;
        end;
        SelectRange(lCol,lCol,lRow,lRow);
        SetFocus;
      end;
    end;
  end;
end;

procedure TtestDetail_Frm.OILGRIDSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  FxRow := ARow;
  FxCol := ACol;
end;

procedure TtestDetail_Frm.op_fipCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if (ARow > 0) and (ACol > 0) then
    CanEdit := True
  else
    CanEdit := False;
end;

procedure TtestDetail_Frm.op_fipGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if (ACol > 0) and (ARow > 0) then
    AEditor := edFloat;
end;

procedure TtestDetail_Frm.op_fipKeyPress(Sender: TObject; var Key: Char);
var
  lRow,lCol : Integer;
  lNext : Integer;
begin
  if key = #$D then
  begin
    lRow := FxRow;
    lCol := FxCol;
    with op_fip do
    begin
      if (lRow > 0) and (lCol > 0) then
      begin
        lCol := lCol+1;
        if lCol > ColCount-1 then
        begin
          lCol := 1;
          lRow := lRow+1;

          if lRow > RowCount-1 then
            lRow := 1;
        end;
        SelectRange(lCol,lCol,lRow,lRow);
        SetFocus;
      end;
    end;
  end;
end;

procedure TtestDetail_Frm.op_fipSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  FxRow := ARow;
  FxCol := ACol;
end;

procedure TtestDetail_Frm.op_fivCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if (ARow > 0) and (ACol > 0) then
    CanEdit := True
  else
    CanEdit := False;
end;

procedure TtestDetail_Frm.op_fivGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if not(ACol = 0)  then
    HAlign := taCenter;

end;

procedure TtestDetail_Frm.op_fivGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if (ACol > 0) and (ARow > 0) then
    AEditor := edFloat;
end;

procedure TtestDetail_Frm.op_fivKeyPress(Sender: TObject; var Key: Char);
var
  lRow,lCol : Integer;
  lNext : Integer;
begin
  if key = #$D then
  begin
    lRow := FxRow;
    lCol := FxCol;
    with op_fiv do
    begin
      if (lRow > 0) and (lCol > 0) then
      begin
        lCol := lCol+1;
        if lCol > ColCount-1 then
        begin
          lCol := 1;
          lRow := lRow+1;

          if lRow > RowCount-1 then
            lRow := 1;
        end;
        SelectRange(lCol,lCol,lRow,lRow);
        SetFocus;
      end;
    end;
  end;
end;

procedure TtestDetail_Frm.op_fivSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  FxRow := ARow;
  FxCol := ACol;
end;

function TtestDetail_Frm.Return_Code_(aCodeName: String): String;
var
  OraQuery: TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select CODE from HITEMS_CODE ' + 'where CODENAME = :param1');
      ParamByName('param1').AsString := aCodeName;
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('CODE').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;


function TtestDetail_Frm.Return_Code_Name(aCode: Double): String;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select CODENAME from HITEMS_CODE ' +
              'where CODE = :param1');
      ParamByName('param1').AsFloat := aCode;
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('CODENAME').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TtestDetail_Frm.Save_HITEMS_ETH_BEARING(aTestNo: String);
var
  li,le : integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From HITEMS_ETH_BEARING ' +
            'where TEST_NO = '+aTestNo);
    ExecSQL;


    Close;
    SQL.Clear;
    SQL.Add('Insert Into HITEMS_ETH_BEARING ' +
            'Values(:TESTNO, :FLAG, :BEARINGNUM, :MAKER, :TYPE, :SERIAL, :PARTNUM)');

    // MAIN BEARING
    for li := 1 to mbGrid.ColCount-1 do
    begin
      ParamByName('TESTNO').AsString      := aTestNo;
      ParamByName('FLAG').AsString        := 'MB';
      ParamByName('BEARINGNUM').AsInteger := li;
      ParamByName('MAKER').AsString       := mbGrid.Cells[1,li];
      ParamByName('TYPE').AsString        := mbGrid.Cells[2,li];
      ParamByName('SERIAL').AsString      := mbGrid.Cells[3,li];
      ParamByName('PARTNUM').AsString     := mbGrid.Cells[4,li];
      ExecSQL;
    end;

    // Con-rod Bearing
    for li := 1 to crGrid.ColCount-1 do
    begin
      ParamByName('TESTNO').AsString      := aTestNo;
      ParamByName('FLAG').AsString        := 'CR';
      ParamByName('BEARINGNUM').AsInteger := li;
      ParamByName('MAKER').AsString       := crGrid.Cells[1,li];
      ParamByName('TYPE').AsString        := crGrid.Cells[2,li];
      ParamByName('SERIAL').AsString      := crGrid.Cells[3,li];
      ParamByName('PARTNUM').AsString     := crGrid.Cells[4,li];
      ExecSQL;
    end;
  end;
end;


procedure TtestDetail_Frm.Save_HITEMS_ETH_FIE(aTestNo: String);
var
  li,le : integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From HITEMS_ETH_FIE ' +
            'where TEST_NO = :param1 ');
    ParamByName('param1').AsString := aTestNo;
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('Insert Into HITEMS_ETH_FIE ' +
            'Values(:TESTNO, :FLAG, :CYLNUM, :ITEM, :VALUES_)');

    // FIP
    for li := 1 to 3 do
    begin
      for le := 1 to op_fip.ColCount-1 do
      begin
        ParamByName('TESTNO').AsString  := aTestNo;
        ParamByName('FLAG').AsString    := 'FIP';
        ParamByName('CYLNUM').AsInteger := le;
        ParamByName('ITEM').AsString    := op_fip.Cells[0,li];

        if not(op_fip.Cells[le,li] = '') then
          ParamByName('VALUES_').AsFloat   := StrToFloat(op_fip.Cells[le,li])
        else
          ParamByName('VALUES_').AsFloat   := 0;

        ExecSQL;
      end;
    end;

    // FIV
    for li := 1 to op_fiv.ColCount-1 do
    begin
      ParamByName('TESTNO').AsString  := aTestNo;
      ParamByName('FLAG').AsString    := 'FIV';
      ParamByName('ITEM').AsString    := op_fiv.Cells[li,0];
      ParamByName('CYLNUM').AsInteger := li;

      if not(op_fiv.Cells[li,1] = '') then
        ParamByName('VALUES_').AsFloat   := StrToFloat(op_fiv.Cells[li,1])
      else
        ParamByName('VALUES_').AsFloat   := 0;

      ExecSQL;
    end;
  end;
end;

procedure TtestDetail_Frm.Save_HITEMS_ETH_USEDOIL(aTestNo: String);
var
  li,le : integer;
  lCode : String;

begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete HITEMS_ETH_USEDOIL ' +
            'where TEST_NO = :param1');
    ParamByName('param1').AsString := aTestNo;
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('Insert Into HITEMS_ETH_USEDOIL ' +
            'Values(:TEST_NO, '+
            ':NUM_OIL, :KIND_OIL, :GRAVITY, :FLASH, :VISCO50,' +
            ':VISCO40, :RECARBON, :ASH, :WATER, :SULFER,' +
            ':LCV, :NETCAL)');

    with oilGrid do
    begin
      for li := 1 to ColCount-1 do
      begin
        if not(Cells[li,1] = '') then
        begin
          lCode := Return_Code_(Cells[li,1]);
          if not(lCode = '') then
          begin
            ParamByName('TEST_NO').AsString  := aTestNo;

            ParamByName('NUM_OIL').AsInteger := li;
            ParamByName('KIND_OIL').AsString := Cells[li,1];

            if not(Cells[li,2] = '') then
              ParamByName('GRAVITY').AsFloat := StrToFloat(Cells[li,2]);
            if not(Cells[li,3] = '') then
              ParamByName('FLASH').AsFloat := StrToFloat(Cells[li,3]);
            if not(Cells[li,4] = '') then
              ParamByName('VISCO50').AsFloat := StrToFloat(Cells[li,4]);

            if not(Cells[li,5] = '') then
              ParamByName('VISCO40').AsFloat := StrToFloat(Cells[li,5]);
            if not(Cells[li,6] = '') then
              ParamByName('RECARBON').AsFloat := StrToFloat(Cells[li,6]);
            if not(Cells[li,7] = '') then
              ParamByName('ASH').AsFloat := StrToFloat(Cells[li,7]);
            if not(Cells[li,8] = '') then
              ParamByName('WATER').AsFloat := StrToFloat(Cells[li,8]);
            if not(Cells[li,9] = '') then
              ParamByName('SULFER').AsFloat := StrToFloat(Cells[li,9]);

            if not(Cells[li,10] = '') then
              ParamByName('LCV').AsFloat := StrToFloat(Cells[li,10]);
            if not(Cells[li,11] = '') then
              ParamByName('NETCAL').AsFloat := StrToFloat(Cells[li,11]);

            ExecSQL;
          end;
        end;
      end;
    end;
  end;
end;

procedure TtestDetail_Frm.Load_Measure_Data(aTestNo: String);
begin
  TThread.Queue(nil,
  procedure
  var
    li : Integer;
    OraQuery : TOraQuery;
    lTable : String;
    lFormat : String;
  begin
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TBACS.HITEMS_MON_STANDARD ' +
              'WHERE ENG_PROJNO = :param1 ');
      ParamByName('param1').AsString := FCurrentProjNo;
      Open;

      if not(RecordCount = 0) then
        lTable := FieldByName('TABLE_NAME').AsString;

      if not(lTable = '') then
      begin
        Close;
        SQL.Clear;
        SQL.Add('select Count(*) Count from '+lTable);
        SQL.Add('where DataSavedTime Between :param1 and :param2 order by DataSavedTime');
        ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS',StrToDateTime(FTestStart));
        ParamByName('param2').AsString := FormatDateTime('YYYYMMDDHHMMSS',StrToDateTime(FTestEnd));
        Open;

        if RecordCount <> 0 then
        begin
          label3.Caption := '/ 조회건수 : '+FieldByName('Count').AsString + ' 건';

          Close;
          Active := False;
          SQL.Clear;
          SQL.Add('select * from '+lTable);
          SQL.Add('where DataSavedTime Between :param1 and :param2 order by DataSavedTime');
          ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS',StrToDateTime(FTestStart));
          ParamByName('param2').AsString := FormatDateTime('YYYYMMDDHHMMSS',StrToDateTime(FTestEnd));
          Active := True;

          with DBGrid1.Columns do
          begin
            BeginUpdate;
            OraQuery := TOraQuery.Create(nil);
            try
              OraQuery.Session := DM1.OraSession1;
              Oraquery.FetchAll := True;

              with OraQuery do
              begin
                Close;
                SQL.Clear;
                SQL.Add('SELECT A.COLUMN_NAME, COMMENTS FROM ALL_TAB_COLUMNS A, ALL_COL_COMMENTS B ' +
                        'WHERE A.OWNER = B.OWNER ' +
                        'AND A.TABLE_NAME = B.TABLE_NAME ' +
                        'AND A.COLUMN_NAME = B.COLUMN_NAME ' +
                        'AND A.TABLE_NAME = :param1 ' +
                        'ORDER BY A.COLUMN_ID ');
                ParamByName('param1').AsString := lTable;
                Open;

                if RecordCount <> 0 then
                begin
                  for li := 0 to RecordCount-1 do
                  begin
                    if SameText(Items[li].Title.Caption, Fields[0].AsString) then
                      Items[li].Title.Caption := FieldByName('COMMENTS').AsString;

                    Next;
                  end;
                end;
              end;
            finally
              FreeAndNil(OraQuery);
              EndUpdate;
            end;
          end;
        end;
      end;
    end;
  end);
end;

procedure TtestDetail_Frm.Load_HITEMS_ETH_LDS(aTestNo, aProjNo: String);
begin
  TThread.Queue(nil,
  procedure
  var
    OraQuery : TOraQuery;
    li : Integer;
  begin
    with OraQuery2 do
    begin
      Close;
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT * FROM HITEMS_ETH_LDS ' +
              'WHERE TEST_NO = :param1 ' +
              'ORDER BY LDS_NO ');
      ParamByName('param1').AsString := aTestNo;
      Active := True;

      with DBGrid2.Columns do
      begin
        BeginUpdate;
        OraQuery := TOraQuery.Create(nil);
        try
          OraQuery.Session := DM1.OraSession1;
          OraQuery.FetchAll := True;

          with OraQuery do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT A.COLUMN_NAME, COMMENTS FROM ALL_TAB_COLUMNS A, ALL_COL_COMMENTS B ' +
                    'WHERE A.OWNER = B.OWNER ' +
                    'AND A.TABLE_NAME = B.TABLE_NAME ' +
                    'AND A.COLUMN_NAME = B.COLUMN_NAME ' +
                    'AND A.TABLE_NAME = :param1 ' +
                    'ORDER BY A.COLUMN_ID ');

            ParamByName('param1').AsString := 'HITEMS_ETH_LDS';
            Open;

            if RecordCount <> 0 then
            begin
              for li := 0 to RecordCount-1 do
              begin
//                if SameText(Items[li].Title.Caption, Fields[0].AsString) then
                  Items[li].Title.Caption := FieldByName('COMMENTS').AsString;

                Next;
              end;
            end;
          end;
        finally
          FreeAndNil(OraQuery);
          EndUpdate;
        end;
      end;
    end;
  end);
end;

procedure TtestDetail_Frm.Set_spec_Table(aEngType: String);
var
  lpos,
  li,le,lt : integer;
  lstr : String;
begin
  lpos := POS('H',aEngType);

  if lpos > 0 then
  begin
    lstr := Copy(aEngType, 0, lpos-1);
    lt := StrToInt(lstr);

    with op_fip do
    begin
      BeginUpdate;
      try
        ColCount := lt+1;

        DefaultColWidth := 80;
        FixedColWidth := 120;

        for li := 0 to lt-1 do
          Cells[1+li,0] := 'Cylinder#'+IntToStr(li+1);
      finally
        EndUpdate;
      end;
    end;

    with op_fiv do
    begin
      BeginUpdate;
      try
        ColCount := lt+1;

        DefaultColWidth := 80;
        FixedColWidth := 120;

        for li := 0 to lt-1 do
          Cells[1+li,0] := 'Cylinder#'+IntToStr(li+1);
      finally
        EndUpdate;
      end;
    end;

    with mbGrid do
    begin
      BeginUpdate;
      try
        ColCount := (lt div 2)+1;

        DefaultColWidth := 80;
        FixedColWidth := 120;

        for li := 0 to lt-1 do
          Cells[1+li,0] := 'Bearing#'+IntToStr(li+1);
      finally
        EndUpdate;
      end;
    end;

    with crGrid do
    begin
      BeginUpdate;
      try
        ColCount := (lt div 2)+1;

        DefaultColWidth := 80;
        FixedColWidth := 120;

        for li := 0 to lt-1 do
          Cells[1+li,0] := 'Bearing#'+IntToStr(li+1);
      finally
        EndUpdate;
      end;
    end;

    with oilGrid do
    begin
      BeginUpdate;
      try
        MergeCells(1,0,3,1);
        for li := 1 to 4 do
          for le := 1 to 10 do
            Cells[li,le] := '';

      finally
        EndUpdate;

      end;
    end;
  end;
end;

procedure TtestDetail_Frm.to_Excel(aGrid: String);
var
  lGrid : TAdvStringGrid;
begin
  SaveDialog1.FileName := FCurrentProjNo+'_'+AdvPageControl1.ActivePage.Caption+'_결과.xls';
  if SaveDialog1.Execute then
  begin
    lGrid := TAdvStringGrid(FindComponent(aGrid));

    if Assigned(lGrid) then
    begin
      AdvGridExcelIO1.AdvStringGrid := lGrid;

      FExportThread := TExportThread.Create(true);
      FExportThread.FreeOnTerminate := true;
      FExportThread.Resume;
    end;
  end;
end;

{ TExportThread }

procedure TExportThread.Execute;
var
  lform : Tprogress_Frm;
begin
  inherited;
  if Assigned(testDetail_Frm) then
  begin
    lform := Tprogress_Frm.Create(nil);
    try
      lform.Show;
      with testDetail_Frm do
        AdvGridExcelIO1.XLSExport(SaveDialog1.FileName);

    finally
      FreeAndNil(lform);
      Terminate;
    end;
  end;
end;

end.

