unit EngineOverView2_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvScrollBox, Vcl.Grids,
  Vcl.ExtCtrls, Vcl.StdCtrls, AdvCircularProgress,
  //Vcl.ExtCtrls, AdvCircularProgress, Vcl.StdCtrls, VCLTee.TeCanvas,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ColorGrd, AdvObj, BaseGrid, AdvGrid, JvExControls,
  JvLabel, System.DateUtils, Vcl.ImgList, Vcl.Imaging.pngimage, VCLTee.TeCanvas, System.StrUtils,
  ShadowButton;

type
  TEngineOverView2_Frm = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    Timer15: TTimer;
    AdvScrollBox1: TAdvScrollBox;
    AdvCircularProgress1: TAdvCircularProgress;
    ShadowButton8: TShadowButton;
    AdvCircularProgress2: TAdvCircularProgress;
    ShadowButton1: TShadowButton;
    AdvCircularProgress3: TAdvCircularProgress;
    ShadowButton2: TShadowButton;
    AdvCircularProgress4: TAdvCircularProgress;
    ShadowButton3: TShadowButton;
    AdvCircularProgress5: TAdvCircularProgress;
    ShadowButton4: TShadowButton;
    AdvCircularProgress6: TAdvCircularProgress;
    ShadowButton5: TShadowButton;
    AdvCircularProgress7: TAdvCircularProgress;
    ShadowButton6: TShadowButton;
    Panel5: TPanel;
    Label1: TLabel;
    Panel7: TPanel;
    grid_orders: TAdvStringGrid;
    Bevel1: TBevel;
    Panel93: TPanel;
    Panel12: TPanel;
    Panel11: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    Panel13: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel10: TPanel;
    Panel94: TPanel;
    Label9: TLabel;
    Panel95: TPanel;
    Panel96: TPanel;
    Panel97: TPanel;
    Panel98: TPanel;
    Panel99: TPanel;
    Panel100: TPanel;
    Panel101: TPanel;
    Panel102: TPanel;
    Panel103: TPanel;
    Panel104: TPanel;
    Panel105: TPanel;
    Panel106: TPanel;
    Panel3: TPanel;
    Label2: TLabel;
    Panel9: TPanel;
    Panel14: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel30: TPanel;
    Label3: TLabel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel37: TPanel;
    Panel38: TPanel;
    Panel39: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    Panel109: TPanel;
    Panel110: TPanel;
    Label10: TLabel;
    Panel111: TPanel;
    Panel112: TPanel;
    Panel113: TPanel;
    Panel114: TPanel;
    Panel115: TPanel;
    Panel116: TPanel;
    Panel117: TPanel;
    Panel118: TPanel;
    Panel119: TPanel;
    Panel120: TPanel;
    Panel121: TPanel;
    Panel122: TPanel;
    Panel27: TPanel;
    Label4: TLabel;
    Panel28: TPanel;
    Panel42: TPanel;
    Panel43: TPanel;
    Panel44: TPanel;
    Panel45: TPanel;
    Panel46: TPanel;
    Panel47: TPanel;
    Panel48: TPanel;
    Panel49: TPanel;
    Panel50: TPanel;
    Panel51: TPanel;
    Panel52: TPanel;
    Panel53: TPanel;
    Label5: TLabel;
    Panel54: TPanel;
    Panel55: TPanel;
    Panel56: TPanel;
    Panel57: TPanel;
    Panel58: TPanel;
    Panel59: TPanel;
    Panel60: TPanel;
    Panel61: TPanel;
    Panel62: TPanel;
    Panel63: TPanel;
    Panel64: TPanel;
    Panel65: TPanel;
    Label6: TLabel;
    Bevel5: TBevel;
    Panel89: TPanel;
    Timer5: TTimer;
    Timer6: TTimer;
    Label7: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    grid_orders2: TAdvStringGrid;
    grid_orders3: TAdvStringGrid;
    grid_orders4: TAdvStringGrid;
    grid_orders5: TAdvStringGrid;
    grid_orders6: TAdvStringGrid;
    grid_orders7: TAdvStringGrid;
    Timer3: TTimer;
    Timer4: TTimer;
    Timer7: TTimer;
    Label16: TLabel;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    Edit1: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Edit2: TEdit;
    Label20: TLabel;
    Edit3: TEdit;
    Label21: TLabel;
    Label22: TLabel;
    Edit4: TEdit;
    Label23: TLabel;
    Label24: TLabel;
    Edit5: TEdit;
    Label25: TLabel;
    Label26: TLabel;
    Edit6: TEdit;
    Label27: TLabel;
    Label28: TLabel;
    Edit7: TEdit;
    Label29: TLabel;
    Label30: TLabel;
    procedure ShadowButton1Click(Sender: TObject);
    procedure AdvCircularProgress1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer15Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
    procedure Timer6Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer7Timer(Sender: TObject);
  private
    procedure Set_Status_18H3240_Of_Grid(aStatus:String;aRow:Integer);
    procedure Set_Status_6H1728_Of_Grid(aStatus:String;aRow:Integer);
    procedure Set_Status_18H2533_Of_Grid(aStatus:String;aRow:Integer);
    procedure Set_Status_20H3240_Of_Grid(aStatus:String;aRow:Integer);
    { Private declarations }
  public
    { Public declarations }
    procedure Get_WorkOrders(aPlanNo:String;aRevNo:Integer);
    procedure Get_EngineType(aENGTYPE:String);
  end;

