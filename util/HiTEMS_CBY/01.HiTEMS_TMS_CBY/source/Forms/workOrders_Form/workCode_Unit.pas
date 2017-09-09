unit workCode_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AeroButtons,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, JvExControls, JvLabel, Vcl.ImgList, NxColumnClasses, NxColumns,
  Vcl.Menus, Ora, iComponent, iVCLComponent, iCustomComponent, iPipe;

type
  TworkCode_Frm = class(TForm)
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
    NxNumberColumn2: TNxNumberColumn;
    NxTextColumn1: TNxTreeColumn;
    btn_Add: TAeroButton;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn7: TNxTextColumn;
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
  private
    { Private declarations }
    FChanged : Boolean;
    function Get_CodeSeqNo:Integer;
  public
    { Public declarations }
    procedure Get_WorkCategory;
    procedure Get_WorkCode;
    procedure Get_WorkCodeGroup(aCatNo:String);
    procedure Insert_TMS_WORK_CODEGRP(aRow:Integer);
    procedure Update_WorkCodeGroupSeqNo(aGrpNo:String;aValue:Integer);
    procedure Update_Category_SeqNo;
    procedure Update_CodeGroup_SeqNo;
  end;

var
  workCode_Frm: TworkCode_Frm;
  function Create_workCode_Frm:Boolean;

implementation
uses
  sheetManagement_Unit,
  HiTEMS_TMS_CONST,
  HiTEMS_TMS_COMMON,
  newCategory_Unit,
  DataModule_Unit;

{$R *.dfm}

function Create_workCode_Frm:Boolean;
begin
  Result := False;
  workCode_Frm := TworkCode_Frm.Create(nil);
  try
    with workCode_Frm do
    begin
      FChanged := False;

      Get_WorkCategory;
      Get_WorkCode;

      ShowModal;

      Result := FChanged;

    end;
  finally
    FreeAndNil(workCode_Frm);
  end;
end;

procedure TworkCode_Frm.btn_AddClick(Sender: TObject);
var
  i,j,
  LRow : Integer;
  msg : String;
  LCatRow : Integer;
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

      for i := 0 to grid_Code.RowCount-1 do
      begin
        if grid_Code.Cell[1,i].AsInteger = 1 then
        begin
          msg := '';
//          for j := 0 to RowCount-1 do
//          begin
//            if Cells[4,j] = grid_Code.Cells[2,i] then
//            begin
//              msg := '같은 코드가 등록되어있습니다.'+#10#13+
//                     '코드명:('+grid_Code.Cells[3,i]+')';
//              Break;
//            end;
//          end;

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
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkCode_Frm.btn_CheckClick(Sender: TObject);
var
  i : Integer;
  LGroupNo:String;
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
          Insert_TMS_WORK_CODEGRP(i);
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
        Update_CodeGroup_SeqNo;
        ShowMessage('코드등록 성공!');
      end;

      if MessageDlg('선택된 작업 카테고리 및 코드의 체크박스를 해제 하시겠습니까?',
                     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        for i := 0 to grid_Cat.RowCount-1 do
          grid_Cat.Cell[0,i].AsInteger := 0;

        for i := 0 to grid_Code.RowCount-1 do
          grid_Code.Cell[1,i].AsInteger := 0;
      end;

      Get_WorkCodeGroup(grid_Cat.Cells[2,grid_Cat.SelectedRow]);

    finally
      FChanged := True;
      EndUpdate;
    end;
  end;
end;

procedure TworkCode_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TworkCode_Frm.btn_DelClick(Sender: TObject);
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
              //WORK ORDER 삭제
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM TMS_WORK_ORDERS ' +
                      'WHERE CODE LIKE :param1 ');

              ParamByName('param1').AsString := LGrpNo;
              ExecSQL;

              //그룹코드 삭제
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM TMS_WORK_CODEGRP ' +
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

