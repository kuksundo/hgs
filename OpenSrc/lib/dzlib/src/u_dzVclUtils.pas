{.GXFormatter.config=twm}
///<summary>
/// Implements functions which work on components but are not methods.
///  @author        twm </summary>
unit u_dzVclUtils;

{$INCLUDE jedi.inc}

// If this conditional define is set, all messages received in the hooked
// WindowProc are written to the console window -> requires a console
{.$DEFINE dzMESSAGEDEBUG}

interface

uses
  Classes,
  Windows,
  SysUtils,
  Graphics,
  Forms,
  Messages,
  Controls,
  ComCtrls,
  CommCtrl,
  CheckLst,
  StdCtrls,
  ExtCtrls,
  Grids,
  DBGrids,
  Buttons,
  Menus,
{$IFDEF HAS_UNIT_SYSTEM_ACTIONS}
  System.Actions,
{$ENDIF}
  ActnList,
  ComObj,
  u_dzTranslator,
  u_dzTypes,
  u_dzInputValidator;

type
  ///<summary> Ancestor to all exceptions raised in this unit. </summary>
  EdzVclUtils = class(Exception);

  ///<summary> raised if the Combobox passed to SetOwnerDrawComboItemCount is not owner drawn. </summary>
  EdzComboBoxNotOwnerDraw = class(EdzVclUtils);

  ///<summary> raised if the Listbox passed to SetOwnerDrawListboxItemCount is not owner drawn. </summary>
  EdzListBoxNotOwnerDraw = class(EdzVclUtils);

  EdzComboBoxNoSelection = class(EdzVclUtils);
  EdzListBoxNoSelection = class(EdzVclUtils);

type
  ///<summary> This is a copy of the TFileFormatsList class from Graphics which
  ///          is unfortunately only declaread in the implementation section </summary>
  TFileFormatsList = class(TList)
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const Ext, Desc: string; DescID: Integer; AClass: TGraphicClass);
    function FindExt(Ext: string): TGraphicClass;
    function FindClassName(const ClassName: string): TGraphicClass;
    procedure Remove(AClass: TGraphicClass);
    ///<summary> returns a file select filter string for all descendants of the given TGraphicClass </summary>
    procedure BuildFilterStrings(GraphicClass: TGraphicClass; var Descriptions, Filters: string);
    function GetFilterString(GraphicClass: TGraphicClass = nil): string;
  end;

function GetModifierKeyState: TShiftState;
function IsAltDown: Boolean;
function IsCtrlDown: Boolean;
function IsShiftDown: Boolean;

///<summary> returns the global file formats list </summary>
function GetFileFormats: TFileFormatsList;

///<summary> Assigns the TBitBtn's glyph from the hex string (e.g. copied from .dfm)
///          if ContainsLength is true, the first 4 bytes (8 characters) contain the length of the
///          data (as is the case with the strings stored in the .dfm file) </summary>
procedure TBitBtn_GlyphFromString(_btn: TBitBtn; const _GlyphStr: AnsiString; _ContainsLength: Boolean = True);
procedure TBitmap_LoadFromString(_bmp: TBitmap; const _Content: AnsiString; _ContainsLength: Boolean = True);

///<summary> This is meant as a replacement to the LockWindowUpate function which shouldn't really be used
///          any more.
///          @param Ctrl is a TWinControl which should be locked
///          @returns an interface, if that interface is released, it will automatically unlock the control </summary>
function TWinControl_Lock(_Ctrl: TWinControl): IInterface;

///<summary> checks whether the integer array contains the given element
///          @param Element is the integer to check for
///          @param Arr is the array to check
///          @returns true, if Arr contains Element </summary>
function ArrayContains(_Element: Integer; const _Arr: array of Integer): Boolean;

type
  ///<summary> used in ResizeStringGrid and ResizeDbGrid to specify additional options
  ///  <ul>
  ///    <li>roUseGridWidth -> make the columns take up the whole grid width</li>
  ///    <li>roIgnoreHeader -> do not use the column header to calculate the column
  ///                          width</li>
  ///    <li>roUseLastRows -> use the last 10 rows to calculate the minimum width, not
  ///                         first 10
  ///    <li>roUseAllRows -> use all Grid rows to calculate the minimum width, not
  ///                        just the first 10</li>
  ///  </ul> </summary>
  TResizeOptions = (roUseGridWidth, roIgnoreHeader, roUseLastRows, roUseAllRows, roReduceMinWidth);
  TResizeOptionSet = set of TResizeOptions;

///<summary> Resizes the columns of a TCustomGrid to fit their contents
///          @param Grid is the TCustomGrid to work on
///          @param Options is a TResizeOptionSet specifying additional options,
///                         defaults to an empty set. </summary>
procedure TGrid_Resize(_Grid: TCustomGrid); overload;
procedure TGrid_Resize(_Grid: TCustomGrid; _Options: TResizeOptionSet); overload;
procedure TGrid_Resize(_Grid: TCustomGrid; _Options: TResizeOptionSet; _RowOffset: Integer); overload;
procedure TGrid_Resize(_Grid: TCustomGrid; _Options: TResizeOptionSet; const _ConstantCols: array of Integer); overload;
procedure TGrid_Resize(_Grid: TCustomGrid; _Options: TResizeOptionSet; const _ConstantCols: array of Integer; _RowOffset: Integer); overload;

///<summary> Resizes the columns of a TDbGrid to fit their contents
///          @param Grid is the TCustomDbGrid to work on
///          @param Options is a TResizeOptionSet specifying additional options,
///                         defaults to an empty set. </summary>
procedure TDbGrid_Resize(_Grid: TCustomDbGrid; _Options: TResizeOptionSet = []; _MinWidth: Integer = 100); overload;
procedure TDbGrid_Resize(_Grid: TCustomDbGrid; _Options: TResizeOptionSet; _MinWidths: array of Integer); overload;

///<summary> Adds a column to the TDbGrid
///          @param Field is the field name
///          @param Title is the field's title, if empty, the field name is used
///          @param Width is the field's width, if empty, the default is used
///          @returns the TColumn that was just created </summary>
function TDbGrid_AddColumn(_dbg: TDBGrid; const _Field: string; const _Title: string = ''; _Width: Integer = 0): TColumn;

///<summary> Returns the content of a StringGrid as a string
///          @param Grid is the TCustomGrid to read from.
///          @param IncludeFixed determines whether the fixed rows/columns are also included
///          @returns a string containing the contents of the grid columns separated by TAB
///                   rows sepearated by CRLF. </summary>
function TGrid_GetText(_Grid: TCustomGrid; _IncludeFixed: Boolean = False): string; overload;

///<summary> Returns the content of a StringGrid as a string
///          @param Grid is the TCustomGrid to read from.
///          @param Selection is a TGridRect that determinens the area of the grid to return
///          @returns a string containing the contents of the grid columns separated by TAB
///                   rows sepearated by CRLF. </summary>
function TGrid_GetText(_Grid: TCustomGrid; _Selection: TGridRect): string; overload;

///<summary> exports the contents of the string grid to a tab separated text file
///          @param Grid is the string grid to export
///          @param Filename is the name of the text file to create
///          @param IncludeFixed determines whether the fixed rows/columns are also exported </summary>
procedure TGrid_ExportToFile(_Grid: TCustomGrid; const _Filename: string; _IncludeFixed: Boolean = False);

///<summary> exports the contents of the string grid as tab separated strings to a stream
///          @param Grid is the string grid to export
///          @param Stream is the stream to write to
///          @param IncludeFixed determines whether the fixed rows/columns are also exported </summary>
procedure TGrid_ExportToStream(_Grid: TCustomGrid; _Stream: TStream; _IncludeFixed: Boolean = False); overload;
procedure TGrid_ExportToStream(_Grid: TCustomGrid; _Stream: TStream; _Selection: TGridRect); overload;

///<summary> sets the row count, taking the fixed rows into account
///          @returns the new RowCount </summary>
function TGrid_SetRowCount(_Grid: TCustomGrid; _RowCount: Integer): Integer;

///<summary> sets the nonfixd row count
///          @returns the new RowCount </summary>
function TGrid_SetNonfixedRowCount(_Grid: TCustomGrid; _RowCount: Integer): Integer;

///<summary> sets the column count, taking the fixed columns into account
///          @returns the new ColCount </summary>
function TGrid_SetColCount(_Grid: TCustomGrid; _ColCount: Integer): Integer;

///<summary> sets the nonfixd column count
///          @returns the new ColCount </summary>
function TGrid_SetNonfixedColCount(_Grid: TCustomGrid; _ColCount: Integer): Integer;

///<summary>
/// Calculates the Nonfixed row from the given row </summary>
function TGrid_RowToNonfixedRow(_Grid: TCustomGrid; _Row: Integer): Integer;

///<summary>
/// Calculates the row from the given Nonfixed row </summary>
function TGrid_NonFixedRowToRow(_Grid: TCustomGrid; _Row: Integer): Integer;

///<summary>
/// Returns the current nonfixed row </summary>
function TGrid_GetNonfixedRow(_Grid: TCustomGrid): Integer;

///<summary>
/// Makes sure the current row of the Grid is visible </summary>
procedure TGrid_MakeCurrentRowVisible(_Grid: TCustomGrid);

///<summary>
/// Sets the current row to the given non-fixed row.
/// @returns the new current row </summary>
function TGrid_SetNonfixedRow(_Grid: TCustomGrid; _Row: Integer; _MakeVisibile: Boolean = True): Integer;

///<summary> sets the grid's current row without triggering an OnClick event
procedure TGrid_SetRowNoClick(_Grid: TCustomGrid; _Row: Integer);

///<summary> sets the row count to FixedRows + 1 and clears all non-fixed cells </summary>
procedure TStringGrid_Clear(_Grid: TStringGrid);

///<summary> adds a new column to the Grid
///          It first searches for an empty column (no caption) and uses that, if
///          found, otherwise the column count is incremented.
///          @param Grid is the grid to expand
///          @param Caption is the caption of the new column
///          @returns the index of the new column </summary>
function TStringGrid_AddColumn(_Grid: TStringGrid; const _Caption: string): Integer;

procedure TStringGrid_SetNonfixedCell(_Grid: TStringGrid; _Col, _Row: Integer; const _Text: string);
function TStringGrid_GetNonfixedCell(_Grid: TStringGrid; _Col, _Row: Integer): string;

///<summary> exports the contents of the string grid to a tab separated text file (deprecated, use TGrid_ExportTofile instead)
///          @param Grid is the string grid to export
///          @param Filename is the name of the text file to create </summary>
procedure TStringGrid_ExportToFile(_Grid: TCustomGrid; const _Filename: string); deprecated; inline; // use TGrid_ExportTofile instead

///<summary> scrolls up the lines of a string grid
///          @param Grid is the TStringGrid to scroll
///          @param Top is the topmost row to scroll, if passed as -1 defaults to the first non-fixed row
///          @param Bottom is the bottommost row to scroll, if passed as -1 defaults to RowCount-1 </summary>
procedure TStringGrid_ScrollUp(_Grid: TStringGrid; _Top: Integer = -1; _Bottom: Integer = -1);

///<summary> sets the row count, taking the fixed rows into account  (deprecated, use TGrid_SetRowCount instead) </summary>
procedure TStringGrid_SetRowCount(_Grid: TCustomGrid; _RowCount: Integer); deprecated; inline; // use TGrid_SetRowCount instead

///<summary> sets the column count, taking the fixed columns into account </summary>
procedure TStringGrid_SetColCount(_Grid: TCustomGrid; _ColCount: Integer); deprecated; inline; // use TGrid_SetColCount instead

///<summary> deletes the given row from the string grid and moves all rows below it up by one,
///   if there is only one non-fixed row left, this row is cleared but not deleted.
///   @param Grid is the StringGrid to change
///   @param Row is the index of the row to delete, or -1 to delete the current row
///   @returns true, if the row was deleted </summary>
function TStringGrid_DeleteRow(_Grid: TStringGrid; _Row: Integer = -1): Boolean;

///<summary> inserts a row at the given index into the string grid and moves all rows below it down by one.
///          @param Grid is the StringGrid to change
///          @param Row is the index of the row to insert, or -1 to insert at the current row
///          @returns the inserted row index or -1 if the row cannot be inserted </summary>
function TStringGrid_InsertRow(_Grid: TStringGrid; _Row: Integer = -1): Integer;

///<summary> Appends a row to the string grid and returns the index of the new row </summary>
function TStringGrid_AppendRow(_Grid: TStringGrid): Integer;

///<summary> Tries to convert the grid cell to a double, if an error occurs, it raises
///          an exception and optionally focuses the cell.
///          @param Grid is the grid containing the data
///          @param Col is the cell's column (zero based)
///          @param Row is the cell's row (zero based)
///          @param FocusCell is a boolean which determines whether to focus the grid and cell
///                           if it does not contain a valid value
///          @returns the cell's content as a double
///          @raises EConvertError if the cell's content could not be converted </summary>
function TStringGrid_CellToDouble(_Grid: TStringGrid; _Col, _Row: Integer; _FocusCell: Boolean = True): Double;

///<summary> Tries to convert the grid cell to an integer, if an error occurs, it raises
///          an exception and optionally focuses the cell.
///          @param Grid is the grid containing the data
///          @param Col is the cell's column (zero based)
///          @param Row is the cell's row (zero based)
///          @param FocusCell is a boolean which determines whether to focus the grid and cell
///                           if it does not contain a valid value
///          @returns the cell's content as an integer
///          @raises EConvertError if the cell's content could not be converted </summary>
function TStringGrid_CellToInt(_Grid: TStringGrid; _Col, _Row: Integer; _FocusCell: Boolean = True): Integer;

///<summary>
/// @returns the index of the first visible line </summary>
function TMemo_GetFirstVisibleLine(_Memo: TMemo): Integer;

///<summary> Deletes the top lines of the memo so it only contains Retain lines
///          @param Memo is the memo to work on
///          @param Retain is the number of lines to retain </summary>
procedure TMemo_DeleteTopLines(_Memo: TMemo; _Retain: Integer);

///<summary> Gets the cursor position (actually the start of the selection) of the memo </summary>
function TMemo_GetCursorPos(_Memo: TMemo): Integer;
procedure TMemo_SetCursorPos(_Memo: TMemo; _CharIdx: Integer);

function TMemo_GetCursorLine(_Memo: TMemo): Integer;
procedure TMemo_SetCursorToLine(_Memo: TMemo; _Line: Integer);

procedure TMemo_ScrollToCursorPos(_Memo: TMemo);

///<summary> Scrolls the memo to the end </summary>
procedure TMemo_ScrollToEnd(_Memo: TMemo);

///<summary> sets the Text property of a TEdit without triggering an OnChange event </summary>
procedure TEdit_SetTextNoChange(_ed: TCustomEdit; const _Text: string);

procedure TEdit_SetEnabled(_ed: TCustomEdit; _Enabled: Boolean);

type
  TAutoCompleteSourceEnum = (acsFileSystem, acsUrlHistory, acsUrlMru);
  TAutoCompleteSourceEnumSet = set of TAutoCompleteSourceEnum;
type
  TAutoCompleteTypeEnum = (actSuggest, actAppend);
  TAutoCompleteTypeEnumSet = set of TAutoCompleteTypeEnum;

///<summary>
/// Enables autocompletion for an edit control using a call to SHAutoComplete
/// NOTE that this will only work until the control handle is recreated which the VCL does
///      quite often. See TEdit_AutoComplete which handles this problem.
/// @param ed is a TCustomEdit control for which autocompletion should be enabled
/// @param Source is a set of TAutoCompleteSourceEnum that determines from which source to
///               autocomplate, any combination of acsFileSystem, acsUrlHistory, acsUrlMru
///               is allowed.
/// @param Type is a set fo TAutoCompleteEnumSet that determines the type of autocompletion
///             actAppend means that the first match will be appended to the existing text and
///                       selected, so that typing anything will automatically overwrite it.
///             actSuggest means that a list of matches will be displayed as a dropdown list
///                        from which the user can then select using the arrow keys or the mouse.
///             is is possible to pass an empty set, in which case the registry setting.
///             (Unfortunately MSDN doesn't say where in the registry this setting is located.)
/// @returns true, if autocomplete could be activated </summary>
function TEdit_SetAutocomplete(_ed: TCustomEdit; _Source: TAutoCompleteSourceEnumSet = [acsFileSystem];
  _Type: TAutoCompleteTypeEnumSet = []; _ErrorHandling: TErrorHandlingEnum = ehReturnFalse): Boolean;

///<summary>
/// Enables autocompletion for an edit control using a call to SHAutoComplete
/// @param ed is a TCustomEdit control for which autocompletion should be enabled
/// @param Source is a set of TAutoCompleteSourceEnum that determines from which source to
///               autocomplate, any combination of acsFileSystem, acsUrlHistory, acsUrlMru
///               is allowed.
/// @param Type is a set fo TAutoCompleteEnumSet that determines the type of autocompletion
///             actAppend means that the first match will be appended to the existing text and
///                       selected, so that typing anything will automatically overwrite it.
///             actSuggest means that a list of matches will be displayed as a dropdown list
///                        from which the user can then select using the arrow keys or the mouse.
///             is is possible to pass an empty set, in which case the registry setting.
///             (Unfortunately MSDN doesn't say where in the registry this setting is located.)
/// @returns the TAutoCompleteActivator instance created.
///          NOTE: You do not need to free this object! It will automatically be freed when the
///                TEdit is destroyed. </summary>
function TEdit_AutoComplete(_ed: TCustomEdit; _Source: TAutoCompleteSourceEnumSet = [acsFileSystem];
  _Type: TAutoCompleteTypeEnumSet = []): TObject;

///<summary>
/// Enables positioning the form with the given modifier keys + the numeric keypad (regardless of
/// whether NumLock is on or off) and the cursor keys (default: Ctrl+Alt+<key>).
/// Key combination moves window to:
/// Ctrl+Alt+Pos1  -> upper left quadrant
/// Ctrl+Alt+Up    -> upper half -> lower half of upper monitor etc.
/// Ctrl+Alt+PgUp  -> upper right quadrant
/// Ctrl+Alt+Right -> right half -> left half of right hand side monitor etc.
/// Ctrl+Alt+PgDn  -> lower right qudarant
/// Ctrl+Alt+Down  -> lower half -> upper half of lower monitor etc.
/// Ctrl+Alt+End   -> lower left quarant
/// Ctrl+Alt+Left  -> left half -> right half of left hand monitor etc. </summary>
function TForm_ActivatePositioning(_Form: TForm; _Modifier: TShiftState = [ssCtrl, ssAlt]): TObject;

type
  TdzWindowPositions = (dwpTop, dwpBottom, dwpLeft, dwpRight, dwpTopLeft, dwpTopRight, dwpBottomLeft, dwpBottomRight);

procedure TForm_MoveTo(_frm: TCustomForm; _Position: TdzWindowPositions);

type
  IdzInputValidator = u_dzInputValidator.IdzInputValidator;

function InputValidator(_OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): IdzInputValidator; deprecated;

///<summary> Tries to convert the edit control text to a double, if an error occurs, it raises
///          an exception and optionally focuses the control.
///          @param ed is the edit control
///          @param FocusControl is a boolean which determines whether to focus the control
///                              if it does not contain a valid value or not
///          @returns the controls content as a double
///          @raises EConvertError if the controls content could not be converted </summary>
function TEdit_TextToDouble(_ed: TCustomEdit; _FocusControl: Boolean = True): Double;

