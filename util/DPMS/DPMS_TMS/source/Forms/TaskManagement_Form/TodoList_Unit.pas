unit TodoList_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TodoList, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.StdCtrls, Todo_Detail, Vcl.Menus, DateUtils;

type
  TToDoListF = class(TForm)
    Panel1: TPanel;
    TodoList1: TTodoList;
    Button1: TButton;
    BitBtn1: TBitBtn;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    Edit1: TMenuItem;
    procedure TodoList1DblClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure EditToDoList(AToDoList: TToDoList);
    procedure DeleteToDoItem;
    procedure AddToDoItem;
    procedure LoadToDoList2Detail(AToDoItem: TToDoItem; AToDoDetailF: TToDoDetailF);
//    procedure SaveToDoItem2Collect;
    procedure LoadToDoItemFromCollect(AIndex: integer; AIsAdd: Boolean);
    procedure SaveToDoItemFromDetailF(AIndex: integer; AToDoDetailF: TToDoDetailF);
  public
    FPlanNo,
    FTaskNo: string;

    procedure Get_ToDoList(APlanNo: string);
  end;

var
  ToDoListF: TToDoListF;

function Create_ToDoList_Frm(aPlan_No: string) : Boolean;

implementation

uses HiTEMS_TMS_COMMON, DataModule_Unit, HiTEMS_TMS_CONST;

{$R *.dfm}

function Create_ToDoList_Frm(aPlan_No: string) : Boolean;
var
  i: integer;
begin
  ToDoListF := TToDoListF.Create(nil);
  try
    with ToDoListF do
    begin
      FPlanNo := aPlan_no;
      FTaskNo := '';

      for i := 0 to DM1.FToDoCollect4Alarm.Count - 1 do
      begin
        if DM1.FToDoCollect4Alarm.Items[i].PlanCode = aPlan_no then
        begin
          with TodoList1.Items.Add do
          begin
            Subject := DM1.FToDoCollect4Alarm.Items[i].Subject;
            Notes.Text := DM1.FToDoCollect4Alarm.Items[i].Notes.Text;
            Completion := DM1.FToDoCollect4Alarm.Items[i].Completion;
            DueDate := DM1.FToDoCollect4Alarm.Items[i].DueDate;
            CreationDate := DM1.FToDoCollect4Alarm.Items[i].CreationDate;
            Priority := DM1.FToDoCollect4Alarm.Items[i].Priority;
            Resource := DM1.FToDoCollect4Alarm.Items[i].Resource;
            Category := DM1.FToDoCollect4Alarm.Items[i].Category;
            Tag := i;
          end;
        end;
      end;

      ShowModal;
    end;
  finally
    FreeAndNil(ToDoListF);
  end;
end;

procedure TToDoListF.AddToDoItem;
begin
  with DM1.FToDoCollect4Alarm.Add do
  begin
    Subject := '새 일정';
    Notes.Text := '일정 상세';
//    Completion := Random(100);
    DueDate := Now + 60;
    CreationDate := Now;
    Priority := tpNormal;
    Resource := 'Unassigned';

//    LoadToDoItemFromCollect(Index);
  end;
end;

procedure TToDoListF.Button1Click(Sender: TObject);
begin
  EditToDoList(ToDoList1);
end;

procedure TToDoListF.Button3Click(Sender: TObject);
begin
  DeleteToDoItem;
end;

procedure TToDoListF.DeleteToDoItem;
begin
  if Assigned(TodoList1.Selected) then
  begin
    if MessageDlg('선택한 항목을 삭제 하시겠습니까?', mtConfirmation, [mbYes, mbNo],
      0) = mrYes then
    begin
      DM1.DeleteToDoList2DB(TodoList1.Selected.Tag);
      DM1.FToDoCollect4Alarm.Delete(TodoList1.Selected.Tag);
      TodoList1.Items.Delete(TodoList1.Selected.Index);
    end;
  end;
end;

procedure TToDoListF.Edit1Click(Sender: TObject);
begin
  if Assigned(TodoList1.Selected) then
    EditToDoList(TodoList1);
end;

procedure TToDoListF.EditToDoList(AToDoList: TToDoList);
var
  LToDoDetailF: TToDoDetailF;
  LIsEdit: Boolean;
  LIdx: integer;
