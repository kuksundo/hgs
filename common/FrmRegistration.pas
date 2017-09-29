unit FrmRegistration;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, UnitRegistrationClass,
  OnGuard, JvBaseDlg, JvSelectDirectory, GetIP;

type
  TRegistrationF = class(TForm)
    Memo1: TMemo;
    btnSave: TButton;
    btnReadme: TButton;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    CompanyEdit: TEdit;
    Label2: TLabel;
    UserNameEdit: TEdit;
    Label5: TLabel;
    EmailEdit: TEdit;
    Label1: TLabel;
    edtSerial: TEdit;
    Label3: TLabel;
    edtReleaseCode: TEdit;
    spdReleaseCode: TBitBtn;
    Memo2: TMemo;
    MachineIDLabel: TLabel;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnReadmeClick(Sender: TObject);
    procedure spdReleaseCodeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    function CheckiifFile: Boolean;
    function CheckirfFile: Boolean;
    function CompareiifNregFile(AhjpFileInfo:TRegistrationInfo): Boolean;
  public
    FRegistrationInfo: TRegistrationInfo;

    class function IsRegistrationValid(var ARegInfo:TRegistrationInfo): Boolean;
    //Return : 1 = IsNotExistRegistry, 2 = IsInValidSerial, 3 = IsInValidRegCode, 4 = IsExpireDate, 5 = IsExpireUsage
    class function IsRegistrationValidFromRegistry(var ARegInfo:TRegistrationInfo; ACurrentUsage: integer = 0): integer;
    function SaveToRegistry(ARegInfo: TRegistrationInfo = nil): Boolean;
    function LoadFromRegistry(ASaveFileName: string): Boolean;
    procedure Object2UI(ARegInfo: TRegistrationInfo = nil);
  end;

var
  RegistrationF: TRegistrationF;

implementation

uses Vcl.ogutil;

{$R *.dfm}

