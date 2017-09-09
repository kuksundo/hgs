unit fuelMain_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, AdvToolBar, DB, Ora,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.ComCtrls, AdvOfficeStatusBar, AdvSplitter,
  Vcl.Grids, Vcl.ImgList, NxEdit, Vcl.StdCtrls, AdvDateTimePicker, AdvPanel,
  NxCollection, AdvObj, BaseGrid, AdvGrid, DateUtils, tmsAdvGridExcel, Vcl.Menus,
  Vcl.Imaging.pngimage;

type
  TfuelMain_Frm = class(TForm)
    ImageList16x16: TImageList;
    ImageList32x32: TImageList;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    AdvGridExcelIO1: TAdvGridExcelIO;
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBar1: TAdvToolBar;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    AdvGlowButton3: TAdvGlowButton;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    Image1: TImage;
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure accGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure AdvGlowButton3Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ChildFormClose(Sender: TObject; var Action: TCloseAction);
    procedure ISCreateForm(aClass: TFormClass; aName ,aCaption : String);


  end;

var
  fuelMain_Frm: TfuelMain_Frm;

implementation
uses
  fuelIn_Unit,
  fuelPrice_Unit,
  fuelConsumption_Unit,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure TfuelMain_Frm.accGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then
    HAlign := taCenter
  else
  begin
    case ACol of
      0..2 : HAlign := taRightJustify;

    end;
  end;
end;

procedure TfuelMain_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  ISCreateForm(TfuelPrice_Frm,'fuelPrice_Frm','[연료유 단가 관리]');
end;

procedure TfuelMain_Frm.AdvGlowButton2Click(Sender: TObject);
begin
  ISCreateForm(TfuelIn_Frm,'fuelIn_Frm','[연료유 입고 관리]');
end;

procedure TfuelMain_Frm.AdvGlowButton3Click(Sender: TObject);
begin
  ISCreateForm(TfuelConsumption_Frm,'fuelConsumption_Frm','[연료유 사용 현황]');
end;

procedure TfuelMain_Frm.ChildFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  AdvToolBar1.RemoveMDIChildMenu(TForm(Sender));
  Action   := caFree;
end;

procedure TfuelMain_Frm.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TfuelMain_Frm.ISCreateForm(aClass: TFormClass; aName,
  aCaption: String);
var
  aForm : TForm;
  i : Integer;
begin
  aForm := nil;
  try
    LockMDIChild(True);
    for i:=(fuelMain_Frm.MDIChildCount - 1) DownTo 0 Do
    begin
      if SameText(fuelMain_Frm.MDIChildren[I].Name,aName) then
      begin
        aForm := fuelMain_Frm.MDIChildren[I];
        Break;
      end;
    end;

    if aForm = nil Then
    begin
      aForm := aClass.Create(Application);
      with aForm do
      begin
        Caption := aCaption;
        OnClose := ChildFormClose;

      end;
      AdvToolBar1.AddMDIChildMenu(aForm);
//      AdvOfficeMDITabSet1.AddTab(aForm);
    end;

    if aForm.WindowState = wsMinimized then
      aForm.WindowState := wsNormal;

    aForm.Show;
  finally
    LockMDIChild(False);
  end;
end;

end.
