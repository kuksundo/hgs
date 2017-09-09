unit NvPing;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask;

type
  TPingDialog = class(TForm)
    btnStart: TButton;
    btnCancel: TButton;
    GroupBox: TGroupBox;
    lblBytes: TLabel;
    lblNumber: TLabel;
    lblTimeOut: TLabel;
    edtBytes: TMaskEdit;
    edtNumber: TMaskEdit;
    edtTimeOut: TMaskEdit;
    chkFragment: TCheckBox;
    lblResults: TLabel;
    Memo: TMemo;
    procedure btnStartClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FComputerName: string;
    FIpAddress: string;
    FCancel: Boolean;
  public
    { Public declarations }
  end;

procedure ShowPingDialog(AOwner: TComponent; const AComputerName, AIpAddress: string);

var
  PingDialog: TPingDialog;

implementation

uses NetConst, IPHlpApi, WinSock;

{$R *.dfm}

procedure ShowPingDialog(AOwner: TComponent; const AComputerName, AIpAddress: string);
begin
  with TPingDialog.Create(AOwner) do
  try
    FComputerName := AComputerName;
    FIpAddress := AIpAddress;
    Caption := Format(Caption, [AComputerName]);
    ShowModal;
  finally
    Free;
  end;
end;

procedure TPingDialog.btnStartClick(Sender: TObject);
var
  IcmpHandle: THandle;
  BufferSize, TimeOut, EchoCount, RetVal, I: Integer;
  IpOpt: TIPOptionInformation;
  PingBuffer: Pointer;
  pIpe: PIcmpEchoReply;
  TimeStr: string;
begin
  IcmpHandle := IcmpCreateFile;
  if IcmpHandle = INVALID_HANDLE_VALUE then
  begin
    Memo.Lines.Add(SIcmpInitErr);
    Exit;
  end;
  try
    BufferSize := StrToInt(Trim(edtBytes.Text));
    if (BufferSize < 1) or (BufferSize > 65500) then
    begin
      BufferSize := 32;
      edtBytes.Text := IntToStr(BufferSize);
    end;
    EchoCount := StrToInt(Trim(edtNumber.Text));
    if EchoCount < 1 then
    begin
      EchoCount := 4;
      edtNumber.Text := IntToStr(EchoCount);
    end;
    TimeOut := StrToInt(Trim(edtTimeOut.Text));
    if TimeOut < 1 then
    begin
      TimeOut := 1000;
      edtTimeout.Text := IntToStr(TimeOut);
    end;
    with IpOpt do
    begin
      Ttl := 32;
      Tos := 0;
      if chkFragment.Checked then
        Flags := IP_FLAG_DF
      else
        Flags := 0;
      OptionsSize := 0;
      OptionsData := nil;
    end;
    GetMem(pIpe, SizeOf(TICMPEchoReply) + BufferSize);
    try
      GetMem(PingBuffer, BufferSize);
      try
        FillChar(PingBuffer^, BufferSize, $AA);
        pIpe^.Data := PingBuffer;
        with Memo.Lines do
        begin
          Add(Format(SPinging, [FComputerName, FIpAddress, BufferSize]));
          for I := 0 to EchoCount - 1 do
          begin
            if FCancel then
              Break;
            if Count > 100 then
            begin
              BeginUpdate;
              try
                Delete(0);
              finally
                EndUpdate;
              end;
            end;
            RetVal := IcmpSendEcho(IcmpHandle, inet_addr(PAnsiChar(AnsiString(FIpAddress))),
                                   PingBuffer, BufferSize, @IpOpt, pIpe,
                                   SizeOf(TICMPEchoReply) + BufferSize, TimeOut);
            if RetVal = 0 then
            begin
              RetVal := GetLastError;
              case RetVal of
                IP_REQ_TIMED_OUT:
                  Add(SReqTimedOut);
                IP_PACKET_TOO_BIG:
                  Add(SPacketNeedsFragmented);
              else
                Add(Format(SErrorCode, [RetVal]));
              end;
            end
            else
            begin
              if pIpe^.RoundTripTime < 1 then
                TimeStr := '<10'
              else
                TimeStr := '=' + IntToStr(pIpe^.RoundTripTime);
              Add(Format(SReply, [inet_ntoa(TInAddr(pIpe^.Address)),
                                  pIpe^.DataSize, TimeStr, pIpe^.Options.Ttl]));
            end;
            Sleep(1000);
            Application.ProcessMessages;
          end;
          Add('');
        end;
      finally
        FreeMem(PingBuffer);
      end;
    finally
      FreeMem(pIpe);
    end;
  finally
    IcmpCloseHandle(IcmpHandle);
  end;  
end;

procedure TPingDialog.btnCancelClick(Sender: TObject);
begin
  FCancel := True;
end;

end.
