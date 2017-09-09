unit UtilUnit;

interface

uses Windows, SysUtils, classes, Vcl.Forms, Vcl.Dialogs, Vcl.Controls, iniFiles;

type
  C_CharSet = Set of Char;
  PC_CharSet = ^C_CharSet;

const
  csNumeric = ['0'..'9'];
  csHexDigit= csNumeric + ['A'..'F', 'a'..'f'];

function ReplaceStr(Str, SearchStr, ReplaceStr : String) : String;
function strToken(var S: String; Seperator: Char): String;
function strTokenCount(S: String; Seperator: Char): Integer;
function  NPos(const C: string; S: string; StartPos,Length: Integer): Integer;
function String2HexByteAry(str1: string; var Buf: array of byte): integer;
function StrPMatchLen(const S: PAnsiChar; const C: C_CharSet;
    const Len: Integer): Integer;
function StrIsNumeric(const S: AnsiString): Boolean;
function StrIsHex(const S: AnsiString): Boolean;
Function PadLeft(St:String;Ch:Char;L:Integer): String;
function TryName(const Test:string;Comp:TComponent):Boolean;
function UniqueName(Comp:TComponent):string;
function ReadDFM(Form: TForm; const DFMName:string): integer;
function ReadFormAsText(const DFMName:string; Form: TForm):TForm;
function File_Open_Append(FileName:string;var Data:String;
                      AppendPosition:integer;IsUpdate:Boolean): Boolean;
procedure CreateShowModal(FormClass:TFormClass);
procedure DeleteAllComponents(ParentControl: TWinControl);
procedure SaveToDFM(const FileName: string; ParentControl: TWinControl);
function LoadFromDFM(const FileName: string; ParentControl: TWinControl): integer;
function InsertStringAtCursor(ASourceString, AInsertString: string; APos: integer): string;
function ExtractRelativePathBaseApplication(AApplicationPath, AFileNameWithPath: string): string;
function EnumModulesFunc(HInstance: NativeInt; Data: Pointer): Boolean;
procedure SaveComponentToFile(Component: TComponent; const FileName: TFileName);
procedure LoadComponentFromFile(Component: TComponent; const FileName: TFileName);

var Signature: packed array[0..3] of Char = ('P', 'A', 'R', 'K');

implementation

uses pjhClasses;

// simple replacement for strings
function ReplaceStr(Str, SearchStr, ReplaceStr : String) : String;
begin
  While pos(SearchStr, Str) <> 0 do
  begin
    Insert(ReplaceStr, Str, pos(SearchStr, Str));
    Delete(Str, pos(SearchStr, Str), Length(SearchStr));
  end;
  Result := Str;
end;

function strToken(var S: String; Seperator: Char): String;
var
  I: Word;
begin
  I:=Pos(Seperator,S);
  if I<>0 then
  begin
    Result:=System.Copy(S,1,I-1);
    System.Delete(S,1,I);
  end else
  begin
    Result:=S;
    S:='';
  end;
end;

function strTokenCount(S: String; Seperator: Char): Integer;
begin
  Result:=0;
  while S<>'' do begin
    StrToken(S,Seperator);
    Inc(Result);
  end;
end;

// 문자열S의 N번째 문자부터 Length까지의 문자열에 C문자열이 있는지 검사한다.
function NPos(const C: string; S: string; StartPos,Length: Integer): Integer;
var
  I: Integer;
  S1:string;
begin
  Result := 0;
  if (S = '') then Exit;
  S1:= Copy(S,StartPos,Length);
  I:=Pos(UpperCase(C),UpperCase(S1));
  if I>0 then Result:= I+StartPos;
end;

// Char를 Byte값으로 변환한다..
function AtoX(Ch : Char): Byte;
var
  Check: Byte;
begin
  Check := Byte(Ch);

  if(Check >= Byte('0')) and (Check <= Byte('9')) then
  begin
    Result := Check-Byte('0');
    Exit;
  end
  else
  begin
    Result := Check-Byte('A')+Byte(10);
    Exit;
  end;
end;

//----------------------------------------------------------------------------------
// String을 Hex값으로 바꾼다.(Byte 단위 계산임)
function Str2Hex_Byte(szStr: string): Byte;
begin
  szStr := UpperCase(szStr);
  Result := ((AtoX(szStr[1]) shl 4)  or (AtoX(szStr[2])));
end;

//두자리가 한개의 헥사값을 가짐.
function String2HexByteAry(str1: string; var Buf: array of byte): integer;
var
  i,j: integer;
