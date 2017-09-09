unit findParts_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxCollection, AdvSmoothListBox,
  Vcl.Imaging.pngimage, GradientLabel, Vcl.StdCtrls, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, NxEdit, Vcl.ExtCtrls, PictureContainer, Vcl.Imaging.jpeg,
  Vcl.ImgList, tmsAdvGridExcel, JvBackgrounds, AdvSmoothPanel;

type
  TfindParts_Frm = class(TForm)
    PictureContainer1: TPictureContainer;
    ImageList1: TImageList;
    AdvGridExcelIO1: TAdvGridExcelIO;
    SaveDialog1: TSaveDialog;
    JvBackground1: TJvBackground;
    AdvSmoothPanel1: TAdvSmoothPanel;
    NxHeaderPanel2: TNxHeaderPanel;
    partGrid: TAdvStringGrid;
    Panel2: TPanel;
    Button2: TButton;
    NxHeaderPanel1: TNxHeaderPanel;
    GradientLabel1: TGradientLabel;
    GradientLabel2: TGradientLabel;
    Label6: TLabel;
    GradientLabel3: TGradientLabel;
    Label7: TLabel;
    GradientLabel4: TGradientLabel;
    Label8: TLabel;
    GradientLabel5: TGradientLabel;
    Label9: TNxLabel;
    NxImage1: TNxImage;
    NxHeaderPanel3: TNxHeaderPanel;
    NxPanel2: TNxPanel;
    Label2: TLabel;
    engBox: TNxComboBox;
    NxPanel3: TNxPanel;
    Label3: TLabel;
    dlabel: TLabel;
    Label4: TLabel;
    NxComboBox1: TNxComboBox;
    Button1: TButton;
    dFrom: TNxDatePicker;
    dTo: TNxDatePicker;
    Image2: TImage;
    procedure fuelBoxButtonDown(Sender: TObject);
    procedure engBoxButtonDown(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NxComboBox1Select(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure partGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure reset_PartGrid;
    procedure Find_case_1(aProjNo:String);//시점 검색
    procedure Find_case_2(aProjNo:String);//기간내 탑재되었던 모든 파트 검색
    procedure Show_Detail_Info(aFlag, aMaker, aType :String;aTypeno:Integer);

  end;

var
  findParts_Frm: TfindParts_Frm;

implementation
uses
  DataModule_Unit;

{$R *.dfm}

procedure TfindParts_Frm.partGridDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
var
  ltypeNo : Integer;
  ltype,
  lmaker,
  lflag : String;
begin
  with partGrid do
  begin
    if not IsNode(ARow) then
    begin
      lflag := Cells[1,ARow];
      if not(lflag = '') then
      begin
        lmaker  := Cells[3,ARow];
        ltype   := Cells[4,ARow];
        ltypeno := StrToInt(Cells[5,ARow]);
        Show_Detail_Info(lflag, lmaker, ltype, ltypeNo);

        Label6.Caption := Cells[9,ARow]; //탑재일
        Label7.Caption := Cells[7,ARow]; // 작업자 hhi
        Label8.Caption := Cells[8,ARow]; // 작업자 gsm
        Label9.Caption := Cells[10,ARow]; // 상세내용

      end;
    end;
  end;
end;

procedure TfindParts_Frm.Button1Click(Sender: TObject);
var
  li : integer;
  lproj : String;
begin
  if not(engBox.Text = '') then
  begin
    if not(engBox.ItemIndex = 0) then
    begin
      li := pos('-',engBox.Text);
      lproj := Copy(engBox.Text,0,li-1);
    end
    else
      lproj := '';

    if not(NxComboBox1.Text = '') then
    begin
      case NxComboBox1.ItemIndex of
        1 : Find_case_1(lProj);
        2 : Find_case_2(lProj);
      end;
    end
    else
      ShowMessage('1.검색조건은 필수 조건 입니다.');
  end;
end;

procedure TfindParts_Frm.Button2Click(Sender: TObject);
var
  lstr,
  lEng : String;
  li : integer;
begin
  lstr := engBox.Text;
  li := pos('/',lstr);
  Delete(lstr,li,1);

  with SaveDialog1 do
  begin
    FileName := FormatDateTime('yymmdd',Now)+'-'+
                lstr+'-PartInfo.xls';
    if Execute then
    begin
      AdvGridExcelIO1.XLSExport(FileName);


    end;
  end;
end;

procedure TfindParts_Frm.engBoxButtonDown(Sender: TObject);
var
  LCaption : String;
begin
  engBox.Items.Clear;
  engBox.Items.Add('전체');
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HiMSEN_ENG_LIST ');


    SQL.Add('order by FuelCD, ENGTYPE' );
    Open;

    if not(RecordCount = 0) then
    begin
      while not eof do
      begin
        engBox.Items.Add(FieldByName('PROJNO').AsString +'-'+
                         FieldByName('ENGTYPE').AsString);
        Next;
      end;
    end;
  end;
end;

procedure TfindParts_Frm.Find_case_1(aProjNo:String);
var
  li : integer;
  lFlagNo : integer;
  lPARTID : TStringList;
begin
  try
    lPARTID := TStringList.Create;
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select A.HIMSENPARTID,B.FLAGNO from HIMSEN_ENGINE_PART_ID A, HIMSEN_PART_FLAG B ');

      if not(aProjNo = '') then
        SQL.Add('WHERE A.PROJNO = '''+aProjNo+''' ' +
                'and A.FLAG = B.FLAG ORDER BY FLAGNO, HIMSENPARTID')
      else
        SQL.Add('where A.FLAG = B.FLAG ORDER BY FLAGNO, HIMSENPARTID');

      Open;

      while not eof do
      begin
        lPARTID.Add(FieldByName('HIMSENPARTID').AsString);
        Next;
      end;
    end;

    with partGrid do
    begin
      try
        BeginUpdate;
        UnGroup;
        ColumnSize.StretchColumn := -1;
        ColumnSize.Stretch := False;
        reset_PartGrid;

        for li := 0 to lPARTID.Count-1 do
        begin
          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('select * from HIMSEN_MOUNTED_V ');
            SQL.Add('where HIMSENPARTID = '''+lPARTID.Strings[li]+''' ' +
                    'and Mounted < :param1 order by MOUNTED DESC');
            ParamByName('param1').AsDate := dFrom.Date+1;
            Open;

            if not(RecordCount = 0) then
            begin
              AddRow;
              lFlagNo := FieldByName('FLAGNO').AsInteger;

              Cells[1,RowCount-1] := Char(96+lFlagNo)+'.'+FieldByName('PARTNAME').AsString;
              Cells[2,RowCount-1] := FieldByName('FLAG').AsString;
              Cells[3,RowCount-1] := FieldByName('POSITION').AsString;
              Cells[4,RowCount-1] := FieldByName('MAKER').AsString;
              Cells[5,RowCount-1] := FieldByName('TYPE').AsString;
              Cells[6,RowCount-1] := FieldByName('TYPENO').AsString;
              Cells[7,RowCount-1] := FieldByName('SERIALNO').AsString;
              Cells[8,RowCount-1] := FieldByName('WORKER_HHI_NM').AsString;
              Cells[9,RowCount-1] := FieldByName('WORKER_OUT_NM').AsString;
              Cells[10,RowCount-1] := FormatDateTime('yyyy-mm-dd hh:mm',FieldByName('MOUNTED').AsDateTime);
              Cells[11,RowCount-1] := FieldByName('DESCRIPTION').AsString;

            end;
          end;
        end;
      finally
        if RowCount > 2 then
        begin
          while Cells[1,1] = '' do
            RemoveRows(1,1);

          Group(1);
          for li := 1 to RowCount-1 do
            if IsNode(li) then
              MergeCells(1,li,ColCount,1);

        end;
        ColumnSize.StretchColumn := 9;
        ColumnSize.Stretch := True;
        EndUpdate;
      end;
    end;
  finally
    FreeAndNil(lPARTID);
  end;
end;

procedure TfindParts_Frm.Find_case_2(aProjNo: String);
var
  li : integer;
  lFlagNo : integer;

  lPARTID : TStringList;
begin
  with partGrid do
  begin
    try
      BeginUpdate;
      UnGroup;
      ColumnSize.StretchColumn := -1;
      ColumnSize.Stretch := False;
      reset_PartGrid;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_MOUNTED_V ');

        if not(aProjNo = '') then
          SQL.Add('WHERE PROJNO = '''+aProjNo+''' '+
                  'and Mounted Between :param1 and :param2 ')
        else
          SQL.Add('where Mounted Between :param1 and :param2 ORDER BY FLAGNO, HIMSENPARTID');

        ParamByName('param1').AsDate := dFrom.Date-1;
        ParamByName('param2').AsDate := dTo.Date+1;
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            AddRow;
            lFlagNo := FieldByName('FLAGNO').AsInteger;

            Cells[1,RowCount-1] := Char(96+lFlagNo)+'.'+FieldByName('PARTNAME').AsString;
            Cells[2,RowCount-1] := FieldByName('FLAG').AsString;
            Cells[3,RowCount-1] := FieldByName('POSITION').AsString;
            Cells[4,RowCount-1] := FieldByName('MAKER').AsString;
            Cells[5,RowCount-1] := FieldByName('TYPE').AsString;
            Cells[6,RowCount-1] := FieldByName('TYPENO').AsString;
            Cells[7,RowCount-1] := FieldByName('SERIALNO').AsString;
            Cells[8,RowCount-1] := FieldByName('WORKER_HHI_NM').AsString;
            Cells[9,RowCount-1] := FieldByName('WORKER_OUT_NM').AsString;
            Cells[10,RowCount-1] := FormatDateTime('yyyy-mm-dd hh:mm',FieldByName('MOUNTED').AsDateTime);
            Cells[11,RowCount-1] := FieldByName('DESCRIPTION').AsString;
            Next;
          end;
        end;
      end;
    finally
      if RowCount > 2 then
      begin
        while Cells[1,1] = '' do
          RemoveRows(1,1);

        Group(1);
        for li := 1 to RowCount-1 do
          if IsNode(li) then
            MergeCells(1,li,ColCount,1);

      end;

      ColumnSize.StretchColumn := 9;
      ColumnSize.Stretch := True;
      EndUpdate;
    end;
  end;
end;

procedure TfindParts_Frm.FormCreate(Sender: TObject);
begin
  dFrom.Date := Date;
  dTo.Date := Date;
end;

procedure TfindParts_Frm.fuelBoxButtonDown(Sender: TObject);
var
  LFuel : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select Distinct(FuelType), FUELCD from HIMSEN_ENG_LIST order by FUELCD');
    Open;

    if not(RecordCount = 0) then
    begin
      while not eof do
      begin
        Next;
      end;
    end;
  end;
end;

procedure TfindParts_Frm.NxComboBox1Select(Sender: TObject);
begin
  case NxComboBox1.ItemIndex of
    0 : begin
          dFrom.Enabled := False;
          dTo.Enabled := False;
          dlabel.Font.Color := clGray;
        end;

    1 : begin
          dFrom.Enabled := True;
          dTo.Enabled := False;
          dlabel.Font.Color := clGray;
        end;

    2 : begin
          dFrom.Enabled := True;
          dTo.Enabled := True;
          dlabel.Font.Color := clBlack;
        end;
  end;
end;

procedure TfindParts_Frm.reset_PartGrid;
begin
  with partGrid do
  begin
    if RowCount > 2 then
    begin
      UnGroup;
      RemoveRows(2,RowCount-2);
      ClearRows(1,1);
    end;
  end;
end;

procedure TfindParts_Frm.Show_Detail_Info(aFlag, aMaker, aType: String;
  aTypeno: Integer);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select Images from Himsen_Part_Specifications ' +
            'where Flag = '''+aFlag+''' ' +
            'and Maker = '''+aMaker+''' '+
            'and Type = '''+aType+''' '+
            'and TypeNo = '+IntToStr(aTypeNo));
    Open;

    if not(RecordCount = 0)  then
    begin
      if not(FieldByName('IMAGES').IsNull = True) then
      begin
        NxImage1.Picture.Assign(FieldByName('IMAGES'));
        NxImage1.Invalidate;
      end
      else
      begin
        NxImage1.Picture.Assign(PictureContainer1.Items[0].Picture);
        NxImage1.Invalidate;
      end;
    end;
  end;
end;

end.

