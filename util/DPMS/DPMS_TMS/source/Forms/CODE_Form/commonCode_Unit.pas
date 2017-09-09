unit commonCode_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AeroButtons,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, JvExControls, JvLabel, Vcl.ImgList, NxColumnClasses, NxColumns,
  Vcl.Menus, Ora, iComponent, iVCLComponent, iCustomComponent, iPipe, iLed,
  iLedArrow;

type
  TcommonCode_Frm = class(TForm)
    ImageList16x16: TImageList;
    JvLabel1: TJvLabel;
    Panel8: TPanel;
    Image1: TImage;
    JvLabel2: TJvLabel;
    grid_Cat: TNextGrid;
    grid_Code: TNextGrid;
    et_filter: TEdit;
    AeroButton4: TAeroButton;
    NxTextColumn2: TNxTextColumn;
    NxNumberColumn1: TNxNumberColumn;
    NxImageColumn1: TNxImageColumn;
    et_codeName: TEdit;
    PopUp_Cat: TPopupMenu;
    menu_NewCat: TMenuItem;
    menu_CatEdit: TMenuItem;
    NxTextColumn1: TNxTreeColumn;
    btn_Add: TAeroButton;
    NxIncrementColumn2: TNxIncrementColumn;
    CodeText: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxNumberColumn3: TNxNumberColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    btn_Check: TAeroButton;
    NxCheckBoxColumn1: TNxImageColumn;
    btn_Del: TAeroButton;
    iPipe1: TiPipe;
    iPipe2: TiPipe;
    iPipe3: TiPipe;
    iPipe4: TiPipe;
    Panel1: TPanel;
    JvLabel3: TJvLabel;
    Panel5: TPanel;
    btn_Up: TAeroButton;
    btn_Down: TAeroButton;
    grid_Group: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxListColumn1: TNxTextColumn;
    NxListColumn2: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    menu_CatDel: TMenuItem;
    btn_DelCode: TAeroButton;
    NxIncrementColumn3: TNxIncrementColumn;
    ImageList24x24: TImageList;
    ImageList32x32: TImageList;
    pn_Main: TPanel;
    JvLabel22: TJvLabel;
    btn_Close: TAeroButton;
    NxImageColumn2: TNxImageColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    popup_Cd: TPopupMenu;
    N1: TMenuItem;
    cb_categoryHeader: TComboBox;
    JvLabel4: TJvLabel;
    cb_codeType: TComboBox;
    iLedArrow1: TiLedArrow;
    iLedArrow2: TiLedArrow;
    CatVisibleText: TNxTextColumn;
    CodeVisibleText: TNxTextColumn;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    GroupVisibleText: TNxTextColumn;
    Reg_Alias_Code: TNxTextColumn;
    Reg_Alias_Code_Type: TNxTextColumn;
    RegId: TNxTextColumn;
    RegPosition: TNxTextColumn;
    CodeVisibleAllCB: TCheckBox;
    CatVisibleAllCB: TCheckBox;
    GroupVisibleAllCB: TCheckBox;
    procedure grid_CatMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure menu_NewCatClick(Sender: TObject);
    procedure btn_AddClick(Sender: TObject);
    procedure AeroButton4Click(Sender: TObject);
    procedure menu_CatEditClick(Sender: TObject);
    procedure grid_CodeSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure grid_GroupSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure grid_CatSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure btn_DelClick(Sender: TObject);
    procedure btn_CheckClick(Sender: TObject);
    procedure et_filterChange(Sender: TObject);
    procedure btn_UpClick(Sender: TObject);
    procedure btn_DownClick(Sender: TObject);
    procedure btn_DelCodeClick(Sender: TObject);
    procedure menu_CatDelClick(Sender: TObject);
    procedure grid_GroupCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure btn_CloseClick(Sender: TObject);
    procedure grid_CodeCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure N1Click(Sender: TObject);
    procedure cb_categoryHeaderDropDown(Sender: TObject);
    procedure cb_categoryHeaderSelect(Sender: TObject);
    procedure cb_codeTypeDropDown(Sender: TObject);
    procedure cb_codeTypeSelect(Sender: TObject);
    procedure grid_CodeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
    FChanged : Boolean;
    FCategoryNo : String;
    FCodeType : String;
    function Get_CodeSeqNo:Integer;
    procedure SetCodeVisible(AVisibleType: string; AVisible: integer);
  public
    { Public declarations }
    procedure Get_CodeCategory(aCat_No:String);
    procedure Get_CodeCategory2(aCat_No, aSql:String);
    procedure Get_Code(aCodeType:String);
    procedure Get_CodeGroup(aCatNo:String);
    procedure SetGrid_Cat(AQry: TOraQuery);

    function Insert_HITEMS_CODE_GROUP(aRow:Integer): string;
    procedure Update_Category_SeqNo;
    procedure Update_Code_Group_SeqNo;

    procedure Update_Code_Visible(ACode, AVisibleType: string);
    procedure Insert_DPMS_CODE_VISIBLE(ACode, AVisibleType: string; ACodeType: integer);
    procedure InsertOrUpdate_Code_Visible(ACode, AVisibleType: string; ACodeType: integer);
    function CheckChangeCode(ARowId: integer): boolean;
//    procedure ApplyCodeVisibleChanged2CodeGrp(ACode: string; AAliasType: integer);

    procedure SetUI;

    procedure SetCodeType(aCodeType:String);
    procedure SetCategoryNo(aCategoryNo:String);
    property SelectedCodeType : String read FCodeType write SetCodeType;
    property StartCategoryNo : String read FCategoryNo write SetCategoryNo;
  end;

var
  commonCode_Frm: TcommonCode_Frm;
  function Create_commonCode_Frm:Boolean;

implementation
uses
  sheetManagement_Unit,
  HiTEMS_TMS_CONST,
  HiTEMS_TMS_COMMON,
  codeCategory_Unit,
  DataModule_Unit;

{$R *.dfm}

function Create_commonCode_Frm:Boolean;
begin
  Result := False;
  commonCode_Frm := TcommonCode_Frm.Create(nil);
  try
    with commonCode_Frm do
    begin
      FChanged := False;

      SetCategoryNo('');
      SetCodeType('');
      SetUI;

      ShowModal;

      Result := FChanged;

    end;
  finally
    FreeAndNil(commonCode_Frm);
  end;
end;

