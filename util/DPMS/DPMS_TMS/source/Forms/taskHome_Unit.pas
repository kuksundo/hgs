unit taskHome_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxCollection, IdBaseComponent,DBXJSON,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Vcl.StdCtrls, WebImage,
  Vcl.ExtCtrls, AdvSmoothPanel, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.Imaging.jpeg, AdvGlowButton,
  CurvyControls, DateUtils, AdvSmoothCalendar, Vcl.ComCtrls, JvExComCtrls,
  JvMonthCalendar, NxEdit, Vcl.Imaging.GIFImg, Vcl.ImgList;

type
  TtaskHome_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    IdHTTP1: TIdHTTP;
    AdvSmoothPanel1: TAdvSmoothPanel;
    Panel8: TPanel;
    Image1: TImage;
    CurvyPanel1: TCurvyPanel;
    Label5: TLabel;
    Image4: TImage;
    TeamLabel1: TLabel;
    TeamLabel2: TLabel;
    TeamLabel3: TLabel;
    TeamMh1: TNxNumberEdit;
    TeamMh2: TNxNumberEdit;
    TeamMh3: TNxNumberEdit;
    TeamLabel4: TLabel;
    TeamMh4: TNxNumberEdit;
    grid_anni: TNextGrid;
    NxImageColumn1: TNxImageColumn;
    NxTextColumn1: TNxTextColumn;
    ImageList_anni: TImageList;
    CurvyPanel2: TCurvyPanel;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Timer2: TTimer;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    Image5: TImage;
    Image3: TImage;
    WebImage1: TWebImage;
    procedure FormCreate(Sender: TObject);
    procedure TeamMh1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure Set_Weather_Info;
    procedure Set_Monthly_MH;
    procedure Get_Anniversary(aUserID:String);
    function Check_TodayIsAnniversary(var ADate: TDateTime; ASolarLunar: string; var AIsCurrentMonth: Boolean): Boolean;
    procedure DisplayCongraturation;
    function GetComponent(AName: string): TObject;
    procedure SetVisibleComponent(AName: string);
  public
    FTodayBirthList: TStringList;

    procedure SetUI;
  end;

var
  taskHome_Frm: TtaskHome_Frm;

//  http://map.naver.com/common2/getRegionByPosition.nhn?xPos=129.4285712&yPos=35.5167946

implementation
uses
  HiTEMS_TMS_COMMON,
  HiTEMS_TMS_CONST,
  DataModule_Unit,
  calendar_unit;

{$R *.dfm}

//ADate: 생일
//ASolarLunar: 음력 또는 양력
function TtaskHome_Frm.Check_TodayIsAnniversary(var ADate: TDateTime; ASolarLunar: string; var AIsCurrentMonth: Boolean): Boolean;
var
  LYear,
  LMonth,
  LDay: Word;
  LYoon: Boolean;
  LYear2: integer;
  LMonth2,
  LDay2: smallint;
  LDateTime: TDateTime;
  LMonth3: word;
begin
  DecodeDate(ADate, LYear, LMonth, LDay);
  LYear := CurrentYear;

  if ASolarLunar = '음력' then
  begin
    lunartosolar(LYear, smallint(LMonth), smallint(LDay), LYoon, LYear2, LMonth2, LDay2);
    LDateTime := EncodeDate(word(LYear2), word(LMonth2), word(LDay2));
    LMonth3 := word(LMonth2);
  end
  else
  begin
    LDateTime := EncodeDate(LYear, LMonth, LDay);
    LMonth3 := LMonth;
  end;

  AIsCurrentMonth := LMonth3 = MonthOf(Today);
  
  ADate := LDateTime;
  
  Result := IsToday(LDateTime);
end;

procedure TtaskHome_Frm.DisplayCongraturation;
var
  i: integer;
  LMsg: string;
begin
  if FTodayBirthList.Count = 0 then
    exit;

  LMsg := '금일 생일자: ' + #13#10;
  
  for i := 0 to FTodayBirthList.Count - 1 do
  begin
    LMsg := LMsg + '      ' + Get_UserName(FTodayBirthList.Strings[i]) + '님' + #13#10;  
  end;

  ShowMessage(LMsg);
end;

procedure TtaskHome_Frm.FormCreate(Sender: TObject);
var
  lrow : Integer;
begin
  NxHeaderPanel1.DoubleBuffered := False;

  FTodayBirthList := TStringList.Create;

//  JvMonthCalendar1.Date := Today;
  FormatDateTime('yyyy-MM-dd HH:mm',Now);
  Set_Weather_Info;
  NxHeaderPanel1.Caption := Get_UserName(DM1.FUserInfo.CurrentUsers)+' 님 환영합니다~ ';

  SetUI;
  Set_Monthly_MH;
  Get_Anniversary(DM1.FUserInfo.CurrentUsers);
