unit frmSDIDocPanelBplUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, AdvOfficePager, pjhFormDesigner,
  Vcl.StdCtrls, AdvPageControl, Vcl.ComCtrls;

type
  TfrmSDIDocPanel = class(TForm)
    Button1: TButton;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    Panel1: TPanel;
    ELDesignPanel1: TELDesignPanel;
    Button2: TButton;
    procedure AdvOfficePager1InsertPage(Sender: TObject; APage: TAdvOfficePage);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses frmMainBplUnit;

procedure TfrmSDIDocPanel.AdvOfficePager1InsertPage(Sender: TObject;
  APage: TAdvOfficePage);
var
  LDesignPanel: TELDesignPanel;
  LPanel: TPanel;
begin
  APage.ShowClose := True;
  LDesignPanel := TELDesignPanel.Create(APage);
  LDesignPanel.Parent := APage;
  LDesignPanel.Align := alClient;

  with frmMain.ELDesigner1 do
  begin
    Active := False;
    if Assigned(LDesignPanel) then
      DesignPanel := LDesignPanel
    else
    begin
      ShowMessage('Design Panel is null');
      exit;
    end;
    LPanel := TPanel.Create(LDesignPanel);
    LPanel.Parent := LDesignPanel;
    LPanel.Align := alClient;
    DesignControl := LPanel;
    Active := True;
    frmMain.PrepareOIInterface(LPanel);
  end;
end;

procedure TfrmSDIDocPanel.Button1Click(Sender: TObject);
var
  i: integer;
  LDesignPanel: TELDesignPanel;
  LPanel: TPanel;
begin
  //frmMain.ELDesigner1.DesignControlVisible := true;
  //frmMain.ELDesigner1.Modified;
  //frmMain.ELDesigner1.DesignControl.Show;
{  for i := 0 to AdvOfficePager1.ActivePage.ComponentCount - 1 do
  begin
    if AdvOfficePager1.ActivePage.Components[i] is TPanel then
    begin
      LDesignPanel := AdvOfficePager1.ActivePage.Components[i] as TELDesignPanel;
      //LDesignPanel.;
    end;
  end;}
  frmMain.ELDesigner1.DesignPanel := ELDesignPanel1;
  frmMain.ELDesigner1.DesignControl := Panel1;
  frmMain.ELDesigner1.Active := True;
  frmMain.PrepareOIInterface(Panel1);
end;

procedure TfrmSDIDocPanel.Button2Click(Sender: TObject);
var
  i: integer;
begin
  frmMain.ELDesigner1.DesignPanel.FormRefresh;
  frmMain.ELDesigner1.DesignControlRefresh;
  //for i := 0 to Panel1.ComponentCount - 1 do
    //TControl(Panel1.Components[i]).Refresh;
end;

end.
