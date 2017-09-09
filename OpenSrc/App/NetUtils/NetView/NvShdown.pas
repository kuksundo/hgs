unit NvShdown;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TShutdownDialog = class(TForm)
    grbOptions: TGroupBox;
    chkForce: TCheckBox;
    chkReboot: TCheckBox;
    btnOk: TButton;
    btnAbort: TButton;
    btnCancel: TButton;
    lblTimeOut: TLabel;
    Memo: TMemo;
    edtTimeout: TEdit;
    lblMessage: TLabel;
    udTimeout: TUpDown;
    procedure btnOkClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
  private
    { Private declarations }
    FComputerName: string;
    FLocal: Boolean;
    procedure EnablePrivileges;
    procedure DisablePrivileges;
  public
    { Public declarations }
  end;

procedure ShowShutdownDialog(AOwner: TComponent; const AComputerName: string);

var
  ShutdownDialog: TShutdownDialog;

implementation

uses NetConst;

{$R *.dfm}

var
  hToken: THandle;
  TokenPrivileges: TTokenPrivileges;
  ReturnLength: DWORD = 0;

procedure ShowShutdownDialog(AOwner: TComponent; const AComputerName: string);
var
  LocalComputerName: string;
  Size: DWORD;
begin
  with TShutdownDialog.Create(AOwner) do
  try
    FComputerName := AComputerName;
    SetLength(LocalComputerName, MAX_COMPUTERNAME_LENGTH + 1);
    Size := Length(LocalComputerName);
    GetComputerName(PChar(LocalComputerName), Size);
    SetLength(LocalComputerName, Size);
    FLocal := AnsiSameText(AComputerName, LocalComputerName);
    Caption := Format(Caption, [AComputerName]);
    Memo.Text := SShutdownText;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TShutdownDialog.EnablePrivileges;
var
  PrivilegeName: PChar;
begin
  if not OpenProcessToken(GetCurrentProcess,
                          TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
    RaiseLastOSError;
  if Flocal then
    PrivilegeName := 'SeShutdownPrivilege'
  else
    PrivilegeName := 'SeRemoteShutdownPrivilege';
  try
    if not LookupPrivilegeValue(PChar(FComputerName), PrivilegeName,
                                TokenPrivileges.Privileges[0].Luid) then
      RaiseLastOSError;
    TokenPrivileges.PrivilegeCount := 1;
    TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    if not AdjustTokenPrivileges(hToken, False, TokenPrivileges, 0, nil, ReturnLength) then
      RaiseLastOSError;
  except
    CloseHandle(hToken);
    raise;
  end;
end;

procedure TShutdownDialog.DisablePrivileges;
begin
  TokenPrivileges.Privileges[0].Attributes := 0;
  try
    if not AdjustTokenPrivileges(hToken, False, TokenPrivileges, 0, nil, ReturnLength) then
      RaiseLastOSError;
  finally
    CloseHandle(hToken);
  end;
end;

procedure TShutdownDialog.btnOkClick(Sender: TObject);
begin
  if Application.MessageBox(PChar(SConfirmMsg), PChar(Application.Title),
                            MB_YESNO or MB_ICONQUESTION) = ID_NO then Exit;
  EnablePrivileges;
  try
    if not InitiateSystemShutdown(PChar(FComputerName),
                                  PChar(Memo.Text),
                                  udTimeout.Position,
                                  chkForce.Checked,
                                  chkReboot.Checked) then
      RaiseLastOSError;
  finally
    DisablePrivileges;
  end;
  btnAbort.Enabled := True;
end;

procedure TShutdownDialog.btnAbortClick(Sender: TObject);
begin
  EnablePrivileges;
  try
    if not AbortSystemShutdown(PChar(FComputerName)) then
      RaiseLastOSError;
  finally
    DisablePrivileges;
  end;
  btnAbort.Enabled := False;
end;

end.
