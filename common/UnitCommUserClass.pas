unit UnitCommUserClass;

interface

uses classes, SysUtils, IniPersist, Generics.Legacy;

type
  TCommUserItem = class(TCollectionItem)
  private
    FUserID,
    FPasswd,
    FIpAddress,
    FUserName,
    FSessionId,
    FUrl,
    FServerPortNo,
    FClientPortNo: string;
  public
    procedure AssignTo(Dest: TCommUserItem);
  published
    property UserID: string read FUserID write FUserID;
    property Passwd: string read FPasswd write FPasswd;
    property IpAddress: string read FIpAddress write FIpAddress;
    property UserName: string read FUserName write FUserName;
    property SessionId: string read FSessionId write FSessionId;
    property Url: string read FUrl write FUrl;
    property ServerPortNo: string read FServerPortNo write FServerPortNo;
    property ClientPortNo: string read FClientPortNo write FClientPortNo;
  end;

  TCommUserCollect<T: TCommUserItem> = class(Generics.Legacy.TCollection<T>)
  end;

  TCommUser = class(TIniPersist)
  private
    FRMISUserCollect: TCommUserCollect<TCommUserItem>;
//    FAlarmDBDriver,
//    FAlarmDBFileName: string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
  published
    property CommUserCollect: TCommUserCollect<TCommUserItem> read FRMISUserCollect write FRMISUserCollect;
    //Config Form의 Component Name을 기록함
//    [JSON2Component('AlarmItemFileEdit')]
//    property AlarmDBDriver: string read FAlarmDBDriver write FAlarmDBDriver;
  end;

const
  RCS_REMOTEDEBUG_IP = '10.22.42.132';
  RCS_REMOTEDEBUG_PORT = '8091';

implementation

{ TCommUser }

procedure TCommUser.Clear;
begin

end;

constructor TCommUser.Create(AOwner: TComponent);
begin
  FRMISUserCollect := TCommUserCollect<TCommUserItem>.Create;
end;

destructor TCommUser.Destroy;
begin
  FRMISUserCollect.Free;

  inherited;
end;

{ TCommUserItem }

procedure TCommUserItem.AssignTo(Dest: TCommUserItem);
begin

end;

end.
