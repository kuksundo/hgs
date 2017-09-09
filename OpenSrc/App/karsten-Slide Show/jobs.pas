(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is jobs.pas of Karsten Bilderschau, version 3.3.4
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

{ $Id: jobs.pas 106 2007-01-21 02:39:24Z hiisi $ }

{
@abstract Classes to execute jobs in a separate thread
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2006/09/02
@cvs $Date: 2007-01-20 20:39:24 -0600 (Sa, 20 Jan 2007) $
}
unit jobs;

interface
uses
  Windows, Classes, SysUtils, Graphics, Controls, Contnrs, SyncObjs;

type
  { Indicates the status of a job }
  TJobStatus = (
    jsPending,   //< Job hasn't executed yet
    jsSuccess,   //< Job has completed successfully
    jsFail);     //< Job has failed

  { Abstract base class for a job }
  TJob = class(TPersistent)
  strict private
    FStatus: TJobStatus;
    FTicket: integer;
  protected
    procedure SetStatus(const Value: TJobStatus); virtual;
    { Executes the job. }
    procedure Execute; virtual; abstract;
  public
    { Creates an instance of a job control object.
      @param(ATicket is assigned to @link(Ticket).) }
    constructor Create(ATicket: integer);
    { A unique number issued by the creator
      so that it can identify the results.
      Note that object pointers may not be uniqe in space and time
      if objects are freed and memory gets reallocated. }
    property  Ticket: integer read FTicket write FTicket;
    { Status of the job.
      If it is jsSuccess the results are valid. }
    property  Status: TJobStatus read FStatus;
  end;

  { Message record for @link(um_JobDone) }
  TUMJobDone = packed record
    Msg: Cardinal;      //< @link(um_JobDone)
    Sender: TObject;    //< sender of the message
    JobTicket: integer; //< @link(TJob.Ticket)
    Result: Longint;    //< unused
  end;

  { @abstract Threaded job queue
    An instance of this class can be kept during the whole lifetime of the process.
    Jobs are added by calling @link(AddJob),
    and executed in a separate thread.
    The thread sends out notification messages after each job has completed.
    Results must be retrieved by calling @link(PopResult) iteratively.

    All public methods must be called from the same thread
    (usually the main thread).
    Protected and private methods are called from the thread specified
    in their description. }
  TJobThread = class(TThread)
  private
    { Pending @link(TJob) objects are added to this list by @link(AddJob),
      and removed by @link(CancelJob). }
    FJobList: TObjectList;
    { Completed @link(TJob) objects are added to this list by @link(Execute).
      The owner must retrieve them using @link(PopResult),
      and destroy them. }
    FResultList: TObjectList;
    { Synchronizes access to @link(FJobList) and @link(FResultList). }
    FSyncObj: TSynchroObject;
    { Signals that a new job has been posted
      or that Terminated has been set @true. }
    FStarter: TEvent;
    { The window where notification messages are sent to. }
    FNotifyWnd: HWND;
    function GetPendingJobs: integer;
  protected
    { This is the thread procedure.
      It calls the @link(TJob.Execute) method of each @link(TJob) object
      in the @link(FJobList).
      After all jobs have been processed,
      the thread waits for @link(FStarter) to be signalled. }
    procedure Execute; override;
  public
    { Creates the object instance and starts the thread.
      @param(ANotifyWnd specifies the window handle that will receive
        @link(um_JobDone) messages after each completed job.) }
    constructor Create(ANotifyWnd: HWND);
    { Terminates and destroys the job queue }
    destructor  Destroy; override;
    { Adds a new job to the queue.
      The job may be processed as soon as the thread gets CPU time.
      After the job has finished,
      a @link(um_JobDone) message is sent to NotifyWnd,
      and the job object with the results
      must be retrieved by calling @link(PopResult)
      and then destroyed.

      @param(AJob must be a valid and fully initialized instance of
        a @link(TJob) descendant.
        @classname takes ownership,
        and the caller must not use the job object any more
        (until it is returned by @link(PopResult).) }
    procedure AddJob(AJob: TJob);
    { Removes any jobs with the given ticket (if @code(all) = @false)
      or all jobs (if @code(all) = @true) from the job queue.
      Does not abort a job that is currently running.
      Does not remove jobs from the list of completed jobs (@link(PopResult)).

      There is no way to find out the job objects that have been cancelled.
      They do not appear in @link(PopResult)
      and they do not generate @link(um_JobDone) messages.

      @returns the number of cancelled jobs. }
    function CancelJobs(ATicket: integer; all: boolean = false): integer;
    { Number of pending jobs.
      The currently executing job is not counted. }
    property  PendingJobs: integer read GetPendingJobs;
    { Immediately start processing the jobs in the calling thread.
      This is an alternative to @link(Start) used mainly for tests and debugging.
      The method returns only when all jobs have completed,
      and no notification messages are sent.
      The results must be retrieved by calling @link(PopResult).

      This method cannot be used at the moment
      because the threaded processing will start
      immediately after creation. }
    procedure RunUnthreaded; deprecated;
    { Returns the result of the first completed job in the queue.
      May be @nil if there is none.
      You must retrieve the result of each job,
      and destroy the object returned by this method.
      Call this function repeatedly until it returns @nil. }
    function  PopResult: TJob;
  end;

implementation

uses
  Types, Math, globals;

{ TJob }

constructor TJob.Create;
begin
  inherited Create;
  FTicket := ATicket;
  FStatus := jsPending;
end;

procedure TJob.SetStatus(const Value: TJobStatus);
begin
  FStatus := Value;
end;

{ TJobThread }

constructor TJobThread.Create;
begin
  inherited Create(false);
  FNotifyWnd := ANotifyWnd;
  FJobList := TObjectList.Create(false);
  FResultList := TObjectList.Create(false);
  FSyncObj := TCriticalSection.Create;
  FStarter := TEvent.Create(nil, false, false, '', false);
  Priority := tpIdle;
end;

destructor TJobThread.Destroy;
begin
  Terminate;
  FStarter.SetEvent;
  inherited;
  if Assigned(FJobList) then FJobList.OwnsObjects := true;
  FreeAndNil(FJobList);
  if Assigned(FResultList) then FResultList.OwnsObjects := true;
  FreeAndNil(FResultList);
  FreeAndNil(FSyncObj);
  FreeAndNil(FStarter);
end;

procedure TJobThread.AddJob;
begin
  FSyncObj.Acquire;
  try
    FJobList.Add(AJob);
  finally
    FSyncObj.Release;
  end;
  FStarter.SetEvent;
end;

function TJobThread.CancelJobs;
var
  i: integer;
  Job: TJob;
begin
  result := 0;
  FSyncObj.Acquire;
  try
    for i := FJobList.Count - 1 downto 0 do begin
      Job := FJobList[i] as TJob;
      if all or (Job.Ticket = ATicket) then begin
        FJobList.Delete(i);
        Job.Free;
        Inc(result);
      end;
    end;
  finally
    FSyncObj.Release;
  end;
end;

function TJobThread.GetPendingJobs: integer;
begin
  FSyncObj.Acquire;
  try
    result := FJobList.Count;
  finally
    FSyncObj.Release;
  end;
end;

procedure TJobThread.RunUnthreaded;
var
  Job: TJob;
begin
  repeat
    FSyncObj.Acquire;
    try
      if FJobList.Count >= 1 then begin
        Job := FJobList[0] as TJob;
        FJobList.Delete(0);
      end else
        Job := nil;
    finally
      FSyncObj.Release;
    end;
    if Assigned(Job) then begin
      try
        Job.Execute;
      except
        Job.SetStatus(jsFail);
      end;
      FSyncObj.Acquire;
      try
        FResultList.Add(Job);
      finally
        FSyncObj.Release;
      end;
    end;
  until
    not Assigned(Job);
end;

procedure TJobThread.Execute;
var
  Job: TJob;
  ticket: integer;
begin
  while not Terminated do begin
    FSyncObj.Acquire;
    try
      if FJobList.Count >= 1 then begin
        Job := FJobList[0] as TJob;
        FJobList.Delete(0);
      end else
        Job := nil;
    finally
      FSyncObj.Release;
    end;
    if Assigned(Job) then begin
      try
        Job.Execute;
      except
        Job.SetStatus(jsFail);
      end;
      ticket := Job.Ticket;
      FSyncObj.Acquire;
      try
        FResultList.Add(Job);
      finally
        FSyncObj.Release;
      end;
      if FNotifyWnd > 0 then
        PostMessage(FNotifyWnd, um_JobDone, integer(Self), ticket);
    end else begin
      FStarter.WaitFor(1000);
    end;
  end;
end;

function TJobThread.PopResult: TJob;
begin
  FSyncObj.Acquire;
  try
    if FResultList.Count >= 1 then begin
      Result := FResultList[0] as TJob;
      FResultList.Delete(0);
    end else
      Result := nil;
  finally
    FSyncObj.Release;
  end;
end;

end.
