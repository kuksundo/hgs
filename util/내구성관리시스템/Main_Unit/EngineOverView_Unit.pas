unit EngineOverView_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvCircularProgress,
  Vcl.Menus, Vcl.ExtCtrls, iPipeJoint, iMotor, iComponent,
  iVCLComponent, iCustomComponent, iPipe, ShadowButton, JvExControls, JvLabel,
  Vcl.Imaging.jpeg, AdvScrollBox, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, JvAnimatedImage,
  JvGIFCtrl, AdvPageControl, Vcl.ImgList,
  Vcl.Grids, Vcl.Outline, NxColumnList,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  NxColumnClasses, NxColumns, Data.DB, Data.Win.ADODB,System.DateUtils, PMSOverViewClass,
  UnitTagCollect, UnitMongoDBManager, SynCommons, HiMECSConst;

type
  TEngineOverView_Frm = class(TForm)
    AdvScrollBox1: TAdvScrollBox;
    CE0081: TImage;
    CE0079: TImage;
    CE0089: TImage;
    CE0094: TImage;
    CE0102: TImage;
    CE0080: TImage;
    CE0086: TImage;
    CE0082: TImage;
    CE0083: TImage;
    CE0084: TImage;
    CE0090: TImage;
    CE0088: TImage;
    CE0091: TImage;
    CE0087: TImage;
    CE0097: TImage;
    CE0096: TImage;
    CE0095: TImage;
    CE0093: TImage;
    CE0092: TImage;
    CE0099: TImage;
    CE0103: TImage;
    CE0101: TImage;
    CE0104: TImage;
    CE0100: TImage;
    CE0105: TImage;
    CE0106: TImage;
    CE0107: TImage;
    CE0085: TImage;
    CE0098: TImage;
    CE0108: TImage;
    JvLabel10: TJvLabel;
    JvLabel11: TJvLabel;
    JvLabel12: TJvLabel;
    JvLabel13: TJvLabel;
    JvLabel14: TJvLabel;
    JvLabel15: TJvLabel;
    JvLabel16: TJvLabel;
    JvLabel17: TJvLabel;
    JvLabel20: TJvLabel;
    JvLabel21: TJvLabel;
    JvLabel22: TJvLabel;
    JvLabel23: TJvLabel;
    JvLabel24: TJvLabel;
    JvLabel25: TJvLabel;
    JvLabel26: TJvLabel;
    JvLabel27: TJvLabel;
    JvLabel28: TJvLabel;
    JvLabel29: TJvLabel;
    JvLabel30: TJvLabel;
    JvLabel31: TJvLabel;
    JvLabel32: TJvLabel;
    JvLabel33: TJvLabel;
    JvLabel36: TJvLabel;
    JvLabel37: TJvLabel;
    JvLabel38: TJvLabel;
    JvLabel39: TJvLabel;
    JvLabel40: TJvLabel;
    JvLabel41: TJvLabel;
    JvLabel42: TJvLabel;
    JvLabel43: TJvLabel;
    JvLabel18: TJvLabel;
    JvLabel19: TJvLabel;
    JvLabel44: TJvLabel;
    JvLabel45: TJvLabel;
    JvLabel46: TJvLabel;
    JvLabel47: TJvLabel;
    JvLabel48: TJvLabel;
    JvLabel49: TJvLabel;
    JvLabel50: TJvLabel;
    JvLabel53: TJvLabel;
    JvLabel54: TJvLabel;
    JvLabel55: TJvLabel;
    JvLabel56: TJvLabel;
    JvLabel57: TJvLabel;
    JvLabel58: TJvLabel;
    JvLabel59: TJvLabel;
    JvLabel60: TJvLabel;
    JvLabel61: TJvLabel;
    JvLabel62: TJvLabel;
    JvLabel63: TJvLabel;
    JvLabel64: TJvLabel;
    iPipe28: TiPipe;
    iPipe30: TiPipe;
    iPipe1: TiPipe;
    iMotor1: TiMotor;
    iPipe50: TiPipe;
    iPipe31: TiPipe;
    iPipe2: TiPipe;
    iPipe3: TiPipe;
    H25VBtn: TButton;
    iPipeJoint1: TiPipeJoint;
    iPipeJoint2: TiPipeJoint;
    iPipe6: TiPipe;
    iPipe7: TiPipe;
    iPipe8: TiPipe;
    iMotor2: TiMotor;
    iPipe10: TiPipe;
    iPipe12: TiPipe;
    iPipe13: TiPipe;
    iPipe14: TiPipe;
    H17UBtn: TButton;
    iPipeJoint3: TiPipeJoint;
    iPipeJoint4: TiPipeJoint;
    iPipe15: TiPipe;
    iPipe18: TiPipe;
    iPipe19: TiPipe;
    iMotor3: TiMotor;
    iPipe21: TiPipe;
    iPipe23: TiPipe;
    iPipe24: TiPipe;
    iPipe51: TiPipe;
    Button9: TButton;
    iPipeJoint5: TiPipeJoint;
    iPipeJoint6: TiPipeJoint;
    iPipe54: TiPipe;
    iPipe55: TiPipe;
    iPipe56: TiPipe;
    iMotor4: TiMotor;
    iPipe58: TiPipe;
    iPipe60: TiPipe;
    iPipe61: TiPipe;
    iPipe62: TiPipe;
    Button11: TButton;
    iPipeJoint7: TiPipeJoint;
    iPipeJoint8: TiPipeJoint;
    iPipe63: TiPipe;
    iPipe27: TiPipe;
    iMotor5: TiMotor;
    iPipe32: TiPipe;
    Button7: TButton;
    iPipe39: TiPipe;
    iMotor6: TiMotor;
    Button13: TButton;
    iMotor7: TiMotor;
    Button15: TButton;
    iPipe16: TiPipe;
    iPipeJoint16: TiPipeJoint;
    iPipe17: TiPipe;
    iPipeJoint18: TiPipeJoint;
    iPipe29: TiPipe;
    iPipe70: TiPipe;
    iPipe38: TiPipe;
    iPipe5: TiPipe;
    iPipe25: TiPipe;
    iPipe52: TiPipe;
    iPipeJoint15: TiPipeJoint;
    iPipe4: TiPipe;
    iPipeJoint17: TiPipeJoint;
    iPipe9: TiPipe;
    iPipe20: TiPipe;
    iPipe53: TiPipe;
    iPipe26: TiPipe;
    iPipe48: TiPipe;
    iPipeJoint24: TiPipeJoint;
    iPipe33: TiPipe;
    iPipe44: TiPipe;
    iPipe72: TiPipe;
    iPipe74: TiPipe;
    iPipe75: TiPipe;
    iPipe76: TiPipe;
    iPipe77: TiPipe;
    iPipe79: TiPipe;
    iPipe80: TiPipe;
    iPipe81: TiPipe;
    iPipe82: TiPipe;
    iPipe78: TiPipe;
    iPipe83: TiPipe;
    iPipe84: TiPipe;
    iPipe85: TiPipe;
    iPipe86: TiPipe;
    CE0121: TImage;
    iPipe87: TiPipe;
    CN0122: TImage;
    iPipe88: TiPipe;
    iPipe89: TiPipe;
    iPipe90: TiPipe;
    iPipe91: TiPipe;
    iPipe92: TiPipe;
    iPipe93: TiPipe;
    JvLabel65: TJvLabel;
    JvLabel66: TJvLabel;
    iPipe106: TiPipe;
    Image28: TImage;
    Image27: TImage;
    Image29: TImage;
    iPipe104: TiPipe;
    iPipe107: TiPipe;
    Bevel1: TBevel;
    Button14: TButton;
    Button16: TButton;
    Panel3: TPanel;
    Panel9: TPanel;
    Panel11: TPanel;
    H25VHzPnl: TPanel;
    Panel14: TPanel;
    Panel17: TPanel;
    H25VPFPnl: TPanel;
    JvLabel34: TJvLabel;
    JvLabel35: TJvLabel;
    JvLabel51: TJvLabel;
    JvLabel52: TJvLabel;
    JvLabel67: TJvLabel;
    JvLabel68: TJvLabel;
    JvLabel69: TJvLabel;
    JvLabel70: TJvLabel;
    JvLabel71: TJvLabel;
    JvLabel72: TJvLabel;
    JvLabel73: TJvLabel;
    JvLabel74: TJvLabel;
    JvLabel75: TJvLabel;
    JvLabel76: TJvLabel;
    JvLabel77: TJvLabel;
    JvLabel78: TJvLabel;
    JvLabel79: TJvLabel;
    JvLabel81: TJvLabel;
    JvLabel82: TJvLabel;
    JvLabel80: TJvLabel;
    JvLabel83: TJvLabel;
    JvLabel84: TJvLabel;
    JvLabel85: TJvLabel;
    JvLabel86: TJvLabel;
    JvLabel87: TJvLabel;
    JvLabel89: TJvLabel;
    JvLabel88: TJvLabel;
    JvLabel90: TJvLabel;
    JvLabel91: TJvLabel;
    JvLabel92: TJvLabel;
    JvLabel93: TJvLabel;
    JvLabel94: TJvLabel;
    JvLabel95: TJvLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    Timer4: TTimer;
    JvLabel97: TJvLabel;
    JvLabel96: TJvLabel;
    iPipe108: TiPipe;
    JvLabel98: TJvLabel;
    JvLabel99: TJvLabel;
    JvLabel100: TJvLabel;
    JvLabel101: TJvLabel;
    JvLabel102: TJvLabel;
    JvLabel103: TJvLabel;
    JvLabel104: TJvLabel;
    JvLabel105: TJvLabel;
    JvLabel106: TJvLabel;
    JvLabel107: TJvLabel;
    JvLabel108: TJvLabel;
    JvLabel109: TJvLabel;
    JvLabel110: TJvLabel;
    JvLabel111: TJvLabel;
    JvLabel112: TJvLabel;
    JvLabel113: TJvLabel;
    JvLabel114: TJvLabel;
    JvLabel115: TJvLabel;
    JvLabel116: TJvLabel;
    JvLabel117: TJvLabel;
    JvLabel118: TJvLabel;
    JvLabel119: TJvLabel;
    JvLabel120: TJvLabel;
    JvLabel121: TJvLabel;
    JvLabel122: TJvLabel;
    CN0061: TShadowButton;
    ShadowButton1: TShadowButton;
    ShadowButton2: TShadowButton;
    ShadowButton3: TShadowButton;
    PopupMenu1: TPopupMenu;
    SetUnitID2TagList1: TMenuItem;
    iPipe11: TiPipe;
    GetTagListFromMongoDB1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Save2PMSTree1: TMenuItem;
    GetTagValueFromMongoDB1: TMenuItem;
    Panel46: TPanel;
    Panel47: TPanel;
    Panel48: TPanel;
    Panel49: TPanel;
    InComP1ActivePnl: TPanel;
    Panel51: TPanel;
    Panel52: TPanel;
    InComP1ReActivePnl: TPanel;
    Panel54: TPanel;
    Panel50: TPanel;
    Panel53: TPanel;
    Panel77: TPanel;
    Panel80: TPanel;
    Panel86: TPanel;
    Panel89: TPanel;
    InComP2ActivePnl: TPanel;
    Panel92: TPanel;
    Panel93: TPanel;
    Panel94: TPanel;
    InComP2ReActivePnl: TPanel;
    Panel96: TPanel;
    Panel97: TPanel;
    Panel73: TPanel;
    Panel74: TPanel;
    Panel75: TPanel;
    Panel76: TPanel;
    InComP3ActivePnl: TPanel;
    Panel79: TPanel;
    Panel81: TPanel;
    Panel82: TPanel;
    InComP3ReActivePnl: TPanel;
    Panel84: TPanel;
    Panel85: TPanel;
    Panel7: TPanel;
    Panel4: TPanel;
    Panel78: TPanel;
    H25VkWpnl: TPanel;
    Panel87: TPanel;
    Panel88: TPanel;
    H25Vkvarpnl: TPanel;
    Panel91: TPanel;
    Panel95: TPanel;
    H25Vvpnl: TPanel;
    Panel99: TPanel;
    Panel100: TPanel;
    H25VApnl: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel5: TPanel;
    H17UHzPnl: TPanel;
    Panel8: TPanel;
    Panel10: TPanel;
    H17UPFPnl: TPanel;
    Panel13: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    H17UkWpnl: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    H17Ukvarpnl: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    H17Uvpnl: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    H17UApnl: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    H2017HzPnl: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    H2017PFPnl: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel37: TPanel;
    H2017kWpnl: TPanel;
    Panel39: TPanel;
    Panel40: TPanel;
    H2017kvarpnl: TPanel;
    Panel42: TPanel;
    Panel43: TPanel;
    H2017vpnl: TPanel;
    Panel45: TPanel;
    Panel83: TPanel;
    H2017Apnl: TPanel;
    Panel98: TPanel;
    Panel101: TPanel;
    Panel102: TPanel;
    H1217HzPnl: TPanel;
    Panel104: TPanel;
    Panel105: TPanel;
    H1217PFPnl: TPanel;
    Panel107: TPanel;
    Panel108: TPanel;
    Panel109: TPanel;
    H1217kWpnl: TPanel;
    Panel111: TPanel;
    Panel112: TPanel;
    H1217kvarpnl: TPanel;
    Panel114: TPanel;
    Panel115: TPanel;
    H1217vpnl: TPanel;
    Panel117: TPanel;
    Panel118: TPanel;
    H1217Apnl: TPanel;
    Panel120: TPanel;
    Panel121: TPanel;
    Panel122: TPanel;
    H1832HzPnl: TPanel;
    Panel124: TPanel;
    Panel125: TPanel;
    H1832PFPnl: TPanel;
    Panel127: TPanel;
    Panel128: TPanel;
    Panel129: TPanel;
    H1832kWpnl: TPanel;
    Panel131: TPanel;
    Panel132: TPanel;
    H1832kvarpnl: TPanel;
    Panel134: TPanel;
    Panel135: TPanel;
    H1832vpnl: TPanel;
    Panel137: TPanel;
    Panel138: TPanel;
    H1832Apnl: TPanel;
    Panel55: TPanel;
    Panel56: TPanel;
    Panel57: TPanel;
    H2032HzPnl: TPanel;
    Panel59: TPanel;
    Panel60: TPanel;
    H2032PFPnl: TPanel;
    Panel62: TPanel;
    Panel63: TPanel;
    Panel64: TPanel;
    H2032kWpnl: TPanel;
    Panel66: TPanel;
    Panel67: TPanel;
    H2032kvarpnl: TPanel;
    Panel69: TPanel;
    Panel70: TPanel;
    H2032vpnl: TPanel;
    Panel72: TPanel;
    Panel140: TPanel;
    H2032Apnl: TPanel;
    Panel6: TPanel;
    Panel12: TPanel;
    Panel18: TPanel;
    H46HzPnl: TPanel;
    Panel24: TPanel;
    Panel27: TPanel;
    H46PFPnl: TPanel;
    Panel34: TPanel;
    Panel38: TPanel;
    Panel41: TPanel;
    H46kvarpnl: TPanel;
    Panel58: TPanel;
    Panel61: TPanel;
    H46kWpnl: TPanel;
    Panel68: TPanel;
    Panel71: TPanel;
    H46vpnl: TPanel;
    Panel103: TPanel;
    Panel106: TPanel;
    H46Apnl: TPanel;
    Panel21: TPanel;
    Panel31: TPanel;
    Panel44: TPanel;
    Panel65: TPanel;
    F1kWpnl: TPanel;
    Panel113: TPanel;
    Panel116: TPanel;
    F1Vpnl: TPanel;
    Panel126: TPanel;
    Panel110: TPanel;
    Panel123: TPanel;
    Panel130: TPanel;
    Panel133: TPanel;
    F2kWpnl: TPanel;
    Panel139: TPanel;
    Panel141: TPanel;
    F2Vpnl: TPanel;
    Panel143: TPanel;
    Panel144: TPanel;
    Panel145: TPanel;
    Panel146: TPanel;
    Panel147: TPanel;
    F3kWpnl: TPanel;
    Panel149: TPanel;
    Panel150: TPanel;
    F3Vpnl: TPanel;
    Panel152: TPanel;
    Panel90: TPanel;
    Panel119: TPanel;
    Panel136: TPanel;
    iPipe22: TiPipe;
    iPipe40: TiPipe;
    iPipe41: TiPipe;
    iPipeJoint10: TiPipeJoint;
    iPipeJoint11: TiPipeJoint;
    iPipeJoint20: TiPipeJoint;
    iPipe42: TiPipe;
    iPipe43: TiPipe;
    iPipeJoint12: TiPipeJoint;
    iPipeJoint21: TiPipeJoint;
    iPipe45: TiPipe;
    ShadowButton4: TShadowButton;
    CE0111: TImage;
    CE0109: TImage;
    iPipe34: TiPipe;
    iPipe35: TiPipe;
    CE0110: TImage;
    iPipe96: TiPipe;
    iPipe47: TiPipe;
    CE0112: TImage;
    iPipe105: TiPipe;
    iPipeJoint9: TiPipeJoint;
    JvLabel141: TJvLabel;
    JvLabel142: TJvLabel;
    JvLabel143: TJvLabel;
    JvLabel144: TJvLabel;
    JvLabel145: TJvLabel;
    JvLabel146: TJvLabel;
    JvLabel147: TJvLabel;
    JvLabel148: TJvLabel;
    JvLabel149: TJvLabel;
    iPipe46: TiPipe;
    iPipe57: TiPipe;
    ShadowButton7: TShadowButton;
    CE0115: TImage;
    CE0113: TImage;
    iPipe97: TiPipe;
    CE0114: TImage;
    iPipe98: TiPipe;
    iPipe99: TiPipe;
    JvLabel150: TJvLabel;
    JvLabel151: TJvLabel;
    JvLabel152: TJvLabel;
    JvLabel153: TJvLabel;
    JvLabel154: TJvLabel;
    JvLabel155: TJvLabel;
    JvLabel156: TJvLabel;
    JvLabel157: TJvLabel;
    JvLabel158: TJvLabel;
    iPipe100: TiPipe;
    ShadowButton8: TShadowButton;
    CE0118: TImage;
    CE0116: TImage;
    iPipe101: TiPipe;
    CE0117: TImage;
    iPipe102: TiPipe;
    iPipe103: TiPipe;
    JvLabel159: TJvLabel;
    JvLabel160: TJvLabel;
    JvLabel161: TJvLabel;
    JvLabel162: TJvLabel;
    JvLabel163: TJvLabel;
    JvLabel164: TJvLabel;
    JvLabel165: TJvLabel;
    JvLabel166: TJvLabel;
    JvLabel167: TJvLabel;
    iPipeJoint13: TiPipeJoint;
    iPipeJoint14: TiPipeJoint;
    iPipeJoint22: TiPipeJoint;
    iPipeJoint23: TiPipeJoint;
    iPipe36: TiPipe;
    iPipeJoint25: TiPipeJoint;
    Factory1Panel: TPanel;
    Factory2Panel: TPanel;
    Factory3Panel: TPanel;
    iPipe37: TiPipe;
    N1: TMenuItem;
    ShowElecPriceTable1: TMenuItem;
    Panel157: TPanel;
    H17Ukwhpnl: TPanel;
    Panel163: TPanel;
    Panel164: TPanel;
    H17UPricePnl: TPanel;
    Panel166: TPanel;
    Panel167: TPanel;
    H25Vkwhpnl: TPanel;
    Panel169: TPanel;
    Panel170: TPanel;
    H25VPricePnl: TPanel;
    Panel172: TPanel;
    Panel173: TPanel;
    H1217Vkwhpnl: TPanel;
    Panel175: TPanel;
    Panel176: TPanel;
    H1217VPricePnl: TPanel;
    Panel178: TPanel;
    Panel179: TPanel;
    H2017Vkwhpnl: TPanel;
    Panel181: TPanel;
    Panel182: TPanel;
    H2017VPricePnl: TPanel;
    Panel184: TPanel;
    procedure Button4Click(Sender: TObject);
    procedure H25VBtnClick(Sender: TObject);
    procedure CE0082Click(Sender: TObject);
    procedure CE0081Click(Sender: TObject);
    procedure CE0119Click(Sender: TObject);
    procedure CE0121Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure SetUnitID2TagList1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GetTagListFromMongoDB1Click(Sender: TObject);
    procedure Save2PMSTree1Click(Sender: TObject);
    procedure GetOPCTagValueFromMongoDB1Click(Sender: TObject);
    procedure CE0110Click(Sender: TObject);
    procedure Factory1PanelClick(Sender: TObject);
    procedure ShowElecPriceTable1Click(Sender: TObject);
    procedure Factory2PanelClick(Sender: TObject);
  private
    FPMSOverViewTree: TPMSOverViewBase;//Circuit Breaker 및 pipe 관련 Tag만 저장 됨.
    FTagList: TTagCollect; //PMS의 모든 tag가 저장됨.
    FMongoDBManager: TMongoDBManager;
    FTreeView: TTreeView;
    FResultMongoDB:Variant;
  public
    procedure Get_OnOffImage(RS:String;Im:TImage);
    procedure SetUnitID2TagList;
    procedure SetMonitoringData;
    procedure SetMonitoringData2;
    procedure SetVCBOnOf(Ai, Aj: integer);
    function SetVCBOnOff(ACompName, AValue: string; AHiMAPType:THiMAPType;
      var AGroupNo: integer; ABitIndex:integer = -1): Bool;
    function SetGeneratorOnOff(ACompName, AValue: string; AHiMAPType:THiMAPType;
      var AGenNo: integer; ABitIndex:integer = -1): Bool;
    procedure SetTROnOff(ACompName: string; AOn: Boolean);
    procedure SetElecLine2(ACompName: string; AOn, AReverse: Boolean);
    procedure GetTagListFromMongoDB;
    procedure Save2PMSTree;
    procedure GetOPCTagValueFromMongoDB;
    procedure GetOPCTagValueFromMongoDB2;
    procedure TraverseDFSTreeView(ATreeView: TTreeView);

    procedure SetPMSAnalogData(ADoc: variant);
    procedure SetPMSDigitalData(ADoc: variant);
    procedure GetEngBaseInfo;
    procedure CalcEngLoad(AkW: integer; ABtn: TButton);

    procedure ShowGridView(ADocs: TVariantDynArray);
    procedure CalcDailykwh(AMongoCollectName: string; var ADocs: TVariantDynArray);
  end;

