unit _DefaultPlugIn;

interface

uses   Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Menus,
  ActnList,
  StdCtrls,
  Buttons,
  ExtCtrls,
  iniFiles,
  Mask,
  Grids,
  FileCtrl,
  Gauges,
  ColorGrd,
  Spin,
  Outline,
  DirOutln,
  Calendar,
  CheckLst,
  Tabs,
  TabNotbk,
  ImgList,
  ComCtrls,
  ToolWin,
  StdActns,
  MPlayer,
  PlugInBase;

type
  TpjhDefaultPlugIn = class (TBasePlugIn)
  protected
  public
    function GetPlugInName:string; override;
    // the functions below should be taken from base class and
    // overriden, so that functions would work...
    function ProcessFile(FileName:string):string; override;
    procedure RegisterDefaultComponent;override;
  end;

  TpjhDefaultPlugIn2 = class (TBasePlugIn)
  protected
  public
    function GetPlugInName:string; override;
    // the functions below should be taken from base class and
    // overriden, so that functions would work...
    function ProcessFile(FileName:string):string; override;
    procedure RegisterDefaultComponent;override;
  end;

procedure RegisterDefaultComponent;
procedure UnRegisterDefaultComponent;

implementation

// 폼 파일에 있는 컴퍼넌트의 클래스를 등록한다.
procedure RegisterDefaultComponent;
begin
    RegisterClasses([TForm               , TButton           //, TMainMenu,
                     {TPopupMenu}          , TLabel            , TEdit,
                     TMemo               , TRadioButton      , TCheckBox,
                     TListBox            , TComboBox         , TScrollBar,
                     TGroupBox           , TRadioGroup       , TPanel,
                     TBitBtn             , TSpeedButton      , TMaskEdit,
                     TStringGrid         , TImage            , TShape,
                     TBevel              , TScrollBox        , TTabControl,
                     TPageControl        , TTreeView         , TListView,
                     TImageList          , THeaderControl    , TRichEdit,
                     TStatusBar          , TTrackBar         , TProgressBar,
                     TUpDown             , THotKey           , //TTable,
                     //TQuery              , TDataSource       , TStoredProc,
                     //TDatabase           , TSession          , TBatchMove,
                     //TUpdateSQL          , TDBGrid           , TDBNavigator,
                     //TDBText             , TDBEdit           , TDBMemo,
                     //TDBImage            , TDBListBox        , TDBComboBox,
                     //TDBCheckBox         , TDBRadioGroup     , TDBLookupListBox,
                     //TDBLookupComboBox   , TDBCtrlGrid       , TDBRichedit,
                     //TDBLookupList       , TDBLookupCombo    , TTimer,
                     TPaintBox           , TFileListBox      , TDirectoryListBox,
                     TDriveComboBox      , TFilterComboBox   , TMediaPlayer,
                     TGauge              , TColorGrid        , TSpinButton,
                     TSpinEdit           , TDirectoryOutline , TCalendar,
                     {TWrapperControl     , TOpenDialog       ,} TTabSheet,
                     {TSaveDialog         , TFontDialog       ,} TToolBar,
                     TCoolBar            , TToolButton       , {TPrintDialog,}
                     TAnimate            , TNotebook         , {TFindDialog,
                     TReplaceDialog      , TOpenPictureDialog, TSavePictureDialog,
                     TPrinterSetupDialog , TColorDialog     ,} TCheckListBox,
                     TSplitter           , TStaticText       , TDatetimePicker,
                     //TOleContainer       , TDdeClientConv    , TDdeClientItem,
                     {TDdeServerConv      , TDdeServerItem    ,} TTabSet,
                     TOutline            , TTabbedNotebook   , THeader
                     ]);
end;

