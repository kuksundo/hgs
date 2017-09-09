{.GXFormatter.config=twm}
/// <summary>
/// This unit implements a string grid that does not store any data. Instead it
/// has an OnGetData event which is called every time a cell is drawn. This
/// prevents duplicating the data just for the purpose of displaying it. </summary>

unit c_dzVirtualStringGrid;

{$include 'jedi.inc'}

interface

uses
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Grids;

type
  TdzCellVertAlign = (cvTop, cvCenter, cvBottom);

  TOnGetCellText = procedure(_Sender: TObject; _GridCol, _GridRow: Integer;
    _State: TGridDrawState;
    var _Text: string; var _HAlign: TAlignment; var _VAlign: TdzCellVertAlign;
    _Font: TFont; var _Color: TColor) of object;
  TOnGetDataText = procedure(_Sender: TObject; _DataCol, _DataRow: Integer; _State: TGridDrawState;
    var _Text: string; var _HAlign: TAlignment; var _VAlign: TdzCellVertAlign;
    _Font: TFont; var _Color: TColor) of object;
  TOnGetRowHead = procedure(_Sender: TObject; _Row: Integer; _State: TGridDrawState;
    var _Text: string; var _HAlign: TAlignment; var _VAlign: TdzCellVertAlign;
    _Font: TFont; var _Color: TColor) of object;
  TOnGetColHead = procedure(_Sender: TObject; _Col: Integer; _State: TGridDrawState;
    var _Text: string; var _HAlign: TAlignment; var _VAlign: TdzCellVertAlign;
    _Font: TFont; var _Color: TColor) of object;
  TOnCanEditModify = procedure(_Sender: TObject; _DataCol, _DataRow: Integer;
    var _CanModify: Boolean) of object;
  TOnCanEditShow = procedure(_Sender: TObject; _DataCol, _DataRow: Integer; var _CanShow: Boolean) of object;
  TOnCanEditAcceptKey = procedure(_Sender: TObject; _Char: Char; var _Accept: Boolean) of object;
  TOnInsertRow = procedure(_Sender: TObject; _Row: Integer; var _Inserted: Boolean) of object;
  TdzDrawCellEvent = procedure(_Sender: TObject; _Col, _Row: Integer; _Rect: TRect;
    _State: TGridDrawState; var _Drawn: Boolean) of object;
  TOnCopyToClipboard = procedure(_Sender: TObject; var _Done: Boolean) of object;

  TCustomdzVirtualStringGrid = class(TCustomGrid)
  protected
    fCellHorzAlign: TAlignment;
    fCellVertAlign: TdzCellVertAlign;
    fOnGetColHead: TOnGetColHead;
    fOnGetRowHead: TOnGetRowHead;
    fOnGetFixedCellData: TOnGetCellText;
    fOnGetNonfixedCellData: TOnGetDataText;
    fOnGetData: TOnGetCellText;
    fOnSelectCell: TSelectCellEvent;
    fOnGetEditText: TGetEditEvent;
    fOnSetEditText: TSetEditEvent;
    fOnGetEditMask: TGetEditEvent;
    fOnCanEditModify: TOnCanEditModify;
    fOnCanEditShow: TOnCanEditShow;
    fOnCanEditAcceptKey: TOnCanEditAcceptKey;
    fOnInsertRow: TOnInsertRow;
    fOnTopLeftChanged: TNotifyEvent;
    fOnDrawCell: TdzDrawCellEvent;
    {: stores the OnPasteFromClipboard event handler }
    fOnPasteFromClipboard: TNotifyEvent;
    {: stores the OnCopyToClipboard event handler }
    fOnCopyToClipboard: TOnCopyToClipboard;
    {: stores the ColumnHeaders property }
    fColumnHeaders: TStringList;
    function CalcColHeight(_Col, _Row: Integer): Integer;
    procedure DrawCell(_Col, _Row: LongInt; _Rect: TRect;
      _State: TGridDrawState); override;
    function SelectCell(_Col, _Row: LongInt): Boolean; override;
    procedure GetData(_Col, _Row: Integer; _State: TGridDrawState;
      var _Text: string; var _HAlign: TAlignment; var _VAlign: TdzCellVertAlign;
      _Font: TFont; var _Color: TColor);
    function GetEditText(_Col, _Row: LongInt): string; override;
    procedure SetEditText(_Col, _Row: Integer; const _EditText: string); override;
    function GetEditMask(_Col, _Row: LongInt): string; override;
    function CanEditModify: Boolean; override;
    function CanEditAcceptKey(Key: Char): Boolean; override;
    function CanEditShow: Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function InsertRow(_Row: Integer): Boolean;
    // this function is private in TCustomGrid :-(
    function CalcMaxTopLeft(const Coord: TGridCoord;
      const DrawInfo: TGridDrawInfo): TGridCoord;

    procedure WMCommand(var _Msg: TWMCommand); message WM_Command;

    procedure SetColumnHeaders(_ColumnHeaders: TStringList);
    procedure TopLeftChanged; override;
    property CellHorzAlign: TAlignment read fCellHorzAlign write fCellHorzAlign stored True default taLeftJustify;
    property CellVertAlign: TdzCellVertAlign read fCellVertAlign write fCellVertAlign stored True default cvCenter;
    property DefaultRowHeight stored True default 16;
    property FixedCols stored True default 0;
    property Options default [goFixedVertLine, goFixedHorzLine, goVertLine,
      goHorzLine, goColSizing];
    property RowCount stored True default 2;
    ///<summary> Strings to be used for column headers </summary>
    property ColumnHeaders: TStringList read fColumnHeaders write SetColumnHeaders;
    // the following events are used to get the data for drawing
    // the first Event that is assigned will get called
    // The order is:
    // a) for Column Headers (e.g. the row it is a fixed row)
    //    1. OnGetColHead
    //    2. OnGetFixedCellData
    //    3. OnGetData
    // b) for row headers (e.g. the column is a fixed column but the row is not fixed)
    //    1. OnGetRowHead
    //    2. OnGetFixedCellData
    //    3. OnGetData
    // c) for non fixed cells
    //    1. OnGetNonfixedCellData (passing Data indexes, that is _Row = Row - FixedRows
    //                              and _Col = Col - FixedCols )
    //    2. OnGetData (passing cell indexes)
    // So, if you want to get indexes like in any other grid, just assign
    // OnGetData. If you like some more comfort, use the other events.
    property OnGetColHead: TOnGetColHead read fOnGetColHead write fOnGetColHead;
    property OnGetRowHead: TOnGetRowHead read fOnGetRowHead write fOnGetRowHead;
    property OnGetFixedCellData: TOnGetCellText read fOnGetFixedCellData write fOnGetFixedCellData;
    property OnGetNonfixedCellData: TOnGetDataText read fOnGetNonfixedCellData write fOnGetNonfixedCellData;
    property OnGetData: TOnGetCellText read fOnGetData write fOnGetData;

    property OnGetEditMask: TGetEditEvent read fOnGetEditMask write fOnGetEditMask;
    property OnGetEditText: TGetEditEvent read fOnGetEditText write fOnGetEditText;
    property OnSetEditText: TSetEditEvent read fOnSetEditText write fOnSetEditText;
    property OnCanEditModify: TOnCanEditModify read fOnCanEditModify write fOnCanEditModify;
    property OnCanEditShow: TOnCanEditShow read fOnCanEditShow write fOnCanEditShow;
    property OnCanEditAcceptKey: TOnCanEditAcceptKey read fOnCanEditAcceptKey write fOnCanEditAcceptKey;
    property OnInsertRow: TOnInsertRow read fOnInsertRow write fOnInsertRow;
    property OnSelectCell: TSelectCellEvent read fOnSelectCell write fOnSelectCell;
    property OnTopLeftChanged: TNotifyEvent read fOnTopLeftChanged write fOnTopLeftChanged;
    property OnDrawCell: TdzDrawCellEvent read fOnDrawCell write fOnDrawCell;
    property OnPasteFromClipboard: TNotifyEvent read fOnPasteFromClipboard write fOnPasteFromClipboard;
    property OnCopyToClipboard: TOnCopyToClipboard read fOnCopyToClipboard write fOnCopyToClipboard;
  public
    constructor Create(_Owner: TComponent); override;
    destructor Destroy; override;
    function GetDataCol: Integer; overload;
    function GetDataRow: Integer; overload;
    function GetDataRow(_Row: Integer): Integer; overload;
    function GetDataCol(_Col: Integer): Integer; overload;
    function GetDisplayRow(_Row: Integer): Integer;
    function GetDisplayCol(_Col: Integer): Integer;
    procedure InvalidateCell(_Col, _Row: LongInt);
    procedure InvalidateCol(_Col: LongInt);
    procedure InvalidateRow(_Row: LongInt);
    procedure InvalidateGrid;
    function CellRect(_Col, _Row: Integer): TRect; virtual;
    function GetCellText(_Col, _Row: Integer): string; virtual;
    procedure CopyToClipboard; virtual;
    procedure PasteFromClipboard; virtual;
    procedure SelectAll; virtual;
    procedure SafeSetRowCount(_RowCount: Integer);
    procedure ScrollDownToEnd;
    procedure AdjustLineHeights(const _ResizeableCols: array of Integer);
  end;

  TdzVirtualStringGrid = class(TCustomdzVirtualStringGrid)
  public
    property Canvas;
    property Col;
    property ColWidths;
    property EditorMode;
    property GridHeight;
    property GridWidth;
    property LeftCol;
    property Selection;
    property Row;
    property RowHeights;
    property TabStops;
    property TopRow;
    property InplaceEditor;
  published
    property OnPasteFromClipboard;
    property OnCopyToClipboard;
    property ColumnHeaders;
    property CellHorzAlign;
    property CellVertAlign;
    property OnGetColHead;
    property OnGetRowHead;
    property OnGetFixedCellData;
    property OnGetNonfixedCellData;
    property OnGetData;
    property OnGetEditMask;
    property OnGetEditText;
    property OnSetEditText;
    property OnCanEditModify;
    property OnCanEditShow;
    property OnCanEditAcceptKey;
    property OnInsertRow;
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property ColCount;
    property Constraints;
    property Ctl3D;
    property DefaultRowHeight;
    property DefaultColWidth;
    property DefaultDrawing;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property FixedCols;
    property FixedRows;
    property Font;
    property GridLineWidth;
    property Options;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RowCount;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property VisibleColCount;
    property VisibleRowCount;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnSelectCell;
    property OnTopLeftChanged;
    property OnDrawCell;
  end;

