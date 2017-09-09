{ *********************************************************************** }
{                                                                         }
{ GraphBuilder                                                            }
{                                                                         }
{ Copyright (c) 2006 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit MainForm;

{$B-}
{$I Directives.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  XPStyleActnCtrls, PlatformDefaultStyleActnCtrls, ActnList, ActnMan, ActnCtrls,
  AppEvnts, StdActns, ImgList, StdCtrls, ExtCtrls, ComCtrls, ToolWin, ActnMenus,
  Menus, Calculator, Clipbrd, Graph;

type
  TMain = class(TForm)
    ActionMainMenuBar: TActionMainMenuBar;
    ActionManager: TActionManager;
    ActionToolBar: TActionToolBar;
    ApplicationEvents: TApplicationEvents;
    cbFormula: TComboBox;
    ColorDialog: TColorDialog;
    ControlBar: TControlBar;
    eMaxX: TEdit;
    eMaxY: TEdit;
    ePenWidth: TEdit;
    eSpacing: TEdit;
    FileExit: TFileExit;
    GraphAxis: TAction;
    GraphColor: TAction;
    GraphCopy: TAction;
    GraphDelete: TAction;
    GraphDraw: TAction;
    GraphGrid: TAction;
    GraphPolar: TAction;
    GraphRectangular: TAction;
    GraphRefresh: TAction;
    GraphTracing: TAction;
    ImageList: TImageList;
    PopupMenu: TPopupMenu;
    StatusBar: TStatusBar;
    tbFormat: TToolBar;
    tbQuality: TTrackBar;
    tbStandard: TToolBar;
    udMaxX: TUpDown;
    udMaxY: TUpDown;
    udPenWidth: TUpDown;
    udSpacing: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ApplicationEventsHint(Sender: TObject);
    procedure GraphDrawExecute(Sender: TObject);
    procedure GraphDrawUpdate(Sender: TObject);
    procedure GraphGridExecute(Sender: TObject);
    procedure GraphGridUpdate(Sender: TObject);
    procedure GraphAxisExecute(Sender: TObject);
    procedure GraphAxisUpdate(Sender: TObject);
    procedure GraphTracingExecute(Sender: TObject);
    procedure GraphTracingUpdate(Sender: TObject);
    procedure GraphCopyExecute(Sender: TObject);
    procedure GraphDeleteExecute(Sender: TObject);
    procedure GraphRefreshExecute(Sender: TObject);
    procedure GraphColorExecute(Sender: TObject);
    procedure tbQualityChange(Sender: TObject);
    procedure cbFormulaKeyPress(Sender: TObject; var Key: Char);
    procedure eMaxXChange(Sender: TObject);
    procedure eMaxXExit(Sender: TObject);
    procedure eMaxYChange(Sender: TObject);
    procedure eMaxYExit(Sender: TObject);
    procedure ePenWidthChange(Sender: TObject);
    procedure ePenWidthExit(Sender: TObject);
    procedure eSpacingChange(Sender: TObject);
    procedure eSpacingExit(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure GraphMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ChangeCoordinateSystem(Sender: TObject);
  private
    FCalculator: TCalculator;
    FGraph: TGraph;
  protected
    procedure AddArray(const Value: array of string); virtual;
    procedure RectangularTrace(Sender: TObject; const X, Y: Double); virtual;
    procedure PolarTrace(Sender: TObject; const Angle, X, Y: Double); virtual;
  public
    procedure Clear; virtual;
    procedure Output(const Index: Integer; const Message: string = ''); overload; virtual;
    procedure Output(const Index: Integer; const Message: string;
      const Arguments: array of const); overload; virtual;
    property Calculator: TCalculator read FCalculator write FCalculator;
    property Graph: TGraph read FGraph write FGraph;
  end;

const
  MenuFileName = 'Menu.dat';
  WheelDelta = 1;
  EditChars = ['0'..'9', '-', Chr(VK_DELETE), Chr(VK_BACK)];
  TracePanel = 1;
  CursorPanel = 0;
  ErrorPanel = 2;
  FormulaMessage = 'Y = %s';
  CursorTraceMessage = 'Cursor: X = %f: Y = %f';
  RectangularTraceMessage = 'Tracing: X = %f: Y = %f';
  PolarTraceMessage = 'Tracing: %f degrees (%f radians); X = %f: Y = %f';

  RectangularArray: array[0..19] of string =
    ('1 / X ^ 2 - 2 * Sin (X ^ 2)', 'X ^ 2 mod X * Sin X',
    'X * Sin SumOfSquares (Sin X, X!, Sec X)', 'X * Sin X', 'X * Sin Int X',
    '15 * Sin ((Cos X + X ^ 2 mod X) / 5)', 'X * Sin Frac X', 'X * Sec X',
    'X * Sec Frac X', 'X * Sec Int X', 'SumOfSquares (Sin X, X, Sec X) / 10',
    'RandomFrom (SumOfSquares (Sin X, Cos X), SumOfSquares (Sec X, Csc X))',
    '(1 / X ^ 2 - 2 * Sin (X ^ 2)) * (SumOfSquares (Sin X, X, Sec X) / 10)',
    'MaxValue (Frac Power (Sin X, Cos Random X), Int X)',
    'MaxValue (Frac Power (Sin X, Cos Random X), X * Sin X)',
    'X * Sin X + X * Cos (1 - Int X)', 'X * Sin (X ^ 2)',
    '(X ^ Cos X) / (X ^ Sin X) / 2', '(X ^ Sin X) / (X ^ Cos X) / 2',
    'Sin X + SumOfSquares (Sin X, Cos X, Tan X)');

  PolarArray: array[0..13] of string =
    ('Angle', '1 / Angle ^ 2 - 2 * Sin (Angle ^ 2)', '5 * Cos Tan Angle',
    'Tan Angle + Sin Index', 'Cos Angle + Sin Index', 'Cos (Angle ^ 2) + Sin (Index ^ 2)',
    'Tan (Index or Angle)', 'Tan (Index and Angle)', 'Tan (Cotan Angle)',
    'CoTan (Sec Angle)', 'Angle + Cotan Angle', 'Cotan Angle + Tan Angle',
    'Sin Angle + Cotan Angle', '(Angle ^ 2 mod Angle * Sin Angle) or Angle');

var
  Main: TMain;

implementation

uses
  GraphicUtils, Math, NumberUtils, Parser, {$IFDEF DELPHI_XE2}System.UITypes, {$ENDIF}
  TextConsts, TextUtils;

{$R *.dfm}

procedure TMain.FormCreate(Sender: TObject);
begin
  FCalculator := TCalculator.Create(Self);
  FGraph := TGraph.Create(Self);
  FGraph.Parent := Self;
  FGraph.Align := alClient;
  FGraph.Parser := FCalculator.Parser;
  FGraph.OnMouseMove := GraphMouseMove;
  FGraph.OnRectangularTrace := RectangularTrace;
  FGraph.OnPolarTrace := PolarTrace;
  FGraph.CoordinateSystem := TCoordinateSystem(-1);
  GraphRectangular.Execute;
  with ActionManager do
  begin
    FileName := ExtractFilePath(Application.ExeName) + MenuFileName;
    if FileExists(FileName) then LoadFromFile(FileName);
  end;
end;

procedure TMain.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  MousePos := FGraph.ScreenToClient(MousePos);
  if PtInRect(Rect(0, 0, Width, Height), MousePos) then
  begin
    if FGraph.MaxX < udMaxX.Max then
    begin
      FGraph.MaxX := FGraph.MaxX + WheelDelta;
      udMaxX.Position := FGraph.MaxX;
    end;
    if FGraph.MaxY < udMaxY.Max then
    begin
      FGraph.MaxY := FGraph.MaxY + WheelDelta;
      udMaxY.Position := FGraph.MaxY;
    end;
    if Trim(FGraph.Formula) <> '' then FGraph.Calculate;
    FGraph.Invalidate;
  end;
end;

procedure TMain.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  MousePos := FGraph.ScreenToClient(MousePos);
  if PtInRect(Rect(0, 0, Width, Height), MousePos) then
  begin
    if FGraph.MaxX > udMaxX.Min then
    begin
      FGraph.MaxX := FGraph.MaxX - WheelDelta;
      udMaxX.Position := FGraph.MaxX;
    end;
    if FGraph.MaxY > udMaxY.Min then
    begin
      FGraph.MaxY := FGraph.MaxY - WheelDelta;
      udMaxY.Position := FGraph.MaxY;
    end;
    if Trim(FGraph.Formula) <> '' then FGraph.Calculate;
    FGraph.Invalidate;
  end;
end;

procedure TMain.ApplicationEventsHint(Sender: TObject);
begin
  if Length(Application.Hint) > 0 then
  begin
    StatusBar.SimplePanel := True;
    StatusBar.SimpleText := Application.Hint
  end
  else StatusBar.SimplePanel := False;
end;

procedure TMain.GraphDrawExecute(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    FGraph.Formula := cbFormula.Text;
    try
      FGraph.Calculate;
      Output(-1);
      Output(ErrorPanel, FormulaMessage, [FCalculator.Parser.ScriptToString(rmFull)]);
    except
      on E: Exception do
      begin
        FGraph.Clear;
        Output(ErrorPanel, E.Message);
      end;
    end;
    FGraph.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMain.GraphDrawUpdate(Sender: TObject);
begin
  GraphDraw.Enabled := cbFormula.Text <> '';
end;

procedure TMain.GraphGridExecute(Sender: TObject);
begin
  GraphGrid.Checked := not GraphGrid.Checked;
  FGraph.ShowGrid := GraphGrid.Checked;
  FGraph.Invalidate;
end;

procedure TMain.GraphGridUpdate(Sender: TObject);
begin
  GraphGrid.Checked := FGraph.ShowGrid;
end;

procedure TMain.GraphAxisExecute(Sender: TObject);
begin
  GraphAxis.Checked := not GraphAxis.Checked;
  FGraph.ShowAxis := GraphAxis.Checked;
  FGraph.Invalidate;
end;

procedure TMain.GraphAxisUpdate(Sender: TObject);
begin
  GraphAxis.Checked := FGraph.ShowAxis;
end;

procedure TMain.GraphTracingExecute(Sender: TObject);
begin
  GraphTracing.Checked := not GraphTracing.Checked;
  Output(TracePanel, '');
  FGraph.Tracing := GraphTracing.Checked;
  FGraph.Invalidate;
end;

procedure TMain.GraphTracingUpdate(Sender: TObject);
begin
  GraphTracing.Checked := FGraph.Tracing;
end;

procedure TMain.GraphCopyExecute(Sender: TObject);
begin
  ClipBoard.Assign(FGraph.Buffer);
end;

procedure TMain.GraphDeleteExecute(Sender: TObject);
begin
  Clear;
end;

procedure TMain.GraphRefreshExecute(Sender: TObject);
begin
  FGraph.Invalidate;
end;

procedure TMain.GraphColorExecute(Sender: TObject);
begin
  ColorDialog.Color := FGraph.GraphPen.Color;
  if ColorDialog.Execute then
  begin
    FGraph.GraphPen.Color := ColorDialog.Color;
    FGraph.Invalidate;
  end;
end;

procedure TMain.cbFormulaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_RETURN) then
  begin
    Key := #0;
    GraphDraw.Execute;
  end;
end;

procedure TMain.tbQualityChange(Sender: TObject);
begin
  FGraph.Quality := tbQuality.Position;
end;

procedure TMain.eMaxXChange(Sender: TObject);
begin
  FGraph.MaxX := udMaxX.Position;
  if Trim(FGraph.Formula) <> '' then FGraph.Calculate;
  FGraph.Invalidate;
end;

procedure TMain.eMaxXExit(Sender: TObject);
begin
  eMaxX.Text := IntToStr(FGraph.MaxX);
end;

procedure TMain.eMaxYChange(Sender: TObject);
begin
  FGraph.MaxY := udMaxY.Position;
  if Trim(FGraph.Formula) <> '' then FGraph.Calculate;
  FGraph.Invalidate;
end;

procedure TMain.eMaxYExit(Sender: TObject);
begin
  eMaxY.Text := IntToStr(FGraph.MaxY);
end;

procedure TMain.ePenWidthChange(Sender: TObject);
begin
  FGraph.GraphPen.Width := udPenWidth.Position;
  FGraph.Invalidate;
end;

procedure TMain.ePenWidthExit(Sender: TObject);
begin
  ePenWidth.Text := IntToStr(FGraph.GraphPen.Width);
end;

procedure TMain.eSpacingChange(Sender: TObject);
begin
  FGraph.HorzSpacing := udSpacing.Position;
  FGraph.VertSpacing := udSpacing.Position;
  FGraph.Invalidate;
end;

procedure TMain.eSpacingExit(Sender: TObject);
begin
  eSpacing.Text := FloatToStr(FGraph.HorzSpacing);
end;

procedure TMain.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, EditChars) then Key := #0;
end;

procedure TMain.GraphMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Output(CursorPanel, CursorTraceMessage, [FGraph.GetX(X), FGraph.GetY(Y)]);
end;

procedure TMain.ChangeCoordinateSystem(Sender: TObject);
var
  Value: TCoordinateSystem;
begin
  Value := TCoordinateSystem(TComponent(Sender).Tag);
  if Value <> FGraph.CoordinateSystem then
  begin
    if Assigned(FGraph) then FGraph.CoordinateSystem := Value;
    Clear;
    cbFormula.Items.Clear;
    case FGraph.CoordinateSystem of
      csRectangular: AddArray(RectangularArray);
      csPolar: AddArray(PolarArray);
    end;
  end;
end;

procedure TMain.PolarTrace(Sender: TObject; const Angle, X, Y: Double);
begin
  Output(TracePanel, PolarTraceMessage, [RadToDeg(Angle), Angle, FGraph.GetX(X), FGraph.GetY(Y)]);
end;

procedure TMain.AddArray(const Value: array of string);
var
  I: Integer;
begin
  for I := Low(Value) to High(Value) do cbFormula.Items.Add(Value[I]);
end;

procedure TMain.RectangularTrace(Sender: TObject; const X, Y: Double);
begin
  Output(TracePanel, RectangularTraceMessage, [FGraph.GetX(X), FGraph.GetY(Y)]);
end;

procedure TMain.Clear;
begin
  FGraph.Clear;
  FGraph.Invalidate;
  Output(-1);
end;

procedure TMain.Output(const Index: Integer; const Message: string;
  const Arguments: array of const);
begin
  StatusBar.Panels[Index].Text := Format(Message, Arguments);
end;

procedure TMain.Output(const Index: Integer; const Message: string);
var
  I: Integer;
begin
  if Index < 0 then
    for I := 0 to StatusBar.Panels.Count - 1 do StatusBar.Panels[I].Text := ''
  else
    Output(Index, Message, []);
end;

initialization
  RegisterClasses([TLabel, TMenuItem, TPanel, TToolButton]);

end.