implementation

uses DataModule_Unit;

{$R *.dfm}

procedure TEngineOverView2_Frm.AdvCircularProgress1Click(Sender: TObject);
begin
  if Sender is TAdvCircularProgress then
  begin
    if TAdvCircularProgress(Sender).Enabled = False then
      begin
      TAdvCircularProgress(Sender).Enabled := True
      end
    else
      TAdvCircularProgress(Sender).Enabled := False;
  end;
end;

procedure TEngineOverView2_Frm.FormActivate(Sender: TObject);
var
  i : integer;
//begin
//  for i := 0 to 6 do
//  begin
//    with TAdvStringGrid(FindComponent('grid_orders'+IntToStr(i+1))) do
begin
  for i := 0 to grid_orders.RowCount-1 do
  begin
    grid_orders.Alignments[0,i] := taCenter;
    grid_orders.Alignments[1,i] := taCenter;
    grid_orders.VAlignment := vtaCenter;
    grid_orders2.Alignments[0,i] := taCenter;
    grid_orders2.Alignments[1,i] := taCenter;
    grid_orders2.VAlignment := vtaCenter;
    grid_orders3.Alignments[0,i] := taCenter;
    grid_orders3.Alignments[1,i] := taCenter;
    grid_orders3.VAlignment := vtaCenter;
    grid_orders4.Alignments[0,i] := taCenter;
    grid_orders4.Alignments[1,i] := taCenter;
    grid_orders4.VAlignment := vtaCenter;
    grid_orders5.Alignments[0,i] := taCenter;
    grid_orders5.Alignments[1,i] := taCenter;
    grid_orders5.VAlignment := vtaCenter;
    grid_orders6.Alignments[0,i] := taCenter;
    grid_orders6.Alignments[1,i] := taCenter;
    grid_orders6.VAlignment := vtaCenter;
    grid_orders7.Alignments[0,i] := taCenter;
    grid_orders7.Alignments[1,i] := taCenter;
    grid_orders7.VAlignment := vtaCenter;
    edit1.Alignment := taCenter;
    edit2.Alignment := taCenter;
    edit6.Alignment := taCenter;
    edit7.Alignment := taCenter;
  end;

  grid_orders.ColWidths[0] := 100;
  grid_orders.ColWidths[1] := 260;
  grid_orders2.ColWidths[0] := 100;
  grid_orders2.ColWidths[1] := 260;
  grid_orders3.ColWidths[0] := 100;
  grid_orders3.ColWidths[1] := 260;
  grid_orders4.ColWidths[0] := 100;
  grid_orders4.ColWidths[1] := 260;
  grid_orders5.ColWidths[0] := 100;
  grid_orders5.ColWidths[1] := 260;
  grid_orders6.ColWidths[0] := 100;
  grid_orders6.ColWidths[1] := 260;
  grid_orders7.ColWidths[0] := 100;
  grid_orders7.ColWidths[1] := 260;
