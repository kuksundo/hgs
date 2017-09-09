unit selectCode_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  AdvGroupBox, AdvOfficeStatusBar, Vcl.ExtCtrls, NxEdit, Vcl.DBCtrls, AdvEdit,
  NxCollection, Vcl.ComCtrls, Data.DB, MemDS, DBAccess, Ora, OraSmart,
  Vcl.Menus, AdvMenus, GradientLabel, AdvGlowButton, TreeList, System.Generics.Collections,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, JvExControls, JvLabel, Vcl.ImgList, Vcl.Imaging.jpeg,
  Vcl.Buttons, cyBaseSpeedButton, cySpeedButton;
//  empPerformance_Unit;

type
  TselectCode_Frm = class(TForm)
    Panel2: TPanel;
    GradientLabel1: TGradientLabel;
    Label1: TLabel;
    Label2: TLabel;
    AdvEdit1: TAdvEdit;
    AdvEdit2: TAdvEdit;
    Label3: TLabel;
    AdvEdit3: TAdvEdit;
    Panel3: TPanel;
    regBtn: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    Panel4: TPanel;
    Panel5: TPanel;
    grid_Code: TNextGrid;
    NxTextColumn7: TNxTextColumn;
    JvLabel3: TJvLabel;
    NxTextColumn1: TNxTextColumn;
    NxNumberColumn2: TNxNumberColumn;
    CodeName: TNxTreeColumn;
    ImageList16x16: TImageList;
    et_Filter: TEdit;
    Panel8: TPanel;
    Image1: TImage;
    JvLabel1: TJvLabel;
    NxTextColumn2: TNxTextColumn;
    VisibleText: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    AliasCode: TNxTextColumn;
    TeamColorBtn: TcySpeedButton;
    PrivateColorBtn: TcySpeedButton;
    JvLabel2: TJvLabel;
    JvLabel4: TJvLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure regBtnClick(Sender: TObject);
    procedure grid_CodeSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure et_FilterChange(Sender: TObject);
    procedure grid_CodeCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure grid_CodeCellFormating(Sender: TObject; ACol, ARow: Integer;
      var TextColor: TColor; var FontStyle: TFontStyles; CellState: TCellState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCurrentNode : TTreeNode;
    FResultString : String;
    FcodeDic : TDictionary<String,TTreeNode>;
    FSelectOnlyLeafNode: Boolean;
  public
    FDeptNo : String;
    { Public declarations }
    procedure Set_Type_Description(aCode:String);
    procedure Set_CodeTree(aCodeType:String);
  end;

var
  selectCode_Frm: TselectCode_Frm;
  function Create_selectCode_Frm(aCode,aCodeType:String) : String;

implementation
uses
  HiTEMS_TMS_COMMON,
  HiTEMS_TMS_CONST,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

function Create_selectCode_Frm(aCode,aCodeType:String) : String;
var
  li : integer;
begin
  if not Assigned(selectCode_Frm) then
  begin
    selectCode_Frm := TselectCode_Frm.Create(nil);
    try
      with selectCode_Frm do
      begin
        FSelectOnlyLeafNode := True;
        Set_CodeTree(aCodeType);

        ShowModal;

        if ModalResult = mrOk then
          Result := FResultString;

      end;
    finally
      FreeAndNil(selectCode_Frm);
    end;
  end;
end;

procedure TselectCode_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TselectCode_Frm.et_FilterChange(Sender: TObject);
var
  i: Integer;
  s: string;
  RowVisible: Boolean;
begin
  s := UpperCase(et_filter.Text);
  for i := 0 to grid_Code.RowCount - 1 do
  begin
    if grid_Code.GetChildCount(i) = 0 then
    begin
      RowVisible := (s = '') or (Pos(s, UpperCase(grid_Code.Cell[0, i].AsString)) > 0);
      grid_Code.RowVisible[i] := RowVisible;

      if s <> '' then
        grid_Code.Cell[0,i].TextColor := clRed
      else
        grid_Code.Cell[0,i].TextColor := clBlack;

    end;
  end;
end;

procedure TselectCode_Frm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FcodeDic) then
    FreeAndNil(FcodeDic);

  Action := caFree;
end;

procedure TselectCode_Frm.FormCreate(Sender: TObject);
begin
  TeamColorBtn.Degrade.FromColor := ALIAS_TEAM_COLOR;
  TeamColorBtn.Degrade.ToColor := ALIAS_TEAM_COLOR;
  PrivateColorBtn.Degrade.FromColor := ALIAS_PRIVATE_COLOR;
  PrivateColorBtn.Degrade.ToColor := ALIAS_PRIVATE_COLOR;
end;

procedure TselectCode_Frm.grid_CodeCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  if AdvEdit3.Text <> '' then
  begin
    FResultString := AdvEdit3.Text;
    ModalResult := mrOk;
  end;
