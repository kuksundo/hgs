unit appVersion_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, NxCollection, Vcl.ComCtrls,
  AdvGroupBox, AdvOfficeButtons, AdvGlowButton, Vcl.ImgList, Vcl.ExtDlgs,
  Vcl.Imaging.pngimage, DB, AdvMemo, AdvmBS, JvFullColorDialogs,
  AdvCircularProgress, JvBaseDlg, JvProgressDialog;

type
  TStreamProgressEvent = procedure(Sender:TObject; Percentage:Single) of Object;
  TProgressFileStream = class(TFileStream)
  private
    FOnProgress:TStreamProgressEvent;
    FProcessed : Int64;
    FSize : Int64;
  public
    procedure InitProgressCounter(aSize:Int64);
    function Read(var Buffer; Count:Integer):Integer;override;
    function Write(const Buffer; Count:Integer):Integer;override;
    property OnProgress:TStreamProgressEvent read FOnProgress write FOnProgress;

  end;

type
  TappVersion_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    ImageList1: TImageList;
    ImageList2: TImageList;
    NxHeaderPanel1: TNxHeaderPanel;
    versionGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxImageColumn1: TNxImageColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    Panel1: TPanel;
    NxHeaderPanel3: TNxHeaderPanel;
    NxHeaderPanel2: TNxHeaderPanel;
    NxHeaderPanel4: TNxHeaderPanel;
    NxHeaderPanel5: TNxHeaderPanel;
    Label3: TLabel;
    appCode: TEdit;
    Label7: TLabel;
    fileName: TEdit;
    btn_fileOpen: TAdvGlowButton;
    Label8: TLabel;
    fileExt: TEdit;
    Label9: TLabel;
    fileSize: TEdit;
    Label10: TLabel;
    fileTime: TEdit;
    OpenDialog1: TOpenDialog;
    AdvBasicMemoStyler1: TAdvBasicMemoStyler;
    btn_close: TAdvGlowButton;
    btn_register: TAdvGlowButton;
    btn_del: TAdvGlowButton;
    btn_refresh: TAdvGlowButton;
    ImageList32: TImageList;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    appGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxImageColumn2: TNxImageColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxMemoColumn2: TNxMemoColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    ScrollBox1: TScrollBox;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Panel2: TPanel;
    im_icon: TImage;
    ra_appType: TAdvOfficeRadioGroup;
    et_appNameK: TEdit;
    et_appNameE: TEdit;
    et_appDesc: TRichEdit;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    JvProgressDialog1: TJvProgressDialog;
    procedure appGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure btn_fileOpenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_refreshClick(Sender: TObject);
    procedure btn_registerClick(Sender: TObject);
    procedure btn_closeClick(Sender: TObject);
    procedure versionGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure btn_delClick(Sender: TObject);
    procedure JvProgressDialog1Progress(Sender: TObject;
      var AContinue: Boolean);
  private
    { Private declarations }
    procedure Initialize_;
  public
    { Public declarations }
    procedure Get_HiTEMS_APP_CODE;
    procedure Get_HiTEMS_APP_VERSION;
    procedure Get_Application_Item(aAppCode:String);

    procedure Insert_New_Version;
    procedure Delete_Version(aVerNo:String);
    procedure StreamProgress(Sender:TObject; Percentage:Single);

  end;

var
  appVersion_Frm: TappVersion_Frm;

implementation
uses
  CommonUtil_Unit,
  DataModule_Unit;


{$R *.dfm}

{ TForm1 }

procedure TappVersion_Frm.btn_fileOpenClick(Sender: TObject);
var
  lext : string;
  newVersion : TMemoryStream;

begin
  if OpenDialog1.Execute then
  begin
    newVersion := TMemoryStream.Create;
    try
      fileName.Text := OpenDialog1.FileName;

      newVersion.LoadFromFile(fileName.Text);
      fileSize.Text := IntToStr(newVersion.Size);
      fileTime.Text := FormatDateTime('YYYY-MM-DD HH:mm:ss',GetFileLastWriteTime(fileName.Text));

      lext := ExtractFileExt(fileName.Text);
      Delete(lext,1,1);
      fileExt.Text  := lext;
    finally
      FreeAndNil(newVersion);
    end;
  end;
end;

procedure TappVersion_Frm.btn_closeClick(Sender: TObject);
begin
  Close;

end;

procedure TappVersion_Frm.btn_delClick(Sender: TObject);
var
  lVerNo : String;
  lrow : Integer;
begin
  with versionGrid do
  begin
    lrow := versionGrid.SelectedRow;
    if (appCode.Text = Cells[9,lrow]) and (appCode.Font.Color = clRed) then
    begin
      Delete_Version(appCode.Text); // 버전번호로 삭제
    end;
  end;
end;

procedure TappVersion_Frm.btn_registerClick(Sender: TObject);
begin
  if appCode.Text = '' then
  begin
    raise Exception.Create('어플리케이션을 선택하여 주십시오!');
    appGrid.SetFocus;
  end;

  if fileName.Text = '' then
  begin
    raise Exception.Create('새로 등록할 파일을 선택하여 주십시오!');
    btn_fileOpen.SetFocus;
  end;
  
  Insert_New_Version;

