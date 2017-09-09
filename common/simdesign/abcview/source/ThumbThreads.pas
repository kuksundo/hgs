{ Unit ThumbThreads

  This unit implements the thumbnail decoding in a thread

  How to use this unit:
  - the thread is created in the Catalog's Create method

  Features:

  Issues:

  Initial release: 20-12-2000

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit ThumbThreads;

interface

uses

  Windows, ComCtrls, Classes, SysUtils, Roots, Items, Streams;

type

//
// TThumbReq
//
// Thumb Request object - holds a thumbnail decode request

  TThumbReq = class(TBasic)
  public
    FItem:     TItem;
    FCallback: TNotifyItemEvent;
    constructor Create(AItem: TItem; ACallback: TNotifyItemEvent);
  end;

  // TThumbThread thread implements the decoding of thumbnails in the background. This
  // is witnessed as the quickly but not instantly popping up of the thumbnails in
  // the list view.
  TThumbThread = class(TThread)
  private
    // Used for cleanup operations
    FThumbStart: longint;
    FThumbCount: longint;
    // Used for synchronisation
    FMessage: string;            // Message to be displayed on the status bar (sync)
    // Synchronized routines
    procedure DoMessage;
  protected
    procedure Execute; override;
  end;

implementation

uses

  Main, GlobalVars;

{ TThumbReq }

constructor TThumbReq.Create(AItem: TItem; ACallback: TNotifyItemEvent);
begin
  inherited Create;
  FItem := AItem;
  FCallback := ACallback;
end;

{ TThumbThread }

procedure TThumbThread.DoMessage;
begin
  MainForm.StatusMessage(Self, FMessage, suPanel1, 0);
end;

procedure TThumbThread.Execute;
var
  i: integer;
  AThumbReq: TThumbReq;
  LimLo, LimHi: word;
  AItem: TItem;
  ACallBack: TNotifyItemEvent;
  ADir, AMin, AMax: integer;
begin

  FThumbStart:=0;
  FThumbCount:=0;

  repeat
    try
      if assigned(Root) then with Root do begin

        // We point to a nil item
        AItem :=nil;
        ACallback := nil;

        // Get the Thumbnail index
        RequestLock.BeginWrite;
        if (Requests.Count > 0) then begin

          // Latest addition first
          AThumbReq := TThumbReq(Requests[Requests.Count-1]);
          with AThumbReq do begin
            AItem      := FItem;     // our Itemrec
            ACallback  := FCallback; // our Callback function
          end;

          Requests.Delete(Requests.Count-1);

        end;
        RequestLock.EndWrite;

        // Do we have a new thumbnail to decode?
        if assigned(AItem) then with AItem do begin

          // Check if the item misses thumbnail and if it's a candidate
          if (not States[ffDecodeErr + ffDeleted + ffNoAccess]) and
             (not assigned(Thumb)) then
          begin

            // No thumbnail, so we ask the item to create
            if CreateThumbnail then begin

              // The item succeeded in creating it's thumb

              // book-keeping
              inc(FThumbCount);
              AItem.ThumbIndex := FThumbCount div 8;

            end else begin

              FMessage:=Format('Unable to decode item %s',[AItem.Name]);
              synchronize(DoMessage);
              AItem.States[ffDecodeErr] := True;

            end;
          end;
          if assigned(ACallBack) then ACallBack(Self, AItem);

          Sleep(0);

        end else begin

          // We spend time here when we don't have something to do
          sleep(50);

        end;

        // Cleanup time! Batch mode
        if abs(FThumbCount-FThumbStart) > cMaxThumbStored then begin

          LimHi := (FThumbCount div 8)+(cMaxThumbStored div 16);
          LimLo := (FThumbCount div 8)-(cMaxThumbStored div 16);

          // Check the files
          for i:=0 to AllFiles.Count-1 do with TFile(AllFiles[i]) do
            if assigned(Thumb) AND
              ((ThumbIndex < LimLo) OR (ThumbIndex > LimHi)) then begin

              TFile(AllFiles[i]).DisposeThumbnail;

            end;

          FThumbStart := FThumbCount;

        end;
      end;
    except
      sleep(10);
    end;
  until Terminated;
end;

end.
