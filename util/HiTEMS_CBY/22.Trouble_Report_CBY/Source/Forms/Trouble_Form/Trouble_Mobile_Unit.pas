unit Trouble_Mobile_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, NxCollection, NxEdit, Jpeg, DB, GDIPPictureContainer, Bde.DBTables;

type
  TUserInfo = packed Record
    UserId : String;
    Deptno : String;
    Teamno : String;
    DBConn : String;
    Privity: String;
end;

type
  TInChargerInfo = packed Record
    ChiefId : String;
    EmpId :String;
    InEmpId : String;
end;

type
  TTrouble_Mobile_Frm = class(TForm)
    Panel1: TPanel;
    Button3: TButton;
    Button4: TButton;
    Panel3: TPanel;
    Label8: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    inemp: TEdit;
    Label11: TLabel;
    emp: TEdit;
    Button2: TButton;
    Button1: TButton;
    leftb: TButton;
    rightb: TButton;
    Panel2: TPanel;
    Image1: TImage;
    title: TLabel;
    itemname: TLabel;
    status: TLabel;
    rptype: TLabel;
    engtype: TLabel;
    informer: TLabel;
    indate: TLabel;
    Label12: TLabel;
    codeid: TLabel;
    Button5: TButton;
    Chief: TEdit;
    detailBtn: TButton;
    GDIPPictureContainer1: TGDIPPictureContainer;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure leftbClick(Sender: TObject);
    procedure rightbClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    FFirst : Boolean;
    FTCODE : String;
    FINFORMER : String;
    FImgList : TStringList;
    FImgPos : Integer;
    FRPTYPE : Integer;
  public
    { Public declarations }

    FOwner : TMain_Frm;
    PUserInfo : TUserInfo;
    PCharger : TInChargerInfo;
    FCODEID : String;
    FUserPriv  : integer;

    procedure Get_Trouble_Info(pCODEID : String);
    procedure Show_Trouble_Img(CodeId, pFilenm : String);
    function Select_User_Info(fUserId:String) : String;
    function Get_Manager(informer:String) : String;

    procedure Set_of_Button_Status;

    function Apply_for_EmpIds_to_DB(CODEID,EmpId:String; idx:integer) : Boolean;
    procedure InEMP_User_Check_for_TRouble_List(FCODEID:String); //담당자가 문서를 확인
  end;

var
  Trouble_Mobile_Frm: TTrouble_Mobile_Frm;


implementation
uses
  DataModule_Unit, TeamChange_Unit, mobileEmpIds_Unit, Trouble_Unit;

{$R *.dfm}

{ TTrouble_Mobile_Frm }

function TTrouble_Mobile_Frm.Apply_for_EmpIds_to_DB(CODEID, EmpId: String;
  idx: integer): Boolean;
begin
  Result := False;
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update Trouble_Mobile Set');
    case idx of
      0 : SQL.Add('INEMPNO = :param1, STEP = 1 where MCODEID = :param2');
      1 : SQL.Add('EMPNO = :param1 STEP = 1 where MCODEID = :param2');
    end;
    parambyname('param1').AsString := EmpId;
    parambyname('param2').AsString := FCODEID;
    ExecSQL;
    Result := True;
  end;
end;

procedure TTrouble_Mobile_Frm.Button1Click(Sender: TObject);
var
  LForm : TmobileEmpIds_Frm;
begin
  LForm := TmobileEmpIds_Frm.Create(nil);
  with LForm do
  begin
    FManager := PCharger.ChiefId;
    manager.Text := Chief.Text;
    try
      FOwner := Self;
      FEmpKind := 1;
      ShowModal;
    finally
      Apply_for_EmpIds_to_DB(FCODEID,PCharger.EmpId,1);

    end;
  end;
end;

procedure TTrouble_Mobile_Frm.Button2Click(Sender: TObject);
var
  LForm : TmobileEmpIds_Frm;
begin
  LForm := TmobileEmpIds_Frm.Create(nil);
  with LForm do
  begin
    FManager := PCharger.ChiefId;
    manager.Text := Chief.Text;
    try
      FOwner := Self;
      FEmpKind := 0;
      ShowModal;
    finally
      Apply_for_EmpIds_to_DB(FCODEID,PCharger.InEmpId,0);

    end;
  end;
end;

procedure TTrouble_Mobile_Frm.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TTrouble_Mobile_Frm.Button4Click(Sender: TObject);
var
  LCodeId : String;
  LForm : TTrouble_Frm;
begin
  if not(codeid.caption = '') then
  begin
    LForm := TTrouble_Frm.Create(self);
    with LForm do
    begin