// 폼 파일에 있는 컴퍼넌트의 클래스를 등록한다.
procedure UnRegisterDefaultComponent;
begin
    UnRegisterClasses([TForm               , TButton           //, TMainMenu,
                     {TPopupMenu}          , TLabel            , TEdit,
                     TMemo               , TRadioButton      , TCheckBox,
                     TListBox            , TComboBox         , TScrollBar,
                     TGroupBox           , TRadioGroup       , TPanel,
                     TBitBtn             , TSpeedButton      , TMaskEdit,
                     TStringGrid         , TImage            , TShape,
                     TBevel              , TScrollBox        , TTabControl,
                     TPageControl        , TTreeView         , TListView,
                     TImageList          , THeaderControl    , TRichEdit,
                     TStatusBar          , TTrackBar         , TProgressBar,
                     TUpDown             , THotKey           , //TTable,
                     //TQuery              , TDataSource       , TStoredProc,
                     //TDatabase           , TSession          , TBatchMove,
                     //TUpdateSQL          , TDBGrid           , TDBNavigator,
                     //TDBText             , TDBEdit           , TDBMemo,
                     //TDBImage            , TDBListBox        , TDBComboBox,
                     //TDBCheckBox         , TDBRadioGroup     , TDBLookupListBox,
                     //TDBLookupComboBox   , TDBCtrlGrid       , TDBRichedit,
                     //TDBLookupList       , TDBLookupCombo    , TTimer,
                     TPaintBox           , TFileListBox      , TDirectoryListBox,
                     TDriveComboBox      , TFilterComboBox   , TMediaPlayer,
                     TGauge              , TColorGrid        , TSpinButton,
                     TSpinEdit           , TDirectoryOutline , TCalendar,
                     {TWrapperControl     , TOpenDialog       ,} TTabSheet,
                     {TSaveDialog         , TFontDialog       ,} TToolBar,
                     TCoolBar            , TToolButton       , {TPrintDialog,}
                     TAnimate            , TNotebook         , {TFindDialog,
                     TReplaceDialog      , TOpenPictureDialog, TSavePictureDialog,
                     TPrinterSetupDialog , TColorDialog     ,} TCheckListBox,
                     TSplitter           , TStaticText       , TDatetimePicker,
                     //TOleContainer       , TDdeClientConv    , TDdeClientItem,
                     {TDdeServerConv      , TDdeServerItem    ,} TTabSet,
                     TOutline            , TTabbedNotebook   , THeader
                     ]);
end;

{ TpjhDefaultPlugIn }

function TpjhDefaultPlugIn.GetPlugInName: string;
begin
  Result := '디폴트 컴포넌트';
end;

function TpjhDefaultPlugIn.ProcessFile(FileName: string): string;
begin
  Result := '';
end;

// 폼 파일에 있는 컴퍼넌트의 클래스를 등록한다.
procedure TpjhDefaultPlugIn.RegisterDefaultComponent;
begin
    RegisterClasses([TForm               , TButton           //, TMainMenu,
                     {TPopupMenu}          , TLabel            , TEdit,
                     TMemo               , TRadioButton      , TCheckBox,
                     TListBox            , TComboBox         , TScrollBar,
                     TGroupBox           , TRadioGroup       , TPanel,
                     TBitBtn             , TSpeedButton      , TMaskEdit,
                     TStringGrid         , TImage            , TShape,
                     TBevel              , TScrollBox        , TTabControl,
                     TPageControl        , TTreeView         , TListView,
                     TImageList          , THeaderControl    , TRichEdit,
                     TStatusBar          , TTrackBar         , TProgressBar,
                     TUpDown             , THotKey           , //TTable,
                     //TQuery              , TDataSource       , TStoredProc,
                     //TDatabase           , TSession          , TBatchMove,
                     //TUpdateSQL          , TDBGrid           , TDBNavigator,
                     //TDBText             , TDBEdit           , TDBMemo,
                     //TDBImage            , TDBListBox        , TDBComboBox,
                     //TDBCheckBox         , TDBRadioGroup     , TDBLookupListBox,
                     //TDBLookupComboBox   , TDBCtrlGrid       , TDBRichedit,
                     //TDBLookupList       , TDBLookupCombo    , TTimer,
                     TPaintBox           , TFileListBox      , TDirectoryListBox,
                     TDriveComboBox      , TFilterComboBox   , TMediaPlayer,
                     TGauge              , TColorGrid        , TSpinButton,
                     TSpinEdit           , TDirectoryOutline , TCalendar,
                     {TWrapperControl     , TOpenDialog       ,} TTabSheet,
                     {TSaveDialog         , TFontDialog       ,} TToolBar,
                     TCoolBar            , TToolButton       , {TPrintDialog,}
                     TAnimate            , TNotebook         , {TFindDialog,
                     TReplaceDialog      , TOpenPictureDialog, TSavePictureDialog,
                     TPrinterSetupDialog , TColorDialog     ,} TCheckListBox,
                     TSplitter           , TStaticText       , TDatetimePicker,
                     //TOleContainer       , TDdeClientConv    , TDdeClientItem,
                     {TDdeServerConv      , TDdeServerItem    ,} TTabSet,
                     TOutline            , TTabbedNotebook   , THeader
                     ]);
end;

{ TpjhDefaultPlugIn2 }

function TpjhDefaultPlugIn2.GetPlugInName: string;
begin
  Result := 'Test';
end;

function TpjhDefaultPlugIn2.ProcessFile(FileName: string): string;
begin
  Result := '';
end;

procedure TpjhDefaultPlugIn2.RegisterDefaultComponent;
begin
  ;
end;

initialization
  RegisterDefaultComponent;

finalization
  UnRegisterDefaultComponent;
end.
