unit FileUtils;

interface
  function getFilelen64(FileName : string) : int64;
  function ExtractFileExtNoDot(const FileName : string) : string;
  function ExtractFilePathWithSlash(const FileName : string) : string;

implementation
  uses Classes, SysUtils, StrUtils;

function getFilelen64(FileName : string) : int64;
var
  Stream : TFileStream;
begin
  Result := -1;
  Try
    Stream := nil;
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    Result := stream.Size;
  Except //try reading file
  end;
  FreeAndNil(stream);
end;

function ExtractFileExtNoDot(const FileName : string) : string;
begin
  Result := ExtractFileExt(FileName);
  if Result <> '' then
    Result := RightStr(Result,Length(Result)-1);
end;

function ExtractFilePathWithSlash(const FileName : string) : string;
var
  i : Integer;
  endSlash : string;
begin
  Result := '';
  if Length(FileName) > 0 then begin
    if Pos('/', FileName) > 0 then
      endSlash := '/'
    else
      endSlash := '\';
    i := LastDelimiter(endSlash,FileName);
    if i > 0 then begin
      if i = Length(FileName) then begin
        Result := FileName;  // is a path with an slash
      end else begin
        Result := LeftStr(FileName,i); // get only path
      end;
    end;
  end;
end;
end.
