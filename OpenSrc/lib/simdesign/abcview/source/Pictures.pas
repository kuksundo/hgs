{ Unit Pictures

  This unit implements the picture manager. This object holds all pictures
  (thumbnails and fullsize) that are needed by the app. Also, it controls
  in which sequence they're decoded.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit Pictures;

interface

uses

  Windows, SysUtils, Classes, Contnrs, Graphics, Dialogs, sdItems, ItemLists,
  NativeXml, NativeJpg, sdProcessThread, sdGraphicLoader, sdSortedLists,
  sdAbcTypes, sdAbcVars, sdAbcFunctions;

type
  TAbcRequestEvent = procedure(const AGuid: TGUID; ARequest: TRequestType; APriority: TRequestPriority;
  AWidth, AHeight, ADelay: integer; ABitmap: TBitmap; ACallBack: TNotifyGuidEvent; AProgress: TStatusMessageEvent) of object;

type

  // TAbcGraphic is an object that holds the request data as well as the
  // decoded picture bitmap
  TAbcGraphic = class
  private
    FItemGuid: TGUID; // Guid of the referenced item
    FPicture: TBitmap;
    FStream: TMemoryStream;
    FThumbCompress: word;
    FStreamSize: integer;
  protected
    FCallBack: TNotifyGuidEvent;
    FDelay: integer;
    FPriority: TRequestPriority;
    FProgress: TStatusMessageEvent;
    FRequestType: TRequestType;
    FWidth: integer;
    FHeight: integer;
    FTick: integer;
    function GetMemorySize: integer;
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
  public
    property MemorySize: integer read GetMemorySize;
    constructor Create; virtual;
    destructor Destroy; override;
    function AssignPictureTo(ABitmap: TBitmap): boolean;
    procedure SetPicture(ABitmap: TBitmap);
    procedure SetPictureStream(S: TStream);
  end;

  TSortedListEx = class(TSortedList)
  public
    procedure LockRead;
    procedure UnlockRead;
    procedure LockWrite;
    procedure UnlockWrite;
    function FindItem(AItem: TObject): TObject;
  end;

  TDecodeThread = class(TProcess)
  private
    FLoader: TsdGraphicLoader;
    FCurrentItemID: TGUID;
    FRequestList: TSortedListEx;
    FPictureList: TSortedListEx;

    FFoundCallback: TNotifyGuidEvent;
    FFoundItemID: TGUID;
    FFoundRequest: TRequestType;
    FProgressItem: TAbcGraphic;
    FProgressMsg: string;
  protected
    function DecodeItem(ARequest: TAbcGraphic): TGraphicResult;
    // Synchronized callback procedure
    procedure DoCallBack;
    // Synchronized progress procedure
    procedure DoProgress;
  public
    constructor Create(CreateSuspended: boolean; AParent: TProcessList); override;
    destructor Destroy; override;
    property CurrentItemID: TGUID read FCurrentItemID write FCurrentItemID;
    property ProgressItem: TAbcGraphic read FProgressItem write FProgressItem;
    procedure Run; override;
    // DecodeProgress is called by the decoding process of TGraphic
    procedure DecodeProgress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
  end;

  // TPictureMngr is used to handle all picture decode requests, for thumbnails,
  // full graphics, and for scaling. It implements an image cache and two threads
  // that load/decode/resize images.
  TPictureMngr = class(TItemMngr)
  private
    FThreads: array of TDecodeThread;
    FPictures: TSortedListEx;
    FRequests: TSortedListEx;
    FSizeMemPicCount: integer;
    FSizeMemThumbCount: integer;
    FStatsThumbCount,
    FStatsPicCount,
    FStatsThumbSize,
    FStatsPicSize: integer;
    FThumbCompress: integer;
    FOnStatistics: TStatusMessageEvent;
  protected
    function GetThreadCount: integer;
    // Set the Mngr's statistic data
    procedure SetStatistics(AThumbCount, APicCount, AThumbSize, APicSize: integer);
    procedure SetThreadCount(AValue: integer);
    procedure SetThumbCompress(AValue: integer);
    // SizeMemoryPics will remove the oldest PictureItems with request rtGraphic
    // or rtResample from the list to warrant that memory usage stays below MemoryLimit.
    procedure SizeMemoryPics;
    // SizeMemoryThumbs will remove the oldest PictureItems with request rtThumbnail
    // from the list to warrant that memory usage stays below MemoryLimit.
    procedure SizeMemoryThumbs;
  public
    // Pictures holds a list of decoded TPictureItems - this is the actual cache.
    property Pictures: TSortedListEx read FPictures;
    // Requests holds a list of requests for thumb/graphic decode or
    // resize operations. A request is added through the Request procedure.
    property Requests: TSortedListEx read FRequests;
    property ThreadCount: integer read GetThreadCount write SetThreadCount;
    // Type of in-memory thumbnail compression (either None, GIF or JPG)
    property ThumbCompress: integer read FThumbCompress write SetThumbCompress;
    // Onstatistics will generate a message with statistical info from the picture manager
    property OnStatistics: TStatusMessageEvent read FOnStatistics write FOnStatistics;
    constructor Create(ARoot: TItemList);
    destructor Destroy; override;

    // Call AddGraphic to add a graphic to the internal cache
    procedure AddGraphic(const AGuid: TGUID; ARequest: TRequestType; APriority: TRequestPriority;
      AWidth, AHeight: integer; AGraphic: TBitmap);
    procedure ClearItems(Sender: TObject); override;
    // Call GetGraphic to get a copy of the Item's graphic representation.
    // Parameters:
    // - AItemID: this is the Item ID of the Item for which you request the graphic
    // - ARequest: rtThumbnail, rtGraphic, or rtResize. Use rtThumbnail for the
    //     standard thumbnails, rtGraphic for the normal 100% size graphic. rtResize
    //     must be used in conjunction with AWidth, AHeight, and a value in AGraphic,
    //     and is a request for a resize using Lazcos filtering.
    // - APriority: rpHigh, rpMedium, rpLow. Use rpHigh for graphics that must be
    //     displayed almost instantly, rpMedium for ones that are close and rpLow for
    //     graphics that are relatively unimportant yet.
    // - AWidth, AHeight: specify width/height of the resulting bitmap after resize.
    // - ACallBack: the callback routine which is used when decoding/resizing is finished.
    // - AGraphic: This value MUST be initialized (AGraphic = TBitmap.Create) before
    //     the call to GetGraphic. A copy of the item's graphic will be placed in it
    //     if it is found in the cache.
    // Return value can be grOK, grDelayed or grDecodeErr. In case of grDelayed, the
    // graphic was not found in the cache so it must be decoded in a thread. When
    // finished this will be signalled with a call to ACallBack.
    function GetGraphic(const AGuid: TGUID; ARequest: TRequestType; APriority: TRequestPriority;
      AWidth, AHeight, ADelay: integer; ACallBack: TNotifyGuidEvent;
      AProgress: TStatusMessageEvent; AGraphic: TBitmap): TGraphicResult;
    // HasGraphic behaves just like GetGraphic, but does not issue a request if the
    // graphic is not found. If AGraphic is initialized, a copy is placed in it
    function HasGraphic(const AGuid: TGUID; ARequest: TRequestType; APriority: TRequestPriority;
      AWidth, AHeight: integer; AGraphic: TBitmap): TGraphicResult;
    procedure RemoveItems(Sender: TObject; AList: TList); override;
    // Request will post a request for a decode/resize operation. Do not call Request
    // directly but use the GetGraphic procedure.
    procedure Request(const AGuid: TGUID; ARequest: TRequestType; APriority: TRequestPriority;
      AWidth, AHeight, ADelay: integer; ABitmap: TBitmap; ACallBack: TNotifyGuidEvent;
      AProgress: TStatusMessageEvent);
    procedure SetThreadPriority(APriority: TThreadPriority);
    procedure UpdateItems(Sender: TObject; AList: TList); override;
  end;


const

   // cRequestCountLimit is the maximum number of simultaneous requests in qew for
   // thumbnail/graphic decoding/resizing that is allowed.
   cRequestCountLimit = 200;

   cSizeMemFreq = 100;

implementation

uses
  sdRoots, ZLib, sdProperties, guiMain;

function RequestCompare(Object1, Object2: TObject; Info: pointer): integer;
var
  Item1, Item2: TAbcGraphic;
begin
  if not ((Object1 is TAbcGraphic) and (Object2 is TAbcGraphic)) then
  begin
    Result := 0;
    exit;
  end;
  Item1 := TAbcGraphic(Object1);
  Item2 := TAbcGraphic(Object2);
  Result := CompareInt(ord(Item1.FPriority), ord(Item2.FPriority));
  if Result = 0 then
    Result := -CompareInt(Item1.FTick, Item2.FTick);
end;

function PictureCompare(Object1, Object2: TObject; Info: pointer): integer;
var
  Item1, Item2: TAbcGraphic;
begin
  if not ((Object1 is TAbcGraphic) and (Object2 is TAbcGraphic)) then
  begin
    Result := 0;
    exit;
  end;
  Item1 := TAbcGraphic(Object1);
  Item2 := TAbcGraphic(Object2);
  // Compare ItemID
  Result := CompareGuid(Item1.FItemGuid, Item2.FItemGuid);
  if Result <> 0 then
    exit;

  // Compare Request
  Result := CompareInt(ord(Item1.FRequestType), ord(Item2.FRequestType));
  if Result <> 0 then
    exit;

  // Compare dimensions, at least one must match
  Result := CompareInt(Item1.FWidth, Item2.FWidth);
  if Result <> 0 then
    Result := CompareInt(Item1.FHeight, Item2.FHeight);
end;

{ TAbcGraphic }

function TAbcGraphic.GetMemorySize: integer;
begin
  Result := 0;
  if assigned(FPicture) then
    Result := FPicture.Width * FPicture.Height * 4;
  if assigned(FStream) then
    Result := Result + FStream.Size;
end;

constructor TAbcGraphic.Create;
begin
  inherited;
  FThumbCompress := sdAbcVars.FThumbCompress;
end;

destructor TAbcGraphic.Destroy;
begin
  FreeAndNil(FPicture);
  FreeAndNil(FStream);
  inherited;
end;

function TAbcGraphic.AssignPictureTo(ABitmap: TBitmap): boolean;
var
  Decom: TDecompressionStream;
  S: TStream;
  Jpeg: TsdJpegGraphic;
begin
  Result := False;
  try
  // No compression
  if assigned(FPicture) then
  begin
    ABitmap.Assign(FPicture);
    Result := True;
    exit;
  end;

  // Compression used
  if assigned(FStream) then
  begin
    case FThumbCompress of
    cThumbCompressLZW:
      begin
        // Was saved with Limpel/Ziv compression
        FStream.Position := 0;
        Decom := TDecompressionStream.Create(FStream);
        S := TMemoryStream.Create;
        try
          // copy to normal stream
          S.CopyFrom(Decom, FStreamSize);
          S.Position := 0;
          ABitmap.LoadFromStream(S);
          Result := True;
        finally
          S.Free;
          Decom.Free;
        end;
      end;
    cThumbCompressJPG:
      begin
        JPeg := TsdJpegGraphic.Create;
        try
          FStream.Position := 0;
          JPeg.LoadFromStream(FStream);
          ABitmap.Assign(JPeg);
          Result := True;
        finally
          JPeg.Free;
        end;
      end;
    end;//case
  end;
  except
    // Some error with assignment
    DoDebugOut(Self, wsFail, 'Exception in "AssignPictureTo"');
  end;
end;

procedure TAbcGraphic.SetPicture(ABitmap: TBitmap);
var
  Compr: TCompressionStream;
  S: TMemoryStream;
  JPeg: TsdJpegGraphic;
// local
procedure SaveUncompressed;
begin
  // First create the picture if not already
  if not assigned(FPicture) then
    FPicture := TBitmap.Create;
  // Assign the bitmap to it
  FPicture.Assign(ABitmap);
  FPicture.Dormant;
  FPicture.FreeImage;
end;
// main
begin
  case FThumbCompress of
  cThumbCompressNone:
    // No compression
    SaveUncompressed;
  cThumbCompressLZW:
    begin
      if FRequestType = rtThumbnail then
      begin
        if assigned(FStream) then
          FStream.Free;
        FStream := TMemoryStream.Create;
        // Save with Limpel/Ziv compression
        Compr := TCompressionStream.Create(clDefault, FStream);
        S := TMemoryStream.Create;
        try
          if assigned(ABitmap) then
            ABitmap.SaveToStream(S);
          FStreamSize := S.Size;
          S.Position := 0;
          Compr.CopyFrom(S, FStreamSize);
        finally
          Compr.Free;
        end;
      end else
        SaveUnCompressed;
    end;
  cThumbCompressJPG:
    begin
      if FRequestType = rtThumbnail then
      begin
        if assigned(FStream) then
          FStream.Free;
        FStream := TMemoryStream.Create;
        JPeg := TsdJpegGraphic.Create;
        try
          //JPeg.PixelFormat := jf24bit;
          JPeg.CompressionQuality := FStoreThumbJPGQual;
          JPeg.Assign(ABitmap);
          JPeg.SaveToStream(FStream);
        finally
          JPeg.Free;
        end;
      end else
        SaveUnCompressed;
    end;
  end;//case
end;

procedure TAbcGraphic.SetPictureStream(S: TStream);
begin
  if assigned(FStream) then
    FStream.Free;
  FStream := TMemoryStream.Create;
  FStream.CopyFrom(S, S.Size);
end;

procedure TAbcGraphic.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle;
  const AMessage: Utf8String);
