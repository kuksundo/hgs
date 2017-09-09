unit UnitFileUtil;

interface

uses Winapi.Windows, classes, SysUtils, Forms, SynCommons, mORMot;

function LoadFromJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;
function SaveToJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;

implementation

function LoadFromJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;
var
  LStrList: TStringList;
  LValid: Boolean;
  LString: RawUTF8;
  Fs: TFileStream;
  LMemStream: TMemoryStream;
begin
  LStrList := TStringList.Create;
  try
    if AIsEncrypt then
    begin
      LMemStream := TMemoryStream.Create;
      Fs := TFileStream.Create(AFileName, fmOpenRead);
      try
        DecryptStream(Fs, LMemStream, APassphrase);
        LMemStream.Position := 0;
        LStrList.LoadFromStream(LMemStream);
      finally
        LMemStream.Free;
        Fs.Free;
      end;

    end
    else
    begin
      LStrList.LoadFromFile(AFileName);
    end;

    SetLength(LString, Length(LStrList.Text));
    LString := StringToUTF8(LStrList.Text);
    JSONToObject(Self, PUTF8Char(LString), LValid);
  finally
    LStrList.Free;
  end;
end;

function SaveToJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;
var
  LStrList: TStringList;
  LMemStream: TMemoryStream;
  Fs: TFileStream;
  LStr: RawUTF8;
begin
  LStrList := TStringList.Create;
  try
    LStr := ObjectToJSON(nil);
    LStrList.Add(UTF8ToString(LStr));

    if AIsEncrypt then
    begin
      LMemStream := TMemoryStream.Create;
      Fs := TFileStream.Create(AFileName, fmCreate);
      try
        LStrList.SaveToStream(LMemStream);
        LMemStream.Position := 0;
        EncryptStream(LMemStream, Fs, APassphrase);
      finally
        Fs.Free;
        LMemStream.Free;
      end;
   end
    else
      LStrList.SaveToFile(AFileName);
  finally
    LStrList.Free;
  end;
end;

end.
