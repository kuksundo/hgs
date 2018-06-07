unit FrmViewFlag;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvOfficeImage, SynCommons;

type
  TFlagViewF = class(TForm)
    AdvOfficeImage1: TAdvOfficeImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure DisplayFlagView(ADoc: variant);

var
  FlagViewF: TFlagViewF;

implementation

uses UnitBase64Util;

{$R *.dfm}

procedure DisplayFlagView(ADoc: variant);
var
  LFlagViewF: TFlagViewF;
  LUtf8: RawByteString;
//  LJpgImage: Vcl.Imaging.jpeg.TJPEGImage;
  LStream: TSynMemoryStream;
begin
  LFlagViewF := TFlagViewF.Create(nil);
  try
    LUtf8 := ADoc.FlagImage;
    if LUtf8 <> '' then
    begin
      LUtf8 := MakeBase64ToUTF8(LUtf8, False);
      LStream := TSynMemoryStream.Create(LUtf8);
      try
//        LJpgImage.LoadFromStream(LStream);
        LFlagViewF.AdvOfficeImage1.Picture.LoadFromStream(LStream);
      finally
        LStream.Free;
      end;
    end;

    LFlagViewF.ShowModal;
  finally
    LFlagViewF.Free;
  end;
end;

end.
