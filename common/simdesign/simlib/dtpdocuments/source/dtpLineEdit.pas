{
  Unit dtpLineEdit

  dtpLineEdit can be used to provide a control with editing capabilities.
  It takes care of processing the keys and updating the text that is edited.
  It works with a selection, that can be set with SelStart and SelLength.

  Start by creating the object, and assigning an event handler to OnChange,
  then set the "Text" property. Next, redirect KeyDown, KeyPress and KeyUp methods
  of TWinControl descendant to Edit.ProcessKeyDown etc.

  Project: DTP-Engine

  Creation Date: 04-08-2003 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

  Contributors: JohnF (JF)
  JohnF 2010-05-26: Modified TdtpLineEdit.ProcessKeyDown (JF)

}
unit dtpLineEdit;

{$i simdesign.inc}

interface

uses
  Classes, Windows, StdCtrls, Math, SysUtils;

type

  TdtpCaretEvent = function (Sender: TObject; ACaretPos: integer; AKeyCode: word): integer of object;

  TdtpLineEdit = class
  private
    FCaretIndex: integer;     // Position of the caret (0 = before first char)
    FCharCase: TEditCharCase; // CharCase: ecNormal for mixed, ecUpperCase to convert to for uppercase, ecLowerCase for lowercase
    FMaxTextLength: integer;  // If 0, no maximum length is checked, otherwise it limits the length of Text
    FSelLength: integer;      // Length of selection or 0 if no selection
    FSelStart: integer;       // Start position of selection (0 = first char)
    FText: widestring;        // The text to be edited
    FOnCaretPosition: TdtpCaretEvent;
    FOnChanged: TNotifyEvent; // OnTextChanged is called whenever text and other props changed
    procedure CheckValidity;
    procedure DoChanged;
    function DoCaretPosition(ACaretPos: integer; AKeyCode: word): integer;
    procedure SetText(const Value: widestring);
    procedure SetMaxTextLength(const Value: integer);
    procedure SetCaretIndex(const Value: integer);
  protected
    function CopySelection: string;
    function CutSelection: string;
    procedure InsertString(AString: string);
  public
    constructor Create; virtual;
    procedure ProcessKeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure ProcessKeyPress(var Key: Char); virtual;
    procedure ProcessKeyUp(var Key: Word; Shift: TShiftState); virtual;
    procedure UnSelectAll;
    procedure SelectAll;
    property CaretIndex: integer read FCaretIndex write SetCaretIndex;
    property CharCase: TEditCharCase read FCharCase write FCharCase;
    property MaxTextLength: integer read FMaxTextLength write SetMaxTextLength;
    property SelLength: integer read FSelLength write FSelLength;
    property SelStart: integer read FSelStart write FSelStart;
    property Text: widestring read FText write SetText;
    property OnCaretPosition: TdtpCaretEvent read FOnCaretPosition write FOnCaretPosition;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  end;

const

  cDefaultMaxTextLength = 0; // Per default we do not limit the text length

implementation

uses
  Clipbrd;

{ TdtpLineEdit }

procedure TdtpLineEdit.CheckValidity;
begin
  // Make sure to have valid property values
  if (FMaxTextLength > 0) and (FMaxTextLength < Length(FText)) then
    FText := copy(FText, 1, FMaxTextLength);
  FCaretIndex := Min(Max(0, FCaretIndex), Length(FText));
  FSelStart   := Min(Max(0, FSelStart  ), Length(FText));
  FSelLength  := Min(Max(0, FSelLength ), Length(FText) - FSelStart);
end;

function TdtpLineEdit.CopySelection: string;
begin
  Result := '';
  if FSelLength > 0 then
    Result := copy(FText, FSelStart + 1, FSelLength);
end;

constructor TdtpLineEdit.Create;
begin
  inherited Create;
  // Defaults
  FMaxTextLength := cDefaultMaxTextLength;
end;

function TdtpLineEdit.CutSelection: string;
begin
  Result := '';
  if FSelLength > 0 then
  begin
    Result := copy(FText, FSelStart + 1, FSelLength);
    Delete(FText, FSelStart + 1, FSelLength);
    FSelLength := 0;
  end;
end;

function TdtpLineEdit.DoCaretPosition(ACaretPos: integer; AKeyCode: word): integer;
// Calculate the new caret position based on the arrow key in AKeyCode
begin
  // Default: just the same caret position
  Result := ACaretPos;
  if assigned(FOnCaretPosition) then
  begin
    // Is an event provided? We will call the event to provide the
    // new caret position (e.g. multiline)
    Result := FOnCaretPosition(Self, ACaretPos, AKeyCode)
  end else
  begin
    // Default behaviour (works well for single-line text)
    case AKeyCode of
    VK_LEFT, VK_UP:    Result := ACaretPos - 1;
    VK_RIGHT, VK_DOWN: Result := ACaretPos + 1;
    VK_HOME:           Result := 0;
    VK_END:            Result := Length(FText);
    end;//case
  end;