var
  EngineOverView_Frm: TEngineOverView_Frm;

implementation

uses
  DataModule_Unit,
  Network_Sub_Unit,
  engView2_Unit,
  Panel_Unit,
  CommonUtil_Unit,
  UnitGridView;

{$R *.dfm}

procedure TEngineOverView_Frm.Button4Click(Sender: TObject);
var
  LHint : String;
begin  if Sender is TBUTTON then
  begin
    with TBUTTON(Sender) do
    begin
      lHint := Hint;
      try
        if Create_Network_Sub_Frm(LHint) then
        begin

        end;
      finally
      end;
    end;
  end;
end;

procedure TEngineOverView_Frm.H25VBtnClick(Sender: TObject);
var
  LHint : String;
begin  if Sender is TBUTTON then
  begin
    with TBUTTON(Sender) do
    begin
      LHint := Tbutton(Sender).Hint;
      try
        if Create_engView2_Frm(LHint) then
        begin

        end;
      finally
      end;
    end;
  end;
end;

//TagList를 mongoDB로부터 가져와서 FPMSOverViewTree에 TagIndex 값을 저장함
procedure TEngineOverView_Frm.GetTagListFromMongoDB;
var
  LDocs: TVariantDynArray;
  i,j: integer;
begin
  if FMongoDBManager.ConnectDB then
  begin
    FMongoDBManager.FMongoCollectionName := 'PMS_OPC_DIGITAL_META';

    if FMongoDBManager.SelectAllDBData(LDocs) then
    begin
      for i := 0 to High(LDocs) do
      begin
        if LDocs[i].TagName = '' then
          continue;

        with FTagList.Add do
        begin
          TagName := LDocs[i].TagName;
          TagDesc := LDocs[i].Desc;

          for j := 0 to FPMSOverViewTree.FPMSOverViewCollect.Count - 1 do
          begin
            if FPMSOverViewTree.FPMSOverViewCollect.Items[j].TagName = LDocs[i].TagName then
            begin
              FPMSOverViewTree.FPMSOverViewCollect.Items[j].TagIndex := LDocs[i].TagIndex+2;
              break;
            end;
          end;
        end;//with
      end;//for
    end;//if

    LDocs := nil;
  end;
