unit UnitAlarmConfigClass;

interface

uses classes, SysUtils, INIPersist, HiMECSConst, EngineParameterClass, BaseConfigCollect;

type
  TAlarmConfigCollect = class;
  TAlarmConfigItem = class;
  TAlarmConfigEPCollect = class;   //Alarm Config�� Engine Parameter Collect
  TAlarmConfigEPItem = class;

  TAlarmConfig = class(TpjhBase)
  private
    FAlarmConfigCollect: TAlarmConfigCollect;
    FAlarmDBDriver,
    FAlarmDBFileName,
    FModbusDBFileName: string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
  published
    property AlarmConfigCollect: TAlarmConfigCollect read FAlarmConfigCollect write FAlarmConfigCollect;
    //Config Form�� Component Name�� �����
    [JSON2Component('AlarmItemFileEdit')]
    property AlarmDBDriver: string read FAlarmDBDriver write FAlarmDBDriver;
    property AlarmDBFileName: string read FAlarmDBFileName write FAlarmDBFileName;
    property ModbusDBFileName: string read FModbusDBFileName write FModbusDBFileName;
  end;

  //HITEMS_ALARM_CONFIG ���̺�� ���� �ؾ� ��
  TAlarmConfigItem = class(TCollectionItem)
  private
    FUserID: string;
    FCategory: string;
    FProjNo: string;
    FEngNo: string;
    FTagName: string;
    FAlarmSetType: TAlarmSetType; //���� �˶��� � �������� ������
    FSetValue: string;    //�˶� ���� ��(limit value)
    FSensorValue: string; //�����κ���  ������ ��
    FAlarmPriority: TAlarmPriority;
    FNotifyTerminals: integer;// set of TNotifyTerminal;
    FNotifyApps: integer;//set of TNotifyApp;
    FNeedAck: Boolean;
    FDelay: integer; //mSec
    FDeadBand: integer;
    FIsAnalog: Boolean; //Analog or digital
    FIsOutLamp: Boolean; //�汤�� ���
    FIsOnlyRun: Boolean; //Running �ÿ��� �˶� ����
    FDueDay: word; //���� ��ȿ �Ⱓ(����� ���� �ϼ�)
    FRegDate: TDateTime; //���� ����
    FAlarmMessage: string; //������ ��� EngineParameter�� Descript�� ǥ�õ�
    FDBAction: string; //'ALL': Delete & Insert,'I': Insert, 'U': Update, 'D': Delete
    FRecipients: string; //������ Notify ������ ���(';'���� ���е�)

    FEngType: string; //���� Type(HITEMS_ALARM_CONFIG ���̺��� ���� �ȵ�)
    FIssueDateTime: TDateTime;
    FReleaseDateTime: TDateTime;
    FAcknowledgedTime: TDateTime;
    FSuppressedTime: TDateTime;
    FAlarmHistoryTableName: string; //Alarm History Table �̸�
    FMonTableName: string;//Monitoring Data Table Name
    FNextGridRow: Pointer;
  public
    procedure AssignTo(Dest: TAlarmConfigItem);

    property IssueDateTime: TDateTime read FIssueDateTime write FIssueDateTime;
    property ReleaseDateTime: TDateTime read FReleaseDateTime write FReleaseDateTime;
    property AcknowledgedTime: TDateTime read FAcknowledgedTime write FAcknowledgedTime;
    property SuppressedTime: TDateTime read FSuppressedTime write FSuppressedTime;
    property AlarmHistoryTableName: string read FAlarmHistoryTableName write FAlarmHistoryTableName;
    property MonTableName: string read FMonTableName write FMonTableName;
    property NextGridRow: Pointer read FNextGridRow write FNextGridRow;
  published
    property UserID: string read FUserID write FUserID;
    property Category: string read FCategory write FCategory;
    property ProjNo: string read FProjNo write FProjNo;
    property EngNo: string read FEngNo write FEngNo;
    property TagName: string read FTagName write FTagName;
    property AlarmSetType: TAlarmSetType read FAlarmSetType write FAlarmSetType;
    property SetValue: string read FSetValue write FSetValue;
    property SensorValue: string read FSensorValue write FSensorValue;
    property AlarmPriority: TAlarmPriority read FAlarmPriority write FAlarmPriority;
    property NotifyTerminals: integer read FNotifyTerminals write FNotifyTerminals;
    property NotifyApps: integer read FNotifyApps write FNotifyApps;
    property NeedAck: Boolean read FNeedAck write FNeedAck;
    property Delay: integer read FDelay write FDelay;
    property DeadBand: integer read FDeadBand write FDeadBand;
    property IsAnalog: Boolean read FIsAnalog write FIsAnalog;
    property IsOutLamp: Boolean read FIsOutLamp write FIsOutLamp;
    property IsOnlyRun: Boolean read FIsOnlyRun write FIsOnlyRun;
    property DueDay: word read FDueDay write FDueDay;
    property RegDate: TDateTime read FRegDate write FRegDate;
    property AlarmMessage: string read FAlarmMessage write FAlarmMessage;
    property EngType: string read FEngType write FEngType;
    property DBAction: string read FDBAction write FDBAction;
    property Recipients: string read FRecipients write FRecipients;
  end;

  TAlarmConfigCollect = class(TCollection)
  private
    //'ALL': Delete & Insert
    //'INSERT': Insert All Items
    //'UPDATE': Update All Items
    //'DELETE': Delete All Items
    //'EACH': Item�� DBAction�� ����(EACH�� �ƴϸ� Item�� DBAction ����)
    FDBAction: string;

    function GetItem(Index: Integer): TAlarmConfigItem;
    procedure SetItem(Index: Integer; const Value: TAlarmConfigItem);
  public
    procedure AssignTo(Dest: TAlarmConfigCollect);
    function Add: TAlarmConfigItem;
    function Insert(Index: Integer): TAlarmConfigItem;
    property Items[Index: Integer]: TAlarmConfigItem read GetItem  write SetItem; default;
  published
    property DBAction: string read FDBAction write FDBAction;
  end;

  //UnitAlarmListConfigEdit.grid_Code�� Row�� �����
  TAlarmConfigEPItem = class(TCollectionItem)
  private
    FTagName,
    FDescription,  //Matrix Data�� ��� Description(XAxis Desc;YAxis Desc;ZAxis Desc)
    FUnit,
    FProjNo, //�����ȣ
    FEngNo: string;//��������(1���� ����)
    FIsAnalog: Boolean;

    FSensorType: TSensorType;
    FParameterCategory: TParameterCategory;
    FParameterType: TParameterType;
    FParameterSource: TParameterSource;
  published
    property ProjNo: string read FProjNo write FProjNo;    //AMS�� ���� �߰���
    property EngNo: string read FEngNo write FEngNo; //AMS�� ���� �߰���
    property TagName: string read FTagName write FTagName;
    property Description: string read FDescription write FDescription;
    property FFUnit: string read FUnit write FUnit;
    property IsAnalog: Boolean read FIsAnalog write FIsAnalog;
    property SensorType: TSensorType read FSensorType write FSensorType;
    property ParameterCatetory: TParameterCategory read FParameterCategory write FParameterCategory;
    property ParameterType: TParameterType read FParameterType write FParameterType;
    property ParameterSource: TParameterSource read FParameterSource write FParameterSource;
  end;

  //Alarm Config�� Engine Parameter Collect
  TAlarmConfigEPCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TAlarmConfigEPItem;
    procedure SetItem(Index: Integer; const Value: TAlarmConfigEPItem);
  public
    procedure CopyEPFromEngineParameterWithPrjoNoEngNo(AProjNo, AEngno: string;
      AEP: TEngineParameterCollect);

    function Add: TAlarmConfigEPItem;
    function Insert(Index: Integer): TAlarmConfigEPItem;
    property Items[Index: Integer]: TAlarmConfigEPItem read GetItem  write SetItem; default;
  end;

