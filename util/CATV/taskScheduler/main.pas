unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  taskSchd, ComCtrls, generics.collections, StdCtrls, Vcl.Menus;

type
  TMainForm = class(TForm)
    taskListView: TListView;
    DescriptionMemo: TMemo;
    PopupMenu1: TPopupMenu;
    CreateNewTask1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure taskListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure CreateNewTask1Click(Sender: TObject);
  private
    { Private declarations }
    taskList : TList<IRegisteredTask>;
    function GetTaskDescription(i:integer):string;
    function GetNetComputerName: String;
    procedure getTasks2RegisteredTaskList(folder : ITaskFolder);
    procedure GetTasks2ListView(AIPAddr: string = ''; AUserName: string = ''; APasswd: string = '');
    procedure SetNewTask(ATaskName, AExecName, AArgument: string;
      AIPAddr: string = ''; AUserName: string = ''; APasswd: string = '');
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

const TaskStateNames : array[TTaskState] of string = ('UnKnown', 'Disabled', 'Queued', 'Ready', 'Running');

implementation
uses typInfo;

{$R *.dfm}

procedure TMainForm.CreateNewTask1Click(Sender: TObject);
begin
//  SetNewTask('시험방송 3', '"C:\Program Files\Microsoft Office\Office14\POWERPNT.EXE"',
//    '/S "D:\scan\엔진기계사업본부 시험방송.ppsx"','10.14.3.103', 'ParkJungHyun', 'k2b59902');
  SetNewTask('시험방송 3', '"C:\Program Files (x86)\Microsoft Office\Office14\POWERPNT.EXE"',
    '/S "D:\scan\엔진기계사업본부 시험방송.ppsx"','10.14.21.117', 'HHI03', 'k2b125178');

//  SetNewTask('엔진방송 오전 1', '"C:\Program Files\Microsoft Office\Office14\POWERPNT.EXE"',
//    '/S "D:\Engine CATV\오전1\AM1.ppsx"','10.14.5.149', 'hhi', 'hhi@12345');
//  SetNewTask('엔진방송 오전 2', '"C:\Program Files\Microsoft Office\Office14\POWERPNT.EXE"',
//    '/S "D:\Engine CATV\오전1\AM2.ppsx"','10.14.5.149', 'hhi', 'hhi@12345');
//  SetNewTask('엔진방송 오전 1', '"C:\Program Files\Microsoft Office\Office14\POWERPNT.EXE"',
//    '/S "D:\Engine CATV\오후1\PM1.ppsx"','10.14.5.149', 'hhi', 'hhi@12345');
//  SetNewTask('엔진방송 오전 1', '"C:\Program Files\Microsoft Office\Office14\POWERPNT.EXE"',
//    '/S "D:\Engine CATV\오후2\PM2.ppsx"','10.14.5.149', 'hhi', 'hhi@12345');

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  taskList := TList<IRegisteredTask>.create();
  GetTasks2ListView('10.14.21.117', 'HHI', 'k2b125178');
//  GetTasks2ListView('10.14.5.149', 'hhi', 'hhi@12345');
end;

function TMainForm.GetNetComputerName: String;
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

function TMainForm.GetTaskDescription(i: integer): string;
begin
end;

procedure TMainForm.GetTasks2ListView(AIPAddr,AUserName,APasswd: string);
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

  tf := ts.GetFolder('\');

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

procedure TMainForm.getTasks2RegisteredTaskList(folder: ITaskFolder);
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

procedure TMainForm.SetNewTask(ATaskName, AExecName, AArgument: string; AIPAddr, AUserName, APasswd: string);
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
  sWhenToTrigger := FormatDateTime('yyyy-mm-dd', Now) + 'T' + FormatDateTime('hh:nn:ss', EncodeTime(8, 38, 0, 0));
  ts := CoTaskScheduler.Create();
  ts.Connect(AIPAddr, AUserName, '', APasswd);

  if ts.Connected then
  begin
    tf := ts.GetFolder('\');
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
      task.RegistrationInfo.Description := 'Example';

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

procedure TMainForm.taskListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
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
    for i := 1 to ac.Count do begin
        if ac.Item[i].ActionType = taExec then begin
            execAction := ac.item[i] as IExecAction;

            descriptionMemo.Lines.Add('蹶潗:  ' + execAction.Path );
        end;
    end;
end;

end.
