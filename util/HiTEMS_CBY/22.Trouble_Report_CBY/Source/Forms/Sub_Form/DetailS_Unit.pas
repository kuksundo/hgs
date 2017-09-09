unit DetailS_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  DBAdvGrid, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.StdCtrls, AdvGroupBox,
  AdvOfficeButtons, NxCollection, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, Data.DB, MemDS, DBAccess, Ora,
  Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.ImgList, AdvOfficeStatusBar,
  tmsAdvGridExcel,
  Main_Unit, NxDBGrid;

type
  TDetailS_Frm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel8: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    Image2: TImage;
    OraQuery2: TOraQuery;
    OraQuery3: TOraQuery;
    DataSource1: TDataSource;
    Imglist16x16: TImageList;
    AdvGridExcelIO1: TAdvGridExcelIO;
    SaveDialog1: TSaveDialog;
    keyWord: TEdit;
    engType: TComboBox;
    projno: TComboBox;
    inempno: TComboBox;
    empno: TComboBox;
    rptype: TAdvOfficeCheckGroup;
    keyGrp: TAdvOfficeCheckGroup;
    trgrp: TAdvOfficeCheckGroup;
    orderby: TAdvOfficeRadioGroup;
    trAlign: TAdvOfficeRadioGroup;
    NxHeaderPanel2: TNxHeaderPanel;
    trtype: TNextGrid;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    Statusbar1: TAdvOfficeStatusBar;
    trGrid: TAdvStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure empnoDropDown(Sender: TObject);
    procedure inempnoDropDown(Sender: TObject);
    procedure engTypeDropDown(Sender: TObject);
    procedure engTypeSelect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure trGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure trtypeHeaderClick(Sender: TObject; ACol: Integer);
    procedure trGridGetDisplText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure trGridDblClick(Sender: TObject);
    procedure trGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure trGridScrollCell(Sender: TObject; ACol, ARow, ScrollPosition,
      ScrollMin, ScrollMax: Integer);
  private
    { Private declarations }
    FxRow : integer; // 제일 최근에 선택된 trGrid Row;
    FtrTypeChk : Boolean;
    FkeyFields : TStringList;
    FEmpNoId : TStringList; //작성자 ID
    FInEmpNoID : TStringList; //설계담당자 ID;
  public
    { Public declarations }
    FOwner : TMain_Frm;
    procedure Show_of_the_Detail;

    procedure Get_Trouble_Type_List_From_Trouble_Data;

    procedure Search_In_Trouble_Data;

    procedure Set_Feilds_to_Local;

    function Check_for_keyGrp : String;
    function Check_for_rpType : String;
    function Check_for_trGrp : String;
    function Check_for_trType : String;

    procedure Initialize_;

    //utils
    function Check_for_CODENM_Base_on_CODE(CODE:String) : String; //코드로 코드명 검색 후 리턴
    procedure TrGrid_Alignment;


  end;

var
  DetailS_Frm: TDetailS_Frm;

implementation
uses
  Trouble_Unit;

{$R *.dfm}

{ TForm1 }

procedure TDetailS_Frm.Button1Click(Sender: TObject);
begin
  Search_In_Trouble_Data;
end;

procedure TDetailS_Frm.Button2Click(Sender: TObject);
var
  li : integer;
begin
  with trGrid do
    for li := 0 to RowCount-1 do
      trType.Cell[0,li].AsBoolean := False;

  rpType.CheckBox.Checked := true;
  for li := 0 to rpType.Items.Count-1 do
    rpType.Checked[li] := True;

  keyGrp.CheckBox.Checked := False;
  for li := 0 to keyGrp.Items.Count-1 do
    keyGrp.Checked[li] := False;

  trGrp.CheckBox.Checked := False;
  for li := 0 to trGrp.Items.Count-1 do
    trGrp.Checked[li] := False;

  engType.Clear;
  projno.Clear;
  empno.Clear;
  inempno.Clear;
  OraQuery3.Active := False;

end;

procedure TDetailS_Frm.Button3Click(Sender: TObject);
var
  LFileName : String;
begin
  Try
    LFileName := FormatDateTime('YYMMDD_',Now)+'문제점 보고서 목록.xls';
    SaveDialog1.FileName := LFileName;
    if SaveDialog1.Execute then
    begin
      with AdvGridExcelIO1 do
      begin
        DateFormat := 'YYYY-MM-DD';
        AdvStringGrid := trGrid;
        XLSExport(SaveDialog1.FileName);
      end;
      ShowMessage('목록 출력이 완료 되었습니다.');
    end;
  Except
    ShowMessage('알 수 없는 문제로 목록 출력이 실패되었습니다.');
  End;
