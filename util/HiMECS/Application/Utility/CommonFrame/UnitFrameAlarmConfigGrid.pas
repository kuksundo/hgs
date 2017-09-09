unit UnitFrameAlarmConfigGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.StrUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  UnitAlarmConfigClass, UnitEngParamConfig;

type
  TFrame1 = class(TFrame)
    grid_Group: TNextGrid;
    Grp_No: TNxIncrementColumn;
    Grp_Check: TNxImageColumn;
    Grp_CategoryName: TNxTextColumn;
    Grp_ProjNo: TNxTextColumn;
    Grp_EngNo: TNxTextColumn;
    Grp_CodeName: TNxTextColumn;
    Grp_CodeDesc: TNxTextColumn;
    Grp_CategoryNo: TNxTextColumn;
    Grp_CodeNo: TNxTextColumn;
    Grp_GroupCode: TNxTextColumn;
    Grp_RegUser: TNxTextColumn;
    Grp_GroupVisibleText: TNxTextColumn;
    Grp_SetValue: TNxTextColumn;
    Grp_AlarmType: TNxTextColumn;
    Grp_ACItemIndex: TNxTextColumn;
    procedure grid_GroupCellDblClick(Sender: TObject; ACol, ARow: Integer);
  private
    procedure SaveGrid(AGrid: TNextGrid; AStm: TStream);
    procedure LoadGrid(AGrid: TNextGrid; AStm: TStream);
  public
    FAlarmConfigCollect: TAlarmConfigCollect;

    constructor Create(AOwner: TComponent) ; override;
    destructor Destroy; override;

    procedure SetUpAlarmConfigItem(AItem:TAlarmConfigItem; ARow: integer; ACollect: TAlarmConfigCollect);
    procedure InitAlamrConfigFormUI(AForm:TEngParamItemConfigForm);
    procedure LoadData2Form(AForm:TEngParamItemConfigForm; AItem:TAlarmConfigItem);
    function SaveDataFromForm(AForm:TEngParamItemConfigForm;
      AItem:TAlarmConfigItem; AAlarmConfigCollect: TAlarmConfigCollect): boolean;
    procedure FillInAlarmConfigItem2GrpGrid(AItem:TAlarmConfigItem; ARow: integer; AColor: TColor = clBlack);
    procedure FillInAlarmCollect2GrpGrid(ACollect: TAlarmConfigCollect);

    procedure DeleteAlarmConfigItem;

    procedure CheckGrid(AGrid: TNextGrid; ACol, ARow: integer);
    procedure ToggleCheckGridAll(AGrid: TNextGrid; ACol: integer; AChecked: Boolean);
  end;

implementation

uses UnitDM, SynCommons, CommonUtil, HiMECSConst, System.Rtti, UnitSelectTagName,
  UnitReporterMain;

{$R *.dfm}

procedure TFrame1.CheckGrid(AGrid: TNextGrid; ACol, ARow: integer);
var
  i : Integer;
begin
  if ARow = -1 then
    Exit;

  with AGrid do
  begin
    BeginUpdate;
    try
//      for i := 0 to AGrid.RowCount-1 do
//        CellByName['Code_Check',i].AsInteger := 0;
//
//      CellByName['Code_Check',ARow].AsInteger := 1;
      Cell[ACol,ARow].AsInteger := BoolToInt(Cell[ACol,ARow].AsInteger = 0);

    finally
      EndUpdate;
    end;
  end;
end;

constructor TFrame1.Create(AOwner: TComponent);
begin
  inherited;
  grid_Group.DoubleBuffered := False;
  FAlarmConfigCollect := TAlarmConfigCollect.Create(TAlarmConfigItem);
end;

procedure TFrame1.DeleteAlarmConfigItem;
var
  i, j,
  LRow : Integer;
  LStrList: TStringList;
//  LGrpNo, LUserId, LProjNo, LEngNo, LTagName: String;
  LItem: TAlarmConfigItem;
begin
  with grid_Group do
  begin
    BeginUpdate;
    LStrList := TStringList.Create;
    try
      if SelectedRow = -1 then
        Exit;

