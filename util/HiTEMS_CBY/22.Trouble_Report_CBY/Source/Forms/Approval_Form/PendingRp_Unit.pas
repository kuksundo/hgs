unit PendingRp_Unit;

interface

uses
  Main_Unit, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvOfficeStatusBar, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, NxCollection, ActnMan,
  Jpeg,StdCtrls, ComCtrls, Menus, Vcl.ImgList, Vcl.ExtCtrls;

type
  TPendingRp_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    PendingTable: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    Panel2: TPanel;
    Button2: TButton;
    Button1: TButton;
    Imglist16x16: TImageList;
    Statusbar1: TAdvOfficeStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PendingTableSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure PendingTableDblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FOwner : TMain_Frm;
    FFirst : Boolean;
    FxRow, FxCol : integer;

    procedure PendingData_Insert_To_Table;
  end;

var
  PendingRp_Frm: TPendingRp_Frm;

implementation

uses
  DataModule_Unit, Trouble_Unit;

{$R *.dfm}

{ TForm1 }

procedure TPendingRp_Frm.PendingData_Insert_To_Table;
var
  li : integer;
  LCCount : integer;
  LPending : integer;
  LApproval : String;
  LN : integer;
  LNext : String;

begin
  PendingTable.ClearRows;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select distinct A.*, B.Pending,B.Status, C.Title, C.ENGTYPE, C.Indate from ZHITEMS_APPROVER A, ZHITEMS_APPROVEP B, Trouble_DataTemp C');
    SQL.Add('where A.CODEID = B.CODEID and A.CODEID = C.CODEID and A.FLAG = ''P01TR'' order by C.Indate');
    Open;

    if RecordCount = 0 then Exit;

    for li := 0 to RecordCount-1 do
    begin
      if FieldByName('Status').AsInteger = 1 then
      begin
        LCCount := FieldByName('ACount').AsInteger;
        LPending := FieldByName('Pending').AsInteger;
        LPending := LPending+1;

        if not(LPending > LCCount) then
        begin
          //다음 결재자 사번 가져오기
          LApproval := Fields[2+Lpending].AsString;
          //다음 결재자가 현재 사용자 이면
          if LApproval = FOwner.Statusbar1.Panels[4].Text then
          begin
            with PendingTable do
            begin
              AddRow(1);
              Cells[1,RowCount-1] := FieldByName('CODEID').AsString;
              Cells[2,RowCount-1] := FieldByName('ENGTYPE').AsString;
              Cells[3,RowCount-1] := FieldByName('Title').AsString;
              Cells[4,RowCount-1] := FormatDateTime('YYYY-MM-DD',FieldByNAme('Indate').AsDateTime);

              LN := LPending+1;
              LNext := Fields[2+LN].AsString;

              if not(LN > LCCount) then
              begin
                with DM1.TQuery2 do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('Select Name_Kor from User_Info where USERID = :param1');
                  parambyname('param1').AsString := LNext;
                  Open;

                  Cells[5,RowCount-1] := Fieldbyname('name_kor').AsString;
                end;
              end
              else
                Cells[5,RowCount-1] := '결재완료';
            end;
          end;
        end;
      end;
      Next;
    end;
  end;
end;

procedure TPendingRp_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;
end;

procedure TPendingRp_Frm.Button1Click(Sender: TObject);
begin
  PendingTableDblClick(self);
end;

procedure TPendingRp_Frm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TPendingRp_Frm.FormActivate(Sender: TObject);
begin
  if FFirst = True then
  begin
    PendingData_Insert_To_Table;
    FFirst := False;
  end;
end;



procedure TPendingRp_Frm.PendingTableDblClick(Sender: TObject);
var
  LCodeId : String;
  LForm : TTrouble_Frm;
begin
  if not(PendingTable.RowCount = 0) then
  begin
    LCodeId := PendingTable.Cells[1,FxRow];
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
      PendingData_Insert_To_Table;
    end;
  end;
end;

procedure TPendingRp_Frm.PendingTableSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  FxCol := ACol;
  FxRow := ARow;

end;

end.
