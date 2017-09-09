{.GXFormatter.config=twm}
///<summary> Generic exception and message dialog.
///          This unit implements a generic Dialog to display exceptions and messages.
///          For exceptions, it only displays the exception's class name and a
///          Details button to get the message.
///          Most times all you need is calling one of the overloaded dzShowException
///          functions.
///          @author twm </summary>
unit w_dzDialog;

{$INCLUDE jedi.inc}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
{$IFNDEF no_jcl}
  Jcldebug,
{$ENDIF}
  u_dzTranslator;

type
  EInvalidModalResult = class(Exception);

type
  TDialogButtonEnum = (dbeYes, dbeNo, dbeOK, dbeCancel, dbeAbort, dbeRetry, dbeIgnore,
    dbeAll, dbeNoToAll, dbeYesToAll, dbeHelp, dbeCustom);
  TDialogButtonArr = array of TDialogButtonEnum;
  TIntegerArray = array of Integer;
  TStringArray = array of string;

const
  ExceptionDialogModalResults: array[TDialogButtonEnum] of Integer = (
    mrYes, mrNo, mrOk, mrCancel, mrAbort, mrRetry, mrIgnore, mrAll, mrNoToAll,
    mrYesToAll, 0, -1);

///<summary> converts the modal result returned by dzShowMessage to the button pressed </summary>
function ModalResultToButton(_Result: Integer): TDialogButtonEnum;

type
  ///<summary> whether to show the maximze button
  ///         <ul>
  ///           <li>smSmart - show only when details are visible</li>
  ///           <li>smShow - show always</li>
  ///           <li>smHide - don't show at all</li>
  ///         </ul> </summary>
  TShowMaximizeOption = (smSmart, smShow, smHide);

type
  { used for the property OnButtonClick in asynchronous mode
    @param(Sender is the Exceptiondialog)
    @param(Button is the ModalResult value of the button pressed)
    @param(Action is a TCloseAction indicating whether the dialog can be closed,
           it is initialized to caNone and can be set to caHide, caFree or caMinimize)}
  TOnButtonClick = procedure(Sender: TObject; _Button: TModalResult; var _Action: TCloseAction) of object;

