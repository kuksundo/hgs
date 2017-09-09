{ Unit Feedbacks

  Unit Feedbacks provides an Outlook-style feedback dialog that shows
  the tasks at hand and the progress.

  Author: Nils Haeck M.Sc.
  Copyright (c) 1999 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}

unit guiFeedback;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  rxAnimate, StdCtrls, ExtCtrls, Gauges, Grids, ComCtrls, RXCtrls,
  Buttons, Contnrs, HTMLLite, ImgList, SyncObjs;

type

  TFeedback = class;

  // The TTaskStatus type is used to assign a status to the TFeedback Status property
  TTaskStatus = (tsWaiting, tsExecuting, tsSkipped, tsError, tsFatal, tsCanceled, tsCompleted);

  // TTaskItem is used by TFeedback to implement a task list.
  TTaskItem = class(TObject)
  private
    FName: string;
    FStatus: TTaskStatus;
    FOnStatusChange: TNotifyEvent;
  protected
    procedure SetStatus(AValue: TTaskStatus);
  public
    // Name holds the tasks' descriptive name that will appear in the feedback
    // task list.
    property Name: string read FName;
    // Status holds the current task status. See TFeedback.Status for more information.
    property Status: TTaskStatus read FStatus write SetStatus;
    property OnStatusChange: TNotifyEvent read FOnStatusChange write FOnStatusChange;
    constructor Create(AName: string);
  end;

  // EFeedback is raised when the user pushes "Stop". The exception is generated
  // from within the thread and can be detected using a Try..Except block in the
  // software.
  EFeedback = class(Exception);

  // TFeedback implements the outlook-style Feedback dialog. It is important to
  // setup the Feedback dialog in the following way:
  // begin
  //   Feedback.Start;
  //   try
  //     Feedback.Add('Your First task name');
  //     {any additional adds}
  //     {do processing}
  //     Feedback.Status := tsCompleted;
  //   finally
  //     Feedback.Finish;
  //   end;
  //  end;
  //  Note: match the number of tsCompleted to number of tasks

  // TFeedback class
  TFeedback = class(TForm)
    aiAnimator: TAnimatedImage;
    btnHide: TButton;
    lbTitle: TLabel;
    btnStop: TButton;
    pcFeedback: TPageControl;
    tsTasks: TTabSheet;
    tsStatus: TTabSheet;
    tsErrors: TTabSheet;
    ProgressPanel: TPanel;
    lbTasks: TLabel;
    edStatus: TRichEdit;
    btnDetails: TButton;
    Panel1: TPanel;
    lvTasks: TListView;
    lbInfo: TLabel;
    sbSticky: TSpeedButton;
    pnlErrors: TPanel;
    ilTasks: TImageList;
    imStatus: TImage;
    ProgressGauge: TGauge;
    ilIcons: TImageList;
    procedure btnHideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
    procedure sbStickyClick(Sender: TObject);
    procedure lvTasksData(Sender: TObject; Item: TListItem);
    procedure FormDestroy(Sender: TObject);
  private
    FAborted: boolean;
    FCurrentTask: integer;
    FErrors: TStrings;
    FHold: boolean;
    FLock: TCriticalSection;
    FProgress: double;           // Progress gauge position in %
    FShowDetails: boolean;
    FSticky: boolean;            // Keep window when finished
    FStopEnabled: boolean;
    FTasks: TObjectList;
    procedure CheckAbort;
    procedure TaskStatusChange(Sender: TObject);
    procedure UpdateControls;
  protected
    function GetCurrent: TTaskItem;
    function GetErrorCount: integer;
    function GetInfo: string;
    function GetStatus: TTaskStatus;
    function GetTaskCount: integer;
    function GetTasks(index: integer): TTaskItem;
    function GetTitle: string;
    procedure SetIconIndex(AValue: integer);
    procedure SetInfo(AValue: string);
    procedure SetProgress(AValue: double);
    procedure SetStatus(AValue: TTaskStatus);
    procedure SetSticky(AValue: boolean);
    procedure SetStopEnabled(AValue: boolean);
    procedure SetTitle(AValue: string);
    property IconIndex: integer write SetIconIndex;
  public
    // Current task item.
    property Current: TTaskItem read GetCurrent;
    property ErrorCount: integer read GetErrorCount;
    // Set Hold to true if you want the dialog to remain visible after Finish
    property Hold: boolean read FHold write FHold;
    // Set Info to display a message to the user on the second line
    property Info: string read GetInfo write SetInfo;
    // Set Progress to advance the progress indicator. It ranges from
    // 0 (empty beam) to 100 (full beam)
    property Progress: double read FProgress write SetProgress;
    // Set sticky to True if you want the dialog to remain permanently visible.
    // The "stick" (lower-right side) button will be in down state.
    property Sticky: boolean read FSticky write SetSticky;
    // Set Status to set the status for the current task. Status is one of the following:
    // - stWaiting: this is the standard, the task is waiting to be executed
    // - stExecuting: the task currently executes.
    // - stError: Set Status to stError to indicate an error ocurred with the task
    // - stFatal: Set Status to stFatal to indicate a fatal error occured in the task.
    //   All remaining tasks will be skipped.
    // - stCompleted: Set Status to stCompleted to indicate the task completed
    //   successfully.
    // Note: The feedback dialog automatically advances to the next task when
    // Status is set to either stError or stCompleted. And the status of the next task
    // is set to stExecuting.
    property Status: TTaskStatus read GetStatus write SetStatus;
    // StopEnabled indicates if the user is allowed to push the stop button
    property StopEnabled: boolean read FStopEnabled write SetStopEnabled;
    // TaskCount shows the number of tasks in the list
    property TaskCount: integer read GetTaskCount;
    // Use Tasks[TaskNo] to get a reference to TTaskItem with index TaskNo
    property Tasks[index: integer]: TTaskItem read GetTasks;
    // Set Title to display a title in the feedback dialog. When a task is executed
    // a title is also automatically displayed as the task's description.
    property Title: string read GetTitle write SetTitle;
    // Use Add to add a task to the list. ATask is the description of the task that
    // will appear in the Tasks list
    procedure Add(ATask: string);
    // Add an error message to the Errors tab. This error message may include any
    // html tags to format it.
    procedure AddError(AError: string);
    // Use clear to clear all controls and the task list inside the feedback dialog
    procedure Clear;
    // Assign DoInfo to any TInfoEvent to display the info string automatically
    procedure DoInfo(Sender: TObject; const AInfo: string);
    // Call Finish to finish all tasks and let the user know that all tasks are
    // finished. The feedback dialog is hidden if Hold and Sticky are FALSE, and
    // no errors have ocurred.
    procedure Finish;
    // Call start to start the feedback dialog.
    procedure Start;
  end;

