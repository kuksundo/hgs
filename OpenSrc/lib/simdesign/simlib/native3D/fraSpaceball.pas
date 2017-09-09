unit fraSpaceball;
{
   simple visual frame with 3 translation and 3 rotation controls for the
   3D mouse (spaceball).

   original author: Nils Haeck M.Sc.
   Copyright (c) 2012  SimDesign BV  (www.simdesign.nl)
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sdSpaceballInput, StdCtrls;

type
  TfrSpaceball = class(TFrame)
    pbX: TPaintBox;
    pbY: TPaintBox;
    pbZ: TPaintBox;
    pbA: TPaintBox;
    pbB: TPaintBox;
    pbC: TPaintBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
  private
    FPaintBoxes: array[0..5] of TPaintBox;
    FColors: array[0..5] of TColor;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateInput3D(Sender: TObject; const AInput: TsdTDxInput);
  end;

implementation

{$R *.dfm}

constructor TfrSpaceball.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // additional creation
  FPaintboxes[0] := pbX;
  FPaintboxes[1] := pbY;
  FPaintboxes[2] := pbZ;
  FPaintboxes[3] := pbA;
  FPaintboxes[4] := pbB;
  FPaintboxes[5] := pbC;
  FColors[0] := clRed;
  FColors[1] := clLime;
  FColors[2] := clBlue;
  FColors[3] := clRed;
  FColors[4] := clLime;
  FColors[5] := clBlue;
end;

procedure TfrSpaceball.UpdateInput3D(Sender: TObject; const AInput: TsdTDxInput);
var
  i: integer;
  Canvas: TCanvas;
  AMin, AMax, AMid: integer;
  IVal: array[0..5] of double;
  MulL, MulA: double;
begin
  MulL := 10;
  MulA := 30;
  IVal[0] := AInput.Tx * MulL;
  IVal[1] := AInput.Ty * MulL;
  IVal[2] := AInput.Tz * MulL;
  IVal[3] := AInput.Rx * MulA;
  IVal[4] := AInput.Ry * MulA;
  IVal[5] := AInput.Rz * MulA;
  for i := 0 to 5 do
  begin
    Canvas := FPaintboxes[i].Canvas;

    AMid := FPaintboxes[i].Height div 2;

    if IVal[i] < 0 then
    begin
      AMin := AMid;
      AMax := round(AMid - IVal[i]);
    end else
    begin
      AMin := round(AMid - IVal[i]);
      AMax := AMid;
    end;


    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Style := psSolid;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(0, 0, FPaintboxes[i].Width, FPaintboxes[i].Height);

    Canvas.Brush.Color := clBtnFace;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(Rect(1, 1, FPaintboxes[i].Width - 1, AMin - 1));

    Canvas.Brush.Color := FColors[i];
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(Rect(1, AMin, FPaintboxes[i].Width - 1, AMax));

    Canvas.Brush.Color := clBtnFace;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(Rect(1, AMax + 1, FPaintboxes[i].Width - 1, FPaintboxes[i].Height - 1));
  end;

  //A := round(AInput.Angle * 10);
  //L := round(AInput.Length * 10);
  //lbTest.Caption := IntToStr(L)+ ' ' + IntToStr(A);
end;

end.
