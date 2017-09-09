unit UnitScheduleList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  taskSchd, ComCtrls, generics.collections, StdCtrls, Vcl.Menus;

type
  TScheduleListF = class(TForm)
    taskListView: TListView;
    DescriptionMemo: TMemo;
    PopupMenu1: TPopupMenu;
    CreateNewTask1: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure taskListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure CreateNewTask1Click(Sender: TObject);
  private
    taskList : TList<IRegisteredTask>;

    function GetTaskDescription(i:integer):string;
    function GetNetComputerName: String;
    procedure getTasks2RegisteredTaskList(folder : ITaskFolder);
    procedure GetTasks2ListView(AIPAddr: string = ''; AUserName: string = ''; APasswd: string = '');
    procedure SetNewTask(ATaskName, AExecName, AArgument: string;
      AStartTime: TDateTime;
      AIPAddr: string = ''; AUserName: string = ''; APasswd: string = '');
  public
    procedure CreateNewTask4CATV;
    procedure CreateNewTask4CATV2;
    procedure CreateNewTask4Test;
  end;

var
  ScheduleListF: TScheduleListF;

const
  TaskStateNames : array[TTaskState] of string = ('UnKnown', 'Disabled', 'Queued', 'Ready', 'Running');
  SCHEDULE_FOLDER = '\CATV';
  CATV_IP = '10.14.5.149'; //10.14.21.117
  CATV_USER = 'hhi';  //HHI03
  CATV_PASSWD = 'hhi@12345'; //k2b125178

implementation

uses typInfo;

{$R *.dfm}

procedure TScheduleListF.CreateNewTask1Click(Sender: TObject);
begin
//  CreateNewTask4CATV;
//  CreateNewTask4Test;
  CreateNewTask4CATV2;
end;

procedure TScheduleListF.CreateNewTask4CATV;
var
  LDT: TDateTime;
  Ly,Lm,Ld: word;
