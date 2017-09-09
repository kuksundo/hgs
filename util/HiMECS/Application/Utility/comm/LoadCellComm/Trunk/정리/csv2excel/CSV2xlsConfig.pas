unit CSV2xlsConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  Tcsv2xlsConfigF = class(TForm)
    HostName_Edit: TEdit;
    DBName_Edit: TEdit;
    LogInID_Edit: TEdit;
    Passwd_Edit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  csv2xlsConfigF: Tcsv2xlsConfigF;

implementation

{$R *.dfm}

end.