//procedure TcommonCode_Frm.ApplyCodeVisibleChanged2CodeGrp(ACode: string;
//  AAliasType: integer);
//var
//  LCatNo, LGroup: string;
//  LCatVisible, LGroupVisible: integer;
//  OraQuery : TOraQuery;
//  LExec: Boolean;
//begin
//  OraQuery := TOraQuery.Create(nil);
//  try
//    OraQuery.Session := DM1.OraSession1;
//
//    with OraQuery do
//    begin
//      Close;
//      SQL.Clear;
//      SQL.Add('SELECT GRP_NO, CAT_NO FROM DPMS_CODE_GROUP ' +
//                       'WHERE CODE = :param1 ');
//      ParamByName('param1').AsString := ACode;
//      Open;
//
//      while not Eof do
//      begin
//        LGroup := FieldByName('GRP_NO').AsString;
//        LCatNo := FieldByName('CAT_NO').AsString;
//
//        with DM1.OraQuery1 do
//        begin
//          LCatVisible := -1;
//          LGroupVisible := -1;
//
//          Close;
//          SQL.Clear;
//          SQL.Add('SELECT ALIAS_CODE_TYPE FROM DPMS_CODE_VISIBLE ' +
//                  'WHERE CODE_ID = :CODE_ID ');
//          ParamByName('CODE_ID').AsString    := LCatNo;
//          Open;
//
//          if RecordCount > 0 then
//            LCatVisible := FieldByName('ALIAS_CODE_TYPE').AsInteger;
//
//          if AAliasType > LCatVisible then
//          begin
////            if LCodeVisible = -1 then  //Group Type이 부서인 경우(DPMS_CODE_VISIBLE에 데이터 없음)
////            begin
////              데이터가 없다는 것은 Code의 Alias Type이 부서란 뜻이므로 AAliasType으로 Update해야 함
////            end
////            else  //데이터가 존재하고 변경해야 할 경우
////            begin
//            if AAliasType <> Ord(atDepart) then //변경할 Type이 부서가 아닌 경우
//            begin
//              Close;
//              SQL.Clear;
//              SQL.Add('SELECT ALIAS_CODE_TYPE FROM DPMS_CODE_VISIBLE ' +
//                      'WHERE CODE_ID = :CODE_ID ');
//              ParamByName('CODE_ID').AsString    := LGroup;
//              Open;
//
//              if RecordCount > 0 then
//              begin
//                Close;
//                SQL.Clear;
//                SQL.Add('UPDATE DPMS_CODE_VISIBLE SET ' +
//                        '   CODE_TYPE = :CODE_TYPE, ' +
//                        '   ALIAS_CODE = :ALIAS_CODE, ALIAS_CODE_TYPE = :ALIAS_CODE_TYPE, ' +
//                        '   VISIBLE_TYPE = : VISIBLE_TYPE, MODID = :MODID, MODDATE = :MODDATE ' +
//                        'WHERE CODE_ID = :CODE_ID ');
//              end
//              else
//              begin
//                Close;
//                SQL.Clear;
//                SQL.Add('INSERT INTO DPMS_CODE_VISIBLE ' +
//                        'VALUES ' +
//                        '( ' +
//                        '   :CODE_ID, :CODE_TYPE, :ALIAS_CODE, :ALIAS_CODE_TYPE, :VISIBLE_TYPE, :MODID, :MODDATE ' +
//                        ') ')
//              end;
//
//              ParamByName('CODE_ID').AsString := LGroup;
//              ParamByName('CODE_TYPE').AsInteger := Ord(ctGroup);  //2: Group
//              ParamByName('ALIAS_CODE').AsInteger := DM1.FUserInfo.AliasCode;
//              ParamByName('ALIAS_CODE_TYPE').AsInteger := AAliasType;
//              ParamByName('VISIBLE_TYPE').AsInteger := Ord(vtShow);
//              ParamByName('MODID').AsString := DM1.FUserInfo.CurrentUsers;
//              ParamByName('MODDATE').AsDateTime := Now;
//
//              ExecSQL;
//            end
//            else  //변경할 Type이 부서 인 경우에는 삭제함
//            begin
//              Close;
//              SQL.Clear;
//              SQL.Add('DELETE FROM DPMS_CODE_VISIBLE ' +
//                      'WHERE CODE_ID = :CODE_ID AND CODE_TYPE = :CODE_TYPE ');
//              ParamByName('CODE_ID').AsString := LGroup;
//              ParamByName('CODE_TYPE').AsInteger := Ord(ctGroup);
//
//              ExecSQL;
//            end;
////            end;
//          end;
//        end;
//
//        OraQuery.Next;
//      end;
//    end;
//  finally
//    FreeAndNil(OraQuery);
//  end;
//end;

procedure TcommonCode_Frm.btn_AddClick(Sender: TObject);
var
  i,j,
  LRow : Integer;
  msg, LCode : String;
  LCatRow, LCodeRow : Integer;
begin
  with grid_Group do
  begin
    BeginUpdate;
    try
      LCatRow := -1;
      for i := 0 to grid_Cat.RowCount-1 do
      begin
        if grid_Cat.Cell[0,i].AsInteger = 1 then
        begin
          LCatRow := i;
          Break;
        end;
      end;

      if LCatRow = -1 then
      begin
        ShowMessage('먼저 카테고리를 선택하여 주십시오!');
        grid_Cat.SetFocus;
        Exit;
      end;

      LCodeRow := -1;
      for i := 0 to grid_Code.RowCount-1 do
      begin
        if grid_Code.Cell[1,i].AsInteger = 1 then
        begin
          LCodeRow := i;
          Break;
        end;
      end;

      if LCodeRow = -1 then
      begin
        ShowMessage('최소 한 개 이상의 코드를 선택하여 주십시오!');
        grid_Code.SetFocus;
        Exit;
      end;

      for i := 0 to grid_Code.RowCount-1 do
      begin
        if grid_Code.Cell[1,i].AsInteger = 1 then //Check 된 것이면
        begin
          msg := '';

          for j := 0 to RowCount-1 do
          begin
            LCode := Cells[3,j] + Cells[4,j];
            if SameText(LCode, grid_Cat.Cells[2,LCatRow] + grid_Code.Cells[2,i]) then
            begin
              msg := '같은 코드가 등록되어있습니다.'+#10#13+
                     '코드명:('+grid_Code.Cells[3,i]+')';
              Break;
            end;
          end;

          if msg <> '' then
            ShowMessage(msg)
          else
          begin
            LRow := AddRow;
            for j := 0 to Columns.Count-1 do
              Cell[j,LRow].TextColor := clBlue;

            Cells[1,LRow] := grid_Cat.Cells[1,LCatRow];
            Cells[2,LRow] := grid_Code.Cells[3,i];
            Cells[3,LRow] := grid_Cat.Cells[2,LCatRow];
            Cells[4,LRow] := grid_Code.Cells[2,i];
            Cells[6,LRow] := DM1.FUserInfo.UserName;

            //Category와 Code의 범위 중 더 좁은(엄격한) 범위를 따라감
            CellByName['GroupVisibleText', LRow].AsString :=
              GetStrictAliasType(grid_Cat.CellByName['CatVisibleText', LCatRow].AsString,
                                  grid_Code.CellByName['CodeVisibleText', i].AsString);
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.btn_CheckClick(Sender: TObject);
var
  i : Integer;
  LGroupNo, LVisible:String;