end;

procedure TselectCode_Frm.grid_CodeCellFormating(Sender: TObject; ACol,
  ARow: Integer; var TextColor: TColor; var FontStyle: TFontStyles;
  CellState: TCellState);
begin
  if ACol = 0 then //name = 'AliasCode'
  begin
    with grid_Code do
    begin
      if ARow <= RowCount - 1 then
      begin
        if Cell[7, ARow].AsInteger = 2 then
          TextColor := ALIAS_TEAM_COLOR
        else
        if Cell[7, ARow].AsInteger = 3 then
          TextColor := ALIAS_PRIVATE_COLOR;
      end;
    end;
  end;
end;

procedure TselectCode_Frm.grid_CodeSelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  LPath_Code : String;
  LRow, QRow : Integer;
  i: Integer;
begin
  if ARow = -1 then
  begin
    AdvEdit1.Clear;
    AdvEdit2.Clear;
    AdvEdit3.Clear;
    Exit;
  end;

  with grid_Code do
  begin
    BeginUpdate;
    try
      if FSelectOnlyLeafNode then
      begin
        if GetChildCount(ARow) > 0 then
        begin
          LRow := -1;
          QRow := GetFirstChild(ARow);
          for i := 0 to GetChildCount(ARow)-1 do
          begin
            if RowVisible[QRow+i] then
            begin
              LRow := QRow+i;
              Break;
            end;
          end;
          SelectedRow := LRow;
          Exit;
        end;
      end;

      Set_Type_Description(grid_Code.Cells[1,ARow]);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TselectCode_Frm.Set_CodeTree(aCodeType:String);
var
  LRow,
  i : integer;
  typeNo : Double;
  deptNm,
  typeNm : String;
  LCatNo: string;
  Lid, LVisible, LCodeName: string;
  LUser: TUserInfo;
  iVisible, LAliasCode : Integer;
begin
  with grid_Code do
  begin
    BeginUpdate;
    try
      ClearRows;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
