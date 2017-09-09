unit fuelIn_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, AdvToolBar, DB, Ora,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.ComCtrls, AdvOfficeStatusBar, AdvSplitter,
  Vcl.Grids, Vcl.ImgList, NxEdit, Vcl.StdCtrls, AdvDateTimePicker, AdvPanel,
  NxCollection, AdvObj, BaseGrid, AdvGrid, DateUtils, tmsAdvGridExcel;

type
  TfuelIn_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList16x16: TImageList;
    ImageList32x32: TImageList;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    AdvGridExcelIO1: TAdvGridExcelIO;
    NxHeaderPanel2: TNxHeaderPanel;
    AdvSplitter2: TAdvSplitter;
    Panel4: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    label21: TLabel;
    Label12: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label18: TLabel;
    Label11: TLabel;
    foInNo: TNxEdit;
    fuelInNo1: TNxEdit;
    certPath: TNxEdit;
    foName: TNxComboBox;
    foStd: TNxEdit;
    Panel5: TPanel;
    foDelBtn: TAdvGlowButton;
    foRegBtn: TAdvGlowButton;
    foClearBtn: TAdvGlowButton;
    AdvGlowButton4: TAdvGlowButton;
    certName: TNxEdit;
    Button3: TButton;
    Button4: TButton;
    reason: TNxEdit;
    price: TNxNumberEdit;
    qty: TNxNumberEdit;
    total: TNxNumberEdit;
    indate: TAdvDateTimePicker;
    devno: TNxComboBox;
    devName: TNxEdit;
    Button1: TButton;
    AdvPanel1: TAdvPanel;
    Label13: TLabel;
    Label14: TLabel;
    ffrom: TDateTimePicker;
    fto: TDateTimePicker;
    Button5: TButton;
    Button2: TButton;
    Panel6: TPanel;
    inGrid: TAdvStringGrid;
    accGrid: TAdvStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure foNameButtonDown(Sender: TObject);
    procedure foNameSelect(Sender: TObject);
    procedure devnoButtonDown(Sender: TObject);
    procedure devnoSelect(Sender: TObject);
    procedure priceChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure foDelBtnClick(Sender: TObject);
    procedure foRegBtnClick(Sender: TObject);
    procedure inGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure foClearBtnClick(Sender: TObject);
    procedure inGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure accGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure Button5Click(Sender: TObject);
    procedure AdvGlowButton3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure qtyExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure fuelMain_Init;

    procedure Set_inGrid_Header;
    procedure Set_inGrid;
    procedure Set_page2Edit(aFoInNo:String);

    procedure Insert_Into_HiTEMS_FUEL_IN;
    procedure Update_HiTEMS_FUEL_IN;
    procedure Del_HiTEMS_FUEL_IN(aFoInNo:String);

    procedure Set_accGrid_Header;
    procedure Set_accGrid;
    procedure Calc_accumulation_of_Fuel(aFuelName:String;aRow:Integer);


  end;

var
  fuelIn_Frm: TfuelIn_Frm;

implementation
uses
  devNo_Unit,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure TfuelIn_Frm.accGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then
    HAlign := taCenter
  else
  begin
    case ACol of
      0..2 : HAlign := taRightJustify;

    end;
  end;
end;

procedure TfuelIn_Frm.AdvGlowButton3Click(Sender: TObject);
begin
  Close;
end;

procedure TfuelIn_Frm.Button1Click(Sender: TObject);
var
  lform : TdevNo_Frm;
begin
  lform := TdevNo_Frm.Create(Self);
  try
    with lform do
    begin
      ShowModal;
    end;
    devNo.Clear;
    devName.Clear;
  finally
    FreeAndNil(lform);

  end;
end;

procedure TfuelIn_Frm.Button2Click(Sender: TObject);
var
  lstr : String;
