unit DFMUtils;

interface

uses
   SysUtils, WinTypes, WinProcs, Classes, Consts,Dialogs,FILECTRL,
   Graphics,Controls,Forms;

procedure ReadDFM(Form:TForm; const DFMName:string);
procedure WriteDFM(Form:TForm;FormName:string);

implementation

function ReadFormAsText(const DFMName:string; Form: TForm):TForm;
var
   Input,Output:TMemoryStream;
   FileName: string;
begin
    Result:= nil;
    Input:= TMemoryStream.Create;
    Input.LoadFromFile(DFMName);
    Output:= TMemoryStream.Create;
    ObjectTextToResource(Input,Output);
    Output.SaveToFile(FilePath + TempForm);
    Output.LoadFromFile(FilePath + TempForm);

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

procedure SetupDFM(Form: TForm; const DFMName:string);
var
  Stream:TFileStream;
  DFMDataLen, Position:Integer;
  Reader:TReader;
  Flags:TFilerFlags;
  TypeName:string;
  Form:TForm;
  Temp: Longint;
  RCType: Word;
  ret: word;
begin
  try
    Stream:= TFileStream.Create(DFMName, fmOpenRead);
    LS.Read(LI, SizeOf(Longint));
    if LI <> Longint(Signature) then
      raise Exception.Create('File "' + ExtractFileName(DFMName) +
        '" is not a Logic Form File');
    LS.Read(LB, SizeOf(Byte));
    Reader:= TReader.Create(Stream, Stream.Size);
    Reader.Root:= Form;

    with Reader do
    begin
      try
        BeginReferences;
        Read(RCType, SizeOf(RCType));

        if RcType <> $0AFF then
        // invalid file format or Delphi 5 form(text form file)
        begin
          if Reader <> nil then Reader.Free;
          if Stream <> nil then Stream.Free;
          ret:= MessageDlg('This is not Delphi Form or Delphi 5 Form!' +#10#13 +
              'Do you want read this form as text?', mtWarning, [mbYes, mbNo], 0);
          if ret = mrYes then ReadFormAsText(DFMName, Form);
          Exit;
        end;

        Position:= 3;                          // Resource Type

        while ReadValue <> vaNull do;          // Form Name
          Position:= Position + 2;        // Resource Flag($3010)

        Read(DFMDataLen, SizeOf(DFMDataLen));  // Resource Size
        ReadSignature;                         // µ¨ÆÄÀÌ Æû ½Äº° ±âÈ£ ('TPF0')
        ReadPrefix(Flags, Position);           // Æû °è½Â ¿©ºÎ ±¸º°(ffInherited, ffChildPos)
        Temp:= Position;
        TypeName:= ReadStr;                    // Form Class Name (TForm1)
        // Form.Name:= Reader.ReadStr;                  // Form Name (Form1)
        RenameSubClass(Form, TypeName);               // ÆûÀÇ ClassNameÀ» Àç¼³Á¤ÇÑ´Ù.
        Position:= Temp;
        OnFindMethod:= TProxyForm(Form).OnFindMethodHandler;
        OnError:= TProxyForm(Form).OnReaderErrorHandler;
        ReadComponent(Form);
      finally
        FixupReferences;
        EndReferences;
      end;//try
    end;//with

    if Reader <> nil then Reader.Free;
    if Stream <> nil then Stream.Free;
  except
    on EClassNotFound do ;
  end;
end;

procedure ReadDFM(Form:TForm; const DFMName:string);
begin
   Result:= nil;
   if not FileExists(DFMName) then Exit;
   Result:= SetupDFM(Form, DFMName);
end;

procedure WriteDFM(Form:TForm;FormName:string);
var
  Output: TFileStream;
  ResName:string;
  I, Po:Integer;
  Writer:TWriter;
  HeaderSize: Integer;
  Origin, ImageSize: Longint;
  Header: array[0..79] of Char;
begin
    ResName:= Form.ClassName;
   // ResName:= FormName;
    try
      Output:= TFileStream.Create(FormName, fmCreate);
      Byte((@Header[0])^) := $FF;
      Word((@Header[1])^) := 10;
      HeaderSize := StrLen(StrUpper(StrPLCopy(@Header[3], ResName, 63))) + 10;
      Word((@Header[HeaderSize - 6])^) := $1030;
      Longint((@Header[HeaderSize - 4])^) := 0;
      Output.WriteBuffer(Header, HeaderSize);
      Po:= Output.Position;
      Writer:= TWriter.Create(Output, 4096);
      Writer.Position:= Po;
      Writer.WriteRootComponent(Form);
      // write dfm file size
      ImageSize := Writer.Position - Po;
      Writer.Position := Po - 4;
      Writer.Write(ImageSize, SizeOf(ImageSize));
      Writer.Position := Po + ImageSize;
    finally
      Writer.Free;
      Output.Free;
    end;
end;

end.