end;

procedure TEngineOverView2_Frm.Get_EngineType(aENGTYPE: String);
begin

end;

procedure TEngineOverView2_Frm.Get_WorkOrders(aPlanNo: String; aRevNo: Integer);
begin

end;

procedure TEngineOverView2_Frm.Set_Status_18H2533_Of_Grid(aStatus: String;
  aRow: Integer);
var
  i : Integer;
begin
  with DM1.OraQuery2 do
  begin
    with grid_orders do
    begin
      BeginUpdate;
      try
        if aStatus = '진행' then
        begin
          Colors[0,ARow] := clSkyBlue;
          Colors[1,ARow] := clSkyBlue;
          Colors[2,ARow] := clSkyBlue;  ;
        end else
        if aStatus = '완료' then
        begin
          Colors[0,ARow] := clMoneyGreen;
          Colors[1,ARow] := clMoneyGreen;
          Colors[2,ARow] := clMoneyGreen;
        end else
        if aStatus = '중지' then
        begin
          Colors[0,ARow] := $0071B8FF;
          Colors[1,ARow] := $0071B8FF;
          Colors[2,ARow] := $0071B8FF;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TEngineOverView2_Frm.Set_Status_20H3240_Of_Grid(aStatus: String;
  aRow: Integer);
var
  i : Integer;
begin
  with DM1.OraQuery2 do
  begin
    with grid_orders7 do
    begin
      BeginUpdate;
      try
        if aStatus = '진행' then
        begin
          Colors[0,ARow] := clSkyBlue;
          Colors[1,ARow] := clSkyBlue;
          Colors[2,ARow] := clSkyBlue;  ;
        end else
        if aStatus = '완료' then
        begin
          Colors[0,ARow] := clMoneyGreen;
          Colors[1,ARow] := clMoneyGreen;
          Colors[2,ARow] := clMoneyGreen;
        end else
        if aStatus = '중지' then
        begin
          Colors[0,ARow] := $0071B8FF;
          Colors[1,ARow] := $0071B8FF;
          Colors[2,ARow] := $0071B8FF;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TEngineOverView2_Frm.Set_Status_6H1728_Of_Grid(aStatus: String;
  aRow: Integer);
var
  i, le : Integer;
begin
  with DM1.OraQuery2 do
  begin
    with grid_orders2 do
    begin
      BeginUpdate;
      try
        if aStatus = '진행' then
        begin
          Colors[0,ARow] := clSkyBlue;
          Colors[1,ARow] := clSkyBlue;
          Colors[2,ARow] := clSkyBlue;  ;
        end else
        if aStatus = '완료' then
        begin
          Colors[0,ARow] := clMoneyGreen;
          Colors[1,ARow] := clMoneyGreen;
          Colors[2,ARow] := clMoneyGreen;
        end else
        if aStatus = '중지' then
        begin
          Colors[0,ARow] := $0071B8FF;
          Colors[1,ARow] := $0071B8FF;
          Colors[2,ARow] := $0071B8FF;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TEngineOverView2_Frm.Set_Status_18H3240_Of_Grid(aStatus: String;
  aRow: Integer);
var
  i : Integer;
begin
  with DM1.OraQuery2 do
  begin
    with grid_orders6 do
    begin
      BeginUpdate;
      try
        if aStatus = '진행' then
        begin
          Colors[0,ARow] := clSkyBlue;
          Colors[1,ARow] := clSkyBlue;
          Colors[2,ARow] := clSkyBlue;  ;
        end else
        if aStatus = '완료' then
        begin
          Colors[0,ARow] := clMoneyGreen;
          Colors[1,ARow] := clMoneyGreen;
          Colors[2,ARow] := clMoneyGreen;
        end else
        if aStatus = '중지' then
        begin
          Colors[0,ARow] := $0071B8FF;
          Colors[1,ARow] := $0071B8FF;
          Colors[2,ARow] := $0071B8FF;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TEngineOverView2_Frm.ShadowButton1Click(Sender: TObject);