var

  Feedback: TFeedback;

implementation

{$R *.DFM}

{ TTaskItem }

procedure TTaskItem.SetStatus(AValue: TTaskStatus);
begin
  if AValue <> FStatus then
  begin
    FStatus := AValue;
    if assigned(FOnStatusChange) then
      FOnStatusChange(Self);
  end;
end;

constructor TTaskItem.Create(AName: string);
begin
  inherited Create;
  FName := AName;
  FStatus := tsWaiting;
end;

{ TFeedback }

procedure TFeedback.FormCreate(Sender: TObject);
begin
  // property defaults
  FSticky := false;
  FCurrentTask := 0;
  FShowDetails := true;
  FStopEnabled := false;

  // Create the task list
  FTasks := TObjectList.Create;

  // Create errors list
  FErrors := TStringList.Create;

  // Create lock
  FLock := TCriticalSection.Create;

  // clear form
  Clear;
end;

procedure TFeedback.btnHideClick(Sender: TObject);
begin
  Hide;
end;

procedure TFeedback.CheckAbort;
begin
  if FAborted then
  begin
    FAborted := false;
    // Raise an exception
    raise EFeedback.Create('User has canceled the operation!');
  end;
end;

procedure TFeedback.TaskStatusChange(Sender: TObject);
var
  Task: TTaskItem;
  Index: integer;