begin
//todo
end;

{ TSortedListEx }

function TSortedListEx.FindItem(AItem: TObject): TObject;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if AItem = Items[i] then
      Result := AItem;
end;

procedure TSortedListEx.LockRead;
begin
//todo
end;

procedure TSortedListEx.LockWrite;
begin
//todo
end;

procedure TSortedListEx.UnlockRead;
begin
//todo
end;

procedure TSortedListEx.UnlockWrite;
begin
//todo
end;

{ TDecodeThread }

constructor TDecodeThread.Create(CreateSuspended: boolean;
  AParent: TProcessList);
begin
  inherited;
  FLoader := TsdGraphicLoader.Create;
end;

function TDecodeThread.DecodeItem(ARequest: TAbcGraphic): TGraphicResult;
var
  AItem: TsdItem;
  Bitmap: TBitmap;
  S: TStream;
begin
  // Decode the item according to specs
  Result := grDecodeErr;
  if not assigned(ARequest) then
    exit;

  frmMain.Root.LockRead;
  try
    AItem := frmMain.Root.ItemByGuid(ARequest.FItemGuid);
  finally
    frmMain.Root.UnlockRead;
  end;

  if not assigned(AItem) then exit;

  frmMain.Root.LockRead;
  try
    case ARequest.FRequestType of
    rtThumbnail:
      begin
        Task := format('thumbing %s', [AItem.Name]);
        // Optimized code
        if (FThumbCompress = cThumbCompressJPG) and FStoreThumbs then
        begin
          S := TMemoryStream.Create;
          try
            if AItem.RetrieveThumbnailStream(S) then
            begin
              S.Seek(0, soFromBeginning);
              ARequest.SetPictureStream(S);
              Result := grOK;
            end;
          finally
            S.Free;
          end;
        end;
        // Conventional method
        if Result <> grOK then
        begin
          Bitmap := TBitmap.Create;
          try
            AItem.RetrieveThumbnail(Bitmap, FLoader);
            if HasContent(Bitmap) then
            begin
              ARequest.SetPicture(Bitmap);
              Result := grOK;
            end;
          finally
            Bitmap.Free;
          end;
        end;
      end;
    rtGraphic:
      begin
        // The DecodeProgress routine causes a deadlock when using the monitoring
        // function (focus on new)! Have to look into this!
        Task := format('decoding %s', [AItem.Name]);
        FLoader.SetDestSize(0, 0);
        FLoader.Quality := iqNormal;
        FLoader.OnProgress := DecodeProgress;
        AItem.RetrievePicture(FLoader);
        if HasContent(FLoader.Bitmap) then
        begin
          // Assign the picture to the request item
          ARequest.SetPicture(FLoader.Bitmap);
          Result := grOK;
        end;
      end;
    rtResample:
      begin
        // Default to error
        Task := format('resampling %s', [AItem.Name]);
        Result := grResampleErr;

        // The request contains the original
        Bitmap := TBitmap.Create;
        try
          // Copy the original
          Bitmap.Assign(ARequest.FPicture);
          // Do the resampling, result in FPicture
          RescaleImage(Bitmap, ARequest.FPicture, ARequest.FWidth, ARequest.FHeight, True, True, True);
          ARequest.FWidth := ARequest.FPicture.Width;
          ARequest.FHeight := ARequest.FPicture.Height;
          ARequest.FPicture.Dormant;
          ARequest.FPicture.FreeImage;
        finally
          // free copy
          Result := grOK;
          FreeAndNil(Bitmap);
        end;
      end;
    end;//case
  finally
    frmMain.Root.UnLockRead;
  end;

