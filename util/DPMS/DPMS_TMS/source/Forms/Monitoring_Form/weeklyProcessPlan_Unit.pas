unit weeklyProcessPlan_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, Vcl.ExtCtrls, AeroButtons, AdvOfficeButtons, Vcl.ComCtrls,
  AdvGroupBox, CurvyControls, JvExControls, JvLabel, AdvEdit, AdvEdBtn,
  PlannerDatePicker, pjhPlannerDatePicker, System.DateUtils;

type
  TweeklyProcessPlanF = class(TForm)
    Panel2: TPanel;
    AdvSG1: TAdvStringGrid;
    Panel3: TPanel;
    JvLabel1: TJvLabel;
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    CurvyPanel3: TCurvyPanel;
    rg_team: TAdvOfficeCheckGroup;
    CurvyPanel4: TCurvyPanel;
    rg_taskType: TAdvOfficeCheckGroup;
    Button2: TButton;
    Button1: TButton;
    CurvyPanel2: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_end: TpjhPlannerDatePicker;
    dt_begin: TpjhPlannerDatePicker;
    AeroButton1: TAeroButton;
    AeroButton3: TAeroButton;
    AeroButton2: TAeroButton;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure AdvSG1GetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure FormCreate(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  weeklyProcessPlanF: TweeklyProcessPlanF;

implementation

uses DataModule_Unit;

{$R *.dfm}

procedure TweeklyProcessPlanF.AdvSG1GetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  Halign := TAlignment.taCenter;
  VAlign := TValignment.vtaCenter;
end;

procedure TweeklyProcessPlanF.AeroButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TweeklyProcessPlanF.Button2Click(Sender: TObject);
begin
  with AdvSG1 do
  begin
    ColCount := 4;
    RowCount := 5;

    Cells[0,0] := #13#10 + 'Engine Type';
    ColWidths[0] := Length(Cells[0,0])*10;

    Cells[1,0] := #13#10 + '금주 실적' + #13#10+'(' + FormatDateTime('mm.dd', dt_begin.DateTime) +
      ' ~ ' + FormatDateTime('mm.dd', dt_end.DateTime) + ')';
    Cells[2,0] := '차주 계획' + '(' + FormatDateTime('mm.dd', dt_begin.DateTime+7) +
      ' ~ ' + FormatDateTime('mm.dd', dt_end.DateTime+7) + ')';
    Cells[3,0] := '비 고';

    MergeCells(0,1,1,3);
    Cells[0,1] := #13#10 + #13#10 + '18H32V';

    ColWidths[1] := Length(Cells[0,1])*70;
    ColWidths[2] := Length(Cells[0,2])*70;
    ColWidths[3] := Length(Cells[0,3])*30;

    RowHeights[0] := RowHeights[0] * 3;

  //  AdvSG1.Alignments[0,2] := taCenter;
  end;
end;

procedure TweeklyProcessPlanF.FormCreate(Sender: TObject);
begin
  DM1.SetListFromDic(rg_team.Items, DM1.FTeamDic);
end;

procedure TweeklyProcessPlanF.rg_periodClick(Sender: TObject);
begin
  dt_begin.Enabled := False;
  dt_end.Enabled   := False;
  case rg_period.ItemIndex of
    0 :
    begin
      dt_begin.Date := Now;
      dt_end.Date   := Now;
    end;
    1 :
    begin
      dt_begin.Date := StartOfTheWeek(Now);
      dt_end.Date   := EndOfTheWeek(Now);
    end;
    2 :
    begin
      dt_begin.Date := StartOfTheMonth(Now);
      dt_end.Date   := EndOfTheMonth(Now);
    end;
    3 :
    begin
      dt_begin.Enabled := True;
      dt_end.Enabled   := True;
    end;
  end;
end;

end.
