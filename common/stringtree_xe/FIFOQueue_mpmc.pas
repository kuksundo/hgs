{****************************************************************************
*                                                                           *
*                          Concurent FIFO Queue                                  *
*
* Language:             FPC Pascal v2.2.0+ / Delphi 5+                      *
* Authors:  Amine Moulay Ramdane                                            *
* Date:                 October 14, 2013                                    
* Last update:          October 14, 2013                                    *
* Version:              1.0                                                 *
*
*        Send bug reports and feedback to  aminer @@ videotron @@ ca        *
*   You can always get the latest version/revision of this package from     *
*                                                                           *
*           http://pages.videotron.com/aminer/                              *
*                                                                           
*  This program is distributed in the hope that it will be useful,          *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
*                                                                           *
*****************************************************************************
}

{ changelog
v.1.0    
}


unit FIFOQueue_mpmc;


interface
{$IFDEF FPC}
{$ASMMODE intel}
{$ENDIF}


uses
LW_ALock,system.syncobjs,system.sysutils,system.classes;

{$I defines.inc}

const INFINITE = longword($FFFFFFFF);

type

{$IFDEF CPU64}
long = uint64;
{$ENDIF CPU64}
{$IFDEF CPU32}
long = longword;
{$ENDIF CPU32}

 
  tNodeQueue = tObject;
  typecache1  = array[0..15] of longword;

 // TLockfree_MPMC = class(TFreelist)
  TFIFOQUEUE_MPMC = class
  private
      tail:long;
      tmp1:typecache1;
      head: long;
      tmp2:typecache1;
      count1:long;
      tmp3:typecache1;
      fMask : long;
      fSize : long;
      fWait : boolean;

      tab : array of tNodeQueue; 
      lock1,lock2,lock3:TALOCK;
      event:TSimpleEvent;
       procedure setobject(lp : long;const aobject : tNodeQueue);
      function getLength:long;
      function getSize:long;
      function getObject(lp : long):tNodeQueue;
  public
      constructor create(aPower : long =20;wait:boolean=true;size:long=1024;fast:boolean=false);  {allocate tab with size equal 2^aPower, for 20 size is equal 1048576}
      destructor Destroy; override;
      function push(tm : tNodeQueue):boolean; 
      function pop(var obj:tNodeQueue):boolean;
      property length : long read getLength;
      property count: long read getLength;
      property size : long read getSize;

  end;


implementation

{$IF defined(CPU64) }
function LockedCompareExchange(CompareVal, NewVal: long; var Target: long): long; overload;
asm
mov rax, rcx
lock cmpxchg [r8], rdx
end;
{$IFEND}
{$IF defined(CPU32) }
function LockedCompareExchange(CompareVal, NewVal: long; var Target:long): long; overload;
asm
lock cmpxchg [ecx], edx
end;
{$IFEND}


function CAS(var Target:long;Comp ,Exch : long): boolean;
var ret:long;
begin

ret:=LockedCompareExchange(Comp,Exch,Target);
if ret=comp
 then result:=true
 else result:=false;  

end; { CAS }



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

function LockedDecLong(var Target: long): long;
asm
        {$IFDEF CPU32}
        // --> EAX Target
        // <-- EAX Result
        MOV     ECX, EAX
        MOV     EAX, -1
        //sfence
       LOCK XADD [ECX], EAX
        dec     eax
        {$ENDIF CPU32}
        {$IFDEF CPU64}
        // --> RCX Target
        // <-- EAX Result
        MOV     rax, -1
        //sfence
        LOCK XADD [rcx], rax
        dec     rax
        {$ENDIF CPU64}
end;

constructor TFIFOQUEUE_MPMC.create(aPower : long=20; wait:boolean=true;size:long=1024;fast:boolean=false);
begin
  if (aPower < 0) or (aPower > high(long)) 
    then 
     begin
      writeln('Constructor''s argument incorrect');
       halt;
     end;  
 
{$IFDEF CPU64}
fMask:=not($FFFFFFFFFFFFFFFF shl aPower);
{$ENDIF CPU64}
{$IFDEF CPU32}
fMask:=not($FFFFFFFF shl aPower);
{$ENDIF CPU32}
  fWait:=wait;
  fSize:=(1 shl aPower);
  setLength(tab,1 shl aPower);
  tail:=0;
  head:=0;
  lock1:=TALOCK.create('',size);
  lock2:=TALOCK.create('',size);
  lock3:=TALOCK.create('',size);
  event:=TSimpleEvent.create;
  count1:=0;
 
end;

destructor  TFIFOQUEUE_MPMC.Destroy;

begin
 lock1.free;
 lock2.free;
 lock3.free; 
 event.free;
 setLength(tab,0);
 inherited Destroy;
end;


procedure TFIFOQUEUE_MPMC.setObject(lp : long;const aobject : tNodeQueue);
begin
  tab[lp and fMask]:=aObject;
end;

function TFIFOQUEUE_MPMC.getObject(lp : long):tNodeQueue;
begin
  result:=tab[lp and fMask];
end;


function TFIFOQUEUE_MPMC.push(tm : tNodeQueue):boolean;//stdcall;
begin

result:=true;
lock1.enter;

if getlength >= fsize 
  then 
      begin
       while getlength >= fsize 
         do 
{$IFDEF FPC}
ThreadSwitch;
{$ENDIF}
{$IFDEF XE}
System.Classes.TThread.Yield;
{$ENDIF}
       //   result:=false;
       //  lock1.leave;
       //  exit;
      end; 

    setObject(tail,tm);
    tail:=(tail+1);
  if fWait 
  then
   begin  
    lock3.enter;
    inc(count1);
    if count1=1 then event.setevent;   
    lock3.leave;
   end; 
   lock1.leave;
end;


function TFIFOQUEUE_MPMC.pop(var obj:tNodeQueue):boolean;
var b:long;
   
begin

if fWait 
  then
   begin  
     if count1=0 then event.waitfor(INFINITE);
   end;

lock2.enter;

  if tail<>head
   then
    begin
     obj:=getObject(head);
     head:=(head+1);
     result:=true;
    if fWait 
     then
       begin  
        lock3.enter;
        dec(count1);
        if count1=0 then event.resetevent;
        lock3.leave;
       end;
     lock2.leave;
      exit;
    end
   else 
       begin
        result:=false;
        lock2.leave;
        
       end;
end;


function TFIFOQUEUE_MPMC.getLength:long;
var head1,tail1:long;
begin
head1:=head;
tail1:=tail;
  if tail1 < head1
       then result:= (High(long)-head1)+(1+tail1)
       else result:=(tail1-head1);
end;

function TFIFOQUEUE_MPMC.getSize:long;

begin
  result:=fSize;
end;

end.

