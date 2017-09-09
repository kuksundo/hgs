unit uGlobal;

{-------------------------------------------------------------------------------
POPTRAY
Copyright (C) 2001-2005  Renier Crause
All Rights Reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

The GNU GPL can be found at:
  http://www.gnu.org/copyleft/gpl.html
-------------------------------------------------------------------------------}

interface

uses Classes, ExtCtrls, Contnrs, SysUtils, Graphics;
// Avoid internal dependencies in this class so other classes are testable.

type
  DefaultTabType = ( TAB_LAST_USED=-1, TAB_HTML=0, TAB_PLAIN_TEXT=2, TAB_RAW=3);
  SpecialImapFolders = ( SPAM_FOLDER=1, TRASH_FOLDER=2, ARCHIVE_FOLDER=3);

const
  APPTITLE = 'PopTrayU';

var
  DebugOptions : record
    ProtocolLogging : boolean;
  end;

  Options : record
    Busy : boolean;
    // interval
    TimerAccount : boolean;
    Interval : real;
    // defaults
    MailProgram : string;
    DefSound : string;
    Languages : array of string; // names of all available languages IN ENGLILSH.
    Language : integer; // language currently in use (indexed into languages array)
    // general options
    StartUp : boolean;
    Minimized : boolean;
    Animated : boolean;
    ResetTray : boolean;
    RotateIcon : boolean;
    ShowForm : boolean;
    Balloon : boolean;
    FirstWait : integer;
    DeleteNextCheck : boolean;
    // advanced - connection
    TimeOut : integer;
    QuickCheck : boolean;
    CheckWhileMinimized : boolean;
    IgnoreRetrieveErrors : boolean;
    ShowErrorsInBalloons : boolean;
    Online : boolean;
    TopLines : integer;
    GetBody : boolean;
    PreferEnvelopes : boolean;
    GetBodyLines : integer;
    GetBodySize : integer;
    // advanced - main window
    CheckingIcon : integer;
    ShowViewed : boolean;
    CloseMinimize : boolean;
    MinimizeTray : boolean;
    NoError : boolean;
    MultilineAccounts : boolean;
    DeleteConfirm : boolean;
    DeleteConfirmProtected : boolean;
    PasswordProtect : boolean;
    Password : string;
    OnTop : boolean;
    AdvInfo : boolean;
    AdvInfoDelay : integer;
    HideViewed : boolean;
    DoubleClickDelay : boolean;
    ShowWhileChecking : boolean;
    ToolbarSpamAction : integer;
    AutoClosePreviewWindows : boolean;
    // advanced - misc
    UseMAPI : boolean;
    LogRules : boolean;
    SafeDelete : boolean;
    RememberViewed : boolean;
    BlackListSpam : boolean;
    DontCheckTimes : boolean;
    DontCheckStart : TTime;
    DontCheckEnd : TTime;
    // Spam
    DowloadFullMsgForPreview : boolean;
    // mouse buttons
    LeftClick : integer;
    RightClick : integer;
    MiddleClick : integer;
    DblClick : integer;
    ShiftLeftClick : integer;
    ShiftRightClick : integer;
    ShiftMiddleClick : integer;
    // hot keys
    Action1 : integer;
    Action2 : integer;
    Action3 : integer;
    Action4 : integer;
    HotKey1 : integer;
    HotKey2 : integer;
    HotKey3 : integer;
    HotKey4 : integer;
    // white list / black list
    WhiteList : TStringList;
    BlackList : TStringList;
    // info
    InfoTab : integer;
    InfoCol1 : integer;
    InfoCol2 : integer;
    InfoCol3 : integer;
    InfoCol4 : integer;
    // visual appearance
    ListboxFont : TFont;
    ListboxBg : TColor;
    GlobalFont : TFont;
    VerticalFont : TFont;
    UseCustomFonts : boolean;
    DefaultFont : integer;
    ToolbarColorScheme : integer;
    VisualStyleFilename : string;
    UseCustomDateFormat : boolean;
    CustomDateFormatString : string;
    //preview
    DisableHtmlPreview: boolean;
    PreviewFont : TFont;
    DefaultPreviewTab : DefaultTabType;
    DefaultSpamTab : DefaultTabType;
    ShowImages : boolean;
    PreviewBgColor : TColor;
    ShowXMailer : boolean;
    //misc
    TempEmailFilename : string; //includes extension
    ShowNewestMessagesOnly : boolean;
    NumNewestMsgToShow : integer;
    Use24HrTime : boolean;
  end;

  HelpFileName : TFileName; // Path+filename to the Help File

