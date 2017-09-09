unit rcg_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls,
  OnGuard, OgUtil, ExtCtrls, UnitRegistrationClass, UnitPasswordGen;

type
  TrcgMain = class(TForm)

    lblAppKey: TLabel;
    edtAppKey: TEdit;

    chkMachMod: TCheckBox;
    edtMachineMod: TEdit;

    edtSerialNumber: TEdit;
    lblSerialNumber: TLabel;

    lblReleaseCode: TLabel;
    edtReleaseCode: TEdit;

    Bevel1: TBevel;
    btnExit: TButton;
    chkExpires: TCheckBox;
    edtExpires: TEdit;
    spdAppKey: TBitBtn;
    spdReleaseCode: TBitBtn;
    btnReadme: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    SaveDialog1: TSaveDialog;
    Button7: TButton;
    PasswordEdit: TEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    OgMakeKeys1: TOgMakeKeys;
    Button8: TButton;

    procedure spdAppKeyClick(Sender: TObject);
    procedure chkMachModClick(Sender: TObject);
    procedure spdReleaseCodeClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure chkExpiresClick(Sender: TObject);
    procedure edtAppKeyChange(Sender: TObject);
    procedure btnReadmeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    FRegInfo: TRegistrationInfo;

    procedure RandomPasswordGenConfig;
  public
    { Public declarations }
    ApplicationKey : TKey;

    procedure UpdateUI(ARegistrationInfo: TRegistrationInfo);
    procedure UpdateRegInfo(var ARegistrationInfo: TRegistrationInfo);
  end;

var
  rcgMain: TrcgMain;

implementation

{$R *.DFM}

uses
  frm_Readme;

procedure TrcgMain.spdAppKeyClick(Sender: TObject);
begin
//  if OgMakeKeys1.Execute then begin
//    OgMakeKeys1.GetKey(ApplicationKey);
//    edtAppKey.Text := BufferToHex(ApplicationKey, sizeof(ApplicationKey));
//  end;
  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      FRegInfo.AppFullPath := ExtractFilePath(OpenDialog1.FileName);
      FRegInfo.GetVersionFromAppName;
      edtAppKey.Text := ExtractFileName(OpenDialog1.FileName);
    end;
  end;
end;

procedure TrcgMain.chkMachModClick(Sender: TObject);
begin
  edtMachineMod.Enabled := chkMachMod.Checked;
  if edtMachineMod.Enabled then begin
    edtMachineMod.SetFocus;
    edtMachineMod.SelectAll;
  end;
end;

procedure TrcgMain.chkExpiresClick(Sender: TObject);
begin
  edtExpires.Enabled := chkExpires.Checked;
  if edtExpires.Enabled then begin
    edtExpires.SetFocus;
    edtExpires.SelectAll;
  end;
end;

procedure TrcgMain.spdReleaseCodeClick(Sender: TObject);
var
  Key : TKey;
  Modifier : longint;
  SerialNum : longint;
  Expires : TDateTime;
  ReleaseCode : TCode;
  CodeString : string;
begin
  edtReleaseCode.Text := '';

  // Get the key that will be used to generate the ReleaseCode
  Key := ApplicationKey;
  if chkMachMod.Checked then
    try
      Modifier := StrToInt(edtMachineMod.Text);
      ApplyModifierToKeyPrim(Modifier, Key, sizeof(Key));
    except
      MessageDlg('Invalid Machine Modifier.  Please check your entry and try again.', mtError, [mbOK], 0);
      exit;
    end;

  // Get the expiration date
  if chkExpires.Checked then
    try
      Expires := StrToDate(edtExpires.Text);
    except
      MessageDlg('Invalid Expiration Date.  Please check your entry and try again.', mtError, [mbOK], 0);
      exit;
    end
  else
    Expires := 0;

  // Get the serial number
  try
    SerialNum := StrToInt(edtSerialNumber.Text);
  except
    MessageDlg('Invalid Serial Number.  Please check your entry and try again.', mtError, [mbOK], 0);
    exit;
  end;

  // Create the release code for the data givien
  InitSerialNumberCode(Key, SerialNum, Expires, ReleaseCode);
  CodeString := BufferToHex(ReleaseCode, sizeof(ReleaseCode));

  // Insert spaces in the release code string for easier reading
  System.Insert(' ', CodeString, 13);
  System.Insert(' ', CodeString, 09);
  System.Insert(' ', CodeString, 05);
  edtReleaseCode.Text := CodeString;
