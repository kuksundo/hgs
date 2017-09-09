unit CltConn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, ActnList, Menus, ExtCtrls, LVEx, ScktComp;

type
  TConnForm = class(TForm)
    StatusBar: TStatusBar;
    ImageList: TImageList;
    ActionList: TActionList;
    actCloseConnection: TAction;
    lvConnections: TListViewEx;
    PopupMenu: TPopupMenu;
    piUpdateSpeed: TMenuItem;
    pi1Second: TMenuItem;
    pi2Seconds: TMenuItem;
    pi3Seconds: TMenuItem;
    pi4Seconds: TMenuItem;
    pi5Seconds: TMenuItem;
    N1: TMenuItem;
    piCloseConnection: TMenuItem;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure lvConnectionsCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lvConnectionsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TimerTimer(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure piSecondsClick(Sender: TObject);
    procedure actCloseConnectionExecute(Sender: TObject);
    procedure actCloseConnectionUpdate(Sender: TObject);
  private
    { Private declarations }
    FData: string;
    FDataLen: Integer;
    FClientSocket: TClientSocket;
    procedure GetCurrentConnections;
    procedure ClearConnections;
    procedure UpdateStatus;
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; const AServerAddress: string); reintroduce;
    destructor Destroy; override;
  end;

var
  ConnForm: TConnForm;

implementation

uses CltMain, CSConst, NetConst, NetUtils, Registry;

{$R *.dfm}

constructor TConnForm.Create(AOwner: TComponent; const AServerAddress: string);
begin
  inherited Create(AOwner);
  FClientSocket := TClientSocket.Create(Self);
  with FClientSocket do
  begin
    Address := Copy(AServerAddress, 1, Pos(':', AServerAddress) - 1);
    Port := StrToInt(Copy(AServerAddress, Pos(':', AServerAddress) + 1, MaxInt));
    OnRead := ClientSocketRead;
    OnDisconnect := ClientSocketDisconnect;
    OnError := ClientSocketError;
  end;
  Caption := AServerAddress;
  ConnForm := Self;
end;

destructor TConnForm.Destroy;
begin
  FClientSocket.Free;
  inherited Destroy;
end;

procedure TConnForm.GetCurrentConnections;
var
  Buffer: DWORD;
begin
  if not FClientSocket.Active then
  begin
    FClientSocket.Open;
    Application.ProcessMessages;
  end;
  if FClientSocket.Active then
  begin
    Buffer := acGetConnTable;
    FClientSocket.Socket.SendBuf(Buffer, SizeOf(Buffer))
  end;
end;

procedure TConnForm.ClearConnections;
begin
  FData := '';
  FDataLen := 0;
  with lvConnections.Items do
    if Count > 0 then
    begin
      BeginUpdate;
      try
        Clear;
      finally
        EndUpdate;
      end;
    end;
  UpdateStatus;
end;

procedure TConnForm.UpdateStatus;
const
  States: array[Boolean] of string = (SDisconnected, SConnected);
begin
  StatusBar.Panels[0].Text := Format(SCurrentConnections, [lvConnections.Items.Count]);
  StatusBar.Panels[1].Text := States[FClientSocket.Active];
end;

procedure TConnForm.FormCreate(Sender: TObject);
var
  Position: TRect;
begin
  with MainForm.Registry do
    if OpenKey(MainForm.ApplicationKey + SL_KEY + Caption, False) then
    try
      if ValueExists(SPosition) then
      begin
        ReadBinaryData(SPosition, Position, SizeOf(Position));
        BoundsRect := Position;
      end;
      if ValueExists(SWindowState) then
        if ReadInteger(SWindowState) = Ord(wsMaximized) then
          WindowState := wsMaximized;
      if ValueExists(STimeOut) then
        Timer.Interval := ReadInteger(STimeOut);   
    finally
      CloseKey;
    end;
end;

procedure TConnForm.FormShow(Sender: TObject);
begin
  UpdateStatus;
  GetCurrentConnections;
end;

procedure TConnForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TConnForm.FormDestroy(Sender: TObject);
var
  Position: TRect;
begin
  with MainForm.Registry do
    if OpenKey(MainForm.ApplicationKey + SL_KEY + Caption, True) then
    try
      if WindowState = wsNormal then
      begin
        Position := BoundsRect;
        WriteBinaryData(SPosition, Position, SizeOf(Position));
      end;
      WriteInteger(SWindowState, Ord(WindowState));
      WriteInteger(STimeOut, Timer.Interval);
    finally
      CloseKey;
    end;
