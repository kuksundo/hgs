unit LoggerU;

interface

uses
  Windows, Messages, SysUtils, Variants, Dialogs, Classes, ComCtrls;

type
  ELogError = class(Exception);

type
  TLog = class(TComponent)
  private
    FActive : Boolean;
    FAppend : Boolean;
    FFileName : TFilename;
    FLogFile : TextFile;
    FLastMessage : String;
    FLastMessageCount : Integer;
    FLogCache : TStringList;
    FCacheSize : Integer;
  protected
    procedure SetFileName(Value : TFileName);
    procedure SetActive(Value : Boolean);
    function IsValidFileName(AFileName : TFileName) : Boolean;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(AMessage : String);
  published
    property Active : Boolean read FActive write SetActive;
    property AppendLog : Boolean read FAppend write FAppend default False;
    property FileName : TFileName read FFilename write SetFileName;
    property CacheSize : Integer read FCacheSize write FCacheSize;
    property LogCache : TStringList read FLogCache;
end;

procedure Register;

implementation

constructor TLog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLogCache := TStringList.Create;
  FCacheSize := 50;
end;

destructor TLog.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FLogCache);
end;

function TLog.IsValidFileName(AFileName : TFileName) : Boolean;
var
  TestFile : TextFile;
begin
  if not FileExists(AFileName) then
    begin
      {$I-}
      AssignFile(TestFile, AFileName);
      Rewrite(TestFile);
      CloseFile(TestFile);
      {$I+}
      Result := IOResult = 0;
      if FileExists(AFileName) then DeleteFile(AFileName);
    end else
    begin
      Result := True;
    end;
end;

procedure TLog.SetActive(Value : Boolean);
begin
  if Value <> FActive then
    begin
      if Value then
        begin
          AssignFile(FLogFile, FFileName);
          if (FileExists(FFileName)) and (FAppend = True) then
            begin
              Append(FLogFile);
            end else
            begin
              Rewrite(FLogFile);
            end;
          Flush(FLogFile);
          Writeln(FLogFile,'----------------------------| Log Start ' + DateTimeToStr(Now) + '|----------------------------');
          Flush(FLogFile);
          FLastMessage := '';
          FLastMessageCount := 0;
          FLogCache.Clear;
          FLogCache.Add('----------------------------| Log Start ' + DateTimeToStr(Now) + '|----------------------------');
          FActive := True;
        end else
        begin
          Flush(FLogFile);
          Writeln(FLogFile,'----------------------------| Log End ' + DateTimeToStr(Now) + '|----------------------------');
          Flush(FLogFile);
          CloseFile(FLogFile);
          FLogCache.Add('----------------------------| Log End ' + DateTimeToStr(Now) + '|----------------------------');
          FActive := False;
        end;
    end;
end;

procedure TLog.SetFileName(Value : TFileName);
begin
  SetActive(False);
  if not FActive then
    begin
      if IsValidFileName(Value) then FFileName := Value;
    end else
    begin
      raise ELogError.CreateFmt('"%s" is not a valid filename',[Value]);
    end;
end;

procedure TLog.Clear;
begin
  CloseFile(FLogFile);
  AssignFile(FLogFile, FFileName);
  Rewrite(FLogFile);
end;

procedure TLog.Add(AMessage : String);
var
  LogMessage : String;
begin
  if FActive then
    begin
      LogMessage := AMessage;
      LogMessage := StringReplace(LogMessage,#13,'',[rfReplaceAll]);
      LogMessage := StringReplace(LogMessage,#10,' ',[rfReplaceAll]);
      if LogMessage <> '' then
        begin
          if LogMessage <> FLastMessage then
            begin
              While FLogCache.Count > FCacheSize do
                begin
                  FLogCache.Delete(FLogCache.Count - 1);
                end;
              if FLastMessageCount > 0 then
                begin
                  Writeln(FLogFile,DateTimeToStr(Now) + ': ' + Format('Last message repeated %d time(s)',[FLastMessageCount]));
                  FLogCache.Insert(0,DateTimeToStr(Now) + ': ' + Format('Last message repeated %d time(s)',[FLastMessageCount]));
                end;
              Flush(FLogFile);
              Writeln(FLogFile,DateTimeToStr(Now) + ': ' + LogMessage);
              FLogCache.Insert(0,DateTimeToStr(Now) + ': ' + LogMessage);
              Flush(FLogFile);
              FLastMessage := LogMessage;
              FLastMessageCount := 0;
            end else
            begin
              Inc(FLastMessageCount);
            end;
        end;
    end else
    begin
      raise ELogError.Create('Log is not active.');
    end;
end;

end.
