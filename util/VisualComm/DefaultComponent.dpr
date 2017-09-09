library DefaultComponent;

uses
  PlugInBase,
  _DefaultPlugIn in '_DefaultPlugIn.pas';

{$R *.res}

// Plugin Object...
var
  MyPlugIn1:TpjhDefaultPlugIn;
  MyPlugIn2:TpjhDefaultPlugIn2;
  ExitFree: Pointer;
const
 NUMPLUGINS = 2; //always keep in mind that you have to increase this one...

function GetPlugInCount:integer; stdcall;
begin
	result:=NUMPLUGINS;
end;

function GetPlugIn( idx:integer ):TBasePlugIn; stdcall;
var presult:TBasePlugIn;
begin
	pResult := nil;
  case idx of    // what plugin to return
    0: pResult := MyPlugIn1;
    1: pResult := MyPlugIn2;
    2: ;
    3: ;
  end;// case

	result:= pResult;
end;

procedure MyExit;
begin
  ExitProc := ExitFree;

  if Assigned(MyPlugIn1) then
    MyPlugIn1.Free;

  if Assigned(MyPlugIn2) then
    MyPlugIn2.Free;
end;

//This Should always stay here
exports
  GetPlugIn,
  GetPlugInCount;

begin

  //Exit Procedure
  ExitFree := ExitProc;
  ExitProc := @MyExit;
  //Don't Forget to init all of your Plugins here
  MyPlugIn1:=TpjhDefaultPlugIn.Create;
  MyPlugIn2:=TpjhDefaultPlugIn2.Create;

end.
