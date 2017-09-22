unit MonitornewApp_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  NxCollection, Vcl.Imaging.jpeg, Vcl.ExtCtrls, AdvGlowButton, Vcl.ExtDlgs,
  Data.DBXJSON, Data.DBXJSONCommon, Vcl.ImgList, JvBaseDlg, JvImageDlg,
  GDIPPictureContainer, Vcl.Imaging.pngimage;

type
  TnewMonApp_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    StatusBar1: TStatusBar;
    appTitle: TEdit;
    appPath: TEdit;
    appDesc: TEdit;
    Button1: TButton;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    Button2: TButton;
    RelPathCB: TCheckBox;
    GDIPPictureContainer1: TGDIPPictureContainer;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    icon: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    AutoRunCB: TCheckBox;
    Label5: TLabel;
    RunParamEdit: TEdit;
    Label1: TLabel;
    ProgRelPathCB: TCheckBox;
    Button3: TButton;
    ProgNameEdit: TEdit;
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    FIconPath,
    FDisableIconPath : String;
  end;

implementation

{$R *.dfm}

procedure TnewMonApp_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TnewMonApp_Frm.AdvGlowButton2Click(Sender: TObject);
begin
  if not Assigned(ICon.Picture) and (FIconPath = '') then
  begin
    raise Exception.Create('Enable ������ �̹����� �����Ͽ� �ֽʽÿ�!');
    Button1.SetFocus;
  end;

  //if not Assigned(DisableICon.Picture) and (FDisableIconPath = '') then
  //begin
  //  raise Exception.Create('Disable ������ �̹����� �����Ͽ� �ֽʽÿ�!');
  //  Button3.SetFocus;
  //end;

  if appTitle.Text = '' then
  begin
    raise Exception.Create('���ø����̼� Ÿ��Ʋ�� �Է��Ͽ� �ֽʽÿ�!');
    appTitle.SetFocus;
  end;

  if appPath.Text = '' then
  begin
    raise Exception.Create('����� ���ø����̼��� �����Ͽ� �ֽʽÿ�!');
    Button2.SetFocus;
  end;

  ModalResult := mrOk;
end;

procedure TnewMonApp_Frm.Button1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    FIconPath := OpenPictureDialog1.FileName;
    with GDIPPictureContainer1.Items do
    begin
      Clear;
      Add;
      Items[Count-1].Name := ExtractFileName(FIconPath);
      Items[Count-1].Picture.LoadFromFile(FIconPath);

      Icon.Picture.Assign(Items[Count-1].Picture);
      Icon.Invalidate;
    end;
  end;
end;

procedure TnewMonApp_Frm.Button2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    appPath.Text := OpenDialog1.FileName;
  end;
end;

procedure TnewMonApp_Frm.Button3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    ProgNameEdit.Text := OpenDialog1.FileName;
  end;
end;

end.