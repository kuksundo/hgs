{*******************************************************}
{                                                       }
{              MIB II Monitor Version 2.3               }
{                                                       }
{          Copyright (c) 1999-2016 Vadim Crits          }
{                                                       }
{*******************************************************}

unit MrMain;

{$B-}
{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ActnList, StdActns, ImgList, NetBase;

type
  TMainForm = class(TBaseForm)
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miWindow: TMenuItem;
    ImageList: TImageList;
    ActionList: TActionList;
    actNew: TAction;
    actSave: TAction;
    actSaveAs: TAction;
    actExit: TAction;
    actCascade: TWindowCascade;
    actTileHorizontal: TWindowTileHorizontal;
    actTileVertical: TWindowTileVertical;
    actMinimizeAll: TWindowMinimizeAll;
    actArrangeIcons: TWindowArrange;
    actAbout: TAction;
    miCascade: TMenuItem;
    miTileHorizontally: TMenuItem;
    miTileVertically: TMenuItem;
    miMinimizeAll: TMenuItem;
    miArrangeAll: TMenuItem;
    miHelp: TMenuItem;
    miAbout: TMenuItem;
    miNew: TMenuItem;
    N1: TMenuItem;
    miExit: TMenuItem;
    actOptions: TAction;
    miOptions: TMenuItem;
    miSave: TMenuItem;
    N2: TMenuItem;
    miSaveAs: TMenuItem;
    actClose: TWindowClose;
    Close1: TMenuItem;
    N3: TMenuItem;
    actCloseAll: TAction;
    miCloseAll: TMenuItem;
    N4: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actCloseAllExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
  private
    { Private declarations }
    FFileName: string;
    procedure MkFile(const FileName: string; CreationFlag: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Community: string = 'public';
  TimeOut: Integer = 1000;
  Retries: Integer = 1;

implementation

uses MrOpts, MrChild, MrConst, NetConst, NetAbout;

{$R *.dfm}

var
  ChildNo: Cardinal = 0;
  
procedure TMainForm.FormCreate(Sender: TObject);
begin
  with Registry do
    if OpenKey(ApplicationKey, False) then
    try
      if ValueExists(SCommunity) then
        Community := ReadString(SCommunity);
      if ValueExists(STimeOut) then
        TimeOut := ReadInteger(STimeOut);
      if ValueExists(SRetries) then
        Retries := ReadInteger(SRetries);
    finally
      CloseKey;
    end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  with Registry do
    if OpenKey(ApplicationKey, True) then
    try
      WriteString(SCommunity, Community);
      WriteInteger(STimeOut, TimeOut);
      WriteInteger(SRetries, Retries);
    finally
      CloseKey;
    end;
end;

procedure TMainForm.actNewExecute(Sender: TObject);
begin
  Application.CreateForm(TChildForm, ChildForm);
  Inc(ChildNo);
  ChildForm.Caption := Format('%s%u', [SUntitled, ChildNo]);
end;

procedure TMainForm.actSaveExecute(Sender: TObject);
begin
  if (FFileName = '') or not FileExists(FFileName) then
    actSaveAsExecute(Sender)
  else
    MkFile(FFileName, False);
end;

procedure TMainForm.actSaveAsExecute(Sender: TObject);
begin
  with TSaveDialog.Create(Self) do
  try
    Options := [ofEnableSizing, ofOverwritePrompt];
    DefaultExt := SDefExt;
    if FFileName = '' then
      FileName := '*' + DefaultExt
    else
      FileName := FFileName;
    Filter := Format(SFileFilter, [DefaultExt, DefaultExt]);
    if Execute then
    begin
      MkFile(FileName, True);
      FFileName := FileName;
    end;
  finally
    Free;
  end;
end;

procedure TMainForm.actOptionsExecute(Sender: TObject);
begin
  ShowOptionsDialog(Self, Community, TimeOut, Retries);
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.actCloseAllExecute(Sender: TObject);
var
  I: Integer;
begin
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].Close;
end;

procedure TMainForm.actAboutExecute(Sender: TObject);
begin
  ShowAboutDialog(Self);
end;

procedure TMainForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actCloseAll.Enabled := MDIChildCount > 0;
  actSave.Enabled := actCloseAll.Enabled and
    (TChildForm(ActiveMDIChild).ActiveLevel in
    [alSystemInfo, alNicTable..alConnTable, alIfStat..alUdpStat]);
  actSaveAs.Enabled := actSave.Enabled;
end;

procedure TMainForm.MkFile(const FileName: string; CreationFlag: Boolean);
var
  F: TextFile;
  SaveCursor: TCursor;
  FmtStr: string;
  I: Integer;
begin
  AssignFile(F, FileName);
  if CreationFlag then
    Rewrite(F)
  else
    Reset(F);
  SaveCursor := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    Append(F);
    Writeln(F);
    with TChildForm(ActiveMDIChild), ListView do
    begin
      if ActiveLevel = alSystemInfo then
        FmtStr := SSysInfo
      else
        with TreeView.Selected do
          FmtStr := Text + ' ' + Parent.Text;
      Writeln(F, Format(SAgent, [Caption, FmtStr, FormatDateTime(
        {$IF CompilerVersion > 22}FormatSettings.{$IFEND}ShortDateFormat + ' ' +
        {$IF CompilerVersion > 22}FormatSettings.{$IFEND}LongTimeFormat, Now)]));
      Writeln(F);  
      case ActiveLevel of
        alSystemInfo:
          begin
            FmtStr := '%-11s %-255s%';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption]));
            Writeln(F, StringOfChar('=', 17));
            for I := 0 to Items.Count - 1 do
              if Items[I].ImageIndex = 0 then
                Writeln(F, Format(FmtStr, [Items[I].Caption,
                                  Items[I].SubItems[0]]));
          end;
        alNicTable:
          begin
            FmtStr := '%-80s %-17s %25s %9s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption,
                                       Columns[3].Caption]));
            Writeln(F, StringOfChar('=', 134));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1],
                                         Items[I].SubItems[2]]));
          end;
        alArpTable:
          begin
            FmtStr := '%-15s %-17s %9s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption]));
            Writeln(F, StringOfChar('=', 43));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1]]));
          end;
        alIpAddrTable:
          begin
            FmtStr := '%-15s %-15s %9s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption]));
            Writeln(F, StringOfChar('=', 41));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1]]));
          end;
        alRouteTable:
          begin
            FmtStr := '%-19s %-15s %-15s %9s %9s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption,
                                       Columns[3].Caption,
                                       Columns[4].Caption]));
            Writeln(F, StringOfChar('=', 71));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1],
                                         Items[I].SubItems[2],
                                         Items[I].SubItems[3]]));
          end;
        alConnTable:
          begin
            FmtStr := '%-8s %-21s %-21s %-12s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption,
                                       Columns[3].Caption]));
            Writeln(F, StringOfChar('=', 65));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1],
                                         Items[I].SubItems[2]]));
          end;
        alIfStat:
          begin
            FmtStr := '%-21s %25s %25s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption]));
            Writeln(F, StringOfChar('=', 73));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1]]));
          end;
        alIpStat:
          begin
            FmtStr := '%-33s %25s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption]));
            Writeln(F, StringOfChar('=', 59));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0]]));
          end;
        alIcmpStat:
          begin
            FmtStr := '%-23s %25s %25s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption,
                                       Columns[2].Caption]));
            Writeln(F, StringOfChar('=', 75));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0],
                                         Items[I].SubItems[1]]));
          end;
        alTcpStat:
          begin
            FmtStr := '%-26s %25s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption]));
            Writeln(F, StringOfChar('=', 52));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0]]));
          end;
        alUdpStat:
          begin
            FmtStr := '%-18s %25s';
            Writeln(F, Format(FmtStr, [Columns[0].Caption,
                                       Columns[1].Caption]));
            Writeln(F, StringOfChar('=', 44));
            for I := 0 to Items.Count - 1 do
              Writeln(F, Format(FmtStr, [Items[I].Caption,
                                         Items[I].SubItems[0]]));
          end;
      end;
    end;
  finally
    CloseFile(F);
    Screen.Cursor := SaveCursor;
  end;
end;

end.