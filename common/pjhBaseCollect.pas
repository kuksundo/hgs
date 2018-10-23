unit pjhBaseCollect;

interface

uses Winapi.Windows, AsyncCalls, AsyncCallsHelper, classes, SysUtils, Forms, Registry,
      SynCommons, mORMot;

type
  TpjhBaseCollect = class(TSynPersistent)
  public
    function LoadFromFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
    function SaveToFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
    procedure LoadFromFile_Thread(AApplication: TApplication; AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);
    procedure SaveToFile_Thread(AApplication: TApplication; AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);
    function LoadFromJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;
    function SaveToJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;
    function LoadFromStream(AStream: TStream; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
    function SaveToStream(AStream: TStream; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
    procedure LoadFromRegistry(RootKey: HKEY; const Key, Name: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);overload;
    procedure SaveToRegistry(RootKey: HKEY; const Key, Name: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);overload;
  end;

implementation

uses UnitEncrypt;

function StreamToRegistry(Stream: TStream; RootKey: HKEY; const Key, Name: string): Boolean;
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

function StreamFromRegistry(Stream: TStream; RootKey: HKEY; const Key, Name: string): Boolean;
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

function TpjhBaseCollect.LoadFromFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
begin
//  if AFileName <> '' then
//  begin
//    LTJvgXMLSerializer_Encrypt := TJvgXMLSerializer_Encrypt.Create(nil);
//    try
//      //FpjhCollect.Clear;
//      LTJvgXMLSerializer_Encrypt.LoadFromXMLFile(Self,AFileName,APassPhrase,AIsEncrypt);
//    finally
//      LTJvgXMLSerializer_Encrypt.Free;
//    end;
//  end
//  else
//    ;//ShowMessage('File name is empty!');
end;

procedure TpjhBaseCollect.LoadFromFile_Thread(AApplication: TApplication; AFileName, APassPhrase: string;
  AIsEncrypt: Boolean);
begin
  AsyncHelper.MaxThreads := 2 * System.CPUCount;
  AsyncHelper.AddTask(TAsyncCalls.Invoke<string, string, Boolean>(LoadFromFile, AFileName, APassPhrase, AIsEncrypt));
  while NOT AsyncHelper.AllFinished do AApplication.ProcessMessages;
end;

function TpjhBaseCollect.LoadFromJSONFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
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

procedure TpjhBaseCollect.LoadFromRegistry(RootKey: HKEY; const Key, Name: string;
  APassPhrase: string; AIsEncrypt: Boolean);
var
  LStrList: TStringList;
  LValid: Boolean;
  LString: RawUTF8;
  LMemStream, LMemStream2: TMemoryStream;
begin
  LStrList := TStringList.Create;
  LMemStream2 := TMemoryStream.Create;
  try
    StreamFromRegistry(LMemStream2, RootKey, Key, Name);

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
    JSONToObject(Self, Pointer(LString), LValid);
  finally
    LStrList.Free;
    LMemStream2.Free;
  end;
end;

function TpjhBaseCollect.LoadFromStream(AStream: TStream; APassPhrase: string;
  AIsEncrypt: Boolean): integer;
var
  LStrList: TStringList;
  LValid: Boolean;
  LString: RawUTF8;
  LMemStream: TMemoryStream;
begin
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
    JSONToObject(Self, Pointer(LString), LValid);
  finally
    LStrList.Free;
  end;
end;

function TpjhBaseCollect.SaveToFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
begin
//  if AFileName <> '' then
//  begin
//    LTJvgXMLSerializer_Encrypt := TJvgXMLSerializer_Encrypt.Create(nil);
//    try
//      //FpjhCollect.Clear;
//      LTJvgXMLSerializer_Encrypt.SaveToXMLFile(Self,AFileName,APassPhrase,AIsEncrypt);
//    finally
//      LTJvgXMLSerializer_Encrypt.Free;
//    end;
//  end
//  else
//    ;//ShowMessage('File name is empty!');
end;

procedure TpjhBaseCollect.SaveToFile_Thread(AApplication: TApplication; AFileName,
  APassPhrase: string; AIsEncrypt: Boolean);
begin
  AsyncHelper.MaxThreads := 2 * System.CPUCount;
  AsyncHelper.AddTask(TAsyncCalls.Invoke<string, string, Boolean>(SaveToFile, AFileName, APassPhrase, AIsEncrypt));
  while NOT AsyncHelper.AllFinished do AApplication.ProcessMessages;
end;

function TpjhBaseCollect.SaveToJSONFile(AFileName, APassPhrase: string;
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

procedure TpjhBaseCollect.SaveToRegistry(RootKey: HKEY; const Key, Name: string;
  APassPhrase: string; AIsEncrypt: Boolean);
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

      StreamToRegistry(LMemStream2, RootKey, Key, Name);
    finally
      LMemStream2.Free;
      LMemStream.Free;
    end;
  finally
    LStrList.Free;
  end;
end;

function TpjhBaseCollect.SaveToStream(AStream: TStream; APassPhrase: string;
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