end;

procedure TappVersion_Frm.Delete_Version(aVerNo: String);
begin
  TThread.Queue(nil,
  procedure
  begin
    with DM1.OraQuery1 do
    begin
      try
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM APP_VERSION ' +
                'WHERE VERNO = :param1 ');
        ParamByName('param1').AsString := aVerNo;

        ExecSQL;

        ShowMessage('삭제성공!');

        Initialize_;
        Get_HiTEMS_APP_VERSION;
      Except
        on e:Exception do
          ShowMessage(e.Message);
      end;
    end;
  end);
end;

procedure TappVersion_Frm.btn_refreshClick(Sender: TObject);
begin
  Initialize_;
end;

procedure TappVersion_Frm.appGridSelectCell(Sender: TObject; ACol, ARow: Integer);
var
  lrow : Integer;
begin
  Initialize_;
  with appGrid do
  begin
    appCode.Text := Cells[6,ARow];//Application Code
    appCode.Font.Color := clBlue;

    btn_del.Enabled := False;

    Get_Application_Item(appCode.Text);
  end;
end;

procedure TappVersion_Frm.FormShow(Sender: TObject);
begin
  Initialize_;
  Get_HiTEMS_APP_VERSION;
  Get_HiTEMS_APP_CODE;
end;

procedure TappVersion_Frm.Get_Application_Item(aAppCode: String);
begin
  TThread.Queue(nil,
  procedure
  var
    MS : TMemoryStream;
    pngImg : TPngImage;
    li : Integer;
  begin
    with appGrid do
    begin
      BeginUpdate;
      try
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM APP_CODE ' +
                  'WHERE APPCODE = :param1 ');
          ParamByName('param1').AsString := aAppCode;
          Open;

          if RecordCount <> 0 then
          begin
            MS := TMemoryStream.Create;
            pngImg := TPngImage.Create;
            try
              TBlobField(FieldByName('ICON')).SaveToStream(MS);
              MS.Position := 0;
              pngImg.LoadFromStream(MS);

              im_icon.Picture.Graphic := pngImg;
              im_icon.Invalidate;

              for li := 0 to ra_appType.Items.Count-1 do
              begin
                if ra_appType.Items.Strings[li] = FieldByName('APPTYPE').AsString then
                begin
                  ra_appType.ItemIndex := li;
                  Break;
                end;
              end;

              et_appNameK.Text := FieldByName('APPNAME_K').AsString;
              et_appNameE.Text := FieldByName('APPNAME_E').AsString;
              et_appDesc.Text  := FieldByName('APPDESC').AsString;

            finally
              pngImg.Free;
              MS.Free;
            end;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end);
end;

procedure TappVersion_Frm.Get_HiTEMS_APP_CODE;
begin
  TThread.Queue(nil,
  procedure
  var
    lrow : Integer;
  begin
    with appGrid do
    begin
      BeginUpdate;
      try
        ClearRows;
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT ' +
                  ' APPCODE, APPTYPE, APPNAME_K, APPNAME_E, APPDESC, REGDATE ' +
                  'FROM APP_CODE ' +
                  'WHERE STATUS = :param1 ' +
                  'ORDER BY SORTNO ');

          ParamByName('param1').AsInteger := 0; //사용중 1:미사용, 2:점검중
          Open;

          while not eof do
          begin
            lrow := AddRow;

            if FieldByName('APPTYPE').AsString = 'Delphi' then
              Cell[1,lrow].AsInteger := 0;
            if FieldByName('APPTYPE').AsString = 'Android' then
              Cell[1,lrow].AsInteger := 1;

            Cells[2,lrow] := FieldByName('APPNAME_K').AsString;
            Cells[3,lrow] := FieldByName('APPNAME_E').AsString;
            Cells[4,lrow] := FieldByName('APPDESC').AsString;
            Cells[5,lrow] := FormatDateTime('YYYY-MM-DD',FieldByName('REGDATE').AsDateTime);
            Cells[6,lrow] := FieldByName('APPCODE').AsString;

            Next;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end);
end;

