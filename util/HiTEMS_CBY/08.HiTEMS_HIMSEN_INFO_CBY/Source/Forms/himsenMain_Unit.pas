unit himsenMain_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  AdvOfficeStatusBar, Vcl.StdCtrls, AeroButtons, JvExControls, JvLabel,
  Vcl.ExtDlgs, Vcl.ImgList, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, AdvGroupBox, AdvOfficeButtons,
  NxEdit, Vcl.ComCtrls, CurvyControls, AdvSmoothTileList,DB,Ora,StrUtils,
  AdvSmoothTileListImageVisualizer, AdvSmoothTileListHTMLVisualizer;

type
  ThimsenMain_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    ImageList16x16: TImageList;
    ImageList32x32: TImageList;
    OpenPictureDialog1: TOpenPictureDialog;
    JvLabel22: TJvLabel;
    btn_Close: TAeroButton;
    btn_Reg: TAeroButton;
    btn_Refrash: TAeroButton;
    btn_Del: TAeroButton;
    JvLabel2: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel11: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel9: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel12: TJvLabel;
    JvLabel13: TJvLabel;
    JvLabel14: TJvLabel;
    JvLabel15: TJvLabel;
    JvLabel16: TJvLabel;
    JvLabel23: TJvLabel;
    JvLabel24: TJvLabel;
    JvLabel25: TJvLabel;
    JvLabel28: TJvLabel;
    JvLabel31: TJvLabel;
    JvLabel42: TJvLabel;
    JvLabel27: TJvLabel;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    ImgList: TAdvSmoothTileList;
    JvLabel26: TJvLabel;
    JvLabel32: TJvLabel;
    JvLabel33: TJvLabel;
    JvLabel34: TJvLabel;
    JvLabel17: TJvLabel;
    JvLabel35: TJvLabel;
    JvLabel36: TJvLabel;
    Image2: TImage;
    grid_EngList: TNextGrid;
    btn_ImgAdd: TAeroButton;
    NxImageColumn1: TNxImageColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    btn_AddManager: TAeroButton;
    rg_Team: TAdvOfficeRadioGroup;
    cb_Status: TComboBox;
    et_engModel: TComboBox;
    et_EngType: TEdit;
    et_ProjNm: TEdit;
    et_ProjNo: TEdit;
    dt_EngIn: TDateTimePicker;
    dt_EngOut: TDateTimePicker;
    dt_TAT: TDateTimePicker;
    et_Manager: TEdit;
    et_ProjName: TEdit;
    et_ShipNo: TEdit;
    et_Owner: TEdit;
    et_ShipName: TEdit;
    cb_Operate: TComboBox;
    et_Freq: TNxNumberEdit;
    et_Rpm: TNxNumberEdit;
    et_Mcr: TNxNumberEdit;
    et_Bed: TEdit;
    et_NumCyl: TNxNumberEdit;
    et_Bore: TNxNumberEdit;
    et_Stroke: TNxNumberEdit;
    et_Class: TEdit;
    cb_Rotate: TComboBox;
    et_Firing: TEdit;
    cb_Arrange: TComboBox;
    CurvyPanel1: TCurvyPanel;
    Label1: TLabel;
    JvLabel30: TJvLabel;
    Label2: TLabel;
    JvLabel18: TJvLabel;
    JvLabel19: TJvLabel;
    JvLabel20: TJvLabel;
    JvLabel21: TJvLabel;
    et_NumCrv: TNxNumberEdit;
    et_NumMB: TNxNumberEdit;
    et_NumCS: TNxNumberEdit;
    et_NumBE: TNxNumberEdit;
    et_NumSE: TNxNumberEdit;
    et_DimA: TNxNumberEdit;
    et_DimC: TNxNumberEdit;
    et_DimB: TNxNumberEdit;
    et_DimH: TNxNumberEdit;
    et_DimD: TNxNumberEdit;
    cb_Site: TComboBox;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grid_EngListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grid_EngListCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure btn_RefrashClick(Sender: TObject);
    procedure btn_ImgAddClick(Sender: TObject);
    procedure btn_RegClick(Sender: TObject);
    procedure dt_EngInChange(Sender: TObject);
    procedure btn_AddManagerClick(Sender: TObject);
    procedure btn_DelClick(Sender: TObject);
    procedure et_engModelDropDown(Sender: TObject);
    procedure cb_SiteDropDown(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLoc_Code_List: TStringList;

    function Get_DeptCode(aDeptName:String) : String;
    function Get_UserName(aUserID:String) : String;
  public
    { Public declarations }
    procedure Init_;
    procedure Get_Engine_List;
    procedure Get_Himsen_Info(aProjNo:String);

    procedure Insert_Himsen_Info;
    procedure Update_Himsen_Info(aProjNo:String);

  end;

var
  himsenMain_Frm: ThimsenMain_Frm;

implementation
uses
  findUser_Unit,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure ThimsenMain_Frm.btn_AddManagerClick(Sender: TObject);
var
  lemp : String;

begin
  lemp := '';
  lemp := Create_findUser_Frm(lemp,'A');

  if not(lemp = '') then
  begin
    et_manager.Hint := lemp;
    et_manager.Text := Get_UserName(lemp);
  end else
  begin
    et_manager.Hint := '';
    et_manager.Clear;
  end;
end;

procedure ThimsenMain_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure ThimsenMain_Frm.btn_DelClick(Sender: TObject);
begin
  if MessageDlg('엔진타입: '+et_ProjNo.Text+'/'+et_EngType.Text+#10#13+
                '삭제 하시겠습니까? 삭제된 정보는 복구할 수 없습니다.', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    with DM1.OraTransaction1 do
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM HIMSEN_INFO ' +
                'WHERE PROJNO LIKE :param1 ');
        ParamByName('param1').AsString := et_ProjNo.Text;
        ExecSQL;
      end;
      ShowMessage('삭제완료!');
      btn_RefrashClick(Sender);
    end;
  end;
end;

procedure ThimsenMain_Frm.btn_ImgAddClick(Sender: TObject);
var
  Tile : TAdvSmoothTile;
begin
  if OpenPictureDialog1.Execute then
  begin
    with ImgList.Tiles do
    begin
      BeginUpdate;
      try
        Clear;

        Tile := Add;
        with Tile do
        begin
          Content.Hint := OpenPictureDialog1.FileName;
          Content.Image.LoadFromFile(Content.Hint);
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure ThimsenMain_Frm.btn_RefrashClick(Sender: TObject);
begin
  Init_;
  Get_Engine_List;
end;

procedure ThimsenMain_Frm.btn_RegClick(Sender: TObject);
begin
  if rg_Team.ItemIndex = -1 then
  begin
    raise Exception.Create('반을 선택하여 주십시오!');
    rg_Team.SetFocus;
  end;

  if cb_Status.ItemIndex = -1 then
  begin
    raise Exception.Create('엔진상태를 선택하여 주십시오!');
    cb_Status.SetFocus;
  end;

  if et_Manager.Text = '' then
  begin
    raise Exception.Create('엔진담당자를 선택하여 주십시오!');
    btn_AddManager.SetFocus;
  end;


  if btn_Reg.Caption = '등록' then
  begin
    Insert_Himsen_Info;
  end else
  begin
    //수정
    Update_Himsen_Info(et_ProjNo.Text);

  end;
  Get_Engine_List;
end;

procedure ThimsenMain_Frm.cb_SiteDropDown(Sender: TObject);
begin
  with cb_Site.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT CODE, CODE_NAME FROM HITEMS_LOCATION_CODE ' +
                'WHERE CODE_LV = 0 ORDER BY CODE ');
        Open;

        FLoc_Code_List.Clear;

        while not eof do
        begin
          Add(FieldByName('CODE_NAME').AsString);
          FLoc_Code_List.Add(FieldByName('CODE').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure ThimsenMain_Frm.dt_EngInChange(Sender: TObject);
begin
  with Sender as TDateTimePicker do
  begin
    Format := 'yyyy-MM-dd'
  end;
end;

procedure ThimsenMain_Frm.et_engModelDropDown(Sender: TObject);
begin
  with et_engModel.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT DISTINCT(ENGMODEL) FROM HIMSEN_INFO ' +
                'ORDER BY ENGMODEL ');
        Open;

        while not eof do
        begin
          Add(FieldByName('ENGMODEL').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure ThimsenMain_Frm.FormCreate(Sender: TObject);
begin
  FLoc_Code_List := TStringList.Create;
  Get_Engine_List;
end;

procedure ThimsenMain_Frm.FormDestroy(Sender: TObject);
begin
  FLoc_Code_List.Free;
end;

function ThimsenMain_Frm.Get_DeptCode(aDeptName: String): String;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT DEPT_CD FROM HITEMS_DEPT ' +
              'WHERE DEPT_NAME LIKE :param1 ');
      ParamByName('param1').AsString := aDeptName;
      Open;

      if RecordCount <> 0 then
        Result := FieldByName('DEPT_CD').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure ThimsenMain_Frm.Get_Engine_List;