//        SQL.Add('SELECT * FROM ' +
//                '( ' +
//                '   SELECT ' +
//                '      PARENT_NO, CAT_NO, CAT_NAME, SEQ_NO ' +
//                '   FROM DPMS_CODE_CATEGORY UNION ALL ' +
//                '   SELECT ' +
//                '      CAT_NO, GRP_NO, CODE_NAME, SEQ_NO ' +
//                '   FROM DPMS_CODE_GROUP ' +
//                ') START WITH CAT_NO = :param1 ' +
//                'CONNECT BY PRIOR CAT_NO = PARENT_NO ' +
//                'ORDER SIBLINGS BY CAT_NO, SEQ_NO ');
        SQL.Add('SELECT * FROM ' +
                '( ' +
                '    SELECT A.PARENT_NO, A.CAT_NO, A.CAT_NAME, A.SEQ_NO, A.REG_ID, A.NAME_KOR, A.POSITION, b.alias_code TEAM, B.CODE_TYPE, B.ALIAS_CODE, B.ALIAS_CODE_TYPE FROM ' +
                '    ( ' +
                '        SELECT A.*, b.userid, B.NAME_KOR,b.position, D.ALIAS_CODE DEPT  FROM ' +
                '        ( ' +
                '            select * from ( ' +
                '                    SELECT PARENT_NO, CAT_NO, CAT_NAME, SEQ_NO, REG_ID, USE_YN ' +
                '                    FROM DPMS_CODE_CATEGORY UNION ALL ' +
                '                     SELECT ' +
                '                      CAT_NO, GRP_NO, CODE_NAME, SEQ_NO, REG_ID, USE_YN ' +
                '                    FROM DPMS_CODE_GROUP) ' +
                '            START WITH CAT_NO = :param1 ' +
                '            CONNECT BY PRIOR CAT_NO = PARENT_NO ' +
                '            ORDER SIBLINGS BY CAT_NO, SEQ_NO ' +
                ' ' +
                '         ) A, DPMS_USER B, DPMS_DEPT C, DPMS_DEPT_ALIAS D ' +
                '        WHERE A.USE_YN = ''Y'' AND ' +
                '            A.REG_ID = B.USERID AND B.DEPT_CD = C.DEPT_CD AND ' +
                '            C.PARENT_CD = D.DEPT_CODE  AND D.ALIAS_CODE = :ALIAS_CODE ' +
                '    )  A LEFT OUTER JOIN DPMS_CODE_VISIBLE B ' +
                '       ON A.CAT_NO = B.CODE_ID ' +
                '       ORDER BY SEQ_NO ' +
                ') START WITH PARENT_NO = :param1 ' +
                '  CONNECT BY PRIOR CAT_NO = PARENT_NO ' +
                '  ORDER SIBLINGS BY CAT_NO, SEQ_NO ');

        ParamByName('param1').AsString := aCodeType;//A:계획코드, B:실적코드
        ParamByName('ALIAS_CODE').AsInteger := DM1.FUserInfo.AliasCode_Dept;
        Open;

        while not eof do
        begin
          LCatNo := FieldByName('CAT_NO').AsString;

          if Copy(LCatNo, 1, 3) = 'CDG' then //코드 그룹을 가리킴
            iVisible := DM1.GetVisibleTypeFromGrp(LCatNo, ord(ctGroup), LCodeName, LAliasCode)
          else
          begin
            iVisible := FieldByName('ALIAS_CODE_TYPE').AsInteger;
            LAliasCode := FieldByName('ALIAS_CODE').AsInteger;
          end;

          Lid := FieldByName('REG_ID').AsString;

          //개인 보이기 이고 현재 사용자와 코드 기안자가 다르면 표시 안함
          if (iVisible = ord(atPrivate)) and (Lid <> DM1.FUserInfo.UserID)then
          begin
            Next;
            Continue;
          end;

          //팀 보이기 이고 현재 사용자의 팀코드와 코드 기안자의 팀코드가 다르면 표시 안함
          if (iVisible = ord(atTeam)) and (LAliasCode <> DM1.FUserInfo.AliasCode_Team)then
          begin
            Next;
            Continue;
          end;

          if RowCount = 0 then
          begin
            LRow := AddRow(1);

            with DM1.OraQuery2 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('SELECT * FROM DPMS_CODE_CATEGORY WHERE ' +
                      ' CAT_NO = :CAT_NO');
              ParamByName('CAT_NO').AsString := aCodeType;//A:계획코드, B:실적코드

              Open;

              if RecordCount > 0 then
              begin
                Cells[0,LRow] := FieldByName('CAT_NAME').AsString;
                Cells[1,LRow] := aCodeType;
                Cells[2,LRow] := FieldByName('PARENT_NO').AsString;
                Cell[3,LRow].AsInteger := FieldByName('SEQ_NO').AsInteger;
                Cell[7,LRow].AsInteger := 1;
              end;
            end;

            Continue;
          end
          else
          begin
            if FieldByName('PARENT_NO').AsString <> '' then
            begin
              for i := 0 to RowCount-1 do
              begin
                if Cells[1,i] = FieldByName('PARENT_NO').AsString then
                begin
                  AddChildRow(i,crLast);
                  LRow := LastAddedRow;
                  Break;
                end;
              end;
            end else
              LRow := AddRow(1);

          end;

          Cells[0,LRow] := FieldByName('CAT_NAME').AsString;
          Cells[1,LRow] := LCatNo;
          Cells[2,LRow] := FieldByName('PARENT_NO').AsString;
          Cell[3,LRow].AsInteger := FieldByName('SEQ_NO').AsInteger;
          Cells[4,LRow] := FieldByName('NAME_KOR').AsString;
          Cells[5,LRow] := LId;

          LVisible := ALIAS_TYPE2String(ALIAS_TYPE(iVisible));

          if LVisible = '' then
            LVisible := ALIAS_TYPE2String(atDepart);

          Cells[6,LRow] := LVisible;
          Cell[7,LRow].AsInteger := iVisible;

          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TselectCode_Frm.regBtnClick(Sender: TObject);
begin
  if AdvEdit3.Text <> '' then
  begin
    FResultString := AdvEdit3.Text;
    ModalResult := mrOk;
  end else
    ShowMessage('선택된 코드가 없습니다!');

end;

procedure TselectCode_Frm.Set_Type_Description(aCode:String);
begin
  if aCode <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ' +
              '( ' +
              '   SELECT ' +
              '     PARENT_NO, CAT_NO, CAT_NAME, CAT_DESC, SEQ_NO ' +
              '   FROM DPMS_CODE_CATEGORY UNION ALL ' +
              '   ( ' +
              '     SELECT CAT_NO, GRP_NO, CODE_NAME, CODE_DESC, SEQ_NO ' +
              '     FROM ' +
              '     ( ' +
              '       SELECT A.*, B.CODE_DESC FROM DPMS_CODE_GROUP A, DPMS_CODE B ' +
              '       WHERE A.CODE = B.CODE ' +
              '     ) ' +
              '   ) ' +
              ') WHERE CAT_NO = :param1 ');
      ParamByName('param1').AsString := aCode;
      Open;

      if not(RecordCount = 0) then
      begin
        AdvEdit1.Text := FieldByName('CAT_NAME').AsString;
        AdvEdit2.Text := FieldByName('CAT_DESC').AsString;
        AdvEdit3.Text := FieldByName('CAT_NO').AsString;
      end;
    end;
  end;
end;

end.
