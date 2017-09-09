unit appCode_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGroupBox, AdvOfficeButtons,
  Vcl.StdCtrls, AdvGlowButton, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, NxCollection, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.ImgList, Vcl.ExtDlgs, Vcl.Imaging.pngimage, DB, Vcl.ComCtrls;

type
  TappCode_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    NxHeaderPanel1: TNxHeaderPanel;
    appGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxImageColumn1: TNxImageColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    AdvGlowButton1: TAdvGlowButton;
    btn_regist: TAdvGlowButton;
    et_appNameK: TEdit;
    et_appNameE: TEdit;
    Label3: TLabel;
    ra_appStatus: TAdvOfficeRadioGroup;
    Label4: TLabel;
    Panel1: TPanel;
    AdvGlowButton3: TAdvGlowButton;
    AdvGlowButton4: TAdvGlowButton;
    im_icon: TImage;
    Label5: TLabel;
    ra_appType: TAdvOfficeRadioGroup;
    ImageList1: TImageList;
    NxTextColumn3: TNxTextColumn;
    OpenPictureDialog1: TOpenPictureDialog;
    Label6: TLabel;
    et_appDesc: TRichEdit;
    ComboBox1: TComboBox;
    ImageList2: TImageList;
    NxMemoColumn1: TNxMemoColumn;
    NxTextColumn4: TNxTextColumn;
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton4Click(Sender: TObject);
    procedure btn_registClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure appGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure AdvGlowButton3Click(Sender: TObject);
  private
    { Private declarations }
    FCurrentCode : String;

  public
    { Public declarations }
    procedure Initialize_;
    procedure Get_HiTEMS_APP_CODE;
    procedure Get_Application_Item(aAppCode:String);
    procedure Insert_Application_Info;
    procedure Update_Application_Info(aAppCode:String);

  end;

var
  appCode_Frm: TappCode_Frm;

implementation
uses
  DataModule_Unit;

{$R *.dfm}


procedure TappCode_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TappCode_Frm.btn_registClick(Sender: TObject);
begin
  if not Assigned(im_icon.Picture.Graphic) then
  begin
    raise Exception.Create('아이콘을 등록하여 주십시오!');
    AdvGlowButton4.SetFocus;
  end;

  if et_appNameK.Text = '' then
  begin
    raise Exception.Create('어플리케이션 명(한글)을 입력하여 주십시오!');
    et_appNameK.SetFocus;
  end;

  if et_appNameE.Text = '' then
  begin
    raise Exception.Create('어플리케이션 명(영문)을 입력하여 주십시오!');
    et_appNameE.SetFocus;
  end;

  try
    try
      if btn_regist.Caption = '등록' then
      begin
        Insert_Application_Info;
      end else
      begin
        //수정
        Update_Application_Info(FCurrentCode);
      end;

      ShowMessage(Format('%s 성공!',[btn_regist.Caption]));
    Except
      ShowMessage(Format('%s 실패!',[btn_regist.Caption]));
    end;
  finally
    Get_HiTEMS_APP_CODE;
    OpenPictureDialog1.FileName := '';
  end;
end;

procedure TappCode_Frm.FormShow(Sender: TObject);
begin
  Get_HiTEMS_APP_CODE;
end;

procedure TappCode_Frm.Get_Application_Item(aAppCode: String);
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
            except
              im_icon.Picture.Graphic := nil;
              im_icon.Invalidate;
            end;

            et_appNameK.Text := FieldByName('APPNAME_K').AsString;
            et_appNameE.Text := FieldByName('APPNAME_E').AsString;
            et_appDesc.Text  := FieldByName('APPDESC').AsString;
            ra_appStatus.ItemIndex := FieldByName('STATUS').AsInteger;

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
end;

procedure TappCode_Frm.Get_HiTEMS_APP_CODE;
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

          ParamByName('param1').AsInteger := ComboBox1.ItemIndex;
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

procedure TappCode_Frm.AdvGlowButton3Click(Sender: TObject);
begin
  Initialize_;
end;

procedure TappCode_Frm.AdvGlowButton4Click(Sender: TObject);
var
  lPath : String;
  pngIcon : TPNGImage;
begin
  if OpenPictureDialog1.Execute then
  begin
    im_icon.Hint := OpenPictureDialog1.FileName;
    pngIcon := TPngImage.Create;
    try
      pngIcon.LoadFromFile(im_icon.Hint);
      im_icon.Picture.Graphic := pngIcon;
      im_icon.Invalidate;
    finally
      pngIcon.Free;
    end;
  end;
end;

procedure TappCode_Frm.appGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  with appGrid do
  begin
    btn_regist.Caption := '수정';

    FCurrentCode := Cells[6,ARow];
    Get_Application_Item(FCurrentCode);

  end;
end;

