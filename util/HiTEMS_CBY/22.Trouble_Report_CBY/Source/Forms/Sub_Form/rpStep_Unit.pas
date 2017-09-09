unit rpStep_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvOfficeStatusBar, Vcl.StdCtrls,
  Vcl.ExtCtrls, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, NxCollection;

type
  TrpStep_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    StepGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    Panel2: TPanel;
    Button2: TButton;
    Button1: TButton;
    Statusbar1: TAdvOfficeStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StepGridDblClick(Sender: TObject);
    procedure StepGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FFirst : Boolean;
    FxRow : Integer;
  public
    FOwner : TMain_Frm;
    { Public declarations }

    procedure Search_For_Action_Doc(FUserID:String);
  end;

var
  rpStep_Frm: TrpStep_Frm;

implementation

uses
  DataModule_Unit, Trouble_Unit;

{$R *.dfm}

procedure TrpStep_Frm.Button1Click(Sender: TObject);
begin
  if stepGrid.SelectedRow > -1 then
    StepGridDblClick(Self);

end;

procedure TrpStep_Frm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TrpStep_Frm.FormActivate(Sender: TObject);
begin
  if FFirst = True then
  begin
    FFirst := False;
    Search_For_Action_Doc(Statusbar1.Panels[4].Text);
  end;
end;

procedure TrpStep_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;


end;

procedure TrpStep_Frm.Search_For_Action_Doc(FUserID: String);
var
  LCodeID, LUserID : String;
  li,LC : integer;
  LStr : String;
begin
  StepGrid.ClearRows;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from Trouble_Data where EmpNo = :param1 and (FResult = 0 or FResult = 1)');
    parambyname('param1').AsString := FUserID;
    Open;

    if not(RecordCount =0) then
    begin
      with stepGrid do
      begin
        for lc := 0 to RecordCount-1 do
        begin
          AddRow(1);

          Cells[1,lc] := Fieldbyname('CODEID').AsString;
          Cells[2,lc] := Fieldbyname('EngType').AsString;
          Cells[3,lc] := Fieldbyname('TITLE').AsString;
          Cells[4,lc] := FormatDateTime('YYYY-MM-DD', Fieldbyname('InDate').AsDateTime);

          LStr := Fieldbyname('FResult').AsString;

          if not(LStr = '') then
          begin
            li := Fieldbyname('FResult').AsInteger;
            case li of
              0 : Cells[5,lc] := '미조치';
              1 : Cells[5,lc] := '조치입력중';
              2 : Cells[5,lc] := '조치완료';
            end;
          end;
          Next;
        end;
      end;
    end;
  end;
end;

procedure TrpStep_Frm.StepGridDblClick(Sender: TObject);
var
  LCodeId : String;
  LForm : TTrouble_Frm;
begin
  if not(stepGrid.RowCount = 0) then
  begin
    LCodeId := stepGrid.Cells[1,FxRow];
    try
      LForm := TTrouble_Frm.Create(self);
      with LForm do
      begin
        Caption := '문제점 보고서 승인 대기문서 조회';
        FOpenCase := 1; //0:신규문서 //1:저장된 문서
        FOwner := Self.FOwner;
        FRpCode := LCodeId;
        Statusbar1.Panels[0].Text := Self.Statusbar1.Panels[0].Text;
        Statusbar1.Panels[1].Text := Self.Statusbar1.Panels[1].Text;
        Statusbar1.Panels[2].Text := Self.Statusbar1.Panels[2].Text;
        Statusbar1.Panels[3].Text := Self.Statusbar1.Panels[3].Text;
        Statusbar1.Panels[4].Text := Self.Statusbar1.Panels[4].Text;
        ShowModal;
      end;
    finally
      Search_For_Action_Doc(Statusbar1.Panels[4].Text);
    end;
  end;
end;

procedure TrpStep_Frm.StepGridSelectCell(Sender: TObject; ACol, ARow: Integer);
begin
  FxRow := ARow;
end;

end.
