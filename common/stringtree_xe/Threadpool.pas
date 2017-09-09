
{****************************************************************************
*                                                                           *
*  Description                                                              *
*                                                                           *
* Threadpool.                                                     *
*                                                                           
*
* Please look at the examples test.pas and testpool.pas...                  * 
*                                                                           *
*                                                                           *
* Look into define.inc there is many options                                *
*                                                                           * 
* CPU32 for 32 bits architecture                                            * CPU64 for 64 bits architecture                                            
*
*                                                                           *
* Language:  FPC Pascal v2.2.0+ / Delphi 5+                                 *
*                                                                           *                 
* Operating Systems:  Win , Linux and Mac (all x86).                        *
*                                                                           *  
* Required FPC switches:  -O3  -Sd  -dFPC -dWin32 -dFreePascal              *
*                                                                           *  
* -Sd for delphi mode....                                                   *
*                                                                           *
*                                                                           *
* Required Delphi switches: -DMSWINDOWS  -$H+                               *
*                                                                           
*                                                                           *
* Date:                 July 8, 2009                                        *                                                                           
* LastUpdate:           October 17, 2013                                    *
* Version:              1.52                                                *
*                                                                           *
*                                                                           *
*                                                                           *
*        Send bug reports and feedback to  aminer@colba.net                 *
*   You can always get the latest version/revision of this package from     *
*                                                                           *
*           http://pages.videotron.com/aminer/                              *      
*                                                                           *
* Email:    aminer@videotron.ca                                             * 
*                                                                           *
*                                                                           *
*  This program is distributed in the hope that it will be useful,          *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
*                                                                           *
*                                                                           *
***************************************************************************** }





unit Threadpool;

{$IFDEF FPC}
{$ASMMODE intel}
{$ENDIF}


interface


uses

{$IFDEF XE}cmem,system.classes,{$ENDIF}
system.SysUtils,system.syncobjs,FIFOQueue_mpmc;

{$I defines.inc}

const 
LOW_PRIORITY = 0;
NORMAL_PRIORITY = 1;
HIGH_PRIORITY = 2;
INFINITE = longword($FFFFFFFF);


type

{$IFDEF CPU64}
long = uint64;
{$ENDIF CPU64}
{$IFDEF CPU32}
long = longword;
{$ENDIF CPU32}


typecache1  = array[0..15] of longword;

TMyProc=procedure (obj:pointer) of object; //stdcall; 

Params = Record
      Proc:TMyProc;
      data:pointer;
     end;   

PParams = ^Params;


  THandle = LongWord;

  TThreadPoolThread = class;
  TThreadPoolThreadClass = class of TThreadPoolThread;
 

  TThreadPool = class (TObject)
  private
    Queue:TFIFOQUEUE_MPMC;
    FThreadCount: Integer;
    FThreads: array of TThreadPoolThread;
    Events: array of TSimpleEvent;
    balance1:long;
   
  protected
  public
    constructor Create(const ThreadCount:integer; const ThreadClass: TThreadPoolThreadClass;const QueuesSize: Integer=14); //;const eventhandle:THandle);
    destructor Destroy; override;
    function Execute(func:TMyProc;const Context: Pointer): Boolean;
    procedure Suspend;//stdcall;
    procedure Resume;//stdcall;
   
  end;

  TThreadPoolThread = class (TThread)
  private
    threadcount:integer;
    FThreadPool: TThreadPool;
  protected
    procedure Execute; override;
  public
    constructor Create;overload;
	constructor Create(const ThreadPool: TThreadPool;const threadcount:integer);overload;
    procedure ProcessRequest(Context: Pointer);virtual; abstract; //stdcall;
    property ThreadPool: TThreadPool read FThreadPool;
  end;

var eventhandle:Thandle;
    exit1:boolean;
implementation

function LockedIncLong(var Target: long): long;
asm
        {$IFDEF CPU32}
        // --> EAX Target
        // <-- EAX Result
        MOV     ECX, EAX
        MOV     EAX, 1
        //sfence
       LOCK XADD [ECX], EAX
        inc     eax
        {$ENDIF CPU32}
        {$IFDEF CPU64}
        // --> RCX Target
        // <-- EAX Result
        MOV     rax, 1
        //sfence
        LOCK XADD [rcx], rax
        INC     rax
        {$ENDIF CPU64}
end;

function LockedInc(var Target: Integer): Integer;
asm
        {$IFDEF CPU32}
        // --> EAX Target
        // <-- EAX Result
        MOV     ECX, EAX
        MOV     EAX, 1
        LOCK XADD [ECX], EAX
        INC     EAX
        {$ENDIF CPU32}
        {$IFDEF CPU64}
        // --> RCX Target
        // <-- EAX Result
        MOV     EAX, 1
        LOCK XADD [RCX], EAX
        INC     EAX
        {$ENDIF CPU64}
