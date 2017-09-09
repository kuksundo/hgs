unit UnitMQTTClientConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, JvExMask, JvToolEdit, Vcl.Samples.Spin, Vcl.ComCtrls,
  IniPersist, UnitConfigIniClass2;

type
  TConfigSettings = class (TINIConfigBase)
  private
    //변수 Type은 값을 받는 컴포넌트 속성 Type과 같아야 함
    //(예: Text면 String, Checked면 Bool, Value면 Integer)
    FServerIP: string;
    FServerPort: string;
    FIsUseMQTT: Boolean;
  public
    //Section Name, Key Name, Default Key Value, Component Tag No
    [IniValue('Comm Server','MQTT Server IP','127.0.0.1',1)]
    property ServerIP : string read FServerIP write FServerIP;
    [IniValue('Comm Server','MQTT Server Port','1883',2)]
    property ServerPort : string read FServerPort write FServerPort;
    [IniValue('Comm Server','Is Use MQTT','True',3)]
    property IsUseMQTT : Boolean read FIsUseMQTT write FIsUseMQTT;
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
    Label11: TLabel;
    AppendStrEdit: TEdit;
    CommServerTab: TTabSheet;
    Label25: TLabel;
    Label26: TLabel;
    ReConnectIntervalEdit: TSpinEdit;
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
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label20: TLabel;
    Label21: TLabel;
    Label14: TLabel;
    Label23: TLabel;
    ServerIPEdit: TEdit;
    UserEdit: TEdit;
    PasswdEdit: TEdit;
    ServerPortEdit: TEdit;
    Label15: TLabel;
    CheckBox1: TCheckBox;
  private
    { Private declarations }
  public
    class procedure SetConfig(ASet: TConfigSettings);
    procedure LoadConfigFromFile(ASet: TConfigSettings; AFileName: string = '');
    procedure LoadConfig2Form(ASet: TConfigSettings);
    procedure LoadConfigForm2Object(ASet: TConfigSettings);
    procedure ApplyUI;
  end;

var
  ConfigF: TConfigF;

implementation

{$R *.dfm}

{ TConfigF }

procedure TConfigF.ApplyUI;
begin

end;

procedure TConfigF.LoadConfig2Form(ASet: TConfigSettings);
begin
  ASet.LoadConfig2Form(TForm(Self), ASet);
end;

procedure TConfigF.LoadConfigForm2Object(ASet: TConfigSettings);
begin
  ASet.LoadConfigForm2Object(TForm(Self), ASet);
end;

procedure TConfigF.LoadConfigFromFile(ASet: TConfigSettings; AFileName: string);
begin
  ASet.Load(AFileName);
end;

class procedure TConfigF.SetConfig(ASet: TConfigSettings);
var
  LConfigF: TConfigF;
begin
  LConfigF := TConfigF.Create(nil);

  try
    with LConfigF do
    begin
      LoadConfig2Form(ASet);

      if ShowModal = mrOK then
      begin
        LoadConfigForm2Object(ASet);
        ASet.Save();
        ApplyUI;
      end;
    end;
  finally
    LConfigF.Free;
  end;
end;

end.