begin
  j := Length(str1);
  Result :=  j div 2;
  //길이가 홀수 일경우 앞에 0을 추가함(두자리가 한개의 헥사값이므로)
  if Odd(j) then
  begin
    Inc(Result);
    Str1 := '0' + str1;
  end;

  for i := 0 to Result - 1 do
    Buf[i] := Str2Hex_Byte(str1[i*2+1] + str1[i*2+2]);
end;

function StrPMatchLen(const S: PAnsiChar; const C: C_CharSet;
    const Len: Integer): Integer;
var P: PAnsiChar;
    L: Integer;
begin
  P := S;
  L := Len;
  Result := 0;
  While L > 0 do
    if P^ in C then
      begin
        Inc(P);
        Dec(L);
        Inc(Result);
      end else
      exit;
end;

//스트링이 숫자로 구성되어 있으면 True를 반환함
function StrIsNumeric(const S: AnsiString): Boolean;
var L: Integer;
begin
  L := Length(S);
  Result := (L > 0) and (StrPMatchLen(Pointer(S), csNumeric, L) = L);
end;

function StrIsHex(const S: AnsiString): Boolean;
var L: Integer;
begin
  L := Length(S);
  Result := (L > 0) and (StrPMatchLen(Pointer(S), csHexDigit, L) = L);
end;

//주어진 스트링의 왼쪽에 인자로 주어진 문자를 반복해서 붙인다.
Function PadLeft(St:String;Ch:Char;L:Integer): String;
Var
   TempStr:String;
   I:Integer;

Begin
   I:=Length(St);
   If I>=L Then Result:=Copy(St,1,L)
   Else Begin
      Setlength(TempStr,L);
      FillChar(TempStr[I+1],L-I,Ch);
      Move(St[1],TempStr[1],I);
      Result:=TempStr;
   End;
End;

{컴퍼넌트 이름이 유일한지 테스트 해보고, 만일 유일하다면 True를 리턴하고, 아니면
 False를 리턴한다.}
function TryName(const Test: string; Comp: TComponent): Boolean;
var I:Integer;
begin
  Result:=False;

  for I:=0 to Comp.ComponentCount-1 do
    if CompareText(Comp.Components[I].Name,Test) =0 then Exit;

  Result:=True;
end;

{표준 델파이의 원칙을 사용하여 컴퍼넌트에 대한 유일한 이름을 생성한다.
 즉 <타입><숫자> 형식을 사용하는데, <타입>은 컴퍼넌트의 클래스 이름에서 'T'를
 뺀 것이고, <숫자>는 이름을 단일하게 만들기 위한 정수이다.}
function UniqueName(Comp: TComponent): string;
var
  I:Integer;
  Fmt:string;
begin
  if Comp.ClassName[1] in ['t','T'] then
    Fmt:=Copy(Comp.ClassName,2,255)+'%d'
  else Fmt:=Comp.ClassName+'%d';

  if Comp.Owner = nil then
  begin
    {소유자가 없으므로 모든 이름이 동일하다. 1을 사용한다.}
    Result:=Format(Fmt,[1]);
    Exit;
  end
  else
  begin
    {유일한 이름이 나올 때까지 , 가능한 숫자를 모두 시험한다.}
    for I:=1 to High(Integer) do
    begin
      Result:=Format(Fmt,[I]);
      if TryName(Result,Comp.Owner) then Exit;
    end;
  end;
end;

function ReadFormAsText(const DFMName: string; Form: TForm): TForm;
var
  Input,Output:TMemoryStream;
  TempFormFileName: string;
begin
  Result:= nil;
  Input:= TMemoryStream.Create;
  Input.LoadFromFile(DFMName);
  Output:= TMemoryStream.Create;
  ObjectTextToResource(Input,Output);
  Output.SaveToFile(TempFormFileName);
  Output.LoadFromFile(TempFormFileName);

  Output.Position:=0;
 // ReadClass;
  try
    Output.ReadComponentRes(Form);
  finally
    Input.Free;
    OutPut.Free;
  end;

  Result:= Form;
end;

function ReadDFM(Form: TForm; const DFMName: string): integer;
var
  Stream:TFileStream;
  DFMDataLen, LPosition:Integer;
  Reader:TReader;
  Flags:TFilerFlags;
  TypeName:string;
  //Form:TForm;
  Temp: Longint;
  RCType: Word;
  ret: word;

  LI: Longint;
  LB: Byte;
