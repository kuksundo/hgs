unit uRegistryFxns;

interface

function SetDefaultMailClientFromRegistry() : string;

implementation

uses Registry, System.UITypes, SynTaskDialog, uTranslate, SysUtils,
  uGlobal, uIniSettings, uMain, Windows;

procedure ConfirmMailClientChoice(clientName: string; clientPath: string);
var
  TaskDlg : TSynTaskDialog;
  msgResult : integer;
begin
  TaskDlg.Caption := APPTITLE + ' - ' +  Translate('Auto-detect Email Client');
  TaskDlg.Title := Translate('Auto-detection Complete');
  //TaskDlg.Content := 'Path: '+clientPath;
  TaskDlg.Buttons :=
            Format(Translate('Use %s'), [clientname])+'\n'+ //message result = 100
            clientPath
            +sLineBreak+
            Translate('Set Email Client Manually')+'\n'+ //message result = 101
            Translate('You will be taken to the Options screen to set this value.')
            +sLineBreak+
            Translate('Ignore')+'\n'+ //message result = 101
            Translate('Take no action at this time');
  msgResult := TaskDlg.Execute([cbOK],mrOK,[tdfUseCommandLinks],tiInformation); //modal dlg
  case msgResult of
  100:
    begin
      Options.MailProgram := clientPath; //set default mail client
      SaveOptionsINI();              //save change to disk
    end;
  101:
    begin
      frmPopUMain.PageControl.ActivePage := frmPopUMain.tsOptions;
      frmPopUMain.ShowForm();
      frmPopUMain.OptionsForm.ShowSetEmailClient();
    end;
  end;
end;

procedure MailClientNotDetectedMsg();
var
  TaskDlg : TSynTaskDialog;
  msgResult : integer;
begin
  TaskDlg.Caption := Translate('Auto-detect My Email Client');
  TaskDlg.Title := Translate('Unable to Detect Mail Client');
  TaskDlg.Text := '';
  TaskDlg.Buttons :=
            Translate('Set Email Client Manually')+'\n'+ //message result = 101
            Translate('You will be taken to the Options screen to set this value.')
            +sLineBreak+
            Translate('Ignore')+'\n'+ //message result = 101
            Translate('Take no action at this time');
  msgResult := TaskDlg.Execute([cbOK],mrOK,[tdfUseCommandLinks],tiError); //modal dlg
  case msgResult of
  100:
    begin
      frmPopUMain.PageControl.ActivePage := frmPopUMain.tsOptions;
      frmPopUMain.ShowForm();
      frmPopUMain.OptionsForm.ShowSetEmailClient();
    end;
  end;
end;


function SetDefaultMailClientFromRegistry() : string;
var
  Registry: TRegistry;
  iniLocation: Integer;
  appname : string;
  found : boolean;
begin
  Result := '';
  found := false;
  Registry := TRegistry.Create(KEY_READ);
  try
    // 1. Get name of default email client (CURRENT USER key)
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\Clients\Mail', false) then
      if Registry.ValueExists('') then
        appname := Registry.ReadString('');
    Registry.CloseKey;

    // 2. (Alt) Get name of default email client (LOCAL MACHINE key)
    if appname = '' then begin
      Registry.RootKey := HKEY_LOCAL_MACHINE;
      if Registry.OpenKey('Software\Clients\Mail', false) then
        if Registry.ValueExists('') then
          appname := Registry.ReadString('');
      Registry.CloseKey;
    end;

    // 3. If above found, look up path to run that program.
    if appname <> '' then begin
      Registry.RootKey := HKEY_LOCAL_MACHINE;
      if Registry.OpenKey('SOFTWARE\Clients\Mail\'+appname+'\shell\open\command',false) then
      if Registry.ValueExists('') then
      begin
        Result := Registry.ReadString('');
        found := true;
      end;
      Registry.CloseKey;
    end;

    if found then
      ConfirmMailClientChoice(appname, Result)
    else
      MailClientNotDetectedMsg();

  finally

  end;
end;


end.
