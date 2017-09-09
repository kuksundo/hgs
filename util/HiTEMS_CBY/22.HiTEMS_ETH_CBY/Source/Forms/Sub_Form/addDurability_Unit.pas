unit addDurability_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvBackgrounds, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.ComCtrls, TreeList, Vcl.StdCtrls, NxCollection,
  AdvSmoothPanel, Ora, NxEdit, Vcl.ImgList, NxScrollControl, Bde.DBTables,
  NxCustomGridControl, NxCustomGrid, NxGrid, NxColumnClasses, NxColumns,
  Vcl.ExtDlgs, Data.DB, AdvGroupBox, AdvOfficeButtons, GDIPPictureContainer,
  Vcl.Imaging.jpeg, AdvSmoothTileList, AdvSmoothTileListImageVisualizer,DBAccess,
  AdvSmoothTileListHTMLVisualizer, AdvGDIPicture, OtlParallel, OtlTask, OtlTaskControl;


type
  TUpdateInfo = Record
    RevisionNo,
    ParentRev : Double;
end;

type
  TaddDurability_Frm = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel2: TPanel;
    Button6: TButton;
    Button1: TButton;
    Image2: TImage;
    JvBackground1: TJvBackground;
    ImageList1: TImageList;
    NxHeaderPanel2: TNxHeaderPanel;
    Panel3: TPanel;
    Button2: TButton;
    Button3: TButton;
    NxHeaderPanel3: TNxHeaderPanel;
    Panel4: TPanel;
    Panel7: TPanel;
    partname: TNxEdit;
    Panel1: TPanel;
    Panel5: TPanel;
    purpose: TNxEdit;
    Panel6: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    remark: TRichEdit;
    OpenPictureDialog1: TOpenPictureDialog;
    targetTime: TNxNumberEdit;
    Label1: TLabel;
    editType: TAdvOfficeRadioGroup;
    GDIPPictureContainer1: TGDIPPictureContainer;
    ImgList: TAdvSmoothTileList;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    AdvGDIPPicture1: TAdvGDIPPicture;
    procedure Button6Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ImgListPageChanged(Sender: TObject; PageIndex: Integer);
    procedure editTypeClick(Sender: TObject);
  private
    { Private declarations }
    FUpdateInfo : TUpdateInfo;
    FParentRev : String;
    FProjNo : String;
    FRecNo : String;
  public
    { Public declarations }
    function Add_new_Durability_Item(aRecNo,aParentRev:String) : Boolean;
    procedure Add_Durability_Images(aRevNo:Double);

    function Update_Items(aRevNo:Double) : Boolean;

    procedure Show_Items(aRevNo:String; var aUpdateInfo:TUpdateInfo);
    procedure Get_Image_from_DB(aRevNo:String);

    procedure Save_routine;
  end;

var
  addDurability_Frm: TaddDurability_Frm;
  function Create_new_durability_Item(aRecNo,aPartName:String) : Boolean;
  function Create_child_durability_Item(aRecNo,aParentRev,aPartName:String) : Boolean;
  function Update_Durability_Items(aRevNo:String) : Boolean;

implementation
uses
  progress_Unit,
  imagefunctions_Unit,
  HiTEMS_ETH_COMMON,
  HiTEMS_ETH_CONST,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

function Create_new_durability_Item(aRecNo,aPartName:String) : Boolean;
var
  li : integer;
  lNode : TTreeNode;
begin
  Result := False;
  with TaddDurability_Frm.Create(Application) do
  begin
    try
      editType.ItemIndex := 0; //신규
      Button1.Caption := '신규등록';
      panel8.Caption := '목표시간';
      partname.Text := aPartName;
      GDIPPictureContainer1.Items.Clear;
      FRecNo := aRecNo;
      if ShowModal = mrOk then
      begin
        Result := True;
      end;
    finally
      Free;
    end;
  end;
end;

function Create_child_durability_Item(aRecNo,aParentRev,aPartName:String) : Boolean;
var
  li : integer;
  lNode : TTreeNode;
begin
  Result := False;
  with TaddDurability_Frm.Create(Application) do
  begin
    try
      editType.ItemIndex := 0; //신규
      Button1.Caption := '신규등록';
      panel8.Caption := '경과시간';
      partname.Text := aPartName;
      GDIPPictureContainer1.Items.Clear;
      FParentRev := aParentRev;
      FRecNo := aRecNo;
      if ShowModal = mrOk then
      begin
        Result := True;
      end;
    finally
      Free;
    end;
  end;
end;

function Update_Durability_Items(aRevNo:String) : Boolean;
begin
  with TaddDurability_Frm.Create(Application) do
  begin
    editType.ItemIndex := 1; //신규
    Button1.Caption := '데이터수정';
    GDIPPictureContainer1.Items.Clear;
    try
      EditType.ItemIndex := 1;
      Show_Items(aRevNo,FUpdateInfo);

      if FUpdateInfo.ParentRev > 0 then
        panel8.Caption := '목표시간'
      else
        panel8.Caption := '경과시간';

      if ShowModal = mrOk then
        Result := True;
    finally
      Free;
    end;
  end;
