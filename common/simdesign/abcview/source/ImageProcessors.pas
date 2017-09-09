{ unit ImageProcessors

  Image processing functions
  
  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit ImageProcessors;

interface

uses
  Classes, Contnrs, SysUtils, Graphics, NativeJpg, GifImage, sdGraphicLoader,
  guiFeedback, sdAbcFunctions;

type

  TGraphicsOutputFormat = (
    gfJPG,
    gfGIF
  );

  TGraphicCommandType = (
    gcResize,      // Resize the image (using StretchBlt) - low quality. Enter
                   // New Width/Height in FWidth/FHeight. Image aspect ratio will
                   // always be kept intact
    gcResample,    // Resample the image (using HQ resampling)
    gcDownSize,    // Downsize the image
    gcDownSample,  // Downsample the image (using HQ resampling)
    gcReduceQual,  // Reduce the final quality of the image (only JPG store),
                   // results in smaller files. Enter the quality in ParamInt
    gcAddFrame     // Draw a 1-pixel frame around with color from FParamInt1
  );

  TsdGraphCommand = class
    FCommandType: TGraphicCommandType;
    FWidth: integer;
    FHeight: integer;
    FParamInt1: integer;
    FColor: TColor;
  end;

  TsdGraphCommandList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdGraphCommand;
  public
    property Items[Index: integer]: TsdGraphCommand read GetItems; default;
  end;

  TImageProcessor = class
  private
    FCommands: TsdGraphCommandList;
    FLoader: TsdGraphicLoader;
    FFeedback: TFeedback;
    FInputFile: string;
    FInputResult: TsdGraphicStatus;
    FOutputBitmap: TBitmap;
    FOutputFile: string;
    FOutputFormat: TGraphicsOutputFormat;
    FOutputQuality: integer;
    FOutputResult: TsdGraphicStatus;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // Call DoGraphicsProcessing to convert the input bitmap into the output
    // bitmap by applying all graphics commands in Commands
    procedure DoGraphicsProcessing;
    // Call Execute to read input file, do the graphics processing in Commands and
    // write the output file
    procedure Execute;
    // ReadInputFile will read the input file into the processor
    procedure ReadInputFile;
    // ReadInputFile will read the input file into the processor
    procedure WriteOutputFile;
    property Commands: TsdGraphCommandList read FCommands;
    // Assign a Feedback Dialog to FeedbackDialog to get feedback messages
    // Assumption: each task represents one image
    property FeedbackDialog: TFeedback read FFeedback write FFeedback;
    // Set Inputfile to the filename of the file that should be processed
    property InputFile: string read FInputFile write FInputFile;
    property OutputBitmap: TBitmap read FOutputBitmap;
    // set OutputFile to the filename of the file that should be created
    // as a result
    property OutputFile: string read FOutputFile write FOutputFile;
    property OutputFormat: TGraphicsOutputFormat read FOutputFormat write FOutputFormat;
    property OutputQuality: integer read FOutputQuality write FOutputQuality;
    property OutputResult: TsdGraphicStatus read FOutputResult;
  end;

const

  cDefaultOutputQuality = 75;

  cOutputFormatExt: array[TGraphicsOutputFormat] of string =
    ('.jpg', '.gif');

// These are helper functions to construct TGraphCommand classes

function CreateResizeCommand(AMaxWidth, AMaxHeight: integer): TsdGraphCommand;
function CreateResampleCommand(AMaxWidth, AMaxHeight: integer): TsdGraphCommand;
function CreateDownSizeCommand(AMaxWidth, AMaxHeight: integer): TsdGraphCommand;
function CreateDownSampleCommand(AMaxWidth, AMaxHeight: integer): TsdGraphCommand;
function CreateAddFrameCommand(AColor: TColor): TsdGraphCommand;
function CreateReduceQualCommand(AQual: integer): TsdGraphCommand;

implementation

uses
  sdItems{, sdUtils};

function CreateResizeCommand(AMaxWidth, AMaxHeight: integer): TsdGraphCommand;
begin
  Result := TsdGraphCommand.Create;
  Result.FCommandType := gcResize;
  Result.FWidth  := AMaxWidth;
  Result.FHeight := AMaxHeight;
end;

function CreateResampleCommand(AMaxWidth, AMaxHeight: integer): TsdGraphCommand;
begin
  Result := TsdGraphCommand.Create;
  Result.FCommandType := gcResample;
  Result.FWidth  := AMaxWidth;
  Result.FHeight := AMaxHeight;
end;

function CreateDownSizeCommand(AMaxWidth, AMaxHeight: integer): TsdGraphCommand;
begin
  Result := TsdGraphCommand.Create;
  Result.FCommandType := gcDownSize;
  Result.FWidth  := AMaxWidth;
  Result.FHeight := AMaxHeight;
end;

function CreateDownSampleCommand(AMaxWidth, AMaxHeight: integer): TsdGraphCommand;
begin
  Result := TsdGraphCommand.Create;
  Result.FCommandType := gcDownSample;
  Result.FWidth  := AMaxWidth;
  Result.FHeight := AMaxHeight;
end;

function CreateAddFrameCommand(AColor: TColor): TsdGraphCommand;
begin
  Result := TsdGraphCommand.Create;
  Result.FCommandType := gcAddFrame;
  Result.FColor := AColor;
end;

function CreateReduceQualCommand(AQual: integer): TsdGraphCommand;
begin
  Result := TsdGraphCommand.Create;
  Result.FCommandType := gcReduceQual;
  Result.FParamInt1 := AQual;
end;

{ TsdGraphCommandList }

function TsdGraphCommandList.GetItems(Index: integer): TsdGraphCommand;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

{ TImageProcessor }

constructor TImageProcessor.Create;
begin
  inherited;
  // Create list
  FCommands := TsdGraphCommandList.Create(True);
  FLoader := TsdGraphicLoader.Create;
  // Defaults
  FOutputFormat := gfJPG;
  FOutputQuality := cDefaultOutputQuality;
end;

destructor TImageProcessor.Destroy;
begin
  FreeAndNil(FCommands);
  FreeAndNil(FLoader);
  FreeAndNil(FOutputBitmap);
  inherited;
end;

procedure TImageProcessor.DoGraphicsProcessing;
var
  i: integer;
begin
  if HasContent(FLoader.Bitmap) then
  begin
    // Clear the output bitmap if neccesary
    if assigned(FOutputBitmap) then
      FOutputBitmap.Free;
    // adn create a new one
    FOutputBitmap := TBitmap.Create;

    // Do the graphics commands
    for i := 0 to FCommands.Count - 1 do
    begin

      // Do each command
      if assigned(Commands[i]) then
      begin
        case Commands[i].FCommandType of
        gcResize:
          begin
            // Progress
            if assigned(FFeedback) then
              Feedback.Info := Format('Resizing to max %dx%d pixels', [Commands[i].FWidth, Commands[i].FHeight]);
            // Rescale fast
            RescaleImage(FLoader.Bitmap, FOutputBitmap, Commands[i].FWidth, Commands[i].FHeight,
              True, True, False);
          end;
        gcResample:
          begin
            // Progress
            if assigned(FFeedback) then
              Feedback.Info := Format('Resampling to max %dx%d pixels', [Commands[i].FWidth, Commands[i].FHeight]);
            // Rescale w HQ sampling
            RescaleImage(FLoader.Bitmap, FOutputBitmap, Commands[i].FWidth, Commands[i].FHeight,
              True, True, True);
          end;
        gcDownSize:
          begin
            // Progress
            if assigned(FFeedback) then
              Feedback.Info := Format('Resampling to max %dx%d pixels', [Commands[i].FWidth, Commands[i].FHeight]);
            // Rescale w HQ sampling, only downsampling no upsampling
            RescaleImage(FLoader.Bitmap, FOutputBitmap, Commands[i].FWidth, Commands[i].FHeight,
              True, False, False);
          end;
        gcDownSample:
          begin
            // Progress
            if assigned(FFeedback) then
              Feedback.Info := Format('Resampling to max %dx%d pixels', [Commands[i].FWidth, Commands[i].FHeight]);
            // Rescale w HQ sampling, only downsampling no upsampling
            RescaleImage(FLoader.Bitmap, FOutputBitmap, Commands[i].FWidth, Commands[i].FHeight,
              True, False, True);
          end;
        gcReduceQual:
          FOutputQuality := Commands[i].FParamInt1;
        gcAddFrame:
          begin
            // Progress
            if assigned(FFeedback) then
              Feedback.Info := 'Adding frame';
            FOutputBitmap.Assign(FLoader.Bitmap);
            FOutputBitmap.Canvas.Lock;
            FOutputBitmap.Canvas.Brush.Color := Commands[i].FColor;
            FOutputBitmap.Canvas.Brush.Style := bsSolid;
            FOutputBitmap.Canvas.FrameRect(Rect(0, 0, FOutputBitmap.Width, FOutputBitmap.Height));
            FOutputBitmap.Canvas.UnLock;
          end;
        end;//case
      end;

      // Progress
      if assigned(FFeedback) then
        FFeedback.Progress := 30 + (i + 1) * 60 / FCommands.Count;

      // Last step?
      if i < FCommands.Count - 1 then
        // Not the last step so copy output to input again
        FLoader.Bitmap.Assign(FOutputBitmap);
    end;
  end;
end;

procedure TImageProcessor.Execute;
begin
  if assigned(FFeedback) then
    FFeedback.Info := 'Loading image';
  // Read the input file
  ReadInputFile;
  // Assume a 25% work done
  if assigned(FFeedback) then
    FFeedback.Progress := 25;

  // Check result
  if FInputResult = gsGraphicsOK then begin
    // Process
    DoGraphicsProcessing;
    // Write output file
    if assigned(FFeedback) then
      FFeedback.Info := 'Saving image';
    WriteOutputFile;
    // all work done
    if assigned(FFeedback) and (FOutputResult = gsGraphicsOK) then
      FFeedback.Progress := 100;
  end;
end;

procedure TImageProcessor.ReadInputFile;
begin
  // Start off w this assumption
  FInputResult := gsMemoryError;
  // Call the loader routine
  FInputResult := FLoader.LoadFromFile(FInputFile);
end;

procedure TImageProcessor.WriteOutputFile;
var
  JPeg: TsdJpegGraphic;
  GIF: TGifImage;
begin
  FOutputResult := gsSaveError;
  // Check if we have a bitmap to output and a filename
  if HasContent(FOutputBitmap) and (length(FOutputFile) > 0) then
  begin
    case FOutputFormat of
    gfJPG:
      begin
        // Create a JPG file
        JPeg := TsdJpegGraphic.Create;
        try
          // always 24 bit - no complications
          //JPeg.PixelFormat := jf24Bit;
          // Select correct quality
          JPeg.CompressionQuality := FOutputQuality;
          // assign - this compresses the image
          JPeg.Assign(FOutputBitmap);
          // now save to the file
          JPeg.SaveToFile(FOutputFile);
          // Result
          FOutputResult := gsGraphicsOK;
        finally
          JPeg.Free;
        end;
      end;
    gfGIF:
      begin
        Gif := TGifImage.Create;
        try
          Gif.ColorReduction := rmQuantizeWindows;
          // Convert the bitmap to a GIF
          Gif.Assign(FOutputBitmap);
          // Save the GIF
          Gif.SaveToFile(FOutputFile);
          // Result
          FOutputResult := gsGraphicsOK;
        finally
          GIF.Free;
        end;
      end;
    end;//case
  end;
end;

end.
