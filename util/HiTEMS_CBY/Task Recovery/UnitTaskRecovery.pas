unit UnitTaskRecovery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TodoList, AdvSmoothStepControl,
  GDIPPictureContainer, UnitDataModule, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  TaskDialog, Vcl.Menus, Vcl.ExtDlgs;

type
  TTaskRecoveryF = class(TForm)
    GDIPPictureContainer1: TGDIPPictureContainer;
    RecoveryStep: TAdvSmoothStepControl;
    TodoList1: TTodoList;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    TaskNoEdit: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    Splitter1: TSplitter;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    TeamCodeEdit: TEdit;
    PopupMenu1: TPopupMenu;
    FTaskNoList1: TMenuItem;
    FPlanNoList1: TMenuItem;
    FResultNoList1: TMenuItem;
    OpenTextFileDialog1: TOpenTextFileDialog;
    procedure RecoveryStepStepClick(Sender: TObject;
      StepIndex: Integer; StepMode: TStepMode);
    procedure RecoveryStepStepChanged(Sender: TObject; StepIndex: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FTaskNoList1Click(Sender: TObject);
    procedure FPlanNoList1Click(Sender: TObject);
    procedure FResultNoList1Click(Sender: TObject);
  private
    FTaskDialog: tAdvTaskDialog;
    FTaskNoList: TStringList;//복구하고자 하는 Task No 자신 및 하위 Task No List를 저장 함
    FPlanNoList: TStringList;//복구하고자 하는 Task No에 등록한 Plan No List를 저장 함
    FResultNoList: TStringList;//복구하고자 하는 Plan No에 실적을 등록한 Result No List를 저장 함
    FResultMHList: TStringList;//복구하고자 하는 Plan No에 실적을 등록한 Result MH List를 저장 함
  public
    procedure InitVar;
    procedure DestroyVar;
    procedure DisplayMessage(msg: string);

    procedure ExecuteToDoList(AToDoIndex: integer);
    procedure CheckTmsTaskClone(AToDoIndex: integer);
    procedure InsertTmsTaskFromClone(AToDoIndex: integer);
    procedure CheckTmsTaskShareClone(AToDoIndex: integer);
    procedure InsertTmsTaskShareFromClone(AToDoIndex: integer);
    procedure CheckTmsPlanClone(AToDoIndex: integer);
    procedure InsertTmsPlanFromClone(AToDoIndex: integer);
    procedure InsertTmsPlanInchargeFromClone(AToDoIndex: integer);
    procedure CheckTmsAttfilesClone(AToDoIndex: integer);
    procedure InsertTmsAttfilesFromClone(AToDoIndex: integer);
    procedure CheckTmsResultClone(AToDoIndex: integer);
    procedure InsertTmsResultFromClone(AToDoIndex: integer);
    procedure CheckTmsResultMhClone(AToDoIndex: integer);
    procedure InsertTmsResultMhFromClone(AToDoIndex: integer);
  end;

var
  TaskRecoveryF: TTaskRecoveryF;

implementation

{$R *.dfm}

procedure TTaskRecoveryF.Button1Click(Sender: TObject);
var
  i: integer;
  ButtonChecked: integer; // custom button number checked
begin
  if TaskNoEdit.Text = '' then
  begin
    ShowMessage('Task No를 입력 하시오.');
    TaskNoEdit.SetFocus;
    exit;
  end;

  if TeamCodeEdit.Text = '' then
  begin
    ShowMessage('Team Code를 입력 하시오.');
    TeamCodeEdit.SetFocus;
    exit;
  end;

  RecoveryStep.ActiveStep := 1;
  FTaskDialog.DialogPosition := dpOwnerFormCenter;

  for i := 0 to ToDoList1.Items.Count - 1 do
  begin
    FTaskDialog.Clear;
    FTaskDialog.Title := IntToStr(i+1) + '번째 작업 중...';
    FTaskDialog.Instruction := ToDoList1.Items.Items[i].Subject;
    FTaskDialog.Content := ToDoList1.Items.Items[i].Notes.Text;
//    FTaskDialog.Options := FTaskDialog.Options + [doHyperlinks];
    FTaskDialog.CommonButtons := FTaskDialog.CommonButtons + [cbClose];
    FTaskDialog.CustomButtons.add('Execute >>');
    FTaskDialog.CustomButtons.add('Skip >>');

    ButtonChecked := FTaskDialog.Execute;

    if buttonChecked < 100 then
    begin // it's a standard button
      case ButtonChecked of
        id_OK:  ShowMessage('id_OK');
        id_YES: ShowMessage('id_YES');
        id_NO:  ;
        id_CANCEL: ShowMessage('id_CANCEL');
        id_RETRY:  ;
        ID_CLOSE: break;
        id_ABORT:  ShowMessage('id_ABORT');
      else
        ;//'UNKNOWN'
      end;
    end
    else
    begin
      if FTaskDialog.CustomButtons[ButtonChecked-100] = 'Skip >>' then
        Continue
      else
      if FTaskDialog.CustomButtons[ButtonChecked-100] = 'Execute >>' then
        ExecuteToDoList(i);
    end;
  end;
end;

procedure TTaskRecoveryF.CheckTmsAttfilesClone(AToDoIndex: integer);
var
  i, j: integer;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;

    for i := 0 to FPlanNoList.Count - 1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
      ParamByName('planno').AsString := FPlanNoList.Strings[i];

      Open;

      if RecordCount > 0 then
        j := j + RecordCount;

      DisplayMessage('CLONE_HITEMS.TMS_ATTFILES Table 의 Plan No: ' + FPlanNoList.Strings[i] + ' 레코드가 ' + IntToStr(RecordCount) + ' 건 존재 함.');
    end;

    DisplayMessage('총 ' + IntToStr(j) + ' 건의 레코드가 존재 함');
  end;
end;

procedure TTaskRecoveryF.CheckTmsPlanClone(AToDoIndex: integer);
var
  i, j, k: integer;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;
    FPlanNoList.Clear;

    for i := 0 to FTaskNoList.Count - 1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
      ParamByName('taskno').AsString := FTaskNoList.Strings[i];

      Open;

      if RecordCount > 0 then
      begin
        j := j + RecordCount;

        for k := 0 to RecordCount - 1 do
        begin
          FPlanNoList.Add(FieldByName('Plan_No').AsString);
          Next;
        end;
      end;

      DisplayMessage('CLONE_HITEMS.TMS_PLAN Table 의 Task No: ' + FTaskNoList.Strings[i] + ' 레코드가 ' + IntToStr(RecordCount) + ' 건 존재 함.');
      DisplayMessage('===== Plan No ====');
    end;

    for k := 0 to FPlanNoList.Count - 1 do
      DisplayMessage('( ' + IntToStr(k+1) + ' ) ' + FPlanNoList.Strings[k]);

    DisplayMessage('총 ' + IntToStr(j) + ' 건의 레코드가 존재 함');
  end;
end;

procedure TTaskRecoveryF.CheckTmsResultClone(AToDoIndex: integer);
var
  i, j, k: integer;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;

    FResultNoList.Clear;

    for i := 0 to FPlanNoList.Count - 1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
      ParamByName('planno').AsString := FPlanNoList.Strings[i];

      Open;

      if RecordCount > 0 then
      begin
        j := j + RecordCount;

        for k := 0 to RecordCount - 1 do
        begin
          FResultNoList.Add(FieldByName('Rst_No').AsString);
          Next;
        end;
      end;

      DisplayMessage('CLONE_HITEMS.TMS_RESULT Table 의 Plan No: ' + FPlanNoList.Strings[i] + ' 레코드가 ' + IntToStr(RecordCount) + ' 건 존재 함.');
    end;

    DisplayMessage('총 ' + IntToStr(j) + ' 건의 레코드가 존재 함');
    DisplayMessage(' ');
    DisplayMessage('====> Result No List <====');

    for k := 0 to FResultNoList.Count - 1 do
      DisplayMessage('( ' + IntToStr(k+1) + ' ) ' + FResultNoList.Strings[k]);
    DisplayMessage('총 ' + IntToStr(FResultNoList.Count) + ' 건의 Result Code 레코드가 CLONE_HITEMS.TMS_RESULT Table에 존재 함');
  end;
end;

procedure TTaskRecoveryF.CheckTmsResultMhClone(AToDoIndex: integer);
var
  i, j, k: integer;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;
    FResultMHList.Clear;

    for i := 0 to FResultNoList.Count - 1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
      ParamByName('rstno').AsString := FResultNoList.Strings[i];

      Open;

      if RecordCount > 0 then
      begin
        for k := 0 to RecordCount - 1 do
        begin
          FResultMHList.Add(FieldByName('RST_NO').AsString + ';' + FieldByName('RST_SORT').AsString + ';' + FieldByName('RST_BY').AsString + ';');
          Next;
        end;

        j := j + RecordCount;
      end;

      DisplayMessage('CLONE_HITEMS.TMS_RESULT_MH Table 의 Result No: ' + FResultNoList.Strings[i] + ' 레코드가 ' + IntToStr(RecordCount) + ' 건 존재 함.');
    end;

    DisplayMessage('총 ' + IntToStr(j) + ' 건의 Result No 레코드가 CLONE_HITEMS.TMS_RESULT_MH Table에 존재 함');
  end;
end;

procedure TTaskRecoveryF.CheckTmsTaskClone(AToDoIndex: integer);
var
  i: integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
    ParamByName('taskno').AsString := TaskNoEdit.Text;

    Open;

    if RecordCount > 0 then
    begin
      FTaskNoList.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        FTaskNoList.Add(FieldByName('Task_No').AsString);
        Next;
      end;

      DisplayMessage(DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
      DisplayMessage('Task No: ' + TaskNoEdit.Text + '의 하위 Task 로 ' + IntToStr(RecordCount) + ' 건의 레코드가 CLONE_HITEMS.TMS_TASK Table에 존재 함.');
      DisplayMessage('===== Task No ====');

      for i := 0 to FTaskNoList.Count - 1 do
        DisplayMessage('( ' + IntToStr(i+1) + ' ) ' + FTaskNoList.Strings[i]);
    end
    else
      DisplayMessage('CLONE_HITEMS.TMS_TASK Table에 Task No: ' + TaskNoEdit.Text + ' 가 존재 하지 않음.');

    Close;
  end;
end;

procedure TTaskRecoveryF.CheckTmsTaskShareClone(AToDoIndex: integer);
var
  i, j: integer;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;

    for i := 0 to FTaskNoList.Count - 1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
      ParamByName('taskno').AsString := FTaskNoList.Strings[i];

      Open;

      if RecordCount > 0 then
        j := j + RecordCount;

      DisplayMessage('CLONE_HITEMS.TMS_TASK_SHARE Table 의 Task No: ' + FTaskNoList.Strings[i] + ' 레코드가 ' + IntToStr(RecordCount) + ' 건 존재 함.');
    end;

    DisplayMessage('총 ' + IntToStr(j) + ' 건의 레코드가 존재 함');
  end;
end;

procedure TTaskRecoveryF.DestroyVar;
begin
  FResultMHList.Free;
  FPlanNoList.Free;
  FResultNoList.Free;
  FTaskNoList.Free;
  FTaskDialog.Free;
end;

procedure TTaskRecoveryF.DisplayMessage(msg: string);
begin
  with Memo1 do
  begin
    if Lines.Count > 100 then
      Clear;

    Lines.Add(msg);
  end;//with
end;

procedure TTaskRecoveryF.ExecuteToDoList(AToDoIndex: integer);
begin
  case AToDoIndex of
    0: CheckTmsTaskClone(AToDoIndex);
    1: InsertTmsTaskFromClone(AToDoIndex);
    2: CheckTmsTaskShareClone(AToDoIndex);
    3: InsertTmsTaskShareFromClone(AToDoIndex);
    4: CheckTmsPlanClone(AToDoIndex);
    5: InsertTmsPlanFromClone(AToDoIndex);
    6: InsertTmsPlanInchargeFromClone(AToDoIndex);
    7: CheckTmsAttfilesClone(AToDoIndex);
    8: InsertTmsAttfilesFromClone(AToDoIndex);
    9: CheckTmsResultClone(AToDoIndex);
    10: InsertTmsResultFromClone(AToDoIndex);
    11: CheckTmsResultMhClone(AToDoIndex);
    12: InsertTmsResultMhFromClone(AToDoIndex);
  end;

end;

procedure TTaskRecoveryF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TTaskRecoveryF.FormDestroy(Sender: TObject);
begin
  DestroyVar;
end;

procedure TTaskRecoveryF.FPlanNoList1Click(Sender: TObject);
begin
  if OpenTextFileDialog1.Execute() then
  begin
    FPlanNoList.SaveToFile(OpenTextFileDialog1.FileName);
  end;

end;

procedure TTaskRecoveryF.FResultNoList1Click(Sender: TObject);
begin
  if OpenTextFileDialog1.Execute() then
  begin
    FResultNoList.SaveToFile(OpenTextFileDialog1.FileName);
  end;

end;

procedure TTaskRecoveryF.FTaskNoList1Click(Sender: TObject);
begin
  if OpenTextFileDialog1.Execute() then
  begin
    FTaskNoList.SaveToFile(OpenTextFileDialog1.FileName);
  end;
end;

procedure TTaskRecoveryF.InitVar;
begin
  FTaskDialog := tAdvTaskDialog.Create(Self);
  FTaskNoList := TStringList.Create;
  FResultNoList := TStringList.Create;
  FPlanNoList := TStringList.Create;
  FResultMHList := TStringList.Create;
end;

procedure TTaskRecoveryF.InsertTmsAttfilesFromClone(AToDoIndex: integer);
var
  i, j: integer;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;

    for i := 0 to FPlanNoList.Count - 1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
      ParamByName('planno').AsString := FPlanNoList.Strings[i];

      ExecSql;

      inc(j);
    end;

    DisplayMessage('총 ' + IntToStr(j) + ' 건의 Plan No에 해당하는 레코드를 HITEMS.TMS_ATTFIES Table에 복사 함(복사한 레코드 건수는 아님)');
  end;
end;

procedure TTaskRecoveryF.InsertTmsPlanFromClone(AToDoIndex: integer);
var
  i, j: integer;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;

    for i := 0 to FTaskNoList.Count - 1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
      ParamByName('taskno').AsString := FTaskNoList.Strings[i];

      ExecSQL;

      inc(j);
      DisplayMessage('CLONE_HITEMS.TMS_PLAN Table 의 Task No: ' + FTaskNoList.Strings[i] + ' 레코드를 HiTEMS.TMS_PLAN Table에 복사 함.');
    end;

    DisplayMessage('총 ' + IntToStr(j) + ' 건의 레코드를 복사 완료 함');
  end;
end;

procedure TTaskRecoveryF.InsertTmsPlanInchargeFromClone(AToDoIndex: integer);
var
  i, j, k: integer;
  LPlanNoExist: TStringList;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;
    k := 0;

    LPlanNoExist := TStringList.Create;
    try
      for i := 0 to FPlanNoList.Count - 1 do
      begin
        DM1.OraQuery2.Close;
        DM1.OraQuery2.SQL.Clear;
        DM1.OraQuery2.SQL.Add('select * from TMS_PLAN_INCHARGE where plan_no =:planno');
        DM1.OraQuery2.ParamByName('planno').AsString := FPlanNoList.Strings[i];
        DM1.OraQuery2.Open;

        if DM1.OraQuery2.RecordCount = 0 then
        begin
          Close;
          SQL.Clear;
          SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
          ParamByName('planno').AsString := FPlanNoList.Strings[i];

          ExecSql;

          inc(j);
        end
        else
        begin
          inc(k);
          LPlanNoExist.Add(FPlanNoList.Strings[i]);
          DisplayMessage('Plan No: ' + FPlanNoList.Strings[i] +' 이(가)  HITEMS.TMS_RESULT Table에 이미 존재하므로 Skip 함.');
        end;
      end;

      DisplayMessage('총 ' + IntToStr(k) + ' 건의 Plan No에 해당하는 레코드를 Skip 함');
      DisplayMessage('총 ' + IntToStr(j) + ' 건의 Plan No에 해당하는 레코드를 HITEMS.TMS_PLAN_INCHARGE Table에 복사 함(복사한 레코드 건수는 아님)');
    finally
      LPlanNoExist.SaveToFile('.\PlanNoExistedListOnTmsPlanIncharge' + FormatDateTime('yyyymmddhhnnss', now) + '.txt');
      LPlanNoExist.Free;
    end;
  end;
end;

procedure TTaskRecoveryF.InsertTmsResultFromClone(AToDoIndex: integer);
var
  i, j, k: integer;
  LPlanNoExist: TStringList;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;
    k := 0;
    LPlanNoExist := TStringList.Create;
    try
      for i := 0 to FPlanNoList.Count - 1 do
      begin
        DM1.OraQuery2.Close;
        DM1.OraQuery2.SQL.Clear;
        DM1.OraQuery2.SQL.Add('select * from TMS_RESULT where plan_no =:planno');
        DM1.OraQuery2.ParamByName('planno').AsString := FPlanNoList.Strings[i];
        DM1.OraQuery2.Open;

        if DM1.OraQuery2.RecordCount = 0 then
        begin
          Close;
          SQL.Clear;
          SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
          ParamByName('planno').AsString := FPlanNoList.Strings[i];

          ExecSql;

          inc(j)
        end
        else
        begin
          inc(k);
          LPlanNoExist.Add(FPlanNoList.Strings[i]);
          DisplayMessage('Plan No: ' + FPlanNoList.Strings[i] +' 이(가)  HITEMS.TMS_RESULT Table에 이미 존재하므로 Skip 함.');
        end;
      end;

      DisplayMessage('총 ' + IntToStr(k) + ' 건의 Plan No에 해당하는 레코드를 Skip 함');
      DisplayMessage('총 ' + IntToStr(j) + ' 건의 Plan No에 해당하는 레코드를 HITEMS.TMS_RESULT Table에 복사 함(복사한 레코드 건수는 아님)');
    finally
      LPlanNoExist.SaveToFile('.\PlanNoExistedListOnTmsResult' + FormatDateTime('yyyymmddhhnnss', now) + '.txt');
      LPlanNoExist.Free;
    end;
  end;
end;

procedure TTaskRecoveryF.InsertTmsResultMhFromClone(AToDoIndex: integer);
var
  i, j: integer;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;

    for i := 0 to FResultNoList.Count - 1 do
    begin
//      DM1.OraQuery2.Close;
//      DM1.OraQuery2.SQL.Clear;
//      DM1.OraQuery2.SQL.Add('select * from TMS_RESULT_MH where plan_no =:planno');
//      DM1.OraQuery2.ParamByName('planno').AsString := FPlanNoList.Strings[i];
//      DM1.OraQuery2.Open;

//      if DM1.OraQuery2.RecordCount = 0 then
//      begin
      try
        Close;
        SQL.Clear;
        SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
        ParamByName('rstno').AsString := FResultNoList.Strings[i];

        ExecSql;

        inc(j)
      except

      end;
//      end
//      else
//      begin
//        inc(k);
//        LPlanNoExist.Add(FPlanNoList.Strings[i]);
//        DisplayMessage('Plan No: ' + FPlanNoList.Strings[i] +' 이(가)  HITEMS.TMS_RESULT Table에 이미 존재하므로 Skip 함.');
//      end;
    end;

    DisplayMessage('총 ' + IntToStr(j) + ' 건의 Plan No에 해당하는 레코드를 HITEMS.TMS_RESULT_MH Table에 복사 함(복사한 레코드 건수는 아님)');
  end;
end;

procedure TTaskRecoveryF.InsertTmsTaskFromClone(AToDoIndex: integer);
var
  i, j: integer;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;

    for i := 0 to FTaskNoList.Count - 1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
      ParamByName('taskno').AsString := FTaskNoList.Strings[i];

      ExecSQL;

      inc(j);
      DisplayMessage('CLONE_HITEMS.TMS_TASK Table 의 Task No: ' + FTaskNoList.Strings[i] + ' 레코드를 HiTEMS.TMS_TASK Table에 복사 함.');
    end;

    DisplayMessage('총 ' + IntToStr(j) + ' 건의 레코드를 복사 완료 함');
  end;
end;

procedure TTaskRecoveryF.InsertTmsTaskShareFromClone(AToDoIndex: integer);
var
  i, j: integer;
begin
  with DM1.OraQuery1 do
  begin
    DisplayMessage(#13#10 + DateTimeToStr(now) + '====> '+ ToDoList1.Items.Items[AToDoIndex].Subject + ' 작업 결과 <====');
    j := 0;

    for i := 0 to FTaskNoList.Count - 1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(ToDoList1.Items.Items[AToDoIndex].Notes.Text);
      ParamByName('taskno').AsString := FTaskNoList.Strings[i];

      ExecSQL;

      inc(j);
      DisplayMessage('CLONE_HITEMS.TMS_TASK_SHARE Table 의 Task No: ' + FTaskNoList.Strings[i] + ' 레코드를 HiTEMS.TMS_TASK_SHARE Table에 복사 함.');
    end;

    DisplayMessage('총 ' + IntToStr(j) + ' 건의 레코드를 복사 완료 함');
  end;
end;

procedure TTaskRecoveryF.RecoveryStepStepChanged(Sender: TObject;
  StepIndex: Integer);
begin
;
end;

procedure TTaskRecoveryF.RecoveryStepStepClick(Sender: TObject;
  StepIndex: Integer; StepMode: TStepMode);
begin
  case StepIndex of
    0: ;
    1: ;
    2: ;
  end;

//  RecoveryStep.ActiveStep
end;

end.