type
  ///<summary> defines the exception and messsage dialog.
  ///          This dialog is used by the various dzShowException and the dzShowMessage
  ///          functions. It can of course also be created independently. The minimum
  ///          properties to set are
  ///          <ul>
  ///            <li>ExcecptionClass</li>
  ///            <li>ExceptionMessage</li>
  ///            <li>VisibleButtons</li>
  ///          </ul>
  ///          for showing an exception and
  ///          <ul>
  ///            <li>UserMessage</li>
  ///            <li>VisibleButtons</li>
  ///            <li>ShowDetailButton (to false)</li>
  ///          </ul>
  ///          for showing a message. </summary>
  Tf_dzDialog = class(TForm)
    p_Top: TPanel;
    l_Message: TLabel;
    l_Options: TLabel;
    p_Details: TPanel;
    m_Details: TMemo;
    im_Icon: TImage;
    procedure FormCreate(Sender: TObject);
  private
    ///<summary> used to display the dialog pseudo modally,
    ///          see dzShowNonModalMessage function and MakeModal/MakeNonmodal methods </summary>
    FWindowList: pointer;
    FOnButtonClick: TOnButtonClick;
  private
    FExceptionClass: string;
    FExceptionMessage: string;
    FExceptionExtendedMessage: string;
    FExceptionAddress: pointer;
    FOptionDescription: string;
    FExceptionProcedure: string;
    FVisibleButtons: TDialogButtonArr;
    FUserMessage: string;
    FDetails: string;
    FFocusButton: Integer;
    FDialogType: TMsgDlgType;
    FShowDetailButton: Boolean;
    FDontShowAgainText: string;
    FShowDontShowAgain: Boolean;
    b_Details: TButton; // FI:C107 - no F prefix
    chk_DontAskAgain: TCheckBox; // FI:C107 - no F prefix
    FCallStack: TStrings;
    FShowMaximize: TShowMaximizeOption;
    FCustomModalResults: TIntegerArray;
    FCustomButtonCaptions: TStringArray;
    procedure SetDontShowAgainText(const _Value: string);
    procedure HideDetails;
    procedure ShowDetails;
    procedure SetCallStack(const _CallStack: TStrings);
    procedure MakeModal;
    procedure MakeNonModal;
    procedure ButtonClick(_Sender: TObject);
    procedure SetVisibleButtons(const _Buttons: array of TDialogButtonEnum);
    procedure SetFocusButton(_ButtonIndex: Integer);
  protected
    procedure b_DetailsClick(Sender: TObject);
    procedure GenerateControls;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(_Owner: TComponent); override;
    destructor Destroy; override;

    procedure Hide;
    ///<summary> class name of the exception </summary>
    property ExceptionClass: string read FExceptionClass write FExceptionClass;
    ///<summary> message of the exception </summary>
    property ExceptionMessage: string read FExceptionMessage write FExceptionMessage;
    ///<summary> exception address (initialized to ExcptAddr) </summary>
    //    property ExcptionAddress: pointer read fExceptionAddress write fExceptionAddress;
    ///<summary> extended exception messsage </summary>
    property ExceptionExtendedMessage: string read FExceptionExtendedMessage write FExceptionExtendedMessage;
    ///<summary> exception procedure </summary>
    property ExceptionProcedure: string read FExceptionProcedure write FExceptionProcedure;
    property CallStack: TStrings read FCallStack write SetCallStack;
    ///<summary> array of buttons to show, note that this is an array, not a set, so the
    ///          order matters </summary>
    property VisibleButtons: TDialogButtonArr read FVisibleButtons;
    ///<summary> array of modal results for the custom buttons. Note: The length of this
    ///          array is set when VisibleButtons is updated (using SetVisibleButtons) </summary>
    property CustomModalResults: TIntegerArray read FCustomModalResults;
    ///<summary> array of captions for the custom buttons Note: The length of this
    ///          array is set when VisibleButtons is updated (using SetVisibleButtons) </summary>
    property CustomButtonCaptions: TStringArray read FCustomButtonCaptions;
    ///<summary> user message to show instead of 'An error <i>exceptionclass</i> occured.'
    ///          Can contain up to two %s wildcards, the first will be replaced with
    ///          the exception's class name the second with the exception's message
    ///          (not implemented) </summary>
    property UserMessage: string read FUserMessage write FUserMessage;
    ///<summary> description of the buttons (or some other text to be displayed) </summary>
    property OptionDescription: string read FOptionDescription write FOptionDescription;
    ///<summary> text to display instead of '<i>exceptionclass</i>'#13#10'<i>exceptionmessage</i>'#13#10 </summary>
    property Details: string read FDetails write FDetails;
    ///<summary> determines the icon of the dialog </summary>
    property DialogType: TMsgDlgType read FDialogType write FDialogType;
    ///<summary> if true the 'Details' button is shown </summary>
    property ShowDetailButton: Boolean read FShowDetailButton write FShowDetailButton;
    ///<summary> if true, the 'Do not show again' checkbox is shown.
    ///          Automatically set true, when DontShowAgainText is set to a nonempty string. </summary>
    property ShowDontShowAgain: Boolean read FShowDontShowAgain write FShowDontShowAgain;
    ///<summary> checkbox caption to show instead of 'Do not ask again.' </summary>
    property DontShowAgainText: string read FDontShowAgainText write SetDontShowAgainText;
    ///<summary> whether to show the maximze button
    ///          <ul>
    ///            <li>smSmart - show only when details are visible</li>
    ///            <li>smShow - show always</li>
    ///            <li>smHide - don't show at all</li>
    ///          </ul> </summary>
    property ShowMaximize: TShowMaximizeOption read FShowMaximize write FShowMaximize;
  public
    ///<summary> Simple function to show an exception.
    ///          This will display a dialog with the exclamation mark (!) icon, an OK button,
    ///          the text 'An error <i>exceptionclass</i> occured.' and a Details button.
    ///          Pressing the details button will display<br>
    ///          <i>exceptionclass</i><br>
    ///          <i>exceptionmessage</i><br>
    ///          <i>call stack, if available</i><br>
    ///          @param e is the exception to display
    ///          @param Owner is used as owner in the constructor and also set as Parent, defaults
    ///                       to nil
    ///          @returns one of the mrXxxx values </summary>
    class function ShowException(_e: Exception; _Owner: TWinControl = nil): Integer; overload;
    ///<summary> Moderately complex function to show an exception.
    ///          This will display a dialog with the exclamation mark (!) icon, the Buttons
    ///          and OptionDesc specified,
    ///          the text 'An error <i>exceptionclass</i> occured.' and a Details button.
    ///          Pressing the details button will display<br>
    ///          <i>exceptionclass</i><br>
    ///          <i>exceptionmessage</i><br>
    ///          <i>call stack, if available</i><br>
    ///          @param e is the exception to display
    ///          @param Buttons is an array of buttons to show (Note: This is an array of
    ///                         buttons, not a set, so the order is important!)
    ///          @param OptionDesc gives the description for the Buttons, if not given,
    ///                            defaults to an empty string
    ///          @param Owner is used as owner in the constructor and also set as Parent, defaults
    ///                       to nil
    ///          @returns one of the mrXxxx values </summary>
    class function ShowException(_e: Exception; const _Buttons: array of TDialogButtonEnum;
      const _OptionDesc: string = ''; _Owner: TWinControl = nil): Integer; overload;
    ///<summary> Complex function to show an exception.
    ///          This will display a dialog with the exclamation mark (!) icon, the Buttons
    ///          and OptionDesc specified, the Message passed and a Details button.
    ///          Pressing the details button will display<br>
    ///          <i>exceptionclass</i><br>
    ///          <i>exceptionmessage</i><br>
    ///          <i>call stack, if available</i><br>
    ///          @param e is the exception to display
    ///          @param Message is the message to display
    ///          @param Buttons is an array of buttons to show (Note: This is an array of
    ///                         buttons, not a set, so the order is important!)
    ///          @param OptionDesc gives the description for the Buttons, if not given,
    ///                            defaults to an empty string
    ///          @param Owner is used as owner in the constructor and also set as Parent, defaults
    ///                       to nil
    ///          @returns one of the mrXxxx values }
    class function ShowException(_e: Exception; const _Message: string;
      const _Buttons: array of TDialogButtonEnum; const _OptionDesc: string = '';
      _Owner: TWinControl = nil): Integer; overload;
    class function ShowError(const _ErrorMsg, _Details: string; const _Buttons: array of TDialogButtonEnum;
      const _OptionDesc: string = ''; _Owner: TWinControl = nil): Integer;
    ///<summary> Simple function to display a message.
    ///          This will display a dialog with the icon indicated by DialogType, the
    ///          Message given, containing the Buttons specified and optionally an
    ///          OptionDesc. In contrast to MessageDlg the dialog is centered on the owner.
    ///          @param DialogType gives the icon to display
    ///          @param Message is the message text to display
    ///          @param Buttons is an array of buttons to show (Note: This is an array of
    ///                         buttons, not a set, so the order is important!)
    ///          @param Owner is the owner component to be used in the constructor, defaults
    ///                       to nil
    ///          @param OptionDesc gives the description for the Buttons, if not given,
    ///                            defaults to an empty string
    ///          @returns one of the mrXxxx values </summary>
    class function ShowMessage(_DialogType: TMsgDlgType; const _Message: string;
      const _Buttons: array of TDialogButtonEnum; _Owner: TWinControl = nil;
      const _OptionDesc: string = ''; _FocusButton: Integer = -1): Integer; overload;
    ///<summary> Complex function to display a message.
    ///          This will display a dialog with the icon indicated by DialogType, the
    ///          Message given, containing the Buttons specified and optionally an
    ///          OptionDesc. In contrast to MessageDlg the dialog is centered on the owner.
    ///          @param DialogType gives the icon to display
    ///          @param Message is the message text to display
    ///          @param Buttons is an array of buttons to show (Note: This is an array of
    ///                         buttons, not a set, so the order is important!)
    ///          @param CustomButtons is an array of strings for the custom button captions,
    ///                               the number of entries must correspond to the number
    ///                               of dbeCustom entries in the Buttons array
    ///          @param CustomResults is an array of integers with the modal results for
    ///                               the custom buttons, the number of entries must
    ///                               correspond to the number of dbeCustom entries in the
    ///                               Buttons array
    ///          @param Owner is the owner component to be used in the constructor, defaults
    ///                       to nil
    ///          @param OptionDesc gives the description for the Buttons, if not given,
    ///                            defaults to an empty string
    ///          @returns one of the mrXxxx values </summary>
    class function ShowMessage(_DialogType: TMsgDlgType; const _Message: string;
      const _Buttons: array of TDialogButtonEnum; const _CustomButtons: array of string;
      const _CustomResults: array of Integer;
      _Owner: TWinControl = nil;
      const _OptionDesc: string = ''; _FocusButton: Integer = -1;
      const _Caption: string = ''): Integer; overload;
    ///<summary> Creates a Tf_dzDialog instance, shows it and returns it. The created
    ///          dialog instance must be freed by the caller. Nonmodal in this context
    ///          means that the call returns to the caller rather than waiting for the
    ///          dialog to be dismissed by the user, so processing can continue. But note
    ///          that the dialog is displayed on top of all application windows and
    ///          works just like a modal dialog by blocking input to all other windows.
    ///          You must free the dialog so it is removed.
    ///          @param DialogType gives the icon to display
    ///          @param Message is the message text to display
    ///          @param Buttons is an array of buttons to show (Note: This is an array of
    ///                         buttons, not a set, so the order is important!)
    ///          @param CustomButton is an array of strings for the custom button captions,
    ///                              the number of entries must correspond to the number
    ///                              of debCustom entries in the Buttons array
    ///          @param CustomResults is an array of integers with the modal results for
    ///                               the custom buttons, the number of entries must
    ///                               correspond to the number of dbeCustom entries in the
    ///                               Buttons array
    ///          @param OnButtonClick is an event handler that will be called if one of the
    ///                               buttons is clicked
    ///          @param OptionDesc gives the description for the Buttons, if not given,
    ///                            defaults to an empty string
    ///          @param Owner is used as owner in the constructor and also set as Parent, defaults
    ///                       to nil
    ///          @returns the created Tf_dzDialog instance, the caller is responsible
    ///                   for closing and freeing this instance. }
    class function ShowNonModalMessage(_DialogType: TMsgDlgType; const _Message: string;
      const _Buttons: array of TDialogButtonEnum; const _CustomButtons: array of string;
      const _CustomResults: array of Integer; _OnButtonClick: TOnButtonClick;
      const _OptionDesc: string = ''; _Owner: TWinControl = nil): Tf_dzDialog; overload;
    class function ShowNonModalMessage(_DialogType: TMsgDlgType; const _Message: string;
      _OnButtonClick: TOnButtonClick; _Owner: TWinControl = nil): Tf_dzDialog; overload;
  end;

