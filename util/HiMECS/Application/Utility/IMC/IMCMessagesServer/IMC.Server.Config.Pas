unit IMC.Server.Config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask, JvExMask, JvToolEdit,
  Winsock;

type
  TServerConfigF = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    Tabsheet2: TTabSheet;
    Label5: TLabel;
    PortEdit: TEdit;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    HostIpCB: TComboBox;
    Label3: TLabel;
    AutoStartIntervalEdit: TEdit;
    Label2: TLabel;
    JvFilenameEdit1: TJvFilenameEdit;
    Label4: TLabel;
    ConfFileFormatRG: TRadioGroup;
    EngParamEncryptCB: TCheckBox;
    procedure HostIpCBDropDown(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServerConfigF: TServerConfigF;

implementation

{$R *.dfm}

function GetLocalIPs : TStrings;
type
    TaPInAddr = array [0..10] of PInAddr;
    PaPInAddr = ^TaPInAddr;
var
    phe  : PHostEnt;
    pptr : PaPInAddr;
    Buffer : array [0..63] of Ansichar;
    I    : Integer;
    GInitData      : TWSADATA;

begin
  Result := TStringList.Create;
  // WSAStartup은 응용 프로그램이 원도우즈 소겟을 이용할 때 최초로 호출하여
  // 다른 소켓 함수를 사용할 수 있도록 초기화 한다.(마무리는 WSACleanup사용)
  // 이 함수는 응용 프로그램에 필요한 원도우즈 소켓 API의 버전을 알려주고,
  // 소켓 내부의 구현 사항을 리턴한다.
    WSAStartup($101, GInitData);
    GetHostName(@Buffer[0], SizeOf(Buffer));
    phe :=GetHostByName(buffer);
    if phe = nil then Exit;
    pptr := PaPInAddr(Phe^.h_addr_list);
    I := 0;
    while pptr^[I] <> nil do begin
      result.Add( StrPas(inet_ntoa(pptr^[I]^)) );
      Inc(I);
    end;
    WSACleanup;
end;

procedure TServerConfigF.HostIpCBDropDown(Sender: TObject);
begin
  HostIpCB.Items.Assign(GetLocalIPs);
end;

end.