procedure TappVersion_Frm.Get_HiTEMS_APP_VERSION;
begin
  TThread.Queue(nil,
  procedure
  var
    li : Integer;
    lrow : Integer;
  begin
    with versionGrid do
    begin
      BeginUpdate;
      try
        ClearRows;
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT ' +
                  ' A.APPTYPE, A.APPCODE, A.APPNAME_K, A.APPNAME_E, ' +
                  ' B.VERNO, B.FILENAME, B.FILESIZE, B.FILEEXT, B.LASTWRITETIME ' +
                  'FROM APP_CODE A, APP_VERSION B ' +
                  'WHERE A.APPCODE = B.APPCODE ' +
                  'ORDER BY VERNO DESC ');
          Open;

          for li := 0 to RecordCount-1 do
          begin
            lrow := Addrow;

            if FieldByName('APPTYPE').AsString = 'Delphi' then
              Cell[1,lrow].AsInteger := 0;
            if FieldByName('APPTYPE').AsString = 'Android' then
              Cell[1,lrow].AsInteger := 1;

            Cells[2,lrow] := FieldByName('APPNAME_K').AsString;
            Cells[3,lrow] := FieldByName('APPNAME_E').AsString;
            Cells[4,lrow] := FieldByName('FILENAME').AsString;
            Cell[5,lrow].AsFloat := FieldByName('FILESIZE').AsFloat;
            Cells[6,lrow] := FieldByName('FILEEXT').AsString;
            Cells[7,lrow] := FormatDateTime('YYYY-MM-DD HH:mm:ss',FieldByName('LASTWRITETIME').AsDateTime);
            Cells[8,lrow] := FieldByName('APPCODE').AsString;
            Cells[9,lrow] := FieldByName('VERNO').AsString;

            Next;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end);
end;

procedure TappVersion_Frm.Initialize_;
begin
  btn_del.Enabled := False;
  btn_register.Enabled := True;

  appCode.Clear;
  fileName.Clear;
  fileSize.Clear;
  fileExt.Clear;
  fileTime.Clear;

  OpenDialog1.FileName := '';

end;

procedure TappVersion_Frm.Insert_New_Version;
begin
  TThread.Queue(nil,
  procedure
  var
    i : Integer;
    stream : TProgressFileStream;
  begin
    JvProgressDialog1.Caption := '새 업데이트 등록(::'+ExtractFileName(fileName.Text)+'::)       ';
    JvProgressDialog1.Text := '업데이트 파일 오픈   ';
    JvProgressDialog1.Show;
    Application.ProcessMessages;

    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM APP_VERSION ' +
                'WHERE VERNO = (SELECT MAX (VERNO) FROM APP_VERSION) ');
        Open;

        Edit;

        stream := TProgressFileStream.Create(fileName.Text, fmOpenRead);
        try
          stream.OnProgress := StreamProgress;
          stream.InitProgressCounter(stream.Size);

          Append;
          JvProgressDialog1.Text := '업데이트 파일 전송   ';

          FieldbyName('VERNO').AsString    := FormatDateTime('YYYYMMDDHHMMSSzzz',Now);
          FieldbyName('APPCODE').AsString  := appCode.Text;
          FieldbyName('FILENAME').AsString := ExtractFileName(fileName.Text);
          FieldbyName('FILESIZE').AsFloat  := StrToFloat(fileSize.Text);
          FieldbyName('FILEEXT').AsString  := fileExt.Text;
          FieldbyName('LASTWRITETIME').AsString  := fileTime.Text;
          FieldbyName('REGID').AsString    := 'Y001613';
          FieldbyName('REGDATE').AsDateTime:= Now;

          TBlobField(FieldByName('FILES')).LoadFromStream(stream);


          Post;

          JvProgressDialog1.Text := '업데이트 파일 전송 성공!    ';

          Initialize_;
          Get_HiTEMS_APP_VERSION;

        except
          on e:Exception do
            ShowMessage(e.Message);

        end;
      end;
    finally
      sleep(500);
      JvProgressDialog1.Hide;
      stream.Free;
    end;
  end);
end;

procedure TappVersion_Frm.JvProgressDialog1Progress(Sender: TObject;
  var AContinue: Boolean);
begin
  Application.ProcessMessages;
end;

procedure TappVersion_Frm.StreamProgress(Sender: TObject; Percentage: Single);
begin
  JvProgressDialog1.Position := Round(Percentage * JvProgressDialog1.Max);
end;

procedure TappVersion_Frm.versionGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  btn_register.Enabled := False;
  btn_del.Enabled := True;

  appCode.Font.Color := clRed;

  with versionGrid do
  begin
    appCode.Text  := Cells[9,ARow]; //삭제시 appCode 에 버전번호를 넣음
    fileName.Text := Cells[4,ARow];
    fileSize.Text := Cells[5,ARow];
    fileExt.Text  := Cells[6,ARow];
    fileTime.Text := Cells[7,ARow];
  end;
end;

{ TProgressFileStream }

procedure TProgressFileStream.InitProgressCounter(aSize: Int64);
begin
  FProcessed := 0;
  if aSize <= 0 then
    FSize := 1
  else
    FSize := aSize;

  if Assigned(FOnProgress) then
    FOnProgress(Self,0);
end;

function TProgressFileStream.Read(var Buffer; Count: Integer): Integer;
begin
  Result := inherited Read(Buffer, Count);
  Inc(FProcessed, Result);
  if Assigned(FOnProgress) then
    FOnProgress(Self, FProcessed / FSize);
end;

function TProgressFileStream.Write(const Buffer; Count: Integer): Integer;
begin
  Result := inherited Write(Buffer, Count);
  Inc(FProcessed, Result);
  if Assigned(FOnProgress) then
    FOnProgress(Self, FProcessed / FSize);
end;

end.
