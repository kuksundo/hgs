unit RwOptions;

{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TOptionsDialog = class(TForm)
    grbDays: TGroupBox;
    chkMonday: TCheckBox;
    chkTuesday: TCheckBox;
    chkWednesday: TCheckBox;
    chkThursday: TCheckBox;
    chkFriday: TCheckBox;
    chkSaturday: TCheckBox;
    chkSunday: TCheckBox;
    btnOk: TButton;
    btnCancel: TButton;
    grbTime: TGroupBox;
    edtHour: TEdit;
    udHour: TUpDown;
    edtMinute: TEdit;
    udMinute: TUpDown;
    lblHour: TLabel;
    lblMinute: TLabel;
    grbIP: TGroupBox;
    edtIpAddress: TEdit;
    edtPort: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TDays = set of 1..7;

procedure ShowOptionsDialog(AOwner: TComponent; var AIpBroadcast: string;
  var AIpPort: Word; var AWakeUpTime: TDateTime; var AWakeUpDays: TDays);
    
var
  OptionsDialog: TOptionsDialog;

implementation

uses NetConst, NetUtils;

{$R *.dfm}

procedure ShowOptionsDialog(AOwner: TComponent; var AIpBroadcast: string;
  var AIpPort: Word; var AWakeUpTime: TDateTime; var AWakeUpDays: TDays);
var
  I: Integer;
begin
  with TOptionsDialog.Create(AOwner) do
  try
    edtIpAddress.Text := AIpBroadcast;
    edtPort.Text := IntToStr(AIpPort);
    udHour.Position := StrToInt(FormatDateTime('h', AWakeUpTime));
    udMinute.Position := StrToInt(FormatDateTime('n', AWakeUpTime));
    chkMonday.Checked := chkMonday.Tag in AWakeUpDays;
    chkTuesday.Checked := chkTuesday.Tag in AWakeUpDays;
    chkWednesday.Checked := chkWednesday.Tag in AWakeUpDays;
    chkThursday.Checked := chkThursday.Tag in AWakeUpDays;
    chkFriday.Checked := chkFriday.Tag in AWakeUpDays;
    chkSaturday.Checked := chkSaturday.Tag in AWakeUpDays;
    chkSunday.Checked := chkSunday.Tag in AWakeUpDays;
    ShowModal;
    if ModalResult = mrOk then
    begin
      AIpBroadcast := edtIpAddress.Text;
      AIpPort := StrToInt(edtPort.Text);
      AWakeUpTime := StrToTime(edtHour.Text + {$IF CompilerVersion > 22}
        FormatSettings.{$IFEND}TimeSeparator + edtMinute.Text);
      AWakeUpDays := [];
      with grbDays do
        for I := 0 to ControlCount - 1 do
          if (Controls[I] as TCheckBox).Checked then
            Include(AWakeUpDays, (Controls[I] as TCheckBox).Tag);
    end;
  finally
    Free;
  end;
end;

procedure TOptionsDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    if not CheckIpAddress(edtIpAddress.Text) then
    begin
      with Application do
        MessageBox(PChar(SInvalidIpAddress), PChar(Title), MB_OK or MB_ICONERROR);
      edtIpAddress.SetFocus;
      Action := caNone;
      Exit;
    end;
    if not CheckPort(edtPort.Text) then
    begin
      with Application do
        MessageBox(PChar(SInvalidPort), PChar(Title), MB_OK or MB_ICONERROR);
      edtPort.SetFocus;
      Action := caNone;
    end;
  end;
end;

end.
