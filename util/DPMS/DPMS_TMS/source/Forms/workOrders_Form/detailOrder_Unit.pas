unit detailOrder_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  JvExControls, JvLabel, Vcl.ImgList, AeroButtons, NxColumnClasses, NxColumns,
  Vcl.ComCtrls, AdvDateTimePicker, Ora, NxEdit, StrUtils;

type
  TdetailOrder_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList24x24: TImageList;
    JvLabel4: TJvLabel;
    grid_History: TNextGrid;
    ImageList16x16: TImageList;
    ImageList32x32: TImageList;
    panel1: TPanel;
    lb_WorkName: TJvLabel;
    btn_Close: TAeroButton;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    grid_Worker: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxImageColumn1: TNxImageColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    JvLabel3: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    cb_Status: TComboBox;
    dt_Start: TAdvDateTimePicker;
    dt_Stop: TAdvDateTimePicker;
    mm_Remark: TMemo;
    NxNumberColumn1: TNxNumberColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    btn_Update: TAeroButton;
    et_OrderNo: TEdit;
    et_SeqNo: TNxNumberEdit;
    Splitter1: TSplitter;
    btn_EditLDS: TAeroButton;
    btn_EditShim: TAeroButton;
    btn_EditPart: TAeroButton;
    procedure btn_CloseClick(Sender: TObject);
    procedure dt_StartChange(Sender: TObject);
    procedure grid_WorkerSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure grid_HistoryCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btn_UpdateClick(Sender: TObject);
    procedure btn_EditLDSClick(Sender: TObject);
    procedure btn_EditShimClick(Sender: TObject);
    procedure btn_EditPartClick(Sender: TObject);
  private
    { Private declarations }
    FEngType : String;
    procedure Init_;
  public
    { Public declarations }
    function Get_UserName(aUserID:String) : String;
    procedure Get_Users(aDept_CD:String);
    procedure Get_Orders(aOrderNo:String);
    procedure Set_Btn_Status(aCode:String);
  end;

var
  detailOrder_Frm: TdetailOrder_Frm;
  procedure Create_detailOrder_Frm(aOrderNo,aDeptCD,aEngType:String);

implementation
uses
  checkChangePart_Unit,
  shimDataSheet_Unit,
  localSheet_Unit,
  workOrder_Unit,
  DataModule_Unit;

{$R *.dfm}

{ TdetailOrder_Frm }

procedure Create_detailOrder_Frm(aOrderNo,aDeptCD,aEngType:String);
begin
  detailOrder_Frm := TdetailOrder_Frm.Create(nil);
  try
    with detailOrder_Frm do
    begin
      FEngType := aEngType;
      et_OrderNo.Text := aOrderNo;
      Get_Users(aDeptCD);
      Get_Orders(et_OrderNo.Text);

      ShowModal;

    end;
  finally
    FreeAndNil(detailOrder_Frm);
  end;
end;