implementation

function TAlarmConfigCollect.Add: TAlarmConfigItem;
begin
  Result := TAlarmConfigItem(inherited Add);
end;

procedure TAlarmConfigCollect.AssignTo(Dest: TAlarmConfigCollect);
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].AssignTo(Dest.Add);
end;

function TAlarmConfigCollect.GetItem(Index: Integer): TAlarmConfigItem;
begin
  Result := TAlarmConfigItem(inherited Items[Index]);
end;

function TAlarmConfigCollect.Insert(Index: Integer): TAlarmConfigItem;
begin
  Result := TAlarmConfigItem(inherited Insert(Index));
end;

procedure TAlarmConfigCollect.SetItem(Index: Integer; const Value: TAlarmConfigItem);
begin
  Items[Index].Assign(Value);
end;

{ TAlarmConfig }

procedure TAlarmConfig.Clear;
begin
  AlarmConfigCollect.Clear;
  AlarmDBDriver := '';
  AlarmDBFileName := '';
end;

constructor TAlarmConfig.Create(AOwner: TComponent);
begin
  FAlarmConfigCollect := TAlarmConfigCollect.Create(TAlarmConfigItem);
end;

destructor TAlarmConfig.Destroy;
begin
  inherited Destroy;
  FAlarmConfigCollect.Free;
