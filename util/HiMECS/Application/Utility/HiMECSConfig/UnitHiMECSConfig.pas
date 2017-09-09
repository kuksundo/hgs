unit UnitHiMECSConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UnitConfig, HiMECSConfigCollect,
  JvDialogs, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    JvOpenDialog1: TJvOpenDialog;
    JvSaveDialog1: TJvSaveDialog;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    EncryptOpenCB: TCheckBox;
    EncryptSaveCB: TCheckBox;
    ProjectItemLB: TListBox;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FHiMECSConfig: THiMECSConfig;
    FOptionFileName: string;
    FFirst: Boolean;

    procedure SaveAsConfigData(AForm: TConfigF);
    function LoadConfigData(AForm: TConfigF): boolean;
  public
    procedure SetConfigData;
    procedure LoadConfigCollect2Form(AForm: TConfigF);
//    procedure LoadConfigForm2Collect(AForm: TConfigF);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  ConfigData: TConfigF;
  LStr: string;
begin
  ConfigData := TConfigF.Create(Self);
  try
    with ConfigData do
    begin
      if ShowModal = mrOK then
      begin
        LoadConfigForm2Collect(ConfigData);
        //LStr := IncludeTrailingPathDelimiter(FHiMECSConfig.ConfigPath);
        SaveAsConfigData(ConfigData);;
      end;
    end;//with
  finally
    ConfigData.Free;
  end;//try
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
//  if LoadConfigData then
    SetConfigData;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FHiMECSConfig.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FHiMECSConfig := THiMECSConfig.Create(Self);
  FFirst := True;
end;

procedure TForm1.LoadConfigCollect2Form(AForm: TConfigF);
begin
  AForm.MenuFilenameEdit.Text := FHiMECSConfig.MenuFileName;
  AForm.EngInfoFilenameEdit.Text := FHiMECSConfig.EngineInfoFileName;
  AForm.ParamFilenameEdit.Text := FHiMECSConfig.ParamFileName;
  AForm.ProjInfoFilenameEdit.Text := FHiMECSConfig.ProjectInfoFileName;
  AForm.UserFilenameEdit.Text := FHiMECSConfig.UserFileName;
  AForm.KillProcFilenameEdit.Text := FHiMECSConfig.KillProcListFileName;

  AForm.FormPathEdit.Text :=   FHiMECSConfig.HiMECSFormPath;
  AForm.ConfigPathEdit.Text := FHiMECSConfig.ConfigPath;
  AForm.DocPathEdit.Text := FHiMECSConfig.DocPath;
  AForm.ExePathEdit.Text := FHiMECSConfig.ExesPath;
  AForm.BplPathEdit.Text := FHiMECSConfig.BplsPath;
  AForm.LogPathEdit.Text := FHiMECSConfig.LogPath;

  AForm.CBExtAppInMDI.Checked := FHiMECSConfig.ExtAppInMDI;
  AForm.EngParamEncryptCB.Checked := FHiMECSConfig.EngParamEncrypt;
  AForm.ConfFileFormatRG.ItemIndex := FHiMECSConfig.EngParamFileFormat;
end;

function TForm1.LoadConfigData(AForm: TConfigF): boolean;
begin
  //JvOpenDialog1.InitialDir := FApplicationPath;
  //JvOpenDialog1.Filter := '*.option||*.*';
  Result := JvOpenDialog1.Execute;

  if Result then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      FOptionFileName := jvOpenDialog1.FileName;
      AForm.LoadConfigCollectFromFile(FOptionFileName, EncryptOpenCB.Checked);
    end;
  end;
end;

procedure TForm1.SaveAsConfigData(AForm: TConfigF);
var
  LFileName: string;
  F : TextFile;
begin
  //JvSaveDialog1.InitialDir := FApplicationPath;
  JvSaveDialog1.Filter :=  '*.option';
  JvSaveDialog1.FileName := FOptionFileName;

  if JvSaveDialog1.Execute then
  begin
    LFileName := JvSaveDialog1.FileName;

    if FileExists(LFileName) then
    begin
      if MessageDlg('File is already exist. Are you overwrite? if No press, then save is cancelled.',
      mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        //FEngineInfoCollect.LoadFromFile(LFileName, ExtractFileName(LFileName), False)
      else
      begin
        AssignFile(F, LFileName);
        Rewrite(F);
        CloseFile(F);
      end;
    end;

    LFileName := ChangeFileExt(LFileName, '.option');
    AForm.SaveConfig(LFileName, EncryptSaveCB.Checked);
  end;
end;

procedure TForm1.SetConfigData;
var
  ConfigData: TConfigF;
begin
  ConfigData := TConfigF.Create(Self);
  try
    with ConfigData do
    begin
      LoadConfigData(ConfigData);
//      Self.LoadConfigCollect2Form(ConfigData);
      LoadConfigCollect2Form(ConfigData);

      if ShowModal = mrOK then
      begin
        LoadConfigForm2Collect(ConfigData);
        SaveAsConfigData(ConfigData);
      end;
    end;//with
  finally
    ConfigData.Free;
  end;//try
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  LStr: string;
  LEncrypt: Boolean;
  i: integer;
begin
  Timer1.Enabled := False;
  try
    if FFirst then
    begin
      FFirst := False;

      if ParamCount > 0 then
      begin
        LStr := UpperCase(ParamStr(1));
        i := Pos('/A', LStr);

        if i > 0 then  //A 제거
          FOptionFileName := Copy(ParamStr(1), i+2, Length(ParamStr(1))-i-1);

        LEncrypt := True;

        if ParamCount > 1 then
        begin
          LStr := UpperCase(ParamStr(2));

          if Pos('/E', LStr) > 0 then  //E 제거
          begin
            i := Pos('/E', LStr);
            LStr := Copy(LStr, i+2, Length(LStr)-i-1);

            if UpperCase(LStr) = 'FALSE' then
              LEncrypt := False;
          end;
        end;

        EncryptSaveCB.Checked := LEncrypt;
        EncryptOpenCB.Checked := LEncrypt;

//        LoadConfigCollectFromFile(FOptionFileName, LEncrypt);
//        SetConfigData;
      end;
    end;//if
  finally
//    Timer1.Enabled := True;
  end;
end;

end.
