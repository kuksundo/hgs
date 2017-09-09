unit UnitConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask, JvExControls, JvComCtrls,
  JvExMask, JvToolEdit, HiMECSConfigCollect, HiMECSConst;

type
  TConfigF = class(TForm)
    PageControl1: TPageControl;
    Tabsheet2: TTabSheet;
    Label1: TLabel;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    TabSheet1: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    TabSheet4: TTabSheet;
    Label14: TLabel;
    Label15: TLabel;
    PortNumEdit: TEdit;
    JvIPAddress1: TJvIPAddress;
    MenuFilenameEdit: TJvFilenameEdit;
    FormPathEdit: TJvDirectoryEdit;
    Label8: TLabel;
    ConfigPathEdit: TJvDirectoryEdit;
    Label9: TLabel;
    DocPathEdit: TJvDirectoryEdit;
    Label10: TLabel;
    ExePathEdit: TJvDirectoryEdit;
    Label13: TLabel;
    LogPathEdit: TJvDirectoryEdit;
    Label3: TLabel;
    EngInfoFilenameEdit: TJvFilenameEdit;
    Label2: TLabel;
    ParamFilenameEdit: TJvFilenameEdit;
    TabSheet3: TTabSheet;
    CBExtAppInMDI: TCheckBox;
    Label4: TLabel;
    UserFilenameEdit: TJvFilenameEdit;
    Label5: TLabel;
    BplPathEdit: TJvDirectoryEdit;
    Label11: TLabel;
    ProjInfoFilenameEdit: TJvFilenameEdit;
    ConfFileFormatRG: TRadioGroup;
    EngParamEncryptCB: TCheckBox;
    TabSheet5: TTabSheet;
    SelProtocolRG: TRadioGroup;
    UpdateCB: TCheckBox;
    URLEdit: TEdit;
    GroupBox1: TGroupBox;
    Label16: TLabel;
    HostEdit: TEdit;
    Label17: TLabel;
    PortEdit: TEdit;
    Label18: TLabel;
    UserIdEdit: TEdit;
    Label19: TLabel;
    PasswdEdit: TEdit;
    Label20: TLabel;
    DirEdit: TEdit;
    Label21: TLabel;
    CBUseMonLauncher: TCheckBox;
    CBUseCommLauncher: TCheckBox;
    Label12: TLabel;
    KillProcFilenameEdit: TJvFilenameEdit;
    Label22: TLabel;
    ManualInfoFilenameEdit: TJvFilenameEdit;
    Panel2: TPanel;
    RelativeCB: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure SelProtocolRGClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EngInfoFilenameEditAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure MenuFilenameEditAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure UserFilenameEditAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure ParamFilenameEditAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure ProjInfoFilenameEditAfterDialog(Sender: TObject;
      var AName: string; var AAction: Boolean);
    procedure ManualInfoFilenameEditAfterDialog(Sender: TObject;
      var AName: string; var AAction: Boolean);
    procedure KillProcFilenameEditAfterDialog(Sender: TObject;
      var AName: string; var AAction: Boolean);
    procedure FormPathEditAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure ConfigPathEditAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure DocPathEditAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure ExePathEditAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure BplPathEditAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure LogPathEditAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
  private
    FHiMECSConfig: THiMECSConfig;

    procedure SetConfigData(Sender: TObject);
  public
    procedure LoadConfigCollect2Form(AForm: TConfigF);
    procedure LoadConfigForm2Collect(AForm: TConfigF);
    procedure LoadConfigCollectFromFile(AFileName: string; AIsEncrypt: Boolean);
    procedure SaveConfig(AFileName: string; AIsEncrypt: Boolean);
  end;

var
  ConfigF: TConfigF;

implementation

uses CommonUtil;

{$R *.dfm}

{ TConfigF }