begin
  LToDoDetailF := TToDoDetailF.Create(Self);
  try
    LIsEdit := Assigned(AToDoList.Selected);

    if LIsEdit then
      LoadToDoList2Detail(AToDoList.Selected, LToDoDetailF);

    if LToDoDetailF.ShowModal = mrOK then
    begin
      if LIsEdit then
        LIdx := AToDoList.Selected.Tag
      else
        LIdx := -1;

      SaveToDoItemFromDetailF(LIdx, LToDoDetailF);
    end;
  finally
    FreeAndNil(LToDoDetailF);
  end;//try
end;

procedure TToDoListF.Get_ToDoList(APlanNo: string);
begin

end;

procedure TToDoListF.LoadToDoItemFromCollect(AIndex: integer; AIsAdd: Boolean);
var
  LTodoItem: TTodoItem;
begin
  if AIsAdd then
    LTodoItem := ToDoList1.Items.Add
  else
    LTodoItem := ToDoList1.Items.Items[AIndex];

  DM1.FToDoCollect4Alarm.Items[AIndex].AssignTo(LTodoItem);
  LTodoItem.Tag := AIndex;
end;

procedure TToDoListF.LoadToDoList2Detail(AToDoItem: TToDoItem; AToDoDetailF: TToDoDetailF);
var
  Lidx: integer;
  myHour, myMin, mySec, myMilli : Word;
begin
  Lidx := AToDoItem.Tag;

  with AToDoDetailF, DM1.FToDoCollect4Alarm.Items[Lidx] do
  begin
    SubjectEdit.Text := Subject;
    dt_begin.Date := CreationDate;
    DecodeTime(CreationDate, myHour, myMin, mySec, myMilli);
    Time_Begin.Time := EncodeTime(myHour, myMin, mySec, myMilli);
    dt_end.date := DueDate;
    DecodeTime(DueDate, myHour, myMin, mySec, myMilli);
    Time_End.Time := EncodeTime(myHour, myMin, mySec, myMilli);
    NoteMemo.Lines.Assign(Notes);
    AlarmCombo.ItemIndex := GetAlarmComboIndex(AlarmTime2);
    MsgCB.Checked := Alarm2Msg = 1;
    NoteCB.Checked := Alarm2Note = 1;
  end;
end;

procedure TToDoListF.SaveToDoItemFromDetailF(AIndex: integer;
  AToDoDetailF: TToDoDetailF);
var
  myHour, myMin, mySec, myMilli : Word;
  myYear, myMonth, myDay : Word;
  LToDoItem: TpjhTodoItem;
  LIsAdd: Boolean;
begin
  LIsAdd := AIndex = -1;

  if LIsAdd then
    LToDoItem := DM1.FToDoCollect4Alarm.Add
  else
    LToDoItem := DM1.FToDoCollect4Alarm.Items[AIndex];

  with AToDoDetailF, LToDoItem do
  begin
    Subject := SubjectEdit.Text;
    Category := AlarmCombo.Text;

    DecodeDate(dt_begin.Date,myYear, myMonth, myDay);
    DecodeTime(Time_Begin.Time, myHour, myMin, mySec, myMilli);
    CreationDate := EncodeDateTime(myYear, myMonth, myDay, myHour, myMin, mySec, myMilli);

    DecodeDate(dt_end.Date,myYear, myMonth, myDay);
    DecodeTime(Time_End.Time, myHour, myMin, mySec, myMilli);
    DueDate := EncodeDateTime(myYear, myMonth, myDay, myHour, myMin, mySec, myMilli);

    Notes.Assign(NoteMemo.Lines);

    AlarmType := 2;
    AlarmTime2 := GetAlarmInterval(AlarmCombo.ItemIndex);
    Alarm2Msg := Integer(MsgCB.Checked);
    Alarm2Note := Integer(NoteCB.Checked);
    Moddate := now;

    if LIsAdd then
    begin
      TodoCode := FormatDateTime('yyyymmddhhmmsszzz', now);
      PlanCode := FPlanNo;
      ModId := DM1.FUserInfo.UserID;
    end;
  end;

  LoadToDoItemFromCollect(LToDoItem.Index, LIsAdd);
  DM1.InsertOrUpdateToDoList2DB(LToDoItem.Index, LIsAdd);
end;

procedure TToDoListF.TodoList1DblClick(Sender: TObject);
begin
  if Assigned(TodoList1.Selected) then
    EditToDoList(TodoList1);
end;

end.
