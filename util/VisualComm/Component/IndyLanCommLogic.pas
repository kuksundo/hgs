unit IndyLanCommLogic;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Forms, Graphics,
  StdCtrls, Menus, Dialogs, SyncObjs, CommLogic2, SerialComport, UtilUnit,
  CopyData, ByteArray, pjhClasses, CommLogicType, IdUDPClient, IdTCPConnection,
  IdTCPClient, IdUDPBase, IdUDPServer, IdBaseComponent, IdComponent, IdTCPServer;

type
  PClient = ^TIndyClient;
  TIndyClient = record  // Object holding data of client (see events)
    DNS : String[20];            { Hostname }
    Connected,                   { Time of connect }
    LastAction : TDateTime;      { Time of last transaction }
    Thread     : Pointer;        { Pointer to thread }
  end;

  TServerClient = (tServer, tClient);

  TCommBlock = record   // the Communication Block used in both parts (Server+Client)
   Command,
   MyUserName,                 // the sender of the message
   Msg,                        // the message itself
   ReceiverName: string[100];  // name of receiver
   UseCommBlock: Boolean; //False 이면 통신시에 Block을 사용하지 않음
  end;

  TCommBlockClass = class(TPersistent)
  private
    FCommand,
    FMyUserName,                 // the sender of the message
    FMsg,                        // the message itself
    FReceiverName: String;  // name of receiver
    FUseCommBlock: Boolean; //False 이면 통신시에 Block을 사용하지 않음
  protected
    procedure SetUseCommBlock(const Value: Boolean);
    procedure SetCommand(const Value: String);
    procedure SetMyUserName(const Value: String);
    procedure SetReceiverName(const Value: String);
    procedure SetMsg(const Value: String);
  public
    FCommBlock: TCommBlock;
  published
    property UseCommBlock: Boolean read FUseCommBlock write SetUseCommBlock;
    property Command: String read FCommand write SetCommand;
    property MyUserName: String read FMyUserName write SetMyUserName;
    property ReceiverName: String read FReceiverName write SetReceiverName;
    property Msg: String read FMsg write SetMsg;
  end;

  TpjhLanIfControl = class(TCustomLogicBoolean)
  private
    FVarControl: TCustomLogicControl; //변수
    FExpression: TExpression;
    FStartIndex: integer;
    FCount: integer;
    FCompareData: TCompareData;

    procedure SetVarControl(Value: TCustomLogicControl);
    procedure SetExpression(Value: TExpression);
    procedure SetStartIndex(Value: integer);
    procedure SetCount(Value: integer);
    procedure SetCompareData(Value: TCompareData);

    procedure DoOnEnter; override;
    procedure DoOnEnterState(Sender: TCustomLogicBoolean; var Result: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function DoCompareData(Value: string): Boolean;
    function CompareStrData(Value1, Value2: string): Boolean;
    function CompareDecData(Value1, Value2: string): Boolean;
    function CompareHexData(Value1, Value2: string): Boolean;
  published
    property TrueStep;
    property FalseStep;

    property VarControl: TCustomLogicControl read FVarControl write SetVarControl;
    property Expression: TExpression read FExpression write SetExpression;
    property StartIndex: integer read FStartIndex write SetStartIndex;
    property Count: integer read FCount write SetCount;
    property CompareData: TCompareData read FCompareData write SetCompareData;
  end;

  TIndyListenTCP = class( TpjhProcess )
  private
    FLanComponent: TIdTCPServer;
    FClients : TThreadList;     // Holds the data of all clients
    FEvent: Boolean;
  protected
    procedure SetLanControl(const Value: TIdTCPServer);
    procedure DoOnEnter; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure TCPOnConnect(AThread: TIdPeerThread);
    procedure TCPOnDisConnect(AThread: TIdPeerThread);
    procedure TCPOnExecute(AThread: TIdPeerThread);

    property Clients: TThreadList read FClients;
  published
    property LanControl: TIdTCPServer read FLanComponent write SetLanControl;
  end;

  TIndyWriteClientTCP = class( TpjhProcess )
  private
    FLanComponent: TIdTCPClient;
    FWriteDataType: TCommDataType;
    FWriteBuffer4String: TStrings;
    FDelimiter: Char;
    FLoadFromFile: TDataFile;
    FCommBlock: TCommBlockClass;
    //FWriteBuffer4Byte: array of byte;
  protected
    function GetDataType: TCommDataType;
    procedure SetDataType(const Value: TCommDataType);
    procedure SetLines(Value: TStrings);
    procedure SetLanControl(const Value: TIdTCPClient);
    function GetDelimiter: TDelimiter;
    procedure SetDelimiter(const Value: TDelimiter);
    procedure SetLoadFromFile(Value: TDataFile);
    procedure SetCommBlock(Value: TCommBlockClass);

    procedure WriteData2LanControl;

    procedure WriteDecimalData;
    procedure WriteHexaDecimalData;
  public
    procedure DoOnEnter; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CommBlock: TCommBlockClass read FCommBlock write SetCommBlock;
    property DataFile: TDataFile read FLoadFromFile write SetLoadFromFile;
    property LanControl: TIdTCPClient read FLanComponent write SetLanControl;
    property Delimiter: TDelimiter read GetDelimiter write SetDelimiter;
    property WriteDataType: TCommDataType read GetDataType write SetDataType;
    property WriteData: TStrings read FWriteBuffer4String write SetLines;
  end;

  TIndyReadClientTCP = class( TpjhProcess )
  private
    FLanComponent: TIdComponent;
    FReadDataType: TCommDataType;
    FReadBuffer4String: TStrings;
    FCommDataCondition: TCommDataCondition;
    FReadDataCount: integer;
    FDisplayFormName: string;
    FReadBuffer4Byte: TByteArray2;
    FBufClearB4Enter: Boolean;
    FSaveToFile: TDataFile;
    FReadDataIndex: integer;    // FA MEM에 기록할 FReadBuffer4Byte 의 Index
    FServerClient: TServerClient;
    FListenControl: TIndyListenTCP;
  protected
    procedure SetDataType(const Value: TCommDataType);
    procedure SetLines(Value: TStrings);
    procedure SetLanControl(const Value: TIdComponent);
    procedure SetListenControl(const Value: TIndyListenTCP);
    procedure SetCommDataCondition(const Value: TCommDataCondition);
    procedure SetReadDataCount(const Value: integer);
    procedure SetSaveToFile(Value: TDataFile);
    procedure SetReadDataIndex(const Value: integer);

    procedure ReadDataFromLanControl;
    procedure ReadStrDataFromLanControl;
    procedure ReadByteDataFromLanControl;

    procedure DoOnEnter; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ServerClient: TServerClient read FServerClient write FServerClient;

  published
    property SaveToFile: TDataFile read FSaveToFile write SetSaveToFile;
    property BufClearB4Enter: Boolean read FBufClearB4Enter write FBufClearB4Enter;
    property LanControl: TIdComponent read FLanComponent write SetLanControl;
    property ListenControl: TIndyListenTCP read FListenControl write SetListenControl;
    property DataCondition: TCommDataCondition read FCommDataCondition
                                                write SetCommDataCondition;
    property DisplayFormName: string read FDisplayFormName write FDisplayFormName;
    property ReadDataType: TCommDataType read FReadDataType write SetDataType;
    property ReadDataBuf: TStrings read FReadBuffer4String write SetLines;
    property ReadDataCount: integer read FReadDataCount write SetReadDataCount;
    property ReadDataIndex: integer read FReadDataIndex write SetReadDataIndex;
  end;

  TIndyWriteFile = class( TpjhProcess )
    FDataFile: TDataFile;
    FVarControl: TpjhProcess;
  protected
    procedure SetDataFile(Value: TDataFile);
    procedure DoOnEnter; override;
    procedure SetVarControl(Value: TpjhProcess);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DataFile: TDataFile read FDataFile write SetDataFile;
    property VarControl: TpjhProcess read FVarControl write SetVarControl;
  end;

implementation

{ TpjhLanIfControl }

function TpjhLanIfControl.DoCompareData(Value: string): Boolean;
begin
  Result := False;

  case CompareData.DataType of
    cdtString: Result := CompareStrData(Value, CompareData.Data);
    cdtDecimal: Result := CompareDecData(Value, CompareData.Data);
    cdtHexaDecimal: Result := CompareHexData(Value, CompareData.Data);
  end;//case

end;

constructor TpjhLanIfControl.Create(AOwner: TComponent);
begin
  //비트맵을 컴포넌트 좌상단에 뿌려줌
  //Inherited 전에 실행해 주어야 함. False는 Default
  FShowLabelBmp := True;

  inherited;

  DiagramType := dtIf;
  OnEnterState := DoOnEnterState;
  FCompareData := TCompareData.Create;
end;

destructor TpjhLanIfControl.Destroy;
begin
  FreeAndNil(FCompareData);

  inherited;
end;

procedure TpjhLanIfControl.DoOnEnter;
begin
  Application.ProcessMessages;
  inherited;//조상 DoOnEnter에서 DoOnEnterState함수를 Call함
end;

procedure TpjhLanIfControl.DoOnEnterState(Sender: TCustomLogicBoolean; var Result: Boolean);
var
  str1: string;
  i: integer;
begin
  Result := False;

  if VarControl = nil then
  begin
    ShowMessage('VarControl should be TIndyReadClientTCP');
    exit;
  end;

  if TComponent(VarControl).ClassName = 'TIndyReadClientTCP' then
  begin
    if TIndyReadClientTCP(VarControl).ReadDataBuf.Count > 0 then
    begin
      str1 := TIndyReadClientTCP(VarControl).ReadDataBuf.Strings[0];
      if Count = 0 then
      begin
        //for i := 0 to TpjhReadComport(VarControl).ReadDataBuf.Count - 1 do
          Result := Pos(CompareData.Data, Str1) > 0;
      end
      else
        Result := DoCompareData( Copy(Str1, StartIndex, Count) );
    end;
  end
  else
    ShowMessage('VarControl should be TIndyReadClientTCP');
end;

function TpjhLanIfControl.CompareDecData(Value1, Value2: string): Boolean;
var LI: Longint;
begin
  Result := False;

  if StrIsNumeric(Value1) and StrIsNumeric(Value2) then
  begin
    LI := Length(Value1) - Length(Value2);
    if LI > 0 then
      PadLeft(Value2, '0', LI)
    else
      PadLeft(Value1, '0', LI)
  end
  else
    exit;

  Result := CompareStrData(Value1, Value2);
end;

function TpjhLanIfControl.CompareHexData(Value1, Value2: string): Boolean;
var
  //ByteAry1, ByteAry2: TByteArray2;
  LI: integer;
begin
  Result := False;

  if StrIsHex(Value1) and StrIsHex(Value2) then
  begin
    LI := Length(Value1) - Length(Value2);
    if LI > 0 then
      PadLeft(Value2, '0', LI)
    else
      PadLeft(Value1, '0', LI)
  end
  else
    exit;

  Result := CompareStrData(Value1, Value2);

{  if StrIsHex(Value1) then
  begin
    ByteAry1 := TByteArray2.Create();

    try
      with ByteAry1 do
      begin
        i := Length(Value1) div 2;

        if Odd(Length(Value1)) then
          inc(i);

        SetLengthAndZero(i);
        
        if String2HexByteAry(Value1, FBuffer) < 0 then
          exit;
      end;//with
    finally
      ByteAry1.Free;
    end;//try
  end
  else
    exit;

  if StrIsHex(Value2) then
  begin
    ByteAry2 := TByteArray2.Create();

    try
      with ByteAry2 do
      begin
        i := Length(Value2) div 2;

        if Odd(Length(Value2)) then
          inc(i);

        SetLengthAndZero(i);

        if String2HexByteAry(Value2, FBuffer) < 0 then
          exit;
      end;//with
    finally
      ByteAry2.Free;
    end;//try
  end
  else
    exit;

  case Expression of
    eEqual: Result := ByteAry1.IsEqual(ByteAry1, ByteAry2);
    eLessThan: Result := (Value < CompareData.Data);
    eLessThanEqual: Result := (Value <= CompareData.Data);
    eGreaterThan: Result := (Value > CompareData.Data);
    eGreaterThanEqual: Result := (Value >= CompareData.Data);
  end;//case
}
end;

function TpjhLanIfControl.CompareStrData(Value1, Value2: string): Boolean;
begin
  Result := False;

  case Expression of
    eEqual: Result := (Value1 = Value2);
    eLessThan: Result := (Value1 < Value2);
    eLessThanEqual: Result := (Value1 <= Value2);
    eGreaterThan: Result := (Value1 > Value2);
    eGreaterThanEqual: Result := (Value1 >= Value2);
  end;//case
end;

procedure TpjhLanIfControl.SetCompareData(Value: TCompareData);
begin
  if FCompareData <> Value then
    FCompareData := Value;
end;

procedure TpjhLanIfControl.SetCount(Value: integer);
begin
  if FCount <> Value then
    FCount := Value;
end;

procedure TpjhLanIfControl.SetExpression(Value: TExpression);
begin
  if FExpression <> Value then
    FExpression := Value;
end;

procedure TpjhLanIfControl.SetStartIndex(Value: integer);
begin
  if FStartIndex <> Value then
    FStartIndex := Value;
end;

procedure TpjhLanIfControl.SetVarControl(Value: TCustomLogicControl);
begin
  if FVarControl <> Value then
    FVarControl := Value;
end;

{ TIndyWriteClientTCP }

constructor TIndyWriteClientTCP.Create(AOwner: TComponent);
begin
  //비트맵을 컴포넌트 좌상단에 뿌려줌
  //Inherited 전에 실행해 주어야 함. False는 Default
  FShowLabelBmp := True;

  inherited;

  FWriteBuffer4String := TStringList.Create;
  FLoadFromFile := TDataFile.Create;
  FCommBlock := TCommBlockClass.Create;
end;

destructor TIndyWriteClientTCP.Destroy;
begin
  FWriteBuffer4String.Free;
  FLoadFromFile.Free;
  FreeAndNil(FCommBlock);
  inherited;
end;

procedure TIndyWriteClientTCP.DoOnEnter;
begin
  Application.ProcessMessages;
  inherited;
  WriteData2LanControl;
  Application.ProcessMessages;
end;

function TIndyWriteClientTCP.GetDataType: TCommDataType;
begin
  Result := FWriteDataType;
end;

function TIndyWriteClientTCP.GetDelimiter: TDelimiter;
begin
  case FDelimiter of
    #13: Result := delCR;
    #10: Result := delLF;
    ',': Result := delComma;
    ';': Result := delSemiColon;
    ':': Result := delColon;
    #0 : Result := delNotUse;
  end;//case
end;

procedure TIndyWriteClientTCP.SetLanControl(const Value: TIdTCPClient);
begin
  FLanComponent := Value;
end;

procedure TIndyWriteClientTCP.SetDataType(const Value: TCommDataType);
begin
  FWriteDataType := Value;
end;

procedure TIndyWriteClientTCP.SetDelimiter(const Value: TDelimiter);
begin
  case Value of
    delCR: FDelimiter := #13;
    delLF: FDelimiter := #10;
    delComma: FDelimiter := ',';
    delSemiColon: FDelimiter := ';';
    delColon: FDelimiter := ':';
    delNotUse: FDelimiter := #0;
  end;//case
end;

procedure TIndyWriteClientTCP.SetLines(Value: TStrings);
begin
  FWriteBuffer4String.Assign(Value);
end;

procedure TIndyWriteClientTCP.WriteData2LanControl;
var
  i: integer;
  str1,str2: string;
begin
  if not Assigned(FLanComponent) then
  begin
    for i := 0 to TComponent(Self.Parent).ComponentCount - 1 do
    begin
      if TComponent(Self.Parent).Components[i].ClassType = TIdTCPClient then
      begin
        FLanComponent := TIdTCPClient(TComponent(Self.Parent).Components[i]);
        Break;
      end;
    end;//for
  end;

  if Assigned(FLanComponent) then
  begin
    if not (FLanComponent.Connected) then
      FLanComponent.Connect;

    if FLanComponent.Connected then
    begin
      case FWriteDataType of
        cdtString:
          begin
            if FLoadFromFile.FileAction = faRead then
            begin
              if (FLoadFromFile.Enabled) and (FLoadFromFile.FileName <> '') then
              begin
                FWriteBuffer4String.Clear;
                FWriteBuffer4String.LoadFromFile(FLoadFromFile .FileName);
              end;

              if FCommBlock.UseCommBlock then
              begin
                for i := 0 to FWriteBuffer4String.Count - 1 do
                begin
                  str1 := FWriteBuffer4String.Strings[i];
                  while str1 <> '' do
                  begin
                    FCommBlock.Msg := strToken(Str1, FDelimiter);
                    FLanComponent.WriteBuffer(CommBlock, SizeOf (CommBlock), true);
                  end;//while
                end;//for
              end
              else
              begin
                FLanComponent.WriteStrings(FWriteBuffer4String);
              end;
            end
            else
            if FLoadFromFile.FileAction = faWrite then
            begin
              ;
            end;
          end;
        cdtDecimal:
          begin
            WriteDecimalData();
          end;
        cdtHexaDecimal:
          begin
            WriteHexaDecimalData();
          end;
      end;//case
    end
    else
      raise Exception.Create('LanControl not connected');
  end
  else
    raise Exception.Create('Not assigned TIdTCPClient to TpjhLogicPanel or TIndyWriteClientTCP');
end;

procedure TIndyWriteClientTCP.WriteDecimalData;
var
  i: integer;
  ByteAry: TByteArray2;
  str1,str2: string;
begin
  ByteAry := TByteArray2.Create();
  try
    with ByteAry do
    begin
      for i := 0 to FWriteBuffer4String.Count - 1 do
      begin
        str1 := FWriteBuffer4String.Strings[i];
        if str1 = '' then
          Continue;

        str2 := str1;
        str2 := ReplaceStr(str2,FDelimiter,'');
        if StrIsNumeric(str2) then
        begin
          FBuffer := StrToByteArray(str1,FDelimiter);
          if FCommBlock.UseCommBlock then
          begin
            ShowMessage('Can''t Write byte data using CommBlock');
            break;
            //FLanControl.WriteBuffer(CommBlock, SizeOf(CommBlock), true);
          end
          else
            FLanComponent.WriteBuffer(FBuffer[0],Size);
        end
        else
        begin
          ShowMessage('Not integer data');
        end;//else
      end;//for
    end;//with
  finally
    ByteAry.Free;
  end;
end;

procedure TIndyWriteClientTCP.WriteHexaDecimalData;
var
  i,j: integer;
  ByteAry: TByteArray2;
  str1,str2: string;
begin
  ByteAry := TByteArray2.Create();
  try
    with ByteAry do
    begin
      for i := 0 to FWriteBuffer4String.Count - 1 do
      begin
        str1 := FWriteBuffer4String.Strings[i];

        if str1 = '' then
          Continue;

        str2 := str1;
        str2 := ReplaceStr(str2,FDelimiter,'');
        if StrIsHex(str2) then
        begin
          while str1 <> '' do
          begin
            str2 := strToken(Str1, FDelimiter);
            j := Length(str2) div 2;

            if Odd(Length(str2)) then
              inc(j);

            ByteAry.SetLengthAndZero(j);

            if String2HexByteAry(str2, FBuffer) > 0 then
              FLanComponent.WriteBuffer(FBuffer[0],Size);
          end;//while
        end
        else
          ShowMessage('Not Hexadecimal data.'+#13#10+'Check the Delimiter or WriteDataType for TIndyWriteClientTCP');

      end;//for
    end;//with
  finally
    ByteAry.Free;
  end;
end;

procedure TIndyWriteClientTCP.SetLoadFromFile(Value: TDataFile);
begin
  if FLoadFromFile <> Value then
  begin
    FLoadFromFile := Value;
    if (FLoadFromFile.Enabled) and (FLoadFromFile.FileName <> '') then
    begin
      FWriteBuffer4String.Clear;
      if Value.FileAction = faRead then
        FWriteBuffer4String.LoadFromFile(FLoadFromFile.FileName)
      else
      begin
        ShowMessage('faRead is not available');
        Value.FileAction := faRead;
      end;
    end;
  end;
end;

procedure TIndyWriteClientTCP.SetCommBlock(Value: TCommBlockClass);
begin
  if FCommBlock <> Value then
  begin
    FCommBlock := Value;
  end;
end;

{ TIndyReadClientTCP }

constructor TIndyReadClientTCP.Create(AOwner: TComponent);
begin
  //비트맵을 컴포넌트 좌상단에 뿌려줌
  //Inherited 전에 실행해 주어야 함. False는 Default
  FShowLabelBmp := True;

  inherited;

  FBufClearB4Enter := True;
  FReadBuffer4String := TStringList.Create;
  FReadBuffer4Byte := TByteArray2.Create();
end;

destructor TIndyReadClientTCP.Destroy;
begin
  FReadBuffer4Byte.Clear;
  FReadBuffer4Byte.Free;
  FReadBuffer4String.Free;
  inherited;
end;

procedure TIndyReadClientTCP.DoOnEnter;
begin
  Application.ProcessMessages;
  inherited;

  if FBufClearB4Enter then
  begin
    FReadBuffer4Byte.Clear;
    FReadBuffer4String.Clear;
  end;

  ReadDataFromLanControl;
  Application.ProcessMessages;
end;

procedure TIndyReadClientTCP.ReadByteDataFromLanControl;
var
  str1: string;
  ByteAry: TByteArray2;
  rCount: integer;
  Len: integer;
begin
  ByteAry := TByteArray2.Create();
  try
    with ByteAry do
    begin
      case FCommDataCondition of
        cdcSize:
          begin
            if ReadDataCount <= 0 then
              Len := 100
            else
              Len := ReadDataCount;

            Size := Len;//FBuffer 의 메모리 확보를 위해 필요함

            TIdTCPClient(FLanComponent).ReadBuffer(FBuffer ,Len);

            FReadBuffer4Byte.AppendByteArray(FBuffer, Len);

            if FReadDataType = cdtDecimal then
            begin
              str1 := CopyToDecString(0, rCount);
            end
            else
              str1 := CopyToHexString(0, rCount);

            FReadBuffer4String.Add(str1);
            //디버그 화면에 데이타 전송
            SendCopyData('', FDisplayFormName, str1, 0);
          end;
        cdcChar:
          begin
          end;
        cdcInterval:;
        cdcDontCare:;
      end;//case
    end;//with
  finally
    ByteAry.Free;
  end;//try
end;

procedure TIndyReadClientTCP.ReadDataFromLanControl;
var Len: integer;
begin
  if not Assigned(FLanComponent) then
  begin
    for Len := 0 to TComponent(Self.Parent).ComponentCount - 1 do
    begin
      if ServerClient = tClient then
      begin
        if TComponent(Self.Parent).Components[Len].ClassType = TIdTCPClient then
        begin
          FLanComponent := TIdTCPClient(TComponent(Self.Parent).Components[Len]);
          break;
        end;
      end
      else
      begin
        if TComponent(Self.Parent).Components[Len].ClassType = TIdTCPServer then
        begin
          FLanComponent := TIdTCPServer(TComponent(Self.Parent).Components[Len]);
          break;
        end;
      end;
    end;//for
  end;

  if Assigned(FLanComponent) then
  begin
    if ServerClient = tClient then
    begin
      if not (TIdTCPClient(FLanComponent).Connected) then
        TIdTCPClient(FLanComponent).Connect(1000);
    end
    else
      if not (TIdTCPServer(FLanComponent).Active) then
        TIdTCPServer(FLanComponent).Active := True;

    case FReadDataType of
      cdtString: ReadStrDataFromLanControl;

      cdtDecimal,
      cdtHexaDecimal: ReadByteDataFromLanControl;
    end;//case
  end
  else
    raise Exception.Create('Not assigned LanControl property');
end;

procedure TIndyReadClientTCP.ReadStrDataFromLanControl;
var str1: string;
    Len: integer;
    RecClient: PClient;
begin
  case FCommDataCondition of
    cdcSize:
      begin
        if ReadDataCount <= 0 then
          Len := 100
        else
          Len := ReadDataCount;

        Str1 := '';

        if ServerClient = tClient then
          Str1 := TIdTCPClient(FLanComponent).ReadString(Len)
        else
        begin
          if TIdTCPServer(FLanComponent).Tag > 0 then
            with ListenControl.Clients.LockList do
              RecClient := Items[TIdTCPServer(FLanComponent).Tag];
            Str1 := TIdPeerThread(RecClient.Thread).Connection.ReadString(Len);
        end;

        if Str1 <> '' then
        begin
          FReadBuffer4String.Add(str1);
          if FDisplayFormName = '' then
            FDisplayFormName := Application.MainForm.Caption;
          SendCopyData('', FDisplayFormName, str1, 0);
        end;
      end;
    cdcChar:
      begin
      end;
    cdcInterval:;
    cdcDontCare:;
  end;//case
end;

procedure TIndyReadClientTCP.SetCommDataCondition(const Value: TCommDataCondition);
begin
  if FCommDataCondition <> Value then
    FCommDataCondition := Value;
end;

procedure TIndyReadClientTCP.SetLanControl(const Value: TIdComponent);
begin
  if (TObject(Value).ClassType = TIdTCPClient) or
      (TObject(Value).ClassType = TIdUDPClient) then
    ServerClient := tClient
  else
  if (TObject(Value).ClassType = TIdTCPServer) or
      (TObject(Value).ClassType = TIdTCPServer) then
    ServerClient := tServer;

  FLanComponent := Value;
end;

procedure TIndyReadClientTCP.SetDataType(const Value: TCommDataType);
begin
  FReadDataType := Value;
end;

procedure TIndyReadClientTCP.SetLines(Value: TStrings);
begin
  FReadBuffer4String.Assign(Value);
end;

procedure TIndyReadClientTCP.SetReadDataCount(const Value: integer);
begin
  if FCommDataCondition = cdcSize then
  begin
    if FReadDataCount <> Value then
      FReadDataCount := Value;
  end
  else
    ShowMessage('This property is used only when ReadDataType set cdcSize');
end;

procedure TIndyReadClientTCP.SetSaveToFile(Value: TDataFile);
begin
  if FSaveToFile <> Value then
    FSaveToFile := Value;
end;

procedure TIndyReadClientTCP.SetReadDataIndex(const Value: integer);
begin
  if FReadDataCount <> Value then
    FReadDataCount := Value;
end;

{ TpjhWriteFAMem }

{procedure TpjhWriteFAMem.DoOnEnter;
var
  str1: string;
begin
  inherited;

  if VarControl = nil then
  begin
    ShowMessage('VarControl should be TIndyReadClientTCP');
    exit;
  end;

  if TComponent(VarControl).ClassName = 'TIndyReadClientTCP' then
  begin
    if TIndyReadClientTCP(VarControl).ReadDataBuf.Count > 0 then
    begin
      Str1 := TIndyReadClientTCP(VarControl).ReadDataBuf.Strings[0];
      Str1 := Copy(Str1, DataIndex, DataCount);
      if StrIsNumeric(Str1) then
        WriteDecimalData2MemMan(StrToInt(Str1))
      else
        ShowMessage('Data is not integer');
    end;
  end
  else
    ShowMessage('VarControl should be TIndyReadClientTCP');

end;

procedure TpjhWriteFAMem.SetFAMemMan(mm: TpjhFAMemMan);
begin
  FFAMemMan := mm;
end;

procedure TpjhWriteFAMem.SetMemName(A: TMemName);
begin
  if FMemName <> A then
    FMemName := A;
end;

procedure TpjhWriteFAMem.SetVarControl(const Value: TCustomLogicControl);
begin
  FVarControl := Value;
end;

procedure TpjhWriteFAMem.WriteDecimalData2MemMan(Data: integer);
begin
  if Assigned(FAMemoryManager) then
  begin
    case FMemName of
      A_MEM: FAMemoryManager.SetA(FAMemIndex, Data);
      F_MEM: FAMemoryManager.SetF(FAMemIndex, Data);
      R_MEM: FAMemoryManager.SetR(FAMemIndex, Data);
      W_MEM: FAMemoryManager.SetW(FAMemIndex, Data);
    end;//case
  end;
end;
}

procedure TIndyReadClientTCP.SetListenControl(const Value: TIndyListenTCP);
begin
  if ServerClient = tServer then
  begin
    FListenControl := Value;
  end
  else
    ShowMessage('LanControl should be TIndyServerTCP!!!');
end;

{ TCommBlockClass }

procedure TCommBlockClass.SetCommand(const Value: String);
begin
  if FCommand <> Value then
  begin
    FCommand := Value;
    FCommBlock.Command := Value;
  end;
end;

procedure TCommBlockClass.SetMsg(const Value: String);
begin
  if FMsg <> Value then
  begin
    FMsg := Value;
    FCommBlock.Msg := Value;
  end;
end;

procedure TCommBlockClass.SetMyUserName(const Value: String);
begin
  if FMyUserName <> Value then
  begin
    FMyUserName := Value;
    FCommBlock.MyUserName := Value;
  end;
end;

procedure TCommBlockClass.SetReceiverName(const Value: String);
begin
  if FReceiverName <> Value then
  begin
    FReceiverName := Value;
    FCommBlock.ReceiverName := Value;
  end;
end;

procedure TCommBlockClass.SetUseCommBlock(const Value: Boolean);
begin
  if FUseCommBlock <> Value then
  begin
    FUseCommBlock := Value;
    FCommBlock.UseCommBlock := Value;
  end;
end;

{ TIndyWriteFile }

constructor TIndyWriteFile.Create(AOwner: TComponent);
begin
  //비트맵을 컴포넌트 좌상단에 뿌려줌
  //Inherited 전에 실행해 주어야 함. False는 Default
  FShowLabelBmp := True;

  inherited;

  FDataFile := TDataFile.Create;
end;

destructor TIndyWriteFile.Destroy;
begin
  FDataFile.Free;

  inherited;
end;

procedure TIndyWriteFile.DoOnEnter;
var str1: string;
begin
  inherited;

  if TComponent(VarControl).ClassName = 'TIndyReadClientTCP' then
  begin
    if TIndyReadClientTCP(VarControl).ReadDataBuf.Count > 0 then
    begin
      Str1 := TIndyReadClientTCP(VarControl).ReadDataBuf.Strings[0];
      File_Open_Append(FDataFile.FileName,Str1,False);
    end;
  end
  else
  if TComponent(VarControl).ClassName = 'TIndyWriteClientTCP' then
  begin
    if TIndyWriteClientTCP(VarControl).WriteData.Count > 0 then
    begin
      Str1 := TIndyWriteClientTCP(VarControl).WriteData.Strings[0];
      File_Open_Append(FDataFile.FileName,Str1,False);
    end;
  end;
end;

procedure TIndyWriteFile.SetDataFile(Value: TDataFile);
begin
  if FDataFile <> Value then
    FDataFile := Value;
end;

procedure TIndyWriteFile.SetVarControl(Value: TpjhProcess);
begin
  if (VarControl = nil) or ((TComponent(VarControl).ClassName <> 'TIndyReadClientTCP')
    and (TComponent(VarControl).ClassName <> 'TIndyWriteClientTCP')) then
  begin
    ShowMessage('VarControl should be TIndy...');
    exit;
  end;

  if FVarControl <> Value then
    FVarControl := Value;
end;

{ TIndyListenTCP }

constructor TIndyListenTCP.Create(AOwner: TComponent);
begin
  //비트맵을 컴포넌트 좌상단에 뿌려줌
  //Inherited 전에 실행해 주어야 함. False는 Default
  FShowLabelBmp := True;

  inherited;

  FClients := TThreadList.Create;
  //FEvent := TEvent.Create(nil, False, False, 'ListenEvent'+IntToStr(Random(1000)));
  FEvent := False;
end;

destructor TIndyListenTCP.Destroy;
begin
  //FEvent.Free;
  FClients.Free;

  inherited;
end;

procedure TIndyListenTCP.DoOnEnter;
begin
  while not FEvent do
  begin
    Application.ProcessMessages;

    if (csDesigning in ComponentState) then
      exit;
  end;

  FEvent := False;

  inherited;

end;

procedure TIndyListenTCP.SetLanControl(const Value: TIdTCPServer);
begin
  FLanComponent := Value;
  FLanComponent.OnConnect := TCPOnConnect;
  FLanComponent.OnDisConnect := TCPOnDisConnect;
  FLanComponent.OnExecute := TCPOnExecute;
end;

procedure TIndyListenTCP.TCPOnConnect(AThread: TIdPeerThread);
var NewClient: PClient;
begin
  GetMem(NewClient, SizeOf(TIndyClient));

  NewClient.DNS        := AThread.Connection.LocalName;
  NewClient.Connected  := Now;
  NewClient.LastAction := NewClient.Connected;
  NewClient.Thread     := AThread;

  AThread.Data := TObject(NewClient);

  try
    FClients.LockList.Add(NewClient);
  finally
    FClients.UnlockList;
  end;
end;

procedure TIndyListenTCP.TCPOnDisConnect(AThread: TIdPeerThread);
var ActClient: PClient;
begin
  ActClient := PClient(AThread.Data);

  try
    FClients.LockList.Remove(ActClient);
  finally
    FClients.UnlockList;
  end;

  FreeMem(ActClient);
  AThread.Data := nil;
end;

procedure TIndyListenTCP.TCPOnExecute(AThread: TIdPeerThread);
var i: integer;
    RecClient: PClient;
begin
  with FClients.LockList do
  try
    LanControl.Tag := -1;

    for i := 0 to Count - 1 do  // iterate through client-list
    begin
      RecClient := Items[i];
      if TThread(RecClient.Thread).ThreadID = AThread.ThreadId then
      begin
        LanControl.Tag := i;
        Break;
      end;
    end;
  finally
    FClients.UnlockList;
  end;

  FEvent := True;
end;

end.