implementation

uses
  u_dzVclUtils,
  Clipbrd;

// copied from Controls

function DoControlMsg(ControlHandle: HWnd; var Message): Boolean;
var
  Control: TWinControl;
begin
  DoControlMsg := False;
  Control := FindControl(ControlHandle);
  if Control <> nil then
    with TMessage(Message) do begin
      Result := Control.Perform(Msg + CN_BASE, WParam, LParam);
      DoControlMsg := True;
    end;
end;

{ TCustomdzVirtualStringGrid }

constructor TCustomdzVirtualStringGrid.Create(_Owner: TComponent);
begin
  inherited;
  fColumnHeaders := TStringList.Create;
  fCellHorzAlign := taLeftJustify;
  fCellVertAlign := cvCenter;
  DefaultRowHeight := 16;
  FixedCols := 0;
  RowCount := 2;
  Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing];
end;

destructor TCustomdzVirtualStringGrid.Destroy;
begin
  fColumnHeaders.Free;
  inherited;
end;

procedure TCustomdzVirtualStringGrid.GetData(_Col, _Row: Integer; _State: TGridDrawState;
  var _Text: string; var _HAlign: TAlignment; var _VAlign: TdzCellVertAlign;
  _Font: TFont; var _Color: TColor);
begin
  if csDesigning in ComponentState then
    _Text := Format('%d:%d', [_Row, _Col]);
  if _Row < FixedRows then begin
    if fColumnHeaders.Count > _Col then
      _Text := fColumnHeaders[_Col];
    if Assigned(OnGetColHead) then
      OnGetColHead(Self, _Col, _State, _Text, _HAlign, _VAlign, _Font, _Color);
    if Assigned(OnGetFixedCellData) then begin
      OnGetFixedCellData(Self, _Col, _Row, _State, _Text, _HAlign, _VAlign,
        _Font, _Color);
    end;
  end else if _Col < FixedCols then begin
    if Assigned(OnGetRowHead) then begin
      OnGetRowHead(Self, _Row, _State, _Text, _HAlign, _VAlign, _Font, _Color);
    end;
    if Assigned(OnGetFixedCellData) then begin
      OnGetFixedCellData(Self, _Col, _Row, _State, _Text, _HAlign, _VAlign,
        _Font, _Color);
    end;
  end else if Assigned(OnGetNonfixedCellData) then begin
    OnGetNonfixedCellData(Self, _Col - FixedCols, _Row - FixedRows, _State,
      _Text, _HAlign, _VAlign, _Font, _Color);
  end;
  // catch all: The user wants it the traditional way.
  if Assigned(OnGetData) then
    OnGetData(Self, _Col, _Row, _State, _Text, _HAlign, _VAlign, _Font, _Color)
