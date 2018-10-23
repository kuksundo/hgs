unit UnitLogUtil;

interface

uses System.Classes, System.Sysutils;

implementation

procedure DoLogTextFile(const AFileName, ATxt: string);
var
  F: TextFile;
begin
  AssignFile(F, AFileName);
  try
    if FileExists(AFileName) then
      Append(f)
    else
      Rewrite(f);
    WriteLn(f,ATxt);
  finally
    CloseFile(F);
  end;
end;

procedure DoLogTFileStream(const AFileName, ATxt: string);
var
  F: TFileStream;
  b: TBytes;
begin
  if FileExists(AFileName) then
    F := TFileStream.Create(AFileName, fmOpenReadWrite)
  else
    F := TFileStream.Create(AFileName, fmCreate);
  try
    F.Seek(0, soFromEnd);
    b := TEncoding.Default.GetBytes(ATxt + sLineBreak);
    F.Write(b, Length(b));
  finally
    F.Free;
  end;
end;

end.