begin
  lstr := FormatDateTime('YYMMDD_',Now);
  SaveDialog1.FileName := lstr+'연료유_입고내역.xls';
  if SaveDialog1.Execute then
  begin
    AdvGridExcelIO1.AdvStringGrid := inGrid;
    AdvGridExcelIO1.XLSExport(SaveDialog1.FileName);
  end;
end;

procedure TfuelIn_Frm.Button3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    certPath.Text := OpenDialog1.FileName;
    certName.Text := ExtractFileName(certPath.Text);
  end;
end;

procedure TfuelIn_Frm.Button5Click(Sender: TObject);
begin
  Set_inGrid;
  Set_accGrid;
end;

procedure TfuelIn_Frm.Calc_accumulation_of_Fuel(aFuelName: String;
  aRow: Integer);
var
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT FUELNAME, SUM(Qty), SUM(Total) FROM FUEL_IN_V ' +
              'WHERE INDATE BETWEEN :param1 and :param2 '+
              'AND FUELNAME LIKE :FUELNAME ' +
              'GROUP BY FUELNAME ');
      ParamByName('FUELNAME').AsString := aFuelName;

      ParamByName('param1').AsDate := ffrom.DateTime;
      ParamByName('param2').AsDate := fto.DateTime;
      Open;

      if RecordCount <> 0 then
      begin
        accGrid.Cells[1,aRow] := NumberFormat(Fields[1].AsString);
        accGrid.Cells[2,aRow] := NumberFormat(Fields[2].AsString);
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

procedure TfuelIn_Frm.Del_HiTEMS_FUEL_IN(aFoInNo: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From FUEL_IN ' +
            'where FOINNO LIKE : param1 ');
    ParamByName('param1').AsString := aFoInNo;
    ExecSQL;

    ShowMessage(Format('%s 성공!',[foDelBtn.Caption]));

  end;
end;

procedure TfuelIn_Frm.devnoButtonDown(Sender: TObject);
begin
  with devNo.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from FUEL_DEVNO ' +
                'where USED = 0 ');
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            Add(FieldByName('DEVNO').AsString);
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfuelIn_Frm.devnoSelect(Sender: TObject);
begin
  with DM1.OraQuery1 do
  begin
    First;
    while not eof do
    begin
      if SameText(devNo.Text,FieldByName('DEVNO').AsString) then
      begin
        devName.Text := FieldByName('DEVNAME').AsString;
        Break;
      end;
      Next;
    end;
  end;
end;

procedure TfuelIn_Frm.FormCreate(Sender: TObject);
begin
  fuelMain_Init;
end;

procedure TfuelIn_Frm.fuelMain_Init;
begin
  ffrom.Date := StartOfTheMonth(today);
  fto.Date := EndOfTheMonth(today);
  indate.DateTime := Now;

  Set_inGrid;
  Set_accGrid;



end;

procedure TfuelIn_Frm.inGridDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  with inGrid do
  begin
    BeginUpdate;
    try
      if ARow > 0 then
      begin
        if Cells[1,ARow] <> '' then
        begin
          Set_page2Edit(Cells[1,ARow]);

          foRegBtn.Caption := '수정하기';
          foDelBtn.Enabled := True;


        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfuelIn_Frm.inGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
  var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then
    HAlign := taCenter
  else
  begin
    case ACol of
      0..1 : HAlign := taCenter;
      3 : HAlign    := taCenter;
      5..7 :HAlign  := taRightJustify;
      8 : HAlign    := taCenter;
    end;
  end;
end;

procedure TfuelIn_Frm.Insert_Into_HiTEMS_FUEL_IN;
var
  lms : TMemoryStream;
  lfoNo : Double;

