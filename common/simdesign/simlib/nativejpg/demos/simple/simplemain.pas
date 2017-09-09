{ simple application that just uses TsdJpegImage (so not TNativeJpg)

  author: Nils Haeck M.Sc.
  copyright (c) 2011 www.simdesign.nl

}
unit simplemain;

interface

uses
  Classes, SysUtils, Variants, Graphics, Controls, Forms,
  Dialogs,

  // NativeJpg core classes
  sdJpegImage, sdJpegTypes, sdDebug, sdMapIterator, sdBitmapConversionWin,

  // SynEdit
  SynEdit;

type
  TfrmMain = class(TForm)
    seMain: TSynEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FJpeg: TsdJpegImage;
    function JpegCreateMap(var AIterator: TsdMapIterator): TObject;
    procedure JpegDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
  public
    { Public declarations }
    FBitmap: TBitmap;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FJpeg := TsdJpegImage.Create(Self);
  FJpeg.OnCreateMap := JpegCreateMap;
  FJpeg.OnDebugOut := JpegDebugOut;
  // here you can change the filename
  FJpeg.LoadFromFile('../../../formats2d/testfiles/jpg/sas.jpg');
  FJpeg.Lossless.Rotate90;

  FJpeg.UpdateBitmap;
  
  FBitmap.SaveToFile('test.bmp');
  FBitmap.Free;

  FJpeg.SaveToFile('test.jpg');
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FJpeg.Free;
end;

function TfrmMain.JpegCreateMap(var AIterator: TsdMapIterator): TObject;
begin
  JpegDebugOut(Self, wsInfo, Format('create TBitmap x=%d y=%d stride=%d',
    [AIterator.Width, AIterator.Height, AIterator.CellStride]));

  // create a bitmap with iterator size and pixelformat
  FBitmap := SetBitmapFromIterator(AIterator);

  // also update the iterator with bitmap properties
  GetBitmapIterator(FBitmap, AIterator);
  Result := FBitmap;
end;

procedure TfrmMain.JpegDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  seMain.Lines.Add(Format('%s: [%s] %s', [Sender.ClassName, cWarnStyleNames[WarnStyle], AMessage]))
end;

end.