procedure TappCode_Frm.Initialize_;
begin
  btn_regist.Caption := '등록';

  FCurrentCode := '';
  OpenPictureDialog1.FileName := '';
  im_icon.Picture.Graphic := nil;
  im_icon.Invalidate;

  ra_appType.ItemIndex := 0;
  ra_appStatus.ItemIndex := 0;
  et_appNameK.Clear;
  et_appNameE.Clear;
  et_appDesc.Clear;
end;

procedure TappCode_Frm.Insert_Application_Info;
begin
  TThread.Queue(nil,
  procedure
  var
    iconPath : String;
    pngImg : TPngImage;
    MS : TMemoryStream;
    sortNo : Integer;
  begin
    iconPath := OpenPictureDialog1.FileName;
    if iconPath <> '' then
    begin
      pngImg := TPngImage.Create;
      MS := TMemoryStream.Create;
      try
        pngImg.LoadFromFile(iconPath);
        pngImg.SaveToStream(MS);
        MS.Position := 0;

        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM APP_CODE ' +
                  'WHERE APPTYPE = :param1 ' +
                  'AND APPNAME_K = :param2 ' +
                  'AND APPNAME_E = :param3 ');
          ParamByName('param1').AsString := ra_appType.Items.Strings[ra_appType.ItemIndex];
          ParamByName('param2').AsString := et_appNameK.Text;
          ParamByName('param3').AsString := et_appNameE.Text;
          Open;

          if RecordCount <> 0 then
          begin
            ShowMessage('같은 이름으로 등록된 어플리케이션이 존재 합니다.' );
            Exit;
          end
          else
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT SORTNO FROM APP_CODE ' +
                    'WHERE APPTYPE = :param1 ');
            ParamByName('param1').AsString := ra_appType.Items.Strings[ra_appType.ItemIndex];
            Open;

            SortNo := RecordCount+1;


            Close;
            SQL.Clear;
            SQL.Add('INSERT INTO APP_CODE ' +
                    'VALUES( ' +
                    ' :APPCODE, :APPTYPE, :APPNAME_K, :APPNAME_E, :APPDESC, ' +
                    ' :STATUS, :SORTNO, :REGID, :REGDATE, :MODID, :MODDATE, :ICON )');

            FCurrentCode := FormatDateTime('YYYYMMDDHHmmsszzz',Now);
            ParamByName('APPCODE').AsString   := FCurrentCode;
            ParamByName('APPTYPE').AsString   := ra_appType.Items.Strings[ra_appType.ItemIndex];
            ParamByName('APPNAME_K').AsString := et_appNameK.Text;
            ParamByName('APPNAME_E').AsString := et_appNameE.Text;
            ParamByName('APPDESC').AsString   := et_appDesc.Text;

            ParamByName('STATUS').AsInteger   := ra_appStatus.ItemIndex;
            ParamByName('SORTNO').AsInteger   := SortNo;

            ParamByName('REGID').AsString := 'Y001613';
            ParamByName('REGDATE').AsDateTime := Now;

            parambyname('ICON').ParamType := ptInput;
            parambyname('ICON').AsOraBlob.LoadFromStream(MS);

            ExecSQL;
          end;
        end;
      finally
        pngImg.Free;
        MS.Free;
      end;
    end;
  end);
end;


procedure TappCode_Frm.Update_Application_Info(aAppCode: String);
begin
  TThread.Queue(nil,
  procedure
  var
    iconPath : String;
    MS : TMemoryStream;
    pngImg : TPngImage;

  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE APP_CODE SET ' +
              'APPTYPE = :APPTYPE, APPNAME_K = :APPNAME_K, ' +
              'APPNAME_E = :APPNAME_E, APPDESC = :APPDESC, ' +
              'STATUS = :STATUS, MODID = :MODID, MODDATE = :MODDATE, ' +
              'ICON = :ICON ' +
              'WHERE APPCODE = :param1 ');
      ParamByName('param1').AsString := aAppCode;

      ParamByName('APPTYPE').AsString   := ra_appType.Items.Strings[ra_appType.ItemIndex];
      ParamByName('APPNAME_K').AsString := et_appNameK.Text;
      ParamByName('APPNAME_E').AsString := et_appNameE.Text;
      ParamByName('APPDESC').AsString   := et_appDesc.Text;

      ParamByName('STATUS').AsInteger   := ra_appStatus.ItemIndex;

      ParamByName('MODID').AsString := 'Y001613';
      ParamByName('MODDATE').AsDateTime := Now;

      if im_icon.Hint <> '' then
      begin
        MS := TMemoryStream.Create;
        try
          pngImg := TPngImage.Create;
          try
            pngImg.LoadFromFile(im_icon.Hint);
            pngImg.SaveToStream(MS);
            Ms.Position := 0;

            parambyname('ICON').ParamType := ptInput;
            parambyname('ICON').AsOraBlob.LoadFromStream(MS);
          finally
            pngImg.Free;
          end;
        finally
          MS.Free;
        end;
      end;
      ExecSQL;
    end;
  end);
end;

end.
