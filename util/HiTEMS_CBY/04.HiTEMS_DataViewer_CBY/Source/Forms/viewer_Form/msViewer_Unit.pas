unit msViewer_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, shellApi,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, NxEdit, Vcl.ComCtrls, AdvDateTimePicker, AdvGlowButton,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, NxCollection, iComponent, iVCLComponent, Ora,
  iCustomComponent, iPlotComponent, iPlot, Vcl.Grids, Vcl.DBGrids,
  StrUtils, Vcl.Menus, AdvMenus, JvBaseDlg, JvProgressDialog,
  DateUtils,ComObj, OleCtrls, ActiveX, Vcl.ImgList;

type
  TgenCsvThread = class(TThread)
  private
    FSaveFileName:String;
    FGrid : TDBGrid;
    FRecNo,
    FRecordCnt : Integer;
    FProgressDlg: TJvProgressDialog;
    procedure UpdateVCL;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

type
  TdrawChartThread = class(TThread)
  private
    FRecNo, FRecordCount, FChannel: Integer;
    FQuery: TOraQuery;
    FxColumn, FyColumn: String;
    FxValue, FyValue: Double;
    FProgressDlg: TJvProgressDialog;
    iPlot: TiPlot;

    procedure UpdateVCL;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    function Replace_Date_Format(aValue: String): String;

  end;

