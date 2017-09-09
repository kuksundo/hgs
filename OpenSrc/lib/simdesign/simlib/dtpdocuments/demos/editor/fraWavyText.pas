unit fraWavyText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraPolygonText, StdCtrls, ComCtrls, ExtCtrls, ColorPickerButton,
  dtpPolygonText, dtpDefaults;

type
  TfrWavyText = class(TfrPolygonText)
    Label13: TLabel;
    edXLen: TEdit;
    Label14: TLabel;
    edXAmp: TEdit;
    Label15: TLabel;
    edXOfs: TEdit;
    Label16: TLabel;
    edYLen: TEdit;
    edYAmp: TEdit;
    edYOfs: TEdit;
    Label17: TLabel;
    procedure edXLenExit(Sender: TObject);
    procedure edYLenExit(Sender: TObject);
    procedure edXAmpExit(Sender: TObject);
    procedure edYAmpExit(Sender: TObject);
    procedure edXOfsChange(Sender: TObject);
    procedure edYOfsExit(Sender: TObject);
  private
  protected
    procedure ShapesToFrame; override;
  public
  end;

var
  frWavyText: TfrWavyText;

implementation

{$R *.DFM}

{ TfrWavyText }

procedure TfrWavyText.ShapesToFrame;
var
  i: integer;
begin
  inherited;
  if ShapeCount = 0 then exit;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Wavy Text'
  else
    lblTitle.Caption := Format('Wavy Texts (%d items)', [ShapeCount]);
  // Main shape
  if Shapes[0] is TdtpWavyText then with TdtpWavyText(Shapes[0]) do begin
    // Text
    edXLen.Text := Format(cDefaultMMFormat, [WaveX.WaveLength]);
    edYLen.Text := Format(cDefaultMMFormat, [WaveY.WaveLength]);
    edXAmp.Text := Format(cDefaultMMFormat, [WaveX.Amplitude]);
    edYAmp.Text := Format(cDefaultMMFormat, [WaveY.Amplitude]);
    edXOfs.Text := Format(cDefaultMMFormat, [WaveX.WaveShift]);
    edYOfs.Text := Format(cDefaultMMFormat, [WaveY.WaveShift]);
  end;
  // Additional shapes
  for i := 1 to ShapeCount - 1 do
    if Shapes[i] is TdtpPolygonText then with TdtpPolygonText(Shapes[i]) do begin
      if edText.Text <> Text then
        edText.Text := '';
    end;

end;

procedure TfrWavyText.edXLenExit(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then for i := 0 to ShapeCount - 1 do
    if Shapes[i] is TdtpWavyText then
      TdtpWavyText(Shapes[i]).WaveX.WaveLength := StrToFloat(edXLen.Text);
  EndUpdate;
end;

procedure TfrWavyText.edYLenExit(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then for i := 0 to ShapeCount - 1 do
    if Shapes[i] is TdtpWavyText then
      TdtpWavyText(Shapes[i]).WaveY.WaveLength := StrToFloat(edYLen.Text);
  EndUpdate;
end;

procedure TfrWavyText.edXAmpExit(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then for i := 0 to ShapeCount - 1 do
    if Shapes[i] is TdtpWavyText then
      TdtpWavyText(Shapes[i]).WaveX.Amplitude := StrToFloat(edXAmp.Text);
  EndUpdate;
end;

procedure TfrWavyText.edYAmpExit(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then for i := 0 to ShapeCount - 1 do
    if Shapes[i] is TdtpWavyText then
      TdtpWavyText(Shapes[i]).WaveY.Amplitude := StrToFloat(edYAmp.Text);
  EndUpdate;
end;

procedure TfrWavyText.edXOfsChange(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then for i := 0 to ShapeCount - 1 do
    if Shapes[i] is TdtpWavyText then
      TdtpWavyText(Shapes[i]).WaveX.WaveShift := StrToFloat(edXOfs.Text);
  EndUpdate;
end;

procedure TfrWavyText.edYOfsExit(Sender: TObject);
var
  i: integer;
begin
  BeginUpdate;
  if not FIsUpdating then for i := 0 to ShapeCount - 1 do
    if Shapes[i] is TdtpWavyText then
      TdtpWavyText(Shapes[i]).WaveY.WaveShift := StrToFloat(edYOfs.Text);
  EndUpdate;
end;

end.
