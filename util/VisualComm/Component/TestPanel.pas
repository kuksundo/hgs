unit TestPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Forms, Graphics,
  ScrollPanel;

type
  TTestPanel = class(TScrollBox)
  private
    FCanvas     : TCanvas;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_EraseBkgnd;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  protected
    procedure PaintWindow(DC: HDC); override;
    procedure Paint; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TAdPanel = class(TTestPanel)
  protected
    procedure Paint; override;

  end;

  TSM = class(TCustomAdvancedScroller_pjh)
  protected
    procedure Paint; override;

  end;

implementation

{ TTestPanel }

constructor TTestPanel.Create(AOwner: TComponent);
begin
  inherited;
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
end;

destructor TTestPanel.Destroy;
begin
  FCanvas.Free;
  inherited;
end;

procedure TTestPanel.Paint;
begin
  //inherited;

end;

procedure TTestPanel.PaintWindow(DC: HDC);
begin
  FCanvas.Lock;
  try
    FCanvas.Handle := DC;
    try
      Paint;
    finally
      FCanvas.Handle := 0;
    end;
  finally
    FCanvas.Unlock;
  end;
end;

procedure TTestPanel.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;

end;

procedure TTestPanel.WMHScroll(var Message: TWMHScroll);
begin
  Invalidate;
  inherited;
end;

procedure TTestPanel.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

procedure TTestPanel.WMVScroll(var Message: TWMVScroll);
begin
  Invalidate;
  inherited;

end;

{ TAdPanel }

procedure TAdPanel.Paint;
var
  Rect: TRect;
begin
  inherited;

  Rect := GetClientRect;
  if HorzScrollBar.Visible then Dec(Rect.Left,HorzScrollBar.Position);
  if VertScrollBar.Visible then Dec(Rect.Top,VertScrollBar.Position);
end;

{ TSM }

procedure TSM.Paint;
begin
    inherited Paint;
end;

end.