type
  TmsViewer_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    NxHeaderPanel1: TNxHeaderPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel1: TBevel;
    Label7: TLabel;
    Label8: TLabel;
    paramGrid: TNextGrid;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    AdvGlowButton1: TAdvGlowButton;
    sTime: TAdvDateTimePicker;
    eTime: TAdvDateTimePicker;
    interval: TNxNumberEdit;
    cb_engType: TComboBox;
    NxSplitter1: TNxSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    Label4: TLabel;
    AdvGlowButton2: TAdvGlowButton;
    DBGrid1: TDBGrid;
    TabSheet2: TTabSheet;
    iPlot1: TiPlot;
    NxTextColumn3: TNxTextColumn;
    AdvPopupMenu1: TAdvPopupMenu;
    AddexistYAxis1: TMenuItem;
    AddnewYValue1: TMenuItem;
    JvProgressDialog1: TJvProgressDialog;
    ImageList16x16: TImageList;
    SaveDialog1: TSaveDialog;
    procedure cb_engTypeDropDown(Sender: TObject);
    procedure cb_engTypeSelect(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure paramGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure paramGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure AddnewYValue1Click(Sender: TObject);
    procedure iPlot1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure iPlot1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure AdvGlowButton2Click(Sender: TObject);
  private
    { Private declarations }
    FsRow: Integer;
    FRecordCount: Integer;
    FCurrentChannel: Integer;
    FEngProjNo, FTableOwner, FTableName: String;
  public
    { Public declarations }
    FaddChartType: Integer;
    { 0 : add Value to new Y axis / 1 : add value to exist Y axis }
    FYaxisName: String;
    progressDialog: TJvProgressDialog;

    FdrawChartThread: TdrawChartThread;
    FgenCsvThread : TgenCsvThread;

    procedure Set_Parameter(aProjNo: String);
    function Gen_Interval_Query: String;
    function Gen_Std_Query: String;

    procedure Open_new_Axis_Popup;
  end;

var
  msViewer_Frm: TmsViewer_Frm;

implementation

uses
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure TmsViewer_Frm.AddnewYValue1Click(Sender: TObject);
var
  lCaption: String;
  lYaxisName: String;
  lYaxis: Integer;
begin
  with iPlot1 do
  begin
    BeginUpdate;
    try

      lCaption := (Sender as TMenuItem).Caption;
      Delete(lCaption, FindDelimiter('&', lCaption, 0), 1);
      FYaxisName := lCaption;

      if lCaption = 'Add new Y-Axis' then
      begin
        if paramGrid.Cell[0, FsRow].AsBoolean = False then
        begin
          paramGrid.Cell[0, FsRow].AsBoolean := True;

          lYaxis := AddYAxis;
          YAxis[lYaxis].Name := 'Y-Axis' + IntToStr(lYaxis + 1);
          YAxis[lYaxis].LabelsFont.Color := clBlack;
          YAxis[lYaxis].ScaleLinesColor := clBlack;
          YAxis[lYaxis].GridLinesVisible := True;
          lYaxisName := YAxis[lYaxis].Name;

        end;
      end
      else
      begin
        if paramGrid.Cell[0, FsRow].AsBoolean = False then
        begin
          paramGrid.Cell[0, FsRow].AsBoolean := True;
          lYaxisName := FYaxisName;
        end;
      end;

      FCurrentChannel := AddChannel;
      Channel[FCurrentChannel].TitleText := paramGrid.Cells[1, FsRow];
      Channel[FCurrentChannel].YAxisName := lYaxisName;

      JvProgressDialog1.Show;
      JvProgressDialog1.InitValues(0, FRecordCount, 200, 0, FTableName,
        Channel[FCurrentChannel].TitleText);

      FdrawChartThread := TdrawChartThread.Create;
      with FdrawChartThread do
      begin
        iPlot := Self.iPlot1;
        FQuery := DM1.OraQuery1;
        FChannel := Self.FCurrentChannel;
        FProgressDlg := JvProgressDialog1;

        FxColumn := paramGrid.Cells[3, 0];
        FyColumn := paramGrid.Cells[3, FsRow];
        resume;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TmsViewer_Frm.AdvGlowButton1Click(Sender: TObject);
var
  i, j: Integer;
  lColumnName: String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    if interval.Value > 0 then
    begin
      SQL.Add(Gen_Interval_Query);
      ParamByName('BEGIN').AsString := FormatDateTime('yyyyMMddHHmm',sTime.DateTime);
      ParamByName('END').AsString := FormatDateTime('yyyyMMddHHmm',eTime.DateTime);
      ParamByName('INTV').AsInteger := interval.AsInteger;
      Open;
      FRecordCount := RecordCount;
    end
    else
    begin
      SQL.Add('SELECT COUNT(*) CNT FROM ' + FTableOwner + '.' + FTableName);
      SQL.Add('WHERE DATASAVEDTIME BETWEEN :BEGIN AND :END ');
      ParamByName('BEGIN').AsString := FormatDateTime('yyyyMMddHHmm',
        sTime.DateTime);
      ParamByName('END').AsString := FormatDateTime('yyyyMMddHHmm',
        eTime.DateTime);
      Open;

      FRecordCount := FieldByName('CNT').AsInteger;
      if FRecordCount <> 0 then
      begin
        Close;
        SQL.Clear;
        SQL.Add(Gen_Std_Query);
        ParamByName('BEGIN').AsString := FormatDateTime('yyyyMMddHHmm',sTime.DateTime);
        ParamByName('END').AsString := FormatDateTime('yyyyMMddHHmm',eTime.DateTime);
        Open;
      end;
    end;
    Label4.Caption := 'Total : ' + IntToStr(FRecordCount);
  end;

  with paramGrid do
  begin
    BeginUpdate;
    try
      for i := 0 to DBGrid1.Columns.Count-1 do
      begin
        lColumnName := DBGrid1.Columns[i].Title.Caption;
        for j := 0 to RowCount-1 do
        begin
          if SameText(Cells[3, i], lColumnName) then
          begin
            DBGrid1.Columns[i].Title.Caption := Cells[1, i];
            Break;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TmsViewer_Frm.AdvGlowButton2Click(Sender: TObject);
var
  dirName : String;
  lFileName : String;
begin
  dirName := GetMyDocumentsDir;
  SaveDialog1.FileName := dirName+'\'+FormatDateTime('yyMMdd_',Now)+FTableName+'.csv';
  if SaveDialog1.Execute then
  begin
    if FRecordCount <> 0 then
    begin
      JvProgressDialog1.Show;
      JvProgressDialog1.InitValues(0, FRecordCount, 200, 0, FTableName, 'CSV파일생성('+IntToStr(FRecordCount)+'/0)  ');

      FgenCsvThread := TgenCsvThread.Create;
      with FgenCsvThread do
      begin
        FGrid := DBGrid1;
        FProgressDlg := JvProgressDialog1;
        FRecordCnt := FRecordCount;
        FSaveFileName := SaveDialog1.FileName;

        resume;
      end;
    end;
  end;
end;

procedure TmsViewer_Frm.cb_engTypeDropDown(Sender: TObject);
var
  OraQuery: TOraQuery;
  EngType: String;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    cb_engType.Items.Clear;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM MON_TABLES ' + 'WHERE USE_YN = 0 ' +
        'ORDER BY SEQ_NO ');
      Open;

      if RecordCount <> 0 then
      begin
        cb_engType.Items.Add('');
        while not eof do
        begin
          EngType := FieldByName('ENG_PROJNO').AsString + '-' +
            FieldByName('ENG_TYPE').AsString;

          cb_engType.Items.Add(EngType);

          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TmsViewer_Frm.cb_engTypeSelect(Sender: TObject);