procedure TConfigF.BplPathEditAfterDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.ConfigPathEditAfterDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.DocPathEditAfterDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.EngInfoFilenameEditAfterDialog(Sender: TObject;
  var AName: string; var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.ExePathEditAfterDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.FormCreate(Sender: TObject);
begin
  FHiMECSConfig := THiMECSConfig.Create(Self);
end;

procedure TConfigF.FormDestroy(Sender: TObject);
begin
  if Assigned(FHiMECSConfig) then
    FreeAndNil(FHiMECSConfig);
end;

procedure TConfigF.FormPathEditAfterDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.KillProcFilenameEditAfterDialog(Sender: TObject;
  var AName: string; var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.LoadConfigCollect2Form(AForm: TConfigF);
begin
  AForm.MenuFilenameEdit.Text := FHiMECSConfig.MenuFileName;
  AForm.EngInfoFilenameEdit.Text := FHiMECSConfig.EngineInfoFileName;
  AForm.ParamFilenameEdit.Text := FHiMECSConfig.ParamFileName;
  AForm.ProjInfoFilenameEdit.Text := FHiMECSConfig.ProjectInfoFileName;
  AForm.UserFilenameEdit.Text := FHiMECSConfig.UserFileName;
  AForm.ManualInfoFilenameEdit.Text := FHiMECSConfig.ManualInfoFileName;
  AForm.KillProcFilenameEdit.Text := FHiMECSConfig.KillProcListFileName;

  AForm.FormPathEdit.Text :=   FHiMECSConfig.HiMECSFormPath;
  AForm.ConfigPathEdit.Text := FHiMECSConfig.ConfigPath;
  AForm.DocPathEdit.Text := FHiMECSConfig.DocPath;
  AForm.ExePathEdit.Text := FHiMECSConfig.ExesPath;
  AForm.BplPathEdit.Text := FHiMECSConfig.BplsPath;
  AForm.LogPathEdit.Text := FHiMECSConfig.LogPath;

  AForm.CBExtAppInMDI.Checked := FHiMECSConfig.ExtAppInMDI;
  AForm.EngParamEncryptCB.Checked := FHiMECSConfig.EngParamEncrypt;
end;

procedure TConfigF.LoadConfigCollectFromFile(AFileName: string;
  AIsEncrypt: Boolean);
begin
  if AFileName <> '' then
  begin
    FHiMECSConfig.Clear;
    FHiMECSConfig.LoadFromFile(AFileName,ExtractFileName(AFileName),AIsEncrypt);
  end
  else
    ShowMessage('Config File name is empty!');
end;

procedure TConfigF.LoadConfigForm2Collect(AForm: TConfigF);
begin
  FHiMECSConfig.MenuFileName := AForm.MenuFilenameEdit.Text;
  FHiMECSConfig.EngineInfoFileName := AForm.EngInfoFilenameEdit.Text;
  FHiMECSConfig.ParamFileName := AForm.ParamFilenameEdit.Text;
  FHiMECSConfig.ProjectInfoFileName := AForm.ProjInfoFilenameEdit.Text;
  FHiMECSConfig.UserFileName := AForm.UserFilenameEdit.Text;
  FHiMECSConfig.ManualInfoFileName := AForm.ManualInfoFilenameEdit.Text;
  FHiMECSConfig.KillProcListFileName := AForm.KillProcFilenameEdit.Text;

  FHiMECSConfig.HiMECSFormPath := AForm.FormPathEdit.Text;
  FHiMECSConfig.ConfigPath := AForm.ConfigPathEdit.Text;
  FHiMECSConfig.DocPath := AForm.DocPathEdit.Text;
  FHiMECSConfig.ExesPath := AForm.ExePathEdit.Text;
  FHiMECSConfig.BplsPath := AForm.BplPathEdit.Text;
  FHiMECSConfig.LogPath := AForm.LogPathEdit.Text;
  FHiMECSConfig.ExtAppInMDI := AForm.CBExtAppInMDI.Checked;
  FHiMECSConfig.EngParamEncrypt := AForm.EngParamEncryptCB.Checked;
end;

procedure TConfigF.LogPathEditAfterDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.ManualInfoFilenameEditAfterDialog(Sender: TObject;
  var AName: string; var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.MenuFilenameEditAfterDialog(Sender: TObject;
  var AName: string; var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.ParamFilenameEditAfterDialog(Sender: TObject;
  var AName: string; var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.ProjInfoFilenameEditAfterDialog(Sender: TObject;
  var AName: string; var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

procedure TConfigF.SaveConfig(AFileName: string; AIsEncrypt: Boolean);
begin
  FHiMECSConfig.SaveToFile(AFileName, ExtractFileName(AFileName),AIsEncrypt);
end;

procedure TConfigF.SelProtocolRGClick(Sender: TObject);
begin
  GroupBox1.Enabled := SelProtocolRG.ItemIndex = 2;
  URLEdit.Enabled := SelProtocolRG.ItemIndex <> 2;
  Label21.Enabled := SelProtocolRG.ItemIndex <> 2;
end;

procedure TConfigF.SetConfigData(Sender: TObject);
var
  LStr: string;
begin
  LoadConfigCollect2Form(self);

  if ShowModal = mrOK then
  begin
    LoadConfigForm2Collect(Self);
    LStr := IncludeTrailingPathDelimiter(FHiMECSConfig.ConfigPath);
    FHiMECSConfig.SaveToFile(LStr + DefaultOptionsFileName);
  end;
end;

procedure TConfigF.UserFilenameEditAfterDialog(Sender: TObject;
  var AName: string; var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

end.