begin
  with grid_Group do
  begin
    BeginUpdate;
    try
      FChanged := True;
      for i := 0 to RowCount-1 do
      begin
        if (Cell[1,i].TextColor = clBlue) AND (Cells[5,i] = '') then
        begin
          LGroupNo := Insert_HITEMS_CODE_GROUP(i);
          LVisible := CellByName['GroupVisibleText', i].AsString;

//          if String2ALIAS_TYPE(LVisible)  > atDepart then
//            Insert_DPMS_CODE_VISIBLE(LGroupNo, LVisible, Ord(ctGroup));

          sleep(10);
        end else
        begin
          if (Cell[1,i].TextColor = clBlue) AND (Cells[5,i] <> '') then
          begin
            //Update

          end;
        end;
      end;

      if RowCount <> 0 then
      begin
        Update_Code_Group_SeqNo;
      end;

      if MessageDlg('선택된 작업 카테고리 및 코드의 체크박스를 해제 하시겠습니까?',
                     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        for i := 0 to grid_Cat.RowCount-1 do
          grid_Cat.Cell[0,i].AsInteger := 0;

        for i := 0 to grid_Code.RowCount-1 do
          grid_Code.Cell[1,i].AsInteger := 0;
      end;

      Get_CodeGroup(grid_Cat.Cells[2,grid_Cat.SelectedRow]);

    finally
      FChanged := True;
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TcommonCode_Frm.btn_DelClick(Sender: TObject);
var
  i,
  LRow : Integer;
  LGrpNo : String;
begin
  with grid_Group do
  begin
    BeginUpdate;
    try
      if SelectedRow = -1 then
        Exit;

      LRow := SelectedRow;
      if MessageDlg('선택된 코드를 삭제 하시겠습니까? 삭제된 코드는 복구할 수 없습니다.',
                     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        FChanged := True;
        btn_Del.Enabled := False;

        with DM1.OraTransaction1 do
        begin
          StartTransaction;
          try
            LGrpNo := Cells[5,LRow];
            with DM1.OraQuery1 do
            begin
              //그룹코드 삭제
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM DPMS_CODE_GROUP ' +
                      'WHERE GRP_NO LIKE :param1 ');
              ParamByName('param1').AsString := LGrpNo;
              ExecSQL;

              DeleteRow(LRow);

            end;

            if RowCount <> 0 then
              Update_Category_SeqNo;

            Commit;
          except
            Rollback;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.btn_DelCodeClick(Sender: TObject);
var
  i : Integer;
  LResult : Boolean;
  LCode: string;
begin
  with grid_Code do
  begin
    BeginUpdate;
    try
      LResult := False;
      for i := 0 to RowCount-1 do
      begin
        if Cell[1,i].AsInteger > 0 then
        begin
          LResult := True;
          Break;
        end;
      end;

      if LResult then
      begin
        if MessageDlg('삭제 하시겠습니까? 삭제된 코드는 복구할 수 없습니다.',
                       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          for i:= RowCount-1 DownTo 0 do
          begin
            if Cell[1,i].AsInteger = 1 then
            begin
              LCode := Cells[2,i];

              with DM1.OraQuery1 do
              begin
                Close;
                SQL.Clear;
                SQL.Add('DELETE FROM DPMS_CODE ' +
                        'WHERE CODE = :param1 ');
                ParamByName('param1').AsString := LCode;
                ExecSQL;

                Close;
                SQL.Clear;
                SQL.Add('DELETE FROM DPMS_CODE_VISIBLE ' +
                        'WHERE CODE_ID = :CODE_ID AND CODE_TYPE = :CODE_TYPE');
                ParamByName('CODE_ID').AsString := LCode;
                ParamByName('CODE_TYPE').AsInteger := 3;
                ExecSQL;

                DeleteRow(i);
              end;
            end;
          end;

          for i := 0 to RowCount-1 do
          begin
            with DM1.OraQuery1 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('UPDATE DPMS_CODE SET ' +
                      'SEQ_NO = :SEQ_NO ' +
                      'WHERE CODE = :param1 ');
              ParamByName('param1').AsString := Cells[2,i];
              ParamByName('SEQ_NO').AsInteger := Cell[0,i].AsInteger;

              ExecSQL;
            end;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.btn_DownClick(Sender: TObject);
var
  i : Integer;
  LToRow,
  LFromRow : Integer;
begin
  with grid_Group do
  begin
    BeginUpdate;
    try
      LToRow := GetNextSibling(SelectedRow);
      LFromRow := SelectedRow;

      MoveRow(LFromRow, LToRow);
      SelectedRow := LToRow;
      SetFocus;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.btn_UpClick(Sender: TObject);
var
  i,
  LToRow,
  LFromRow : Integer;
begin
  with grid_Group do
  begin
    BeginUpdate;
    try
      LToRow := GetPrevSibling(SelectedRow);
      LFromRow := SelectedRow;

      MoveRow(LFromRow, LToRow);
      SelectedRow := LToRow;
      SetFocus;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.cb_categoryHeaderDropDown(Sender: TObject);
begin
  with cb_categoryHeader.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM DPMS_CODE_CATEGORY ' +
                'WHERE PARENT_NO IS NULL AND USE_YN = ''Y''' +
                'ORDER BY SEQ_NO ');
        Open;

        if RecordCount > 0 then
        begin
          Add('');
          while not eof do
          begin
            Add(FieldByName('CAT_NAME').AsString);
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.cb_categoryHeaderSelect(Sender: TObject);
begin
  with cb_categoryHeader.Items do
  begin
    BeginUpdate;
    try
      if cb_categoryHeader.ItemIndex = 0 then
      begin
        SetCategoryNo('');
        Exit;
      end;

      with DM1.OraQuery1 do
      begin
        First;
        while not eof do
        begin
          if RecNo = cb_categoryHeader.ItemIndex then
          begin
            SetCategoryNo(FieldByName('CAT_NO').AsString);
            Get_CodeCategory(StartCategoryNo);

            Break;
          end;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.cb_codeTypeDropDown(Sender: TObject);
begin
  with cb_codeType.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM DPMS_CODE_TYPE A, DPMS_USER B, DPMS_DEPT C, DPMS_DEPT_ALIAS D ' +
                'WHERE USE_YN = ''Y'' AND ' +
                '      A.REG_ID = B.USERID AND B.DEPT_CD = C.DEPT_CD AND ' +
                '      C.PARENT_CD = D.DEPT_CODE ' +
                'ORDER BY SEQ_NO ');
//        SQL.Add('SELECT * FROM DPMS_CODE_TYPE ' +
//                'WHERE USE_YN LIKE ''Y'' ' +
//                'ORDER BY SEQ_NO ');
        Open;
        Add('');
        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            Add(FieldByName('TYPE_NAME').AsString);
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.cb_codeTypeSelect(Sender: TObject);
begin
  with cb_codeType.Items do
  begin
    BeginUpdate;
    try
      if cb_codeType.ItemIndex = 0 then
      begin
        grid_Code.ClearRows;
        et_filter.Clear;
        Exit;
      end;

      with DM1.OraQuery1 do
      begin
        First;
        while not eof do
        begin
          if RecNo = cb_codeType.ItemIndex then
          begin
            SetCodeType(FieldByName('CODE_TYPE').AsString);
            Get_Code(SelectedCodeType);
            Break;
          end;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

