unit UnitDynamoCommConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, Vcl.Mask, JvExMask, JvToolEdit;

type
  TDynamoConfigF = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    Tabsheet2: TTabSheet;
    Label5: TLabel;
    Label1: TLabel;
    PortEdit: TEdit;
    HostIPEdit: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    MyPortEdit: TEdit;
    MyIPEdit: TEdit;
    Bevel1: TBevel;
    Label4: TLabel;
    IntervalEdit: TEdit;
    Bevel2: TBevel;
    Label6: TLabel;
    TabSheet1: TTabSheet;
    ParaFilenameEdit: TJvFilenameEdit;
    Label7: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DynamoConfigF: TDynamoConfigF;

implementation

{$R *.dfm}

end.