end;

procedure TtaskHome_Frm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FTodayBirthList);
end;

procedure TtaskHome_Frm.FormShow(Sender: TObject);
begin
//  JvMonthCalendar1.SetFocus;
end;

function TtaskHome_Frm.GetComponent(AName: string): TObject;
var
  i: integer;
begin
  Result := nil;

  for i := 0 to Self.ComponentCount - 1 do
  begin
    if (Self.Components[i].Name = AName) then
    begin
      Result := Self.Components[i];
//      Result.Visible := True;
      SetVisibleComponent(AName);
      exit;
    end;
  end;
end;

procedure TtaskHome_Frm.Get_Anniversary(aUserID: String);
var
  lrow,
  i,j : Integer;
  msgs, LSolarLunar : String;
  LDate: TDateTime;
  LIsCurrentMonth, LTodayIsAnni: Boolean;
begin
  with grid_anni do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM DPMS_USER_ANNIVERSARY ' +
                'WHERE (((USERID = :param1) and (OPEN = :param2)) ' +
                'OR (OPEN = :param3)) ' +
                //'AND TO_CHAR(DAY, ''MM'') = :f '+ //BETWEEN :f And :t ' +
                'ORDER BY DAY');
        ParamByName('param1').AsString := DM1.FUserInfo.CurrentUsers;
        ParamByName('param2').AsString := '비공개';
        ParamByName('param3').AsString := '공개';
        //ParamByName('f').AsString        := FormatDateTime('mm', Today);// StartOfTheMonth(Today);
        //ParamByName('t').AsDate        := EndOfTheMonth(today);
        Open;

        if RecordCount > 0 then
        begin
          FTodayBirthList.Clear;

          while not eof do
          begin
            LDate := FieldByName('DAY').AsDateTime;
            LSolarLunar := FieldByName('CALENDAR').AsString;
            LTodayIsAnni := Check_TodayIsAnniversary(LDate,LSolarLunar,LIsCurrentMonth);

            if not LIsCurrentMonth then
            begin
              Next;
              continue;
            end;
                    
            i := AddRow;
            if (i mod 2) = 0 then
              for j := 0 to Columns.Count-1 do
                Cell[j,i].Color := $00DFDFDF;

            if FieldByName('ATYPE').AsString = '생일' then
            begin
              Cell[0,i].AsInteger := 0;
              msgs := FieldByName('MESSAGE').AsString;//'생일을 축하합니다.';
            end else
            if FieldByName('ATYPE').AsString = '결혼기념일' then
            begin
              Cell[0,i].AsInteger := 1;
              msgs := FieldByName('MESSAGE').AsString;//'결혼기념일을 축하합니다.';
            end else
            if FieldByName('ATYPE').AsString = '기일' then
            begin
              Cell[0,i].AsInteger := 2;
              msgs := FieldByName('MESSAGE').AsString;//'기일 입니다.';
            end;

            if LTodayIsAnni then
            begin
              FTodayBirthList.Add(FieldByName('USERID').AsString);
              Cell[1,i].TextColor := clRed;
            end;

            Cells[1,i] := msgs+':'+FormatDateTime('M월dd일',FieldByName('DAY').AsDateTime)+
                            '(' + LSolarLunar + ')';
                            
            if LSolarLunar = '음력' then
              Cells[1,i] := Cells[1,i] + ' ==> ' + FormatDateTime('M월dd일',LDate) + 
                            '(양력)';
            Next;
          end;
        end;
      end;
    finally
      DisplayCongraturation;
      EndUpdate;
    end;
  end;
end;

procedure TtaskHome_Frm.TeamMh1Change(Sender: TObject);
begin
//  NxNumberEdit4.Value := NxNumberEdit1.Value +
//                         NxNumberEdit2.Value +
//                         NxNumberEdit3.Value;
end;

procedure TtaskHome_Frm.SetUI;
var
  i: integer;
  LObject: TObject;
begin
  for i := 0 to DM1.FTeamList.Count - 1 do
  begin
    LObject := GetComponent('TeamLabel' + IntToStr(i+1));

    if LObject is TLabel then
    begin
      TLabel(LObject).Caption := TDeptClass(DM1.FTeamDic.Items[DM1.FTeamList.Strings[i]]).FName;
      TLabel(LObject).Visible := True;
    end;
  end;
end;

procedure TtaskHome_Frm.SetVisibleComponent(AName: string);
var
  i: integer;
begin
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if (Self.Components[i].Name = AName) then
    begin
      TControl(Self.Components[i]).Visible := True;
      exit;
    end;
  end;
end;

procedure TtaskHome_Frm.Set_Monthly_MH;
var
  li : Integer;
  LObject: TObject;