begin
  if Sender is TShadowButton then
  begin
    if TShadowButton(Sender).Color = clLime then
      TShadowButton(Sender).Color := clRed
    else
      TShadowButton(Sender).Color := clLime;
  end;
  if Sender is TShadowButton then
  {begin
    if TShadowButton(Sender).Caption <> '' then
      TShadowButton(Sender).Color := clRed
    else
      TShadowButton(Sender).Color := clLime;
  end;}
end;

procedure TEngineOverView2_Frm.Timer15Timer(Sender: TObject);
var
  Li,le,LRow,i: integer;
  lstr : String;
begin
  Timer15.Enabled := False;

  with DM1.OraQuery2 do
  begin
    close;
    SQL.clear;
    SQL.Add('SELECT * FROM ' +
            '( ' +
            '   SELECT * FROM ' +
            '   ( ' +
            '       SELECT A.PLAN_NO, PRN, PLAN_NAME,PLAN_START, PLAN_END, ENG_MODEL, ENG_TYPE, ENG_PROJNO FROM ' +
            '       ( ' +
            '           SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN ' +
            '           GROUP BY PLAN_NO ' +
            '       ) A LEFT OUTER JOIN TMS_PLAN B ' +
            '       ON A.PLAN_NO = B.PLAN_NO ' +
            '       AND A.PRN = B.PLAN_REV_NO ' +
            '   ) A LEFT OUTER JOIN ' +
            '   ( ' +
                   '       SELECT PLAN_NO PN, PERFORM, CODE_NAME, A.STATUS, A.SEQ_NO, ACT_START, ACT_STOP FROM TMS_WORK_ORDERS A, TMS_WORK_CODEGRP B, TMS_WORK_RESULT C ' +
            '       WHERE A.CODE = B.GRP_NO ' +
            '       AND A.ORDER_NO = C.ORDER_NO ' +
            '   ) B ' +
            '   ON A.PLAN_NO = B.PN ' +
            '   ORDER BY SEQ_NO ' +
            ') ' +
            'WHERE PERFORM = :day ' +
            'AND ENG_PROJNO LIKE ''BF1562'' ');

            ParamByName('day').AsDate := Today;

            open;

    with grid_orders6 do
    begin
      ColWidths[2] := 0;
      RowCount := RecordCount+1;
      try
        for le := 0 to recordCount-1 do
        begin
          grid_orders6.Cells[1,le+1] := FieldByName('CODE_NAME').AsString;
          grid_orders6.Cells[2,le+1] := FieldByName('STATUS').AsString;
          Set_Status_18H3240_Of_Grid(FieldByName('STATUS').AsString, le+1);

          if grid_orders6.Cells[2,le+1] <> ' ' then
          begin
            if grid_orders6.Cells[2,le+1] = '대기' then
              grid_orders6.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_START').asDateTime);

            if grid_orders6.Cells[2,le+1] = '진행' then
              grid_orders6.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_START').asDateTime);

            if grid_orders6.Cells[2,le+1] = '완료' then
              grid_orders6.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_STOP').asDateTime);

            if grid_orders6.Cells[2,le+1] = '중지' then
              grid_orders6.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_STOP').asDateTime);
          end;

          DM1.OraQuery2.Next;
          edit6.Text := (IntToStr(grid_orders6.RowCount-1));
        end;
      finally
        for le := 0 to RowCount-1 do
        begin
          if Cells[1,le+1] = '진행' then
          begin
            ScrollInView(0,le+1);
            Break;
          end;
        end;
      end;
    end;
  end;
end;

procedure TEngineOverView2_Frm.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.clear;
      SQL.add('SELECT DATASAVEDTIME, DATA27, DATA249 FROM TBACS.YE0594_18H2533V_MEASURE_DATA ' +
              'WHERE DATASAVEDTIME LIKE :param1 ');

      ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-5));
      Open;

      Shadowbutton8.Caption := FieldByName('DATA27').AsString;
      Panel2.Caption := FieldByName('DATA249').AsString+' kW';
    end;
  finally
    timer1.Enabled := True;
    AdvCircularProgress1.Enabled := Shadowbutton8.Caption <> '';

    if AdvCircularProgress1.Enabled = True then
     ShadowButton8.Color := clLime
    else
       ShadowButton8.Color := clSilver;

    if ShadowButton8.Caption = '' then
      AdvCircularProgress1.Position := 0;
  end;
