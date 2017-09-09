unit MountedGrid_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothPanel, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, Vcl.StdCtrls, Vcl.ExtCtrls, NxCollection, JvBackgrounds,
  Vcl.Imaging.pngimage, Ora, GradientLabel, Vcl.ImgList, tmsAdvGridExcel;

type
  TmountedGrid_Frm = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    NxHeaderPanel1: TNxHeaderPanel;
    Image2: TImage;
    NxHeaderPanel2: TNxHeaderPanel;
    GradientLabel1: TGradientLabel;
    GradientLabel2: TGradientLabel;
    NxImage1: TNxImage;
    specGrid: TAdvStringGrid;
    JvBackground1: TJvBackground;
    Panel1: TPanel;
    partGrid: TAdvStringGrid;
    Panel2: TPanel;
    Button1: TButton;
    ImageList1: TImageList;
    AdvGridExcelIO1: TAdvGridExcelIO;
    SaveDialog1: TSaveDialog;
    procedure partGridGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure partGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FsDateTime : TDateTime;
    FProjNo : String;
  public
    { Public declarations }
    procedure Show_the_Mounted_Part(aProjNo:String;aTestDate:TDateTime);
    procedure Add_Item(aHimsenID:String;aTestDate:TDateTime);
    function Check_Items_Count(aRootName:String) : Integer;

    procedure fill_to_the_specGrid(aRootNo,aPcode,aMaker,aType:String);
    procedure Set_of_the_SpecGrid(aRootNo,aPcode:String);
  end;

var
  mountedGrid_Frm: TmountedGrid_Frm;
  procedure Show_Mounted_Grid(aProjNo:String;aTestDate:TDateTime);

implementation
uses
  DataModule_Unit;
{$R *.dfm}

{ TmountedGrid_Frm }
procedure Show_Mounted_Grid(aProjNo:String;aTestDate:TDateTime);
begin
  with TmountedGrid_Frm.Create(Application) do
  begin
    FProjNo := aProjNo;
    FsDateTime := aTestDate;
    Show_the_Mounted_Part(aProjNo,aTestDate);
    Show;
  end;
end;

procedure TmountedGrid_Frm.Add_Item(aHimsenID:String;aTestDate:TDateTime);
var
  OraQuery1 : TOraQuery;
  lCount:Integer;
  lDate : String;
  lSQL : String;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with partGrid do
    begin
      lDate := FormatDateTime('YYYY-MM-DD HH:mm:ss',aTestDate);

      lSQL := 'select * from HIMSEN_PART_SPEC_V ' +
                'where HIMSENPARTID = '+aHimsenID +
                ' and MOUNTED <= :param1 '+
                ' order by MOUNTED DESC, CYLNUM';

      with OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add(lSQL);
        ParamByName('param1').AsDateTime := aTestDate;
        Open;

        if not(RecordCount = 0) then
        begin
          AddRow;
          Cells[1,RowCount-1] := Fieldbyname('ROOTNAME').AsString;

          if FieldByName('QTY').AsInteger > 1 then
          begin
            lCount := Check_Items_Count(Fieldbyname('ROOTNAME').AsString);
            Cells[2,RowCount-1] := Fieldbyname('PCODENM').AsString+' #'+IntToStr(lCount);
          end
          else
            Cells[2,RowCount-1] := Fieldbyname('PCODENM').AsString;

          Cells[3,RowCount-1] := Fieldbyname('MOUNTED').AsString;
          Cells[4,RowCount-1] := Fieldbyname('MAKER').AsString;
          Cells[5,RowCount-1] := Fieldbyname('TYPE').AsString;
          Cells[6,RowCount-1] := Fieldbyname('SERIALNO').AsString;
          Cells[7,RowCount-1] := Fieldbyname('ROOTNO').AsString;
          Cells[8,RowCount-1] := Fieldbyname('PCODE').AsString;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

procedure TmountedGrid_Frm.Button1Click(Sender: TObject);
begin
  SaveDialog1.FileName := FormatDateTime('YYMMDD_',FsDateTime)+FProjNo+'_부품탑재현황.xls';
  if SaveDialog1.Execute then
  begin
    AdvGridExcelIO1.XLSExport(SaveDialog1.FileName);
    ShowMessage('내보내기 성공!');
  end;
end;

function TmountedGrid_Frm.Check_Items_Count(aRootName: String): Integer;
var
  li : integer;
  lCount : integer;
begin
  with partGrid do
  begin
    BeginUpdate;
    try
      lCount := 0;
      for li := 1 to RowCount-1 do
        if Cells[1,li] = aRootName then
          Inc(lCount);

      if lCount = 0 then
        Result := 1
      else
        Result := lCount;
    finally
      EndUpdate;
    end;
  end;

end;

procedure TmountedGrid_Frm.fill_to_the_specGrid(aRootNo,aPcode,aMaker,aType:String);
var
  LStr,
  LSQL : String;
  LSubjList : TStringList;
  li: Integer;