end;

function TDetailS_Frm.Check_for_CODENM_Base_on_CODE(CODE: String): String;
begin
  with OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select CODENM from ZHITEMSCODE where CODE = :param1');
    parambyname('param1').AsString := CODE;
    Open;
    if not(RecordCount = 0) then
      Result := Fieldbyname('CODENM').AsString
    else
      Result := '';
  end;
end;

function TDetailS_Frm.Check_for_keyGrp: String;
var
  li : integer;
  LState : Boolean;
  LSQL : String;
  lcnt : integer;
begin
  Result := '';

  lcnt := 0;
  try
    for li := 0 to keyGrp.Items.Count-1 do
    begin
      LState := keyGrp.Checked[li];
      if LState = True then
      begin
        if lcnt = 0 then
          LSQL := ' and( upper('+FkeyFields.Strings[li]+ ') LIKE ''%'+keyWord.Text+'%'''
        else
          LSQL := LSQL + ' or upper('+FkeyFields.Strings[li]+ ') LIKE ''%'+keyWord.Text+'%''';

        inc(lcnt);
      end;
    end;
    LSQL := LSQL + ')';

    if not(lcnt = 0) then
    begin
      Result := LSQL;
    end
    else
      Result := 'Failed';
  Except
    Result := 'Failed';
  end;
end;

function TDetailS_Frm.Check_for_rpType: String;
var
  li : integer;
  LState : Boolean;
  LSQL : String;
  lcnt : integer;
begin
  Result := '';

  LSQL := 'where (rpType in (';
  lcnt := 0;
  try
    for li := 0 to rpType.Items.Count-1 do
    begin
      LState := rpType.Checked[li];
      if LState = True then
      begin
        inc(lcnt);
        LSQL := LSQL + IntToStr(li)+',';
      end;
    end;

    if not(lcnt = 0) then
    begin

      li := Length(LSQL);
      Delete(LSQL,li,1);

      LSQL := LSQL + '))';
      Result := LSQL;
    end
    else
      Result := 'Failed';
  Except
    Result := 'Failed';
  end;
end;

function TDetailS_Frm.Check_for_trGrp: String;
var
  li : integer;
  LState : Boolean;
  LSQL : String;
  LStr : String;
  lcnt : integer;
  LFields : String;
begin
  Result := '';
  try
    lcnt := 0;
    LSQL := '';
    LStr := '';
    for li := 0 to trGrp.Items.Count-1 do
    begin
      LState := trGrp.Checked[li];
      if LState = True then
      begin
        LFields := 'TRTYPE'+IntToStr(li+1);
        if lcnt = 0 then
          LStr := LFields + ' = ''T'''
        else
          LStr := LStr + ' or '+LFields+ ' = ''T''';

        inc(lcnt);
      end;
    end;
    if not(lcnt = 0) then
      LSQL := 'and('+LStr+')';
    Result := LSQL;
  Except
    Result := 'Failed';
  end;
end;

function TDetailS_Frm.Check_for_trType: String;
var
  li : integer;
  LState : Boolean;
  LSQL : String;
  lcnt : integer;
  LStr : String;
begin

  Result := '';

  lcnt := 0;
  try
    LStr := '(';
    for li := 0 to trType.RowCount-1 do
    begin
      LState := trType.Cell[0,li].AsBoolean;
      if LState = True then
      begin
        Inc(LCnt);
        LStr := LStr + trType.Cells[1,li]+',';
      end;
    end;

    if not(lcnt = 0) then
    begin
      li := Length(LStr);
      Delete(LStr,li,1);

      LStr := LStr + ')';

      LSQL := ' And (TROUBLETYPE1 in '+LStr;
      LSQL := LSQL + ' or TROUBLETYPE2 in '+LStr;
      LSQL := LSQL + ' or TROUBLETYPE3 in '+LStr;
      LSQL := LSQL + ' or TROUBLETYPE4 in '+LStr;
      LSQL := LSQL + ' or TROUBLETYPE5 in '+LStr;

      LSQL := LSQL + ')';
      Result := LSQL;
    end
    else
      Result := 'Failed';
  Except
    Result := 'Failed';
  end;
end;

procedure TDetailS_Frm.empnoDropDown(Sender: TObject);
var
  lc : integer;
  LStr : String;