procedure TdetailOrder_Frm.btn_UpdateClick(Sender: TObject);
var
  i,
  LCnt : Integer;
  str : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE DPMS_TMS_WORK_RESULT SET ' +
            '   ACT_START = :ACT_START, ACT_STOP = :ACT_STOP, STATUS = :STATUS, ' +
            '   LIST_OF_WORKERS = :LIST_OF_WORKERS, NUM_OF_WORKERS = :NUM_OF_WORKERS, ' +
            '   REMARK = :REMARK ' +
            'WHERE ORDER_NO LIKE :param1 ' +
            'AND SEQ_NO = :param2 ');

    ParamByName('param1').AsString := et_OrderNo.Text;
    ParamByName('param2').AsInteger := et_SeqNo.AsInteger;

    if dt_Start.Format <> ' ' then
      ParamByName('ACT_START').AsDateTime := dt_Start.DateTime
    else
      ParamByName('ACT_START').Clear;

    if dt_Stop.Format <> ' ' then
      ParamByName('ACT_STOP').AsDateTime := dt_Stop.DateTime
    else
      ParamByName('ACT_STOP').Clear;

    if cb_Status.Text <> '' then
      ParamByName('STATUS').AsString := cb_Status.Text;

    ParamByName('REMARK').AsString := mm_Remark.Text;

    with grid_Worker do
    begin
      BeginUpdate;
      try
        LCnt := 0;
        str := '';
        for i := 0 to RowCount-1 do
        begin
          if Cell[1,i].AsInteger = 1 then
          begin
            str := str+Cells[3,i]+',';
            Inc(LCnt);
          end;
        end;

        str := Copy(str,1,Length(str)-1);

        ParamByName('LIST_OF_WORKERS').AsString := str;
        ParamByName('NUM_OF_WORKERS').AsInteger := LCnt;

        ExecSQL;

        if MessageDlg('수정성공!'+#13#10+'초기화 하시겠습니까?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          Init_;

      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TdetailOrder_Frm.dt_StartChange(Sender: TObject);
begin
  TAdvDateTimePicker(Sender).Format := 'yyyy-MM-dd';
  TAdvDateTimePicker(Sender).TimeFormat := 'HH:mm';
end;

procedure TdetailOrder_Frm.FormCreate(Sender: TObject);
begin
  dt_Start.DateTime := Now;
  dt_Stop.DateTime := dt_Start.DateTime;

end;

procedure TdetailOrder_Frm.btn_EditLDSClick(Sender: TObject);
begin
  Create_localSheet_Frm(et_OrderNo.Text,
                        lb_WorkName.Caption,
                        LeftStr(FEngType,6));
end;

procedure TdetailOrder_Frm.btn_EditPartClick(Sender: TObject);
begin
  Create_checkChangePart_Frm(et_OrderNo.Text,
                             LeftStr(FEngType,6));
end;

procedure TdetailOrder_Frm.btn_EditShimClick(Sender: TObject);
begin
  Create_shimDataSheet_Frm(et_OrderNo.Text,
                           LeftStr(FEngType,6));
end;

procedure TdetailOrder_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TdetailOrder_Frm.Get_Orders(aOrderNo: String);
var
  i,
  LRow : Integer;
  str : String;
  strList : TStringList;
begin
  with grid_History do
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
                '   SELECT A.CODE, CODE_NAME, ORDER_NO, B.CODE SCODE FROM DPMS_TMS_WORK_ORDERS A, DPMS_TMS_WORK_CODEGRP B ' +
                '   WHERE A.CODE = B.GRP_NO ' +
                '   AND A.ORDER_NO = :param1 ' +
                ') A LEFT OUTER JOIN DPMS_TMS_WORK_RESULT B ' +
                'ON A.ORDER_NO = B.ORDER_NO ' +
                'ORDER BY SEQ_NO DESC ');

        ParamByName('param1').AsString := aOrderNo;
        Open;

        if RecordCount <> 0 then
        begin
          Set_Btn_Status(FieldByName('SCODE').AsString);

          lb_WorkName.Caption := FieldByName('CODE_NAME').AsString;
          while not eof do
          begin
            LRow := AddRow;

            Cell[0,LRow].AsInteger := FieldByName('SEQ_NO').AsInteger;
            Cells[1,LRow]          := FieldByName('ORDER_NO').AsString;

            if not(FieldByName('ACT_START').IsNull) then
              Cells[2,LRow]        := FormatDateTime('yyyy-MM-dd HH:mm',FieldByName('ACT_START').AsDateTime);

            if not(FieldByName('ACT_STOP').IsNull) then
              Cells[3,LRow]        := FormatDateTime('yyyy-MM-dd HH:mm',FieldByName('ACT_STOP').AsDateTime);

            Cells[4,LRow]          := FieldByName('STATUS').AsString;

            if FieldByName('LIST_OF_WORKERS').AsString <> '' then
            begin
              strList := TStringList.Create;
              try
                ExtractStrings([','],[],PChar(FieldByName('LIST_OF_WORKERS').AsString), strList);
                str := '';
                for i := 0 to strList.Count-1 do
                  str := str + Get_UserName(strList.Strings[i])+',';

                str := Copy(str, 1, Length(str)-1);

                Cells[5,Lrow] := str;

              finally
                FreeAndNil(strList);
              end;
            end;

            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TdetailOrder_Frm.Get_UserName(aUserID: String): String;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_USER ' +
              'WHERE USERID LIKE :param1 ');
      ParamByName('param1').AsString := aUserID;
      Open;

      Result := FieldByName('NAME_KOR').AsString;

    end;
  finally
    FreeAndNil(OraQuery);
  end;

end;

procedure TdetailOrder_Frm.Get_Users(aDept_CD: String);
var
  lrow : Integer;
begin
  with grid_worker do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.*, B.DESCR FROM DPMS_USER A, DPMS_USER_GRADE B ' +
                'WHERE A.GRADE = B.GRADE ' +
                'AND GUNMU LIKE ''I'' ' +
                'AND A.DEPT_CD LIKE :param1 ' +
                'ORDER BY PRIV DESC, POSITION, A.GRADE, USERID ');
        ParamByName('param1').AsString := aDept_CD;
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            lrow := AddRow;
            Cell[1,lrow].AsInteger := 0;
            Cells[2,lrow] := FieldByName('NAME_KOR').AsString+'/'+FieldByName('DESCR').AsString;
            Cells[3,lrow] := FieldByName('USERID').AsString;

            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdetailOrder_Frm.grid_HistoryCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  i,j : Integer;
  str : String;
  strList : TStringList;
