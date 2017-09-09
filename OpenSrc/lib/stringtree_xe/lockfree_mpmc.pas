{****************************************************************************
*                                                                           *
*                          Lockfree fifo queue                              *
*                                                                           *
*                                                                           *
* Language:             FPC Pascal v2.2.0+ / Delphi 6+                      *
*                                                                           *
* Required switches:    none                                                *
*                                                                           *
* Authors:  Dariusz Mazur                                                   *
*              and                                                          *
*          modified and enhanced by Amine Moulay Ramdane                    *                            
*                                                                           *   
*                                                                           * 
* Date:                 june 30, 2009                                       *
*                                                                           *
* Last update:          october 1,2012                                      *
*                                                                           *
* Version:              1.2                                                 *
* Licence:              MPL or GPL                                          *
*                                                                           *
*        Send bug reports and feedback to  darekm @@ emadar @@ com          *
*   You can always get the latest version/revision of this package from     *
*                                                                           *
*           http://www.emadar.com/fpc/lockfree.htm                          *
*           http://pages.videotron.com/aminer/                              *
*                                                                           *
* Description:  Lock-free algorithm to handle queue FIFO                    *
*               Has two implementation queue based on circular array        *
*               proposed by Dariusz Mazur                                   *
                and modified and enhanced by Amine Moulay Ramdane           *
*               use only single CAS                                         *
*               Lockfree_MPMC: for queue of tObject (pointer)               *
*                                                                           *
*  This program is distributed in the hope that it will be useful,          *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
*                                                                           *
*                                                                           *
*****************************************************************************
*                      BEGIN LICENSE BLOCK                                  *

The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: flqueue.pas, released 20.01.2008.
The Initial Developer of the Original Code is Dariusz Mazur


Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

*                     END LICENSE BLOCK                                     * }

{ changelog
v.0.06 27.01.2008 change implementation of circural array (bug find by Martin Friebe 
v.0.07 june 30.2009 changed and redesigned implementation by Amine Moulay Ramdane
                    and now it avoids false sharing. 
v.0.08 april 21.2010 added a sleep(0) in the repeat loop inside the push() method
                     to avoid blocking/hanging the threads...              
v.0.9  corrected a problem with getlength()   
//v 1.01 added an sfence, cause LOCK may not synchronize non-temporal stores and WC-memory,
//       and the performance is the same.   
v 1.1 I have added an exponential backoff in the push and the pop side this is efficient especially 
       in under contention.   

}


unit Lockfree_MPMC;

{$IFDEF FPC}
{$ASMMODE intel}
{$ENDIF}


interface

uses
expbackoff,
{$IFDEF XE}system.sysutils;system.classes;{$ENDIF}
{$IFDEF FPC}sysutils;{$ENDIF}

{$I defines.inc}

const margin=1000; // limited to 1000 threads...

type
{$IFDEF CPU64}
long = qword;
{$ENDIF CPU64}
{$IFDEF CPU32}
long = longword;
{$ENDIF CPU32}


  tNodeQueue = tObject;
  typecache1  = array[0..15] of longword;

 // TLockfree_MPMC = class(TFreelist)
  TLockfree_MPMC = class
  private
      tail:long;
      tmp1:typecache1;
      head: long;
      fMask : long;
      fSize : long;
      temp:long;
      backoff1,backoff2:texpbackoff;
      tab : array of tNodeQueue; 
      procedure setobject(lp : long;const aobject : tNodeQueue);
      function getLength:long;
      function getSize:long;
      function getObject(lp : long):tNodeQueue;
  public
     {$IFDEF CPU64}
     constructor create(aPower : int64 =20);  {allocate tab with size equal 2^aPower, for 20 size is equal 1048576}
     {$ENDIF CPU64}  
     {$IFDEF CPU32}
     constructor create(aPower : integer =20);  {allocate tab with size equal 2^aPower, for 20 size is equal 1048576}
     {$ENDIF CPU32}

      
      destructor Destroy; override;
      function push(tm : tNodeQueue):boolean; 
      function pop(var obj:tNodeQueue):boolean;
      property length : long read getLength;
      property count: long read getLength;
      property size : long read getSize;

  end;


implementation

//function SwitchToThread: BOOL; stdcall; external kernel32 name 'SwitchToThread';


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


{function CAS(var Target: long; Comperand: long;NewValue: long ): boolean; assembler;stdcall;
asm
        mov    ecx,Target
        mov    edx,NewValue
        mov    eax,Comperand
       //sfence
       lock        cmpxchg   [ecx],edx
       JNZ @@2
       MOV AL,01
       JMP @@Exit
       @@2:
       XOR AL,AL
       @@Exit:
end;}
{$IFDEF CPU64}
constructor TLockfree_MPMC.create(aPower : int64 );
{$ENDIF CPU64}
{$IFDEF CPU32}
constructor TLockfree_MPMC.create(aPower : integer );
{$ENDIF CPU32}


begin
  if aPower < 10 
    then 
     begin
      writeln('Constructor argument must be greater or equal to 10');
       halt;
     end;  
 if (aPower < 0) or (aPower > high(integer)) 
    then 
     begin
      writeln('Constructor argument is incorrect');
       halt;
     end;  
  
{$IFDEF CPU64}
fMask:=not($FFFFFFFFFFFFFFFF shl aPower);{$ENDIF CPU64}
{$IFDEF CPU32}
fMask:=not($FFFFFFFF shl aPower);
{$ENDIF CPU32}
  
  fSize:=(1 shl aPower) - margin;
  setLength(tab,1 shl aPower);
  tail:=0;
  head:=0;
  temp:=0;
 
end;

destructor  TLockfree_MPMC.Destroy;

begin
   setLength(tab,0);
   inherited Destroy;
end;


procedure TLockfree_MPMC.setObject(lp : long;const aobject : tNodeQueue);
begin
  tab[lp and fMask]:=aObject;
end;

function TLockfree_MPMC.getObject(lp : long):tNodeQueue;
begin
  result:=tab[lp and fMask];
end;


function TLockfree_MPMC.push(tm : tNodeQueue):boolean;
var lasttail,newtemp:long;
i,j:integer;
begin

 if getlength >= fsize 
  then 
      begin
          result:=false;
          exit;
      end; 
result:=true;

newTemp:=LockedIncLong(temp);

lastTail:=newTemp-1;
//asm mfence end;
setObject(lastTail,tm);

repeat

 if CAS(tail,lasttail,newtemp) 
   then 
      begin
       exit; 
      end;
{$IFDEF FPC}
ThreadSwitch;
{$ENDIF}
{$IFDEF XE}
System.Classes.TThread.Yield;
{$ENDIF}
 until false;

end;


function TLockfree_MPMC.pop(var obj:tNodeQueue):boolean;

var lastHead : long;
begin
  repeat
  lastHead:=head;
  if tail<>head
   then
    begin
      obj:=getObject(lastHead);
   
          if CAS(head,lasthead,lasthead+1)  
          then 
           begin
            result:=true;
           exit;
           end
          else  
{$IFDEF FPC}
ThreadSwitch;
{$ENDIF}
{$IFDEF XE}
System.Classes.TThread.Yield;
{$ENDIF}

     end 
   else 
       begin
        result:=false;
        exit;
       end;
  until false;
end;

function TLockfree_MPMC.getLength:long;
var head1,tail1:long;
begin
head1:=head;
tail1:=tail;
  if tail1 < head1
       then result:= (High(long)-head1)+(1+tail1)
       else result:=(tail1-head1);
end;

function TLockfree_MPMC.getSize:long;

begin
  result:=fSize;
end;

end.