end;

procedure TCustomdzVirtualStringGrid.DrawCell(_Col, _Row: Integer; _Rect: TRect;
  _State: TGridDrawState);
var
  Drawn: Boolean;
  Text: string;
  HAlign: TAlignment;
  VAlign: TdzCellVertAlign;
  TextHoeheMg: Integer;
  TextBreite: Integer;
  XPos, YPos: Integer;
  BgColor: TColor;
  DefaultColor: TColor;
  CanvasFont: TFont;
  CanvasBrush: TBrush;
  CanvasPen: TPen;
begin
  if not Assigned(Parent) then
    Exit;
  if Assigned(OnDrawCell) then begin
    Drawn := False;
    OnDrawCell(Self, _Col, _Row, _Rect, _State, Drawn);
    if Drawn then
      Exit;
  end;

  CanvasFont := TFont.Create;
  CanvasBrush := TBrush.Create;
  CanvasPen := TPen.Create;
  try
    CanvasFont.Assign(Canvas.Font);
    CanvasBrush.Assign(Canvas.Brush);
    CanvasPen.Assign(Canvas.Pen);
    Text := '';
    HAlign := CellHorzAlign;
    VAlign := CellVertAlign;
    DefaultColor := Canvas.Brush.Color;
    BgColor := DefaultColor;
    GetData(_Col, _Row, _State, Text, HAlign, VAlign, Canvas.Font, BgColor);
    TextHoeheMg := Canvas.TextHeight('Mg');
    TextBreite := Canvas.TextWidth(Text);
    case HAlign of
      taRightJustify: XPos := _Rect.Right - 2 - TextBreite;
      taCenter: XPos := _Rect.Left + ((_Rect.Right - _Rect.Left) - TextBreite) div 2;
    else // chLeft
      XPos := _Rect.Left + 2;
    end;
    case VAlign of
      cvTop: YPos := _Rect.Top + 2;
      cvBottom: YPos := _Rect.Bottom - 2 - TextHoeheMg;
    else // cvCenter
      YPos := _Rect.Top + ((_Rect.Bottom - _Rect.Top) - TextHoeheMg) div 2;
    end;
    if not DefaultDrawing or (BgColor <> DefaultColor) then begin
      Canvas.Brush.Color := BgColor;
      Canvas.FillRect(_Rect);
    end;
    //    if gdFixed in _State then
    //      Canvas.TextRect(_Rect, XPos, YPos, Text)
    //    else
    //      begin
    Canvas.TextRect(_Rect, XPos, YPos, Text);
    //        if gdFocused in _State then
    //          Canvas.FrameRect(_Rect);
    //      end;
    Canvas.Font.Assign(CanvasFont);
    Canvas.Brush.Assign(CanvasBrush);
    Canvas.Pen.Assign(CanvasPen);
  finally
    CanvasPen.Free;
    CanvasBrush.Free;
    CanvasFont.Free;
  end;