begin
  with DM1.OraQuery1 do
  begin
    lms := TMemoryStream.Create;
    try
      Close;
      SQL.Clear;
      SQL.Add('Insert Into FUEL_IN ' +
              'Values(:FOINNO, :FUELINNO, :DEVNO, :REASON, :PRICE, ' +
              ':QTY, :TOTAL, :INDATE, :CERTNAME, :CERT) ');

      lfoNo := DateTimeToMilliseconds(Now);

      ParamByName('FOINNO').AsFloat := lfoNo;
      ParamByName('FUELINNO').AsFloat := fuelInNo1.AsFloat;
      ParamByName('DEVNO').AsString   := devNo.Text;
      ParamByName('REASON').AsString  := reason.Text;
      ParamByName('PRICE').AsInteger  := price.AsInteger;

      ParamByName('QTY').AsInteger    := qty.AsInteger;
      ParamByName('TOTAL').AsFloat    := total.Value;
      ParamByName('INDATE').AsDateTime:= inDate.DateTime;

      if certPath.Text <> '' then
      begin
        ParamByName('CERTNAME').AsString  := certName.Text;
        lms.LoadFromFile(certPath.Text);
        ParamByName('CERT').ParamType := ptInput;
        ParamByName('CERT').AsOraBlob.LoadFromStream(lms);
      end;

      ExecSQL;
      ShowMessage(Format('%s 성공!',[foRegBtn.Caption]));
    finally
      if lms <> nil then
        FreeAndNil(lms);
    end;
  end;
end;

procedure TfuelIn_Frm.foClearBtnClick(Sender: TObject);
begin
  foInNo.Clear;
  devNo.Clear;
  devName.Clear;
  reason.Clear;
  foName.Clear;
  foStd.Clear;
  fuelInNo1.Clear;
  price.Clear;
  qty.Clear;
  certName.Clear;
  certPath.Clear;
  indate.DateTime := Now;

  foDelBtn.Enabled := False;
  foRegBtn.Caption := '입고등록';

end;

procedure TfuelIn_Frm.foDelBtnClick(Sender: TObject);
begin
  if MessageDlg('삭제 하시겠습니까? 삭제된 정보는 복구할 수 없습니다.',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if foInNo.Text <> '' then
    begin
      Del_HiTEMS_FUEL_IN(foInNo.Text);
      Set_inGrid;
      Set_accGrid;
    end;
  end;
end;

procedure TfuelIn_Frm.foNameButtonDown(Sender: TObject);
begin
  with foName.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select distinct(FUELNO), FUELNAME, FUELSTD, UNIT from ' +
                'FUEL_PRICE ' +
                'order by FuelNo ');
        Open;

        while not eof do
        begin
          Add(FieldByName('FUELNAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfuelIn_Frm.foNameSelect(Sender: TObject);
begin
  if foName.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select FUELINNO, FUELNO, FUELSTD, PRICE from FUEL_PRICE ' +
                'where FUELNAME LIKE :param1 ' +
                'order by FUELINDATE DESC ');
        ParamByName('param1').AsString := foName.Text;
        Open;

        if RecordCount <> 0 then
        begin
          fuelInNo1.Text := FieldByName('FUELINNO').AsString;
          foStd.Text := FieldByName('FUELSTD').AsString;
          Price.Text := NumberFormat(FieldByName('PRICE').AsString);
        end;
      end;
    end;
  end;
end;

procedure TfuelIn_Frm.foRegBtnClick(Sender: TObject);
begin
  if devNo.Text = '' then
  begin
    devNo.SetFocus;
    raise Exception.Create('개발과제 번호를 선택하여 주십시오!');
  end;

  if reason.Text = '' then
  begin
    reason.SetFocus;
    raise Exception.Create('신청사유를 입력하여 주십시오!');
  end;

  if foName.Text = '' then
  begin
    foName.SetFocus;
    raise Exception.Create('품명을 선택하여 주십시오!');
  end;

  if qty.AsInteger <= 0 then
  begin
    qty.SetFocus;
    raise Exception.Create('입고수량을 입력하여 주십시오!');
  end;

  if foRegBtn.Caption = '입고등록' then
    Insert_Into_HiTEMS_FUEL_IN
  else
    Update_HiTEMS_FUEL_IN;

  Set_inGrid;
  Set_accGrid;
  foClearBtnClick(Sender);

end;

procedure TfuelIn_Frm.priceChange(Sender: TObject);
begin
  Price.Text := NumberFormat(Price.Text);
  if qty.Value > 0 then
    total.Text := NumberFormat(IntToStr(price.AsInteger * qty.AsInteger));

end;

procedure TfuelIn_Frm.qtyExit(Sender: TObject);
begin
  qty.Text := NumberFormat(qty.Text);
  total.Text := NumberFormat(IntToStr(price.AsInteger * qty.AsInteger));
end;

procedure TfuelIn_Frm.Set_accGrid;
var
  lrow,
  li,le : Integer;
  ld : Double;
  lFuelName : String;
begin
  Set_accGrid_Header;
  with accGrid do
  begin
    BeginUpdate;
    AutoSize := False;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select distinct(FUELNAME) from FUEL_IN_V ' +
                'where INDATE Between :param1 and :param2 ');

        ParamByName('param1').AsDate := ffrom.DateTime;
        ParamByName('param2').AsDate := fto.DateTime;

        Open;

        for li := 0 to RecordCount-1 do
        begin
          if li <> 0 then
            AddRow;
          lrow := RowCount-1;

          lFuelName := FieldByName('FUELNAME').AsString;
          Cells[0,lrow] := lFuelName+'   ';
          Calc_accumulation_of_Fuel(lFuelName,lrow);
          Next;
        end;


        if RowCount > 2 then
        begin
          AddRow;
          lrow := RowCount-1;
          Cells[0,lrow] := '합계   ';

          for le := 1 to 2 do
          begin
            ld := 0;
            for li := lrow-1 DownTo 1 do
              ld := ld + Floats[le,li];

            Cells[le,lrow] := NumberFormat(FloatToStr(ld));
          end;
        end;
      end;
    finally
      AutoSize := True;
      EndUpdate;
    end;
  end;
