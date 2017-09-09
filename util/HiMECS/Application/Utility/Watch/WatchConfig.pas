unit WatchConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Spin, Buttons, Mask, JvExMask,
  JvToolEdit, AdvGlowButton, AdvOfficeSelectors, AdvGroupBox;

type
  TWatchConfigF = class(TForm)
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
    DivisorEdit: TEdit;
    TabSheet2: TTabSheet;
    ViewAvgValueCB: TCheckBox;
    SelAlarmValueRG: TRadioGroup;
    AlarmValueGB: TAdvGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MinWarnEdit: TEdit;
    MaxWarnEdit: TEdit;
    MinAlarmEdit: TEdit;
    MaxAlarmEdit: TEdit;
    MinWarnColorSelector: TAdvOfficeColorSelector;
    MaxWarnColorSelector: TAdvOfficeColorSelector;
    MinAlarmColorSelector: TAdvOfficeColorSelector;
    MaxAlarmColorSelector: TAdvOfficeColorSelector;
    MinWarnBlinkCB: TCheckBox;
    MaxWarnBlinkCB: TCheckBox;
    MinAlarmBlinkCB: TCheckBox;
    MaxAlarmBlinkCB: TCheckBox;
    DefaultSoundEdit: TJvFilenameEdit;
    Label11: TLabel;
    Label12: TLabel;
    NameFontSizeEdit: TEdit;
    Label13: TLabel;
    ValueFontSizeEdit: TEdit;
    procedure btnSrcClick(Sender: TObject);
    procedure SelAlarmValueRGClick(Sender: TObject);
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

procedure TWatchConfigF.SelAlarmValueRGClick(Sender: TObject);
begin
  case SelAlarmValueRG.ItemIndex of
    0: AlarmValueGB.Enabled := False;
    1: AlarmValueGB.Enabled := False;
    2: AlarmValueGB.Enabled := True;
  end;
end;

end.