type
  TOptionsPanelName = (
    optNone = -1,
    optDefaults = 0,
    optInterval = 1,
    optGeneralOptions = 2,
    optMainWindow = 3,
    optPreview = 4,
    optRules = 5,
    optWhiteBlackList = 6,
    optVisualAppearance = 7,
    optMouseButtons = 8,
    optHotKeys = 9,
    optAdvancedOptions = 10//,
    //optPlugins = 11
    );

const
  // checking icon
  ciNone = 0;
  ciLightning = 1;
  ciStar = 2;
  ciAnimatedStar = 3;

  // options
{  optDefaults = 0;
  optInterval = 1;
  optGeneralOptions = 2;
  optAdvancedOptions = 3;
  optAdvancedInterface = 4;
  optAdvancedMisc = 5;
  optMouseButtons = 6;
  optHotKeys = 7;
  optWhiteBlackList = 8;
  optPlugins = 9;
  optVisualAppearance = 10; }

  // Spam Actions
  optSpamActNone = 0;
  optSpamActDelSpam = 1;
  optSpamActMarkSpam = 2;

  // Toolbar Color Schemes
  schemeLight = 0;
  schemeDark = 1;




const
  Actions : array[0..15] of string =
    ('Nothing','Show Messages','Pop-Up Menu','Check for Mail',
     'Run E-Mail Client','Check and Show','Show Info','Check and Info',
     'Toggle Message Window','Toggle AutoCheck','New Message',
     'Toggle Sound','Delete Spam','Mark as Viewed','Check First Account',
     'Stop Checking');

type
  TCommand = (cmdNothing,cmdShow,cmdMenu,cmdCheck,
              cmdRun,cmdCheckShow,cmdInfo,cmdCheckInfo,
              cmdToggleShow,cmdToggleAutoCheck,cmdNewMessage,
              cmdToggleSound, cmdDeleteSpam, cmdMarkViewed,
              cmdCheckFirst, cmdStopChecking,
              // extra commands
              cmdAutoCheckOn,cmdAutoCheckOff,cmdSoundOn,cmdSoundOff);

function StrToAction(st: string): TCommand;

var
  FBusy : boolean;

implementation

function StrToAction(st: string): TCommand;
begin
  st := UpperCase(st);
  Result := cmdNothing;
  if st = 'SHOW' then Result := cmdShow
  else if st = 'MENU' then Result := cmdMenu
  else if st = 'CHECK' then Result := cmdCheck
  else if st = 'CHECKALL' then Result := cmdCheck
  else if st = 'RUNCLIENT' then Result := cmdRun
  else if st = 'CHECKSHOW' then Result := cmdCheckShow
  else if st = 'INFO' then Result := cmdInfo
  else if st = 'CHECKINFO' then Result := cmdCheckInfo
  else if st = 'WINDOW' then Result := cmdToggleShow
  else if st = 'AUTOCHECK' then Result := cmdToggleAutoCheck
  else if st = 'NEW' then Result := cmdNewMessage
  else if st = 'SOUND' then Result := cmdToggleSound
  else if st = 'DELSPAM' then Result := cmdDeleteSpam
  else if st = 'MARKVIEWED' then Result := cmdMarkViewed
  else if st = 'STOPCHECKING' then Result := cmdStopChecking
  else if st = 'AUTOCHECKON' then Result := cmdAutoCheckOn
  else if st = 'AUTOCHECKOFF' then Result := cmdAutoCheckOff
  else if st = 'SOUNDON' then Result := cmdSoundOn
  else if st = 'SOUNDOFF' then Result := cmdSoundOff
end;


initialization
  Options.WhiteList := TStringList.Create;
  Options.BlackList := TStringList.Create;
  Options.GlobalFont := TFont.Create;
  Options.VerticalFont := TFont.Create;
  Options.ListboxFont := TFont.Create;
  Options.PreviewFont := TFont.Create;

finalization
  Options.WhiteList.Free;
  Options.BlackList.Free;
  Options.GlobalFont.Free;
  Options.VerticalFont.Free;
  Options.ListboxFont.Free;
  Options.PreviewFont.Free
end.