begin
  CheckAbort;
  // React to any changes in the sender's status
  Task := TTaskItem(Sender);
  if assigned(Task) and assigned(FTasks) then
  begin
    Index := FTasks.IndexOf(Task);
    if Index >= 0 then
    begin
      case Task.Status of
      tsExecuting:
        begin
          FCurrentTask := Index;
          if assigned(Tasks[FCurrentTask]) then
          begin
            Title := Tasks[FCurrentTask].Name;
            Info := '';
            Progress := 0;
          end;
          StopEnabled := true;
          aiAnimator.Show;
        end;
      tsCanceled:
        begin
          FCurrentTask := Index;
          StopEnabled := false;
          aiAnimator.Hide;
          IconIndex := 0;
          imStatus.Show;
          Title := 'The user has canceled the operation.';
          Info := '';
        end;
      tsFatal:
        begin
          FCurrentTask := Index + 1;
          StopEnabled := false;

          // clean slate
          aiAnimator.Hide;
          IconIndex := 0;
          imStatus.Show;
          Title := '';
          Info := '';
        end;
      tsSkipped, tsError, tsCompleted:
        begin
          FCurrentTask := Index + 1;
          StopEnabled := false;

          // clean slate
          aiAnimator.Hide;

          Title := '';

          // Automatically start the new task
          if assigned(Tasks[FCurrentTask]) then
          begin
            Tasks[FCurrentTask].Status := tsExecuting;
            Info := '';
          end;
        end;
      end;//case
    end;
    UpdateControls;
  end;
end;

procedure TFeedback.UpdateControls;
var
  i: integer;
  Html: string;
begin
  CheckAbort;
  if TaskCount <> lvTasks.Items.Count then
    lvTasks.Items.Count := TaskCount;
  lvTasks.Invalidate;
  if TaskCount > 0 then
    lbTasks.Caption := Format('%d of %d tasks completed', [FCurrentTask, TaskCount])
  else
    lbTasks.Caption := 'No tasks';

  // Create html for error tab
  Html := '<body>';
  for i := 0 to FErrors.Count - 1 do
    Html := Html + '<li>' + FErrors[i] + '</li>';
  Html := Html + '</body>';

//  htErrors.LoadFromString(Html, '');
  Application.ProcessMessages;
end;

function TFeedback.GetCurrent: TTaskItem;
begin
  GetCurrent := Tasks[FCurrentTask];
end;

function TFeedback.GetErrorCount: integer;
begin
  Result := FErrors.Count;
end;

function TFeedback.GetInfo: string;
begin
  Result := lbInfo.Caption;
end;

function TFeedback.GetStatus: TTaskStatus;
begin
  Result := tsWaiting;
  if assigned(Current) then
    Result := Current.Status;
end;

function TFeedback.GetTaskCount: integer;
begin
  if assigned(FTasks) then
    Result := FTasks.Count
  else
    Result := 0;
end;

function TFeedback.GetTasks(Index: integer): TTaskItem;
begin
  Result := nil;
  if assigned(FTasks) and (Index >= 0) and (Index < FTasks.Count) then
    Result := TTaskItem(FTasks[Index]);
end;

function TFeedback.GetTitle: string;
begin
  Result := lbTitle.Caption;
end;

procedure TFeedback.SetIconIndex(AValue: integer);
var
  Icon: TIcon;
begin
  Icon := TIcon.Create;
  try
    ilIcons.GetIcon(AValue, Icon);
    imStatus.Picture.Assign(Icon);
  finally
    Icon.Free;
  end;
end;

procedure TFeedback.SetInfo(AValue: string);
begin
  lbInfo.Caption := AValue;
  CheckAbort;
  Application.ProcessMessages;
end;

procedure TFeedback.SetProgress(AValue: double);
begin
  CheckAbort;
  if AValue <> FProgress then
  begin
    FProgress := AValue;
    ProgressGauge.Progress := round(FProgress * 10);
    Application.ProcessMessages;
  end;
end;

procedure TFeedback.SetStatus(AValue: TTaskStatus);
begin
  CheckAbort;
  if assigned(Current) then
    Current.Status := AValue;
end;

procedure TFeedback.SetSticky(AValue: boolean);
const
  GlyphNo: array[boolean] of integer = (0, 1);
begin
  if AValue <> FSticky then
  begin
    FSticky := AValue;
    sbSticky.Down := FSticky;
  end;
end;

procedure TFeedback.SetStopEnabled(AValue: boolean);
begin
  if FStopEnabled <> AValue then
  begin
    FStopEnabled := AValue;
    btnStop.Enabled := FStopEnabled;
  end;
end;

procedure TFeedback.SetTitle(AValue: string);
begin
  CheckAbort;
  lbTitle.Caption := AValue;
  Application.ProcessMessages;
end;

procedure TFeedback.Add(ATask: string);
var
  Task: TTaskItem;
