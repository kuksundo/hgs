unit uImapFolderSelect;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, OKCANCL2, uAccounts;

type
  TImapFolderSelectDlg = class(TOKRightDlg)
    HelpBtn: TButton;
    ListBox1: TListBox;
    procedure HelpBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ShowSelectImapFolder(account : TAccount): string;
    function ShowSelectDlg(dialogTitle : string; listItems : TStringList): string;
  end;

var
  ImapFolderSelectDlg: TImapFolderSelectDlg;

implementation
uses uIMAP4, uTranslate;

{$R *.dfm}

procedure TImapFolderSelectDlg.HelpBtnClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

function TImapFolderSelectDlg.ShowSelectImapFolder(account : TAccount): string;
var
  folders : TStringList;
  i : integer;
  dlgResult : integer;
begin
  Screen.cursor := crAppStart;
  Result := '';
  TranslateComponentFromEnglish(self);

  account.ConnectIfNeeded;
  folders := TStringList.Create;
  try
    if (Account.Prot as TProtocolIMAP4).GetFolderNames(folders) then
    begin
      for i := 0 to (folders.Count - 1) do begin
        ListBox1.AddItem(folders[i], nil);
      end;
    end;
    Screen.Cursor := crDefault;
    self.Caption := uTranslate.Translate('Select IMAP Folder');
    dlgResult := self.ShowModal;
    if (dlgResult = mrOk) and (ListBox1.itemindex >= 0) then begin
      Result := listbox1.items[listbox1.itemindex];
    end;
  finally
    folders.Free;
  end;

end;

function TImapFolderSelectDlg.ShowSelectDlg(dialogTitle : string; listItems : TStringList): string;
var
  i : integer;
  dlgResult : integer;
begin
  Result := '';
  if listItems = nil then exit;

  TranslateComponentFromEnglish(self);
  begin
    for i := 0 to (listItems.Count - 1) do begin
      ListBox1.AddItem(listItems[i], nil);
    end;
  end;
  Screen.Cursor := crDefault;
  self.Caption := dialogTitle;
  dlgResult := self.ShowModal;
  if (dlgResult = mrOk) and (ListBox1.itemindex >= 0) then begin
    Result := listbox1.items[listbox1.itemindex];
  end;

end;


end.
 
