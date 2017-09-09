unit uPositioning;

interface
uses Vcl.Controls, Vcl.StdCtrls, Vcl.Graphics, Math;

  function calcPosBelow(const control : TControl) : integer; inline;
  function CalcPosToRightOf(const control : TControl; const marginPx : integer = 3): Integer;
  procedure AutosizeCombobox(comboBox : TCombobox; minSize : Integer = 0); inline;
  procedure AutoSizeButton(button : TButton; canvas : TCanvas); inline;

//------------------------------------------------------------------------------
// Implementation Section
//------------------------------------------------------------------------------
implementation
uses System.Types, Windows;

function calcPosBelow(const control : TControl) : integer;
begin
  Result := control.Top + control.Height + control.Margins.Bottom;
end;

function CalcPosToRightOf(const control : TControl; const marginPx : integer = 3): Integer;
begin
  Result := control.Left + control.Width + marginPx; //control.Margins.Right;
end;

// Note: this function is not in tested, working order. it is experimental.
procedure AutosizeCombobox(comboBox : TCombobox; minSize : Integer = 0);
var
  //Rect : TRect;
  Canvas : TCanvas;
  widest, strWidth, i : Integer;
begin
  if comboBox = nil then exit;

  //Rect := listbox.ClientRect;
  Canvas := comboBox.Canvas;
  widest := minSize;
  try
    Canvas.Font.Assign(comboBox.Font);

    for i := 0 to comboBox.Items.Count - 1 do begin

      strWidth := Canvas.TextWidth(comboBox.Items[i]);
      if (strWidth) > widest then
        widest := strWidth;
    end;
  finally
    //Canvas.Free;
    comboBox.Width := Math.Max(widest + GetSystemMetrics(SM_CXVSCROLL) + comboBox.Margins.Left + comboBox.Margins.Right, minSize);
  end;


end;

procedure AutoSizeButton(button : TButton; canvas : TCanvas);
begin
  button.ClientWidth := canvas.TextWidth(button.Caption) + 8;
end;


//TODO: move other autosize code from RC Utils to here.

end.
