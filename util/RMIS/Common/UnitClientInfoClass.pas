unit UnitClientInfoClass;

interface

uses classes, SysUtils, ExtCtrls, Vcl.Graphics, BaseConfigCollect;

type
  TClientInfoCollect = class;
  TClientInfoItem = class;

  TClientInfo = class(TpjhBase)
  private
    FClientInfoCollect: TClientInfoCollect;
    FIPAddress: string;
    FPortNo: integer;
    FComputerName: string;
    FUserName: string;
    FGUID: string;
    FMacAddress: string;
//    FInterface: IInterface;
    FArryIndexOfIntf: integer;
  public
    FQryNameList4Changed: TStringList;

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
  published
    property ClientInfoCollect: TClientInfoCollect read FClientInfoCollect write FClientInfoCollect;
    property IPAddress: string read FIPAddress write FIPAddress;
    property PortNo: integer read FPortNo write FPortNo;
    property MacAddress: string read FMacAddress write FMacAddress;
    property ComputerName: string read FComputerName write FComputerName;
    property UserName: string read FUserName write FUserName;
    property GUID: string read FGUID write FGUID;
//    property FFInterface: IInterface  read FInterface write FInterface;
    property ArryIndexOfIntf: integer read FArryIndexOfIntf write FArryIndexOfIntf;
  end;

  TClientInfoItem = class(TCollectionItem)
  private
    FMethodName: string;
    FQueryInterval: integer; //mSec
  published
    property MethodName: string read FMethodName write FMethodName;
    property QueryInterval: integer read FQueryInterval write FQueryInterval;
  end;

  TClientInfoCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TClientInfoItem;
    procedure SetItem(Index: Integer; const Value: TClientInfoItem);
  public
    function Add: TClientInfoItem;
    function Insert(Index: Integer): TClientInfoItem;
    property Items[Index: Integer]: TClientInfoItem read GetItem  write SetItem; default;
  end;

implementation

{ TClientInfoCollect }

function TClientInfoCollect.Add: TClientInfoItem;
begin
  Result := TClientInfoItem(inherited Add);
end;

function TClientInfoCollect.GetItem(Index: Integer): TClientInfoItem;
begin
  Result := TClientInfoItem(inherited Items[Index]);
end;

function TClientInfoCollect.Insert(Index: Integer): TClientInfoItem;
begin
  Result := TClientInfoItem(inherited Insert(Index));
end;

procedure TClientInfoCollect.SetItem(Index: Integer;
  const Value: TClientInfoItem);
begin
  Items[Index].Assign(Value);
end;

{ TClientInfo }

procedure TClientInfo.Clear;
begin
  FQryNameList4Changed.Clear;
  FClientInfoCollect.Clear;
end;

constructor TClientInfo.Create(AOwner: TComponent);
begin
  FClientInfoCollect := TClientInfoCollect.Create(TClientInfoItem);
  FQryNameList4Changed := TStringList.Create;
end;

destructor TClientInfo.Destroy;
begin
  FClientInfoCollect.Free;
  FQryNameList4Changed.Free;

  inherited;
end;

end.