//grid_code에서 보이기를 변경할 권한이 있으면  True 반환
function TcommonCode_Frm.CheckChangeCode(ARowId: integer): boolean;
var
  LAlias, LAliasType: integer;
  LId: string;
  LUser: TUserInfo;
begin
  Result := False;
  LId := grid_code.CellByName['RegId', ARowId].AsString;
  LAlias := grid_code.CellByName['Reg_Alias_Code', ARowId].AsInteger;

  //현재 사용자와 기안자가 사번이 같으면 True
  //현재 사용자가 기안자의 팀장이거나 부서장이면 True
  if ( LId = DM1.FUserInfo.UserID) or
    ((LAlias = DM1.FUserInfo.AliasCode_Team) and (DM1.FUserInfo.JobPosition = '직책과장')) or
    (DM1.FUserInfo.JobPosition = '부서장') then
    Result := True;
end;

procedure TcommonCode_Frm.et_filterChange(Sender: TObject);
var
  i: Integer;
  s: string;
  RowVisible: Boolean;
begin
  for i := 0 to grid_Code.RowCount - 1 do
  begin
    s := UpperCase(et_filter.Text);
    RowVisible := (s = '') or (Pos(s, UpperCase(grid_Code.Cell[3, i].AsString)) > 0);
    grid_Code.RowVisible[i] := RowVisible;
  end;
end;

procedure TcommonCode_Frm.AeroButton4Click(Sender: TObject);
var
  LCode : String;
begin
  if cb_codeType.Text = '' then
  begin
    cb_codeType.SetFocus;
    raise Exception.Create('코트분류를 선택하여 주십시오!');
  end;

  if et_codeName.Text <> '' then
  begin
    LCode := 'CDN'+FormatDateTime('YYYYMMDDHHMMSSZZZ',Now);
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
//        SQL.Add('SELECT CODE_NAME FROM DPMS_CODE ' +
//                'WHERE CODE_NAME = :param1 ');
        //등록자의 부서가 다르면 CODE_NAME이 같아도 됨
        SQL.Add('SELECT A.CODE_NAME FROM ( ' +
                '  SELECT A.*, B.USERID, B.NAME_KOR, B.POSITION, D.ALIAS_CODE ' +
                '  FROM DPMS_CODE A, DPMS_USER B, DPMS_DEPT C, DPMS_DEPT_ALIAS D ' +
                '  WHERE A.CODE_NAME = :CODE_NAME AND USE_YN = ''Y'' AND ' +
                '        A.REG_ID = B.USERID AND B.DEPT_CD = C.DEPT_CD AND ' +
                '        C.PARENT_CD = D.DEPT_CODE AND D.ALIAS_CODE = :ALIAS_CODE) A LEFT OUTER JOIN DPMS_CODE_VISIBLE B ' +
                '        ON A.CODE = B.CODE_ID' );
        ParamByName('CODE_NAME').AsString := et_codeName.Text;
        ParamByName('ALIAS_CODE').AsInteger := DM1.FUserInfo.AliasCode_Dept;
        Open;

        if RecordCount = 0 then
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO DPMS_CODE ' +
                  '( ' +
                  '   CODE, CODE_TYPE, CODE_NAME, CODE_DESC, SEQ_NO, USE_YN, REG_ID, REG_DATE ' +
                  ') VALUES ' +
                  '( ' +
                  '   :CODE, :CODE_TYPE, :CODE_NAME, :CODE_DESC, :SEQ_NO, :USE_YN, :REG_ID, :REG_DATE ' +
                  ') ');

          ParamByName('CODE').AsString      := LCode;
          ParamByName('CODE_TYPE').AsString := SelectedCodeType;
          ParamByName('CODE_NAME').AsString := et_codeName.Text;
          ParamByName('CODE_DESC').AsString := '';
          ParamByName('SEQ_NO').AsInteger   := Get_CodeSeqNo;
          ParamByName('USE_YN').AsString    := 'Y';
          ParamByName('REG_ID').AsString    := DM1.FUserInfo.CurrentUsers;
          ParamByName('REG_DATE').AsDateTime:= Now;

          ExecSQL;

          //처음 생성할 때는 부서 보이기 이며 Visible 테이블에 추가 할 필요 없음
//          InsertOrUpdate_Code_Visible(LCode, ALIAS_TYPE2String(atDepart), Ord(ctCode));

          et_codeName.Clear;
          et_codeName.Hint := '';

          ShowMessage('등록성공!');
        end else
          ShowMessage('같은 이름으로 등록된 코드가 있습니다.');
      end;
    finally
      Get_Code(SelectedCodeType);
    end;
  end;
end;

function TcommonCode_Frm.Get_CodeSeqNo: Integer;
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
      SQL.Add('SELECT MAX(SEQ_NO+1) SEQ_NO FROM DPMS_CODE ');
      Open;

      Result := FieldByName('SEQ_NO').AsInteger;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TcommonCode_Frm.Get_CodeCategory(aCat_No:String);
var
  LSql: string;
begin
  //현재 사용자가 입력한 카테고리만 가져옴
//  LSql := 'SELECT * FROM (' +
//          ' SELECT * FROM ( ' +
//              'SELECT A.*, B.NAME_KOR, D.ALIAS_CODE FROM DPMS_CODE_CATEGORY A, DPMS_USER B, DPMS_DEPT C, DPMS_DEPT_ALIAS D ' +
//              'WHERE USE_YN = ''Y'' AND ' +
//              '      A.REG_ID = B.USERID AND B.DEPT_CD = C.DEPT_CD AND ' +
//              '      C.PARENT_CD = D.DEPT_CODE ' +
//            ') A LEFT OUTER JOIN DPMS_CODE_VISIBLE B ' +
//              'ON A.CAT_NO = B.CODE_ID AND A.ALIAS_CODE = B.ALIAS_CODE ' +
//          ' ) '+
//          'START WITH PARENT_NO = :param1 ' +
//          'CONNECT BY PRIOR CAT_NO = PARENT_NO ' +
//          'ORDER SIBLINGS BY SEQ_NO ';
//  Get_CodeCategory2(aCat_No, LSql);

  LSql := ('SELECT * FROM ' +
          '        (     ' +
          '          SELECT A.*, B.ALIAS_CODE, B.ALIAS_CODE_TYPE FROM '+
          '          (                                                ' +
          '            SELECT A.*, B.NAME_KOR, D.ALIAS_CODE DEPT FROM DPMS_CODE_CATEGORY A, DPMS_USER B, DPMS_DEPT C, DPMS_DEPT_ALIAS D ' +
          '            WHERE USE_YN = ''Y'' AND ' +
          '                  A.REG_ID = B.USERID AND B.DEPT_CD = C.DEPT_CD AND ' +
          '                  C.PARENT_CD = D.DEPT_CODE  AND D.ALIAS_CODE = :DEPT ' +
          '            ) A LEFT OUTER JOIN DPMS_CODE_VISIBLE B ' +
          '        ON A.CAT_NO = B.CODE_ID ' +
          '        ) ' +
          '        START WITH PARENT_NO = :PARENT_NO ' +
          '        CONNECT BY PRIOR CAT_NO = PARENT_NO ' +
          '        ORDER SIBLINGS BY SEQ_NO' );

  Get_CodeCategory2(aCat_No, LSql);
