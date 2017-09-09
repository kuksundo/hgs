unit FastList;

interface

{$I defines.inc}

uses
  
{$IFDEF Delphi}
  Classes, sysUtils,parallelsort,mtpcpu; 
{$ENDIF Delphi}
{$IFDEF FPC}
  Classes, sysUtils,parallelsort,mtpcpu ; 
{$ENDIF FPC}
{$IFDEF XE}
  system.Classes, system.sysUtils,parallelsort,mtpcpu ;
{$ENDIF XE}

type
   


ArrayOfString = array of string;

TFastList = class(TObject)

protected

myobj:TParallelSort;
counter:integer;
myArray: ArrayOfString;
fSorted:boolean;
function GetItems(i:integer): string; register;
procedure SetItems(i:integer; const Value: string); register;

public
 constructor Create();
    destructor  Destroy; override;

procedure Add(const Value: string);

function count:integer;
procedure sort();
procedure Clear;
function Find(SubStr: string): Integer; 
property Items[i: integer] : string read GetItems write SetItems; default;

end;


   

implementation


function comp(Item1, Item2: Pointer): integer;

begin

if string(Item1) < string(Item2) 
 then 
 begin 
  result:=-1;
  exit;
 end;

if string(Item1) > string(Item2) then 
 begin 
  result:=1;
  exit;
 end;
 
 if string(Item1) = string(Item2) 
then 
 begin 
  result:=0;
  exit;
 end;


end;

constructor TFastList.create();

begin
inherited Create;

myobj:=TParallelSort.create(GetSystemThreadCount,ctMergesort); // set the number of threads and the sort's type
// ctQuickSort or ctHeapSort or ctMergeSort ..
										    
// you have to set the number of cores to power of 2 
fSorted:=false;
setlength(myArray,100000);
counter:=0;
end;

destructor TFastList.Destroy;
begin

myobj.free;
setlength(myArray,0);
  inherited Destroy;

end;

procedure TFastList.Add(const Value: string);
begin

if counter>=length(myArray)-1
then setlength(myArray,length(myArray)+100000);


myArray[counter]:=value;

inc(counter);
fSorted:=false;

end;

procedure TFastList.SetItems(i: integer; const Value: string);
begin

if ((i<0) or (i>self.count-1)) then raise Exception.Create('Out of bound access violation in TFastList''s object');


myArray[i]:=value;
fSorted:=false;

end;

function TFastList.GetItems(i: integer): string;
begin

if ((i<0) or (i>self.count-1)) then raise Exception.Create('Out of bound access violation in TFastList''s object');


result:=myArray[i];

end;

function TFastList.count: integer;
begin

result:=counter;

end;


function TFastList.Find(SubStr: string): Integer; // A binary search
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
  Found: Boolean;
begin

  if fSorted=false then self.sort;
  First  := Low(myArray); //Sets the first item of the range
  Last   := High(myArray); //Sets the last item of the range
  Found  := False; //Initializes the Found flag (Not found yet)
  Result := -1; //Initializes the Result

  //If First > Last then the searched item doesn't exist
  //If the item is found the loop will stop
  while (First <= Last) and (not Found) do
  begin
    //Gets the middle of the selected range
    Pivot := (First + Last) div 2;
    //Compares the String in the middle with the searched one
    if myArray[Pivot] = SubStr then
    begin
      Found  := True;
      Result := Pivot;
    end
    //If the Item in the middle has a bigger value than
    //the searched item, then select the first half
    else if myArray[Pivot] > SubStr then
      Last := Pivot - 1
        //else select the second half
    else 
      First := Pivot + 1;
  end;
end;

procedure TFastList.sort();
begin

setlength(myarray,counter);
myobj.sort(ttabpointer(myArray),comp);
fSorted:=true;
end;

procedure TFastList.Clear;
begin

setlength(myArray,0);
setlength(myArray,100000);
counter:=0;
end;

end.