procedure TworkCode_Frm.btn_DelCodeClick(Sender: TObject);
var
  i : Integer;
  LResult : Boolean;
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
              with DM1.OraQuery1 do
              begin
                Close;
                SQL.Clear;
                SQL.Add('DELETE FROM TMS_WORK_CODE ' +
                        'WHERE CODE LIKE :param1 ');
                ParamByName('param1').AsString := Cells[2,i];
                ExecSQL;

                //DeleteRow(i);
              end;
            end;
          end;

          for i := 0 to RowCount-1 do
          begin
            with DM1.OraQuery1 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('UPDATE TMS_WORK_CODE SET ' +
                      'SEQ_NO = :SEQ_NO ' +
                      'WHERE CODE LIKE :param1 ');
              ParamByName('param1').AsString := Cells[2,i];
              ParamByName('SEQ_NO').AsInteger := Cell[0,i].AsInteger;
              ExecSQL;
            end;
          end;
        end;
      end;
    finally
      EndUpdate;

      if LResult then
        Get_WorkCode;
    end;
  end;
end;

procedure TworkCode_Frm.btn_DownClick(Sender: TObject);
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

procedure TworkCode_Frm.btn_UpClick(Sender: TObject);
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

procedure TworkCode_Frm.et_filterChange(Sender: TObject);
var
  i: Integer;
  s: string;
  RowVisible: Boolean;
begin
  for i := 0 to grid_Code.RowCount - 1 do
  begin
    grid_Code.Cell[1,i].AsInteger := 0;
    s := UpperCase(et_filter.Text);
    RowVisible := (s = '') or (Pos(s, UpperCase(grid_Code.Cell[3, i].AsString)) > 0);
    grid_Code.RowVisible[i] := RowVisible;
  end;
end;

procedure TworkCode_Frm.AeroButton4Click(Sender: TObject);
var
  LCode : String;
begin
  if et_codeName.Text <> '' then
  begin
    LCode := 'CDN'+FormatDateTime('YYYYMMDDHHMMSSZZZ',Now);
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT CODE_NAME FROM TMS_WORK_CODE ' +
                'WHERE CODE_NAME LIKE :param1 ');
        ParamByName('param1').AsString := et_codeName.Text;
        Open;

        if RecordCount = 0 then
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO TMS_WORK_CODE ' +
                  '( ' +
                  '   CODE, CODE_NAME, SEQ_NO, USE_YN, DRAFTER ' +
                  ') VALUES ' +
                  '( ' +
                  '   :CODE, :CODE_NAME, :SEQ_NO, :USE_YN, :DRAFTER ' +
                  ') ');

          ParamByName('CODE').AsString      := LCode;
          ParamByName('CODE_NAME').AsString := et_codeName.Text;
          ParamByName('SEQ_NO').AsInteger   := Get_CodeSeqNo;
          ParamByName('USE_YN').AsString    := 'Y';
          ParamByName('DRAFTER').AsString   := DM1.FUserInfo.CurrentUsers;

          ExecSQL;

          et_codeName.Clear;
          et_codeName.Hint := '';
        end else
          ShowMessage('같은 이름으로 등록된 코드가 있습니다.');

      end;
    finally
      Get_WorkCode;
    end;
  end;
end;

function TworkCode_Frm.Get_CodeSeqNo: Integer;
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
      SQL.Add('SELECT COUNT(*) COUNT FROM TMS_WORK_CODE ');
      Open;

      Result := FieldByName('COUNT').AsInteger;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TworkCode_Frm.Get_WorkCategory;
var
  i,
  LRow : Integer;
begin
  with grid_Cat do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM ' +
                '( ' +
                '   SELECT A.*, B.NAME_KOR FROM TMS_WORK_CATEGORY A ' +
                '   LEFT OUTER JOIN HITEMS_USER B ' +
                '   ON A.DRAFTER = B.USERID ' +
                ') ' +
                'START WITH PARENT_NO IS NULL ' +
                'CONNECT BY PRIOR CAT_NO = PARENT_NO ' +
                'ORDER SIBLINGS BY SEQ_NO ');
        Open;

        while not eof do
        begin
          if RowCount = 0 then
            LRow := AddRow(1)
          else
          begin
            if FieldByName('PARENT_NO').AsString <> '' then
            begin
              for i := 0 to RowCount-1 do
              begin
                if Cells[2,i] = FieldByName('PARENT_NO').AsString then
                begin
                  AddChildRow(i,crLast);
                  LRow := LastAddedRow;
                  Break;
                end;
              end;
            end else
              LRow := AddRow(1);

          end;

          Cell[0,LRow].AsInteger := 0;
          Cells[1,LRow] := FieldByName('CAT_NAME').AsString;
          Cells[2,LRow] := FieldByName('CAT_NO').AsString;
          Cells[3,LRow] := FieldByName('PARENT_NO').AsString;
          Cell[4,LRow].AsInteger := FieldByName('CAT_LV').AsInteger;