end;

{ TAlarmConfigEPCollect }

function TAlarmConfigEPCollect.Add: TAlarmConfigEPItem;
begin
  Result := TAlarmConfigEPItem(inherited Add);
end;

procedure TAlarmConfigEPCollect.CopyEPFromEngineParameterWithPrjoNoEngNo(AProjNo, AEngNo: string;
  AEP: TEngineParameterCollect);
var
  i: integer;
begin
  Self.Clear;

  for i := 0 to AEP.Count - 1 do
  begin
    if (AProjNo = AEP.Items[i].ProjNo) and
      (AEngNo = AEP.Items[i].EngNo) then
    begin
      with Add do
      begin
        FTagName := AEP.Items[i].TagName;
        FDescription := AEP.Items[i].Description;
        FUnit := AEP.Items[i].FUnit;
        FProjNo := AEP.Items[i].ProjNo; //�����ȣ
        FEngNo := AEP.Items[i].EngNo;
      end;
    end;
  end;
end;

function TAlarmConfigEPCollect.GetItem(Index: Integer): TAlarmConfigEPItem;
begin
  Result := TAlarmConfigEPItem(inherited Items[Index]);
end;

function TAlarmConfigEPCollect.Insert(Index: Integer): TAlarmConfigEPItem;
begin
  Result := TAlarmConfigEPItem(inherited Insert(Index));
end;

procedure TAlarmConfigEPCollect.SetItem(Index: Integer;
  const Value: TAlarmConfigEPItem);
begin
  Items[Index].Assign(Value);
end;

{ TAlarmConfigItem }

procedure TAlarmConfigItem.AssignTo(Dest: TAlarmConfigItem);
begin
  with Dest do
  begin
    UserID := Self.UserID;
    Category := Self.Category;
    ProjNo := Self.ProjNo;
    EngNo := Self.EngNo;
    TagName := Self.TagName;
    AlarmSetType := Self.AlarmSetType;
    SetValue := Self.SetValue;
    SensorValue := Self.SensorValue;
    AlarmPriority := Self.AlarmPriority;
    NotifyTerminals := Self.NotifyTerminals;
    NotifyApps := Self.NotifyApps;
    NeedAck := Self.NeedAck;
    Delay := Self.Delay;
    DeadBand := Self.DeadBand;
    IsAnalog := Self.IsAnalog;
    IsOutLamp := Self.IsOutLamp;
    IsOnlyRun := Self.IsOnlyRun;
    DueDay := Self.DueDay;
    RegDate := Self.RegDate;
    AlarmMessage := Self.AlarmMessage;
    EngType := Self.EngType;
    DBAction := Self.DBAction;
    Recipients := Self.FRecipients;

    IssueDateTime := Self.IssueDateTime;
    ReleaseDateTime := Self.ReleaseDateTime;
    AcknowledgedTime := Self.AcknowledgedTime;
    AlarmHistoryTableName := Self.AlarmHistoryTableName;
    NextGridRow := Self.NextGridRow;
  end;
end;

end.
