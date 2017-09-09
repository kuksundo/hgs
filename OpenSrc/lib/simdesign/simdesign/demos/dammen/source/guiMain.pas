unit guiMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ComCtrls,

  // game code
  DammenConfig, DammenEval, GameCheck, GameConst, guiGamePaint, sdPaintHelper;


type

  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    mnuLevel: TMenuItem;
    mnuGame: TMenuItem;
    mnuFlow: TMenuItem;
    mnuOptions: TMenuItem;
    mnuMode: TMenuItem;
    mnuHelp: TMenuItem;
    mnuLoad: TMenuItem;
    mnuSave: TMenuItem;
    mnuNew: TMenuItem;
    Break1: TMenuItem;
    mnuNewStd: TMenuItem;
    Break2: TMenuItem;
    mnuExportText: TMenuItem;
    mnuExportBitmap: TMenuItem;
    Break3: TMenuItem;
    mnuClose: TMenuItem;
    mnuBeginner: TMenuItem;
    mnuLevel2: TMenuItem;
    mnuLevel3: TMenuItem;
    mnuLevel4: TMenuItem;
    mnuLevel5: TMenuItem;
    mnuExpert: TMenuItem;
    mnuMoveNow: TMenuItem;
    mnuHint: TMenuItem;
    mnuMoveBack: TMenuItem;
    Break4: TMenuItem;
    mnuPause: TMenuItem;
    mnuAnalysis: TMenuItem;
    mnuNotation: TMenuItem;
    mnuFields: TMenuItem;
    mnuSound: TMenuItem;
    mnuClock: TMenuItem;
    mnuOverview: TMenuItem;
    mnuReversed: TMenuItem;
    mnuTime: TMenuItem;
    mnuModeNormal: TMenuItem;
    mnuModeReplay: TMenuItem;
    mnuModeInsert: TMenuItem;
    mnuHelpManual: TMenuItem;
    mnuHelpGame: TMenuItem;
    Break5: TMenuItem;
    mnuAbout: TMenuItem;
    StatusBar: TStatusBar;
    mnuSaveAs: TMenuItem;
    procedure mnuCloseClick(Sender: TObject);
    procedure DambordBoxPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure InitVars;
  public
    { Public declarations }
    FStartStelling: TField;
    FStelling: TField;
    procedure DisplayHint(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.mnuCloseClick(Sender: TObject);
begin
  if MessageDlg('Hiermee beëindigt u '+ cProgName,
     mtWarning, mbOkCancel, 0) = mrOK then
    Close;
end;

procedure TMainForm.DambordBoxPaint(Sender: TObject);
begin
//  DambordBox.Canvas.Draw(0, 0, bmpDambord);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitTeken;

  // board bitmap
//  bmpDambord := TBitmap.Create;
//  bmpDambord.LoadFromFile('..\resource\dambord.bmp');

  // title
  Caption := cProgName;

  // evaluation
//  TEvalThread.Create;
  Application.OnHint := DisplayHint;
end;

procedure TMainForm.DisplayHint(Sender: TObject);
begin
  StatusBar.SimpleText := Application.Hint;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
//  bmpDambord.Free;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  // setup the DOS canvas
  DOSCanvas := Canvas;

  // background
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clTeal;
    FillRect(Rect(0, 0, ClientWidth, ClientHeight));
  end;

  // game
  TekenScherm;
  //TekenDambord;
end;

procedure TMainForm.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  // this avoids the automatic erase
  Message.Result := integer(False);
end;

procedure TMainForm.InitVars;
var
  x,y: integer;
  h,m,s,sh: word;
  T1,T2: real;
begin
  FStartStelling := TField.Create(fldStandard);
  FStelling := TField.Create(FStartStelling.Fields);
{  Eval:=nil;
  EvPers:=nil;
  Reg:=nil;
  StdNames[1]:='Computer';
  StdNames[2]:='Persoon';
  Partij[1].Typ:=2;
  Partij[1].Name:=StdNames[2];
  Partij[2].Typ:=1;
  Partij[2].Name:=StdNames[1];
  Niveau:=2;
  Randomize;
  InitTeken;
  Conf:=cfInit;
  UseSound:=GetConf(cfSound);
  Refr:=rfInit;
  Mode:=mdInit;
  Game.Phase:=phInit;
  Game.Descr:='';
  for x:=1 to 2 do
  begin
    Tijd[x].Init(0,0,0,0,false);
    Tijd[x].Halt;
  end;
  Replay.Init;
  DefFileName:='SPEL01';}
end;

end.