begin
  Result := 0;

  if not FileExists(DFMName) then
  begin
    Result := 1;
    Exit;
  end;

  try
    Stream:= TFileStream.Create(DFMName, fmOpenRead);
   //Stream.Read(LI, SizeOf(Longint));
   //if LI <> Longint(Signature) then
   //   raise Exception.Create('File "' + ExtractFileName(DFMName) +
   //     '" is not a Logic Form File');
   // Stream.Read(LB, SizeOf(Byte));
    Reader:= TReader.Create(Stream, Stream.Size);
    with Reader do
    begin
      Root:= Form;

      try
        BeginReferences;
        Read(RCType, SizeOf(RCType));

        if RcType <> $0AFF then
        // invalid file format or Delphi 5 form(text form file)
        begin
          if Reader <> nil then Reader.Free;
          if Stream <> nil then Stream.Free;
          //ret:= MessageDlg('This is not Logic Form!' +#10#13 +
          //    'Do you want read this form as text?', mtWarning, [mbYes, mbNo], 0);
          //if ret = mrYes then ReadFormAsText(DFMName, Form);
          ShowMessage('This is not Logic Form!');
          Exit;
        end;

        Position:= 3;                          // Resource Type

        while ReadValue <> vaNull do;          // Form Name

        Position:= Position + 2;        // Resource Flag($3010)
        Read(DFMDataLen, SizeOf(DFMDataLen));  // Resource Size
        ReadSignature;                         // 델파이 폼 식별 기호 ('TPF0')
        //ReadPrefix(Flags, LPosition);           // 폼 계승 여부 구별(ffInherited, ffChildPos)
        //Temp:= Position;
        //TypeName:= ReadStr;                    // Form Class Name (TForm1)
        //Self.Name := Reader.ReadStr;                  // Form Name (Form1)
        //Self.ClassName := Reader.ReadStr;                  // Form Name (Form1)
        //RenameSubClass(Form, TypeName);               // 폼의 ClassName을 재설정한다.
        //Position:= Temp;
        //Reader.OnFindMethod:= Self.OnFindMethodHandler;
        //Reader.OnError:= Self.OnReaderErrorHandler;
        ReadComponent(Form);         
      finally//error가 났을 경우에 다시 파일을 오픈 할 수 있도록 하기 위해
        FixupReferences;
        EndReferences;

        if Reader <> nil then
          Reader.Free;
        if Stream <> nil then
          Stream.Free;
      end;//try
    end;//with
  except
    on EClassNotFound do Result := 3;
  end;

end;

function FileAppend(hFile, AppendPosition: Integer; Data: String): Boolean;
var
  BWrite: word;
  Buffer: RawByteString;