var
  LRow : Integer;
begin
  with grid_EngList do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT  ' +
                '   TO_NUMBER(SUBSTR(ENGTYPE, 1, INSTR(ENGTYPE,''H'',1,1)-1)) CYLNUM, ' +
                '   ENGTYPE, ' +
                '   PROJNO, ' +
                '   PROJNAME ' +
                'FROM HIMSEN_INFO ' +
                'ORDER BY CYLNUM, PROJNO ');
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            LRow := AddRow;

            Cell[0,LRow].AsInteger := 4;
            Cell[1,LRow].AsString  := FieldByName('PROJNO').AsString;
            Cell[2,LRow].AsString  := FieldByName('ENGTYPE').AsString;
            Cell[3,LRow].AsString  := FieldByName('PROJNAME').AsString;

            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure ThimsenMain_Frm.Get_Himsen_Info(aProjNo: String);
var
  MS : TMemoryStream;
  im : TImage;
  Tile : TAdvSmoothTile;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT A.*, B.DEPT_NAME, C.NAME_KOR MANAGER ' +
            'FROM HIMSEN_INFO A, HITEMS_DEPT B, HITEMS_USER C ' +
            'WHERE PROJNO LIKE :param1 ' +
            'AND A.TEAM = B.DEPT_CD ' +
            'AND A.MEASP = C.USERID ');

    ParamByName('param1').AsString := aProjNo;
    Open;

    if RecordCount <> 0 then
    begin
      rg_Team.ItemIndex := rg_Team.Items.IndexOf(FieldByName('DEPT_NAME').AsString);
      cb_Status.ItemIndex := FieldByName('STATUS').AsInteger;
      et_EngModel.Text    := FieldByName('ENGMODEL').AsString;
      et_EngType.Text     := FieldByName('ENGTYPE').AsString;
      et_ProjNm.Text      := FieldByName('ENGPROJ').AsString;
      et_ProjNo.Text      := FieldByName('PROJNO').AsString;
      et_ProjName.Text    := FieldByName('PROJNAME').AsString;
      et_ShipNo.Text      := FieldByName('SHIPNO').AsString;
      et_ShipName.Text    := FieldByName('SHIPNAME').AsString;

      if FieldByName('ENGIN').IsNull then
        dt_EngIn.Format := ' '
      else
      begin
        dt_EngIn.Format   := 'yyy-MM-dd';
        dt_EngIn.Date     := FieldByName('ENGIN').AsDateTime;
      end;

      if FieldByName('ENGOUT').IsNull then
        dt_EngOut.Format := ' '
      else
      begin
        dt_EngOut.Format  := 'yyy-MM-dd';
        dt_EngOut.Date    := FieldByName('ENGOUT').AsDateTime;
      end;

      if FieldByName('TAT').IsNull then
        dt_TAT.Format     := ' '
      else
      begin
        dt_TAT.Format     := 'yyy-MM-dd';
        dt_TAT.Date       := FieldByName('TAT').AsDateTime;
      end;

      if FieldByName('MANAGER').IsNull then
      begin
        et_Manager.Clear;
        et_Manager.Hint := '';
      end else
      begin
        et_Manager.Text := FieldByName('MANAGER').AsString;
        et_Manager.Hint := FieldByName('MEASP').AsString;
      end;

      if not FieldByName('OPTYPE').IsNull then
        cb_Operate.ItemIndex := cb_Operate.Items.IndexOf(FieldByName('OPTYPE').AsString)
      else
        cb_Operate.ItemIndex := 0;

      et_Freq.Value     := FieldByName('FREQUENCY').AsInteger;
      et_Mcr.Value      := FieldByName('MCR').AsInteger;
      et_Rpm.Value      := FieldByName('RPM').AsInteger;

      et_NumCyl.Value   := FieldByName('CYLNUM').AsInteger;
      et_Bore.Value     := FieldByName('BORE').AsInteger;
      et_Stroke.Value   := FieldByName('STROKE').AsInteger;

      et_Class.Text     := FieldByName('CLASS').AsString;
      et_Bed.Text       := FieldByName('TESTBED').AsString;
      cb_Site.Text      := FieldByName('SITE').AsString;

      cb_Rotate.ItemIndex  := cb_Rotate.Items.IndexOf(FieldByName('ROTATING').AsString);
      et_Firing.Text       := FieldByName('FIRING').AsString;
      cb_Arrange.ItemIndex := cb_Arrange.Items.IndexOf(FieldByName('ENGARR').AsString);

      et_NumCrv.Value   := FieldByName('CRVNUM').AsInteger;
      et_NumMB.Value    := FieldByName('MAINBN').AsInteger;
      et_NumCS.Value    := FieldByName('CAMBN').AsInteger;
      et_NumBE.Value    := FieldByName('BIGN').AsInteger;
      et_NumSE.Value    := FieldByName('SMALLN').AsInteger;

      et_DimA.Value     := FieldByName('DIMENSIONA').AsInteger;
      et_DimB.Value     := FieldByName('DIMENSIONB').AsInteger;
      et_DimC.Value     := FieldByName('DIMENSIONC').AsInteger;
      et_DimD.Value     := FieldByName('DIMENSIOND').AsInteger;
      et_DimH.Value     := FieldByName('DIMENSIONH').AsInteger;


      if not FieldByName('ENGVIEW').IsNull then
      begin
        im := TImage.Create(nil);
        try
          LoadPictureFromBlobField(TBlobField(FieldByName('ENGVIEW')),im.Picture);

          with ImgList do
          begin
            BeginUpdate;
            try
              with Tiles do
              begin
                Clear;
                Tile := Add;

                with Tile do
                begin
                  Content.Image.Assign(im.Picture);
                  Content.Text := '';
                  Content.Hint := '';

                end;
              end;
            finally
              EndUpdate;
            end;
          end;
        finally
          FreeAndNil(im);
        end;
      end else
        ImgList.Tiles.Clear;

    end;
  end;
