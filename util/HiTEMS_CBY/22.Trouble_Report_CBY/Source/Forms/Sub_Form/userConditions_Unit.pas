unit userConditions_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGroupBox,
  AdvOfficeButtons, Vcl.ExtCtrls, AdvOfficeStatusBar;

type
  TuserConditions_Frm = class(TForm)
    Statusbar1: TAdvOfficeStatusBar;
    Panel8: TPanel;
    Panel11: TPanel;
    grptype: TAdvOfficeRadioGroup;
    Panel1: TPanel;
    Panel2: TPanel;
    GDate: TAdvOfficeRadioGroup;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FFirst : Boolean;
  public
    { Public declarations }
    FOwner : TMain_Frm;

    procedure SaveConditions;
  end;

var
  userConditions_Frm: TuserConditions_Frm;

implementation
uses
  DataModule_Unit;

{$R *.dfm}

{ TuserConditions_Frm }

procedure TuserConditions_Frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TuserConditions_Frm.FormActivate(Sender: TObject);
begin
  if FFirst = True then
  begin
    FFirst := False;

    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from TROUBLE_USERCONDITIONS');
      SQL.Add('where USERID = :param1');
      parambyname('param1').AsString := STATUSBAR1.Panels[0].Text;
      Open;

      if not(RecordCount = 0) then
      begin
        grpType.ItemIndex := Fieldbyname('RPTYPE').AsInteger;
        GDate.ItemIndex := Fieldbyname('SDATETERMS').AsInteger;
      end;
    end;
  end;
end;

procedure TuserConditions_Frm.FormCreate(Sender: TObject);
begin
  FFirst := true;
end;

procedure TuserConditions_Frm.SaveConditions;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From Trouble_UserConditions where userID = :param1');
    parambyname('param1').AsString := Statusbar1.Panels[0].Text;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into Trouble_DataTemp');
    SQL.Add('Values(:UserID, :RPType, :SDateTerms)');
    parambyname('UserID').AsString     := Statusbar1.Panels[0].Text;
    parambyname('RPType').AsInteger    := GRPType.ItemIndex;
    parambyname('SDateTerms').AsInteger := GDate.ItemIndex;
    ExecSQL;
  end;
end;

end.