end;

procedure TEngineOverView_Frm.GetTagListFromMongoDB1Click(Sender: TObject);
begin
  GetTagListFromMongoDB;
end;

procedure TEngineOverView_Frm.CalcDailykwh(AMongoCollectName: string;
  var ADocs: TVariantDynArray);
var
//  LDocs: TVariantDynArray;
  LQry: string;
  LFromtm, LToTm: TDateTime;
  LYear, LMonth, LDay: word;
  LHour, LMin, LSec, LMSec: word;
begin
  if FMongoDBManager.ConnectDB then
  begin
    FMongoDBManager.FMongoCollectionName := AMongoCollectName;
//    LQry := '{$group:{_id:"$SavedTime",kwh:{$avg:"$V9"}}}';
//    LQry := '{$project:{userid: "$_id","_id":0}}';
    LQry := '{$project:{"SavedTime":1,"V9":1,"V266":1,"V609":1,"V861":1,"_id":0}},{$match:{SavedTime:{$gt:?, $lt:?}}}';  //
//    LQry := '{$project:{"SavedTime":1,"V9":1,"_id":0}},{$match:{SavedTime:{$gt:?, $lt:?}, V9:{$gt:?}}}';
//    LQry := '{$match:{SavedTime:{$gt:?, $lt:?}}}, {$group:{_id:{$hour:"$SavedTime"},kwh:{$sum:"$V9"}, min:{$min: "$V9"}, max:{$max: "$V9"}, count:{$sum:1}}}';
//    LQry := '{$match:{SavedTime:{$gt:?, $lt:?}}}, {$group:{_id:{$hour:"$SavedTime"}, kwh:{$sum:"$V9"}, min:{$min: "$V9"}, max:{$max: "$V9"}}}';