end;

function ThimsenMain_Frm.Get_UserName(aUserID: String): String;
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
      SQL.Add('select * from HITEMS_USER ' +
              'where USERID = :param1 ');
      ParamByName('param1').AsString := aUserID;
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('NAME_KOR').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

procedure ThimsenMain_Frm.grid_EngListCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  with grid_EngList do
  begin
    btn_Reg.Caption := '수정';
    et_ProjNo.ReadOnly := True;
    et_ProjNo.Color    := $00DFDFDF;
    btn_Del.Enabled    := True;
    Get_Himsen_Info(Cells[1,ARow]);
  end;
end;

procedure ThimsenMain_Frm.grid_EngListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  with grid_EngList do
  begin
    BeginUpdate;
    try
      for i := 0 to RowCount-1 do
        Cell[0,i].AsInteger := 4;


      i := GetRowAtPos(X,Y);
      if i >= 0 then
        Cell[0,i].AsInteger := 5;

    finally
      EndUpdate;
    end;
  end;
end;

procedure ThimsenMain_Frm.Init_;
var
  i : Integer;
begin
  btn_Reg.Caption := '등록';
  et_ProjNo.ReadOnly := False;
  et_ProjNo.Color    := clWhite;

  rg_Team.ItemIndex := 0;
  cb_Status.ItemIndex := -1;

  et_EngModel.Clear;
  et_EngType.Clear;
  et_ProjNo.Clear;
  et_ProjNm.Clear;
  et_ProjName.Clear;
  et_Manager.Clear;
  et_Manager.Hint := '';
  et_ShipNo.Clear;
  et_ShipName.Clear;
  et_Firing.Clear;

  dt_EngIn.Format := ' ';
  dt_EngOut.Format := ' ';
  dt_TAT.Format := ' ';

  cb_Operate.ItemIndex := -1;
  cb_Rotate.ItemIndex := -1;
  cb_Arrange.ItemIndex := -1;

  et_Freq.Value := 0;
  et_Rpm.Value  := 0;
  et_mcr.Value  := 0;


  et_NumCyl.Value := 0;
  et_Bore.Value   := 0;
  et_Stroke.Value := 0;

  et_Class.Clear;
  cb_Site.Clear;
  et_Bed.Clear;

  et_NumCrv.Value := 0;
  et_NumMB.Value := 0;
  et_NumBE.Value := 0;
  et_NumCS.Value := 0;
  et_NumSE.Value := 0;

  et_DimA.Value := 0;
  et_DimB.Value := 0;
  et_DimC.Value := 0;
  et_DimD.Value := 0;
  et_DimH.Value := 0;

  ImgList.Tiles.Clear;

  with grid_EngList do
  begin
    BeginUpdate;
    try
      for i := 0 to RowCount-1 do
        Cell[0,i].AsInteger := 4;


    finally
      EndUpdate;
    end;
  end;