end;

function TCustomdzVirtualStringGrid.SelectCell(_Col, _Row: Integer): Boolean;
begin
  Result := True;
  if Assigned(fOnSelectCell) then
    fOnSelectCell(Self, _Col, _Row, Result);
end;

function TCustomdzVirtualStringGrid.GetEditText(_Col, _Row: Integer): string;
begin
  if Assigned(OnGetEditText) then
    OnGetEditText(Self, _Col, _Row, Result)
  else
    Result := GetCellText(_Col, _Row);
end;

procedure TCustomdzVirtualStringGrid.SetEditText(_Col, _Row: Integer; const _EditText: string);
begin
  if Assigned(OnSetEditText) then
    OnSetEditText(Self, _Col, _Row, _EditText);
end;

function TCustomdzVirtualStringGrid.GetEditMask(_Col, _Row: Integer): string;
begin
  if Assigned(OnGetEditMask) then
    OnGetEditMask(Self, _Col, _Row, Result)
  else
    Result := '';
end;

function TCustomdzVirtualStringGrid.CanEditModify: Boolean;
begin
  Result := inherited CanEditModify;
  if Assigned(OnCanEditModify) then
    OnCanEditModify(Self, Col, Row, Result);
end;

function TCustomdzVirtualStringGrid.CanEditShow: Boolean;
begin
  Result := inherited CanEditShow;
  if Assigned(OnCanEditShow) then
    OnCanEditShow(Self, Col, Row, Result);