//    LQry := '{$project:{h:{$hour:"$SavedTime"}}},{$group:{_id:"$SavedTime",kwh:{$avg:"$V9"}}}';
//    LQry := '{$sort:{_id:-1}},{$limit:5}';
//
    LFromtm := now-1;
    DecodeDateTime(LFromtm, LYear, LMonth, LDay, LHour, LMin, LSec, LMsec);
    LHour := 0;
    LMin := 0;
    LSec := 0;
    LMsec := 0;
    LFromTm := EncodeDateTime(LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);
    LFromTm := TTimeZone.Local.ToUniversalTime(LFromTm);

    LTotm := now-1;
    DecodeDateTime(LTotm, LYear, LMonth, LDay, LHour, LMin, LSec, LMsec);
    LHour := 23;
    LMin := 59;
    LSec := 59;
    LTotm := EncodeDateTime(LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);
    LTotm := TTimeZone.Local.ToUniversalTime(LTotm);

    FMongoDBManager.AggreateDocFromQry(ADocs, LQry, [DateTimeToIso8601(LFromtm, True), DateTimeToIso8601(LTotm, True)]);
    ShowGridView(ADocs);
//    FMongoDBManager.AggreateDocFromQry(ADocs, LQry, []);
  end;
end;

procedure TEngineOverView_Frm.GetEngBaseInfo;
var
  LDocs: TVariantDynArray;
  i: integer;
begin
  if FMongoDBManager.ConnectDB then
  begin
    FMongoDBManager.FMongoCollectionName := 'PMS_ENG_BASE_INFO';

    if FMongoDBManager.SelectAllDBData(LDocs) then
    begin
      for i := 0 to High(LDocs) do
      begin
        if LDocs[i].EngType = '18H25V' then
        begin
          H25VBtn.tag := LDocs[i].MCR_kW;
          H25VBtn.Hint := 'MCR kW = ' + IntToStr(H25VBtn.tag);
        end
        else
        if LDocs[i].EngType = '6H17U' then
        begin
          H17UBtn.tag := LDocs[i].MCR_kW;
          H17UBtn.Hint := 'MCR kW = ' + IntToStr(H17UBtn.tag);
        end;
      end;//for
    end;//if
  end;//if

end;

procedure TEngineOverView_Frm.GetOPCTagValueFromMongoDB;
var
  LDoc: Variant;
  LDoc2: Variant;
  LStr: string;
//  LDoc2: Variant;
//  LUtf8: RawUTF8;
begin
  if FMongoDBManager.ConnectDB then
  begin
//    FMongoDBManager.FMongoCollectionName := 'PMS_COLL';
    FMongoDBManager.FMongoCollectionName := 'PMS_OPC_DIGITAL';
    FResultMongoDB := FMongoDBManager.SelectDBDataLatest(LDoc);

    if FResultMongoDB <> Null then
    begin
      SetPMSDigitalData(LDoc);
    end;//if

    FMongoDBManager.FMongoCollectionName := 'PMS_OPC_ANALOG';
    FResultMongoDB := FMongoDBManager.SelectDBDataLatest(LDoc2);

    if FResultMongoDB <> Null then
    begin
      SetPMSAnalogData(LDoc2);
    end;
  end;
end;

procedure TEngineOverView_Frm.GetOPCTagValueFromMongoDB1Click(Sender: TObject);
begin
  GetOPCTagValueFromMongoDB;
//  GetOPCTagValueFromMongoDB2;
end;

procedure TEngineOverView_Frm.GetOPCTagValueFromMongoDB2;
var
  LDoc: RawUTF8;
  LDoc2: Variant;
  i,j: integer;
  LUtf8: RawUTF8;
begin
  if FMongoDBManager.ConnectDB then
  begin
    FMongoDBManager.FMongoCollectionName := 'PMS_COLL';
    LDoc := '';
    LDoc := FMongoDBManager.SelectDBDataLatest2;

    if LDoc <> '' then
    begin

//      for j := 0 to FPMSOverViewTree.FPMSOverViewCollect.Count - 1 do
//      begin
//        i := FPMSOverViewTree.FPMSOverViewCollect.Items[j].TagIndex;

//        if i > 0 then
//          FPMSOverViewTree.FPMSOverViewCollect.Items[j].TagValue := LArr.;
//      end;//for
//      LUtf8 := VariantSaveJSon(LDoc);
//      LDoc2 := _Json(LDoc);
        LDoc2 := _Json('[{arr:[1,2]}]');
//      for i := 0 to LDoc2._count - 1 do
//        Memo1.Lines.Add(LDoc2.arr);//LDoc2.Name(1) + ',' + LDoc2.Value(1));
    end;//if
  end;//if
end;

procedure TEngineOverView_Frm.Get_OnOffImage(RS: String; Im: TImage);
var
  MyResourceStream: TResourceStream;
  LOnOffImage: TJPEGImage;
begin
  MyResourceStream := TResourceStream.Create(hInstance, RS, RT_RCDATA);
  try
    LOnOffImage := TJPEGImage.Create;
    try
      LOnOffImage.LoadFromStream(MyResourceStream);
      Im.Picture.Graphic := LOnOffImage;
    finally
      LOnOffImage.Free
    end;
  finally
    MyResourceStream.Free
  end;
end;

procedure TEngineOverView_Frm.CalcEngLoad(AkW: integer; ABtn: TButton);
begin
  if ABtn.Tag > 0 then
  begin
    ABtn.Caption := FormatFloat('##### ''%', AkW / ABtn.Tag * 100);
  end;
end;

procedure TEngineOverView_Frm.CE0081Click(Sender: TObject);
var
  lname : String;
begin
  lname := TImage(Sender).Name;
  try
    if Create_Panel_Frm(Lname) then
    begin

    end;
  finally
  end;
end;

procedure TEngineOverView_Frm.CE0082Click(Sender: TObject);
var
  lname : String;
begin
  lname := TImage(Sender).Name;
  try
    if Create_Panel_Frm(Lname) then
    begin

    end;
  finally
  end;
end;

procedure TEngineOverView_Frm.CE0110Click(Sender: TObject);
var
  lname : String;
begin
  lname := TImage(Sender).Name;
  try
    if Create_Panel_Frm(Lname) then
    begin

    end;
  finally
  end;
end;


procedure TEngineOverView_Frm.CE0119Click(Sender: TObject);
var
  lname : String;
begin
  lname := TImage(Sender).Name;
  try
    if Create_Panel_Frm(Lname) then
    begin

    end;
  finally
  end;
end;

procedure TEngineOverView_Frm.CE0121Click(Sender: TObject);
var
  lname : String;
begin
  lname := TImage(Sender).Name;
  try
    if Create_Panel_Frm(Lname) then
    begin

    end;
  finally
  end;
end;


procedure TEngineOverView_Frm.Factory1PanelClick(Sender: TObject);
var
  LDocs: TVariantDynArray;
  LQry: string;
  i,j: integer;
  LVarDocs: variant;
  LFromtm, LToTm: TDateTime;
  LYear, LMonth, LDay: word;
  LHour, LMin, LSec, LMSec: word;
begin
  if FMongoDBManager.ConnectDB then
  begin
    FMongoDBManager.FMongoCollectionName := 'PMS_OPC_ANALOG';
    LQry := '{SavedTime:{$gt:?, $lt:?}}';

    LFromtm := now;
    DecodeDate(LFromtm,LYear, LMonth, LDay);
    LHour := 0;
    LMin := 0;
    LSec := 0;
    LMsec := 0;
    LFromTm := EncodeDateTime(LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);

    LFromTm := TTimeZone.Local.ToUniversalTime(LFromTm);
    LTotm := now;
    DecodeTime(LTotm,LHour, LMin, LSec, LMSec);
    LTotm := TTimeZone.Local.ToUniversalTime(LTotm);
    if FMongoDBManager.FindDocsFromQry(LDocs, LQry, [DateTimeToIso8601(LFromtm, True), DateTimeToIso8601(LTotm, True)]) then
    begin
      ShowGridView(LDocs);