end;

procedure TrcgMain.UpdateRegInfo(var ARegistrationInfo: TRegistrationInfo);
begin
  ARegistrationInfo.AppName := edtAppKey.Text;
  ARegistrationInfo.MachineID := StrToInt64(edtMachineMod.Text);
  ARegistrationInfo.SerialNo := StrToInt(edtSerialNumber.Text);
  ARegistrationInfo.RegCode := edtReleaseCode.Text;
end;

procedure TrcgMain.UpdateUI(ARegistrationInfo: TRegistrationInfo);
begin
  edtAppKey.Text := ARegistrationInfo.AppName;
  edtMachineMod.Text := IntToStr(ARegistrationInfo.MachineID);
  edtSerialNumber.Text := IntToStr(ARegistrationInfo.SerialNo);
  edtReleaseCode.Text := ARegistrationInfo.RegCode;
end;

procedure TrcgMain.edtAppKeyChange(Sender: TObject);
begin
  edtReleaseCode.Text := '';
end;

procedure TrcgMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FRegInfo.Free;
end;

procedure TrcgMain.FormCreate(Sender: TObject);
begin
  FRegInfo := TRegistrationInfo.Create(nil);
end;

procedure TrcgMain.RandomPasswordGenConfig;
var
  LPasswordGenF: TPasswordGenF;
begin
  LPasswordGenF := TPasswordGenF.Create(Self);
  try
    if LPasswordGenF.ShowModal = mrOK then
    begin
      PasswordEdit.Text := LPasswordGenF.edtPassword.Text;
    end;
  finally
    LPasswordGenF.Free;
  end;

end;

procedure TrcgMain.BitBtn1Click(Sender: TObject);
begin
  RandomPasswordGenConfig;
end;

procedure TrcgMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TrcgMain.btnReadmeClick(Sender: TObject);
begin
  frmReadme.Show;
end;

procedure TrcgMain.Button1Click(Sender: TObject);
var
  LCode: TCode;
  LStr: string;
begin
//  InitSerialNumberCode(ApplicationKey, StrToInt(edtSerialNumber.Text), 0, LCode);
//  LStr := BufferToHex(LCode, sizeof(LCode));
//  // Insert spaces in the release code string for easier reading
//  System.Insert('-', LStr, 13);
//  System.Insert('-', LStr, 09);
//  System.Insert('-', LStr, 05);
  LStr := FRegInfo.EncodeSerialNo(ApplicationKey, StrToInt(edtSerialNumber.Text));
  edtSerialNumber.Text := LStr;
end;

procedure TrcgMain.Button2Click(Sender: TObject);
var
  LCode: TCode;
  LStr: string;
begin
  LStr := edtSerialNumber.Text;
  LStr := StringReplace(LStr, '-', '', [rfReplaceAll, rfIgnoreCase]);

  if not HexToBuffer(LStr, LCode, SizeOf(LCode)) then
    FillChar(LCode, SizeOf(LCode), 0);

  edtSerialNumber.Text := IntToStr(GetSerialNumberCodeValue(ApplicationKey, LCode));
end;

procedure TrcgMain.Button3Click(Sender: TObject);
var
  LKey: TKey;
begin
  //exe filename을 이용하여 Application key 생성함
  FRegInfo.MakeKey(LKey, True, False, edtAppKey.Text);
  ApplicationKey := LKey;
  edtAppKey.Text := BufferToHex(LKey, SizeOf(LKey));
end;

procedure TrcgMain.Button4Click(Sender: TObject);
var
  LPhrase: string;
  LRegInfo: TRegistrationInfo;
  LCode: TCode;
  LStr: string;