end;

function LockedSub(var Target: Integer; Value: Integer): Integer;
asm
        {$IFDEF CPU32}
        // --> EAX Target
        //     EDX Value
        // <-- EAX Result
        MOV     ECX, EAX
        NEG     EDX
        MOV     EAX, EDX
        LOCK XADD [ECX], EAX
        ADD     EAX, EDX
        {$ENDIF CPU32}
        {$IFDEF CPU64}
        // --> RCX Target
        //     EDX Value
        // <-- EAX Result
        NEG     EDX
        MOV     EAX, EDX
        LOCK XADD [RCX], EAX
        ADD     EAX, EDX
        {$ENDIF CPU64}
end;



{ TThreadPool }


constructor TThreadPool.Create(const ThreadCount:integer;const ThreadClass: TThreadPoolThreadClass;const QueuesSize: Integer=14 );//;const eventhandle:THandle);
var
  I: Integer;
begin
  inherited Create;
  //windows.InitializeCriticalSection(FLock);
 
if ThreadCount < 1 
then 
begin
writeln('The number of cores in the constructor is incorrect...');
halt;
end;

balance1:=0;
  FThreadCount := ThreadCount;
  
  SetLength(FThreads, FThreadCount);
  exit1:=false;
 
  Queue:=TFIFOQUEUE_MPMC.create(QueuesSize,false);
 SetLength(Events, FThreadCount);
 for I := 0 to FThreadCount - 1  do Events[I] := TSimpleEvent.Create;
  for I := 0 to FThreadCount - 1  do FThreads[I] := ThreadClass.Create(Self,i);
  //repeat
  //until count1 = Fthreadcount
end;

destructor TThreadPool.Destroy;
var
  i,j: Integer;
begin
repeat 
{$IFDEF FPC}
ThreadSwitch;
{$ENDIF}
{$IFDEF XE}
System.Classes.TThread.Yield;
{$ENDIF}
until Queue.length = 0;

  for i := 0 to FThreadCount - 1 
         do
          begin
           FThreads[I].Terminate;
           exit1:=true;
           Events[i].setevent;
           FThreads[I].WaitFor;
           FThreads[I].Free;
           Events[i].free;

          end;
Queue.Free;
SetLength(Events, 0);
SetLength(FThreads, 0);


inherited Destroy;
end;

function TThreadPool.execute(func:TmyProc;const Context: Pointer): Boolean; 

var
params:PParams;
local_balance:long;
begin

new(params);
params^.proc:=func;
params^.data:=context;

local_balance:=LockedIncLong(balance1) mod FThreadCount;

while not Queue.push(tobject(params))  
do 
{$IFDEF FPC}
ThreadSwitch;
{$ENDIF}
{$IFDEF XE}
System.Classes.TThread.Yield;
{$ENDIF}

events[local_balance].setevent;

end;

procedure TThreadPool.Resume;
var
  I: Integer;
begin
   for I := 0 to FThreadCount - 1 do FThreads[I].Suspended:=false;
  
end;

procedure TThreadPool.Suspend;
var
  I: Integer;
begin

  for I := 0 to FThreadCount - 1 do FThreads[I].Suspended:=true;
  
end;

{ TThreadPoolThread }

constructor TThreadPoolThread.Create;//;const eventhandle:THandle);

begin
  inherited Create(true);
end;

constructor TThreadPoolThread.Create(const ThreadPool: TThreadPool;const threadcount:integer);
begin
   inherited Create(true);
    self.threadcount:=threadcount;
   FThreadPool := ThreadPool;
  Resume;
 
end;



procedure TThreadPoolThread.Execute;
var
   Context: Tobject;
   rec1:PParams;
   bool3,bool4:boolean;

 begin
bool4:=false;
while ((not Terminated) or (bool4=true)) do
 begin
bool3:=false;
if bool4=false then bool3:=FThreadPool.Queue.pop(context); 
if bool3 or bool4
then
begin 
           rec1:=PParams(context);
            rec1^.proc(rec1^.data);
            dispose(rec1);
			
end;

bool4:=FThreadPool.Queue.pop(context); 
if bool4 
then
begin
{$IFDEF FPC}
ThreadSwitch;
{$ENDIF}
{$IFDEF XE}
System.Classes.TThread.Yield;
{$ENDIF}
 continue;
end;

if ((bool4=false) and (exit1=false)) then 
          begin
                   FThreadpool.events[self.threadcount].waitfor(INFINITE);
                     FThreadpool.events[self.threadcount].resetevent;
           end;

{$IFDEF FPC}
ThreadSwitch;
{$ENDIF}
{$IFDEF XE}
System.Classes.TThread.Yield;
{$ENDIF}
 end;                        
 end;  
 end.
