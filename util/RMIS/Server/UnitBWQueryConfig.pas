unit UnitBWQueryConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, JvExMask, JvToolEdit, Vcl.Samples.Spin, Vcl.ComCtrls,
  IniPersist, UnitConfigIniClass;

type
  TBWQryFetchType = (ftCyclic, ftScheduledTime );//주기적으로 가져오기, 정해진 시간에 가져오기

  TConfigSettings = class (TINIConfigBase)
  private
    FServerIP_HhiOfficeNews,
    FServerPort_HhiOfficeNews,
    FServerTimeToGetHhiOfficeNews,
    FServerTimeToGetBWQry,
    FIPCServerName: string;
    FBWQryFetchType: integer;
  public
    //Section Name, Key Name, Default Key Value  (Control.hint = SectionName;KeyName 으로 저장 함)
    [IniValue('Comm Server','HHI Office News Server IP','')]
    property ServerIP_HhiOfficeNews : string read FServerIP_HhiOfficeNews write FServerIP_HhiOfficeNews;
    [IniValue('Comm Server','HHI Office News Server Port','')]
    property ServerPort_HhiOfficeNews : string read FServerPort_HhiOfficeNews write FServerPort_HhiOfficeNews;
    [IniValue('Comm Server','Time To Get HHI Office News From Server','')]
    property ServerTimeToGetHhiOfficeNews : string read FServerTimeToGetHhiOfficeNews write FServerTimeToGetHhiOfficeNews;
    [IniValue('BW Query','Fetch Type','0')]
    property BWQryFetchType : integer read FBWQryFetchType write FBWQryFetchType;
    [IniValue('BW Query','Time To Get From Server','')]
    property ServerTimeToGetBWQry : string read FServerTimeToGetBWQry write FServerTimeToGetBWQry;
    [IniValue('Comm Server','IPC Server Name','BWQry_IPC_Server')]
    property IPCServerName : string read FIPCServerName write FIPCServerName;
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
    Label9: TLabel;
    Label14: TLabel;
    Label23: TLabel;
    ServerIPEdit: TEdit;
    UserEdit: TEdit;
    PasswdEdit: TEdit;
    ServerPortEdit: TEdit;
    TimeToGetEdit: TEdit;
    Bevel1: TBevel;
    Label15: TLabel;
    Label16: TLabel;
    Edit3: TEdit;
    BWQryRG: TRadioGroup;
    hourlbl: TLabel;
    mSeclbl: TLabel;
    Label17: TLabel;
    IPCServerNameEdit: TEdit;
    procedure BWQryRGClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfigF: TConfigF;

implementation

{$R *.dfm}

procedure TConfigF.BWQryRGClick(Sender: TObject);
begin
  mSeclbl.Visible := BWQryRG.ItemIndex = 0;
  hourlbl.Visible := BWQryRG.ItemIndex = 1;
end;

end.