begin
  if hFile > 0 then
  begin
    if FileSeek(hFile,0,AppendPosition) <> HFILE_ERROR then
    begin
      try
        Buffer := PChar(Data+#13+#10);
        BWrite:=FileWrite(hFile,Buffer[1],Length(Buffer));
        if BWrite = Sizeof(Data) then
          Result := True
        else
          Result := False;
      finally
      end;
    end;
  end;
end;

function File_Open_Append(FileName:string;var Data:String;
                      AppendPosition:integer;IsUpdate:Boolean): Boolean;
var hFile: integer;
    //Buffer: Pointer;
    //BWrite: word;
begin
  SetCurrentDir(ExtractFilePath(Application.exename));
  try
    if FileExists(FileName) then
    begin
      if IsUpdate then
      begin
        if DeleteFile(FileName) then
          hFile := FileCreate(FileName);
      end
      else
        hFile := FileOpen(FileName,fmOpenWrite+fmShareDenyNone);  { Open Source }
    end
    else
      hFile := FileCreate(FileName);

    Result := FileAppend(hFile,AppendPosition,data);
  finally
    if hFile > 0 then
      FileClose(hFile);
  end;

end;

procedure CreateShowModal(FormClass:TFormClass);
begin
  Screen.Cursor:=crHourGlass;

  with FormClass.Create(Application) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;

  Screen.Cursor:=crDefault;
end;

procedure DeleteAllComponents(ParentControl: TWinControl);
var
  I: Integer;
begin
  // Delete controls from ParentControl
  I := 0;
  // (rom) added Assigned for security
  if Assigned(ParentControl) then
  begin
    while I < ParentControl.ControlCount do
    begin
      //if ParentControl.Controls[I] is TJvCustomDiagramShape then
        ParentControl.Controls[I].Free;
        // Note that there is no need to increment the counter, because the
        // next component (if any) will now be at the same position in Controls[]
      //else
        Inc(I);
    end;
  end;
end;

procedure SaveToDFM(const FileName: string; ParentControl: TWinControl);
var
  FS: TFileStream;
  Writer: TWriter;
  RealName: string;
begin
  FS := TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
  Writer := TWriter.Create(FS, 4096);
  try
    Writer.Root := ParentControl;//.Owner;
    RealName := ParentControl.Name;
    ParentControl.Name := '';
    Writer.WriteComponent(ParentControl);
    ParentControl.Name := RealName;
  finally
    Writer.Free;
    FS.Free;
  end;
end;

function LoadFromDFM(const FileName: string; ParentControl: TWinControl): integer;
var
  FS: TFileStream;
  Reader: TReader;
  RealName: string;
begin
  Result := 0;

  if not FileExists(FileName) then
  begin
    Result := 1;
    Exit;
  end;

  DeleteAllComponents(ParentControl);
  FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  Reader := TReader.Create(FS, 4096);
  try
    // Save the parent's name, in case we are reading into a different
    // control than we saved the diagram from
    RealName := ParentControl.Name;
    Reader.Root := ParentControl;//.Owner;
    Reader.BeginReferences;
    Reader.ReadComponent(ParentControl);
    Reader.FixupReferences;
    // Restore the parent's name
    ParentControl.Name := RealName;
  finally
    Reader.EndReferences;
    Reader.Free;
    FS.Free;
  end;
end;

//ASourceString의 APos 위치에 AInsertString을 삽입함
function InsertStringAtCursor(ASourceString, AInsertString: string; APos: integer): string;
var
  LStr, LStr2: string;
begin
  LStr := Copy(ASourceString, 1, APos);
  LStr2 := Copy(ASourceString, APos+1, Length(ASourceString));
  Result := LStr + AInsertString + LStr2;
end;

//Application.exename을 기준으로 AFilePath의 상대 경로를 반환함
//'.\'을 포함함
function ExtractRelativePathBaseApplication(AApplicationPath, AFileNameWithPath: string): string;
begin
  Result := IncludeTrailingBackslash(ExtractRelativePath(
                      ExtractFilePath(AApplicationPath),
                      ExtractFilePath(AFileNameWithPath))) +
                      ExtractFileName(AFileNameWithPath);

  if Result[1] = '\' then
    Result := '.'+ Result;
  {else
  if Pos('.\', Result) = 0 then
  begin
    if Result[1] = '\' then
      Result := '.' + Result
    else
      Result := '.\' + Result;
  end;    }
end;

function EnumModulesFunc(HInstance: NativeInt; Data: Pointer): Boolean;
var Buff:array[0..1023] of char;
begin
  if GetModuleFileName(HInstance, @Buff, SizeOf(Buff)) = ERROR_INSUFFICIENT_BUFFER then
    Buff[High(Buff)] := #0;
  TStringList(Data).Add(Buff);
end;

procedure SaveComponentToFile(Component: TComponent; const FileName: TFileName);
var
  FileStream : TFileStream;
  MemStream : TMemoryStream;
begin
  MemStream := nil;

  if not Assigned(Component) then
    raise Exception.Create('Component is not assigned');

  FileStream := TFileStream.Create(FileName,fmCreate);
  try
    MemStream := TMemoryStream.Create;
    MemStream.WriteComponent(Component);
    MemStream.Position := 0;
    ObjectBinaryToText(MemStream, FileStream);
  finally
    MemStream.Free;
    FileStream.Free;
  end;
end;

procedure LoadComponentFromFile(Component: TComponent; const FileName: TFileName);
var
  FileStream : TFileStream;
  MemStream : TMemoryStream;
  i: Integer;
begin
  MemStream := nil;

  if not Assigned(Component) then
    raise Exception.Create('Component is not assigned');

  if FileExists(FileName) then
  begin
    FileStream := TFileStream.Create(FileName,fmOpenRead);
    try
      for i := Component.ComponentCount - 1 downto 0 do
      begin
        if Component.Components[i] is TControl then
          TControl(Component.Components[i]).Parent := nil;
        Component.Components[i].Free;
      end;

      MemStream := TMemoryStream.Create;
      ObjectTextToBinary(FileStream, MemStream);
      MemStream.Position := 0;
      MemStream.ReadComponent(Component);
      Application.InsertComponent(Component);
    finally
      MemStream.Free;
      FileStream.Free;
    end;
  end;
end;

end.
