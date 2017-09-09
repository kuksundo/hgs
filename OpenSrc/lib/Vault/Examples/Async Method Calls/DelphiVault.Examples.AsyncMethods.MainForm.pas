// Written with Delphi XE3 Pro
// Created Nov 24, 2012 by Darian Miller
//
// Example for DelphiVault.Threading.AsyncMethods
//
// [Example1] Execute a method within a background thread in one line of code
// [Example2] Execute a method within a background thread in one line of code
//            and specify a callback routine to be executed when the task is completed.
unit DelphiVault.Examples.AsyncMethods.MainForm;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Controls, Vcl.ExtCtrls;

type
  TfrmAsyncExample = class(TForm)
    butExample1: TButton;
    memTaskStatus1: TMemo;
    memTaskStatus2: TMemo;
    butExample2: TButton;
    labClickMultiple: TLabel;
    labThreadPayload: TLabel;
    edtPayload: TEdit;
    chkAutoGen: TCheckBox;
    labAndreas: TLabel;
    labPrimoz: TLabel;
    linkAsyncCalls: TLinkLabel;
    linkOTL: TLinkLabel;
    procedure butExample1Click(Sender: TObject);
    procedure butExample2Click(Sender: TObject);
    procedure chkAutoGenClick(Sender: TObject);
    procedure LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    procedure MyBackgroundTask1(const ThreadPayload:String);

    procedure MyBackgroundTask2(const ThreadPayload:String);
    procedure MyTaskFinishedProc2(const ThreadPayload:String);

    procedure LogTask1(const LogEntry:String);
    procedure LogTask2(const LogEntry:String);
    function GetPayload:String;
  end;

var
  frmAsyncExample: TfrmAsyncExample;

implementation
uses
  Winapi.Windows,
  Winapi.ShellApi,
  DelphiVault.Threading.AsyncMethods;

{$R *.dfm}


//[Example1] Execute a method within a background thread in one line of code
procedure TfrmAsyncExample.butExample1Click(Sender: TObject);
begin
  LogTask1('Firing off threaded Task1...');
  TAsyncMethod.Execute(MyBackgroundTask1);
  //main thread continues while background thread is working
end;
//[Example1] Method to be called within a background thread
procedure TfrmAsyncExample.MyBackgroundTask1(const ThreadPayload:String);
begin
  //Note: should not interact with GUI elements within the background task thread...
  //LogTask1('Processing ' + ThreadPayload);
  sleep(1000); //emulate some work...no feedback when done
end;



//[Example2] Execute a method within a background thread in one line of code
//and specify a callback routine to be executed when the task is finished.
procedure TfrmAsyncExample.butExample2Click(Sender: TObject);
begin
  LogTask2('Firing off threaded Task2...');
  TAsyncMethod.Execute(MyBackgroundTask2, GetPayload, MyTaskFinishedProc2, True);
end;
//[Example2] Method to be called within a background thread
procedure TfrmAsyncExample.MyBackgroundTask2(const ThreadPayload:String);
begin
  //Note: should not interact with GUI elements within the background task thread...
  //LogTask2('Processing ' + ThreadPayload);
  sleep(Random(3000)); //emulate some work
end;
//[Example2] Method to be called when background thread is completed
procedure TfrmAsyncExample.MyTaskFinishedProc2(const ThreadPayload:String);
begin
  //Since we passed a True to SyncOnTerminate param of Execute, this call
  //will be safely Synchronized within the main application thread and we can
  //update GUI elements.
  LogTask2('Task2 [' + ThreadPayload + '] finished.')
end;


//Payload is blank by default, but can be used for unique task id,
//to pass in a serialized object, or whatever is needed to either perform the
//task and/or to be provided by the callback.
function TfrmAsyncExample.GetPayload():String;
begin
  if chkAutoGen.Checked then
  begin
    edtPayload.Text := TGuid.NewGuid.ToString;
  end;
  Result := edtPayload.Text;
end;
procedure TfrmAsyncExample.chkAutoGenClick(Sender: TObject);
begin
  edtPayload.Enabled := not chkAutoGen.Checked;
end;


procedure TfrmAsyncExample.LogTask1(const LogEntry:String);
begin
  memTaskStatus1.Lines.Add(IntToStr(GetCurrentThreadID) + ' ' + LogEntry);
end;
procedure TfrmAsyncExample.LogTask2(const LogEntry:String);
begin
  memTaskStatus2.Lines.Add(IntToStr(GetCurrentThreadID) + ' ' + LogEntry);
end;

procedure TfrmAsyncExample.LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(0, 'Open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;

end.