//      FOwner := Self;
      Caption := '모바일 문제점 상세 등록';
      FOpenCase := 3; //0:신규문서 //1:저장된 문서 // 2:상세조회 // 3:모바일 기반
      FUserPriv  := Self.FUserPriv;

      Statusbar1.Panels[0].Text := Self.PUserInfo.DBConn;
      Statusbar1.Panels[1].Text := Self.PUserInfo.Privity;
      Statusbar1.Panels[2].Text := Self.PUserInfo.Deptno;
      Statusbar1.Panels[3].Text := Self.PUserInfo.Teamno;
      Statusbar1.Panels[4].Text := Self.PUserInfo.UserId;

      PMTRContent.MCODEID   := self.codeid.Caption;
      PMTRContent.MSTATUS   := self.title.Caption; //문제현상
      PMTRContent.MITEMNAME := self.itemname.Caption;
      PMTRContent.MREASON   := self.status.Caption; //추정원인
      PMTRContent.MEngType  := self.engtype.Caption;
      PMTRContent.MRPTYPE   := self.FRPTYPE;
      PMTRContent.MInDate   := self.indate.Caption;

      ShowModal;
    end;
  end;
end;


procedure TTrouble_Mobile_Frm.Button5Click(Sender: TObject);
var
  LForm : TTeamChange_Frm;

begin
  if PCharger.InEmpId = '' then
  begin
    LForm := TTeamChange_Frm.Create(nil);

    with LForm do
    begin
      FCODEID := codeid.Caption;
      FCurrentChief := PCharger.ChiefId;
      Chief.Text := Self.Chief.Text;
      FItemName := Self.itemname.Caption;
      FEngType := Self.engtype.Caption;
      ShowModal;

    end;
  end
  else
    ShowMessage('작성담당 등록 후 팀 변경 불가 합니다.'+#13#10+
                '변경을 원하실 경우 관리자에게 문의 바랍니다.(2-7348)');

end;

procedure TTrouble_Mobile_Frm.FormActivate(Sender: TObject);
var
  LStr : String;
  lManager : TStringList;
begin
  if FFirst = True then
  begin
    FFirst := False;
    Get_Trouble_Info(FCODEID);
    Set_of_Button_Status;
  end;
end;

procedure TTrouble_Mobile_Frm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(FImgList);
end;

procedure TTrouble_Mobile_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;
  FImgList := TStringList.Create;

end;

function TTrouble_Mobile_Frm.Get_Manager(informer: String): String;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select A.*, B.CODENM from User_Info A, ZHITEMSCODE B');
    SQL.Add('where A.Priv = 2 and A.TEAM = (select TEAM from User_Info where USERID = :param1)');
    SQL.Add('and A.CLASS = B.CODE');

    if not(PCharger.InEmpId = '') then
      parambyname('param1').AsString := PCharger.InEmpId
    else
      parambyname('param1').AsString := Informer;

    Open;

    if not(RecordCount = 0) then
      Result := Fieldbyname('USERID').AsString +'|' + Fieldbyname('Name_Kor').AsString
                 +'|' + Fieldbyname('CODENM').AsString
    else
      Result := '';
  end;
end;

procedure TTrouble_Mobile_Frm.Get_Trouble_Info(pCODEID : String);
var
  LStr : String;
  lManager : TStringList;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Trouble_Mobile');
    SQL.Add('where MCODEID = :param1');
    parambyname('param1').AsString := FCODEID;
    Open;

    if not(RecordCount = 0) then
    begin
      FTCODE              := Fieldbyname('TCODEID').AsString;//문제점 보고서 코드
      codeid.Caption   := FCODEID;
      title.Caption       := Fieldbyname('STATUS').AsString;
      itemname.Caption    := Fieldbyname('ITEMNAME').AsString;
      status.Caption      := Fieldbyname('REASON').AsString;

      FRPTYPE := Fieldbyname('RPTYPE').AsInteger;
      case  FRPTYPE of
        0 : rptype.Caption := '품질문제';
        1 : rptype.Caption := '설비문제';
        2 : rptype.Caption := '문제예상';
      end;

      engtype.Caption     := Fieldbyname('ENGTYPE').AsString;
      FInformer           := Fieldbyname('INFORMER').AsString;
      informer.Caption    := Select_User_Info(FInformer);
      indate.Caption      := formatDateTime('YYYY-MM-DD',Fieldbyname('INDATE').AsDateTime);

      PCharger.EmpId := Fieldbyname('EMPNO').AsString;//설계담당
      emp.Text := Select_User_Info(PCharger.EmpId);
      PCharger.InEmpId := Fieldbyname('INEMPNO').AsString;//작성담당
      inemp.Text := Select_User_Info(PCharger.InEmpId);

      LStr := Get_Manager(Fieldbyname('MANAGER').AsString);
      if not(LStr = '') then
      begin
        try
          lManager := TStringList.Create;

          lManager.Delimiter := '|';
          lManager.DelimitedText := LStr;

          // 0 : ID / 1 : NAME / 2 : Class
          PCharger.ChiefId := lManager.Strings[0];
          Chief.Text := lManager.Strings[2]+' '+ lManager.Strings[1];

        finally
          FreeAndNil(lManager);
        end;
      end;
    end;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from TROUBLE_ATTFILES where CODEID = :param1');
    SQL.Add('and ATTFLAG = ''I''');
    parambyname('param1').AsString := FCODEID;
    Open;

    FImgList.Clear;

    if not(RecordCount = 0) then
    begin
      while not eof do
      begin
        FImgList.Add(Fieldbyname('DBFILENAME').AsString);
        Next;
      end;
      FImgPos := 0;

      if FImgList.Count > 1 then
      begin
        leftb.Visible := True;
        rightb.Visible := True;
      end
      else
      begin
        leftb.Visible := false;
        rightb.Visible := false;
      end;

      Show_Trouble_Img(FCODEID,FImgList.Strings[0]);
    end;
  end;

  if PUserInfo.UserId = PCharger.InEmpId then
    InEMP_User_Check_for_TRouble_List(pCODEID);