end;

procedure ThimsenMain_Frm.Insert_Himsen_Info;
var
  MS : TMemoryStream;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO HIMSEN_INFO ' +
            '(' +
            '   TEAM, STATUS, ENGIN, ENGOUT, PROJNO, ' +
            '   PROJNAME, SHIPNO, SHIPNAME, ENGMODEL, ENGTYPE, ' +
            '   ENGPROJ, OWNER, CLASS, SITE, OPTYPE, ' +
            '   MEASP, DESIGNP, CYLNUM, BORE, STROKE, ' +
            '   RPM, FREQUENCY, MCR, ENGARR, TESTBED, ' +
            '   LBXNO, FIRING, ROTATING, CRVNUM, MAINBN, ' +
            '   CAMBN, BIGN, SMALLN, DIMENSIONA, DIMENSIONB,  ' +
            '   DIMENSIONC, DIMENSIOND, DIMENSIONH, ENGVIEW, TAT, ' +
            '   LOC_CODE ' +
            ') VALUES ( ' +
            '   :TEAM, :STATUS, :ENGIN, :ENGOUT, :PROJNO, ' +
            '   :PROJNAME, :SHIPNO, :SHIPNAME, :ENGMODEL, :ENGTYPE, ' +
            '   :ENGPROJ, :OWNER, :CLASS, :SITE, :OPTYPE, ' +
            '   :MEASP, :DESIGNP, :CYLNUM, :BORE, :STROKE, ' +
            '   :RPM, :FREQUENCY, :MCR, :ENGARR, :TESTBED, ' +
            '   :LBXNO, :FIRING, :ROTATING, :CRVNUM, :MAINBN, ' +
            '   :CAMBN, :BIGN, :SMALLN, :DIMENSIONA, :DIMENSIONB,  ' +
            '   :DIMENSIONC, :DIMENSIOND, :DIMENSIONH, :ENGVIEW, :TAT, ' +
            '   :LOC_CODE ' +
            ') ');

    ParamByName('TEAM').AsString     := Get_DeptCode(rg_Team.Items.Strings[rg_Team.ItemIndex]);
    ParamByName('STATUS').AsInteger  := cb_Status.ItemIndex;
    if dt_EngIn.Format <> ' ' then
      ParamByName('ENGIN').AsDate    := dt_EngIn.Date;
    if dt_EngOut.Format <> ' ' then
      ParamByName('ENGOUT').AsDate   := dt_EngOut.Date;
    ParamByName('PROJNO').AsString   := et_ProjNo.Text;

    ParamByName('PROJNAME').AsString := et_ProjName.Text;
    ParamByName('SHIPNO').AsString   := et_ShipNo.Text;
    ParamByName('SHIPNAME').AsString := et_ShipName.Text;
    ParamByName('ENGMODEL').AsString := et_EngModel.Text;
    ParamByName('ENGTYPE').AsString  := et_EngType.Text;

    ParamByName('ENGPROJ').AsString  := et_ProjNm.Text;
    ParamByName('OWNER').AsString    := et_Owner.Text;
    ParamByName('CLASS').AsString    := et_Class.Text;
    ParamByName('SITE').AsString     := cb_Site.Text;
    ParamByName('OPTYPE').AsString   := cb_Operate.Text;

    ParamByName('MEASP').AsString    := et_Manager.Hint;
    ParamByName('DESIGNP').AsString  := '';
    ParamByName('CYLNUM').AsInteger  := et_NumCyl.AsInteger;
    ParamByName('BORE').AsInteger    := et_Bore.AsInteger;
    ParamByName('STROKE').AsInteger  := et_Stroke.AsInteger;

    ParamByName('RPM').AsInteger     := et_Rpm.AsInteger;
    ParamByName('FREQUENCY').AsInteger := et_Freq.AsInteger;
    ParamByName('MCR').AsInteger       := et_Mcr.AsInteger;
    ParamByName('ENGARR').AsString     := cb_Arrange.Text;
    ParamByName('TESTBED').AsString    := et_Bed.Text;

    ParamByName('LBXNO').AsInteger     := 0;
    ParamByName('FIRING').AsString     := et_Firing.Text;
    ParamByName('ROTATING').AsString   := cb_Rotate.Text;
    ParamByName('CRVNUM').AsInteger    := et_NumCrv.AsInteger;
    ParamByName('MAINBN').AsInteger    := et_NumMB.AsInteger;

    ParamByName('CAMBN').AsInteger     := et_NumCS.AsInteger;
    ParamByName('BIGN').AsInteger      := et_NumBE.AsInteger;
    ParamByName('SMALLN').AsInteger    := et_NumSE.AsInteger;
    ParamByName('DIMENSIONA').AsInteger:= et_DimA.AsInteger;
    ParamByName('DIMENSIONB').AsInteger:= et_DimB.AsInteger;

    ParamByName('DIMENSIONC').AsInteger:= et_DimC.AsInteger;
    ParamByName('DIMENSIOND').AsInteger:= et_DimD.AsInteger;
    ParamByName('DIMENSIONH').AsInteger:= et_DimH.AsInteger;

    if dt_TAT.Format <> ' ' then
      ParamByName('TAT').AsDate        := dt_TAT.Date;

    if (cb_Site.ItemIndex >= 0) and (cb_Site.ItemIndex < cb_Site.Items.Count)then
      ParamByName('LOC_CODE').AsString   :=  FLoc_Code_List.Strings[cb_Site.ItemIndex];

    if ImgList.Tiles.Count > 0 then
    begin
      if ImgList.Tiles[0].Content.Hint <> '' then
      begin
        MS := TMemoryStream.Create;
        try
          MS.LoadFromFile(ImgList.Tiles[0].Content.Hint);
          ParamByName('ENGVIEW').ParamType := ptInput;
          ParamByName('ENGVIEW').AsOraBlob.LoadFromStream(MS);
        finally
          FreeAndNil(MS);
        end;
      end;
    end;

    ExecSQL;
    ShowMessage('등록성공!');
  end;