begin
  if ARow = -1 then
    Exit;

  with grid_History do
  begin
    BeginUpdate;
    try
      et_OrderNo.Text := Cells[1,Arow];
      et_SeqNo.Value  := Cell[0,ARow].AsInteger;

      btn_Update.Enabled := True;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM ' +
                '( ' +
                '   SELECT A.CODE, CODE_NAME,ORDER_NO ' +
                '   FROM DPMS_TMS_WORK_ORDERS A, DPMS_TMS_WORK_CODEGRP B ' +
                '   WHERE A.CODE = B.GRP_NO ' +
                ') A, DPMS_TMS_WORK_RESULT B ' +
                'WHERE A.ORDER_NO = B.ORDER_NO ' +
                'AND B.ORDER_NO LIKE :param1 ' +
                'AND B.SEQ_NO = :param2 ' +
                'ORDER BY SEQ_NO DESC ');

        ParamByName('param1').AsString  := et_OrderNo.Text;
        ParamByName('param2').AsInteger := et_SeqNo.AsInteger;
        Open;

        if RecordCount <> 0 then
        begin
          lb_WorkName.Hint := Cells[1,ARow];

          if not FieldByName('ACT_START').IsNull then
          begin
            dt_Start.DateTime := FieldByName('ACT_START').AsDateTime;
            dt_Start.Format := 'yyyy-MM-dd';
            dt_Start.TimeFormat := 'HH:mm';
          end else
          begin
            dt_Start.Format := ' ';
            dt_Start.TimeFormat := ' ';
          end;

          if not FieldByName('ACT_STOP').IsNull then
          begin
            dt_Stop.DateTime := FieldByName('ACT_STOP').AsDateTime;
            dt_Stop.Format := 'yyyy-MM-dd';
            dt_Stop.TimeFormat := 'HH:mm';
          end else
          begin
            dt_Stop.Format := ' ';
            dt_Stop.TimeFormat := ' ';
          end;

          for i := 0 to cb_Status.Items.Count-1 do
          begin
            if SameText(FieldByName('STATUS').AsString, cb_Status.Items.Strings[i]) then
            begin
              cb_Status.ItemIndex := i;
              Break;
            end;
          end;

          mm_Remark.Text := FieldByName('REMARK').AsString;

          if not FieldByName('LIST_OF_WORKERS').IsNull then
          begin
            strList := TStringList.Create;
            try
              ExtractStrings([','],[],PChar(FieldByName('LIST_OF_WORKERS').AsString),strList);
              with grid_Worker do
              begin
                BeginUpdate;
                try
                  for i := 0 to RowCount -1 do
                    Cell[1,i].AsInteger := 0;

                  for i := 0 to strList.Count-1 do
                  begin
                    for j := 0 to RowCount-1 do
                    begin
                      if SameText(Cells[3,j],strList.Strings[i]) then
                      begin
                        Cell[1,j].AsInteger := 1;
                        Break;
                      end;
                    end;
                  end;
                finally
                  EndUpdate;
                end;
              end;
            finally
              FreeAndNil(strList);
            end;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdetailOrder_Frm.grid_WorkerSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  with grid_worker do
  begin
    if ACol = 1 then
    begin
      case Cell[1,ARow].AsInteger of
        0:
        begin
          Cell[1,ARow].AsInteger := 1;
        end;
        1:
        begin
          Cell[1,ARow].AsInteger := 0;
        end;
      end;
    end;
  end;
end;

procedure TdetailOrder_Frm.Init_;
var
  i : Integer;
begin
  btn_Update.Enabled := False;
  grid_History.SelectedRow := -1;
  et_SeqNo.Clear;

  dt_Start.Format := ' ';
  dt_Start.TimeFormat := ' ';
  dt_Stop.Format := ' ';
  dt_Stop.TimeFormat := ' ';
  cb_Status.ItemIndex := -1;
  mm_Remark.Clear;

  Get_Orders(et_OrderNo.Text);

  for i := 0 To grid_Worker.RowCount-1 do
    grid_Worker.Cell[1,i].AsInteger := 0;


end;

procedure TdetailOrder_Frm.Set_Btn_Status(aCode: String);
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_TMS_WORK_CODE_SHEET ' +
              'WHERE CODE LIKE :CODE ');
      ParamByName('CODE').AsString := aCode;
      Open;

      if RecordCount <> 0 then
      begin
        btn_EditLDS.Visible := False;
        btn_EditShim.Visible := False;
        btn_EditPart.Visible := False;
        while not eof do
        begin
          if FieldByName('CLASS_NAME').AsString = 'localSheet_Frm' then
            btn_EditLDS.Visible := True;

          if FieldByName('CLASS_NAME').AsString = 'shimDataSheet_Frm' then
            btn_EditShim.Visible := True;

          if FieldByName('CLASS_NAME').AsString = 'checkChangePart_Frm' then
            btn_EditPart.Visible := True;

          Next;

        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

end.