begin
  with DM1.OraQuery1 do
  begin
    Label5.Caption := DM1.FUserInfo.DeptName + ':' + Label5.Caption +' ('+FormatDateTime('yyyy-MM',today)+'월)';

    for li := 0 to DM1.FTeamList.Count - 1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT SUM(RST_MH) MH FROM DPMS_TMS_RESULT A, DPMS_TMS_RESULT_MH B ' +
              'WHERE A.RST_NO = B.RST_NO ' +
              'AND RST_PERFORM >= :begin  ' +
              'AND RST_PERFORM <= :end ' +
              'AND RST_BY IN (SELECT USERID FROM DPMS_USER WHERE DEPT_CD LIKE :TEAM )');

      ParamByName('begin').AsDate := StartOfTheMonth(Today);
      ParamByName('end').AsDate := EndOfTheMonth(Today);
      ParamByName('TEAM').AsString := DM1.FTeamList.Strings[li];// 'K2B'+IntToStr(li)+'%';
      Open;

      if RecordCount > 0 then
      begin
        LObject := GetComponent('TeamMh' + IntToStr(li+1));

        if Assigned(LObject) then
          TNxNumberEdit(LObject).Value := FieldByName('MH').AsFloat;
      end;

//      case li of
//        1 : TeamMh1.Value := FieldByName('MH').AsFloat;
//        2 : TeamMh2.Value := FieldByName('MH').AsFloat;
//        3 : TeamMh3.Value := FieldByName('MH').AsFloat;
//      end;
    end;
  end;
end;

procedure TtaskHome_Frm.Set_Weather_Info;
const
strJson  =
'{ '+
' "result":{' +
'   "region":{' +
'     "rcode":"10170550",' +
'     "doCode":"1000000000",' +
'     "doName":"울산광역시",' +
'     "siCode":"1017000000",' +
'     "siName":"동구",' +
'     "dongCode":"10170550",' +
'     "dongName":"전하1동",' +
'     "xPos":"129.4285712",' +
'     "yPos":"35.5167946"' +
'    },' +
'   "weather":{' +
'     "weatherCode":"1",' +
'     "weatherText":"맑음",' +
'     "temperature":"14.0",' +
'     "iconURL":"http://static.naver.net/weather/images/w_icon/w_s1.gif",' +
'     "detailURL":"http://weather.naver.com/rgn/townWetr.nhn?naverRgnCd=10170550"' +
'    }' +
'  }' +
'}';

var
  lJsonObj : TJSONObject;
  ljPair : TJSONPair;
  lresult : TJSONValue;
  lcontent : TJSONValue;
  litem : TJSONValue;
  licon,

  doName,
  siName,
  dongName,
  lStr : String;
  lweather,
  ltemp,
  locate : String;


  li,
  lsize : Integer;
begin
  lStr := IdHTTP1.Get('http://map.naver.com/common2/getRegionByPosition.nhn?xPos=129.4285712&yPos=35.5167946');
  lJsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(lStr),0) as TJSONObject;
  try
    lresult := lJsonObj.Get('result').JsonValue;
    lsize := TJSONArray(lresult).Size;
    for li := 0 to lsize-1 do
    begin
      lcontent := TJSONArray(lresult).Get(li);
      ljPair := TJSONPair(lcontent);

      locate := '지역 : ';
      for litem in TJSONArray(ljPair.JsonValue) do
      begin
        if TJSONPair(LItem).JsonString.Value = 'doName' then
          doName := TJSONPair(LItem).JsonValue.Value;

        if TJSONPair(LItem).JsonString.Value = 'siName' then
          siName := TJSONPair(LItem).JsonValue.Value;

        if TJSONPair(LItem).JsonString.Value = 'dongName' then
          dongName := TJSONPair(LItem).JsonValue.Value;

        if TJSONPair(LItem).JsonString.Value = 'weatherText' then
          lweather := '날씨 : ' + TJSONPair(LItem).JsonValue.Value;

        if TJSONPair(LItem).JsonString.Value = 'temperature' then
          ltemp := '기온 : ' + TJSONPair(LItem).JsonValue.Value;

        if TJSONPair(LItem).JsonString.Value = 'iconURL' then
          WebImage1.URL := TJSONPair(LItem).JsonValue.Value;

      end;
      label2.Caption := '지역 : '+doName+'/'+siNAme+'/'+dongName;
      label3.Caption := lweather;
      label4.Caption := ltemp+' ℃';

    end;
  finally
    lJsonObj.Free;
  end;
end;

procedure TtaskHome_Frm.Timer2Timer(Sender: TObject);
begin
  label1.Caption := '시간 : ' + FormatDateTime('yyyy-MM-dd HH:mm:ss',Now);
end;

end.