//procedure GetProcessorInfo;
//Var
//  SMBios             : TSMBios;
//  LProcessorInfo     : TProcessorInformation;
//  LSRAMTypes         : TCacheSRAMTypes;
//  i: integer;
//begin
//  SMBios:=TSMBios.Create;
//  try
//      WriteLn('Processor Information');
//    if SMBios.HasProcessorInfo then
//    begin
//      for i := Low(SMBios.ProcessorInfo) to High(SMBios.ProcessorInfo) do
//      begin
//        LProcessorInfo:=SMBios.ProcessorInfo[i];
//        WriteLn('Manufacter         '+LProcessorInfo.ProcessorManufacturerStr);
//        WriteLn('Socket Designation '+LProcessorInfo.SocketDesignationStr);
//        WriteLn('Type               '+LProcessorInfo.ProcessorTypeStr);
//        WriteLn('Familiy            '+LProcessorInfo.ProcessorFamilyStr);
//        WriteLn('Version            '+LProcessorInfo.ProcessorVersionStr);
//        WriteLn(Format('Processor ID       %x',[LProcessorInfo.RAWProcessorInformation^.ProcessorID]));
//        WriteLn(Format('Voltaje            %n',[LProcessorInfo.GetProcessorVoltaje]));
//        WriteLn(Format('External Clock     %d  Mhz',[LProcessorInfo.RAWProcessorInformation^.ExternalClock]));
//        WriteLn(Format('Maximum processor speed %d  Mhz',[LProcessorInfo.RAWProcessorInformation^.MaxSpeed]));
//        WriteLn(Format('Current processor speed %d  Mhz',[LProcessorInfo.RAWProcessorInformation^.CurrentSpeed]));
//        WriteLn('Processor Upgrade   '+LProcessorInfo.ProcessorUpgradeStr);
//        WriteLn(Format('External Clock     %d  Mhz',[LProcessorInfo.RAWProcessorInformation^.ExternalClock]));
//
//        if SMBios.SmbiosVersion>='2.3' then
//        begin
//          WriteLn('Serial Number      '+LProcessorInfo.SerialNumberStr);
//          WriteLn('Asset Tag          '+LProcessorInfo.AssetTagStr);
//          WriteLn('Part Number        '+LProcessorInfo.PartNumberStr);
//          if SMBios.SmbiosVersion>='2.5' then
//          begin
//            WriteLn(Format('Core Count         %d',[LProcessorInfo.RAWProcessorInformation^.CoreCount]));
//            WriteLn(Format('Cores Enabled      %d',[LProcessorInfo.RAWProcessorInformation^.CoreEnabled]));
//            WriteLn(Format('Threads Count      %d',[LProcessorInfo.RAWProcessorInformation^.ThreadCount]));
//            WriteLn(Format('Processor Characteristics %.4x',[LProcessorInfo.RAWProcessorInformation^.ProcessorCharacteristics]));
//          end;
//        end;
//        Writeln;
//
//        if (LProcessorInfo.RAWProcessorInformation^.L1CacheHandle>0) and (LProcessorInfo.L2Chache<>nil)  then
//        begin
//          WriteLn('L1 Cache Handle Info');
//          WriteLn('--------------------');
//          WriteLn('  Socket Designation    '+LProcessorInfo.L1Chache.SocketDesignationStr);
//          WriteLn(Format('  Cache Configuration   %.4x',[LProcessorInfo.L1Chache.RAWCacheInformation^.CacheConfiguration]));
//          WriteLn(Format('  Maximum Cache Size    %d Kb',[LProcessorInfo.L1Chache.GetMaximumCacheSize]));
//          WriteLn(Format('  Installed Cache Size  %d Kb',[LProcessorInfo.L1Chache.GetInstalledCacheSize]));
//          LSRAMTypes:=LProcessorInfo.L1Chache.GetSupportedSRAMType;
//          WriteLn(Format('  Supported SRAM Type   [%s]',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));
//          LSRAMTypes:=LProcessorInfo.L1Chache.GetCurrentSRAMType;
//          WriteLn(Format('  Current SRAM Type     [%s]',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));
//
//          WriteLn(Format('  Error Correction Type %s',[ErrorCorrectionTypeStr[LProcessorInfo.L1Chache.GetErrorCorrectionType]]));
//          WriteLn(Format('  System Cache Type     %s',[SystemCacheTypeStr[LProcessorInfo.L1Chache.GetSystemCacheType]]));
//          WriteLn(Format('  Associativity         %s',[LProcessorInfo.L1Chache.AssociativityStr]));
//        end;
//
//        if (LProcessorInfo.RAWProcessorInformation^.L2CacheHandle>0)  and (LProcessorInfo.L2Chache<>nil)  then
//        begin
//          WriteLn('L2 Cache Handle Info');
//          WriteLn('--------------------');
//          WriteLn('  Socket Designation    '+LProcessorInfo.L2Chache.SocketDesignationStr);
//          WriteLn(Format('  Cache Configuration   %.4x',[LProcessorInfo.L2Chache.RAWCacheInformation^.CacheConfiguration]));
//          WriteLn(Format('  Maximum Cache Size    %d Kb',[LProcessorInfo.L2Chache.GetMaximumCacheSize]));
//          WriteLn(Format('  Installed Cache Size  %d Kb',[LProcessorInfo.L2Chache.GetInstalledCacheSize]));
//          LSRAMTypes:=LProcessorInfo.L2Chache.GetSupportedSRAMType;
//          WriteLn(Format('  Supported SRAM Type   [%s]',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));
//          LSRAMTypes:=LProcessorInfo.L2Chache.GetCurrentSRAMType;
//          WriteLn(Format('  Current SRAM Type     [%s]',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));
//
//          WriteLn(Format('  Error Correction Type %s',[ErrorCorrectionTypeStr[LProcessorInfo.L2Chache.GetErrorCorrectionType]]));
//          WriteLn(Format('  System Cache Type     %s',[SystemCacheTypeStr[LProcessorInfo.L2Chache.GetSystemCacheType]]));
//          WriteLn(Format('  Associativity         %s',[LProcessorInfo.L2Chache.AssociativityStr]));
//        end;
//
//        if (LProcessorInfo.RAWProcessorInformation^.L3CacheHandle>0) and (LProcessorInfo.L3Chache<>nil) then
//        begin
//          WriteLn('L3 Cache Handle Info');
//          WriteLn('--------------------');
//          WriteLn('  Socket Designation    '+LProcessorInfo.L3Chache.SocketDesignationStr);
//          WriteLn(Format('  Cache Configuration   %.4x',[LProcessorInfo.L3Chache.RAWCacheInformation^.CacheConfiguration]));
//          WriteLn(Format('  Maximum Cache Size    %d Kb',[LProcessorInfo.L3Chache.GetMaximumCacheSize]));
//          WriteLn(Format('  Installed Cache Size  %d Kb',[LProcessorInfo.L3Chache.GetInstalledCacheSize]));
//          LSRAMTypes:=LProcessorInfo.L3Chache.GetSupportedSRAMType;
//          WriteLn(Format('  Supported SRAM Type   [%s]',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));
//          LSRAMTypes:=LProcessorInfo.L3Chache.GetCurrentSRAMType;
//          WriteLn(Format('  Current SRAM Type     [%s]',[SetToString(TypeInfo(TCacheSRAMTypes), LSRAMTypes)]));
//
//          WriteLn(Format('  Error Correction Type %s',[ErrorCorrectionTypeStr[LProcessorInfo.L3Chache.GetErrorCorrectionType]]));
//          WriteLn(Format('  System Cache Type     %s',[SystemCacheTypeStr[LProcessorInfo.L3Chache.GetSystemCacheType]]));
//          WriteLn(Format('  Associativity         %s',[LProcessorInfo.L3Chache.AssociativityStr]));
//        end;
//
//        Readln;
//      end;
//    end;
//      Writeln('No Processor Info was found');
//  finally
//   SMBios.Free;
//  end;
//end;