//      for i := 0 to High(LDocs) do
//      begin
//        ShowMessage(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',Iso8601ToDateTime(LDocs[i].SavedTime)) + ' ' + LDocs[i].V1);
//        exit;
//      end;//for
    end;//if

    LDocs := nil;
  end;
end;

procedure TEngineOverView_Frm.Factory2PanelClick(Sender: TObject);
var
  LDocs: TVariantDynArray;
begin
  SetLength(LDocs, 5);
  CalcDailykwh('PMS_OPC_ANALOG', LDocs);
end;

procedure TEngineOverView_Frm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FMongoDBManager.Free;
  FTagList.Free;
  FPMSOverViewTree.Free;
  FTreeView.Free;
end;

procedure TEngineOverView_Frm.FormCreate(Sender: TObject);
begin
  FPMSOverViewTree := TPMSOverViewBase.Create(Self);
  FPMSOverViewTree.LoadFromJSONFile('.\OverViewTree.menu');
  FTagList := TTagCollect.Create;
  FMongoDBManager := TMongoDBManager.Create('10.14.21.117', 'PMS_DB', 'PMS_COLL', 27017);
  FTreeView := TTreeView.Create(self);
  FTreeView.Parent := Self;
  FTreeView.Visible := False;
  FPMSOverViewTree.PMSCollect2TreeView(FTreeView);
  GetTagListFromMongoDB;
  GetEngBaseInfo;
  DM1.GetElecPowerPriceTable;
end;

procedure TEngineOverView_Frm.Save2PMSTree;
var
  LFileName: string;
begin
  if SaveDialog1.Execute then
  begin
    LFileName := SaveDialog1.FileName;

    if FileExists(LFileName) then
    begin
      if MessageDlg('File is already exist. Are you overwrite? if No press, then save is cancelled.',
                                mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        exit
    end
    else
    begin

    end;

    FPMSOverViewTree.SaveToJSONFile(LFileName);
  end;
end;

procedure TEngineOverView_Frm.Save2PMSTree1Click(Sender: TObject);
begin
  Save2PMSTree;
end;

procedure TEngineOverView_Frm.SetElecLine2(ACompName: string; AOn, AReverse: Boolean);
var
  LComp: TComponent;
begin
  LComp := nil;
  LComp := FindComponent(ACompName);

  if Assigned(LComp) then
  begin
    if LComp is TiPipe then
    begin
      TiPipe(LComp).FlowOn := AOn;

//      if TiPipe(LComp).Horizontal then
        TiPipe(LComp).FlowReverse := AReverse;
//      else
//        TiPipe(LComp).FlowReverse := not AReverse;

      if AOn then
      begin
        TiPipe(LComp).TubeColor := clRed;
      end
      else
      begin
        TiPipe(LComp).TubeColor := clBlack;
      end;
    end;
  end;
end;

//AGroupNo: PMS Group No: iMotor.tag에 저장됨
function TEngineOverView_Frm.SetGeneratorOnOff(ACompName, AValue: string;
  AHiMAPType: THiMAPType; var AGenNo: integer; ABitIndex: integer): Bool;
var
  LComp: TComponent;
begin
  Result := False;
  LComp := nil;
  LComp := FindComponent(ACompName);

  if Assigned(LComp) then
  begin
    if LComp is TiMotor then
    begin
      if (AHiMAPType = htBCS) or (AHiMAPType = htFeeder) then//Generator도  HiMAP-F로 설정 됨.
      begin
        Result := IsbitSet(StrToIntDef(AValue,0),ABitIndex);

        TiMotor(LComp).FanOn := Result;
        AGenNo := TiMotor(LComp).Tag;
      end;
    end;
  end;
end;

procedure TEngineOverView_Frm.SetMonitoringData;
var
  i,j: integer;
begin
//  for i := 0 to PMSOPCClientF.FTagList.Count - 1 do
//  begin
//    if PMSOPCClientF.FTagList.Item[i].UnitID = '' then
//      continue;
//
//    for j := 0 to ComponentCount - 1 do
//    begin
//      SetVCBOnOf(i,j);
//    end;
//  end;
  SetMonitoringData2;
end;

procedure TEngineOverView_Frm.SetMonitoringData2;
begin
  GetOPCTagValueFromMongoDB;
  TraverseDFSTreeView(FTreeView);
end;

procedure TEngineOverView_Frm.SetPMSAnalogData(ADoc: variant);
var
  LStr: string;
  j: integer;
  Ld: double;
begin
  Caption := Utf8ToString(VariantToUtf8(ADoc.SavedTime));
//  Caption := FormatDateTime('yyyy-mm-dd hh:nn:ss',Iso8601ToDateTime(ADoc.SavedTime));
  LStr := Utf8ToString(VariantToUtf8(ADoc.V520)); //InComing #1 kW
  j := Round(StrToFloatDef(LStr,0.0));
  InComP1ActivePnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V521));//InComing #1 kVAR
  j := Round(StrToFloatDef(LStr,0.0));
  InComP1ReActivePnl.Caption :=  FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1068)); //InComing #2 kW
  j := Round(StrToFloatDef(LStr,0.0));
  InComP2ActivePnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1069)); //InComing #2 kVAR
  j := Round(StrToFloatDef(LStr,0.0));
  InComP2ReActivePnl.Caption :=  FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1087)); //InComing #3 kW
  j := Round(StrToFloatDef(LStr,0.0));
  InComP3ActivePnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1088)); //InComing #3 kVAR
  j := Round(StrToFloatDef(LStr,0.0));
  InComP3ReActivePnl.Caption :=  FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1)); //VCB-G2 V-AB
  j := Round(StrToFloatDef(LStr,0.0));
  H25Vvpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V4)); //VCB-G2 I-AB
  j := Round(StrToFloatDef(LStr,0.0));
  H25VApnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V7)); //VCB-G2 PF(%)
  j := Round(StrToFloatDef(LStr,0.0));
  H25VPFPnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V8)); //VCB-G2 Hz
  j := Round(StrToFloatDef(LStr,0.0));
  H25VHzPnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V9)); //VCB-G2 kW
  Ld := StrToFloatDef(LStr,0.0);
  DM1.FElecPowerCalcBase.SetVCBG2kW(Ld);
  j := Round(Ld);
  H25VkWpnl.Caption := FormatCurr('#,##0', j);
  CalcEngLoad(j,H25VBtn);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V10)); //VCB-G2 kvar
  j := Round(StrToFloatDef(LStr,0.0));
  H25Vkvarpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V258)); //VCB-G4 V-AB
  j := Round(StrToFloatDef(LStr,0.0));
  H17Uvpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V261)); //VCB-G4 I-AB
  j := Round(StrToFloatDef(LStr,0.0));
  H17UApnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V264)); //VCB-G4 PF(%)
  j := Round(StrToFloatDef(LStr,0.0));
  H17UPFPnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V265)); //VCB-G4 Hz
  j := Round(StrToFloatDef(LStr,0.0));
  H17UHzPnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V266)); //VCB-G4 kW
  Ld := StrToFloatDef(LStr,0.0);
  DM1.FElecPowerCalcBase.SetACBG4kW(Ld);
  j := Round(Ld);
  H17UkWpnl.Caption := FormatCurr('#,##0', j);
  CalcEngLoad(j,H17UBtn);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V267)); //VCB-G4 var
  j := Round(StrToFloatDef(LStr,0.0));
  H17Ukvarpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V543)); //VCB-F1 kW
  Ld := StrToFloatDef(LStr,0.0);
  DM1.FElecPowerCalcBase.SetVCBF1kW(Ld);
  j := Round(Ld);
  F1Kwpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V536)); //VCB-F1 V
  j := Round(StrToFloatDef(LStr,0.0));
  F1Vpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V566)); //VCB-F2 kW
  Ld := StrToFloatDef(LStr,0.0);
  DM1.FElecPowerCalcBase.SetVCBF2kW(Ld);
  j := Round(Ld);
  F2Kwpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V559)); //VCB-F2 V
  j := Round(StrToFloatDef(LStr,0.0));
  F2Vpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1292)); //VCB-F3 kW
  Ld := StrToFloatDef(LStr,0.0);
  DM1.FElecPowerCalcBase.SetVCBF3kW(Ld);
  j := Round(Ld);
  F3Kwpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1286)); //VCB-F3 V
  j := Round(StrToFloatDef(LStr,0.0));
  F3Vpnl.Caption := FormatCurr('#,##0', j);

  //Group 1