end;

procedure ThimsenMain_Frm.Update_Himsen_Info(aProjNo: String);
var
  MS : TMemoryStream;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE HIMSEN_INFO SET ' +
            '   TEAM = :TEAM, STATUS = :STATUS, ENGIN = :ENGIN, ENGOUT = :ENGOUT,' +
            '   PROJNAME = :PROJNAME, SHIPNO = :SHIPNO, SHIPNAME = :SHIPNAME, ENGMODEL = :ENGMODEL, ENGTYPE = :ENGTYPE, ' +
            '   ENGPROJ = :ENGPROJ, OWNER = :OWNER, CLASS = :CLASS, SITE = :SITE, OPTYPE = :OPTYPE, ' +
            '   MEASP = :MEASP, DESIGNP = :DESIGNP, CYLNUM = :CYLNUM, BORE = :BORE, STROKE = :STROKE, ' +
            '   RPM = :RPM, FREQUENCY = :FREQUENCY, MCR = :MCR, ENGARR = :ENGARR, TESTBED = :TESTBED, ' +
            '   LBXNO = :LBXNO, FIRING = :FIRING, ROTATING = :ROTATING, CRVNUM = :CRVNUM, MAINBN = :MAINBN, ' +
            '   CAMBN = :CAMBN, BIGN = :BIGN, SMALLN = :SMALLN, DIMENSIONA = :DIMENSIONA, DIMENSIONB = :DIMENSIONB,  ' +
            '   DIMENSIONC = :DIMENSIONC, DIMENSIOND = :DIMENSIOND, DIMENSIONH = :DIMENSIONH, ENGVIEW = :ENGVIEW, TAT = :TAT, ' +
            '   LOC_CODE = :LOC_CODE ' +
            'WHERE PROJNO LIKE :param1 ');

    ParamByName('param1').AsString   := aProjNo;

    ParamByName('TEAM').AsString     := Get_DeptCode(rg_Team.Items.Strings[rg_Team.ItemIndex]);
    ParamByName('STATUS').AsInteger  := cb_Status.ItemIndex;
    if dt_EngIn.Format <> ' ' then
      ParamByName('ENGIN').AsDate    := dt_EngIn.Date;
    if dt_EngOut.Format <> ' ' then
      ParamByName('ENGOUT').AsDate   := dt_EngOut.Date;

    ParamByName('PROJNAME').AsString := et_ProjName.Text;
    ParamByName('SHIPNO').AsString   := et_ShipNo.Text;
    ParamByName('SHIPNAME').AsString := et_ShipName.Text;
    ParamByName('ENGMODEL').AsString := et_EngModel.Text;
    ParamByName('ENGTYPE').AsString  := et_EngType.Text;

    ParamByName('ENGPROJ').AsString  := et_ProjNm.Text;
    ParamByName('OWNER').AsString    := et_Owner.Text;
    ParamByName('CLASS').AsString    := et_Class.Text;
    ParamByName('SITE').AsString     := cb_Site.Text;
    ParamByName('OPTYPE').AsString   := cb_Operate.Text;

    ParamByName('MEASP').AsString    := et_Manager.Hint;
    ParamByName('DESIGNP').AsString  := '';
    ParamByName('CYLNUM').AsInteger  := et_NumCyl.AsInteger;
    ParamByName('BORE').AsInteger    := et_Bore.AsInteger;
    ParamByName('STROKE').AsInteger  := et_Stroke.AsInteger;

    ParamByName('RPM').AsInteger     := et_Rpm.AsInteger;
    ParamByName('FREQUENCY').AsInteger := et_Freq.AsInteger;
    ParamByName('MCR').AsInteger       := et_Mcr.AsInteger;
    ParamByName('ENGARR').AsString     := cb_Arrange.Text;
    ParamByName('TESTBED').AsString    := et_Bed.Text;

    ParamByName('LBXNO').AsInteger     := 0;
    ParamByName('FIRING').AsString     := et_Firing.Text;
    ParamByName('ROTATING').AsString   := cb_Rotate.Text;
    ParamByName('CRVNUM').AsInteger    := et_NumCrv.AsInteger;
    ParamByName('MAINBN').AsInteger    := et_NumMB.AsInteger;

    ParamByName('CAMBN').AsInteger     := et_NumCS.AsInteger;
    ParamByName('BIGN').AsInteger      := et_NumBE.AsInteger;
    ParamByName('SMALLN').AsInteger    := et_NumSE.AsInteger;
    ParamByName('DIMENSIONA').AsInteger:= et_DimA.AsInteger;
    ParamByName('DIMENSIONB').AsInteger:= et_DimB.AsInteger;

    ParamByName('DIMENSIONC').AsInteger:= et_DimC.AsInteger;
    ParamByName('DIMENSIOND').AsInteger:= et_DimD.AsInteger;
    ParamByName('DIMENSIONH').AsInteger:= et_DimH.AsInteger;

    if dt_TAT.Format <> ' ' then
      ParamByName('TAT').AsDate        := dt_TAT.Date;

    if (cb_Site.ItemIndex >= 0) and (cb_Site.ItemIndex < cb_Site.Items.Count)then
      ParamByName('LOC_CODE').AsString   :=  FLoc_Code_List.Strings[cb_Site.ItemIndex];

    if ImgList.Tiles.Count > 0 then
    begin
      if ImgList.Tiles[0].Content.Hint <> '' then
      begin
        MS := TMemoryStream.Create;
        try
          MS.LoadFromFile(ImgList.Tiles[0].Content.Hint);
          ParamByName('ENGVIEW').ParamType := ptInput;
          ParamByName('ENGVIEW').AsOraBlob.LoadFromStream(MS);
        finally
          ImgList.Tiles[0].Content.Hint := '';
          FreeAndNil(MS);
        end;
      end else
      begin
        SQL.Text := ReplaceStr(SQL.Text,'ENGVIEW = :ENGVIEW,','');
      end;
    end;

    ExecSQL;
    ShowMessage('수정성공!');
  end;
end;


end.
