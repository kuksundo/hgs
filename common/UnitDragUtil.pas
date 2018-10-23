unit UnitDragUtil;

interface

uses System.Classes, WinApi.ActiveX, Vcl.Dialogs, DragDropFile;

function GetStreamFromDropDataFormat(AFormat: TVirtualFileStreamDataFormat): TStream;
function GetStreamFromDropDataFormat2(AFormat: TVirtualFileStreamDataFormat; AIdx:integer): TStream;

implementation

function GetStreamFromDropDataFormat(AFormat: TVirtualFileStreamDataFormat): TStream;
var
  LStream, LTargetAdapter: IStream;
  LTargetStream: TMemoryStream;
  LInt1, LInt2: LargeInt;
begin
  Result := nil;
  LStream := TVirtualFileStreamDataFormat(AFormat).FileContentsClipboardFormat.GetStream(0);

  if (LStream <> nil) then
  begin
    try
      LTargetStream := TMemoryStream.Create;
     try
        LTargetAdapter := TStreamAdapter.Create(LTargetStream);
      except
        LTargetStream.Free;
        raise;
      end;

      LStream.CopyTo(LTargetAdapter, High(Int64), LInt1, LInt2);
    finally
//      ShowMessage(IntToStr(LInt1));
      LTargetAdapter := nil;
      LTargetStream.Position := 0;
      Result := LTargetStream;
    end;
  end
  else
    ShowMessage('LStream not Assigned');
end;

function GetStreamFromDropDataFormat2(AFormat: TVirtualFileStreamDataFormat; AIdx:integer): TStream;
var
  LStream, LTargetAdapter: IStream;
  LTargetStream: TMemoryStream;
  LInt1, LInt2: LargeInt;
begin
  Result := nil;
  LStream := TVirtualFileStreamDataFormat(AFormat).FileContentsClipboardFormat.GetStream(AIdx);

  if (LStream <> nil) then
  begin
    try
      LTargetStream := TMemoryStream.Create;
     try
        LTargetAdapter := TStreamAdapter.Create(LTargetStream);
      except
        LTargetStream.Free;
        raise;
      end;

      LStream.CopyTo(LTargetAdapter, High(Int64), LInt1, LInt2);
    finally
//      ShowMessage(IntToStr(LInt1));
      LTargetAdapter := nil;
      LTargetStream.Position := 0;
      Result := LTargetStream;
    end;
  end
  else
    ShowMessage('LStream not Assigned');
end;

end.