//  G1IncomPnl.Caption := InComP1ActivePnl.Caption;

  LStr := Utf8ToString(VariantToUtf8(ADoc.V522)); //Total Used kW
  j := Round(StrToFloatDef(LStr,0.0));
  Factory1Panel.Caption := FormatCurr('#,##0 kW', j);
//  G1TotalPnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1070)); //Total Used kW
  j := Round(StrToFloatDef(LStr,0.0));
  Factory2Panel.Caption := FormatCurr('#,##0 kW', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1086)); //Total Used kW
  j := Round(StrToFloatDef(LStr,0.0));
  Factory3Panel.Caption := FormatCurr('#,##0 kW', j);

//  G1H25VPnl.Caption := H25VkWpnl.Caption;
//  G1H17UPnl.Caption := H17UkWpnl.Caption;

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1602)); //LB #3 kW
  j := Round(StrToFloatDef(LStr,0.0));
//  G1LB3Pnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1610)); //LB #4 kW
  j := Round(StrToFloatDef(LStr,0.0));
//  G1LB4Pnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V609)); //VCB-G5 kW
  j := Round(StrToFloatDef(LStr,0.0));
  H2017kWpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V610)); //VCB-G5 kVar
  j := Round(StrToFloatDef(LStr,0.0));
  H2017kvarpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V601)); //VCB-G5 Voltage
  j := Round(StrToFloatDef(LStr,0.0));
  H2017vpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V604)); //VCB-G5 A
  j := Round(StrToFloatDef(LStr,0.0));
  H2017Apnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V608)); //VCB-G5 Hz
  j := Round(StrToFloatDef(LStr,0.0));
  H2017HzPnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V607)); //VCB-G5 PF
  j := Round(StrToFloatDef(LStr,0.0));
  H2017PFPnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V861)); //ACB-G6 kW
  Ld := StrToFloatDef(LStr,0.0);
  DM1.FElecPowerCalcBase.SetVCBG6kW(Ld);
  j := Round(Ld);
  H1217kWpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V862)); //ACB-G6 kVar
  j := Round(StrToFloatDef(LStr,0.0));
  H1217kvarpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V853)); //ACB-G6 Voltage
  j := Round(StrToFloatDef(LStr,0.0));
  H1217vpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V856)); //ACB-G6 A
  j := Round(StrToFloatDef(LStr,0.0));
  H1217Apnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V860)); //ACB-G6 Hz
  j := Round(StrToFloatDef(LStr,0.0));
  H1217HzPnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V859)); //ACB-G6 PF
  j := Round(StrToFloatDef(LStr,0.0));
  H1217PFPnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1100)); //VCB-G7 kW
  Ld := StrToFloatDef(LStr,0.0);
  DM1.FElecPowerCalcBase.SetVCBG7kW(Ld);
  j := Round(Ld);
  H46kWpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1101)); //VCB-G7 kVar
  j := Round(StrToFloatDef(LStr,0.0));
  H46kvarpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1092)); //VCB-G7 Voltage
  j := Round(StrToFloatDef(LStr,0.0));
  H46vpnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1095)); //VCB-G7 A
  j := Round(StrToFloatDef(LStr,0.0));
  H46Apnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1099)); //VCB-G7 Hz
  j := Round(StrToFloatDef(LStr,0.0));
  H46HzPnl.Caption := FormatCurr('#,##0', j);

  LStr := Utf8ToString(VariantToUtf8(ADoc.V1098)); //VCB-G7 PF
  j := Round(StrToFloatDef(LStr,0.0));
  H46PFPnl.Caption := FormatCurr('#,##0', j);

  Ld := DM1.FElecPowerCalcBase.VCBG2kWh;
  H25Vkwhpnl.Caption := FormatCurr('#,##0', Round(Ld)); //VCB-G2 kWh
  H25VPricepnl.Caption := FormatCurr('#,##0', DM1.FElecPowerCalcBase.GetPrice4UsedkWhAtTime(now, Ld));
  Ld := DM1.FElecPowerCalcBase.ACBG4kWh;
  H17Ukwhpnl.Caption := FormatCurr('#,##0', Round(Ld)); //ACB-G4 kWh
  H17UPricepnl.Caption := FormatCurr('#,##0', DM1.FElecPowerCalcBase.GetPrice4UsedkWhAtTime(now, Ld));
  Ld := DM1.FElecPowerCalcBase.VCBG6kWh;
  H1217Vkwhpnl.Caption := FormatCurr('#,##0', Round(Ld)); //VCB-G6 kWh
  H1217VPricepnl.Caption := FormatCurr('#,##0', DM1.FElecPowerCalcBase.GetPrice4UsedkWhAtTime(now, Ld));
  Ld := DM1.FElecPowerCalcBase.VCBG5kWh;
  H2017Vkwhpnl.Caption := FormatCurr('#,##0', Round(Ld)); //VCB-G5 kWh
  H2017VPricepnl.Caption := FormatCurr('#,##0', DM1.FElecPowerCalcBase.GetPrice4UsedkWhAtTime(now, Ld));
end;

procedure TEngineOverView_Frm.SetPMSDigitalData(ADoc: variant);
var
  Li: Variant;
  j: integer;
begin
  for j := 0 to FPMSOverViewTree.FPMSOverViewCollect.Count - 1 do
  begin
    Li := FPMSOverViewTree.FPMSOverViewCollect.Items[j].TagIndex;
    if Li > 0 then
    begin
      if Li < ADoc._Count then
        FPMSOverViewTree.FPMSOverViewCollect.Items[j].TagValue := ADoc.Value(Li);
    end;
  end;//for
end;

procedure TEngineOverView_Frm.SetTROnOff(ACompName: string; AOn: Boolean);
var
  LComp: TComponent;
begin
  LComp := nil;
  LComp := FindComponent(ACompName);

  if Assigned(LComp) then
  begin
    if LComp is TImage then
    begin
      if TImage(LComp).Tag = -1 then//Horizantal
      begin
        if AOn then
          Get_OnOffImage('Tr1_On', TImage(LComp))
        else
          Get_OnOffImage('Tr1_Off', TImage(LComp));

      end
      else
      begin
        if AOn then
          Get_OnOffImage('Tr_On', TImage(LComp))
        else
          Get_OnOffImage('Tr_Off', TImage(LComp));
      end;
    end;
  end;
end;

procedure TEngineOverView_Frm.SetUnitID2TagList;
var
  i,j: integer;
begin
//  for i := 0 to PMSOPCClientF.FTagList.Count - 1 do
//  begin
//    for j := 0 to ComponentCount - 1 do
//    begin
//      if Components[j] is TImage then
//      begin
//        if PMSOPCClientF.FTagList.Item[i].TagName = TImage(Components[j]).Hint then
//          PMSOPCClientF.FTagList.Item[i].UnitID := Components[j].Name;
//      end
//      else
//      if Components[j] is TShadowButton then
//      begin
//        if PMSOPCClientF.FTagList.Item[i].TagName = TShadowButton(Components[j]).Hint then
//          PMSOPCClientF.FTagList.Item[i].UnitID := Components[j].Name;
//      end
//      else
//      if Components[j] is TiPipe then
//      begin
////        if PMSOPCClientF.FTagList.Item[i].TagName = TiPipe(Components[j]).Hint then
////          PMSOPCClientF.FTagList.Item[i].UnitID := Components[j].Name;
//      end;
//    end;
//  end;
end;

procedure TEngineOverView_Frm.SetUnitID2TagList1Click(Sender: TObject);
begin
  SetUnitID2TagList;
end;

function TEngineOverView_Frm.SetVCBOnOff(ACompName, AValue: string;
  AHiMAPType:THiMAPType; var AGroupNo: integer; ABitIndex:integer): Bool;
var
  LComp: TComponent;
begin
  Result := False;
  LComp := nil;
  LComp := FindComponent(ACompName);

  if Assigned(LComp) then
  begin
    if LComp is TImage then
    begin
      if TImage(LComp).Tag > 0 then
        AGroupNo := TImage(LComp).Tag
      else
        AGroupNo := 0;

      if (AHiMAPType = htBCS) or (AHiMAPType = htFeeder) then//HiMAP-BCS, HiMAP-F
      begin
        Result := IsbitSet(StrToIntDef(AValue,0),ABitIndex);

        if Result then
        begin
          if TImage(LComp).HelpKeyword = 'H' then
            Get_OnOffImage('HCB_On', TImage(LComp))
          else
            Get_OnOffImage('VCB_ON', TImage(LComp));
        end
        else
        begin
          if TImage(LComp).HelpKeyword = 'H' then
            Get_OnOffImage('HCB_Off', TImage(LComp))
          else
            Get_OnOffImage('VCB_OFF', TImage(LComp));
        end;
      end
      else
      if (AHiMAPType = htBCG) then//HiMAP-BCG
      begin
        Result := UpperCase(AValue) = 'TRUE';

        if Result then
        begin
          if TImage(LComp).HelpKeyword = 'H' then
            Get_OnOffImage('HCB_On', TImage(LComp))
          else
            Get_OnOffImage('VCB_ON', TImage(LComp));
        end
        else
        begin
          if TImage(LComp).HelpKeyword = 'H' then
            Get_OnOffImage('HCB_Off', TImage(LComp))
          else
            Get_OnOffImage('VCB_OFF', TImage(LComp));
        end;
      end;

    end;
  end;