end;

function TCustomdzVirtualStringGrid.CanEditAcceptKey(Key: Char): Boolean;
begin
  Result := True;
  if Assigned(OnCanEditAcceptKey) then
    OnCanEditAcceptKey(Self, Key, Result);
end;

procedure TCustomdzVirtualStringGrid.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewTopLeft, NewCurrent, MaxTopLeft: TGridCoord;
  DrawInfo: TGridDrawInfo;
  PageWidth, PageHeight: Integer;
  //  RTLFactor: Integer;
  NeedsInvalidating: Boolean;

  procedure CalcPageExtents;
  begin
    CalcDrawInfo(DrawInfo);
    PageWidth := DrawInfo.Horz.LastFullVisibleCell - LeftCol;
    if PageWidth < 1 then
      PageWidth := 1;
    PageHeight := DrawInfo.Vert.LastFullVisibleCell - TopRow;
    if PageHeight < 1 then
      PageHeight := 1;
  end;

  procedure Restrict(var Coord: TGridCoord; MinX, MinY, MaxX, MaxY: LongInt);
  begin
    with Coord do begin
      if X > MaxX then
        X := MaxX
      else if X < MinX then
        X := MinX;
      if Y > MaxY then
        Y := MaxY
      else if Y < MinY then
        Y := MinY;
    end;
  end;