end;

procedure TEngineOverView2_Frm.Timer2Timer(Sender: TObject);
begin
  timer2.Enabled := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.clear;
      SQL.add('SELECT DATASAVEDTIME, DATA27,DATA199  FROM TBACS.YE0539_6H1728U_MEASURE_DATA ' +
              'WHERE DATASAVEDTIME LIKE :param1 ');

      ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-5));
      Open;

      Shadowbutton1.Caption := FieldByName('DATA27').AsString;
      Panel99.Caption := FieldByName('DATA199').AsString+' kW';
    end;
  finally
    timer2.Enabled := True;
    AdvCircularProgress2.Enabled := Shadowbutton1.Caption <> '';

    if AdvCircularProgress2.Enabled = True then
      ShadowButton1.Color := clLime
    else
      ShadowButton1.Color := clSilver;
    if ShadowButton1.Caption = '' then
      AdvCircularProgress2.Position := 0;
  end;
end;

procedure TEngineOverView2_Frm.Timer3Timer(Sender: TObject);
var
  Li,le,LRow: integer;
  lstr : String;
begin
  Timer3.Enabled := False;

  with DM1.OraQuery2 do
  begin
    close;
    SQL.clear;
    SQL.Add('SELECT * FROM ' +
            '( ' +
            '   SELECT * FROM ' +
            '   ( ' +
            '       SELECT A.PLAN_NO, PRN, PLAN_NAME,PLAN_START, PLAN_END, ENG_MODEL, ENG_TYPE, ENG_PROJNO FROM ' +
            '       ( ' +
            '           SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN ' +
            '           GROUP BY PLAN_NO ' +
            '       ) A LEFT OUTER JOIN TMS_PLAN B ' +
            '       ON A.PLAN_NO = B.PLAN_NO ' +
            '       AND A.PRN = B.PLAN_REV_NO ' +
            '   ) A LEFT OUTER JOIN ' +
            '   ( ' +
            '       SELECT PLAN_NO PN, PERFORM, CODE_NAME, A.STATUS, A.SEQ_NO, ACT_START, ACT_STOP FROM TMS_WORK_ORDERS A, TMS_WORK_CODEGRP B, TMS_WORK_RESULT C ' +
            '       WHERE A.CODE = B.GRP_NO ' +
            '       AND A.ORDER_NO = C.ORDER_NO ' +
            '   ) B ' +
            '   ON A.PLAN_NO = B.PN ' +
            '   ORDER BY SEQ_NO ' +
            ') ' +
            'WHERE PERFORM = :day ' +
            'AND ENG_PROJNO LIKE ''BF1656'' ');

    ParamByName('day').AsDate := Today;

    open;

    with grid_orders7 do
    begin
      ColWidths[2] := 0;
      RowCount := RecordCount+1;
      try
        for le := 0 to recordCount-1 do
        begin
          grid_orders7.Cells[1,le+1] := FieldByName('CODE_NAME').AsString;
          grid_orders7.Cells[2,le+1] := FieldByName('STATUS').AsString;
          Set_Status_20H3240_Of_Grid(FieldByName('STATUS').AsString, le+1);

          if grid_orders7.Cells[2,le+1] <> ' ' then
          begin
            if grid_orders7.Cells[2,le+1] = '대기' then
              grid_orders7.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_START').asDateTime);

            if grid_orders7.Cells[2,le+1] = '진행' then
              grid_orders7.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_START').asDateTime);

            if grid_orders7.Cells[2,le+1] = '완료' then
              grid_orders7.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_STOP').asDateTime);

            if grid_orders7.Cells[2,le+1] = '중지' then
              grid_orders7.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_STOP').asDateTime);
          end;

          DM1.OraQuery2.Next;
          edit7.Text := (IntToStr(grid_orders7.RowCount-1));
        end;
      finally
      for le := 0 to RowCount-1 do
        begin
          if Cells[1,le+1] = '진행' then
          begin
            ScrollInView(0,le+1);
            Break;
          end;
        end;
      end;
    end;
  end;
