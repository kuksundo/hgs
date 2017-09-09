unit UnitAlarmListConfigEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvToolBar, AdvStyleIF, Vcl.StdCtrls, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.Menus,
  Vcl.ImgList, AeroButtons, JvExControls, JvLabel, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, iLed, iLedArrow, iComponent, iVCLComponent, iCustomComponent,
  iPipe, UnitAlarmConfigClass, UnitEngParamConfig, UnitFrameAlarmConfigGrid,
  pjhComboBox;

type
  TAlarmListConfigF = class(TForm)
    pn_Main: TPanel;
    JvLabel22: TJvLabel;
    CodeVisibleAllCB: TCheckBox;
    CatVisibleAllCB: TCheckBox;
    Panel1: TPanel;
    Panel6: TPanel;
    JvLabel2: TJvLabel;
    JvLabel4: TJvLabel;
    cb_codeType: TComboBox;
    et_filter: TComboBox;
    grid_Code: TNextGrid;
    Code_No: TNxIncrementColumn;
    Code_Check: TNxImageColumn;
    Code_CodeName: TNxTextColumn;
    Code_TagName: TNxTextColumn;
    Code_SeqNo: TNxNumberColumn;
    Code_IsUse: TNxTextColumn;
    Code_RegUser: TNxTextColumn;
    Code_CodeVisibleText: TNxTextColumn;
    Code_Reg_Alias_Code: TNxTextColumn;
    Code_Reg_Alias_Code_Type: TNxTextColumn;
    Code_RegId: TNxTextColumn;
    Code_RegPosition: TNxTextColumn;
    Panel9: TPanel;
    Panel2: TPanel;
    Panel5: TPanel;
    JvLabel1: TJvLabel;
    grid_Cat: TNextGrid;
    CheckCol: TNxImageColumn;
    Cat_CategoryName: TNxTreeColumn;
    Cat_CategoryNo: TNxTextColumn;
    Cat_ParentCategory: TNxTextColumn;
    Cat_CategoryLevel: TNxNumberColumn;
    Cat_SeqNo: TNxIncrementColumn;
    Cat_IsUse: TNxImageColumn;
    Cat_RegUser: TNxTextColumn;
    Cat_CatVisibleText: TNxTextColumn;
    Panel7: TPanel;
    Panel3: TPanel;
    btn_Add: TAeroButton;
    iPipe1: TiPipe;
    iPipe2: TiPipe;
    iPipe3: TiPipe;
    iPipe4: TiPipe;
    iLedArrow1: TiLedArrow;
    iLedArrow2: TiLedArrow;
    Panel4: TPanel;
    Panel10: TPanel;
    btn_Del: TAeroButton;
    btn_Check: TAeroButton;
    Panel11: TPanel;
    JvLabel3: TJvLabel;
    btn_Up: TAeroButton;
    btn_Down: TAeroButton;
    ImageList16x16: TImageList;
    ImageList24x24: TImageList;
    ImageList32x32: TImageList;
    PopUp_Cat: TPopupMenu;
    menu_NewCat: TMenuItem;
    menu_CatEdit: TMenuItem;
    menu_CatDel: TMenuItem;
    popup_Cd: TPopupMenu;
    N1: TMenuItem;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    AeroButton1: TAeroButton;
    AeroButton2: TAeroButton;
    OpenDialog1: TOpenDialog;
    Code_TagDesc: TNxTextColumn;
    AeroButton3: TAeroButton;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel8: TJvLabel;
    btn_Close: TAeroButton;
    cb_categoryHeader: TComboBox;
    JvLabel5: TJvLabel;
    FACG: TFrame1;
    cb_dept: TComboBoxInc;
    cb_team: TComboBoxInc;
    cb_user: TComboBoxInc;
    procedure btn_CloseClick(Sender: TObject);
    procedure cb_codeTypeDropDown(Sender: TObject);
    procedure cb_codeTypeSelect(Sender: TObject);
    procedure et_filterSelect(Sender: TObject);
    procedure cb_deptDropDown(Sender: TObject);
    procedure cb_deptSelect(Sender: TObject);
    procedure cb_teamDropDown(Sender: TObject);
    procedure cb_teamSelect(Sender: TObject);
    procedure cb_userDropDown(Sender: TObject);
    procedure cb_userSelect(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure grid_CatSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure grid_CodeSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure AeroButton3Click(Sender: TObject);
    procedure btn_AddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_CheckClick(Sender: TObject);
    procedure cb_categoryHeaderDropDown(Sender: TObject);
    procedure FACGgrid_GroupCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure FACGgrid_GroupSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure btn_DelClick(Sender: TObject);
  private
    FCatCode: string;
    FAlarmConfigEPCollect: TAlarmConfigEPCollect;

    procedure DisplayTagList2Grid(ACollect: TAlarmConfigEPCollect);
    procedure Get_User_AlarmConfigList(AUserId: string);

    procedure Get_ProjNo_EngNo(AText: string; var AProjNo, AEngNo: string);
    procedure AddAlarmConfigItem2GrpGrid;
  public
    FUpdated: Boolean;
    FProgramMode: integer; //0: Report Mode, 1: User Monitor Mode

    procedure FillInAlarmConfigList2Grid;
  end;

var
  AlarmListConfigF: TAlarmListConfigF;

implementation

uses UnitDM, SynCommons, CommonUtil, HiMECSConst, System.Rtti;

{$R *.dfm}

procedure TAlarmListConfigF.AddAlarmConfigItem2GrpGrid;
begin

end;

procedure TAlarmListConfigF.AeroButton1Click(Sender: TObject);
var
  LProjNo, LEngNo: string;
begin
  if OpenDialog1.Execute then
  begin
    Get_ProjNo_EngNo(et_filter.Text, LProjNo, LEngNo);
    DM1.UpdateEngParamFile2DB(LProjNo, LEngNo, OpenDialog1.FileName);
  end;
end;

procedure TAlarmListConfigF.AeroButton2Click(Sender: TObject);
begin
  FillInAlarmConfigList2Grid;
end;

procedure TAlarmListConfigF.AeroButton3Click(Sender: TObject);
begin
  FACG.ToggleCheckGridAll(grid_Code, 1, False);
end;

procedure TAlarmListConfigF.btn_AddClick(Sender: TObject);
var
  LUserId, LProjNo, LEngNo: String;
  i,r: integer;
  LAlarmConfigItem: TAlarmConfigItem;
begin
  if cb_user.Text = '' then
  begin
    cb_user.SetFocus;
    ShowMessage('먼저 사용자를 선택 하세요');
    exit;
  end;

  LUserId := GetstrTokenNth(cb_user.Hint, ';', cb_user.Tag);
  Get_ProjNo_EngNo(et_filter.Text, LProjNo, LEngNo);

  for i := 0 to grid_Code.RowCount - 1 do
  begin
    //선택(체크)이 된 행이면 무조건 grid에 표시(나중에 Item을 더블클릭하여 세부 설정함)
    //세부설정이 안되면 db에 저장시 무시됨
    if grid_Code.CellByName['Code_Check',i].AsInteger = 1 then
    begin
      LAlarmConfigItem := FACG.FAlarmConfigCollect.Add;
      LAlarmConfigItem.UserID := LUserId;
      LAlarmConfigItem.Category := FCatCode;
      LAlarmConfigItem.ProjNo := LProjNo;
      LAlarmConfigItem.EngNo := LEngNo;
      LAlarmConfigItem.TagName := grid_Code.CellByName['Code_TagName',i].AsString;
      LAlarmConfigItem.AlarmMessage := grid_Code.CellByName['Code_TagDesc',i].AsString;
      LAlarmConfigItem.IsAnalog := TAlarmConfigEPItem(grid_Code.Row[i].Data).IsAnalog;
      LAlarmConfigItem.AlarmSetType := astNone;
      LAlarmConfigItem.Recipients := LUserId + ';';
      FACG.FillInAlarmConfigItem2GrpGrid(LAlarmConfigItem,-1,clBlue);
    end;
  end;//for

  FACG.grid_Group.ScrollToRow(FACG.grid_Group.LastAddedRow);
end;

procedure TAlarmListConfigF.btn_CheckClick(Sender: TObject);
begin
  FACG.FAlarmConfigCollect.DBAction := 'ALL';
  DM1.SaveAlarmConfigList2DB(FACG.FAlarmConfigCollect);
  FUpdated := True;
end;

procedure TAlarmListConfigF.btn_CloseClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOK;
end;

procedure TAlarmListConfigF.btn_DelClick(Sender: TObject);
begin
  FACG.DeleteAlarmConfigItem;
  FUpdated := True;
end;

procedure TAlarmListConfigF.cb_categoryHeaderDropDown(Sender: TObject);
begin
  if cb_user.Text <> '' then
  begin
    DM1.FillInCategoryCombo(cb_user.text,'','', cb_categoryHeader);
  end else
  begin
    cb_dept.SetFocus;
    ShowMessage('먼저 사용자를 선택하여 주십시오!');
  end;
end;

procedure TAlarmListConfigF.cb_codeTypeDropDown(Sender: TObject);
var
  LDynArr: TRawUTF8DynArray;
  i: integer;
begin
  cb_codeType.Clear;
  LDynArr := nil;
  LDynArr := DM1.GetPlantList;

  for i := Low(LDynArr) to High(LDynArr) do
  begin
    if LDynArr[i] <> '' then
      cb_codeType.Items.Add(UTF8ToString(LDynArr[i]));
  end;
end;

procedure TAlarmListConfigF.cb_codeTypeSelect(Sender: TObject);
var
  LAlarmConfigCollect: TAlarmConfigCollect;
  LAlarmConfigItem: TAlarmConfigItem;
  i: integer;
begin
  if cb_codeType.Text <> '' then
  begin
    try
      LAlarmConfigCollect := TAlarmConfigCollect.Create(TAlarmConfigItem);
//      LAlarmConfigItem := LAlarmConfigCollect.Add;
      DM1.GetEngineListFromPlant(cb_codeType.Text, LAlarmConfigCollect);
      et_filter.Clear;

      for i := 0 to LAlarmConfigCollect.Count - 1 do
      begin
        et_filter.Items.Add(LAlarmConfigCollect.Items[i].ProjNo + '(' +
                            LAlarmConfigCollect.Items[i].EngNo + ') : ' +
                            LAlarmConfigCollect.Items[i].EngType);
      end;
    finally
      LAlarmConfigCollect.Free;
    end;
  end;
end;

procedure TAlarmListConfigF.cb_deptDropDown(Sender: TObject);
begin
  DM1.FillInDeptCombo(cb_dept);
//  with cb_dept.Items do
//  begin
//    BeginUpdate;
//    try
//      Clear;
//      with DM1.OraQuery1 do
//      begin
//        Close;
//        SQL.Clear;
//        SQL.Add('SELECT * FROM HiTEMS_DEPT ' +
//                'WHERE DEPT_LV <= :param1 ' +
//                'ORDER BY DEPT_CD ');
//        ParamByName('param1').AsInteger := 1;
//        Open;
//
//        Add('');
//        while not eof do
//        begin
//          Add(FieldByName('DEPT_NAME').AsString);
//          Next;
//        end;
//      end;
//    finally
//      EndUpdate;
//    end;
//  end;
end;

procedure TAlarmListConfigF.cb_deptSelect(Sender: TObject);
var
  i: Integer;
  LDept: string;
begin
  //현재 선택된 ComboBox Index를 Tag에 저장하여
  //hint에 저장된 ';' 로 분리된 부서코드를 가져오기 위한 Index로 사용함
  cb_dept.Tag := cb_dept.ItemIndex;
  LDept := GetstrTokenNth(cb_dept.Hint, ';', cb_dept.Tag);
  DM1.FillInPartCombo(LDept, cb_team);
end;

procedure TAlarmListConfigF.cb_teamDropDown(Sender: TObject);
begin
  if cb_dept.Text <> '' then
  begin
  end
  else
    ShowMessage('먼저 부서를 선택하여 주십시오.');
end;

procedure TAlarmListConfigF.cb_teamSelect(Sender: TObject);
var
  LDept: string;
  LTeam: string;
begin
  LDept := GetstrTokenNth(cb_dept.Hint, ';', cb_dept.Tag);
  cb_team.Tag := cb_team.ItemIndex;
  LTeam := GetstrTokenNth(cb_team.Hint, ';', cb_team.Tag);
  DM1.FillInUserCombo(LDept, LTeam, cb_user);
end;

procedure TAlarmListConfigF.cb_userDropDown(Sender: TObject);
var
  LDept: string;
  lteam : String;
begin
  if cb_dept.Text <> '' then
  begin
    if cb_team.Text = '' then
    begin
      LDept := GetstrTokenNth(cb_dept.Hint, ';', cb_dept.Tag);
      DM1.FillInUserCombo(LDept, '', cb_user);
    end;
  end else
  begin
    cb_dept.SetFocus;
    ShowMessage('먼저 부서를 선택하여 주십시오!');
  end;
end;

procedure TAlarmListConfigF.cb_userSelect(Sender: TObject);
begin
  cb_user.Tag := cb_user.ItemIndex;
  FillInAlarmConfigList2Grid;
end;

procedure TAlarmListConfigF.DisplayTagList2Grid(
  ACollect: TAlarmConfigEPCollect);
var
  i, LRow: integer;
begin
  with grid_Code do
  begin
    BeginUpdate;
    try
      ClearRows;

      for i := 0 to ACollect.Count - 1 do
      begin
        if SysUtils.UpperCase(ACollect.Items[i].TagName) <> 'DUMMY' then
        begin
          LRow := AddRow;
          CellByName['Code_TagName', LRow].AsString := ACollect.Items[i].TagName;
          CellByName['Code_TagDesc', LRow].AsString := ACollect.Items[i].Description;
          Row[LRow].Data := ACollect.Items[i];
        end;
      end;
    finally
      EndUpdate;
    end;
  end; //with
end;

procedure TAlarmListConfigF.et_filterSelect(Sender: TObject);
var
  LStr, LProjNo, LEngNo: string;
begin
  if et_filter.Text <> '' then
  begin
    try
      FAlarmConfigEPCollect.Clear;
      Get_ProjNo_EngNo(et_filter.Text, LProjNo, LEngNo);
      DM1.GetTagListFromEngine(LProjNo, LEngNo, FAlarmConfigEPCollect);

      if FAlarmConfigEPCollect.Count > 0 then
        DisplayTagList2Grid(FAlarmConfigEPCollect)
      else
        ShowMessage(LProjNo + '(' + LEngNo + ') Parameter File does not exist');
    finally
    end;
  end;
end;

procedure TAlarmListConfigF.FACGgrid_GroupCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  LUserId: string;
begin
  FACG.grid_Group.Tag := FProgramMode;
  LUserId := FACG.grid_Group.CellByName['Grp_RegUser',FACG.grid_Group.SelectedRow].AsString;
  FACG.grid_Group.Hint := DM1.GetDeptNTeamCodeFromUserId(LUserId);

  FACG.grid_GroupCellDblClick(Sender, ACol, ARow);
end;

procedure TAlarmListConfigF.FACGgrid_GroupSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  with FACG.grid_Group do
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
      if ACol = 1 then
        FACG.CheckGrid(FACG.grid_Group, ACol, ARow);

      if CellByName['Grp_No',ARow].TextColor = clBlue then
        Btn_Del.Enabled := True
      else
        Btn_Del.Enabled := False;

      if CellByName['Grp_Check',ARow].AsInteger = 1 then
        Btn_Del.Enabled := True;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TAlarmListConfigF.FillInAlarmConfigList2Grid;
var
  userId : String;
begin
  userId := GetstrTokenNth(cb_user.Hint, ';', cb_user.Tag);

  if userId <> '' then
  begin
    Get_User_AlarmConfigList(userId);
  end;
end;

procedure TAlarmListConfigF.FormCreate(Sender: TObject);
begin
  FCatCode := 'Default';
  FAlarmConfigEPCollect := TAlarmConfigEPCollect.Create(TAlarmConfigEPItem);
end;

procedure TAlarmListConfigF.FormDestroy(Sender: TObject);
begin
  FAlarmConfigEPCollect.Free;
end;

procedure TAlarmListConfigF.Get_ProjNo_EngNo(AText: string; var AProjNo,
  AEngNo: string);
var
  LStr: string;
begin
  LStr := AText;
  AProjNo := strToken(LStr, '(');
  LStr := AText;
  AEngNo := ExtractText(LStr, '(', ')');
end;

procedure TAlarmListConfigF.Get_User_AlarmConfigList(AUserId: string);
var
  LProjNo, LEngNo: string;
  i: integer;
begin
  FACG.FAlarmConfigCollect.Clear;

  try
    Get_ProjNo_EngNo(et_filter.Text, LProjNo, LEngNo);
    DM1.GetAlarmConfigList(AUserId,FCatCode,LProjNo,LEngNo,FACG.FAlarmConfigCollect);

    with FACG.grid_Group do
    begin
      ClearRows;

      for i := 0 to FACG.FAlarmConfigCollect.Count - 1 do
      begin
        FACG.FillInAlarmConfigItem2GrpGrid(FACG.FAlarmConfigCollect.Items[i], -1);
      end;
    end;//with
  finally
  end;
end;

procedure TAlarmListConfigF.grid_CatSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ACol = 0 then
    FACG.CheckGrid(grid_Cat, ACol, ARow);
end;

procedure TAlarmListConfigF.grid_CodeSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ACol = 1 then
    FACG.CheckGrid(grid_Code, ACol, ARow);
end;

end.