///<summary> Tries to convert the edit control text to a double, if an error occurs, it changes it's
///          color to ErrColor and returns false, otherwise it changes the color to OkColor and
///          returns true. </summary>
function TEdit_TryTextToDouble(_ed: TEdit; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean; overload;
function TEdit_TryTextToDouble(_ed: TEdit; out _Value: Double; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean; overload;

function TEdit_TryTextToFloat(_ed: TCustomEdit; out _Value: Extended;
  _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean; overload;
function TEdit_TryTextToFloat(_ed: TCustomEdit; out _Value: Double;
  _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean; overload;
function TEdit_TryTextToFloat(_ed: TCustomEdit; out _Value: Single;
  _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean; overload;

function TEdit_IsTextFloat(_ed: TCustomEdit; _MinValue, _MaxValue: Extended;
  _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean; overload;
function TEdit_IsTextFloat(_ed: TCustomEdit; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean; overload;

function TEdit_TryTextToInt(_ed: TEdit; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean; overload;
function TEdit_TryTextToInt(_ed: TCustomEdit; out _Value: Integer;
  _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean; overload;

function TEdit_IsTextInt(_ed: TCustomEdit; _MinValue, _MaxValue: Integer;
  _OkColor: TColor; _ErrColor: TColor = clYellow): Boolean; overload;
function TEdit_IsTextInt(_ed: TCustomEdit; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean; overload;

function TEdit_TextHHMMSSToTime(_ed: TCustomEdit; _FocusControl: Boolean = True): TDateTime;

function TEdit_IsTextNonEmpty(_ed: TCustomEdit; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;

///<summary> Tries to convert the edit control text to an integer, if an error occurs, it raises
///          an exception and optionally focuses the control.
///          @param ed is the edit control
///          @param FocusControl is a boolean which determines whether to focus the control
///                              if it does not contain a valid value
///          @returns the controls content as an integer
///          @raises EConvertError if the controls content could not be converted </summary>
function TEdit_TextToInt(_ed: TCustomEdit; _FocusControl: Boolean = True): Integer; overload;
function TEdit_TextToInt(_ed: TLabeledEdit; _FocusControl: Boolean = True): Integer; overload;

///<summary> Tries to convert the edit control text to an integer, if an error occurs, the
///          default value is used instead.
///          @param ed is the edit control
///          @param Default is the value to use if the edit does not contain an integer
///          @returns the controls content as an integer
function TEdit_TextToIntDef(_ed: TCustomEdit; _Default: Integer): Integer;

///<summary> returns the contents of the tree view as a string with indentations
///          @param Tree is the TTreeView to process
///          @param Indentation is the number of spaces for indentation
///          @param Marker is a marker character to use for each item, #0 for no marker </summary>
function TTreeView_GetAsText(_Tree: TTreeView; _Indentation: Integer = 2; _Marker: Char = #0): string;

///<summary> adds a new TTabSheet with the given Caption to the PageControl and returns it </summary>
function TPageControl_AddTabSheet(_PageControl: TPageControl; const _Caption: string): TTabSheet;

///<summary> Draws the tab text for a TPageControl as horizontal text, useful, if you
///          want to have the tabs on the left or right but don't want vertical text.
///         Set the TPageControl's OwnerDraw property to true, the TabHeight property
///         (which actually gives the width of the tabs if they are on the left or right
///         hand side) sufficiently large, the TabWidth (which is actually is the height)
///         to 18 and assign a OnDrawTab event. From this event call this function.
///         @param PageControl is the TPageControl to draw
///         @param TabIndex is the index of the tab to draw
///         @param Rect is a TRect giving the drawing area
///         @param Active is a boolean that is true if the Tab is currently active </summary>
procedure TPageControl_DrawTab(_PageControl: TPageControl; _TabIndex: Integer;
  const _Rect: TRect; _Active: Boolean);

///<summary> Draws the tab text for a TTabControl as horizontal text, useful, if you
///          want to have the tabs on the left or right but don't want vertical text.
///         Set the TTabControl's OwnerDraw property to true, the TabHeight property
///         (which actually gives the width of the tabs if they are on the left or right
///         hand side) sufficiently large, the TabWidth (which is actually is the height)
///         to 18 and assign a OnDrawTab event. From this event call this function.
///         @param PageControl is the TPageControl to draw
///         @param TabIndex is the index of the tab to draw
///         @param Rect is a TRect giving the drawing area
///         @param Active is a boolean that is true if the Tab is currently active </summary>
procedure TTabControl_DrawTab(_TabControl: TTabControl; _TabIndex: Integer;
  const _Rect: TRect; _Active: Boolean);

///<summary> Sets a TTabControl's tab width based on the text it displays, usefull
///          to display horizontal text in tabs on the left or right hand side </summary>
procedure TTabControl_AdjustTabWidth(_TabControl: TTabControl; _Form: TForm; _MinWidth: Integer = 80);

///<summary> Gets the object associated with the currently selected tab
///          @param TabControl is the TTabControl to work on
///          @param Obj is the object of the selected tab, only valid if Result=true
///          @returns true, if TabIndex <> -1 </summary>
function TTabControl_GetSelectedObject(_TabControl: TTabControl; out _Obj: Pointer): Boolean; overload;
function TTabControl_GetSelectedObject(_TabControl: TTabControl; out _Idx: Integer; out _Obj: Pointer): Boolean; overload;

///<summary> Enables longer SimpleText (longer than 127 characters)
///          Call once to enable. Works, by adding a single panel with owner drawing and
///          setting the StatusBar's OnDrawPanel to a custom drawing method.
///          To make it work, you must use TStatusBar_SetLongSimpleText to set
///          the text, or use TLongSimpleTextStatusBar as an interposer class. </summary>
procedure TStatusBar_EnableLongSimpleText(_StatusBar: TStatusBar);

///<summary> Set the SimpleText of the StatusBar and invalidate it to enforce a redraw </summary>
procedure TStatusBar_SetLongSimpleText(_StatusBar: TStatusBar; const _Text: string);

///<summary> call this function to determine which panel of a TStatusBar has been clicked
//           Note: This assumes, that the status bar actually was clicked, so only call it
//           from the status bar's OnClick, OnMouseDown or OnMouseUp event handlers
//           If the status bar does not have any panels (e.g. SimplePanel=true), this function
//           will return 0.
function TStatusBar_GetClickedPanel(_sb: TStatusBar): Integer;

type
  ///<summary> Interposer class for TStatusBar to allow longer than 127 characters in SimpleText </summary>
  TLongSimpleTextStatusBar = class(TStatusBar)
  private
    function GetSimpleText: string;
    procedure SetSimpleText(const Value: string);
  published
  public
    property SimpleText: string read GetSimpleText write SetSimpleText;
  end;

{$IFDEF DELPHI2009_UP}
type
  TdzButtonedEdit = class(TButtonedEdit)
  protected
    procedure KeyDown(var _Key: Word; _Shift: TShiftState); override;
{$IFDEF DELPHI2010_UP}
  public
    procedure Loaded; override;
{$ENDIF DELPHI2010_UP}
  end;
{$ENDIF DELPHI2009_UP}

///<summary> sets the control and all its child controls Enabled property and changes their
///          caption to reflect this
///          @param Control is the TControl to change
///          @param Enabled is a boolean with the new value for the Enabled property. </summary>
procedure TControl_SetEnabled(_Control: TControl; _Enabled: Boolean);
procedure SetControlEnabled(_Control: TControl; _Enabled: Boolean); deprecated; // use TControl_SetEnabled instead

///<summary> Calls protected TControl.Resize (which calls TControl.OnResize if assigned) </summary>
procedure TControl_Resize(_Control: TControl);

///<summary> Sets the control's Constraints.MinHeight und Constraints.MinWidth properties
///          to the control's Width and Height. </summary>
procedure TControl_SetMinConstraints(_Control: TControl);

///<summary> Frees all objects assigned to the combobox and then clears the combobox </summary>
procedure TComboBox_ClearWithObjects(_cmb: TCustomComboBox);

procedure TComboBox_SetEnabled(_cmb: TCustomComboBox; _Enabled: Boolean);

///<summary> sets the with of a ComboBox's dropdown  in pixels </summary>
procedure TComboBox_SetDropdownWidth(_cmb: TCustomComboBox; _Pixels: Integer);

///<summary> Selects the entry in a combobox that has an object pointer matching Value
///          @param cmb is the TCustomCombobox (descendant) to select
///          @param Value is the desired object value
///          @returns true, if the value could be found, false otherwise </summary>
function TComboBox_SelectByObject(_cmb: TCustomComboBox; _Value: Pointer): Boolean; overload;
function TComboBox_SelectByObject(_cmb: TCustomComboBox; _Value: Integer): Boolean; overload;

///<summary> Gets the string of a combobox entry that has an object pointer matching Obj
///          @param cmb is the TCustomCombobox (descendant) to select
///          @param Obj is the desired object value
///          @param s is the string of the combobox entry, only valid if the function returns true
///          @returns true, if the object could be found, false otherwise </summary>
function TComboBox_GetObjectCaption(_cmb: TCustomComboBox; _Obj: Pointer; out _s: string): Boolean;

///<summary> Gets the object pointer of the selected combobox item
///          @param cmb is the TCustomCombobox (descendant) to read from
///          @param Idx is the combobox's ItemIndex, only valid if the function returns true
///          @param Obj is the value of the object pointer of the selected item, only valid
///                     if the function returns true
///          @param FocusControl is a boolean which determines whether to focus the control
///                              if it does not contain a valid value, default = false
///          @returns true, if these out parameters are valid </summary>
function TComboBox_GetSelectedObject(_cmb: TCustomComboBox;
  out _Obj: Pointer; _FocusControl: Boolean = False): Boolean; overload; inline;
function TComboBox_GetSelectedObject(_cmb: TCustomComboBox;
  out _Idx: Integer; out _Obj: Pointer; _FocusControl: Boolean = False): Boolean; overload;
function TComboBox_GetSelectedObject(_cmb: TCustomComboBox;
  out _ObjAsInt: Integer; _FocusControl: Boolean = False): Boolean; overload;
function TComboBox_GetSelectedObject(_cmb: TCustomComboBox;
  out _Item: string; out _Obj: Pointer; _FocusControl: Boolean = False): Boolean; overload;
function TComboBox_GetSelectedObject(_cmb: TCustomComboBox;
  out _Item: string; out _ObjAsInt: Integer; _FocusControl: Boolean = False): Boolean; overload;

function TComboBox_GetSelectedObjectDef(_cmb: TCustomComboBox;
  _Default: Integer; _FocusControl: Boolean = False): Integer;

///<summary> Gets the caption of the selected combobox item
///          @param cmb is the TCustomCombobox (descendant) to read from
///          @param Item is the selected item, only valid if the function returns true
///          @param FocusControl is a boolean which determines whether to focus the control
///                              if it does not contain a valid value, default = false
///          @returns true, if an item was selected </summary>
function TComboBox_GetSelected(_cmb: TCustomComboBox; out _Item: string;
  _FocusControl: Boolean = False): Boolean; overload;

///<summary> Gets the index of the selected combobox item
///          @param cmb is the TCustomCombobox (descendant) to read from
///          @param Item is the selected item, only valid if the function returns true
///          @param FocusControl is a boolean which determines whether to focus the control
///                              if it does not contain a valid value, default = false
///          @returns true, if an item was selected </summary>
function TComboBox_GetSelected(_cmb: TCustomComboBox; out _Idx: Integer;
  _FocusControl: Boolean = False): Boolean; overload;

///<summary> Returns the currently selected item from the combobox.
///          @raises EdzComboBoxNoSelection if no item is selected </summary>
function TComboBox_GetSelected(_cmb: TCustomComboBox): string; overload;

///<summary> Returns the currently selected item from the combobox or the Default if no item
///          is selected </summary>
function TComboBox_GetSelectedDef(_cmb: TCustomComboBox; const _Default: string): string; overload;

///<summary> Returns the currently selected item index from the combobox or the Default if no item
///          is selected </summary>
function TComboBox_GetSelectedDef(_cmb: TCustomComboBox; const _Default: Integer = -1): Integer; overload;

function TComboBox_IsSelected(_cmb: TCustomComboBox; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;

///<summary> Selects the item if it is in the list and returns the new ItemIndex
///          @param cmb is the TCustomCombobox (descendant) to use
///          @param Item is the item to select
///          @param DefaultIdx is the ItemIndex to use if no item matches.
///          @returns the index of the newly selected item or -1 if it doesn't exist </summary>
function TComboBox_Select(_cmb: TCustomComboBox; const _Item: string; _DefaultIdx: Integer = -1;
  _AllowPartialMatch: Boolean = False): Integer;

///<summary> Calls the protected Change method of the combobox </summary>
procedure TComboBox_Change(_cmb: TCustomCombo);

///<summary> Selects an item (or no Item, if Idx = -1) without triggering an OnChange event
///          (I am not even sure whether setting the item index always triggers an OnChange event.) </summary>
procedure TComboBox_SelectWithoutChangeEvent(_cmb: TCustomComboBox; _Idx: Integer);

///<summary> Assign the Items without affecting the Text
///          @param cmb is the TCustomCombobox (descendant) to use
///          @param Items is the TStrings to assign
procedure TComboBox_AssignItems(_cmb: TCustomComboBox; _Items: TStrings);

///<summary>
/// Add a new item with Object = Pointer(Value) </summary>
procedure TComboBox_AddIntObject(_cmb: TCustomComboBox; const _Item: string; _Value: Integer);

///<summary> Selects an item without triggering an OnChange event
///          (I am not even sure whether setting the item index always triggers an OnChange event.) </summary>
procedure TColorBox_SelectWithoutChangeEvent(_cmb: TColorBox; _Color: TColor);

///<summary> Sets the control to readonly by adding a TPanel as parent and disable it. Note that this does
///          not grey out the control as the Enabled property would.
///          This is meant for controls that do not have a readonly property like TComboBox or TCheckBox. </summary>
procedure TControl_SetReadonly(_Ctrl: TControl; _ReadOnly: Boolean);

///<summary> Gets the object pointer of the selected listbox item
///          @param lst is the TCustomListbox (descendant) to read from
///          @param Idx is the listbox's ItemIndex, only valid if the function returns true
///          @param Obj is the value of the object pointer of the selected item, only valid
///                     if the function returns true
///          @returns true, if out parameters are valid </summary>
function TListBox_GetSelectedObject(_lst: TCustomListbox; out _Idx: Integer; out _Obj: Pointer): Boolean;

///<summary> Gets the caption of the selected listbox item
///          @param cmb is the TCustomListbox (descendant) to read from
///          @param Item is the selected item, only valid if the function returns true
///          @param FocusControl is a boolean which determines whether to focus the control
///                              if it does not contain a valid value, default = false
///          @returns true, if an item was selected </summary>
function TListBox_GetSelected(_lb: TCustomListbox; out _Item: string;
  _FocusControl: Boolean = False): Boolean; overload;
function TListBox_GetSelected(_lb: TCustomListbox): string; overload;
function TListBox_GetSelected(_lb: TCustomListbox; out _Idx: Integer; out _Item: string): Boolean; overload;

///<summary> @Returns the number of selected items in the ListBox
///          @param Selected will contain the selected items as well as the
///                          associated objects. May be passed as NIL if only the count
///                          is required. </summary>
function TListBox_GetSelected(_lb: TCustomListbox; _Selected: TStrings): Integer; overload;

///<summary> Selects the item if it is in the list and returns the new ItemIndex
///          @param lb is the TCustomListbox (descendant) to use
///          @param Item is the item to select
///          @param DefaultIdx is the ItemIndex to use if no item matches.
///          @returns the index of the newly selected item or -1 if it doesn't exist </summary>
function TListBox_Select(_lb: TCustomListbox; const _Item: string; _DefaultIdx: Integer = -1): Integer;

///<summary> Deletes the selected listbox item
///          @param lst is the TCustomListbox (descendant) to read from
///          @param Idx is the listbox's ItemIndex, only valid if the function returns true
///   @returns true, if these values are valid </summary>
function TListBox_DeleteSelected(_lst: TCustomListbox; out _Idx: Integer): Boolean; overload;
function TListBox_DeleteSelected(_lst: TCustomListbox): Boolean; overload;
function TListBox_DeleteSelected(_lst: TCustomListbox; out _s: string): Boolean; overload;

procedure TListBox_UnselectAll(_lb: TCustomListbox);

///<summary> Frees all objects assigned to the list and then clears the list </summary>
procedure TListbox_ClearWithObjects(_lst: TCustomListbox);

///<summary> Returns the nunber of items that are checked </summary>
function TCheckListBox_GetCheckedCount(_clb: TCheckListBox): Integer;
procedure TCheckListBox_DeleteDisabled(_clb: TCheckListBox);
procedure TCheckListBox_InvertCheckmarks(_clb: TCheckListBox; _IncludeDisabled: Boolean = False);
procedure TCheckListBox_UncheckAll(_clb: TCheckListBox);
procedure TCheckListBox_CheckAll(_clb: TCheckListBox; _IncludeDisabled: Boolean = False);
///<summary> Returns the checked items and the objects associated in them
///          @param clb is the TCheckListBox
///          @param Checked is a TStrings to which the selected items and objects are to be added
///                         default: NIL
///          @param IncludeDisabled determines whether the disabled items should also be returned if they are checked
///          @returns the number of Items in Checked </summary>
function TCheckListBox_GetChecked(_clb: TCheckListBox; _Checked: TStrings = nil; _IncludeDisabled: Boolean = False): Integer; overload;
function TCheckListBox_GetChecked(_clb: TCheckListBox; _IncludeDisabled: Boolean = False): string; overload;
///<summary> Returns the objects associated with the checked items
///          @param clb is the TCheckListBox
///          @param Objects is a TList to which the selected objects are to be added
///          @param IncludeDisabled determines whether the disabled items should also be returned if they are checked
///          @returns the number of Items in Objects </summary>
function TCheckListBox_GetCheckedObjects(_clb: TCheckListBox; _Objects: TList; _IncludeDisabled: Boolean = False): Integer;
///<summary> Checks all items contained in the Checked string list
///          @param clb is the TCheckListBox to modify
///          @param Checked is a string list containing the items to be checked
///          @param UncheckOthers determines whether any items not in the list should
///                               be unchecked (defaults to true).
///          @param SuppressClick determines whether the automatic OnClickCkeck
///                               event should be suppressed.
///          @returns the number of items that have been checked. </summary>
function TCheckListBox_SetChecked(_clb: TCheckListBox; _Checked: TStrings;
  _UncheckOthers: Boolean = True; _SuppressClick: Boolean = False): Integer; overload;

function TCheckListBox_SetChecked(_clb: TCheckListBox; const _Checked: string;
  _UncheckOthers: Boolean = True; _SuppressClick: Boolean = False): Integer; overload;

function TCheckListBox_SetChecked(_clb: TCheckListBox; const _Checked: array of string;
  _UncheckOthers: Boolean = True; _SuppressClick: Boolean = False): Integer; overload;

///<summary> sets the checked property without triggering an OnClickCheck event </summary>
procedure TCheckListBox_SetCheckedNoClick(_clb: TCheckListBox; _Idx: Integer; _Checked: Boolean);

procedure TCheckListBox_CheckSelected(_clb: TCheckListBox; _IncludeDisabled: Boolean = False);
procedure TCheckListBox_UncheckSelected(_clb: TCheckListBox; _IncludeDisabled: Boolean = False);

///<summary> Makes the given TCheckListBox readonly by assigning a special
///          method to its OnClickCheck event or makes it ReadWrite again
///          by removing that method.
///          @param ReadOnly determines whether to assign or remove the event.
///          @param ChangeColor determines whether to change the background color
///                             to clWindow (ReadWrite) and clBtnFace (ReadOnly)
///                             respectively. Defaults to true </summary>
procedure TCheckListBox_Readonly(_clb: TCheckListBox; _ReadOnly: Boolean; _ChangeColor: Boolean = True);

///<summary> Gets the caption of the given or selected item in the RadioGroup
///          @param rg is the TCustomRadioGroup descendant to read
///          @param Caption returns a string with the requested caption with
///                         Ampersands ('&') stripped, only valid, if
///                         the function returns true
///          @param Idx is the item index to read, defaults to -1 meaning 'selected item'
///          @returns true, if the caption could be read </summary>
function TRadioGroup_GetItemCaption(_rg: TCustomRadioGroup;
  out _Caption: string; _Idx: Integer = -1): Boolean;

///<summary> Selects the item in the radio group with the given caption,
///          returns the item's index or -1 if no item matched.
///          Comparison is case insensitive </summary>
function TRadioGroup_Select(_rg: TCustomRadioGroup; const _Item: string; _DefaultIdx: Integer = -1): Integer;

///<summary> Gets the object pointer of the selected RadioGroup item
///          @param cmb is the TCustomListbox (descendant) to read from
///          @param Idx is the listbox's ItemIndex, only valid if the function returns true
///          @param Obj is the value of the object pointer of the selected item, only valid
///                     if the function returns true
///          @returns true, if the out parameters are valid </summary>
function TRadioGroup_GetSelectedObject(_rg: TCustomRadioGroup; out _Idx: Integer; out _Obj: Pointer): Boolean;

///<summary> Writes a TPicture object to a String. The Format is
///          <pictureformat>#26<picturedata> </summary>
function TPicture_WriteToString(_Pic: TPicture): string;

///<summary> Reads a TPicture object from a String which was created using
///          Picture_WriteToString </summary>
procedure TPicture_ReadFromString(_Pic: TPicture; const _s: string);

///<summary> Writes a TRichEdit to a string including all formatting </summary>
function TRichEdit_WriteToString(_Re: TRichEdit): string;

///<summary> Reads a TRichEdit from a string including all formatting </summary>
procedure TRichEdit_ReadFromString(_Re: TRichEdit; const _s: string);

///<summary> Returns the characater offset of the first character of the given row
///          example: RicheEdit1.SelStart := RichEdit_GetRowCharIndex(RichEdit1, 5);
///          @param Re is a TRichEdit
///          @param Row is the row number (0 based)
///          @returns the character offset (0 based) of the first character of the row </summary>
function TRichEdit_RowToCharIndex(_Re: TRichEdit; _Row: Integer): Integer;

///<summary> Returns the row which contains the given character index </summary>
function TRichEdit_CharIndexToRow(_Re: TRichEdit; _Idx: Integer): Integer;

///<summary> Returns the current row number (0 based) of the RichEdit </summary>
function TRichEdit_GetCurrentRow(_Re: TRichEdit): Integer;

///<summary> Scrolls the rich edit to the current caret position </summary>
procedure TRichEdit_ScrollToCaret(_Re: TRichEdit);

///<summary> Write a line to a RichEdit, optionally specifying color and font style </summary>
procedure TRichEdit_WriteLn(_Re: TRichEdit; const _s: string; _Color: TColor = clBlack; _Style: TFontStyles = []);

///<summary> Adds a control and a corresponding label, a line consists of 24 pixels
///          with 16 pixels distance from the upper and 8 pixels from the left border.
///          It is assumed that the control already has the correct x position, only
///          Top will be adjusted. </summary>
function AddLabeledControl(_Idx: Integer; const _Caption: string; _Ctrl: TControl): TLabel;

///<summary> Calculates the height for writing a Text on a control </summary>
function CalcTextHeight(_Ctrl: TWinControl; const _Text: string; _Width: Integer = -1): Integer; overload;
function CalcTextHeight(_Ctrl: TGraphicControl; const _Text: string; _Width: Integer = -1): Integer; overload;

///<summary> I don't quite remember what this is supposed to do and where it is used,
///          Please, if you find a call to this function somewhere, tell me. -- twm </summary>
function TStringGrid_IsScrollBarVisible(_Grid: TCustomGrid; _Code: Integer): Boolean;

///<summary> Returns the path to the application's executable including the trailing backslash </summary>
function GetApplicationPath: string; deprecated; // use TApplication_GetExePath instead

///<summary> Center the child on the parent </summary>
procedure TControl_Center(_Child: TControl; _Parent: TControl);

///<summary> Sets the control's hint and ShowHint to true </summary>
procedure TControl_SetHint(_Ctrl: TControl; const _Hint: string);

///<summary> sets the Checked property without firing an OnClick event </summary>
procedure TCheckBox_SetCheckedNoOnClick(_Chk: TCustomCheckBox; _Checked: Boolean);

///<summary> Tries to set the checkbox's width to accomodate the text, does not always
///          work, especially since it does not take the WordWrap parameter into account
///          @param chk is the checkbox to autosize
///          @param ParentCanvas is the TCanvas to use for getting the text width
///                              can be nil in which case the function tries the
///                              Checkbox's parent controls until it finds either a TCustomControl
///                              or TForm.
///          @returns the new width or -1 if resizing failed. </summary>
function TCheckBox_Autosize(_Chk: TCustomCheckBox; _ParentCanvas: TCanvas = nil): Integer;

///<summary> centers a form on the given point, but makes sure the form is fully visible </summary>
procedure TForm_CenterOn(_frm: TForm; _Center: TPoint); overload;
///<summary> centers a form on the given component, but makes sure the form is fully visible </summary>
procedure TForm_CenterOn(_frm: TForm; _Center: TWinControl); overload;

type
  TFormPlacementEnum = (fpePositionOnly, fpeSizeOnly, fpePosAndSize);

///<summary> Stores the form's current position and size to the registry
///          @param frm is the form whose placement is to be stored
///          @param Which determines whether the Position and/or the size is to be stored
///          @param RegistryPath gives the full path, including the value name to write to,
///                              not yet implemented: defaults to '<Company_name>\<executable>\<frm.Classname>\NormPos'
///                              where <Company_name> is read from the version resources
///                              and <frm.Classname is the form's ClassName without the T-Prefix
///          @param HKEY is the root key, defaults to HKEY_CURRENT_USER
///          @returns false, if anything goes wrong, including any exceptions that might
///                          occur, true if it worked.
function TForm_StorePlacement(_frm: TForm; _Which: TFormPlacementEnum; const _RegistryPath: string;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean; overload;

///<summary> Stores the form's current position and size to the registry
///          under Software\<executable>\<frm.name>\NormPos'
///          @param frm is the form whose placement is to be stored
///          @param Which determines whether the Position and/or the size is to be stored
///          @param HKEY is the root key, defaults to HKEY_CURRENT_USER
///          @returns false, if anything goes wrong, including any exceptions that might
///                          occur, true if it worked.
function TForm_StorePlacement(_frm: TForm; _Which: TFormPlacementEnum;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean; overload;

///<summary> Reads the form's position and size from the registry
///          @param frm is the form whose placement is to be read
///          @param Which determines whether the Position and/or the size is to be read
///          @param RegistryPath gives the full path, including the value name to write to,
///                              not yet implemented: defaults to '<Company_name>\<executable>\<frm.Classname>\NormPos'
///                              where <Company_name> is read from the version resources
///                              and <frm.Classname is the form's ClassName without the T-Prefix
///          @param HKEY is the root key, defaults to HKEY_CURRENT_USER
///          @returns false, if anything goes wrong, including any exceptions that might
///                          occur, true if it worked.
function TForm_ReadPlacement(_frm: TForm; _Which: TFormPlacementEnum; const _RegistryPath: string;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean; overload;

///<summary> Reads the form's position and size from the registry
///          under Software\<executable>\<frm.name>\NormPos'
///          @param frm is the form whose placement is to be stored
///          @param Which determines whether the Position and/or the size is to be stored
///          @param HKEY is the root key, defaults to HKEY_CURRENT_USER
///          @returns false, if anything goes wrong, including any exceptions that might
///                          occur, true if it worked.
function TForm_ReadPlacement(_frm: TForm; _Which: TFormPlacementEnum;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean; overload;

///<summary> Generates the registry path for storing a form's placement as used in
///          TForm_Read/StorePlacement. </summary>
function TForm_GetPlacementRegistryPath(_frm: TForm): string; overload;

///<summary> Generates the registry path for storing a form's placement as used in
///          TForm_Read/StorePlacement. </summary>
function TForm_GetPlacementRegistryPath(const _FrmName: string): string; overload;

///<summary> Generates the registry path for storing a form's configuration. </summary>
function TForm_GetConfigRegistryPath(_frm: TForm): string; overload;
function TForm_GetConfigRegistryPath(const _FrmName: string): string; overload;

///<summary> Sets the form's Constraints.MinWidth and .MinHeight to the form's current size. </summary>
procedure TForm_SetMinConstraints(_frm: TForm); deprecated; // use TControl_SetMinConstraints instead

///<summary> appends ' - [fileversion projectversion] to the form's caption
///          @param Caption is used instead of the original caption, if not empty </summary>
procedure TForm_AppendVersion(_frm: TForm; _Caption: string = '');

///<summary> inserts <fileversion> <projectversion> into the form's caption using
///          the given Mask. The mask must contain one or two %s format specifiers
///          the first one will be replaced with <fileversion> the second one with
///          <productversion>. To change the order, use an index in the specifier:
///          'Product version: %1:s, File version: %0:s'.
///          If no Mask is given, the form's caption + ' - [%s %s]' is assumed. </summary>
procedure TForm_InsertVersion(_frm: TForm; _Mask: string = '');

type
  ///<summary>
  /// Event used in TWinControl_ActivateDropFiles.
  /// @param Sender is the control onto which the files were dropped
  /// @param Files is a TStrings containg the full names of all files dropped </summary>
  TOnFilesDropped = procedure(_Sender: TObject; _Files: TStrings) of object;

function TForm_ActivateDropFiles(_WinCtrl: TWinControl; _Callback: TOnFilesDropped): TObject; deprecated; // use TWinControl_ActivateDropFiles instead

///<summary>
/// Enables dropping of files (folders) from explorer to the given WinControl
/// @param WinCtrl is a TWinControl for which dropping should be enabled
/// @param Callback is a TOnFilesDropped event that is called when files are dropped on the form.
/// @returns the TAutoCompleteActivator instance created.
///          NOTE: You do not need to free this object! It will automatically be freed when the
///                TEdit is destroyed. </summary>
function TWinControl_ActivateDropFiles(_WinCtrl: TWinControl; _Callback: TOnFilesDropped): TObject;

///<summary> tries to focus the given control, returns false if that's not possible </summary>
function TWinControl_SetFocus(_Ctrl: TWinControl): Boolean;

///<summary>
/// @returns the full path of the executable (without the filename but including a backslash) </summary>
function TApplication_GetExePath: string;
function TApplication_GetExePathBS: string;

///<summary>
/// @returns the filename of the executable without path and extension </summary>
function TApplication_GetFilenameOnly: string;

///<summary> returns true, if the application's executable contains version information </summary>
function TApplication_HasVersionInfo: Boolean;

///<summary> gets the file version from the executable's version information </summary>
function TApplication_GetFileVersion: string;

///<summary> Returns the ini-file with the application name </summary>
function TApplication_GetDefaultIniFileName: string;

///<summary>
/// Returns the registry path SOFTWARE\[company\]Application
/// if the application does not have version information, the company part is omitted. </summary>
function TApplication_GetRegistryPath: string;
///<summary>
/// Returns the registry path SOFTWARE\[company\]Application\Config
/// if the application does not have version information, the company part is omitted. </summary>
function TApplication_GetConfigRegistryPath: string;

///<summary> switches off "Windows Ghosting" in Win 2000 and XP
///          This is a workaround for the bug that modal forms sometimes aren't modal in W2K and XP.
///          Call in application startup. </summary>
procedure DisableProcessWindowsGhosting;

procedure MergeForm(AControl: TWinControl; AForm: TForm; Align: TAlign; Show: Boolean); deprecated; // use a frame instead
///<summary> Reverses a VclUtils.MergeForm (rxlib)
///          @param Form is the TForm to unmerge </summary>
procedure UnMergeForm(_Form: TCustomForm); deprecated; // use a frame instead

///<summary> Calls lv.Items.BeginUpdate and returns an interface which, when released calls
///          lv.Items.EndUpdate. </summary>
function TListView_BeginUpdate(_lv: TListView): IInterface;

///<summary> free all lv.Items[n].Data objects and then clear the items </summary>
procedure TListView_ClearWithObjects(_lv: TListView);

///<summary> Unselect all items, if WithSelectEvents is false, OnSelectItem events will be temporarily
///          disabled. </summary>
procedure TListView_UnselectAll(_lv: TListView; _WithSelectEvents: Boolean = True);

///<summary> Returns the number of selected items in the ListView </summary>
function TListView_GetSelectedCount(_lv: TListView): Integer;

function TListView_GetSelected(_lv: TListView; out _Idx: Integer): Boolean; overload;
function TListView_GetSelected(_lv: TListView; out _Item: TListItem): Boolean; overload;

function TListView_Select(_lv: TListView; const _Caption: string; _DefaultIdx: Integer = -1): Integer;

type
  TListViewResizeOptions = (lvrCaptions, lvrContent);
  TLIstViewResizeOptionSet = set of TListViewResizeOptions;
///<summary>
/// Resize a TListView column in vsReport ViewStyle
/// @param lc is the TListColumn to resize
/// @param Options is a set of tListViewResizeOptions
///                lvrCaptions means resize so the captions fit
///                lvrContent menas resize so the contents fit
///                both can be combined. </summary>
procedure TListView_ResizeColumn(_lc: TListColumn; _Options: TLIstViewResizeOptionSet);
///<summary>
/// Resize all columns of a TListView in vsReport ViewStyle
/// @param lc is the TListColumn to resize
/// @param Options is a set of tListViewResizeOptions
///                lvrCaptions means resize so the captions fit
///                lvrContent menas resize so the contents fit
///                both can be combined. </summary>
procedure TListView_Resize(_lv: TListView; _Options: TLIstViewResizeOptionSet = [lvrCaptions, lvrContent]);

///<summary>
/// Gets the index of the selected item of the ListView
/// @param lv is the ListView to work on
/// @param Idx is the index of the selected item, only valid if Result = true
/// @returns true, if an item was selected, false otherwise </summary>
function TListView_TryGetSelected(_lv: TListView; out _Idx: Integer): Boolean; overload;
///<summary>
/// Gets the selected item of the ListView
/// @param lv is the ListView to work on
/// @param li is the selected item, only valid if Result = true
/// @returns true, if an item was selected, false otherwise </summary>
function TListView_TryGetSelected(_lv: TListView; out _li: TListItem): Boolean; overload;

///<summary> Returns the first item in the radio group with the caption ItemText </summary>
function TRadioGroup_GetButton(_rg: TRadioGroup; const _ItemText: string): TRadioButton; overload;
///<summary> Returns the ItemIdx'th item in the radio group </summary>
function TRadioGroup_GetButton(_rg: TRadioGroup; _ItemIdx: Integer): TRadioButton; overload;

///<summary> Returns the Checked value of a TCheckbox or TRadioButton (which both descend from TButtonControl) </summary>
function TButtonControl_GetChecked(_bctrl: TButtonControl): Boolean;

///<summary> Sets the Checked value of a TCheckbox or TRadioButton (which both descend from TButtonControl) </summary>
procedure TButtonControl_SetChecked(_bctrl: TButtonControl; _Value: Boolean);

///<summary> Sets the Caption value of a TCheckbox or TRadioButton (which both descend from TButtonControl) </summary>
procedure TButtonControl_SetCaption(_bctrl: TButtonControl; const _Value: string);

{$IFNDEF DELPHI2009_UP}
//Delphi 2009 introduced TCustomButton as the common Ancestor of TButton and TBitBtn.
type
  TCustomButton = TButton;
{$ENDIF}

///<summary>
/// Adds a drowdown menu to a button which automatically gets opened when the user clicks on
/// the button. The button's OnClick event gets changed by this. </summary>
procedure TButton_AddDropdownMenu(_btn: TCustomButton; _pm: TPopupMenu);

///<summary>
/// Appends a new menu item with the given Caption to the popup menu and returns it </summary>
function TPopupMenu_AppendMenuItem(_pm: TPopupMenu; const _Caption: string; _OnClick: TNotifyEvent): TMenuItem; overload;

///<summary>
/// Appends a new menu item with the given Action to the popup menu and returns it </summary>
function TPopupMenu_AppendMenuItem(_pm: TPopupMenu; _Action: TBasicAction): TMenuItem; overload;

///<summary>
/// Appends all menu items of Src to the menu items of Dest, optionally with a divider
/// between the existing and the new items. </summary>
procedure TPopupMenu_AppendAllMenuItems(_Dest: TPopupMenu; _Src: TPopupMenu; _InsertDivider: Boolean = True);

///<summary>
/// Appends menu items for all actions in Src to the menu items of Dest, optionally with a divider
/// between the existing and the new items. </summary>
procedure TPopupMenu_AppendAllActions(_Dest: TPopupMenu; _Src: TActionList; _InsertDivider: Boolean = True);

///<summary>
/// Appends a new menu item with the given Caption to the given menu item and returns it </summary>
function TMenuItem_AppendSubmenuItem(_mi: TMenuItem; const _Caption: string; _OnClick: TNotifyEvent): TMenuItem; overload;

///<summary>
/// Appends a new sub menu item with the given Action to the given menu item and returns it </summary>
function TMenuItem_AppendSubmenuItem(_mi: TMenuItem; _Action: TBasicAction): TMenuItem; overload;

///<summary> sets Screen.Cursor to NewCursor and restores it automatically when the returned interface
///          goes out of scope </summary>
function TCursor_TemporaryChange(_NewCursor: TCursor = crHourGlass): IInterface;

///<summary> If the Checked property of the action = the Checked parameter nothing happens and
///          the function returns true. If they are different, it calls the action's Execute
///          method and returns its result.
///          @returns true, if Execute was called and returned true, false otherwise </summary>
function TAction_SetCheckedExecute(_act: TCustomAction; _Checked: Boolean): Boolean;

///<summary>
/// (Tries to) set the Visible property of all actions in the action list.
/// This only works for Actions that are derived from TCustomAction (TActionList.Actions contains
/// TBasicAction items, so this is not necessarily true for all actions).
procedure TActionList_SetAllVisible(_al: TActionList; _Visible: Boolean);

///<summary> Sets the caption of a groupbox in the form '<prefix:><filename>' shortening the
///          filename in the path part using '..' so the file name itself should be visible.
///          Note that the Prefix is used as is, so include any whitespace and punctuation you
///          might want to see. </summary>
function TGroupBox_SetFileCaption(_grp: TCustomGroupBox; const _Prefix: string; const _Filename: string): string;

type
  TActionListShortcutHelper = class
  private
    type
      TShortcutRec = record
        Action: TAction;
        PrimaryShortcut: TShortCut;
        SecondaryShortcuts: array of TShortCut;
        procedure Assign(_Action: TAction);
        procedure AssignTo(_Action: TAction);
      end;
  private
    FActionList: TActionList;
    FShortcuts: array of TShortcutRec;
  public
    constructor Create(_al: TActionList);
    procedure RemoveShortcuts;
    procedure AssignShortcuts;
  end;

type
  TRectLTWH = record
  public
    Left: Integer;
    Top: Integer;
    Width: Integer;
    Height: Integer;
    procedure Assign(_Left, _Top, _Width, _Height: Integer); overload;
    procedure Assign(_a: TRect); overload;
    procedure AssignTLRB(_Left, _Top, _Right, _Bottom: Integer);
    class operator Implicit(_a: TRect): TRectLTWH;
    class operator Implicit(_a: TRectLTWH): TRect;
  end;

///<summary>
/// Move the rectangle (usually representing a form) so it is fully visible on the given monitor.</summary>
procedure TMonitor_MakeFullyVisible(_MonitorRect: TRect; var _Left, _Top, _Width, _Height: Integer); overload;
procedure TMonitor_MakeFullyVisible(_Monitor: TMonitor; var _Left, _Top, _Width, _Height: Integer); overload;
procedure TMonitor_MakeFullyVisible(_MonitorRect: TRect; var _Rect: TRect; out _Width, _Height: Integer); overload;
procedure TMonitor_MakeFullyVisible(_Monitor: TMonitor; var _Rect: TRect; out _Width, _Height: Integer); overload;
procedure TMonitor_MakeFullyVisible(_Monitor: TMonitor; var _Rect: TRect); overload;
procedure TMonitor_MakeFullyVisible(_Monitor: TMonitor; var _Rect: TRectLTWH); overload;

implementation

uses
  Consts,
{$IFDEF RTL230_UP}
  Vcl.Imaging.JPEG,
{$ELSE}
  JPEG,
{$ENDIF RTL230_UP}
  ShellApi,
  StrUtils,
  Types,
  Math,
  FileCtrl,
{$IFDEF SUPPORTS_UNICODE_STRING}
  AnsiStrings,
{$ENDIF SUPPORTS_UNICODE_STRING}
{$IFDEF GIFByRx}
  RxGConst,
  rxGif,
{$ENDIF GIFByRx}
  u_dzConvertUtils,
  u_dzDateUtils,
  u_dzStringUtils,
  u_dzFileUtils,
  u_dzClassUtils,
{$IFDEF dzMESSAGEDEBUG}
  u_dzWmMessageToString,
{$ENDIF dzMESSAGEDEBUG}
  u_dzSortProvider,
  u_dzVersionInfo,
  u_dzGraphicsUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

procedure TBitBtn_GlyphFromString(_btn: TBitBtn; const _GlyphStr: AnsiString; _ContainsLength: Boolean = True);
var
  st: TMemoryStream;
  s: AnsiString;
  Buf: array of Byte;
  Res: Integer;
  Size: Integer;
begin
  if _ContainsLength then
    s := LowerCase(Copy(_GlyphStr, 9))
  else
    s := LowerCase(_GlyphStr);
  Size := Length(s) div 2;
  SetLength(Buf, Size);
  Res := HexToBin(PAnsiChar(s), @Buf[0], Size);
  if Res <> Size then
    raise Exception.CreateFmt(_('Glyph string contained invalid character at position %d.'), [Res]);
  st := TMemoryStream.Create;
  try
    st.Write(Buf[0], Size);
    st.Position := 0;
    _btn.Glyph.LoadFromStream(st);
  finally
    FreeAndNil(st);
  end;
end;

procedure TBitmap_LoadFromString(_bmp: TBitmap; const _Content: AnsiString; _ContainsLength: Boolean = True);
var
  st: TMemoryStream;
  s: AnsiString;
  Buf: array of Byte;
  Res: Integer;
  Size: Integer;
begin
  if _ContainsLength then
    s := LowerCase(Copy(_Content, 9))
  else
    s := LowerCase(_Content);
  Size := Length(s) div 2;
  SetLength(Buf, Size);
  Res := HexToBin(PAnsiChar(s), @Buf[0], Size);
  if Res <> Size then
    raise Exception.CreateFmt(_('Bitmap string contained invalid character at position %d.'), [Res]);
  st := TMemoryStream.Create;
  try
    st.Write(Buf[0], Size);
    st.Position := 0;
    _bmp.LoadFromStream(st);
  finally
    FreeAndNil(st);
  end;
end;

// we need this to access protected methods
type
  TGridHack = class(TCustomGrid);
  TDbGridHack = class(TCustomDbGrid);

function TGrid_GetText(_Grid: TCustomGrid; _IncludeFixed: Boolean = False): string;
var
  Selection: TGridRect;
  Grid: TGridHack;
begin
  Grid := TGridHack(_Grid);
  if _IncludeFixed then begin
    Selection.Left := 0;
    Selection.Top := 0;
  end else begin
    Selection.Left := Grid.FixedCols;
    Selection.Top := Grid.FixedRows;
  end;
  Selection.Right := Grid.ColCount - 1;
  Selection.Bottom := Grid.RowCount - 1;
  Result := TGrid_GetText(_Grid, Selection);
end;

function TGrid_GetText(_Grid: TCustomGrid; _Selection: TGridRect): string;
var
  Grid: TGridHack;
  Line: TLineBuilder;
  Content: TLineBuilder;
  r: Integer;
  c: Integer;
begin
  Grid := TGridHack(_Grid);
  Result := '';
  Content := TLineBuilder.Create(#13#10);
  try
    Line := TLineBuilder.Create;
    try
      for r := _Selection.Top to _Selection.Bottom do begin
        Line.Clear;
        for c := _Selection.Left to _Selection.Right do begin
          Line.Add(Grid.GetEditText(c, r));
        end;
        Content.Add(Line.Content);
      end;
    finally
      FreeAndNil(Line);
    end;
    Result := Content.Content;
  finally
    FreeAndNil(Content);
  end;
end;

procedure TGrid_ExportToStream(_Grid: TCustomGrid; _Stream: TStream; _IncludeFixed: Boolean = False);
var
  s: string;
begin
  s := TGrid_GetText(_Grid, _IncludeFixed);
  TStream_WriteStringLn(_Stream, s);
end;

procedure TGrid_ExportToStream(_Grid: TCustomGrid; _Stream: TStream; _Selection: TGridRect);
var
  s: string;
begin
  s := TGrid_GetText(_Grid, _Selection);
  TStream_WriteStringLn(_Stream, s);
end;

procedure TGrid_ExportToFile(_Grid: TCustomGrid; const _Filename: string; _IncludeFixed: Boolean = False);
var
  t: Text;
  s: string;
begin
  s := TGrid_GetText(_Grid, _IncludeFixed);
  AssignFile(t, _Filename);
  Rewrite(t);
  try
    Write(t, s);
  finally
    CloseFile(t);
  end;
end;

function TGrid_SetRowCount(_Grid: TCustomGrid; _RowCount: Integer): Integer;
var
  Grid: TGridHack;
begin
  Grid := TGridHack(_Grid);
  if Grid.FixedRows >= _RowCount then
    Result := Grid.FixedRows + 1
  else
    Result := _RowCount;
  Grid.RowCount := Result;
end;

function TGrid_SetColCount(_Grid: TCustomGrid; _ColCount: Integer): Integer;
var
  Grid: TGridHack;
begin
  Grid := TGridHack(_Grid);
  if Grid.FixedCols >= _ColCount then
    Result := Grid.FixedCols + 1
  else
    Result := _ColCount;
  Grid.ColCount := Result;
end;

function TGrid_RowToNonfixedRow(_Grid: TCustomGrid; _Row: Integer): Integer;
begin
  Result := _Row - TGridHack(_Grid).FixedRows;
end;

function TGrid_GetNonfixedRow(_Grid: TCustomGrid): Integer;
begin
  Result := TGrid_RowToNonfixedRow(_Grid, TGridHack(_Grid).Row);
end;

function TGrid_NonFixedRowToRow(_Grid: TCustomGrid; _Row: Integer): Integer;
begin
  Result := _Row + TGridHack(_Grid).FixedRows;
end;

procedure TGrid_MakeCurrentRowVisible(_Grid: TCustomGrid);
var
  Grid: TGridHack;
  r: Integer;
begin
  Grid := TGridHack(_Grid);
  r := Grid.Row;
  if r > Grid.TopRow + Grid.VisibleRowCount - 1 then
    Grid.TopRow := r - Grid.VisibleRowCount + 1
  else if r < Grid.TopRow then
    Grid.TopRow := r;
end;

function TGrid_SetNonfixedRow(_Grid: TCustomGrid; _Row: Integer; _MakeVisibile: Boolean = True): Integer;
var
  Grid: TGridHack;
begin
  if _Row < 0 then
    _Row := 0;
  Grid := TGridHack(_Grid);
  Result := Grid.FixedRows + _Row;
  if Grid.RowCount > 0 then begin
    if Result >= Grid.RowCount then
      Result := Grid.RowCount - 1;
    Grid.Row := Result;
  end;
  if _MakeVisibile then
    TGrid_MakeCurrentRowVisible(_Grid);
end;

function TGrid_SetNonfixedColCount(_Grid: TCustomGrid; _ColCount: Integer): Integer;
var
  Grid: TGridHack;
begin
  Grid := TGridHack(_Grid);
  if _ColCount = 0 then
    _ColCount := 1;
  Result := Grid.FixedCols + _ColCount;
  Grid.ColCount := Result;
end;

function TGrid_SetNonfixedRowCount(_Grid: TCustomGrid; _RowCount: Integer): Integer;
var
  Grid: TGridHack;
begin
  Grid := TGridHack(_Grid);
  if _RowCount = 0 then
    _RowCount := 1;
  Result := Grid.FixedRows + _RowCount;
  Grid.RowCount := Result;
end;

procedure TStringGrid_SetRowCount(_Grid: TCustomGrid; _RowCount: Integer);
begin
  TGrid_SetRowCount(_Grid, _RowCount);
end;

procedure TStringGrid_SetColCount(_Grid: TCustomGrid; _ColCount: Integer);
begin
  TGrid_SetColCount(_Grid, _ColCount);
end;

procedure TGrid_SetRowNoClick(_Grid: TCustomGrid; _Row: Integer);
var
  Event: TNotifyEvent;
var
  Grid: TGridHack;
begin
  Grid := TGridHack(_Grid);
  Event := Grid.OnClick;
  try
    Grid.OnClick := nil;
    Grid.Row := _Row;
  finally
    Grid.OnClick := Event;
  end;
end;

procedure TStringGrid_ExportToFile(_Grid: TCustomGrid; const _Filename: string);
begin
  TGrid_ExportToFile(_Grid, _Filename, True);
end;

procedure TStringGrid_Clear(_Grid: TStringGrid);
var
  c: Integer;
begin
  _Grid.RowCount := _Grid.FixedRows + 1;
  for c := _Grid.FixedCols to _Grid.ColCount - 1 do
    _Grid.Cells[c, _Grid.FixedRows] := '';
end;

procedure TStringGrid_SetNonfixedCell(_Grid: TStringGrid; _Col, _Row: Integer; const _Text: string);
begin
  _Grid.Cells[_Col + _Grid.FixedCols, _Row + _Grid.FixedRows] := _Text;
end;

function TStringGrid_GetNonfixedCell(_Grid: TStringGrid; _Col, _Row: Integer): string;
begin
  Result := _Grid.Cells[_Col + _Grid.FixedCols, _Row + _Grid.FixedRows];
end;

function TStringGrid_AddColumn(_Grid: TStringGrid; const _Caption: string): Integer;
var
  i: Integer;
begin
  Result := _Grid.ColCount;
  for i := _Grid.ColCount - 1 downto 0 do begin
    if _Grid.Cells[i, 0] = '' then begin
      Result := i;
    end;
  end;

  if Result >= _Grid.ColCount then
    TGrid_SetColCount(_Grid, Result + 1);
  _Grid.Cells[Result, 0] := _Caption;
end;

procedure TStringGrid_ScrollUp(_Grid: TStringGrid; _Top: Integer = -1; _Bottom: Integer = -1);
var
  r: Integer;
  c: Integer;
begin
  if _Top = -1 then
    _Top := _Grid.FixedRows;
  if _Bottom = -1 then
    _Bottom := _Grid.RowCount - 1;
  for r := _Top to _Bottom - 1 do begin
    for c := _Grid.FixedCols to _Grid.ColCount - 1 do
      _Grid.Cells[c, r] := _Grid.Cells[c, r + 1];
  end;
  if _Bottom > _Top then
    for c := _Grid.FixedCols to _Grid.ColCount - 1 do
      _Grid.Cells[c, _Bottom] := '';
end;

function TStringGrid_DeleteRow(_Grid: TStringGrid; _Row: Integer): Boolean;
var
  r: Integer;
  c: Integer;
begin
  Assert(Assigned(_Grid));
  Assert(_Grid.FixedRows < _Grid.RowCount);

  if _Row = -1 then
    _Row := _Grid.Row;
  if (_Row < _Grid.FixedRows) or (_Row >= _Grid.RowCount) then begin
    Result := False;
    Exit;
  end;
  if _Grid.RowCount <= _Grid.FixedRows + 1 then begin
    for c := 0 to _Grid.ColCount - 1 do
      _Grid.Cells[c, _Grid.FixedRows] := '';
    Result := True;
    Exit;
  end;

  if _Grid.Row = _Grid.RowCount - 1 then
    _Grid.Row := _Grid.Row - 1;

  for r := _Row + 1 to _Grid.RowCount - 1 do begin
    for c := 0 to _Grid.ColCount - 1 do
      _Grid.Cells[c, r - 1] := _Grid.Cells[c, r];
  end;
  _Grid.RowCount := _Grid.RowCount - 1;
  Result := True;
end;

function TStringGrid_InsertRow(_Grid: TStringGrid; _Row: Integer = -1): Integer;
var
  r: Integer;
  c: Integer;
begin
  Assert(Assigned(_Grid));

  if _Row = -1 then
    _Row := _Grid.Row;
  if (_Row < _Grid.FixedRows) or (_Row >= _Grid.RowCount) then begin
    Result := -1;
    Exit;
  end;

  _Grid.RowCount := _Grid.RowCount + 1;
  for r := _Grid.RowCount - 1 downto _Row + 1 do begin
    for c := 0 to _Grid.ColCount - 1 do
      _Grid.Cells[c, r] := _Grid.Cells[c, r - 1];
  end;
  for c := 0 to _Grid.ColCount - 1 do
    _Grid.Cells[c, _Row] := '';
  Result := _Row;
end;

function TStringGrid_AppendRow(_Grid: TStringGrid): Integer;
begin
  Result := _Grid.RowCount;
  _Grid.RowCount := Result + 1;
end;

function TStringGrid_CellToDouble(_Grid: TStringGrid; _Col, _Row: Integer; _FocusCell: Boolean = True): Double;
var
  s: string;
begin
  s := _Grid.Cells[_Col, _Row];
  if not TryStr2Float(s, Result, #0) then begin
    if _FocusCell then begin
      _Grid.Row := _Row;
      _Grid.Col := _Col;
      _Grid.SetFocus;
    end;
    raise EConvertError.CreateFmt(_('"%s" is not a valid floating point value.'), [s]);
  end;
end;

function TStringGrid_CellToInt(_Grid: TStringGrid; _Col, _Row: Integer; _FocusCell: Boolean = True): Integer;
var
  s: string;
begin
  s := _Grid.Cells[_Col, _Row];
  if not TryStrToInt(s, Result) then begin
    if _FocusCell then begin
      _Grid.Row := _Row;
      _Grid.Col := _Col;
      _Grid.SetFocus;
    end;
    raise EConvertError.CreateFmt(_('"%s" is not a valid integer value.'), [s]);
  end;
end;

type
  THackEdit = class(TCustomEdit)
  end;

procedure TEdit_SetEnabled(_ed: TCustomEdit; _Enabled: Boolean);
var
  ed: THackEdit;
begin
  ed := THackEdit(_ed);
  ed.Enabled := _Enabled;
  if _Enabled then
    ed.Color := clWindow
  else
    ed.Color := clBtnFace;
end;

procedure TEdit_SetTextNoChange(_ed: TCustomEdit; const _Text: string);
var
  Event: TNotifyEvent;
  ed: THackEdit;
begin
  ed := THackEdit(_ed);
  Event := ed.OnChange;
  ed.OnChange := nil;
  try
    ed.Text := _Text;
  finally
    ed.OnChange := Event;
  end;
end;

function TEdit_TextHHMMSSToTime(_ed: TCustomEdit; _FocusControl: Boolean = True): TDateTime;
var
  s: string;
begin
  s := _ed.Text;
  if not TryIso2Time(s, Result) then begin
    if _FocusControl then begin
      _ed.SetFocus;
    end;
    raise EConvertError.CreateFmt(_('"%s" is not a time value (format: hh:mm:ss) (%s).'), [s, _ed.Name]);
  end;
end;

function TEdit_TextToDouble(_ed: TCustomEdit; _FocusControl: Boolean = True): Double;
var
  s: string;
begin
  s := _ed.Text;
  if not TryStr2Float(s, Result, #0) then begin
    if _FocusControl then begin
      _ed.SetFocus;
    end;
    raise EConvertError.CreateFmt(_('"%s" is not a valid floating point value (%s).'), [s, _ed.Name]);
  end;
end;

function TEdit_TryTextToDouble(_ed: TEdit; out _Value: Double; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
var
  s: string;
begin
  s := _ed.Text;
  Result := TryStr2Float(s, _Value, #0);
  if Result then
    _ed.Color := _OkColor
  else
    _ed.Color := _ErrColor;
end;

function TEdit_TryTextToDouble(_ed: TEdit; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
var
  Value: Double;
begin
  Result := TEdit_TryTextToDouble(_ed, Value, _OkColor, _ErrColor);
end;

type
  TEditHack = class(TCustomEdit);

function TEdit_TryTextToFloat(_ed: TCustomEdit; out _Value: Extended;
  _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
var
  s: string;
begin
  s := _ed.Text;
  Result := TryStr2Float(s, _Value, #0);
  if Result then
    TEditHack(_ed).Color := _OkColor
  else
    TEditHack(_ed).Color := _ErrColor;
end;

function TEdit_TryTextToFloat(_ed: TCustomEdit; out _Value: Double;
  _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
var
  s: string;
begin
  s := _ed.Text;
  Result := TryStr2Float(s, _Value, #0);
  if Result then
    TEditHack(_ed).Color := _OkColor
  else
    TEditHack(_ed).Color := _ErrColor;
end;

function TEdit_TryTextToFloat(_ed: TCustomEdit; out _Value: Single;
  _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
var
  s: string;
begin
  s := _ed.Text;
  Result := TryStr2Float(s, _Value, #0);
  if Result then
    TEditHack(_ed).Color := _OkColor
  else
    TEditHack(_ed).Color := _ErrColor;
end;

function TEdit_IsTextFloat(_ed: TCustomEdit; _MinValue, _MaxValue: Extended;
  _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
var
  Value: Extended;
begin
  Result := TEdit_TryTextToFloat(_ed, Value, _OkColor, _ErrColor);
  if not Result then
    Exit;
  Result := (CompareValue(_MinValue, Value) <> GreaterThanValue)
    and (CompareValue(_MaxValue, Value) <> LessThanValue);
  if Result then
    TEditHack(_ed).Color := _OkColor
  else
    TEditHack(_ed).Color := _ErrColor;
end;

function TEdit_IsTextFloat(_ed: TCustomEdit; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
var
  Value: Extended;
begin
  Result := TEdit_TryTextToFloat(_ed, Value, _OkColor, _ErrColor);
end;

function TEdit_IsTextInt(_ed: TCustomEdit; _MinValue, _MaxValue: Integer;
  _OkColor: TColor; _ErrColor: TColor = clYellow): Boolean;
var
  Value: Integer;
begin
  Result := TEdit_TryTextToInt(_ed, Value, _OkColor, _ErrColor);
  if not Result then
    Exit;
  Result := (_MinValue < Value) and (Value < _MaxValue);
  if Result then
    TEditHack(_ed).Color := _OkColor
  else
    TEditHack(_ed).Color := _ErrColor;
end;

function TEdit_IsTextInt(_ed: TCustomEdit; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
var
  Value: Integer;
begin
  Result := TEdit_TryTextToInt(_ed, Value, _OkColor, _ErrColor);
end;

function TEdit_TryTextToInt(_ed: TCustomEdit; out _Value: Integer;
  _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
var
  s: string;
begin
  s := _ed.Text;
  Result := TryStrToInt(s, _Value);
  if Result then
    TEditHack(_ed).Color := _OkColor
  else
    TEditHack(_ed).Color := _ErrColor;
end;

function TEdit_IsTextNonEmpty(_ed: TCustomEdit; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
begin
  Result := _ed.Text <> '';
  if Result then
    TEditHack(_ed).Color := _OkColor
  else
    TEditHack(_ed).Color := _ErrColor;
end;

function TEdit_TryTextToInt(_ed: TEdit; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
var
  Value: Integer;
begin
  Result := TEdit_TryTextToInt(_ed, Value, _OkColor, _ErrColor);
end;

function TEdit_TextToInt(_ed: TCustomEdit; _FocusControl: Boolean = True): Integer;
var
  s: string;
begin
  s := _ed.Text;
  if not TryStrToInt(s, Result) then begin
    if _FocusControl then begin
      _ed.SetFocus;
    end;
    raise EConvertError.CreateFmt(_('"%s" is not a valid integer value.'), [s]);
  end;
end;

function TEdit_TextToInt(_ed: TLabeledEdit; _FocusControl: Boolean = True): Integer;
var
  s: string;
begin
  s := _ed.Text;
  if not TryStrToInt(s, Result) then begin
    if _FocusControl then begin
      _ed.SetFocus;
    end;
    raise EConvertError.CreateFmt(_('"%s" is not a valid integer value.'), [s]);
  end;
end;

function TEdit_TextToIntDef(_ed: TCustomEdit; _Default: Integer): Integer;
begin
  if not TEdit_TryTextToInt(_ed, Result) then
    Result := _Default;
end;

function TTreeView_GetAsText(_Tree: TTreeView; _Indentation: Integer = 2; _Marker: Char = #0): string;
var
  Level: Integer;
  Marker: string;

  function GetSubnodes(_tn: TTreeNode): string;
  var
    Child: TTreeNode;
  begin
    if Assigned(_tn) then begin
      Result := StringOfChar(' ', Level * _Indentation) + Marker + _tn.Text + #13#10;
      Inc(Level);
      try
        Child := _tn.getFirstChild;
        while Assigned(Child) do begin
          Result := Result + GetSubnodes(Child);
          Child := Child.getNextSibling;
        end;
      finally
        Dec(Level);
      end;
    end else
      Result := '';
  end;

begin
  if _Marker = #0 then
    Marker := ''
  else
    Marker := _Marker;
  Result := GetSubnodes(_Tree.Items.GetFirstNode);
end;

function ArrayContains(_Element: Integer; const _Arr: array of Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(_Arr) to High(_Arr) do begin
    Result := _Arr[i] = _Element;
    if Result then
      Exit;
  end;
end;

procedure HandleRow(_Grid: TGridHack; _Col, _Row: Integer; var _MinWidth: Integer);
var
  ColWidth: Integer;
  ColText: string;
begin
  ColText := _Grid.GetEditText(_Col, _Row);
  ColWidth := _Grid.Canvas.TextWidth(ColText);
  if ColWidth > _MinWidth then
    _MinWidth := ColWidth;
end;

procedure TGrid_Resize(_Grid: TCustomGrid);
begin
  TGrid_Resize(_Grid, [], [], -1);
end;

procedure TGrid_Resize(_Grid: TCustomGrid; _Options: TResizeOptionSet);
begin
  TGrid_Resize(_Grid, _Options, [], -1);
end;

procedure TGrid_Resize(_Grid: TCustomGrid; _Options: TResizeOptionSet; _RowOffset: Integer);
begin
  TGrid_Resize(_Grid, _Options, [], _RowOffset);
end;

procedure TGrid_Resize(_Grid: TCustomGrid; _Options: TResizeOptionSet; const _ConstantCols: array of Integer);
begin
  TGrid_Resize(_Grid, _Options, _ConstantCols, -1);
end;

procedure TGrid_Resize(_Grid: TCustomGrid; _Options: TResizeOptionSet; const _ConstantCols: array of Integer; _RowOffset: Integer);
var
  Col, Row: Integer;
  Grid: TGridHack;
  MinWidth: Integer;
  MinCol: Integer;
  MaxCol: Integer;
  MaxRow: Integer;
  ColWidths: array of Integer;
  FirstRow: Integer;
  SumWidths: Integer;
  Additional: Integer;
begin
  Grid := TGridHack(_Grid);
  MaxCol := Grid.ColCount - 1;
  MinCol := 0;
  SetLength(ColWidths, MaxCol + 1);

  if _RowOffset = -1 then
    FirstRow := Grid.FixedRows
  else
    FirstRow := _RowOffset;

  MaxRow := FirstRow + 10;
  if (MaxRow >= Grid.RowCount) or (roUseAllRows in _Options) or (roUseLastRows in _Options) then
    MaxRow := Grid.RowCount - 1;
  if roUseLastRows in _Options then begin
    if MaxRow > FirstRow + 10 then
      FirstRow := MaxRow - 1
  end;
  SumWidths := MaxCol; // one spare pixel per column
  if goVertLine in Grid.Options then
    Inc(SumWidths, Grid.GridLineWidth);
  for Col := MinCol to MaxCol do begin
    if ArrayContains(Col, _ConstantCols) then
      MinWidth := Grid.ColWidths[Col]
    else begin
      MinWidth := 0;

      if not (roIgnoreHeader in _Options) then
        for Row := 0 to Grid.FixedRows - 1 do
          HandleRow(Grid, Col, Row, MinWidth);

      for Row := FirstRow to MaxRow do
        HandleRow(Grid, Col, Row, MinWidth);

      if goVertLine in Grid.Options then
        Inc(MinWidth, Grid.GridLineWidth);
      Inc(MinWidth, 4); // 2 Punkte rechts und links, wie in TStringGrid.DrawCell
      if MinWidth < Grid.DefaultColWidth then
        MinWidth := Grid.DefaultColWidth;
    end;
    ColWidths[Col] := MinWidth;
    Inc(SumWidths, MinWidth);
  end;
  if (SumWidths < Grid.ClientWidth) and (roUseGridWidth in _Options)
    and (Length(_ConstantCols) < MaxCol + 1) then begin
    Additional := (Grid.ClientWidth - SumWidths) div (MaxCol + 1 - Length(_ConstantCols));
    for Col := MinCol to MaxCol do begin
      if not ArrayContains(Col, _ConstantCols) then begin
        Inc(ColWidths[Col], Additional);
        Inc(SumWidths, Additional);
      end;
    end;
    if SumWidths < Grid.ClientWidth then begin
      Col := MaxCol;
      while ArrayContains(Col, _ConstantCols) do
        Dec(Col);
      Inc(ColWidths[Col], Grid.ClientWidth - SumWidths);
    end;
  end;
  for Col := MinCol to MaxCol do
    Grid.ColWidths[Col] := ColWidths[Col];
end;

function TDbGrid_CalcAdditionalWidth(_Grid: TCustomDbGrid): Integer;
var
  Grid: TDbGridHack;
begin
  Grid := TDbGridHack(_Grid);
  Result := 4; // for some reason this must be 4 and not 0
  if dgColLines in Grid.Options then
    // there is one more grid line than there are columns
    Inc(Result, Grid.GridLineWidth);
  if dgIndicator in Grid.Options then
    Inc(Result, 21); // ColWidht[0] does not work :-(
end;

procedure TDbGrid_Resize(_Grid: TCustomDbGrid; _Options: TResizeOptionSet = [];
  _MinWidth: Integer = 100); overload;
var
  MinWidths: array of Integer;
  Grid: TDbGridHack;
  i: Integer;
  TotalWidth: Integer;
  sp: TdzIntegerArraySortProvider;
  WidestIdx: Integer;
  Additional: Integer;
begin
  Grid := TDbGridHack(_Grid);
  SetLength(MinWidths, Grid.Columns.Count);
  TotalWidth := 0;
  for i := 0 to Grid.Columns.Count - 1 do begin
    MinWidths[i] := Grid.Columns[i].DefaultWidth;
    Inc(TotalWidth, MinWidths[i]);
  end;

  if roReduceMinWidth in _Options then begin
    Additional := TDbGrid_CalcAdditionalWidth(_Grid);
    if dgColLines in Grid.Options then
      Inc(Additional, Grid.GridLineWidth * Grid.Columns.Count);
    Inc(Additional, 4 * Grid.Columns.Count); // 2 pixels right and left, like in TStringGrid.DrawCell
    Inc(TotalWidth, Additional);
    sp := TdzIntegerArraySortProvider.Create(MinWidths);
    try
      while TotalWidth > _Grid.ClientWidth do begin
        WidestIdx := sp.GetRealPos(High(MinWidths));
        if MinWidths[WidestIdx] <= _MinWidth then
          Break;
        Dec(TotalWidth, MinWidths[WidestIdx] - _MinWidth);
        MinWidths[WidestIdx] := _MinWidth;
        if TotalWidth < _Grid.ClientWidth then begin
          MinWidths[WidestIdx] := MinWidths[WidestIdx] + (_Grid.ClientWidth - TotalWidth);
          Break;
        end;
        sp.Update;
      end;
    finally
      FreeAndNil(sp);
    end;
  end;
  TDbGrid_Resize(_Grid, _Options, MinWidths);
end;

procedure TDbGrid_Resize(_Grid: TCustomDbGrid; _Options: TResizeOptionSet; _MinWidths: array of Integer);
var
  Col, Row: Integer;
  Grid: TDbGridHack;
  MinWidth: Integer;
  ColWidth: Integer;
  ColText: string;
  MinCol: Integer;
  MaxCol: Integer;
  MaxRow: Integer;
  ColWidths: array of Integer;
  FirstRow: Integer;
  SumWidths: Integer;
  Additional: Integer;
  DBColumn: TColumn;
  cw: Integer;
begin
  Grid := TDbGridHack(_Grid);
  MaxCol := Grid.ColCount - 1 - Grid.IndicatorOffset;
  MinCol := 0;
  SetLength(ColWidths, MaxCol + 1);
  FirstRow := 0;
  MaxRow := 10;
  if (MaxRow >= Grid.RowCount) or (roUseAllRows in _Options) then
    MaxRow := Grid.RowCount - 1;
  SumWidths := TDbGrid_CalcAdditionalWidth(_Grid);
  for Col := MinCol to MaxCol do begin
    DBColumn := Grid.Columns[Col];
    MinWidth := _MinWidths[Col];
    if not (roIgnoreHeader in _Options) then begin
      ColText := DBColumn.Title.Caption;
      ColWidth := Grid.Canvas.TextWidth(ColText);
      if ColWidth > MinWidth then
        MinWidth := ColWidth;
    end;
    for Row := FirstRow to MaxRow do begin
      ColText := Grid.GetEditText(Col + Grid.IndicatorOffset, Row);
      ColWidth := Grid.Canvas.TextWidth(ColText);
      if ColWidth > MinWidth then
        MinWidth := ColWidth;
    end;
    if dgColLines in Grid.Options then
      Inc(MinWidth, Grid.GridLineWidth);
    Inc(MinWidth, 4); // 2 pixels right and left, like in TStringGrid.DrawCell
    ColWidths[Col] := MinWidth;
    Inc(SumWidths, MinWidth);
  end;
  if roUseGridWidth in _Options then begin
    cw := Grid.ClientWidth;
    if Grid.ScrollBars in [ssBoth, ssVertical] then
      Dec(cw, GetSystemMetrics(SM_CXVSCROLL));
    if SumWidths < cw then begin
      Additional := (cw - SumWidths) div (MaxCol + 1);
      for Col := MinCol to MaxCol do begin
        Inc(ColWidths[Col], Additional);
        Inc(SumWidths, Additional);
      end;
      if SumWidths < cw then
        Inc(ColWidths[MaxCol], cw - SumWidths);
    end;
  end;
  for Col := MinCol to MaxCol do
    Grid.Columns[Col].Width := ColWidths[Col];
end;

function TDbGrid_AddColumn(_dbg: TDBGrid; const _Field: string; const _Title: string = ''; _Width: Integer = 0): TColumn;
begin
  Result := _dbg.Columns.Add;
  Result.Expanded := False;
  Result.FieldName := _Field;
  if _Title = '' then
    Result.Title.Caption := _Field
  else
    Result.Title.Caption := _Title;
  if _Width > 0 then
    Result.Width := _Width;
  Result.Visible := True;
end;

function TPageControl_AddTabSheet(_PageControl: TPageControl; const _Caption: string): TTabSheet;
begin
  Result := TTabSheet.Create(_PageControl);
  Result.Parent := _PageControl;
  Result.PageControl := _PageControl;
  Result.Caption := _Caption;
end;

procedure DrawTab(_TabControl: TCustomTabControl; const _Caption: string;
  const _Rect: TRect; _Active: Boolean);
var
  TopOffs: Integer;
begin
  if _Active then
    TopOffs := 4
  else
    TopOffs := 0;
  _TabControl.Canvas.TextRect(_Rect, _Rect.Left + 4, _Rect.Top + TopOffs, _Caption);
end;

procedure TPageControl_DrawTab(_PageControl: TPageControl; _TabIndex: Integer;
  const _Rect: TRect; _Active: Boolean);
begin
  DrawTab(_PageControl, _PageControl.Pages[_TabIndex].Caption, _Rect, _Active);
end;

procedure TTabControl_DrawTab(_TabControl: TTabControl; _TabIndex: Integer;
  const _Rect: TRect; _Active: Boolean);
begin
  DrawTab(_TabControl, _TabControl.Tabs[_TabIndex], _Rect, _Active);
end;

procedure TTabControl_AdjustTabWidth(_TabControl: TTabControl; _Form: TForm; _MinWidth: Integer = 80);
var
  i: Integer;
  MinWidth: Integer;
  w: Integer;
begin
  MinWidth := _MinWidth;
  for i := 0 to _TabControl.Tabs.Count - 1 do begin
    w := _TabControl.Canvas.TextWidth(_TabControl.Tabs[i]) + 16;
    if w > MinWidth then
      MinWidth := w;
  end;
  w := _TabControl.TabHeight;
  if (w < MinWidth) or (w > _MinWidth) then begin
    w := MinWidth - w;
    if Assigned(_Form) then
      _Form.Width := _Form.Width + w;
    if not Assigned(_Form) or not (akRight in _TabControl.Anchors) then
      _TabControl.Width := _TabControl.Width + w;
    _TabControl.TabHeight := MinWidth;
  end;
end;

function TTabControl_GetSelectedObject(_TabControl: TTabControl; out _Obj: Pointer): Boolean;
var
  Idx: Integer;
begin
  Idx := _TabControl.TabIndex;
  Result := (Idx <> -1);
  if Result then
    _Obj := _TabControl.Tabs.Objects[Idx];
end;

function TTabControl_GetSelectedObject(_TabControl: TTabControl; out _Idx: Integer; out _Obj: Pointer): Boolean;
begin
  _Idx := _TabControl.TabIndex;
  Result := (_Idx <> -1);
  if Result then
    _Obj := _TabControl.Tabs.Objects[_Idx];
end;

type
  // Note: This class is never instantiated, only the DrawPanel method will be used
  //       without ever referencing the self pointer (which is NIL), so it should work
  TStatusBarPainter = class
  public
    procedure DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
  end;

procedure TStatusBarPainter.DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
var
  cnv: TCanvas;
  s: string;
  h: Integer;
begin
  s := StatusBar.SimpleText;
  cnv := StatusBar.Canvas;
  h := cnv.TextHeight(s);
  cnv.TextRect(Rect, 2, (StatusBar.ClientHeight - h) div 2, StatusBar.SimpleText);
end;

procedure TStatusBar_EnableLongSimpleText(_StatusBar: TStatusBar);
var
  Painter: TStatusBarPainter;
  pnl: TStatusPanel;
begin
  _StatusBar.SimplePanel := False;
  _StatusBar.Panels.Clear;
  pnl := _StatusBar.Panels.Add;
  pnl.Style := psOwnerDraw;
  Painter := nil;
  _StatusBar.OnDrawPanel := Painter.DrawPanel;
end;

procedure TStatusBar_SetLongSimpleText(_StatusBar: TStatusBar; const _Text: string);
begin
  _StatusBar.SimpleText := _Text;
  _StatusBar.Invalidate;
end;

procedure SetControlEnabled(_Control: TControl; _Enabled: Boolean);
begin
  TControl_SetEnabled(_Control, _Enabled);
end;

procedure TControl_SetEnabled(_Control: TControl; _Enabled: Boolean);
var
  i: Integer;
  Container: TWinControl;
  ctrl: TControl;
begin
  if _Control is TWinControl then begin
    Container := _Control as TWinControl;
    for i := 0 to Container.ControlCount - 1 do begin
      ctrl := Container.Controls[i];
      TControl_SetEnabled(ctrl, _Enabled);
    end;
  end;
  _Control.Enabled := _Enabled;
end;

type
  TControlHack = class(TCustomControl);

procedure TControl_Resize(_Control: TControl);
begin
  TControlHack(_Control).Resize;
end;

type
  TComboBoxHack = class(TCustomComboBox);

procedure TComboBox_ClearWithObjects(_cmb: TCustomComboBox);
begin
  TStrings_FreeAllObjects(_cmb.Items);
  _cmb.Clear;
end;

procedure TComboBox_SetEnabled(_cmb: TCustomComboBox; _Enabled: Boolean);
var
  cmb: TComboBoxHack;
begin
  cmb := TComboBoxHack(_cmb);
  cmb.Enabled := _Enabled;
  if _Enabled then
    cmb.Color := clWindow
  else
    cmb.Color := clBtnFace;
end;

procedure TComboBox_SetDropdownWidth(_cmb: TCustomComboBox; _Pixels: Integer);
begin
  _cmb.HandleNeeded;
  _cmb.Perform(CB_SETDROPPEDWIDTH, _Pixels, 0);
end;

function TComboBox_SelectByObject(_cmb: TCustomComboBox; _Value: Pointer): Boolean;
var
  i: Integer;
begin
  for i := 0 to _cmb.Items.Count - 1 do begin
    Result := (_cmb.Items.Objects[i] = _Value);
    if Result then begin
      _cmb.ItemIndex := i;
      Exit;
    end;
  end;
  Result := False;
end;

function TComboBox_SelectByObject(_cmb: TCustomComboBox; _Value: Integer): Boolean;
begin
  Result := TComboBox_SelectByObject(_cmb, Pointer(_Value));
end;

function TComboBox_GetObjectCaption(_cmb: TCustomComboBox; _Obj: Pointer; out _s: string): Boolean;
var
  i: Integer;
begin
  for i := 0 to _cmb.Items.Count - 1 do begin
    Result := (_cmb.Items.Objects[i] = _Obj);
    if Result then begin
      _s := _cmb.Items[i];
      Exit;
    end;
  end;
  Result := False;
end;

function TComboBox_GetSelectedObject(_cmb: TCustomComboBox; out _Obj: Pointer; _FocusControl: Boolean = False): Boolean;
var
  Idx: Integer;
begin
  Result := TComboBox_GetSelectedObject(_cmb, Idx, _Obj, _FocusControl);
end;

function TComboBox_GetSelectedObject(_cmb: TCustomComboBox; out _ObjAsInt: Integer; _FocusControl: Boolean = False): Boolean;
var
  Obj: Pointer;
begin
  Result := TComboBox_GetSelectedObject(_cmb, Obj, _FocusControl);
  if Result then
    _ObjAsInt := Integer(Obj);
end;

function TComboBox_GetSelectedObject(_cmb: TCustomComboBox; out _Idx: Integer;
  out _Obj: Pointer; _FocusControl: Boolean = False): Boolean;
begin
  _Idx := _cmb.ItemIndex;
  Result := (_Idx <> -1);
  if Result then
    _Obj := _cmb.Items.Objects[_Idx]
  else if _FocusControl then
    _cmb.SetFocus;
end;

function TComboBox_GetSelectedObject(_cmb: TCustomComboBox;
  out _Item: string; out _Obj: Pointer; _FocusControl: Boolean = False): Boolean;
var
  Idx: Integer;
begin
  Idx := _cmb.ItemIndex;
  Result := (Idx <> -1);
  if Result then begin
    _Item := _cmb.Items[Idx];
    _Obj := _cmb.Items.Objects[Idx];
  end else if _FocusControl then
    _cmb.SetFocus;
end;

function TComboBox_GetSelectedObject(_cmb: TCustomComboBox;
  out _Item: string; out _ObjAsInt: Integer; _FocusControl: Boolean = False): Boolean;
var
  Obj: Pointer;
begin
  Result := TComboBox_GetSelectedObject(_cmb, _Item, Obj, _FocusControl);
  if Result then
    _ObjAsInt := Integer(Obj);
end;

function TComboBox_GetSelected(_cmb: TCustomComboBox; out _Idx: Integer;
  _FocusControl: Boolean = False): Boolean;
begin
  _Idx := _cmb.ItemIndex;
  Result := (_Idx <> -1);
  if not Result then
    if _FocusControl then
      _cmb.SetFocus;
end;

function TComboBox_GetSelected(_cmb: TCustomComboBox; out _Item: string;
  _FocusControl: Boolean = False): Boolean;
var
  Idx: Integer;
begin
  Result := TComboBox_GetSelected(_cmb, Idx, _FocusControl);
  if Result then
    _Item := _cmb.Items[Idx];
end;

function TComboBox_GetSelected(_cmb: TCustomComboBox): string; overload;
begin
  if not TComboBox_GetSelected(_cmb, Result) then
    raise EdzComboBoxNoSelection.Create(_('No item selected in combobox'));
end;

function TComboBox_GetSelectedDef(_cmb: TCustomComboBox; const _Default: string): string;
begin
  if not TComboBox_GetSelected(_cmb, Result) then
    Result := _Default;
end;

function TComboBox_GetSelectedDef(_cmb: TCustomComboBox; const _Default: Integer = -1): Integer; overload;
begin
  if not TComboBox_GetSelected(_cmb, Result) then
    Result := _Default;
end;

function TComboBox_GetSelectedObjectDef(_cmb: TCustomComboBox; _Default: Integer;
  _FocusControl: Boolean = False): Integer;
begin
  if not TComboBox_GetSelectedObject(_cmb, Result, _FocusControl) then
    Result := _Default;
end;

function TListBox_GetSelected(_lb: TCustomListbox; out _Item: string;
  _FocusControl: Boolean = False): Boolean;
var
  Idx: Integer;
begin
  Idx := _lb.ItemIndex;
  Result := Idx <> -1;
  if Result then
    _Item := _lb.Items[Idx]
  else if _FocusControl then
    _lb.SetFocus;
end;

function TListBox_GetSelected(_lb: TCustomListbox): string;
begin
  if not TListBox_GetSelected(_lb, Result) then
    raise EdzListBoxNoSelection(_('No item selected in listbox'));
end;

function TListBox_GetSelected(_lb: TCustomListbox; out _Idx: Integer; out _Item: string): Boolean;
begin
  _Idx := _lb.ItemIndex;
  Result := _Idx <> -1;
  if Result then
    _Item := _lb.Items[_Idx]
end;

function TListBox_GetSelected(_lb: TCustomListbox; _Selected: TStrings): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to _lb.Items.Count - 1 do begin
    if _lb.Selected[i] then begin
      Inc(Result);
      if Assigned(_Selected) then
        _Selected.AddObject(_lb.Items[i], _lb.Items.Objects[i]);
    end;
  end;
end;

function TComboBox_IsSelected(_cmb: TCustomComboBox; _OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): Boolean;
begin
  Result := (_cmb.ItemIndex <> -1);
  if Result then
    TComboBoxHack(_cmb).Color := _OkColor
  else
    TComboBoxHack(_cmb).Color := _ErrColor;
end;

function TListBox_GetSelectedObject(_lst: TCustomListbox; out _Idx: Integer; out _Obj: Pointer): Boolean;
begin
  _Idx := _lst.ItemIndex;
  Result := _Idx <> -1;
  if Result then
    _Obj := _lst.Items.Objects[_Idx];
end;

function TListBox_DeleteSelected(_lst: TCustomListbox; out _Idx: Integer): Boolean;
begin
  _Idx := _lst.ItemIndex;
  Result := _Idx <> -1;
  if Result then
    _lst.Items.Delete(_Idx);
end;

function TListBox_DeleteSelected(_lst: TCustomListbox; out _s: string): Boolean; overload;
var
  Idx: Integer;
begin
  Idx := _lst.ItemIndex;
  Result := Idx <> -1;
  if Result then begin
    _s := _lst.Items[Idx];
    _lst.Items.Delete(Idx);
  end;
end;

function TListBox_DeleteSelected(_lst: TCustomListbox): Boolean;
var
  Idx: Integer;
begin
  Result := TListBox_DeleteSelected(_lst, Idx);
end;

procedure TListBox_UnselectAll(_lb: TCustomListbox);
var
  i: Integer;
begin
  for i := 0 to _lb.Items.Count - 1 do
    _lb.Selected[i] := False;
end;

procedure TListbox_ClearWithObjects(_lst: TCustomListbox);
begin
  TStrings_FreeAllObjects(_lst.Items);
  _lst.Items.Clear;
end;

function TCheckListBox_GetCheckedCount(_clb: TCheckListBox): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to _clb.Items.Count - 1 do
    if _clb.Checked[i] then
      Inc(Result);
end;

procedure TCheckListBox_CheckAll(_clb: TCheckListBox; _IncludeDisabled: Boolean = False);
var
  i: Integer;
begin
  for i := 0 to _clb.Items.Count - 1 do
    _clb.Checked[i] := _IncludeDisabled or _clb.ItemEnabled[i];
end;

procedure TCheckListBox_UncheckAll(_clb: TCheckListBox);
var
  i: Integer;
begin
  for i := 0 to _clb.Items.Count - 1 do
    _clb.Checked[i] := False;
end;

procedure TCheckListBox_InvertCheckmarks(_clb: TCheckListBox; _IncludeDisabled: Boolean = False);
var
  i: Integer;
begin
  for i := 0 to _clb.Items.Count - 1 do
    _clb.Checked[i] := not _clb.Checked[i] and (_IncludeDisabled or _clb.ItemEnabled[i]);
end;

procedure TCheckListBox_CheckSelected(_clb: TCheckListBox; _IncludeDisabled: Boolean = False);
var
  i: Integer;
begin
  for i := 0 to _clb.Items.Count - 1 do
    if _clb.Selected[i] and (_IncludeDisabled or _clb.ItemEnabled[i]) then
      _clb.Checked[i] := True;
end;

procedure TCheckListBox_UncheckSelected(_clb: TCheckListBox; _IncludeDisabled: Boolean = False);
var
  i: Integer;
begin
  for i := 0 to _clb.Items.Count - 1 do
    if _clb.Selected[i] and (_IncludeDisabled or _clb.ItemEnabled[i]) then
      _clb.Checked[i] := False;
end;

procedure TCheckListBox_DeleteDisabled(_clb: TCheckListBox);
var
  i: Integer;
begin
  for i := _clb.Items.Count - 1 downto 0 do
    if not _clb.ItemEnabled[i] then
      _clb.Items.Delete(i);
end;

procedure TCheckListBox_SetCheckedNoClick(_clb: TCheckListBox; _Idx: Integer; _Checked: Boolean);
var
  Event: TNotifyEvent;
begin
  Event := _clb.OnClickCheck;
  _clb.OnClickCheck := nil;
  try
    _clb.Checked[_Idx] := _Checked;
  finally
    _clb.OnClickCheck := Event;
  end;
end;

function TCheckListBox_SetChecked(_clb: TCheckListBox; _Checked: TStrings;
  _UncheckOthers: Boolean = True; _SuppressClick: Boolean = False): Integer;
var
  i: Integer;
  Idx: Integer;
begin
  Result := 0;
  for i := 0 to _clb.Items.Count - 1 do begin
    Idx := _Checked.IndexOf(_clb.Items[i]);
    if Idx <> -1 then begin
      Inc(Result);
      if _SuppressClick then
        TCheckListBox_SetCheckedNoClick(_clb, i, True)
      else
        _clb.Checked[i] := True;
    end else if _UncheckOthers then begin
      if _SuppressClick then
        TCheckListBox_SetCheckedNoClick(_clb, i, False)
      else
        _clb.Checked[i] := False;
    end;
  end;
end;

function TCheckListBox_SetChecked(_clb: TCheckListBox; const _Checked: string;
  _UncheckOthers: Boolean = True; _SuppressClick: Boolean = False): Integer; overload;
begin
  Result := TCheckListBox_SetChecked(_clb, [_Checked], _UncheckOthers, _SuppressClick);
end;

function TCheckListBox_SetChecked(_clb: TCheckListBox; const _Checked: array of string;
  _UncheckOthers: Boolean = True; _SuppressClick: Boolean = False): Integer; overload;
var
  i: Integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := Low(_Checked) to High(_Checked) do
      sl.Add(_Checked[i]);
    Result := TCheckListBox_SetChecked(_clb, sl, _UncheckOthers, _SuppressClick);
  finally
    FreeAndNil(sl);
  end;
end;

function TCheckListBox_GetChecked(_clb: TCheckListBox; _Checked: TStrings = nil; _IncludeDisabled: Boolean = False): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to _clb.Items.Count - 1 do
    if _clb.Checked[i] and (_IncludeDisabled or _clb.ItemEnabled[i]) then begin
      Inc(Result);
      if Assigned(_Checked) then
        _Checked.AddObject(_clb.Items[i], _clb.Items.Objects[i]);
    end;
end;

function TCheckListBox_GetChecked(_clb: TCheckListBox; _IncludeDisabled: Boolean = False): string; overload;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    TCheckListBox_GetChecked(_clb, sl, _IncludeDisabled);
    Result := StringReplace(sl.Text, #13#10, ',', [rfReplaceAll]);
  finally
    FreeAndNil(sl);
  end;
end;

function TCheckListBox_GetCheckedObjects(_clb: TCheckListBox; _Objects: TList; _IncludeDisabled: Boolean = False): Integer;
var
  i: Integer;
begin
  Assert(Assigned(_clb));
  Assert(Assigned(_Objects));

  for i := 0 to _clb.Items.Count - 1 do
    if _clb.Checked[i] and (_IncludeDisabled or _clb.ItemEnabled[i]) then
      _Objects.Add(_clb.Items.Objects[i]);
  Result := _Objects.Count;
end;

function TComboBox_Select(_cmb: TCustomComboBox; const _Item: string; _DefaultIdx: Integer = -1;
  _AllowPartialMatch: Boolean = False): Integer;
var
  i: Integer;
  sl: TStringList;
begin
  if _AllowPartialMatch then begin
    sl := TStringList.Create;
    try
      sl.Assign(_cmb.Items);
      Result := _DefaultIdx;
      for i := 0 to sl.Count - 1 do
        if StartsText(_Item, sl[i]) then begin
          Result := i;
          Break;
        end;
    finally
      FreeAndNil(sl);
    end;
  end else begin
    Result := _cmb.Items.IndexOf(_Item);
    if Result = -1 then
      Result := _DefaultIdx;
  end;
  _cmb.ItemIndex := Result;
end;

type
  TComboHack = class(TCustomCombo)
  end;

procedure TComboBox_Change(_cmb: TCustomCombo);
begin
  TComboHack(_cmb).Change;
end;

procedure TComboBox_SelectWithoutChangeEvent(_cmb: TCustomComboBox; _Idx: Integer);
var
  Event: TNotifyEvent;
begin
  Event := TComboHack(_cmb).OnChange;
  try
    TComboHack(_cmb).OnChange := nil;
    _cmb.ItemIndex := _Idx;
  finally
    TComboHack(_cmb).OnChange := Event;
  end;
end;

procedure TComboBox_AssignItems(_cmb: TCustomComboBox; _Items: TStrings);
var
  s: string;
  SelStart: Integer;
  SelLen: Integer;
begin
  s := TComboHack(_cmb).Text;
  SelStart := TComboHack(_cmb).SelStart;
  SelLen := TComboHack(_cmb).SelLength;
  _cmb.Items.Assign(_Items);
  TComboHack(_cmb).Text := s;
  TComboHack(_cmb).SelStart := SelStart;
  TComboHack(_cmb).SelLength := SelLen;
end;

procedure TComboBox_AddIntObject(_cmb: TCustomComboBox; const _Item: string; _Value: Integer);
begin
  _cmb.Items.AddObject(_Item, Pointer(_Value));
end;

procedure TColorBox_SelectWithoutChangeEvent(_cmb: TColorBox; _Color: TColor);
var
  Event: TNotifyEvent;
begin
  Event := _cmb.OnChange;
  try
    _cmb.OnChange := nil;
    _cmb.Selected := _Color;
  finally
    _cmb.OnChange := Event;
  end;
end;

procedure TControl_SetReadonly(_Ctrl: TControl; _ReadOnly: Boolean);
var
  Panel: TPanel;
  comp: TComponent;
  PanelName: string;
begin
  if _Ctrl.Name = '' then
    raise Exception.Create('Combobox must have a name to be set readonly');
  PanelName := 'p_dzVclUtils' + _Ctrl.Name;
  comp := _Ctrl.Owner.FindComponent(PanelName);
  if Assigned(comp) then begin
    if not (comp is TPanel) then
      raise Exception.Create(PanelName + ' is not a TPanel');
    Panel := comp as TPanel;
    if _ReadOnly then
      Exit; // assume it is already readonly
    _Ctrl.Parent := Panel.Parent;
    _Ctrl.Top := Panel.Top;
    _Ctrl.Left := Panel.Left;
    FreeAndNil(Panel);
    Exit;
  end;
  if not _ReadOnly then
    Exit; // assume it is not readonly

  Panel := TPanel.Create(_Ctrl.Owner);
  Panel.Name := PanelName;
  Panel.Parent := _Ctrl.Parent;
  Panel.Top := _Ctrl.Top;
  Panel.Left := _Ctrl.Left;
  Panel.Height := _Ctrl.Height;
  Panel.Width := _Ctrl.Width;
  Panel.BevelOuter := bvNone;
  _Ctrl.Top := 0;
  _Ctrl.Left := 0;
  _Ctrl.Parent := Panel;
  Panel.Enabled := False;
end;

function TListBox_Select(_lb: TCustomListbox; const _Item: string; _DefaultIdx: Integer = -1): Integer;
begin
  Result := _lb.Items.IndexOf(_Item);
  if Result = -1 then
    Result := _DefaultIdx;
  _lb.ItemIndex := Result;
end;

type
  TRadioGroupHack = class(TCustomRadioGroup);

function TRadioGroup_GetItemCaption(_rg: TCustomRadioGroup;
  out _Caption: string; _Idx: Integer = -1): Boolean;
var
  Hack: TRadioGroupHack;
begin
  Hack := TRadioGroupHack(_rg);
  if _Idx = -1 then
    _Idx := Hack.ItemIndex;
  Result := (_Idx <> -1) and (_Idx < Hack.Items.Count);
  if Result then
    _Caption := StripHotKey(Hack.Items[_Idx]);
end;

function TRadioGroup_Select(_rg: TCustomRadioGroup; const _Item: string; _DefaultIdx: Integer = -1): Integer;
var
  Hack: TRadioGroupHack;
  i: Integer;
begin
  Hack := TRadioGroupHack(_rg);
  for i := 0 to Hack.Items.Count - 1 do
    if AnsiSameText(Hack.Items[i], _Item) then begin
      Hack.ItemIndex := i;
      Result := Hack.ItemIndex;
      Exit;
    end;
  Hack.ItemIndex := _DefaultIdx;
  Result := Hack.ItemIndex;
end;

function TRadioGroup_GetSelectedObject(_rg: TCustomRadioGroup; out _Idx: Integer; out _Obj: Pointer): Boolean;
var
  Hack: TRadioGroupHack;
begin
  Hack := TRadioGroupHack(_rg);
  _Idx := Hack.ItemIndex;
  Result := _Idx <> -1;
  if Result then
    _Obj := Hack.Items.Objects[_Idx];
end;

function TRichEdit_WriteToString(_Re: TRichEdit): string;
var
  st: TMemoryStream;
begin
  st := TMemoryStream.Create;
  try
    _Re.Lines.SaveToStream(st);
    Result := PChar(st.Memory);
  finally
    FreeAndNil(st);
  end;
end;

procedure TRichEdit_ReadFromString(_Re: TRichEdit; const _s: string);
var
  st: TMemoryStream;
begin
  st := TMemoryStream.Create;
  try
    st.Write(_s[1], Length(_s));
    st.Position := 0;
    _Re.Lines.LoadFromStream(st);
  finally
    FreeAndNil(st);
  end;
end;

function TPicture_WriteToString(_Pic: TPicture): string;
var
  st: TStringStream;
begin
  Result := '';
  st := TStringStream.Create('');
  try
    if Assigned(_Pic.Graphic) then begin
      Result := _Pic.Graphic.ClassName;
      _Pic.Graphic.SaveToStream(st);
      Result := Result + #26 + st.DataString;
    end
  finally
    FreeAndNil(st);
  end;
end;

procedure TPicture_ReadFromString(_Pic: TPicture; const _s: string);
var
  st: TStringStream;
  Klasse: string;
  Data: string;
  p: Integer;
  GraphicClass: TGraphicClass;
  GraphicObj: TGraphic;
begin
  if _s = '' then
    Exit;
  p := Pos(#26, _s);
  if p = 0 then
    Exit;
  Klasse := LeftStr(_s, p - 1);
  Data := TailStr(_s, p + 1);

  st := TStringStream.Create(Data);
  try
    GraphicClass := GetFileFormats.FindClassName(Klasse);
    if GraphicClass <> nil then begin
      GraphicObj := GraphicClass.Create;
      GraphicObj.LoadFromStream(st);
      _Pic.Graphic := GraphicObj;
    end;
  finally
    FreeAndNil(st);
  end;
end;

function AddLabeledControl(_Idx: Integer; const _Caption: string; _Ctrl: TControl): TLabel;
begin
  Result := TLabel.Create(_Ctrl.Owner);
  Result.Parent := _Ctrl.Parent;
  Result.Left := 8;
  Result.Caption := _Caption;
  _Ctrl.Top := _Idx * 24 + 16;
  Result.Top := _Ctrl.Top + (_Ctrl.Height - Result.Height) div 2;
end;

function CalcTextHeight(_Ctrl: TWinControl; const _Text: string; _Width: Integer = -1): Integer;
var
  Rect: TRect;
begin
  _Ctrl.HandleNeeded;
  Rect := _Ctrl.BoundsRect;
  if _Width <> -1 then
    Rect.Right := Rect.Left + _Width - 1;
  Result := DrawText(_Ctrl.Handle, PChar(_Text), Length(_Text), Rect,
    DT_LEFT or DT_WORDBREAK or DT_CALCRECT);
end;

type
  TGraphicControlHack = class(TGraphicControl)
  end;

function CalcTextHeight(_Ctrl: TGraphicControl; const _Text: string; _Width: Integer = -1): Integer; overload;
var
  Rect: TRect;
begin
  Rect := _Ctrl.BoundsRect;
  if _Width <> -1 then
    Rect.Right := Rect.Left + _Width - 1;
  Result := DrawText(TGraphicControlHack(_Ctrl).Canvas.Handle, PChar(_Text),
    Length(_Text), Rect, DT_LEFT or DT_WORDBREAK or DT_CALCRECT);
end;

type
  THackGrid = class(TCustomGrid);

function TStringGrid_IsScrollBarVisible(_Grid: TCustomGrid; _Code: Integer): Boolean;
var
  Min, Max: Integer;
  Grid: THackGrid;
begin
  Result := False;
  if not _Grid.HandleAllocated then
    Exit;
  Grid := THackGrid(_Grid);
  if (Grid.ScrollBars = ssBoth) or
    ((_Code = SB_HORZ) and (Grid.ScrollBars = ssHorizontal)) or
    ((_Code = SB_VERT) and (Grid.ScrollBars = ssVertical)) then begin
    GetScrollRange(_Grid.Handle, _Code, Min, Max);
    Result := Min <> Max;
  end;
end;

function GetApplicationPath: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
end;

function TRichEdit_RowToCharIndex(_Re: TRichEdit; _Row: Integer): Integer;
begin
  Result := _Re.Perform(EM_LINEINDEX, _Row, 0);
end;

function TRichEdit_CharIndexToRow(_Re: TRichEdit; _Idx: Integer): Integer;
begin
  Result := _Re.Perform(EM_LINEFROMCHAR, _Idx, 0);
end;

function TRichEdit_GetCurrentRow(_Re: TRichEdit): Integer;
begin
  Result := TRichEdit_CharIndexToRow(_Re, _Re.SelStart);
end;

procedure TRichEdit_ScrollToCaret(_Re: TRichEdit);
begin
  _Re.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TRichEdit_WriteLn(_Re: TRichEdit; const _s: string; _Color: TColor = clBlack; _Style: TFontStyles = []);
begin
  _Re.SelAttributes.Color := _Color;
  _Re.SelAttributes.Style := _Style;
  _Re.Lines.Add(_s);
  _Re.SelAttributes.Color := clBlack;
  _Re.SelAttributes.Style := [];
end;

procedure TControl_Center(_Child: TControl; _Parent: TControl);
begin
  _Child.Left := (_Parent.Width - _Child.Width) div 2;
  _Child.Top := (_Parent.Height - _Child.Height) div 2;
end;

procedure TControl_SetHint(_Ctrl: TControl; const _Hint: string);
begin
  _Ctrl.Hint := _Hint;
  _Ctrl.ShowHint := True;
end;

type
  THackCheckBox = class(TCustomCheckBox)
  end;

procedure TCheckBox_SetCheckedNoOnClick(_Chk: TCustomCheckBox; _Checked: Boolean);
var
  Chk: THackCheckBox;
begin
  Chk := THackCheckBox(_Chk);
  Chk.ClicksDisabled := True;
  try
    Chk.Checked := _Checked;
  finally
    Chk.ClicksDisabled := False;
  end;
end;

type
  TCustomControlHack = class(TCustomControl)
    // for accessing the Canvas property
  end;

function TCheckBox_Autosize(_Chk: TCustomCheckBox; _ParentCanvas: TCanvas = nil): Integer;
var
  Parent: TWinControl;
  s: string;
  w: Integer;
begin
  if _ParentCanvas = nil then begin
    Parent := _Chk.Parent;
    while (Parent <> nil) and (_ParentCanvas = nil) do begin
      if Parent is TCustomForm then
        _ParentCanvas := TCustomForm(Parent).Canvas
      else if Parent is TCustomControl then
        _ParentCanvas := TCustomControlHack(Parent).Canvas;
      Parent := Parent.Parent;
    end;
  end;

  if _ParentCanvas <> nil then begin
    s := THackCheckBox(_Chk).Caption;
    w := _ParentCanvas.TextWidth(s);
    Result := GetSystemMetrics(SM_CXMENUCHECK) + 16 + w;
    _Chk.Width := Result;
  end else
    Result := -1;
end;

procedure TForm_CenterOn(_frm: TForm; _Center: TPoint);
var
  Monitor: TMonitor;
begin
  _frm.Position := poDesigned;
  _frm.DefaultMonitor := dmDesktop;
  _frm.Left := _Center.X - _frm.Width div 2;
  _frm.Top := _Center.Y - _frm.Height div 2;
  Monitor := Screen.MonitorFromPoint(_Center);
  _frm.MakeFullyVisible(Monitor);
end;

procedure TForm_CenterOn(_frm: TForm; _Center: TWinControl);
begin
  if not Assigned(_Center) then
    _Center := Application.MainForm;
  if not Assigned(_Center) then begin
    if Screen.FormCount > 0 then
      _Center := Screen.Forms[0];
  end;
  if Assigned(_Center) then begin
    if Assigned(_Center.Parent) then
      TForm_CenterOn(_frm, _Center.ClientToScreen(Point(_Center.Width div 2, _Center.Height div 2)))
    else
      TForm_CenterOn(_frm, Point(_Center.Left + _Center.Width div 2, _Center.Top + _Center.Height div 2));
  end else begin
    TForm_CenterOn(_frm, Point(Screen.Width div 2, Screen.Height div 2));
  end;
end;

function TApplication_GetRegistryPath: string;
var
  VerInfo: IFileInfo;
  Company: string;
begin
  VerInfo := TApplicationInfo.Create;
  VerInfo.AllowExceptions := False;
  Company := VerInfo.CompanyName;
  if Company <> '' then
    Company := Company + '\';
  Result := 'Software\' + Company + ChangeFileExt(ExtractFileName(Application.ExeName), '');
end;

function TApplication_GetConfigRegistryPath: string;
begin
  Result := TApplication_GetRegistryPath + '\Config';
end;

function TForm_GetPlacementRegistryPath(const _FrmName: string): string;
begin
  Result := TApplication_GetRegistryPath + '\' + _FrmName + '\NormPos';
end;

function TForm_GetPlacementRegistryPath(_frm: TForm): string;
begin
  Result := TForm_GetPlacementRegistryPath(_frm.Name);
end;

function TForm_GetConfigRegistryPath(const _FrmName: string): string;
begin
  Result := TApplication_GetRegistryPath + '\' + _FrmName + '\Config';
end;

function TForm_GetConfigRegistryPath(_frm: TForm): string;
begin
  Result := TForm_GetConfigRegistryPath(_frm.Name);
end;

function TForm_StorePlacement(_frm: TForm; _Which: TFormPlacementEnum; const _RegistryPath: string;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean;
var
  L, t, w, h: Integer;
begin
  try
    L := _frm.Left;
    t := _frm.Top;
    w := _frm.Width;
    h := _frm.Height;
    case _Which of
      fpePositionOnly: begin
          w := -1;
          h := -1;
        end;
      fpeSizeOnly: begin
          L := -1;
          t := -1;
        end;
      // fpePosAndSize: ;
    end;
    TRegistry_WriteString(_RegistryPath, Format('%d,%d,%d,%d', [L, t, w, h]));
    Result := True;
  except
    Result := False;
  end;
end;

function TForm_StorePlacement(_frm: TForm; _Which: TFormPlacementEnum;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean;
begin
  Result := TForm_StorePlacement(_frm, _Which, TForm_GetPlacementRegistryPath(_frm), _HKEY);
end;

function TForm_ReadPlacement(_frm: TForm; _Which: TFormPlacementEnum; const _RegistryPath: string;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean;
var
  s: string;
  PosStr: string;
  L, t, w, h: Integer;
  fn: TFilename;
begin
  try
    fn := _RegistryPath;
    Result := TRegistry_TryReadString(fn.Directory, fn.Filename, PosStr, _HKEY);
    if Result then begin
      s := ExtractStr(PosStr, ',');
      if not TryStrToInt(s, L) then
        Exit;
      s := ExtractStr(PosStr, ',');
      if not TryStrToInt(s, t) then
        Exit;
      s := ExtractStr(PosStr, ',');
      if not TryStrToInt(s, w) then
        Exit;
      s := PosStr;
      if not TryStrToInt(s, h) then
        Exit;

      case _Which of
        fpePositionOnly: begin
            if L <> -1 then
              _frm.Left := L;
            if t <> -1 then
              _frm.Top := t;
          end;
        fpeSizeOnly: begin
            if w <> -1 then
              _frm.Width := w;
            if h <> -1 then
              _frm.Height := h;
          end;
        fpePosAndSize: begin
            if L <> -1 then
              _frm.Left := L;
            if t <> -1 then
              _frm.Top := t;
            if w <> -1 then
              _frm.Width := w;
            if h <> -1 then
              _frm.Height := h;
          end;
      else
        Exit;
      end;
      _frm.Position := poDesigned;
      _frm.MakeFullyVisible(nil);
    end;
  except
    Result := False;
  end;
end;

function TForm_ReadPlacement(_frm: TForm; _Which: TFormPlacementEnum;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean; overload;
begin
  Result := TForm_ReadPlacement(_frm, _Which, TForm_GetPlacementRegistryPath(_frm), _HKEY);
end;

procedure TForm_SetMinConstraints(_frm: TForm);
begin
  TControl_SetMinConstraints(_frm);
end;

procedure TForm_AppendVersion(_frm: TForm; _Caption: string = '');
var
  VersionInfo: IFileInfo;
begin
  VersionInfo := TApplicationInfo.Create;
  if _Caption = '' then
    _Caption := _frm.Caption;

  _frm.Caption := _Caption
    + ' - [' + VersionInfo.FileVersion + ' ' + VersionInfo.ProductVersion + ']';
end;

procedure TForm_InsertVersion(_frm: TForm; _Mask: string = '');
var
  VersionInfo: IFileInfo;
begin
  if _Mask = '' then
    _Mask := _frm.Caption + ' - [%s %s]';
  VersionInfo := TApplicationInfo.Create;
  _frm.Caption := Format(_Mask, [VersionInfo.FileVersion, VersionInfo.ProductVersion]);
end;

function TApplication_GetFileVersion: string;
var
  VersionInfo: IFileInfo;
begin
  Result := '';
  VersionInfo := TApplicationInfo.Create;
  if VersionInfo.HasVersionInfo then
    Result := VersionInfo.FileVersion;
end;

procedure TControl_SetMinConstraints(_Control: TControl);
begin
  _Control.Constraints.MinHeight := _Control.Height;
  _Control.Constraints.MinWidth := _Control.Width;
end;

function TWinControl_SetFocus(_Ctrl: TWinControl): Boolean;
var
  ParentForm: TCustomForm;
begin
  Result := False;
  ParentForm := GetParentForm(_Ctrl);
  if Assigned(ParentForm) then begin
    ParentForm.ActiveControl := _Ctrl;
    if ParentForm.Visible and ParentForm.Enabled and _Ctrl.CanFocus then
      try
        _Ctrl.SetFocus;
        Result := True;
      except
        Result := False;
      end;
  end;
end;

procedure DisableProcessWindowsGhosting;
var
  DisableProcessWindowsGhostingProc: procedure;
begin
  DisableProcessWindowsGhostingProc := GetProcAddress(
    GetModuleHandle('user32.dll'),
    'DisableProcessWindowsGhosting');
  if Assigned(DisableProcessWindowsGhostingProc) then
    DisableProcessWindowsGhostingProc;
end;

type
  PFileFormat = ^TFileFormat;
  TFileFormat = record
    GraphicClass: TGraphicClass;
    Extension: string;
    Description: string;
    DescResID: Integer;
  end;

constructor TFileFormatsList.Create;
begin
  inherited Create;
  Add('wmf', SVMetafiles, 0, TMetafile);
  Add('emf', SVEnhMetafiles, 0, TMetafile);
  Add('ico', SVIcons, 0, TIcon);
  Add('bmp', SVBitmaps, 0, TBitmap);
{$IFDEF GIFByRx}
  Add('gif', LoadStr(SGIFImage), 0, TGIFImage);
{$ENDIF GIFByRx}
  Add('jpg', _('JPEG Files'), 0, TJPEGImage);
end;

destructor TFileFormatsList.Destroy;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Dispose(PFileFormat(Items[i]));
  inherited Destroy;
end;

procedure TFileFormatsList.Add(const Ext, Desc: string; DescID: Integer;
  AClass: TGraphicClass);
var
  NewRec: PFileFormat;
begin
  New(NewRec);
  with NewRec^ do begin
    Extension := AnsiLowerCase(Ext);
    GraphicClass := AClass;
    Description := Desc;
    DescResID := DescID;
  end;
  inherited Add(NewRec);
end;

function TFileFormatsList.FindExt(Ext: string): TGraphicClass;
var
  i: Integer;
begin
  Ext := AnsiLowerCase(Ext);
  for i := Count - 1 downto 0 do
    with PFileFormat(Items[i])^ do
      if Extension = Ext then begin
        Result := GraphicClass;
        Exit;
      end;
  Result := nil;
end;

function TFileFormatsList.GetFilterString(GraphicClass: TGraphicClass = nil): string;
var
  s: string;
begin
  if GraphicClass = nil then
    GraphicClass := TGraphic;
  BuildFilterStrings(GraphicClass, Result, s);
end;

function TFileFormatsList.FindClassName(const ClassName: string): TGraphicClass;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do begin
    Result := PFileFormat(Items[i])^.GraphicClass;
    if Result.ClassName = ClassName then
      Exit;
  end;
  Result := nil;
end;

procedure TFileFormatsList.Remove(AClass: TGraphicClass);
var
  i: Integer;
  p: PFileFormat;
begin
  for i := Count - 1 downto 0 do begin
    p := PFileFormat(Items[i]);
    if p^.GraphicClass.InheritsFrom(AClass) then begin
      Dispose(p);
      Delete(i);
    end;
  end;
end;

procedure TFileFormatsList.BuildFilterStrings(GraphicClass: TGraphicClass;
  var Descriptions, Filters: string);
var
  c, i: Integer;
  p: PFileFormat;
begin
  Descriptions := '';
  Filters := '';
  c := 0;
  for i := Count - 1 downto 0 do begin
    p := PFileFormat(Items[i]);
    if p^.GraphicClass.InheritsFrom(GraphicClass) and (p^.Extension <> '') then
      with p^ do begin
        if c <> 0 then begin
          Descriptions := Descriptions + '|';
          Filters := Filters + ';';
        end;
        if (Description = '') and (DescResID <> 0) then
          Description := LoadStr(DescResID);
        FmtStr(Descriptions, '%s%s (*.%s)|*.%2:s', [Descriptions, Description, Extension]); // do not translate
        FmtStr(Filters, '%s*.%s', [Filters, Extension]); // do not translate
        Inc(c);
      end;
  end;
  if c > 1 then
    FmtStr(Descriptions, '%s (%s)|%1:s|%s', [sAllFilter, Filters, Descriptions]); // do not translate
end;

var
  FileFormats: TFileFormatsList = nil;

function GetFileFormats: TFileFormatsList;
begin
  if FileFormats = nil then
    FileFormats := TFileFormatsList.Create;
  Result := FileFormats;
end;

function TMemo_GetFirstVisibleLine(_Memo: TMemo): Integer;
begin
  Result := SendMessage(_Memo.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
end;

procedure TMemo_DeleteTopLines(_Memo: TMemo; _Retain: Integer);
const
  EmptyStr: PChar = '';
var
  Offset: Integer;
  cnt: Integer;
begin
  cnt := _Memo.Lines.Count;
  if cnt <= _Retain then
    Exit;
  Dec(cnt, _Retain);

  Offset := SendMessage(_Memo.Handle, EM_LINEINDEX, cnt - 1, 0);
  if (Offset < 0) or (cnt = 0) then
    Offset := SendMessage(_Memo.Handle, EM_LINELENGTH, 0, 0);
  SendMessage(_Memo.Handle, EM_SETSEL, 0, Offset);
  SendMessage(_Memo.Handle, EM_REPLACESEL, 0, LongInt(EmptyStr));
end;

function TMemo_GetCursorPos(_Memo: TMemo): Integer;
begin
  SendMessage(_Memo.Handle, EM_GETSEL, Integer(@Result), 0);
end;

procedure TMemo_SetCursorPos(_Memo: TMemo; _CharIdx: Integer);
begin
  SendMessage(_Memo.Handle, EM_SETSEL, _CharIdx, _CharIdx);
  TMemo_ScrollToCursorPos(_Memo);
end;

function TMemo_GetCursorLine(_Memo: TMemo): Integer;
var
  CurPos: Integer;
begin
  CurPos := TMemo_GetCursorPos(_Memo);
  Result := SendMessage(_Memo.Handle, EM_LINEFROMCHAR, CurPos, 0);
end;

procedure TMemo_SetCursorToLine(_Memo: TMemo; _Line: Integer);
var
  CurPos: Integer;
begin
  CurPos := SendMessage(_Memo.Handle, EM_LINEINDEX, _Line, 0);
  TMemo_SetCursorPos(_Memo, CurPos);
end;

procedure TMemo_ScrollToCursorPos(_Memo: TMemo);
begin
  SendMessage(_Memo.Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TMemo_ScrollToEnd(_Memo: TMemo);
var
  cnt: Integer;
begin
  cnt := SendMessage(_Memo.Handle, EM_GETLINECOUNT, 0, 0);
  SendMessage(_Memo.Handle, EM_LINESCROLL, 0, cnt);
end;

function TApplication_GetFilenameOnly: string;
begin
  Result := ChangeFileExt(ExtractFileName(Application.ExeName), '');
end;

function TApplication_GetExePath: string;
begin
  Result := ExcludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
end;

function TApplication_GetExePathBS: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
end;

function TApplication_HasVersionInfo: Boolean;
var
  Handle: DWORD;
  Size: DWORD;
begin
  Size := GetFileVersionInfoSize(PChar(Application.ExeName), Handle);
  Result := Size <> 0;
end;

function TApplication_GetDefaultIniFileName: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

procedure MergeForm(AControl: TWinControl; AForm: TForm; Align: TAlign; Show: Boolean);
var
  r: TRect;
  AutoScroll: Boolean;
begin
  AutoScroll := AForm.AutoScroll;
  AForm.Hide;
  TControlHack(AForm).DestroyHandle;
  with AForm do begin
    BorderStyle := bsNone;
    BorderIcons := [];
    Parent := AControl;
  end;
  AControl.DisableAlign;
  try
    if Align <> alNone then
      AForm.Align := Align
    else begin
      r := AControl.ClientRect;
      AForm.SetBounds(r.Left + AForm.Left, r.Top + AForm.Top, AForm.Width,
        AForm.Height);
    end;
    AForm.AutoScroll := AutoScroll;
    AForm.Visible := Show;
  finally
    AControl.EnableAlign;
  end;
end;

procedure UnMergeForm(_Form: TCustomForm);
begin
  _Form.Hide;
  TControlHack(_Form).DestroyHandle;
  _Form.Parent := nil;
end;

procedure TListView_ClearWithObjects(_lv: TListView);
var
  i: Integer;
begin
  for i := 0 to _lv.Items.Count - 1 do begin
    TObject(_lv.Items[i].Data).Free;
    _lv.Items[i].Data := nil;
  end;
  _lv.Clear;
end;

type
  TListViewEndUpdateClass = class(TInterfacedObject, IInterface)
  private
    FListView: TListView;
  public
    constructor Create(_ListView: TListView);
    destructor Destroy; override;
  end;

function TListView_BeginUpdate(_lv: TListView): IInterface;
begin
  _lv.Items.BeginUpdate;
  Result := TListViewEndUpdateClass.Create(_lv);
end;

function TListView_TryGetSelected(_lv: TListView; out _Idx: Integer): Boolean;
begin
  _Idx := _lv.ItemIndex;
  Result := (_Idx <> -1);
end;

function TListView_TryGetSelected(_lv: TListView; out _li: TListItem): Boolean;
var
  Idx: Integer;
begin
  Result := TListView_TryGetSelected(_lv, Idx);
  if Result then
    _li := _lv.Items[Idx];
end;

function TRadioGroup_GetButton(_rg: TRadioGroup; _ItemIdx: Integer): TRadioButton;
// taken from http://delphi.about.com/od/adptips2006/qt/radiogroupbtns.htm
begin
  if (_ItemIdx < 0) or (_ItemIdx >= _rg.Items.Count) then
    Result := nil
  else
    Result := _rg.Controls[_ItemIdx] as TRadioButton;
end;

function TRadioGroup_GetButton(_rg: TRadioGroup; const _ItemText: string): TRadioButton;
// taken from http://delphi.about.com/od/adptips2006/qt/radiogroupbtns.htm
var
  cnt: Integer;
  Idx: Integer;
begin
  Idx := -1;
  for cnt := 0 to -1 + _rg.Items.Count do begin
    if _rg.Items[cnt] = _ItemText then begin
      Idx := cnt;
      Break;
    end;
  end;
  Result := TRadioGroup_GetButton(_rg, Idx);
end;

type
  THackButtonControl = class(TButtonControl)
  end;

function TButtonControl_GetChecked(_bctrl: TButtonControl): Boolean;
begin
  Result := THackButtonControl(_bctrl).Checked;
end;

procedure TButtonControl_SetChecked(_bctrl: TButtonControl; _Value: Boolean);
begin
  THackButtonControl(_bctrl).Checked := _Value;
end;

procedure TButtonControl_SetCaption(_bctrl: TButtonControl; const _Value: string);
begin
  THackButtonControl(_bctrl).Caption := _Value;
end;

type
  TButtonPopupMenuLink = class(TComponent)
  private
    FBtn: TCustomButton;
    FMenu: TPopupMenu;
    FLastClose: DWORD;
  public
    constructor Create(_btn: TCustomButton; _pm: TPopupMenu); reintroduce;
    procedure doOnButtonClick(_Sender: TObject);
  end;

{ TButtonPopupMenuLink }

type
  TCustomButtonHack = class(TCustomButton)
  end;

constructor TButtonPopupMenuLink.Create(_btn: TCustomButton; _pm: TPopupMenu);
begin
  inherited Create(_btn);
  FBtn := _btn;
  FMenu := _pm;
  FMenu.PopupComponent := FBtn;
  TCustomButtonHack(FBtn).OnClick := Self.doOnButtonClick;
end;

procedure TButtonPopupMenuLink.doOnButtonClick(_Sender: TObject);
var
  Pt: TPoint;
begin
  if GetTickCount - FLastClose > 100 then begin
    Pt := FBtn.ClientToScreen(Point(0, FBtn.ClientHeight));
    FMenu.Popup(Pt.X, Pt.Y);
    { Note: PopupMenu.Popup does not return until the menu is closed }
    FLastClose := GetTickCount;
  end;
end;

procedure TButton_AddDropdownMenu(_btn: TCustomButton; _pm: TPopupMenu);
begin
  TButtonPopupMenuLink.Create(_btn, _pm);
end;

function TPopupMenu_AppendMenuItem(_pm: TPopupMenu; const _Caption: string; _OnClick: TNotifyEvent): TMenuItem;
begin
  Result := TMenuItem.Create(_pm);
  Result.Caption := _Caption;
  Result.OnClick := _OnClick;
  _pm.Items.Add(Result);
end;

function TPopupMenu_AppendMenuItem(_pm: TPopupMenu; _Action: TBasicAction): TMenuItem;
begin
  Result := TMenuItem.Create(_pm);
  Result.Action := _Action;
  _pm.Items.Add(Result);
end;

function TMenuItem_AppendSubmenuItem(_mi: TMenuItem; const _Caption: string; _OnClick: TNotifyEvent): TMenuItem;
begin
  Result := TMenuItem.Create(_mi);
  Result.Caption := _Caption;
  Result.OnClick := _OnClick;
  _mi.Add(Result);
end;

function TMenuItem_AppendSubmenuItem(_mi: TMenuItem; _Action: TBasicAction): TMenuItem;
begin
  Result := TMenuItem.Create(_mi);
  Result.Action := _Action;
  _mi.Add(Result);
end;

procedure TPopupMenu_AppendAllMenuItems(_Dest: TPopupMenu; _Src: TPopupMenu; _InsertDivider: Boolean = True);
var
  i: Integer;
  mi: TMenuItem;
  NewMi: TMenuItem;
begin
  if _InsertDivider and (_Dest.Items.Count > 0) and (_Src.Items.Count > 0) then
    _Dest.Items.NewBottomLine;
  for i := 0 to _Src.Items.Count - 1 do begin
    mi := _Src.Items[i];
    if Assigned(mi.Action) then
      TPopupMenu_AppendMenuItem(_Dest, mi.Action)
    else begin
      NewMi := TPopupMenu_AppendMenuItem(_Dest, mi.Caption, mi.OnClick);
      NewMi.AutoCheck := mi.AutoCheck;
      NewMi.Bitmap := mi.Bitmap;
      NewMi.Checked := mi.Checked;
      NewMi.RadioItem := mi.RadioItem;
      NewMi.GroupIndex := mi.GroupIndex;
    end;
  end;
end;

procedure TPopupMenu_AppendAllActions(_Dest: TPopupMenu; _Src: TActionList; _InsertDivider: Boolean = True);
var
  i: Integer;
  act: TContainedAction;
  cnt: Integer;
begin
  cnt := _Src.ActionCount;
  if _InsertDivider and (_Dest.Items.Count > 0) and (cnt > 0) then
    _Dest.Items.NewBottomLine;
  for i := 0 to cnt - 1 do begin
    act := _Src.Actions[i];
    TPopupMenu_AppendMenuItem(_Dest, act)
  end;
end;

procedure TListView_UnselectAll(_lv: TListView; _WithSelectEvents: Boolean = True);
var
  i: Integer;
  Event: TLVSelectItemEvent;
begin
  Event := _lv.OnSelectItem;
  if not _WithSelectEvents then
    _lv.OnSelectItem := nil;
  try
    for i := 0 to _lv.Items.Count - 1 do
      _lv.Items[i].Selected := False;
  finally
    _lv.OnSelectItem := Event;
  end;
end;

function TListView_GetSelectedCount(_lv: TListView): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to _lv.Items.Count - 1 do
    if _lv.Items[i].Selected then
      Inc(Result);
end;

function TListView_GetSelected(_lv: TListView; out _Idx: Integer): Boolean;
var
  Idx: Integer;
begin
  Idx := _lv.ItemIndex;
  Result := (Idx <> -1);
  if Result then
    _Idx := Idx;
end;

function TListView_GetSelected(_lv: TListView; out _Item: TListItem): Boolean;
var
  Item: TListItem;
begin
  Item := _lv.Selected;
  Result := Assigned(Item);
  if Result then
    _Item := Item;
end;

function TListView_Select(_lv: TListView; const _Caption: string; _DefaultIdx: Integer = -1): Integer;
var
  i: Integer;
  li: TListItem;
begin
  for i := 0 to _lv.Items.Count - 1 do begin
    li := _lv.Items[i];
    if SameText(li.Caption, _Caption) then begin
      _lv.Selected := li;
      Result := li.Index;
      Exit; //==>
    end;
  end;
  _lv.ItemIndex := _DefaultIdx;
  Result := _DefaultIdx;
end;

// This code is based on an idea from
// http://delphi-wmi-class-generator.googlecode.com/svn/trunk/units/ListView_Helper.pas

procedure TListView_ResizeColumn(_lc: TListColumn; _Options: TLIstViewResizeOptionSet);
var
  Width: Integer;
begin
  if _Options = [lvrCaptions, lvrContent] then begin
    _lc.Width := LVSCW_AUTOSIZE;
    Width := _lc.Width;
    _lc.Width := LVSCW_AUTOSIZE_USEHEADER;
    if Width > _lc.Width then
      _lc.Width := LVSCW_AUTOSIZE;
  end else if _Options = [lvrContent] then
    _lc.Width := LVSCW_AUTOSIZE
  else if _Options = [lvrCaptions] then
    _lc.Width := LVSCW_AUTOSIZE_USEHEADER;
end;

procedure TListView_Resize(_lv: TListView; _Options: TLIstViewResizeOptionSet = [lvrCaptions, lvrContent]);
var
  i: Integer;
begin
  for i := 0 to _lv.Columns.Count - 1 do
    TListView_ResizeColumn(_lv.Columns[i], _Options);
end;

function TAction_SetCheckedExecute(_act: TCustomAction; _Checked: Boolean): Boolean;
begin
  Result := _act.Checked <> _Checked;
  if Result then
    Result := _act.Execute;
end;

procedure TActionList_SetAllVisible(_al: TActionList; _Visible: Boolean);
var
  i: Integer;
  act: TBasicAction;
begin
  for i := 0 to _al.ActionCount - 1 do begin
    act := _al[i];
    if act is TCustomAction then
      TCustomAction(act).Visible := _Visible;
  end;
end;

type
  THackGroupBox = class(TCustomGroupBox)
  end;

function TGroupBox_SetFileCaption(_grp: TCustomGroupBox; const _Prefix: string; const _Filename: string): string;
var
  Len: Integer;
  grp: THackGroupBox;
begin
  grp := THackGroupBox(_grp);
  Len := grp.Canvas.TextWidth(_Prefix);
  Result := _Prefix + MinimizeName(_Filename, grp.Canvas, grp.Width - Len);
  grp.Caption := Result;
end;

function TStatusBar_GetClickedPanel(_sb: TStatusBar): Integer;
// call this to determine which panel of a TStatusBar has been clicked
// Note: This assumes, that the status bar actually was clicked, so only call it
//       from the status bar's OnClick, OnMouseDown or OnMouseUp event handlers
// If the status bar does not have any panels (e.g. SimplePanel=true), this function
// will return 0.
var
  mpt: TPoint;
  X: Integer;
  j: Integer;
  cnt: Integer;
begin
  cnt := _sb.Panels.Count;
  if _sb.SimplePanel then
    cnt := 0;

  mpt := _sb.ScreenToClient(Mouse.CursorPos);

  Result := -1;
  X := 0;
  for j := 0 to cnt - 1 do begin
    X := X + _sb.Panels[j].Width;
    if mpt.X < X then begin
      Result := j;
      Break;
    end;
  end;

  //clicked "after" the last panel -
  //fake it as if the last one was clicked
  if Result = -1 then
    Result := _sb.Panels.Count - 1;
end;

{ TLongSimpleTextStatusBar }

function TLongSimpleTextStatusBar.GetSimpleText: string;
begin
  Result := inherited SimpleText;
end;

procedure TLongSimpleTextStatusBar.SetSimpleText(const Value: string);
begin
  TStatusBar_SetLongSimpleText(Self, Value);
end;

type
  TCursorRestorer = class(TInterfacedObject, IInterface)
  private
    FOldCursor: TCursor;
    constructor Create(_NewCursor: TCursor);
    destructor Destroy; override;
  end;

{ TCursorRestorer }

constructor TCursorRestorer.Create(_NewCursor: TCursor);
begin
  inherited Create;
  FOldCursor := Screen.Cursor;
  Screen.Cursor := _NewCursor;
end;

destructor TCursorRestorer.Destroy;
begin
  Screen.Cursor := FOldCursor;
  inherited;
end;

function TCursor_TemporaryChange(_NewCursor: TCursor = crHourGlass): IInterface;
begin
  Result := TCursorRestorer.Create(_NewCursor);
end;

type
  TWinControlLocker = class(TInterfacedObject, IInterface)
  private
    FCtrl: TWinControl;
  public
    constructor Create(_Ctrl: TWinControl);
    destructor Destroy; override;
  end;

function TWinControl_Lock(_Ctrl: TWinControl): IInterface;
begin
  Result := TWinControlLocker.Create(_Ctrl);
end;

{ TWinControlLocker }

constructor TWinControlLocker.Create(_Ctrl: TWinControl);
begin
  inherited Create;
  FCtrl := _Ctrl;
  SendMessage(FCtrl.Handle, WM_SETREDRAW, Integer(LongBool(False)), 0);
end;

destructor TWinControlLocker.Destroy;
begin
  SendMessage(FCtrl.Handle, WM_SETREDRAW, Integer(LongBool(True)), 0);
  RedrawWindow(FCtrl.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_ALLCHILDREN);
  inherited;
end;

type
  TCheckListBoxHelper = class
  private
    procedure HandleClickCheck(_Sender: TObject);
  end;

var
  gblCheckListBoxHelper: TCheckListBoxHelper = nil;

procedure TCheckListBox_Readonly(_clb: TCheckListBox; _ReadOnly: Boolean; _ChangeColor: Boolean = True);
begin
  if _ReadOnly then begin
    if not Assigned(gblCheckListBoxHelper) then
      gblCheckListBoxHelper := TCheckListBoxHelper.Create;
    _clb.OnClickCheck := gblCheckListBoxHelper.HandleClickCheck;
    if _ChangeColor then
      _clb.Color := clBtnFace;
  end else begin
    _clb.OnClickCheck := nil;
    if _ChangeColor then
      _clb.Color := clWindow;
  end;
end;

procedure TCheckListBoxHelper.HandleClickCheck(_Sender: TObject);
var
  clb: TCheckListBox;
  Idx: Integer;
begin
  clb := _Sender as TCheckListBox;
  Idx := clb.ItemIndex;
  if Idx <> -1 then begin
    clb.Checked[Idx] := not clb.Checked[Idx];
  end;
end;

{$IFDEF DELPHI2009_UP}
{ TdzButtonedEdit }

procedure TdzButtonedEdit.KeyDown(var _Key: Word; _Shift: TShiftState);
begin
  inherited;
  if (_Key = VK_RETURN) and (ssCtrl in _Shift) then
    OnRightButtonClick(Self);
end;

{$IFDEF DELPHI2010_UP}

procedure TdzButtonedEdit.Loaded;
begin
  inherited;
  if RightButton.Visible and (RightButton.Hint = '') then begin
    RightButton.Hint := _('Ctrl+Return to ''click'' right button.');
    ShowHint := True;
  end;
end;
{$ENDIF DELPHI2010_UP}

{$ENDIF DELPHI2009_UP}

{ TListViewEndUpdateClass }

constructor TListViewEndUpdateClass.Create(_ListView: TListView);
begin
  inherited Create;
  FListView := _ListView;
end;

destructor TListViewEndUpdateClass.Destroy;
begin
  if Assigned(FListView) then
    FListView.Items.EndUpdate;
  inherited;
end;

type
  TWindowProcHook = class(TComponent)
  protected
    FCtrl: TWinControl;
    FOldWindowProc: TWndMethod;
{$IFDEF dzMESSAGEDEBUG}
    FMsgToStr: TWmMessageToString;
{$ENDIF dzMESSAGEDEBUG}
  protected
    procedure WmNcCreate; virtual;
    procedure WmNcDestroy; virtual;
    procedure NewWindowProc(var _Msg: TMessage); virtual;
  public
    constructor Create(_WinControl: TWinControl); reintroduce;
    destructor Destroy; override;
  end;

{ TWindowProcHook }

constructor TWindowProcHook.Create(_WinControl: TWinControl);
begin
  inherited Create(_WinControl);
  FCtrl := _WinControl;

{$IFDEF dzMESSAGEDEBUG}
  FMsgToStr := TWmMessageToString.Create;
{$ENDIF dzMESSAGEDEBUG}
  FOldWindowProc := FCtrl.WindowProc;
  FCtrl.WindowProc := NewWindowProc;
end;

destructor TWindowProcHook.Destroy;
begin
  if Assigned(FCtrl) and Assigned(FOldWindowProc) then begin
    FCtrl.WindowProc := FOldWindowProc;
  end;
{$IFDEF dzMESSAGEDEBUG}
  FreeAndNil(FMsgToStr);
{$ENDIF dzMESSAGEDEBUG}
  inherited;
end;

procedure TWindowProcHook.WmNcCreate;
begin
  // do nothing
end;

procedure TWindowProcHook.WmNcDestroy;
begin
  // do nothing
end;

procedure TWindowProcHook.NewWindowProc(var _Msg: TMessage);
begin
  if _Msg.Msg = WM_NCCREATE then
    WmNcCreate
  else if _Msg.Msg = WM_NCDESTROY then
    WmNcDestroy;
{$IFDEF dzMESSAGEDEBUG}
  WriteLn(FMsgToStr.MsgToString(_Msg));
{$ENDIF dzMESSAGEDEBUG}
  // call original WindowProc method to handle all other messages
  FOldWindowProc(_Msg);
end;

type
  TDropFilesActivator = class(TWindowProcHook)
  private
    FCallback: TOnFilesDropped;
    procedure WmDropFiles(var _Msg: TMessage);
    procedure doCallback(_st: TStrings);
  protected
    procedure WmNcCreate; override;
    procedure WmNcDestroy; override;
    procedure NewWindowProc(var _Msg: TMessage); override;
  public
    constructor Create(_WinControl: TWinControl; _Callback: TOnFilesDropped);
    destructor Destroy; override;
  end;

{ TDropFilesActivator }

constructor TDropFilesActivator.Create(_WinControl: TWinControl; _Callback: TOnFilesDropped);
begin
  inherited Create(_WinControl);
  FCallback := _Callback;
  DragAcceptFiles(FCtrl.Handle, True);
end;

destructor TDropFilesActivator.Destroy;
begin
  if Assigned(FCtrl) and (FCtrl.HandleAllocated) then
    DragAcceptFiles(FCtrl.Handle, False);
  inherited;
end;

procedure TDropFilesActivator.doCallback(_st: TStrings);
begin
  if Assigned(FCallback) then
    FCallback(FCtrl, _st);
end;

procedure TDropFilesActivator.WmNcCreate;
begin
  inherited;
  DragAcceptFiles(FCtrl.Handle, True);
end;

procedure TDropFilesActivator.WmNcDestroy;
begin
  inherited;
  DragAcceptFiles(FCtrl.Handle, False);
end;

procedure TDropFilesActivator.NewWindowProc(var _Msg: TMessage);
begin
  if _Msg.Msg = WM_DROPFILES then
    WmDropFiles(_Msg);

  inherited NewWindowProc(_Msg);
end;

procedure TDropFilesActivator.WmDropFiles(var _Msg: TMessage);
var
  arr: array[0..255] of Char;
  fn: string;
  i: Integer;
  sl: TStringList;
  cnt: Cardinal;
begin
  sl := TStringList.Create;
  try
    cnt := DragQueryFile(_Msg.wParam, $FFFFFFFF, nil, 255);
    for i := 0 to cnt - 1 do begin
      DragQueryFile(_Msg.wParam, i, @arr, SizeOf(arr));
      fn := PChar(@arr);
      sl.Add(fn);
    end;
    DragFinish(_Msg.wParam);
    doCallback(sl);
  finally
    FreeAndNil(sl);
  end;
end;

function TForm_ActivateDropFiles(_WinCtrl: TWinControl; _Callback: TOnFilesDropped): TObject;
begin
  Result := TWinControl_ActivateDropFiles(_WinCtrl, _Callback);
end;

function TWinControl_ActivateDropFiles(_WinCtrl: TWinControl; _Callback: TOnFilesDropped): TObject;
begin
  Result := TDropFilesActivator.Create(_WinCtrl, _Callback);
end;

const
  // constants and descriptions from MSDN
  // http://msdn.microsoft.com/en-us/library/windows/desktop/bb759862(v=vs.85).aspx

  // Ignore the registry default and force the AutoAppend feature off.
  // This flag must be used in combination with one or more of the
  // SHACF_FILESYS* or SHACF_URL* flags.
  SHACF_AUTOAPPEND_FORCE_OFF = $80000000;

  // Ignore the registry value and force the AutoAppend feature on. The completed string will be
  // displayed in the edit box with the added characters highlighted.
  // This flag must be used in combination with one or more of the
  // SHACF_FILESYS* or SHACF_URL* flags.
  SHACF_AUTOAPPEND_FORCE_ON = $40000000;

  // Ignore the registry default and force the AutoSuggest feature off.
  // This flag must be used in combination with one or more of the
  // SHACF_FILESYS* or SHACF_URL* flags.
  SHACF_AUTOSUGGEST_FORCE_OFF = $20000000;

  // Ignore the registry value and force the AutoSuggest feature on.
  // A selection of possible completed strings will be displayed as a
  // drop-down list, below the edit box. This flag must be used in
  // combination with one or more of the
  // SHACF_FILESYS* or SHACF_URL* flags.
  SHACF_AUTOSUGGEST_FORCE_ON = $10000000;

  // The default setting, equivalent to
  // SHACF_FILESYSTEM | SHACF_URLALL.
  // SHACF_DEFAULT cannot be combined with any other flags.
  SHACF_DEFAULT = $00000000;

  // Include the file system only.
  SHACF_FILESYS_ONLY = $00000010;

  // Include the file system and directories, UNC servers, and UNC server shares.
  SHACF_FILESYS_DIRS = $00000020;

  // Include the file system and the rest of the Shell (Desktop, Computer, and Control Panel, for example).
  SHACF_FILESYSTEM = $00000001;

  // Include the URLs in the user's History list.
  SHACF_URLHISTORY = $00000002;

  // Include the URLs in the user's Recently Used list.
  SHACF_URLMRU = $00000004;

  // Include the URLs in the users History and Recently Used lists. Equivalent to
  // SHACF_URLHISTORY | SHACF_URLMRU.
  SHACF_URLALL = SHACF_URLHISTORY or SHACF_URLMRU;

  // Allow the user to select from the autosuggest list by pressing the TAB key.
  // If this flag is not set, pressing the TAB key will shift focus to the next
  // control and close the autosuggest list.
  // If SHACF_USETAB is set, pressing the TAB key will select the first item
  // in the list. Pressing TAB again will select the next item in the list,
  // and so on. When the user reaches the end of the list, the next TAB key
  // press will cycle the focus back to the edit control.
  // This flag must be used in combination with one or more of the
  // SHACF_FILESYS* or SHACF_URL*
  // flags
  SHACF_USETAB = $00000008;

  SHACF_VIRTUAL_NAMESPACE = $00000040;

function SHAutoComplete(hwndEdit: HWnd; dwFlags: DWORD): HResult; stdcall; external 'Shlwapi.dll';

function TEdit_SetAutocomplete(_ed: TCustomEdit; _Source: TAutoCompleteSourceEnumSet = [acsFileSystem];
  _Type: TAutoCompleteTypeEnumSet = []; _ErrorHandling: TErrorHandlingEnum = ehReturnFalse): Boolean;
var
  Options: DWORD;
  Res: HResult;
begin
  Options := 0;
  if acsFileSystem in _Source then
    Options := Options or SHACF_FILESYSTEM;
  if acsUrlHistory in _Source then
    Options := Options or SHACF_URLHISTORY;
  if acsUrlMru in _Source then
    Options := Options or SHACF_URLMRU;
  if actSuggest in _Type then
    Options := Options or SHACF_AUTOSUGGEST_FORCE_ON;
  if actAppend in _Type then
    Options := Options or SHACF_AUTOAPPEND_FORCE_ON;

  Res := SHAutoComplete(_ed.Handle, Options);
  Result := (Res = S_OK);
  if not Result and (_ErrorHandling = ehRaiseException) then
    raise EOleException.Create(_('Call to SHAutoComplete failed.'), Res, 'Shlwapi.dll', '', 0);
end;

type
  TFormPositioningActivator = class(TWindowProcHook)
  private
    FModifier: TShiftState;
    procedure CmChildKey(var _Msg: TMessage);
    function TheForm: TForm;
  protected
    procedure NewWindowProc(var _Msg: TMessage); override;
  public
    constructor Create(_Form: TForm; _Modifier: TShiftState);
  end;

type
  TAutoCompleteActivator = class(TWindowProcHook)
  private
    FSource: TAutoCompleteSourceEnumSet;
    FType: TAutoCompleteTypeEnumSet;
  protected
    procedure WmNcCreate; override;
    procedure SetAutoComplete;
    procedure NewWindowProc(var _Msg: TMessage); override;
  public
    constructor Create(_ed: TCustomEdit; _Source: TAutoCompleteSourceEnumSet = [acsFileSystem];
      _Type: TAutoCompleteTypeEnumSet = []);
  end;

{ TAutoCompleteActivator }

constructor TAutoCompleteActivator.Create(_ed: TCustomEdit;
  _Source: TAutoCompleteSourceEnumSet = [acsFileSystem]; _Type: TAutoCompleteTypeEnumSet = []);
begin
  inherited Create(_ed);
  FSource := _Source;
  FType := _Type;
  SetAutoComplete;
end;

procedure TAutoCompleteActivator.WmNcCreate;
begin
  inherited;
  SetAutoComplete;
end;

procedure TAutoCompleteActivator.SetAutoComplete;
begin
  TEdit_SetAutocomplete(FCtrl as TCustomEdit, FSource, FType);
end;

// This and the calling function IsAutoSuggstionDropdownVisible are taken from mghie's answer on
// http://stackoverflow.com/a/9228954/49925

function EnumThreadWindowsProc(AWnd: HWnd; AParam: LParam): BOOL; stdcall;
var
  WndClassName: string;
  FoundAndVisiblePtr: PInteger;
begin
  SetLength(WndClassName, 1024);
  GetClassName(AWnd, PChar(WndClassName), Length(WndClassName));
  WndClassName := PChar(WndClassName);
  if WndClassName = 'Auto-Suggest Dropdown' then begin // do not translate
    FoundAndVisiblePtr := PInteger(AParam);
    FoundAndVisiblePtr^ := Ord(IsWindowVisible(AWnd));
    Result := False;
  end else
    Result := True;
end;

function IsAutoSuggestDropdownVisible: Boolean;
var
  FoundAndVisible: Integer;
begin
  FoundAndVisible := 0;
  EnumThreadWindows(GetCurrentThreadId, @EnumThreadWindowsProc,
    LParam(@FoundAndVisible));
  Result := FoundAndVisible > 0;
end;

procedure TAutoCompleteActivator.NewWindowProc(var _Msg: TMessage);
begin
  if (_Msg.Msg = CM_WANTSPECIALKEY) then begin
    if (_Msg.wParam = VK_RETURN) or (_Msg.wParam = VK_ESCAPE) then begin
      if IsAutoSuggestDropdownVisible then begin
        _Msg.Result := 1;
        Exit; //==>
      end;
    end;
  end;
  inherited NewWindowProc(_Msg);
end;

function TEdit_AutoComplete(_ed: TCustomEdit; _Source: TAutoCompleteSourceEnumSet = [acsFileSystem];
  _Type: TAutoCompleteTypeEnumSet = []): TObject;
begin
  Result := TAutoCompleteActivator.Create(_ed, _Source, _Type);
end;

function InputValidator(_OkColor: TColor = clWindow; _ErrColor: TColor = clYellow): IdzInputValidator;
begin
  Result := u_dzInputValidator.InputValidator(_OkColor, _ErrColor);
end;

{ TActionListShortcutHelper }

constructor TActionListShortcutHelper.Create(_al: TActionList);
var
  i: Integer;
  act: TAction;
  cnt: Integer;
begin
  inherited Create;
  FActionList := _al;
  cnt := FActionList.ActionCount;
  SetLength(FShortcuts, cnt);
  for i := 0 to cnt - 1 do begin
    act := TAction(FActionList.Actions[i]);
    FShortcuts[i].Assign(act);
  end;
end;

procedure TActionListShortcutHelper.RemoveShortcuts;
var
  i: Integer;
  act: TAction;
begin
  for i := 0 to FActionList.ActionCount - 1 do begin
    act := TAction(FActionList.Actions[i]);
    act.ShortCut := scNone;
    act.SecondaryShortcuts.Clear;
  end;
end;

procedure TActionListShortcutHelper.AssignShortcuts;
var
  ActIdx: Integer;
  act: TAction;
  cnt: Integer;
  i: Integer;
begin
  cnt := Min(FActionList.ActionCount, Length(FShortcuts));
  for ActIdx := 0 to cnt - 1 do begin
    act := TAction(FActionList.Actions[ActIdx]);
    for i := 0 to Length(FShortcuts) - 1 do
      if FShortcuts[i].Action = act then begin
        FShortcuts[i].AssignTo(act);
        Break;
      end;
  end;
end;

{ TActionListShortcutHelper.TShortcutRec }

procedure TActionListShortcutHelper.TShortcutRec.Assign(_Action: TAction);
var
  j: Integer;
begin
  Action := _Action;
  PrimaryShortcut := Action.ShortCut;
  SetLength(SecondaryShortcuts, Action.SecondaryShortcuts.Count);
  for j := 0 to Action.SecondaryShortcuts.Count - 1 do
    SecondaryShortcuts[j] := Action.SecondaryShortcuts.ShortCuts[j];
end;

procedure TActionListShortcutHelper.TShortcutRec.AssignTo(_Action: TAction);
var
  i: Integer;
begin
  Assert(Action = _Action, 'actions do not match');

  Action.ShortCut := PrimaryShortcut;
  for i := 0 to Length(SecondaryShortcuts) - 1 do begin
    Action.SecondaryShortcuts.Add(ShortCutToText(SecondaryShortcuts[i]));
  end;
end;

function IsShiftDown: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Shift] and 128) <> 0);
end;

function IsCtrlDown: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_CONTROL] and 128) <> 0);
end;

function IsAltDown: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_MENU] and 128) <> 0);
end;

function GetModifierKeyState: TShiftState;
var
  State: TKeyboardState;
begin
  Result := [];
  if GetKeyboardState(State) then begin
    if ((State[vk_Shift] and 128) <> 0) then
      Include(Result, ssShift);
    if ((State[VK_CONTROL] and 128) <> 0) then
      Include(Result, ssCtrl);
    if ((State[VK_MENU] and 128) <> 0) then
      Include(Result, ssAlt);
  end;
end;

procedure TMonitor_MakeFullyVisible(_MonitorRect: TRect; var _Left, _Top, _Width, _Height: Integer); overload;
begin
  if _Left + _Width > _MonitorRect.Right then
    _Left := _MonitorRect.Right - _Width;
  if _Left < _MonitorRect.Left then
    _Left := _MonitorRect.Left;
  if _Top + _Height > _MonitorRect.Bottom then
    _Top := _MonitorRect.Bottom - _Height;
  if _Top < _MonitorRect.Top then
    _Top := _MonitorRect.Top;
end;

procedure TMonitor_MakeFullyVisible(_Monitor: TMonitor; var _Left, _Top, _Width, _Height: Integer); overload;
begin
  TMonitor_MakeFullyVisible(_Monitor.WorkareaRect, _Left, _Top, _Width, _Height);
end;

procedure TMonitor_MakeFullyVisible(_MonitorRect: TRect; var _Rect: TRect; out _Width, _Height: Integer); overload;
var
  Left: Integer;
  Top: Integer;
begin
  Left := _Rect.Left;
  Top := _Rect.Top;
  _Width := _Rect.Right - Left;
  _Height := _Rect.Bottom - Top;
  TMonitor_MakeFullyVisible(_MonitorRect, Left, Top, _Width, _Height);
  _Rect.Left := Left;
  _Rect.Top := Top;
  _Rect.Right := Left + _Width;
  _Rect.Bottom := Top + _Height;
end;

procedure TMonitor_MakeFullyVisible(_Monitor: TMonitor; var _Rect: TRect; out _Width, _Height: Integer); overload;
begin
  TMonitor_MakeFullyVisible(_Monitor.WorkareaRect, _Rect, _Width, _Height);
end;

procedure TMonitor_MakeFullyVisible(_Monitor: TMonitor; var _Rect: TRect); overload;
var
  Width: Integer;
  Height: Integer;
begin
  TMonitor_MakeFullyVisible(_Monitor, _Rect, Width, Height);
end;

procedure TMonitor_MakeFullyVisible(_Monitor: TMonitor; var _Rect: TRectLTWH); overload;
begin
  TMonitor_MakeFullyVisible(_Monitor.WorkareaRect, _Rect.Left, _Rect.Top, _Rect.Width, _Rect.Height);
end;

{ TRectLTWH }

procedure TRectLTWH.Assign(_Left, _Top, _Width, _Height: Integer);
begin
  Left := _Left;
  Top := _Top;
  Width := _Width;
  Height := _Height;
end;

procedure TRectLTWH.Assign(_a: TRect);
begin
  AssignTLRB(_a.Left, _a.Top, _a.Right, _a.Bottom);
end;

procedure TRectLTWH.AssignTLRB(_Left, _Top, _Right, _Bottom: Integer);
begin
  Assign(_Left, _Top, _Right - _Left, _Bottom - _Top);
end;

class operator TRectLTWH.Implicit(_a: TRectLTWH): TRect;
begin
  Result := Rect(_a.Left, _a.Top, _a.Left + _a.Width, _a.Top + _a.Height);
end;

class operator TRectLTWH.Implicit(_a: TRect): TRectLTWH;
begin
  Result.Assign(_a);
end;

procedure TForm_MoveTo(_frm: TCustomForm; _Position: TdzWindowPositions);

  procedure ToTop(var _Re: TRect);
  begin
    _Re.Bottom := _Re.Top + TRect_Height(_Re) div 2;
  end;

  procedure ToBottom(var _Re: TRect);
  begin
    _Re.Top := _Re.Top + TRect_Height(_Re) div 2;
  end;

  procedure ToLeft(var _Re: TRect);
  begin
    _Re.Right := _Re.Left + TRect_Width(_Re) div 2;
  end;

  procedure ToRight(var _Re: TRect);
  begin
    _Re.Left := _Re.Left + TRect_Width(_Re) div 2;
  end;

  function SamePoint(const _pnt1, _pnt2: TPoint): Boolean;
  begin
    Result := (_pnt1.X = _pnt2.X) and (_pnt1.Y = _pnt2.Y);
  end;

  function SameRect(const _re1, _re2: TRect): Boolean;
  begin
    Result := SamePoint(_re1.TopLeft, _re2.TopLeft) and SamePoint(_re1.BottomRight, _re2.BottomRight);
  end;

  function MonitorFromPoint(_pnt: TPoint): TMonitor;
  var
    i: Integer;
    WaRect: TRect;
  begin
    for i := 0 to Screen.MonitorCount - 1 do begin
      Result := Screen.Monitors[i];
      WaRect := Result.WorkareaRect;
      if (WaRect.Top <= _pnt.Y) and (WaRect.Bottom >= _pnt.Y)
        and (WaRect.Left <= _pnt.X) and (WaRect.Right >= _pnt.X) then
        Exit;
    end;
    Result := nil;
  end;

var
  re: TRect;
  NewMonitor: TMonitor;
begin
  re := _frm.Monitor.WorkareaRect;
  case _Position of
    dwpTop: begin
        ToTop(re);
        if SameRect(re, _frm.BoundsRect) then begin
          NewMonitor := MonitorFromPoint(Point((re.Left + re.Right) div 2, re.Top - TRect_Height(re) div 2));
          if Assigned(NewMonitor) then begin
            re := NewMonitor.WorkareaRect;
            ToBottom(re);
          end;
        end;
      end;
    dwpBottom: begin
        ToBottom(re);
        if SameRect(re, _frm.BoundsRect) then begin
          NewMonitor := MonitorFromPoint(Point((re.Left + re.Right) div 2, re.Bottom + TRect_Height(re) div 2));
          if Assigned(NewMonitor) then begin
            re := NewMonitor.WorkareaRect;
            ToTop(re);
          end;
        end;
      end;
    dwpLeft: begin
        ToLeft(re);
        if SameRect(re, _frm.BoundsRect) then begin
          NewMonitor := MonitorFromPoint(Point(re.Left - TRect_Width(re) div 2, (re.Top + re.Bottom) div 2));
          if Assigned(NewMonitor) then begin
            re := NewMonitor.WorkareaRect;
            ToRight(re);
          end;
        end;
      end;
    dwpRight: begin
        ToRight(re);
        if SameRect(re, _frm.BoundsRect) then begin
          NewMonitor := MonitorFromPoint(Point(re.Right + TRect_Width(re) div 2, (re.Top + re.Bottom) div 2));
          if Assigned(NewMonitor) then begin
            re := NewMonitor.WorkareaRect;
            ToLeft(re);
          end;
        end;
      end;
    dwpTopLeft: begin
        ToTop(re);
        ToLeft(re);
      end;
    dwpTopRight: begin
        ToTop(re);
        ToRight(re);
      end;
    dwpBottomLeft: begin
        ToBottom(re);
        ToLeft(re);
      end;
    dwpBottomRight: begin
        ToBottom(re);
        ToRight(re);
      end;
  end;
  _frm.BoundsRect := re;
end;

{ TFormCtrlAltPositioningActivator }

constructor TFormPositioningActivator.Create(_Form: TForm; _Modifier: TShiftState);
begin
  inherited Create(_Form);
  FModifier := _Modifier;
end;

procedure TFormPositioningActivator.CmChildKey(var _Msg: TMessage);
var
  Key: Word;
begin
  Key := (_Msg.WParamLo and $FF);
  if GetModifierKeyState = FModifier then begin
    case Key of
      VK_LEFT, VK_NUMPAD4: TForm_MoveTo(TheForm, dwpLeft);
      VK_RIGHT, VK_NUMPAD6: TForm_MoveTo(TheForm, dwpRight);
      VK_UP, VK_NUMPAD8: TForm_MoveTo(TheForm, dwpTop);
      VK_DOWN, VK_NUMPAD2: TForm_MoveTo(TheForm, dwpBottom);
      VK_PRIOR, VK_NUMPAD9: TForm_MoveTo(TheForm, dwpTopRight);
      VK_NEXT, VK_NUMPAD3: TForm_MoveTo(TheForm, dwpBottomRight);
      VK_HOME, VK_NUMPAD7: TForm_MoveTo(TheForm, dwpTopLeft);
      VK_END, VK_NUMPAD1: TForm_MoveTo(TheForm, dwpBottomLeft);
    else
      Exit; //==> exit, so Result doesn't get set to 1
    end;
    _Msg.Result := 1;
  end;
end;

procedure TFormPositioningActivator.NewWindowProc(var _Msg: TMessage);
begin
  if _Msg.Msg = CM_CHILDKEY then
    CmChildKey(_Msg);

  inherited NewWindowProc(_Msg);
end;

function TFormPositioningActivator.TheForm: TForm;
begin
  Result := TForm(FCtrl);
end;

function TForm_ActivatePositioning(_Form: TForm; _Modifier: TShiftState = [ssCtrl, ssAlt]): TObject;
begin
  Result := TFormPositioningActivator.Create(_Form, _Modifier);
end;

initialization
finalization
  FreeAndNil(gblCheckListBoxHelper);
end.