begin
  DecodeDate(now, Ly,Lm,Ld);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(8, 10, 0, 0);
  SetNewTask('Engine CATV 1', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\8시10분\AM1.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(9, 10, 0, 0);
  SetNewTask('Engine CATV 2', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\9시10분\AM2.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(10, 20, 0, 0);
  SetNewTask('Engine CATV 3', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\10시20분\AM3.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(11, 10, 0, 0);
  SetNewTask('Engine CATV 4', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\11시10분\AM4.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(13, 10, 0, 0);
  SetNewTask('Engine CATV 5', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\13시10분\PM1.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(14, 10, 0, 0);
  SetNewTask('Engine CATV 6', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\14시10분\PM2.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(15, 20, 0, 0);
  SetNewTask('Engine CATV 7', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\15시20분\PM3.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(16, 0, 0, 0);
  SetNewTask('Engine CATV 8', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\16시\PM4.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(17, 0, 0, 0);
  SetNewTask('Engine CATV 9', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\17시\PM5.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  GetTasks2ListView(CATV_IP, CATV_USER, CATV_PASSWD);
end;

procedure TScheduleListF.CreateNewTask4CATV2;
var
  LDT: TDateTime;
  Ly,Lm,Ld: word;
begin
  DecodeDate(now, Ly,Lm,Ld);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(8, 10, 0, 0);
  SetNewTask('Engine CATV 1', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\8시10분\CATV.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(9, 10, 0, 0);
  SetNewTask('Engine CATV 2', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\9시10분\CATV.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(10, 20, 0, 0);
  SetNewTask('Engine CATV 3', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\10시20분\CATV.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(11, 10, 0, 0);
  SetNewTask('Engine CATV 4', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\11시10분\CATV.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(13, 10, 0, 0);
  SetNewTask('Engine CATV 5', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\13시10분\CATV.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(14, 10, 0, 0);
  SetNewTask('Engine CATV 6', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\14시10분\CATV.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(15, 20, 0, 0);
  SetNewTask('Engine CATV 7', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\15시20분\CATV.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(16, 0, 0, 0);
  SetNewTask('Engine CATV 8', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\16시\CATV.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(17, 0, 0, 0);
  SetNewTask('Engine CATV 9', '"D:\Engine CATV\EngineCATV.exe"',
    '"D:\Engine CATV\17시\CATV.ppsx"',LDT, CATV_IP, CATV_USER, CATV_PASSWD);

  GetTasks2ListView(CATV_IP, CATV_USER, CATV_PASSWD);
end;

procedure TScheduleListF.CreateNewTask4Test;
var
  LDT: TDateTime;
  Ly,Lm,Ld: word;
  LIp,
  LUser,
  LPasswd: string;
begin
  LIp := '10.14.21.117';
  LUser := 'HHI03';
  LPasswd := 'k2b125178';

  DecodeDate(now, Ly,Lm,Ld);

//  SetNewTask('시험방송 3', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
//    '/S "D:\scan\엔진기계사업본부 시험방송.ppsx"',LIp, LUser, LPasswd);

//  DecodeDate(now, Ly,Lm,Ld);
//  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(15, 46, 0, 0);
//  SetNewTask('시험방송 1', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
//    '"e:\scan\엔진기계사업본부 시험방송.ppsx"',LDT,LIp, LUser, LPasswd);
//
//  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(15, 47, 0, 0);
//  SetNewTask('시험방송 3', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
//    '"e:\scan\AM2.ppsx"',LDT,LIp, LUser, LPasswd);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(10, 10, 0, 0);
  SetNewTask('엔진방송 오전 1', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
    '"e:\scan\8시10분\AM1.ppsx"',LDT,LIp, LUser, LPasswd);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(10, 11, 0, 0);
  SetNewTask('엔진방송 오전 2', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
    '"e:\scan\9시10분\AM2.ppsx"',LDT,LIp, LUser, LPasswd);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(10, 12, 0, 0);
  SetNewTask('엔진방송 오전 3', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
    '"e:\scan\10시20분\AM3.ppsx"',LDT,LIp, LUser, LPasswd);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(10, 13, 0, 0);
  SetNewTask('엔진방송 오전 4', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
    '"e:\scan\11시10분\AM4.ppsx"',LDT,LIp, LUser, LPasswd);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(10, 14, 0, 0);
  SetNewTask('엔진방송 오후 1', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
    '"e:\scan\13시10분\PM1.ppsx"',LDT,LIp, LUser, LPasswd);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(10, 15, 0, 0);
  SetNewTask('엔진방송 오후 2', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
    '"e:\scan\14시10분\PM2.ppsx"',LDT,LIp, LUser, LPasswd);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(10, 16, 0, 0);
  SetNewTask('엔진방송 오후 3', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
    '"e:\scan\15시20분\PM3.ppsx"',LDT,LIp, LUser, LPasswd);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(10, 17, 0, 0);
  SetNewTask('엔진방송 오후 4', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
    '"e:\scan\16시\PM4.ppsx"',LDT,LIp, LUser, LPasswd);

  LDT := EncodeDate(Ly,Lm,Ld) + EncodeTime(10, 18, 0, 0);
  SetNewTask('엔진방송 오후 5', '"E:\pjh\project\util\CATV\EngineCATV.EXE"',
    '"e:\scan\17시\PM5.ppsx"',LDT,LIp, LUser, LPasswd);

  GetTasks2ListView(LIp, LUser, LPasswd);
end;

procedure TScheduleListF.FormCreate(Sender: TObject);
begin
  taskList := TList<IRegisteredTask>.create();
//  GetTasks2ListView(CATV_IP, CATV_USER, CATV_PASSWD);
//  GetTasks2ListView(CATV_IP, CATV_USER, CATV_PASSWD);
end;

function TScheduleListF.GetNetComputerName: String;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := Trim(buffer)
  else
    Result := ''
end;

function TScheduleListF.GetTaskDescription(i: integer): string;
begin
end;

procedure TScheduleListF.GetTasks2ListView(AIPAddr,AUserName,APasswd: string);
var
  ts : ITaskService;
  tf : ITaskFolder;
  task : IRegisteredTask;

  function getDate(date:TDate):string; inline;
  begin
    if date = 0 then result := ''
    else result := DateToStr(date);
  end;
begin
  ts := CoTaskScheduler.Create();
//    ts.Connect('', '', '', '');
  ts.Connect(AIPAddr,AUserName,'',APasswd);

  tf := nil;
  try
    tf := ts.GetFolder(SCHEDULE_FOLDER)
  except
    tf := ts.GetFolder('\');
    tf := tf.CreateFolder(SCHEDULE_FOLDER, null);
  end;

  getTasks2RegisteredTaskList(tf);

  taskListView.Items.BeginUpdate();
  try
    for task in taskList do
    begin
      with taskListView.Items.Add() do
      begin
        caption := task.Name;
        subItems.Add(getDate(task.LastRunTime));
        subItems.add(getDate(task.NextRunTime));
        subItems.Add(TaskStateNames[task.State]);
      end;
    end;
  finally
    taskListView.Items.EndUpdate();
  end;
end;

procedure TScheduleListF.getTasks2RegisteredTaskList(folder: ITaskFolder);
var
  i : integer;
  tfc : ITaskFolderCollection;
  tc : IRegisteredTaskCollection;
begin
//  taskList.Clear;

  tc := folder.GetTasks(1);
  for i := 1 to tc.Count do taskList.Add(tc.Item[i]);

  tfc := folder.GetFolders(0);
  for i:=1 to tfc.Count do getTasks2RegisteredTaskList(tfc.Item[i]);
end;

procedure TScheduleListF.SetNewTask(ATaskName, AExecName, AArgument: string;
  AStartTime: TDateTime; AIPAddr, AUserName, APasswd: string);
var
  ts : ITaskService;
  tf: ITaskFolder;
  task : ITaskDefinition;
  action: IExecAction;
  trigger: ITrigger;
  RegisteredTask: IRegisteredTask;
  sWhenToTrigger: String;
  i: integer;
begin
  //set trigger time to 22:00 each day
  sWhenToTrigger := FormatDateTime('yyyy-mm-dd', AStartTime) + 'T' + FormatDateTime('hh:nn:ss', AStartTime);
  ts := CoTaskScheduler.Create();
  ts.Connect(AIPAddr, AUserName, '', APasswd);

  if ts.Connected then
  begin
    tf := ts.GetFolder(SCHEDULE_FOLDER);
    taskList.Clear;
    getTasks2RegisteredTaskList(tf);
    try
      for i := 0 to taskList.Count - 1 do
      begin
        RegisteredTask := taskList.Items[i];
        if RegisteredTask.Name = ATaskName then
        begin
          tf.DeleteTask(ATaskName, 0);  //delete if exists
          break;
        end;
      end;
    except
    end;

    if AUserName = '' then
      AUserName := 'ParkJungHyun';

    try
      task := ts.NewTask(0);
      task.RegistrationInfo.Author := AUserName;
      task.RegistrationInfo.Description := 'Engine Division CATV Schedule';

      task.Settings.AllowDemandStart := True;
      task.Settings.Enabled := True;
      task.Settings.Hidden := False;
      task.Settings.StartWhenAvailable := True;
      task.Settings.DisallowStartIfOnBatteries := False;
      task.Settings.StopIfGoingOnBatteries := False;
      task.Settings.AllowHardTerminate := False;
      task.Settings.ExecutionTimeLimit := 'PT0S'; //(PT1H5M = 1시간 5분 동안 만 실행, PT0S = 무한대 시간동안  실행)

      action := task.Actions.Create(taExec) as IExecAction;
      action.Path := AExecName;//'C:\path to backup\BackupApp.exe'
//      action.WorkingDirectory := ExtractFileDir(action.Path);
      action.Arguments := AArgument; //possible arguments

      trigger := task.Triggers.Create(ttDaily) as ITrigger;
      trigger.Id := 'Backup demo';
      trigger.StartBoundary := sWhenToTrigger;
//      trigger.ExecutionTimeLimit := 'PT1H';   //1시간 이상 실행되는 작업 중지
//      trigger.EndBoundary := '2014-12-31T12:00:00';  ///when expires if set
      trigger.Enabled := True;

      RegisteredTask := tf.RegisterTaskDefinition(ATaskName, task, ord(tcCreateOrUpdate),
        AUserName, APasswd, tlIneractiveToken, '');
      ShowMessage('Task registered: '+RegisteredTask.Name);
    finally
      action := nil;
      trigger := nil;
      task := nil;
      ts := nil;
    end;
  end;
end;

procedure TScheduleListF.taskListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var index : integer;
    td : ITaskDefinition;
    regInfo : IRegistrationInfo;
    ac : IActionCollection;
    execAction : IExecAction;
    i:integer;
begin
    if not selected then exit;

    td := taskList[taskListView.ItemIndex].Definition;
    regInfo := td.RegistrationInfo;
    with descriptionMemo.lines do begin
        text := regInfo.Description;
        add( regInfo.Author + '/' + regInfo.Version );
    end;

    ac := td.Actions;
    for i := 1 to ac.Count do
    begin
        if ac.Item[i].ActionType = taExec then
        begin
            execAction := ac.item[i] as IExecAction;
            descriptionMemo.Lines.Add('aaa:' + execAction.Path );
        end;
    end;
end;

end.
