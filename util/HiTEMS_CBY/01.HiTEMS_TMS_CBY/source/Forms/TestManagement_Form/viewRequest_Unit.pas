unit viewRequest_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, AeroButtons, JvExControls, JvLabel, CurvyControls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, AdvDateTimePicker, Vcl.ImgList,
  winApi.ShellApi, Ora, DB, DateUtils;

type
  TviewRequest_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    CurvyPanel1: TCurvyPanel;
    JvLabel11: TJvLabel;
    btn_Close: TAeroButton;
    JvLabel1: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel15: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel6: TJvLabel;
    et_testName: TEdit;
    et_testPurpose: TEdit;
    et_EngLoc: TEdit;
    JvLabel3: TJvLabel;
    et_reqDept: TEdit;
    JvLabel5: TJvLabel;
    et_reqIncharge: TEdit;
    imagelist24x24: TImageList;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    JvLabel8: TJvLabel;
    et_method: TMemo;
    JvLabel12: TJvLabel;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn19: TNxTextColumn;
    NxTextColumn20: TNxTextColumn;
    JvLabel7: TJvLabel;
    et_ReqNo: TEdit;
    grid_part: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    OpenDialog1: TOpenDialog;
    et_engType: TEdit;
    et_begin: TEdit;
    et_end: TEdit;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fileGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  private
    { Private declarations }
    ForiginFileGridWindowProc : TWndMethod;
    procedure FileGridWindowProc(var msg : TMessage);
    procedure FileGridDropFiles(aGrid:TNextGrid;var msg:TWMDropFiles);
  public
    { Public declarations }
    procedure Get_Attfiles(aGrid:TNextGrid;aOwner:String);
    procedure Get_Choose_List(aPartNo:String);
    procedure Get_Request_Resource(aReqNo:String);
  end;

var
  viewRequest_Frm: TviewRequest_Frm;
  procedure Preview_Request_Frm(aReqNo:String);

implementation
uses
  DataModule_Unit;

{$R *.dfm}

procedure Preview_Request_Frm(aReqNo:String);
begin
  viewRequest_Frm := TviewRequest_Frm.Create(nil);
  try
    with viewRequest_Frm do
    begin
      Caption := '시험요청>상세보기';
      JvLabel11.Caption := '요청 상세보기';

      et_ReqNo.Text := aReqNo;
      Get_Request_Resource(et_ReqNo.Text);

      ShowModal;

    end;
  finally
    FreeAndNil(viewRequest_Frm);
  end;
end;

procedure TviewRequest_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TviewRequest_Frm.fileGridDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  DragAcceptFiles(handle,true);
  Accept := True;
end;

procedure TviewRequest_Frm.FileGridDropFiles(aGrid: TNextGrid;
  var msg: TWMDropFiles);
var
  i,j,c, numFiles,NameLength : Integer;
  hDrop : THandle;
  tmpFile : array[0..MAX_PATH] of char;
  FileName,
  str,
  lExt : String;
  lms : TMemoryStream;
  lsize : Int64;
  LResult : Boolean;
begin
  with aGrid do
  begin
    BeginUpdate;
    try
      hDrop := Msg.Drop;
      try
        numFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
        for i := 0 to numFiles-1 do
        begin
          NameLength := DragQueryFile(hDrop, i, nil, 0);

          DragQueryFile(hDrop, i, tmpFile, NameLength+1);

          FileName := StrPas(tmpFile);

          if FileExists(FileName) then
          begin
            str := ExtractFileName(FileName);

            LResult := True;
            for j := 0 to RowCount-1 do
              if SameText(str, Cells[1,j]) then
              begin
                LResult := False;
                Break;
              end;

            if LResult then
            begin
              lms := TMemoryStream.Create;
              try
                lms.LoadFromFile(FileName);
                lsize := lms.Size;

                lExt := ExtractFileExt(str);
                Delete(lExt,1,1);
                AddRow;
                Cells[1,LastAddedRow] := str;
                Cells[2,LastAddedRow] := IntToStr(lsize);
                Cells[3,LastAddedRow] := FileName;

                for c := 0 to Columns.Count-1 do
                  Cell[c,LastAddedRow].TextColor := clBlue;
              finally
                FreeAndNil(lms);
              end;
            end;
          end;
        end;
      finally
        DragFinish(hDrop);
      end;
    finally
      EndUpdate;
    end;
  end;
end;


procedure TviewRequest_Frm.FileGridWindowProc(var msg: TMessage);
begin
  if msg.msg = WM_DROPFILES then
    FileGridDropFiles(fileGrid,TWMDROPFILES(Msg))
  else
    ForiginFileGridWindowProc(Msg);
end;

