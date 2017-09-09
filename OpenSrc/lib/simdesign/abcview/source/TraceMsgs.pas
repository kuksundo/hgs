{ unit TraceMsgs

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit TraceMsgs;

{.$DEFINE TRACE}

interface

uses

  SysUtils, Windows;


procedure TraceMsg(AMsg: string);

function AddTextToFile(const aFileName, aText: string; AddCRLF: Boolean): Boolean;

const

  cTraceFile = 'd:\temp\delphi\trace.txt';


implementation

procedure TraceMsg(AMsg: string);
begin
{$IFDEF TRACE}
  // Add a line to the trace file
  AddTextToFile(cTraceFile, Format('%.6d: %s',[GetTickCount, AMsg]), True);
{$ENDIF}
end;

function AddTextToFile(const aFileName, aText: string; AddCRLF: Boolean): Boolean;
var
  lF: Integer;
  lS: string;
begin
  Result := False;
  if FileExists(aFileName) then lF := FileOpen(aFileName, fmOpenWrite + fmShareDenyNone)
   else lF := FileCreate(aFileName);
  if (lF >= 0) then
    try
      FileSeek(lF, 0, 2);
      if AddCRLF then lS := aText + #13#10
      else lS := aText;
      FileWrite(lF, lS[1], Length(lS));
    finally
      FileClose(lF);
    end;
end;

procedure DoInitialization;
begin
{$IFDEF TRACE}
  DeleteFile(cTraceFile);
{$ENDIF}
end;

initialization

  DoInitialization;

end.
