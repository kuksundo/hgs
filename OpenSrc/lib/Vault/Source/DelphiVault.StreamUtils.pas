// Written with Delphi XE3 Pro
// Created Nov 24, 2012 by Darian Miller
unit DelphiVault.StreamUtils;

interface
uses
  System.Classes;

  function MemoryStreamToString(const Source:TMemoryStream):string;

implementation

// Based on answer by Rob Kennedy on Apr 9, 2009 to question:
// http://stackoverflow.com/questions/732666/converting-tmemorystream-to-string-in-delphi-2009
function MemoryStreamToString(const Source:TMemoryStream):string;
begin
  SetString(Result, Source.Memory, Source.Size div SizeOf(Char));
end;

end.
