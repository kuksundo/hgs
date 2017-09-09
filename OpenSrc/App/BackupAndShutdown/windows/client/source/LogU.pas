{ -----------------------------------------------------------------------------
  Unit Name: LogU
  Author: Tristan Marlow
  Purpose: Backup and Shutdown Log.

  ----------------------------------------------------------------------------
  License
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU Library General Public License as
  published by the Free Software Foundation; either version 2 of
  the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Library General Public License for more details.
  ----------------------------------------------------------------------------

  History: 04/05/2007 - First Release.

  ----------------------------------------------------------------------------- }
unit LogU;

interface

uses
  Windows, Messages, SysUtils, Variants, Dialogs, Classes;

type
  ELogError = class(Exception);

type
  TLog = class(TComponent)
  private
    FActive: Boolean;
    FAppend: Boolean;
    FFileName: TFilename;
    FLogFile: TextFile;
    FLastMessage: String;
    FLastMessageCount: Integer;
    FLogCache: TStringList;
    FCacheSize: Integer;
  protected
    procedure SetFileName(Value: TFilename);
    procedure SetActive(Value: Boolean);
    function IsValidFileName(AFileName: TFilename): Boolean;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(AMessage: String);
  published
    property Active: Boolean read FActive write SetActive;
    property AppendLog: Boolean read FAppend write FAppend default False;
    property FileName: TFilename read FFileName write SetFileName;
    property CacheSize: Integer read FCacheSize write FCacheSize;
    property LogCache: TStringList read FLogCache;
  end;

implementation

constructor TLog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLogCache := TStringList.Create;
  FCacheSize := 50;
end;

destructor TLog.Destroy;
begin
  FreeAndNil(FLogCache);
  inherited Destroy;
end;

function TLog.IsValidFileName(AFileName: TFilename): Boolean;
var
  TestFile: TextFile;
begin
  if not FileExists(AFileName) then
  begin
{$I-}
    AssignFile(TestFile, AFileName);
    Rewrite(TestFile);
    CloseFile(TestFile);
{$I+}
    Result := IOResult = 0;
    if FileExists(AFileName) then
      DeleteFile(AFileName);
  end
  else
  begin
    Result := True;
  end;
end;

procedure TLog.SetActive(Value: Boolean);
begin
  if Value <> FActive then
  begin
    if Value then
    begin
      AssignFile(FLogFile, FFileName);
      if (FileExists(FFileName)) and (FAppend = True) then
      begin
        Append(FLogFile);
      end
      else
      begin
        Rewrite(FLogFile);
      end;
      Flush(FLogFile);
      Writeln(FLogFile, '----------------------------| Log Start ' +
        DateTimeToStr(Now) + '|----------------------------');
      Flush(FLogFile);
      FLastMessage := '';
      FLastMessageCount := 0;
      FLogCache.Clear;
      FLogCache.Add('----------------------------| Log Start ' +
        DateTimeToStr(Now) + '|----------------------------');
      FActive := True;
    end
    else
    begin
      Flush(FLogFile);
      Writeln(FLogFile, '----------------------------| Log End ' +
        DateTimeToStr(Now) + '|----------------------------');
      Flush(FLogFile);
      CloseFile(FLogFile);
      FLogCache.Add('----------------------------| Log End ' +
        DateTimeToStr(Now) + '|----------------------------');
      FActive := False;
    end;
  end;
end;

procedure TLog.SetFileName(Value: TFilename);
begin
  SetActive(False);
  if not FActive then
  begin
    if IsValidFileName(Value) then
      FFileName := Value;
  end
  else
  begin
    raise ELogError.CreateFmt('"%s" is not a valid filename', [Value]);
  end;
end;

procedure TLog.Clear;
begin
  CloseFile(FLogFile);
  AssignFile(FLogFile, FFileName);
  Rewrite(FLogFile);
end;

procedure TLog.Add(AMessage: String);
var
  LogMessage: String;
begin
  if FActive then
  begin
    LogMessage := AMessage;
    LogMessage := StringReplace(LogMessage, #13, '', [rfReplaceAll]);
    LogMessage := StringReplace(LogMessage, #10, ' ', [rfReplaceAll]);
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
          Writeln(FLogFile, DateTimeToStr(Now) + ': ' +
            Format('Last message repeated %d time(s)', [FLastMessageCount]));
          FLogCache.Insert(0, DateTimeToStr(Now) + ': ' +
            Format('Last message repeated %d time(s)', [FLastMessageCount]));
        end;
        Flush(FLogFile);
        Writeln(FLogFile, DateTimeToStr(Now) + ': ' + LogMessage);
        FLogCache.Insert(0, DateTimeToStr(Now) + ': ' + LogMessage);
        Flush(FLogFile);
        FLastMessage := LogMessage;
        FLastMessageCount := 0;
      end
      else
      begin
        Inc(FLastMessageCount);
      end;
    end;
  end
  else
  begin
    raise ELogError.Create('Log is not active.');
  end;
end;

end.