begin
  FEngProjNo := LeftStr(cb_engType.Text, 6);
  Set_Parameter(FEngProjNo);
end;

procedure TmsViewer_Frm.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  iPlot1.RemoveAllChannels;

  sTime.DateTime := Now;
  eTime.DateTime := IncDay(sTime.DateTime, 3);
end;

function TmsViewer_Frm.Gen_Interval_Query: String;
var
  i: Integer;
  f: string;
  mResult : String;
  a : TStringList;
begin
  with paramGrid do
  begin
    BeginUpdate;
    try
      Result := 'SELECT ' + #10#13;
      for i := 0 to RowCount - 1 do
      begin
        f := ' MAX(' + Cells[3, i] + ') ' + Cells[3, i] + ',';
        if Pos(f,Result) = 0  then
        begin
          if i <> 0 then
            Result := Result + f
          else
            Result := Result + Cells[3, i] + ',';

          if i mod 10 = 0 then
            Result := Result + #10#13;

        end;
      end;
      Result := Copy(Result, 0, Length(Result) - 1);
      Result := Result + ' FROM ( ' + #10#13;
      // ===========================

      mResult := ' SELECT ' + #10#13;
      for i := 0 to RowCount - 1 do
      begin
        f := Cells[3, i] + ',';
        if Pos(f,mResult) = 0  then
        begin
          if i <> 0 then
            mResult := mResult + f
          else
            mResult := mResult + ' SUBSTR(' + Cells[3, i] + ',1,12) ' +
              Cells[3, i] + ',';

          if i mod 10 = 0 then
            Result := Result + #10#13;
        end;
      end;
      mResult := Copy(mResult, 0, Length(mResult) - 1);

      mResult := mResult + ' FROM ' + FTableOwner + '.' + FTableName + #10#13;
      mResult := mResult + ' WHERE ' + Cells[3, 0] +
        ' BETWEEN :BEGIN AND :END ' + #10#13;
      mResult := mResult + ' AND MOD(SUBSTR(' + Cells[3, 0] +
        ',11,2),:INTV) = 0 ' + #10#13;

      // ===========================
      Result := Result + mResult + ') ' + #10#13;
      Result := Result + ' GROUP BY ' + Cells[3, 0] + #10#13;
      Result := Result + ' ORDER BY ' + Cells[3, 0] + #10#13;

      a := TStringList.Create;
      a.Text := Result;
      a.SaveToFile('C:\Users\HwangSeonHo\Desktop\genQuery.txt');

    finally
      FreeAndNil(a);

      EndUpdate;
    end;
  end;
end;

function TmsViewer_Frm.Gen_Std_Query: String;
var
  i: Integer;
  f: string;
begin
  with paramGrid do
  begin
    BeginUpdate;
    try
      Result := Result + ' SELECT ' + #10#13;
      for i := 0 to RowCount - 1 do
        Result := Result + Cells[3, i] + ',';

      Result := Copy(Result, 0, Length(Result) - 1);

      Result := Result + ' FROM ' + FTableOwner + '.' + FTableName + #10#13;
      Result := Result + ' WHERE ' + Cells[3, 0] +
        ' BETWEEN :BEGIN AND :END ' + #10#13;

      Result := Result + ' ORDER BY ' + Cells[3, 0] + #10#13;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TmsViewer_Frm.iPlot1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  li : integer;
  litem: TNextGrid;
  lmenuItem : TMenuItem;
