unit WatchConfig2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Spin, Buttons, Mask, JvExMask,
  JvToolEdit, AdvGlowButton, AdvOfficeSelectors, AdvGroupBox, JvExControls,
  JvComCtrls;

type
  TWatchConfigF = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    TabSheet1: TTabSheet;
    Label2: TLabel;
    WatchFileNameEdit: TEdit;
    TabSheet2: TTabSheet;
    SelAlarmValueRG: TRadioGroup;
    AlarmValueGB: TAdvGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MinAlarmEdit: TEdit;
    MaxAlarmEdit: TEdit;
    MinFaultEdit: TEdit;
    MaxFaultEdit: TEdit;
    MinAlarmColorSelector: TAdvOfficeColorSelector;
    MaxAlarmColorSelector: TAdvOfficeColorSelector;
    MinFaultColorSelector: TAdvOfficeColorSelector;
    MaxFaultColorSelector: TAdvOfficeColorSelector;
    MinAlarmBlinkCB: TCheckBox;
    MaxAlarmBlinkCB: TCheckBox;
    MinFaultBlinkCB: TCheckBox;
    MaxFaultBlinkCB: TCheckBox;
    DefaultSoundEdit: TJvFilenameEdit;
    Label11: TLabel;
    IntervalRG: TRadioGroup;
    IntervalEdit: TEdit;
    Label14: TLabel;
    SubWatchCloseCB: TCheckBox;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    GroupBox1: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    NameFontSizeEdit: TEdit;
    ValueFontSizeEdit: TEdit;
    ViewAvgValueCB: TCheckBox;
    Label1: TLabel;
    MapFilenameEdit: TJvFilenameEdit;
    ZoomToFitCB: TCheckBox;
    Label10: TLabel;
    AvgEdit: TEdit;
    AlarmListTabSheet: TTabSheet;
    Label15: TLabel;
    DBDriverEdit: TJvFilenameEdit;
    Label16: TLabel;
    AlarmDBFilenameEdit: TJvFilenameEdit;
    GroupBox2: TGroupBox;
    RB_bydate: TRadioButton;
    RB_byfilename: TRadioButton;
    RadioButton1: TRadioButton;
    ED_csv: TEdit;
    Label17: TLabel;
    RingBufSizeEdit: TEdit;
    Label18: TLabel;
    CaptionEdit: TEdit;
    ConfFileFormatRG: TRadioGroup;
    EngParamEncryptCB: TCheckBox;
    Label19: TLabel;
    AliveIntervalEdit: TEdit;
    Label20: TLabel;
    MonDataFromRG: TRadioGroup;
    TabSheet3: TTabSheet;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    MQIPAddress: TJvIPAddress;
    MQPortEdit: TEdit;
    MQUserEdit: TEdit;
    MQPasswdEdit: TEdit;
    DispAvgValueCB: TCheckBox;
    MQTopicLB: TListBox;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    procedure btnSrcClick(Sender: TObject);
    procedure SelAlarmValueRGClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WatchConfigF: TWatchConfigF;

implementation

{$R *.dfm}

procedure TWatchConfigF.btnSrcClick(Sender: TObject);
var S:string;
begin
  if MapFilenameEdit.FileName <> '' then
    S := ExtractFilePath(MapFilenameEdit.FileName)
  else
    S := GetCurrentDir;
    
  with TOpenDialog.Create(self) do
  try

    InitialDir := S;
    Title := 'Select xml file';
    Filename := MapFilenameEdit.FileName;
    if Execute then
      MapFilenameEdit.FileName := Filename;
  finally
    Free;
  end;
end;

procedure TWatchConfigF.Button1Click(Sender: TObject);
begin
  if Edit1.Text <> '' then
  begin
    if MQTopicLB.Items.IndexOf(Edit1.Text) = -1 then
      MQTopicLB.Items.Add(Edit1.Text)
    else
      ShowMessage('Topic is duplicated.');
  end;
end;

procedure TWatchConfigF.Button2Click(Sender: TObject);
var
  i: integer;
begin
  if MQTopicLB.SelCount > 0 then
  begin
    for i := MQTopicLB.Count - 1 downto 0 do
    begin
      if MQTopicLB.Selected[i] then
        MQTopicLB.Items.Delete(i);
    end;
  end;
end;

procedure TWatchConfigF.SelAlarmValueRGClick(Sender: TObject);
begin
  case SelAlarmValueRG.ItemIndex of
    0: AlarmValueGB.Enabled := False;
    1: AlarmValueGB.Enabled := False;
    2: AlarmValueGB.Enabled := True;
  end;
end;

end.