end;

procedure TcommonCode_Frm.Get_CodeCategory2(aCat_No, aSql: String);
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    OraQuery.FetchAll := True;

    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(aSql);

      ParamByName('PARENT_NO').AsString := aCat_No;
      ParamByName('DEPT').AsInteger := DM1.FUserInfo.AliasCode_Dept;
      Open;

//      if RecordCount > 0 then
        SetGrid_Cat(OraQuery);
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TcommonCode_Frm.Get_Code(aCodeType:String);
var
  LRow, iVisible, LAliasCode, LDept : Integer;
  LVisible, LId: string;
begin
  with grid_Code do
  begin
    BeginUpdate;
    try
      ClearRows;
      et_filter.Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear; //현 사용자와 동일한 부서인 기안자의 코드만 가져옴
        SQL.Add('SELECT A.CODE, A.CODE_NAME, A.SEQ_NO, A.CODE_DESC, A.NAME_KOR, A.USERID, A.POSITION, B.ALIAS_CODE, B.ALIAS_CODE_TYPE FROM ( ' +
                '  SELECT A.*, B.USERID, B.NAME_KOR, B.POSITION, D.ALIAS_CODE FROM DPMS_CODE A, DPMS_USER B, DPMS_DEPT C, DPMS_DEPT_ALIAS D ' +
                '  WHERE A.CODE_TYPE = :CODE_TYPE AND USE_YN = ''Y'' AND ' +
                '        A.REG_ID = B.USERID AND B.DEPT_CD = C.DEPT_CD AND ' +
                '        C.PARENT_CD = D.DEPT_CODE AND D.ALIAS_CODE = :ALIAS_CODE) A LEFT OUTER JOIN DPMS_CODE_VISIBLE B ' +
                '        ON A.CODE = B.CODE_ID ' +
                'ORDER BY SEQ_NO');

        ParamByName('CODE_TYPE').AsString := aCodeType;
        ParamByName('ALIAS_CODE').AsInteger := DM1.FUserInfo.AliasCode_Dept;
        Open;

        while not eof do
        begin
          iVisible := FieldByName('ALIAS_CODE_TYPE').AsInteger;
          Lid := FieldByName('USERID').AsString;
          LAliasCode := FieldByName('ALIAS_CODE').AsInteger;

          //개인 보이기 이고 현재 사용자와 코드 기안자가 다르면 표시 안함
          if (iVisible = ord(atPrivate)) and (Lid <> DM1.FUserInfo.UserID)then
          begin
            Next;
            Continue;
          end;

          if not CodeVisibleAllCB.Checked then
          begin
            //팀 보이기 이고 현재 사용자의 팀코드와 코드 기안자의 팀코드가 다르면 표시 안함
            if (iVisible = ord(atTeam)) and (LAliasCode <> DM1.FUserInfo.AliasCode_Team)then
            begin
              Next;
              Continue;
            end;
          end;

          LRow := AddRow;
          Cell[1,LRow].AsInteger := 0;
          Cells[2,LRow] := FieldByName('CODE').AsString;
          Cells[3,LRow] := FieldByName('CODE_NAME').AsString;
          Cell[4,LRow].AsInteger := FieldByName('SEQ_NO').AsInteger;
          Cells[5,LRow] := FieldByName('CODE_DESC').AsString;
          Cells[6,LRow] := FieldByName('NAME_KOR').AsString;

          LVisible := ALIAS_TYPE2String(ALIAS_TYPE(iVisible));

          if LVisible = '' then
            LVisible := ALIAS_TYPE2String(atDepart);

          CellByName['CodeVisibleText', LRow].AsString := LVisible;
          CellByName['Reg_Alias_Code', LRow].AsInteger := LAliasCode;
          CellByName['Reg_Alias_Code_Type', LRow].AsInteger := iVisible;
          CellByName['RegId', LRow].AsString := Lid;
          CellByName['RegPosition', LRow].AsString := FieldByName('POSITION').AsString;

//          with DM1.OraQuery2 do
//          begin
//            Close;
//            SQL.Clear;
//            SQL.Add('SELECT ALIAS_CODE_TYPE ' +
//                    'FROM DPMS_CODE_VISIBLE ' +
//                    'WHERE CODE_ID = :param1 ');
//
//            ParamByName('param1').AsString := DM1.OraQuery1.FieldByName('CODE').AsString;
//            Open;
//
//            if RecordCount > 0 then
//            begin
//              LVisible := ALIAS_TYPE2String(ALIAS_TYPE(FieldByName('ALIAS_CODE_TYPE').AsInteger));
//
//              if LVisible = '' then
//                LVisible := ALIAS_TYPE2String(atDepart);
//
//            end
//            else
//              LVisible := ALIAS_TYPE2String(atDepart);
//
//            CellByName['CodeVisibleText', LRow].AsString := LVisible;
//          end;

          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.Get_CodeGroup(aCatNo: String);
var
  LRow, iVisible, LAliasCode, LDept : Integer;
  LVisible, LId, LCodeName: string;
begin
  with grid_Group do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear; //현 사용자와 동일한 부서인 기안자의 그룹코드만 가져옴
        SQL.Add('SELECT A.CAT_NO, A.CODE, A.GRP_NO, A.NAME_KOR, A.USERID, A.CODE_NAME, A.ALIAS_CODE, A.ALIAS_CODE_TYPE, B.CAT_NAME FROM ( ' +
                ' SELECT A.*, B.ALIAS_CODE TEAM,  B.ALIAS_CODE_TYPE FROM ( ' +
                '   SELECT A.*,b.userid, B.NAME_KOR,b.position, D.ALIAS_CODE FROM DPMS_CODE_GROUP A, DPMS_USER B, DPMS_DEPT C, DPMS_DEPT_ALIAS D ' +
                '   WHERE USE_YN = ''Y'' AND ' +
                '       A.REG_ID = B.USERID AND B.DEPT_CD = C.DEPT_CD AND ' +
                '       C.PARENT_CD = D.DEPT_CODE  AND D.ALIAS_CODE = :ALIAS_CODE AND A.CAT_NO = :CAT_NO) A LEFT OUTER JOIN DPMS_CODE_VISIBLE B ' +
                '       ON A.CAT_NO = B.CODE_ID ' +
                ' ORDER BY SEQ_NO) A, DPMS_CODE_CATEGORY B ' +
                'WHERE A.CAT_NO = B.CAT_NO');