begin
  if Source is TNextGrid then
  begin

    Open_new_Axis_Popup;

  end;
end;

procedure TmsViewer_Frm.iPlot1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source is TNextGrid then
    Accept := True
  else
    Accept := False;
end;

procedure TmsViewer_Frm.Open_new_Axis_Popup;
var
  li: Integer;
  lmenuItem: TMenuItem;

begin

  for li := AdvPopupMenu1.Items[0].Count - 1 Downto 0 do
    AdvPopupMenu1.Items[0].Delete(li);

  for li := 0 to iPlot1.YAxisCount - 1 do
  begin
    lmenuItem := TMenuItem.Create(Self);
    lmenuItem.Caption := iPlot1.YAxis[li].Name;
    lmenuItem.OnClick := AddnewYValue1Click;

    AdvPopupMenu1.Items[0].Add(lmenuItem);

  end;

  AdvPopupMenu1.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);

end;

procedure TmsViewer_Frm.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0:
      begin
        paramGrid.Enabled := False;

      end;

    1:
      begin
        paramGrid.Enabled := True;

      end;
  end;
end;

procedure TmsViewer_Frm.paramGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ax: TPoint;
  lrow: Integer;
begin
  if Button = mbLeft then
  begin
    with Sender as TNextGrid do
    begin
      if SelectedRow > -1 then
      begin
        BeginDrag(False);
      end;
    end;
  end;
end;

procedure TmsViewer_Frm.paramGridSelectCell(Sender: TObject;
  ACol, ARow: Integer);
var
  li: Integer;
  lTitle: String;
begin
  FsRow := ARow;
  with paramGrid do
  begin
    if ACol = 0 then
    begin
      if Cell[0, ARow].AsBoolean then
      begin
        Cell[0, ARow].AsBoolean := False;
        lTitle := paramGrid.Cells[1, FsRow];
        with iPlot1 do
        begin
          BeginUpdate;
          try
            for li := 0 to ChannelCount - 1 do
            begin
              if Channel[li].TitleText = lTitle then
              begin
                DeleteChannel(li);
                Break;
              end;
            end;
          finally
            EndUpdate;
          end;
        end;
      end
      else
      begin

        Open_new_Axis_Popup;

      end;
    end;
  end;
end;

procedure TmsViewer_Frm.Set_Parameter(aProjNo: String);
var
  OraQuery: TOraQuery;
begin
  with paramGrid do
  begin
    BeginUpdate;
    try
      ClearRows;

      OraQuery := TOraQuery.Create(nil);
      try
        OraQuery.Session := DM1.OraSession1;
        OraQuery.FetchAll := True;
        with OraQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM ' + '( ' + '   SELECT ' +
            '     A.SEQ_NO, A.KEY, DESCRIPTION, B.DATA_COLUMN, ' +
            '     B.DATA_ENGPROJNO, B.DATA_ENGTYPE, C.OWNER, C.TABLE_NAME ' +
            '   FROM MON_KEY A, MON_MAP B, MON_TABLES C ' +
            '   WHERE A.KEY = B.KEY ' +
            '   AND B.DATA_ENGPROJNO = C.ENG_PROJNO ' + ') ' +
            'WHERE DATA_ENGPROJNO LIKE :param1 ' + 'ORDER BY SEQ_NO ');

          ParamByName('param1').AsString := aProjNo;
          Open;

          if RecordCount <> 0 then
          begin
            FTableOwner := FieldByName('OWNER').AsString;
            FTableName := FieldByName('TABLE_NAME').AsString;
            while not eof do
            begin
              AddRow;
              Cells[1, LastAddedRow] := FieldByName('DESCRIPTION').AsString;
              Cells[2, LastAddedRow] := FieldByName('KEY').AsString;
              Cells[3, LastAddedRow] := FieldByName('DATA_COLUMN').AsString;
              Next;
            end;
          end
          else
            ShowMessage('Project: ' + aProjNo +
              ' 의 데이터가 "MON_KEY" 또는 "MON_MAP" 테이블에 존재하지 않습니다.' + #13#10 +
              '상기 테이블에 데이터 입력 후 사용 하세요!');
        end;
      finally
        FreeAndNil(OraQuery);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

