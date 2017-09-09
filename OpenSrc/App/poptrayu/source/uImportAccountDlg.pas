unit uImportAccountDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, OKCANCL2, Vcl.ComCtrls,
  uAccounts;

type
  TImportAcctDlg = class(TOKRightDlg)
    HelpBtn: TButton;
    ListViewAccounts: TListView;
    Label1: TLabel;
    chkSelAll: TCheckBox;
    procedure HelpBtnClick(Sender: TObject);
    procedure chkSelAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ImportAccounts(accounts : TAccounts): integer;
  end;

var
  ImportAcctDlg: TImportAcctDlg;

implementation
uses Vcl.Dialogs, System.IniFiles, uTranslate;

{$R *.dfm}

procedure TImportAcctDlg.chkSelAllClick(Sender: TObject);
var
  item : TListItem;
begin
  inherited;
  for item in ListViewAccounts.Items do begin
    item.Checked := (chkSelAll.Checked);
  end;
end;

procedure TImportAcctDlg.HelpBtnClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

// @param accounts - pass in the account list that you would like any imported
//    accounts to be added to. It should be initialized before calling this
//    function.
// @return number of accounts imported
function TImportAcctDlg.ImportAccounts(accounts : TAccounts): integer;
var
  openDialog : TOpenDialog;
  aSection : string;
  Ini : TMemIniFile;
  numImportedAccounts : integer;
  item : TListItem;
  iniSections : TStringList;
  account : TAccount;
begin
  inherited;
  Result := 0;
  numImportedAccounts := 0;

  openDialog := TOpenDialog.Create(self);
  try
    openDialog.Title := Translate('Import/Restore Accounts');
    openDialog.InitialDir := GetCurrentDir;
    openDialog.Filter := Translate('Ini File') + '|*.ini|' + Translate('Text File') + '|*.txt';
    openDialog.DefaultExt := 'ini';
    openDialog.FilterIndex := 1;

    // Display the open file dialog
    if openDialog.Execute
    then begin
      ListViewAccounts.Clear;

      Ini := TMemIniFile.Create(openDialog.FileName);

      // make a list of accounts in the ini file
      iniSections := TStringList.Create;
      try
        Ini.ReadSections(iniSections);

        // add each account+data from the ini file to the import dialog.
        for aSection in iniSections do
        begin
          if aSection.StartsWith('Account') then
          begin
            account := TAccount.Create;
            account.LoadAccountFromINI(Ini, aSection);

            item := ListViewAccounts.Items.Add;
            item.Caption := account.Name;
            item.SubItems.Add(account.Server);
            item.SubItems.Add(account.Login);
            item.SubItems.Add(aSection);
            item.Data := account;
          end;
        end;
        TranslateComponentFromEnglish(self);

        Result := self.ShowModal;

        if (Result = mrOk) then
        begin
          for item in ListViewAccounts.Items do begin
            if (item.Checked) then begin
              Inc(numImportedAccounts);
              account := accounts.Add;
              account.LoadAccountFromINI(Ini, item.SubItems[2]);
            end;
          end;
          if (numImportedAccounts > 0) then begin
            Result := numImportedAccounts;
          end;
        end;

        // todo: free item.Data??
      finally
         Ini.Free;
         iniSections.Free;
      end;

    end;
  finally
    openDialog.Free;
  end;


end;

end.
 