begin
  //Encode 된 Serial No를 AppKey를 이용하여 암호화 한 후 지정한 파일에 저장함
  if SaveDialog1.Execute then
  begin
    if SaveDialog1.FileName <> '' then
    begin
      LRegInfo:= TRegistrationInfo.Create(nil);
      try
        LStr := edtSerialNumber.Text;  //암호화 된 번호
        LStr := StringReplace(LStr, '-', '', [rfReplaceAll, rfIgnoreCase]);

        if not HexToBuffer(LStr, LCode, SizeOf(LCode)) then
          FillChar(LCode, SizeOf(LCode), 0);

        LRegInfo.SerialNo := GetSerialNumberCodeValue(ApplicationKey, LCode);
        LRegInfo.AppName := ExtractFileName(SaveDialog1.FileName);
        LRegInfo.AppFullPath := ExtractFilePath(SaveDialog1.FileName);
        LPhrase := LRegInfo.MakePassPhrase(LRegInfo.AppName);
        FRegInfo.SaveToJSONFile(SaveDialog1.FileName, LPhrase, True);
      finally
        LRegInfo.Free;
      end;
    end;
  end;
end;

procedure TrcgMain.Button5Click(Sender: TObject);
var
  LKey: TKey;
  LStr: string;
begin
  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      try
        //.iif(install info file) File(Serial No + Mach ID)
        LStr := ExtractFileName(ChangeFileExt(OpenDialog1.FileName, '.exe'));
        LStr := FRegInfo.MakePassPhrase(LStr);  //암호 Phrase 생성
        FRegInfo.LoadFromJSONFile(OpenDialog1.FileName, LStr, True);
        FRegInfo.MakeKey(LKey, True, False); //Exe Name + MachID를 LKey에 저장

        if FRegInfo.IsValidSerialCode then
        begin
          FRegInfo.SerialNo := FRegInfo.DecodeSerialNo(LKey);
          FRegInfo.IsUseMachineId := True;
          FRegInfo.RegCode := FRegInfo.EncodeRegCode(LKey, FRegInfo.SerialCode, FRegInfo.ExpireDate);
          UpdateUI(FRegInfo);
        end;

//        LPhrase := LRegInfo.MakePassPhrase(LRegInfo.AppName);
//        FRegInfo.SaveToJSONFile(OpenDialog1.FileName, LPhrase, True);
      finally
      end;
    end;
  end;
end;

procedure TrcgMain.Button6Click(Sender: TObject);
var
  LPhrase: string;
  LRegInfo: TRegistrationInfo;
begin
  if SaveDialog1.Execute then
  begin
    if SaveDialog1.FileName <> '' then
    begin
//      LRegInfo:= TRegistrationInfo.Create(nil);
      try
        UpdateRegInfo(FRegInfo);
        LPhrase := FRegInfo.MakePassPhrase(FRegInfo.AppName);
        FRegInfo.SaveToJSONFile(SaveDialog1.FileName, LPhrase, True);
      finally
//        LRegInfo.Free;
      end;
    end;
  end;
end;

procedure TrcgMain.Button7Click(Sender: TObject);
begin
  PasswordEdit.Text := FRegInfo.GeneratePassword(2,2,2,10);
end;

procedure TrcgMain.Button8Click(Sender: TObject);
begin
  FRegInfo.IsTrialVersion := True;
  FRegInfo.IsUseMachineId := False;
  FRegInfo.SerialCode := FRegInfo.EncodeSerialNo(ApplicationKey, StrToInt(edtSerialNumber.Text));
  FRegInfo.ExpireUsage := 1;
  FRegInfo.GenerateRegOrUsageCode;

  if FRegInfo.IsValidUsageCode then
  begin
    FRegInfo.DecUsageCount;
    if FRegInfo.IsExpiredUsageCode then
      raise Exception.Create('Hallo World!');;
  end;

//    ShowMessage(FRegInfo.UsageCode);
//  ShowMessage(FRegInfo.EncodeUsageCode(FRegInfo.FApplicationKey,1,now+1));
end;

end.