//          Cell[5,LRow].AsInteger := FieldByName('SEQ_NO').AsInteger;

          if FieldByName('USE_YN').AsString = 'Y' then
            Cell[6,LRow].AsInteger := 2
          else
            Cell[6,LRow].AsInteger := 1;

          Cell[7,LRow].AsInteger := FieldByName('CAT_LV').AsInteger;

          Cell[8,LRow].AsString  := FieldByName('NAME_KOR').AsString;

          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkCode_Frm.Get_WorkCode;
var
  LRow : Integer;
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
        SQL.Add('SELECT * FROM ' +
                '( ' +
                '   SELECT A.*, B.NAME_KOR FROM TMS_WORK_CODE A ' +
                '   LEFT OUTER JOIN HITEMS_USER B ' +
                '   ON A.DRAFTER = B.USERID ' +
                ') ' +
                'WHERE USE_YN = :param1 ' +
                'ORDER BY SEQ_NO ');
        ParamByName('param1').AsString := 'Y';
        Open;

        while not eof do
        begin
          LRow := AddRow;
          Cell[1,LRow].AsInteger := 0;
          Cells[2,LRow] := FieldByName('CODE').AsString;
          Cells[3,LRow] := FieldByName('CODE_NAME').AsString;
          Cell[4,LRow].AsInteger := FieldByName('SEQ_NO').AsInteger;
          Cells[5,LRow] := FieldByName('USE_YN').AsString;
          Cells[6,LRow] := FieldByName('NAME_KOR').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
      SelectLastRow;
    end;
  end;
end;

procedure TworkCode_Frm.Get_WorkCodeGroup(aCatNo: String);
var
  LRow : Integer;