end;

procedure TdtpLineEdit.DoChanged;
begin
  if assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TdtpLineEdit.InsertString(AString: string);
begin
  // Convert case
  case CharCase of
  ecUpperCase: AString := AnsiUpperCase(AString);
  ecLowerCase: AString := AnsiLowerCase(AString);
  end;
  if SelLength > 0 then
  begin
    // Replace selection
    Delete(FText, FSelStart + 1, FSelLength);
    Insert(AString, FText, FSelStart + 1);
    FCaretIndex := FSelStart + Length(AString);
    FSelLength := 0;
  end else
  begin
    // Insert at caret pos
    Insert(AString, FText, FCaretIndex + 1);
    inc(FCaretIndex, Length(AString));
  end;
end;

procedure TdtpLineEdit.ProcessKeyDown(var Key: Word; Shift: TShiftState);
var
  Delta: integer;
begin
  case Key of
  VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME, VK_END:
    begin
      // Arrow keys + home and end
      Delta := DoCaretPosition(FCaretIndex, Key) - FCaretIndex;
      if ssShift in Shift then
      begin
        if SelLength = 0 then
          SelStart := CaretIndex;
        // Change selection border at CaretIndex as well
        if FCaretIndex = FSelStart then
        begin
          inc(FSelStart, Delta);
          inc(FSelLength, -Delta);
        end else
          if FCaretIndex = FSelStart + FSelLength then
            inc(FSelLength, Delta);
        // Change caret index
        inc(FCaretIndex, Delta);
      end else
      begin
        // Make sure not to have a selection
        FSelLength := 0;
        inc(FCaretIndex, Delta);
      end;
      // Checks
      if FSelLength < 0 then
      begin
        // Swap
        FSelStart := FSelStart + FSelLength;
        FSelLength := abs(FSelLength);
      end;
    end;
  VK_BACK, VK_DELETE: // Backspace and delete
    if FSelLength > 0 then
    begin
      // Delete selection
      Delete(FText, FSelStart + 1, FSelLength);
      FCaretIndex := FSelStart;
      FSelLength := 0;
    end else
    begin
      // Delete single char
      if Key = VK_BACK then
      begin
        Delete(FText, FCaretIndex, 1);
        dec(FCaretIndex);
        if length(FText) <> 0 then  // added by JF bug fix
        begin
          if ord(FText[FCaretIndex]) in [13] then 
          begin   
            // eliminates need to do 2 backspaces to delete linefeed
            Delete(FText, FCaretIndex, 1);
            dec(FCaretIndex);
          end;
        end;  
      end else
        Delete(FText, FCaretIndex + 1, 1);
    end;
  VK_RETURN:
    InsertString(#13#10);
  else
    exit;
  end;//case
  CheckValidity;
  DoChanged;
end;

procedure TdtpLineEdit.ProcessKeyPress(var Key: Char);
begin
  case ord(Key) of
  $20..$FF:
    // Normal characters
    InsertString(Key);
  $03: // Ctrl-C (Copy)
    // Copy selection from control to clipboard
    begin
      Clipboard.Clear; // added by J.F.
      Clipboard.AsText := CopySelection;
    end;
  $16: // Ctrl-V (Paste)
    // Paste selection from clipboard to control
    InsertString(Clipboard.AsText);
  $18: // Ctrl-X (Cut)
    // Cut selection from control to clipboard
    begin
      dec(FCaretIndex, FSelLength);
      Clipboard.Clear; // added by J.F.
      Clipboard.AsText := CutSelection;
    end;
  end;//case
  CheckValidity;
  DoChanged;
end;

procedure TdtpLineEdit.ProcessKeyUp(var Key: Word; Shift: TShiftState);
begin
//
end;

procedure TdtpLineEdit.UnSelectAll; 
// added by JF
begin
  if FSelLength > 0 then
  begin
    FSelStart:= 0;
    FSelLength:= 0;
    DoChanged;
  end;
end;

procedure TdtpLineEdit.SelectAll;
begin
  FCaretIndex := Length(FText);
  FSelStart   := 0;
  FSelLength  := Length(FText);
  DoChanged;
end;

procedure TdtpLineEdit.SetCaretIndex(const Value: integer);
begin
  if FCaretIndex <> Value then
  begin
    FCaretIndex := Value;
    DoChanged;
  end;
end;

procedure TdtpLineEdit.SetMaxTextLength(const Value: integer);
begin
  if FMaxTextLength <> Value then
  begin
    FMaxTextLength := Value;
    CheckValidity;
    DoChanged;
  end;
end;

procedure TdtpLineEdit.SetText(const Value: widestring);
// User sets the text
begin
  if FText <> Value then
  begin
    FText       := Value;
    FCaretIndex := Length(FText);
    FSelStart   := 0;
    FSelLength  := 0;
  end;
  DoChanged;
end;

end.