procedure TRegistrationF.btnReadmeClick(Sender: TObject);
begin
  //.irf 파일 로드
  if not CheckirfFile then
    exit;

  ModalResult := mrOK

//  if edtReleaseCode.Text <> '' then
//    ModalResult := mrOK
//  else
//  begin
//    ModalResult := mrCancel;
//    ShowMessage('Registration Failed!');
//    TerminateProcess(GetCurrentProcess, 0);
//    halt(0);
//  end;
end;

procedure TRegistrationF.btnSaveClick(Sender: TObject);
begin
  CheckiifFile;
  ModalResult := mrCancel;
end;

procedure TRegistrationF.Button1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

function TRegistrationF.CheckiifFile: Boolean;
var
  LFN, LPassPhrase: string;
  LCode: TCode;
begin
  Result := False;

  FRegistrationInfo.RegCodeRecord.CustomerCompanyName := CompanyEdit.Text;
  FRegistrationInfo.RegCodeRecord.CustomerUserName := UserNameEdit.Text;
  FRegistrationInfo.RegCodeRecord.CustomerEmail := EmailEdit.Text;
  LFN := edtSerial.Text;
  FRegistrationInfo.RegCodeRecord.SerialCode := FRegistrationInfo.DeleteSeperator(LFN);
//  FRegistrationInfo.RegCode := edtReleaseCode.Text;

  LFN := IncludeTrailingBackSlash(FRegistrationInfo.RegCodeRecord.AppFullPath) + FRegistrationInfo.RegCodeRecord.AppName;
  LFN := ChangeFileExt(LFN,'.iif');
  LPassPhrase := FRegistrationInfo.MakePassPhrase(FRegistrationInfo.RegCodeRecord.AppName);
  FRegistrationInfo.SaveToJSONFile(LFN, LPassPhrase, True);
  LPassPhrase := Caption;
  Caption := ExtractFileName(LFN);
  ShowMessage(LFN + ' file saved successfully.');
  Caption := LPassPhrase;

  Result := True;
end;

function TRegistrationF.CheckirfFile: Boolean;
var
  LRegInfo : TRegistrationInfo;
  LPhrase: string;
begin
  Result := False;
  OpenDialog1.Filter := 'install reg file(*.irf)|*.irf|All Files(*.*)|*.*';

  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      LRegInfo:= TRegistrationInfo.Create(nil);
      try
        LPhrase := LRegInfo.MakePassPhrase(FRegistrationInfo.RegCodeRecord.AppName);
        LRegInfo.LoadFromJSONFile(OpenDialog1.FileName, LPhrase, True);

        if LRegInfo.IsValidSerialCode then
        begin
          if LRegInfo.IsValidReleaseCode then
          begin
            LRegInfo.SaveToRegistry;
            Result := True;
            ShowMessage('Success registration!');
          end;
        end;
      finally
        LRegInfo.Free;
      end;
    end;
  end;
end;

