unit FrmEditEmailInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, CommonData;

type
  TEmailInfoF = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    ContainDataCB: TComboBox;
    Label2: TLabel;
    EmailDirectionCB: TComboBox;
    procedure ContainDataCBDropDown(Sender: TObject);
    procedure EmailDirectionCBDropDown(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EmailInfoF: TEmailInfoF;

implementation

uses UnitElecServiceData;

{$R *.dfm}

procedure TEmailInfoF.ContainDataCBDropDown(Sender: TObject);
begin
  g_ContainData4Mail.SetType2Combo(ContainDataCB);
end;

procedure TEmailInfoF.EmailDirectionCBDropDown(Sender: TObject);
begin
  g_ProcessDirection.SetType2Combo(EmailDirectionCB);
end;

procedure TEmailInfoF.FormCreate(Sender: TObject);
begin
  ContainDataCBDropDown(nil);
  EmailDirectionCBDropDown(nil);
end;

end.

