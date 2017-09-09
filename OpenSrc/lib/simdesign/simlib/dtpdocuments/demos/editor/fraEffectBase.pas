unit fraEffectBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraBase, StdCtrls, ExtCtrls, fraMaskBase;

type
  TfrEffectBase = class(TfrBase)
    chbMirrored: TCheckBox;
    chbFlipped: TCheckBox;
    procedure chbMirroredClick(Sender: TObject);
    procedure chbFlippedClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure ShapesToFrame; override;
  public
    { Public declarations }
  end;

var
  frEffectBase: TfrEffectBase;

implementation

{$R *.DFM}

{ TfrEffect }

procedure TfrEffectBase.ShapesToFrame;
begin
  if ShapeCount = 0 then exit;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Shape Effects'
  else
    lblTitle.Caption := Format('Shape Effects (%d items)', [ShapeCount]);
  // Main shape
  with Shapes[0] do begin
    // Mirrored, Flipped
    chbMirrored.Checked := Mirrored;
    chbFlipped.Checked  := Flipped;
  end;
end;

procedure TfrEffectBase.chbMirroredClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    Shapes[i].Mirrored := chbMirrored.Checked;
  EndUpdate;
end;

procedure TfrEffectBase.chbFlippedClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    Shapes[i].Flipped := chbFlipped.Checked;
  EndUpdate;
end;

end.