implementation

{$R *.DFM}

uses
  Consts,
  Math,
  ShellApi,
  u_dzVclUtils;

const
  CHECKBOX_WIDTH = 24;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

function ModalResultToButton(_Result: Integer): TDialogButtonEnum;
var
  btn: TDialogButtonEnum;
begin
  for btn := Low(TDialogButtonEnum) to High(TDialogButtonEnum) do
    if ExceptionDialogModalResults[btn] = _Result then begin
      Result := btn;
      Exit;
    end;
  raise EInvalidModalResult.CreateFmt(_('Invalid modal result %d.'), [_Result]);
end;

class function Tf_dzDialog.ShowMessage(_DialogType: TMsgDlgType;
  const _Message: string; const _Buttons: array of TDialogButtonEnum;
  const _CustomButtons: array of string; const _CustomResults: array of Integer;
  _Owner: TWinControl = nil; const _OptionDesc: string = ''; _FocusButton: Integer = -1;
  const _Caption: string = ''): Integer;
var
  frm: Tf_dzDialog;
  i: Integer;
begin
  frm := Tf_dzDialog.Create(_Owner);
  try
    frm.ShowDetailButton := False;
    frm.SetVisibleButtons(_Buttons);
    frm.SetFocusButton(_FocusButton);
    Assert(Length(_CustomButtons) = Length(frm.CustomButtonCaptions));
    for i := Low(_CustomButtons) to High(_CustomButtons) do
      frm.CustomButtonCaptions[i] := _CustomButtons[i];
    Assert(Length(_CustomResults) = Length(frm.CustomModalResults));
    for i := Low(_CustomResults) to High(_CustomResults) do
      frm.CustomModalResults[i] := _CustomResults[i];
    frm.UserMessage := _Message;
    frm.OptionDescription := _OptionDesc;
    frm.DialogType := _DialogType;
    frm.GenerateControls;
    if _Caption <> '' then
      frm.Caption := _Caption;
    TForm_CenterOn(frm, _Owner);
    Result := frm.ShowModal;
  finally
    frm.Free;
  end;
