{*************************************************************
*      Module:  Scalable Lock
*      Version: 1.02
*      Author: Amine Moulay Ramdane                
*     Company: Cyber-NT Communications           
*     
*       Email: aminer@videotron.ca   
*     Website: http://pages.videotron.com/aminer/
*        Date: March 24, 2014
*    Last update: March 24, 2014
*    
* Copyright © 2013 Amine Moulay Ramdane.All rights reserved
*
*************************************************************}

unit LW_ALock;

{$I defines.inc}

{$ifdef FPC}
{$mode delphi} 
{$endif}

{$IFDEF FPC}
{$ASMMODE intel}
{$ENDIF FPC}

interface

uses 
{$IF defined(XE)}
   cmem,
  {$IFEND}

{$IF defined(Windows32) or  defined(Windows64) }
   winapi.Windows,
  {$IFEND}
system.sysutils,system.syncobjs,system.classes;

const
  Alignment = 64; // alignment, needs to be power of 2

type


{$IFDEF CPU64}
int = int64;
Long = uint64;
{$ENDIF CPU64}
{$IFDEF CPU32}
int = integer;
Long = longword;
{$ENDIF CPU32}
myobj1=^int;

typecache  = array[0..15] of integer;
typecache1  = array[0..14] of integer;
typecache2  = array[0..13] of integer;

MyRecord = Record  
  FCount1:long;
  {$IFDEF CPU32}
  cache:typecache1;
  {$ENDIF CPU32}
  {$IFDEF CPU64}
  cache:typecache2;
  {$ENDIF CPU64}
end;

MyArray = array[0..0] of MyRecord;

MyRecord2 = Record  
  FCount2:long;
  {$IFDEF CPU32}
  cache:typecache1;
  {$ENDIF CPU32}
  {$IFDEF CPU64}
  cache:typecache2;
  {$ENDIF CPU64} 
end;

MyRecord3 = Record  
  FCount3:long;
  {$IFDEF CPU32}
  cache:typecache1;
  {$ENDIF CPU32}
  {$IFDEF CPU64}
  cache:typecache2;
  {$ENDIF CPU64}
end;

MyRecord4 = Record  
  FCount4:long;
  {$IFDEF CPU32}
  cache:typecache1;
  {$ENDIF CPU32}
  {$IFDEF CPU64}
  cache:typecache2;
  {$ENDIF CPU64}
end;


MyRecord5 = Record  
  FCount5:long;
  {$IFDEF CPU32}
  cache:typecache1;
  {$ENDIF CPU32}
  {$IFDEF CPU64}
  cache:typecache2;
  {$ENDIF CPU64}
end;

MyRecord8 = Record  
  FCount8:long;
  {$IFDEF CPU32}
  cache:typecache1;
  {$ENDIF CPU32}
  {$IFDEF CPU64}
  cache:typecache2;
  {$ENDIF CPU64}
end;

MyRecord9 = Record  
  FCount9:long;
  {$IFDEF CPU32}
  cache:typecache1;
  {$ENDIF CPU32}
  {$IFDEF CPU64}
  cache:typecache2;
  {$ENDIF CPU64}
end;

PMyRecord1 = ^MyArray;
PMyRecord2 = ^MyRecord2;
PMyRecord3 = ^MyRecord3;
PMyRecord4 = ^MyRecord4;
PMyRecord5 = ^MyRecord5;
PMyRecord8 = ^MyRecord8;
PMyRecord9 = ^MyRecord9;

TALOCK = class
  private
Buffer1: pointer;
Buffer2: pointer;
Buffer3: pointer;
Buffer4: pointer;
Buffer5: pointer;
Buffer8: pointer;
Buffer9: pointer;
FCount1:PMyRecord1;
FCount2: PMyRecord2;
FCount3: PMyRecord3;
FCount4: PMyRecord4;
FCount5: PMyRecord5;
FCount8: PMyRecord8;
FCount9: PMyRecord9;