procedure TviewRequest_Frm.FormCreate(Sender: TObject);
begin
  //Drag & Drop Method
  ForiginFileGridWindowProc := fileGrid.WindowProc;
  fileGrid.WindowProc := FileGridWindowProc;

  DragAcceptFiles(fileGrid.Handle,True);
  // ============================

  PageControl1.ActivePageIndex := 0;
end;

procedure TviewRequest_Frm.Get_Attfiles(aGrid: TNextGrid; aOwner: String);
begin
  with aGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT FILENAME, FILESIZE, REGNO, OWNER from TMS_ATTFILES ' +
                'WHERE OWNER IN ( ' +
                '   SELECT REQ_NO FROM TMS_TEST_REQUEST  ' +
                '   START WITH REQ_NO LIKE :param1 ' +
                '   CONNECT BY PRIOR PARENT_NO = REQ_NO ) ');

        ParamByName('param1').AsString := aOwner;
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1,RowCount-1] := FieldByName('FILENAME').AsString;
          Cells[2,RowCount-1] := FieldByName('FILESIZE').AsString;
          Cells[4,RowCount-1] := FieldByName('REGNO').AsString;
          Cells[5,RowCount-1] := FieldByName('OWNER').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;


procedure TviewRequest_Frm.Get_Choose_List(aPartNo: String);
var
  i : Integer;
  OraQuery : TOraQuery;
begin
  with grid_part do
  begin
    BeginUpdate;
    try
      OraQuery := TOraQuery.Create(nil);
      try
        OraQuery.Session := DM1.OraSession1;
        OraQuery.FetchAll := True;

        with OraQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM HIMSEN_MS_PART  ' +
                  'WHERE PART_NO LIKE :param1 ');
          ParamByName('param1').AsString := aPartNo;
          Open;

          if RecordCount <> 0 then
          begin
            i := AddRow;

            Cells[1, i] := FieldByName('PART_NO').AsString;
            Cells[2, i] := FieldByName('MS_NO').AsString;
            Cells[3, i] := FieldByName('NAME').AsString;
            Cells[4, i] := FieldByName('MAKER').AsString;
            Cells[5, i] := FieldByName('TYPE').AsString;
            Cells[6, i] := FieldByName('STANDARD').AsString;
          end;
        end;
      finally
        FreeAndNil(OraQuery);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TviewRequest_Frm.Get_Request_Resource(aReqNo: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM ' +
            '( ' +
            '   SELECT ' +
            '     A.*, ' +
            '     B.ENGTYPE, LOC_CODE, ' +
            '     (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE A.REQ_ID) REQ_ID_NAME, ' +
            '     (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE DEPT_CD LIKE A.REQ_DEPT) REQ_DEPT_NAME, ' +
            '     (SELECT CODE_NAME FROM HITEMS_LOCATION_CODE WHERE CODE LIKE B.LOC_CODE) LOC_CODE_NAME ' +
            '   FROM TMS_TEST_REQUEST A LEFT OUTER JOIN ( ' +
            '     SELECT PROJNO, ENGTYPE, LOC_CODE FROM HIMSEN_INFO ' +
            '   ) B ON A.TEST_ENGINE = B.PROJNO ' +
            ') WHERE REQ_NO LIKE :param1 ');

    ParamByName('param1').AsString := aReqNo;
    Open;

    if RecordCount <> 0 then
    begin
      et_reqDept.Text      := FieldByName('REQ_DEPT_NAME').AsString;
      et_reqDept.Hint      := FieldByName('REQ_DEPT').AsString;

      et_EngType.Text      := FieldByName('TEST_ENGINE').AsString+'-'+FieldByName('ENGTYPE').AsString;
      et_EngLoc.Text       := FieldByName('LOC_CODE_NAME').AsString;

      et_reqIncharge.Text  := FieldByName('REQ_ID_NAME').AsString;
      et_reqIncharge.Hint  := FieldByName('REQ_ID').AsString;

      et_testName.Text     := FieldByName('TEST_NAME').AsString;
      et_testPurpose.Text  := FieldByName('TEST_PURPOSE').AsString;
      et_begin.Text        := FormatDateTime('yyyy-MM-dd', FieldByName('TEST_BEGIN').AsDateTime);
      et_end.Text          := FormatDateTime('yyyy-MM-dd', FieldByName('TEST_END').AsDateTime);
      et_method.Text       := FieldByName('TEST_METHOD').AsString;


      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TMS_TEST_REQUEST_PART ' +
              'WHERE REQ_NO LIKE :param1 ');
      ParamByName('param1').AsString := et_ReqNo.Text;
      Open;

      First;
      while not eof do
      begin
        Get_Choose_List(FieldByName('PART_NO').AsString);
        Next;
      end;

      Get_Attfiles(fileGrid,et_ReqNo.Text);

    end;
  end;
end;

end.