begin
  with grid_Group do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM ' +
                '( ' +
                '   SELECT A.*, B.NAME_KOR FROM ' +
                '   ( ' +
                '       SELECT A.*, B.CAT_NAME FROM TMS_WORK_CODEGRP A, TMS_WORK_CATEGORY B ' +
                '       WHERE A.CAT_NO = :param1 ' +
                '       AND A.CAT_NO = B.CAT_NO ' +
                '   ) A LEFT OUTER JOIN HITEMS_USER B ' +
                '   ON A.DRAFTER = B.USERID ' +
                ') ' +
                'ORDER BY SEQ_NO ');
        ParamByName('param1').AsString := aCatNo;
        Open;

        while not eof do
        begin
          LRow := AddRow;
          Cells[1,LRow] := FieldByName('CAT_NAME').AsString;
          Cells[2,LRow] := FieldByName('CODE_NAME').AsString;          
          Cells[3,LRow] := FieldByName('CAT_NO').AsString;
          Cells[4,LRow] := FieldByName('CODE').AsString;        
          Cells[5,LRow] := FieldByName('GRP_NO').AsString;
          Cells[6,LRow] := FieldByName('NAME_KOR').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkCode_Frm.grid_CatMouseDown(Sender: TObject;
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

procedure TworkCode_Frm.grid_CatSelectCell(Sender: TObject; ACol,
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
            Cell[0,i].AsInteger := 0;

          Cell[0,ARow].AsInteger := 1;

        end;
      end;
    finally
      EndUpdate;
    end;
  end;

  Get_WorkCodeGroup(grid_Cat.Cells[2,ARow]);
  
end;

procedure TworkCode_Frm.grid_CodeCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  et_codeName.Text := grid_Code.Cells[3,ARow];
end;

procedure TworkCode_Frm.grid_CodeSelectCell(Sender: TObject; ACol,
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

procedure TworkCode_Frm.grid_GroupCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  btn_Del.Enabled := True;

end;

procedure TworkCode_Frm.grid_GroupSelectCell(Sender: TObject; ACol,
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

procedure TworkCode_Frm.Insert_TMS_WORK_CODEGRP(aRow:Integer);
var
  i : Integer;
  LGroupNo:String;
begin
  with grid_Group do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO TMS_WORK_CODEGRP ' +
                '( ' +
                '   GRP_NO, CAT_NO, CODE, CODE_NAME, SEQ_NO, USE_YN, DRAFTER ' +
                ') VALUES ( ' +
                '   :GRP_NO, :CAT_NO, :CODE, :CODE_NAME, :SEQ_NO, :USE_YN, :DRAFTER ' +
                ') ');

        ParamByName('GRP_NO').AsString := 'CDG'+FormatDateTime('YYYYMMDDHHMMSSZZZ',Now);
        ParamByName('CAT_NO').AsString := Cells[3,aRow];
        ParamByName('CODE').AsString := Cells[4,aRow];
        ParamByName('CODE_NAME').AsString := Cells[2,aRow];
        ParamByName('SEQ_NO').AsInteger := Cell[0,aRow].AsInteger;
        ParamByName('USE_YN').AsString  := 'Y';
        ParamByName('DRAFTER').AsString := DM1.FUserInfo.CurrentUsers;
        ExecSQL;

      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkCode_Frm.menu_CatDelClick(Sender: TObject);
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
      if MessageDlg('삭제 하시겠습니까? 삭제된 코드는 복구할 수 없습니다.',
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
              //WORK ORDER 삭제
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM TMS_WORK_ORDERS ' +
                      'WHERE CODE IN ' +
                      '( ' +
                      '   SELECT CAT_NO FROM TMS_WORK_CATEGORY ' +
                      '   START WITH CAT_NO LIKE :param1 ' +
                      '   CONNECT BY PRIOR CAT_NO = PARENT_NO ' +
                      ')');
              ParamByName('param1').AsString := LCatNo;
              ExecSQL;

              //카테고리 삭제
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM TMS_WORK_CATEGORY ' +
                      'WHERE CAT_NO LIKE :param1 ');
              ParamByName('param1').AsString := LCatNo;
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

procedure TworkCode_Frm.menu_CatEditClick(Sender: TObject);
var
  i : Integer;
  LParentNo : String;
begin
  with grid_Cat do
  begin
    FChanged := True;
    if SelectedRow <> -1 then
    begin
      Create_newCategory_Frm(Cells[3,SelectedRow],Cells[2,SelectedRow],Cell[7,SelectedRow].AsInteger)
    end
  end;
  Get_WorkCategory;
end;

procedure TworkCode_Frm.menu_NewCatClick(Sender: TObject);
var
  i : Integer;
begin
  with grid_Cat do
  begin
    BeginUpdate;
    try
      FChanged := True;
      if RowCount = 0 then
        SelectedRow := -1;

      if SelectedRow <> -1 then
        Create_newCategory_Frm(Cells[2,SelectedRow],'',Cell[7,SelectedRow].AsInteger)
      else
        Create_newCategory_Frm('','',0);

      Get_WorkCategory;

    finally
      Update_Category_SeqNo;
      EndUpdate;
    end;
  end;
end;

procedure TworkCode_Frm.N1Click(Sender: TObject);
begin
  Create_sheetManagement_Frm(grid_Code.Cells[2,grid_Code.SelectedRow], //Code
                             grid_Code.Cells[3,grid_Code.SelectedRow]); //CodeName
end;

procedure TworkCode_Frm.Update_Category_SeqNo;
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
        SQL.Add('UPDATE TMS_WORK_CATEGORY SET ' +
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

procedure TworkCode_Frm.Update_CodeGroup_SeqNo;
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
        SQL.Add('UPDATE TMS_WORK_CODEGRP SET ' +
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



procedure TworkCode_Frm.Update_WorkCodeGroupSeqNo(aGrpNo: String;
  aValue: Integer);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE TMS_WORK_CODEGRP SET ' +
            'SEQ_NO = :SEQ_NO ' +
            'WHERE GRP_NO = :param1 ');
    ParamByName('param1').AsString := aGrpNo;
    ParamByName('param2').AsInteger := aValue;
    ExecSQL;
  end;
end;

end.
