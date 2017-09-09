unit main_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, Vcl.ExtCtrls,
  AdvOfficeStatusBar, Vcl.Menus, AdvToolBar, Vcl.ImgList, Vcl.Imaging.pngimage;

type
  Tmain_Frm = class(TForm)
    AdvDockPanel1: TAdvDockPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    Panel1: TPanel;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    ImageList32: TImageList;
    Image1: TImage;
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ISCreateForm(aClass: TFormClass; aName ,aCaption : String);
    procedure ChildFormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  main_Frm: Tmain_Frm;

implementation
uses
  appVersion_Unit,
  appCode_Unit,
  CommonUtil_Unit;

{$R *.dfm}

procedure Tmain_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  if Assigned(appCode_Frm) then
    appCode_Frm.Show
  else
    ISCreateForm(TappCode_Frm,'appCode_Frm','[어플리케이션 코드 관리]');
end;

procedure Tmain_Frm.AdvGlowButton2Click(Sender: TObject);
begin
  if Assigned(appCode_Frm) then
    appVersion_Frm.Show
  else
    ISCreateForm(TappVersion_Frm,'appVersion_Frm','[어플리케이션 버전 관리]');
end;

procedure Tmain_Frm.ChildFormClose(Sender: TObject; var Action: TCloseAction);
begin
//  AdvToolBar1.RemoveMDIChildMenu(TForm(Sender));
  Action   := caFree;
end;

procedure Tmain_Frm.ISCreateForm(aClass: TFormClass; aName, aCaption: String);
var
  aForm : TForm;
  i : Integer;
begin
  aForm := nil;
  try
    LockMDIChild(True);
    for i:=(Main_Frm.MDIChildCount - 1) DownTo 0 Do
    begin
      if SameText(Main_Frm.MDIChildren[I].Name,aName) then
      begin
        aForm := Main_Frm.MDIChildren[I];
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
//      AdvToolBar1.AddMDIChildMenu(aForm);
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
