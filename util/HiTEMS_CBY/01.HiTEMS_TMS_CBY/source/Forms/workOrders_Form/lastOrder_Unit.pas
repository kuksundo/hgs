unit lastOrder_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AeroButtons,
  NxColumnClasses, NxColumns, JvExControls, JvLabel, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ImgList, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls;

type
  TlastOrder_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    JvLabel2: TJvLabel;
    grid_Orders: TNextGrid;
    NxTreeColumn2: TNxTreeColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    Panel1: TPanel;
    AeroButton3: TAeroButton;
    ImageList32x32: TImageList;
    JvLabel1: TJvLabel;
    ImageList16x16: TImageList;
    JvLabel3: TJvLabel;
    AeroButton1: TAeroButton;
    grid_List: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxImageColumn1: TNxImageColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    procedure AeroButton3Click(Sender: TObject);
    procedure grid_ListSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure grid_OrdersCustomDrawCell(Sender: TObject; ACol, ARow: Integer;
      CellRect: TRect; CellState: TCellState);
    procedure grid_ListCellDblClick(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
    FSelectedRow : Integer;
    function GetButtonRect(ARect:TRect;Level:Integer):TRect;
  public
    { Public declarations }
    procedure Get_LastOrders;
    procedure Get_Orders(aPlanNo,aPerform:String);
    function Get_AuthorizedForEdit(aPlanNo,aPerform,aUserId:String):Boolean;
  end;

var
  lastOrder_Frm: TlastOrder_Frm;
  function Create_lastOrder_Frm : String;

implementation
uses
  editOrder_Unit,
  HiTEMS_TMS_CONST,
  makeOrder_Unit,
  DataModule_Unit;

{$R *.dfm}

function Create_lastOrder_Frm : String;
var
  i : Integer;
begin
  Result := '';
  lastOrder_Frm := TlastOrder_Frm.Create(nil);
  try
    with lastOrder_Frm do
    begin
      Get_LastOrders;
      if grid_List.RowCount > 0 then
        Get_Orders(grid_List.Cells[4,0],grid_List.Cells[2,0]);//계획번호, 수행일

      ShowModal;

      if ModalResult = mrOk then
      begin
        with grid_List do
        begin
          BeginUpdate;
          try
            for i := 0 to RowCount-1 do
            begin
              if Cell[1,i].AsInteger = 1 then
              begin
                Result := Cells[2,i]+';'+Cells[4,i];
                Break;
              end;
            end;
          finally
            EndUpdate;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(lastOrder_Frm);
  end;
end;

{ TlastOrder_Frm }
procedure TlastOrder_Frm.AeroButton3Click(Sender: TObject);
begin
  Close;
end;

function TlastOrder_Frm.GetButtonRect(ARect: TRect; Level: Integer): TRect;
var
  m, t: Integer;
begin
  m := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
  t := m - 5;
  with Result do
  begin
    Left := Level * 19;
    Left := ARect.Left + Level * 19;
    Right := Left + 9;
    Top := ARect.Top;
    Bottom := Top + 3;
  end;
  OffsetRect(Result, 15, 3);
end;

procedure TlastOrder_Frm.Get_LastOrders;
var
  LRow : Integer;
begin
  with grid_List do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM ' +
                '( ' +
                '   SELECT * FROM ' +
                '   ( ' +
                '       SELECT PLAN_NO PN, PERFORM ' +
                '       FROM TMS_WORK_ORDERS GROUP BY PLAN_NO, PERFORM ' +
                '   ) A LEFT OUTER JOIN ' +
                '   ( ' +
                '       SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN ' +
                '       FROM TMS_PLAN GROUP BY PLAN_NO ' +
                '   ) B ' +
                '   ON A.PN = B.PLAN_NO ' +
                ') A LEFT OUTER JOIN ' +
                '( ' +
                '   SELECT PLAN_NO, PLAN_REV_NO, PLAN_NAME FROM TMS_PLAN ' +
                ') B ' +
                'ON A.PN = B.PLAN_NO ' +
                'AND A.PRN = B.PLAN_REV_NO ' +
                'ORDER BY PERFORM DESC, PLAN_NAME ');
        Open;

        while not eof do
        begin
          LRow := AddRow;
          if RowCount = 1 then
            Cell[1,LRow].AsInteger := 1
          else
            Cell[1,LRow].AsInteger := 0;

          Cell[2,LRow].AsString := FormatDateTime('YYYY-MM-DD',FieldByName('PERFORM').AsDateTime);
          Cell[3,LRow].AsString := FieldByName('PLAN_NAME').AsString;
          Cell[4,LRow].AsString := FieldByName('PLAN_NO').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TlastOrder_Frm.Get_AuthorizedForEdit(aPlanNo, aPerform, aUserId: String): Boolean;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT DRAFTER FROM TMS_WORK_ORDERS ' +
            'WHERE PLAN_NO LIKE :param1 ' +
            'AND DRAFTER LIKE :param2 ' +
            'AND PERFORM = :param3 ');

    ParamByName('param1').AsString := aPlanNo;
    ParamByName('param2').AsString := aUserId;
    ParamByName('param3').AsDate   := StrToDate(aPerform);
    Open;

    if RecordCount <> 0 then
      Result := True
    else
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT WORK_DEL FROM TMS_AUTHORITY ' +
              'WHERE USERID LIKE :param1 ');
      ParamByName('param1').AsString := aUserId;
      Open;

      if RecordCount <> 0 then
      begin
        if FieldByName('WORK_DEL').AsInteger = 1 then
          Result := True;


      end;
    end;
  end;