//        SQL.Add('SELECT ' +
//                '   CAT_NAME, CODE_NAME, CAT_NO, CODE, GRP_NO, NAME_KOR ' +
//                'FROM ' +
//                '( ' +
//                '   SELECT A.*, B.CAT_NAME ' +
//                '   FROM DPMS_CODE_GROUP A, DPMS_CODE_CATEGORY B ' +
//                '   WHERE A.CAT_NO = :param1 ' +
//                '   AND A.CAT_NO = B.CAT_NO ' +
//                ') ' +
//                'A LEFT OUTER JOIN DPMS_USER B ' +
//                'ON A.REG_ID = B.USERID ' +
//                'ORDER BY SEQ_NO ');

        ParamByName('CAT_NO').AsString := aCatNo;
        ParamByName('ALIAS_CODE').AsInteger := DM1.FUserInfo.AliasCode_Dept;
        Open;

        while not eof do
        begin
          iVisible := DM1.GetVisibleTypeFromGrp(FieldByName('GRP_NO').AsString, ord(ctGroup), LCodeName, LAliasCode);
          Lid := FieldByName('USERID').AsString;
//          LAliasCode := FieldByName('ALIAS_CODE').AsInteger;

          //개인 보이기 이고 현재 사용자와 코드 기안자가 다르면 표시 안함
          if (iVisible = ord(atPrivate)) and (Lid <> DM1.FUserInfo.UserID)then
          begin
            Next;
            Continue;
          end;

          if not GroupVisibleAllCB.Checked then
          begin
            //팀 보이기 이고 현재 사용자의 팀코드와 코드 기안자의 팀코드가 다르면 표시 안함
            if (iVisible = ord(atTeam)) and (LAliasCode <> DM1.FUserInfo.AliasCode_Team)then
            begin
              Next;
              Continue;
            end;
          end;

          LRow := AddRow;
          Cells[1,LRow] := FieldByName('CAT_NAME').AsString;
          Cells[2,LRow] := FieldByName('CODE_NAME').AsString;
          Cells[3,LRow] := FieldByName('CAT_NO').AsString;
          Cells[4,LRow] := FieldByName('CODE').AsString;
          Cells[5,LRow] := FieldByName('GRP_NO').AsString;
          Cells[6,LRow] := FieldByName('NAME_KOR').AsString;

          LVisible := ALIAS_TYPE2String(ALIAS_TYPE(iVisible));

          if LVisible = '' then
            LVisible := ALIAS_TYPE2String(atDepart);

          CellByName['GroupVisibleText', LRow].AsString := LVisible;;

          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.grid_CatMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lrow : Integer;
begin
  with grid_Cat do
  begin
    if Button = mbRight then
    begin
      if SelectedRow <> -1 then
      begin
        lrow := SelectedRow;
        menu_NewCat.Enabled := True;
        menu_CatEdit.Enabled := True;

      end else
      begin
        menu_NewCat.Enabled := True;
        menu_CatEdit.Enabled := False;

      end;
    end;
  end;
end;

procedure TcommonCode_Frm.grid_CatSelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  i : Integer;
begin
  if ARow = -1 then
    Exit;

  with grid_Cat do
  begin
    BeginUpdate;
    try
      case ACol of
        0 :
        begin
          for i := 0 to grid_Cat.RowCount-1 do
          begin
            if i = ARow then
            begin
              if Cell[0,ARow].AsInteger = 1 then
                Cell[0,ARow].AsInteger := 0
              else
                Cell[0,ARow].AsInteger := 1;
            end
            else
              Cell[0,i].AsInteger := 0;
          end;

        end;
      end;
    finally
      EndUpdate;
    end;
  end;

  Get_CodeGroup(grid_Cat.Cells[2,ARow]);
end;

procedure TcommonCode_Frm.grid_CodeCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  et_codeName.Text := grid_Code.Cells[3,ARow];
end;

procedure TcommonCode_Frm.grid_CodeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i : Integer;
  LPoint: TPoint;
begin
  LPoint.X := X;
  LPoint.Y := Y;

  i := TNxCustomColumn(grid_Code.GetColumnAtPos(LPoint)).Index;

  if i = 7 then
  begin
    for i := 0 to PopupMenu1.Items.Count - 1 do
      PopupMenu1.Items[i].Enabled := True;
  end
  else
  begin
    for i := 0 to PopupMenu1.Items.Count - 1 do
      PopupMenu1.Items[i].Enabled := False;
  end;

end;

procedure TcommonCode_Frm.grid_CodeSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  with grid_Code do
  begin
    BeginUpdate;
    try
      case ACol of
        1 :
        begin
          if Cell[1,ARow].AsInteger = 0 then
            Cell[1,ARow].AsInteger := 1
          else
            Cell[1,ARow].AsInteger := 0;          
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.grid_GroupCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  btn_Del.Enabled := True;

end;

procedure TcommonCode_Frm.grid_GroupSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  with grid_Group do
  begin
    btn_Del.Enabled := False;

    if GetPrevSibling(ARow) > -1 then
      btn_Up.Enabled := True
    else
      btn_Up.Enabled := False;

    if GetNextSibling(ARow) > -1 then
      btn_Down.Enabled := True
    else
      btn_Down.Enabled := False;

    BeginUpdate;
    try
      if Cell[0,ARow].TextColor = clBlue then    
        Btn_Del.Enabled := True
      else
        Btn_Del.Enabled := False;

      
        
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.InsertOrUpdate_Code_Visible(ACode,
  AVisibleType: string; ACodeType: integer);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT CODE_ID FROM DPMS_CODE_VISIBLE ' +
            'WHERE CODE_ID = :CODE_ID');

    ParamByName('CODE_ID').AsString    := ACode;
    Open;

    if RecordCount <= 0 then
      Insert_DPMS_CODE_VISIBLE(ACode, AVisibleType, ACodeType)
    else
      Update_Code_Visible(ACode, AVisibleType);
  end;

end;

procedure TcommonCode_Frm.Insert_DPMS_CODE_VISIBLE(ACode, AVisibleType: string; ACodeType: integer);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO DPMS_CODE_VISIBLE ' +
            'VALUES ' +
            '( ' +
            '   :CODE_ID, :CODE_TYPE, :ALIAS_CODE, :ALIAS_CODE_TYPE, :VISIBLE_TYPE, :MODID, :MODDATE ' +
            ') ');

    ParamByName('CODE_ID').AsString    := ACode;
    ParamByName('CODE_TYPE').AsInteger    := ACodeType;  //1: Category, 3: Code
    ParamByName('ALIAS_CODE').AsInteger    := DM1.FUserInfo.AliasCode_Team;
    ParamByName('ALIAS_CODE_TYPE').AsInteger := Ord(String2ALIAS_TYPE(AVisibleType));//Ord(atDepart); //1: 부서
    ParamByName('VISIBLE_TYPE').AsInteger    := Ord(vtShow);
    ParamByName('MODID').AsString    := DM1.FUserInfo.CurrentUsers;
    ParamByName('MODDATE').AsDateTime    := Now;

    ExecSQL;
  end;
