unit Trouble_Unit;

interface

uses
  Main_Unit,Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, NxEdit, Vcl.StdCtrls, AdvGroupBox,
  AdvOfficeButtons, NxCollection, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, NxPageControl, Vcl.ImgList, NxColumnClasses, NxColumns,
  Vcl.ComCtrls, StrUtils, Vcl.ExtDlgs, DB, AdvOfficeStatusBar, ExcelUtil,
  Vcl.Menus, AdvMenus, Vcl.ActnList, Ora, GDIPPictureContainer, bde.DBTables,
  AdvDateTimePicker, System.Actions;

const FTP_SERVER_IP = '10.100.23.115';

type
  TDelFile = Record
    Flag : String[1];
    FileNm : String[50];
    FileSize : String[15];
end;

type
  TMobileContent = Packed Record
    MCODEID : String;
    MSTATUS : String;
    MITEMNAME : String;
    MREASON : String;
    MEngType : String;
    MRPTYPE : Integer;
    MInDate : String;

end;

type
  TTrouble_Frm = class(TForm)
    Panel1: TPanel;
    Image3: TImage;
    Image2: TImage;
    AppGrid: TAdvStringGrid;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel2: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel11: TPanel;
    Label11: TLabel;
    grptype: TAdvOfficeRadioGroup;
    Panel33: TPanel;
    Panel36: TPanel;
    Label5: TLabel;
    Panel60: TPanel;
    CODEID: TNxEdit;
    CLAIMNO: TNxEdit;
    Panel37: TPanel;
    Panel61: TPanel;
    Label7: TLabel;
    TITLE: TNxEdit;
    Panel65: TPanel;
    Panel66: TPanel;
    Label6: TLabel;
    Panel67: TPanel;
    ENGNAME: TNxEdit;
    PROJNO: TNxEdit;
    Panel63: TPanel;
    ENGTYPE: TNxEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel12: TPanel;
    PROJNAME: TNxEdit;
    SHIPNO: TNxEdit;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    TOWNER: TNxEdit;
    SITE: TNxEdit;
    Panel16: TPanel;
    RPM: TNxComboBox;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    ACTIONCODE: TNxComboBox;
    WORKTIME: TNxNumberEdit;
    Panel32: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel38: TPanel;
    FORUSE: TNxComboBox;
    REGTYPE: TNxComboBox;
    REFTYPE: TNxComboBox;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Button2: TButton;
    EMPNO: TNxComboBox;
    INEMPNO: TNxComboBox;
    Button3: TButton;
    SENDDATE: TNxDatePicker;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Button4: TButton;
    HIEMPNO: TNxComboBox;
    HIINEMPNO: TNxComboBox;
    Button5: TButton;
    RCVDATE: TNxDatePicker;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    STEPSTAT: TNxComboBox;
    StepText: TNxEdit;
    CCListN: TNxEdit;
    CCListS: TNxEdit;
    Button6: TButton;
    NxPageControl1: TNxPageControl;
    NxTabSheet1: TNxTabSheet;
    NxTabSheet2: TNxTabSheet;
    NxTabSheet3: TNxTabSheet;
    NxHeaderPanel2: TNxHeaderPanel;
    NxHeaderPanel3: TNxHeaderPanel;
    NxSplitter1: TNxSplitter;
    NxFlipPanel1: TNxFlipPanel;
    Panel39: TPanel;
    Button7: TButton;
    Button8: TButton;
    Image1: TImage;
    Panel40: TPanel;
    Panel41: TPanel;
    Panel42: TPanel;
    Panel43: TPanel;
    Panel44: TPanel;
    ITEMNAME: TNxEdit;
    Panel46: TPanel;
    Panel47: TPanel;
    Panel48: TPanel;
    ADATE: TNxDatePicker;
    Panel49: TPanel;
    Panel50: TPanel;
    PROCESS: TNxEdit;
    Panel51: TPanel;
    PDATE: TNxDatePicker;
    Panel52: TPanel;
    NxHeaderPanel4: TNxHeaderPanel;
    Panel53: TPanel;
    Panel54: TPanel;
    STATUSTITLE: TNxEdit;
    Panel56: TPanel;
    Panel57: TPanel;
    STATUS: TRichEdit;
    NxHeaderPanel5: TNxHeaderPanel;
    FileGrid1: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    Panel58: TPanel;
    Button10: TButton;
    Imglist16x16: TImageList;
    Button9: TButton;
    Panel59: TPanel;
    Button11: TButton;
    Button12: TButton;
    Panel62: TPanel;
    NxHeaderPanel6: TNxHeaderPanel;
    Panel68: TPanel;
    Panel80: TPanel;
    NxHeaderPanel8: TNxHeaderPanel;
    Panel81: TPanel;
    Panel82: TPanel;
    ReasonTitle: TNxEdit;
    Panel83: TPanel;
    Panel84: TPanel;
    Reason: TRichEdit;
    NxHeaderPanel7: TNxHeaderPanel;
    Panel55: TPanel;
    Panel64: TPanel;
    Plantitle: TNxEdit;
    Panel69: TPanel;
    Panel70: TPanel;
    plan: TRichEdit;
    NxHeaderPanel9: TNxHeaderPanel;
    Panel71: TPanel;
    Button13: TButton;
    Button14: TButton;
    NxHeaderPanel10: TNxHeaderPanel;
    Panel72: TPanel;
    Panel73: TPanel;
    NxHeaderPanel13: TNxHeaderPanel;
    Panel87: TPanel;
    Button15: TButton;
    Button16: TButton;
    Panel78: TPanel;
    NxHeaderPanel11: TNxHeaderPanel;
    Panel74: TPanel;
    panel75: TPanel;
    Reason1Title: TNxEdit;
    Panel76: TPanel;
    Panel77: TPanel;
    Reason1: TRichEdit;
    NxHeaderPanel12: TNxHeaderPanel;
    Panel79: TPanel;
    Panel85: TPanel;
    ResultTitle: TNxEdit;
    Panel86: TPanel;
    Panel88: TPanel;
    RESULTa: TRichEdit;
    NxHeaderPanel14: TNxHeaderPanel;
    ACGrid1: TAdvStringGrid;
    Panel146: TPanel;
    Panel89: TPanel;
    Panel90: TPanel;
    Panel91: TPanel;
    Panel92: TPanel;
    Panel93: TPanel;
    Panel94: TPanel;
    Panel95: TPanel;
    Panel96: TPanel;
    Panel97: TPanel;
    Panel98: TPanel;
    Panel99: TPanel;
    Panel100: TPanel;
    Panel101: TPanel;
    Panel102: TPanel;
    Panel111: TPanel;
    ResultC1: TNxEdit;
    Panel132: TPanel;
    ResultC2: TNxEdit;
    Panel135: TPanel;
    Panel147: TPanel;
    ResultC3: TNxNumberEdit;
    Panel136: TPanel;
    Panel148: TPanel;
    ResultC4: TNxNumberEdit;
    Panel137: TPanel;
    Panel149: TPanel;
    ResultC5: TNxNumberEdit;
    Panel138: TPanel;
    Panel139: TPanel;
    Panel140: TPanel;
    Panel141: TPanel;
    Panel142: TPanel;
    Panel143: TPanel;
    Panel144: TPanel;
    Panel145: TPanel;
    ResultC6: TNxNumberEdit;
    CpPanel: TNxPanel;
    Panel103: TPanel;
    DesignApp: TNxComboBox;
    Panel104: TPanel;
    ApplyEmpno: TNxComboBox;
    EDate: TNxDatePicker;
    Panel105: TPanel;
    FUpList: TNxComboBox;
    FileGrid0: TNextGrid;
    NxIncrementColumn5: TNxIncrementColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    NxTextColumn18: TNxTextColumn;
    FileGrid2: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    FileGrid3: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    Button17: TButton;
    Panel107: TPanel;
    Panel108: TPanel;
    DIVLIC: TNxComboBox;
    Panel106: TPanel;
    TroubleList: TNextGrid;
    NxIncrementColumn4: TNxIncrementColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    Button18: TButton;
    Button19: TButton;
    ENGNUM: TNxNumberEdit;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenDialog1: TOpenDialog;
    NxButton11: TButton;
    P_Reset: TButton;
    RpDel: TButton;
    summitbtn: TButton;
    TempSave: TButton;
    TempUpdate: TButton;
    C_Rp: TButton;
    fRegbtn: TButton;
    MasterDel: TButton;
    FResultBtn: TButton;
    CompleBtn: TButton;
    Label3: TLabel;
    Statusbar1: TAdvOfficeStatusBar;
    Timer1: TTimer;
    Timer2: TTimer;
    Trkind: TAdvOfficeCheckGroup;
    SaveDialog1: TSaveDialog;
    AppPopup: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    Button21: TButton;
    Label4: TLabel;
    AdvPopupMenu1: TAdvPopupMenu;
    N1: TMenuItem;
    ActionList1: TActionList;
    Download_Attachment_File: TAction;
    SaveDialog2: TSaveDialog;
    MobileNo: TPanel;
    MCODEID: TNxEdit;
    GDIPPictureContainer1: TGDIPPictureContainer;
    SDATE: TAdvDateTimePicker;
    procedure grptypeClick(Sender: TObject);
    procedure ENGNAMEClick(Sender: TObject);
    procedure EMPNOKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure INEMPNOKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HIEMPNOKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HIINEMPNOKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure STEPSTATChange(Sender: TObject);
    procedure STATUSClick(Sender: TObject);
    procedure STATUSChange(Sender: TObject);
    procedure ReasonClick(Sender: TObject);
    procedure planClick(Sender: TObject);
    procedure Reason1Click(Sender: TObject);
    procedure RESULTaClick(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AppGridGetWordWrap(Sender: TObject; ACol, ARow: Integer;
      var WordWrap: Boolean);
    procedure ACGrid1GetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure Button12Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure TempSaveClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FileGrid0SelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure Image1DblClick(Sender: TObject);
    procedure summitbtnClick(Sender: TObject);
    procedure TempUpdateClick(Sender: TObject);
    procedure P_ResetClick(Sender: TObject);
    procedure RpDelClick(Sender: TObject);
    procedure NxButton11Click(Sender: TObject);
    procedure MasterDelClick(Sender: TObject);
    procedure fRegbtnClick(Sender: TObject);
    procedure C_RpClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure AppGridRightClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure N3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FResultBtnClick(Sender: TObject);
    procedure CompleBtnClick(Sender: TObject);
    procedure Download_Attachment_FileExecute(Sender: TObject);
    procedure FileGrid1SelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure FileGrid2SelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure FileGrid3SelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
  private
    { Private declarations }
    FFirst : Boolean;

    FDelInfo : Array of TDelFile;
    FDelCnt : integer;
    FxRow,FxCol : integer;
    FTroubleFrmChanged : Boolean;
    FFileGridNo : integer;
  public
    { Public declarations }
    FOwner : TMain_Frm;
    FOpenCase : Integer;
    FRpCode : String;
    FUserPriv : integer;

    PMTRContent : TMobileContent;

    //=======결재선 지정 변수 ======================
    FAppCount : Integer; //결재선 카운트
    FAprovalArr : Array[0..4] of String; // 결재선 사번
    FReturnContent : String; //반려내용

    procedure Open_Engine_Info;
    procedure Check_for_Docu_Step;
    procedure Get_of_EDMS_ITEMS;

    procedure Check_for_FileGrid_and_Upload_2_TBACS;
    procedure Upload_Files_within_FileGrid(Flag,Fpath,FNm,Fsize,Fext:String);
    procedure Input_of_New_Report_InCharger;

    procedure TroubleData_Move_To_MainTable(FOCODE:String); // 결재 완료 후 Trouble_Data로 자료 이동
    procedure Update_TroubleRP_CODE_TO_TSMS(FNCODE,FOCODE:String);//TRouble_Report 임시코드를 TSMS 코드로 업데이트
    // 문제점 데이터 조회 ===============================
    procedure Call_a_TroubleReport(FCODEID:String);
    procedure TroubleData_Get_From_DB(FCODEID:String);// DB에서 문제점데이터 가져오기
    procedure Get_CClist_From_Trouble_CCList(FCODEID:String);
    procedure Get_Attachment_From_Trouble_attfiles(FCODEID,MCODEID:String);

    //======= 임시 문서 저장부 ======================
    function Check_for_Mandatory_Items : Boolean;
    procedure Trouble_Temp_CODE_Generator; // 임시 코드 번호 생성...
    procedure Trouble_Save_to_Trouble_Datatemp;
    function TroubleData_Save_To_DB: Boolean; // 데이터 저장
    procedure CCList_2_DataBase(FCODEID:String);// 참조자 리스트 데이터 베이스에 저장
    procedure Registor_of_New_Report_Log(FCODEID,FCharge:String;FKind:integer); //로그 등록

    // 수정
    function TroubleDataTemp_Update_To_DB : Boolean;//TT 상태 업데이트
    function TroubleData_Update_To_DB : Boolean; // 데이터 업데이트
    procedure Delete_TroubleRP_Temp_Data(FCODEID : String);
    function Check_for_Doc_Status : integer;

    function Modify_permissions_for_report : Boolean; //보고서수정 버튼 권한
    function Complete_permissions_for_report : Boolean; //보고서 완료버튼 권한
    function summit_permissions_for_report : Boolean; //결재상신버튼 권한
    function Delete_permissions_for_report : Boolean; //삭제버튼 권한

    //메세지 전송
    procedure Send_Message_to_After_Approved(FCODEID:String);// 결재 후 다음 결재자에게 메세지 보내기 함수
    procedure Send_Message_to_Design_Charge; //설계 담당자에게 통보
    procedure Send_Message_to_CarbonCharge; // 참조대상에서 통보
    procedure Send_Message_to_Charge_Report_Complete; //설계담당자가 작성자에게 문서 조치 완료 통보
    procedure Send_Message_to_Inempno(Approved, nApproved:String);// 결재진행상황 작성자에게 통보
    procedure Send_Message_Main_CODE(FFlag,FSendID,FRecID,FHead,FTitle,FContent:String); // 메세지 메인 함수

    //문제예상보고서
    procedure Trouble_expectation_CODE_Generator;// 문제 예상 보고서 코드번호 생성

    //TSMS
    procedure Generator_CODEID_of_TSMS; // TSMS CODEID 생성
    procedure Generator_CODEID_of_TSMS2; // TSMS CODEID 생성
    procedure Turn_to_Back_Before_TSMSCODE(FNCODE,FOCODE:String); //이전 TSMS CODE 되돌리기
    procedure Turn_to_Back_Before_TSMSCODE2(FNCODE,FOCODE:String); //이전 TSMS CODE 되돌리기
    function TroubleData_Save_To_TSMS : Boolean; //TSMS에 문제점 보고서 등록!!
    procedure TroubleFiles_Info_Upload_To_TSMS(FNCODE,FOCODE:String); // 첨부파일 등록
    function TSMS_FTP_Server_Connection : Boolean;
    procedure TSMS_FTP_Server_Directory_Setting(FFlag : String);
    procedure Register_Trouble_Data_To_TSMS; //결재 완료 후 TSMS에 보고서 등록

    //결재 관련 ===================================================
    procedure Approval_Grid_Setting(ApprovalCnt:integer);// 결재란 세팅
    function Save_of_Approval : Boolean; // 결재선 저장 함수의 집합
    function Approver_to_ZHITEMS_APPROVER : Boolean;
    function Approved_info_to_ZHITEMS_APPROVEP_D : Boolean;
    procedure Approval_Info_Apply_To_Table(FCODEID:String);
    procedure Approval_Sign_Apply_To_Table;
    procedure Approved_of_Representatives;
    function Check_for_DB_In_EMPNO:Boolean;
    procedure Approved_apply_to_ZHITEMS_APPROVEP(FCODE,FnCharger:String;FPending:INTEGER);
    procedure Return_Process;//보고서 반려
    function Return_for_Message(FCODE:String) : Boolean;//반려내용을 반환
    function Return_to_First_Step(FCODEID,FCharge:String;FPending:integer):Boolean;

    //조치결과 저장
    procedure Follow_Up_of_Trouble_Data_TBACS(FCODEID:String);//조치사항 저장
    procedure Follow_Up_of_Trouble_Data_TSMS(FCODEID:String);//조치사항 저장
    procedure Follow_Up_of_Trouble_AttFiles_(FCODEID:String);//조치사항 저장
    procedure Follow_Up_of_Trouble_AttFiles_TSMS(FCODE:String); // 첨부파일 등록

    //보고서 출력
    procedure TBACS_FTP_SERVER_Connection;
    function Get_Report_Fomat_From_FTP : Boolean;

    //기타 기능...
    procedure Get_Trouble_Image(FCODEID, FMCODE:String);
    procedure Show_Trouble_Image(FCODEID, FMCODE:String;FImgCnt:integer);
    procedure Btn_arrangement_after_check_for_DocStatus;
    procedure Initialize_of_Trouble_Frm;
    procedure Generating_Trouble_Report;
    function Select_User_Info(fUserId:String) : String;

    procedure Update_TroubleTemp_approved_Field;
    function Get_UserName(aUSERID:String):String;

    //Mobile
    procedure Start_Detail_Write_for_Mobile_Content;
    procedure InEMP_User_Check_for_TRouble_List(FCODEID:String; FIdx:Integer); //담당자가 문서를 확인

  end;

var
  Trouble_Frm: TTrouble_Frm;
  Excel: Variant;
  MyShape : Variant;
  WorkBook: Variant;//ExcelWorkbook;
  Fworksheet: OleVariant;
  Fworksheet1: OleVariant;

implementation

uses
  addRefer_Unit,
  DataModule_Unit, EngGeneral_Unit, TroubleCd_Unit, Approvaln_Unit,
  CommonUtil_Unit, imagefunctions_Unit, HHI_WebService, UnitHHIMessage,
  CODE_FUNCTION, ReturnMsg_Unit, DownLoad_, findUser_Unit;

{$R *.dfm}

procedure TTrouble_Frm.ACGrid1GetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  case Acol of
    2 : AEditor := edDateEdit;
  end;
end;

procedure TTrouble_Frm.Download_Attachment_FileExecute(Sender: TObject);
var
  LForm : TDownLoadF;
  LFileGrid : TNextGrid;
  li: Integer;
  LStr, LStr1 : String;
begin
  if not(FFileGridNo = -1) then
  begin
    LFileGrid := TNextGrid(Self.FindComponent('FileGrid'+IntToStr(FFileGridNo)));
    if not(LFileGrid.SelectedRow = -1) then
    begin
      LForm := TDownLoadF.Create(nil);
      try
        with LForm do
        begin
          FOwner := Self;
          FDownOwner :=  'Trouble';
          Label5.Caption := LFileGrid.Cells[2,FxRow];

          LStr := ExTractFileEXT(LFileGrid.Cells[2,FxRow]);
          LStr1 := GetToken(LStr,'.');

          Label6.Caption := LStr + ' File';
          ShowModal;

        end;
      finally
        FreeAndNil(LForm);
      end;
    end;
  end;
end;

procedure TTrouble_Frm.AppGridGetWordWrap(Sender: TObject; ACol, ARow: Integer;
  var WordWrap: Boolean);
begin
  case ACol of
    0 : WordWrap := True;
  end;
end;

procedure TTrouble_Frm.AppGridRightClickCell(Sender: TObject; ARow,
  ACol: Integer);
var
  LCharge : String;
  LPending : integer;
  LCCount : integer;
begin
  FxCol := ACol;

  if not(ACol = 1) and (ARow = 1) then
  begin
    if (LeftStr(CODEID.Text,2)='TS') or (LeftStr(CODEID.Text,2)='TX') then Exit;

    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select A.*, B.Pending from ZHITEMS_APPROVER A, ZHITEMS_APPROVEP B');
      SQL.Add('where A.CODEID = :param1 and A.CODEID = B.CODEID');
      parambyname('param1').AsString := CODEID.Text;
      Open;

      if not(RecordCount = 0) then
      begin
        LCCount := Fieldbyname('ACount').AsInteger;
        Lpending := Fieldbyname('Pending').AsInteger;

        if LCCount = LPending then
          ShowMessage('결재 완료된 문서입니다.');

        LCharge := Fields[2+ACol].AsString;
      end
      else
        Exit;
    end;

    if not(LCharge = StatusBar1.Panels[4].Text) then
    begin
      ShowMessage('결재 대상자가 아닙니다.');
      Exit;
    end
    else
      APPPOPUP.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
  end;
end;

procedure TTrouble_Frm.Approval_Info_Apply_To_Table(FCODEID: String);
var
  LUSERID : Array of String;
  LIndate : TDatetime;
  LCount : integer;
  LBoolean : Boolean;
  li : integer;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from ZHITEMS_APPROVER');
    SQL.Add('where CODEID = :param1');
    Parambyname('Param1').AsString := FCODEID;
    Open;

    if not(RecordCount = 0) then
    begin
      LCount := FieldBYName('ACOUNT').AsInteger;
      FAppCount := FieldBYName('ACOUNT').AsInteger;

      SetLength(LUserID,LCount);

      for li := 0 to 4 do
        FAprovalArr[Li] := '';

      for li := 0 to LCount-1 do
      begin
        LUserID[li] := Fields[3+li].AsString;
        FAprovalArr[Li] := Fields[3+li].AsString;
      end;
      LBoolean := False;
    end
    else
    begin
      with DM1.TQuery2 do
      begin
        if not(CODEID.Text = '') then
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select INEMPNO, INDATE from Trouble_Data where CODEID = :param1');
          parambyname('param1').AsString := CODEID.Text;
          Open;
          if not(RecordCount = 0) then
          begin
            LCount := 1;
            SetLength(LUserID,LCount);
            LUserID[0] := Fieldbyname('INEMPNO').AsString;
            LIndate := Fieldbyname('INDATE').AsDateTime;
            LBoolean := True;
          end;
        end;
      end;
    end;
  end;//with

  //결재선 정보
  {
  for li := 0 to LCount-1 do
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select A.*, B.CODENM from User_Info A, ZHITEMSCODE B');
      SQL.Add('where USERID = :param1 and A.CLASS = B.CODE');
      Parambyname('param1').AsString := LUserID[li];
      Open;

      AppGrid.Cells[1+li,0] := Fieldbyname('CODENM').AsString+'/'+
                                   Fieldbyname('Name_Kor').AsString;

    end;
  end;
  }

  if LBoolean = False then
  begin
    for li := 0 to LCount-1 do
    begin
      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from ZHITEMS_APPROVED');
        SQL.Add('where CODEID = :param1');
        Parambyname('param1').AsString := FCODEID;
        Open;

        if not(RecordCount = 0) then
        begin
          if not(Fields[2+li].AsString = '') then
            AppGrid.Cells[li+1,2] := FormatDateTime('YY.MM.DD',Fields[2+li].AsDateTime);
        end;
      end;
    end;
    Approval_Sign_Apply_To_Table;//결재자 사인 적용하기
  end
  else
    AppGrid.Cells[1,2] := FormatDateTime('YY.MM.DD',LIndate);
end;

procedure TTrouble_Frm.Approval_Sign_Apply_To_Table;
var
  LACOUNT : integer; //결재선 수..
  LPending : integer;

  li : integer;

  LCharge : Array of String;
  LProc : Array of integer;
  LBmp : TBitmap;

  TS : TStream;
  JPG : TJpegImage;
  LPic : TPicture;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select A.*, B.* from ZHITEMS_APPROVER A, ZHITEMS_APPROVEP B');
    SQL.Add('where A.CODEID = :param1 and A.Codeid = B.Codeid');
    parambyname('param1').AsString := Codeid.Text;
    Open;


    LACOUNT := FieldByName('ACount').AsInteger;

    SetLength(LCharge,LACOUNT);
    SetLength(LProc, LACOUNT);

    for li := 0 to LACOUNT-1 do
    begin
      LCharge[li] := Fields[3+li].AsString; // 등록자 담당자
      LProc[li]   := Fields[10+li].AsInteger;// 결재상태
    end;
  end;

  for li := 0 to LACOUNT -1 do
  begin
    if LProc[li] = 1 then
    begin
      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from User_Info_Image');
        SQL.Add('where UserID = :param1');
        Parambyname('param1').AsString := LCharge[li];
        Open;

        if not(RecordCount = 0) then
        begin
          try
            TS := TStream.Create;
            LBmp := Tbitmap.Create;
            LPic := TPicture.Create;

            TS := createblobstream(fieldbyname('Sign'), bmread);

            if TS.Size > 0 then
            begin
              LBmp.LoadFromStream(TS);
              LPic.Assign(LBmp);
              AppGrid.CreatePicture(li+1,1,True,Stretch,0,haleft,vatop).Assign(LPic);
            end
            else
            begin
              AppGrid.Cells[li+1,1] := '결재완료'+#13#10#13#10+'(사인없음)';
            end;
          finally
            TS.Free;
            LBmp.Free;
            LPic.Free;
            AppGrid.Refresh;
          end;
        end;
      end;
    end;
  end;//for
end;

procedure TTrouble_Frm.Approval_Grid_Setting(ApprovalCnt: integer);
var
  LCol : integer;
  Li : integer;
begin
  with AppGrid do
  begin
    BeginUpdate;
    Clear;
    LCol := ApprovalCnt + 1;
    ColCount := LCol; //결재란 칸수 세팅
    MergeCells(0,0,1,3);

    DefaultColWidth := 75;
    AppGrid.FixedColWidth := 25;

    Case LCol of
      2 : Width := 104;
      3 : Width := 179;
      4 : Width := 254;
      5 : Width := 329;
      6 : Width := 404;
    end;

    for li := 0 to ColCount-1 do
    begin
      Alignments[li,0] := taCenter;
      Alignments[li,1] := taCenter;
      Alignments[li,2] := taCenter;
    end;
//    ColumnHeaders.Text := '          결  재';

    if not(ApprovalCnt = 0) then
    begin
      AppGrid.Visible := True;
      AppGrid.TabOrder := 0;
      Button17.TabOrder := 1;
    end
    else
    begin
      AppGrid.Visible := False;
    end;

    Panel1.Invalidate;
    EndUpdate;
    Refresh;
  end;
end;

procedure TTrouble_Frm.Approved_apply_to_ZHITEMS_APPROVEP(FCODE,FnCharger:String;FPending:INTEGER);
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update ZHITEMS_APPROVEP Set');

    Case FPending of
      1 : SQL.Add('Pending = :param1, Approval1 = :param2, status = :status  where CODEID = :param3');
      2 : SQL.Add('Pending = :param1, Approval2 = :param2, status = :status  where CODEID = :param3');
      3 : SQL.Add('Pending = :param1, Approval3 = :param2, status = :status  where CODEID = :param3');
      4 : SQL.Add('Pending = :param1, Approval4 = :param2, status = :status  where CODEID = :param3');
      5 : SQL.Add('Pending = :param1, Approval5 = :param2, status = :status  where CODEID = :param3');
    end;
    parambyname('param3').AsString := FCODE;

    parambyname('param1').AsInteger := FPending;
    parambyname('param2').AsInteger := 1;

    if not(FnCharger = '') then //fnCharge = 0 이면 다음 결재자가 없는것, 문서 결재 완료 처리함
      parambyname('status').AsInteger  := 1
    else
      parambyname('status').AsInteger  := 3; // State = 1: 작성중, 2: 반려, 3:결재완료

    ExecSQL;
  end;

  //Trouble_ConfirmD 결재일 업데이트!!
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update ZHITEMS_APPROVED Set');

    Case FPending of
      1 : SQL.Add('Pending = :param1, Approval1 = :param2 where CODEID = :param3');
      2 : SQL.Add('Pending = :param1, Approval2 = :param2 where CODEID = :param3');
      3 : SQL.Add('Pending = :param1, Approval3 = :param2 where CODEID = :param3');
      4 : SQL.Add('Pending = :param1, Approval4 = :param2 where CODEID = :param3');
      5 : SQL.Add('Pending = :param1, Approval5 = :param2 where CODEID = :param3');
    end;
    parambyname('param3').AsString := FCODE;

    parambyname('param1').AsInteger := FPending;

    parambyname('param2').AsDateTime := Now;
    ExecSQL;
  end;

  if not(AppGrid.ColCount <= 2) then
    AppGrid.Cells[FxCol,2] := FormatDateTime('YY.MM.DD',Now)
  else
    AppGrid.Cells[1,2] := FormatDateTime('YY.MM.DD',Now);

  Approval_Sign_Apply_To_Table; //사인 적용
end;

function TTrouble_Frm.Approved_info_to_ZHITEMS_APPROVEP_D: Boolean;
var
  li : integer;
begin
  try
    Result := False;
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert Into ZHITEMS_APPROVEP');
      SQL.Add('Values(:CODEID, :Pending, :APPROVAL1, :APPROVAL2, :APPROVAL3, :APPROVAL4, :APPROVAL5, :STATUS)');


      Parambyname('CODEID').AsString     := CODEID.Text;
      Parambyname('Pending').AsInteger   := 0; //1 = 담당자 결재상신한 상태
      Parambyname('APPROVAL1').AsInteger := 0; //담당자
      Parambyname('APPROVAL2').AsInteger := 0; // 결재1
      Parambyname('APPROVAL3').AsInteger := 0; // 결재2
      Parambyname('APPROVAL4').AsInteger := 0; // 결재3
      Parambyname('APPROVAL5').AsInteger := 0; // 결재4
      Parambyname('STATUS').AsInteger    := 0; // 0: 작성중, 1:결재진행중, 2:반려, 3 결재완료
      ExecSQL;
    end;//with

    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert Into ZHITEMS_APPROVED');
      SQL.Add('Values(:CODEID, :Pending, :APPROVAL1, :APPROVAL2, :APPROVAL3, :APPROVAL4, :APPROVAL5)');

      Parambyname('CODEID').AsString    := CODEID.Text;
      Parambyname('Pending').AsInteger  := 0; //1 = 담당자 결재상신한 상태
  //    Parambyname('Charge').AsDateTime      := Now;

  //    Parambyname('Confirm1').AsInteger := 0; // 결재1
  //    Parambyname('Confirm2').AsInteger := 0; // 결재2
  //    Parambyname('Confirm3').AsInteger := 0; // 결재3
  //    Parambyname('Confirm4').AsInteger := 0; // 결재4
      ExecSQL;
    end;//with
    Result := True;
  except
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM ZHITEMS_APPROVER where CODEID = :param1');
      parambyname('param1').AsString := CODEID.Text;
      ExecSQL;
      ShowMessage('결재선 저장에 실패하였습니다.');
    end;
  end;
end;

procedure TTrouble_Frm.Approved_of_Representatives;
var
  LCCount, LPending : integer;
  LCharge : String;
  LN : integer;
  LNCharge : String;//현재 결재자 다음 결재자

begin
  // 결재선 카운트와 진행단계
  try
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select A.*, B.Pending from ZHITEMS_APPROVER A, ZHITEMS_APPROVEP B');
      SQL.Add('where A.CODEID = :param1 And A.CodeID = B.CodeID');
      Parambyname('param1').AsString := CODEID.Text;
      Open;

      LCCount := FieldByName('ACount').AsInteger;  //결재선이 몇명인지 기록
      LPending := FieldByName('Pending').AsInteger; //현재 문서 진행상태.. 어디까지 결재 되었나?

      if LPending = 0 then
      begin
        ShowMessage('결재 미상신 보고서 입니다..');
        Exit;
      end;

      LPending := LPending + 1;// 결재 대상자
      LN := LPending + 1;

      if not(Statusbar1.Panels[1].Text = 'S') then
      begin
        if not(LPending > LCCount) then
        begin
          LCharge := Fields[2+LPending].AsString;//현재 결재 대상자

          if not(LCCount = 5) then
            LnCharge := Fields[2+LN].AsString //현재 결재 대상자 다음 결재자 존재 여부 확인
          else
            LnCharge := '';

          if not(LPending = LCCount) and not(LnCharge = '')  then
          begin

            if Check_for_DB_In_EMPNO = False then
            begin
              If MessageDlg('설계 담당자가 등록되지 않았습니다.'+#13+'다음 결재자에게 전달 하시겠습니까?'
                            , mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
              begin
                Approved_apply_to_ZHITEMS_APPROVEP(CODEID.Text,LnCharge,LPending);
                Registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,4);//수정로그
                Send_Message_to_After_Approved(CODEID.Text);
                ShowMessage('승인 되었습니다.');
                Send_Message_to_Inempno(LCharge,LnCharge);
                Exit;
              end;
            end
            else
            begin
              Approved_apply_to_ZHITEMS_APPROVEP(CODEID.Text,LnCharge,LPending);
              Registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,4);//수정로그
              Send_Message_to_After_Approved(CODEID.Text);
              Send_Message_to_Inempno(LCharge,LnCharge);//작성자에게 결재정보 전송
              ShowMessage('승인 되었습니다.');

            end;
          end;// if

          if (LPending = LCCount) and (LnCharge = '')  then
          begin
            if Check_for_DB_In_EMPNO = False then
            begin
              ShowMessage('설계 담당자는 필수 입력 입니다!!');
              Exit;
            end
            else
            begin
              Approved_apply_to_ZHITEMS_APPROVEP(CODEID.Text,LnCharge,LPending);
              Registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,4);//수정로그
              Register_Trouble_Data_To_TSMS; // 결재 후 pending CCount 비교 후 같으면 보고서 결재 완료 처리!
              Send_Message_to_Inempno(LCharge,LnCharge);//작성자에게 결재정보 전송

              if not(MCODEID.Text = '') then
                InEMP_User_Check_for_TRouble_List(MCODEID.Text,4);

              ShowMessage('승인 완료 되었습니다.');
            end;
          end;
        end
        else
          Exit;
      end
      else
      begin
        if EmpNo.Items.Count = 0 then
        begin
          ShowMessage('설계 담당자는 필수 입력 입니다!!');

          with DM1.TQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('Update ZHITEMS_APPROVEP Set');
            SQL.Add('Pending = :Pending, APPROVAL1 = :APPROVAL1, Status = :Status where CODEID = :param1');

            Parambyname('param1').AsString     := CODEID.Text;
            Parambyname('Pending').AsInteger   := 1; //1 = 담당자 결재상신한 상태
            Parambyname('APPROVAL1').AsInteger := 1; //담당자
            Parambyname('Status').AsInteger    := 0; // 0: 작성중, 1:결재진행, 2:반려
            ExecSQL;
          end;//with
          Exit;
        end;

        if AppGrid.ColCount <= 2 then
        begin
          LCharge := Fields[LPending+1].AsString;//현재 결재 대상자
          LPending := 1;
          LnCharge := '';
          Approved_apply_to_ZHITEMS_APPROVEP(CODEID.Text,LnCharge,LPending);
          Registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,4);//수정로그
          Register_Trouble_Data_To_TSMS; // 결재 후 pending CCount 비교 후 같으면 보고서 결재 완료 처리!
        end
        else
        begin
          if not(LPending > LCCount) then
          begin
            LCharge := Fields[2+LPending].AsString;//현재 결재 대상자

            if not(LCCount = 5) then
              LnCharge := Fields[2+LN].AsString //현재 결재 대상자 다음 결재자 존재 여부 확인
            else
              LnCharge := '';

            Approved_apply_to_ZHITEMS_APPROVEP(CODEID.Text,LnCharge,LPending);
            Registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,4);//수정로그

            if not(LnCharge = '') then
            begin
              Send_Message_to_After_Approved(CODEID.Text);
              Send_Message_to_Inempno(LCharge,LnCharge);//작성자에게 결재정보 전송
            end
            else
              Register_Trouble_Data_To_TSMS; // 결재 후 pending CCount 비교 후 같으면 보고서 결재 완료 처리!
          end
          else
            Exit;

        end;
      end;
    end;
  Except
    ShowMessage('TSMS 등록처리가 실패 되었습니다.');
  end;
