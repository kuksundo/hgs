unit login_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NxEdit, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.Menus, AdvMenus, AdvOfficeStatusBar,Ora,
  AdvOfficeStatusBarStylers, Vcl.ImgList,Data.DB, NxCollection, JvBaseDlg,
  JvProgressDialog, DBXJSON, AdvOfficeImage, HiMECSUserClass;

type
  TFadeType = (ftIn, ftOut);

  Tlogin_Frm = class(TForm)
    ImageList1: TImageList;
    IconImg: TImageList;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    StatusBar1: TAdvOfficeStatusBar;
    AdvMainMenu1: TAdvMainMenu;
    File1: TMenuItem;
    Panel1: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    fadeTimer: TTimer;
    UserID: TNxEdit;
    PassWD: TNxEdit;
    LoginButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    NxLinkLabel1: TNxLinkLabel;
    JvProgressDialog1: TJvProgressDialog;
    lb_ver: TLabel;
    AdvOfficeImage1: TAdvOfficeImage;
    procedure fadeTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure UserIDKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LoginButtonClick(Sender: TObject);
    procedure PassWDKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NxLinkLabel1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fFadeType : TFadeType;
    property FadeType : TFadeType read fFadeType write fFadeType;
    procedure StreamProgress(Sender:TObject; Percentage:Single);
  public
    { Public declarations }
    class function Check_Users(aId,aPw:String) : Boolean;
    class function ProcessInputParameter(var AUserID, APasswd, APrjFileName: string): Boolean;
  end;

var
  login_Frm: Tlogin_Frm;
  Start:Boolean=False;

  procedure Create_LoginForm;

implementation

uses
  newUser_Unit,
  CommonUtil_Unit,
  HiTEMS_CONST,
  DataModule_Unit;

{$R *.dfm}

procedure Create_LoginForm;
var
  lPath : String;
  F : TStringList;
  JObj : TJSONObject;
  JValue : TJSONValue;
  lv : TDateTime;
  LUserId, LPasswd, LPrjName: string;
begin
  if ParamCount > 0 then
  begin
    //AutoLoginFileName은 Param으로 제공 됨
    if FileExists(AutoLoginFileName) then
    begin
      Tlogin_Frm.ProcessInputParameter(LUserId, LPasswd, LPrjName);
      Start := Tlogin_Frm.Check_Users(LUserId, LPasswd);

      if Start then
        exit;
    end;
  end;

  login_Frm := Tlogin_Frm.Create(Application);

  try
    with login_Frm do
    begin
      lv := GetFileLastWriteTime(Application.ExeName);
      lb_ver.Caption := 'V.'+FormatDateTime('YYYYMMDDHHMMSS',lv);

      if FileExists(LastLoginFileName) then
      begin
        F := TStringList.Create;

        try
          F.LoadFromFile(LastLoginFileName);

          if F.Text <> '' then
          begin
            JObj := TJSONObject.ParseJSONValue(F.Text) as TJSONObject;

            try
              UserID.Text := JObj.Get('USERID').JsonValue.Value;
//              PassWD.Text := JObj.Get('PASSWD').JsonValue.Value;

            finally
              FreeAndNil(JObj);
            end;
          end;
        finally
          FreeAndNil(F);
        end;
      end;

      AlphaBlend := true;
      AlphaBlendValue := 0;
      fFadeType := ftIn;
      fadeTimer.Enabled := true;

      if DM1.OraSession1.Connected = True then
      begin
        LoginButton.Enabled := True;
        StatusBar1.Panels[0].Text := 'Connect';
        StatusBar1.Panels[0].ImageIndex := 1;
      end
      else
        LoginButton.Enabled := False;

      ShowModal;
    end;
  finally
    FreeAndNil(login_Frm);
  end;
end;

procedure Tlogin_Frm.LoginButtonClick(Sender: TObject);
var
  JObj : TJSONObject;
  F : TStringList;
  LStr: string;
begin
  if UserID.Text = '' then
  begin
    UserID.SetFocus;
    raise Exception.Create('ID(은)는 필수입력 입니다!');
  end;

  if passWd.Text = '' then
  begin
    passWd.SetFocus;
    raise Exception.Create('PW(은)는 필수입력 입니다!');
  end;

  if Check_Users(UserID.Text,passWd.Text) = True then
  begin
    JObj := TJSONObject.Create;
    try
      JObj.AddPair('USERID',UserID.Text).
           AddPair('PASSWD',passWd.Text);

      if JObj.ToString <> '' then
      begin
        F := TStringList.Create;
        try
          F.Clear;
          F.Add(JObj.ToString);
          LStr := ExtractFilePath(LastLoginFileName);
          CreateDirIfNotExist(LStr);
          F.SaveToFile(LastLoginFileName);
        finally
          FreeAndNil(F);
        end;
      end;
    finally
      FreeAndNil(JObj);
    end;
    Start := True;
    Close;
  end;