begin
  Task := TTaskItem.Create(ATask);
  Task.OnStatusChange := TaskStatusChange;
  FTasks.Add(Task);
  // First task? Start it automatically
  if TaskCount = 1 then
    Status := tsExecuting;
  UpdateControls;
end;

procedure TFeedback.AddError(AError: string);
begin
  FErrors.Add(AError);
  UpdateControls;
end;

procedure TFeedback.Clear;
begin
  // clear controls
  if assigned(FTasks) then
    FTasks.Clear;

  FCurrentTask := 0;
  aiAnimator.Hide;
  imStatus.Hide;
  Title := '';
  Info := '';
  Progress := 0;
  pcFeedback.ActivePage := tsTasks;
  FAborted := false;
  FHold := false;

  edStatus.Lines.Clear;
  FErrors.Clear;

  // clear depending controls
  UpdateControls;

end;

procedure TFeedback.DoInfo(Sender: TObject; const AInfo: string);
begin
  edStatus.Lines.Add(AInfo);
  Info := AInfo;
end;

procedure TFeedback.Finish;
var
  i: integer;
  AErrorCount,
  CompleteCount: integer;
  // local
  function NormalExit: boolean;
  begin
    Result := true;
    if (TaskCount > 0) and not (Tasks[TaskCount - 1].Status = tsCompleted) then
      Result := false;
  end;
// main
begin
  // Count errors
  AErrorCount := 0;
  CompleteCount := 0;

  // If we get here with executing mode it must be a fatal error
  if Status = tsExecuting then
    Status := tsFatal;

  for i := 0 to TaskCount - 1 do
  begin
    if Tasks[i].Status in [tsError, tsFatal] then
      inc(AErrorCount);
    if Tasks[i].Status in [tsCompleted, tsSkipped] then
      inc(CompleteCount);
  end;

  // Last message
  if AErrorCount = 0 then
  begin
    IconIndex := 1;
    if TaskCount = 0 then
      Title := 'No tasks processed.'
    else
      if (TaskCount = 1) and (CompleteCount = 1) then
      begin
        Title := 'The task was completed successfully.'
      end else
      begin
        if (CompleteCount = TaskCount) then
          Title := 'All tasks were completed successfully.'
        else
          Title := 'Some tasks were not completed.';
      end;
  end else
  begin
    IconIndex := 0;
    Title := 'Some tasks have errors.' + #13 +
             'See Errors for more information.';
    pcFeedback.ActivePage := tsErrors;
  end;
  Info := '';
  Progress := 0;
  aiAnimator.Hide;
  imStatus.Show;

  // Hide
  if (not Sticky) and (not Hold) and NormalExit then
    Hide;
end;

procedure TFeedback.Start;
begin
  Clear;
  Show;
end;

procedure TFeedback.btnStopClick(Sender: TObject);
begin
  if assigned(Tasks[FCurrentTask]) then
    Tasks[FCurrentTask].Status := tsCanceled;

  // Reflect state
  FAborted := True;
  btnStop.Enabled := false;

end;

procedure TFeedback.btnDetailsClick(Sender: TObject);
const
  cDisplayHeight: array[boolean] of integer = (145, 391);
  cButtonCaption: array[boolean] of string = ('&Details >>', '<< &Details');
begin
  FShowDetails := not FShowDetails;
  Height := cDisplayHeight[FShowDetails];
  btnDetails.Caption := cButtonCaption[FShowDetails];
end;

procedure TFeedback.sbStickyClick(Sender: TObject);
begin
  Sticky := not Sticky;
end;

procedure TFeedback.lvTasksData(Sender: TObject; Item: TListItem);
const
  StatusImage: array[TTaskStatus] of integer =
    (-1, 4, 3, 1, 1, 2, 0);
  StatusCaption: array[TTaskStatus] of string =
    ('', 'Executing', 'Skipped', 'Error', 'Error', 'Canceled', 'Completed');

begin
  // Provide data for the items in the listview
  if assigned(Tasks[Item.Index]) then
    with Tasks[Item.Index], Item do
    begin

      Caption := Name;
      ImageIndex := StatusImage[Status];
      SubItems.Add(StatusCaption[Status]);

    end;
end;

procedure TFeedback.FormDestroy(Sender: TObject);
begin
  // Free the task list
  FreeAndNil(FTasks);

  // Free errors list
  FreeAndNil(FErrors);

  // Free lock
  FreeAndNil(FLock);

end;

end.