begin
  NeedsInvalidating := False;
  if not CanGridAcceptKey(Key, Shift) then
    Key := 0;
  //  if not UseRightToLeftAlignment then
  //    RTLFactor := 1
  //  else
  //    RTLFactor := -1;
  NewCurrent.X := Col;
  NewCurrent.Y := Row;
  NewTopLeft.X := LeftCol;
  NewTopLeft.Y := TopRow;
  CalcPageExtents;
  if (Key = VK_TAB) and (Shift - [ssShift] = []) then begin
    repeat
      if ssShift in Shift then begin
        Dec(NewCurrent.X);
        if NewCurrent.X < FixedCols then begin
          NewCurrent.X := ColCount - 1;
          Dec(NewCurrent.Y);
          if NewCurrent.Y < FixedRows then
            NewCurrent.Y := RowCount - 1;
        end;
        Shift := [];
      end else begin
        Inc(NewCurrent.X);
        if NewCurrent.X >= ColCount then begin
          NewCurrent.X := FixedCols;
          Inc(NewCurrent.Y);
          if NewCurrent.Y >= RowCount then
            if InsertRow(NewCurrent.Y) then
              NewCurrent.Y := RowCount
            else
              NewCurrent.Y := FixedRows;
        end;
      end;
    until TabStops[NewCurrent.X] or (NewCurrent.X = Col);
    MaxTopLeft.X := ColCount - 1;
    MaxTopLeft.Y := RowCount - 1;
    MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
    Restrict(NewTopLeft, FixedCols, FixedRows, MaxTopLeft.X, MaxTopLeft.Y);
    if NewTopLeft.X <> LeftCol then
      LeftCol := NewTopLeft.X;
    if NewTopLeft.Y <> TopRow then
      TopRow := NewTopLeft.Y;
    Restrict(NewCurrent, FixedCols, FixedRows, ColCount - 1, RowCount - 1);
    if NewCurrent.X <> Col then
      Col := NewCurrent.X;
    if NewCurrent.Y <> Row then
      Row := NewCurrent.Y;
    if NeedsInvalidating then
      Invalidate;
  end else
    inherited KeyDown(Key, Shift);

  //  NeedsInvalidating := False;
  //  if not CanGridAcceptKey(Key, Shift) then Key := 0;
  //  if not UseRightToLeftAlignment then
  //    RTLFactor := 1
  //  else
  //    RTLFactor := -1;
  //  NewCurrent := FCurrent;
  //  NewTopLeft := FTopLeft;
  //  CalcPageExtents;
  //  if ssCtrl in Shift then
  //    case Key of
  //      VK_UP: Dec(NewTopLeft.Y);
  //      VK_DOWN: Inc(NewTopLeft.Y);
  //      VK_LEFT:
  //        if not (goRowSelect in Options) then
  //        begin
  //          Dec(NewCurrent.X, PageWidth * RTLFactor);
  //          Dec(NewTopLeft.X, PageWidth * RTLFactor);
  //        end;
  //      VK_RIGHT:
  //        if not (goRowSelect in Options) then
  //        begin
  //          Inc(NewCurrent.X, PageWidth * RTLFactor);
  //          Inc(NewTopLeft.X, PageWidth * RTLFactor);
  //        end;
  //      VK_PRIOR: NewCurrent.Y := TopRow;
  //      VK_NEXT: NewCurrent.Y := DrawInfo.Vert.LastFullVisibleCell;
  //      VK_HOME:
  //        begin
  //          NewCurrent.X := FixedCols;
  //          NewCurrent.Y := FixedRows;
  //          NeedsInvalidating := UseRightToLeftAlignment;
  //        end;
  //      VK_END:
  //        begin
  //          NewCurrent.X := ColCount - 1;
  //          NewCurrent.Y := RowCount - 1;
  //          NeedsInvalidating := UseRightToLeftAlignment;
  //        end;
  //    end
  //  else
  //    case Key of
  //      VK_UP: Dec(NewCurrent.Y);
  //      VK_DOWN: Inc(NewCurrent.Y);
  //      VK_LEFT:
  //        if goRowSelect in Options then
  //          Dec(NewCurrent.Y, RTLFactor) else
  //          Dec(NewCurrent.X, RTLFactor);
  //      VK_RIGHT:
  //        if goRowSelect in Options then
  //          Inc(NewCurrent.Y, RTLFactor) else
  //          Inc(NewCurrent.X, RTLFactor);
  //      VK_NEXT:
  //        begin
  //          Inc(NewCurrent.Y, PageHeight);
  //          Inc(NewTopLeft.Y, PageHeight);
  //        end;
  //      VK_PRIOR:
  //        begin
  //          Dec(NewCurrent.Y, PageHeight);
  //          Dec(NewTopLeft.Y, PageHeight);
  //        end;
  //      VK_HOME:
  //        if goRowSelect in Options then
  //          NewCurrent.Y := FixedRows else
  //          NewCurrent.X := FixedCols;
  //      VK_END:
  //        if goRowSelect in Options then
  //          NewCurrent.Y := RowCount - 1 else
  //          NewCurrent.X := ColCount - 1;
  //      VK_TAB:
  //        if not (ssAlt in Shift) then
  //        repeat
  //          if ssShift in Shift then
  //          begin
  //            Dec(NewCurrent.X);
  //            if NewCurrent.X < FixedCols then
  //            begin
  //              NewCurrent.X := ColCount - 1;
  //              Dec(NewCurrent.Y);
  //              if NewCurrent.Y < FixedRows then NewCurrent.Y := RowCount - 1;
  //            end;
  //            Shift := [];
  //          end
  //          else
  //          begin
  //            Inc(NewCurrent.X);
  //            if NewCurrent.X >= ColCount then
  //            begin
  //              NewCurrent.X := FixedCols;
  //              Inc(NewCurrent.Y);
  //              if NewCurrent.Y >= RowCount then NewCurrent.Y := FixedRows;
  //            end;
  //          end;
  //        until TabStops[NewCurrent.X] or (NewCurrent.X = FCurrent.X);
  //      VK_F2: EditorMode := True;
  //    end;
  //  MaxTopLeft.X := ColCount - 1;
  //  MaxTopLeft.Y := RowCount - 1;
  //  MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  //  Restrict(NewTopLeft, FixedCols, FixedRows, MaxTopLeft.X, MaxTopLeft.Y);
  //  if (NewTopLeft.X <> LeftCol) or (NewTopLeft.Y <> TopRow) then
  //    MoveTopLeft(NewTopLeft.X, NewTopLeft.Y);
  //  Restrict(NewCurrent, FixedCols, FixedRows, ColCount - 1, RowCount - 1);
  //  if (NewCurrent.X <> Col) or (NewCurrent.Y <> Row) then
  //    FocusCell(NewCurrent.X, NewCurrent.Y, not (ssShift in Shift));
  //  if NeedsInvalidating then Invalidate;