end;

procedure TfuelIn_Frm.Set_accGrid_Header;
var
  li : Integer;
begin
  with accGrid do
  begin
    BeginUpdate;
    try
      AutoSize := False;
      ClearAll;

      ColCount := 3;

      while RowCount > 2 do
        RemoveRows(2,1);

      Cells[0,0] := '품명';
      Cells[1,0] := '누적입고량';
      Cells[2,0] := '누적금액';

    finally
      AutoSize := True;
      FixedColAlways := True;
      FixedRowAlways := True;
      ColumnSize.StretchColumn := 0;
      ColumnSize.Stretch := True;

      EndUpdate;
    end;
  end;
end;

procedure TfuelIn_Frm.Set_inGrid;
var
  lrow,
  li: Integer;
begin
  Set_inGrid_Header;

  with inGrid do
  begin
    BeginUpdate;
    AutoSize := False;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from FUEL_IN_V ' +
                'where INDATE Between :param1 and :param2 '+
                'order by INDATE DESC ');

        fto.Time := Time;

        ParamByName('param1').AsDateTime := ffrom.DateTime;
        ParamByName('param2').AsDateTime := fto.DateTime;

        Open;

        for li := 0 to RecordCount-1 do
        begin
          if li <> 0 then
            AddRow;
          lrow := RowCount-1;

          Cells[0,lrow] := IntToStr(li+1);
          Cells[1,lrow] := FieldByName('FOINNO').AsString;
          Cells[2,lrow] := FieldByName('FUELNAME').AsString;
          Cells[3,lrow] := FieldByName('DEVNO').AsString;
          Cells[4,lrow] := FieldByName('REASON').AsString;

          Cells[5,lrow] := NumberFormat(FieldByName('PRICE').AsString);
          Cells[6,lrow] := NumberFormat(FieldByName('QTY').AsString);
          Cells[7,lrow] := NumberFormat(FieldByName('TOTAL').AsString);
          Cells[8,lrow] := FormatDateTime('YYYY-MM-DD',FieldByName('INDATE').AsDateTime);
          Next;
        end;
      end;
    finally
      AutoSize := True;
      ColWidths[1] := 0;
      EndUpdate;
    end;
  end;