end;

procedure TaddDurability_Frm.Add_Durability_Images(aRevNo: Double);
var
  OraQuery1 : TOraQuery;
  Lms : TMemoryStream;
  li: Integer;
begin
  with GDIPPictureContainer1.Items do
  begin
    OraQuery1 := TOraQuery.Create(nil);
    OraQuery1.Session := DM1.OraSession1;
    OraQuery1.Options.TemporaryLobUpdate := True;
    if Count > 0 then
    begin
      with OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Insert Into HIMSEN_DURABILITY_IMAGES ' +
                'Values(:REVNO, :IMGNO, :IMGNAME, :IMGSIZE, :IMAGES)');

        for li := 0 to Count-1 do
        begin
          ParamByName('REVNO').AsFloat    := aRevNo;
          ParamByName('IMGNO').AsInteger  := li+1;
          ParamByName('IMGNAME').AsString := Items[li].Name;

          if Items[li].Picture <> nil then
          begin
            LMS := TMemoryStream.Create;
            try
              Items[li].Picture.SaveToStream(LMS);
              ParamByName('IMGSIZE').AsFloat  := LMS.Size;

              LMS.Position := 0;

              if LMS <> nil then
              begin
                ParamByName('IMAGES').ParamType := ptInput;
                ParamByName('IMAGES').AsOraBlob.LoadFromStream(LMS);
                ExecSQL;
              end;

            finally
              FreeAndNil(LMS);
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TaddDurability_Frm.Add_new_Durability_Item(aRecNo,aParentRev:String) : Boolean;
var
  lKey : Int64;
  lResult : Boolean;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert Into HIMSEN_DURABILITY_DESC (REVNO, PARENTREV, RECNO, ' +
            'STATUS, PURPOSE, TARGETTIME, REMARK, REGID, REGDATE, LV, PARTNAME) ' +
            'VALUES(:REVNO, :PARENTREV, :RECNO, :STATUS, :PURPOSE, :TARGETTIME, :REMARK, ' +
            ':REGID, :REGDATE, :LV, :PARTNAME)');

    lKey := DateTimeToMilliseconds(Now);
    ParamByName('REVNO').AsFloat := lKey;
    if not(aParentRev = '') then
    begin
      ParamByName('PARENTREV').AsFloat := StrToFloat(aParentRev);
      ParamByName('LV').AsInteger := 1;
    end
    else
      ParamByName('LV').AsInteger := 0;

    ParamByName('RECNO').AsFloat := StrToFloat(FRecNo);
    ParamByName('STATUS').AsInteger := 0;
    ParamByName('PURPOSE').AsString := purpose.Text;
    ParamByName('TARGETTIME').AsFloat := targetTime.AsInteger;
    ParamByName('REMARK').AsString := remark.Text;


    ParamByName('REGID').AsString := CurrentUsers;
    ParamByName('REGDATE').AsDateTime := Now;

    ParamByName('PARTNAME').AsString := partName.Text;
    ExecSQL;
    Add_Durability_Images(lKey);
    Result := True;
  end;
end;

procedure TaddDurability_Frm.Button1Click(Sender: TObject);
var
  LForm : Tprogress_Frm;
begin
  LForm := Tprogress_Frm.Create(nil);
  LForm.Show;
  Parallel.Async(
    procedure
    begin
      save_routine;
    end,
    Parallel.TaskConfig.OnTerminated(
      procedure(const task:IOmniTaskControl)
      begin
        sleep(1000);
        FreeAndNil(LForm);
      end
    )
  );
end;

procedure TaddDurability_Frm.Button2Click(Sender: TObject);
var
  LPath : String;
  li : integer;
  lcnt : integer;
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

          Add;
          lcnt := GDIPPictureContainer1.Items.Count-1;
          Items[lcnt].Picture.LoadFromFile(LPath);
          Items[lcnt].Name := ExtractFileName(LPath);

          with imglist.Tiles do
            Add;
        end;
      finally
        if Count > 0 then
        begin
          imgList.PageIndex := 0;
          imgList.Tiles.Items[0].Content.Image.Assign(Items[0].Picture);
        end;
        EndUpdate;
      end;
    end;
  end;
end;

procedure TaddDurability_Frm.Button3Click(Sender: TObject);
var
  idx : integer;
begin
  with ImgList do
  begin
    if SelectedTile <> nil then
    begin
      if GDIPPictureContainer1.Items.Count > 0 then
      begin
        try
          Tiles.Delete(PageIndex);
          GDIPPictureContainer1.Items.Delete(PageIndex);
        finally
          if GDIPPictureContainer1.Items.Count > 0 then
          begin
            idx := PageIndex-1;
            if idx > -1 then
            begin
              Tiles.Items[idx].Content.Image.Assign(GDIPPictureContainer1.Items[idx].Picture);
              ImgList.PageIndex := idx;
            end;
          end;
        end;
      end;
    end
    else
      ShowMessage('선택된 이미지가 없습니다.');
  end;
