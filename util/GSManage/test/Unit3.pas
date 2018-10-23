unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  Vcl.StdCtrls, syncommons, SynCrypto;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    edtTextToEncrypt: TEdit;
    edtCrypted: TEdit;
    edtDecrypted: TEdit;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SayHi;
    function GetSum(X,Y:Integer): Integer;
  end;

const
  my_key = 'testkey';

var
  Form3: TForm3;
  g_IPCClient: TIPCClient;

implementation

uses RTTI, UnitExcelUtil;

{$R *.dfm}

const
  IPC_SERVER_NAME_4_OUTLOOK = 'Mail2CromisIPCServer';
  IPC_SERVER_NAME_4_OUTLOOK2 = 'Mail2CromisIPCServer2';
  CMD_REQ_MAILINFO_SEND2 = 'Request Mail-Info to Send2';
  CMD_LIST = 'CommandList';
  CMD_SEND_MAIL_ENTRYID = 'Send Mail Entry Id';
  CMD_REQ_MAIL_VIEW = 'Request Mail View';

procedure ExecMethod(AClassInstance: TObject; MethodName:string; const Args: array of TValue);
var
 R : TRttiContext;
 T : TRttiType;
 M : TRttiMethod;
// C : TForm3;
begin
  T := R.GetType(TForm3);
//  C := TForm3.Create(nil);
//  try
    for M in t.GetMethods do
      if (m.Parent = t) and (m.Name = MethodName)then
      begin
          M.Invoke(AClassInstance,Args);
      end;
//  finally
//    C.Free;
//  end;
end;

procedure TForm3.Button1Click(Sender: TObject);
var
  Request: IIPCData;
  Result: IIPCData;
  LStrList: TStringList;
  LEntryId, LStoreId: string;
begin
  if not g_IPCClient.IsConnected then
  begin
    ShowMessage('Not Connected');
//    Exit;
    g_IPCClient.ConnectClient;
  end;

  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK);
    LStrList.Add('Command='+CMD_REQ_MAIL_VIEW);
    LEntryId := 'Entry';
    LStoreId := 'Store';
    LStrList.Add('EntryId='+LEntryId);
    LStrList.Add('StoreId='+LStoreId);

    Request := AcquireIPCData;
    Request.ID := DateTimeToStr(Now);
    Request.Data.WriteUTF8String(CMD_LIST,LStrList.Text);
    Result := g_IPCClient.ExecuteRequest(Request);

    if g_IPCClient.AnswerValid then
    begin
    end;
  finally
    LStrList.Free;
  end;
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  IPCClient: TIPCClient;
  Request: IIPCData;
  Result: IIPCData;
  LStrList: TStringList;
  Command: AnsiString;
begin
  LStrList := TStringList.Create;
  IPCClient := TIPCClient.Create;
  try
    IPCClient.ServerName := IPC_SERVER_NAME_4_OUTLOOK2;
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK2);
    LStrList.Add('Command='+CMD_REQ_MAILINFO_SEND2);

    Request := AcquireIPCData;
    Request.ID := DateTimeToStr(Now);
    Request.Data.WriteUTF8String(CMD_LIST,LStrList.Text);
//    Result := IPCClient.ExecuteConnectedRequest(Request);
    Result := IPCClient.ExecuteRequest(Request);

    if IPCClient.AnswerValid then
    begin
      LStrList.Clear;
      LStrList.Text := Result.Data.ReadUTF8String(CMD_LIST);
      Command := LStrList.Values['Command'];
      if Command = CMD_SEND_MAIL_ENTRYID then
      begin
        ShowMessage(LStrList.Text);
      end;
    end;
  finally
    IPCClient.Free;
    LStrList.Free;
  end;
end;

procedure TForm3.Button3Click(Sender: TObject);
var
  Docs, Docs2: TVariantDynArray;
  LVar: Variant;
  DocsDA, DocsDA2: TDynArray;
  LCount: integer;
  LStr: string;