end;


procedure TfuelIn_Frm.Set_inGrid_Header;
var
  li : Integer;
begin
  with inGrid do
  begin
    BeginUpdate;
    try
      AutoSize := False;
      ClearAll;

      ColCount := 9;
      FixedCols := 1;
      FixedColWidth := 18;

      while RowCount > 2 do
        RemoveRows(2,1);

      Cells[0,0] := '순';
      Cells[1,0] := '등록번호';
      Cells[2,0] := '자재코드';
      Cells[3,0] := '개발과제';
      Cells[4,0] := '신청사유';

      Cells[5,0] := '단가';
      Cells[6,0] := '수량';
      Cells[7,0] := '금액';
      Cells[8,0] := '입고일';

    finally
      AutoSize := True;
      FixedColAlways := True;
      FixedRowAlways := True;
      ColWidths[0] := 30;
      ColWidths[1] := 0;


      ColumnSize.StretchColumn := 4;
      ColumnSize.Stretch := True;
      EndUpdate;
    end;
  end;
end;

procedure TfuelIn_Frm.Set_page2Edit(aFoInNo: String);
begin
  if aFoInNo <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from FUEL_IN_V ' +
              'where FOINNO LIKE :param1 ');
      ParamByName('param1').AsString := aFoInNo;
      Open;

      if RecordCount <> 0 then
      begin
        foInNo.Text := aFoInNo;
        devNo.Text  := FieldByName('DEVNO').AsString;
        devName.Text := FieldByName('DEVNAME').AsString;
        reason.Text  := FieldByName('REASON').AsString;
        foName.Text  := FieldByName('FUELNAME').AsString;
        foStd.Text   := FieldByName('FUELSTD').AsString;
        fuelInNo1.Text := FieldByName('FUELINNO').AsString;
        price.Value  := FieldByName('PRICE').AsInteger;
        qty.Value    := FieldByName('QTY').AsInteger;
        certName.Text := FieldByName('CERTNAME').AsString;
        indate.DateTime := FieldByName('INDATE').AsDateTime;

      end;
    end;
  end;
end;

procedure TfuelIn_Frm.Update_HiTEMS_FUEL_IN;
var
  lms : TMemoryStream;
  lfoNo : Double;

begin
  with DM1.OraQuery1 do
  begin
    lms := TMemoryStream.Create;
    try
      Close;
      SQL.Clear;
      SQL.Add('Update FUEL_IN Set ' +
              'FUELINNO = :FUELINNO, DEVNO = :DEVNO, REASON = :REASON, ' +
              'PRICE = :PRICE, QTY = :QTY, TOTAL = :TOTAL, INDATE = :INDATE, ' +
              'CERTNAME = :CERTNAME, CERT = :CERT ' +
              'where FOINNO LIKE :param1 ');

      ParamByName('param1').AsString := foInNo.Text;

      ParamByName('FUELINNO').AsFloat := fuelInNo1.AsFloat;
      ParamByName('DEVNO').AsString   := devNo.Text;
      ParamByName('REASON').AsString  := reason.Text;
      ParamByName('PRICE').AsInteger  := price.AsInteger;

      ParamByName('QTY').AsInteger    := qty.AsInteger;
      ParamByName('TOTAL').AsFloat    := total.Value;
      ParamByName('INDATE').AsDateTime:= inDate.DateTime;

      if certPath.Text <> '' then
      begin
        ParamByName('CERTNAME').AsString  := certName.Text;

        lms.LoadFromFile(certPath.Text);
        ParamByName('CERT').ParamType := ptInput;
        ParamByName('CERT').AsOraBlob.LoadFromStream(lms);
      end;

      ExecSQL;
      ShowMessage(Format('%s 성공!',[foRegBtn.Caption]));
    finally
      if lms <> nil then
        FreeAndNil(lms);
    end;
  end;
end;

end.