function TRegistrationF.CompareiifNregFile(AhjpFileInfo: TRegistrationInfo): Boolean;
begin
  Result := (AhjpFileInfo.RegCodeRecord.AppName = FRegistrationInfo.RegCodeRecord.AppName) and
            (AhjpFileInfo.RegCodeRecord.CustomerCompanyName = FRegistrationInfo.RegCodeRecord.CustomerCompanyName) and
            (AhjpFileInfo.RegCodeRecord.CustomerUserName = FRegistrationInfo.RegCodeRecord.CustomerUserName) and
            (AhjpFileInfo.RegCodeRecord.CustomerEmail = FRegistrationInfo.RegCodeRecord.CustomerEmail) and
            (AhjpFileInfo.RegCodeRecord.SerialCode = FRegistrationInfo.RegCodeRecord.SerialCode) and
            (AhjpFileInfo.RegCodeRecord.MachineID = FRegistrationInfo.RegCodeRecord.MachineID);
end;

procedure TRegistrationF.FormCreate(Sender: TObject);
var
  LStr, LPhrase: string;
begin
  FRegistrationInfo := TRegistrationInfo.Create(nil);
  FRegistrationInfo.GetProcessorInfo;
  FRegistrationInfo.InitRegInfoFromClient(Application.ExeName);
  LStr := ChangeFileExt(Application.ExeName, '.iif');

  if FileExists(LStr) then
  begin
    LPhrase := FRegistrationInfo.MakePassPhrase(FRegistrationInfo.RegCodeRecord.AppName);
    FRegistrationInfo.LoadFromJSONFile(LStr, LPhrase, True);
    CompanyEdit.Text := FRegistrationInfo.RegCodeRecord.CustomerCompanyName;
    UserNameEdit.Text := FRegistrationInfo.RegCodeRecord.CustomerUserName;
    EMailEdit.Text := FRegistrationInfo.RegCodeRecord.CustomerEmail;
    LPhrase := FRegistrationInfo.RegCodeRecord.SerialCode;
    edtSerial.Text := FRegistrationInfo.InsertSeperator(LPhrase);
  end;

  MachineIDLabel.Caption := IntToStr(FRegistrationInfo.RegCodeRecord.MachineID);
end;

procedure TRegistrationF.FormDestroy(Sender: TObject);
begin
  FRegistrationInfo.Free;
end;

class function TRegistrationF.IsRegistrationValid(
  var ARegInfo: TRegistrationInfo): Boolean;
var
  LRegFile,
  LPhrase, LSerialCode: string;
  LInstallInfo: TRegistrationInfo;
  LCPUID: int64;
  LResult: Boolean;

  function ShowRegistrationForm: boolean;
  var
    LRegistrationF: TRegistrationF;
  begin
    Result := False;
    LRegistrationF := TRegistrationF.Create(nil);
    try
//      if not Assigned(ARegInfo) then
//      begin
//        ARegInfo := TRegistrationInfo.Create(nil);
//        ARegInfo.Assign(LRegistrationF.FRegistrationInfo);
//      end;
//
//      LRegistrationF.FRegistrationInfo.Assign(ARegInfo);
//      LRegistrationF.Object2UI();
      LRegistrationF.ShowModal;
      ARegInfo.Assign(LRegistrationF.FRegistrationInfo);

      if LRegistrationF.ModalResult = mrOK then
        Result := True;
    finally
      LRegistrationF.Free;
    end;
  end;
begin
  Result := False;
  //프로그램 처음 설치 시 생성되는 파일: 설치 일자 CPU ID, Serial No 등이 저장됨
  //.iif 파일은 실행화일과 이름이 같아야 함
  LRegFile := ChangeFileExt(Application.ExeName, '.iif');

  LPhrase := ARegInfo.MakePassPhrase(ExtractFileName(Application.ExeName));

  if FileExists(LRegFile) then
  begin
    LSerialCode := '';
    LInstallInfo := TRegistrationInfo.Create(nil);
    try
      LInstallInfo.LoadFromJSONFile(LRegFile, LPhrase, True);
      LSerialCode := LInstallInfo.RegCodeRecord.SerialCode;
    finally
      LInstallInfo.Free;
    end;
  end
  else
  begin