end;

function TcommonCode_Frm.Insert_HITEMS_CODE_GROUP(aRow:Integer): string;
var
  i : Integer;
begin
  Result := '';

  with grid_Group do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO DPMS_CODE_GROUP ' +
                '( ' +
                '   GRP_NO, CAT_NO, CODE, CODE_NAME, SEQ_NO, USE_YN, REG_ID, REG_DATE ' +
                ') VALUES ( ' +
                '   :GRP_NO, :CAT_NO, :CODE, :CODE_NAME, :SEQ_NO, :USE_YN, :REG_ID, :REG_DATE ' +
                ') ');

        Result := 'CDG'+FormatDateTime('YYYYMMDDHHMMSSZZZ',Now);
        ParamByName('GRP_NO').AsString     := Result;
        ParamByName('CAT_NO').AsString     := Cells[3,aRow];
        ParamByName('CODE').AsString       := Cells[4,aRow];
        ParamByName('CODE_NAME').AsString  := Cells[2,aRow];
        ParamByName('SEQ_NO').AsInteger    := Cell[0,aRow].AsInteger;
        ParamByName('USE_YN').AsString     := 'Y';
        ParamByName('REG_ID').AsString     := DM1.FUserInfo.CurrentUsers;
        ParamByName('REG_DATE').AsDateTime := Now;
        ExecSQL;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.menu_CatDelClick(Sender: TObject);
var
  i,
  LRow : Integer;
  LCatNo : String;
begin
  with grid_Cat do
  begin
    BeginUpdate;
    try
      if SelectedRow = -1 then
        Exit;

      FChanged := True;
      LRow := SelectedRow;

      if MessageDlg('삭제된 코드는 복구할 수 없습니다.'+#13#10+
                   // '기존에 코드 그룹에 추가했던 내용도 모두 삭제 됩니다.' +#13#10+
                    '삭제 하시겠습니까?',
                     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        with DM1.OraTransaction1 do
        begin
          StartTransaction;
          try
            LCatNo := Cells[2,LRow];
            grid_Group.ClearRows;

            with DM1.OraQuery1 do
            begin
              //카테고리 삭제
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM DPMS_CODE_CATEGORY ' +
                      'WHERE CAT_NO = :param1 ');
              ParamByName('param1').AsString := LCatNo;
              ExecSQL;

              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM DPMS_CODE_VISIBLE ' +
                      'WHERE CODE_ID = :CODE_ID AND CODE_TYPE = 1 ');
              ParamByName('CODE_ID').AsString := LCatNo;
              ExecSQL;

              DeleteRow(LRow);
            end;

            if RowCount <> 0 then
              Update_Category_SeqNo;

            Commit;
          except
            Rollback;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.menu_CatEditClick(Sender: TObject);
var
  i : Integer;
  LParentNo : String;
begin
  with grid_Cat do
  begin
    FChanged := True;

    if SelectedRow <> -1 then
    begin
      if Create_codeCategory_Frm(Cells[3,SelectedRow],Cells[2,SelectedRow],Cell[5,SelectedRow].AsInteger) then
      begin
        Get_CodeCategory(StartCategoryNo);
        grid_Group.ClearRows;
      end;
    end
  end;
end;

procedure TcommonCode_Frm.menu_NewCatClick(Sender: TObject);
var
  i : Integer;
begin
  with grid_Cat do
  begin
    BeginUpdate;
    try
      FChanged := True;
      if cb_categoryHeader.Text = '' then
      begin
        cb_categoryHeader.SetFocus;
        raise Exception.Create('카테고리를 선택하여 주십시오!');
      end;


      if RowCount = 0 then
        SelectedRow := -1;

      if SelectedRow <> -1 then
        Create_codeCategory_Frm(Cells[2,SelectedRow],'',Cell[5,SelectedRow].AsInteger)
      else
        Create_codeCategory_Frm(StartCategoryNo,'',1);

      Get_CodeCategory(StartCategoryNo);

    finally
      Update_Category_SeqNo;
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.N1Click(Sender: TObject);
begin
  Create_sheetManagement_Frm(grid_Code.Cells[2,grid_Code.SelectedRow], //Code
                             grid_Code.Cells[3,grid_Code.SelectedRow]); //CodeName
end;

procedure TcommonCode_Frm.N2Click(Sender: TObject);
begin
  SetCodeVisible(TMenuItem(Sender).Hint, TMenuItem(Sender).Tag);
end;

procedure TcommonCode_Frm.N3Click(Sender: TObject);
begin
  SetCodeVisible(TMenuItem(Sender).Hint, TMenuItem(Sender).Tag);
end;

procedure TcommonCode_Frm.N4Click(Sender: TObject);
begin
  SetCodeVisible(TMenuItem(Sender).Hint, TMenuItem(Sender).Tag);
end;

procedure TcommonCode_Frm.SetCategoryNo(aCategoryNo: String);
begin
  FCategoryNo := aCategoryNo;
end;

procedure TcommonCode_Frm.SetCodeType(aCodeType: String);
begin
  FCodeType := aCodeType;
end;

