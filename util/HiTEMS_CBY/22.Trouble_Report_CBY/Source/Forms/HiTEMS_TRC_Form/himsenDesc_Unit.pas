unit himsenDesc_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, NxCollection, StdCtrls, NxEdit, AdvGroupBox,DBTables,
  AdvOfficeButtons, Vcl.ExtDlgs, DB, Vcl.Imaging.jpeg, AdvSmoothTileList,
  GDIPPictureContainer, AdvSmoothTileListImageVisualizer,
  AdvSmoothTileListHTMLVisualizer, Generics.Collections;

type
  ThimsenDesc_Frm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel3: TPanel;
    Button6: TButton;
    Panel4: TPanel;
    NxHeaderPanel2: TNxHeaderPanel;
    Button8: TButton;
    Button3: TButton;
    Button2: TButton;
    Panel5: TPanel;
    TEAM: TAdvOfficeRadioGroup;
    Panel6: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    ENGIN: TNxDatePicker;
    Panel12: TPanel;
    Panel10: TPanel;
    ENGOUT: TNxDatePicker;
    Panel11: TPanel;
    PROJNO: TNxEdit;
    Panel13: TPanel;
    PROJNAME: TNxEdit;
    Panel14: TPanel;
    Panel15: TPanel;
    SHIPNO: TNxEdit;
    Panel16: TPanel;
    SHIPNAME: TNxEdit;
    Panel17: TPanel;
    Panel18: TPanel;
    ENGMODEL: TNxEdit;
    Panel19: TPanel;
    ENGTYPE: TNxEdit;
    Panel20: TPanel;
    ENGPROJ: TNxEdit;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    DESIGNID: TNxEdit;
    Panel24: TPanel;
    DESIGNM: TNxEdit;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    CYLNUM: TNxNumberEdit;
    BORE: TNxNumberEdit;
    STROKE: TNxNumberEdit;
    RPM: TNxNumberEdit;
    FREQ: TNxNumberEdit;
    MCR: TNxNumberEdit;
    Panel33: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    TESTBED: TNxComboBox;
    Panel7: TPanel;
    ESTATUS: TNxComboBox;
    LBXNO: TNxNumberEdit;
    Panel37: TPanel;
    Panel39: TPanel;
    FIRING: TNxEdit;
    Panel40: TPanel;
    Panel41: TPanel;
    CRV: TNxNumberEdit;
    Panel38: TPanel;
    ROTATE: TNxComboBox;
    ENGARR: TNxComboBox;
    Panel42: TPanel;
    Panel43: TPanel;
    MAINBN: TNxNumberEdit;
    Panel44: TPanel;
    Panel45: TPanel;
    CAMBN: TNxNumberEdit;
    Panel46: TPanel;
    BIGBN: TNxNumberEdit;
    Panel47: TPanel;
    SMALLBN: TNxNumberEdit;
    Panel48: TPanel;
    Panel49: TPanel;
    DIMA: TNxNumberEdit;
    Panel50: TPanel;
    Panel51: TPanel;
    DIMB: TNxNumberEdit;
    Panel52: TPanel;
    DIMC: TNxNumberEdit;
    Panel53: TPanel;
    DIMD: TNxNumberEdit;
    Panel54: TPanel;
    Panel55: TPanel;
    OWNER_: TNxEdit;
    Panel56: TPanel;
    CLASS_: TNxEdit;
    Panel57: TPanel;
    MEASID: TNxEdit;
    MEASNM: TNxEdit;
    OPTYPE: TNxComboBox;
    SITE: TNxComboBox;
    Label1: TLabel;
    Panel58: TPanel;
    TAT: TNxDatePicker;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel61: TPanel;
    Image2: TImage;
    GDIPPictureContainer1: TGDIPPictureContainer;
    ImgList: TAdvSmoothTileList;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OPTYPEButtonDown(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure MEASIDChange(Sender: TObject);
    procedure DESIGNIDChange(Sender: TObject);
    procedure MEASNMClick(Sender: TObject);
    procedure DESIGNMClick(Sender: TObject);
  private
    { Private declarations }
    FFirst : Boolean;
    FChaged : Boolean;
  public
    { Public declarations }

    FProjNo : String;
    procedure Initialize_for_Input_Item;
    procedure Save_for_Himsen_General_Infomation;
    procedure Update_Himsen_Generaal_Infomation;
    procedure Remove_Himsen_General_Info(FPROJNO:String);

    procedure Get_General_info_From_DB(FProj:String);
    function Check_for_Must_input_item_values : String;
  end;

var
  himsenDesc_Frm: ThimsenDesc_Frm;
  function Create_himsenDesc(aProjNo:String):Boolean;

implementation
uses
  findUser_Unit,
  HiTEMS_TRC_COMMON,
  DataModule_Unit,
  Main_Unit;

{$R *.dfm}

{ TEngDesc_Frm }
function Create_himsenDesc(aProjNo:String):Boolean;
begin
  himsenDesc_Frm := ThimsenDesc_Frm.Create(nil);
  try
    with himsenDesc_Frm do
    begin
      FChaged := False;
      if aProjNo <> '' then
        Get_General_info_From_DB(aProjNo);

      ShowModal;

      Result := FChaged;

    end;
  finally
    FreeAndNil(himsenDesc_Frm);
  end;
end;

procedure ThimsenDesc_Frm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure ThimsenDesc_Frm.Button3Click(Sender: TObject);
begin
  Initialize_for_Input_Item;
end;

procedure ThimsenDesc_Frm.Button6Click(Sender: TObject);
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
        Clear;
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

procedure ThimsenDesc_Frm.Button8Click(Sender: TObject);
var
  LMsg : String;
  li : integer;
begin
  LMsg := Check_for_Must_input_item_values;
  if LMsg = '' then
  begin
    If MessageDlg('입력된 정보를 저장 하시겠습니까?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
    begin
      with DM1.OraQuery2 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HiTEMS.HIMSEN_INFO where PROJNO = '''+PROJNo.Text+''' ');
        Open;

        if not(RecordCount = 0) then
          li := RecordCount
        else
          li := 0;
      end;

      if li > 0 then
      begin
        Update_Himsen_Generaal_Infomation;
      end
      else
        Save_for_Himsen_General_Infomation;

      FChaged := True;
    end;
  end
  else
    ShowMessage(LMsg);
end;

function ThimsenDesc_Frm.Check_for_Must_input_item_values: String;
begin
  Result := '';

  if Team.ItemIndex < 0 then
  begin
    Result := '엔진 관리팀을 선택하여 주십시오';
    Exit;
  end;

  if EStatus.Text = '' then
  begin
    Result := '엔진 상황을 선택하여 주십시오';
    Exit;
  end;

  if EngType.Text = '' then
  begin
    Result := '엔진타입을 입력하여 주십시오';
    Exit;
  end;

  if CRV.Value = 0 then
  begin
    Result := 'Crankcase Relief V/V 탑재 수를 넣어 주십시오';
    Exit;
  end;

  if MainBn.Value = 0 then
  begin
    Result := 'Main Bearing 수를 넣어 주십시오';
    Exit;
  end;

  if CamBn.Value = 0 then
  begin
    Result := 'Camshaft Bearing 수를 넣어 주십시오';
    Exit;
  end;

  if BigBn.Value = 0 then
  begin
    Result := 'Big-End Bearing 수를 넣어 주십시오';
    Exit;
  end;

  if SmallBn.Value = 0 then
  begin
    Result := 'Small-End Bearing 수를 넣어 주십시오';
    Exit;
  end;
end;

procedure ThimsenDesc_Frm.DESIGNIDChange(Sender: TObject);
begin
  if DESIGNID.Text <> '' then
    DESIGNM.Text := Return_UserName(DESIGNID.Text)
  else
    DESIGNM.Clear;
end;

procedure ThimsenDesc_Frm.DESIGNMClick(Sender: TObject);
var
  lResult : String;
begin
  lResult := Create_findUser_Frm(DESIGNID.Text,'A');
  if lResult <> '' then
    DESIGNID.Text:= lResult
  else
    DESIGNID.Clear;
end;

procedure ThimsenDesc_Frm.FormActivate(Sender: TObject);
begin
  if FFirst = True then
  begin
    FFirst := False;

    if not(FProjNo = '') then
    begin
      Get_General_info_From_DB(FProjNo);


    end;
  end;
end;

procedure ThimsenDesc_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure ThimsenDesc_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;
  Initialize_for_Input_Item;
end;

procedure ThimsenDesc_Frm.Get_General_info_From_DB(FProj:String);
var
  li : integer;
  LStr : String;
  tmpBlob : TBlobStream;
  LMS : TMemoryStream;
  LDCList: TDictionary<string, string>;
  LDeptCode: string;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HiTEMS.HIMSEN_INFO where PROJNO = :param1');
    parambyname('param1').AsString := FProj;
    Open;

    if RecordCount <> 0 then
    begin
      LStr := Fieldbyname('TEAM').AsString;

      LDCList := TDeptUsers.Instance.GetDeptCodeList;
      li := 0;

      for LDeptCode in LDCList.Keys do
      begin
        if LStr = LDeptCode then
          break;

        inc(li);
      end;

      Team.ItemIndex := li;

{      if LStr = 'K2B3-1' then
        Team.ItemIndex := 0
      else if LStr = 'K2B3-2' then
        Team.ItemIndex := 1
      else if LStr = 'K2B3-3' then
        Team.ItemIndex := 2;
 }
      EStatus.ItemIndex   := Fieldbyname('STATUS').AsInteger;

      EngIn.Date          := Fieldbyname('EngIn').AsDateTime;

      if not (FieldByName('EngOut').IsNull = True) then
        EngOut.Date            := Fieldbyname('EngOut').AsDateTime
      else
        EngOut.Text := '';

      PROJNO.Text         := Fieldbyname('PROJNO').AsString;

      PROJNAME.Text       := Fieldbyname('PROJNAME').AsString;
      SHIPNO.Text         := Fieldbyname('SHIPNO').AsString;
      SHIPNAME.Text       := Fieldbyname('SHIPNAME').AsString;
      ENGMODEL.Text       := Fieldbyname('ENGMODEL').AsString;
      ENGTYPE.Text        := Fieldbyname('ENGTYPE').AsString;

      ENGPROJ.Text        := Fieldbyname('ENGPROJ').AsString;
      OWNER_.Text         := Fieldbyname('OWNER').AsString;
      CLASS_.Text         := Fieldbyname('CLASS').AsString;
      SITE.Text           := Fieldbyname('SITE').AsString;

      OPTYPE.Text         := Fieldbyname('OPTYPE').AsString;

      MEASID.Text         := Fieldbyname('MEASP').AsString;
      DESIGNID.Text       := Fieldbyname('DESIGNP').AsString;
      CYLNUM.Value        := Fieldbyname('CYLNUM').AsFloat;
      BORE.Value          := Fieldbyname('BORE').AsFloat;
      STROKE.Value        := Fieldbyname('STROKE').AsFloat;

      RPM.Value           := Fieldbyname('RPM').AsFloat;
      FREQ.Value          := Fieldbyname('FREQUENCY').AsFloat;
      MCR.Value           := Fieldbyname('MCR').AsFloat;
      ENGARR.Text         := Fieldbyname('ENGARR').AsString;
      TestBed.Text        := Fieldbyname('TESTBED').AsString;

      LBXNO.Value         := Fieldbyname('LBXNO').AsFloat;
      FIRING.Text         := Fieldbyname('FIRING').AsString;
      ROTATE.Text         := Fieldbyname('ROTATING').AsString;
      CRV.Value           := Fieldbyname('CRVNUM').AsFloat;
      MainBN.Value        := Fieldbyname('MAINBN').AsFloat;

      CamBn.Value         := Fieldbyname('CAMBN').AsFloat;
      BigBn.Value         := Fieldbyname('BIGN').AsFloat;
      SmallBn.Value       := Fieldbyname('SMALLN').AsFloat;
      DimA.Value          := Fieldbyname('DIMENSIONA').AsFloat;
      DimB.Value          := Fieldbyname('DIMENSIONB').AsFloat;

      DimC.Value          := Fieldbyname('DIMENSIONC').AsFloat;
      DimD.Value          := Fieldbyname('DIMENSIOND').AsFloat;


      with GDIPPictureContainer1.Items do
      begin
        BeginUpdate;
        Clear;
        try
          LMS := TMemoryStream.Create;
          try
            LMS.Clear;
            LMS.Position := 0;
            if FieldByName('ENGVIEW').IsBlob then
            begin
              (FieldByName('ENGVIEW') as TBlobField).SaveToStream(LMS);
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

      if not (FieldByName('TAT').IsNull = True) then
        TAT.Date            := Fieldbyname('TAT').AsDateTime
      else
        TAT.Text := '';

    end;
  end;
end;

procedure ThimsenDesc_Frm.Initialize_for_Input_Item;
var
  LList: TList<string>;
  LDCList: TDictionary<string, string>;
  LDeptCode: string;
  i: integer;
begin
  LDCList := TDeptUsers.Instance.GetDeptCodeList;
  Team.Items.Clear;
  LList := TList<string>.Create(LDCList.Keys);
  try
    LList.Sort;

    for i := 0 to LList.Count - 1 do
    begin
      LDeptCode := LList.Items[i];
      Team.Items.Add(TDeptUsers.Instance.GetDeptNameFromCode(LDeptCode));
    end;
  finally
    FreeAndNil(LList);
  end;

  Team.ItemIndex := -1;

  EStatus.Clear;

  EngIn.Clear;
  EngOut.Clear;

  PROJNO.Clear;

  PROJNAME.Clear;
  SHIPNO.Clear;
  SHIPNAME.Clear;
  ENGMODEL.Clear;
  ENGTYPE.Clear;

  ENGPROJ.Clear;
  OWNER_.Clear;
  CLASS_.Clear;
  SITE.Clear;

  OPTYPE.Clear;

  MEASID.Clear;
  DESIGNID.Clear;
  CYLNUM.Clear;
  BORE.Clear;
  STROKE.Clear;

  RPM.Clear;
  FREQ.Clear;
  MCR.Clear;
  ENGARR.Clear;
  TestBed.Clear;

  LBXNO.Value;
  FIRING.Clear;
  ROTATE.Clear;
  CRV.Clear;
  MainBN.Clear;

  CamBn.Clear;
  BigBn.Clear;
  SmallBn.Clear;
  DimA.Clear;
  DimB.Clear;

  DimC.Clear;
  DimD.Clear;
  TAT.Clear;
end;

procedure ThimsenDesc_Frm.MEASIDChange(Sender: TObject);
begin
  if MEASID.Text <> '' then
    MEASNM.Text := Return_UserName(MEASID.Text)
  else
    MEASNM.Clear;
end;

procedure ThimsenDesc_Frm.MEASNMClick(Sender: TObject);
var
  lResult : String;
begin
  lResult := Create_findUser_Frm(MEASID.Text,'A');
  if lResult <> '' then
    MEASID.Text:= lResult
  else
    MEASID.Clear;
end;

procedure ThimsenDesc_Frm.OPTYPEButtonDown(Sender: TObject);
begin
  OPTYPE.Items.Clear;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select A.*, B.CODENM from ZHITEMSCDGRPCD A, ZHITEMSCODE B');
    SQL.Add('where A.CDGRP = ''E02'' and DELYN = 0 and A.CODE = B.CODE');
    SQL.Add('order by A.SortOdr');
    Open;

    if not(RecordCount = 0) then
    begin
      while not Eof do
      begin
        OPTYPE.Items.Add(Fieldbyname('CODENM').AsString);
        Next;
      end;
    end;
  end;
end;

procedure ThimsenDesc_Frm.Remove_Himsen_General_Info(FPROJNO: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From HiTEMS.HIMSEN_INFO where PROJNO = :param1');
    parambyname('param1').AsString := FPROJNO;
    ExecSQL;
  end;
end;

procedure ThimsenDesc_Frm.Save_for_Himsen_General_Infomation;
var
  MS : TMemoryStream;
  LSQL : String;
  LStr : String;
begin

  LSQL := 'Insert into HiTEMS.HIMSEN_INFO ' +
          'Values(:TEAM,:STATUS,:ENGIN,:ENGOUT,:PROJNO,:PROJNAME,:SHIPNO,:SHIPNAME,:ENGMODEL,:ENGTYPE,:ENGPROJ,:OWNER,:CLASS,' +
          ':SITE,:OPTYPE,:MEASP,:DESIGNP,:CYLNUM,:BORE,:STROKE,:RPM,:FREQUENCY,:MCR,:ENGARR,:TESTBED,:LBXNO,:FIRING,' +
          ':ROTATING,:CRVNUM,:MAINBN,:CAMBN,:BIGN,:SMALLN,:DIMENSIONA,:DIMENSIONB,:DIMENSIONC,:DIMENSIOND,:ENGVIEW,:TAT)';

  with DM1.OraQuery2 do
  begin
    Options.TemporaryLobUpdate := True;
    Close;
    SQL.Clear;
    SQL.Add(LSQL);

    try
      parambyname('TEAM').AsString        := TEAM.Items.Strings[TEAM.ItemIndex];
      parambyname('STATUS').AsInteger     := ESTATUS.ItemIndex;

      parambyname('ENGIN').AsDateTime         := EngIn.Date;

      if not(EStatus.ItemIndex = 0) then
        parambyname('ENGOUT').AsDateTime      := EngOut.Date;

      parambyname('PROJNO').AsString      := PROJNO.Text;

      parambyname('PROJNAME').AsString    := PROJNAME.Text;
      parambyname('SHIPNO').AsString      := SHIPNO.Text;
      parambyname('SHIPNAME').AsString    := SHIPNAME.Text;
      parambyname('ENGMODEL').AsString    := ENGMODEL.Text;
      parambyname('ENGTYPE').AsString     := ENGTYPE.Text;

      parambyname('ENGPROJ').AsString     := ENGPROJ.Text;
      parambyname('OWNER').AsString       := OWNER_.Text;
      parambyname('CLASS').AsString       := CLASS_.Text;
      parambyname('SITE').AsString        := SITE.Text;

      parambyname('OPTYPE').AsString      := OPTYPE.Text;

      parambyname('MEASP').AsString       := MEASID.Text;
      parambyname('DESIGNP').AsString     := DESIGNID.Text;
      parambyname('CYLNUM').AsFloat       := CYLNUM.Value;
      parambyname('BORE').AsFloat         := BORE.Value;
      parambyname('STROKE').AsFloat       := STROKE.Value;

      parambyname('RPM').AsFloat          := RPM.Value;
      parambyname('FREQUENCY').AsFloat    := FREQ.Value;
      parambyname('MCR').AsFloat          := MCR.Value;
      parambyname('ENGARR').AsString      := ENGARR.Text;
      parambyname('TESTBED').AsString     := TestBed.Text;

      parambyname('LBXNO').AsFloat        := LBXNO.Value;
      parambyname('FIRING').AsString      := FIRING.Text;
      parambyname('ROTATING').AsString    := ROTATE.Text;
      parambyname('CRVNUM').AsFloat       := CRV.Value;
      parambyname('MAINBN').AsFloat       := MainBN.Value;

      parambyname('CAMBN').AsFloat        := CamBn.Value;
      parambyname('BIGN').AsFloat         := BigBn.Value;
      parambyname('SMALLN').AsFloat       := SmallBn.Value;
      parambyname('DIMENSIONA').AsFloat   := DimA.Value;
      parambyname('DIMENSIONB').AsFloat   := DimB.Value;

      parambyname('DIMENSIONC').AsFloat   := DimC.Value;
      parambyname('DIMENSIOND').AsFloat   := DimD.Value;


      MS := TMemoryStream.Create;
      if GDIPPictureContainer1.Items.Count > 0 then
      begin
        GDIPPictureContainer1.Items[0].Picture.SaveToStream(MS);

        parambyname('ENGVIEW').ParamType := ptInput;
        parambyname('ENGVIEW').AsOraBlob.LoadFromStream(MS);
      end;


      if NOT(TAT.Text = '') then
        parambyname('TAT').AsDateTime   := TAT.Date;

      ExecSQL;
      ShowMessage('엔진정보등록 성공');
    finally
      MS.Free;
    end;
  end;
end;

procedure ThimsenDesc_Frm.Update_Himsen_Generaal_Infomation;
var
  MS : TMemoryStream;
  BMP : TBitmap;
  LSQL : String;
  LStr : String;
begin
  with DM1.OraQuery2 do
  begin
    Options.TemporaryLobUpdate := True;
    Close;
    SQL.Clear;
    SQL.Add('Update HiTEMS.HIMSEN_INFO Set ');
    SQL.Add('TEAM = :TEAM, STATUS = :STATUS, ENGIN = :ENGIN, ENGOUT = :ENGOUT, ');
    SQL.Add('PROJNO = :PROJNO, PROJNAME = :PROJNAME, SHIPNO = :SHIPNO, ');
    SQL.Add('SHIPNAME = :SHIPNAME, ENGMODEL = :ENGMODEL, ENGTYPE = :ENGTYPE, ');
    SQL.Add('ENGPROJ = :ENGPROJ, OWNER = :OWNER, CLASS = :CLASS, ');
    SQL.Add('SITE = :SITE, OPTYPE = :OPTYPE, MEASP = :MEASP, DESIGNP = :DESIGNP, ');
    SQL.Add('CYLNUM = :CYLNUM, BORE = :BORE, STROKE = :STROKE, RPM = :RPM, ');
    SQL.Add('FREQUENCY = :FREQUENCY, MCR = :MCR, ENGARR = :ENGARR, ');
    SQL.Add('TESTBED = :TESTBED, LBXNO = :LBXNO, FIRING = :FIRING, ');
    SQL.Add('ROTATING = :ROTATING, CRVNUM = :CRVNUM, MAINBN = :MAINBN, ');
    SQL.Add('CAMBN = :CAMBN, BIGN = :BIGN, SMALLN = :SMALLN, ');
    SQL.Add('DIMENSIONA = :DIMENSIONA, DIMENSIONB = :DIMENSIONB, ');
    SQL.Add('DIMENSIONC = :DIMENSIONC, DIMENSIOND = :DIMENSIOND, ');
    SQL.add('ENGVIEW = :ENGVIEW, TAT = :TAT ');
    SQL.Add('where PROJNO = '''+PROJNO.Text+''' ');

    try
      case Team.ItemIndex of
        0 : LStr := 'K2B3-1';
        1 : LStr := 'K2B3-2';
        2 : LStr := 'K2B3-3';
      end;
      parambyname('TEAM').AsString        := LStr;

      parambyname('STATUS').AsInteger     := ESTATUS.ItemIndex;

      parambyname('ENGIN').AsDateTime     := EngIn.Date;

      if not(EStatus.ItemIndex = 0) then
        parambyname('ENGOUT').AsDateTime  := EngOut.Date;

      parambyname('PROJNO').AsString      := PROJNO.Text;

      parambyname('PROJNAME').AsString    := PROJNAME.Text;
      parambyname('SHIPNO').AsString      := SHIPNO.Text;
      parambyname('SHIPNAME').AsString    := SHIPNAME.Text;
      parambyname('ENGMODEL').AsString    := ENGMODEL.Text;
      parambyname('ENGTYPE').AsString     := ENGTYPE.Text;

      parambyname('ENGPROJ').AsString     := ENGPROJ.Text;
      parambyname('OWNER').AsString       := OWNER_.Text;
      parambyname('CLASS').AsString       := CLASS_.Text;
      parambyname('SITE').AsString        := SITE.Text;

      parambyname('OPTYPE').AsString      := OPTYPE.Text;

      parambyname('MEASP').AsString       := MEASID.Text;
      parambyname('DESIGNP').AsString     := DESIGNID.Text;
      parambyname('CYLNUM').AsFloat       := CYLNUM.Value;
      parambyname('BORE').AsFloat         := BORE.Value;
      parambyname('STROKE').AsFloat       := STROKE.Value;

      parambyname('RPM').AsFloat          := RPM.Value;
      parambyname('FREQUENCY').AsFloat    := FREQ.Value;
      parambyname('MCR').AsFloat          := MCR.Value;
      parambyname('ENGARR').AsString      := ENGARR.Text;
      parambyname('TESTBED').AsString     := TestBed.Text;

      parambyname('LBXNO').AsFloat        := LBXNO.Value;
      parambyname('FIRING').AsString      := FIRING.Text;
      parambyname('ROTATING').AsString    := ROTATE.Text;
      parambyname('CRVNUM').AsFloat       := CRV.Value;
      parambyname('MAINBN').AsFloat       := MainBN.Value;

      parambyname('CAMBN').AsFloat        := CamBn.Value;
      parambyname('BIGN').AsFloat         := BigBn.Value;
      parambyname('SMALLN').AsFloat       := SmallBn.Value;
      parambyname('DIMENSIONA').AsFloat   := DimA.Value;
      parambyname('DIMENSIONB').AsFloat   := DimB.Value;

      parambyname('DIMENSIONC').AsFloat   := DimC.Value;
      parambyname('DIMENSIOND').AsFloat   := DimD.Value;

      MS := TMemoryStream.Create;
      if GDIPPictureContainer1.Items.Count > 0 then
      begin
        GDIPPictureContainer1.Items[0].Picture.SaveToStream(MS);

        parambyname('ENGVIEW').ParamType := ptInput;
        parambyname('ENGVIEW').AsOraBlob.LoadFromStream(MS);
      end;

      if NOT(TAT.Text = '') then
        parambyname('TAT').AsDateTime   := TAT.Date;

      ExecSQL;
      ShowMessage('엔진정보등록 성공');
    finally
      MS.Free;
    end;
  end;
end;
end.
