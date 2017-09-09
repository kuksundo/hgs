{*******************************************************}
{                                                       }
{           IP Connections Client Version 1.3           }
{                                                       }
{          Copyright (c) 1999-2016 Vadim Crits          }
{                                                       }
{*******************************************************}

unit CltMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, ImgList, Menus, NetBase;

type
  TMainForm = class(TBaseForm)
    ActionList: TActionList;
    lvServers: TListView;
    StatusBar: TStatusBar;
    ImageList: TImageList;
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miView: TMenuItem;
    miHelp: TMenuItem;
    actExit: TAction;
    miExit: TMenuItem;
    miWindow: TMenuItem;
    miNoWindows: TMenuItem;
    actAbout: TAction;
    miAbout: TMenuItem;
    actStatusBar: TAction;
    miStatusBar: TMenuItem;
    miServer: TMenuItem;
    actAdd: TAction;
    actRemove: TAction;
    miAdd: TMenuItem;
    miRemove: TMenuItem;
    PopupMenu: TPopupMenu;
    piAdd: TMenuItem;
    piRemove: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvServersDblClick(Sender: TObject);
    procedure lvServersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miWindowClick(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actStatusBarExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actRemoveExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
  private
    { Private declarations }
    procedure ReadServerList;
    procedure WriteServerList;
    procedure UpdateStatus;
    procedure WindowClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses CltConn, CltNewSv, CSConst, NetConst, NetAbout;

{$R *.dfm}

procedure TMainForm.ReadServerList;
var
  List: TStrings;
  I: Integer;
begin
  with Registry do
    if OpenKey(ApplicationKey + SL_KEY, False) then
    try
      List := TStringList.Create;
      try
        GetKeyNames(List);
        with lvServers do
          for I := 0 to List.Count - 1 do
          begin
            with Items.Add do
            begin
              ImageIndex := 0;
              Caption := List[I];
            end;
            if not Assigned(ItemFocused) then
              Items[0].Focused := True;
          end;
        UpdateStatus;
      finally
        List.Free;
      end;
    finally
      CloseKey;
    end;
end;

procedure TMainForm.WriteServerList;
var
  List: TStrings;
  I, J: Integer;
begin
  with Registry do
    if OpenKey(ApplicationKey + SL_KEY, True) then
    try
      List := TStringList.Create;
      try
        GetKeyNames(List);
        with lvServers do
        begin
          for I := 0 to Items.Count - 1 do
          begin
            for J := 0 to List.Count - 1 do
              if Items[I].Caption = List[J] then
                Break;
            if J > List.Count - 1 then
              CreateKey(ApplicationKey + SL_KEY + Items[I].Caption);
          end;
          for I := 0 to List.Count - 1 do
          begin
            for J := 0 to Items.Count - 1 do
              if List[I] = Items[J].Caption then
                Break;
            if J > Items.Count - 1 then
              DeleteKey(ApplicationKey + SL_KEY + List[I]);
          end;
        end;
      finally
        List.Free;
      end;
    finally
      CloseKey;
    end;
end;

procedure TMainForm.UpdateStatus;
begin
  StatusBar.SimpleText := Format(SAvailableServers, [lvServers.Items.Count]);
end;

procedure TMainForm.WindowClick(Sender: TObject);
var
  hWindow: HWND;
begin
  hWindow := (Sender as TComponent).Tag;
  if IsIconic(hWindow) then
    ShowWindow(hWindow, SW_RESTORE)
  else
    Windows.SetFocus(hWindow);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  with Registry do
  begin
    if OpenKey(ApplicationKey, False) then
    try
      if ValueExists(SShowStatusBar) then
        StatusBar.Visible := ReadBool(SShowStatusBar);
    finally
      CloseKey;
    end;
    ReadServerList;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  with Registry do
  begin
    if OpenKey(ApplicationKey, True) then
    try
      WriteBool(SShowStatusBar, StatusBar.Visible);
    finally
      CloseKey;
    end;
    WriteServerList;
  end;
end;

procedure TMainForm.lvServersDblClick(Sender: TObject);
var
  I: Integer;
begin
  with lvServers do
  begin
    if not Assigned(Selected) then
      Exit;
    with Screen do
      for I := 0 to FormCount - 1 do
        if AnsiSameText(Forms[I].Caption, Selected.Caption) then
        begin
          if Forms[I].WindowState = wsMinimized then
            ShowWindow(Forms[I].Handle, SW_RESTORE)
          else
            Forms[I].SetFocus;
          Exit;
        end;
    with TConnForm.Create(Self, Selected.Caption) do Show;
  end;
end;

procedure TMainForm.lvServersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    lvServersDblClick(Sender)
  else if (Key = VK_F2) and Assigned(lvServers.Selected) then
    lvServers.Selected.EditCaption;  
end;

procedure TMainForm.miWindowClick(Sender: TObject);
var
  I: Integer;
  MenuItem: TMenuItem;
begin
  with miWindow do
    for I := Count - 1 downto 0  do
      if Items[I] <> miNoWindows then
        Items[I].Free;
  with Screen do
    for I := 0 to FormCount - 1 do
      if Forms[I] <> Self then
      begin
        MenuItem := TMenuItem.Create(Self);
        MenuItem.Caption := Forms[I].Caption;
        MenuItem.Tag := Forms[I].Handle;
        MenuItem.OnClick := WindowClick;
        miWindow.Add(MenuItem);
      end;
  miNoWindows.Visible := miWindow.Count = 1;
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.actStatusBarExecute(Sender: TObject);
begin
  StatusBar.Visible := not StatusBar.Visible;
end;

procedure TMainForm.actAboutExecute(Sender: TObject);
begin
  ShowAboutDialog(Self);
end;

procedure TMainForm.actAddExecute(Sender: TObject);
begin
  with TNewServerDialog.Create(Self) do
  try
    ShowModal;
    if ModalResult = mrOk then
      with lvServers.Items.Add do
      begin
        ImageIndex := 0;
        Caption := Format('%s:%s', [edtIpAddress.Text, edtPort.Text]);
        UpdateStatus;
      end;
  finally
    Free;
  end;
end;

procedure TMainForm.actRemoveExecute(Sender: TObject);
begin
  lvServers.Selected.Delete;
end;

procedure TMainForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actStatusBar.Checked := StatusBar.Visible;
  actRemove.Enabled := Assigned(lvServers.Selected);
end;

end.