{$IF defined(Windows32) or  defined(Windows64) }
  FFileMapping1,FFileMapping2,FFileMapping3, FFileMapping4,FFileMapping5,FFileMapping8,FFileMapping9: THandle;
{$ELSE}
{$IFEND}

Fsize:long;

function GetUProcess: Boolean;

public
     constructor Create(const Name: string='';const size:long=1024);
    destructor  Destroy; override;
  
    procedure Enter; 
    procedure Leave; 
    
  end; { TMREW }

implementation

procedure mfence;assembler;
asm 
 mfence
end;
        
function GetCurrentProcessorNumber:long;assembler;
asm
{$IFDEF CPU32}
   push ebx
   mov eax, 1
   CPUID
   shr ebx, 24
   mov eax, ebx
  pop ebx
 {$ENDIF CPU32}
{$IFDEF CPU64}
   push rbx
    mov rax, 1
   cpuid
   shr rbx, 24
   mov rax, rbx
   pop rbx
  {$ENDIF CPU64}
end;

function LockedIncInt(var Target: long):long;
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

function LockedDecInt(var Target: long): long;
asm
        {$IFDEF CPU32}
        // --> EAX Target
        // <-- EAX Result
        MOV     ECX, EAX
        MOV     EAX, -1
        LOCK XADD [ECX], EAX
        dec     EAX
        {$ENDIF CPU32}
        {$IFDEF CPU64}
        // --> RCX Target
        // <-- EAX Result
        MOV     RAX, -1
        LOCK XADD [RCX], RAX
        dec     RAX
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
function LockedCompareExchange(CompareVal, NewVal: long; var Target: long): long; overload;
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


constructor TALOCK.Create(const Name: string='';const size: long=1024);

var i:integer;
begin

If size=0 
 then
  begin
   writeln('Constructor''s size parameter must be greater than 0...');
   halt;
  end;

FSize := size;

{$IF defined(threads)}

      Buffer1 := AllocMem((fSize*SizeOf(MyRecord)) + Alignment); // 64 byte alignment.
     

       FCount1 := PMyRecord1((int(Buffer1) + Alignment -1) and not (Alignment -1));  
      
 
Buffer2 := AllocMem(SizeOf(MyRecord2) + Alignment);
FCount2 := PMyRecord2((int(Buffer2) + Alignment - 1)
                           and not (Alignment - 1));  

Buffer3 := AllocMem(SizeOf(MyRecord3) + Alignment);
FCount3 := PMyRecord3((int(Buffer3) + Alignment - 1)
                           and not (Alignment - 1));  

Buffer4 := AllocMem(SizeOf(MyRecord4) + Alignment);
FCount4 := PMyRecord4((int(Buffer4) + Alignment - 1)
                           and not (Alignment - 1));  


Buffer5 := AllocMem(SizeOf(MyRecord5) + Alignment);
FCount5 := PMyRecord5((int(Buffer5) + Alignment - 1)
                           and not (Alignment - 1));  

Buffer8 := AllocMem(SizeOf(MyRecord8) + Alignment);
FCount8 := PMyRecord8((int(Buffer8) + Alignment - 1)
                           and not (Alignment - 1)); 
						 
					   
   FCount1^[0].FCount1:=0;
   FCount2^.FCount2:=0;
   FCount3^.fcount3:=0;   
   FCount4^.FCount4:=0; // count
   FCount8^.fcount8:=size;  

{$ELSE}

if Name = '' then
  begin
FFileMapping1 := 0;FFileMapping2 := 0;FFileMapping3 := 0;
    FFileMapping4 := 0;FFileMapping5 := 0;FFileMapping8 := 0;FFileMapping9 := 0;

   Buffer1 := AllocMem((fSize*SizeOf(MyRecord)) + Alignment); // 64 byte alignment.
     

       FCount1 := PMyRecord1((int(Buffer1) + Alignment -1) and not (Alignment -1));  
      
 
Buffer2 := AllocMem(SizeOf(MyRecord2) + Alignment);
FCount2 := PMyRecord2((int(Buffer2) + Alignment - 1)
                           and not (Alignment - 1));  

