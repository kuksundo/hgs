unit WT1600Connection;

interface

uses tmctl_h;

type
  TDynaArray = array of char;

  TWT1600Connection = class
  private
    m_sAddress: AnsiString;     //address parameter.
    m_iPort: integer;       //connection type.
    m_iTerminitor: integer; //terminator in message.
    m_iID: integer;         //connection ID.
    m_sName: AnsiString;        //the model of the instrument.
    m_sIP: AnsiString;
    m_DLLName: string;
    m_Model: integer;

    m_LastError: integer;

    procedure SetIpAddress(Value: AnsiString);
    procedure SetAddress(Value: AnsiString);
    procedure SetPort(Value: integer);

  public
    m_aData: array[0..200] of Ansichar; //동적배열 대신 정적 배열 사용

    constructor create(APort: integer; AAdress: AnsiString; AModel: integer = 0);
    destructor destroy;
    //Set Connection To The Device
	  function Initialize: integer;
    //Function: Set Timeout
	  function SetTimeout(Atimeout: integer): integer;
    //Function: Break the Connection
	  function Finish: integer;
    //Function: Sending Message
	  function Send(Amsg: AnsiString): integer;
    function SendByLength(Amsg: AnsiString; Alen: integer): integer;
    //Function: Receive Message
	  function ReceiveSetup(): integer;
	  function ReceiveOnly(Abuff: PAnsiChar; Ablen: Integer;Arlen: PInteger): integer;
	  function Receive(Abuff: PAnsiChar; Ablen: integer; Arlen:PInteger): integer;
	  function ReceiveBlockHeader(Arlen: PInteger): integer;
	  function ReceiveBlockData(Abuff:PAnsiChar; Ablen: integer; Arlen: PInteger;Aend: Pinteger): integer;
    //Function: Get Last Error
    function GetLastError(): integer;
    //Function: Set the Remote Status
	  function SetRen(Aflag: Integer): integer;
  published
    property IpAddress: AnsiString read m_sIP write SetIpAddress;
    property ConnectAddress: AnsiString read m_sAddress write SetAddress;
    property ConnectType: integer read m_iPort write SetPort;
    property ConnectModel: AnsiString read m_sName write m_sName;
    property ConnectID: integer read m_iID write m_iID;
    property DLLName: String read m_DLLName write m_DLLName;
    property Model: integer read m_Model write m_Model;
    property LastErrorNo: integer read m_LastError write m_LastError;
  end;

implementation

{ TWT1600Connection }

constructor TWT1600Connection.create(APort: integer; AAdress: AnsiString; AModel: integer = 0);
begin
  m_iID := -1;
  m_sName := '';
	m_iPort := APort;
	m_sAddress := AAdress;
  //{$IFDEF WT500}
  if AModel = 0 then
  	m_iTerminitor := 2 //(for WT500)
  //{$ELSE}
  else
	  m_iTerminitor := 1;//(for WT1600)
  //{$ENDIF}

  DLLName := DLL_NAME;
  m_Model := AModel;
end;

destructor TWT1600Connection.destroy;
begin
  Finish;
end;

function TWT1600Connection.Finish: integer;
begin
  Result := TmcFinish(m_iID);
end;

function TWT1600Connection.GetLastError: integer;
begin
  Result := TmcGetLastError(m_iID);
end;

function TWT1600Connection.Initialize: integer;
var
  maxLength,
  realLength: integer;
  buf: array of char;
begin
  //return 0 when successed.
  Result := TmcInitialize(m_iPort,@m_sAddress[1], @m_iID);

  if Result <> 0 then
    exit;

  //set terminator of the message.
	Result := TmcSetTerm(m_iID, m_iTerminitor, 1);
	if Result <> 0 then
	begin
		TmcFinish(m_iID);
		exit;
	end;//if

  //timeout settings, 20*100ms
	Result := TmcSetTimeout(m_iID, 20);
	if Result <> 0 then
	begin
		TmcFinish(m_iID);
		exit;
	end;//if

	//test the device module connected.
	Result := TmcSend(m_iID, AnsiString('*IDN?'));
  //{$IFDEF WT500}
  if m_Model = 0 then
    maxLength := 50//(for WT500)
  //{$ELSE}
  else
	  maxLength := 30;//(for WT1600)
  //{$ENDIF}
	SetLength(buf, maxLength);
	Result := TmcReceive(m_iID, PAnsiChar(buf), maxLength, @realLength);
	m_sName := String(buf);
	buf := nil;

	if Result <> 0 then
  begin
    m_LastError := GetLastError;
    TmcFinish(m_iID);
  end;
end;

function TWT1600Connection.Receive(Abuff: PAnsiChar; Ablen: integer;
  Arlen: PInteger): integer;
begin
  Result := TmcReceive(m_iID, Abuff, Ablen, Arlen);
end;

function TWT1600Connection.ReceiveBlockData(Abuff: PAnsiChar; Ablen: integer;
  Arlen, Aend: Pinteger): integer;
begin
  Result := TmcReceiveBlockData(m_iID, Abuff, Ablen, Arlen, Aend);
end;

function TWT1600Connection.ReceiveBlockHeader(Arlen: PInteger): integer;
begin
  Result := TmcReceiveBlockHeader(m_iID, Arlen);
end;

function TWT1600Connection.ReceiveOnly(Abuff: PAnsiChar; Ablen: Integer;
  Arlen: PInteger): integer;
begin
  Result := TmcReceiveOnly(m_iID, Abuff, Ablen, Arlen);
end;

function TWT1600Connection.ReceiveSetup: integer;
begin
  Result := TmcReceiveSetup(m_iID);
end;

function TWT1600Connection.Send(Amsg: AnsiString): integer;
begin
  Result := TmcSend(m_iID, PAnsiChar(Amsg));
end;

function TWT1600Connection.SendByLength(Amsg: AnsiString;
  Alen: integer): integer;
begin
  Result := TmcSendByLength(m_iID, PAnsiChar(Amsg), Alen);
end;

procedure TWT1600Connection.SetAddress(Value: AnsiString);
begin
  if m_sAddress <> Value then
    m_sAddress := Value;
end;

procedure TWT1600Connection.SetIpAddress(Value: AnsiString);
begin
  if m_sIP <> Value then
    m_sIP := Value;
end;

procedure TWT1600Connection.SetPort(Value: integer);
begin
  if m_iPort <> Value then
    m_iPort := Value;
end;

function TWT1600Connection.SetRen(Aflag: Integer): integer;
begin
  Result := TmcSetRen(m_iID, Aflag);
end;

function TWT1600Connection.SetTimeout(Atimeout: integer): integer;
begin
  Result := TmcSetTimeout(m_iID, Atimeout);
end;

end.