end;

procedure TEngineOverView2_Frm.Timer4Timer(Sender: TObject);
var
  Li,le,LRow: integer;
  lstr : String;
begin
  Timer4.Enabled := False;

  with DM1.OraQuery2 do
  begin
    close;
    SQL.clear;
    SQL.Add('SELECT * FROM ' +
            '( ' +
            '   SELECT * FROM ' +
            '   ( ' +
            '       SELECT A.PLAN_NO, PRN, PLAN_NAME,PLAN_START, PLAN_END, ENG_MODEL, ENG_TYPE, ENG_PROJNO FROM ' +
            '       ( ' +
            '           SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN ' +
            '           GROUP BY PLAN_NO ' +
            '       ) A LEFT OUTER JOIN TMS_PLAN B ' +
            '       ON A.PLAN_NO = B.PLAN_NO ' +
            '       AND A.PRN = B.PLAN_REV_NO ' +
            '   ) A LEFT OUTER JOIN ' +
            '   ( ' +
            '       SELECT PLAN_NO PN, PERFORM, CODE_NAME, A.STATUS, A.SEQ_NO, ACT_START, ACT_STOP FROM TMS_WORK_ORDERS A, TMS_WORK_CODEGRP B, TMS_WORK_RESULT C ' +
            '       WHERE A.CODE = B.GRP_NO ' +
            '       AND A.ORDER_NO = C.ORDER_NO ' +
            '   ) B ' +
            '   ON A.PLAN_NO = B.PN ' +
            '   ORDER BY SEQ_NO ' +
            ') ' +
            'WHERE PERFORM = :day ' +
            'AND ENG_PROJNO LIKE ''YE0594'' ');

    ParamByName('day').AsDate := Today;

    open;

    with grid_orders do
    begin
      ColWidths[2] := 0;
      RowCount := RecordCount+1;

      try
        for le := 0 to recordCount-1 do
        begin
          grid_orders.Cells[1,le+1] := FieldByName('CODE_NAME').AsString;
          grid_orders.Cells[2,le+1] := FieldByName('STATUS').AsString;
          Set_Status_18H2533_Of_Grid(FieldByName('STATUS').AsString, le+1);

          if grid_orders.Cells[2,le+1] <> ' ' then
          begin
            if grid_orders.Cells[2,le+1] = '대기' then
              grid_orders.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_START').asDateTime);

            if grid_orders.Cells[2,le+1] = '진행' then
              grid_orders.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_START').asDateTime);

            if grid_orders.Cells[2,le+1] = '완료' then
              grid_orders.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_STOP').asDateTime);

            if grid_orders.Cells[2,le+1] = '중지' then
              grid_orders.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_STOP').asDateTime);
          end;

          DM1.OraQuery2.Next;
          edit1.Text := (IntToStr(grid_orders.RowCount-1));
        end;
      finally
      for le := 0 to RowCount-1 do
      begin
        if Cells[1,le+1] = '진행' then
        begin
          ScrollInView(0,le+1);
          Break;
        end;
      end;
      end;
    end;
  end;
end;

procedure TEngineOverView2_Frm.Timer5Timer(Sender: TObject);
begin
  timer5.Enabled := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.clear;
      SQL.add('SELECT DATASAVEDTIME, DATA51, DATA149 FROM TBACS.BF1562_18H3240V_MEASURE_DATA ' +
              'WHERE DATASAVEDTIME LIKE :param1 ');

      ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-5));
      Open;

      Shadowbutton5.Caption:= FieldByName('DATA51').AsString;
      Panel45.Caption := FieldByName('DATA149').AsString +' kW';
    end;

  finally
    timer5.Enabled := True;
    AdvCircularProgress6.Enabled := Shadowbutton5.Caption <> '';

    if AdvCircularProgress6.Enabled = True then
      ShadowButton5.Color := clLime
    else
      ShadowButton5.Color := clSilver ;

    if ShadowButton5.Caption = '' then
      AdvCircularProgress6.Position := 0;
  end;