end;

function TTrouble_Frm.Approver_to_ZHITEMS_APPROVER: Boolean;
var
  li : integer;
begin
  Result := False;
  try
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert Into ZHITEMS_APPROVER');
      SQL.Add('Values(:CODEID, :FLAG, :ACount, :APPROVAL1, :APPROVAL2, :APPROVAL3, :APPROVAL4, :APPROVAL5)');

      if not(Statusbar1.Panels[1].Text = 'S') then
      begin
        Parambyname('CODEID').AsString    := CODEID.Text;
        Parambyname('FLAG').AsString      := 'P01TR';
        Parambyname('ACount').AsInteger   := FAppCount;//결재선이 몇명인지 입력 : 담당자포함 총 5
        Parambyname('APPROVAL1').AsString := FAprovalArr[0]; //담당자
        Parambyname('APPROVAL2').AsString := FAprovalArr[1]; // 결재1
        Parambyname('APPROVAL3').AsString := FAprovalArr[2]; // 결재2
        Parambyname('APPROVAL4').AsString := FAprovalArr[3]; // 결재3
        Parambyname('APPROVAL5').AsString := FAprovalArr[4]; // 결재4
        ExecSQL;
      end
      else
      begin
        Parambyname('CODEID').AsString    := CODEID.Text;
        Parambyname('FLAG').AsString      := 'P01TR';
        Parambyname('ACount').AsInteger   := 1;
        Parambyname('APPROVAL1').AsString := Statusbar1.Panels[4].Text; //담당자
        ExecSQL;
      end;
      Result := True;
    end;
  Except
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM ZHITEMS_APPROVER where CODEID = :param1');
      parambyname('param1').AsString := CODEID.Text;
      ExecSQL;
      ShowMessage('결재선 저장에 실패하였습니다.');
    end;
  end;//with
end;

procedure TTrouble_Frm.MasterDelClick(Sender: TObject);
begin
  if not(CodeID.Text = '') and (LeftStr(CODEID.Text,2) = 'TT') then
  begin
    Delete_TroubleRP_Temp_Data(CODEID.Text); // 보고서 삭제
    P_ResetClick(Sender); // 삭제 후 보고서 리셋
    FTroubleFrmChanged := True;
  end;
end;

function TTrouble_Frm.Modify_permissions_for_report: Boolean;
var
  LAcount : integer; //결재선 수
  LPending : integer; //결재대기 상태
  LSTATUS : integer; //문서상태 0:작성중 1:결재진행 2:반려 3: 완료
  LApprover : String;

  LUser : String;
  LEMPNO : String;
begin
  Result := False;
  LUser := Statusbar1.Panels[4].Text;
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select A.*, B.STATUS, B.Pending from ZHITEMS_APPROVER A, ZHITEMS_APPROVEP B');
    SQL.Add('where A.CODEID = :param1 and A.CODEID = B.CODEID');
    parambyname('param1').AsString := CODEID.Text;
    Open;

    if not(RecordCount = 0) then
    begin
      LSTATUS := Fieldbyname('STATUS').AsInteger;
      if not(LSTATUS = 3) then
      begin
        if LSTATUS = 2 then
        begin
          if LUser = InEMPNO.Items.Strings[0] then
          begin
            Result := True;
            Exit;

          end;
        end;

        if LStatus = 1 then
        begin
          LAcount := Fieldbyname('ACOUNT').AsInteger;
          LPending := Fieldbyname('PENDING').AsInteger;
          LPending := LPending +1;

          if (LPending > 1) and not(LPending > LACount) then
          begin
            LApprover := Fields[2+LPENDING].AsString;
            if LApprover = LUser then
              Result := True;
          end;
        end;

        if LSTATUS = 0 then
        begin
          Result := True;
          Exit;
        end;
      end
      else
      begin
      {
        if not(EMPNO.Items.Count = 0) then
          LEMPNO := EMPNO.Items.Strings[0]
        else
        begin
          Result := False;
          Exit;
        end;

        LUser := Statusbar1.Panels[4].Text;

        if LUser = LEMPNO then
          Result := True
        else
          Result := False;
      }
      end;
    end;
  end;
end;

procedure TTrouble_Frm.N2Click(Sender: TObject);
begin
  try
    Approved_of_Representatives;
  finally
    FTroubleFrmChanged := True;
    Btn_arrangement_after_check_for_DocStatus;
  end;
end;

procedure TTrouble_Frm.N3Click(Sender: TObject);
begin
  try
    Return_Process;
  finally
    FTroubleFrmChanged := True;
    Btn_arrangement_after_check_for_DocStatus;
  end;
end;

procedure TTrouble_Frm.NxButton11Click(Sender: TObject);
begin
  Close;
end;

procedure TTrouble_Frm.Btn_arrangement_after_check_for_DocStatus;
var
  LCODEID : String;
  LAuthority : String;
  li : integer;
  LUser, LApprover : String;
begin
  LCODEID := CODEID.Text;
  LUser := Statusbar1.Panels[4].Text;

  if not(FOpenCase = 2) then
  begin

    FRegBtn.Visible := False;  //M권한 //강제 등록 버튼
    MasterDel.Visible := False; //M권한 //강제삭제 버튼
    TempSave.Enabled := True;
    TempUpdate.Enabled := True; //보고서 수정 버튼
    summitbtn.Enabled := False; // 결재상신 버튼
    RpDel.Enabled := False; //보고서 삭제 버튼
    FResultBtn.Visible := False; //조치결과저장 버튼
    CompleBtn.Visible := False; //조치완료 버튼

    if LCODEID = '' then
    begin
      FRegBtn.Visible := False;  //M권한 //강제 등록 버튼
      MasterDel.Visible := False; //M권한 //강제삭제 버튼
      TempSave.Enabled := True;
      TempUpdate.Enabled := False; //보고서 수정 버튼
      summitbtn.Enabled := False; // 결재상신 버튼
      RpDel.Enabled := False; //보고서 삭제 버튼
      FResultBtn.Visible := False; //조치결과저장 버튼
      CompleBtn.Visible := False; //조치완료 버튼
    end
    else
    begin
      if not('TS' = LeftStr(LCODEID,2)) then
      begin
        FRegBtn.Visible := False;  //M권한 //강제 등록 버튼
        MasterDel.Visible := False; //M권한 //강제삭제 버튼
        TempSave.Enabled := False;
        TempUpdate.Enabled := Modify_permissions_for_report;
        summitbtn.Enabled := summit_permissions_for_report;
        RpDel.Enabled := Delete_permissions_for_report;


        if 'TX' = LeftStr(LCODEID,2) then
        begin
          if Complete_permissions_for_report = True then
          begin
            CompleBtn.Visible := True; //조치완료 버튼
            CompleBtn.TabOrder := 9;
            FResultBtn.Visible := True; //조치결과저장 버튼
            FResultBtn.TabOrder := 8;
          end;
        end;
      end
      else
      begin
        FRegBtn.Visible := False;  //M권한 //강제 등록 버튼
        MasterDel.Visible := False; //M권한 //강제삭제 버튼
        TempSave.Enabled := False;
        TempUpdate.Enabled := Modify_permissions_for_report;
        RPDel.Enabled := Delete_permissions_for_report;
        summitbtn.Enabled := summit_permissions_for_report;

        if Complete_permissions_for_report = True then
        begin
          CompleBtn.Visible := True; //조치완료 버튼
          CompleBtn.TabOrder := 9;
          FResultBtn.Visible := True; //조치결과저장 버튼
          FResultBtn.TabOrder := 8;

        end;
      end;
    end;

    LAuthority := Statusbar1.Panels[1].Text;
    if (LAuthority = 'M') then
    begin
      FRegBtn.Visible := True;  //M권한 //강제 등록 버튼
      MasterDel.Visible := True; //M권한 //강제삭제 버튼
      TempSave.Enabled := True;
      TempUpdate.Enabled := True;
      RPDel.Enabled := True;
      FResultBtn.Visible := True; //조치결과저장 버튼
      CompleBtn.Visible := True; //조치완료 버튼
    end;

    if (LAuthority = 'S') and (FUserPriv = 3) then
    begin
      TempUpdate.Enabled := True;
      RPDel.Enabled := True;
      FResultBtn.Visible := True; //조치결과저장 버튼
      CompleBtn.Visible := True; //조치완료 버튼
    end;
  end
  else
  begin
    FRegBtn.Visible := False;  //M권한 //강제 등록 버튼
    MasterDel.Visible := False; //M권한 //강제삭제 버튼
    TempSave.Visible := False;
    TempUpdate.Visible := False; //보고서 수정 버튼
    summitbtn.Visible := False; // 결재상신 버튼
    RpDel.Visible := False; //보고서 삭제 버튼
    FResultBtn.Visible := False; //조치결과저장 버튼
    CompleBtn.Visible := False; //조치완료 버튼
    p_Reset.Visible := False;

    Button11.Visible := False;
    Button12.Visible := False;

    Button10.Visible := False;
    Button9.Visible := False;

    Button13.Visible := False;
    Button14.Visible := False;

    Button15.Visible := False;
    Button16.Visible := False;

  end;
end;

procedure TTrouble_Frm.Button10Click(Sender: TObject);
var
  lrow : integer;
begin
  with FileGrid1 do
  begin
    lrow := SelectedRow;

    if (Cells[1,lRow] = '') and not(Cells[2,lRow] = '')  then
    begin
      Inc(FDelCnt);
      SetLength(FDelInfo, Sizeof(TDelFile) * 2);

      FDelInfo[FDelCnt-1].Flag     := 'A';
      FDelInfo[FDelCnt-1].FileNm   := Cells[2,lRow];
      FDelInfo[FDelCnt-1].FileSize := Cells[3,lRow];
    end;

    FileGrid1.DeleteRow(LROW)
  end;
end;


procedure TTrouble_Frm.Button11Click(Sender: TObject);
var
  lrow : integer;
begin
  with FileGrid0 do
  begin
    lrow := SelectedRow;

    if (Cells[1,lRow] = '') and not(Cells[2,lRow] = '')  then
    begin
      Inc(FDelCnt);
      SetLength(FDelInfo, Sizeof(TDelFile) * 2);

      FDelInfo[FDelCnt-1].Flag     := 'I';
      FDelInfo[FDelCnt-1].FileNm   := Cells[2,lRow];
      FDelInfo[FDelCnt-1].FileSize := Cells[3,lRow];
    end;

    FileGrid0.DeleteRow(LROW)
  end;
end;

procedure TTrouble_Frm.Button12Click(Sender: TObject);
var
  lCnt : integer;
  li,le : integer;
  LExt : String;
  LMS : TMemoryStream;
  LFileSize : Int64;
  LStr : String;
  lResult : Boolean;
begin
  try
    if OpenPictureDialog1.Execute then
    begin
      with FileGrid0 do
      begin
        for le := 0 to OpenPictureDialog1.Files.Count-1 do
        begin
          lResult := True;
          for li := 0 to FileGrid0.RowCount-1 do
          begin
            if ExtractFileName(OpenPictureDialog1.Files.Strings[le]) = FileGrid0.Cells[2,li] then
            begin
              lResult := False;
              Break;
            end;
          end;

          if lResult = True then
          begin
            LMS := TMemoryStream.Create;
            LMS.LoadFromFile(OpenPictureDialog1.Files.Strings[le]);
            LFileSize := LMS.Size;
            LExt := ExtractFileExt(OpenPictureDialog1.Files.Strings[le]);
            Delete(LExt,1,1);
            try
              AddRow(1);
              Cells[1,RowCount-1] := OpenPictureDialog1.Files.Strings[le];
              Cells[2,RowCount-1] := ExtractFileName(OpenPictureDialog1.Files.Strings[le]);
              Cells[3,RowCount-1] := IntToStr(LFileSize);
              Cells[4,RowCount-1] := UpperCase(LExt);

              with GDIPPictureContainer1.Items do
              begin
                BeginUpdate;
                try
                  Add;
                  lcnt := GDIPPictureContainer1.Items.Count-1;
                  Items[lcnt].Picture.LoadFromFile(OpenPictureDialog1.Files.Strings[le]);
                  Items[lcnt].Name := ExtractFileName(OpenPictureDialog1.Files.Strings[le]);
                finally
                  EndUpdate;
                end;
              end;
            finally
              FreeAndNil(LMS);
            end;
          end;
        end;//if
      end;
    end;
  finally
    if GDIPPictureContainer1.Items.Count > 0 then
    begin
      Image1.Picture.Assign(GDIPPictureContainer1.Items.Items[0].Picture);
      Image1.Invalidate;
    end;
  end;
end;

procedure TTrouble_Frm.Button13Click(Sender: TObject);
var
  lrow : integer;
begin
  with FileGrid2 do
  begin
    lrow := SelectedRow;

    if (Cells[1,lRow] = '') and not(Cells[2,lRow] = '')  then
    begin
      Inc(FDelCnt);
      SetLength(FDelInfo, Sizeof(TDelFile) * 2);

      FDelInfo[FDelCnt-1].Flag     := 'B';
      FDelInfo[FDelCnt-1].FileNm   := Cells[2,lRow];
      FDelInfo[FDelCnt-1].FileSize := Cells[3,lRow];
    end;

    FileGrid2.DeleteRow(LROW)
  end;
end;

procedure TTrouble_Frm.Button14Click(Sender: TObject);
var
  li : integer;
  LExt : String;
  LMS : TMemoryStream;
  LFileSize : Int64;
  LStr : String;
begin
  try
    if OpenDialog1.Execute then
    begin
      for li := 0 to FileGrid2.RowCount-1 do
      begin
        if ExtractFileName(OpenDialog1.FileName) = FileGrid2.Cells[1,li] then
        begin
          ShowMessage('이미 같은이름의 이미지가 등록되어 있습니다.');
          Exit;
        end;
      end;

      LExt := UpperCase(ExtractFileExt(OpenDialog1.FileName));
      LStr := GetToken(LExt,'.');

      LMS := TMemoryStream.Create;
      LMS.LoadFromFile(OpenDialog1.FileName);
      LFileSize := LMS.Size;
      with FileGrid2 do
      begin
        AddRow(1);
        Cells[1,RowCount-1] := OpenDialog1.FileName;
        Cells[2,RowCount-1] := ExtractFileName(OpenDialog1.FileName);
        Cells[3,RowCount-1] := IntToStr(LFileSize);
        Cells[4,RowCount-1] := LExt;
      end;//with
    end;
  finally
    FreeAndNil(LMS);
  end;
end;

procedure TTrouble_Frm.Button15Click(Sender: TObject);
var
  lrow : integer;
begin
  with FileGrid3 do
  begin
    lrow := SelectedRow;

    if (Cells[1,lRow] = '') and not(Cells[2,lRow] = '')  then
    begin
      Inc(FDelCnt);
      SetLength(FDelInfo, Sizeof(TDelFile) * 2);

      FDelInfo[FDelCnt-1].Flag     := 'C';
      FDelInfo[FDelCnt-1].FileNm   := Cells[2,lRow];
      FDelInfo[FDelCnt-1].FileSize := Cells[3,lRow];
    end;

    FileGrid3.DeleteRow(LROW)
  end;
end;
procedure TTrouble_Frm.Button16Click(Sender: TObject);
var
  li : integer;
  LExt : String;
  LMS : TMemoryStream;
  LFileSize : Int64;
  LStr : String;
begin
  try
    if OpenDialog1.Execute then
    begin
      for li := 0 to FileGrid3.RowCount-1 do
      begin
        if ExtractFileName(OpenDialog1.FileName) = FileGrid3.Cells[1,li] then
        begin
          ShowMessage('이미 같은이름의 이미지가 등록되어 있습니다.');
          Exit;
        end;
      end;

      LExt := UpperCase(ExtractFileExt(OpenDialog1.FileName));
      LStr := GetToken(LExt,'.');

      LMS := TMemoryStream.Create;
      LMS.LoadFromFile(OpenDialog1.FileName);
      LFileSize := LMS.Size;
      with FileGrid3 do
      begin
        AddRow(1);
        Cells[1,RowCount-1] := OpenDialog1.FileName;
        Cells[2,RowCount-1] := ExtractFileName(OpenDialog1.FileName);
        Cells[3,RowCount-1] := IntToStr(LFileSize);
        Cells[4,RowCount-1] := Lext;
      end;//with
    end;
  finally
    FreeAndNil(LMS);
    FTroubleFrmChanged := True;
  end;
end;

procedure TTrouble_Frm.Button17Click(Sender: TObject);
var
  LForm : TApprovaln_Frm;
  LStatus : integer;
  i,r: integer;
begin
  LStatus := Check_for_Doc_Status;

  if (LStatus = 0) or (LSTATUS = 2) then
  begin
    LForm := TApprovaln_Frm.Create(nil);
    try
      with LForm do
      begin
        FOwner := Self;

        ShowModal;
      end;
    finally
      FreeAndNIl(LForm);
    end;
  end
  else
    ShowMessage('진행중인 보고서의 결재선은 수정할 수 없습니다.');
end;

procedure TTrouble_Frm.Button18Click(Sender: TObject);
var
  LForm : TTroubleCd_Frm;
begin
  LForm := TTroubleCd_Frm.Create(nil);
  try
    LForm.FOwner := Self;
    LForm.ShowModal;
  finally
    FreeAndNIl(LForm);
  end;
end;

procedure TTrouble_Frm.Button19Click(Sender: TObject);
var
  lemp : String;

begin
  lemp := Statusbar1.Panels[4].Text;
  lemp := Create_findUser_Frm(lemp,'A');

  if not(lemp = '') then
  begin
    ApplyEmpno.Items.Clear;
    ApplyEmpno.Items.Add(lemp);
    ApplyEmpno.Text := Get_UserName(lemp);
    ApplyEmpno.Hint := lemp;
  end else
  begin
    ApplyEmpno.Items.Clear;
    ApplyEmpno.Clear;
    ApplyEmpno.Hint := '';
  end;
end;

procedure TTrouble_Frm.Button21Click(Sender: TObject);
begin
//  MasterDel.Visible := True;
  Register_Trouble_Data_To_TSMS;
//  TroubleData_Move_To_MainTable(CODEID.Text);
//  Check_for_FileGrid_and_Upload_2_TBACS;시험 완료 정상 동작 함
//  Update_TroubleTemp_approved_Field;
//  Update_TroubleRP_CODE_TO_TSMS('AS360','TS_K2B0_2011_06_020');
//  Update_TroubleRP_CODE_TO_TSMS('TS_K2B0_2011_06_020','AS360');
  //TS_K2B0_2011_06_020
end;

procedure TTrouble_Frm.Button2Click(Sender: TObject);
var
  lemp : String;

begin
  lemp := Statusbar1.Panels[4].Text;
  lemp := Create_findUser_Frm(lemp,'A');//사번 가져옴

  if not(lemp = '') then
  begin
    EMPNO.Items.Clear;
    EMPNO.Items.Add(lemp);
    EMPNO.Text := Get_UserName(lemp);
    EMPNO.Hint := lemp;
  end else
  begin
    EMPNO.Items.Clear;
    EMPNO.Clear;
    EMPNO.Hint := '';
  end;
end;

procedure TTrouble_Frm.Button3Click(Sender: TObject);
var
  lemp : String;
begin
  lemp := Statusbar1.Panels[4].Text;
  lemp := Create_findUser_Frm(lemp,'A');

  if not(lemp = '') then
  begin
    INEMPNO.Items.Clear;
    INEMPNO.Items.Add(lemp);
    INEMPNO.Text := Get_UserName(lemp);
    INEMPNO.Hint := lemp;
  end else
  begin
    INEMPNO.Items.Clear;
    INEMPNO.Clear;
    INEMPNO.Hint := '';
  end;
end;

procedure TTrouble_Frm.Button4Click(Sender: TObject);
var
  lemp : String;

begin
  lemp := Statusbar1.Panels[4].Text;
  lemp := Create_findUser_Frm(lemp,'A');

  if not(lemp = '') then
  begin
    HIEMPNO.Items.Clear;
    HIEMPNO.Items.Add(lemp);
    HIEMPNO.Text := Get_UserName(lemp);
    HIEMPNO.Hint := lemp;
  end else
  begin
    HIEMPNO.Items.Clear;
    HIEMPNO.Clear;
    HIEMPNO.Hint := '';
  end;
end;

procedure TTrouble_Frm.Button5Click(Sender: TObject);
var
  lemp : String;

begin
  lemp := Statusbar1.Panels[4].Text;
  lemp := Create_findUser_Frm(lemp,'A');

  if not(lemp = '') then
  begin
    HIINEMPNO.Items.Clear;
    HIINEMPNO.Items.Add(lemp);
    HIINEMPNO.Text := Get_UserName(lemp);
    HIINEMPNO.Hint := lemp;
  end else
  begin
    HIINEMPNO.Items.Clear;
    HIINEMPNO.Clear;
    HIINEMPNO.Hint := '';
  end;
end;

procedure TTrouble_Frm.Button6Click(Sender: TObject);
var
  LForm : TaddRefer_Frm;
  LStatus : integer;
begin
  LStatus := Check_for_Doc_Status;
  LForm := TaddRefer_Frm.Create(nil);
  try
    LForm.FOwner := Self;
    LForm.ShowModal;
  finally
    FreeAndNIl(LForm);
  end;
end;

procedure TTrouble_Frm.Button7Click(Sender: TObject);
var
  li : integer;
begin
  li := FileGrid0.SelectedRow;
  li := li-1;

  if li < 0 then
    li := GDIPPictureContainer1.Items.Count-1;

  Image1.Picture.Assign(GDIPPictureContainer1.Items.Items[li].Picture);
  Image1.Invalidate;

  FileGrid0.SelectedRow := li;
end;

procedure TTrouble_Frm.Button8Click(Sender: TObject);
var
  li : integer;
begin
  li := FileGrid0.SelectedRow;
  li := li+1;

  if li > GDIPPictureContainer1.Items.count-1 then
    li := 0;

  Image1.Picture.Assign(GDIPPictureContainer1.Items.Items[li].Picture);
  Image1.Invalidate;

  FileGrid0.SelectedRow := li;
end;

procedure TTrouble_Frm.Button9Click(Sender: TObject);
var
  li : integer;
  LExt : String;
  LMS : TMemoryStream;
  LFileSize : Int64;
  LStr : String;
begin
  try
    if OpenDialog1.Execute then
    begin
      for li := 0 to FileGrid1.RowCount-1 do
      begin
        if ExtractFileName(OpenDialog1.FileName) = FileGrid1.Cells[1,li] then
        begin
          ShowMessage('이미 같은이름의 이미지가 등록되어 있습니다.');
          Exit;
        end;
      end;

      LExt := UpperCase(ExtractFileExt(OpenDialog1.FileName));
      LStr := GetToken(LExt,'.');

      LMS := TMemoryStream.Create;
      LMS.LoadFromFile(OpenDialog1.FileName);
      LFileSize := LMS.Size;
      with FileGrid1 do
      begin
        AddRow(1);
        Cells[1,RowCount-1] := OpenDialog1.FileName;
        Cells[2,RowCount-1] := ExtractFileName(OpenDialog1.FileName);
        Cells[3,RowCount-1] := IntToStr(LFileSize);
        Cells[4,RowCount-1] := LExt;
      end;//with
    end;
  finally
    FreeAndNil(LMS);
  end;
end;

procedure TTrouble_Frm.Call_a_TroubleReport(FCODEID: String);
var
  LFlag : String;
  Li : integer;
  LStr : String;

  FMCODE : String;
begin
  if FCODEID = '' then Exit;

  DM1.Splash1.BeginUpdate;
  LStr := 'CODEID :'+FCODEID+#13+'TBACS 데이터베이스에서 보고서를 호출 중입니다.';
  DM1.Splash1.TopLayerItems.Items[0].HTMLText.Text := LStr;
  DM1.Splash1.EndUpdate;
  DM1.Splash1.Show;

  TroubleData_Get_From_DB(FCODEID); //문서가져오기
  Approval_Info_Apply_To_Table(FCODEID);//결재 정보 테이블에 적용
  Get_CClist_From_Trouble_CCList(FCODEID);//참조 목록 가져오기

  Get_Attachment_From_Trouble_attfiles(FCODEID,MCODEID.Text);


  if not(NxPageControl1.ActivePageIndex = 0) then;
    NxPageControl1.ActivePageIndex := 0;

  Sleep(500);
  DM1.Splash1.Hide;
