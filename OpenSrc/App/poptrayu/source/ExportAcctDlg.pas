unit ExportAcctDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, OKCANCL2, Vcl.CheckLst,
  Vcl.ComCtrls, uAccounts;

type
  TExportAccountsDlg = class(TOKRightDlg)
    HelpBtn: TButton;
    chkIncludePw: TCheckBox;
    Label1: TLabel;
    ListViewAccounts: TListView;
    chkSelAll: TCheckBox;
    procedure HelpBtnClick(Sender: TObject);
    procedure chkSelAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function DoExport(saveDialogTitle : String): integer;
  public
    { Public declarations }
    function ExportSingleAccount(account : TAccount) : integer;
  end;

var
  ExportAccountsDlg: TExportAccountsDlg;

implementation
uses System.IniFiles, Vcl.Dialogs, uTranslate;

{$R *.dfm}

procedure TExportAccountsDlg.chkSelAllClick(Sender: TObject);
var
  item : TListItem;
begin
  inherited;

  for item in ListViewAccounts.Items do begin
    item.Checked := (chkSelAll.Checked);
  end;

end;

procedure TExportAccountsDlg.FormCreate(Sender: TObject);
begin
  inherited;
  ListViewAccounts.Clear;
end;

procedure TExportAccountsDlg.FormShow(Sender: TObject);
var
  account : TAccount;
  item : TListItem;
begin
  inherited;
  TranslateComponentFromEnglish(self);

  for account in Accounts do begin
    item := ListViewAccounts.Items.Add;
    item.Caption := account.Name;
    item.SubItems.Add(account.Server);
    item.SubItems.Add(account.Login);
    item.Data := account;
  end;
end;

// return value = mrOk or mrCancel (whether user pressed cancel on the save dialog)
function TExportAccountsDlg.ExportSingleAccount(account : TAccount) : integer;
var
  item : TListItem;
begin
  ListViewAccounts.Clear;
  item := ListViewAccounts.Items.Add;
  item.Caption := account.Name;
  //item.SubItems.Add(account.Server);
  //item.SubItems.Add(account.Login);
  item.Data := account;
  item.Selected := true;

  Result := DoExport(Translate('Backup Account:')+' '+account.name);
end;


procedure TExportAccountsDlg.HelpBtnClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

// return value = mrOk or mrCancel (whether user pressed cancel on the save dialog)
function TExportAccountsDlg.DoExport(saveDialogTitle : String): integer;
var
  saveDialog : TSaveDialog;    // Save dialog variable
  iniSection : string;
  Ini : TMemIniFile;
  numExportedAccounts : integer;
  item : TListItem;
begin
  saveDialog := TSaveDialog.Create(self);
  try
    saveDialog.InitialDir := GetCurrentDir;
    saveDialog.Title := saveDialogTitle;
    saveDialog.Filter := Translate('Ini File') + '|*.ini|' + Translate('Text File') + '|*.txt';
    saveDialog.DefaultExt := 'ini';
    saveDialog.FilterIndex := 1;

    // Display the save file dialog
    if saveDialog.Execute
    then begin
      Result := mrOk;
      // write to ini
      Ini := TMemIniFile.Create(saveDialog.FileName);
      numExportedAccounts := 0;
      try
        for item in ListViewAccounts.Items do begin
          if (item.Checked) then begin
            Inc(numExportedAccounts);

            iniSection := 'Account'+IntToStr(numExportedAccounts);
            TAccount(item.Data).SaveAccountToIniFile(Ini, iniSection, chkIncludePw.Checked);
            Ini.UpdateFile;
          end;
        end;
        Ini.WriteInteger('Options','NumAccounts',numExportedAccounts);
      finally
         Ini.Free;
      end;
      ShowMessage('Account(s) Exported Successfully'+ sLineBreak + saveDialog.FileName);

    end else Result := mrCancel;
  finally
    saveDialog.Free;
  end;
end;

procedure TExportAccountsDlg.OKBtnClick(Sender: TObject);
begin
  inherited;
  DoExport(Translate('Export/Backup Accounts'));
end;

end.