//    ShowMessage('The install info file does not exist!');
//    halt(0);
  end;

  if not Assigned(ARegInfo) then
  begin
    ARegInfo := TRegistrationInfo.Create(nil);
    //MachineID를 저장함
    ARegInfo.GetProcessorInfo;
    //AppName을 ARegInfo에 저장함
    ARegInfo.InitRegInfoFromClient(Application.ExeName);
    //SerialCode를 ARegInfo에 저장함
    ARegInfo.RegCodeRecord.SerialCode := LSerialCode;
  end;

  LRegFile := ChangeFileExt(Application.ExeName, '.irf');

  if not FileExists(LRegFile) then
  begin
    if ARegInfo.IsExistRegInfoAtRegistry then
    begin
      ARegInfo.LoadFromRegistry;
      ARegInfo.SaveToJSONFile(LRegFile, LPhrase, True);
    end;
  end;

  while True do
  begin
    if (FileExists(LRegFile)) then//(LModal = mrOK) and
    begin
      try
        //.irf file:AppName, MachineID, SerialNo가 포함 되어 있음
        ARegInfo.LoadFromJSONFile(LRegFile, LPhrase, True);

        if not ARegInfo.IsExistRegInfoAtRegistry then
          ARegInfo.SaveToRegistry;

        LResult := ARegInfo.IsValidSerialCode;

        if LResult then
        begin
          Result := ARegInfo.IsValidReleaseCode;

          if Result then
          begin
