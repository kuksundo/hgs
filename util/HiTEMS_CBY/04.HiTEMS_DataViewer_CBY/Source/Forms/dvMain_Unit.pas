unit dvMain_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, AdvOfficeStatusBar,
  AdvToolBar, AdvMenus, AdvMenuStylers, AdvToolBarStylers, Vcl.Menus,
  Vcl.ImgList, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TdvMain_Frm = class(TForm)
    AdvMainMenu1: TAdvMainMenu;
    Files1: TMenuItem;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    AdvMenuStyler1: TAdvMenuStyler;
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBar1: TAdvToolBar;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    AdvDockPanel2: TAdvDockPanel;
    AdvToolBar2: TAdvToolBar;
    AdvGlowButton1: TAdvGlowButton;
    ImageList16x16: TImageList;
    Image1: TImage;
    procedure AdvGlowButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ChildFormClose(Sender: TObject; var Action: TCloseAction);
    procedure ISCreateForm(aClass: TFormClass; aName ,aCaption : String);
  end;

var
  dvMain_Frm: TdvMain_Frm;

implementation
uses
  msViewer_Unit,
  CommonUtil_Unit;

{$R *.dfm}

{ TdvMain_Frm }

procedure TdvMain_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  ISCreateForm(TmsViewer_Frm,'msViewer_Frm','[계측데이터 조회]');
end;

procedure TdvMain_Frm.ChildFormClose(Sender: TObject; var Action: TCloseAction);
begin
  AdvToolBar1.RemoveMDIChildMenu(TForm(Sender));
  Action   := caFree;
end;

procedure TdvMain_Frm.ISCreateForm(aClass: TFormClass; aName, aCaption: String);
var
  aForm : TForm;
  i : Integer;
begin
  aForm := nil;
  try
    LockMDIChild(True);
    for i:=(dvMain_Frm.MDIChildCount - 1) DownTo 0 Do
    begin
      if SameText(dvMain_Frm.MDIChildren[I].Name,aName) then
      begin
        aForm := dvMain_Frm.MDIChildren[I];
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