end;

procedure TDecodeThread.DecodeProgress(Sender: TObject; Stage: TProgressStage;
  PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
var
  NewMsg: string;
begin
  if assigned(FProgressItem) and assigned(FProgressItem.FProgress) then
  begin
    // Select correct message
    NewMsg := '';

    if length(Msg) > 0 then
      NewMsg := Msg;
    if length(NewMsg) = 0 then
      NewMsg := 'Processing...';

    if Stage = psRunning then
      NewMsg := Format('%s (%d%%)',
        [NewMsg, PercentDone]);

    if NewMsg <> FProgressMsg then
    begin
      FProgressMsg := NewMsg;
      // with or without synch?
      if not Terminated then
        synchronize(DoProgress);

    end;
  end;
end;

destructor TDecodeThread.Destroy;
begin
  FreeAndNil(FLoader);
  inherited;
end;

procedure TDecodeThread.DoCallBack;
begin
  if not IsEmptyGuid(FFoundItemID) then
    if assigned(FFoundCallBack) then
      FFoundCallBack(Self, FFoundItemID);
end;

procedure TDecodeThread.DoProgress;
begin
  if assigned(FProgressItem) then
    if assigned(FProgressItem.FProgress) then
      FProgressItem.FProgress(Self, FProgressMsg);
end;

procedure TDecodeThread.Run;
var
  Index: integer;
  Picture: TAbcGraphic;
  Source: TsdItem;
  GraphResult: TGraphicResult;
begin
  repeat
    Task := '';
    try
      // We assume that FRequestList and FPictureList are going to be assigned
      try
        while FRequestList.Count > 0 do
        begin

          FRequestList.LockWrite;
          try

            // Get our item from the pool
            Picture := nil;
            Index := 0;
            while (Index < FRequestList.Count) and not assigned(Picture) do
            begin

              Picture := TAbcGraphic(FRequestList.Items[Index]);
              if assigned(Picture)  and
                ((Picture.FTick + Picture.FDelay) <= integer(GetTickCount)) then
              begin
                // Extract the item
                Picture := TAbcGraphic(FRequestList.Extract(Picture));
              end else
              begin
                Picture := nil;
                inc(Index);
              end;

            end;
          finally
            FRequestList.UnlockWrite;
          end;

          FProgressItem := nil;
          FProgressMsg := '';

          // Do we have an item?
          if assigned(Picture) then
          begin

            // This is the item we're working on
            FProgressItem := Picture;

            if (Picture.FDelay > 0) and (not IsEqualGuid(Picture.FItemGuid, FCurrentItemID)) then
            begin

              // Expired
              GraphResult := grExpired;

            end else
            begin

              // Decode this item, it is a valid request!
              GraphResult := DecodeItem(Picture);

            end;

            case GraphResult of

            // Decoded correctly
            grOK, grDecodeErr:
              begin
                // In case of an error: add it to the state of the item
                if GraphResult = grDecodeErr then
                begin
                  Source := frmMain.Root.ItemByGuid(Picture.FItemGuid);
                  if assigned(Source) then
                    Source.SetState(isDecodeErr, True);
                end else
                begin
                  // Not an error: add picture to the picture list
                  FPictureList.Add(Picture);
                end;
                // Do we want a callback?
                if (GraphResult  = grOK) or
                   ((GraphResult = grDecodeErr) and (Picture.FRequestType = rtGraphic)) then
                begin
                  FFoundItemID := Picture.FItemGuid;
                  FFoundRequest := Picture.FRequestType;
                  FFoundCallback := Picture.FCallback;
                  if not Terminated then
                    synchronize(DoCallBack);
                end;
              end;

            end;//case

          end;//if

          // Check pausing
          if Status = psPausing then
            Pause;

          // Allow other threads
          sleep(0);

        end;//while
      except
        // An exception! It is handled per default
        //DoDebugOut(Self, wsFail, 'Exception in decode thread');
      end;
    finally
      // Wait state
      if not Terminated then
        Pause;
    end;
  until Terminated;
end;

{ TPictureMngr }

function TPictureMngr.GetThreadCount: integer;
begin
  Result := length(FThreads);
end;

procedure TPictureMngr.SetThreadCount(AValue: integer);
var
  i: integer;
begin
  // No changes? then exit
  if AValue = length(FThreads) then
    exit;

  // Free previous threads
  for i := 0 to length(FThreads) - 1 do
    FThreads[i].Terminate;
  SetLength(FThreads, 0);

  // Setup new threads
  SetLength(FThreads, AValue);
  for i := 0 to AValue - 1 do
  begin
    FThreads[i] := TDecodeThread.Create(True, glProcessList);
    FThreads[i].Name := format('Decoder %d', [i + 1]);
    FThreads[i].FRequestList := FRequests;
    FThreads[i].FPictureList := FPictures;
    FThreads[i].Priority := FDecodePriority;
    FThreads[i].Options := [poAllowPause];
    FThreads[i].Resume;
  end;

end;

procedure TPictureMngr.SetThumbCompress(AValue: integer);
begin
  if AValue <> FThumbCompress then
  begin
    ClearItems(Self);
    FThumbCompress := AValue;
  end;
end;

procedure TPictureMngr.SetStatistics(AThumbCount, APicCount, AThumbSize, APicSize: integer);
var
  StatsChanged: boolean;
begin
  StatsChanged := false;
  if FStatsThumbCount <> AThumbCount then
  begin
    FStatsThumbCount := AThumbCount;
    StatsChanged := true;
  end;
  if FStatsPicCount <> APicCount then
  begin
    FStatsPicCount := APicCount;
    StatsChanged := true;
  end;
  if FStatsThumbSize <> AThumbSize then
  begin
    FStatsThumbSize := AThumbSize;
    StatsChanged := true;
  end;
  if FStatsPicSize <> APicSize then
  begin
    FStatsPicSize := APicSize;
    StatsChanged := true;
  end;
  if StatsChanged then
    if assigned(FOnStatistics) then
      FOnStatistics(Self, Format('%d thumbs (%3.1fMb), %d pics (%3.1fMb) in memory',
        [FStatsThumbCount, FStatsThumbSize/(1024*1024),
         FStatsPicCount, FStatsPicSize/(1024*1024)]));
end;

procedure TPictureMngr.SizeMemoryPics;
var
  i: integer;
  OldestPic,
  OldestPicTick,
  TotalPicSize,
  PicCount: integer;
  PI: TAbcGraphic;
begin
  inc(FSizeMemPicCount);
  // We only visit this routine 1 on 4 to save resources
  if (FSizeMemPicCount mod 4 <> 0) then
    exit;

  repeat
    // calculate size
    TotalPicSize   := 0;
    OldestPic   := 0;
    PicCount   := 0;
    OldestPicTick   := GetTickCount;
    for i:= 0 to Pictures.Count - 1 do
    begin
      PI := TAbcGraphic(Pictures[i]);
      case PI.FRequestType of
      rtGraphic, rtResample:
        begin
          inc(PicCount);
          inc(TotalPicSize, PI.MemorySize);
          if PI.FTick < OldestPicTick then
          begin
            OldestPic := i;
            OldestPicTick := PI.FTick;
          end;
        end;
      end;
    end;

    // compare
    if TotalPicSize > FGraphicsCache * 1048576 then
      Pictures.Remove(Pictures.Items[OldestPic]);

  until (TotalPicSize <= FGraphicsCache * 1048576);
  SetStatistics(FStatsThumbCount, PicCount, FStatsThumbSize, TotalPicSize);
end;

procedure TPictureMngr.SizeMemoryThumbs;
var
  i: integer;
  OldestThumb,
  OldestThumbTick,
  TotalThumbSize,
  ThumbCount: integer;
  PI: TAbcGraphic;
begin
  inc(FSizeMemThumbCount);
  // We only visit this routine 1 on cSizeMemFreq to save resources
  if (FSizeMemThumbCount mod cSizeMemFreq <> 0) then
    exit;

  repeat
    // calculate size
    TotalThumbSize := 0;
    OldestThumb := 0;
    ThumbCount := 0;
    OldestThumbTick := GetTickCount;
    for i:= 0 to Pictures.Count - 1 do
    begin
      PI := TAbcGraphic(Pictures[i]);
      case PI.FRequestType of
      rtThumbnail:
        begin
          inc(ThumbCount);
          inc(TotalThumbSize, PI.MemorySize);
          if PI.FTick < OldestThumbTick then
          begin
            OldestThumb := i;
            OldestThumbTick := PI.FTick;
          end;
        end;
      end;
    end;

    // compare
    if TotalThumbSize > FThumbnailCache * 1048576 then
      Pictures.Remove(Pictures.Items[OldestThumb]);

  until (TotalThumbSize <= FThumbnailCache * 1048576);
  SetStatistics(ThumbCount, FStatsPicCount, TotalThumbSize, FStatsPicSize);
end;

constructor TPictureMngr.Create(ARoot: TItemList);
begin
  inherited Create;
  FRequests := TSortedListEx.Create(True);
  FRequests.CompareMethod := RequestCompare;

  //FRequests.Name := 'Request list';
  FPictures := TSortedListEx.Create(True);
  FPictures.CompareMethod := PictureCompare;

  //FPictures.Name := 'Picture list';
  FName := 'Picture Manager';

  // Create the threads
  ThreadCount := FDecodeThreads;

  FThumbCompress := sdAbcVars.FThumbCompress;

  Parent := ARoot;
end;

destructor TPictureMngr.Destroy;
begin
  Parent := nil;
  FreeAndNil(FRequests);
  FreeAndNil(FPictures);
  inherited;
end;

procedure TPictureMngr.AddGraphic(const AGuid: TGUID; ARequest: TRequestType; APriority: TRequestPriority;
  AWidth, AHeight: integer; AGraphic: TBitmap);
var
  Index: integer;
  Temp, New: TAbcGraphic;
  PI: TAbcGraphic;
begin
  // We have the picture
  if not assigned(AGraphic) then
    raise Exception.Create('AGraphic must be assigned!');

  // Check if we have a graphic already decoded
  Temp := TAbcGraphic.Create;
  try
    Temp.FItemGuid := AGuid;
    Temp.FRequestType := ARequest;
    Temp.FWidth := AWidth;
    Temp.FHeight := AHeight;

    if Pictures.Find(Temp, Index) then
    begin

      if assigned(Pictures[Index]) then
      begin

        // Update this item
        PI := TAbcGraphic(Pictures[Index]);
        PI.FTick := GetTickCount;
      end;

    end else
    begin

      // We do not have it.. so add the graphic
      New := TAbcGraphic.Create;
      New.FItemGuid := AGuid;
      New.FRequestType := ARequest;
      New.FWidth := AWidth;
      New.FHeight := AHeight;
      New.SetPicture(AGraphic);
      Pictures.Add(New);

    end;
  finally
    Temp.Free;
  end;
  if (ARequest in [rtGraphic, rtResample]) then
    SizeMemoryPics;
  if (ARequest in [rtThumbnail]) then
    SizeMemoryThumbs;
end;

procedure TPictureMngr.ClearItems(Sender: TObject);
var
  i: integer;
begin
  // Just in case, we will also clear the thread's pointers
  for i := 0 to ThreadCount - 1 do
    FThreads[i].ProgressItem := nil;
  FRequests.Clear;
  FPictures.Clear;
  // Make sure to reflect changes in statistics
  SizeMemoryPics;
  SizeMemoryThumbs;
end;

function TPictureMngr.GetGraphic(const AGuid: TGuid; ARequest: TRequestType; APriority: TRequestPriority;
  AWidth, AHeight, ADelay: integer; ACallBack: TNotifyGuidEvent; AProgress: TStatusMessageEvent;
  AGraphic: TBitmap): TGraphicResult;
var
  Temp: TAbcGraphic;
  Index, i: integer;
  Item: TsdItem;
  PI: TAbcGraphic;
begin
  Result := grNotFound;

  // Current request
  if ADelay > 0 then
    for i := 0 to ThreadCount - 1 do
      FThreads[i].CurrentItemID := AGuid;

  // Check if we have a graphic already decoded
  Temp := TAbcGraphic.Create;
  try
    Temp.FItemGuid := AGuid;
    Temp.FRequestType := ARequest;
    Temp.FWidth := AWidth;
    Temp.FHeight := AHeight;

    if Pictures.Find(Temp, Index) then
    begin

      // We have the picture
      if not assigned(AGraphic) then
        raise Exception.Create('AGraphic must be assigned!');

      if assigned(Pictures[Index]) then
      begin
        PI := TAbcGraphic(Pictures[Index]);
        if PI.AssignPictureTo(AGraphic) then
          Result := grOK
        else
          Result := grDecodeErr;
        // Update this item so that it will be deleted later
        PI.FTick := GetTickCount;
      end;

    end else
    begin

      // We do not have it.. so decode it, but only if the item is valid
      Item := Root.ItemByGuid(AGuid);
      if assigned(Item) and (Item.States * [isDecodeErr, isNoAccess, isDeleted] = []) then
      begin
        Result := grDelayed;
        Request(AGuid, ARequest, APriority, AWidth, AHeight, ADelay, AGraphic, ACallBack, AProgress);
      end else
      begin
        Result := grDecodeErr;
      end;

    end;
  finally
    Temp.Free;
  end;

  if (ARequest in [rtGraphic, rtResample]) then
    SizeMemoryPics;
  if (ARequest in [rtThumbnail]) then
    SizeMemoryThumbs;
end;

function TPictureMngr.HasGraphic(const AGuid: TGUID; ARequest: TRequestType; APriority: TRequestPriority;
  AWidth, AHeight: integer; AGraphic: TBitmap): TGraphicResult;
var
  Temp, PI: TAbcGraphic;
  Index: integer;
begin
  Result := grNotFound;
  // Check if we have a graphic already decoded
  Temp := TAbcGraphic.Create;
  try
    Temp.FItemGuid := AGuid;
    Temp.FRequestType := ARequest;
    Temp.FWidth := AWidth;
    Temp.FHeight := AHeight;

    if Pictures.Find(Temp, Index) then
    begin

      if assigned(Pictures[Index]) then
      begin
        PI := TAbcGraphic(Pictures[Index]);
        if assigned(AGraphic) then
        begin
          if PI.AssignPictureTo(AGraphic) then
            Result := grOK;
        end else
          Result := grOK;
        // Update this item so that it will be more forward in the cache
        PI.FTick := GetTickCount;
      end;

    end;
  finally
    Temp.Free;
  end;
end;

procedure TPictureMngr.RemoveItems(Sender: TObject; AList: TList);
var
  i: integer;
  Item: TObject;
begin
  // Just in case, we will also clear the thread's pointers
  for i := 0 to ThreadCount - 1 do
    FThreads[i].ProgressItem := nil;

  // Remove all items from the list that are present in AList
  for i := 0 to AList.Count - 1 do
  begin
    Item := FRequests.FindItem(AList[i]);
    while assigned(Item) do
    begin
      Requests.Remove(Item);
      Item := FRequests.FindItem(AList[i])
    end;
    Item := FPictures.FindItem(AList[i]);
    while assigned(Item) do
    begin
      FPictures.Remove(Item);
      Item := FPictures.FindItem(AList[i]);
    end;
  end;
  FRequests.Clear;
  FPictures.Clear;

  // Make sure to reflect changes in statistics
  SizeMemoryPics;
  SizeMemoryThumbs;
end;

procedure TPictureMngr.Request(const AGuid: TGUID; ARequest: TRequestType; APriority: TRequestPriority;
  AWidth, AHeight, ADelay: integer; ABitmap: TBitmap; ACallBack: TNotifyGuidEvent; AProgress: TStatusMessageEvent);
var
  i: integer;
  NewItem: TAbcGraphic;
  Index: integer;
begin
  // To do: add "Executing" flag to a request so that we can see if the request
  // is currently executing. This will avoid double requests

  // Remove similar requests first
  Requests.LockRead;
  try

    i := 0;
    while i < Requests.Count - 1 do
    begin
      if IsEqualGuid(TAbcGraphic(Requests.Items[i]).FItemGuid, AGuid) and
         (TAbcGraphic(Requests.Items[i]).FRequestType = ARequest) then
      begin
         if APriority > TAbcGraphic(Requests.Items[i]).FPriority then
           exit;
         Requests.UnlockRead;
         Requests.Remove(Requests.Items[i]);
         Requests.LockRead;
      end else
        inc(i);
    end;

  finally
    Requests.UnlockRead;
  end;

  // Create the request
  NewItem := TAbcGraphic.Create;
  NewItem.FCallBack := ACallBack;
  NewItem.FDelay    := ADelay;
  NewItem.FProgress := AProgress;
  NewItem.FHeight   := AHeight;
  NewItem.FItemGuid := AGuid;
  NewItem.FPriority := APriority;
  NewItem.FRequestType := ARequest;
  NewItem.FTick     := GetTickCount;
  NewItem.FWidth    := AWidth;

  if ARequest = rtResample then
  begin
    // Create a copy of the bitmap
    NewItem.FPicture := TBitmap.Create;
    NewItem.FPicture.Assign(ABitmap);
    NewItem.FPicture.Dormant;
    NewItem.FPicture.FreeImage;
  end;

  // add request to the list only if it is not already there
  if Pictures.Find(NewItem, Index) then
  begin
    Pictures.LockRead;
    try
      TAbcGraphic(Pictures[Index]).FTick := GetTickCount;
      FreeAndNil(NewItem);
    finally
      Pictures.UnlockRead;
    end;
  end else
  begin
    Requests.Add(NewItem);
    while Requests.Count > cRequestCountLimit do
      Requests.Remove(Requests.Items[Count - 1])
  end;

  // Run threads
  for i := 0 to ThreadCount - 1 do
    FThreads[i].Status := psRun;
end;

procedure TPictureMngr.SetThreadPriority(APriority: TThreadPriority);
var
  i: integer;
begin
  for i := 0 to ThreadCount - 1 do
    FThreads[i].Priority := APriority;
end;

procedure TPictureMngr.UpdateItems(Sender: TObject; AList: TList);
begin
  // Remove all items from the list that are present in AList
  RemoveItems(Sender, AList);
end;

end.
