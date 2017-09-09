unit trReport_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,DB,
  AdvGlowButton, Vcl.StdCtrls, NxEdit, AdvGroupBox, AdvOfficeButtons,
  AdvSmoothTileList, NxCollection, Vcl.ComCtrls, AdvDateTimePicker,
  AdvOfficePager, AdvOfficePagerStylers, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ImgList,
  GDIPPictureContainer, Vcl.ExtDlgs, AdvSmoothTileListImageVisualizer,
  AdvSmoothTileListHTMLVisualizer, JvComponentBase, JvThread, JvThreadDialog,
  DBTables, DateUtils;

type
  TtrReport_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    NxHeaderPanel1: TNxHeaderPanel;
    rpType: TAdvOfficeRadioGroup;
    Label3: TLabel;
    typeCode: TNxEdit;
    AdvGlowButton1: TAdvGlowButton;
    trType: TAdvOfficeRadioGroup;
    Label2: TLabel;
    typeName: TNxEdit;
    Label4: TLabel;
    itemName: TNxEdit;
    Label5: TLabel;
    occurDate: TAdvDateTimePicker;
    Label7: TLabel;
    Label8: TLabel;
    planEnd: TDateTimePicker;
    Label10: TLabel;
    ImgList: TAdvSmoothTileList;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    AdvOfficePager13: TAdvOfficePage;
    AdvOfficePagerOfficeStyler1: TAdvOfficePagerOfficeStyler;
    Panel2: TPanel;
    regBtn: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    submitBtn: TAdvGlowButton;
    status: TRichEdit;
    Label9: TLabel;
    Label11: TLabel;
    FileGrid1: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    Button1: TButton;
    Button4: TButton;
    Label13: TLabel;
    cause: TRichEdit;
    Label14: TLabel;
    Label15: TLabel;
    countmeasure: TRichEdit;
    Label16: TLabel;
    Label12: TLabel;
    trKind: TAdvOfficeCheckGroup;
    ImageList1: TImageList;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    GDIPPictureContainer1: TGDIPPictureContainer;
    OpenPictureDialog1: TOpenPictureDialog;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    fileGrid2: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    fileGrid3: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn18: TNxTextColumn;
    NxTextColumn19: TNxTextColumn;
    NxTextColumn20: TNxTextColumn;
    OpenDialog1: TOpenDialog;
    delBox: TNxComboBox;
    planName: TNxComboBox;
    planNo: TNxEdit;
    procedure FormCreate(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure regBtnClick(Sender: TObject);
    procedure AdvGlowButton3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ImgListPageChanged(Sender: TObject; PageIndex: Integer);
    procedure ImgListResize(Sender: TObject);
    procedure addFiles(Sender: TObject);
    procedure delFiles(Sender: TObject);
    procedure JvThread1Execute(Sender: TObject; Params: Pointer);
    procedure Button3Click(Sender: TObject);
    procedure ImgListTileClick(Sender: TObject; Tile: TAdvSmoothTile;
      State: TTileState);
    procedure planNameButtonDown(Sender: TObject);
    procedure planNameSelect(Sender: TObject);
    procedure trTypeClick(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure submitBtnClick(Sender: TObject);
  private
    { Private declarations }
    FtrNo : String;
    FStatusChange : Boolean;
    FSelectedTile : TAdvSmoothTile;

  public
    { Public declarations }
    procedure Insert_Into_HiTEMS_TRC_ISSUE(aTrNo:String);
    procedure Update_HiTEMS_TRC_ISSUE(aTrNo:String);
    procedure Get_HiTEMS_TRC_ISSUE(aTrNo:String);
    procedure Check_report_Status(aTrNo:String);



    procedure Get_TrImages(aTrNo:String);
    procedure TrImage_Management(aTrNo:String);
    procedure Delete_TrImage(aTrNo,aFileName : String);

    procedure FileGrid_management(aTrNo:String);


    procedure Get_HiTEMS_TRC_ATTFILES(aTrNo:String);
    procedure Button_Ctrl(const Enabled:Boolean);



  end;

var
  trReport_Frm: TtrReport_Frm;
  function Create_trReport_Frm(aTrNo:String) : Boolean;

implementation
uses
  findUser_Unit,
  trObject_Unit,
  HiTEMS_TRC_COMMON,
  HiTEMS_TRC_CONST,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

function Create_trReport_Frm(aTrNo:String) : Boolean;
begin
  Result := False;
  trReport_Frm := TtrReport_Frm.Create(nil);
  try
    with trReport_Frm do
    begin
      if aTrNo <> '' then
      begin
        FtrNo := aTrNo;
        Check_report_Status(aTrNo);
        Get_HiTEMS_TRC_ISSUE(aTrNo);
        Get_HiTEMS_TRC_ATTFILES(aTrNo);
        Get_TrImages(FtrNo);
      end else
      begin
        submitBtn.Enabled := False;
      end;

      ShowModal;

      Result := FStatusChange;

    end;
  finally
    FreeAndNil(trReport_Frm);
  end;
end;

procedure TtrReport_Frm.addFiles(Sender: TObject);
var
  lidx : Integer;
  lGrid : TNextGrid;
  lname : String;
  li,le,
  lrow : Integer;
  lms : TMemoryStream;

  lFlag,
  lDBFileName,
  lFileName,
  lExt,
  lSize,
  lPath : String;


begin
  lidx := AdvOfficePager1.ActivePageIndex;

  if lidx > -1 then
  begin
    lidx := lidx+1;
    lname := 'fileGrid'+IntToStr(lidx);
    lGrid := TNextGrid(FindComponent(lname));

    case lidx of
      1 : lFlag := 'A';
      2 : lFlag := 'B';
      3 : lFlag := 'C';
    end;

    with lGrid do
    begin
      BeginUpdate;
      try
        if OpenDialog1.Execute then
        begin
          with OpenDialog1.Files do
          begin
            if Count > 0 then
            begin
              lms := TMemoryStream.Create;
              try
                for li := 0 to Count-1 do
                begin
                  lms.Clear;
                  lms.Position := 0;

                  lPath := Strings[li];
                  lFileName := ExtractFileName(lPath);
                  lExt := ExtractFileExt(lFileName);
                  lDBFileName :=  Get_makeKey(now);
                  lDBFileName := lDBFileName + lExt;
                  system.Delete(lExt,1,1);
                  lExt := UpperCase(lExt);

                  lms.LoadFromFile(lPath);
                  lSize := FloatToStr(lms.Size);

                  lrow := AddRow;

                  Cells[1,lrow] := lFlag;
                  Cells[2,lrow] := lDBFileName;
                  Cells[3,lrow] := lFileName;
                  Cells[4,lrow] := lExt;
                  Cells[5,lrow] := lSize;
                  Cells[6,lrow] := lPath;

                  for le := 0 to Columns.Count-1 do
                    Cell[le,lrow].TextColor := clBlue;

                end;
              finally
                FreeAndNil(lms);
              end;
            end;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TtrReport_Frm.AdvGlowButton1Click(Sender: TObject);
var
  lResult : String;
  lstrList : TStringList;
begin
  lResult := Create_trObject(trType.ItemIndex);

  if lResult <> '' then
  begin
    lstrList := TStringList.Create;
    try
      ExtractStrings([';'],[],PChar(lResult),lstrList);
      if lstrList.Count = 2 then
      begin
        typeCode.Text := lstrList.Strings[0];
        typeName.Text := lstrList.Strings[1];
      end else
      begin
        typeCode.Clear;
        typeName.Clear;
      end;
    finally
      FreeAndNil(lstrList);
    end;
  end;
end;

procedure TtrReport_Frm.AdvGlowButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TtrReport_Frm.AdvGlowButton3Click(Sender: TObject);
var
  lCode : String;
  li : Integer;
  litem : TStringList;
  lRow : Integer;
begin
//  with codeGrid do
//  begin
//    BeginUpdate;
//    litem := TStringList.Create;
//    try
//      if RowCount = 0 then
//        lCode := Create_trCode_Frm('')
//      else
//      begin
//        lCode := '';
//        for li := 0 to codeGrid.RowCount-1 do
//          lCode := lCode + codeGrid.Cells[2,li]+';';
//
//        lCode := Create_trCode_Frm(lCode);
//      end;
//
//      ClearRows;
//      if lCode <> '' then
//      begin
//
//        ExtractStrings([';'],[],PChar(lCode),litem);
//
//        for li := 0 to litem.Count-1 do
//        begin
//          lRow := AddRow;
//          Cells[1,lRow] := Return_trCodeName(litem.Strings[li]);
//          Cells[2,lRow] := litem.Strings[li];
//
//        end;
//      end;
//    finally
//      FreeAndNil(litem);
//      EndUpdate;
//    end;
//  end;
end;


procedure TtrReport_Frm.Button2Click(Sender: TObject);
var
  LPath : String;
  li,le : integer;
  lcnt : integer;
  lname : String;
  lResult : Boolean;
begin
  if OpenPictureDialog1.Execute then
  begin
    with GDIPPictureContainer1.Items do
    begin
      BeginUpdate;
      try
        for li := 0 to OpenPictureDialog1.Files.Count-1 do
        begin
          LPath := OpenPictureDialog1.Files.Strings[li];
          lname := ExtractFileName(LPath);

          lResult := True;
          for le := 0 to Count-1 do
            if SameText(lname, Items[le].Name) then
              lResult := False;

          if lResult = True then
          begin
            Add;
            lcnt := GDIPPictureContainer1.Items.Count-1;
            Items[lcnt].Picture.LoadFromFile(LPath);
            Items[lcnt].Name := lname;

            with imglist.Tiles do
            begin
              BeginUpdate;
              try
                Add;
                imgList.Tiles.Items[Count-1].Content.Image.Assign(GDIPPictureContainer1.Items[lcnt].Picture);
              finally
                EndUpdate;
              end;
            end;
          end
          else
            ShowMessage('같은 이름으로 등록된 이미지가 존재합니다.');
        end;
      finally
        if Count > 0 then
          imgList.PageIndex := Count-1;
      end;
    end;
  end;
end;

procedure TtrReport_Frm.Button3Click(Sender: TObject);
var
  lidx : Integer;
begin
  with GDIPPictureContainer1.Items do
  begin
    BeginUpdate;
    try
      lidx := FSelectedTile.Index;

      if lidx > -1 then
      begin
        DelBox.Items.Add(Items[lidx].Name);
        FSelectedTile.Destroy;
        Delete(lidx);

      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtrReport_Frm.Button_Ctrl(const Enabled: Boolean);
var
  li : Integer;
begin
  for li := 0 to ComponentCount-1 do
  begin
    if (Components[li] is TButton) or (Components[li] is TAdvGlowButton) then
      (Components[li] as TControl).Enabled := Enabled;
  end;
end;

procedure TtrReport_Frm.Check_report_Status(aTrNo: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HiTEMS_TRC_ISSUE WHERE TROUBLE_NO = :param1 ');
    ParamByName('param1').AsString := aTrNo;
    Open;

    if RecordCount <> 0 then
    begin
      //미 제보 상태에서 수정버튼 활성화
      if FieldByName('TRSTATE').AsInteger = 0 then
      begin
        regBtn.Caption := '수정하기';
        submitBtn.Enabled := True;
      end else
      begin
      //제보된 상태에서 접수자가 수정가능할 수 있도록
        Close;
        SQL.Clear;
        SQL.Add('SELECT RECEIVER FROM HITEMS_TRC_RECEIPT ' +
                'WHERE TROUBLE_NO = :param1 ' +
                'AND RECEIVER = :param2 ');

        ParamByName('param1').AsString := aTrNo;
        ParamByName('param2').AsString := CurrentUsers;
        Open;

        if RecordCount > 0 then
        begin
          regBtn.Enabled := True;
          regBtn.Caption := '수정하기';
          submitBtn.Visible := False;
        end else
        begin
        // 제보는 된 상태이나 미 접수 일때 작성자가 수정 가능하도록
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM HITEMS_TRC_ISSUE ' +
                  'WHERE TROUBLE_NO = :param1 ' +
                  'AND INFORMER = :param2 ');

          ParamByName('param1').AsString := aTrNo;
          ParamByName('param2').AsString := CurrentUsers;
          Open;

          if RecordCount > 0  then
          begin
            regBtn.Enabled := True;
            regBtn.Caption := '수정하기';
            submitBtn.Visible := False;
          end else
          begin
            // 접수자가 아닌 권한자가 권한테이블에서 수정 권한 있는지 확인하기
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM HITEMS_TRC_AUTHORITY ' +
                    'WHERE USERID = :param1 ');
            ParamByName('param1').AsString := CurrentUsers;
            Open;

            if RecordCount > 0 then
            begin
              if FieldByName('MODIFY_ISSUE').AsInteger > 0 then
              begin
                regBtn.Enabled := True;
                regBtn.Caption := '수정하기';
                submitBtn.Visible := False;
              end else
              begin
                regBtn.Visible := False;
                submitBtn.Visible := False;
              end;
            end else
            begin
              regBtn.Visible := False;
              submitBtn.Visible := False;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TtrReport_Frm.Delete_TrImage(aTrNo, aFileName: String);
var
  li : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From HiTEMS_TRC_ATTFILES ' +
            'where OWNER = '+aTrNo+' ' +
            'and LCFILENAME = '''+aFileName+''' ');

    ExecSQL;

  end;
end;

procedure TtrReport_Frm.delFiles(Sender: TObject);
var
  li,
  lidx : Integer;
  lname : String;
  lGrid : TNextGrid;
  lrow : Integer;

begin
  lidx := AdvOfficePager1.ActivePageIndex;

  if lidx > -1 then
  begin
    lidx := lidx+1;
    lname := 'fileGrid'+IntToStr(lidx);
    lGrid := TNextGrid(FindComponent(lname));

    with lGrid do
    begin
      BeginUpdate;
      try
        lrow := lGrid.SelectedRow;
        if Cells[6,lrow] <> '' then
          DeleteRow(lrow)
        else
        begin
          for li := 0 to Columns.Count-1 do
            Cell[li,lrow].TextColor := clRed;

        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TtrReport_Frm.FileGrid_management(aTrNo:String);
var
  li,le : Integer;
  lname : String;
  lGrid : TNextGrid;

  lFlag,
  lDBFileName,
  lFileName,
  lExt,
  lSize,
  lPath : String;

begin
  for li := 1 to 3 do
  begin
    lname := 'fileGrid'+IntToStr(li);
    lGrid := TNextGrid(FindComponent(lname));

    case li of
      1 : lFlag := 'A';
      2 : lFlag := 'B';
      3 : lFlag := 'C';
    end;

    with lGrid do
    begin
      if RowCount > 0 then
      begin
        BeginUpdate;
        try
          for le := 0 to RowCount-1 do
          begin
            lFlag         := Cells[1,le];
            lDBFileName   := Cells[2,le];
            lFileName     := Cells[3,le];
            lExt          := Cells[4,le];
            lSize         := Cells[5,le];
            lPath         := Cells[6,le];

            if Cell[1,le].TextColor = clRed then
              Delete_HiTEMS_TRC_ATTFILES(aTrNo,lFlag,lFileName);

            if Cell[1,le].TextColor = clBlue then
              Insert_Into_HiTEMS_TRC_ATTFILES(aTrNo,lFlag,lDBFileName,lFileName,lExt,lSize,lPath);
          end;
        finally
          EndUpdate;
        end;
      end;
    end;
  end;
end;

procedure TtrReport_Frm.FormCreate(Sender: TObject);
begin
  fileGrid1.DoubleBuffered := False;
  fileGrid2.DoubleBuffered := False;
  fileGrid3.DoubleBuffered := False;
  GDIPPictureContainer1.Items.Clear;
  FStatusChange := False;

  occurDate.DateTime       := Now;
  planEnd.Date             := today;

  AdvOfficePager1.ActivePageIndex := 0;
  delBox.Items.Clear;

end;

procedure TtrReport_Frm.Get_HiTEMS_TRC_ATTFILES(aTrNo:String);
var
  lGrid : TNextGrid;
  lrow : Integer;
begin
  FileGrid1.ClearRows;
  FileGrid2.ClearRows;
  FileGrid3.ClearRows;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT OWNER, FLAG, DBFILENAME, LCFILENAME, FILEEXT, ' +
            'FILESIZE from HiTEMS_TRC_ATTFILES ' +
            'WHERE OWNER = :param1 '+
            'AND FLAG != ''I'' '+
            'ORDER BY INDATE, FLAG ');

    ParamByName('param1').AsString := aTrNo;

    Open;

    if RecordCount <> 0 then
    begin
      while not eof do
      begin
        if FieldByName('FLAG').AsString = 'A' then
          lGrid := fileGrid1;
        if FieldByName('FLAG').AsString = 'B' then
          lGrid := fileGrid2;
        if FieldByName('FLAG').AsString = 'C' then
          lGrid := fileGrid3;

        with lGrid do
        begin
          BeginUpdate;
          try
            lrow := AddRow;

            Cells[1,lrow] := FieldByName('FLAG').AsString;
            Cells[2,lrow] := FieldByName('DBFILENAME').AsString;
            Cells[3,lrow] := FieldByName('LCFILENAME').AsString;
            Cells[4,lrow] := FieldByName('FILEEXT').AsString;
            Cells[5,lrow] := FieldByName('FILESIZE').AsString;
          finally
            EndUpdate;
          end;
        end;
        Next;
      end;
    end;
  end;
end;

procedure TtrReport_Frm.Get_HiTEMS_TRC_ISSUE(aTrNo: String);
var
  lrow,
  li : Integer;
  lField : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM HiTEMS_TRC_ISSUE ' +
            'WHERE TROUBLE_NO = '+aTrNo );
    Open;

    if RecordCount <> 0 then
    begin
      rpType.ItemIndex := FieldByName('RPTYPE').AsInteger;
      trType.ItemIndex := FieldByName('TRTYPE').AsInteger;
      typeCode.Text    := FieldByName('TYPECODE').AsString;
      typeName.Text    := FieldByName('TYPENAME').AsString;
      itemName.Text    := FieldByName('ITEMNAME').AsString;

      occurDate.DateTime := FieldByName('OCCURENCE').AsDateTime;
//      receiveDate.Date   := FieldByName('RECEIVEDATE').AsDateTime;

      for li := 0 to trKind.Items.Count-1 do
        trKind.Checked[li] := False;

      if FieldByName('TRQUALITY').AsString = 'T' then
        trKind.Checked[0] := True;

      if FieldByName('TRWORK').AsString = 'T' then
        trKind.Checked[1] := True;

      if FieldByName('TRDRAW').AsString = 'T' then
        trKind.Checked[2] := True;

      if FieldByName('TRETC').AsString = 'T' then
        trKind.Checked[3] := True;

      planNo.Text        := FieldByName('PLANNO').AsString;
      planName.AsString  := FieldByName('PLANNAME').AsString;
      planEnd.Date       := FieldByName('PLANEND').AsDateTime;

      status.Text        := FieldByName('STATUS').AsString;
      cause.Text         := FieldByName('PCAUSE').AsString;
      countMeasure.Text  := FieldByName('COUNTMEASURE').AsString;

    end;
  end;
end;

procedure TtrReport_Frm.Get_TrImages(aTrNo: String);
var
  li: Integer;
  tmpBlob : TBlobStream;
  LMS : TMemoryStream;
begin
  with GDIPPictureContainer1.Items do
  begin
    BeginUpdate;
    Clear;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HiTEMS_TRC_ATTFILES ' +
                'where OWNER = :param1 '+
                'and FLAG = ''I'' ' +
                'order by Indate ');

        ParamByName('param1').AsString := aTrNo;

        Open;

        if not(RecordCount = 0) then
        begin
          LMS := TMemoryStream.Create;
          try
            for li := 0 to RecordCount-1 do
            begin
              LMS.Clear;
              LMS.Position := 0;
              if FieldByName('FILES').IsBlob then
              begin
                (FieldByName('FILES') as TBlobField).SaveToStream(LMS);
                add;
                Items[Count-1].Name := FieldByName('LCFILENAME').AsString;
                Items[Count-1].Picture.LoadFromStream(LMS);

                with imglist.Tiles do
                begin
                  BeginUpdate;
                  try
                    Add;
                    imgList.Tiles.Items[Count-1].Content.Image.Assign(GDIPPictureContainer1.Items[li].Picture);
                  finally
                    EndUpdate;
                  end;
                end;
              end;
              Next;
            end;
          finally
            FreeAndNil(LMS);
          end;
        end;
      end;
    finally
      if Count > 0 then
        imgList.PageIndex := 0;
      EndUpdate;
    end;
  end;
end;

procedure TtrReport_Frm.ImgListPageChanged(Sender: TObject; PageIndex: Integer);
var
  li : integer;
begin
//  with imgList.Tiles do
//  begin
//    BeginUpdate;
//    try
//      for li := 0 to Count-1 do
//        Items[li].Content.Image.Assign(nil);
//
//      if PageIndex > -1 then
//        Items[PageIndex].Content.Image.Assign(GDIPPictureContainer1.Items[PageIndex].Picture);
//    finally
//      EndUpdate;
//    end;
//  end;
end;

procedure TtrReport_Frm.ImgListResize(Sender: TObject);
const
  lwidth = 440;
var
  ld,
  lCnt : Integer;

begin
  with ImgList do
  begin
    BeginUpdate;
    try
      lCnt := Tiles.Count;
      if lCnt > 1 then
      begin
        if width > lwidth then
        begin
          ld := width div lwidth;

          if ld < lCnt then
            Columns := ld
          else
            Columns := lcnt;
        end
        else
          Columns := 1;

      end;
    finally
      EndUpdate;
    end;
  end;

end;

procedure TtrReport_Frm.ImgListTileClick(Sender: TObject; Tile: TAdvSmoothTile;
  State: TTileState);
begin
  FSelectedTile := Tile;
end;

procedure TtrReport_Frm.Insert_Into_HiTEMS_TRC_ISSUE(aTrNo:String);
var
  li : Integer;
  lstr : String;
begin
  TThread.
  Synchronize(
  nil,
  procedure
  var
    li : Integer;
  begin
    Button_Ctrl(False);
    Application.ProcessMessages;
    try
      with DM1.OraTransaction1 do
      begin
        try
          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('INSERT INTO HiTEMS_TRC_ISSUE ' +
                    'values(:TROUBLE_NO, :RPTYPE, :TRTYPE, :TYPECODE, :TYPENAME, ' +
                    ':ITEMNAME, :OCCURENCE, :PLANNO, :PLANNAME, :PLANEND, ' +
                    ':STATUS, :PCAUSE, :COUNTMEASURE, :TRQUALITY, :TRWORK, ' +
                    ':TRDRAW, :TRETC, :INFORMER, :INDATE, :TRSTATE, :REGTYPE, ' +
                    ':MODIFY_DATE, :MODIFY_ID) ');

            try
              ParamByName('TROUBLE_NO').AsString      := aTrNo;
              ParamByName('RPTYPE').AsInteger         := rpType.ItemIndex;
              ParamByName('TRTYPE').AsInteger         := trType.ItemIndex;
              ParamByName('TYPECODE').AsString        := typeCode.Text;
              ParamByName('TYPENAME').AsString        := typeName.Text;

              ParamByName('ITEMNAME').AsString        := itemName.Text;
              ParamByName('OCCURENCE').AsDateTime     := occurDate.DateTime;

              if planNo.Text <> '' then
                ParamByName('PLANNO').AsString        := planNo.Text;

              ParamByName('PLANNAME').AsString        := planName.Text;
              ParamByName('PLANEND').AsDate           := planEnd.Date;

              ParamByName('STATUS').AsString          := status.Text;
              ParamByName('PCAUSE').AsString          := cause.Text;
              ParamByName('COUNTMEASURE').AsString    := countmeasure.Text;


              for li := 0 to trKind.Items.Count-1 do
              begin
                if trKind.Checked[li] then
                  lstr := 'T'
                else
                  lstr := 'F';

                case li of
                  0 : ParamByName('TRQUALITY').AsString := lstr;
                  1 : ParamByName('TRWORK').AsString    := lstr;
                  2 : ParamByName('TRDRAW').AsString    := lstr;
                  3 : ParamByName('TRETC').AsString     := lstr;
                end;
              end;

              ParamByName('INFORMER').AsString          := CurrentUsers;
              ParamByName('INDATE').AsDateTime          := Now;
              ParamByName('TRSTATE').AsInteger          := 0;
              ParamByName('REGTYPE').AsString           := 'P';//PC작성

              ExecSQL;

              FileGrid_management(aTrNo);
              TrImage_Management(aTrNo);

              ShowMessage('저장성공!');

            except
              raise Exception.Create('Error - Insert HiTEMS_TROUBLE_DATA');
            end;
          end;
        except
          Rollback;
        end;
      end;
    finally
      Button_Ctrl(True);
      Get_HiTEMS_TRC_ATTFILES(FTrNo);
      FStatusChange := True;
    end;
  end);
end;

procedure TtrReport_Frm.JvThread1Execute(Sender: TObject; Params: Pointer);
var
  li: Integer;

begin
  if regBtn.Caption = '저장하기' then
  begin
    FTrNo := Get_makeKey(Now);
    Insert_Into_HiTEMS_TRC_ISSUE(FTrNo);
    regBtn.Caption := '수정하기';
    submitBtn.Enabled := True;
  end else
  begin
    Update_HiTEMS_TRC_ISSUE(FTrNo);
    submitBtn.Enabled := True;
  end;

  FileGrid_management(FTrNo);
  TrImage_Management(FtrNo);

  Get_HiTEMS_TRC_ATTFILES(FtrNo);
  FStatusChange := True;

end;

procedure TtrReport_Frm.planNameButtonDown(Sender: TObject);
begin
  with planName.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT TK_NAME, TK_END FROM HITEMS_TMS_TASK_PLAN ' +
                'WHERE ((TK_START <= :param1) AND (TK_END >= :param1)) '+
                'ORDER BY TK_NAME ');

        ParamByName('param1').AsDate := occurDate.Date;
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            Add(FieldByName('TK_NAME').AsString);
            Next;

          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtrReport_Frm.planNameSelect(Sender: TObject);
begin
  with planName.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        First;
        while not eof do
        begin
          if SameText(FieldByName('TK_NAME').AsString,planName.Text) then
          begin
            planEnd.Date := FieldByName('TK_END').AsDateTime;
            Break;
          end;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtrReport_Frm.regBtnClick(Sender: TObject);
var
  li, lcnt : Integer;
  lcaption : String;
begin
  lcaption := regBtn.Caption;
  if typeCode.Text = '' then
  begin
    typeCode.SetFocus;
    raise Exception.Create('문제구분 코드를 입력하여 주십시오!');
  end;

  if typeName.Text = '' then
  begin
    typeName.SetFocus;
    raise Exception.Create('문제구분 코드명을 입력하여 주십시오!');
  end;

  if itemName.Text = '' then
  begin
    itemName.SetFocus;
    raise Exception.Create('품명을 입력하여 주십시오!');
  end;


//  if codeGrid.RowCount = 0 then
//  begin
//    codeGrid.SetFocus;
//    raise Exception.Create('문제코드(유형)는 필수 입력 입니다! ');
//  end;

  lCnt := 0;
  for li := 0 to trKind.Items.Count-1 do
  begin
    if trKind.Checked[li] then
      inc(lCnt);
  end;

  if lCnt = 0 then
  begin
    trKind.SetFocus;
    raise Exception.Create('문제유형을 하나이상 체크해 주십시오!');
  end;

  if status.Text = '' then
  begin
    status.SetFocus;
    raise Exception.Create('문제현상을 입력하여 주십시오!');
  end;

  // 문제 이미지 삭제
  if FtrNo <> '' then
  begin
    for li := 0 to delBox.Items.Count-1 do
      Delete_TrImage(FtrNo,delBox.Items.Strings[li]);

    delBox.Items.Clear;

  end;

  if regBtn.Caption = '저장하기' then
  begin
    FTrNo := Get_makeKey(Now);
    Insert_Into_HiTEMS_TRC_ISSUE(FTrNo);
    regBtn.Caption := '수정하기';
  end else
  begin
    Update_HiTEMS_TRC_ISSUE(FTrNo);
  end;
end;

procedure TtrReport_Frm.submitBtnClick(Sender: TObject);
begin
  if FtrNo <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Button_Ctrl(False);
      try
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('UPDATE HITEMS_TRC_ISSUE SET ' +
                  'INDATE = :param1, TRSTATE = :param2 ' +
                  'WHERE TROUBLE_NO = :param3 ');
          ParamByName('param3').AsString  := FtrNo;
          ParamByName('param2').AsInteger := 1;
          ParamByName('param1').AsDateTime := Now;
          ExecSQL;

          ShowMessage('제보완료!');
        end;
      finally
        Button_Ctrl(True);
        Check_report_Status(FtrNo);
      end;
    end;
  end;
end;

procedure TtrReport_Frm.TrImage_Management(aTrNo: String);
var
  li: Integer;
  lms : TMemoryStream;

  lFlag,
  lDBFileName,
  lFileName,
  lExt,
  lSize : String;
begin
  with GDIPPictureContainer1.Items do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        lms := TMemoryStream.Create;
        try
          for li := 0 to Count-1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT LCFILENAME from HiTEMS_TRC_ATTFILES ' +
                    'where OWNER = :param1 '+
                    'and LCFILENAME = :param2');

            ParamByName('param1').AsString := aTrNo;
            ParamByName('param2').AsString := Items[li].Name;
            Open;

            if RecordCount = 0 then
            begin
              lms.Clear;
              lms.Position := 0;

              lFileName := Items[li].Name;
              lExt := ExtractFileExt(lFileName);
              lDBFileName :=  FloatToStr(DateTimeToMilliseconds(Now));
              lDBFileName := lDBFileName + lExt;
              system.Delete(lExt,1,1);
              lExt := UpperCase(lExt);

              Items[li].Picture.SaveToStream(lms);
              lSize := FloatToStr(lms.Size);


              Close;
              SQL.Clear;
              SQL.Add('INSERT INTO HiTEMS_TRC_ATTFILES ' +
                      'Values(:OWNER, :FLAG, :DBFILENAME, :LCFILENAME, :FILEEXT, ' +
                      ':FILESIZE, :FILES, :INDATE) ');

              try
                ParamByName('OWNER').AsString       := aTrNo;
                ParamByName('FLAG').AsString       := 'I';
                ParamByName('DBFILENAME').AsString := lDBfileName;
                ParamByName('LCFILENAME').AsString := lFileName;
                ParamByName('FILEEXT').AsString    := lExt;
                ParamByName('FILESIZE').AsString   := lSize;
                ParamByName('INDATE').AsDateTime   := Now;

                if lms <> nil then
                begin
                  ParamByName('FILES').ParamType := ptInput;
                  ParamByName('FILES').AsOraBlob.LoadFromStream(lms);
                  ExecSQL;
                end;
              except
                on e : exception do
                begin
                  ShowMessage(e.Message);
                  raise;
                end;
              end;
            end;
          end;
        finally
          FreeAndNil(lms);
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtrReport_Frm.trTypeClick(Sender: TObject);
begin
  typeCode.Clear;
  typeName.Clear;
end;

procedure TtrReport_Frm.Update_HiTEMS_TRC_ISSUE(aTrNo: String);
var
  li : Integer;
  lstr : String;
begin
  TThread.
  Synchronize(
  nil,
  procedure
  var
    li : Integer;
  begin
    Button_Ctrl(False);
    Application.ProcessMessages;
    try
      with DM1.OraTransaction1 do
      begin
        StartTransaction;
        try
          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('UPDATE HiTEMS_TRC_ISSUE SET ' +
                    'RPTYPE=:RPTYPE, TRTYPE=:TRTYPE, TYPECODE=:TYPECODE, TYPENAME=:TYPENAME, ' +
                    'ITEMNAME=:ITEMNAME, OCCURENCE=:OCCURENCE, PLANNO=:PLANNO, PLANNAME=:PLANNAME, PLANEND=:PLANEND, ' +
                    'STATUS=:STATUS, PCAUSE=:PCAUSE, COUNTMEASURE=:COUNTMEASURE, ' +
                    'TRQUALITY=:TRQUALITY, TRWORK=:TRWORK, TRDRAW=:TRDRAW, TRETC=:TRETC, ' +
                    'MODIFY_DATE=:MODIFY_DATE, MODIFY_ID=:MODIFY_ID ' +
                    'WHERE TROUBLE_NO = :param1 ');


            try
              ParamByName('param1').AsString          := aTrNo;

              ParamByName('RPTYPE').AsInteger         := rpType.ItemIndex;
              ParamByName('TRTYPE').AsInteger         := trType.ItemIndex;
              ParamByName('TYPECODE').AsString        := typeCode.Text;
              ParamByName('TYPENAME').AsString        := typeName.Text;

              ParamByName('ITEMNAME').AsString        := itemName.Text;
              ParamByName('OCCURENCE').AsDateTime     := occurDate.DateTime;

              if planNo.Text <> '' then
                ParamByName('PLANNO').AsFloat           := StrToFloat(planNo.Text);

              ParamByName('PLANNAME').AsString        := planName.Text;
              ParamByName('PLANEND').AsDate           := planEnd.Date;

              ParamByName('STATUS').AsString          := status.Text;
              ParamByName('PCAUSE').AsString          := cause.Text;

              ParamByName('COUNTMEASURE').AsString    := countmeasure.Text;

              for li := 0 to trKind.Items.Count-1 do
              begin
                if trKind.Checked[li] then
                  lstr := 'T'
                else
                  lstr := 'F';

                case li of
                  0 : ParamByName('TRQUALITY').AsString := lstr;
                  1 : ParamByName('TRWORK').AsString    := lstr;
                  2 : ParamByName('TRDRAW').AsString    := lstr;
                  3 : ParamByName('TRETC').AsString     := lstr;
                end;
              end;

              ParamByName('MODIFY_DATE').AsDateTime := NOW;
              ParamByName('MODIFY_ID').AsString     := CurrentUsers;

              ExecSQL;

              FileGrid_management(aTrNo);
              TrImage_Management(aTrNo);

              ShowMessage('수정성공!');

            except
              raise Exception.Create('Error - UPDATE HiTEMS_TRC_DATA');
            end;
          end;
          Commit;
        except
          Rollback;
        end;
      end;
    finally
      Button_Ctrl(True);
      Get_HiTEMS_TRC_ATTFILES(FTrNo);
      FStatusChange := True;
    end;
  end);
end;

end.