end;

procedure TEngineOverView_Frm.ShowElecPriceTable1Click(Sender: TObject);
begin
  DM1.ShowElecPowerPriceTable;
end;

procedure TEngineOverView_Frm.ShowGridView(ADocs: TVariantDynArray);
var
  LGridViewF: TGridViewF;
  LnxTextColumn: TnxTextColumn;
  LNxComboBoxColumn: TNxComboBoxColumn;
  i: integer;
  LDateTime: TDateTime;
  LStr: string;
begin
  LGridViewF := TGridViewF.Create(Self);
  try
    with LGridViewF do
    begin
      with TFrame11.NextGrid1 do
      begin
        ClearRows;
        Columns.Clear;

        Columns.Add(TnxIncrementColumn,'No.');

        LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Date Time'));
        LnxTextColumn.Name := 'RegDate';
        LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

        LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'18H25V'));
        LnxTextColumn.Name := 'Value_18H25V';
        LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

        LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'6H17U'));
        LnxTextColumn.Name := 'Value_6H17U';
        LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

        LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'20H17V'));
        LnxTextColumn.Name := 'Value_20H17V';
        LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

        LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'12H17V'));
        LnxTextColumn.Name := 'Value_12H17V';
        LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

        ClearRows;

        BeginUpdate;

        try
          for i := 0 to High(ADocs) do
          begin
            AddRow;
            LDateTime := TTimeZone.Local.ToLocalTime(Iso8601ToDateTime(ADocs[i].SavedTime));
            CellByName['RegDate',i].AsString := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',LDateTime);
            CellByName['Value_18H25V',i].AsString := ADocs[i].V9;
            CellByName['Value_6H17U',i].AsString := ADocs[i].V266;
            CellByName['Value_20H17V',i].AsString := ADocs[i].V609;
            CellByName['Value_12H17V',i].AsString := ADocs[i].V861;
          end;
        finally
          EndUpdate;
        end;
      end;//with

      ShowModal;
    end;
  finally
    FreeAndNil(LGridViewF);
  end;
end;

procedure TEngineOverView_Frm.SetVCBOnOf(Ai, Aj: integer);
var
  LComp: TComponent;
  LBool: Boolean;
begin
  LComp := nil;
//  LComp := FindComponent(PMSOPCClientF.FTagList.Item[Ai].UnitID);
//
//  if Assigned(LComp) then
//  begin
//    if LComp is TImage then
//    begin
//      if LComp.Tag > 0 then//HiMAP-BCS, HiMAP-F
//      begin
//        LBool := IsbitSet(StrToInt(PMSOPCClientF.FTagList.Item[Ai].TagValue),LComp.Tag);
//
//        if LBool then
//        begin
//          Get_OnOffImage('VCB_ON', TImage(LComp));
//        end
//        else
//        begin
//          Get_OnOffImage('VCB_OFF', TImage(LComp));
//        end;
//      end
//      else //HiMAP-BCG
//      begin
//        LBool := UpperCase(PMSOPCClientF.FTagList.Item[Ai].TagValue) = 'TRUE';
//
//        if LBool then
//        begin
//          Get_OnOffImage('VCB_ON', TImage(LComp));
//        end
//        else
//        begin
//          Get_OnOffImage('VCB_OFF', TImage(LComp));
//        end;
//      end;
//
//      SetElecLine(TImage(LComp).Hint, LBool);
//    end
//    else
//    if LComp is TShadowButton then
//    begin
//    end
//    else
//    if LComp is TiPipe then
//    begin
//    end;
//  end;
end;

procedure TEngineOverView_Frm.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled := False;
  try
//    with DM1.OraQuery1 do
//    begin
//      Close;
//      SQL.clear;
//      SQL.add('SELECT DATASAVEDTIME, DATA27, DATA249 FROM TBACS.YE0594_18H2533V_MEASURE_DATA ' +
//              'WHERE DATASAVEDTIME LIKE :param1 ');
//      //ParamByName('param1').AsString := FormatDateTime('IncMinute(YYYYMMDDHHMMSS)',Now);
//      ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-5));
//      Open;
//
//      //Shadowbutton8.Caption := FieldByName('DATA251').AsString;
//
//      Panel11.Caption := FieldByName('DATA27').AsString;
//      Panel17.Caption := FieldByName('DATA249').AsString+' kW';
//    end;
//
  finally
    SetMonitoringData;
    timer1.Enabled := True;
//    iMotor1.Fanon := Panel11.Caption <> '';
//
//    if Panel11.Caption <> '' then
//    begin
//      Panel11.Font.Color := clLime;
//      Panel17.Font.Color := clLime;
//    end;
  end;

end;

procedure TEngineOverView_Frm.Timer2Timer(Sender: TObject);
begin
  timer2.Enabled := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.clear;
      SQL.add('SELECT DATASAVEDTIME, DATA27,DATA199  FROM TBACS.YE0539_6H1728U_MEASURE_DATA ' +
              'WHERE DATASAVEDTIME LIKE :param1 ');
      //ParamByName('param1').AsString := FormatDateTime('IncMinute(YYYYMMDDHHMMSS)',Now);
      ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-5));
      Open;

      //Shadowbutton8.Caption := FieldByName('DATA251').AsString;

      Panel8.Caption := FieldByName('DATA27').AsString;
      Panel15.Caption := FieldByName('DATA199').AsString+' kW';
    end;
  finally
    timer2.Enabled := True;
    iMotor2.Fanon := Panel8.Caption <> '';

    if Panel8.Caption <> '' then
      Panel8.Font.Color := clLime;

     Panel15.Font.Color := clLime;
  end;
end;

procedure TEngineOverView_Frm.Timer3Timer(Sender: TObject);
begin
  timer3.Enabled := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.clear;
      SQL.add('SELECT DATASAVEDTIME, DATA51, DATA149 FROM TBACS.BF1562_18H3240V_MEASURE_DATA ' +
              'WHERE DATASAVEDTIME LIKE :param1 ');
      //ParamByName('param1').AsString := FormatDateTime('IncMinute(YYYYMMDDHHMMSS)',Now);
      ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-5));
      Open;

      //Shadowbutton8.Caption := FieldByName('DATA251').AsString;

      Panel59.Caption := FieldByName('DATA51').AsString;
      Panel62.Caption := FieldByName('DATA149').AsString+' kW';
    end;
  finally
    timer3.Enabled := True;
    iMotor6.Fanon := Panel59.Caption <> '';
    if Panel59.Caption <> '' then
     Panel59.Font.Color := clLime;
     Panel62.Font.Color := clLime;
  end;
end;

procedure TEngineOverView_Frm.Timer4Timer(Sender: TObject);
begin
  timer4.Enabled := False;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.clear;
      SQL.add('SELECT DATASAVEDTIME, DATA51, DATA149 FROM TBACS.BF1656_20H3240V_MEASURE_DATA ' +
              'WHERE DATASAVEDTIME LIKE :param1 ');
      //ParamByName('param1').AsString := FormatDateTime('IncMinute(YYYYMMDDHHMMSS)',Now);
      ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-5));
      Open;

      //Shadowbutton8.Caption := FieldByName('DATA251').AsString;

      Panel68.Caption := FieldByName('DATA51').AsString;
      Panel71.Caption := FieldByName('DATA149').AsString+' kW';
    end;
  finally
    timer4.Enabled := True;
    iMotor7.Fanon := Panel68.Caption <> '';
    if Panel68.Caption <> '' then
     Panel68.Font.Color := clLime;
     Panel71.Font.Color := clLime;
  end;
end;

procedure TEngineOverView_Frm.TraverseDFSTreeView(ATreeView: TTreeView);
var
  LTreeNode: TTreeNode;
//  LDownPowerOn,
  LDownPowerOn1, //VCB #1
  LDownPowerOn2, //VCB #2
  LDownPowerOn3, //VCB #3