end;

procedure TEngineOverView2_Frm.Timer6Timer(Sender: TObject);
begin
  timer6.Enabled := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.clear;
      SQL.add('SELECT DATASAVEDTIME, DATA51, DATA149 FROM TBACS.BF1656_20H3240V_MEASURE_DATA ' +
              'WHERE DATASAVEDTIME LIKE :param1 ');

      ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-5));
      Open;

      Shadowbutton6.Caption := FieldByName('DATA51').AsString;
      Panel58.Caption := FieldByName('DATA149').AsString;
    end;

  finally
    timer6.Enabled := True;
    AdvCircularProgress7.Enabled := Shadowbutton6.Caption <> '';

    if AdvCircularProgress7.Enabled = True then
      ShadowButton6.Color := clLime
    else
      ShadowButton6.Color := clSilver;

    if ShadowButton6.Caption = '' then
      AdvCircularProgress6.Position := 0;
  end;
end;

procedure TEngineOverView2_Frm.Timer7Timer(Sender: TObject);
var
  Li,le,LRow,ARow: integer;
  lstr : String;
begin
  Timer7.Enabled := False;

  with DM1.OraQuery2 do
  begin
    close;
    SQL.clear;
    SQL.Add('SELECT * FROM ' +
            '( ' +
            '   SELECT * FROM ' +
            '   ( ' +
            '       SELECT A.PLAN_NO, PRN, PLAN_NAME,PLAN_START, PLAN_END, ENG_MODEL, ENG_TYPE, ENG_PROJNO FROM ' +
            '       ( ' +
            '           SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN ' +
            '           GROUP BY PLAN_NO ' +
            '       ) A LEFT OUTER JOIN TMS_PLAN B ' +
            '       ON A.PLAN_NO = B.PLAN_NO ' +
            '       AND A.PRN = B.PLAN_REV_NO ' +
            '   ) A LEFT OUTER JOIN ' +
            '   ( ' +
            '       SELECT PLAN_NO PN, PERFORM, CODE_NAME, A.STATUS, A.SEQ_NO, ACT_START, ACT_STOP FROM TMS_WORK_ORDERS A, TMS_WORK_CODEGRP B, TMS_WORK_RESULT C ' +
            '       WHERE A.CODE = B.GRP_NO ' +
            '       AND A.ORDER_NO = C.ORDER_NO ' +
            '   ) B ' +
            '   ON A.PLAN_NO = B.PN ' +
            '   ORDER BY SEQ_NO ' +
            ') ' +
            'WHERE PERFORM = :day ' +
            'AND ENG_PROJNO LIKE ''YE0539'' ');

    ParamByName('day').AsDate := Today;

    open;

    with grid_orders2 do
    begin
      ColWidths[2] := 0;
      RowCount := RecordCount+1;
      try
        for le := 0 to recordCount-1 do
        begin
          grid_orders2.Cells[1,le+1] := FieldByName('CODE_NAME').AsString;
          grid_orders2.Cells[2,le+1] := FieldByName('STATUS').AsString;
          Set_Status_6H1728_Of_Grid(FieldByName('STATUS').AsString, le+1);

          if grid_orders2.Cells[2,le+1] <> ' ' then
          begin
            if grid_orders2.Cells[2,le+1] = '대기' then
              grid_orders2.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_START').asDateTime);

            if grid_orders2.Cells[2,le+1] = '진행' then
              grid_orders2.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_START').asDateTime);

            if grid_orders2.Cells[2,le+1] = '완료' then
              grid_orders2.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_STOP').asDateTime);

            if grid_orders2.Cells[2,le+1] = '중지' then
              grid_orders2.Cells[0,le+1] := FormatdateTime('tt', FieldByName('ACT_STOP').asDateTime);
          end;

          DM1.OraQuery2.Next;
          edit2.Text := (IntToStr(grid_orders2.RowCount-1));
        end;
      finally
        for le := 0 to RowCount-1 do
        begin
          if Cells[2,le+1] = '진행' then
          begin
            ScrollInView(0,le+1);
            Break;
          end;
        end;
      end;
    end;
  end;
end;


end.



