unit DataSaveConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Spin, Buttons, Mask, ToolEdit;

type
  TSaveConfigF = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ampm_combo: TComboBox;
    Hour_SpinEdit: TSpinEdit;
    Label1: TLabel;
    Minute_SpinEdit: TSpinEdit;
    Label2: TLabel;
    UseDate_ChkBox: TCheckBox;
    Month_SpinEdit: TSpinEdit;
    Label3: TLabel;
    Date_SpinEdit: TSpinEdit;
    Label4: TLabel;
    Repeat_ChkBox: TCheckBox;
    Label5: TLabel;
    TabSheet2: TTabSheet;
    HourCnt_SpinEdit: TSpinEdit;
    Label6: TLabel;
    MinuteCnt_SpinEdit: TSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    RepeatCnt_ChkBox: TCheckBox;
    TabSheet3: TTabSheet;
    SaveDB_ChkBox: TCheckBox;
    SaveFile_ChkBox: TCheckBox;
    Label9: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SecondCnt_SpinEdit: TSpinEdit;
    Label10: TLabel;
    FilenameEdit1: TFilenameEdit;
    FNameType_RG: TRadioGroup;
    TabSheet4: TTabSheet;
    Label11: TLabel;
    Label12: TLabel;
    Sep_Edit: TEdit;
    LastBlockNo_SpinEdit: TSpinEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SaveConfigF: TSaveConfigF;

implementation

{$R *.dfm}

end.