end;

procedure TTrouble_Mobile_Frm.InEMP_User_Check_for_TRouble_List(FCODEID:String);
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update Trouble_Mobile Set STEP = 2 where MCODEID = :param1');
    parambyname('param1').AsString := FCODEID;
    ExecSQL;
  end;
end;

procedure TTrouble_Mobile_Frm.leftbClick(Sender: TObject);
var
  li : integer;
begin

  Dec(FImgPos);
  li := FImgPos;

  if (li < 0) then
  begin
    li := FImgList.Count-1;
    FImgPos := FImgList.Count-1;
  end;

  Show_Trouble_Img(FCODEID, FImgList.Strings[li]);

end;

procedure TTrouble_Mobile_Frm.rightbClick(Sender: TObject);
var
  li : integer;
begin
  Inc(FImgPos);
  li := FImgPos;

  if (li > FImgList.Count-1) then
  begin
    li := 0;
    FImgPos := 0;
  end;

  Show_Trouble_Img(FCODEID, FImgList.Strings[li]);

end;

function TTrouble_Mobile_Frm.Select_User_Info(fUserId: String): String;
var
  li : integer;
  LName, LClass : String;
begin
  try
    with DM1.TQuery2 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select A.Name_Kor, B.Codenm from User_Info A, ZHITEMSCODE B');
      SQL.Add('where A.UserID = :param1 and A.CLASS = B.CODE');
      parambyname('param1').AsString := fUserId;
      Open;

      if not(Fieldbyname('Name_Kor').AsString = '') then
      begin
        LName := Fieldbyname('Name_Kor').AsString;
        LClass := Fieldbyname('CODENM').AsString;
        Result := LClass + ' ' + LName;
      end
      else
        Result := '';
    end;
  except
    Result := '';
  end;
end;

procedure TTrouble_Mobile_Frm.Set_of_Button_Status;
begin
  if PCharger.ChiefId = PUserInfo.UserId then
  begin
    Button5.Visible := True; //팀변경
//    Button1.Visible := True; //설계담당
    Button2.Visible := True; //작성자
  end
  else
  begin
    Button5.Visible := False;
//    Button1.Visible := False;
    Button2.Visible := False;
  end;

  if not(PCharger.InEmpId = '') and (PCharger.InEmpId = PUserInfo.UserId) then
    Button4.Visible := True
  else
    Button4.Visible := False;

  if not(FTCODE = '') then
    detailBtn.Visible := True
  else
    detailBtn.Visible := False;

end;

procedure TTrouble_Mobile_Frm.Show_Trouble_Img(CodeId, pFilenm: String);
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
      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from Trouble_Attfiles where CODEID = :param1');
        SQL.Add('and ATTFLAG = ''I'' and DBFILENAME = :param2');
        parambyname('param1').AsString := CodeId;
        parambyname('param2').AsString := pFilenm;
        Open;

        Image1.Picture := nil;

        if not(RecordCount = 0) then
        begin
          for li := 0 to 1 do
          begin
            if FieldByName('FILES').IsBlob then
            begin
              LMS := TMemoryStream.Create;
              try
                (FieldByName('FILES') as TBlobField).SaveToStream(LMS);
                add;
                Items[Count-1].Name := FieldByName('LCFILENAME').AsString;
                Items[Count-1].Picture.LoadFromStream(LMS);
              finally
                FreeAndNil(LMS);
              end;
            end;
            Next;
          end;
        end;
      end;
    finally
      if GDIPPictureContainer1.Items.Count > 0 then
        Image1.Picture.Assign(GDIPPictureContainer1.Items[0].Picture);

      Image1.Invalidate;
      EndUpdate;
    end;
  end;
end;

end.