procedure TcommonCode_Frm.SetCodeVisible(AVisibleType: string; AVisible: integer);
begin
  if CheckChangeCode(grid_Code.SelectedRow) then
  begin
    grid_Code.Cells[grid_Code.SelectedColumn, grid_Code.SelectedRow] := AVisibleType;
    InsertOrUpdate_Code_Visible(grid_Code.CellsByName['CodeText',grid_Code.SelectedRow], AVisibleType, Ord(ctCode));
  //  ApplyCodeVisibleChanged2CodeGrp(grid_Code.CellsByName['CodeText',grid_Code.SelectedRow],Ord(String2ALIAS_TYPE(AVisibleType)));
  end
  else
    ShowMessage('변경 권한이 없습니다!' + #13#10 + '변경 권한은 기안자 및 기안자의 팀장 또는 부서장에게만 있습니다');
end;

procedure TcommonCode_Frm.SetGrid_Cat(AQry: TOraQuery);
var
  i,
  LRow : Integer;
  LVisible,
  LCatNo: string;
  Lid: string;
  LUser: TUserInfo;
  iVisible, LAliasCode, LDept : Integer;
begin
  with grid_Cat, AQry do
  begin
    BeginUpdate;
    try
      ClearRows;

      while not eof do
      begin
        LCatNo := FieldByName('CAT_NO').AsString;
        Lid := FieldByName('REG_ID').AsString;
        iVisible := FieldByName('ALIAS_CODE_TYPE').AsInteger;
        LAliasCode := FieldByName('ALIAS_CODE').AsInteger;

        //개인 보이기 이고 현재 사용자와 코드 기안자가 다르면 표시 안함
        if (iVisible = ord(atPrivate)) and (Lid <> DM1.FUserInfo.UserID)then
        begin
          Next;
          Continue;
        end;

        if not CatVisibleAllCB.Checked then
        begin
          //팀 보이기 이고 현재 사용자의 팀코드와 코드 기안자의 팀코드가 다르면 표시 안함
          if (iVisible = ord(atTeam)) and (LAliasCode <> DM1.FUserInfo.AliasCode_Team)then
          begin
            Next;
            Continue;
          end;
        end;

//        if Lid <> DM1.FUserInfo.UserID then
//        begin
//          LUser := DM1.Get_User_Info(Lid);
//          LAutho := (Lid = DM1.FUserInfo.UserID) or //현사용자가 기안한 카테고리
//                    ((LUser.AliasCode_Team = DM1.FUserInfo.AliasCode_Team) and (DM1.FUserInfo.JobPosition = '직책과장')) or //현 사용자가 카테고리 기안자의 팀장
//                    ((LUser.AliasCode_Dept = DM1.FUserInfo.AliasCode_Dept) and (DM1.FUserInfo.JobPosition = '부서장')); //현 사용자가 카테고리 기안자의 부서장
//
//          LAlias := DM1.GetVisibleTypeFromCat(LCatNo, LUser.AliasCode_Team);
//          LName := LUser.UserName;
//        end
//        else
//        begin
//          LAutho := True;
//          LName := DM1.FUserInfo.UserName;
//          LAlias := DM1.GetVisibleTypeFromCat(LCatNo, DM1.FUserInfo.AliasCode_Team);;
//        end;
//
//        if not LAutho then
//        begin
//          //현사용자가 카테고리 기안자와 같은 부서이고 카테고리가 부서 보이기 이면(부서 보이기는 Visible에 존재하지 않음)
//          if (LUser.AliasCode_Dept = DM1.FUserInfo.AliasCode_Dept) and (LAlias = -1) then
//          begin
//            LAutho := True;
//          end
//          else
//          if (LUser.AliasCode_Team = DM1.FUserInfo.AliasCode_Team) and (LAlias = ord(atTeam)) then
//          begin
//            LAutho := True;
//          end;
//        end;

        if RowCount = 0 then
          LRow := AddRow
        else
        begin
          if FieldByName('PARENT_NO').AsString <> '' then
          begin
            LRow := -1;
            for i := 0 to RowCount-1 do
            begin
              if Cells[2, i] = FieldByName('PARENT_NO').AsString then
              begin
                AddChildRow(i,crLast);
                LRow := LastAddedRow;
                Break;
              end;
            end;

            if LRow = -1 then
              LRow := AddRow;
          end else
            LRow := AddRow;
        end;

        Cell[0,LRow].AsInteger := 0;
        Cells[1,LRow] := FieldByName('CAT_NAME').AsString;
        Cells[2,LRow] := FieldByName('CAT_NO').AsString;
        Cells[3,LRow] := FieldByName('PARENT_NO').AsString;
        Cell[4,LRow].AsInteger := FieldByName('CAT_LV').AsInteger;
        Cell[5,LRow].AsInteger := FieldByName('SEQ_NO').AsInteger;

//          if FieldByName('USE_YN').AsString = 'Y' then
//            Cell[6,LRow].AsInteger := 2
//          else
//            Cell[6,LRow].AsInteger := 1;

        Cell[7,LRow].AsString := FieldByName('NAME_KOR').AsString;;

        LVisible := ALIAS_TYPE2String(ALIAS_TYPE(iVisible));

        if LVisible = '' then
          LVisible := ALIAS_TYPE2String(atDepart);

        CellByName['CatVisibleText',LRow].AsString := LVisible;
//            CellByName['CatVisibleText',LRow].AsString := DM1.GetVisibleTypeToStr(FieldByName('CAT_NO').AsString, Ord(ctCategory));

        Next;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.SetUI;
begin
  if DM1.FUserInfo.JobPosition = '부서장' then
  begin
    CodeVisibleAllCB.Visible := True;
    CatVisibleAllCB.Visible := True;
    GroupVisibleAllCB.Visible := True;
  end;
end;

procedure TcommonCode_Frm.Update_Category_SeqNo;
var
  i : Integer;
begin
  with grid_Cat do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE DPMS_CODE_CATEGORY SET ' +
                'SEQ_NO = :SEQ_NO ' +
                'WHERE CAT_NO LIKE :param1 ');
        for i := 0 to RowCount-1 do
        begin
          ParamByName('param1').AsString  := Cells[2,i];
          ParamByName('SEQ_NO').AsInteger := Cell[5,i].AsInteger;
          ExecSQL;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.Update_Code_Group_SeqNo;
var
  i : Integer;
begin
  with grid_Group do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE DPMS_CODE_GROUP SET ' +
                'SEQ_NO = :SEQ_NO ' +
                'WHERE GRP_NO = :param1 ');

        for i := 0 to RowCount-1 do
        begin
          ParamByName('param1').AsString := Cells[5,i];
          ParamByName('SEQ_NO').AsInteger := Cell[0,i].AsInteger;
          ExecSQL;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcommonCode_Frm.Update_Code_Visible(ACode, AVisibleType: string);
begin
  with DM1.OraQuery2 do
  begin
    if Ord(String2ALIAS_TYPE(AVisibleType)) = ord(atDepart) then
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM DPMS_CODE_VISIBLE ' +
              'WHERE CODE_ID = :CODE_ID AND ALIAS_CODE = :ALIAS_CODE ');
      ParamByName('CODE_ID').AsString := ACode;
      ParamByName('ALIAS_CODE').AsInteger := DM1.FUserInfo.AliasCode_Team;

      ExecSQL;
    end
    else
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE DPMS_CODE_VISIBLE SET ' +
              '   CODE_TYPE = :CODE_TYPE, ' +
              '   ALIAS_CODE = :ALIAS_CODE, ALIAS_CODE_TYPE = :ALIAS_CODE_TYPE, ' +
              '   VISIBLE_TYPE = : VISIBLE_TYPE, MODID = :MODID, MODDATE = :MODDATE ' +
              'WHERE CODE_ID = :CODE_ID ');
      ParamByName('CODE_ID').AsString    := ACode;
      ParamByName('CODE_TYPE').AsInteger    := 1;  //1: Category
      ParamByName('ALIAS_CODE').AsInteger    := DM1.FUserInfo.AliasCode_Team;
      ParamByName('ALIAS_CODE_TYPE').AsInteger := Ord(String2ALIAS_TYPE(AVisibleType));
      ParamByName('VISIBLE_TYPE').AsInteger    := ord(vtShow);
      ParamByName('MODID').AsString    := DM1.FUserInfo.CurrentUsers;
      ParamByName('MODDATE').AsDateTime    := Now;

      ExecSQL;
    end;
  end;
end;

end.
