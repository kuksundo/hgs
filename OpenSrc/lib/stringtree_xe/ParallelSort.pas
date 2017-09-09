
{*************************************************************
*      Parallel Sort Library 
*      Version: 3.32 
*      Author: Amine Moulay Ramdane                
*     Company: Cyber-NT Communications           
*      
*       Email: aminer@videotron.ca   
*     Website: http://pages.videotron.com/aminer/
*        Date: April 9,2010                                            
* Last update: February 11,2015                                 
*
* Copyright © 2009 Amine Moulay Ramdane.All rights reserved
*
*************************************************************}
{****************************************************************************
*                                                                           *
*  Description                                                              *
*                                                                           *
* Parallel Sort Library that supports Parallel Quicksort,                   *
* Parallel HeapSort and Parallel MergeSort on Multicores systems.           *
*                                                                           *
* Parallel Sort Library uses my Thread Pool Engine and sort                 *
* many array parts - of your array -  in parallel using Quicksort or        *
* HeapSort or MergeSort,  and after that it finally merge them              *
* - with the parallelmerge() procedure -                                    *
*                                                                           *
* In the previous parallelsort version i have parallelized only the         *
* sort part, but in this new parallelsort version i have parallelized       *
* also the merge procedure part and it gives better performance.            *
*                                                                           *
* I have implemented a Parallel hybrid divide-and-conquer merge algorithm   *
* that performs 0.9-5.8 times better than sequential merge, on a quad-core  *
* processor, with larger arrays outperforming by over 5 times. Parallel     *
* processing combined with a hybrid algorithm approach provides a powerful  *
* high performance result                                                   *
*                                                                           *
* And please look at test.pas, a parallel quicksort on many cores           *
*  - compile and execute it...                                              *
*                                                                           *
* Language:  FPC Pascal v2.2.0+ / Delphi 7+                                 *
*                                                                           *                 
* Operating Systems:  Win , Linux and Mac (all x86).                        *
*                                                                           *  
* Required FPC switches:  -O3  -Sd  -dFPC -dWin32 -dFreePascal              *
*                                                                           *  
* -Sd for delphi mode....                                                   * 
*                                                                           *
* -dUnix for Linux,MacOSX etc.                                              *                            
*                                                                           *
* Required Delphi switches: -DMSWINDOWS  -$H+                               *
*                                                                           *
* For Delphi 5,6,7 use -DDelphi                                             *
*                                                                           *
* For Delphi 2005,2006,2007,2009,2010+ use the switch -DDELPHI2005+         *
*                                                                           *
*                                                                           * 
*                                                                           *
* Date:                 April 9,2010                                        *  
* Lastupdate:          October 31,2012                                      *
* Version:              3.04                                                *
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



Unit ParallelSort;

{$IFDEF FPC}
{$ASMMODE intel}
{$ENDIF}

interface

uses
{$IFDEF XE}
cmem,
{$ENDIF}

Threadpool,system.sysutils,system.syncobjs,system.classes,system.math;

{$I defines.inc}

type

{$IFDEF CPU64}
long = int64;
{$ENDIF CPU64}
{$IFDEF CPU32}
long = integer;
{$ENDIF CPU32}

TTypeSort = (
    ctQuicksort,
    ctHeapSort,
    ctMergeSort
  );

 TParams = class
public
a,b: long;
end;
 
TArrayParams = array of TParams; 

TSortCompare = function (Item1, Item2: Pointer): Integer;

TTabPointer = array of pointer;
TTab = array[0..0] of pointer;

TJob = class
public
A: TTabpointer;
iLo, iHi,count:long;
event:tsimpleevent;
 end;

TJob1 = class
public
A1,A2: TTabpointer;
LOW,Mid,Hi,count: long;
event:tsimpleevent;
comp:TSortCompare;
end;

TJob2 = class
public
T: TTabpointer;
p1, r1,p2, r2: long;
A: TTabpointer;
value,value1:pointer;
p3:long;
event:tsimpleevent;
comp:TSortCompare;
end;




TMyThread = class (TThreadPoolThread)
   
    //procedure Sort(obj: Pointer);
    // procedure QuickSortStr(obj: Pointer);

    end;

TParallelSort = class
  private
  crit:tcriticalsection;
  // myobj:TMyThread;
  TP,TP1: TThreadPool;
  obj,temp_obj:TJob;
  obj1:Tjob1;
  a,rest,count1:long;
  NbrProcs,c:integer;
  tab,tab1:Ttabpointer;
  tab2:array of Ttabpointer;
  
  arr1:TArrayParams;
  FTypeSort:TTypeSort;
  comp:TSortCompare;

  protected
  public
   
    constructor Create(nbrprocessors:integer;TypeSort:TTypeSort = ctQuickSort);
    destructor Destroy; override;
    procedure Sort(var tab:TTabPointer;SCompare: TSortCompare); // SCompare: TSortCompare
    procedure ParallelSort(obj: Pointer);

    procedure ParallelMerge(obj: Pointer);
    procedure Merge_Parallel1(job: Pointer);
    procedure merge_parallel(var  t:TTabPointer; p1, r1:long;  p2, r2:long;var a:TTabPointer; p3:long;SCompare: TSortCompare;value,value1:pointer;event:TSimpleEvent);

    property TypeSort: TTypeSort read FTypeSort write FTypeSort default ctQuickSort;

  end;

function BinSearch(var a: TTabPointer; value:pointer;left, right:long;SCompare: TSortCompare): long;
function Binsearch1(var a: TTabPointer; value:pointer;left, right:long;SCompare: TSortCompare):long;


implementation
 

function LockedIncLong(var Target: long): long;
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
        MOV     RAX, 1
        LOCK XADD [RCX], RAX
        INC     RAX
        {$ENDIF CPU64}
end;


function LockedIncLong1(Target: pointer): long;
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
        MOV     RAX, 1
        LOCK XADD [RCX], RAX
        INC     RAX
        {$ENDIF CPU64}
end;

function LockedDecLong1(Target: pointer): long;
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

function Binsearch1(var a: TTabPointer; value:pointer;left, right:long;SCompare: TSortCompare):long;

var low,high,mid:long;

begin

    low  := left;
    high := max( left, right + 1 );
    while( low < high )
    do 
    begin
        mid := ( low + high) div 2;
        if ( scompare(value,a[ mid ])<=0 ) then high:=mid 
        else   low  := mid + 1;// because we compared to a[mid] and the value was larger than a[mid].
                                                    // Thus, the next array element to the right from mid is the next possible
                                                    // candidate for low, and a[mid] can not possibly be that candidate.
    end;
    result:=high;
end;


function BinSearch(var a: TTabPointer; value:pointer;left, right:long;SCompare: TSortCompare): long;
var
First: long;
Last: long;
Pivot: long;
Found: Boolean;

begin

First := left; 
Last := right; 
Found := False; 
Result := -1; 

while (First <= Last) and (not Found) do
begin
Pivot := (First+Last)div 2;
if scompare(a[Pivot],value)=0 then
begin
Found := True;
Result := Pivot;
end
else if scompare(a[Pivot],value)>0 then
Last := Pivot - 1
else 
First := Pivot + 1;
end;
end;


Procedure SequentialMerge(var to1:TTabPointer; var temp:TTabPointer; lowX, highX,lowY, highY, lowTo:long;SCompare: TSortCompare);
 
var highto:long;  
  begin
         highTo := lowTo + highX - lowX + highY - lowY + 1;
        
    lowto:=lowto;
 repeat
 //see here 
   if (lowX > highX) 
               then  
                begin 
                to1[lowTo] := temp[lowY];
                inc(lowY); 
                end 
            else if (lowY > highY)
                then 
                 begin
                  to1[lowTo] := temp[lowX];
                  inc(lowX);
                 end  
            else
             begin
              if scompare(temp[lowX],temp[lowY])<0 
                   then
                      begin 
                       to1[lowTo]:=temp[lowX];
                       inc(lowX);
                      end
                    else
                      begin 
                       to1[lowTo]:=temp[lowY];
                       inc(lowY);
                      end;

             end;
    inc(lowto);
  if lowto=highto+1 then break;
until false; 

end;  	

procedure TParallelSort.merge_parallel1(job:pointer);

var event:tsimpleevent;
   value:pointer;
  localvalue:long;
begin

merge_parallel(tjob2(job).t,tjob2(job).p1,tjob2(job).r1,tjob2(job).p2,tjob2(job).r2,tjob2(job).a,tjob2(job).p3,tjob2(job).comp,tjob2(job).value,tjob2(job).value1,tjob2(job).event);

tjob2(job).free;

end;  


procedure  TParallelSort.merge_parallel(var  t:TTabPointer; p1, r1:long;  p2, r2:long;var a:TTabPointer; p3:long;SCompare: TSortCompare;value,value1:pointer;event:TSimpleEvent);

var length1,length2,length3,tmp,q1,q2,q3,temp:long;
    mergeLeft,mergeRight:TJob2;
begin
 

    length1 := (r1 - p1) + 1;
    length2 := (r2 - p2) + 1;
     
if (length1 < length2) then
        begin
           merge_parallel(t, p2,r2,p1, r1, a,p3,SCompare,value,value1,event);
     exit;
  // temp:=p1;
  // p1:=p2;
  // p2:=temp;
  // temp:=r1;
  // r1:=r2;
  // r2:=temp;
  // temp:=length1;
  // length1:=length2;
  // length2:=temp;

       end;    

if ( length1 = 0 ) then exit;  
 
if (( length1 + length2 ) <= 1000)  then 

                  begin
                    SequentialMerge(a,t, p1, r1, p2, r2, p3,scompare);
                    crit.enter;
                    long(value1^):=long(value1^)+(length1+length2);
                    length3:=length(a);
                     if long(value1^)=length3 then event.setevent;  
                    crit.leave;
                    // if long(value^)=0 then event.setevent;     
                    exit;
                  end;


        q1 :=  (p1 +r1) div 2;

q2 :=binsearch1( t,t[q1 ], p2, r2,SCompare); 
//      q2 := binsearch( t,t[q1 ], p2, r2,SCompare); 
        
            q3 := p3 +  (q1 - p1)  +  (q2 - p2) ;
            a[q3] := t[q1];

       mergeLeft:=TJob2.create();
      // lockedinclong1(value);
      // lockedinclong1(value);

       mergeLeft.t:=t;
       mergeLeft.p1:=p1;
       mergeLeft.r1:=q1; //q1-1
       mergeLeft.p2:=p2;
       mergeLeft.r2:=q2-1;
       mergeLeft.a:=a;
       mergeLeft.p3:=p3;
       mergeLeft.comp:=scompare;
       mergeleft.value:=value;
       mergeLeft.event:=event;
       mergeLeft.value1:=value1;

        
                         
       mergeRight:=TJob2.create();

       mergeRight.t:=t;
       mergeRight.p1:=q1+1; //q1

       mergeRight.r1:=r1;
       mergeRight.p2:=q2;
       mergeRight.r2:=r2;
       mergeRight.a:=a;
       mergeRight.p3:=q3+1; //q3
       mergeRight.comp:=scompare;
       mergeRight.value:=value;
       mergeRight.event:=event;
       mergeRight.value1:=value1;

      
      
        
      TP1.execute(self.merge_parallel1,pointer(mergeLeft)); 
      TP1.execute(self.merge_parallel1,pointer(mergeRight));
	 
  
end;



procedure Merge(var T1,T2:TTabPointer;Low,Mid,Hi:integer;SCompare: TSortCompare);
 
    var
    p,pp,s,i:integer;
    
   begin
      p:=Low;
      pp:=Low;
      s:=Mid+1;
    for i := Low to Hi do T2[i]:=T1[i];
    while (p<=Mid) and (s<=Hi) 
      do
        begin
         if  scompare(T2[p],T2[s]) < 0  //T2[p]<T2[s] 
           then
             begin
              T1[pp]:=T2[p];
              inc(p);
             end
           else
            begin
             T1[pp]:=T2[s];
             inc(s);
            end;
        inc(pp);
       end;
    if s>Hi 
       then
        for i := p to Mid 
        do
          begin
           T1[pp]:=T2[i];
           inc(pp);
          end
       else
       for I := s to Hi 
       do
         begin
          T1[pp]:=T2[i];
          inc(pp);
         end;
    end;

procedure Merge1(var T1,T2:TTabPointer;Low,Mid,Hi:long;SCompare: TSortCompare);
 
    var
    p,pp,s,i:long;
    J:INTEGER;
   begin
      p:=Low;
      pp:=Low;
     s:=Mid+1;
   

 i:=low;
 repeat
 //see here for i := Low to Hi do T2[i-low]:=T1[i];
  T2[i-low]:=T1[i];
    inc(i);
  if i=Hi+1 then break;
until false; 

    while (p<=Mid) and (s<=Hi) 
      do
        begin
        if   scompare(T2[p-low],T2[s-low]) < 0 
           then
             begin
              T1[pp]:=T2[p-low];
              inc(p);
             end
           else
            begin
             T1[pp]:=T2[s-low];
             inc(s);
            end;
        inc(pp);
       end;
    if s>Hi 
       then
	    begin
	    i:=p;
	    repeat
		 T1[pp]:=T2[i-low];
           inc(pp);
		   inc(i);
		   if i=Mid+1 then break;
		 until false; 
       end		 
       else
	    begin 
	    i:=s;
	    repeat
		 T1[pp]:=T2[i-low];
           inc(pp);
		   inc(i);
		   if i=Hi+1 then break;
		 until false; 
       end;
   end;

procedure swap ( var a, b: Pointer);
var temp: Pointer;
begin
temp := a;
a := b;
b := temp;
end;

procedure siftDown ( var A: Ttabpointer;iLo,start, end_: long;SCompare: TSortCompare); 

var root, child: long;
begin
root := start;

while ( root * 2 + 1 <= end_ ) do begin 
child := root * 2 + 1; 
if ( child < end_ ) and ( scompare(A[child+iLo],A[child +1+iLo]) < 0  ) 
 then child := child + 1; 
if (  scompare(A[root+iLo],A[child+iLo]) < 0 ) 
  then 
   begin 
    swap ( A[root+iLo], A[child+iLo] );
    root := child; 
   end
else break;
end;
end;


procedure heapify ( var A: TTabpointer; iLo,count: long ;SCompare: TSortCompare);
var start: long;
begin
start := (count - 1) div 2;

while ( start >= 0 ) 
do 
 begin
   siftDown (A,iLo, start, count-1,scompare);
   start := start - 1;
  end;
end;


procedure heapSort( var A:ttabpointer;iLo,n: long; SCompare: TSortCompare); 

var end_: long;
begin

heapify ( A,iLo, n,scompare);

end_ := n - 1;
while ( end_ > 0 ) 
 do 
  begin
   swap( A[end_+iLo], A[0+iLo]);
   end_ := end_ - 1;
   siftDown (A, iLo,0, end_,scompare);
  end;
end;

procedure QSort(var A: TTabPointer; iLo, iHi: long; SCompare: TSortCompare) ; 

var
Lo, Hi, i,j,k: long;
Pivot,T:pointer;
begin
Lo := iLo;
Hi := iHi;

Pivot := A[(Lo + Hi) div 2];

repeat
    while scompare(A[Lo], Pivot) < 0 do Inc(Lo) ; 
    while scompare(A[Hi], Pivot) > 0 do Dec(Hi) ; 
   if Lo <= Hi then
       begin
           T := A[Lo];
           A[Lo] := A[Hi];
           A[Hi] := T;
           Inc(Lo) ;
           Dec(Hi) ;
            
        end;
until Lo > Hi;

if Hi > iLo then QSort(A, iLo, Hi,scompare) ;
if Lo < iHi then QSort(A, Lo, iHi,scompare) ;
end;


function Partition2(var fdata: Ttabpointer;left, right, pivotIndex: Long;scompare:TSortCompare): Long;
var
  i    ,j   : long;
  a:integer;
  pivotValue: pointer;
  storeIndex: Long;
  tmp       : pointer;
begin
j:=0;
  pivotValue := FData[pivotIndex];
  tmp := FData[pivotIndex]; FData[pivotIndex] := FData[right]; FData[right] := tmp;
     
  storeIndex := left;
  
i:=left;
repeat
  a:=scompare(FData[i],pivotValue); 
   if a <= 0 then begin
      tmp := FData[i]; FData[i] := FData[storeIndex]; FData[storeIndex] := tmp;
      Inc(storeIndex);
    end;
   if a=0 then inc(j);
   inc(i);
 if i=(right-1)+1 then break;
until false; 
   
   tmp := FData[storeIndex]; FData[storeIndex] := FData[right]; FData[right] := tmp;

   if j=(right-left) then result:=(left+right) div 2
 else Result := storeIndex;
end; { TSorter.Partition }




procedure QuickSort2(var fdata: Ttabpointer;left, right: Long;scompare:TSortCompare);
var
  pivotIndex,R: Long;
  temp:pointer;

begin


 if right > left then begin
    
      if (right - left) >= 2 then begin 
      R :=  (left + right) div 2; 
      if (sCompare(fdata[left], fdata[R]) > 0) then begin 
        Temp := fdata[left]; 
        fdata[left] := fdata[R]; 
        fdata[R] := Temp; 
      end; 
      if (sCompare(fdata[left], fdata[right]) > 0) then begin 
        Temp := fdata[left]; 
        fdata[left] := fdata[right]; 
        fdata[right] := Temp; 
      end; 
      if (sCompare(fdata[R], fdata[right]) > 0) then begin 
        Temp := fdata[R]; 
        fdata[R] := fdata[right]; 
        fdata[right] := Temp; 
      end; 
     end;

      pivotIndex := Partition2(fdata,left, right, (left + right) div 2,scompare);
          
       Quicksort2(fdata,left,pivotIndex-1, scompare);
       Quicksort2(fdata,pivotIndex+1,right,scompare);
      
    //   end;
    end;
  
end;


procedure mergesort(var a: Ttabpointer;lks,rts:long;SCompare: TSortCompare);
var
  B : Ttabpointer;
  procedure merge(links,rechts:long);
  var
    i,j,k,mid :long;

    procedure InsertSort;
    var
      i: integer;
      Pivot : Pointer;
    begin
      for i:=links+1 to rechts do
        begin
        j :=i;
        Pivot := A[j]; 
        while (j>links) AND (scompare(A[j-1],Pivot)>0) do
          begin  
          A[j] := A[j-1];
          dec(j);
          end;
        A[j] :=Pivot;
        end;
     end;

  begin
    If rechts-links<=4 then
      InsertSort
    else
      begin
      mid := (rechts+links) div 2;
      merge(links, mid);
      merge(mid+1, rechts);
      IF scompare(A[Mid],A[Mid+1])<0 then
        exit;
      
      move(A[links],B[0],(mid-links+1)*SizeOf(Pointer));
      i := 0;
      j := mid+1;
      k := links;
      while (k<j) AND (j<=Rechts) do
        begin
        IF scompare(B[i],A[j])<=0 then
          begin
          A[k] := B[i];
          inc(i);
          end
        else
          begin
          A[k]:= A[j];
          inc(j);
          end;
        inc(k);
        end;

      while (k<j) do
        begin
        A[k] := B[i];
        inc(i);
        inc(k);
        end;
    end;   
  end;     
begin
  setlength(B,((rts-lks)+1));
  merge(lks,rts);
  setlength(B,0);
end;


constructor TParallelSort.Create(nbrprocessors:integer;TypeSort:TTypeSort = ctQuickSort);

begin
  inherited Create;
  TP := TThreadPool.Create(nbrprocessors, TMyThread,13 ); // nbrprocs workers threads and 2^11 items for each queue. 
  TP1 := TThreadPool.Create(nbrprocessors, TMyThread,13 ); // nbrprocs workers threads and 2^11 items for each queue. 

 crit:=tcriticalsection.create;
  randomize;
  FTypeSort:=TypeSort;
  NbrProcs:=nbrprocessors;
 

if ((nbrprocs mod 2) <> 0) and  (nbrprocs <> 1) 
   then 
     begin
       writeln('Number of cores must be multiple of 2');
      halt;
     end;

end;

destructor TParallelSort.Destroy;

begin
crit.free;
TP.free;
TP1.free;
inherited Destroy;
end;


procedure TParallelSort.parallelmerge(obj:pointer) ;

var

local_count:long;
 value,value1:^long;
    event,event1:TSimpleEvent;
    i,count:long;
begin
new(value);new(value1);
event1:=tsimpleevent.create;
value^:=0;value1^:=0;


//Merge1(Tjob1(obj).a1,Tjob1(obj).a2,Tjob1(obj).Low,Tjob1(obj).Mid,Tjob1(obj).Hi,Tjob1(obj).comp);
merge_parallel(Tjob1(obj).a1,Tjob1(obj).Low,Tjob1(obj).Mid,Tjob1(obj).Mid+1,Tjob1(obj).Hi,Tjob1(obj).a2,0,Tjob1(obj).comp,value,value1,event1);

event1.waitfor(INFINITE);
event1.resetevent;

dispose(value);
dispose(value1);

i:=Tjob1(obj).Low;
repeat
  Tjob1(obj).a1[i]:=Tjob1(obj).a2[i-Tjob1(obj).Low];
   inc(i);
 if i=Tjob1(obj).Hi+1 then break;
until false; 
   
setlength(Tjob1(obj).a2,0);

local_count:=LockedIncLong(count1);

event:=Tjob1(obj).event;
count:=TJob1(obj).count;
TJob1(obj).free;
if local_count=count then event.setevent;

event1.free;

end;



procedure TParallelSort.ParallelSort(obj:pointer) ;

var

local_count,i:long;
local_a:long;
count:long;
event:tsimpleevent;

local_tab:ttabpointer;

begin
Case FTypeSort of 

ctQuicksort: //QSort(TJob(obj).a,Tjob(obj).iLo,Tjob(obj).iHi,comp);
              Quicksort2(TJob(obj).a,Tjob(obj).iLo,Tjob(obj).iHi,comp);

ctHeapSort : begin
               //local_tab:=pointer(@TJob(obj).a[Tjob(obj).iLo]);
               //local_tab:=TTabPointer(addr(TJob(obj).a[Tjob(obj).iLo]));
               //heapsort(local_tab,local_a,comp);
              local_a:=(Tjob(obj).iHi-Tjob(obj).iLo)+1;  
              heapsort(TJob(obj).a,Tjob(obj).iLo,local_a,comp);
             end; 
ctMergeSort: MergeSort(TJob(obj).a,Tjob(obj).iLo,Tjob(obj).iHi,comp);
             

end;

local_count:=LockedIncLong(count1);
count:=TJob(obj).count;
event:=Tjob(obj).event;
TJob(obj).free;
if local_count=count then event.setevent;
end;


Procedure TParallelSort.Sort(var tab:TTabPointer;SCompare: TSortCompare); 

var

i:integer;
j,b,c,a1:long;
event1:tsimpleevent;

begin

 count1:=0;

event1:=tsimpleevent.create;
event1.resetevent;

comp:=SCompare;

if length(tab)=0 
  then 
   begin
    event1.free;
    exit;
   end;


if  (HIGH(Tab)+1 <= 1000) or (Nbrprocs=1) then NbrProcs:=1
else if (length(tab) >= 80000) 
then
begin
a1:=length(tab) div 10000;
b:=2;
for i:=0 to high(integer)
do
begin
c:=b;
if c >= a1 then break;
b:=b*2;
end;
NbrProcs:=c;
end
else if ((length(tab) < 80000) and  (length(tab) >= 40000)) 
then
begin
a1:=length(tab) div 5000;
b:=2;
for i:=0 to high(integer)
do
begin
c:=b;
if c >= a1 then break;
b:=b*2;
end;
NbrProcs:=c;
end
else if ((length(tab) < 40000) and  (length(tab) >= 20000)) 
then
begin
a1:=length(tab) div 2500;
b:=2;
for i:=0 to high(integer)
do
begin
c:=b;
if c >= a1 then break;
b:=b*2;
end;
NbrProcs:=c;
end
else if (length(tab) < 20000)  
then
begin
a1:=length(tab) div 1000;
b:=2;
for i:=0 to high(integer)
do
begin
if a1=1 
then 
begin
c:=1; 
break;
end;
c:=b;
if c >= a1 then break;
b:=b*2;
end;
NbrProcs:=c;
end;


if nbrprocs > length(tab)

  then 
   begin
    QuickSort2(tab,low(tab), high(tab),comp);
    event1.free;
     exit;
   end; 

setlength(arr1,nbrprocs); 

a:=length(tab) div NbrProcs;

for i:=0 to nbrprocs-1
 do 
    begin 
     if (i = (nbrprocs-1))
     then 
      begin
         arr1[i]:=TParams.create;
         arr1[i].a:=i*a;
         arr1[i].b:=High(tab);
      break;
      end;
      
     arr1[i]:=TParams.create;
     arr1[i].a:=i*a;
     arr1[i].b:=((i+1)*a)-1;
      
 end;

for i:=0 to nbrprocs-1
 do 
  begin
   
     obj:=Tjob.create;
     obj.a:=tab;
     obj.iLo:=arr1[i].a;
     obj.iHi:=arr1[i].b;
     obj.event:=event1;
     obj.count:=nbrprocs;
     TP.execute(self.Parallelsort,pointer(obj));
  end;

event1.waitfor(INFINITE);
event1.resetevent;

c:=(nbrprocs) div 2;

repeat
if (c >= 1) 
 then
  begin
  count1:=0;
  for i:=0 to c-1
   do 
    begin
       setlength(tab2,i+1);
       
       setlength(tab2[i],((arr1[(i*2)+1].b-arr1[i*2].a)+1));
       
       //readln;
       //setlength(tab2[i],length(tab));
       obj1:=Tjob1.create;
       obj1.a1:=tab;
       obj1.a2:=tab2[i];
       obj1.Low:=arr1[i*2].a;
       obj1.Mid:=arr1[i*2].b;  
       obj1.Hi:=arr1[(i*2)+1].b;
       obj1.comp:=comp;
       obj1.event:=event1;
       obj1.count:=c;
           
       TP.execute(self.parallelmerge,pointer(obj1));
     
       // Merge(Tab,Tab1,arr1[i*2].a,arr1[i*2].b,arr1[i*2+1].b,comp);
       arr1[i].a:=arr1[i*2].a;
       arr1[i].b:=arr1[(i*2)+1].b;
      end;
   event1.waitfor(INFINITE);
   event1.resetevent;
   c:=c div 2;
   
  end
else 
   break;
until false;

   for i:=0 to nbrprocs-1 do TParams(arr1[i]).free;


SetLength(tab2,0);
setlength(arr1,0); 

event1.free;
end;

end.




