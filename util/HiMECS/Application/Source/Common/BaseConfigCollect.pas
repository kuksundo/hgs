unit BaseConfigCollect;

interface

uses Winapi.Windows, classes, SysUtils, Forms, Registry,//, AsyncCalls, AsyncCallsHelper
  SynCommons, mORMot, UnitRttiUtil, UnitStreamUtil;

type
  TpjhBase = class(TPersistent)//TSQLRecord
  public
    procedure Assign(ASource: TPersistent); virtual;

    function LoadFromFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;virtual;
    function SaveToFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;virtual;
    procedure LoadFromFile_Thread(AApplication: TApplication; AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);
    procedure SaveToFile_Thread(AApplication: TApplication; AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);
    function LoadFromJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;
    function SaveToJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;
    function LoadFromJSONFile2(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;
    function SaveToJSONFile2(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;
    function LoadFromSqliteFile(ADBFileName: string): integer; virtual;
    function SaveToSqliteFile(ADBFileName: string; AItemIndex: integer=-1): integer; virtual;
    function LoadFromSqliteFile4Secure(ADBFileName: string): integer; virtual;
    function SaveToSqliteFile4Secure(ADBFileName: string; AItemIndex: integer=-1): integer; virtual;
    function LoadFromStream(AStream: TStream; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
    function SaveToStream(AStream: TStream; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
    function LoadFromRegistry(RootKey: HKEY; const Key, Name: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): Boolean;overload;
    function SaveToRegistry(RootKey: HKEY; const Key, Name: string; APassPhrase: string=''; AIsEncrypt: Boolean=False):Boolean; overload;
    function LoadFromString(AString: RawByteString; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
//    function SaveToString(AStream: TStream; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;

    function StreamToRegistry(Stream: TStream; RootKey: HKEY; const Key, Name: string): Boolean;
    function StreamFromRegistry(Stream: TStream; RootKey: HKEY; const Key, Name: string): Boolean;
    function AsHashString: string;
    function CheckHashString(AHashedStr: string): Boolean;
  end;

implementation

uses JvgXMLSerializer_Encrypt, UnitEncrypt, UnitCryptUtil;

function TpjhBase.StreamToRegistry(Stream: TStream; RootKey: HKEY; const Key, Name: string): Boolean;
var
  Reg: TRegistry;
  Buf: Pointer;
  Size: Cardinal;
begin
  Result := True;
  Buf := nil;
  try
    Stream.Position := 0;
    Size := Stream.Size - Stream.Position;
    if Size > 0 then
    begin
      Buf := AllocMem(Size);
      Stream.Read(Buf^, Size);
    end;

   // Daten in Registry schreiben
    if Size > 0 then
    begin
      Reg := TRegistry.Create;
      try
        Reg.RootKey := RootKey;
        if Reg.OpenKey(Key, True) then
        begin
          Reg.WriteBinaryData(Name, Buf^, Size);
          Reg.CloseKey;
        end else Result := False;
      finally
        Reg.Free;
      end;
    end;
  finally
    if Assigned(Buf) then FreeMem(Buf);
  end;
end;

function TpjhBase.StreamFromRegistry(Stream: TStream; RootKey: HKEY; const Key, Name: string): Boolean;
var
  Reg: TRegistry;
  Buf: Pointer;
  Size: Cardinal;
begin
  Result := False;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKeyReadOnly(Key) then
    begin
      if (Reg.ValueExists(Name)) and (Reg.GetDataType(Name) = rdBinary) then
      begin
        Result := True;
        Size := Reg.GetDataSize(Name);
        if Size > 0 then
        begin
          Buf := AllocMem(Size);
          try
            Stream.Position := 0;
            Reg.ReadBinaryData(Name, Buf^, Size);
            Stream.Write(Buf^, Size);
          finally
            FreeMem(Buf);
          end;
        end;
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

function TpjhBase.AsHashString: string;
begin
  Result := ObjectToJSON(Self);
  Result := GetSHA256HashStringFromSyn(Result);
end;

procedure TpjhBase.Assign(ASource: TPersistent);
var
  LDoc: variant;
begin
  TDocVariant.New(LDoc);
  LoadRecordPropertyToVariant(ASource, LDoc);
  LoadRecordPropertyFromVariant(Self, LDoc);
end;

function TpjhBase.CheckHashString(AHashedStr: string): Boolean;
var
  LOriginalStr: string;
begin
  LOriginalStr := ObjectToJSON(Self);
  Result := CheckSHA256HashStringFromSyn(LOriginalStr, AHashedStr);
end;

function TpjhBase.LoadFromFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
var
  LTJvgXMLSerializer_Encrypt: TJvgXMLSerializer_Encrypt;
begin
  if AFileName <> '' then
  begin
    LTJvgXMLSerializer_Encrypt := TJvgXMLSerializer_Encrypt.Create(nil);
    try
      //FpjhCollect.Clear;
      LTJvgXMLSerializer_Encrypt.LoadFromXMLFile(Self,AFileName,APassPhrase,AIsEncrypt);
    finally
      LTJvgXMLSerializer_Encrypt.Free;
    end;
  end
  else
    ;//ShowMessage('File name is empty!');
end;

procedure TpjhBase.LoadFromFile_Thread(AApplication: TApplication; AFileName, APassPhrase: string;
  AIsEncrypt: Boolean);
begin
//  AsyncHelper.MaxThreads := 2 * System.CPUCount;
//  AsyncHelper.AddTask(TAsyncCalls.Invoke<string, string, Boolean>(LoadFromFile, AFileName, APassPhrase, AIsEncrypt));
//  while NOT AsyncHelper.AllFinished do AApplication.ProcessMessages;
end;

function TpjhBase.LoadFromJSONFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
var
  LStrList: TStringList;
  LValid: Boolean;
  LString: RawUTF8;
  Fs: TFileStream;
  LMemStream: TMemoryStream;
begin
  Result := -1;
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
    JSONToObject(Self, PUTF8Char(LString), LValid, nil, [j2oIgnoreUnknownProperty]);
    Result := 0;
  finally
    LStrList.Free;
  end;
end;

function TpjhBase.LoadFromJSONFile2(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
var
  LStrList: TStringList;
  LValid: Boolean;
  LRaw: RawByteString;
  LString: RawUTF8;
  Fs: TFileStream;
  LMemStream: TMemoryStream;
begin
  Result := -1;

  LStrList := TStringList.Create;
  try
    if AIsEncrypt then
    begin
      LRaw := StringFromFile(AFileName);
      LRaw := DecryptString_Syn2(LRaw, APassPhrase);
      LStrList.Text := UTF8ToString(LRaw);
    end
    else
    begin
      LStrList.LoadFromFile(AFileName);
    end;

    SetLength(LString, Length(LStrList.Text));
    LString := StringToUTF8(LStrList.Text);
    JSONToObject(Self, PUTF8Char(LString), LValid, nil, [j2oIgnoreUnknownProperty]);
    Result := 0;
  finally
    LStrList.Free;
  end;
end;

function TpjhBase.LoadFromRegistry(RootKey: HKEY; const Key, Name: string;
  APassPhrase: string; AIsEncrypt: Boolean): Boolean;
var
  LStrList: TStringList;
  LValid: Boolean;
  LString: RawUTF8;
  LMemStream, LMemStream2: TMemoryStream;
begin
  Result := False;
  LStrList := TStringList.Create;
  LMemStream2 := TMemoryStream.Create;
  try
    if StreamFromRegistry(LMemStream2, RootKey, Key, Name) then
    begin
      if AIsEncrypt then
      begin
        LMemStream := TMemoryStream.Create;
        try
          LMemStream2.Position := 0;
          DecryptStream(LMemStream2, LMemStream, APassphrase);
          LMemStream.Position := 0;
          LStrList.LoadFromStream(LMemStream);
        finally
          LMemStream.Free;
        end;

      end
      else
      begin
        LStrList.LoadFromStream(LMemStream2);
      end;

      SetLength(LString, Length(LStrList.Text));
      LString := AnsiString(LStrList.Text);
      JSONToObject(Self, Pointer(LString), LValid, nil, [j2oIgnoreUnknownProperty]);
      Result := True;
    end;
  finally
    LStrList.Free;
    LMemStream2.Free;
  end;
end;

function TpjhBase.LoadFromSqliteFile(ADBFileName: string): integer;
begin

end;

function TpjhBase.LoadFromSqliteFile4Secure(ADBFileName: string): integer;
begin

end;

function TpjhBase.LoadFromStream(AStream: TStream; APassPhrase: string;
  AIsEncrypt: Boolean): integer;
var
  LStrList: TStringList;
  LValid: Boolean;
  LString: RawUTF8;
  LMemStream: TMemoryStream;
begin
  Result := -1;

  LStrList := TStringList.Create;
  try
    if AIsEncrypt then
    begin
      LMemStream := TMemoryStream.Create;
      try
        DecryptStream(AStream, LMemStream, APassphrase);
        LMemStream.Position := 0;
        LStrList.LoadFromStream(LMemStream);
      finally
        LMemStream.Free;
      end;

    end
    else
    begin
      LStrList.LoadFromStream(AStream);
    end;

    SetLength(LString, Length(LStrList.Text));
    LString := AnsiString(LStrList.Text);
    JSONToObject(Self, Pointer(LString), LValid, nil, [j2oIgnoreUnknownProperty]);

    if LValid then
      Result := 0;
  finally
    LStrList.Free;
  end;
end;

function TpjhBase.LoadFromString(AString: RawByteString; APassPhrase: string;
  AIsEncrypt: Boolean): integer;
var
  LStrList: TStringList;
  LValid: Boolean;
  LString: RawByteString;
  LMemStream: TMemoryStream;
//  LSrcStream: TFileStream;
  LSrcStream: TStringStream;
begin
  Result := -1;

  LStrList := TStringList.Create;
  LSrcStream := TStringStream.Create('');
//  LSrcStream := TFileStream.Create('E:\pjh\project\util\HiMECS\Application\Bin\Log\Host\HiMECS.irf2', fmOpenRead);
  try
//     if LSrcStream.Size>0 then
//     begin
//      SetLength(LString, LSrcStream.Size);
//      LSrcStream.Read(Pointer(LString)^, LSrcStream.Size);
//     end;
//    LString := StringToAnsi7(AString);
    LSrcStream.Write(AString[1], ByteLength(AString));
//    WriteString2Stream(AString, LSrcStream);
//    LSrcStream.Write(AString[1], ByteLength(AString));
    LSrcStream.Position := 0;
//    LString := StreamToRawByteString(LSrcStream);

    if AIsEncrypt then
    begin
      LMemStream := TMemoryStream.Create;
      try
        DecryptStream(LSrcStream, LMemStream, APassphrase);
        LMemStream.Position := 0;
        LStrList.LoadFromStream(LMemStream);
      finally
        LMemStream.Free;
      end;
    end
    else
    begin
      LStrList.LoadFromStream(LSrcStream);
    end;

    SetLength(LString, Length(LStrList.Text));
    LString := AnsiString(LStrList.Text);
    JSONToObject(Self, Pointer(LString), LValid, nil, [j2oIgnoreUnknownProperty]);

    if LValid then
      Result := 0;
  finally
    LSrcStream.Free;
    LStrList.Free;
  end;
end;

function TpjhBase.SaveToFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
var
  LTJvgXMLSerializer_Encrypt: TJvgXMLSerializer_Encrypt;
begin
  if AFileName <> '' then
  begin
    LTJvgXMLSerializer_Encrypt := TJvgXMLSerializer_Encrypt.Create(nil);
    try
      //FpjhCollect.Clear;
      LTJvgXMLSerializer_Encrypt.SaveToXMLFile(Self,AFileName,APassPhrase,AIsEncrypt);
    finally
      LTJvgXMLSerializer_Encrypt.Free;
    end;
  end
  else
    ;//ShowMessage('File name is empty!');
end;

procedure TpjhBase.SaveToFile_Thread(AApplication: TApplication; AFileName,
  APassPhrase: string; AIsEncrypt: Boolean);
begin
//  AsyncHelper.MaxThreads := 2 * System.CPUCount;
//  AsyncHelper.AddTask(TAsyncCalls.Invoke<string, string, Boolean>(SaveToFile, AFileName, APassPhrase, AIsEncrypt));
//  while NOT AsyncHelper.AllFinished do AApplication.ProcessMessages;
end;

function TpjhBase.SaveToJSONFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
var
  LStrList: TStringList;
  LMemStream: TMemoryStream;
  Fs: TFileStream;
  LStr: RawUTF8;
begin
  LStrList := TStringList.Create;
  try
    LStr := ObjectToJSON(Self);
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

function TpjhBase.SaveToJSONFile2(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
var
  LStrList: TStringList;
  LMemStream: TMemoryStream;
  Fs: TFileStream;
  LStr: RawUTF8;
begin
  LStr := ObjectToJSON(Self);

  if AIsEncrypt then
  begin
    LStr := EncryptString_Syn2(LStr, APassPhrase);
    FileFromString(LStr, AFileName);
  end
  else
  begin
    LStrList := TStringList.Create;
    try
      LStrList.Add(UTF8ToString(LStr));
      LStrList.SaveToFile(AFileName);
    finally
      LStrList.Free;
    end;
  end;
end;

function TpjhBase.SaveToRegistry(RootKey: HKEY; const Key, Name: string;
  APassPhrase: string; AIsEncrypt: Boolean): Boolean;
var
  LStrList: TStringList;
  LMemStream, LMemStream2: TMemoryStream;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add(ObjectToJSON(Self));
    LMemStream := TMemoryStream.Create;
    LMemStream2 := TMemoryStream.Create;
    try
      if AIsEncrypt then
      begin
        LStrList.SaveToStream(LMemStream);
        LMemStream.Position := 0;
        EncryptStream(LMemStream, LMemStream2, APassphrase);
      end
      else
        LStrList.SaveToStream(LMemStream2);

      Result := StreamToRegistry(LMemStream2, RootKey, Key, Name);
    finally
      LMemStream2.Free;
      LMemStream.Free;
    end;
  finally
    LStrList.Free;
  end;
end;

function TpjhBase.SaveToSqliteFile(ADBFileName: string;
  AItemIndex: integer): integer;
begin

end;

function TpjhBase.SaveToSqliteFile4Secure(ADBFileName: string;
  AItemIndex: integer): integer;
begin

end;

function TpjhBase.SaveToStream(AStream: TStream; APassPhrase: string;
  AIsEncrypt: Boolean): integer;
var
  LStrList: TStringList;
  LMemStream: TMemoryStream;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add(ObjectToJSON(Self));
    LMemStream := TMemoryStream.Create;
    try
      if AIsEncrypt then
      begin
        LStrList.SaveToStream(LMemStream);
        LMemStream.Position := 0;
        EncryptStream(LMemStream, AStream, APassphrase);
      end
      else
        LStrList.SaveToStream(AStream);
        
    finally
      LMemStream.Free;
    end;
  finally
    LStrList.Free;
  end;
end;

end.