end;

function TCustomdzVirtualStringGrid.CalcMaxTopLeft(const Coord: TGridCoord;
  const DrawInfo: TGridDrawInfo): TGridCoord;

  function CalcMaxCell(const Axis: TGridAxisDrawInfo; Start: Integer): Integer;
  var
    Line: Integer;
    i, Extent: LongInt;
  begin
    Result := Start;
    with Axis do begin
      Line := GridExtent + EffectiveLineWidth;
      for i := Start downto FixedCellCount do begin
        Extent := GetExtent(i);
        if Extent > 0 then begin
          Dec(Line, Extent);
          Dec(Line, EffectiveLineWidth);
          if Line < FixedBoundary then begin
            if (Result = Start) and (GetExtent(Start) <= 0) then
              Result := i;
            break;
          end;
          Result := i;
        end;
      end;
    end;
  end;

begin
  Result.X := CalcMaxCell(DrawInfo.Horz, Coord.X);
  Result.Y := CalcMaxCell(DrawInfo.Vert, Coord.Y);
end;

function TCustomdzVirtualStringGrid.InsertRow(_Row: Integer): Boolean;
begin
  Result := False;
  if Assigned(OnInsertRow) then
    OnInsertRow(Self, _Row, Result);
end;

function TCustomdzVirtualStringGrid.GetDataCol(_Col: Integer): Integer;
begin
  Result := _Col - FixedCols;
end;

function TCustomdzVirtualStringGrid.GetDataCol: Integer;
begin
  Result := GetDataCol(Col);
end;

function TCustomdzVirtualStringGrid.GetDataRow(_Row: Integer): Integer;
begin
  Result := _Row - FixedRows;
end;

function TCustomdzVirtualStringGrid.GetDataRow: Integer;
begin
  Result := GetDataRow(Row);
end;

procedure TCustomdzVirtualStringGrid.InvalidateGrid;
var
  r: Integer;
begin
  for r := 0 to RowCount - 1 do
    InvalidateRow(r);
end;

procedure TCustomdzVirtualStringGrid.InvalidateCell(_Col, _Row: Integer);
begin
  HideEditor;
  inherited;
  if goAlwaysShowEditor in Options then
    ShowEditor;
end;

procedure TCustomdzVirtualStringGrid.InvalidateCol(_Col: Integer);
begin
  HideEditor;
  inherited;
  if goAlwaysShowEditor in Options then
    ShowEditor;
end;

procedure TCustomdzVirtualStringGrid.InvalidateRow(_Row: Integer);
begin
  HideEditor;
  inherited;
  if goAlwaysShowEditor in Options then
    ShowEditor;
end;

function TCustomdzVirtualStringGrid.GetDisplayCol(_Col: Integer): Integer;
begin
  Result := _Col + FixedCols;
end;

function TCustomdzVirtualStringGrid.GetDisplayRow(_Row: Integer): Integer;
begin
  Result := _Row + FixedRows;
end;

// Why is this function not virtual to start with?

function TCustomdzVirtualStringGrid.CellRect(_Col, _Row: Integer): TRect;
begin
  Result := inherited CellRect(_Col, _Row);
end;

procedure TCustomdzVirtualStringGrid.SetColumnHeaders(
  _ColumnHeaders: TStringList);
var
  i: Integer;
begin
  fColumnHeaders.Assign(_ColumnHeaders);
  for i := 0 to FixedRows - 1 do
    InvalidateRow(i);