end;

procedure TConnForm.lvConnectionsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if Data = -1 then
    Compare := AnsiCompareText(AlignIpAddress(Item1.Caption),
                               AlignIpAddress(Item2.Caption))
  else
    Compare := AnsiCompareText(Item1.SubItems[Data],
                               Item2.SubItems[Data]);
  if lvConnections.SortOrder = soDown then
    Compare := -Compare;
end;

procedure TConnForm.lvConnectionsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 65) and (Shift = [ssCtrl]) then
    lvConnections.SelectAll;
end;

procedure TConnForm.TimerTimer(Sender: TObject);
begin
  GetCurrentConnections;
end;

procedure TConnForm.PopupMenuPopup(Sender: TObject);
begin
  piUpdateSpeed.Items[(Timer.Interval div MSecsPerSec) - 1].Checked := True;
end;

procedure TConnForm.piSecondsClick(Sender: TObject);
begin
  Timer.Interval := (Sender as TMenuItem).Tag;
end;

procedure TConnForm.actCloseConnectionExecute(Sender: TObject);
var
  Buffer: Pointer;
  BufLen, I: Integer;
begin
  BufLen := AC_SIZE * 2;
  GetMem(Buffer, BufLen);
  try
    for I := lvConnections.Items.Count - 1 downto 0 do
      with lvConnections.Items[I] do
        if Selected then
        begin
          PDWORD(Buffer)^ := acCloseConnect;
          PDWORD(DWORD(Buffer) + AC_SIZE)^ := DWORD(Data);
          FClientSocket.Socket.SendBuf(Buffer^, BufLen);
        end;
  finally
    FreeMem(Buffer);
  end;
end;

procedure TConnForm.actCloseConnectionUpdate(Sender: TObject);
begin
  actCloseConnection.Enabled := Assigned(lvConnections.Selected);
end;

procedure TConnForm.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  RecvLen, Offset, I, J: Integer;
  Buffer: Pointer;
  Str: string;
  List: TStrings;
begin
  with Socket do
  begin
    RecvLen := ReceiveLength;
    GetMem(Buffer, RecvLen);
    try
      RecvLen := ReceiveBuf(Buffer^, RecvLen);
      if RecvLen > 0 then
      begin
        Offset := 0;
        if PDWORD(Buffer)^ = acResult then
        begin
          FDataLen := PDWORD(DWORD(Buffer) + AC_SIZE)^;
          Offset := AC_SIZE * 2;
          if FDataLen = 0 then
          begin
            ClearConnections;
            Exit;
          end;
        end;
        SetString(Str, PChar(DWORD(Buffer) + DWORD(Offset)),
          (RecvLen - Offset) div SizeOf(Char));
        FData := FData + Str;
        if FDataLen = Length(FData) * SizeOf(Char) then
          with TStringList.Create do
          try
            Text := FData;
            with lvConnections do
            begin
              List := TStringList.Create;
              try
                for I := 0 to Count - 1 do
                begin
                  List.Clear;
                  ExtractStrings([cFldSep], [], PChar(Strings[I]), List);
                  for J := 0 to Items.Count - 1 do
                    if StrToInt(List[3]) = Integer(Items[J].Data) then
                      Break;
                  if J > Items.Count - 1 then
                    with Items.Add do
                    begin
                      ImageIndex := 0;
                      Caption := List[0];
                      SubItems.Add(List[1]);
                      SubItems.Add(List[2]);
                      Data := Pointer(StrToInt(List[3]));
                    end;
                end;
                for I := Items.Count - 1 downto 0 do
                begin
                  for J := 0 to Count - 1 do
                  begin
                    List.Clear;
                    ExtractStrings([cFldSep], [], PChar(Strings[J]), List);
                    if Integer(Items[I].Data) = StrToInt(List[3]) then
                      Break;
                  end;
                  if J > Count - 1 then
                    Items[I].Delete;
                end;
              finally
                List.Free;
              end;
              if not Assigned(ItemFocused) then
                Items[0].Focused := True;
            end;
            FData := '';
            FDataLen := 0;
            UpdateStatus;
          finally
            Free;
          end;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

procedure TConnForm.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  ClearConnections;
end;

procedure TConnForm.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

end.