end;

procedure TTrouble_Frm.CCList_2_DataBase(FCODEID: String);
var
  li : integer;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from TROUBLE_CCLIST where CODEID = :param1');
    parambyname('param1').AsString := FCODEID;
    ExecSQL;
  end;

  if not(CCLists.Text = '') then
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert Into Trouble_CCList');
      SQL.Add('Values(:CODEID, :CCList)');

      Parambyname('CODEID').AsString   := CODEID.Text;
      Parambyname('CCList').AsString   := CCListS.Text;
      ExecSQL;
    end;
  end;
end;

function TTrouble_Frm.Check_for_DB_In_EMPNO: Boolean;
begin
  Result := False;
  with DM1.TQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select EMPNO from Trouble_DataTemp where CODEID = :param1');
    parambyname('param1').AsString := CODEID.Text;
    Open;

    if not(Fieldbyname('EMPNO').AsString = '') then
      Result := True;
  end;
end;

procedure TTrouble_Frm.Check_for_Docu_Step;
var
  lstep : integer;
begin
  lstep := 0;
  if Status.GetTextLen > 1 then
    lstep := 0;
    if (Reason.GetTextLen > 1) or (Plan.GetTextLen > 1) then
      lstep := 1;
      if (Reason1.GetTextLen > 1) or (Resulta.GetTextLen > 1) then
        lstep := 2;

  StepStat.ItemIndex := lstep;
end;

function TTrouble_Frm.Check_for_Doc_Status: integer;
begin
  with DM1.TQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from ZHITEMS_APPROVEP');
    SQL.Add('where CODEID = :param1');
    parambyname('param1').AsString := CODEID.Text;
    Open;

    if not(RecordCount = 0) then
      Result := Fieldbyname('STATUS').AsInteger
    else
      Result := 0;

  end;
end;

procedure TTrouble_Frm.Check_for_FileGrid_and_Upload_2_TBACS;
var
  li,le : integer;
  LFileGrid : TNextGrid;
  LFlag, LPath, Lnm, Lsize, Lext : String;

begin
  // 삭제된 파일이 존재하는지 확인 후 존재하면 파일 삭제
  if FDelCnt > 0 then
  begin
    for li := 0 to FDelCnt do
    begin
      if not(FDelInfo[li].Flag = '') then
      begin
        with DM1.TQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Delete from Trouble_Attfiles where CODEID = :param1');
          SQL.Add('and ATTFLAG = :param2 and LCFILENAME = :param3');
          parambyname('param1').AsString := CODEID.Text;
          parambyname('param2').AsString := FDelInfo[li].Flag;
          parambyname('param3').AsString := FDelInfo[li].FileNm;
//          parambyname('param4').AsString := FDelInfo[li].FileSize;
          ExecSQL;
        end;//with
      end;//if
    end;
  end;

  for li := 0 to 3 do
  begin
    LFileGrid := TNextGrid(FindComponent('FileGrid'+IntToStr(li)));
    case li of
      0 : LFlag := 'I';
      1 : LFlag := 'A';
      2 : LFlag := 'B';
      3 : LFlag := 'C';
    end;

    with LFileGrid do
    begin
      for le := 0 to RowCount-1 do
      begin
        if not(Cells[1,le] = '') then
        begin
          LPath := Cells[1,le];
          Lnm   := Cells[2,le];
          Lsize := Cells[3,le];
          Lext  := Cells[4,le];

          Upload_Files_within_FileGrid(LFlag, LPath, Lnm, Lsize, Lext);
          Cells[1,le] := '';
        end;
      end;
    end;
  end;
end;

function TTrouble_Frm.Check_for_Mandatory_Items: Boolean;
var
  LAuthority : String;
  LSTATUS : integer;
begin
  Result := True;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select STATUS from ZHITEMS_APPROVEP where CODEID = :param1');
    parambyname('param1').AsString := CODEID.Text;
    Open;

    if not(RecordCount = 0) then
      LSTATUS := Fieldbyname('STATUS').AsInteger
  end;

  if not(GrpType.ItemIndex > -1 ) then
  begin
    ShowMessage('보고서 타입을 선택하여 주십시오.');
    Result := False;
    exit;
  end;

  if Title.Text = '' then
  begin
    ShowMessage('보고서 제목을 입력하여 주십시오.');
    Result := False;
    exit;
  end;

  LAuthority := Statusbar1.Panels[1].Text;
  if not(LAuthority = 'S') then
  begin
    if AppGrid.ColCount <= 2 then
    begin
      ShowMessage('결재선이 지정되지 않았습니다.');
      Result := False;
      exit;
    end;
  end;

  if TroubleList.RowCount = 0 then
  begin
    ShowMessage('문제유형은 필수 입력 항목입니다.');
    Result := False;
    exit;
  end;

  if LSTATUS = 0 then
  begin
    if FileGrid0.RowCount = 0 then
    begin
      ShowMessage('1장 이상의 문제 이미지를 등록 하셔야 합니다!!');
      Result := False;
      Exit;
    end;
  end;

  if INEMPNO.Text = '' then
  begin
    ShowMessage('작성자는 필수 입력 항목입니다.');
    Result := False;
    INEMPNO.SetFocus;
    exit;
  end;

end;

procedure TTrouble_Frm.CompleBtnClick(Sender: TObject);
var
  LBoolean : Boolean;
  LCount : integer;
begin
  If MessageDlg('보고서 완료처리 하시겠습니까?'+#13+'완료처리후에는 보고서 수정이 불가하오니 유의하시기 바랍니다.',
  mtConfirmation, [mbYes, mbNo], 0) = mrYes Then

  TRY
    if CODEID.Text = '' then
      Exit
    else
    begin
      if (LeftStr(CODEID.Text,2) = 'TS') or (LeftStr(CODEID.Text,2) = 'TX') then
      begin
        with DM1.TQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select FResult from Trouble_Data where CODEID = :param1');
          parambyname('param1').AsString := CODEID.Text;
          Open;

          if not(RecordCount = 0) then
          begin
            if not(Fieldbyname('FResult').AsInteger = 1) then
            begin
              ShowMessage('조치내용 저장 후 완료처리하여 주십시오.');
              Exit;
            end;
          end
          else
            Exit;
        end;

        try
          with DM1.TQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('Update TROUBLE_Data Set');
            SQL.Add(' STEPSTATUS = :STEPSTATUS, FResult = :FResult where CodeID = :Param1');
            parambyname('param1').AsString := CODEID.Text;
            parambyname('STEPSTATUS').AsString := 'DONE';
            parambyname('FResult').AsInteger := 2;
            ExecSQL;
          end;

//          with DM1.EQuery1 do
//          begin
//            Close;
//            SQL.Clear;
//            SQL.Add('Update TS_DATA Set');
//            SQL.Add(' STEPSTATUS = :STEPSTATUS where CodeID = :Param1');
//            parambyname('param1').AsString := CODEID.Text;
//            parambyname('STEPSTATUS').AsString := 'DONE';
//            ExecSQL;
//          end;

          Send_Message_to_Charge_Report_Complete;
          registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,7);
          FResultBtn.Visible := False;
          CompleBtn.Visible := False;

          ShowMessage('완료처리가 정상적으로 수행되었습니다.');
        Except
          ShowMessage('완료처리가 실패하였습니다.');
        end;
      end;
    end;//else end;
  FINALLY
    FDelCnt := 0;
    FillChar(FDelInfo,SizeOf(FDelInfo), 0); // 삭제목록 초기화
    FTroubleFrmChanged := True;
  END;
end;
function TTrouble_Frm.Complete_permissions_for_report: Boolean;
var
  LAcount : integer; //결재선 수
  LEMPNO : String; //설계담당자
  LSTATUS : integer; //문서상태 0:작성중 1:결재진행 2:반려 3: 완료
  LApprover : String;
  LUser : String;
  LFResult : integer;
begin
  Result := False;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from ZHITEMS_APPROVEP');
    SQL.Add('where CODEID = :param1');
    parambyname('param1').AsString := CODEID.Text;
    Open;

    if Not(RecordCount = 0) then
    begin
      LSTATUS := Fieldbyname('Status').AsInteger;
    end;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Trouble_Data Where CODEID = :param1');
    parambyname('param1').AsString := CODEID.Text;
    Open;

    LFResult := 0;
    if not(RecordCount = 0) then
    begin
      LFResult := Fieldbyname('FResult').AsInteger;
    end;//if
  end;

  if (LStatus = 3) and (LFResult = 2) then
  begin
    Result := False;
    Exit;
  end
  else
  begin
    if not(EMPNO.Items.Count = 0) then
      LEMPNO := EMPNO.Items.Strings[0]
    else
    begin
      Result := False;
      Exit;
    end;

    LUser := Statusbar1.Panels[4].Text;

    if LUser = LEMPNO then
      Result := True
    else
      Result := False;

  end;
end;

procedure TTrouble_Frm.C_RpClick(Sender: TObject);
var
  LRpType : String;
  LDocuNumber : String;
begin
  SaveDialog1.Filter := 'xls Files (*.xls)|*.xls';

  LRpType := GrpType.Items.Strings[GRPType.ItemIndex];
  LDocuNumber := CODEID.Text;

  SaveDialog1.FileName := LDocuNumber+'_'+ENGNAME.Text+'_'+LRpType+' 보고서.xls';

  if SaveDialog1.Execute then
    if Get_Report_Fomat_From_FTP = True then
      Generating_Trouble_Report;
end;

function TTrouble_Frm.Delete_permissions_for_report: Boolean;
var
  LINEMPNO : String; //문서 작성담당자
  LSTATUS : integer; //문서상태 0:작성중 1:결재진행 2:반려 3: 완료
  LUser : String;
begin
  Result := False;
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * From ZHITEMS_APPROVEP');
    SQL.Add('where CODEID = :param1');
    parambyname('param1').AsString := CODEID.Text;
    Open;

    if not(RecordCount = 0) then
    begin
      LSTATUS := Fieldbyname('STATUS').AsInteger;
      if (LSTATUS = 1) or (LSTATUS = 3) then
      begin
        Result := False;
        Exit;
      end
      else
      begin
        if not(INEMPNO.Items.Count = 0) then
          LINEMPNO := INEMPNO.Items.Strings[0]
        else
        begin
          Result := False;
          Exit;
        end;

        LUser := Statusbar1.Panels[4].Text;

        if LUser = LINEMPNO then
          Result := True;

      end;
    end;
  end;
end;

procedure TTrouble_Frm.Delete_TroubleRP_Temp_Data(FCODEID: String);
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete Trouble_DataTemp where CODEID = :param1');
    parambyname('param1').AsString  := FCODEID;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete ZHITEMS_APPROVER where CODEID = :param1 and FLAG = :param2');
    parambyname('param1').AsString  := FCODEID;
    parambyname('param2').AsString  := 'P01TR';
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete Trouble_AttFiles where CODEID = :param1');
    parambyname('param1').AsString  := FCODEID;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete Trouble_DataLog where CODEID = :param1');
    parambyname('param1').AsString  := FCODEID;
    ExecSQL;
  end;
end;


procedure TTrouble_Frm.EMPNOKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_LEFT) or (key = VK_UP) or (key = VK_RIGHT) or (key = VK_DOWN) then
    key := 0;
end;

procedure TTrouble_Frm.ENGNAMEClick(Sender: TObject);
begin
  Open_Engine_Info;
end;

procedure TTrouble_Frm.FileGrid0SelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  FxRow := ARow;
  FFileGridNo := 0;
  {

  if FileGrid0.RowCount = 0 then Exit;

  if (FileGrid0.Cells[1,FxRow] = '') and not(FileGrid0.Cells[2,FxRow] = '') then
    Image1.Picture.Assign(GDIPPictureContainer1.FindPicture(FileGrid0.Cells[1,FxRow]));

  if not(FileGrid0.Cells[1,FxRow] = '') and not(FileGrid0.Cells[2,FxRow] = '') then
    Image1.Picture.LoadFromFile(FileGrid0.Cells[1,FxRow]);

  FileGrid0.Caption := 'Trouble Image / '+FileGrid0.Cells[2,FxRow];
  }
end;

procedure TTrouble_Frm.FileGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  FxRow := ARow;
  FFileGridNo := 1;
end;

procedure TTrouble_Frm.FileGrid2SelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  FxRow := ARow;
  FFileGridNo := 2;
end;

procedure TTrouble_Frm.FileGrid3SelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  FxRow := ARow;
  FFileGridNo := 3;
end;

procedure TTrouble_Frm.Follow_Up_of_Trouble_AttFiles_(FCODEID: String);
var
  li,le : integer;
  LFileGrid : TNextGrid;
  LFlag, LPath, Lnm, Lsize, Lext : String;

begin
  // 삭제된 파일이 존재하는지 확인 후 존재하면 파일 삭제
  if FDelCnt > 0 then
  begin
    for li := 0 to FDelCnt-1 do
    begin
      if not(FDelInfo[li].Flag = 'A') or not(FDelInfo[li].Flag = 'I') or not(FDelInfo[li].Flag = '') then
      begin
        with DM1.TQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Delete from Trouble_Attfiles where CODEID = :param1');
          SQL.Add('and ATTFLAG = :param2 and LCFILENAME = :param3');
          parambyname('param1').AsString := CODEID.Text;
          parambyname('param2').AsString := FDelInfo[li].Flag;
          parambyname('param3').AsString := FDelInfo[li].FileNm;
//          parambyname('param4').AsString := FDelInfo[li].FileSize;
          ExecSQL;
        end;//with

//        with DM1.EQuery1 do
//        begin
//          Close;
//          SQL.Clear;
//          SQL.Add('Delete from TS_Attfiles where CODEID = :param1');
//          SQL.Add('and ATTFLAG = :param2 and FILETITLE = :param3');
//          parambyname('param1').AsString := CODEID.Text;
//          parambyname('param2').AsString := FDelInfo[li].Flag;
//          parambyname('param3').AsString := FDelInfo[li].FileNm;
////          parambyname('param4').AsString := FDelInfo[li].FileSize;
//          ExecSQL;
//        end;//with
      end;//if
    end;
  end;

  for li := 2 to 3 do
  begin
    LFileGrid := TNextGrid(FindComponent('FileGrid'+IntToStr(li)));
    case li of
      0 : LFlag := 'I';
      1 : LFlag := 'A';
      2 : LFlag := 'B';
      3 : LFlag := 'C';
    end;

    with LFileGrid do
    begin
      for le := 0 to RowCount-1 do
      begin
        if not(Cells[1,le] = '') then
        begin
          LPath := Cells[1,le];
          Lnm   := Cells[2,le];
          Lsize := Cells[3,le];
          Lext  := Cells[4,le];

          Upload_Files_within_FileGrid(LFlag, LPath, Lnm, Lsize, Lext);
          Cells[1,le] := '';
        end;
      end;
    end;
  end;
//  Follow_Up_of_Trouble_AttFiles_TSMS(FCODEID);// FileGrid A, C 변경사항 업로드
end;

procedure TTrouble_Frm.Follow_Up_of_Trouble_AttFiles_TSMS(FCODE: String);
var
  li : integer;
  LCODEID : String;
  LFlag : String;
  LDBfileName : String;
  LLCfileName : String;
  FileExt : String;
  FileSize : String;
  LURL : String;
  LIndate : TDateTime;
  LYear : String;
  LMonth : String;
  LTS : TStream;
  LongTime : int64;
  LiCnt : integer;
begin
  Try
    LiCnt := 0;
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from Trouble_ATTFiles where CODEID = :param1');
      SQL.Add('and ATTFLAG IN (''B'',''C'') order by ATTFLAG');
      parambyname('param1').AsString := FCODE;
      Open;


      for li := 0 to RecordCount -1 do
      begin
        if LiCnt = 0 then
        begin
          LInDate     := Now;
          LCODEID     := FCODE;
          LFlag       := FieldByName('ATTFlag').AsString;
          LLCfileName := FieldByName('LCFileName').AsString;
          FileExt     := FieldByName('FileEXT').AsString;
          FileSize    := FieldByName('FileSize').AsString;
          LYear       := FormatDateTime('YYYY',LIndate);
          LMonth      := FormatDateTime('MM',LIndate);
          LDBfileName := IntToStr(DateTimeToMilliseconds(LInDate))+'.'+FileExt;
          LUrl := Statusbar1.Panels[2].Text+'/'+LFlag+'/'+LYear+'/'+LMonth+'/';

          LTS := TStream.Create;
          LTS := createblobstream(fieldbyname('Files'), bmread);


//          with DM1.EQuery1 do
//          begin
//            Close;
//            SQL.Clear;
//            SQL.Add('insert into TS_ATTFILES');
//            SQL.Add('Values(:CODEID,:ATTFLAG,:LONGTIME,:FILENAME,:FILEURL,');
//            SQL.Add('       :FILETITLE,:FILEEXT,:FILESIZE,:UPLOADFLAG,:INDATE)');
//
//            parambyname('CODEID').AsString      := LCODEID;
//            parambyname('ATTFLAG').AsString     := LFlag;
//            LongTime := DateTimeToMilliseconds(Now);
//            parambyname('LONGTIME').AsString    := IntToStr(LongTime);
//            parambyname('FILENAME').AsString    := LDBFileName;
//            parambyname('FILEURL').AsString     := LURL;
//
//            parambyname('FILETITLE').AsString   := LLCFileName;
//            parambyname('FILEEXT').AsString     := FileExt;
//            parambyname('FILESIZE').AsString    := FileSize;
//            parambyname('UPLOADFLAG').AsString  := 'Y';
//            parambyname('INDATE').AsDateTime    := Now;
//            ExecSQL;
//
//            // FTP에 파일 저장
//            try
//              if TSMS_FTP_Server_Connection = True then
//              begin
//                TSMS_FTP_Server_Directory_Setting(LFlag);// FTP Directory 설정 하고!!
//                if DM1.IdFTP1.Connected then
//                  DM1.IdFTP1.Put(LTS,LDBFileName);
//              end;
//            finally
//              TSMS_FTP_Server_Connection;//FTP DisConnect
//            end;
//          end;//with EQuery1
        end;
        Next;
      end;
    end;//with
  Finally
    LTS.Free;
  End;
end;

procedure TTrouble_Frm.Follow_Up_of_Trouble_Data_TBACS(FCODEID: String);
begin
  // TBACS_Trouble_Data
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update TROUBLE_Data Set');
    SQL.Add(' REASONTITLE = :REASONTITLE, REASON = :REASON, PlanTitle = :planTitle, Plan = :Plan,');
    SQL.Add(' REASON1TITLE = :REASON1TITLE, REASON1 = :REASON1, RESULTTITLE = :RESULTTITLE, RESULT = :RESULT,');
    SQL.Add(' APPLYEMPNO = :APPLYEMPNO, EDATE = :EDATE, DESIGNAPP = :DESIGNAPP,');
    SQL.Add(' NDEPT1 = :NDEPT1, NDEPT2 = :NDEPT2, NDEPT3 = :NDEPT3, COMPLE1 = :COMPLE1, COMPLE2 = :COMPLE2, COMPLE3 = :COMPLE3, ');
    SQL.Add(' CDATE1 = :CDATE1, CDATE2 = :CDATE2, CDATE3 = :CDATE3,');
    SQL.Add(' RESULTC1 = :RESULTC1, RESULTC2 = :RESULTC2, RESULTC3 = :RESULTC3, RESULTC4 = :RESULTC4,');
    SQL.Add(' RESULTC5 = :RESULTC5, RESULTC6 = :RESULTC6, REMARK1 = :REMARK1, REMARK2 = :REMARK2, REMARK3 = :REMARK3,');
    SQL.Add(' REMARK4 = :REMARK4, REMARK5 = :REMARK5, REMARK6 = :REMARK6, REFTYPE = :REFTYPE, STEPSTATUS = :STEPSTATUS,');
    SQL.Add(' FResult = :FResult');
    SQL.Add(' where CodeID = :Param1');

    parambyname('Param1').AsString := FCODEID;

    paramByName('REASONTITLE').AsString     := REASONTITLE.Text;
    paramByName('REASON').AsString          := REASON.Text;

    paramByName('PlanTitle').AsString       := PlanTitle.Text;
    paramByName('Plan').AsString            := Plan.Text;

    paramByName('REASON1TITLE').AsString    := REASON1TITLE.Text;
    paramByName('REASON1').AsString         := REASON1.Text;

    paramByName('RESULTTITLE').AsString     := RESULTTITLE.Text;
    paramByName('RESULT').AsString          := RESULTa.Text;

    if ApplyEmpno.Items.Count > 0 then
      paramByName('APPLYEMPNO').AsString      := ApplyEmpno.Items.Strings[0];

    if not(EDATE.Text = '') then
      paramByName('EDATE').AsDateTime          := StrToDateTime(EDATE.Text);

    paramByName('DESIGNAPP').AsInteger      := DesignApp.ItemIndex;

    with ACGrid1 do
    begin
      paramByName('NDEPT1').AsString          := Cells[0,1];
      paramByName('NDEPT2').AsString          := Cells[0,2];
      paramByName('NDEPT3').AsString          := Cells[0,3];

      paramByName('COMPLE1').AsString         := Cells[1,1];
      paramByName('COMPLE2').AsString         := Cells[1,2];
      paramByName('COMPLE3').AsString         := Cells[1,3];

      paramByName('CDATE1').AsString          := Cells[2,1];
      paramByName('CDATE2').AsString          := Cells[2,2];
      paramByName('CDATE3').AsString          := Cells[2,3];
    end;

    paramByName('RESULTC1').AsString          := ResultC1.Text;
    paramByName('RESULTC2').AsString          := ResultC2.Text;
    paramByName('RESULTC3').AsString          := ResultC3.Text;
    paramByName('RESULTC4').AsString          := ResultC4.Text;
    paramByName('RESULTC5').AsString          := ResultC5.Text;
    paramByName('RESULTC6').AsString          := ResultC6.Text;

    paramByName('REMARK1').AsString           := '';
    paramByName('REMARK2').AsString           := '';
    paramByName('REMARK3').AsString           := '';
    paramByName('REMARK4').AsString           := '';
    paramByName('REMARK5').AsString           := '';
    paramByName('REMARK6').AsString           := '';

    if REFTYPE.ItemIndex > -1 then
      paramByName('REFTYPE').AsString   := IntToStr(RegType.ItemIndex)
    else
      paramByName('REFTYPE').AsString   := '';


    Case StepStat.ItemIndex of
      0 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[0];
      1 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[1];
      2 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[2];
      3 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[3];
    end;

    paramByName('FResult').AsInteger          := 1; //0:기본값 1: 담당자 저장 2: 문서완료
    ExecSQL;
  end;
end;

procedure TTrouble_Frm.Follow_Up_of_Trouble_Data_TSMS(FCODEID: String);
begin
//  with DM1.EQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('Update TS_DATA Set');
//    SQL.Add('REASON = :REASON, PLAN = :PLAN,');
//    SQL.Add(' EDATE = :EDATE, APPLYEMPNO = :APPLYEMPNO, REASON1 = :REASON1, RESULT = :RESULT, ');
//    SQL.Add(' STEPSTATUS = :STEPSTATUS, REFTYPE = :REFTYPE where CODEID = :param1');
//    parambyname('param1').AsString := FCODEID;
//
//    if not (EDate.Text = '') then
//    begin
//      paramByName('REASON').AsString   := REASON.Text;
//      paramByName('PLAN').AsString     := PLAN.Text;
//      paramByName('EDATE').AsDateTime           := EDate.Date;
//      paramByName('APPLYEMPNO').AsString    := ApplyEmpno.Items.Strings[0];
//      paramByName('REASON1').AsString       := Reason1.Text;
//      paramByName('RESULT').AsString        := RESULTa.Text;
//
//      Case StepStat.ItemIndex of
//        0 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[0];
//        1 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[1];
//        2 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[2];
//        3 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[3];
//      end;
//
//      Case REFType.ItemIndex of
//        0 : paramByName('REFTYPE').AsString := '0';
//        1 : paramByName('REFTYPE').AsString := '1';
//        2 : paramByName('REFTYPE').AsString := '2';
//        3 : paramByName('REFTYPE').AsString := '3';
//      end;//case
//      ExecSQL;
//    end;
//  end;
end;

procedure TTrouble_Frm.FormActivate(Sender: TObject);
begin
  if FFirst = True then
  begin
    FFirst := False;
    case FOpenCase of
      0 : Input_of_New_Report_InCharger; //신규문서
      1 : Call_a_TroubleReport(FRpCode); //저장된문서
      2 : Call_a_TroubleReport(FRpCode); //상세검색에서 조회시
      3 : Start_Detail_Write_for_Mobile_Content; //모바일 문제제보기반 상세등록
    end;
//    Get_of_EDMS_ITEMS;
    Btn_arrangement_after_check_for_DocStatus;
  end;
end;

procedure TTrouble_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FTroubleFrmChanged = True then
  begin
    if Assigned(FOwner) then
      FOwner.Reflect_the_Changes;
  end;

  Action := caFree;
end;

procedure TTrouble_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;
  NxPageControl1.ActivePageIndex := 0;
end;

procedure TTrouble_Frm.fRegbtnClick(Sender: TObject);
var
  LCCount, LPending : integer;
  LOriginCODE : String;
begin

  LOriginCODE := CODEID.Text; //TSMS CODE 생성전 관리번호

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select A.*, B.Pending from ZHITEMS_APPROVER A, ZHITEMS_APPROVEP B');
    SQL.Add('where A.CODEID = :param1 And A.CodeID = B.CodeID');
    Parambyname('param1').AsString := CODEID.Text;
    Open;

    if not(RecordCount = 0) then
    begin
      LCCount := FieldByName('ACount').AsInteger;  //결재선이 몇명인지 기록
      LPending := FieldByName('Pending').AsInteger; //현재 문서 진행상태.. 어디까지 결재 되었나?
    end;
  end;

  if LCCount = LPending then
  begin
    if not(GRpType.ItemIndex = 4) then
    begin
      Generator_CODEID_of_TSMS2; //TSMS 코드번호 생성 후 CODE.text 에 입력!
      try
//        if TroubleData_Save_To_TSMS = True then
//        begin
//          TroubleFiles_Info_Upload_To_TSMS(CODEID.Text,LOriginCODE); // 첨부파일 등록

          // TSMS에 데이터가 저장 되었으면 Trouble_DataTemp 에 저장된 데이터를 Trouble_Data로 이동한다.
          TroubleData_Move_To_MainTable(LOriginCODE); // Data 이동 후 DataTemp Record 삭제
          Update_TroubleRP_CODE_TO_TSMS(CODEID.Text,LOriginCODE);//임시코드를 TSMS 코드로 수정
          Send_Message_to_Design_Charge; //설계 담당자에게 통보
          Send_Message_to_CarbonCharge; // 참조대상에서 통보
//        end;
      Except
//        Turn_to_Back_Before_TSMSCODE2(CODEID.Text,LOriginCODE);
      end;
    end
    else
    begin
      if GrpType.ItemIndex = 4 then
      begin
        Trouble_expectation_CODE_Generator;
        TroubleData_Move_To_MainTable(LOriginCODE); // Data 이동 후 DataTemp Record 삭제
        Update_TroubleRP_CODE_TO_TSMS(CODEID.Text,LOriginCODE);//임시코드를 문제예상 코드로 수정
        Send_Message_to_CarbonCharge; // 참조대상에서 통보
      end;
    end;
  end
  else
    Exit;
  ShowMessage('등록처리 되었습니다.');
  FTroubleFrmChanged := True;
end;

procedure TTrouble_Frm.FResultBtnClick(Sender: TObject);
begin
  Try
    Try
      if (RefType.ItemIndex = -1) then
      begin
        ShowMessage('참조구분을 선택하여 주십시오.');
        Exit;
      end;

      if (ApplyEmpno.Items.Count = 0) then
      begin
        ShowMessage('조치자를 선택하여 주십시오.');
        Exit;
      end;

      if (EDate.Text = '') then
      begin
        ShowMessage('조치일을 선택하여 주십시오.');
        Exit;
      end;

      //TROUBLE REPORT STEP2 UPDATE 2011-06-14 일 추가 작업
      Follow_Up_of_Trouble_Data_TBACS(CODEID.Text);//조치사항 저장
//      Follow_Up_of_Trouble_Data_TSMS(CODEID.Text);//조치사항 저장
      Follow_Up_of_Trouble_AttFiles_(CODEID.Text);// FileGrid A, C 변경사항 업로드


      ShowMessage('조치내용이 정상적으로 저장 되었습니다.');
      registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,6);

    Except
      ShowMessage('조치내용 저장에 실패하였습니다.');
    End;
  Finally
    FDelCnt := 0;
    FillChar(FDelInfo,SizeOf(FDelInfo), 0); // 삭제목록 초기화
    FTroubleFrmChanged := True;
  End;
end;

procedure TTrouble_Frm.Generating_Trouble_Report;
var
  LRange: OleVariant;
  Lselection:Variant;
  pic : OleVariant;
  Li  : integer;
  LTitle,
  LStr : String;
  LUserAr : Array of String[7];
  LName : Array of String[20];  
  LApprove : Array of integer;
  LCCount : integer;