end;

procedure TaddDurability_Frm.Button6Click(Sender: TObject);
begin
  Close;
end;

procedure TaddDurability_Frm.editTypeClick(Sender: TObject);
begin
  case editType.ItemIndex of
    0 : Button1.Caption := '신규등록';
    1 : Button1.Caption := '내용수정';
  end;
end;

procedure TaddDurability_Frm.Get_Image_from_DB(aRevNo: String);
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
        SQL.Add('select * from HIMSEN_DURABILITY_IMAGES ' +
                'where REVNO = '+aRevNo+' order by IMGNO');
        Open;

        if not(RecordCount = 0) then
        begin
          for li := 0 to RecordCount-1 do
          begin
            if FieldByName('IMAGES').IsBlob then
            begin
              LMS := TMemoryStream.Create;
              try
                (FieldByName('IMAGES') as TBlobField).SaveToStream(LMS);
                add;
                Items[Count-1].Name := FieldByName('IMGNAME').AsString;
                Items[Count-1].Picture.LoadFromStream(LMS);
                ImgList.Tiles.Add;
              finally
                FreeAndNil(LMS);
              end;
            end;
            Next;
          end;
        end;
      end;
    finally
      if ImgList.Tiles.Count > 0 then
        ImgList.Tiles.Items[0].Content.Image.Assign(Items[0].Picture);
      EndUpdate;
    end;
  end;
end;

procedure TaddDurability_Frm.ImgListPageChanged(Sender: TObject;
  PageIndex: Integer);
var
  li : integer;
begin
  with imgList.Tiles do
  begin
    BeginUpdate;
    try
      for li := 0 to Count-1 do
        Items[li].Content.Image.Assign(nil);

      if PageIndex > -1 then
        Items[PageIndex].Content.Image.Assign(GDIPPictureContainer1.Items[PageIndex].Picture);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TaddDurability_Frm.Save_routine;
begin
  if purpose.Text = '' then
  begin
    ShowMessage('시험 목적을 입력하여 주십시오!');
    Exit;
  end;

  if targetTime.AsInteger <= 0 then
  begin
    case editType.ItemIndex of
      0 : begin
            if FUpdateInfo.ParentRev > 0 then
              ShowMessage('경과시간을 입력하여 주십시오!')
            else
              ShowMessage('목표시간을 입력하여 주십시오!')


          end;
      1 : ShowMessage('경과시간을 입력하여 주십시오!');
    end;
    Exit;
  end;

  case editType.ItemIndex of
    0 : begin
          if Add_new_Durability_Item(FRecNo,FParentRev) = True then
            ModalResult := mrOk
          else
            ShowMessage('내구성 품목 등록 실패!');
        end;
    1 : begin
          if Update_Items(FUpdateInfo.RevisionNo) = True then
            ModalResult := mrOk
          else
            ShowMessage('내구성 품목 수정 실패!');
        end;

  end;
end;

procedure TaddDurability_Frm.Show_Items(aRevNo:String; var aUpdateInfo:TUpdateInfo);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_DURABILITY_DESC V ' +
            'where REVNO = '+aRevNo);
    Open;

    if not(RecordCount = 0) then
    begin
      partName.Text := FieldByName('PARTNAME').AsString;
      purpose.Text  := FieldByName('PURPOSE').AsString;
      targetTime.AsInteger := FieldByName('TARGETTIME').AsInteger;
      remark.Text   := FieldByName('REMARK').AsString;

      with aUpdateInfo do
      begin
        RevisionNo := FieldByName('REVNO').AsFloat;
        ParentRev  := FieldByName('PARENTREV').AsFloat;
      end;
    end;
    Get_Image_from_DB(aRevNo);
  end;
end;

function TaddDurability_Frm.Update_Items(aRevNo: Double): Boolean;
var
  lResult : Boolean;

begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update HIMSEN_DURABILITY_DESC Set ' +
            'PURPOSE = :PURPOSE, TARGETTIME = :TARGETTIME, REMARK = :REMARK, '+
            'STATUS = 0, MODID = :MODID, REGDATE = :REGDATE ' +
            'where REVNO = '+FloatToStr(aRevNo));

    ParamByName('PURPOSE').AsString := purpose.text;
    ParamByName('TARGETTIME').AsInteger := targetTime.AsInteger;
    ParamByName('REMARK').AsString := remark.Text;
    ParamByName('MODID').AsString := CurrentUsers;
    ParamByName('REGDATE').AsDateTime := Now;
    ExecSQL;
    lResult := True;
  end;

  if lResult = True then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Delete From HIMSEN_DURABILITY_IMAGES ' +
              'where REVNO = '+FloatToStr(aRevNo));
      ExecSQL;
    end;
    Add_Durability_Images(aRevNo);
    Result := True;
  end;
end;

end.