end;

class function Tf_dzDialog.ShowMessage(_DialogType: TMsgDlgType; const _Message: string;
  const _Buttons: array of TDialogButtonEnum; _Owner: TWinControl = nil; const _OptionDesc: string = '';
  _FocusButton: Integer = -1): Integer;
var
  frm: Tf_dzDialog;
begin
  frm := Tf_dzDialog.Create(_Owner);
  try
    if Assigned(_Owner) and (_Owner is TForm) then
      frm.Font := TForm(_Owner).Font;
    frm.ShowDetailButton := False;
    frm.SetVisibleButtons(_Buttons);
    frm.SetFocusButton(_FocusButton);
    frm.UserMessage := _Message;
    frm.OptionDescription := _OptionDesc;
    frm.DialogType := _DialogType;
    frm.GenerateControls;
    TForm_CenterOn(frm, _Owner);
    Result := frm.ShowModal;
  finally
    frm.Free;
  end;
end;

class function Tf_dzDialog.ShowNonModalMessage(_DialogType: TMsgDlgType; const _Message: string;
  _OnButtonClick: TOnButtonClick; _Owner: TWinControl = nil): Tf_dzDialog;
begin
  Result := Tf_dzDialog.Create(_Owner);
  Result.ShowDetailButton := False;
  Result.SetVisibleButtons([dbeOK]);
  Result.UserMessage := _Message;
  Result.OptionDescription := '';
  Result.DialogType := _DialogType;
  Result.GenerateControls;
  TForm_CenterOn(Result, _Owner);
  Result.FOnButtonClick := _OnButtonClick;
  Result.MakeModal;
  Result.Show;
end;

class function Tf_dzDialog.ShowNonModalMessage(_DialogType: TMsgDlgType; const _Message: string;
  const _Buttons: array of TDialogButtonEnum; const _CustomButtons: array of string;
  const _CustomResults: array of Integer; _OnButtonClick: TOnButtonClick;
  const _OptionDesc: string = ''; _Owner: TWinControl = nil): Tf_dzDialog;
var
  i: Integer;