Buffer3 := AllocMem(SizeOf(MyRecord3) + Alignment);
FCount3 := PMyRecord3((int(Buffer3) + Alignment - 1)
                           and not (Alignment - 1));  

Buffer4 := AllocMem(SizeOf(MyRecord4) + Alignment);
FCount4 := PMyRecord4((int(Buffer4) + Alignment - 1)
                           and not (Alignment - 1));  


Buffer5 := AllocMem(SizeOf(MyRecord5) + Alignment);
FCount5 := PMyRecord5((int(Buffer5) + Alignment - 1)
                           and not (Alignment - 1));  

Buffer8 := AllocMem(SizeOf(MyRecord8) + Alignment);
FCount8 := PMyRecord8((int(Buffer8) + Alignment - 1)
                           and not (Alignment - 1));  

		   
  FCount1^[0].FCount1:=0;
   FCount2^.FCount2:=0;
   FCount3^.fcount3:=0;   
   FCount4^.FCount4:=0; 
   FCount8^.fcount8:=size;  

end
else 
 begin
  FFileMapping1 := winapi.Windows.CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE,
      0, (fSize*SizeOf(MyRecord)) + Alignment, PChar('TALOCK_MMF1_' + Name));
    Assert(FFileMapping1 <> 0);
    Buffer1 := winapi.Windows.MapViewOfFile(FFileMapping1, FILE_MAP_WRITE, 0, 0, 0);
    Assert(Buffer1 <> nil);
   
FCount1 := PMyRecord1((int(Buffer1) + Alignment - 1)
                           and not (Alignment - 1));  


FFileMapping2 := winapi.Windows.CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE,
      0, SizeOf(MyRecord2)+ Alignment, PChar('TALOCK_MMF2_' + Name));
   Assert(FFileMapping2 <> 0);
    Buffer2 := winapi.Windows.MapViewOfFile(FFileMapping2, FILE_MAP_WRITE, 0, 0, 0);
    Assert(Buffer2 <> nil);
 
 FCount2 := PMyRecord2((int(Buffer2) + Alignment - 1)
                           and not (Alignment - 1));  



FFileMapping3 := winapi.Windows.CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE,
      0, SizeOf(MyRecord3)+ Alignment, PChar('TALOCK_MMF3_' + Name));
   Assert(FFileMapping3 <> 0);
    Buffer3 := winapi.Windows.MapViewOfFile(FFileMapping3, FILE_MAP_WRITE, 0, 0, 0);
    Assert(Buffer3 <> nil);
 
 FCount3 := PMyRecord3((int(Buffer3) + Alignment - 1)
                           and not (Alignment - 1));  


FFileMapping4 := winapi.Windows.CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE,
      0, SizeOf(MyRecord4)+ Alignment, PChar('TALOCK_MMF4_' + Name));
   Assert(FFileMapping4 <> 0);
    Buffer4 := winapi.Windows.MapViewOfFile(FFileMapping4, FILE_MAP_WRITE, 0, 0, 0);
    Assert(Buffer4 <> nil);
 
 FCount4 := PMyRecord4((int(Buffer4) + Alignment - 1)
                           and not (Alignment - 1));  



FFileMapping5 := winapi.Windows.CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE,
      0, SizeOf(MyRecord5)+ Alignment, PChar('TALOCK_MMF5_' + Name));
   Assert(FFileMapping5 <> 0);
    Buffer5 := winapi.Windows.MapViewOfFile(FFileMapping5, FILE_MAP_WRITE, 0, 0, 0);
    Assert(Buffer5 <> nil);
 
 FCount5 := PMyRecord5((int(Buffer5) + Alignment - 1)
                           and not (Alignment - 1));  


FFileMapping8 := winapi.Windows.CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE,
      0, SizeOf(MyRecord8)+ Alignment, PChar('TALOCK_MMF8_' + Name));
   Assert(FFileMapping8 <> 0);
    Buffer8 := winapi.Windows.MapViewOfFile(FFileMapping8, FILE_MAP_WRITE, 0, 0, 0);
    Assert(Buffer8 <> nil);
 
 FCount8 := PMyRecord8((int(Buffer8) + Alignment - 1)
                           and not (Alignment - 1));  

