unit equipment_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NxEdit, AdvSmoothTileList,
  NxCollection, AdvGlowButton, Vcl.Imaging.jpeg, Vcl.ExtCtrls,DB, DBTables,
  GDIPPictureContainer, Vcl.ExtDlgs, AdvSmoothTileListImageVisualizer,
  AdvSmoothTileListHTMLVisualizer, JvExStdCtrls, JvCombobox, Ora;

type
  Tequipment_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    Panel3: TPanel;
    Panel4: TPanel;
    regBtn: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    NxHeaderPanel1: TNxHeaderPanel;
    NxHeaderPanel2: TNxHeaderPanel;
    ImgList: TAdvSmoothTileList;
    Label1: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Button6: TButton;
    Label5: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    GDIPPictureContainer1: TGDIPPictureContainer;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    eqCode: TNxEdit;
    eqMaker: TNxEdit;
    eqName: TNxEdit;
    eqStd: TNxEdit;
    Label3: TLabel;
    eqNo: TNxEdit;
    eqType: TJvComboBox;
    Label2: TLabel;
    eqLocation1: TJvComboBox;
    Label6: TLabel;
    eqLocation2: TNxEdit;
    procedure Button6Click(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure regBtnClick(Sender: TObject);
    procedure eqTypeDropDown(Sender: TObject);
    procedure eqTypeSelect(Sender: TObject);
    procedure eqLocation1DropDown(Sender: TObject);
    procedure eqLocation1Select(Sender: TObject);
  private
    { Private declarations }
    FEQUIPNO : String;
    FeqType : Integer;
    FChanged : Boolean;
    FChangedImg : Boolean;
  public
    { Public declarations }
    procedure Get_HiTEMS_EQUIP_LIST(aEquipNo:String);
    procedure Insert_HiTEMS_EQUIP_LIST;
    procedure Update_HiTEMS_EQUIP_LIST(aEQUIPNO:String);

    function Get_LOC_NAME(aLOC_CODE:String) : String;
  end;

var
  equipment_Frm: Tequipment_Frm;
  function Create_equipment(aType:Integer;aCode:String) : Boolean;



implementation
uses
  HiTEMS_TRC_COMMON,
  CommonUtil_Unit,
  findUser_Unit,
  DataModule_Unit;


{$R *.dfm}

function Create_equipment(aType:Integer;aCode:String) : Boolean;
begin
  equipment_Frm := Tequipment_Frm.Create(nil);
  try
    with equipment_Frm do
    begin
      FChanged := False;
      FChangedImg := False;
      FeqType := aType;

      if aCode <> '' then
      begin
        regBtn.Caption := '수정하기';
        FEQUIPNO := aCode;
        Get_HiTEMS_EQUIP_LIST(FEQUIPNO);
      end
      else
      begin
        regBtn.Caption := '신규등록';
      end;

      ShowModal;


      Result := FChanged;
    end;
  finally
    FreeAndNil(equipment_Frm);

  end;
end;

procedure Tequipment_Frm.AdvGlowButton2Click(Sender: TObject);
begin
  Close;
end;

procedure Tequipment_Frm.Button6Click(Sender: TObject);
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
      Clear;
      try
        LPath := OpenPictureDialog1.FileName;
        lname := ExtractFileName(LPath);

        Add;
        lcnt := GDIPPictureContainer1.Items.Count-1;
        Items[lcnt].Picture.LoadFromFile(LPath);
        Items[lcnt].Name := lname;

        with imglist.Tiles do
        begin
          BeginUpdate;
          Clear;
          try
            Add;
            imgList.Tiles.Items[Count-1].Content.Image.Assign(GDIPPictureContainer1.Items[lcnt].Picture);
          finally
            EndUpdate;
          end;
        end;
      finally
        if Count > 0 then
        begin
          FChangedImg := True;
          imgList.PageIndex := Count-1;
        end;
      end;
    end;
  end;
end;

procedure Tequipment_Frm.Get_HiTEMS_EQUIP_LIST(aEquipNo: String);
var
  tmpBlob : TBlobStream;
  LMS : TMemoryStream;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM HiTEMS_EQUIP_LIST A, HiTEMS_EQUIP_TYPE B ' +
            'WHERE A.EQUIPNO = '''+aEquipNo+''' ' +
            'AND A.EQTYPE = B.TYPECODE ');
    Open;

    if RecordCount <> 0 then
    begin
      eqType.Text  := FieldByName('TYPENAME').AsString;
      eqCode.Text  := FieldByName('TYPECODE').AsString;
      eqNo.Text    := FieldByName('EQNO').AsString;
      eqMaker.Text := FieldByName('EQMAKER').AsString;
      eqName.Text  := FieldByName('EQNAME').AsString;
      eqSTD.Text   := FieldByName('EQSTD').AsString;
      eqLocation1.Text := Get_LOC_NAME(FieldByName('EQLOCATION1').AsString);
      eqLocation2.Text := FieldByName('EQLOCATION2').AsString;

      with GDIPPictureContainer1.Items do
      begin
        BeginUpdate;
        Clear;
        try
          LMS := TMemoryStream.Create;
          try
            LMS.Clear;
            LMS.Position := 0;
            if FieldByName('EQIMG').IsBlob then
            begin
              (FieldByName('EQIMG') as TBlobField).SaveToStream(LMS);
              add;
//              Items[Count-1].Name := FieldByName('LCFILENAME').AsString;
              Items[Count-1].Picture.LoadFromStream(LMS);

              with imglist.Tiles do
              begin
                BeginUpdate;
                try
                  Add;
                  imgList.Tiles.Items[0].Content.Image.Assign(GDIPPictureContainer1.Items[0].Picture);
                finally
                  EndUpdate;
                end;
              end;
            end;
          finally
            FreeAndNil(LMS);
          end;
        finally
          if Count > 0 then
            imgList.PageIndex := 0;
          EndUpdate;
        end;
      end;
    end;
  end;
end;

function Tequipment_Frm.Get_LOC_NAME(aLOC_CODE: String): String;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.TSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM HITEMS_LOC_CODE ' +
              'WHERE LOC_CODE = :param1 ');
      ParamByName('param1').AsString := aLOC_CODE;
      Open;

      Result := FieldByName('LOC_NAME').AsString;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure Tequipment_Frm.Insert_HiTEMS_EQUIP_LIST;
var
  lms : TMemoryStream;
begin
  lms := TMemoryStream.Create;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert Into HiTEMS_EQUIP_LIST ' +
              'values(:EQUIPNO, :EQTYPE, :EQNO, :EQMAKER, :EQNAME, ' +
              ':EQSTD, :EQLOCATION1, :EQLOCATION2, :EQIMG)');

      ParamByName('EQUIPNO').AsString     := eqCode.Text+eqNo.Text;
      ParamByName('EQTYPE').AsString      := eqCode.Text;
      ParamByName('EQNO').AsString        := eqNo.Text;
      ParamByName('EQMAKER').AsString     := eqMaker.Text;
      ParamByName('EQNAME').AsString      := eqName.Text;

      ParamByName('EQSTD').AsString       := eqStd.Text;
      ParamByName('EQLOCATION1').AsString := eqLocation1.Hint;
      ParamByName('EQLOCATION2').AsString := eqLocation2.Text;

      if FChangedImg = True then
      begin
        lms.Clear;
        lms.Position := 0;
        GDIPPictureContainer1.Items[0].Picture.SaveToStream(lms);

        ParamByName('EQIMG').ParamType := ptInput;
        ParamByName('EQIMG').AsOraBlob.LoadFromStream(lms);
      end;

      ExecSQL;

    end;
  finally
    FreeAndNil(lms);
  end;
end;

procedure Tequipment_Frm.eqLocation1DropDown(Sender: TObject);
begin
  with eqLocation1.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_LOC_CODE ');
        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('LOC_NAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure Tequipment_Frm.eqLocation1Select(Sender: TObject);
begin
  with DM1.OraQuery1 do
  begin
    First;
    while not eof do
    begin
      if SameText(eqLocation1.Text,FieldByName('LOC_NAME').AsString) then
      begin
        eqLocation1.Hint := FieldByName('LOC_CODE').AsString;
        Break;
      end;
      Next;
    end;
  end;
end;

procedure Tequipment_Frm.eqTypeDropDown(Sender: TObject);
begin
  with eqType.Items do
  begin
    BeginUpdate;
    try
      Clear;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS_EQUIP_TYPE ' +
                'ORDER BY TYPENAME ');
        Open;

        Add('');
        while not eof do
        begin
          Add(FieldByName('TYPENAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure Tequipment_Frm.eqTypeSelect(Sender: TObject);
var
  lcodeNo : Double;
begin
  if eqType.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      First;

      while not eof do
      begin
        if SameText(eqType.Text, FieldByName('TYPENAME').AsString) then
        begin
          eqCode.Text := FieldByName('TYPECODE').AsString;

          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM HITEMS_EQUIP_LIST ' +
                  'WHERE EQTYPE = :param1 ');
          ParamByName('param1').AsString := eqCode.Text;
          Open;

          if RecordCount <> 0 then
            lcodeNo := RecordCount+1
          else
            lcodeNo := 1;

          Break;
        end;
        Next;
      end;
    end;
    eqNo.Text := FormatFloat('0000',lcodeNo);
  end;
end;

procedure Tequipment_Frm.regBtnClick(Sender: TObject);
begin
  FChanged := True;

  if regBtn.Caption = '신규등록' then
  begin
    Insert_HiTEMS_EQUIP_LIST;

  end else
  begin
    Update_HiTEMS_EQUIP_LIST(FEQUIPNO);

  end;
  ShowMessage(Format('%s 성공!',[regBtn.caption]));
  Close;

end;

procedure Tequipment_Frm.Update_HiTEMS_EQUIP_LIST(aEQUIPNO:String);
var
  lregNo : Double;
  lms : TMemoryStream;
begin
  lms := TMemoryStream.Create;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE HiTEMS_EQUIP_LIST SET ' +
              'EQUIPNO = :EQUIPNO, EQTYPE = :EQTYPE, EQNO = :EQNO, ' +
              'EQMAKER = :EQMAKER, EQNAME = :EQNAME, EQSTD = :EQSTD, ' +
              'EQLOCATION1 = :EQLOCATION1, EQLOCATION2 = :EQLOCATION2');

      ParamByName('EQUIPNO').AsString     := eqCode.Text+eqNo.Text;
      ParamByName('EQTYPE').AsString      := eqCode.Text;
      ParamByName('EQNO').AsString        := eqNo.Text;
      ParamByName('EQMAKER').AsString     := eqMaker.Text;
      ParamByName('EQNAME').AsString      := eqName.Text;

      ParamByName('EQSTD').AsString       := eqStd.Text;
      ParamByName('EQLOCATION1').AsString := eqLocation1.Hint;
      ParamByName('EQLOCATION2').AsString := eqLocation2.Text;

      if FChangedImg = True then
      begin
        SQL.Add(',EQIMG = :EQIMG ');

        lms.Clear;
        lms.Position := 0;
        GDIPPictureContainer1.Items[0].Picture.SaveToStream(lms);

        ParamByName('EQIMG').ParamType := ptInput;
        ParamByName('EQIMG').AsOraBlob.LoadFromStream(lms);
      end;

      SQL.Add('WHERE EQUIPNO = '''+aEQUIPNO+''' ' );

      ExecSQL;

    end;
  finally
    FreeAndNil(lms);
  end;
end;

end.
