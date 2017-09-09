unit UnitSTOMP2IPCClientAll_basic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TimerPool,
  UnitIPCClientAll, UnitSTOMPClass, UnitConfigIniClass, UnitSTOMP2IPCClientAllConfig;

type
  TSTOMP2IPCClientAllF = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FIPCClientAll: TIPCClientAll;
    FpjhSTOMPClass: TpjhSTOMPClass;
    FMQUser,
    FMQPasswd,
    FMQTopic,
    FMQServerIp: string;
    FPJHTimerPool: TPJHTimerPool;
    FParamFileNameChanged: Boolean;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
  protected
//    procedure OnMakeData4Simulate(Sender : TObject; Handle : Integer;
//            Interval : Cardinal; ElapsedTime : LongInt);
  public
    FExeFilePath: string;
    FSettings : TConfigSettings;

    procedure InitVar;
    procedure DestroyVar;
    procedure InitSTOMP;
    procedure DestroySTOMP;
    procedure InitIPCClientAll;
    procedure DestroyIPCClientAll;
  end;

var
  STOMP2IPCClientAllF: TSTOMP2IPCClientAllF;

implementation

{$R *.dfm}

{ TSTOMP2IPCClientAllF }

procedure TSTOMP2IPCClientAllF.ApplyUI;
begin
  InitIPCClientAll;
  InitSTOMP;
end;

procedure TSTOMP2IPCClientAllF.DestroyIPCClientAll;
begin
  if Assigned(FIPCClientAll) then
    FIPCClientAll.Free;
end;

procedure TSTOMP2IPCClientAllF.DestroySTOMP;
begin
  if Assigned(FpjhSTOMPClass) then
    FpjhSTOMPClass.Free;
end;

procedure TSTOMP2IPCClientAllF.DestroyVar;
begin
  if Assigned(FPJHTimerPool) then
  begin
    FPJHTimerPool.RemoveAll;
    FreeAndNil(FPJHTimerPool);
  end;

  DestroySTOMP;
  FSettings.Free;
end;

procedure TSTOMP2IPCClientAllF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TSTOMP2IPCClientAllF.FormDestroy(Sender: TObject);
begin
  DestroyVar;
end;

procedure TSTOMP2IPCClientAllF.InitIPCClientAll;
begin
  if not Assigned(FIPCClientAll) then
    FIPCClientAll := TIPCClientAll.Create;

  if FParamFileNameChanged then
    FIPCClientAll.FEngineParameter.LoadFromJSONFile(FSettings.ParamFileName)
end;

procedure TSTOMP2IPCClientAllF.InitSTOMP;
begin
  FMQUser := 'pjh';
  FMQPasswd := 'pjh';
//  if FMQTopic = '' then
//    FIPCClientAll.FEngineParameter.
  FMQTopic := 'UniqueEngineName';
  FMQServerIp := '10.14.21.117';

  if not Assigned(FpjhSTOMPClass) then
    FpjhSTOMPClass := TpjhSTOMPClass.Create(FMQUser,FMQPasswd,FMQServerIp,FMQTopic);
end;

procedure TSTOMP2IPCClientAllF.InitVar;
begin
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FExeFilePath := ExtractFilePath(Application.ExeName);
  FSettings := TConfigSettings.create(ChangeFileExt(Application.ExeName, '.ini'));
  LoadConfigFromFile;

  if FileExists(FSettings.ParamFileName) then
  begin
    InitIPCClientAll;
    InitSTOMP;
  end
  else
    ShowMessage('Param File Name is empty or not exist    !');
end;

procedure TSTOMP2IPCClientAllF.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TSTOMP2IPCClientAllF.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);
end;

procedure TSTOMP2IPCClientAllF.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);
end;

procedure TSTOMP2IPCClientAllF.SetConfig;
var
  LConfigF: TConfigF;
  LParamFileName: string;
begin
  LConfigF := TConfigF.Create(Self);

  try
    LParamFileName := FSettings.ParamFileName;
    LoadConfig2Form(LConfigF);

    if LConfigF.ShowModal = mrOK then
    begin
      LoadConfigForm2Object(LConfigF);
      FSettings.Save();

      FParamFileNameChanged := LParamFileName <> FSettings.ParamFileName;
      ApplyUI;
    end;
  finally
    LConfigF.Free;
  end;
end;

end.
