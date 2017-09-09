unit MT210Config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask,
  JvExControls, JvComCtrls, MT210ComConst;

type
  TMT210ConfigF = class(TForm)
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
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MT210ConfigF: TMT210ConfigF;

implementation

uses MT210_Comm;

{$R *.dfm}

procedure TMT210ConfigF.Button1Click(Sender: TObject);
begin
  MT210ComF.SetConfigComm;
end;

end.