//  LUpPowerOn,
  LUpPowerOn1,//G1 Generator 상태
  LUpPowerOn2,//G2 Generator 상태
  LUpPowerOn3,//G3 Generator 상태
  LUpPowerOn4,//G4 Generator 상태
  LUpPowerOn5: boolean;//G5 Generator 상태

  LGenNo,
  LInComNo: integer;

  function SetUpPowerOn(AGenNo:integer; APMSItem: TPMSOverViewItem): Boolean;
  begin
    case AGenNo of
      1:Result := LUpPowerOn1;
      2:begin
          if APMSItem.UnionGroup = 1 then
            Result := LUpPowerOn1 or LUpPowerOn2
          else
            Result := LUpPowerOn2;
      end;
      3:Result := LUpPowerOn3;
      4:begin
          if APMSItem.UnionGroup = 2 then
            Result := LUpPowerOn3 or LUpPowerOn4
          else
            Result := LUpPowerOn4;
      end;
      5:Result := LUpPowerOn5;
    end;

    if APMSItem.DefaultReverse then
      Result := not Result;
  end;

  function SetDownPowerOn(AOnOff: Boolean): Boolean;
  begin
    //한번 False면  LDownPowerOnx는 False임
    case LInComNo of
      1:begin
        if LDownPowerOn1 then
          LDownPowerOn1 := AOnOff;

        Result := LDownPowerOn1;
      end;
      2:begin
        if LDownPowerOn2 then
          LDownPowerOn2 := AOnOff;

        Result := LDownPowerOn2;
      end;
      3:begin
        if LDownPowerOn3 then
          LDownPowerOn3 := AOnOff;

        Result := LDownPowerOn3;
      end;
    end;//case
  end;

  //LDownPowerOn: Incoming Power가 계속 연결되어 있으면 True
  //LUpPowerOn: Gen Power가 가동 중이고 계속 연결되어 있으면 True
  function DFSTree(ANode: TTreeNode; AParentValue: Boolean = False): Boolean; //자신의 OnOff 값 반환함
  var
    i: integer;
    LNode: TTreeNode;
    LPMSItem: TPMSOverViewItem;
    LOnOff, LChildValue, LDownPowerOn, LUpPowerOn: Bool;
  begin
    LOnOff := False;
    LChildValue := False;
    Result := False;

    LPMSItem := TPMSOverViewItem(ANode.Data);

    if (LPMSItem.EquipType = etACB) or (LPMSItem.EquipType = etVCB) then
    begin
      LOnOff := SetVCBOnOff(LPMSItem.CompName,LPMSItem.TagValue,LPMSItem.HiMapType, i, LPMSItem.BitIndex);

      //InComing VCB #1 ~ #3인 경우만 실행(한전 인입 라인)
      case i of
        1:begin
          LInComNo := i;
          LDownPowerOn1 := LOnOff;
        end;
        2:begin
          LInComNo := i;
          LDownPowerOn2 := LOnOff;
        end;
        3:begin
          LInComNo := i;
          LDownPowerOn3 := LOnOff;
        end;
      end;
    end
    else
    if LPMSItem.EquipType = etPipe then
    begin
//      if LPMSItem.DependChild then
//        SetElecLine2(LPMSItem.CompName, AParentValue, AParentValue)
//      else
//        SetElecLine2(LPMSItem.CompName, AParentValue, LPMSItem.DefaultReverse);

      LOnOff := AParentValue;
    end
    else
    if LPMSItem.EquipType = etTransformer then
    begin
      SetTROnOff(LPMSItem.CompName, AParentValue);
      LOnOff := AParentValue;
    end
    else
    if LPMSItem.EquipType = etGenerator then
    begin
      LOnOff := SetGeneratorOnOff(LPMSItem.CompName,LPMSItem.TagValue,LPMSItem.HiMapType,LGenNo, LPMSItem.BitIndex);

      case LGenNo of
        1:if not LUpPowerOn1 then
            LUpPowerOn1 := LOnOff;
        2:if not LUpPowerOn2 then
            LUpPowerOn2 := LOnOff;
        3:if not LUpPowerOn3 then
            LUpPowerOn3 := LOnOff;
        4:if not LUpPowerOn4 then
            LUpPowerOn4 := LOnOff;
        5:if not LUpPowerOn5 then
            LUpPowerOn5 := LOnOff;
      end;
    end;

    LDownPowerOn := SetDownPowerOn(LOnOff);
    Result := LOnOff;

    if ANode.HasChildren then
    begin
      LNode := ANode.getFirstChild;

      for i := 0 to ANode.Count - 1 do
      begin
        LChildValue := DFSTree(LNode, Result);

        if LPMSItem.EquipType = etPipe then
        begin
          if LPMSItem.DependChild then
          begin
            if TPMSOverViewItem(LNode.Data).ImageIndex <> 2 then //Pipe중에 DependChild와 무관한 Pipe는 ImageIndex = 2 임
            begin
              LUpPowerOn := SetUpPowerOn(LGenNo, LPMSItem);

              if LChildValue then
              begin
                Result := LChildValue;

                if LUpPowerOn then
                  SetElecLine2(LPMSItem.CompName, LChildValue, LPMSItem.UpPowerReverse)
                else
                  SetElecLine2(LPMSItem.CompName, LChildValue, LPMSItem.DownPowerReverse)
              end
              else
              begin
                Result := AParentValue;

                if LUpPowerOn then
                  SetElecLine2(LPMSItem.CompName, AParentValue, LPMSItem.UpPowerReverse)
                else
                  SetElecLine2(LPMSItem.CompName, AParentValue, LPMSItem.DownPowerReverse)
  //              if LDownPowerOn then
  //              begin
  //                SetElecLine2(LPMSItem.CompName, AParentValue, LChildValue);
  //                Result := AParentValue;
  //              end
  //              else
  //              begin
  //                SetElecLine2(LPMSItem.CompName, AParentValue, LDownPowerOn);
  //                Result := False;
  //              end;
              end;
            end;
          end
          else
          begin
            Result := AParentValue;
//            SetElecLine2(LPMSItem.CompName, AParentValue, LPMSItem.DefaultReverse);
            if LUpPowerOn then
              SetElecLine2(LPMSItem.CompName, AParentValue, LPMSItem.UpPowerReverse)
            else
              SetElecLine2(LPMSItem.CompName, AParentValue, LPMSItem.DownPowerReverse)
          end;
        end
        else
        if (LPMSItem.EquipType = etACB) or (LPMSItem.EquipType = etVCB) then
        begin
          if LPMSItem.ImageIndex = 0 then//LB에 연결된 ACB/VCB는 LUpPowerOn과 무관함(ImageIndex = 1)
          begin
            if not LOnOff then
            begin
              case LGenNo of
                1:if LUpPowerOn1 then
                    LUpPowerOn1 := False;
                2:if LUpPowerOn2 then
                    LUpPowerOn2 := False;
                3:if LUpPowerOn3 then
                    LUpPowerOn3 := False;
                4:if LUpPowerOn4 then
                    LUpPowerOn4 := False;
                5:if LUpPowerOn5 then
                    LUpPowerOn5 := False;
              end;
            end;
          end;
//          if not LChildValue then
//          begin
//            case LGenNo of
//              1:if not LUpPowerOn1 then
//                  LUpPowerOn1 := False;
//              2:if not LUpPowerOn2 then
//                  LUpPowerOn2 := False;
//              3:if not LUpPowerOn3 then
//                  LUpPowerOn3 := False;
//              4:if not LUpPowerOn4 then
//                  LUpPowerOn4 := False;
//              5:if not LUpPowerOn5 then
//                  LUpPowerOn5 := False;
//            end;
//          end;
        end;

        LNode := ANode.GetNextChild(LNode);
      end;
    end
    else
    if LPMSItem.DependChild then//Children이 없는(말단) Pipe의 경우
      SetElecLine2(LPMSItem.CompName, AParentValue, True)
    else
      SetElecLine2(LPMSItem.CompName, AParentValue, LPMSItem.DefaultReverse);
  end;
begin
  if FResultMongoDB = Null then
    exit;

  LUpPowerOn1 := False;
  LUpPowerOn2 := False;
  LUpPowerOn3 := False;
  LUpPowerOn4 := False;
  LUpPowerOn5 := False;

  ATreeView.Items.BeginUpdate;
  try
    LTreeNode := ATreeView.Items.GetFirstNode;

    DFSTree(LTreeNode);

    while True do
    begin
      LTreeNode := LTreeNode.getNextSibling;

      if not Assigned(LTreeNode) then
        break;

      DFSTree(LTreeNode);
    end;//while
  finally
    ATreeView.Items.EndUpdate;
  end;
end;

end.
