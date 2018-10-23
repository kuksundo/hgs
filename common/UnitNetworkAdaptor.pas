unit UnitNetworkAdaptor;

interface

uses SysUtils, classes;

type
  TNetworkAdapterItem = class(TCollectionItem)
  private
    FIPAddress,
    FIPSubnet,
    FMacAddress,
    FDHCPServer: string;
  published
    property IPAddress: string read FIPAddress write FIPAddress;
    property IPSubnet: string read FIPSubnet write FIPSubnet;
    property MacAddress: string read FMacAddress write FMacAddress;
    property DHCPServer: string read FDHCPServer write FDHCPServer;
  end;

  TNetworkAdapterCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TNetworkAdapterItem;
    procedure SetItem(Index: Integer; const Value: TNetworkAdapterItem);
  public
    function GetLocalIPList : TStrings;
    function GetLocalSubNetList : TStrings;
    function GetLocalMacList : TStrings;
    function GetBindIP(ADestIP: string): string;

    function  Add: TNetworkAdapterItem;
    function Insert(Index: Integer): TNetworkAdapterItem;
    property Items[Index: Integer]: TNetworkAdapterItem read GetItem  write SetItem; default;
  end;

implementation

function strToken(var S: String; Seperator: Char): String;
var
  I               : Word;
begin
  I:=Pos(Seperator,S);
  if I<>0 then
  begin
    Result:=System.Copy(S,1,I-1);
    System.Delete(S,1,I);
  end else
  begin
    Result:=S;
    S:='';
  end;
end;

{ TNetworkAdapterCollect }
function TNetworkAdapterCollect.Add: TNetworkAdapterItem;
begin
  Result := TNetworkAdapterItem(inherited Add);
end;

//ADestIP: 통신할 설비의 IP 주소(xxx.xxx.xxx.xxx)
function TNetworkAdapterCollect.GetBindIP(ADestIP: string): string;
var
  i, j: integer;
  V1, V2, V3, V4: integer;
  D1, D2, D3, D4: integer;
  LStr, LIp, LIp2, LSubnet: string;
  LMatch: Boolean;
begin
  Result := '';
  LIp2 := ADestIP;

  for j := 1 to 4 do
  begin
    case j of
      1: D1 := StrToInt(strToken(LIp2, '.'));
      2: D2 := StrToInt(strToken(LIp2, '.'));
      3: D3 := StrToInt(strToken(LIp2, '.'));
      4: D4 := StrToInt(strToken(LIp2, '.'));
    end;
  end;

  for i := 0 to Self.Count - 1 do
  begin
    LStr := Self.Items[i].FIPSubnet;
    LIp := Self.Items[i].FIPAddress;

    V1 := -1;
    V2 := -1;
    V3 := -1;
    V4 := -1;
    LMatch := False;

    for j := 1 to 4 do
    begin
      LSubnet := strToken(LStr, '.');

      if LSubnet = '255' then
      begin
        case j of
          1: begin
            V1 := StrToInt(strToken(LIp, '.'));
            LMatch := D1 = V1;
          end;
          2: begin
            V2 := StrToInt(strToken(LIp, '.'));
            LMatch := D2 = V2;
          end;
          3: begin
            V3 := StrToInt(strToken(LIp, '.'));
            LMatch := D3 = V3;
          end;
          4: begin
            V4 := StrToInt(strToken(LIp, '.'));
            LMatch := D4 = V4;
          end;
        end;
      end;
    end;

    if LMatch then
    begin
      Result := Self.Items[i].FIPAddress;
      exit;
    end;
  end;
end;

function TNetworkAdapterCollect.GetItem(Index: Integer): TNetworkAdapterItem;
begin
  Result := TNetworkAdapterItem(inherited Items[Index]);
end;

function TNetworkAdapterCollect.GetLocalIPList: TStrings;
var
  i: integer;
begin
  Result := TStringList.Create;

  for i := 0 to Self.Count - 1 do
    Result.Add(Self.Items[i].FIPAddress);
end;

function TNetworkAdapterCollect.GetLocalMacList: TStrings;
var
  i: integer;
begin
  Result := TStringList.Create;

  for i := 0 to Self.Count - 1 do
    Result.Add(Self.Items[i].FMacAddress);
end;

function TNetworkAdapterCollect.GetLocalSubNetList: TStrings;
var
  i: integer;
begin
  Result := TStringList.Create;

  for i := 0 to Self.Count - 1 do
    Result.Add(Self.Items[i].FIPSubnet);
end;

function TNetworkAdapterCollect.Insert(Index: Integer): TNetworkAdapterItem;
begin
  Result := TNetworkAdapterItem(inherited Insert(Index));
end;

procedure TNetworkAdapterCollect.SetItem(Index: Integer;
  const Value: TNetworkAdapterItem);
begin
  Items[Index].Assign(Value);
end;

end.