begin
  DocsDA.Init(TypeInfo(TVariantDynArray), Docs, @LCount);
  LCount := 2;
  SetLength(Docs,LCount);
  TDocVariant.New(Docs[0]);
  docs[0].EntryId := 'EntryId1';
  docs[0].StoreId := 'StoreId1';
  TDocVariant.New(Docs[1]);
  docs[1].EntryId := 'EntryId2';
  docs[1].StoreId := 'StoreId2';

  LStr := DocsDA.SaveToJson;
  Docs2 := JSONToVariantDynArray(LStr);
//  DocsDA2.Init(TypeInfo(TVariantDynArray), LStr);
//  DocsDA2.Init(TypeInfo(TVariantDynArray), Docs2, @LCount);
//  DocsDA2.LoadFromJSON(Pointer(LStr), nil);

//  VariantLoadJson(LVar,StringToUTF8(LStr));
  ShowMessage(Docs2[1].EntryId);
//  ShowMessage(VariantSaveJSON(docs[0]));
end;

procedure TForm3.Button4Click(Sender: TObject);
var
  key : TSHA256Digest;
  aes : TAESCFB;
  s:RawByteString;
begin
  SynCommons.HexToBin(Pointer(SHA256(my_key)), @key, 32);

  aes := TAESCFB.Create(key, 256);
  try
    s := StringToUTF8(edtTextToEncrypt.Text);
    s := BinToBase64(aes.EncryptPKCS7(s, True));
    edtCrypted.Text := UTF8ToString(s);
  finally
    aes.Free;
  end;
end;

procedure TForm3.Button5Click(Sender: TObject);
var
  key : TSHA256Digest;
  aes : TAESCFB;
  s:RawByteString;
begin
  SynCommons.HexToBin(Pointer(SHA256(my_key)), @key, 32);

   aes := TAESCFB.Create(key, 256);
  try
    s := StringToUTF8(edtCrypted.Text);
    s := aes.DecryptPKCS7(Base64ToBin(s), True);
    edtDecrypted.Text := UTF8ToString(s);
  finally
    aes.Free;
  end;
end;

procedure TForm3.Button6Click(Sender: TObject);
begin
  ExecMethod(Self,'SayHi',[]);
  ExecMethod(Self,'GetSum',[10,20]);
end;

procedure TForm3.Button7Click(Sender: TObject);
begin
  Button7.Caption := Char(VK_DOWN);
end;

procedure TForm3.Button8Click(Sender: TObject);
var
  i: smallint;
  b: byte;
begin
  i := VKKeyScanEx(Char(VK_DOWN), GetKeyboardLayout(0));
  b := i;
  Button8.Caption := IntToStr(Ord(Char(VK_DOWN)));
end;

procedure TForm3.Button9Click(Sender: TObject);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
begin
  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open('e:\INVOICE(¿µ¹®).xlsx');
  LExcel.Visible := true;
  LWorksheet := LExcel.ActiveSheet;

//  LRange := LWorkSheet.Rows[27].Select;
  LRange := LWorksheet.range['A27:M27'];
  LRange.Copy;
  LRange := LWorksheet.range['A28:M28'];
  LRange.Insert;
  LRange := LWorkSheet.Rows[28];
  LRange.RowHeight := 25;
//  LExcel.CutCopyMode := False;
//  LRange.Paste;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(g_IPCClient);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  g_IPCClient := TIPCClient.Create;
  g_IPCClient.ServerName := IPC_SERVER_NAME_4_OUTLOOK;
  g_IPCClient.ConnectClient;
end;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Button8.Caption := IntToStr(Ord('('));
end;

procedure TForm3.FormKeyPress(Sender: TObject; var Key: Char);
var
  i: smallint;
  b: byte;
begin
  i := VKKeyScanEx(Key, GetKeyboardLayout(0));
  b := i;
  Button8.Caption := IntToStr(b);
end;

function TForm3.GetSum(X, Y: Integer): Integer;
begin
   ShowMessage(IntToStr(X + Y));
end;

procedure TForm3.SayHi;
begin
  ShowMessage('Hi');
end;

end.
