unit WatchSaveConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Spin, Buttons, Mask, JvExMask,
  JvToolEdit, AdvGlowButton, AdvOfficeSelectors, AdvGroupBox, JvExControls,
  JvComCtrls;

type
  TWatchSaveConfigF = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet3: TTabSheet;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    TabSheet1: TTabSheet;
    Label10: TLabel;
    AvgEdit: TEdit;
    MapFilenameEdit: TJvFilenameEdit;
    Label2: TLabel;
    SplitEdit: TEdit;
    IntervalRG: TRadioGroup;
    IntervalEdit: TEdit;
    Label14: TLabel;
    Label3: TLabel;
    InitialCB: TCheckBox;
    InitialEdit: TEdit;
    ConfFileFormatRG: TRadioGroup;
    EngParamEncryptCB: TCheckBox;
    MonDataFromRG: TRadioGroup;
    TabSheet2: TTabSheet;
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
    MQTopicLB: TListBox;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    procedure btnSrcClick(Sender: TObject);
    procedure IntervalRGClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WatchSaveConfigF: TWatchSaveConfigF;

implementation

{$R *.dfm}

procedure TWatchSaveConfigF.btnSrcClick(Sender: TObject);
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

procedure TWatchSaveConfigF.Button1Click(Sender: TObject);
begin
  if Edit1.Text <> '' then
  begin
    if MQTopicLB.Items.IndexOf(Edit1.Text) = -1 then
      MQTopicLB.Items.Add(Edit1.Text)
    else
      ShowMessage('Topic is duplicated.');
  end;
end;

procedure TWatchSaveConfigF.Button2Click(Sender: TObject);
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

procedure TWatchSaveConfigF.IntervalRGClick(Sender: TObject);
begin
  IntervalEdit.Enabled := IntervalRG.ItemIndex = 1;
end;

end.