//            if ARegInfo.IsUseOgUtil4MachineId then
//            begin
//
//            end
//            else
              exit;
          end
          else
          begin
            ShowMessage('Not Registered.' + #13#10 + 'Register first Please!');
          end;
        end
        else
        begin
          MessageDlg('Invalid Serial Number.' + #13#10 + 'Please check your entry and try again.', mtError, [mbOK], 0);
        end;
      finally
//        LInstallInfo.Free;
      end;
    end;

    if not ShowRegistrationForm then //Reg Code가 정상이고 Registration Button을 누른 경우
    begin
      Result := False;
      Break;
    end;
  end; //while

//        if LInstallInfo.RegCode = '' then
//        begin
//          ShowMessage('Not Registered.' + #13#10 + 'Register first Please!');
//        end;

//    if not FileExists(LRegFile) then
//    begin
//      ShowMessage('Install Infomation File(' + LRegFile + ') not found.');
//      TerminateProcess(GetCurrentProcess, 0);
//  //    halt(0);
//    end;

//    if not FileExists(LInstallInfo.RegFileName) then
//    begin
//      ShowMessage('Registration File(' + LInstallInfo.RegFileName + ') not found.');
//      TerminateProcess(GetCurrentProcess, 0);
//  //    halt(0);
//    end;

//    if not Assigned(ARegInfo) then
//      ARegInfo := TRegistrationInfo.Create(nil);

//    //.hjp file(RegCode가 포함되어 있음)
//    ARegInfo.LoadFromJSONFile(LInstallInfo.RegFileName, LPhrase, True);
//    //현재 시스템의 CPU ID를 가져옴
//    LCPUID := ABS(CreateMachineID([{midUser,} midSystem{, midNetwork, midDrives}]));
//    //.hjp file의 CPUID와 현시스템의 CPUID를 비교함
//    Result := LCPUID = ARegInfo.MachineID;
//
    if Result then
    begin
      ARegInfo.SaveToRegistry;
    end
    else
    begin
      ShowMessage('Not Allowed run on this machine');
      TerminateProcess(GetCurrentProcess, 0);
    end

//
//    Result := ARegInfo.IsReleaseCodeValid(ARegInfo.RegCode);
end;

class function TRegistrationF.IsRegistrationValidFromRegistry(
  var ARegInfo: TRegistrationInfo; ACurrentUsage: integer): integer;
begin
  Result := -1;

  if not Assigned(ARegInfo) then
    ARegInfo := TRegistrationInfo.Create(nil);

  //Registry에 등록정보가 존재하면
  if ARegInfo.IsExistRegInfoAtRegistry then
  begin
    ARegInfo.LoadFromRegistry;

    //SerialCode가 유효한지 확인
    if ARegInfo.IsValidSerialCode then
    begin
      //ReleaseCode가 유효한지 확인
      if ARegInfo.IsValidReleaseCode then
      begin
        if ctDate in ARegInfo.RegCodeRecord.CodeTypes then
        begin
          if ARegInfo.RegCodeRecord.ExpireDate < now then
          begin
            Result := 4;
            Exit;
          end;
        end;

        if ctUsage in ARegInfo.RegCodeRecord.CodeTypes then
        begin
          if ARegInfo.RegCodeRecord.ExpireUsage < ACurrentUsage then
          begin
            Result := 5;
            Exit;
          end;
        end;

        Result := 0;
      end
      else
        Result := 3
    end
    else
      Result := 2
  end
  else
  begin
    //MachineID를 저장함
    ARegInfo.GetProcessorInfo;
    //AppName을 ARegInfo에 저장함
    ARegInfo.InitRegInfoFromClient(Application.ExeName);
    //SerialCode를 ARegInfo에 저장함
//    ARegInfo.SerialCode := LSerialCode;
    ARegInfo.RegCodeRecord.IPAddress := GetLocalIP(0);
    Result := 1;
  end;

end;

function TRegistrationF.LoadFromRegistry(ASaveFileName: string): Boolean;
var
  LRegInfo: TRegistrationInfo;
  LPhrase: string;
begin
  LRegInfo := TRegistrationInfo.Create(nil);
  try
    LPhrase := LRegInfo.MakePassPhrase(ExtractFileName(Application.ExeName));
    LRegInfo.LoadFromRegistry;

    if LRegInfo.IsValidReleaseCode then
    begin
      LRegInfo.SaveToJSONFile(ASaveFileName, LPhrase, True);
    end;
  finally
    LRegInfo.Free;
  end;
end;

procedure TRegistrationF.Object2UI(ARegInfo: TRegistrationInfo);
var
  LStr: string;
begin
  if not Assigned(ARegInfo) then
    ARegInfo := FRegistrationInfo;

  ARegInfo.MakeApplicationKey(ARegInfo.FApplicationKey, ARegInfo.RegCodeRecord.AppName);

  CompanyEdit.Text := ARegInfo.RegCodeRecord.CustomerCompanyName;
  UserNameEdit.Text := ARegInfo.RegCodeRecord.CustomerUserName;
  EmailEdit.Text := ARegInfo.RegCodeRecord.CustomerEmail;

//  if ARegInfo.SerialCode > 0 then
//  begin
//    LStr := ARegInfo.EncodeSerialNo(FRegistrationInfo.FApplicationKey, ARegInfo.SerialNo);
//    ARegInfo.InsertSeperator(LStr);
//    edtSerial.Text := LStr;
//  end;

  LStr := ARegInfo.RegCodeRecord.SerialCode;
  edtSerial.Text := ARegInfo.InsertSeperator(LStr);
  edtReleaseCode.Text := ARegInfo.RegCodeRecord.RegCode;
end;

function TRegistrationF.SaveToRegistry(ARegInfo: TRegistrationInfo): Boolean;
//var
//  LRegInfo: TRegistrationInfo;
//  LPhrase: string;
begin
  if Assigned(ARegInfo) then
    ARegInfo.SaveToRegistry;

//  LRegInfo := TRegistrationInfo.Create(nil);
//  try
//    LPhrase := LRegInfo.MakePassPhrase(ExtractFileName(Application.ExeName));
//    LRegInfo.SaveToRegistry;
//  finally
//    LRegInfo.Free;
//  end;
end;

procedure TRegistrationF.spdReleaseCodeClick(Sender: TObject);
var
  LRegInfo: TRegistrationInfo;
  LPhrase: string;
begin
  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      LRegInfo := TRegistrationInfo.Create(nil);
      try
        LPhrase := FRegistrationInfo.MakePassPhrase(FRegistrationInfo.RegCodeRecord.AppName);
        //.irf file(RegCode가 포함되어 있음)
        LRegInfo.LoadFromJSONFile(OpenDialog1.FileName, LPhrase, True);

//        if CompareiifNregFile(LRegInfo) then
//        begin
        LRegInfo.RegCodeRecord.RegFileName := OpenDialog1.FileName;
        LPhrase := LRegInfo.RegCodeRecord.RegCode;
        edtReleaseCode.Text := LRegInfo.InsertSeperator(LPhrase);
        FRegistrationInfo.Assign(LRegInfo);
//        end
//        else
//          ShowMessage('Release Code is not valid');
      finally
        LRegInfo.Free;
      end;
    end;
  end;
end;

end.