begin
  Result := Tf_dzDialog.Create(_Owner);
  Result.ShowDetailButton := False;
  Result.SetVisibleButtons(_Buttons);
  Assert(Length(_CustomButtons) = Length(Result.CustomButtonCaptions));
  for i := Low(_CustomButtons) to High(_CustomButtons) do
    Result.CustomButtonCaptions[i] := _CustomButtons[i];
  Assert(Length(_CustomResults) = Length(Result.CustomModalResults));
  for i := Low(_CustomResults) to High(_CustomResults) do
    Result.CustomModalResults[i] := _CustomResults[i];
  Result.UserMessage := _Message;
  Result.OptionDescription := _OptionDesc;
  Result.DialogType := _DialogType;
  Result.GenerateControls;
  TForm_CenterOn(Result, _Owner);
  Result.FOnButtonClick := _OnButtonClick;
  Result.MakeModal;
  Result.Show;
end;

class function Tf_dzDialog.ShowException(_e: Exception; const _Message: string;
  const _Buttons: array of TDialogButtonEnum; const _OptionDesc: string = ''; _Owner: TWinControl = nil): Integer;
var
  frm: Tf_dzDialog;
{$IFNDEF no_jcl}
  sl: TStringList;
  StackList: TJclStackInfoList;
{$ENDIF}
begin
  frm := Tf_dzDialog.Create(_Owner);
  try
    if Assigned(_Owner) and (_Owner is TForm) then
      frm.Font := TForm(_Owner).Font;
    if Assigned(_e) then begin
      frm.ExceptionClass := _e.ClassName;
      // frm.ExcptionAddress := ExceptAddr;
      frm.ExceptionMessage := _e.Message;
      frm.ExceptionExtendedMessage := _e.Message;
{$IFDEF no_jcl}
      frm.ExceptionProcedure := Format('[%p]', [ExceptAddr]);
{$ELSE no_jcl}
      frm.ExceptionProcedure := GetLocationInfoStr(ExceptAddr);
      sl := TStringList.Create;
      try
        StackList := JclLastExceptStackList;
        if Assigned(StackList) then begin
          StackList.AddToStrings(sl, False, True, True);
          frm.CallStack := sl;
        end;
      finally
        sl.Free;
      end;
{$ENDIF}
    end else
      frm.ShowDetailButton := False;
    frm.SetVisibleButtons(_Buttons);
    frm.UserMessage := _Message;
    frm.OptionDescription := _OptionDesc;
    frm.GenerateControls;
    TForm_CenterOn(frm, _Owner);
    Result := frm.ShowModal;
  finally
    frm.Free;
  end;
end;

class function Tf_dzDialog.ShowException(_e: Exception; const _Buttons: array of TDialogButtonEnum;
  const _OptionDesc: string = ''; _Owner: TWinControl = nil): Integer;
begin
  Result := ShowException(_e, '', _Buttons, _OptionDesc, _Owner);
end;

class function Tf_dzDialog.ShowException(_e: Exception; _Owner: TWinControl = nil): Integer;
begin
  Result := ShowException(_e, '', [dbeOK], '', _Owner);
end;

class function Tf_dzDialog.ShowError(const _ErrorMsg, _Details: string; const _Buttons: array of TDialogButtonEnum;
  const _OptionDesc: string = ''; _Owner: TWinControl = nil): Integer;
var
  frm: Tf_dzDialog;
begin
  frm := Tf_dzDialog.Create(_Owner);
  try
    frm.UserMessage := _ErrorMsg;
    frm.Details := _Details;
    frm.ShowDetailButton := True;
    frm.SetVisibleButtons(_Buttons);
    frm.OptionDescription := _OptionDesc;
    frm.GenerateControls;
    TForm_CenterOn(frm, _Owner);
    Result := frm.ShowModal;
  finally
    frm.Free;
  end;
end;

{ Copied from Dialogs.pas }

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  i: Integer;
  Buffer: array[0..51] of Char;
