unit u_TextFileIndexer;

interface

uses
  SysUtils,
  Classes,
  u_Int64List,
  u_dzCriticalSection;

type
  TTextFileIndexer = class
  private
    FCritSect: TdzCriticalSection;
    FLineIndexes: TInt64List;
    FIsDone: boolean;
    FFilename: string;
    FAbortRequested: Boolean;
    function GetLineIndex(_Idx: integer): Int64;
    function GetLineIndexCount: integer;
  public
    constructor Create(const _Filename: string);
    destructor Destroy; override;
    procedure Execute;
    procedure Abort;
    property LineIndex[_Idx: integer]: Int64 read GetLineIndex;
    property LineIndexCount: integer read GetLineIndexCount;
    property isDone: boolean read FIsDone;
  end;

implementation

uses
  u_dzFileStreams;

{ TTextFileIndexer }

constructor TTextFileIndexer.Create(const _Filename: string);
begin
  inherited Create;
  FLineIndexes := TInt64List.Create;
  FFilename := _Filename;
  FCritSect := TdzCriticalSection.Create;
end;

destructor TTextFileIndexer.Destroy;
begin
  FreeAndNil(FCritSect);
  FreeAndNil(FLineIndexes);
  inherited;
end;

procedure TTextFileIndexer.Execute;
const
  BUFFER_SIZE = 1024 * 128;
var
  st: TdzFile;
  buffer: array[0..BUFFER_SIZE - 1] of char;
  Offset: Int64;
  BytesRead: Integer;
  i: Integer;
begin
  FAbortRequested := False;
  FIsDone := False;
  st := TdzFile.Create(FFilename);
  try
    st.OpenReadonly;
    FCritSect.Enter;
    try
      FLineIndexes.Add(0);
    finally
      FCritSect.Leave;
    end;
    while not st.EOF do begin
      Offset := st.Position;
      BytesRead := st.Read(Buffer, SizeOf(Buffer));
      for i := 0 to BytesRead - 1 do
        if buffer[i] = #10 then begin
          FCritSect.Enter;
          try
            FLineIndexes.Add(Offset + i + 1);
          finally
            FCritSect.Leave;
          end;
        end;
      if FAbortRequested then
        SysUtils.Abort;
    end;
  finally
    FreeAndNil(st);
  end;
  FIsDone := true;
end;

function TTextFileIndexer.GetLineIndex(_Idx: integer): Int64;
begin
  FCritSect.Enter;
  try
    Result := FLineIndexes.Items[_Idx];
  finally
    FCritSect.Leave;
  end;
end;

function TTextFileIndexer.GetLineIndexCount: integer;
begin
  FCritSect.Enter;
  try
    Result := FLineIndexes.Count;
  finally
    FCritSect.Leave;
  end;
end;

procedure TTextFileIndexer.Abort;
begin
  FAbortRequested := true;
end;

end.

