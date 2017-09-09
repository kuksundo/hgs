unit DataSaveConfig2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, StdCtrls, dxWinXPBar, dxCore, dxContainer,
  ExtCtrls, ComCtrls, ATXPtask, dxCheckCtrls, Spin, dxButtons;

type
  TForm2 = class(TForm)
    spltMain: TSplitter;
    dxContainer3: TdxContainer;
    ScrollBox1: TScrollBox;
    dxContainer4: TdxContainer;
    dxWinXPBar4: TdxWinXPBar;
    dxContainer5: TdxContainer;
    dxWinXPBar5: TdxWinXPBar;
    dxContainer6: TdxContainer;
    dxWinXPBar6: TdxWinXPBar;
    imlWinXPBar: TImageList;
    aclWinXPBar: TActionList;
    acConnectRemoteServer: TAction;
    acConnectLocalServer: TAction;
    acConnectAdministrator: TAction;
    acSettingsUsers: TAction;
    acSettingsStatistics: TAction;
    acSettingsDatabase: TAction;
    acSettingsDownloads: TAction;
    acSynchronizeUnknown: TAction;
    acSynchronizeWeb: TAction;
    Action1: TAction;
    dxContainer1: TdxContainer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label5: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ComboBox1: TComboBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    chk2: TdxCheckbox;
    chk1: TdxCheckbox;
    TabSheet2: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    dxCheckbox1: TdxCheckbox;
    TabSheet3: TTabSheet;
    dxCheckbox2: TdxCheckbox;
    dxCheckbox3: TdxCheckbox;
    dxContainer2: TdxContainer;
    btnOK: TdxButton;
    btnCancel: TdxButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

end.