end;

procedure TlastOrder_Frm.Get_Orders(aPlanNo,aPerform:String);
var
  i,
  LRow : Integer;

begin
  with grid_orders do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.*, B.CODE_NAME FROM ' +
                '( ' +
                '   SELECT * FROM TMS_WORK_ORDERS ' +
                ') A, ' +
                '( ' +
                '   SELECT CAT_NO, CAT_NAME CODE_NAME FROM TMS_WORK_CATEGORY UNION ALL ' +
                '   SELECT GRP_NO, CODE_NAME FROM TMS_WORK_CODEGRP ' +
                ') B ' +
                'WHERE A.CODE = B.CAT_NO ' +
                'AND PLAN_NO = :param1  ' +
                'AND PERFORM = :param2  ' +
                'ORDER BY SEQ_NO ');

        ParamByName('param1').AsString  := aPlanNo;
        ParamByName('param2').AsDate    := StrToDateTime(aPerform);
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            if RowCount = 0 then
              LRow := AddRow
            else
            begin
              if FieldByName('PARENT_NO').AsString <> '' then
              begin
                LRow := -1;
                for i := 0 to RowCount-1 do
                begin
                  if Cells[6,i] = FieldByName('PARENT_NO').AsString then
                  begin
                    AddChildRow(i,crLast);
                    LRow := LastAddedRow;
                    Break;
                  end;
                end;

                if LRow = -1 then
                  LRow := AddRow;
              end else
                LRow := AddRow;

            end;

            Cells[0,LRow] := FieldByName('CODE_NAME').AsString;
            Cells[1,LRow] := FieldByName('CODE').AsString;
            Cell[2,LRow].Clear;
            Cells[3,LRow] := FieldByName('CODE_TYPE').AsString;
            // Cells[4,LRow] := 자동정렬
            Cells[5,LRow] := FieldByName('PARENT_NO').AsString;
            Cells[6,LRow] := FieldByName('ORDER_NO').AsString;
            Cells[7,LRow] := FieldByName('PLAN_NO').AsString;
            Cells[8,LRow] := FieldByName('STATUS').AsString;
//            Cells[9,LRow] := FieldByName('STATUS').AsString;

            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TlastOrder_Frm.grid_ListCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  with grid_List do
  begin
    if Get_AuthorizedForEdit(Cells[4,ARow],Cells[2,ARow],DM1.FUserInfo.CurrentUsers) then
    begin
      if Create_editOrder_Frm(Cells[4,ARow],Cells[3,ARow],Cells[2,ARow]) then
        Get_LastOrders;

    end;
  end;
end;

procedure TlastOrder_Frm.grid_ListSelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  i : Integer;
begin
  with grid_List do
  begin
    BeginUpdate;
    try
      if ARow = -1 then
        Exit;


      for i := 0 to RowCount-1 do
        Cell[1,i].AsInteger := 0;

      if Cell[1,ARow].AsInteger = 0 then
        Cell[1,ARow].AsInteger := 1
      else
        Cell[1,ARow].AsInteger := 0;


      Get_Orders(Cells[4,ARow],Cells[2,ARow]);//계획번호, 수행일

    finally
      EndUpdate;
    end;
  end;
end;

procedure TlastOrder_Frm.grid_OrdersCustomDrawCell(Sender: TObject; ACol,
  ARow: Integer; CellRect: TRect; CellState: TCellState);
var
  s : String;
  LRect : TRect;
  LCanvas : TCanvas;
  bmp : TBitmap;
begin
  with Sender as TNextGrid do
  begin
    if ACol = 0 then
    begin
      LRect := GetButtonRect(CellRect,GetLevel(ARow));
      s := Cells[0,ARow];
      LCanvas := Canvas;
      LCanvas.FillRect(LRect);

      bmp := TBitmap.Create;
      try
        if Cells[3,ARow] = 'C' then
          ImageList16x16.GetBitmap(5,bmp)
        else
          ImageList16x16.GetBitmap(4,bmp);

        if bmp <> nil then
          LCanvas.Draw(LRect.Left, LRect.Top, bmp);

      finally
        bmp.Free;
      end;
    end;
  end;
end;


end.