begin
  try
    Excel := GetActiveExcelOleObject(True);
    WorkBook := Excel.Workbooks.Open(SaveDialog1.FileName);
    Excel.Visible := true;
    Excel.ActiveWindow.Zoom := 100;

    Workbook.Sheets['Sheet1'].Activate;
    fworksheet := Excel.ActiveSheet;

    LRange := fworksheet.range['Y3'];
    LRange.FormulaR1C1 := CODEID.Text;

    LRange := fworksheet.range['AK3'];
    LRange.FormulaR1C1 := '';

    LRange := fworksheet.range['Y4'];
    LStr := StringReplace('√',#$D#$A,#$A,[rfReplaceAll]);
    if TrKind.Checked[0] = True then
      LRange.FormulaR1C1 := LStr
    else
      LRange.FormulaR1C1 := '';

    LRange := fworksheet.range['Y5'];
    LStr := StringReplace('√',#$D#$A,#$A,[rfReplaceAll]);
    if TrKind.Checked[1] = True then
      LRange.FormulaR1C1 := LStr
    else
      LRange.FormulaR1C1 := '';

    LRange := fworksheet.range['Y6'];
    LStr := StringReplace('√',#$D#$A,#$A,[rfReplaceAll]);
    if TrKind.Checked[2] = True then
      LRange.FormulaR1C1 := LStr
    else
      LRange.FormulaR1C1 := '';

    LRange := fworksheet.range['Y7'];
    LStr := StringReplace('√',#$D#$A,#$A,[rfReplaceAll]);
    if TrKind.Checked[3] = True then
      LRange.FormulaR1C1 := LStr
    else
      LRange.FormulaR1C1 := '';


    LRange := fworksheet.range['AE4'];
    LRange.FormulaR1C1 := ENGNAME.Text;

    LRange := fworksheet.range['AE6'];
    LRange.FormulaR1C1 := ENGTYPE.Text;

    LRange := fworksheet.range['E8'];
    LRange.FormulaR1C1 := ITEMNAME.Text;

    LRange := fworksheet.range['E10'];
    LRange.FormulaR1C1 := PROCESS.Text;

    LRange := fworksheet.range['AA8'];
    LRange.FormulaR1C1 := FormatDateTime('YYYY-MM-DD HH:mm',SDATE.DateTime);

    LRange := fworksheet.range['AA10'];
    LRange.FormulaR1C1 := PDATE.Text;

    LRange := fworksheet.range['AO4'];
    LRange.FormulaR1C1 := '엔진개발시험부';

    LRange := fworksheet.range['AO5'];
    LRange.FormulaR1C1 := FormatDateTime('YYYY-MM-DD',Now);

    LRange := fworksheet.range['AB13'];
    LStr := StringReplace(Status.Text,#$D#$A,#$A,[rfReplaceAll]);
    lTitle := StringReplace(STATUSTITLE.Text,#$D#$A,#$A,[rfReplaceAll]);
    LRange.FormulaR1C1 := lTitle+#10+LStr;

    fworksheet.range['AB13'].select;
    excel.ActiveCell.Characters(1, Length(lTitle)).Font.Color := -16776961;
    excel.ActiveCell.Characters(1, Length(lTitle)).Font.FontStyle := '굵게';

    LRange := fworksheet.range['AB17'];
    LStr := StringReplace(Reason.Text,#$D#$A,#$A,[rfReplaceAll]);
    lTitle := StringReplace(ReasonTitle.Text,#$D#$A,#$A,[rfReplaceAll]);
    LRange.FormulaR1C1 := lTitle+#10+LStr;

    fworksheet.range['AB17'].select;
    excel.ActiveCell.Characters(1, Length(lTitle)).Font.Color := -16776961;
    excel.ActiveCell.Characters(1, Length(lTitle)).Font.FontStyle := '굵게';

    LRange := fworksheet.range['AB21'];
    LStr := StringReplace(PLAN.Text,#$D#$A,#$A,[rfReplaceAll]);
    lTitle := StringReplace(PLANTITLE.Text,#$D#$A,#$A,[rfReplaceAll]);
    LRange.FormulaR1C1 := lTitle+#10+LStr;

    fworksheet.range['AB21'].select;
    excel.ActiveCell.Characters(1, Length(lTitle)).Font.Color := -16776961;
    excel.ActiveCell.Characters(1, Length(lTitle)).Font.FontStyle := '굵게';

    LRange := fworksheet.range['B26'];
    LStr := StringReplace(Reason1.Text,#$D#$A,#$A,[rfReplaceAll]);
    lTitle := StringReplace(Reason1TITLE.Text,#$D#$A,#$A,[rfReplaceAll]);
    LRange.FormulaR1C1 := lTitle+#10+LStr;

    fworksheet.range['B26'].select;
    excel.ActiveCell.Characters(1, Length(lTitle)).Font.Color := -16776961;
    excel.ActiveCell.Characters(1, Length(lTitle)).Font.FontStyle := '굵게';

    with ACGrid1 do
    begin
      LRange := fworksheet.range['AB27'];
      LRange.FormulaR1C1 := Cells[0,1];

      LRange := fworksheet.range['AB28'];
      LRange.FormulaR1C1 := Cells[0,2];

      LRange := fworksheet.range['AB29'];
      LRange.FormulaR1C1 := Cells[0,3];

      LRange := fworksheet.range['AG27'];
      LRange.FormulaR1C1 := Cells[1,1];

      LRange := fworksheet.range['AG28'];
      LRange.FormulaR1C1 := Cells[1,2];

      LRange := fworksheet.range['AG29'];
      LRange.FormulaR1C1 := Cells[1,3];

      LRange := fworksheet.range['AQ27'];
      LRange.FormulaR1C1 := Cells[2,1];

      LRange := fworksheet.range['AQ28'];
      LRange.FormulaR1C1 := Cells[2,2];

      LRange := fworksheet.range['AQ29'];
      LRange.FormulaR1C1 := Cells[2,3];
    end;
    LRange := fworksheet.range['B32'];
    LStr := StringReplace(Resulta.Text,#$D#$A,#$A,[rfReplaceAll]);
    lTitle := StringReplace(ResultTITLE.Text,#$D#$A,#$A,[rfReplaceAll]);
    LRange.FormulaR1C1 := lTitle+#10+LStr;

    fworksheet.range['B32'].select;
    excel.ActiveCell.Characters(1, Length(lTitle)).Font.Color := -16776961;
    excel.ActiveCell.Characters(1, Length(lTitle)).Font.FontStyle := '굵게';

    LRange := fworksheet.range['AI32'];
    LRange.FormulaR1C1 := ResultC1.Text;

    LRange := fworksheet.range['AI33'];
    LRange.FormulaR1C1 := ResultC2.Text;

    LRange := fworksheet.range['AI34'];
    LRange.FormulaR1C1 := ResultC3.Text;

    LRange := fworksheet.range['AI35'];
    LRange.FormulaR1C1 := ResultC4.Text;

    LRange := fworksheet.range['AI36'];
    LRange.FormulaR1C1 := ResultC5.Text;

    LRange := fworksheet.range['AI38'];
    LRange.FormulaR1C1 := ResultC6.Text;

    {
    with ACgrid2 do
    begin
      LRange := fworksheet.range['AI32'];
      LRange.FormulaR1C1 := Cells[2,1];

      LRange := fworksheet.range['AI33'];
      LRange.FormulaR1C1 := Cells[2,2];

      LRange := fworksheet.range['AI34'];
      LRange.FormulaR1C1 := Cells[2,3];

      LRange := fworksheet.range['AI35'];
      LRange.FormulaR1C1 := Cells[2,4];

      LRange := fworksheet.range['AI36'];
      LRange.FormulaR1C1 := Cells[2,5];

      LRange := fworksheet.range['AI37'];
      LRange.FormulaR1C1 := Cells[2,6];

      LRange := fworksheet.range['AP32'];
      LRange.FormulaR1C1 := Cells[3,1];

      LRange := fworksheet.range['AP33'];
      LRange.FormulaR1C1 := Cells[3,2];

      LRange := fworksheet.range['AP34'];
      LRange.FormulaR1C1 := Cells[3,3];

      LRange := fworksheet.range['AP35'];
      LRange.FormulaR1C1 := Cells[3,4];

      LRange := fworksheet.range['AP36'];
      LRange.FormulaR1C1 := Cells[3,5];

      LRange := fworksheet.range['AP37'];
      LRange.FormulaR1C1 := Cells[3,6];
    end;
    }
    if Image1.Picture.Graphic <> nil then
    begin
      Image1.Picture.SaveToFile('C:/Ci_1.Jpeg');
      Excel.ActiveSheet.Shapes.Item('ImageBox').Select;
      Excel.Selection.ShapeRange.Fill.Visible := 1;
      Excel.Selection.ShapeRange.Fill.UserPicture('C:/Ci_1.Jpeg');
//      Excel.Selection.ShapeRange.Fill.UserPicture('C:\Users\HwangSeonHo\Pictures\Blue-Eye.jpg');
    end;

    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from ZHITEMS_APPROVER where CODEID = :param1');
      parambyname('param1').AsString := CODEID.Text;
      Open;

      if not(RecordCount = 0) then
      begin
        LCCount := Fieldbyname('ACount').AsInteger;
        SetLength(LUserAr,LCCount);
        for li := 0 to LCCount-1 do
          LUserAr[li] := Fields[3+li].AsString;
      end;
    end;

    for li := 0 to LCCount-1 do
    begin
      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select Name_Kor from HITEMS.HITEMS_USER where USERID = :param1');
        parambyname('param1').AsString := LUserAr[li];
        Open;

        if not(RecordCount = 0) then
        begin
          SetLength(LName,LCCount);
          LName[li] := Fieldbyname('Name_Kor').AsString;
        end;
      end;
    end;

    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from ZHITEMS_APPROVEP where CODEID = :param1');
      parambyname('param1').AsString := CODEID.Text;
      Open;

      if not(RecordCount = 0) then
      begin
        SetLength(LApprove,LCCount);
        for li := 0 to LCCount-1 do
          LApprove[li] := Fields[2+li].AsInteger;
      end;
    end;

    if LCCount = 2 then
    begin
      if LApprove[0] = 1 then
      begin
        LRange := fworksheet.range['AO10'];
        LRange.FormulaR1C1 := LName[0]+'(案)';
      end
      else
      begin
        LRange := fworksheet.range['AO10'];
        LRange.FormulaR1C1 := LName[0]+'(未)';
      end;

      if LApprove[1] = 1 then
      begin
        LRange := fworksheet.range['AO6'];
        LRange.FormulaR1C1 := LName[1]+'(認)';
      end
      else
      begin
        LRange := fworksheet.range['AO6'];
        LRange.FormulaR1C1 := LName[1]+'(未)';
      end;
    end;

    if LCCount = 3 then
    begin
      if LApprove[0] = 1 then
      begin
        LRange := fworksheet.range['AO10'];
        LRange.FormulaR1C1 := LName[0]+'(案)';
      end
      else
      begin
        LRange := fworksheet.range['AO10'];
        LRange.FormulaR1C1 := LName[0]+'(未)';
      end;

      if LApprove[1] = 1 then
      begin
        LRange := fworksheet.range['AO8'];
        LRange.FormulaR1C1 := LName[1]+'(檢)';
      end
      else
      begin
        LRange := fworksheet.range['AO8'];
        LRange.FormulaR1C1 := LName[1]+'(未)';
      end;

      if LApprove[2] = 1 then
      begin
        LRange := fworksheet.range['AO6'];
        LRange.FormulaR1C1 := LName[2]+'(認)';
      end
      else
      begin
        LRange := fworksheet.range['AO6'];
        LRange.FormulaR1C1 := LName[2]+'(未)';
      end;
    end;

    if LCCount >= 4 then
    begin
      if LApprove[0] = 1 then
      begin
        LRange := fworksheet.range['AO10'];
        LRange.FormulaR1C1 := LName[0]+'(案)';
      end
      else
      begin
        LRange := fworksheet.range['AO10'];
        LRange.FormulaR1C1 := LName[0]+'(未)';
      end;

      if LApprove[LCCount-2] = 1 then
      begin
        LRange := fworksheet.range['AO8'];
        LRange.FormulaR1C1 := LName[LCCount-2]+'(檢)';
      end
      else
      begin
        LRange := fworksheet.range['AO8'];
        LRange.FormulaR1C1 := LName[LCCount-2]+'(未)';
      end;

      if LApprove[LCCount-1] = 1 then
      begin
        LRange := fworksheet.range['AO6'];
        LRange.FormulaR1C1 := LName[LCCount-1]+'(認)';
      end
      else
      begin
        LRange := fworksheet.range['AO6'];
        LRange.FormulaR1C1 := LName[LCCount-1]+'(未)';
      end;
    end;
    Excel.Visible := True;
  finally
    DeleteFile('C:/ci_1.Jpeg');
  end;//try
end;


procedure TTrouble_Frm.Generator_CODEID_of_TSMS;
var
  LCount : integer;
  LDouble : Double;
  LUpDate, LInsert : Boolean;
  LDept : String;
  LYear, LMonth, LSeqNo : String;

begin
  LUpDate := False;
  LInsert := False;

//  with DM1.EQuery1 do
//  begin
//    Try
//      Close;
//      SQL.Clear;
//      SQL.Add('select SEQNo from TS_GetSEQNo where Dept = :param1');
////      SQL.Add('select SEQNo from TS_GetSEQNo where Dept = :param1');
//      SQL.Add('And Year = :param2 And Month = :param3');
//
//      ParamByName('Param1').AsString := Statusbar1.Panels[2].Text;
//      ParamByName('Param2').AsString := FormatDateTime('YYYY',Now);
//      ParamByName('Param3').AsString := FormatDateTime('MM',Now);
//      Open;
//
//      if RecordCount = 0 then
//      begin
//        LInsert := True;
//        LCount := 0;
//      end
//      else
//      begin
//        LUpdate := True;
//        LCount := StrToInt(FieldByName('SeqNo').AsString);
//      end;//else
//    except
//
//    raise;
//    end;
//  end;//with
//
//  if LUpdate = True then
//  begin
//    with DM1.EQuery1 do
//    begin
//      Try
//        Close;
//        SQL.Clear;
//        SQL.Add(' Update TS_GetSEQNo Set');
////        SQL.Add(' Update TS_GetSEQNo Set');
//        SQL.Add(' SeqNo = :SeqNo ');
//        SQL.Add(' where Dept = :Param1 And Year = :param2 And Month = :param3');
//
//        paramByName('Param1').AsString := Statusbar1.Panels[2].Text;
//        paramByName('Param2').AsString := FormatDateTime('YYYY',Now);
//        paramByName('Param3').AsString := FormatDateTime('MM',Now);
//
//        ParambyName('SeqNo').AsString := IntToStr(LCount+1);
//        ExecSQL;
//      except
//      raise;
//      end;
//    end;//with
//  end;//if
//
//  if LInsert = True then
//  begin
//    with DM1.EQuery1 do
//    begin
//      try
//        Close;
//        SQL.Clear;
//        SQL.Add('insert into TS_GetSEQNo');
////        SQL.Add('insert into TS_GetSEQNo');
//        SQL.Add('(Dept, Year, Month, SeqNo)');
//        SQL.Add(' Values (:Dept, :Year, :Month, :SeqNo)');
//
//        ParamByName('Dept').AsString := Statusbar1.Panels[2].Text;
//        ParamByName('Year').AsString := FormatDateTime('YYYY',Now);
//        ParamByName('Month').AsString := FormatDateTime('MM',Now);
//        ParamByName('SeqNo').AsString := intToStr(LCount + 1);
//        ExecSQL;
//      except
//      raise;
//      end;
//    end;//with
//  end;//if
//
//  //관리번호 생성하고~~ CodeID.Text 에 관리번호 집어넣기!!
//
//  with DM1.EQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('select * from TS_GetSEQNo where Dept = :param1');
////    SQL.Add('select * from TS_GetSEQNo where Dept = :param1');
//    SQL.Add('And Year = :param2 And Month = :param3');
//    ParamByName('Param1').AsString := Statusbar1.Panels[2].Text;
//    ParamByName('Param2').AsString := FormatDateTime('YYYY',Now);
//    ParamByName('Param3').AsString := FormatDateTime('MM',Now);
//    Open;
//
//    LYear  := FieldByName('Year').AsString;
//    LMonth := FieldByName('Month').AsString;
//    LDouble:= StrToFloat(FieldByName('SeqNo').AsString);
//    LSeqNo := formatFloat('000',LDouble);
//
//    CODEID.Clear;
//    LDept := Statusbar1.Panels[2].Text;
//    CodeID.Text := 'TS_'+LDept+'_'+ LYear +'_'+ LMonth +'_'+ LSeqNo; //관리번호 완성~~
//  end;//with
end;

//TSMS 대신에 TBACS에서 번호 생성함.
procedure TTrouble_Frm.Generator_CODEID_of_TSMS2;
var
  LCount : integer;
  LDouble : Double;
  LUpDate, LInsert : Boolean;
  LDept : String;
  LYear, LMonth, LSeqNo : String;

begin
  LUpDate := False;
  LInsert := False;

  with DM1.TQuery1 do //EQuery1
  begin
    Try
      Close;
      SQL.Clear;
      SQL.Add('select SEQNo from TROUBLE_TSNO where Dept = :param1');
      SQL.Add('And Year = :param2 And Month = :param3');

      ParamByName('Param1').AsString := Statusbar1.Panels[2].Text;
      ParamByName('Param2').AsString := FormatDateTime('YYYY',Now);
      ParamByName('Param3').AsString := FormatDateTime('MM',Now);
      Open;

      if RecordCount = 0 then
      begin
        LInsert := True;
        LCount := 0;
      end
      else
      begin
        LUpdate := True;
        LCount := StrToInt(FieldByName('SeqNo').AsString);
      end;//else
    except

    raise;
    end;
  end;//with

  if LUpdate = True then
  begin
    with DM1.TQuery1 do //EQuery1
    begin
      Try
        Close;
        SQL.Clear;
        SQL.Add(' Update TROUBLE_TSNO Set');
        SQL.Add(' SeqNo = :SeqNo ');
        SQL.Add(' where Dept = :Param1 And Year = :param2 And Month = :param3');

        paramByName('Param1').AsString := Statusbar1.Panels[2].Text;
        paramByName('Param2').AsString := FormatDateTime('YYYY',Now);
        paramByName('Param3').AsString := FormatDateTime('MM',Now);

        ParambyName('SeqNo').AsString := IntToStr(LCount+1);
        ExecSQL;
      except
      raise;
      end;
    end;//with
  end;//if

  if LInsert = True then
  begin
    with DM1.TQuery1 do //EQuery1
    begin
      try
        Close;
        SQL.Clear;
        SQL.Add('insert into TROUBLE_TSNO');
        SQL.Add('(Dept, Year, Month, SeqNo)');
        SQL.Add(' Values (:Dept, :Year, :Month, :SeqNo)');

        ParamByName('Dept').AsString := Statusbar1.Panels[2].Text;
        ParamByName('Year').AsString := FormatDateTime('YYYY',Now);
        ParamByName('Month').AsString := FormatDateTime('MM',Now);
        ParamByName('SeqNo').AsString := intToStr(LCount + 1);
        ExecSQL;
      except
      raise;
      end;
    end;//with
  end;//if

  //관리번호 생성하고~~ CodeID.Text 에 관리번호 집어넣기!!

  with DM1.TQuery1 do //EQuery1
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from TROUBLE_TSNO where Dept = :param1');
    SQL.Add('And Year = :param2 And Month = :param3');
    ParamByName('Param1').AsString := Statusbar1.Panels[2].Text;
    ParamByName('Param2').AsString := FormatDateTime('YYYY',Now);
    ParamByName('Param3').AsString := FormatDateTime('MM',Now);
    Open;

    LYear  := FieldByName('Year').AsString;
    LMonth := FieldByName('Month').AsString;
    LDouble:= StrToFloat(FieldByName('SeqNo').AsString);
    LSeqNo := formatFloat('000',LDouble);

    CODEID.Clear;
    LDept := Statusbar1.Panels[2].Text;
    CodeID.Text := 'TS_'+LDept+'_'+ LYear +'_'+ LMonth +'_'+ LSeqNo; //관리번호 완성~~
  end;//with
end;

procedure TTrouble_Frm.Get_Attachment_From_Trouble_attfiles(FCODEID,MCODEID: String);
var
  li : integer;
  LFlag : String;
  LCase : integer;
  LFileGrid : TNextGrid;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Trouble_ATTFILES');
    SQL.Add('where CODEID In ('''+FCODEID+''','''+MCODEID+''') order by ATTFLAG Desc');
    Open;

    if not(RecordCount = 0) then
    begin
      for li := 0 to RecordCount-1 do
      begin
        LFlag := Fieldbyname('ATTFLAG').AsString;
        if LFlag = 'I' then
          LCase := 0;
        if LFlag = 'A' then
          LCase := 1;
        if LFlag = 'B' then
          LCase := 2;
        if LFlag = 'C' then
          LCase := 3;



        LFileGrid := TNextGrid(Self.FindComponent('FileGrid'+IntToStr(LCase)));

        with LFileGrid do
        begin
          AddRow(1);
          Cells[2,RowCount-1] := Fieldbyname('LCFILENAME').AsString;
          Cells[3,RowCount-1] := Fieldbyname('FILESIZE').AsString;
          Cells[4,RowCount-1] := Fieldbyname('FILEEXT').AsString;
        end;
        Next;
      end;
    end;
  end;
//  Show_Trouble_Image(FCODEID,MCODEID,0);
  Get_Trouble_Image(FCODEID,MCODEID);
end;

procedure TTrouble_Frm.Get_CClist_From_Trouble_CCList(FCODEID: String);
var
  LStrList : TStringList;
  Li : integer;

begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * From Trouble_CCList where CODEID = :param1');
    parambyname('param1').AsString := FCODEID;
    Open;

    if not(RecordCount=0) then
      CCListS.Text := FieldByName('CCList').AsString;
  end;

  if not(CCListS.GetTextLen <= 0) then
  begin
    Try
      LStrList := TStringList.Create;
      LStrList.Delimiter := ';';
      LStrList.DelimitedText := CCListS.Text;

      CCListN.Clear;

      for li := 0 to LStrList.Count-1 do
      begin
        if not(LStrList.Strings[li] = '') then
        begin
          with DM1.TQuery1 do //EQuery1
          begin
            Close;
            SQL.Clear;
            SQL.Add('Select * From HITEMS.HITEMS_USER where USERID = :param1');
            Parambyname('param1').AsString := LStrList.Strings[li];
            Open;

            CCListN.Text := CCListN.Text+FieldByName('NAME_KOR').AsString+';';
          end;//with
        end;//if
      end;//for
    Finally
      LStrList.Free;
    End;
  end;
end;

procedure TTrouble_Frm.Get_of_EDMS_ITEMS;
begin
  //Div_Lic 가져오기
//  with DM1.EQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('Select * From TS_CODE');
//    SQL.Add('where KIND = :param1 order by CODE');
//    parambyname('param1').AsString := 'divlic';
//    Open;
//
//    DivLic.Items.Clear;
//
//    while not eof do
//    begin
//      DivLic.Items.Add(FieldByName('DATA').AsString);
//      Next;
//    end;
//  end;
//
//  //RPM
//  with DM1.EQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('Select * From TS_CODE');
//    SQL.Add('where KIND = :param1 order by CODE');
//    parambyname('param1').AsString := 'rpm';
//    Open;
//
//    rpm.items.Clear;
//
//    while not eof do
//    begin
//      rpm.Items.Add(FieldByName('DATA').AsString);
//      Next;
//    end;
//  end;
//
//  //Actioncode
//  with DM1.EQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('Select * From TS_CODE');
//    SQL.Add('where KIND = :param1 order by CODE');
//    parambyname('param1').AsString := 'actioncode';
//    Open;
//
//    ActionCode.items.Clear;
//
//    while not eof do
//    begin
//      ActionCode.Items.Add(FieldByName('DATA').AsString);
//      Next;
//    end;
//  end;
//
//  //용도
//  with DM1.EQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('Select * From TS_CODE');
//    SQL.Add('where KIND = :param1 order by CODE');
//    parambyname('param1').AsString := 'use';
//    Open;
//
//    Foruse.items.Clear;
//
//    while not eof do
//    begin
//      Foruse.Items.Add(FieldByName('DATA').AsString);
//      Next;
//    end;
//  end;
end;

function TTrouble_Frm.Get_Report_Fomat_From_FTP: Boolean;
begin
  Result := False;
  try
    TBACS_FTP_SERVER_Connection;
    if DM1.IdFTP2.Connected = True then
    begin
      with DM1.IdFTP2 do
      begin
        ChangeDir('Data_Sheet/');
        Get('Trouble_RP.xls',SaveDialog1.FileName,True);
        Result := True;
      end;
    end;
  finally
    TBACS_FTP_SERVER_Connection;//DisConnect;
  end;
end;

procedure TTrouble_Frm.Get_Trouble_Image(FCODEID, FMCODE:String);
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
        SQL.Add('select * from Trouble_Attfiles ');
        SQL.Add(' where CODEID In ('''+FCODEID+''','''+FMCODE+''') and AttFlag = ''I'' ');
        Open;

        if not(RecordCount = 0) then
        begin
          for li := 0 to RecordCount-1 do
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
      FileGrid0.SelectedRow := 0;
      EndUpdate;
    end;
  end;
end;

function TTrouble_Frm.Get_UserName(aUSERID: String): String;
begin
//  with DM1.OraQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('SELECT * FROM HiTEMS.HITEMS_USER A ' +
//            'WHERE USERID LIKE :param1 ');
//    ParamByName('param1').AsString := aUSERID;
//    Open;
//
//    Result := FieldByName('NAME_KOR').AsString;
//  end;
  Result := DM1.GetKORNameFromID(AUserId);
end;

procedure TTrouble_Frm.grptypeClick(Sender: TObject);
begin
  case GrpType.ItemIndex of
   -1 : begin
          Label1.Caption := '문제 보고서';
          Label1.Left := 72;
          Label2.Caption := '(Trouble Report)';
          Label2.Left := 86;
        end;

    0 : begin
          Label1.Caption := '품질 문제 보고서';
          Label1.Left := 40;
          Label2.Caption := '(Quality Trouble)';
          Label2.Left := 82;
        end;

    1 : begin
          Label1.Caption := '설비 문제 보고서';
          Label1.Left := 40;
          Label2.Caption := '(Auxiliary Trouble)';
          Label2.Left := 82;
        end;

    2 : begin
          Label1.Caption := '문제 예상 보고서';
          Label1.Left := 40;
          Label2.Caption := '(Trouble Expectation)';
          Label2.Left := 66;
        end;
  end;
end;

procedure TTrouble_Frm.HIEMPNOKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_LEFT) or (key = VK_UP) or (key = VK_RIGHT) or (key = VK_DOWN) then
    key := 0;
end;

procedure TTrouble_Frm.HIINEMPNOKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_LEFT) or (key = VK_UP) or (key = VK_RIGHT) or (key = VK_DOWN) then
    key := 0;
end;

procedure TTrouble_Frm.Image1DblClick(Sender: TObject);
var
  LForm : TForm;
  LImage : TImage;
  LStatus : TAdvOfficeStatusBar;

begin
  if Image1.Picture.Graphic <> nil then
  begin
    Try
      LForm := TForm.Create(self);
      with LForm do
      begin
        Caption := 'Trouble Image / '+FileGrid0.Cells[2,FxRow];
        Name := 'ImgForm';
        Width := 580;
        Height := 420;
        Position := poScreenCenter;

        LStatus := TAdvOfficeStatusbar.Create(LForm);
        with LStatus do
        begin
          SimplePanel := True;
          Parent := LForm;
          Align := alBottom;

        end;

        LImage := TImage.Create(LForm);
        with LImage do
        begin
          Name := 'ViewImage';
          Align := alClient;
          Parent := LForm;
          Stretch := True;
          Picture.Graphic := Image1.Picture.Graphic;
        end;//with
      end;//with
      LForm.ShowModal;
    finally
      LStatus.Free;
      LImage.Free;
      LForm.Free;
    end;
  end;//if
end;

procedure TTrouble_Frm.INEMPNOKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_LEFT) or (key = VK_UP) or (key = VK_RIGHT) or (key = VK_DOWN) then
    key := 0;
end;

procedure TTrouble_Frm.InEMP_User_Check_for_TRouble_List(FCODEID: String;
  FIdx: Integer);
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update Trouble_Mobile Set STEP = :STEP where MCODEID = :param1');
    parambyname('Step').AsInteger := FIdx;
    parambyname('param1').AsString := FCODEID;
    ExecSQL;
  end;
end;

procedure TTrouble_Frm.Initialize_of_Trouble_Frm;
var
  li,lr : integer;
  LStr : String;
begin
  // 변수 초기화 ================================================
  FxRow   := 0;
  FxCol   := 0;
  FReturnContent := ''; //반려 보고서 내용

  FAppCount := 1; //결재선 초기화
  Approval_Grid_Setting(1);//결재테이블 초기화
  AppGrid.Refresh;
  Panel1.Invalidate;
  FillChar(FAprovalArr,SizeOf(FAprovalArr), 0); // 결재선 사번 초기화

  //=============================================================

  GrpType.ItemIndex := -1;
  Label1.Caption := '문제 보고서';
  Label1.Left := 76;
  Label2.Caption := '(Trouble Report)';
  Label2.Left := 86;

  CodeID.Clear;
  MCodeId.Clear;
  ClaimNo.Clear;
  Title.Clear;
  EngName.Clear;
  ProjNo.Clear;
  EngType.Clear;
  ProjName.Clear;
  ShipNo.Clear;
  Divlic.Clear;
  TOwner.Clear;
  Site.Clear;
  RPM.Clear;
  EngNum.Clear;
  ActionCode.Clear;
  WorkTime.Clear;
  Foruse.Clear;

  EmpNo.Items.Clear;
  EMPNo.Text := '';

  //INempNo.Items.Clear;
  //INempNo.Text := '';

  HIEMPNO.Items.Clear;
  HIEMPNO.Text := '';

  HIINEMPNO.Items.Clear;
  HIINEMPNO.Text := '';

  ApplyEmpno.Items.Clear;
  ApplyEmpno.Text := '';

  RegType.ItemIndex := 0;
  RefType.ItemIndex := 1;

  SendDate.Date := Now;
  SendDate.Text := '';

  RcvDate.Date := Now;
  RcvDate.Text := '';

  SDate.DateTime := Now;
  SDate.DateTime := SDate.DateTime;

  ADate.Date := Now;
  ADate.Text := FormatDateTime('YYYY-MM-DD',Now);

  EDate.Date := Now;
  EDate.Text := '';

  DesignApp.ItemIndex := 0;

  TroubleList.ClearRows;

  CClistN.Clear;
  CClistS.Clear;

  StepText.Clear;
  StepStat.ItemIndex := -1;


  // 이미지 부분....
  Image1.Picture.Assign(nil);
  Image1.Refresh;
  FileGrid0.ClearRows;


  // 파일첨부 1
  FileGrid1.ClearRows;

  // 파일첨부 2
  FileGrid2.ClearRows;

  // 파일첨부 1
  FileGrid3.ClearRows;


  for li := 0 to 3 do
    TrKind.Checked[li] := False;


  ItemName.Clear;

  SDate.DateTime := Now;

  ADate.Date := Now;
  ADate.Text := FormatDateTime('YYYY-MM-DD',Now);

  Process.Clear;
  PDate.Date := Now;
  PDate.Text := '';

  StatusTitle.Clear;
  Status.Clear;
  ReasonTitle.Clear;
  Reason.Clear;
  PlanTitle.Clear;
  Plan.Clear;
  Reason1title.Clear;
  Reason1.Clear;
  ResultTitle.Clear;
  Resulta.Clear;

  for li := 0 to 2 do
    for lr := 1 to 3 do
      with ACGrid1 do
        Cells[li,lr] := '';
{
  for li := 2 to 3 do
    for lr := 1 to 6 do
      with ACGrid2 do
        Cells[li,lr] := '';
}
    ResultC1.Clear;
    ResultC2.Clear;
    ResultC3.Value := 0;
    ResultC4.Value := 0;
    ResultC5.Value := 0;
    ResultC6.Value := 0;


// 버튼 상태
  TempSave.Visible := True;   // 보고서 저장
  TempSave.Enabled := True;
  TempUpdate.Visible := False; // 보고서 수정
  summitbtn.Enabled := False;      // 보고서 결재상신

  FResultBtn.Visible := False; //조치결과 저장
  CompleBtn.Visible := False; //완료처리

  DesignApp.ItemIndex := 0;
  ApplyEmpno.Items.Clear;
  ApplyEmpno.Text := '';
  EDate.Date := Now;
  EDate.Text := '';

  FUpList.Items.Clear; //FResultBtn, CompleBtn Visible Control
  NxPageControl1.ActivePageIndex := 0;
  Self.Invalidate;
end;

procedure TTrouble_Frm.Input_of_New_Report_InCharger;
var
  LClass, lemp : String;
begin
  Initialize_of_Trouble_Frm;

  lemp := Statusbar1.Panels[4].Text;
  INEMPNO.Items.Add(lemp);
  INEMPNO.Text := Get_UserName(lemp);
  INEMPNO.Hint := lemp;

  if INEMPNO.Items.Count >0 then
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      sQL.Add('SELECT A.NAME_KOR, A.GRADE, DESCR FROM HITEMS.HITEMS_USER A, HITEMS.HITEMS_USER_GRADE B ' +
              'WHERE A.USERID = :param1 ' +
              'AND A.GRADE = B.GRADE ');
      parambyname('param1').AsString := Statusbar1.Panels[4].Text;
      Open;
//      INEMPNO.Text := fieldbyname('Name_Kor').AsString;
      LClass := Fieldbyname('DESCR').AsString;
    end;

    with AppGrid do
    begin
      Approval_Grid_Setting(1);
      Cells[1,0] := LClass+'/'+INEMPNO.Text;
      Cells[1,2] := FormatDateTime('YY.MM.DD',Now);
    end;
  end;
end;

procedure TTrouble_Frm.Open_Engine_Info;
var
  LForm : TEngGeneral_Frm;
begin
  LForm := TEngGeneral_Frm.Create(nil);
  try
    LForm.FOwner := Self;
    LForm.ShowModal;
  finally
    FreeAndNIl(LForm);
  end;
end;

procedure TTrouble_Frm.planClick(Sender: TObject);
begin
  if not(planTitle.GetTextLen > 1) then
  begin
    ShowMessage('요약을 먼저 기입하여 주십시오...');
    planTitle.SetFocus;
  end;
end;

procedure TTrouble_Frm.P_ResetClick(Sender: TObject);
begin
  Initialize_of_Trouble_Frm;
end;

procedure TTrouble_Frm.Reason1Click(Sender: TObject);
begin
  if not(Reason1Title.GetTextLen > 1) then
  begin
    ShowMessage('요약을 먼저 기입하여 주십시오...');
    Reason1Title.SetFocus;
  end;
end;

procedure TTrouble_Frm.ReasonClick(Sender: TObject);
begin
  if not(ReasonTitle.GetTextLen > 1) then
  begin
    ShowMessage('요약을 먼저 기입하여 주십시오...');
    ReasonTitle.SetFocus;
  end;
end;

procedure TTrouble_Frm.Register_Trouble_Data_To_TSMS;
var
  LCCount, LPending : integer;
  LOriginCODE : String;
begin
  if CODEID.Text = '' then Exit;

  LOriginCODE := CODEID.Text;

  if not(LeftStr(CODEID.Text,2) = 'TT') then Exit;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select A.ACount, B.Pending from ZHITEMS_APPROVER A, ZHITEMS_APPROVED B');
    SQL.Add('where A.CODEID = :param1 and A.CODEID=B.CODEID');
    parambyname('param1').AsString := CODEID.Text;
    Open;

    if not(RecordCount = 0) then
    begin
      LCCount  := FieldByName('ACount').AsInteger;
      LPending := FieldByName('Pending').AsInteger;
    end;
  end;

  if LCCount = LPending then
  begin
    if not(GRpType.ItemIndex = 2) then  //"문제예상" 이 아니면
    begin
      Generator_CODEID_of_TSMS2; //TSMS 코드번호 생성 후 CODE.text 에 입력!
      try
//        if TroubleData_Save_To_TSMS = True then
//        begin
//          TroubleFiles_Info_Upload_To_TSMS(CODEID.Text,LOriginCODE); // 첨부파일 등록

          // TSMS에 데이터가 저장 되었으면 Trouble_DataTemp 에 저장된 데이터를 Trouble_Data로 이동한다.
          TroubleData_Move_To_MainTable(LOriginCODE); // Data 이동 후 DataTemp Record 삭제
          Update_TroubleRP_CODE_TO_TSMS(CODEID.Text,LOriginCODE);//임시코드를 TSMS 코드로 수정
          Send_Message_to_Design_Charge; //설계 담당자에게 통보
          Send_Message_to_CarbonCharge; // 참조대상에서 통보
//        end;
      Except
//        Turn_to_Back_Before_TSMSCODE2(CODEID.Text,LOriginCODE);
      end;
    end
    else
    begin
      if GrpType.ItemIndex = 2 then
      begin
        Trouble_expectation_CODE_Generator;
        TroubleData_Move_To_MainTable(LOriginCODE); // Data 이동 후 DataTemp Record 삭제
        Update_TroubleRP_CODE_TO_TSMS(CODEID.Text,LOriginCODE);//임시코드를 문제예상 코드로 수정
        Send_Message_to_CarbonCharge; // 참조대상에서 통보
      end;
    end;
  end
  else
    Exit;
end;

procedure TTrouble_Frm.Registor_of_New_Report_Log(FCODEID, FCharge: String;
  FKind: integer);
var
  LCount : integer;
  LAction : String;
begin
  case FKind of
    0 : LAction := GrpType.Items.Strings[GrpType.ItemIndex]+'-신규등록';
    1 : LAction := GrpType.Items.Strings[GrpType.ItemIndex]+'-보고서 수정';
    2 : LAction := GrpType.Items.Strings[GrpType.ItemIndex]+'-보고서 반려';
    3 : LAction := GrpType.Items.Strings[GrpType.ItemIndex]+'-보고서 결재';
    4 : LAction := GrpType.Items.Strings[GrpType.ItemIndex]+'-결재 완료';
    5 : LAction := GrpType.Items.Strings[GrpType.ItemIndex]+'-반려처리 취소';
    6 : LAction := GrpType.Items.Strings[GrpType.ItemIndex]+'-설계담당자 조치내용 저장';
    7 : LAction := GrpType.Items.Strings[GrpType.ItemIndex]+'-설계담당자 문서 완료처리';
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select LCount from TROUBLE_DATALOG where CODEID = :param1');
    parambyname('param1').AsString := FCODEID;
    Open;

    if not(RecordCount = 0) then
      LCount := RecordCount +1
    else
      LCount := 1;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into TROUBLE_DATALOG');
    SQL.Add('Values(:CODEID, :LCOUNT, :LCHARGE, :LDATE, :LACTION)');
    parambyname('CODEID').AsString  := FCODEID;
    parambyname('LCOUNT').AsInteger := LCount;
    parambyname('LCHARGE').AsString := FCharge;
    parambyname('LDATE').AsDateTime := Now;
    parambyname('LACTION').AsString := LAction;
    ExecSQL;
  end;
end;

procedure TTrouble_Frm.RESULTaClick(Sender: TObject);
begin
  if not(RESULTTitle.GetTextLen > 1) then
  begin
    ShowMessage('요약을 먼저 기입하여 주십시오...');
    RESULTTitle.SetFocus;
  end;
end;

function TTrouble_Frm.Return_for_Message(FCODE:String) : Boolean;
var
  LForm : TReturnMsg_Frm;
begin
  Result := False;
  try
    LForm := TReturnMsg_Frm.Create(nil);
    with LForm do
    begin
      FOwner := Self;
      label1.Caption := FCODE;
      FMode := 0; // 0: 등록모드, 1:확인모드
      ShowModal;

      if not(FReturnContent = '') then
      begin
        Result := True;
        Exit;
      end
      else
      begin
        Result := False;
        Exit;
      end;
    end;
  finally
    FreeAndNil(LForm);
  end;
end;

procedure TTrouble_Frm.Return_Process;
var
  LCCount, LPending : integer;
  LCharge : String;
  LBCount : integer;
begin
  // 결재선 카운트와 진행단계

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select A.*, B.Pending from ZHITEMS_APPROVER A, ZHITEMS_APPROVEP B');
    SQL.Add('where A.CODEID = :param1 And A.CodeID = B.CodeID');
    Parambyname('param1').AsString := CODEID.Text;
    Open;

    LCCount := FieldByName('ACount').AsInteger;  //결재선이 몇명인지 기록
    LPending := FieldByName('Pending').AsInteger; //현재 문서 진행상태.. 어디까지 결재 되었나?

    LPending := LPending + 1;// 현재결재선에서 한단계 위 검색
  end;

  if not(LPending > LCCount) then
  begin
    if Return_for_Message(CODEID.Text) = True then
    begin
      if InEMPNo.Items.Count > 0 then
        LCharge := InEMPNO.Items.Strings[0];

      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from ZHITEMS_DOCRETURN where CODEID = :param1');
        parambyname('param1').AsString := CODEID.Text;
        Open;

        if not(RecordCount = 0) then
          LBCount := RecordCount+1
        else
          LBCount := 1;
      end;

      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Insert into ZHITEMS_DOCRETURN');
        SQL.Add('Values(:CODEID, :BCount, :Charge, :Confirm, :Bdate, :Content)');
        parambyname('CODEID').AsString  := CODEID.Text;
        parambyname('BCount').AsInteger := LBCount;
        parambyname('Charge').AsString  := LCharge;
        parambyname('Confirm').AsString := Statusbar1.Panels[4].Text;
        parambyname('Bdate').AsDateTime := Now;
        parambyname('Content').AsString := FReturnContent;
        ExecSQL;
      end;

      Return_to_First_Step(CODEID.Text, LCharge, LPending);
      Registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,2);//수정로그
      ShowMessage('반려절차가 완료 되었습니다.');
      Exit;
    end
    else
    begin
      Registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,5);//수정로그
      ShowMessage('반려 절차가 취소되었습니다.');
      Exit;
    end;
  end;
end;

function TTrouble_Frm.Return_to_First_Step(FCODEID,FCharge:String;FPending:integer): Boolean;
var
  LFlag,LCharge,LNextCharge,LHead,LTitle,LContent : AnsiString; //Send Message 변수!!
  Li : integer;
  LDate : TDateTime;
begin
  Result := False;
  //Trouble_ConfirmP 초기화 및 상태 반려처리로 업데이트
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update ZHITEMS_APPROVEP Set');
    SQL.Add('Pending = :Pending, APPROVAL1 = :APPROVAL1, APPROVAL2 = :APPROVAL2,');
    SQL.Add('APPROVAL3 = :APPROVAL3, APPROVAL4 = :APPROVAL4, APPROVAL5 = :APPROVAL5, STATUS = :STATUS');
    SQL.Add('where CODEID = :param1');
    parambyname('param1').AsString := FCODEID;

    parambyname('Pending').AsInteger  := 0;
    parambyname('APPROVAL1').AsInteger   := 0; //0:미결재 1:결재
    parambyname('APPROVAL2').AsInteger := 0;
    parambyname('APPROVAL3').AsInteger := 0;
    parambyname('APPROVAL4').AsInteger := 0;
    parambyname('APPROVAL5').AsInteger := 0;
    parambyname('STATUS').AsInteger    := 2; //0:작성중 1:결재진행 2:반려처리
    ExecSQL;
  end;

  //Trouble_ConfirmD 반려로 인해 결재일 초기화
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update ZHITEMS_APPROVED Set');
    SQL.Add('Pending = :Pending, APPROVAL1 = :APPROVAL1, APPROVAL2 = :APPROVAL2, ');
    SQL.Add('APPROVAL3 = :APPROVAL3, APPROVAL4 = :APPROVAL4, APPROVAL5 = :APPROVAL5');
    SQL.Add('where CODEID = :param1');
    parambyname('param1').AsString := FCODEID;

    parambyname('Pending').AsInteger  := 0;
    parambyname('APPROVAL1').AsString  := '';
    parambyname('APPROVAL2').AsString  := '';
    parambyname('APPROVAL3').AsString  := '';
    parambyname('APPROVAL4').AsString  := '';
    parambyname('APPROVAL5').AsString  := '';
    ExecSQL;
  end;


  Approval_Grid_Setting(1);
  Approval_Sign_Apply_To_Table; //사인 적용


  LCharge := FCharge; //Receive;
  LNextCharge := StatusBar1.Panels[4].Text; //Send;

  if not(LCharge = LNextCharge) and not(LCharge = '') and not(LNextCharge = '') then
  begin
    LHead := 'HiTEMS-문제점보고서';
    LTITLE := '결재상신한 보고서가 반려 되었습니다. 수정 후 재상신 요망!';
    LCONTENT := ItemName.Text+'에 관한 문제점 보고서가 결재 반려 되었습니다. 검토 후 결재상신 부탁 드립니다.';

    for li := 0 to 1 do
    begin
      case li of
        0 : LFlag := 'A';
        1 : LFlag := 'B';
      end;
      Send_Message_Main_CODE(LFlag,LNextCharge,LCharge,LHead,LTitle,LContent);
      // LNextCharge : Send, LCharge : Receive

    end;
  end;
end;

procedure TTrouble_Frm.RpDelClick(Sender: TObject);
begin
  If MessageDlg('작성중인 보고서를 삭제 하시겠습니까?'+#13+'삭제된 문서는 확인하실 수 없습니다.', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then

  if not(CodeID.Text = '') and (LeftStr(CODEID.Text,2) = 'TT') then
  begin
    if (statusbar1.Panels[4].Text = '') or (INEMPNO.Items.Strings[0] = '') then
      Exit;

    if statusbar1.Panels[4].Text = INEMPNO.Items.Strings[0] then
    begin
      Delete_TroubleRP_Temp_Data(CODEID.Text); // 보고서 삭제
      Initialize_of_Trouble_Frm; // 삭제 후 보고서 리셋
      FTroubleFrmChanged := True;
      Btn_arrangement_after_check_for_DocStatus;
    end
    else
      ShowMessage('문서 등록자만이 삭제 가능 합니다.');
  end;
end;

function TTrouble_Frm.Save_of_Approval : Boolean;
begin
  Result := False;
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from ZHITEMS_APPROVER');
    SQL.Add('where CODEID = :param1');
    Parambyname('Param1').AsString := CODEID.Text;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from ZHITEMS_APPROVEP');
    SQL.Add('where CODEID = :param1');
    Parambyname('Param1').AsString := CODEID.Text;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from ZHITEMS_APPROVED');
    SQL.Add('where CODEID = :param1');
    Parambyname('Param1').AsString := CODEID.Text;
    ExecSQL;
  end;

  if (Approver_to_ZHITEMS_APPROVER = true) and
     (Approved_info_to_ZHITEMS_APPROVEP_D = true) then Result := True;

end;

function TTrouble_Frm.Select_User_Info(fUserId: String): String;
var
  li : integer;
  LName, LClass : String;
begin
  try
    with DM1.TQuery2 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select A.USERID, NAME_KOR, A.GRADE, DESCR FROM HITEMS.HITEMS_USER A, HITEMS.HITEMS_USER_GRADE B');
      SQL.Add('where A.UserID = :param1 and A.GRADE = B.GRADE ');
      parambyname('param1').AsString := fUserId;
      Open;

      if not(Fieldbyname('Name_Kor').AsString = '') then
      begin
        LName := Fieldbyname('Name_Kor').AsString;
        LClass := Fieldbyname('DESCR').AsString;
        Result := LClass + ' ' + LName;
      end
      else
        Result := '';
    end;
  except
    Result := '';
  end;
end;

procedure TTrouble_Frm.Send_Message_Main_CODE(FFlag, FSendID, FRecID, FHead,
  FTitle, FContent: String);
var
  LTXK0SMS2 : TXK0SMS2;
begin
  LTXK0SMS2 := TXK0SMS2.Create;
  try
    LTXK0SMS2.SEND_SABUN := FSendID;
    LTXK0SMS2.RCV_SABUN := FRecID;
    LTXK0SMS2.SYS_TYPE := '112';
    LTXK0SMS2.NOTICE_GUBUN := FFlag;

    LTXK0SMS2.TITLE := FTitle;
    //LTXK0SMS2.SEND_HPNO := '010-4190-6742';
    //LTXK0SMS2.RCV_HPNO := '010-3351-7553';
    LTXK0SMS2.CONTENT := FContent;
    LTXK0SMS2.ALIM_HEAD := FHead;

    SendHHIMessage(LTXK0SMS2);
  finally
    LTXK0SMS2.Free;
  end;
end;

procedure TTrouble_Frm.Send_Message_to_After_Approved(FCODEID: String);
var
  Li : integer;
  LPending : integer;
  LCCount : integer;
  LSendMessage : Boolean;
  LFlag,
  LCharge,
  LNextCharge,
  LTitle,
  LContent,
  LHead : AnsiString;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from ZHITEMS_APPROVEP');
    SQL.Add('where CODEID = :param1');
    parambyname('param1').AsString := FCODEID;
    Open;

    if not(RecordCount = 0) then
    begin
      LPending := Fieldbyname('Pending').AsInteger;
      LPending := LPending + 1;
      LSendMessage := True;
    end
    else
      Exit;
  end;

  if LSendMessage = True then
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from ZHITEMS_APPROVER');
      SQL.Add('where CODEID = :param1');
      parambyname('param1').AsString := FCODEID;
      Open;

      if not(RecordCount = 0) then
      begin
        LCCount := FieldByName('ACount').AsInteger;
        LNextCharge := Fields[LPending+2].AsString;
      end
      else
        Exit;
    end;
  end;

  LCharge := Statusbar1.Panels[4].Text;
  if (LCharge = '') or (LNextCharge='') then Exit;
  if not(LCharge = LNextCharge) then
  begin

    LHead := 'HiTEMS-문제점보고서';
    LTITLE := '문제점보고서 결재 문서 등록';
    LCONTENT := ItemName.Text+'에 관한 문제점 보고서가 등록되었습니다. 검토 후 결재 부탁 드립니다.';

    for li := 0 to 1 do
    begin
      case li of
        0 : LFlag := 'A';
        1 : LFlag := 'B';
      end;
      Send_Message_Main_CODE(LFlag,LCharge,LNextCharge,LHead,LTitle,LContent);

    end;
  end;
end;

procedure TTrouble_Frm.Send_Message_to_CarbonCharge;
var
  Lc,Li : integer;
  LPending : integer;
  LCCount : integer;
  LSendMessage : Boolean;
  LFlag,
  LSend,
  Lreceive,
  LTitle,
  LContent,
  LHead : AnsiString;
  LStrList : TStringList;
begin
  if not(CCListS.GetTextLen <= 0) then
  begin
    try
      LStrList := TStringList.Create;
      LStrList.Delimiter := ';';
      LStrList.DelimitedText := CCListS.Text;

      LSend := InEMPNO.Items.Strings[0];

      LHead := 'HiTEMS-문제점보고서';
      LTITLE := '문제 예상 보고서가 등록되었습니다. 업무 참조 하시길 바랍니다..';
      LCONTENT := ItemName.Text+'에 관한 문제 예상 보고서가 등록되었습니다. 업무 참조 하시길 바랍니다.';

      for lc := 0 to LStrList.Count-1 do
      begin
        Lreceive := LStrList.Strings[lc];
        if (LSend = '') or (LReceive='') then Continue;
        if not(LSend = Lreceive) then
        begin
          for li := 0 to 1 do
          begin
            case li of
              0 : LFlag := 'A';
              1 : LFlag := 'B';
            end;
            Send_Message_Main_CODE(LFlag,LSend,LReceive,LHead,LTitle,LContent);
          end;
        end;
      end;
    finally
      LStrList.Free;
    end;
  end;
end;

procedure TTrouble_Frm.Send_Message_to_Charge_Report_Complete;
var
  Li : integer;
  LPending : integer;
  LCCount : integer;
  LSendMessage : Boolean;
  LFlag,
  LSend,
  LReceive,
  LTitle,
  LContent,
  LHead : AnsiString;
begin
  if EMPNo.Items.Count > 0 then
    LSend := EMPNO.Items.Strings[0];

  if InEMPNO.Items.Count > 0 then
    LReceive := InEMPNO.Items.Strings[0];

  if (LSend = '') or (LReceive='') then Exit;
  if not(LSend = LReceive) then
  begin
    LHead := 'HiTEMS-문제점보고서';
    LTITLE := '등록하신 문제점 보고서 조치가 모두 완료 되었습니다.';
    LCONTENT := ItemName.Text+'에 관한 문제점 보고서 조치가 모두 완료되었습니다. 확인 부탁 드립니다.';

    for li := 0 to 1 do
    begin
      case li of
        0 : LFlag := 'A';
        1 : LFlag := 'B';
      end;

      Send_Message_Main_CODE(LFlag,LSend,LReceive,LHead,LTitle,LContent);

    end;
  end;
end;

procedure TTrouble_Frm.Send_Message_to_Design_Charge;
var
  Li : integer;
  LPending : integer;
  LCCount : integer;
  LSendMessage : Boolean;
  LFlag,
  LSend,
  LReceive,
  LTitle,
  LContent,
  LHead : AnsiString;
begin
  if InEMPNO.Items.Count > 0 then
    LSend := InEMPNO.Items.Strings[0];

  if EMPNo.Items.Count > 0 then
    LReceive := EMPNO.Items.Strings[0];


  if (LSend = '') or (LReceive='') then Exit;
  if not(LSend = LReceive) then
  begin
    LHead := 'HiTEMS-문제점보고서';
    LTITLE := '문제점보고서가 등록되었습니다. 조치사항 입력 부탁 드립니다.';
    LCONTENT := ItemName.Text+'에 관한 문제점 보고서가 등록되었습니다. 검토 후 조치사항 입력 부탁 드립니다..';

    LSend := InEMPNO.Items.Strings[0];
    LReceive := EMPNo.Items.Strings[0];

    for li := 0 to 1 do
    begin
      case li of
        0 : LFlag := 'A';
        1 : LFlag := 'B';
      end;
      Send_Message_Main_CODE(LFlag,LSend,LReceive,LHead,LTitle,LContent);

    end;
  end;
end;


procedure TTrouble_Frm.Send_Message_to_Inempno(Approved, nApproved:String);
var
  Li : integer;
  LPending : integer;
  LCCount : integer;
  LSendMessage : Boolean;
  LFlag,
  LSend,
  LReceive,
  LTitle,
  LContent,
  LHead,
  LApprove,
  LnApprove : AnsiString;
begin
  if (InEMPNO.Items.Count > 0) and not(Approved='') then
  begin
    LSend := Approved;
    LReceive := InEmpNo.Items.Strings[0];

    LApprove := Select_User_Info(Approved);
    LnApprove := Select_User_Info(nApproved);

    if (LSend = '') or (LReceive='') then Exit;
    if not(LSend = LReceive) then
    begin
      LHead := 'HiTEMS-문제점보고서';
      if not(LnApprove = '') then
      begin
        LTITLE := '++문제점보고서 승인 메세지++ / 현재 승인자: '+LApprove+'/ 다음 승인자:'+LnApprove;
        LCONTENT := '++문제점보고서 승인 메세지++ / 현재 승인자: '+LApprove+'/ 다음 승인자:'+LnApprove;
      end
      else
      begin
        LTITLE := '++문제점보고서 승인 메세지++ / 현재 승인자: '+LApprove+'/ 보고서 결재 완료!';
        LCONTENT := '++문제점보고서 승인 메세지++ / 현재 승인자: '+LApprove+'/ 보고서 결재 완료!';
      end;

      for li := 0 to 1 do
      begin
        case li of
          0 : LFlag := 'A';
          1 : LFlag := 'B';
        end;
        Send_Message_Main_CODE(LFlag,LSend,LReceive,LHead,LTitle,LContent);

      end;
    end;
  end;
end;

procedure TTrouble_Frm.Show_Trouble_Image(FCODEID, FMCODE:String;FImgCnt:integer);
var
  LMS : TMemoryStream;
  LEXT : String;
  li : Integer;
  LStr, eLStr : String;
begin
  if FileGrid0.RowCount = 0 then Exit;
  LStr := FCODEID;
  LStr := LeftStr(LStr,2);

  eLStr := FMCODE;
  eLStr := LeftStr(eLStr,2);
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' Select * from TROUBLE_ATTFILES');

    if ((LStr = 'TS') or (LStr = 'TX') or (LStr = 'TT') or (LStr = 'TM')) or
       ((eLStr = 'TS') or (eLStr = 'TX') or (eLStr = 'TT') or (eLStr = 'TM'))then
    begin
      SQL.Add(' where CODEID In ('''+FCODEID+''','''+FMCODE+''') and AttFlag = ''I'' and LCFilename = :param4');
      ParamByName('Param4').AsString := FileGrid0.Cells[2,FImgCnt];
    end
    else
    begin
      SQL.Add(' where '''+FCODEID+''' and AttFlag = ''I''');
    end;

    Open;

    if not(RecordCount = 0) then
    begin
      if FieldByName('FILES').IsBlob then
      begin
        LMS := TMemoryStream.Create;
        try
          (FieldByName('FILES') as TBlobField).SaveToStream(LMS);
          GDIPPictureContainer1.Items.add;
          GDIPPictureContainer1.Items.Items[GDIPPictureContainer1.Items.Count-1].Name := FieldByName('LCFILENAME').AsString;
          GDIPPictureContainer1.Items.Items[GDIPPictureContainer1.Items.Count-1].Picture.LoadFromStream(LMS);
        finally
          FreeAndNil(LMS);
        end;
      end;
      if GDIPPictureContainer1.Items.Count > 0 then
      begin
        Image1.Picture.Assign(GDIPPictureContainer1.Items.Items[0].Picture);
        fileGrid0.SelectedRow := 0;
      end;
    end;
  end;//with
end;

procedure TTrouble_Frm.Start_Detail_Write_for_Mobile_Content;
var
  LClass, lemp : String;
begin
  Initialize_of_Trouble_Frm;

  lemp := Statusbar1.Panels[4].Text;
  INEMPNO.Items.Add(lemp);
  INEMPNO.Text := Get_UserName(lemp);
  INEMPNO.Hint := lemp;

  if INEMPNO.Items.Count >0 then
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      sQL.Add('select A.Name_Kor, A.GRADE, DESCR from HITEMS.HITEMS_USER A, HITEMS.HITEMS_USER_GRADE B ');
      SQL.Add('where UserID = :param1 ' +
              'AND A.GRADE = B.GRADE ');

      parambyname('param1').AsString := Statusbar1.Panels[4].Text;
      Open;
//      INEMPNO.Text := fieldbyname('Name_Kor').AsString;
      LClass := Fieldbyname('DESCR').AsString;
    end;

    with AppGrid do
    begin
      Approval_Grid_Setting(1);
      Cells[1,0] := LClass+'/'+INEMPNO.Text;
      Cells[1,2] := FormatDateTime('YY.MM.DD',Now);
    end;

    // 모바일 항목 위치 시키기
    MCODEID.Text      := PMTRContent.MCODEID;
    title.Text        := PMTRContent.MSTATUS;
    statusTitle.Text  := PMTRContent.MSTATUS;
    ItemName.Text     := PMTRContent.MITEMNAME;
    reasonTitle.Text  := PMTRContent.MREASON;

    EngType.Text      := PMTRContent.MEngType;
    grpType.ItemIndex := PMTRContent.MRPTYPE;
//    SDate.DateTime    := PMTRContent.MInDate;

    Get_Attachment_From_Trouble_attfiles(CODEID.Text, MCODEID.Text);
  end;
end;

procedure TTrouble_Frm.STATUSChange(Sender: TObject);
begin
  Check_for_Docu_Step;
end;

procedure TTrouble_Frm.STATUSClick(Sender: TObject);
begin
  if not(StatusTitle.GetTextLen > 1) then
  begin
    ShowMessage('요약을 먼저 기입하여 주십시오...');
    StatusTitle.SetFocus;
  end;
end;

procedure TTrouble_Frm.STEPSTATChange(Sender: TObject);
begin
  case StepStat.ItemIndex of
    0 : StepText.Text := 'Step1 작성중';
    1 : StepText.Text := 'Step2 작성중';
    2 : StepText.Text := 'Step3 작성중';
  end;
end;

procedure TTrouble_Frm.summitbtnClick(Sender: TObject);
var
  LPending : integer;
  LApproved : Boolean;
  LACount : integer;
begin
  If MessageDlg('결재 상신 하시겠습니까?'+#13+'결재 상신후에는 결재선 수정 또는 보고서 수정'+#13+
  '이 불가하오니 유의하시기 바랍니다.', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then

  try
    if Check_for_Mandatory_Items = False then Exit;

    TRY
      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Update ZHITEMS_APPROVEP Set');
        SQL.Add('Pending = :Pending, APPROVAL1 = :APPROVAL1, Status = :Status where CODEID = :param1');

        Parambyname('param1').AsString     := CODEID.Text;
        Parambyname('Pending').AsInteger   := 1; //1 = 담당자 결재상신한 상태
        Parambyname('APPROVAL1').AsInteger := 1; //담당자
        Parambyname('Status').AsInteger    := 1; // 0: 작성중, 1:결재진행, 2:반려
        ExecSQL;
      end;//with

      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Update ZHITEMS_APPROVED Set');
        SQL.Add('Pending = :Pending, APPROVAL1 = :APPROVAL1 where CODEID = :param1');

        Parambyname('param1').AsString    := CODEID.Text;
        Parambyname('Pending').AsInteger  := 1; //1 = 담당자 결재상신한 상태
        Parambyname('APPROVAL1').AsDateTime   := Now;
        ExecSQL;
      end;//with
      Send_Message_to_After_Approved(CODEID.Text);//다음 결재자에게 메세지 보내기
      Approval_Info_Apply_To_Table(CODEID.Text);
      Registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,3);
      if (Statusbar1.Panels[1].Text = 'S') then
        Approved_of_Representatives //S 권한일 경우 바로 등록
      else
        ShowMessage('보고서 결재상신이 완료 되었습니다.');

    except
      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Update ZHITEMS_APPROVEP Set');
        SQL.Add('Pending = :Pending, APPROVAL1 = :APPROVAL1, Status = :Status where CODEID = :param1');

        Parambyname('param1').AsString     := CODEID.Text;
        Parambyname('Pending').AsInteger   := 0; //1 = 담당자 결재상신한 상태
        Parambyname('APPROVAL1').AsInteger := 0; //담당자
        Parambyname('Status').AsInteger    := 0; // 0: 작성중, 1:결재진행, 2:반려
        ExecSQL;
      end;//with

      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Update ZHITEMS_APPROVED Set');
        SQL.Add('Pending = :Pending, APPROVAL1 = :APPROVAL1 where CODEID = :param1');

        Parambyname('param1').AsString    := CODEID.Text;
        Parambyname('Pending').AsInteger  := 0; //1 = 담당자 결재상신한 상태
        Parambyname('APPROVAL1').AsDateTime   := Now;
        ExecSQL;
      end;//with
    END;
  finally
    FTroubleFrmChanged := True;
    Btn_arrangement_after_check_for_DocStatus;
  end;
end;

function TTrouble_Frm.summit_permissions_for_report: Boolean;
var
  LINEMPNO : String; //문서 작성담당자
  LSTATUS : integer; //문서상태 0:작성중 1:결재진행 2:반려 3: 완료
  LUser : String;
begin
  Result := False;
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * From ZHITEMS_APPROVEP');
    SQL.Add('where CODEID = :param1');
    parambyname('param1').AsString := CODEID.Text;
    Open;

    if not(RecordCount = 0) then
    begin
      LSTATUS := Fieldbyname('STATUS').AsInteger;
      if not(LSTATUS = 0) and not(LSTATUS = 2) then
      begin
        Result := False;
        Exit;
      end
      else
      begin
        if not(INEMPNO.Items.Count = 0) then
          LINEMPNO := INEMPNO.Items.Strings[0]
        else
        begin
          Result := False;
          Exit;
        end;

        LUser := Statusbar1.Panels[4].Text;

        if LUser = LINEMPNO then
          Result := True;

      end;
    end;
  end;
end;

procedure TTrouble_Frm.TBACS_FTP_SERVER_Connection;
begin
  if DM1.idFTP2.Connected then
  begin
    DM1.idFTP2.Disconnect;
  end
  else
  begin
    with DM1 do
    begin
      idFTP2.host := FTP_SERVER_IP;
      idFTP2.UserName := 'anonymous';
      idFTP2.Port := 21;
      idFTP2.Connect;
    end;
  end;
end;


procedure TTrouble_Frm.TempSaveClick(Sender: TObject);
begin
  try
    Trouble_Save_to_Trouble_Datatemp;
  finally
    if LeftStr(CODEID.Text,2) = 'TT' then
      TempUpdate.Visible := True;

    FTroubleFrmChanged := True;
  end;
end;

procedure TTrouble_Frm.TempUpdateClick(Sender: TObject);
var
  LStatus : integer;
begin
  try
    try
      if LeftStr(CODEID.Text,2) = 'TT' then
      begin
        if TroubleDataTemp_Update_To_DB = True then
        begin
          Check_for_FileGrid_and_Upload_2_TBACS;
          LStatus := Check_for_Doc_Status;
          if (LStatus = 0) or (LStatus = 2) then
            Save_of_Approval;

          CCList_2_DataBase(CODEID.Text);
          Registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,1);
          Btn_arrangement_after_check_for_DocStatus;
          ShowMessage('수정완료!');
        end;
      end
      else
      begin
        if (Statusbar1.Panels[1].Text = 'M') or (FUserPriv = 3) then
        begin
          if TroubleData_Update_To_DB = True then
          begin
            Check_for_FileGrid_and_Upload_2_TBACS;
            LStatus := Check_for_Doc_Status;
            if (LStatus = 0) or (LStatus = 2) then
              Save_of_Approval;

            CCList_2_DataBase(CODEID.Text);
            Registor_of_New_Report_Log(CODEID.Text,Statusbar1.Panels[4].Text,1);
            Btn_arrangement_after_check_for_DocStatus;
            ShowMessage('수정완료!');
          end;
        end;
      end;
    except
      ShowMessage('수정실패!');
    end;
  finally
    FDelCnt := 0;
    FillChar(FDelInfo,SizeOf(FDelInfo), 0); // 삭제목록 초기화
    FTroubleFrmChanged := True;
  end;
end;

procedure TTrouble_Frm.Timer1Timer(Sender: TObject);
begin
  if Timer1.Enabled then
  begin
    if Statusbar1.Panels[6].Text = '' then
      Statusbar1.Panels[6].Text := '"※" 표시는 필수 입력 항목입니다.'
    else
      Statusbar1.Panels[6].Text := ''
  end;
end;

procedure TTrouble_Frm.Timer2Timer(Sender: TObject);
begin
  Statusbar1.Panels[5].Text := FormatDateTime('YYYY-MM-DD HH:mm:ss',Now);
end;

function TTrouble_Frm.TroubleDataTemp_Update_To_DB: Boolean;
var
  li : integer;
  Lstr : String;
begin
  Result := False;
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update TROUBLE_DataTemp Set');
    SQL.Add(' RPTYPE = :RPTYPE, CLAIMNO = :CLAIMNO, TITLE = :TITLE, ENGNAME = :ENGNAME,'); //1 ~ 5
    SQL.Add(' PROJNO = :PROJNO, ENGTYPE = :ENGTYPE, MEASPM = :MEASPM, APPROVAL = :APPROVAL, INDATE = :INDATE,'); //6 ~ 10
    SQL.Add(' CHECKED = :CHECKED, PREPARED = :PREPARED, PROJNAME = :PROJNAME, SHIPNO = :SHIPNO, DIVLIC = :DIVLIC,');//11 ~ 15
    SQL.Add(' OWNER = :OWNER, SITE = :SITE, RPM = :RPM, ENGNUM = :ENGNUM, ACTIONCODE = :ACTIONCODE,');//16 ~ 20
    SQL.Add(' WORKTIME = :WORKTIME, REGTYPE = :REGTYPE, FORUSE = :FORUSE, EMPNO = :EMPNO, INEMPNO = :INEMPNO,');//21 ~ 25
    SQL.Add(' HIEMPNO = :HIEMPNO, HIINEMPNO = :HIINEMPNO, SENDDATE = :SENDDATE, RCVDATE = :RCVDATE, TROUBLETYPE1 = :TROUBLETYPE1,');//26~30
    SQL.Add(' TROUBLETYPE2 = :TROUBLETYPE2, TROUBLETYPE3 = :TROUBLETYPE3, TROUBLETYPE4 = :TROUBLETYPE4, TROUBLETYPE5 = :TROUBLETYPE5, TRTYPE1 = :TRTYPE1,');//31~35
    SQL.Add(' TRTYPE2 = :TRTYPE2, TRTYPE3 = :TRTYPE3, TRTYPE4 = :TRTYPE4, ITEMNAME = :ITEMNAME, SDATE = :SDATE,');//36~40
    SQL.Add(' ADATE = :ADATE, PROCESS = :PROCESS, PDATE = :PDATE, STATUSTITLE = :STATUSTITLE, STATUS = :STATUS,');//41 ~ 45
    SQL.Add(' REASONTITLE = :REASONTITLE, REASON = :REASON, PLANTITLE = :PLANTITLE, PLAN = :PLAN, REASON1TITLE = :REASON1TITLE,');
    SQL.Add(' REASON1 = :REASON1, RESULTTITLE = :RESULTTITLE, RESULT = :RESULT, APPLYEMPNO = :APPLYEMPNO, EDATE = :EDATE,');
    SQL.Add(' DESIGNAPP = :DESIGNAPP, NDEPT1 = :NDEPT1, NDEPT2 = :NDEPT2, NDEPT3 = :NDEPT3,');
    SQL.Add(' COMPLE1 = :COMPLE1, COMPLE2 = :COMPLE2, COMPLE3 = :COMPLE3, CDATE1 = :CDATE1, CDATE2 = :CDATE2,');
    SQL.Add(' CDATE3 = :CDATE3, RESULTC1 = :RESULTC1, RESULTC2 = :RESULTC2, RESULTC3 = :RESULTC3, RESULTC4 = :RESULTC4,');
    SQL.Add(' RESULTC5 = :RESULTC5, RESULTC6 = :RESULTC6, REMARK1 = :REMARK1, REMARK2 = :REMARK2, REMARK3 = :REMARK3,');
    SQL.Add(' REMARK4 = :REMARK4, REMARK5 = :REMARK5, REMARK6 = :REMARK6, REFTYPE = :REFTYPE, STEPSTATUS = :STEPSTATUS,');
    SQL.Add(' DEPT = :DEPT, DTEAM = :DTEAM, FResult = :FResult, DOAPPLY = :DOAPPLY,APPROVED1 = :APPROVED1, APPROVED2 = :APPROVED2,');
    SQL.Add(' APPROVED3 = :APPROVED3, APPROVED4 = :APPROVED4, APPROVED5 = :APPROVED5');
    SQL.Add(' where CodeID = :Param1');

    paramByName('Param1').AsString          := CodeID.Text;

    paramByName('RPTYPE').AsString          := IntToStr(GrpType.ItemIndex); // 0 : 품질, 1:설비문제, 2:조립문제,3:시운전문제,4:문제예상

    paramByName('CLAIMNO').AsString         := ClaimNo.Text;
    paramByName('TITLE').AsString           := TITLE.Text;
    paramByName('ENGNAME').AsString         := ENGNAME.Text;
    paramByName('PROJNO').AsString          := PROJNO.Text;

    paramByName('ENGTYPE').AsString         := ENGTYPE.Text;
    paramByName('MEASPM').AsString          := '';
    paramByName('INDATE').AsDateTime            := Now;
    paramByName('APPROVAL').AsString        := '';

    paramByName('CHECKED').AsString         := '';
    paramByName('PREPARED').AsString        := '';
    paramByName('PROJNAME').AsString        := PROJNAME.Text;
    paramByName('SHIPNO').AsString          := SHIPNO.Text;
    paramByName('DIVLIC').AsString          := DIVLIC.Text;
    paramByName('OWNER').AsString           := TOWNER.Text;
    paramByName('SITE').AsString            := SITE.Text;
    paramByName('RPM').AsString             := RPM.Text;
    paramByName('ENGNUM').AsString          := ENGNUM.Text;
    paramByName('ACTIONCODE').AsString      := ACTIONCODE.Text;

    paramByName('WORKTIME').AsString        := WORKTIME.Text;

    if RegType.ItemIndex > -1 then
      paramByName('REGTYPE').AsString       := IntToStr(RegType.ItemIndex)
    else
      paramByName('REGTYPE').AsString       := '0';

    paramByName('FORUSE').AsString          := FORUSE.Text;

    if not(EMPNO.Items.Count = 0) then
      paramByName('EMPNO').AsString         := EMPNO.Hint//.Items.Strings[0]
    else
      paramByName('EMPNO').AsString         := '';

    if not(INEMPNO.Items.Count = 0) then
      paramByName('INEMPNO').AsString       := INEMPNO.Hint//.Items.Strings[0]
    else
      paramByName('INEMPNO').AsString       := '';

    if not(HIEMPNO.Items.Count = 0) then
      paramByName('HIEMPNO').AsString       := HIEMPNO.Hint//.Items.Strings[0]
    else
      paramByName('HIEMPNO').AsString       := '';

    if not(HIINEMPNO.Items.Count = 0) then
      paramByName('HIINEMPNO').AsString     := HIINEMPNO.Hint//.Items.Strings[0]
    else
      paramByName('HIINEMPNO').AsString         := '';


    if not (sendDate.Text = '') then
      paramByName('SENDDATE').AsDateTime          := StrToDateTime(SendDate.Text);
    if not (RCVDATE.Text = '') then
      paramByName('RCVDATE').AsDateTime          := StrToDateTime(RCVDATE.Text);

    with TroubleList do
    begin
      for li := 0 to RowCount-1 do
      begin
        LStr := 'TROUBLETYPE'+ IntToStr(li+1);
        paramByName(LStr).AsString := Cells[2,li];
      end;//for
    end;//with


    if TrKind.Checked[0] = True then
      paramByName('TRTYPE1').AsString       := 'T'
    else
      paramByName('TRTYPE1').AsString       := 'F';

    if TrKind.Checked[1] = True then
      paramByName('TRTYPE2').AsString       := 'T'
    else
      paramByName('TRTYPE2').AsString       := 'F';

    if TrKind.Checked[2] = True then
      paramByName('TRTYPE3').AsString       := 'T'
    else
      paramByName('TRTYPE3').AsString       := 'F';

    if TrKind.Checked[3] = True then
      paramByName('TRTYPE4').AsString       := 'T'
    else
      paramByName('TRTYPE4').AsString       := 'F';

    paramByName('ITEMNAME').AsString        := ITEMNAME.Text;
    paramByName('SDATE').AsDateTime         := SDATE.DateTime;

    if not (ADATE.Text = '') then
      paramByName('ADATE').AsDateTime           := StrToDateTime(ADATE.Text);
    paramByName('PROCESS').AsString         := PROCESS.Text;
    if not (PDATE.Text = '') then
      paramByName('PDATE').AsDateTime           := StrToDateTime(PDATE.Text);
    paramByName('STATUSTITLE').AsString     := STATUSTITLE.Text;
    paramByName('STATUS').AsString          := STATUS.Text;
    paramByName('REASONTITLE').AsString     := REASONTITLE.Text;
    paramByName('REASON').AsString          := REASON.Text;
    paramByName('PLANTITLE').AsString       := PLANTITLE.Text;
    paramByName('PLAN').AsString            := PLAN.Text;
    paramByName('REASON1TITLE').AsString    := REASON1TITLE.Text;

    paramByName('REASON1').AsString         := REASON1.Text;
    paramByName('RESULTTITLE').AsString     := RESULTTITLE.Text;
    paramByName('RESULT').AsString          := RESULTa.Text;
//      paramByName('APPLYEMPNO').AsString      := APPLYEMPNO.Text;
//      if not (EDATE.Text = '') then
//        paramByName('EDATE').AsDateTime          := StrToDateTime(EDATE.Text);

    paramByName('DESIGNAPP').AsInteger      := DesignApp.ItemIndex;

    with ACGrid1 do
    begin
      paramByName('NDEPT1').AsString          := Cells[0,1];
      paramByName('NDEPT2').AsString          := Cells[0,2];
      paramByName('NDEPT3').AsString          := Cells[0,3];

      paramByName('COMPLE1').AsString         := Cells[1,1];
      paramByName('COMPLE2').AsString         := Cells[1,2];
      paramByName('COMPLE3').AsString         := Cells[1,3];

      paramByName('CDATE1').AsString          := Cells[2,1];
      paramByName('CDATE2').AsString          := Cells[2,2];
      paramByName('CDATE3').AsString          := Cells[2,3];
    end;

    paramByName('RESULTC1').AsString          := ResultC1.Text;
    paramByName('RESULTC2').AsString          := ResultC2.Text;
    paramByName('RESULTC3').AsString          := ResultC3.Text;
    paramByName('RESULTC4').AsString          := ResultC4.Text;
    paramByName('RESULTC5').AsString          := ResultC5.Text;
    paramByName('RESULTC6').AsString          := ResultC6.Text;

    paramByName('REMARK1').AsString           := '';
    paramByName('REMARK2').AsString           := '';
    paramByName('REMARK3').AsString           := '';
    paramByName('REMARK4').AsString           := '';
    paramByName('REMARK5').AsString           := '';
    paramByName('REMARK6').AsString           := '';
    {
    with ACGrid2 do
    begin
      paramByName('RESULTC1').AsString        := Cells[2,1];
      paramByName('RESULTC2').AsString        := Cells[2,2];
      paramByName('RESULTC3').AsString        := Cells[2,3];
      paramByName('RESULTC4').AsString        := Cells[2,4];
      paramByName('RESULTC5').AsString        := Cells[2,5];
      paramByName('RESULTC6').AsString        := Cells[2,6];

      paramByName('REMARK1').AsString         := Cells[3,1];
      paramByName('REMARK2').AsString         := Cells[3,2];
      paramByName('REMARK3').AsString         := Cells[3,3];
      paramByName('REMARK4').AsString         := Cells[3,4];
      paramByName('REMARK5').AsString         := Cells[3,5];
      paramByName('REMARK6').AsString         := Cells[3,6];
    end;//with ACGrid2
    }
    if REFTYPE.ItemIndex > -1 then
      paramByName('REFTYPE').AsString   := IntToStr(RefType.ItemIndex)
    else
      paramByName('REFTYPE').AsString   := '';


    Case StepStat.ItemIndex of
      0 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[0];
      1 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[1];
      2 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[2];
      3 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[3];
    end;

    paramByName('DEPT').AsString              := Statusbar1.Panels[2].Text;
    paramByName('DTeam').AsString             := Statusbar1.Panels[3].Text;

    paramByName('FResult').AsInteger          := 0;//담당자가 조치사항 등록안한 상태
//      paramByName('DOAPPLY').AsString           := '';//TSMS 유사공사 조치사항 필요없는 항목 이전버젼 때문에 남겨둠
    for li := 1 to 5 do
    begin
      if not(li > AppGrid.ColCount-1) then
        LStr := AppGrid.Cells[li,0]
      else
        LStr := '';

      case li of
        1 : paramByName('APPROVED1').AsString  := LStr;
        2 : paramByName('APPROVED2').AsString  := LStr;
        3 : paramByName('APPROVED3').AsString  := LStr;
        4 : paramByName('APPROVED4').AsString  := LStr;
        5 : paramByName('APPROVED5').AsString  := LStr;
      end;
    end;

    try
      ExecSQL;
      Result := True;
    except
      on e:Exception do
        ShowMessage(e.Message);
    end;
  end;
end;


procedure TTrouble_Frm.TroubleData_Get_From_DB(FCODEID: String);
var
  LCase : integer; //완성된 보고서 인지,, 저장된 보고서 인지 판단
  LUserID : String;
  li,lr, lc : integer;
  LStr : String;
  LtPCode : array[1..5] of String; //trouble type의 PCode
  LtCode : array[1..5] of String; //trouble type의 Code
  LtData : array[1..5] of String; //trouble type의 Data
  LrCode : array[1..5] of String; //trouble Root
  LrData : array[1..5] of String; //trouble Root
  ldate : TDateTime;

begin
  LCase := 0;

  if (LeftStr(FCODEID,2) = 'TS') or (LeftStr(FCODEID,2) = 'TX') then
    LCase := 0;

  if LeftStr(FCODEID,2) = 'TT' then
    LCase := 1;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    case LCase of
      0 : LStr := 'Select * From Trouble_Data';
      1 : LStr := 'Select * From Trouble_DataTemp';
    end;
    SQL.Add(LStr);
    SQL.Add('where CODEID = :param1');
    parambyname('param1').AsString := FCODEID;
    Open;

    CodeID.Text          := FieldByName('CODEID').AsString;
    MCodeId.Text         := FieldByName('MOBILECODE').AsString;


    GRpType.ItemIndex    := StrToInt(FieldByName('RPType').AsString);
    grptypeClick(self);

    ClaimNo.Text         := FieldByName('ClaimNo').AsString;
    Title.Text           := FieldByName('Title').AsString;
    EngName.Text         := FieldByName('EngName').AsString;
    ProjNo.Text          := FieldByName('ProjNo').AsString;
    EngType.Text         := FieldByName('EngType').AsString;
  //      MeasPM.Text    := FieldByName('MeasPM').AsString;
  //      InDate.Text    := FieldByName('InDate').AsString;
  //      Approval.Text  := FieldByName('APProval').AsString;
  //      Checked.Text   := FieldByName('').AsString;
//    PREPARED.Text        := ConfirmGrid.Cells[1,1];
    ProjName.Text        := FieldByName('ProjName').AsString;
    ShipNo.Text          := FieldByName('ShipNo').AsString;
    Divlic.Text          := FieldByName('DivLic').AsString;
    TOwner.Text          := FieldByName('Owner').AsString;
    Site.Text            := FieldByName('Site').AsString;
    RPM.Text             := FieldByName('RPM').AsString;
    EngNum.Text          := FieldByName('EngNum').AsString;
    ActionCode.Text      := FieldByName('ActionCode').AsString;
    WorkTime.Text        := FieldByName('WorkTime').AsString;


    if not(FieldByName('RegType').AsString = '') then
      REGType.ItemIndex    := StrToInt(FieldByName('RegType').AsString);

    Foruse.Text          := FieldByName('Foruse').AsString;

    if not(FieldByName('EmpNo').AsString = '') then
    begin
      LUserID := FieldByName('EmpNo').AsString;

      with DM1.TQuery2 do
      begin
        Close;
        SQL.Clear;
        sQL.Add('select * from HITEMS.HITEMS_USER where UserID = :param1 or Name_Kor = :param2');
        parambyname('param1').AsString := LUserID;
        parambyname('param2').AsString := LUserID;
        Open;
        EMPNO.Items.Add(fieldbyname('UserID').AsString);
        EMPNo.Text := fieldbyname('Name_Kor').AsString;
      end;
    end;

    if not(FieldByName('InempNo').AsString = '') then
    begin
      LUserID := FieldByName('InempNo').AsString;
      with DM1.TQuery2 do
      begin
        Close;
        SQL.Clear;
        sQL.Add('select * from HITEMS.HITEMS_USER where UserID = :param1 or Name_Kor = :param2');
        parambyname('param1').AsString := LUserID;
        parambyname('param2').AsString := LUserID;
        Open;
        InempNo.Items.Add(fieldbyname('UserID').AsString);
        InempNo.Text := fieldbyname('Name_Kor').AsString;
        InempNo.Hint := fieldbyname('UserID').AsString;
      end;
    end;

    if not(FieldByName('HiempNo').AsString = '') then
    begin
      LUserID := FieldByName('HiempNo').AsString;
      with DM1.TQuery2 do
      begin
        Close;
        SQL.Clear;
        sQL.Add('select * from HITEMS.HITEMS_USER where UserID = :param1 or Name_Kor = :param2');
        parambyname('param1').AsString := LUserID;
        parambyname('param2').AsString := LUserID;
        Open;
        HiempNo.Items.Add(fieldbyname('UserID').AsString);
        HiempNo.Text := fieldbyname('Name_Kor').AsString;
        HiempNo.Hint := fieldbyname('UserID').AsString;
      end;
    end;

    if not(FieldByName('HiinempNo').AsString = '') then
    begin
      LUserID := FieldByName('HiinempNo').AsString;
      with DM1.TQuery2 do
      begin
        Close;
        SQL.Clear;
        sQL.Add('select * from HITEMS.HITEMS_USER where UserID = :param1 or Name_Kor = :param2');
        parambyname('param1').AsString := LUserID;
        parambyname('param2').AsString := LUserID;
        Open;
        HiinempNo.Items.Add(fieldbyname('UserID').AsString);
        HiinempNo.Text := fieldbyname('Name_Kor').AsString;
        HiinempNo.Hint := fieldbyname('UserID').AsString;
      end;
    end;

    if Fieldbyname('SendDate').IsNull then
      SendDate.Text        := FieldByName('SendDate').AsString
    else
      SendDate.Text           := '';

    if Fieldbyname('RcvDate').IsNull then
      RcvDate.Text         := FieldByName('RcvDate').AsString
    else
      RcvDate.Text         := '';      

//      EDMS_DataBase_Connect; //EDMS 서버 접속~
    with DM1.EQuery1 do
    begin
      for li := 1 to 5 do
      begin
        Close;
        SQL.Clear;
        SQL.Add(' Select * from TS_TroubleType');
        SQL.Add(' where Code = :param1');
        ParamByName('Param1').AsString := DM1.TQuery1.Fields[28+li].AsString;
        Open;

        LtPCode[li] := FieldByName('PCode').AsString;
        LtCode[li] := FieldByName('Code').AsString;
        LtData[li] := FieldByName('Data').AsString;
      end;//for
    end;//with

    with DM1.EQuery1 do
    begin
      for li := 1 to 5 do
      begin
        Close;
        SQL.Clear;
        SQL.Add(' Select * from TS_TroubleRoot');
        SQL.Add(' where Code = :param1');
        ParamByName('Param1').AsString := LtPCode[li];
        Open;

        LrCode[li] := FieldByName('Code').AsString;
        LrData[li] := FieldByName('Data').AsString;
      end;//for
    end;//with

    TroubleList.ClearRows;
    for li := 1 to 5 do
    begin
      if Not(LtData[li] = '') then
      begin
        with TroubleList do
        begin
          AddRow(1);
          Cells[1,li-1] := LrData[li]+'/'+LtData[li];
          Cells[2,li-1] := LtCode[li];
        end;//with
      end;//if
    end;//for

    for li := 1 to 4 do
    begin
      LStr := Fields[33+li].AsString;
      if LStr = 'T' then
        TrKind.Checked[li-1] := True
      else
        TrKind.Checked[li-1] := False;
    end;//for

    ItemName.Text     := FieldByName('ItemName').AsString;

    lDate := FieldByName('SDate').AsDateTime;
    SDate.DateTime    := lDate;

    if Fieldbyname('ADATE').IsNull then
      ADate.Text        := FieldByName('ADate').AsString
    else
      ADate.Text        := FormatDateTime('YYYY-MM-DD', FieldByName('INDATE').AsDateTime);

    Process.Text      := FieldByName('Process').AsString;
    PDate.Text        := FieldByName('PDate').AsString;
    StatusTitle.Text  := FieldByName('StatusTitle').AsString;
    STatus.Text       := FieldByName('Status').AsString;
    Reasontitle.Text  := FieldByName('ReasonTitle').AsString;
    reason.Text       := FieldByName('Reason').AsString;
    plantitle.Text    := FieldByName('PlanTitle').AsString;
    plan.Text         := FieldByName('Plan').AsString;
    reason1title.Text := FieldByName('Reason1Title').AsString;
    reason1.Text      := FieldByName('Reason1').AsString;
    resulttitle.Text  := FieldByName('ResultTitle').AsString;
    resulta.Text      := FieldByName('Result').AsString;
//      DApply.text := Cells[56,ARow];

    DesignApp.ItemIndex := FieldByName('DesignApp').AsInteger;

    if not(FieldByName('ApplyEmpNo').AsString = '') then
    begin
      LUserID := FieldByName('ApplyEmpNo').AsString;
      with DM1.TQuery2 do
      begin
        Close;
        SQL.Clear;
        sQL.Add('select * from HITEMS.HITEMS_USER where UserID = :param1 or Name_Kor = :param2');
        parambyname('param1').AsString := LUserID;
        parambyname('param2').AsString := LUserID;
        Open;
        ApplyEmpNo.Items.Add(fieldbyname('UserID').AsString);
        ApplyEmpNo.Text := fieldbyname('Name_Kor').AsString;
      end;
    end;

    EDate.Text           := FieldByName('EDate').AsString;
    LC := -1;

    for li := 0 to 2 do
    begin
      for lr := 1 to 3 do
      begin
        Inc(LC);
        with ACGrid1 do
          Cells[li,lr] := Fields[56+LC].AsString;

      end;
    end;

    ResultC1.Text := fieldbyname('RESULTC1').AsString;
    ResultC2.Text := fieldbyname('RESULTC2').AsString;
    ResultC3.Text := fieldbyname('RESULTC3').AsString;
    ResultC4.Text := fieldbyname('RESULTC4').AsString;
    ResultC5.Text := fieldbyname('RESULTC5').AsString;
    ResultC6.Text := fieldbyname('RESULTC6').AsString;

    {
    LC := -1;
    for li := 2 to 3 do
    begin
      for lr := 1 to 6 do
      begin
        Inc(LC);
        with ACGrid2 do
          Cells[li,lr] := Fields[65+lc].AsString;

      end;
    end;
    }

    LStr := FieldByName('RefType').AsString;
    if not (LStr = '') then
    begin
      Case StrToInt(LStr) of
        0 : REFType.ItemIndex := 0;
        1 : REFType.ItemIndex := 1;
        2 : REFType.ItemIndex := 2;
        3 : REFType.ItemIndex := 3;
      end;//case
      REFType.Text := REFType.Items[REFType.ItemIndex];
    end;//if

    LStr := FieldByName('StepStatus').AsString;
    if not (LStr = '') then
    begin
      if LStr = 'STEP1' then
      begin
        StepStat.ItemIndex := 0;
        StepText.Text := ' STEP1 작성중';
      end;
      if LStr = 'STEP2' then
      begin
        StepStat.ItemIndex := 1;
        StepText.Text := ' STEP2 작성중';
      end;
      if LStr = 'STEP3' then
      begin
        StepStat.ItemIndex := 2;
        StepText.Text := ' STEP3 작성중';
      end;

      if LStr = 'DONE' then
        StepText.Text := ' 완료문서';
    end;//if
{
    if Not(FmOwner.UserName = Cells[12,ARow]) Or (LStr = 'DONE') then
      CBtn.Visible := False
    else
      CBtn.Visible := True;
}

  lc := 0;
  for li := 1 to 5 do
    if not(Fields[82+li].AsString = '') then
      Inc(Lc)
    else
      Break;
    
    Approval_Grid_Setting(LC);
    for li := 1 to AppGrid.ColCount-1 do
      with AppGrid do
        Cells[li,0] := Fields[82+li].AsString; //83 = Approved1
  end;
end;

procedure TTrouble_Frm.TroubleData_Move_To_MainTable(FOCODE: String);
begin
  // Trouble_DataTemp -> Trouble_Data 메인 테이블로 레코드 이동
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into Trouble_Data Select * from Trouble_DataTemp where CODEID = :param1');
    parambyname('param1').AsString := FOCODE;
    ExecSQL;
  end;

  // 이동 후 Temp Table Record 삭제
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete Trouble_DataTemp where CODEID = :param1');
    parambyname('param1').AsString := FOCODE;
    ExecSQL;
  end;
end;

function TTrouble_Frm.TroubleData_Save_To_DB: Boolean;
var
  li : integer;
  Lstr : String;
  OraQuery : TOraQuery;
begin
  Result := False;

  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.TSession1;
  OraQuery.Options.TemporaryLobUpdate := True;

  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into TROUBLE_DATATEMP');

      SQL.Add('(CODEID, RPTYPE, CLAIMNO, TITLE, ENGNAME, PROJNO, ENGTYPE, MEASPM, INDATE, APPROVAL,');
      SQL.Add(' CHECKED, PREPARED, PROJNAME, SHIPNO, DIVLIC, OWNER, SITE, RPM, ENGNUM, ACTIONCODE,');
      SQL.Add(' WORKTIME, REGTYPE, FORUSE, EMPNO, INEMPNO, HIEMPNO, HIINEMPNO, SENDDATE, RCVDATE, TROUBLETYPE1,');
      SQL.Add(' TROUBLETYPE2, TROUBLETYPE3, TROUBLETYPE4, TROUBLETYPE5, TRTYPE1, TRTYPE2, TRTYPE3, TRTYPE4, ITEMNAME, SDATE,');
      SQL.Add(' ADATE, PROCESS, PDATE, STATUSTITLE, STATUS, REASONTITLE, REASON, PLANTITLE, PLAN, REASON1TITLE,');
      SQL.Add(' REASON1, RESULTTITLE, RESULT, APPLYEMPNO, EDATE, DESIGNAPP, NDEPT1, NDEPT2, NDEPT3,');
      SQL.Add(' COMPLE1, COMPLE2, COMPLE3, CDATE1, CDATE2, CDATE3, RESULTC1, RESULTC2, RESULTC3, RESULTC4,');
      SQL.Add(' RESULTC5, RESULTC6, REMARK1, REMARK2, REMARK3, REMARK4, REMARK5, REMARK6, REFTYPE, STEPSTATUS, DEPT, DTEAM, FResult, DOAPPLY,');
      SQL.Add(' APPROVED1, APPROVED2, APPROVED3, APPROVED4, APPROVED5, MOBILECODE)');

      SQL.Add('Values(:CODEID, :RPTYPE, :CLAIMNO, :TITLE, :ENGNAME, :PROJNO, :ENGTYPE, :MEASPM, :INDATE, :APPROVAL,');
      SQL.Add(' :CHECKED, :PREPARED, :PROJNAME, :SHIPNO, :DIVLIC, :OWNER, :SITE, :RPM, :ENGNUM, :ACTIONCODE,');
      SQL.Add(' :WORKTIME, :REGTYPE, :FORUSE, :EMPNO, :INEMPNO, :HIEMPNO, :HIINEMPNO, :SENDDATE, :RCVDATE, :TROUBLETYPE1,');
      SQL.Add(' :TROUBLETYPE2, :TROUBLETYPE3, :TROUBLETYPE4, :TROUBLETYPE5, :TRTYPE1, :TRTYPE2, :TRTYPE3, :TRTYPE4, :ITEMNAME, :SDATE,');
      SQL.Add(' :ADATE, :PROCESS, :PDATE, :STATUSTITLE, :STATUS, :REASONTITLE, :REASON, :PLANTITLE, :PLAN, :REASON1TITLE,');
      SQL.Add(' :REASON1, :RESULTTITLE, :RESULT, :APPLYEMPNO, :EDATE, :DESIGNAPP, :NDEPT1, :NDEPT2, :NDEPT3,');
      SQL.Add(' :COMPLE1, :COMPLE2, :COMPLE3, :CDATE1, :CDATE2, :CDATE3, :RESULTC1, :RESULTC2, :RESULTC3, :RESULTC4,');
      SQL.Add(' :RESULTC5, :RESULTC6, :REMARK1, :REMARK2, :REMARK3, :REMARK4, :REMARK5, :REMARK6, :REFTYPE, :STEPSTATUS, :DEPT, :DTEAM, :FResult,:DOAPPLY,');
      SQL.Add(' :APPROVED1, :APPROVED2, :APPROVED3, :APPROVED4, :APPROVED5, :MOBILECODE)');

      paramByName('CodeID').AsString          := CodeID.Text;

      paramByName('RPTYPE').AsString          := IntToStr(GrpType.ItemIndex); // 0 : 품질, 1:설비문제, 2:문제예상

      paramByName('CLAIMNO').AsString         := ClaimNo.Text;
      paramByName('TITLE').AsString           := TITLE.Text;
      paramByName('ENGNAME').AsString         := ENGNAME.Text;
      paramByName('PROJNO').AsString          := PROJNO.Text;

      paramByName('ENGTYPE').AsString         := ENGTYPE.Text;
      paramByName('MEASPM').AsString          := '';
      paramByName('INDATE').AsDateTime        := Now;
      paramByName('APPROVAL').AsString        := '';

      paramByName('CHECKED').AsString         := '';
      paramByName('PREPARED').AsString        := '';
      paramByName('PROJNAME').AsString        := PROJNAME.Text;
      paramByName('SHIPNO').AsString          := SHIPNO.Text;
      paramByName('DIVLIC').AsString          := DIVLIC.Text;
      paramByName('OWNER').AsString           := TOWNER.Text;
      paramByName('SITE').AsString            := SITE.Text;
      paramByName('RPM').AsString             := RPM.Text;
      paramByName('ENGNUM').AsString          := ENGNUM.Text;
      paramByName('ACTIONCODE').AsString      := ACTIONCODE.Text;

      paramByName('WORKTIME').AsString        := WORKTIME.Text;
      if RegType.ItemIndex > -1 then
        paramByName('REGTYPE').AsString       := IntToStr(RegType.ItemIndex)
      else
        paramByName('REGTYPE').AsString       := '0';

      paramByName('FORUSE').AsString          := FORUSE.Text;

      if not(EMPNO.Items.Count = 0) then
        paramByName('EMPNO').AsString         := EMPNO.Hint// .Items.Strings[0]
      else
        paramByName('EMPNO').AsString         := '';

      if not(INEMPNO.Items.Count = 0) then
        paramByName('INEMPNO').AsString       := INEMPNO.Hint//.Text//.Items.Strings[0]
      else
        paramByName('INEMPNO').AsString       := '';

      if not(HIEMPNO.Items.Count = 0) then
        paramByName('HIEMPNO').AsString       := HIEMPNO.Hint//.Items.Strings[0]
      else
        paramByName('HIEMPNO').AsString       := '';

      if not(HIINEMPNO.Items.Count = 0) then
        paramByName('HIINEMPNO').AsString     := HIINEMPNO.Hint//.Items.Strings[0]
      else
        paramByName('HIINEMPNO').AsString         := '';

      if not (sendDate.Text = '') then
        paramByName('SENDDATE').AsDateTime          := StrToDateTime(SendDate.Text);
      if not (RCVDATE.Text = '') then
        paramByName('RCVDATE').AsDateTime          := StrToDateTime(RCVDATE.Text);

      with TroubleList do
      begin
        for li := 0 to RowCount-1 do
        begin
          LStr := 'TROUBLETYPE'+ IntToStr(li+1);
          paramByName(LStr).AsString := Cells[2,li];
        end;//for
      end;//with


      if TrKind.Checked[0] = True then
        paramByName('TRTYPE1').AsString       := 'T'
      else
        paramByName('TRTYPE1').AsString       := 'F';

      if TrKind.Checked[1] = True then
        paramByName('TRTYPE2').AsString       := 'T'
      else
        paramByName('TRTYPE2').AsString       := 'F';

      if TrKind.Checked[2] = True then
        paramByName('TRTYPE3').AsString       := 'T'
      else
        paramByName('TRTYPE3').AsString       := 'F';

      if TrKind.Checked[3] = True then
        paramByName('TRTYPE4').AsString       := 'T'
      else
        paramByName('TRTYPE4').AsString       := 'F';

      paramByName('ITEMNAME').AsString        := ITEMNAME.Text;

      paramByName('SDATE').AsDateTime         := SDATE.DateTime;

      if not (ADATE.Text = '') then
        paramByName('ADATE').AsDateTime           := StrToDateTime(ADATE.Text);

      paramByName('PROCESS').AsString         := PROCESS.Text;
      if not (PDATE.Text = '') then
        paramByName('PDATE').AsDateTime           := StrToDateTime(PDATE.Text);

      paramByName('STATUSTITLE').AsString     := STATUSTITLE.Text;
      paramByName('STATUS').AsString          := STATUS.Text;
      paramByName('REASONTITLE').AsString     := REASONTITLE.Text;
      paramByName('REASON').AsString          := REASON.Text;
      paramByName('PLANTITLE').AsString       := PLANTITLE.Text;
      paramByName('PLAN').AsString            := PLAN.Text;
      paramByName('REASON1TITLE').AsString    := REASON1TITLE.Text;

      paramByName('REASON1').AsString         := REASON1.Text;
      paramByName('RESULTTITLE').AsString     := RESULTTITLE.Text;
      paramByName('RESULT').AsString          := RESULTa.Text;
  //      paramByName('APPLYEMPNO').AsString      := APPLYEMPNO.Text;
  //      if not (EDATE.Text = '') then
  //        paramByName('EDATE').AsDateTime          := StrToDateTime(EDATE.Text);
  //    paramByName('DOAPPLY').AsString         := DOAPPLY.Text;

      paramByName('DESIGNAPP').AsInteger      := DesignApp.ItemIndex;

      with ACGrid1 do
      begin
        paramByName('NDEPT1').AsString          := Cells[0,1];
        paramByName('NDEPT2').AsString          := Cells[0,2];
        paramByName('NDEPT3').AsString          := Cells[0,3];

        paramByName('COMPLE1').AsString         := Cells[1,1];
        paramByName('COMPLE2').AsString         := Cells[1,2];
        paramByName('COMPLE3').AsString         := Cells[1,3];

        paramByName('CDATE1').AsString          := Cells[2,1];
        paramByName('CDATE2').AsString          := Cells[2,2];
        paramByName('CDATE3').AsString          := Cells[2,3];
      end;

      paramByName('RESULTC1').AsString          := ResultC1.Text;
      paramByName('RESULTC2').AsString          := ResultC2.Text;
      paramByName('RESULTC3').AsString          := ResultC3.Text;
      paramByName('RESULTC4').AsString          := ResultC4.Text;
      paramByName('RESULTC5').AsString          := ResultC5.Text;
      paramByName('RESULTC6').AsString          := ResultC6.Text;

      paramByName('REMARK1').AsString           := '';
      paramByName('REMARK2').AsString           := '';
      paramByName('REMARK3').AsString           := '';
      paramByName('REMARK4').AsString           := '';
      paramByName('REMARK5').AsString           := '';
      paramByName('REMARK6').AsString           := '';

      {
      with ACGrid2 do
      begin
        paramByName('RESULTC1').AsString        := Cells[2,1];
        paramByName('RESULTC2').AsString        := Cells[2,2];
        paramByName('RESULTC3').AsString        := Cells[2,3];
        paramByName('RESULTC4').AsString        := Cells[2,4];
        paramByName('RESULTC5').AsString        := Cells[2,5];
        paramByName('RESULTC6').AsString        := Cells[2,6];

        paramByName('REMARK1').AsString         := Cells[3,1];
        paramByName('REMARK2').AsString         := Cells[3,2];
        paramByName('REMARK3').AsString         := Cells[3,3];
        paramByName('REMARK4').AsString         := Cells[3,4];
        paramByName('REMARK5').AsString         := Cells[3,5];
        paramByName('REMARK6').AsString         := Cells[3,6];
//여기      end;//with ACGrid2
}

      if REFTYPE.ItemIndex > -1 then
        paramByName('REFTYPE').AsString   := IntToStr(REFTYPE.ItemIndex)
      else
        paramByName('REFTYPE').AsString   := '';


      Case StepStat.ItemIndex of
        0 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[0];
        1 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[1];
        2 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[2];
        3 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[3];
      end;
      paramByName('DEPT').AsString              := Statusbar1.Panels[2].Text;
      paramByName('DTeam').AsString             := Statusbar1.Panels[3].Text;

      paramByName('FResult').AsInteger          := 0; //조치사항 등록 0:담당자 등록 안됨, 1: 담당자 등록
  //      paramByName('DOAPPLY').AsString           := '';//유사공사 조치사항;; 필요없는 항목

      for li := 1 to 5 do
      begin
        if not(li > AppGrid.ColCount-1) then
          LStr := AppGrid.Cells[li,0]
        else
          LStr := '';

        case li of
          1 : paramByName('APPROVED1').AsString  := LStr;
          2 : paramByName('APPROVED2').AsString  := LStr;
          3 : paramByName('APPROVED3').AsString  := LStr;
          4 : paramByName('APPROVED4').AsString  := LStr;
          5 : paramByName('APPROVED5').AsString  := LStr;
        end;
      end;

      if not(MCodeID.Text = '') then
        parambyname('MOBILECODE').AsString      := MCodeId.Text;

      try
        ExecSQL;
        Result := True;
      except
        on e:exception do
          ShowMessage(e.Message);
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TTrouble_Frm.TroubleData_Save_To_TSMS: Boolean;
var
  li : integer;
  LStr1, LStr2, LStr3 : String;
  LStr4, LStr5 : String;
begin
  Result := False;
  with DM1.EQuery1 do
  begin
    Try
      Close;
      SQL.Clear;
      SQL.Add('insert into TS_DATA');
      SQL.Add(' (CODEID, PROJNO, PROJNAME, SHIPNO, ENGTYPE, SITE, OWNER, DIVLIC, ACTIONCODE, RPM,'); // 1 ~ 10
      SQL.Add(' FORUSE, CLAIMNO, SENDDATE, WORKTIME, TROUBLETYPE1, TROUBLETYPE2, TROUBLETYPE3, TROUBLETYPE4, TROUBLETYPE5, SDATE,'); // 11 ~ 20
      SQL.Add(' ADATE, INDATE, RCVDATE, EDATE, DELDATE, EMPNO, INEMPNO, HIEMPNO, HIINEMPNO, APPLYEMPNO,'); //21 ~ 30
      SQL.Add(' DELEMPNO, STATUS, REASON, PLAN, REASON1, RESULT, SUBPLAN1, SUBPLAN2, DOAPPLY, TITLE,'); // 31 ~ 40
      SQL.Add(' REMARK, ENGNUM, PARTNUM, SUBPROJNONUM, STEPSTATUS, ISTEMPSAVE, REGTYPE, FB_NO, CTRL_NO, REFTYPE)'); // 41 ~ 50

      SQL.Add(' Values (:CODEID, :PROJNO, :PROJNAME, :SHIPNO, :ENGTYPE, :SITE, :OWNER, :DIVLIC, :ACTIONCODE, :RPM,'); // 1 ~ 10
      SQL.Add(' :FORUSE, :CLAIMNO, :SENDDATE, :WORKTIME, :TROUBLETYPE1, :TROUBLETYPE2, :TROUBLETYPE3, :TROUBLETYPE4, :TROUBLETYPE5, :SDATE,'); // 11 ~ 20
      SQL.Add(' :ADATE, :INDATE, :RCVDATE, :EDATE, :DELDATE, :EMPNO, :INEMPNO, :HIEMPNO, :HIINEMPNO, :APPLYEMPNO,'); //21 ~ 30
      SQL.Add(' :DELEMPNO, :STATUS, :REASON, :PLAN, :REASON1, :RESULT, :SUBPLAN1, :SUBPLAN2, :DOAPPLY, :TITLE,'); // 31 ~ 40
      SQL.Add(' :REMARK, :ENGNUM, :PARTNUM, :SUBPROJNONUM, :STEPSTATUS, :ISTEMPSAVE, :REGTYPE, :FB_NO, :CTRL_NO, :REFTYPE)'); // 41 ~ 50

      paramByName('CodeID').AsString       := CodeID.Text;
      paramByName('PROJNO').AsString       := PROJNO.Text;
      paramByName('PROJNAME').AsString     := PROJNAME.Text;
      paramByName('SHIPNO').AsString       := SHIPNO.Text;
      paramByName('ENGTYPE').AsString      := ENGTYPE.Text;
      paramByName('SITE').AsString         := SITE.Text;
      paramByName('OWNER').AsString        := TOWNER.Text;
      paramByName('DIVLIC').AsString       := DIVLIC.Text;
      paramByName('ACTIONCODE').AsString   := ACTIONCODE.Text;
      paramByName('RPM').AsString          := RPM.Text;

      paramByName('FORUSE').AsString       := FORUSE.Text;
      paramByName('CLAIMNO').AsString      := CLAIMNO.Text;
      if not (SendDate.Text = '') then
        paramByName('SENDDATE').AsDateTime       := STRTODATETIME(SENDDATE.Text);
      paramByName('WORKTIME').AsString     := WORKTIME.Text;

      with TroubleList do
      begin
        for li := 0 to RowCount-1 do
        begin
          LStr1 := 'TROUBLETYPE'+ IntToStr(li+1);
          paramByName(LStr1).AsString := Cells[2,li];
        end;//for
      end;//with

      paramByName('SDATE').AsDateTime         := SDATE.DateTime;
      if not (ADate.Text = '') then
        paramByName('ADATE').AsDateTime         := StrToDateTime(ADate.Text);

      paramByName('INDATE').AsDateTime      := Now;

      if not (RCVDate.Text = '') then
        paramByName('RCVDATE').AsDateTime       := StrtoDateTime(RCVDate.Text);

//      if not (EDate.Text = '') then
//        paramByName('EDATE').AsDateTime       := StrtoDateTime(EDate.Text);
    //    paramByName('DELDATE').AsDateTime     := ' ';

      if EMPNo.Items.Count > 0then
        paramByName('EMPNO').AsString       := EMPNO.Items.Strings[0];

      if INEMPNO.Items.Count > 0then
        paramByName('INEMPNO').AsString     := INEMPNO.Items.Strings[0];

      if HIEMPNO.Items.Count > 0then
        paramByName('HIEMPNO').AsString     := HIEMPNO.Items.Strings[0];

      if HIINEMPNO.Items.Count > 0then
        paramByName('HIINEMPNO').AsString   := HIINEMPNO.Items.Strings[0];

    //    paramByName('DELEMPNO').AsString    := ''; //사번으로 입력 삭제자

      paramByName('STATUS').AsString      := Status.Text;
      paramByName('REASON').AsString      := Reason.Text;
      paramByName('PLAN').AsString        := Plan.Text;
      paramByName('REASON1').AsString     := Reason1.Text;
      paramByName('RESULT').AsString      := RESULTa.Text;
    //    paramByName('SUBPLAN1').AsString    := ''; 유사공사 조치계획의...조치방안1 ~ 2
    //    paramByName('SUBPLAN2').AsString    := '';

    //    paramByName('DOAPPLY').AsString     := ''; 조치완료 페이지의 유사공사 조치여부..
      paramByName('TITLE').AsString       := TITLE.Text;

    //    paramByName('REMARK').AsString      := '';
      paramByName('ENGNUM').AsString      := ENGNUM.Text;

    //    paramByName('PARTNUM').AsString     := '';
    //    paramByName('SUBPROJNONUM').AsString:= '';

      Case StepStat.ItemIndex of
        0 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[0];
        1 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[1];
        2 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[2];
        3 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[3];
      end;

    //    paramByName('ISTEMPSAVE').AsString  := '';

      if not(RegType.Text = '') then
      begin
        Case RegType.ItemIndex of
          0 : paramByName('REGTYPE').AsString := '0';
          1 : paramByName('REGTYPE').AsString := '1';
          2 : paramByName('REGTYPE').AsString := '2';
        end;//case
      end
      else
        paramByName('REGTYPE').AsString := '0';

    //    paramByName('FB_NO').AsString       := '';
    //    paramByName('CTRL_NO').AsString     := '';

      Case REFType.ItemIndex of
        0 : paramByName('REFTYPE').AsString := '0';
        1 : paramByName('REFTYPE').AsString := '1';
        2 : paramByName('REFTYPE').AsString := '2';
        3 : paramByName('REFTYPE').AsString := '3';
      end;//case
      ExecSQL;
      Result := True;
    except
      Result := False;
    raise;
    end;
  end;//with
end;

function TTrouble_Frm.TroubleData_Update_To_DB: Boolean;
var
  li : integer;
  Lstr : String;
begin
  Result := False;
  with DM1.TQuery1 do
  begin
    Try
      Close;
      SQL.Clear;
      SQL.Add('Update TROUBLE_Data Set');
      SQL.Add(' RPTYPE = :RPTYPE, CLAIMNO = :CLAIMNO, TITLE = :TITLE, ENGNAME = :ENGNAME,'); //1 ~ 5
      SQL.Add(' PROJNO = :PROJNO, ENGTYPE = :ENGTYPE, MEASPM = :MEASPM, APPROVAL = :APPROVAL, INDATE = :INDATE,'); //6 ~ 10
      SQL.Add(' CHECKED = :CHECKED, PREPARED = :PREPARED, PROJNAME = :PROJNAME, SHIPNO = :SHIPNO, DIVLIC = :DIVLIC,');//11 ~ 15
      SQL.Add(' OWNER = :OWNER, SITE = :SITE, RPM = :RPM, ENGNUM = :ENGNUM, ACTIONCODE = :ACTIONCODE,');//16 ~ 20
      SQL.Add(' WORKTIME = :WORKTIME, REGTYPE = :REGTYPE, FORUSE = :FORUSE, EMPNO = :EMPNO, INEMPNO = :INEMPNO,');//21 ~ 25
      SQL.Add(' HIEMPNO = :HIEMPNO, HIINEMPNO = :HIINEMPNO, SENDDATE = :SENDDATE, RCVDATE = :RCVDATE, TROUBLETYPE1 = :TROUBLETYPE1,');//26~30
      SQL.Add(' TROUBLETYPE2 = :TROUBLETYPE2, TROUBLETYPE3 = :TROUBLETYPE3, TROUBLETYPE4 = :TROUBLETYPE4, TROUBLETYPE5 = :TROUBLETYPE5, TRTYPE1 = :TRTYPE1,');//31~35
      SQL.Add(' TRTYPE2 = :TRTYPE2, TRTYPE3 = :TRTYPE3, TRTYPE4 = :TRTYPE4, ITEMNAME = :ITEMNAME, SDATE = :SDATE,');//36~40
      SQL.Add(' ADATE = :ADATE, PROCESS = :PROCESS, PDATE = :PDATE, STATUSTITLE = :STATUSTITLE, STATUS = :STATUS,');//41 ~ 45
      SQL.Add(' REASONTITLE = :REASONTITLE, REASON = :REASON, PLANTITLE = :PLANTITLE, PLAN = :PLAN, REASON1TITLE = :REASON1TITLE,');
      SQL.Add(' REASON1 = :REASON1, RESULTTITLE = :RESULTTITLE, RESULT = :RESULT, APPLYEMPNO = :APPLYEMPNO, EDATE = :EDATE,');
      SQL.Add(' DESIGNAPP = :DESIGNAPP, NDEPT1 = :NDEPT1, NDEPT2 = :NDEPT2, NDEPT3 = :NDEPT3,');
      SQL.Add(' COMPLE1 = :COMPLE1, COMPLE2 = :COMPLE2, COMPLE3 = :COMPLE3, CDATE1 = :CDATE1, CDATE2 = :CDATE2,');
      SQL.Add(' CDATE3 = :CDATE3, RESULTC1 = :RESULTC1, RESULTC2 = :RESULTC2, RESULTC3 = :RESULTC3, RESULTC4 = :RESULTC4,');
      SQL.Add(' RESULTC5 = :RESULTC5, RESULTC6 = :RESULTC6, REMARK1 = :REMARK1, REMARK2 = :REMARK2, REMARK3 = :REMARK3,');
      SQL.Add(' REMARK4 = :REMARK4, REMARK5 = :REMARK5, REMARK6 = :REMARK6, REFTYPE = :REFTYPE, STEPSTATUS = :STEPSTATUS,');
      SQL.Add(' DEPT = :DEPT, DTEAM = :DTEAM, FResult = :FResult, DOAPPLY = :DOAPPLY,APPROVED1 = :APPROVED1, APPROVED2 = :APPROVED2,');
      SQL.Add(' APPROVED3 = :APPROVED3, APPROVED4 = :APPROVED4, APPROVED5 = :APPROVED5');            
      SQL.Add(' where CodeID = :Param1');

      paramByName('Param1').AsString          := CodeID.Text;

      paramByName('RPTYPE').AsString          := IntToStr(GrpType.ItemIndex); // 0 : 품질, 1:설비문제, 2:조립문제,3:시운전문제,4:문제예상

      paramByName('CLAIMNO').AsString         := ClaimNo.Text;
      paramByName('TITLE').AsString           := TITLE.Text;
      paramByName('ENGNAME').AsString         := ENGNAME.Text;
      paramByName('PROJNO').AsString          := PROJNO.Text;

      paramByName('ENGTYPE').AsString         := ENGTYPE.Text;
      paramByName('MEASPM').AsString          := '';
      paramByName('INDATE').AsDateTime            := Now;
      paramByName('APPROVAL').AsString        := '';

      paramByName('CHECKED').AsString         := '';
      paramByName('PREPARED').AsString        := '';
      paramByName('PROJNAME').AsString        := PROJNAME.Text;
      paramByName('SHIPNO').AsString          := SHIPNO.Text;
      paramByName('DIVLIC').AsString          := DIVLIC.Text;
      paramByName('OWNER').AsString           := TOWNER.Text;
      paramByName('SITE').AsString            := SITE.Text;
      paramByName('RPM').AsString             := RPM.Text;
      paramByName('ENGNUM').AsString          := ENGNUM.Text;
      paramByName('ACTIONCODE').AsString      := ACTIONCODE.Text;

      paramByName('WORKTIME').AsString        := WORKTIME.Text;

      if RegType.ItemIndex > -1 then
        paramByName('REGTYPE').AsString       := IntToStr(RegType.ItemIndex)
      else
        paramByName('REGTYPE').AsString       := '0';

      paramByName('FORUSE').AsString          := FORUSE.Text;

      if not(EMPNO.Items.Count = 0) then
        paramByName('EMPNO').AsString         := EMPNO.Items.Strings[0]
      else
        paramByName('EMPNO').AsString         := '';

      if not(INEMPNO.Items.Count = 0) then
        paramByName('INEMPNO').AsString       := INEMPNO.Items.Strings[0]
      else
        paramByName('INEMPNO').AsString       := '';

      if not(HIEMPNO.Items.Count = 0) then
        paramByName('HIEMPNO').AsString       := HIEMPNO.Items.Strings[0]
      else
        paramByName('HIEMPNO').AsString       := '';

      if not(HIINEMPNO.Items.Count = 0) then
        paramByName('HIINEMPNO').AsString     := HIINEMPNO.Items.Strings[0]
      else
        paramByName('HIINEMPNO').AsString         := '';


      if not (sendDate.Text = '') then
        paramByName('SENDDATE').AsDateTime          := StrToDateTime(SendDate.Text);
      if not (RCVDATE.Text = '') then
        paramByName('RCVDATE').AsDateTime          := StrToDateTime(RCVDATE.Text);

      with TroubleList do
      begin
        for li := 0 to RowCount-1 do
        begin
          LStr := 'TROUBLETYPE'+ IntToStr(li+1);
          paramByName(LStr).AsString := Cells[2,li];
        end;//for
      end;//with


      if TrKind.Checked[0] = True then
        paramByName('TRTYPE1').AsString       := 'T'
      else
        paramByName('TRTYPE1').AsString       := 'F';

      if TrKind.Checked[1] = True then
        paramByName('TRTYPE2').AsString       := 'T'
      else
        paramByName('TRTYPE2').AsString       := 'F';

      if TrKind.Checked[2] = True then
        paramByName('TRTYPE3').AsString       := 'T'
      else
        paramByName('TRTYPE3').AsString       := 'F';

      if TrKind.Checked[3] = True then
        paramByName('TRTYPE4').AsString       := 'T'
      else
        paramByName('TRTYPE4').AsString       := 'F';

      paramByName('ITEMNAME').AsString        := ITEMNAME.Text;
      paramByName('SDATE').AsDateTime         := SDATE.DateTime;

      if not (ADATE.Text = '') then
        paramByName('ADATE').AsDateTime           := StrToDateTime(ADATE.Text);
      paramByName('PROCESS').AsString         := PROCESS.Text;
      if not (PDATE.Text = '') then
        paramByName('PDATE').AsDateTime           := StrToDateTime(PDATE.Text);
      paramByName('STATUSTITLE').AsString     := STATUSTITLE.Text;
      paramByName('STATUS').AsString          := STATUS.Text;
      paramByName('REASONTITLE').AsString     := REASONTITLE.Text;
      paramByName('REASON').AsString          := REASON.Text;
      paramByName('PLANTITLE').AsString       := PLANTITLE.Text;
      paramByName('PLAN').AsString            := PLAN.Text;
      paramByName('REASON1TITLE').AsString    := REASON1TITLE.Text;

      paramByName('REASON1').AsString         := REASON1.Text;
      paramByName('RESULTTITLE').AsString     := RESULTTITLE.Text;
      paramByName('RESULT').AsString          := RESULTa.Text;
//      paramByName('APPLYEMPNO').AsString      := APPLYEMPNO.Text;
//      if not (EDATE.Text = '') then
//        paramByName('EDATE').AsDateTime          := StrToDateTime(EDATE.Text);

      paramByName('DESIGNAPP').AsInteger      := DesignApp.ItemIndex;

      with ACGrid1 do
      begin
        paramByName('NDEPT1').AsString          := Cells[0,1];
        paramByName('NDEPT2').AsString          := Cells[0,2];
        paramByName('NDEPT3').AsString          := Cells[0,3];

        paramByName('COMPLE1').AsString         := Cells[1,1];
        paramByName('COMPLE2').AsString         := Cells[1,2];
        paramByName('COMPLE3').AsString         := Cells[1,3];

        paramByName('CDATE1').AsString          := Cells[2,1];
        paramByName('CDATE2').AsString          := Cells[2,2];
        paramByName('CDATE3').AsString          := Cells[2,3];
      end;

      paramByName('RESULTC1').AsString          := ResultC1.Text;
      paramByName('RESULTC2').AsString          := ResultC2.Text;
      paramByName('RESULTC3').AsString          := ResultC3.Text;
      paramByName('RESULTC4').AsString          := ResultC4.Text;
      paramByName('RESULTC5').AsString          := ResultC5.Text;
      paramByName('RESULTC6').AsString          := ResultC6.Text;

      paramByName('REMARK1').AsString           := '';
      paramByName('REMARK2').AsString           := '';
      paramByName('REMARK3').AsString           := '';
      paramByName('REMARK4').AsString           := '';
      paramByName('REMARK5').AsString           := '';
      paramByName('REMARK6').AsString           := '';
      {
      with ACGrid2 do
      begin
        paramByName('RESULTC1').AsString        := Cells[2,1];
        paramByName('RESULTC2').AsString        := Cells[2,2];
        paramByName('RESULTC3').AsString        := Cells[2,3];
        paramByName('RESULTC4').AsString        := Cells[2,4];
        paramByName('RESULTC5').AsString        := Cells[2,5];
        paramByName('RESULTC6').AsString        := Cells[2,6];

        paramByName('REMARK1').AsString         := Cells[3,1];
        paramByName('REMARK2').AsString         := Cells[3,2];
        paramByName('REMARK3').AsString         := Cells[3,3];
        paramByName('REMARK4').AsString         := Cells[3,4];
        paramByName('REMARK5').AsString         := Cells[3,5];
        paramByName('REMARK6').AsString         := Cells[3,6];
      end;//with ACGrid2
      }
      if REFTYPE.ItemIndex > -1 then
        paramByName('REFTYPE').AsString   := IntToStr(RefType.ItemIndex)
      else
        paramByName('REFTYPE').AsString   := '';


      Case StepStat.ItemIndex of
        0 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[0];
        1 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[1];
        2 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[2];
        3 : paramByName('STEPSTATUS').AsString  := StepStat.Items.Strings[3];
      end;

      paramByName('DEPT').AsString              := Statusbar1.Panels[2].Text;
      paramByName('DTeam').AsString             := Statusbar1.Panels[3].Text;

      paramByName('FResult').AsInteger          := 0;//담당자가 조치사항 등록안한 상태
//      paramByName('DOAPPLY').AsString           := '';//TSMS 유사공사 조치사항 필요없는 항목 이전버젼 때문에 남겨둠
      for li := 1 to 5 do
      begin
        if not(li > AppGrid.ColCount-1) then
          LStr := AppGrid.Cells[li,0]
        else
          LStr := '';

        case li of
          1 : paramByName('APPROVED1').AsString  := LStr;
          2 : paramByName('APPROVED2').AsString  := LStr;
          3 : paramByName('APPROVED3').AsString  := LStr;
          4 : paramByName('APPROVED4').AsString  := LStr;
          5 : paramByName('APPROVED5').AsString  := LStr;                                        
        end;
      end;

      ExecSQL;
      Result := True;
    except
    raise;
    end;
  end;
end;


procedure TTrouble_Frm.TroubleFiles_Info_Upload_To_TSMS(FNCODE, FOCODE: String);
var
  li : integer;
  LCODEID : String;
  LFlag : String;
  LDBfileName : String;
  LLCfileName : String;
  FileExt : String;
  FileSize : String;
  LURL : String;
  LIndate : TDateTime;
  LYear : String;
  LMonth : String;
  LTS : TStream;
  LongTime : int64;
  LiCnt : integer;
begin
//  Try
//    LiCnt := 0;
//    with DM1.TQuery1 do
//    begin
//      Close;
//      SQL.Clear;
//      SQL.Add('Select * from Trouble_ATTFiles where CODEID = :param1 order by ATTFlag');
//      parambyname('param1').AsString := FOCODE;
//      Open;
//
//
//      for li := 0 to RecordCount -1 do
//      begin
//        if LiCnt = 0 then
//        begin
//          LInDate     := Now;
//          LCODEID     := FNCODE;
//          LFlag       := FieldByName('ATTFlag').AsString;
//          LLCfileName := FieldByName('LCFileName').AsString;
//          FileExt     := FieldByName('FileEXT').AsString;
//          FileSize    := FieldByName('FileSize').AsString;
//          LYear       := FormatDateTime('YYYY',LIndate);
//          LMonth      := FormatDateTime('MM',LIndate);
//          LDBfileName := IntToStr(DateTimeToMilliseconds(LInDate))+'.'+FileExt;
//          LUrl := Statusbar1.Panels[2].Text+'/'+LFlag+'/'+LYear+'/'+LMonth+'/';
//
//          LTS := TStream.Create;
//          LTS := createblobstream(fieldbyname('Files'), bmread);
//
//
//          with DM1.EQuery1 do
//          begin
//            Close;
//            SQL.Clear;
//            SQL.Add('insert into TS_ATTFILES');
//            SQL.Add('Values(:CODEID,:ATTFLAG,:LONGTIME,:FILENAME,:FILEURL,');
//            SQL.Add('       :FILETITLE,:FILEEXT,:FILESIZE,:UPLOADFLAG,:INDATE)');
//
//            parambyname('CODEID').AsString      := LCODEID;
//            parambyname('ATTFLAG').AsString     := LFlag;
//            LongTime := DateTimeToMilliseconds(Now);
//            parambyname('LONGTIME').AsString    := IntToStr(LongTime);
//            parambyname('FILENAME').AsString    := LDBFileName;
//            parambyname('FILEURL').AsString     := LURL;
//
//            parambyname('FILETITLE').AsString   := LLCFileName;
//            parambyname('FILEEXT').AsString     := FileExt;
//            parambyname('FILESIZE').AsString    := FileSize;
//            parambyname('UPLOADFLAG').AsString  := 'Y';
//            parambyname('INDATE').AsDateTime    := Now;
//            ExecSQL;
//
//            // FTP에 파일 저장
//            // FTP 서버 접근 불가로 14.01.24일 comment 처리함
//            {
//            if TSMS_FTP_Server_Connection = True then
//            begin
//              try
//                TSMS_FTP_Server_Directory_Setting(LFlag);// FTP Directory 설정 하고!!
//                if DM1.IdFTP1.Connected then
//                  DM1.IdFTP1.Put(LTS,LDBFileName);
//              finally
//                TSMS_FTP_Server_Connection;//FTP DisConnect
//              end;
//            end;
//            }
//            if LFlag = 'I' then
//              Inc(LiCnt);
//          end;//with EQuery1
//        end;
//        Next;
//      end;
//    end;//with
//  Finally
//    LTS.Free;
//  End;
end;

procedure TTrouble_Frm.Trouble_expectation_CODE_Generator;
var
  LCount : integer;
  LDouble : Double;
  LUpDate, LInsert : Boolean;
  LYear, LMonth, LSeqNo : String;
  LStr : String;
  LP1,LP2,LP3,LP4 : String; // Update 변수

begin
  LUpDate := False;
  LInsert := False;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select SEQNo from Trouble_TXNO where Dept = :param1');
    SQL.Add('And DTeam = :param2 And Year = :param3 And Month = :param4');

    ParamByName('Param1').AsString := Statusbar1.Panels[2].Text;
    ParamByName('Param2').AsString := Statusbar1.Panels[3].Text;
    ParamByName('Param3').AsString := FormatDateTime('YYYY',Now);
    ParamByName('Param4').AsString := FormatDateTime('MM',Now);
    Open;

    if RecordCount = 0 then
    begin
      LInsert := True;
      LCount := 0;
    end
    else
    begin
      LUpdate := True;
      LCount := StrToInt(FieldByName('SeqNo').AsString);
    end;//else
  end;//with

  if LUpdate = True then
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' Update Trouble_TXNO Set');
      SQL.Add(' SeqNo = :SeqNo ');
//      SQL.Add(' where Dept = :Param1 And DTeam = :param2 And Year = :param3 And Month = :param4');
      LP1 := Statusbar1.Panels[2].Text;
      LP2 := Statusbar1.Panels[3].Text;
      LP3 := FormatDateTime('YYYY',Now);
      LP4 := FormatDateTime('MM',Now);

      SQL.Add(' where Dept = ');
      SQL.Add(''''+LP1+'''');
      SQL.Add(' And DTeam = ');
      SQL.Add(''''+Lp2+'''');
      SQL.Add(' And Year = ');
      SQL.Add(''''+LP3+'''');
      SQL.Add(' And Month = ');
      SQL.Add(''''+LP4+'''');


      ParambyName('SeqNo').AsString := IntToStr(LCount+1);
      ExecSQL;

    end;//with
  end;//if

  if LInsert = True then
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into Trouble_TXNO');
      SQL.Add('(Dept, Dteam, Year, Month, SeqNo)');
      SQL.Add(' Values (:Dept, :DTeam, :Year, :Month, :SeqNo)');

      ParamByName('Dept').AsString  := Statusbar1.Panels[2].Text;
      ParamByName('DTeam').AsString := Statusbar1.Panels[3].Text;
      ParamByName('Year').AsString  := FormatDateTime('YYYY',Now);
      ParamByName('Month').AsString := FormatDateTime('MM',Now);
      ParamByName('SeqNo').AsString := intToStr(LCount + 1);
      ExecSQL;
    end;//with
  end;//if

  //관리번호 생성하고~~ CodeID.Text 에 관리번호 집어넣기!!

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Trouble_TXNO where Dept = :param1');
    SQL.Add('And DTeam = :param2 And Year = :param3 And Month = :param4');
    ParamByName('Param1').AsString := Statusbar1.Panels[2].Text;
    ParamByName('Param2').AsString := Statusbar1.Panels[3].Text;
    ParamByName('Param3').AsString := FormatDateTime('YYYY',Now);
    ParamByName('Param4').AsString := FormatDateTime('MM',Now);
    Open;

    LYear   := FieldByName('Year').AsString;
    LMonth  := FieldByName('Month').AsString;
    LDouble := StrToint(FieldByName('SeqNo').AsString);
    LSeqNo  := formatFloat('000',LDouble);
    LStr    := LeftStr(Statusbar1.Panels[2].Text,3)+Statusbar1.Panels[3].Text;

    CodeID.Text := 'TX_'+LSTR+'_'+ LYear +'_'+ LMonth +'_'+ LSeqNo; //관리번호 완성~~
  end;//with
end;

procedure TTrouble_Frm.Trouble_Save_to_Trouble_Datatemp;
var
  li : integer;
  LUser : String;
  lok : Boolean;
begin
  lok := False;
  with DM1.OraTransaction1 do
  begin
    DefaultSession := DM1.TSession1;
    try
      StartTransaction;
      try
        if Check_for_Mandatory_Items = True then
        begin
          Trouble_Temp_CODE_Generator;
          lok := TroubleData_Save_To_DB;
          if lok = True then
          begin
            Check_for_FileGrid_and_Upload_2_TBACS; //파일 업로드
            CCList_2_DataBase(CODEID.Text); // 참조자 저장
            Save_of_Approval;

            Registor_of_New_Report_Log(CODEID.Text, LUser, 0);
            Btn_arrangement_after_check_for_DocStatus;

            if not(MCODEID.Text = '') then
              InEMP_User_Check_for_TRouble_List(MCODEID.Text,3);
            ShowMessage('보고서 저장이 완료되었습니다.');
//            Commit;
//          end else
//            Rollback;
          end;
        end;
      except
        Rollback;
        ShowMessage('보고서 저장에 실패하였습니다.');
        Exit;
      end;
    finally
      if lok then
        Commit
      else
        Rollback;

      FDelCnt := 0;
      FillChar(FDelInfo,SizeOf(FDelInfo), 0); // 삭제목록 초기화
    end;
  end;
end;

procedure TTrouble_Frm.Trouble_Temp_CODE_Generator;
var
  LCount : integer;
  LDouble : Double;
  LUpDate, LInsert : Boolean;
  LYear, LMonth, LSeqNo : String;
  LStr : String;
  LP1,LP2,LP3,LP4 : String; // Update 변수

begin
  LUpDate := False;
  LInsert := False;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select SEQNo from Trouble_TEMPNO where Dept = :param1');
    SQL.Add('And DTeam = :param2 And Year = :param3 And Month = :param4');

    ParamByName('Param1').AsString := LeftStr(Statusbar1.Panels[2].Text,3);
    ParamByName('Param2').AsString := Statusbar1.Panels[3].Text;
    ParamByName('Param3').AsString := FormatDateTime('YYYY',Now);
    ParamByName('Param4').AsString := FormatDateTime('MM',Now);
    Open;

    if RecordCount = 0 then
    begin
      LInsert := True;
      LCount := 0;
    end
    else
    begin
      LUpdate := True;
      LCount := StrToInt(FieldByName('SeqNo').AsString);
    end;//else
  end;//with

  if LUpdate = True then
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' Update Trouble_TEMPNO Set');
      SQL.Add(' SeqNo = :SeqNo ');
//      SQL.Add(' where Dept = :Param1 And DTeam = :param2 And Year = :param3 And Month = :param4');
      LP1 := LeftStr(Statusbar1.Panels[2].Text,3);
      LP2 := Statusbar1.Panels[3].Text;
      LP3 := FormatDateTime('YYYY',Now);
      LP4 := FormatDateTime('MM',Now);

      SQL.Add(' where Dept = ');
      SQL.Add(''''+LP1+'''');
      SQL.Add(' And DTeam = ');
      SQL.Add(''''+Lp2+'''');
      SQL.Add(' And Year = ');
      SQL.Add(''''+LP3+'''');
      SQL.Add(' And Month = ');
      SQL.Add(''''+LP4+'''');


      ParambyName('SeqNo').AsString := IntToStr(LCount+1);
      ExecSQL;

    end;//with
  end;//if

  if LInsert = True then
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into Trouble_TEMPNO');
      SQL.Add('(Dept, Dteam, Year, Month, SeqNo)');
      SQL.Add(' Values (:Dept, :DTeam, :Year, :Month, :SeqNo)');

      ParamByName('Dept').AsString  := LeftStr(Statusbar1.Panels[2].Text,3);
      ParamByName('DTeam').AsString := Statusbar1.Panels[3].Text;
      ParamByName('Year').AsString  := FormatDateTime('YYYY',Now);
      ParamByName('Month').AsString := FormatDateTime('MM',Now);
      ParamByName('SeqNo').AsString := intToStr(LCount + 1);
      ExecSQL;
    end;//with
  end;//if

  //관리번호 생성하고~~ CodeID.Text 에 관리번호 집어넣기!!

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Trouble_TEMPNO where Dept = :param1');
    SQL.Add('And DTeam = :param2 And Year = :param3 And Month = :param4');
    ParamByName('Param1').AsString := LeftStr(Statusbar1.Panels[2].Text,3);
    ParamByName('Param2').AsString := Statusbar1.Panels[3].Text;
    ParamByName('Param3').AsString := FormatDateTime('YYYY',Now);
    ParamByName('Param4').AsString := FormatDateTime('MM',Now);
    Open;

    LYear   := FieldByName('Year').AsString;
    LMonth  := FieldByName('Month').AsString;
    LDouble := StrToint(FieldByName('SeqNo').AsString);
    LSeqNo  := formatFloat('000',LDouble);
    LStr    := LeftStr(Statusbar1.Panels[2].Text,3)+Statusbar1.Panels[3].Text;

    CodeID.Text := 'TT_'+LSTR+'_'+ LYear +'_'+ LMonth +'_'+ LSeqNo; //관리번호 완성~~
  end;//with
end;

function TTrouble_Frm.TSMS_FTP_Server_Connection : Boolean;
begin
  try
    if DM1.idFTP1.Connected then
    begin
      DM1.idFTP1.Disconnect;
    end
    else
    begin
      with DM1.IdFTP1 do
      begin
        host := '10.100.22.37';
        UserName := 'ts';
        Password := 'ts01';
        Port := 9003;
        Connect;
        ChangeDir('/K2B0');
        Result := True;
      end;
    end;
  except
    Result := False;
  end;
end;

procedure TTrouble_Frm.TSMS_FTP_Server_Directory_Setting(FFlag: String);
var
  li : integer;
  AList : TStringList;
  Dirname : String;
  DirRoot : String;
  DirYear : String;
  DirMonth : String;
  DirBool : Boolean;
begin
  try
    DirRoot := FFlag;
    DirRoot := '/K2B0/'+DirRoot;
    DirYear := FormatDateTime('YYYY',Now);
    DirMonth := FormatDateTime('MM',Now);
    DM1.idFTP1.ChangeDir(DirRoot);

    AList := TStringList.Create;
    DM1.IdFtp1.List(AList, '*', True);

    for li := 0 to AList.Count-1 do
    begin
      Dirname := RightStr(AList.Strings[li],4);

      if Dirname = DirYear then
      begin
        DM1.idFTP1.ChangeDir(DirRoot+'/'+DirName);
        DirBool := True;
      end;//if
    end;//for

    if DirBool = False then
    begin
      DM1.idFTP1.MakeDir(DirYear);
      DM1.idFTP1.ChangeDir(DirRoot+'/'+DirYear);
    end;//if

    DirBool := False;

    AList := TStringList.Create;
    DM1.IdFtp1.List(AList, '*', True);

    for li := 0 to Alist.Count - 1 do
    begin
      Dirname := RightStr(AList.Strings[li],2);
      if Dirname = DirMonth then
      begin
        DM1.idFTP1.ChangeDir(DirRoot+'/'+DirYear+'/'+DirName);
        DirBool := True;
      end;//if
    end;//for

    if DirBool = False then
    begin
      DM1.idFTP1.MakeDir(DirMonth);
      DM1.idFTP1.ChangeDir(DirRoot+'/'+DirYear+'/'+DirMonth);
    end;//if
  Finally
    AList.Free;
  end;
end;

procedure TTrouble_Frm.Turn_to_Back_Before_TSMSCODE(FNCODE, FOCODE: String);
var
  LBValue : integer;
begin
//  with DM1.EQuery1 do
//  begin
//    Try
//      Close;
//      SQL.Clear;
//      SQL.Add('select SEQNo from TS_GETSEQNO where Dept = :param1');
//      SQL.Add('And Year = :param2 And Month = :param3');
//
//      ParamByName('Param1').AsString := Statusbar1.Panels[2].Text;
//      ParamByName('Param2').AsString := FormatDateTime('YYYY',Now);
//      ParamByName('Param3').AsString := FormatDateTime('MM',Now);
//      Open;
//
//      LBValue := StrToInt(FieldByName('SeqNo').AsString);
//    except
//    raise;
//    end;
//  end;//with
//
//  with DM1.EQuery1 do
//  begin
//    try
//      Close;
//      SQL.Clear;
//      SQL.Add('Update TS_GETSEQNO Set');
//      SQL.Add('SeqNo = :SeqNo');
//      SQL.Add('where Dept = :param1 And Year = :param2 And Month = :param3');
//
//      ParamByName('param1').AsString := Statusbar1.Panels[2].Text;
//      ParamByName('param2').AsString := FormatDateTime('YYYY',Now);
//      ParamByName('param3').AsString := FormatDateTime('MM',Now);
//      ParamByName('SeqNo').AsString := intToStr(LBValue - 1);
//      ExecSQL;
//    except
//    raise;
//    end;
//  end;//with
//
//  with DM1.EQuery1 do
//  begin
//    try
//      Close;
//      SQL.Clear;
//      SQL.Add('Delete from TS_DATA where CODEID = :param1');
//      parambyname('param1').AsString := FNCODE;
//
//      ExecSQL;
//    except
//    raise;
//    end;
//  end;//with
//
//  with DM1.EQuery1 do
//  begin
//    try
//      Close;
//      SQL.Clear;
//      SQL.Add('Delete from TS_ATTFILES where CODEID = :param1');
//      parambyname('param1').AsString := FNCODE;
//
//      ExecSQL;
//    except
//    raise;
//    end;
//  end;//with
end;

procedure TTrouble_Frm.Turn_to_Back_Before_TSMSCODE2(FNCODE, FOCODE: String);
var
  LBValue : integer;
begin
//  with DM1.EQuery1 do
//  begin
//    Try
//      Close;
//      SQL.Clear;
//      SQL.Add('select SEQNo from TROUBLE_TSNO where Dept = :param1');
//      SQL.Add('And Year = :param2 And Month = :param3');
//
//      ParamByName('Param1').AsString := Statusbar1.Panels[2].Text;
//      ParamByName('Param2').AsString := FormatDateTime('YYYY',Now);
//      ParamByName('Param3').AsString := FormatDateTime('MM',Now);
//      Open;
//
//      LBValue := StrToInt(FieldByName('SeqNo').AsString);
//    except
//    raise;
//    end;
//  end;//with
//
//  with DM1.EQuery1 do
//  begin
//    try
//      Close;
//      SQL.Clear;
//      SQL.Add('Update TROUBLE_TSNO Set');
//      SQL.Add('SeqNo = :SeqNo');
//      SQL.Add('where Dept = :param1 And Year = :param2 And Month = :param3');
//
//      ParamByName('param1').AsString := Statusbar1.Panels[2].Text;
//      ParamByName('param2').AsString := FormatDateTime('YYYY',Now);
//      ParamByName('param3').AsString := FormatDateTime('MM',Now);
//      ParamByName('SeqNo').AsString := intToStr(LBValue - 1);
//      ExecSQL;
//    except
//    raise;
//    end;
//  end;//with
end;

procedure TTrouble_Frm.Update_TroubleRP_CODE_TO_TSMS(FNCODE, FOCODE: String);
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update Trouble_Data Set CODEID = :NCODEID where CODEID = :param1'); //12.05.10 INDATE Update 제거 최초 작성일 그대로 감
//    SQL.Add('Update Trouble_Data Set CODEID = :NCODEID, Indate = :NIndate where CODEID = :param1');
    parambyname('param1').AsString  := FOCODE;
    parambyname('NCODEID').AsString := FNCODE;
//    parambyname('NIndate').AsDateTimeTime := Now;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update Trouble_CCList Set CODEID = :NCODEID where CODEID = :param1');
    parambyname('param1').AsString  := FOCODE;
    parambyname('NCODEID').AsString := FNCODE;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update Trouble_AttFiles Set CODEID = :NCODEID where CODEID = :param1');
    parambyname('param1').AsString  := FOCODE;
    parambyname('NCODEID').AsString := FNCODE;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update Trouble_DataLog Set CODEID = :NCODEID where CODEID = :param1');
    parambyname('param1').AsString  := FOCODE;
    parambyname('NCODEID').AsString := FNCODE;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update ZHITEMS_APPROVER Set CODEID = :NCODEID where CODEID = :param1');
    parambyname('param1').AsString  := FOCODE;
    parambyname('NCODEID').AsString := FNCODE;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update ZHITEMS_APPROVEP Set CODEID = :NCODEID where CODEID = :param1');
    parambyname('param1').AsString  := FOCODE;
    parambyname('NCODEID').AsString := FNCODE;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update ZHITEMS_APPROVED Set CODEID = :NCODEID where CODEID = :param1');
    parambyname('param1').AsString  := FOCODE;
    parambyname('NCODEID').AsString := FNCODE;
    ExecSQL;
  end;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update ZHITEMS_DOCRETURN Set CODEID = :NCODEID where CODEID = :param1');
    parambyname('param1').AsString  := FOCODE;
    parambyname('NCODEID').AsString := FNCODE;
    ExecSQL;
  end;
end;

procedure TTrouble_Frm.Update_TroubleTemp_approved_Field;
var
  li,lc : integer;
  LStr : String;
  LCODE : String;
  LClass : String;
  LName :  String;
  LInfo : Array[0..4] of String;
  Lboolean : Boolean;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from ZHITEMS_APPROVER order by CODEID');
    Open;

    if not(RecordCount = 0) then
    begin
      for li := 0 to RecordCount-1 do
      begin
        caption := IntToStr(li+1);
        LCODE := Fieldbyname('CODEID').AsString;
        for lc := 0 to 4 do
        begin
          LStr := Fields[3+lc].AsString;

          if not(LStr = '') then
          begin
            with DM1.TQuery2 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('select * from HITEMS.HITEMS_USER where UserID = :param1');
              parambyname('param1').AsString := LStr;
              Open;

              if not(RecordCount = 0) then
              begin
                LName := Fieldbyname('Name_Kor').AsString;
                LClass := Fieldbyname('CLASS').AsString;
                LClass := Check_for_CODENM_Base_on_CODE(LClass);
                LInfo[lc] := LClass+'/'+LNAME;
              end;
            end;
          end
          else
            LInfo[lc] := '';
        end;

        LBoolean := False;
        with DM1.TQuery2 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from TROUBLE_Data where CODEID = :param1');
          parambyname('param1').AsString := LCODE;
          Open;

          if not(RecordCount = 0) then
            LBoolean := True;
        end;

        if LBoolean = True then
        begin
          with DM1.TQuery2 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('Update TROUBLE_Data Set');
            SQL.Add(' APPROVED1 = :APPROVED1, APPROVED2 = :APPROVED2,');
            SQL.Add(' APPROVED3 = :APPROVED3, APPROVED4 = :APPROVED4, APPROVED5 = :APPROVED5');            
            SQL.Add(' where CodeID = :Param1');      

            parambyname('param1').AsString := LCODE;
        
            parambyname('APPROVED1').AsString := LInfo[0];
            parambyname('APPROVED2').AsString := LInfo[1];
            parambyname('APPROVED3').AsString := LInfo[2];
            parambyname('APPROVED4').AsString := LInfo[3];
            parambyname('APPROVED5').AsString := LInfo[4];

            ExecSQL;
          end;      
        end;
        Next;        
      end;
    end;
  end;
end;

procedure TTrouble_Frm.Upload_Files_within_FileGrid(Flag, Fpath, FNm, Fsize, Fext: String);
var
  Lint : Int64;
  FS : TFileStream;
  LDate : TDateTime;
  LStr, LStr1 : String;
  LMS : TMemoryStream;
  LInBmp : TBitmap;
  LOutBmp : TBitmap;
  LJpgImage : TJpegImage;
begin
  with DM1.OraStoredProc1 do
  begin
    Options.TemporaryLobUpdate := True;
    StoredProcName := 'HSH_Trouble_Attfiles_Insert';
    Prepare;
    Parambyname('I_CODEID').AsString := CODEID.Text;
    Parambyname('I_ATTFLAG').AsString := Flag;

    LDate := Now;
    Lint := DateTimeToMilliseconds(LDate);

    Parambyname('I_DBFILENAME').AsString := IntToStr(Lint)+'.'+UpperCase(Fext);
    Parambyname('I_LCFILENAME').AsString := ExtractFileName(Fnm);

    LStr := UpperCase(Fext);
    LStr1 := GetToken(LStr,'.');

    parambyname('I_FILEEXT').AsString    := Fext;

    if Flag = 'I' then
    begin
      try
        LMS := TMemoryStream.Create;
        LMS.Position := 0;
        LInBmp := TBitmap.Create;
        LOutBmp := TBitmap.Create;
        LJpgImage := TJpegImage.Create;
        if Fext = 'BMP' then
        begin
          LInBmp.LoadFromFile(FPath);
          ResizeBitmap( LInBmp, LOutBmp, 1024, 768 );
          LOutBmp.SaveToStream(LMS);
        end;

        if (Fext = 'JPG') or (Fext = 'JPEG') then
        begin
          LJpgImage.LoadFromFile(FPath);
          ResizeJPEG( LJpgImage, 1024, 768 );
          LJpgImage.SaveToStream(LMS);
        end;

        parambyname('I_FILESIZE').AsString   := IntToStr(LMS.Size);
        parambyname('I_FILES').ParamType := ptInput;
        parambyname('I_FILES').AsOraBlob.LoadFromStream(LMS);
        parambyname('I_INDATE').AsDateTime := LDate;
        Execute;
      finally
        LMS.Free;
        LInBmp.Free;
        LoutBmp.Free;
        LJpgImage.Free;
      end;
    end
    else
    begin
      try
        FS := TFileStream.Create(Fpath,fmShareDenyNone);
        FS.Position := 0;
        parambyname('I_FILESIZE').AsString   := Fsize;
        parambyname('I_FILES').ParamType := ptInput;
        parambyname('I_FILES').AsOraBlob.LoadFromStream(FS);
        parambyname('I_INDATE').AsDateTime := LDate;
        Execute;
      finally
        FS.Free;
      end;
    end;
    DM1.TSession1.Commit;
  end;
end;

end.
