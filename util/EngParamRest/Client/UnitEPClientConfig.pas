unit UnitEPClientConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, JvExMask, JvToolEdit, Vcl.Samples.Spin, Vcl.ComCtrls,
  IniPersist, Ora, UnitConfigIniClass;

type
  TConfigSettings = class (TINIConfigBase)
  private
    FSharedName: String;
    FServerIP: string;
    FServerPort: string;
    FUserId: string;
    FUserPasswd: string;
  public
    // Use the IniValue attribute on any property or field
    // you want to show up in the INI File.
    //Section Name, Key Name, Default Key Value  (Control.hint = SectionName;KeyName 으로 저장 함)
    [IniValue('Parameter','Shared Name','')]
    property SharedName : String read FSharedName write FSharedName;
    [IniValue('Parameter','Server IP','')]
    property ServerIP : String read FServerIP write FServerIP;
    [IniValue('Parameter','Server Port','')]
    property ServerPort : String read FServerPort write FServerPort;
    [IniValue('Parameter','User ID','')]
    property UserId : String read FUserId write FUserId;
    [IniValue('Parameter','PassWord','')]
    property UserPasswd : String read FUserPasswd write FUserPasswd;
  end;

  TConfigF = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ampm_combo: TComboBox;
    Hour_SpinEdit: TSpinEdit;
    Minute_SpinEdit: TSpinEdit;
    UseDate_ChkBox: TCheckBox;
    Month_SpinEdit: TSpinEdit;
    Date_SpinEdit: TSpinEdit;
    Repeat_ChkBox: TCheckBox;
    TabSheet4: TTabSheet;
    Label16: TLabel;
    Label11: TLabel;
    ParaFilenameEdit: TJvFilenameEdit;
    ConfFileFormatRG: TRadioGroup;
    EngParamEncryptCB: TCheckBox;
    AppendStrEdit: TEdit;
    CommServerTab: TTabSheet;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    ServerIPEdit: TEdit;
    UserEdit: TEdit;
    PasswdEdit: TEdit;
    ReConnectIntervalEdit: TSpinEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label9: TLabel;
    ServerPortEdit: TEdit;
    Label23: TLabel;
    SharedNameEdit: TEdit;
    DBServarTab: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ServerEdit: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    TableNameCombo: TComboBox;
    SpinEdit1: TSpinEdit;
    FNameType_RG: TRadioGroup;
    procedure TableNameComboDropDown(Sender: TObject);
  private
    { Private declarations }
  public
//    procedure LoadConfig2Form(ASettings: TConfigSettings);
//    procedure LoadConfigForm2Object(ASettings: TConfigSettings);
  end;

var
  ConfigF: TConfigF;

implementation

{$R *.dfm}

{ TConfigF }

//procedure TConfigF.LoadConfig2Form(ASettings: TConfigSettings);
//begin
//  ServerIPEdit.Text := ASettings.FServerIP;
//  ServerPortEdit.Text := ASettings.FServerPort;
//  SharedNameEdit.Text := ASettings.FSharedName;
//  UserEdit.Text := ASettings.FUserId;
//  PasswdEdit.Text := ASettings.FUserPasswd;
//end;
//
//procedure TConfigF.LoadConfigForm2Object(ASettings: TConfigSettings);
//begin
//  ASettings.SharedName := SharedNameEdit.Text;
//  ASettings.FServerIP := ServerIPEdit.Text;
//  ASettings.FServerPort := ServerPortEdit.Text;
//  ASettings.FUserId := UserEdit.Text;
//  ASettings.FUserPasswd := PasswdEdit.Text;
//end;

procedure TConfigF.TableNameComboDropDown(Sender: TObject);
var
  OraSession1 : TOraSession;
  OraQuery1 : TOraQuery;
  lTable : String;
  i: integer;
begin
  OraSession1 := TOraSession.Create(nil);
  OraQuery1 := TOraQuery.Create(nil);
  try
    with OraSession1 do
    begin
      UserName := UserEdit.Text;//'TBACS';
      Password := PassWdEdit.Text;//'TBACS';
      Server   := ServerEdit.Text;//'10.100.23.114:1521:TBACS';
      LoginPrompt := False;
      Options.Direct := True;
      Options.Charset := 'KO16KSC5601';
      Connected := True;
      OraQuery1.AutoCommit := False;
      OraQuery1.Connection := OraSession1;
    end;

    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HITEMS.MON_TABLES');

      Open;

      if RecordCount = 0 then
        raise Exception.Create('테이블이 존재하지 않습니다.'+#10#13+
                               '테이블 이름 가져오기에 실패하였습니다.');

      TableNameCombo.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        TableNameCombo.AddItem(FieldByName('TABLE_NAME').AsString, nil);
        next;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
    FreeAndNil(OraSession1);
  end;
end;

end.