begin
  for i := 0 to 25 do
    Buffer[i] := Chr(i + Ord('A'));
  for i := 0 to 25 do
    Buffer[i + 26] := Chr(i + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

const
  IconIDs: array[TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND,
    IDI_ASTERISK, IDI_QUESTION, nil);
  ButtonNames: array[TDialogButtonEnum] of string = (// do not translate
    'Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll',
    'YesToAll', 'Help', 'Custom');
  ButtonCaptions: array[TDialogButtonEnum] of string = (
    SMsgDlgYes, SMsgDlgNo, SMsgDlgOK, SMsgDlgCancel, SMsgDlgAbort,
    SMsgDlgRetry, SMsgDlgIgnore, SMsgDlgAll, SMsgDlgNoToAll, SMsgDlgYesToAll,
    SMsgDlgHelp, 'Custom');

  { Tf_dzDialog }

constructor Tf_dzDialog.Create(_Owner: TComponent);
begin
  inherited;
  FFocusButton := 0;
  FDialogType := mtError;
  FShowDetailButton := True;
  FDontShowAgainText := _('Do not show again.');
  FCallStack := TStringList.Create;
  try
    Icon.Handle := ExtractIcon(hInstance, PChar(Application.ExeName), 0);
  except
  end; // FI:W501 - ignore any errors

  TranslateComponent(Self);
end;

destructor Tf_dzDialog.Destroy;
begin
  FCallStack.Free;
  inherited;
end;

procedure Tf_dzDialog.SetCallStack(const _CallStack: TStrings);
begin
  FCallStack.Assign(_CallStack);
end;

procedure Tf_dzDialog.MakeModal;
begin
  FWindowList := DisableTaskWindows(0);
end;

procedure Tf_dzDialog.MakeNonModal;
begin
  EnableTaskWindows(FWindowList);
end;

procedure Tf_dzDialog.GenerateControls;
const
  mcHorzMargin = 8;
  mcVertMargin = 8;
  mcHorzSpacing = 10;
  mcVertSpacing = 10;
  mcButtonWidth = 50;
  mcButtonHeight = 14;
  mcButtonSpacing = 4;

  function CalcTextSize(_Handle: HDC; const _Caption: string; _Format: Integer): TPoint;
  var
    TextRect: TRect;
  begin
    TextRect := Rect(0, 0, 0, 0);
    Windows.DrawText(_Handle, PChar(_Caption), -1, TextRect,
      DT_CALCRECT or _Format);
    Result := TextRect.BottomRight;
  end;

  function CalcMinButtonWidth(_Handle: HDC; const _Caption: string): Integer;
  begin
    Result := CalcTextSize(_Handle, _Caption, DT_LEFT or DT_SINGLELINE or
      DrawTextBiDiModeFlagsReadingOnly).X + 8;
  end;

var
  DialogUnits: TPoint;
  CurButtonWidth,
    ButtonTop,
    ButtonWidth,
    ButtonHeight,
    ButtonSpacing,
    ButtonCount,
    ButtonGroupWidth,
    MinHeight,
    MinWidth: Integer;
  i: Integer;
  X: Integer;
  be,
    DefaultButton,
    CancelButton: TDialogButtonEnum;
  IconID: PChar;
  btn: TButton;
  CustomCount: Integer;
  FocusButton: TButton;
begin
  inherited;
  EnableMenuItem(GetSystemMenu(Handle, LongBool(False)), SC_MAXIMIZE, MF_BYCOMMAND or MF_GRAYED);
  if FUserMessage = '' then
    FUserMessage := Format(_('An error occurred:'#13#10'%s'), [FExceptionMessage]);
  if CallStack.Count > 0 then begin
    FUserMessage := FUserMessage + #13#10
      + #13#10
      + Format(_('Support Info (see Details for more):'#13#10'%s'), [CallStack[0]]);
  end;
  l_Message.Caption := FUserMessage;
  l_Message.AutoSize := True;
  if l_Message.Height > im_Icon.Height then
    MinHeight := l_Message.Top + l_Message.Height
  else
    MinHeight := im_Icon.Top + im_Icon.Height;
  Inc(MinHeight, 8);
  MinWidth := 250; // 400;
  MinWidth := Max(MinWidth, l_Message.Left + l_Message.Width + 8);
  if FOptionDescription = '' then
    l_Options.Visible := False
  else begin
    l_Options.Top := MinHeight;
    l_Options.Caption := FOptionDescription;
    l_Options.AutoSize := True;
    MinHeight := MinHeight + l_Options.Height + 8;
    MinWidth := Max(MinWidth, l_Options.Left + l_Options.Width + 8);
  end;
  if FShowDetailButton then
    if FShowDetailButton and (FDetails = '') then begin
      m_Details.Lines.Text := FUserMessage;
      m_Details.Lines.Add('');
      m_Details.Lines.Add('');
      m_Details.Lines.Add(_('Additional information:'));
      if FExceptionProcedure = '' then
        m_Details.Lines.Add(Format('%s at %p:', [FExceptionClass, FExceptionAddress]))
      else
        m_Details.Lines.Add(Format('%s at %s:', [FExceptionClass, FExceptionProcedure]));
      m_Details.Lines.Add(FExceptionExtendedMessage);

      if CallStack.Count = 0 then
        m_Details.Lines.Add('<call stack not available>')
      else begin
        m_Details.Lines.Add('<begin call stack>');
        m_Details.Lines.AddStrings(CallStack);
        m_Details.Lines.Add('<end call stack>');
      end;
    end else
      m_Details.Lines.Text := FDetails;
  BiDiMode := Application.BiDiMode;
  DialogUnits := GetAveCharSize(Canvas);
  ButtonWidth := MulDiv(mcButtonWidth, DialogUnits.X, 4);
  if FShowDetailButton then
    ButtonWidth := CalcMinButtonWidth(Canvas.Handle, _('&Details >>'));
  CustomCount := 0;
  for i := Low(FVisibleButtons) to High(FVisibleButtons) do begin
    be := FVisibleButtons[i];
    if be = dbeCustom then begin
      CurButtonWidth := CalcMinButtonWidth(Canvas.Handle, FCustomButtonCaptions[CustomCount]);
      Inc(CustomCount);
    end else
      CurButtonWidth := CalcMinButtonWidth(Canvas.Handle, ButtonCaptions[be]);
    if CurButtonWidth > ButtonWidth then
      ButtonWidth := CurButtonWidth;
  end;
  ButtonHeight := MulDiv(mcButtonHeight, DialogUnits.Y, 8);
  ButtonSpacing := MulDiv(mcButtonSpacing, DialogUnits.X, 4);
  IconID := IconIDs[FDialogType];
  im_Icon.Picture.Icon.Handle := LoadIcon(0, IconID);
  ButtonCount := Length(FVisibleButtons);
  if FShowDetailButton then
    ButtonGroupWidth := ButtonWidth + ButtonSpacing
  else
    ButtonGroupWidth := 0;
  if ButtonCount <> 0 then
    ButtonGroupWidth := ButtonGroupWidth + ButtonWidth * ButtonCount
      + ButtonSpacing * (ButtonCount - 1);
  ButtonTop := MinHeight + 8;

  if FShowDontShowAgain then begin
    MinWidth := Max(MinWidth, ButtonGroupWidth + 2 * ButtonSpacing
      + CalcTextSize(Canvas.Handle, FDontShowAgainText,
      DT_LEFT or DT_SINGLELINE or
      DrawTextBiDiModeFlagsReadingOnly).X + CHECKBOX_WIDTH + 8);
  end else
    MinWidth := Max(MinWidth, ButtonGroupWidth + 2 * ButtonSpacing);

  p_Top.Height := MinHeight + ButtonHeight + 16;
  if Self.ClientWidth < MinWidth then
    Self.ClientWidth := MinWidth;
  Self.ClientHeight := p_Top.Height;
  Constraints.MinWidth := Self.Width;
  Constraints.MinHeight := Self.Height;
  Constraints.MaxHeight := Self.Height;
  Caption := Application.Title;
  DefaultButton := dbeRetry;
  CancelButton := dbeOK;
  for i := Low(FVisibleButtons) to High(FVisibleButtons) do begin
    be := FVisibleButtons[i];
    case be of
      dbeOK:
        if DefaultButton in [dbeRetry, dbeYes] then
          DefaultButton := dbeOK;
      dbeYes:
        if DefaultButton = dbeRetry then
          DefaultButton := dbeYes;
      dbeNo:
        if CancelButton = dbeOK then
          CancelButton := dbeNo;
      dbeCancel:
        if CancelButton in [dbeOK, dbeNo] then
          CancelButton := dbeCancel;
      dbeAbort:
        if CancelButton in [dbeOK, dbeNo] then
          CancelButton := dbeAbort;
    end;
  end;
  X := (ClientWidth - ButtonGroupWidth - ButtonSpacing) {div 2};
  CustomCount := 0;
  FocusButton := nil;
  for i := Low(FVisibleButtons) to High(FVisibleButtons) do begin
    be := FVisibleButtons[i];
    btn := TButton.Create(Self);
    btn.Name := ButtonNames[be];
    if be = dbeCustom then
      btn.Name := btn.Name + IntToStr(CustomCount);
    btn.Parent := p_Top;
    if be = dbeCustom then begin
      btn.Caption := FCustomButtonCaptions[CustomCount];
      btn.ModalResult := FCustomModalResults[CustomCount];
      Inc(CustomCount);
    end else begin
      btn.Caption := ButtonCaptions[be];
      btn.ModalResult := ExceptionDialogModalResults[be];
    end;
    if be = DefaultButton then begin
      btn.Default := True;
      FocusButton := btn;
    end;
    if be = CancelButton then
      btn.Cancel := True;
    btn.SetBounds(X, ButtonTop, ButtonWidth, ButtonHeight);
    btn.Anchors := [akTop, akRight];
    btn.OnClick := ButtonClick;
    Inc(X, ButtonWidth + ButtonSpacing);
    if i = FFocusButton then
      FocusButton := btn;
  end;
  if Assigned(FocusButton) then
    ActiveControl := FocusButton;

  if FShowDontShowAgain then begin
    chk_DontAskAgain := TCheckBox.Create(Self);
    chk_DontAskAgain.Name := 'chk_DontAskAgain';
    chk_DontAskAgain.Parent := p_Top;
    chk_DontAskAgain.Width := CalcTextSize(Canvas.Handle, FDontShowAgainText,
      DT_LEFT or DT_SINGLELINE or DrawTextBiDiModeFlagsReadingOnly).X + CHECKBOX_WIDTH;
    chk_DontAskAgain.Left := 8;
    chk_DontAskAgain.Top := ButtonTop + ButtonHeight - chk_DontAskAgain.Height;
    chk_DontAskAgain.Caption := FDontShowAgainText;
  end;

  if FShowDetailButton then begin
    b_Details := TButton.Create(Self);
    b_Details.Name := 'b_Details';
    b_Details.Parent := p_Top;
    b_Details.Caption := _('&Details >>');
    b_Details.SetBounds(X, ButtonTop, ButtonWidth, ButtonHeight);
    b_Details.Anchors := [akTop, akRight];
    b_Details.OnClick := b_DetailsClick;
  end;
end;

procedure Tf_dzDialog.ShowDetails;
var
  SavedStyle: Integer;
begin
  if FShowMaximize = smSmart then begin
    SavedStyle := GetWindowLong(Handle, GWL_STYLE);
    SetWindowLong(Handle, GWL_STYLE, SavedStyle or WS_MAXIMIZEBOX);
  end;
  Constraints.MaxHeight := 0;
  ClientHeight := p_Top.Height + p_Details.Height;
  Constraints.MinHeight := p_Top.Height + 100 + Height - ClientHeight;
  p_Details.Visible := True;
  p_Details.Align := alClient;
  //  EnableMenuItem(GetSystemMenu(Handle, LongBool(false)), SC_MAXIMIZE, MF_BYCOMMAND or MF_ENABLED);
  //  BorderIcons := BorderIcons - [biMaximize];
end;

procedure Tf_dzDialog.HideDetails;
var
  SavedStyle: Integer;
begin
  if FShowMaximize = smSmart then begin
    SavedStyle := GetWindowLong(Handle, GWL_STYLE);
    SetWindowLong(Handle, GWL_STYLE, SavedStyle and not WS_MAXIMIZEBOX);
    if WindowState = wsMaximized then
      WindowState := wsNormal;
  end;
  p_Details.Align := alNone;
  p_Details.Visible := False;
  Constraints.MinHeight := p_Top.Height + Height - ClientHeight;
  Constraints.MaxHeight := Self.Height;
  ClientHeight := p_Top.Height;
  EnableMenuItem(GetSystemMenu(Handle, LongBool(False)), SC_MAXIMIZE, MF_BYCOMMAND or MF_GRAYED);
  //  BorderIcons := BorderIcons - [biMaximize];
end;

procedure Tf_dzDialog.b_DetailsClick(Sender: TObject);
begin
  if p_Details.Visible then begin
    HideDetails;
    b_Details.Caption := _('&Details >>');
  end else begin
    ShowDetails;
    b_Details.Caption := _('&Details <<');
  end;
end;

procedure Tf_dzDialog.SetDontShowAgainText(const _Value: string);
begin
  FDontShowAgainText := _Value;
  FShowDontShowAgain := FDontShowAgainText <> '';
end;

procedure Tf_dzDialog.SetFocusButton(_ButtonIndex: Integer);
begin
  FFocusButton := _ButtonIndex;
end;

procedure Tf_dzDialog.SetVisibleButtons(const _Buttons: array of TDialogButtonEnum);
var
  i: Integer;
  CustomCount: Integer;
begin
  CustomCount := 0;
  SetLength(FVisibleButtons, Length(_Buttons));
  for i := Low(_Buttons) to High(_Buttons) do begin
    FVisibleButtons[i] := _Buttons[i];
    if _Buttons[i] = dbeCustom then
      Inc(CustomCount);
  end;
  SetLength(FCustomModalResults, CustomCount);
  SetLength(FCustomButtonCaptions, CustomCount);
end;

procedure Tf_dzDialog.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if Assigned(Owner) and (Owner is TWinControl) then
    Params.WndParent := (Owner as TWinControl).Handle;
  if FShowMaximize = smShow then
    Params.Style := Params.Style or WS_MAXIMIZEBOX;
end;

procedure Tf_dzDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent(Self);
end;

procedure Tf_dzDialog.Hide;
begin
  MakeNonModal;
  inherited Hide;
end;

procedure Tf_dzDialog.ButtonClick(_Sender: TObject);
var
  Action: TCloseAction;
begin
  Action := caNone;
  if Assigned(FOnButtonClick) then
    FOnButtonClick(Self, (_Sender as TButton).ModalResult, Action);
  case Action of
    caHide:
      Hide;
    caFree:
      Release;
    caMinimize:
      WindowState := wsMinimized;
  end;
end;

{$IFNDEF no_jcl}
initialization
  // Enable raw mode (default mode uses stack frames which aren't always generated by the compiler)
  Include(JclStackTrackingOptions, stRawMode);
  // Disable stack tracking in dynamically loaded modules (it makes stack tracking code a bit faster)
  Include(JclStackTrackingOptions, stStaticModuleList);
  // Initialize Exception tracking
  JclStartExceptionTracking;
finalization
  JclStopExceptionTracking;
{$ENDIF}
end.