end;

procedure TCustomdzVirtualStringGrid.TopLeftChanged;
begin
  inherited;
  if Assigned(FOnTopLeftChanged) then
    FOnTopLeftChanged(Self);
end;

procedure TCustomdzVirtualStringGrid.WMCommand(var _Msg: TWMCommand);
begin
  inherited;
  DoControlMsg(_Msg.Ctl, _Msg);
end;

function TCustomdzVirtualStringGrid.GetCellText(_Col, _Row: Integer): string;
var
  HAlign: TAlignment;
  VAlign: TdzCellVertAlign;
  Color: TColor;
  Font: TFont;
begin
  HAlign := taLeftJustify;
  VAlign := cvTop;
  Color := clBlack;
  Font := TFont.Create;
  try
    GetData(_Col, _Row, [], Result, HAlign, VAlign, Font, Color);
  finally
    Font.Free;
  end;
end;

procedure TCustomdzVirtualStringGrid.CopyToClipboard;
var
  r: Integer;
  c: Integer;
  RowStr: string;
  s: string;
  Done: Boolean;
begin
  Done := False;
  if Assigned(fOnCopyToClipboard) then
    fOnCopyToClipboard(Self, Done);
  if Done then
    Exit;
  s := '';
  for r := Selection.Top to Selection.Bottom do begin
    RowStr := '';
    for c := Selection.Left to Selection.Right do begin
      if RowStr <> '' then
        RowStr := RowStr + #9;
      RowStr := RowStr + GetCellText(c, r);
    end;
    s := s + RowStr + #13#10;
  end;
  Clipboard.AsText := s;
end;

procedure TCustomdzVirtualStringGrid.PasteFromClipboard;
begin
  if Assigned(fOnPasteFromClipboard) then
    fOnPasteFromClipboard(Self);
end;

procedure TCustomdzVirtualStringGrid.SelectAll;
var
  Rect: TGridRect;
begin
  Rect.Left := FixedCols;
  Rect.Top := FixedRows;
  Rect.Right := ColCount - 1;
  Rect.Bottom := RowCount - 1;
  Selection := Rect;
end;

procedure TCustomdzVirtualStringGrid.SafeSetRowCount(_RowCount: Integer);
begin
  if _RowCount < FixedRows + 1 then
    RowCount := FixedRows + 1
  else
    RowCount := _RowCount;
end;

procedure TCustomdzVirtualStringGrid.ScrollDownToEnd;
var
  Msg: TWMVScroll;
begin
  Msg.Msg := WM_VSCROLL;
  Msg.ScrollCode := SB_BOTTOM;
  Msg.Pos := 0;
  Msg.ScrollBar := 0;
  Dispatch(Msg);
  Row := RowCount - 1;
end;

function TCustomdzVirtualStringGrid.CalcColHeight(_Col, _Row: Integer): Integer;
var
  TheRect: TRect;
  s: string;
begin
  s := GetCellText(_Col, _Row);
  TheRect := Rect(0, 0, ColWidths[_Col], DefaultRowHeight);
  Result := DrawText(Canvas.Handle, PChar(s), Length(s), TheRect,
    DT_LEFT or DT_WORDBREAK or DT_CALCRECT) + 4;
end;

procedure TCustomdzVirtualStringGrid.AdjustLineHeights(const _ResizeableCols: array of Integer);

  procedure AdjustRowHeight(_Row: Integer);
  var
    h: Integer;
    c: Integer;
    MaxH: Integer;
  begin
    MaxH := DefaultRowHeight;
    for c := FixedCols to ColCount - 1 do begin
      if ArrayContains(c, _ResizeableCols) then begin
        h := CalcColHeight(c, _Row);
        if h > MaxH then
          MaxH := h;
      end;
      RowHeights[_Row] := MaxH;
    end;
  end;

var
  i: Integer;
  OldTopRow: Integer;
begin
  OldTopRow := TopRow;
  i := OldTopRow - 100;
  if i < FixedRows then
    i := FixedRows;
  while (i < RowCount) and (i < OldTopRow + VisibleRowCount) do begin
    AdjustRowHeight(i);
    Inc(i);
  end;
  TopRow := OldTopRow;
end;

end.