begin
  try
    LSubjList := nil;

    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSEN_PART_GRP_V');
      SQL.Add('where ROOTNO = '+aRootNo);
      SQL.Add('and PCODE = '+aPcode);
      SQL.Add(' order by RootNo, GRPNO');
      Open;

      if not(RecordCount = 0) then
      begin
        LSubjList := TStringList.Create;
        while not eof do
        begin
          LSubjList.Add(FieldByName('SUBJECT_').AsString);
          Next;
        end;
      end;
    end;

    if not(LSubjList = nil) then
    begin
      LSQL := 'select ';

      for li := 0 to LSubjList.Count-1 do
        LSQL := LSQL + LSubjList.Strings[li]+',';

      LSQL := LSQL + ' IMAGES from HIMSEN_PART_SPECIFICATIONS';
      LSQL := LSQL + ' where ROOTNO = '+aRootNo;
      LSQL := LSQL + ' and PCODE = '+aPcode;
      LSQL := LSQL + ' and MAKER = '''+aMaker+''' ';
      LSQL := LSQL + ' and Type = '''+aType+''' ';

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add(LSQL);
        Open;

        if not(RecordCount = 0) then
        begin
          with specGrid do
          begin
            for li := 1 to RowCount-1 do
              Cells[1,li] := FieldByName(LSubjList.Strings[li-1]).AsString;

            if not(FieldByName('IMAGES').IsNull = True) then
            begin
              NxImage1.Picture.Assign(FieldByName('IMAGES'));
              NxImage1.Invalidate;
            end;

            Cells[0,0] := 'ITEM';
            Cells[1,0] := 'VALUES';

          end;
        end;
      end;
    end;
  finally
    if not(LSubjList = nil) then
      FreeAndNil(LSubjList);
  end;
end;

procedure TmountedGrid_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TmountedGrid_Frm.partGridDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
var
  lRootNo,
  lPcode,
  lMaker,
  lType : String;
begin
  if (ACol > 0) and (ARow > 0) then
  begin
    with partGrid do
    begin
      if not(IsNode(ARow)) then
      begin
        lMaker := Cells[3,ARow];
        lType := Cells[4,ARow];
        lRootNo := Cells[6,ARow];
        lPcode := Cells[7,ARow];

        if not(lRootNo = '') and not(lPCode = '') then
        begin
          Set_of_the_SpecGrid(lRootNo,lPcode);
          fill_to_the_specGrid(lRootNo,lPcode,lMaker,lType);
        end;
      end;
    end;
  end;
end;

procedure TmountedGrid_Frm.partGridGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if partGrid.IsNode(aRow) then
  begin
    ABrush.Color := clGray;
    aFont.Color  := clWhite;
  end;
end;

procedure TmountedGrid_Frm.Set_of_the_SpecGrid(aRootNo,aPcode:String);
var
  li: integer;
begin
  if specGrid.RowCount > 2 then
  begin
    specGrid.RemoveRows(2,specGrid.RowCount-2);
    specGrid.ClearRows(1,1);
  end;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_GRP_V ');
    SQL.Add('where ROOTNO = '+aRootNo+
            ' and PCODE = '+aPcode+
            ' order by ROOTNO, GRPNO');

    Open;

    if RecordCount > 0 then
    begin
      with specGrid do
      begin
        try
          BeginUpdate;
          AutoSize := False;

          while not eof do
          begin
            AddRow;
            Cells[0,RowCount-1] := FieldByName('SUBJECT_ENG').AsString;
    //      Cells[1,RowCount-1] := 입력란
            Cells[2,RowCount-1] := FieldByName('PDATATYPE').AsString;
            Cells[3,RowCount-1] := FieldByName('PSIZE').AsString;
            Cells[4,RowCount-1] := FieldByName('SUBJECT_').AsString;
            Next;
          end;
        finally
          for li := 0 to RowCount-1 do
            if Cells[0,1] = '' then
              RemoveRows(0,1);

          ColumnSize.StretchColumn := 1;
          ColumnSize.Stretch := True;

          AutoSize := True;
          for li := 2 to ColCount-1 do
            ColWidths[li] := 0;

          EndUpdate;
        end;
      end;
    end;
  end;
end;

procedure TmountedGrid_Frm.Show_the_Mounted_Part(aProjNo:String;aTestDate: TDateTime);
var
  lPartIdList : TStringList;
  li : integer;
begin
  lPartIdList := TStringList.Create;
  try
    with lPartIdList do
    begin
      with DM1.OraQuery2 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT HIMSENPARTID FROM HIMSEN_PART_SPEC_V ' +
                ' where PROJNO = '''+aProjNo+''' '+
                ' group by HIMSENPARTID ORDER BY HIMSENPARTID');
        Open;

        while not eof do
        begin
          Add(FieldByName('HIMSENPARTID').AsString);
          Next;
        end;
      end;

      with lPartIdList do
      begin
        if Count > 0 then
        begin
          with partGrid do
          begin
            BeginUpdate;
            try
              AutoSize := False;
              if RowCount > 2 then
              begin
                RemoveRows(2,RowCount-2);
                ClearRows(1,1);
              end;

              for li := 0 to count-1 do
                Add_Item(Strings[li],aTestDate);

            finally
              AutoSize := True;

              ColWidths[7] := 0;
              ColWidths[8] := 0;

              while Cells[1,1] = '' do
                RemoveRows(1,1);

              Group(1);
              for li := 1 to RowCount-1 do
                if IsNode(li) then
                  MergeCells(1,li,ColCount,1);

              EndUpdate;
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(lPartIdList);
  end;
end;

end.