begin
  if empNo.Items.Count = 0 then
  begin
    empNo.Clear;
    empNo.Items.Clear;
    FEmpNoID := TStringList.Create;
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select distinct a.empno, b.name_kor, b.class, C.CODENM from Trouble_Data a, ');
      SQL.Add(' user_info b, ZHITEMSCODE C where empno = userid');
      SQL.Add(' and b.Class = C.CODE order by Name_Kor');
      Open;

      if not(RecordCount = 0) then
      begin
        for lc := 0 to RecordCount -1 do
        begin
          FEmpNoID.Add(Fieldbyname('empno').AsString);
          LStr := Check_for_CODENM_Base_on_CODE(Fieldbyname('CLASS').AsString);
          EMPNO.Items.Add(LStr+' '+Fieldbyname('Name_Kor').AsString);
          Next;
        end;
      end;//if
    end;//with
  end;
end;

procedure TDetailS_Frm.engTypeDropDown(Sender: TObject);
begin
  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select Distinct(EngType) from Trouble_Data order by EngType');
    Open;

    EngType.Items.Clear;
    while not(Eof) do
    begin
      EngType.Items.Add(Fieldbyname('EngType').AsString);
      Next;
    end;
  end;
end;

procedure TDetailS_Frm.engTypeSelect(Sender: TObject);
begin
  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select Distinct(ProjNo),EngType from Trouble_Data');
    SQL.Add('where EngType = :param1 order by ProjNo DESC');
    parambyname('param1').AsString := EngType.Text;
    Open;

    PROJNO.Items.Clear;
    while not(Eof) do
    begin
      PROJNO.Items.Add(Fieldbyname('PROJNO').AsString);
      Next;
    end;
  end;
end;

procedure TDetailS_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDetailS_Frm.FormCreate(Sender: TObject);
begin
  Initialize_;


end;

procedure TDetailS_Frm.Get_Trouble_Type_List_From_Trouble_Data;
var
  li,lc : integer;
  LtroubleList : TStringList;
  LStr : String;
  Ladd : Boolean;
  LTrouble : String;
begin

  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TROUBLETYPE1,TROUBLETYPE2,TROUBLETYPE3,TROUBLETYPE4,TROUBLETYPE5 ');
    SQL.Add('from Trouble_Data');
    Open;

    LtroubleList := TStringList.Create;
    while not eof do
    begin
      for li := 0 to 4 do
      begin
        LStr := Fields[li].AsString;
        if not(LStr = '') then
          LtroubleList.Add(LStr);

      end;
      Next;
    end;

    LtroubleList.Sort;

    try
      for lc := 0 to LtroubleList.Count-1 do
      begin
        with trType do
        begin
          LTrouble := LtroubleList.Strings[lc];
          if not(RowCount = 0) then
          begin
            for li := 0 to RowCount-1 do
            begin
              Ladd := true;
              if Cells[1,li] = LTrouble then
              begin
                Ladd := false;
                Break;
              end;
            end;
            if Ladd = True then
            begin
              AddRow(1);
              Cells[1,RowCount-1] := LTrouble;
            end;
          end
          else
          begin
            AddRow(1);
            Cells[1,0] := LTrouble;
          end;
        end;
      end;

      with trType do
      begin
        for lc := 0 to RowCount-1 do
        begin
          with OraQuery1 do
          begin
            LStr := Cells[1,lc];
            Close;
            SQL.Clear;
            SQL.Add('select A.Data, B.Data from Trouble_Root A, Trouble_Type B ');
            SQL.Add('where B.code = :param1 and A.CODE = B.PCODE');
            parambyname('param1').AsString := LStr;
            Open;

            LStr := '';
            LStr := Fieldbyname('Data').AsString+'-'+Fieldbyname('Data_1').AsString;

            Cells[2,lc] := LStr;
          end;
        end;
      end;
    finally
      trType.Refresh;
    end;
  end;
end;

procedure TDetailS_Frm.inempnoDropDown(Sender: TObject);
var
  lc : integer;
  LStr : String;
begin
  if InempNo.Items.Count = 0 then
  begin
    InempNo.Clear;
    InempNo.Items.Clear;
    FinEmpNoID := TStringList.Create;
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select distinct a.inempno, b.name_kor, b.class, C.CODENM from Trouble_Data a, ');
      SQL.Add(' user_info b, ZHITEMSCODE C where inempno = userid');
      SQL.Add(' and b.Class = C.CODE order by Name_Kor');
      Open;

      if not(RecordCount = 0) then
      begin
        for lc := 0 to RecordCount -1 do
        begin
          FinEmpNoID.Add(Fieldbyname('INEMPNO').AsString);
          LStr := Check_for_CODENM_Base_on_CODE(Fieldbyname('CLASS').AsString);
          INEMPNO.Items.Add(LStr+' '+Fieldbyname('Name_Kor').AsString);
          Next;
        end;
      end;//if
    end;//with
  end;
