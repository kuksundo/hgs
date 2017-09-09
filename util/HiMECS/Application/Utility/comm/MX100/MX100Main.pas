unit MX100Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Samples.Spin, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls, Data.SqlExpr,
  VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart, Vcl.Menus, IniFiles,
  MX100Config, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Data.DB, MemDS, DBAccess,
  Ora, MiddleWareDAO, MiddlewareHelper;

type
  TTestStatus = (stStart, stPause, stStop);

  TMX100MainForm = class(TForm)
    Panel1: TPanel;
    lsbMX100: TListBox;
    StatusBar: TStatusBar;
    TimerMX100: TTimer;
    TimerStart: TTimer;
    MX100Menu: TPopupMenu;
    mnuLOGON: TMenuItem;
    mnuLOGOFF: TMenuItem;
    TrayIcon1: TTrayIcon;
    pmnTray: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    imgBackGround: TImage;
    imgConfig: TImage;
    imgRun: TImage;
    imgPause: TImage;
    imgClose: TImage;
    imgLOG: TImage;
    imgSTATUS: TImage;
    lblEngInfo: TLabel;
    BasePanel: TPanel;
    AddressPanel: TPanel;
    ledConnected: TShape;
    Panel3: TPanel;
    Panel4: TPanel;
    LastupdatePanel: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    SalveidPanel: TPanel;
    Panel2: TPanel;
    pnlSlaveId: TPanel;
    EngtypePanel: TPanel;
    Panel12: TPanel;
    pnlEngtype: TPanel;
    Panel8: TPanel;
    projectnoPanel: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel9: TPanel;
    NoUpDown: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerMX100Timer(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure mnuLOGONClick(Sender: TObject);
    procedure mnuLOGOFFClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Readini();
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure imgConfigClick(Sender: TObject);
    procedure imgRunClick(Sender: TObject);
    procedure imgPauseClick(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure imgLOGClick(Sender: TObject);
    procedure imgSTATUSClick(Sender: TObject);
    procedure NoUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure DisplayOnOff(MachinNo : integer);
    //procedure CommStart(bOnOff: boolean);
  private
    { Private declarations }
    giHandle1, giHandle2, giHandle3: LongInt;
    giErrorCode: LongInt;
    giErrorCode1, giErrorCode2: LongInt;
    giErrorCode3, giErrorCode4: LongInt;
    giErrorCode5, giErrorCode6: LongInt;
    giFlag: LongInt;
    LOGONOFF : boolean;
    gbTestEndOK: boolean;
  public
    { Public declarations }
    giStation: integer;
    procedure CommConnect(bOnOff: boolean);
    procedure CommStart(bOnOff: boolean);
    procedure GetData1();
    procedure GetData2();
    procedure GetData3();
    procedure E1();
  end;

var
  MX100MainForm: TMX100MainForm;
  IsConnected1, IsConnected2, IsConnected3 : boolean;
  sAddress1, sAddress2, sAddress3, AppPath, IniName, ENGINE, EngName,nowDT : string;
  nUpDown : integer;
  stringList: TStringList;


implementation

{$R *.dfm}

uses
  UnitDAQMX;
const
  MAX_TEMP_COUNT = 30;
  FIFONO         = 0;
  INDEXNO        = 0;

var
  startNo1  : MXDataNo;
  endNo1    : MXDataNo;
  dataNo1   : MXDataNo;
  chinfo1   : MXChInfo;
  datainfo1 : MXDataInfo;
  datetime1 : MXDateTime;
  userTime1 : MXUserTime;
  //fStartTime: double;

  startNo2  : MXDataNo;
  endNo2    : MXDataNo;
  dataNo2   : MXDataNo;
  chinfo2   : MXChInfo;
  datainfo2 : MXDataInfo;
  datetime2 : MXDateTime;
  userTime2 : MXUserTime;
  //fStartTime1: double;

  startNo3  : MXDataNo;
  endNo3    : MXDataNo;
  dataNo3   : MXDataNo;
  chinfo3   : MXChInfo;
  datainfo3 : MXDataInfo;
  datetime3 : MXDateTime;
  userTime3 : MXUserTime;
  //fStartTime1: double;


// MX100 데이터 수집 실행 프로그램 시작
// MX100 1,2,3 연결 후 시작, bOnOff가 참이면 시작, 거짓이면 중단
procedure TMX100MainForm.CommStart(bOnOff: boolean);
begin
  if bOnOff then
  begin
    //명령어 수집시작
    if (giHandle1 < 0) and (IsConnected1 = false) then exit;
    StatusBar.Panels.Items[0].Text := sAddress1 + ':RUNNING';
    gbTestEndOK := False;
    giFlag := 0;
    giErrorCode := startFIFOMX(giHandle1);  //MX100 no1 시작

    // 타이머 시작
    TimerMX100.Enabled := True;

    if (giHandle2 < 0) and (IsConnected2 = false) then exit;
    //BtnStart.Down := True;
    //BtnStart.Caption := 'STOP';
    StatusBar.Panels.Items[1].Text :=  sAddress2 + ':RUNNING';
    giErrorCode := startFIFOMX(giHandle2);  //MX100 no2 시작

    if (giHandle3 < 0) and (IsConnected3 = false) then exit;
    //BtnStart.Down := True;
    //BtnStart.Caption := 'STOP';
    StatusBar.Panels.Items[2].Text :=  sAddress3 + ':RUNNING';
    giErrorCode := startFIFOMX(giHandle3);  //MX100 no3 시작
    //TimerMX1002.Enabled := True;
  end
  else
  begin
    //명령어 수집중단
    StatusBar.Panels.Items[0].Text := 'READY';
    StatusBar.Panels.Items[1].Text := 'READY';
    StatusBar.Panels.Items[2].Text := 'READY';

    gbTestEndOK := True;
    TimerMX100.Enabled := False;

    if giHandle1 <> 0 then
    begin
      stopFIFOMX(giHandle1);  //MX100 no1 중단
    end;

    if giHandle2 <> 0 then
    begin
      stopFIFOMX(giHandle2);  //MX100 no2 중단
    end;

    if giHandle3 <> 0 then
    begin
      stopFIFOMX(giHandle3);  //MX100 no3 중단
    end;
  end;
end;
//화면 숨기기, 트레이 아이콘 보이기
procedure TMX100MainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  WindowState := wsMinimized;
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;
//MX100 연결 메모리 생성
procedure TMX100MainForm.FormCreate(Sender: TObject);
begin
  stringList := TStringList.Create;
end;
//MX100 화면 닫을 때 연결 메모리 해제
procedure TMX100MainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(stringList);
  TimerStart.Enabled := False;
end;

// MX100 수집 미들웨어 화면 로딩시
// 환경설정 파일 읽음
procedure TMX100MainForm.FormShow(Sender: TObject);
begin
  appPath := ExtractFileDir(Application.ExeName);
  nUpDown := 1;
  iniName := '\config.ini';
  ReadIni();
  LOGONOFF := false;
  IsConnected1 := false;
  IsConnected2 := false;
  IsConnected3 := false;
  DisplayOnOff(nUpDown);
end;
//LOG POPUP 메뉴, LOG기록 안보이기
procedure TMX100MainForm.mnuLOGOFFClick(Sender: TObject);
begin
  LOGONOFF := false;
  lsbMX100.Clear;
end;
//LOG POPUP 메뉴, LOG기록 보이기
procedure TMX100MainForm.mnuLOGONClick(Sender: TObject);
begin
  LOGONOFF := true;
end;
//트레이 아이콘  POPUP 메뉴, 창 보이기
procedure TMX100MainForm.N1Click(Sender: TObject);
begin
  TrayIcon1.Visible := false;
  Show();
  WindowState := wsNormal;
  Application.BringToFront;
end;
//트레이 아이콘  POPUP 메뉴, 프로그램 실행 종료
procedure TMX100MainForm.N2Click(Sender: TObject);
begin
  if TrayIcon1.Visible then
    begin
      TrayIcon1.Visible := false;
    end;
  CommConnect(False);
  FreeAndNil(MX100MainForm);

  //ExitProcess(0);
end;
// MX100 IP주소 정보 리스트 박스 업다운 버튼 클릭시
procedure TMX100MainForm.NoUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  if Button = TUDBtnType(0) then
  begin
    inc(nUpDown);
    if nUpDown >= 3 then nUpDown := 3
  end
  else if Button = TUDBtnType(1) then
  begin
    dec(nUpDown);
    if nUpDown <= 1 then nUpDown := 1
  end;

  DisplayOnOff(nUpDown);
end;
// MX100 IP주소 정보 리스트 박스 보이기 변경
procedure TMX100MainForm.DisplayOnOff(MachinNo : integer);
var
  tmpAddr : string;
  onoff : boolean;
begin
  onoff := false;
  case nUpDown of
    1:
    begin
      tmpAddr := sAddress1;
      onoff := Isconnected1;
    end;
    2:
    begin
      tmpAddr := sAddress2;
      onoff := Isconnected2;
    end;
    3:
    begin
      tmpAddr := sAddress3;
      onoff := Isconnected3;
    end;
  end;
  AddressPanel.caption := tmpAddr;
  if onoff then
  begin
    ledconnected.Brush.Color := clLime;
  end
  else
  begin
    ledconnected.Brush.Color := clBlack;
  end;
end;


// 두번째 MX100에 명령어를 보내고 데이터를 받음
procedure TMX100MainForm.GetData1();
var
  nValue1: integer;
  //fStartTime: double;
  sChNo1: string;
  I : Integer;
begin

  lsbMX100.Clear;

  if gbTestEndOK then exit;

    { fStartTime := GetTickCountEx(); }

    giErrorCode := getFIFODataNoMX(giHandle1, FIFONO, startNo1, endNo1);

    if (isDataNoVBMX(startNo1) and isDataNoVBMX(endNo1)) = 1 then
    begin
      giErrorCode := talkFIFODataVBMX(giHandle1, FIFONO, startNo1, endNo1);

     { fStartTime := GetTickCountEx(); }
      while (giFlag and DAQMX_FlAG_ENDDATA) = 0 do
      begin
          giErrorCode1 := getTimeDataMX(giHandle1, dataNo1, datetime1, userTime1, giFlag);

          if giErrorCode1 <> 0 then
          begin
              //WriteDebugString( Format('MX100-Error1:%d', [giErrorCode1]) );
              Break;
          end;

      {    if (GetTickCountEx() - fStartTime) > 1000 then
          begin
              //WriteDebugString( Format('MX100-DelayError1:%f', [GetTickCountEx - fStartTime]) );
              Break;
          end;
       }
          Application.ProcessMessages;
          //Sleep(5);
      end;
      giFlag := 0;

       { fStartTime := GetTickCountEx(); }
      //while (giFlag and DAQMX_FlAG_ENDDATA) = 0 do
      for i := 1 to 60 do
      begin
        giErrorCode2 := getChDataMX(giHandle1, dataNo1, chinfo1, datainfo1, giFlag);
        if giErrorCode2 <> 0 then
        begin
            //WriteDebugString( Format('MX100-Error2:%d', [giErrorCode2]) );
            Break;
        end;

     {   if (GetTickCountEx() - fStartTime) > 1000 then
        begin
            //WriteDebugString( Format('MX100-DelayError2:%f', [GetTickCountEx - fStartTime]) );
            Break;
        end;
        }

        if chinfo1.aFIFOIndex = INDEXNO Then
          begin
            nValue1 := datainfo1.aValue;
            if nValue1 >= 32767 then
              begin
                nValue1 := 0
              end
            else if nValue1 <= -32767 then
              begin
                nValue1 := 0;
              end;
            try
              // stringList.Add(varToStr(nValue1));

              sChNo1 := Format('%.2d', [chinfo1.aChID.aChNo]);
              if chinfo1.aChID.aChNo = I  then
                stringList.Add(varToStr(nValue1))
              else
                stringList.Add('0');
//                  gStringList1.Values['[' + nowDT + ']' + sChNo1 ] := Format('%d', [nValue1]);
              //if sChNo1 = '56' then
              //  break;
              //gStringList.Add( Format('%s=%d', [sChNo, nValue]) );
            except

            end;
          end;

        Application.ProcessMessages;
        //Sleep(5);
      end;
      giFlag := 0;

    end;

    if gbTestEndOK then exit;

    if (not (giErrorCode1 in [0, 11])) or (not (giErrorCode2 in [0, 11])) then
    begin
      CommStart(False);
      CommConnect(False);

      CommConnect(True);
      CommStart(True);
    end;

  { fStartTime := GetTickCountEx(); }
  //WriteDebugString( Format('Mx Loop : %f', [ (GetTickCountEx() - fStartTime) / 1000 ]) );
end;

// 첫번째 MX100에 명령어를 보내고 데이터를 받음
procedure TMX100MainForm.GetData2();
var
  nValue2: integer;
  sChNo2: string;
  chCnt: Integer;
begin
  try

    if gbTestEndOK then exit;

    { fStartTime := GetTickCountEx(); }
    giErrorCode3 := getFIFODataNoMX(giHandle2, FIFONO, startNo2, endNo2);

    if (isDataNoVBMX(startNo2) and isDataNoVBMX(endNo2)) = 1 then
    begin
        giErrorCode3 := talkFIFODataVBMX(giHandle2, FIFONO, startNo2, endNo2);

  //     { fStartTime := GetTickCountEx(); }
        while (giFlag and DAQMX_FlAG_ENDDATA) = 0 do
        begin
            giErrorCode4 := getTimeDataMX(giHandle2, dataNo2, datetime2, userTime2, giFlag);

            if giErrorCode4 <> 0 then
            begin
                //WriteDebugString( Format('MX100-Error1:%d', [giErrorCode1]) );
                Break;
            end;

        {    if (GetTickCountEx() - fStartTime) > 1000 then
            begin
                //WriteDebugString( Format('MX100-DelayError1:%f', [GetTickCountEx - fStartTime]) );
                Break;
            end;
         }
            Application.ProcessMessages;
            //Sleep(5);
        end;
        giFlag := 0;

       { fStartTime := GetTickCountEx(); }
       // while (giFlag and DAQMX_FlAG_ENDDATA) = 0 do
       for chCnt := 1 to 60 do

        begin


          giErrorCode4 := getChDataMX(giHandle2, dataNo2, chinfo2, datainfo2, giFlag);
          if giErrorCode4 <> 0 then
          begin
              //WriteDebugString( Format('MX100-Error2:%d', [giErrorCode2]) );
              Break;
          end;

       {   if (GetTickCountEx() - fStartTime) > 1000 then
          begin
              //WriteDebugString( Format('MX100-DelayError2:%f', [GetTickCountEx - fStartTime]) );
              Break;
          end;
          }

          if chinfo2.aFIFOIndex = INDEXNO Then
            begin
              nValue2 := datainfo2.aValue;
              if nValue2 >= 32767 then
                begin
                  nValue2 := 0
                end
              else if nValue2 <= -32767 then
                begin
                  nValue2 := 0;
                end;
              try

                sChNo2 := Format('%.2d', [chinfo2.aChID.aChNo]);
                if chinfo2.aChID.aChNo = chCnt  then
                  stringList.Add(varToStr(nValue2))
                else
                  stringList.Add('0');

                // stringList.Add(varToStr(nValue2));
                //stringList.Values['[' + nowDT + ']' +  sChNo2 ] := Format('%d', [nValue2]);
                //gStringList2.Values[ sChNo ] := Format('%d', [nValue]);
                //if sChNo2 = '56' then
                //      break;
                //gStringList.Add( Format('%s=%d', [sChNo, nValue]) );
              except
                on E : Exception do
                begin
                  TMiddlewareHelper.writeLog('TMX100MainForm.GetData1 - ' + E.Message);
                end;
              end;
            end;

          Application.ProcessMessages;
          //Sleep(5);
        end;
        giFlag := 0;
    end;


    if gbTestEndOK then exit;

    if (not (giErrorCode3 in [0, 11])) or (not (giErrorCode4 in [0, 11])) then
    begin
        CommStart(False);
        CommConnect(False);

        CommConnect(True);
        CommStart(True);
    end;
  finally

  end;

end;

// 세번째 MX100에 명령어를 보내고 데이터를 받음
procedure TMX100MainForm.GetData3();
var
  nValue3: integer;
  sChNo3: string;
  I: Integer;
begin
  if gbTestEndOK then exit;

  { fStartTime := GetTickCountEx(); }
  giErrorCode5 := getFIFODataNoMX(giHandle3, FIFONO, startNo3, endNo3);

  if (isDataNoVBMX(startNo3) and isDataNoVBMX(endNo3)) = 1 then
  begin
      giErrorCode5 := talkFIFODataVBMX(giHandle3, FIFONO, startNo3, endNo3);

     { fStartTime := GetTickCountEx(); }
      while (giFlag and DAQMX_FlAG_ENDDATA) = 0 do
      begin
          giErrorCode5 := getTimeDataMX(giHandle3, dataNo3, datetime3, userTime3, giFlag);

          if giErrorCode5 <> 0 then
          begin
              //WriteDebugString( Format('MX100-Error1:%d', [giErrorCode1]) );
              Break;
          end;

      {    if (GetTickCountEx() - fStartTime) > 1000 then
          begin
              //WriteDebugString( Format('MX100-DelayError1:%f', [GetTickCountEx - fStartTime]) );
              Break;
          end;
       }
          Application.ProcessMessages;
          //Sleep(5);
      end;
      giFlag := 0;

     { fStartTime := GetTickCountEx(); }
     // while (giFlag and DAQMX_FlAG_ENDDATA) = 0 do
     for I := 1 to 60 do

      begin
        giErrorCode5 := getChDataMX(giHandle3, dataNo3, chinfo3, datainfo3, giFlag);
        if giErrorCode4 <> 0 then
        begin
            //WriteDebugString( Format('MX100-Error2:%d', [giErrorCode2]) );
            Break;
        end;

     {   if (GetTickCountEx() - fStartTime) > 1000 then
        begin
            //WriteDebugString( Format('MX100-DelayError2:%f', [GetTickCountEx - fStartTime]) );
            Break;
        end;
        }

        if chinfo3.aFIFOIndex = INDEXNO Then
          begin
            nValue3 := datainfo3.aValue;
            if nValue3 >= 32767 then
              begin
                nValue3 := 0
              end
            else if nValue3 <= -32767 then
              begin
                nValue3 := 0;
              end;
            try

               sChNo3 := Format('%.2d', [chinfo3.aChID.aChNo]);
              if chinfo3.aChID.aChNo = I  then
                stringList.Add(varToStr(nValue3))
              else
                stringList.Add('0');

         // TMiddlewareHelper.writeLog('I:' + varToStr(I) + ';' + 'CHNO:'+ varToStr(sChNo3));


               //stringList.Add(varToStr(nValue3));
               //sChNo3 := Format('%.2d', [chinfo3.aChID.aChNo]);
//              gStringList3.Values['[' + nowDT + ']' +  sChNo3 ] := Format('%d', [nValue3]);
              //gStringList2.Values[ sChNo ] := Format('%d', [nValue]);
              //if sChNo3 = '56' then
              //      break;
              //gStringList.Add( Format('%s=%d', [sChNo, nValue]) );
            except
            end;


          end;

        Application.ProcessMessages;
        //Sleep(5);
      end;
      giFlag := 0;

  end;
  if gbTestEndOK then exit;

  if (not (giErrorCode5 in [0, 11])) or (not (giErrorCode6 in [0, 11])) then
  begin
      CommStart(False);
      CommConnect(False);

      CommConnect(True);
      CommStart(True);
  end;

end;
//CLOSE BUTTON 화면 숨기고, 트레이 아이콘 보이기
procedure TMX100MainForm.imgCloseClick(Sender: TObject);
begin
 WindowState := wsMinimized;
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;
//config button 설정 화면 보이기
procedure TMX100MainForm.imgConfigClick(Sender: TObject);
begin
  MX100ConfigForm.Show;
end;
//LOG BUTTON,LOG 화면 보이기/숨기기
procedure TMX100MainForm.imgLOGClick(Sender: TObject);
begin
  if NOT lsbMX100.Visible then
    begin
      lsbMX100.Visible := true;
      lsbMX100.Align :=  alClient;
      BasePanel.Visible := false;
    end
  else
    begin
      lsbMX100.Visible := false;
      lsbMX100.Align :=  alNone;
      BasePanel.Visible := true;
    end;
end;

//STOP BUTTON, 명령어 수집 중단
procedure TMX100MainForm.imgPauseClick(Sender: TObject);
begin
  if application.MessageBox('정말 중단하시겠습니까?','수집중단',MB_ICONINFORMATION OR MB_YESNOCANCEL) = IDYES then
    begin
      CommStart(false);
      CommConnect(false);
    end;
end;
//START BUTTON, 명령어 수집 실행(시작)
procedure TMX100MainForm.imgRunClick(Sender: TObject);
begin
  ReadIni();  //config.ini로 부터 설정 읽기
  if (giHandle1 = 0) or (giHandle2 = 0) or (giHandle3 = 0)then
    begin
      CommConnect(true);
      CommStart(true);
      DisplayOnOff(1);
    end;

   //if IsConnected1 or IsConnected2 then  CommConnect(true);
  if TimerMX100.Enabled = false then
    begin
      TimerMX100.Enabled := true;
    end;
end;
//STATUS BUTTON
procedure TMX100MainForm.imgSTATUSClick(Sender: TObject);
begin
  with lsbMX100 do
    begin
      Align :=  alNone;
      Height := 307;
      Width := 320;
      Left := 264;
      Top := 51;
    end;
  BasePanel.Visible := true;
end;

// 첫번째 타이머
procedure TMX100MainForm.TimerMX100Timer(Sender: TObject);
begin
  if (ENGINE = 'E1') OR (ENGINE = 'E2') then
    E1;
end;

procedure TMX100MainForm.E1();
var
  tmpPath : string;
  tmpINI : TIniFile;
  tmpThread1, tmpThread2, tmpThread3 : TThread;
  query : String;
  oraQuery_CUD : TOraQuery;
  ds_CUD : TDataSource;
  I : Integer;
begin
  //TimerMX100.Enabled := false;

  tmpPath := appPath + IniName;
  tmpIni := TiniFile.Create(tmpPath);
//  TimerMX100.Interval := StrToint(tmpIni.ReadString('MX100','INTERVAL','0'));
//  TimerStart.Interval := 1000;

  // 첫번째 MX100에 명령어를 보내고 데이터를 받음
  GetData1();

  // 두번째 MX100에 명령어를 보내고 데이터를 받음
  GetData2();

  // 세번째 MX100에 명령어를 보내고 데이터를 받음
  GetData3();

  // LOG 창 띄우기
  if Visible and  LOGONOFF then
    begin
      lsbMX100.Items := stringList;
      lsbMX100.ItemIndex := lsbMX100.Count -1;
    end;

  // DB 저장
  oraQuery_CUD := TOraQuery.Create(nil);
  oraQuery_CUD.Connection := MiddleWareDM.OraSession1;

  oraQuery_CUD.Close;
  oraQuery_CUD.SQL.Clear;

  query := ' INSERT INTO HEMMS_E1_MX100(OCCUR_TIME, ';
  for I := 1 to stringList.count do
  begin
     query := query + 'CH_' + varToStr(I) + ',' ;
  end;
  query := copy(query, 0, length(query)-1);
  query := query + ') VALUES ( :OCCUR_TIME, ';
  for I := 1 to stringList.count do
  begin
     query := query + ':CH_' + varToStr(I) + ',' ;
  end;
  query := copy(query, 0, length(query)-1);
  query := query + ' ) ';

  oraQuery_CUD.SQL.Add(query);

  try
    MiddleWareDM.OraSession1.Open;
    try
      oraQuery_CUD.Close;

      oraQuery_CUD.ParamByName('OCCUR_TIME').Text := FormatDateTime('yyyymmddhhnnsszzz',now);
      for I := 0 to stringList.count-1 do
      begin
        if stringList[I] <> '0' then
          oraQuery_CUD.ParamByName('CH_'+varToStr(I+1)).Text := varToSTR(strToInt(stringList[I])/10000)
        else
          oraQuery_CUD.ParamByName('CH_'+varToStr(I+1)).Text := stringList[I];
      end;

      oraQuery_CUD.Execute;

    except
      on e:Exception do
        begin
          TMiddlewareHelper.writeLog('MX100Main.SaveToDBFromMx100 -' + E.Message);
        end;
    end;
  //tmpThread1 := ShowThread1.Create(true); //DB 저장 thread 생성
  //tmpThread1.Resume;                      //DB 저장 Thread 실행
    LastupdatePanel.Caption := FormatDateTime('yyyy-mm-dd hh:nn:ss',Now());
  finally
    stringList.Clear;
    FreeAndNil(oraQuery_CUD);
  end;


  { TODO :
TStringList1 객체에 GetData1(), GetDate2(), GetDate3() 조회한
채널 값을 저장하고, 쓰레드에서 전체 채널 값 입력 처리 }

end;




//MX100 시작
procedure TMX100MainForm.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := False;

  CommStart(False);
  CommConnect(False);

  CommConnect(True);
  CommStart(True);

  TimerStart.Enabled := True;
end;

procedure TMX100MainForm.TrayIcon1DblClick(Sender: TObject);
begin
  TrayIcon1.Visible := false;
  Show();
  WindowState := wsNormal;
  Application.BringToFront;
end;

//MX100 연결(bOnOff 가 참이면 연결/ 거짓이면 연결 닫기)
procedure TMX100MainForm.CommConnect(bOnOff: boolean);
begin
  if bOnOff then
  begin
      //sAddress := '192.168.0.200';
      //sAddress1 := '192.168.0.201';
      //sAddress1 := '192.168.0.202';
      if (sAddress1 = '') Or (sAddress2 = '') Or (sAddress3 = '') then exit;
      if giHandle1 = 0 then
        begin
          giHandle1 := openMX(AnsiString(sAddress1), giErrorCode);
        end;
      if giHandle2 = 0 then
        begin
          giHandle2 := openMX(AnsiString(sAddress2), giErrorCode);
        end;
      if giHandle3 = 0 then
        begin
          giHandle3 := openMX(AnsiString(sAddress3), giErrorCode);
        end;
      //showmessage(inttostr(gihandle));
      ////////////////////////////////////////////////////////////////////
      ///  MX NO.1  CONNECTION
      if (giHandle1 <> 0) and (IsConnected1 = false) then
        begin
          StatusBar.Panels.Items[0].Text := sAddress1 + ':CONNECTED';
          IsConnected1 := true;
        end
      else
        begin
          StatusBar.Panels.Items[0].Text := sAddress1 + ':DISCONNECT';
          IsConnected1 := false;
        end;
       ////////////////////////////////////////////////////////////////////
      ///  MX NO.2  CONNECTION
       if (giHandle2 <> 0) and (IsConnected2 = false) then
        begin
          StatusBar.Panels.Items[1].Text := sAddress2 + ':CONNECTED';
          IsConnected2 := true;
        end
      else
        begin
          StatusBar.Panels.Items[1].Text := sAddress2 + ':DISCONNECT';
          IsConnected2 := false;
        end;
      ////////////////////////////////////////////////////////////////////
      ///  MX NO.3  CONNECTION
      if (giHandle3 <> 0) and (IsConnected3 = false) then
        begin
          StatusBar.Panels.Items[2].Text := sAddress3 + ':CONNECTED';
          IsConnected3 := true;
        end
      else
        begin
          StatusBar.Panels.Items[2].Text := sAddress3 + ':DISCONNECT';
          IsConnected3 := false;
        end;
    end
  else
    begin
      IsConnected1 := false;
      IsConnected2 := false;
      IsConnected3 := false;
      if giHandle1 <> 0 then
        begin
          CommStart(False);
          //DelayEx(200, True);
          closeMX(giHandle1);
          StatusBar.Panels.Items[0].Text := sAddress1 + ':DISCONNECT';
          giHandle1 := 0;
        end;
      if giHandle2 <> 0 then
        begin
          CommStart(False);
          //DelayEx(200, True);
          closeMX(giHandle2);
          StatusBar.Panels.Items[1].Text := sAddress2 + ':DISCONNECT';
          giHandle2 := 0;
        end;
      if giHandle3 <> 0 then
        begin
          CommStart(False);
          //DelayEx(200, True);
          closeMX(giHandle3);
          StatusBar.Panels.Items[2].Text := sAddress3 + ':DISCONNECT';
          giHandle3 := 0;
        end;
  end;
end;

//config.ini로 부터 설정 정보 읽기
procedure TMX100MainForm.Readini();
var
  tmpPath : string;
  tmpINI : TIniFile;
begin
  tmpPath :=  appPath + iniName;
  if FileExists(tmpPath) then
    begin
      tmpINI := TiniFile.Create(tmpPath);
      try
        sAddress1 := tmpini.ReadString('MX100','IPADDRESS1','192.168.0.100');
        sAddress2 := tmpini.ReadString('MX100','IPADDRESS2','192.168.0.101');
        sAddress3 := tmpini.ReadString('MX100','IPADDRESS3','192.168.0.102');
        EngName :=  tmpini.ReadString('ENGINE','NAME','0');
        ENGINE := tmpini.ReadString('ENGINE','CODE','0');
        pnlEngtype.Caption := EngName;
        pnlSlaveId.Caption := ENGINE;
      finally
        tmpini.Free;
      end;
      //strIniAddr := tmpini.ReadString('MX100','IPADDRESS3','0');
      //addresspanel.Caption := strIniAddr;
      //strIniInterval := tmpini.ReadString('WT500','INTERVAL','500');
      //WT500Timer.Interval := StrToInt(strIniInterval);
    end
  else
    begin
      tmpINI := TiniFile.Create(tmpPath);
      try
        tmpini.WriteString('WT500','IPADDRESS','192.168.0.55');
        tmpini.WriteString('WT500','INTERVAL','500');
        tmpini.WriteString('MX100','IPADDRESS1','192.168.0.100');
        tmpini.WriteString('MX100','IPADDRESS2','192.168.0.101');
        tmpini.WriteString('MX100','IPADDRESS3','192.168.0.102');
        tmpini.WriteString('MX100','INTERVAL','500');
      finally
        tmpIni.Free;
      end;
    end;
end;

end.