{ TdrawChartThread }

constructor TdrawChartThread.Create;
begin
  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TdrawChartThread.Destroy;
begin

  inherited;
end;

procedure TdrawChartThread.Execute;
begin
  with iPlot do
  begin
    BeginUpdate;
    try
      with FQuery do
      begin
        First;
        while not eof do
        begin
          FRecNo := RecNo;
          FxValue := StrToDateTime(Replace_Date_Format(FieldByName(FxColumn).AsString));
          FyValue := FieldByName(FyColumn).AsFloat;

          Channel[FChannel].AddXY(FxValue, FyValue);

          Synchronize(UpdateVCL);

          Application.ProcessMessages;

          Next;
        end;
      end;
    finally
      XAxis[0].ZoomToFit;
      FProgressDlg.Hide;
      EndUpdate;
    end;
  end;
end;

function TdrawChartThread.Replace_Date_Format(aValue: String): String;
var
  s: String;
begin
  if Length(aValue) = 12 then
  begin
    try
      s := Copy(aValue, 1, 4) + FormatSettings.DateSeparator + Copy(aValue, 5, 2) +
        FormatSettings.DateSeparator + Copy(aValue, 7, 2) + ' ' + Copy(aValue, 9, 2) +
        FormatSettings.TimeSeparator + Copy(aValue, 11, 2);

      Result := s;

      Exit;
    except
      Result := '';
    end;
  end;

  if Length(aValue) = 17 then
  begin
    try
      s := Copy(aValue, 1, 4) + FormatSettings.DateSeparator + Copy(aValue, 5, 2) +
        FormatSettings.DateSeparator + Copy(aValue, 7, 2) + ' ' + Copy(aValue, 9, 2) +
        FormatSettings.TimeSeparator + Copy(aValue, 11, 2) + FormatSettings.TimeSeparator +
        Copy(aValue, 13, 2) + '.' + Copy(aValue, 15, 3);

      Result := s;

      Exit;
    except
      Result := '';
    end;
  end;
end;

procedure TdrawChartThread.UpdateVCL;
begin
  FProgressDlg.Position := FRecNo;
end;

{ TgenCsvThread }

constructor TgenCsvThread.Create;
begin
  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TgenCsvThread.Destroy;
begin

  inherited;
end;

procedure TgenCsvThread.Execute;
const
  ldec = 65;//Ascii Code Dec = A
var
  i,j,s : Integer;
  strList : TStringList;
  LValues,
  LValues2,
  lPath,
  lfn : String;

begin
  strList := TStringList.Create;
  try
    with strList do
    begin
      BeginUpdate;
      try
        Clear;
        with FGrid.DataSource.DataSet do
        begin
          DisableControls;
          try
            First;
            FRecNo := 0;
            while FRecNo < FRecordCnt-1 do
            begin
              LValues := '';
              for i := 0 to FGrid.Columns.Count-1 do
              begin
                if FRecNo <> 0 then
                  LValues2 := FGrid.Fields[i].AsString
                else
                  LValues2 := FGrid.Columns[i].Title.Caption;

                LValues := LValues + LValues2 + ',';

              end;

              LValues := Copy(LValues,1,Length(LValues)-1);

              Add(LValues);

              Synchronize( UpdateVCL );

              Application.ProcessMessages;

              if FRecNo <> 0 then
                Next;

              FRecNo := RecNo;
            end;
//            lPath := GetMyDocumentsDir;
//            lPath := lPath+'\'+FormatDateTime('yyMMdd_',Now)+FProgressDlg.Caption+'.csv';
            SaveToFile(FSaveFileName);
//            ShellExecute(handle,'open',PWideChar(lPath),nil,nil,SW_NORMAL);
          finally
            First;
            EnableControls;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  finally
    FProgressDlg.Hide;
  end;
end;

procedure TgenCsvThread.UpdateVCL;
begin
  FProgressDlg.Text := 'CSV파일생성('+IntToStr(FRecordCnt)+'/'+IntToStr(FRecNo)+')     ';
  FProgressDlg.Position := FRecNo;

end;

end.