end;

procedure TDetailS_Frm.Initialize_;
var
  li : integer;
begin
  if Assigned(FEmpNoID) then
    FEmpNoID.Free;
  if Assigned(FInEmpNoID) then
    FInEmpNoID.Free;
  if Assigned(FkeyFields) then
    FkeyFields.Free;

  FtrTypeChk := False;
  Set_Feilds_to_Local;
  Get_Trouble_Type_List_From_Trouble_Data;

  for li := 0 to rpType.Items.Count-1 do
    rpType.Checked[li] := True;

  keyWord.Text := '';
  trGrid.MouseActions.WheelAction := waScroll;

end;

procedure TDetailS_Frm.Search_In_Trouble_Data;
var
  LSQL : String;
  LStr : String;
  LEngList : TStringList;
  li: Integer;
begin
  LSQL := 'Select * from Trouble_Data ';

  //check Report Type
  LStr := Check_for_rpType;
  if not(LStr = 'Failed') then
    LSQL := LSQL + LStr
  else
  begin
    ShowMessage('보고서 타입을 선택하여 주십시오!!!');
    Exit;
  end;

  //키워드 검색 범위
  if not(keyWord.Text = '') then
  begin
    LStr := Check_for_keyGrp;
    if not(LStr = 'Failed') then
      LSQL := LSQL + LStr
    else
    begin
      ShowMessage('Keyword 검색 범위를 선택하여 주십시오!!!');
      Exit;
    end;
  end;

  LStr := Check_for_trType;
  if not(LStr = 'Failed') and not(LStr = '') then
    LSQL := LSQL + LStr;

  //유형외 검색 범위
  LStr := Check_for_trGrp;
  if not(LStr = 'Failed') then
    LSQL := LSQL + LStr;

  if not(engType.Text = '') then
  begin
    try
      LEngList := TStringList.Create;
      LEngList.Delimiter := ',';
      LEngList.DelimitedText := engType.Text;

      for li := 0 to LEngList.Count-1 do
      begin
        if li = 0 then
          LSQL := LSQL + ' and (upper(ENGTYPE) LIKE ''%'+LEngList.Strings[li]+'%'''
        else
          LSQL := LSQL + ' or upper(ENGTYPE) LIKE ''%'+LEngList.Strings[li]+'%'''

      end;
      LSQL := LSQL + ')';
    finally
      FreeAndNil(LEngList);
    end;
  end;

  if not(projNo.Text = '') then
    LSQL := LSQL + ' and (PROJNO ='''+projNo.Text+''')';

  if not(inempNo.Text = '') then
    LSQL := LSQL + ' and (INEMPNO ='''+FinempNoId.Strings[inempno.ItemIndex]+''')';

  if not(empno.Text = '') then
    LSQL := LSQL + ' and (EMPNO ='''+FempNoId.Strings[empno.ItemIndex]+''')';

  case orderby.ItemIndex of
    0 : LStr := ' order by SDate';
    1 : LStr := ' order by InDate';
  end;

  case trAlign.ItemIndex of
    1 : LStr := LStr + ' DESC';
  end;

  LSQL := LSQL + LStr;

  with trGrid do
  begin
    BeginUpdate;
    try
      RemoveRows(1,RowCount-1);
      AddRow;
      FixedRows := 1;
      
      AutoSize := false;
      with OraQuery3 do
      begin
        Active := False;
        Close;
        SQL.Clear;
        SQL.Add(LSQL);
        open;

        if not(RecordCount = 0) then
        begin
          NxHeaderPanel1.Caption := '검색결과 - 총( '+IntToStr(RecordCount)+' )건의 보고서가 검색 되었습니다.';
          RowCount := RecordCount+1;
          li := 0;
          while not eof do
          begin
            Inc(li);

            Cells[1,li] := FieldByName('CODEID').AsString;
            Cells[2,li] := FieldByName('TITLE').AsString;
            Cells[3,li] := FieldByName('ENGTYPE').AsString;
            Cells[4,li] := FieldByName('INDATE').AsString;
            Cells[5,li] := FieldByName('INDATE').AsString;            
            
            Cells[6,li] := FieldByName('ITEMNAME').AsString;
            Cells[7,li] := FieldByName('STATUS').AsString;
            Cells[8,li] := FieldByName('REASON').AsString;
            Cells[9,li] := FieldByName('PLAN').AsString;
            Cells[10,li] := FieldByName('REASON1').AsString;
            Cells[11,li] := FieldByName('RESULT').AsString;
            
            Next;
          end;
        end
        else
          NxHeaderPanel1.Caption := '검색결과 - 검색된 데이터가 없습니다.';
      end;
    finally
      trGrid.AutoSize := true;
      trGrid_Alignment;
      trGrid.EndUpdate;
    end;
  end;
end;

procedure TDetailS_Frm.Set_Feilds_to_Local;
begin
  FkeyFields := TStringList.Create;

  FkeyFields.Add('TITLE');
  FkeyFields.Add('ITEMNAME');
  FkeyFields.Add('STATUS');
  FkeyFields.Add('REASON');
  FkeyFields.Add('PLAN');

  FkeyFields.Add('REASON1');
  FkeyFields.Add('RESULT');

end;



procedure TDetailS_Frm.Show_of_the_Detail;
var
  LCodeId : String;
  LForm : TTrouble_Frm;
begin
  if not(trGrid.RowCount = 0) then
  begin
    LCodeId := trGrid.Cells[1,FxRow];
    try
      LForm := TTrouble_Frm.Create(self);
      with LForm do
      begin
        Caption := '문제점 보고서 문서 상세조회';
        FOpenCase := 2;
        FRpCode := LCodeId;
        Show;
      end;
    finally
    end;
  end;
end;

procedure TDetailS_Frm.trGridDblClick(Sender: TObject);
begin
  Show_of_the_Detail;
end;

procedure TDetailS_Frm.trGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
  var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then
    HAlign := taCenter;
end;

procedure TDetailS_Frm.trGridGetDisplText(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
var
  lCell, lCell1 : String;
  lref, lref1 : String;
  lpos : integer;
  lvalue : String;
  lorigin : String;
begin
  if AROW > 0 then
  begin
    if not(Value = '') then
    begin
      lref := keyWord.Text;

      lorigin := Value;
      lvalue := uppercase(Trim(lorigin));
      lpos := POS(lref, lvalue);

      if lPos > 0 then
      begin
        lCell := Copy(lorigin, 0, lPos-1);
        lCell1 := Copy(lorigin, lPos+Length(lref), Length(lorigin));

        Value := lCell+'<FONT COLOR = "clRed"><B>' + lRef + '</B></FONT>' + lCell1;
      end;
    end;
  end;
end;

procedure TDetailS_Frm.trGridScrollCell(Sender: TObject; ACol, ARow,
  ScrollPosition, ScrollMin, ScrollMax: Integer);
begin
  StatusBar1.panels[5].Text := 'scroll: '+ inttostr(Acol)+':'+inttostr(ARow)+' position '+  inttostr(ScrollPosition)+' in range ['+inttostr(scrollmin)+'..'+inttostr(scrollmax)+']';
end;

procedure TDetailS_Frm.trGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  sp: TScrollProp;
begin
  FxRow := ARow;
end;

procedure TDetailS_Frm.TrGrid_Alignment;
var
  li : integer;
begin
  with trGrid do
  begin
    BeginUpdate;
    try
      DefaultRowHeight := 60;
      RowHeights[0] := 23;
      ColWidths[1] := 0;
    
      Cells[2,0] := 'TITLE';
      Cells[3,0] := '엔진타입';
      Cells[4,0] := '등록일';
      Cells[5,0] := '발생일';      

      ColWidths[6] := 250;
      trGrid.Cells[6,0] := '품명';

      ColWidths[7] := 250;      
      trGrid.Cells[7,0] := '문제현상';

      ColWidths[8] := 250;      
      trGrid.Cells[8,0] := '추정원인';

      ColWidths[9] := 250;
      trGrid.Cells[9,0] := '대책방안';

      ColWidths[10] := 250;      
      trGrid.Cells[10,0] := '발생원인';

      ColWidths[11] := 250;      
      trGrid.Cells[11,0] := '조치사항';

      for li := 1 to ColCount-1 do
      begin
        AddScrollBar(6,li,True);
        AddScrollBar(7,li,True);
        AddScrollBar(8,li,True);
        AddScrollBar(9,li,True);
        AddScrollBar(10,li,True);
        AddScrollBar(11,li,True);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TDetailS_Frm.trtypeHeaderClick(Sender: TObject; ACol: Integer);
var
  li : integer;
begin
  if ACol = 0 then
  begin
    for li := 0 to trType.RowCount-1 do
    begin
      if FtrTypeChk then
          trType.Cell[0,li].AsBoolean := False
      else
          trType.Cell[0,li].AsBoolean := True;
    end;

    if FtrTypeChk then
        FtrTypeChk := False
    else
        FtrTypeChk := True;
  end;
end;

end.