end;

class function Tlogin_Frm.Check_Users(aId, aPw: String) : Boolean;
var
  lResult : Boolean;
begin //ADMIN, root
  lResult := False;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_USER ' +
            'WHERE USERID = :param1 ');
    ParamByName('param1').AsString := aID;
    Open;

    if RecordCount > 0 then
    begin
      while not eof do
      begin
        if DM1.CheckPassWord(aPw, FieldByName('PASSWD').AsString) then
        begin
          FUserInfo.USERNAME := FieldByName('NAME_KOR').AsString;
          FUserInfo.USERID   := aId;
          FUserInfo.TEAM     := FieldByName('DEPT_CD').AsString;
          FUserInfo.PWD := aPw;
          Result := True;
          exit;
        end;
        Next;
      end;
      if lResult = False then
      begin
//        Self.passWD.SetFocus;
        raise Exception.Create('비밀번호가 일치하지 않습니다.');
      end;
    end
    else
    begin
//      UserID.SetFocus;
      raise Exception.Create('존재하지 않는 사번 입니다.');
    end;
  end;
end;

procedure Tlogin_Frm.fadeTimerTimer(Sender: TObject);
const
  FADE_IN_SPEED = 3;
  FADE_OUT_SPEED = 5;
var
  newBlendValue : integer;
begin
  case FadeType of
    ftIn:
      begin
        if AlphaBlendValue < 255 then
          AlphaBlendValue := FADE_IN_SPEED + AlphaBlendValue
        else
        begin
          fadeTimer.Enabled := false;
          UserID.SetFocus;
        end;
      end;
    ftOut:
      begin
        if AlphaBlendValue > 0 then
        begin
          newBlendValue := -1 * FADE_OUT_SPEED + AlphaBlendValue;
          if newBlendValue >  0 then
            AlphaBlendValue := newBlendValue
          else
            AlphaBlendValue := 0;
        end
        else
        begin
          fadeTimer.Enabled := false;
          Close;
        end;
      end;
  end;
end;

procedure Tlogin_Frm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FadeType = ftIn then
  begin
    fFadeType := ftOut;
    AlphaBlendValue := 255;
    fadeTimer.Enabled := true;
    CanClose := false;
  end
  else
  begin
    CanClose := true;
  end;
end;

procedure Tlogin_Frm.FormCreate(Sender: TObject);
begin
  if not setcurrentdir(defaultPath) then
    createdir(defaultPath);
end;

procedure Tlogin_Frm.NxLinkLabel1Click(Sender: TObject);
var
  empNo : String;
begin
  empNo := Create_newUser_Frm;
  if empNo <> '' then
  begin
    UserID.Text := empNo;
    PassWD.Text := UserID.Text;
  end;
end;

procedure Tlogin_Frm.PassWDKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    LoginButtonClick(Sender);
end;

class function Tlogin_Frm.ProcessInputParameter(var AUserID,
  APasswd, APrjFileName: string): Boolean;
var
  i,j: integer;
  LStr: string;
  LHiMECSUser: THiMECSUser;
begin
  for i := 1 to ParamCount do
  begin
    LStr := ParamStr(i);
    j := Pos('/UF', UpperCase(LStr)); //User File Parameter(.id)

    if j > 0 then  //UF 제거
    begin
      LStr := Copy(LStr, j+3, Length(LStr)-j-1);

      if FileExists(LStr) then
      begin
        try
          LHiMECSUser := THiMECSUser.Create(nil);
          LHiMECSUser.LoadFromJSONFile( LStr,
                                    ExtractFileName(LStr),
                                    True);

          if LHiMECSUser.HiMECSUserCollect.Count > 0 then
          begin
            AUserID := LHiMECSUser.HiMECSUserCollect.Items[0].UserID;
            APasswd := LHiMECSUser.HiMECSUserCollect.Items[0].Password;
          end;
        finally
          LHiMECSUser.HiMECSUserCollect.Clear;
          FreeAndNil(LHiMECSUser);
        end;
      end
      else
        ShowMessage('User File from param does not exists: ' + #13#10 + LStr);
    end
    else
    begin
      j := Pos('/PF', UpperCase(LStr)); //Project File Name Parameter(.himecs)
      if j > 0 then
      begin ///PF 제거
        LStr := Copy(LStr, j+3, Length(LStr)-j-1);

        if FileExists(LStr) then
        begin
          APrjFileName := LStr;
        end
        else
          ShowMessage('Project File from param does not exists: ' + #13#10 + LStr);
      end;
    end;
  end;
end;

procedure Tlogin_Frm.StreamProgress(Sender: TObject; Percentage: Single);
begin
  JvProgressDialog1.Position := Round(Percentage * JvProgressDialog1.Max);
  Application.ProcessMessages;
end;

procedure Tlogin_Frm.UserIDKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    passWd.SetFocus;

end;

end.