FFileMapping9 := winapi.Windows.CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE,
      0, SizeOf(MyRecord9)+ Alignment, PChar('TALOCK_MMF9_' + Name));
   Assert(FFileMapping9 <> 0);
    Buffer9 := winapi.Windows.MapViewOfFile(FFileMapping9, FILE_MAP_WRITE, 0, 0, 0);
    Assert(Buffer9 <> nil);
 
 FCount9 := PMyRecord9((int(Buffer9) + Alignment - 1)
                           and not (Alignment - 1));  
				   
if CAS(FCount5^.fcount5,0,1)
 then 
  begin
   FCount1^[0].FCount1:=0;
   FCount2^.FCount2:=0;
   FCount3^.fcount3:=0;
   FCount4^.FCount4:=0; // count
   FCount8^.fcount8:=size;  
   FCount9^.fcount9:=1;
  end
 else 
  begin
   repeat
   until FCount9^.fcount9=1;
  end;

end;
{$IFEND}

end;

function TALock.GetUProcess: Boolean;
begin
{$IF defined(threads)}
    result:=true;
{$ELSE}
  Result := ((FFileMapping1 = 0) and (FFileMapping2 = 0) and (FFileMapping3 = 0) and (FFileMapping4 = 0) and (FFileMapping5 = 0)
  and (FFileMapping8 = 0) and (FFileMapping9 = 0));

{$IFEND}

end;


destructor TALock.Destroy;
begin

{$IF defined(threads)}
FreeMem(Buffer1);
FreeMem(Buffer2);
FreeMem(Buffer3);
FreeMem(Buffer4);
FreeMem(Buffer5);
FreeMem(Buffer8);

{$ELSE}
if GetUProcess then
   begin
    FreeMem(Buffer1);
    FreeMem(Buffer2);
    FreeMem(Buffer3);
    FreeMem(Buffer4);
    FreeMem(Buffer5);
    FreeMem(Buffer8);
  end
  else
  begin
    winapi.Windows.UnmapViewOfFile(Buffer1);
    winapi.Windows.CloseHandle(FFileMapping1);
    winapi.Windows.UnmapViewOfFile(Buffer2);
    winapi.Windows.CloseHandle(FFileMapping2);
    winapi.Windows.UnmapViewOfFile(Buffer3);
    winapi.Windows.CloseHandle(FFileMapping3);
    winapi.Windows.UnmapViewOfFile(Buffer4);
    winapi.Windows.CloseHandle(FFileMapping4);
    winapi.Windows.UnmapViewOfFile(Buffer5);
    winapi.Windows.CloseHandle(FFileMapping5);
    winapi.Windows.UnmapViewOfFile(Buffer8);
    winapi.Windows.CloseHandle(FFileMapping8);
    winapi.Windows.UnmapViewOfFile(Buffer9);
    winapi.Windows.CloseHandle(FFileMapping9);
  end;

{$IFEND}

  inherited Destroy;

end;

//==============================================================================

procedure pause1;assembler;
asm pause end;



procedure TALOCK.Enter;

var  slot:long;
     k:integer;
begin


repeat
slot:=LockedIncInt(fcount2^.fcount2);
if slot<high(long) then break
until false;  

while Fcount1^[(slot-1) mod  FCount8^.fcount8].fcount1<>(slot-1) 
do 
begin
{$IFDEF FPC}
ThreadSwitch;
{$ENDIF}
{$IFDEF XE}
System.Classes.TThread.Yield;
{$ENDIF}
end;
end;
//==============================================================================

procedure TALOCK.Leave;

begin
mfence;
FCount1^[fcount3^.fcount3 mod  FCount8^.fcount8].FCount1 := high(long);

repeat 
inc(fcount3^.fcount3);
if fcount3^.fcount3<high(long) then break
until false;

FCount1^[fcount3^.fcount3  mod  FCount8^.fcount8].FCount1 := fcount3^.fcount3  ;
end;
end.


