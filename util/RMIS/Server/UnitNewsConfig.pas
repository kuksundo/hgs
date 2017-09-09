unit UnitNewsConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, JvExMask, JvToolEdit, Vcl.Samples.Spin, Vcl.ComCtrls,
  IniPersist, UnitConfigIniClass;

const
  DEFAULT_RSS_ADDR_FILE_NAME = 'RSSAddress.json';
type
  TConfigSettings = class (TINIConfigBase)
  private
    FRSSAddrFileName,
    FServerIP_HhiOfficeNews,
    FServerPort_HhiOfficeNews,
    FServerTimeToGetHhiOfficeNews: string;
    FNumOfNewsList: Integer;
  public
    //Section Name, Key Name, Default Key Value  (Control.hint = SectionName;KeyName 으로 저장 함)
    [IniValue('File','RSS Address File Name','')]
    property RSSAddrFileName : string read FRSSAddrFileName write FRSSAddrFileName;
    [IniValue('Comm Server','HHI Office News Server IP','')]
    property ServerIP_HhiOfficeNews : string read FServerIP_HhiOfficeNews write FServerIP_HhiOfficeNews;
    [IniValue('Comm Server','HHI Office News Server Port','')]
    property ServerPort_HhiOfficeNews : string read FServerPort_HhiOfficeNews write FServerPort_HhiOfficeNews;
    [IniValue('Comm Server','Time To Get HHI Office News From Server','')]
    property ServerTimeToGetHhiOfficeNews : string read FServerTimeToGetHhiOfficeNews write FServerTimeToGetHhiOfficeNews;
    [IniValue('Parameter','Number of News List', '10')]
    property NumOfNewsList : integer read FNumOfNewsList write FNumOfNewsList;
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
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label9: TLabel;
    Label23: TLabel;
    ServerIPEdit: TEdit;
    UserEdit: TEdit;
    PasswdEdit: TEdit;
    ReConnectIntervalEdit: TSpinEdit;
    ServerPortEdit: TEdit;
    TimeToGetEdit: TEdit;
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
    Bevel1: TBevel;
    Label14: TLabel;
    Label15: TLabel;
    JvFilenameEdit1: TJvFilenameEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfigF: TConfigF;

implementation

{$R *.dfm}

end.
