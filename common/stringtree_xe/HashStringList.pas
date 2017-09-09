{*************************************************************
*      THashStringList 
*      Version: 1.0 
*      Author: Amine Moulay Ramdane 
*     Company: Cyber-NT Communications           
*      
*       Email: aminer@videotron.ca   
*     Website: http://pages.videotron.com/aminer/
*        Date: April 9,2010                                            
* Last update: February 10,2015                                 
*
* Copyright � 2009 Amine Moulay Ramdane.All rights reserved
*
*************************************************************}
unit HashStringList;

{$I defines.inc}


interface

{$IFDEF Delphi}
uses
  Classes, SysUtils, HashList;
{$ENDIF Delphi}
{$IFDEF FPC}
uses
  Classes, SysUtils, HashList;
{$ENDIF FPC}
{$IFDEF XE}
 uses
  system.Classes, system.SysUtils, HashList;
{$ENDIF XE}




type
  THashStringList = class(TObject)
  private
    obj1:TCaseSensitiveTraits;
    list:TStringList;
    FValueHash: THashList;
    FHashSize: Integer;
	FSorted:boolean; 
    procedure AddHash(const S: string; Index: Integer);
    procedure DeleteHash(Index: Integer);
  protected
  function GetObjects(i:integer): TObject; register;
procedure SetObjects(i:integer; const Value: TObject); register;
 function GetStrings(i:integer): string; register;
procedure SetStrings(i:integer; const Value: string); register;
procedure SetSorted(Value: Boolean);
procedure SetCapacity(Value: Integer);
function GetCapacity:integer;
  public
    constructor Create(HashSize: Integer);
    destructor Destroy; override;
    function Add(const S: string): Integer; 
    function AddObject(const S: string;obj:TObject): Integer;
procedure InsertObject(Index: Integer; const S: string;
      AObject: TObject); 
    procedure Delete(Index: Integer); 
    function IndexOf(const S: string): Integer; 
    function Contains(const S: string): Boolean;
    procedure Remove(const S: string);
    procedure Clear;
	function Count:integer; 
	procedure Assign(Source: THashStringList); 
	property Sorted: Boolean read FSorted write SetSorted;
    property Objects[i: integer] : TObject read GetObjects write SetObjects; 
    property Strings[i: integer] : string read GetStrings write SetStrings;
   	property Capacity: Integer read GetCapacity write SetCapacity;

  end;

implementation

{ THashStringList }

procedure THashStringList.SetCapacity(Value: Integer);
begin
list.capacity:=value;
end;

function THashStringList.GetCapacity:integer;
begin
result:=list.capacity;
end;

procedure THashStringList.SetObjects(i: integer; const Value: TObject);
begin

list.objects[i]:=value;

end;

function THashStringList.GetObjects(i: integer): TObject;
begin

result:=list.objects[i];

end;


procedure THashStringList.SetStrings(i: integer; const Value: string);
begin

list.strings[i]:=value;

end;

function THashStringList.GetStrings(i: integer): string;
begin

result:=list.strings[i];

end;

procedure THashStringList.SetSorted(value: boolean);
begin

list.sorted:=false;
fsorted:=false;

end;

function THashStringList.Add(const S: string): Integer;

begin

result := list.Add(S);
 AddHash(S, result);

end;

function THashStringList.AddObject(const S: string;obj:TObject): Integer;

begin

result := list.AddObject(S,obj);
 AddHash(S, result);

end;

procedure THashStringList.InsertObject(Index: Integer; const S: string;
      AObject: TObject); 


begin

list.InsertObject(index,S,AObject);
 AddHash(S, index);

end;


procedure THashStringList.AddHash(const S: string; index: Integer);
{$IFDEF CPU64}
var b:int64;
{$ENDIF CPU64}
{$IFDEF CPU32}
var b:integer;
{$ENDIF CPU32}

begin
b:=index;
  FValueHash.Add(S, pointer(b));
end;

function THashStringList.Contains(const S: string): Boolean;
begin
  Result:= IndexOf(S) <> -1;
end;

constructor THashStringList.Create(HashSize: Integer);

begin
list:=TStringList.create;
list.sorted:=false;
  // 대소문자를 구별한다.
  FHashSize:= HashSize;
obj1:=TCaseSensitiveTraits.Create; 
  FValueHash := THashList.Create(obj1,FHashSize);
 
end;

procedure THashStringList.Delete(Index: Integer);
begin
  
 if (list.count=1) or (index=list.count-1)
 then 
 begin
   remove(list[index]);
   list.Delete(index);
 end
 else if index<list.count-1
  then 
   begin
    remove(list[list.count-1]);
    remove(list[index]);
    list[index]:=list[list.count-1];
    FValueHash.Add(list[index], index);
    list.Delete(list.count-1);
  end;

end;

procedure THashStringList.DeleteHash(Index: Integer);
begin
  Remove(list[Index]);
end;

destructor THashStringList.Destroy;
begin
obj1.free;
FValueHash.Free;
list.free;
inherited Destroy;
end;

function THashStringList.IndexOf(const S: string): Integer;
var p:pointer;
  bool:boolean;
begin
p:=0;
bool:=FValueHash.Find(S,p);
if bool=true
then 
{$IFDEF CPU64}
result:=int64(p)
{$ENDIF CPU64}
{$IFDEF CPU32}
result:=integer(p)
{$ENDIF CPU32}
else result:=-1;

//result:=inherited IndexOf(S);
end;

procedure THashStringList.Remove(const S: string);
begin
  FValueHash.Remove(S);
end;

procedure THashStringList.Clear;

var i,count:integer;
begin
list.clear;
fvaluehash.clear
//count:=inherited count;
//for i:=0 to count-1
//do delete(0);
end;

function THashStringList.Count:integer;

begin
result:=list.count;

end;

procedure THashStringList.Assign(Source: THashStringList); 
var i:integer;
begin

self.clear;
for i:=0 to source.count-1
do self.AddObject(source.strings[i],source.objects[i]);
end;

end.
