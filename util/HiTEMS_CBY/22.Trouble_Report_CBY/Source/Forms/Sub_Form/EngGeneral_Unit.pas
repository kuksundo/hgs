unit EngGeneral_Unit;

interface

uses
  Trouble_Unit, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AdvGroupBox, AdvOfficeButtons, Grids, AdvObj,
  BaseGrid, AdvGrid, NxCollection, Vcl.Menus, Vcl.ImgList;

type
  TEngGeneral_Frm = class(TForm)
    Panel2: TPanel;
    Button2: TButton;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    InfoGrid: TAdvStringGrid;
    RadioGroup1: TAdvOfficeRadioGroup;
    Button1: TButton;
    Imglist16x16: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure InfoGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure InfoGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
    FRow : integer;
  public
    { Public declarations }
    FOwner : TTrouble_Frm;
    procedure Engine_Genenal_Info_Show;
  end;

var
  EngGeneral_Frm: TEngGeneral_Frm;

implementation

uses
  himsenDesc_Unit,
  DataModule_Unit,
  CODE_Function,
  Main_Unit;

{$R *.dfm}

procedure TEngGeneral_Frm.Button1Click(Sender: TObject);
var
  lrow : integer;
  lprm : String;
begin
  try
    lrow := FRow;
    lprm := InfoGrid.Cells[2,lrow];
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select ENGPROJ, PROJNO, ENGTYPE, PROJNAME, SHIPNO, SITE, RPM, OWNER from HiTEMS.HIMSEN_INFO where ProjNo = :param1');
      parambyname('param1').AsString := lprm;
      Open;

      if not(RecordCount = 0) then
      begin
        with FOwner do
        begin
          TOWNER.Text  := Fieldbyname('OWNER').AsString;
          EngName.Text := Fieldbyname('EngProj').AsString;
          ProjNo.Text  := Fieldbyname('ProjNo').AsString;
          EngType.Text := Fieldbyname('EngType').AsString;
          ProjName.Text:= Fieldbyname('ProjName').AsString;
          ShipNo.Text  := Fieldbyname('ShipNo').AsString;
          Site.Text    := Fieldbyname('Site').AsString;
          RPM.Text     := Fieldbyname('RPM').AsString;
          ENGNUM.Text  := '1';
        end;
      end;
    end;
  finally
    Self.Close;
  end;
end;

procedure TEngGeneral_Frm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TEngGeneral_Frm.Engine_Genenal_Info_Show;
var
  li : integer;
  LStr : String;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select TEAM, PROJNO, PROJNAME, ENGMODEL, ENGTYPE, ENGPROJ from HITEMS.HIMSEN_INFO ');
    if RadioGroup1.ItemIndex <> 2 then
    begin
      SQL.Add('where STATUS = :param1');
      ParamByName('param1').AsInteger := RadioGroup1.ItemIndex;
    end;
    SQL.Add('order by PROJNO');

    Open;

    with InfoGrid do
    begin
      try
        AutoSize := False;

        if not(RecordCount = 0) then
          RowCount := RecordCount+1
        else
        begin
          RowCount := 2;
          ClearRows(1,1);
        end;

        for li := 0 to RecordCount -1 do
        begin
{          if Fieldbyname('TEAM').AsString = 'K2B3-1' then
            LStr := '시운전1반';
          if Fieldbyname('TEAM').AsString = 'K2B3-2' then
            LStr := '시운전2반';
          if Fieldbyname('TEAM').AsString = 'K2B3-3' then
            LStr := '시운전3반';
}
          LStr := TDeptUsers.Instance.GetDeptNameFromCode(Fieldbyname('TEAM').AsString);

          Cells[1,li+1] := LStr;
          Cells[2,li+1] := Fieldbyname('PROJNO').AsString;
          Cells[3,li+1] := Fieldbyname('PROJNAME').AsString;
          Cells[4,li+1] := Fieldbyname('ENGMODEL').AsString;
          Cells[5,li+1] := Fieldbyname('ENGTYPE').AsString;
          Cells[6,li+1] := Fieldbyname('ENGPROJ').AsString;
          Next;
        end;
      finally
        AutoSize := True;
      end;
    end;
  end;
end;

procedure TEngGeneral_Frm.FormCreate(Sender: TObject);
begin
  Engine_Genenal_Info_Show;
end;

procedure TEngGeneral_Frm.InfoGridDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  if ARow > 0 then
  begin
    Button1Click(Sender);
//    if Create_himsenDesc(InfoGrid.Cells[2,ARow]) then
//      Engine_Genenal_Info_Show;

  end;
end;

procedure TEngGeneral_Frm.InfoGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  FRow := ARow;
end;

procedure TEngGeneral_Frm.RadioGroup1Click(Sender: TObject);
begin
  Engine_Genenal_Info_Show;
end;

end.
