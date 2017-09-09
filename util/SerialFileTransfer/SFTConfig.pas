unit SFTConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask,
  JvExControls, JvComCtrls, JvExMask, JvToolEdit, JvExStdCtrls, JvCheckBox;

type
  TSFTConfigF = class(TForm)
    PageControl1: TPageControl;
    Tabsheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    QueryIntervalEdit: TEdit;
    ResponseWaitTimeOutEdit: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Label5: TLabel;
    DownLoadDirEdit: TJvDirectoryEdit;
    DontAskDnLdConfirmCB: TJvCheckBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SFTConfigF: TSFTConfigF;

implementation

uses MainUnit;

{$R *.dfm}

procedure TSFTConfigF.Button1Click(Sender: TObject);
begin
  SerialFileTransferF.SetConfigComm;
end;

end.
