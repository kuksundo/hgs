unit Preview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DSPack;

type
  TfrmPreview = class(TForm)
    VideoWindow: TVideoWindow;
  end;

var
  frmPreview: TfrmPreview;

implementation

uses dmMainU;

{$R *.dfm}

end.