//      LRow := SelectedRow;
      if MessageDlg('선택된 알람 설정을 삭제 하시겠습니까? 삭제된 설정은 복구할 수 없습니다.',
                     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
//        FChanged := True;
//        btn_Del.Enabled := False;

        with DM1.OraTransaction1 do
        begin
          StartTransaction;
          try
            for i := Rowcount - 1 downto 0 do
            begin
              if CellByName['Grp_Check', i].AsInteger = 1 then
              begin
                LRow := i;
                LItem := TAlarmConfigItem(Row[LRow].Data);

                DM1.ExecuteDBActionEachDelete(LItem, False);

                LStrList.Add(CellByName['Grp_ACItemIndex',LRow].AsString);
                DeleteRow(LRow);
              end;
            end;//for

//            if RowCount <> 0 then
//              Update_Category_SeqNo;

            Commit;

            LStrList.Sort;
            for i := LStrList.Count - 1 downto 0 do
            begin
              j := StrToInt(LStrList.Strings[i]);
              FAlarmConfigCollect.Delete(j);
            end;

          except
            Rollback;
          end;
        end;
      end;
    finally
      EndUpdate;
      LStrList.Free;
    end;
  end;
end;

destructor TFrame1.Destroy;
begin
  FAlarmConfigCollect.Free;

  inherited;
end;

procedure TFrame1.FillInAlarmCollect2GrpGrid(ACollect: TAlarmConfigCollect);
var
  i: integer;
begin
  with grid_Group do
  begin
    BeginUpdate;
    ClearRows;
    try
      for i := 0 to ACollect.Count - 1 do
      begin
        FillInAlarmConfigItem2GrpGrid(ACollect.Items[i], -1);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TFrame1.FillInAlarmConfigItem2GrpGrid(AItem: TAlarmConfigItem;
  ARow: integer; AColor: TColor);
var
  r: integer;
begin
  with grid_Group do
  begin
    if ARow = -1 then
      r := AddRow
    else
      r := ARow;

//    CellByName['Grp_Check', r].AsInteger := 1;
    CellByName['Grp_CategoryName', r].AsString := AItem.Category;
    CellByName['Grp_ProjNo', r].AsString :=  AItem.ProjNo;
    CellByName['Grp_EngNo',r].AsString := AItem.EngNo;
    CellByName['Grp_CodeName',r].AsString := AItem.TagName;
    CellByName['Grp_CodeDesc', r].AsString := AItem.AlarmMessage;

    if AItem.AlarmSetType = astDigital then
      //SetValue = '0': False, '1': True
      CellByName['Grp_SetValue', r].AsString := BoolToStr(IntToBool(StrToInt(AItem.SetValue)), True)
    else
      CellByName['Grp_SetValue', r].AsString := AItem.SetValue;

    CellByName['Grp_AlarmType', r].AsString := TRttiEnumerationType.GetName<TAlarmSetType>(AItem.AlarmSetType);
    CellByName['Grp_ACItemIndex', r].AsInteger := AItem.Index;
    CellByName['Grp_RegUser', r].AsString := AItem.UserID;

    CellByName['Grp_CategoryName', r].TextColor := AColor;
    CellByName['Grp_ProjNo', r].TextColor := AColor;
    CellByName['Grp_EngNo',r].TextColor := AColor;
    CellByName['Grp_CodeName',r].TextColor := AColor;
    CellByName['Grp_CodeDesc', r].TextColor := AColor;
    CellByName['Grp_SetValue', r].TextColor := AColor;
    CellByName['Grp_AlarmType', r].TextColor := AColor;
    CellByName['Grp_RegUser', r].TextColor := AColor;

    Row[r].Data := AItem;
  end;
end;

procedure TFrame1.grid_GroupCellDblClick(Sender: TObject; ACol, ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  //grid_Group.hint에 DeptName;Deptcode;TeamName;TeamCode가 저장되어 있음
  SetUpAlarmConfigItem(TAlarmConfigItem(grid_Group.Row[ARow].Data), ARow, FAlarmConfigCollect);
end;

procedure TFrame1.InitAlamrConfigFormUI(AForm: TEngParamItemConfigForm);
begin
  with AForm do
  begin
    GeneralSheet.TabVisible := False;
    ClassificationSheet.TabVisible := False;
    GraphSheet.TabVisible := False;
    AlarmConfigSheet.Visible := True;
//    AdvOfficePager1.ActivePage := AlarmConfigSheet;

    LowAlarmGroup.Enabled := False;
    LowFaultGroup.Enabled := False;
    MaxAlarmGroup.Enabled := False;
    MaxFaultGroup.Enabled := False;
  end;
end;

procedure TFrame1.LoadData2Form(AForm: TEngParamItemConfigForm;
  AItem: TAlarmConfigItem);
var
  LNotifyTerminals: TNotifyTerminals;
  LNotifyApps: TNotifyApps;
begin
  with AForm do
  begin
    Panel1.Hint := grid_Group.Hint;//DeptName;Deptcode;TeamName;TeamCode 저장

    ProjNoEdit.Text := AItem.ProjNo;
    EngNoEdit.Text := AItem.EngNo;

    case AItem.AlarmSetType of
      astNone:;
      astDigital: begin
        DigitalAlarmGroup.CheckBox.Checked := True;
        DigitalSetValueRG.ItemIndex := Ord(StrToIntDef(AItem.SetValue, 0));
        DigitalAlarmDelayEdit.Text := IntToStr(AItem.Delay);
        DigitalAlarmNeedAckCB.Checked := AItem.NeedAck;
      end;
      astLoLo: begin
        LowFaultEnableCB.Checked := True;
        MinFaultEdit.Text :=  AItem.SetValue;
        MinFaultDelayEdit.Text := IntToStr(AItem.Delay);
        MinFaultDeadBandEdit.Text := IntToStr(AItem.DeadBand);
        MinFaultNeedAckCB.Checked := AItem.NeedAck;
        LowFaultEnableCBClick(nil);
      end;
      astLo: begin
        LowAlarmEnableCB.Checked := True;
        MinAlarmEdit.Text :=  AItem.SetValue;
        MinAlarmDelayEdit.Text := IntToStr(AItem.Delay);
        MinAlarmDeadBandEdit.Text := IntToStr(AItem.DeadBand);
        MinAlarmNeedAckCB.Checked := AItem.NeedAck;
        LowAlarmEnableCBClick(nil);
      end;
      astHiHi: begin
        MaxFaultEnableCB.Checked := True;
        MaxFaultEdit.Text :=  AItem.SetValue;
        MaxFaultDelayEdit.Text := IntToStr(AItem.Delay);
        MaxFaultDeadBandEdit.Text := IntToStr(AItem.DeadBand);
        MaxFaultNeedAckCB.Checked := AItem.NeedAck;
        MaxFaultEnableCBClick(nil);
      end;
      astHi: begin
        MaxAlarmEnableCB.Checked := True;
        MaxAlarmEdit.Text :=  AItem.SetValue;
        MaxAlarmDelayEdit.Text := IntToStr(AItem.Delay);
        MaxAlarmDeadBandEdit.Text := IntToStr(AItem.DeadBand);
        MaxAlarmNeedAckCB.Checked := AItem.NeedAck;
        MaxAlarmEnableCBClick(nil);
      end;
    end;

    PriorityGrp.ItemIndex := ord(AItem.AlarmPriority);
    LNotifyTerminals := IntegerToNotifyTerminalSet(AItem.NotifyTerminals);
    NotifyTerminalsGB.CheckBox.Checked := LNotifyTerminals <> [];
    DesktopCB.Checked := ntDesktop in LNotifyTerminals;
    MobileCB.Checked := ntMobile in LNotifyTerminals;

    LNotifyApps := IntegerToNotifyAppSet(AItem.NotifyApps);
    NotifyAppsGB.CheckBox.Checked := LNotifyApps <> [];
    SMSCB.Checked := naSMS in LNotifyApps;
    NoteCB.Checked := naNote in LNotifyApps;
    EMailCB.Checked := naEmail in LNotifyApps;

    OutlampCB.Checked := AItem.IsOutLamp;
    IsOnlyRunCB.Checked := AItem.IsOnlyRun;
    DueDayEdit.Text := IntToStr(AItem.DueDay);
    RecipientsEdit.Text := AItem.Recipients;
  end;
end;

procedure TFrame1.LoadGrid(AGrid: TNextGrid; AStm: TStream);
var
  i, j: integer;
  ACount: integer;
  Len: integer;
  S: string;
  Lss: TStringStream;
  LStrList: TStringList;
  LStrArr: System.Types.TStringDynArray;
begin
  Lss := TStringStream.Create;
  LStrList := TStringList.Create;
  try
    Lss.CopyFrom(AStm,0);

    AGrid.BeginUpdate;
    AGrid.ClearRows;

    LStrList.LineBreak := #13;
    LStrList.Text := Lss.DataString;
    ACount := StrToIntDef(LStrList.Strings[0],0);
    AGrid.AddRow(ACount);

    for i := 0 to ACount - 1 do
    begin
      LStrArr := System.StrUtils.SplitString(LStrList.Strings[i+1], ';');

      for j := 0 to High(LStrArr) do
      begin
        AGrid.Cells[j,i] := LStrArr[j];
      end;
    end;

  finally
    Lss.Free;
    LStrList.Free;
    AGrid.EndUpdate;
  end;
end;

function TFrame1.SaveDataFromForm(AForm: TEngParamItemConfigForm;
  AItem: TAlarmConfigItem; AAlarmConfigCollect: TAlarmConfigCollect): boolean;
var
  i: integer;
  LAlarmSetType: TAlarmSetType;
  LValue, LMsg: string;
  LNotifyTerminals: TNotifyTerminals;
  LNotifyApps: TNotifyApps;
  LNeedAck: Boolean;
  LDelay, LDeadBand: integer;
begin
  Result := False;

  if AForm.DigitalAlarmGroup.CheckBox.Checked then
  begin
    LAlarmSetType := astDigital;
    LValue := IntToStr(AForm.DigitalSetValueRG.ItemIndex);
    LNeedAck := AForm.DigitalAlarmNeedAckCB.Checked;
    LDelay := StrToIntDef(AForm.DigitalAlarmDelayEdit.Text,0);
    LMsg := ' Alarm';
  end
  else
  if AForm.LowAlarmEnableCB.Checked then
  begin
    LAlarmSetType := astLo;
    LValue := AForm.MinAlarmEdit.Text;
    LNeedAck := AForm.MinAlarmNeedAckCB.Checked;
    LDelay := StrToIntDef(AForm.MinAlarmDelayEdit.Text,0);
    LDeadBand := StrToIntDef(AForm.MinAlarmDeadBandEdit.Text,0);
    LMsg := ' Low Alarm';
  end
  else
  if AForm.LowFaultEnableCB.Checked then
  begin
    LAlarmSetType := astLoLo;
    LValue := AForm.MinFaultEdit.Text;
    LNeedAck := AForm.MinFaultNeedAckCB.Checked;
    LDelay := StrToIntDef(AForm.MinFaultDelayEdit.Text,0);
    LDeadBand := StrToIntDef(AForm.MinFaultDeadBandEdit.Text,0);
    LMsg := ' Low Fault';
  end
  else
  if AForm.MaxAlarmEnableCB.Checked then
  begin
    LAlarmSetType := astHi;
    LValue := AForm.MaxAlarmEdit.Text;
    LNeedAck := AForm.MaxAlarmNeedAckCB.Checked;
    LDelay := StrToIntDef(AForm.MaxAlarmDelayEdit.Text,0);
    LDeadBand := StrToIntDef(AForm.MaxAlarmDeadBandEdit.Text,0);
    LMsg := ' High Alarm';
  end
  else
  if AForm.MaxFaultEnableCB.Checked then
  begin
    LAlarmSetType := astHiHi;
    LValue := AForm.MaxFaultEdit.Text;
    LNeedAck := AForm.MaxFaultNeedAckCB.Checked;
    LDelay := StrToIntDef(AForm.MaxFaultDelayEdit.Text,0);
    LDeadBand := StrToIntDef(AForm.MaxFaultDeadBandEdit.Text,0);
    LMsg := ' High Fault';
  end
  else
    LAlarmSetType := astNone;

  for i := 0 to AAlarmConfigCollect.Count - 1 do
  begin
    if i = grid_Group.SelectedRow then
      Continue;

    if (AAlarmConfigCollect.Items[i].UserID = AItem.UserID) and
       (AAlarmConfigCollect.Items[i].Category = AItem.Category) and
       (AAlarmConfigCollect.Items[i].ProjNo = AItem.ProjNo) and
       (AAlarmConfigCollect.Items[i].EngNo = AItem.EngNo) and
       (AAlarmConfigCollect.Items[i].TagName = AItem.TagName) and
       (AAlarmConfigCollect.Items[i].AlarmSetType = LAlarmSetType) then
    begin
      ShowMessage('User ID: ' + AItem.UserID + #13#10 +
                  'Category: ' + AItem.Category  + #13#10 +
                  'Project No: ' + AItem.ProjNo + '(' + AItem.EngNo + ')' + #13#10 +
                  'Tag Name: ' + AItem.TagName + #13#10 +
                  'Alarm Type: ' + TRttiEnumerationType.GetName<TAlarmSetType>(AItem.AlarmSetType) + #13#10 +
                  ' 설정값이 이미 존재함');
      exit;
    end;
  end;

  AItem.AlarmSetType := LAlarmSetType;
  AItem.SetValue := LValue;
  AItem.AlarmPriority := TAlarmPriority(AForm.PriorityGrp.ItemIndex);

  if AForm.DesktopCB.Checked then
    LNotifyTerminals := [ntDesktop];
  if AForm.MobileCB.Checked then
    LNotifyTerminals := LNotifyTerminals + [ntMobile];
  AItem.NotifyTerminals := NotifyTerminalSetToInteger(LNotifyTerminals);

  if AForm.SMSCB.Checked then
    LNotifyApps := [naSMS];
  if AForm.NoteCB.Checked then
    LNotifyApps := LNotifyApps + [naNote];
  if AForm.EMailCB.Checked then
    LNotifyApps := LNotifyApps + [naEmail];
  AItem.NotifyApps := NotifyAppSetToInteger(LNotifyApps);

  AItem.NeedAck := LNeedAck;
  AItem.Delay := LDelay;
  AItem.DeadBand := LDeadBand;
  AItem.IsOutLamp := AForm.OutlampCB.Checked;
  AItem.IsOnlyRun := AForm.IsOnlyRunCB.Checked;
  AItem.DueDay := StrToIntDef(AForm.DueDayEdit.Text, 0);
  AItem.RegDate := now;
  AItem.Recipients := AForm.RecipientsEdit.Text;

  if AForm.AlarmMsgEdit.Text <> '' then
    AItem.AlarmMessage := AForm.AlarmMsgEdit.Text;

  if Pos(LMsg, AItem.AlarmMessage) = 0 then
    AItem.AlarmMessage := AItem.AlarmMessage + LMsg;

  Result := True;
end;

procedure TFrame1.SaveGrid(AGrid: TNextGrid; AStm: TStream);
var
  i, j: integer;
  Len: integer;
  S: string;
  Lss: TStringStream;
begin
  Lss := TStringStream.Create;
  try
    Len := AGrid.RowCount;
    Lss.WriteString(IntToStr(Len) + #13);

    for i := 0 to AGrid.RowCount - 1 do
    begin
      for j := 0 to AGrid.Columns.Count - 1 do
      begin
        Lss.WriteString(AGrid.Cells[j,i]);

        if j = (AGrid.Columns.Count - 1) then
          Lss.WriteString(#13)
        else
          Lss.WriteString(';');
      end;
    end;

    AStm.CopyFrom(Lss,0);
  finally
    Lss.Free;
  end;
end;

procedure TFrame1.SetUpAlarmConfigItem(AItem: TAlarmConfigItem; ARow: integer; ACollect: TAlarmConfigCollect);
var
  LEngParamItemConfigForm: TEngParamItemConfigForm;
begin
  LEngParamItemConfigForm := TEngParamItemConfigForm.Create(nil);
  try
    with LEngParamItemConfigForm do
    begin
      //4가지 알람 설정 중에 한개만 선택 가능하게 함(astLoLo, astLo, astHiHi, astHi)
      FIsOnlyOneSelect := True;
      InitAlamrConfigFormUI(LEngParamItemConfigForm);

      if not AItem.IsAnalog then
        AItem.AlarmSetType := astDigital;

      if AItem.AlarmSetType = astDigital then
      begin
        LimitValueSheet_D.TabVisible := True;
        LimitValueSheet_A.TabVisible := False;
        AdvOfficePager1.ActivePage := LimitValueSheet_D;
      end
      else
        AdvOfficePager1.ActivePage := LimitValueSheet_A;

      LoadData2Form(LEngParamItemConfigForm, AItem);

      while True do
      begin
        if ShowModal = mrOK then
        begin
//          ShowMessage('This Setting Value is not saved to Database.' + #13#10 +
//            'If you want to save to Database, then select menu ' + #13#10 +
//            '"Alarm List Config" with mouse right button');
          if SaveDataFromForm(LEngParamItemConfigForm, AItem, ACollect) then
          begin
            FillInAlarmConfigItem2GrpGrid(AItem, ARow);
            break;
          end;
        end
        else
          break;
      end;
    end;
  finally
    LEngParamItemConfigForm.Free;
  end;
end;

procedure TFrame1.ToggleCheckGridAll(AGrid: TNextGrid; ACol: integer;
  AChecked: Boolean);
var
  i: integer;
begin
  with AGrid do
  begin
    BeginUpdate;
    try
      for i := 0 to AGrid.RowCount-1 do
        Cell[ACol,i].AsInteger := BoolToInt(AChecked);
    finally
      EndUpdate;
    end;
  end;
end;

end.
