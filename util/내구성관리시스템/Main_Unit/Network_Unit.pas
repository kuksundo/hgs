unit Network_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, AdvPanel, AdvOfficePager,
  iComponent, iVCLComponent, iCustomComponent, iLed, iLedRectangle, iPipe,
  Vcl.Imaging.jpeg, Vcl.StdCtrls, Vcl.Imaging.pngimage, AdvScrollBox,
  Vcl.ComCtrls, AdvPageControl, iPipeJoint, JvExControls, JvLabel, NxCollection,
  JvExExtCtrls, JvExtComponent, JvPanel;

type
  TNetWork_Frm = class(TForm)
    CCTV1: TAdvPageControl;
    AdvTabSheet1: TAdvTabSheet;
    AdvTabSheet2: TAdvTabSheet;
    AdvScrollBox3: TAdvScrollBox;
    EGCP1: TImage;
    ETHERNET2: TImage;
    ETHERNET1: TImage;
    HUB1: TImage;
    MX100_1: TImage;
    MX100_2: TImage;
    MX100_3: TImage;
    LocalWorkstation1: TImage;
    WT500_1: TImage;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    CN007: TImage;
    ETHERNET3: TImage;
    HUB2: TImage;
    MX100_4: TImage;
    MX100_5: TImage;
    MX100_6: TImage;
    LocalWorkstation2: TImage;
    WT500_2: TImage;
    Label107: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    CN0031: TImage;
    ETHERNET4: TImage;
    HUB3: TImage;
    MX100_7: TImage;
    MX100_8: TImage;
    MX100_9: TImage;
    LocalWorkstation3: TImage;
    WT500_3: TImage;
    Label116: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    Label120: TLabel;
    Label121: TLabel;
    Label122: TLabel;
    Label123: TLabel;
    Label124: TLabel;
    CN0037: TImage;
    ETHERNET5: TImage;
    HUB4: TImage;
    MX100_10: TImage;
    MX100_11: TImage;
    MX100_12: TImage;
    LocalWorkstation4: TImage;
    WT500_4: TImage;
    Label125: TLabel;
    Label127: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    Label130: TLabel;
    Label131: TLabel;
    Label132: TLabel;
    Label133: TLabel;
    Image120: TImage;
    ETHERNET6: TImage;
    HUB5: TImage;
    MX100_13: TImage;
    MX100_14: TImage;
    MX100_15: TImage;
    LocalWorkstation5: TImage;
    WT500_5: TImage;
    Label134: TLabel;
    Label135: TLabel;
    Label136: TLabel;
    Label137: TLabel;
    Label138: TLabel;
    Label139: TLabel;
    Label140: TLabel;
    Label141: TLabel;
    Label142: TLabel;
    ETHERNET7: TImage;
    HUB6: TImage;
    MX100_16: TImage;
    MX100_17: TImage;
    MX100_18: TImage;
    LocalWorkstation6: TImage;
    WT500_6: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Image2: TImage;
    Image3: TImage;
    HUB7: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    LocalWorkstation7: TImage;
    WT500_7: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    HHT1: TImage;
    HHT2: TImage;
    HHT3: TImage;
    HHT4: TImage;
    HHT5: TImage;
    HHT6: TImage;
    HHT7: TImage;
    TOUCH1: TImage;
    TOUCH2: TImage;
    TOUCH3: TImage;
    TOUCH4: TImage;
    Label19: TLabel;
    HUB0: TImage;
    Label23: TLabel;
    Panel28: TPanel;
    DisplayServer: TPanel;
    iPipe197: TiPipe;
    iPipe198: TiPipe;
    iPipe199: TiPipe;
    Panel31: TPanel;
    iPipe200: TiPipe;
    iPipe201: TiPipe;
    iPipe202: TiPipe;
    iPipe203: TiPipe;
    iPipe204: TiPipe;
    iPipe205: TiPipe;
    iPipe206: TiPipe;
    Panel38: TPanel;
    Label143: TLabel;
    Label144: TLabel;
    iPipe210: TiPipe;
    iPipe211: TiPipe;
    iPipe215: TiPipe;
    iPipe216: TiPipe;
    iPipe217: TiPipe;
    iPipe218: TiPipe;
    iPipe219: TiPipe;
    iPipe220: TiPipe;
    iPipe221: TiPipe;
    iPipe222: TiPipe;
    iPipe223: TiPipe;
    iPipe224: TiPipe;
    iPipe225: TiPipe;
    iPipe226: TiPipe;
    iPipe227: TiPipe;
    iPipe228: TiPipe;
    iPipe229: TiPipe;
    Panel39: TPanel;
    Panel40: TPanel;
    iPipe230: TiPipe;
    iPipe231: TiPipe;
    iPipe232: TiPipe;
    iPipe233: TiPipe;
    iPipe234: TiPipe;
    iPipe236: TiPipe;
    iPipe237: TiPipe;
    iPipe238: TiPipe;
    iPipe239: TiPipe;
    iPipe240: TiPipe;
    iPipe241: TiPipe;
    iPipe242: TiPipe;
    iPipe243: TiPipe;
    iPipe244: TiPipe;
    Panel41: TPanel;
    Panel42: TPanel;
    iPipe245: TiPipe;
    iPipe246: TiPipe;
    iPipe247: TiPipe;
    iPipe248: TiPipe;
    iPipe249: TiPipe;
    iPipe251: TiPipe;
    iPipe252: TiPipe;
    iPipe253: TiPipe;
    iPipe254: TiPipe;
    iPipe255: TiPipe;
    iPipe256: TiPipe;
    iPipe257: TiPipe;
    iPipe258: TiPipe;
    iPipe259: TiPipe;
    Panel43: TPanel;
    Panel44: TPanel;
    iPipe260: TiPipe;
    iPipe261: TiPipe;
    iPipe262: TiPipe;
    iPipe263: TiPipe;
    iPipe264: TiPipe;
    iPipe266: TiPipe;
    iPipe267: TiPipe;
    iPipe268: TiPipe;
    iPipe269: TiPipe;
    iPipe270: TiPipe;
    iPipe271: TiPipe;
    iPipe272: TiPipe;
    iPipe273: TiPipe;
    iPipe274: TiPipe;
    Panel45: TPanel;
    Panel46: TPanel;
    iPipe275: TiPipe;
    iPipe276: TiPipe;
    iPipe277: TiPipe;
    iPipe278: TiPipe;
    iPipe279: TiPipe;
    iPipe281: TiPipe;
    iPipe282: TiPipe;
    iPipe283: TiPipe;
    iPipe284: TiPipe;
    iPipe285: TiPipe;
    iPipe286: TiPipe;
    iPipe287: TiPipe;
    iPipe288: TiPipe;
    iPipe289: TiPipe;
    Panel1: TPanel;
    Panel2: TPanel;
    iPipe1: TiPipe;
    iPipe2: TiPipe;
    iPipe3: TiPipe;
    iPipe4: TiPipe;
    iPipe5: TiPipe;
    iPipe6: TiPipe;
    iPipe7: TiPipe;
    iPipe8: TiPipe;
    iPipe9: TiPipe;
    iPipe10: TiPipe;
    iPipe11: TiPipe;
    iPipe12: TiPipe;
    iPipe13: TiPipe;
    iPipe14: TiPipe;
    Panel3: TPanel;
    Panel4: TPanel;
    iPipe15: TiPipe;
    iPipe16: TiPipe;
    iPipe17: TiPipe;
    iPipe18: TiPipe;
    iPipe19: TiPipe;
    iPipe20: TiPipe;
    iPipe21: TiPipe;
    iPipe22: TiPipe;
    iPipe23: TiPipe;
    iPipe24: TiPipe;
    iPipe25: TiPipe;
    iPipe26: TiPipe;
    iPipe27: TiPipe;
    iPipe28: TiPipe;
    iPipe30: TiPipe;
    iPipe33: TiPipe;
    iPipe34: TiPipe;
    iPipe35: TiPipe;
    LOADBANKPLC1: TPanel;
    LOADBANKPLC2: TPanel;
    LOADBANKPLC3: TPanel;
    LOADBANKPLC4: TPanel;
    LOADBANKPLC5: TPanel;
    LOADBANKPLC6: TPanel;
    LOADBANKPLC7: TPanel;
    LOADBANKPLC8: TPanel;
    LOADBANKPLC9: TPanel;
    LOADBANKPLC10: TPanel;
    LOADBANKPLC11: TPanel;
    LOADBANKPLC13: TPanel;
    iPipe36: TiPipe;
    iPipe37: TiPipe;
    iPipe38: TiPipe;
    iPipe39: TiPipe;
    iPipe40: TiPipe;
    iPipe41: TiPipe;
    iPipe42: TiPipe;
    iPipe43: TiPipe;
    iPipe44: TiPipe;
    iPipe45: TiPipe;
    LOADBANKPLC12: TPanel;
    iPipe46: TiPipe;
    AdvScrollBox1: TAdvScrollBox;
    CCTV_SERVER_1: TPanel;
    CCTV_1: TPanel;
    CCTV_SERVER_2: TPanel;
    HUB8: TImage;
    iPipe47: TiPipe;
    iPipe48: TiPipe;
    iPipe50: TiPipe;
    Label24: TLabel;
    iPipe55: TiPipe;
    iPipe51: TiPipe;
    iPipe56: TiPipe;
    iPipe57: TiPipe;
    iPipe58: TiPipe;
    Label20: TLabel;
    Label21: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    iPipe59: TiPipe;
    iPipe60: TiPipe;
    iPipe61: TiPipe;
    iPipe62: TiPipe;
    iPipe63: TiPipe;
    Label22: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    iPipe29: TiPipe;
    iPipe64: TiPipe;
    Panel7: TPanel;
    iPipe65: TiPipe;
    Panel8: TPanel;
    Panel11: TPanel;
    iPipe67: TiPipe;
    iPipe69: TiPipe;
    iPipe70: TiPipe;
    iPipe31: TiPipe;
    iPipe71: TiPipe;
    iPipe72: TiPipe;
    iPipe73: TiPipe;
    iPipe74: TiPipe;
    iPipe75: TiPipe;
    iPipe76: TiPipe;
    iPipe77: TiPipe;
    iPipe78: TiPipe;
    iPipeJoint1: TiPipeJoint;
    iPipeJoint2: TiPipeJoint;
    iPipeJoint3: TiPipeJoint;
    iPipeJoint4: TiPipeJoint;
    iPipeJoint5: TiPipeJoint;
    iPipeJoint8: TiPipeJoint;
    iPipeJoint9: TiPipeJoint;
    iPipeJoint10: TiPipeJoint;
    iPipeJoint11: TiPipeJoint;
    iPipeJoint16: TiPipeJoint;
    iPipeJoint17: TiPipeJoint;
    iPipeJoint18: TiPipeJoint;
    iPipeJoint19: TiPipeJoint;
    iPipeJoint20: TiPipeJoint;
    iPipeJoint21: TiPipeJoint;
    iPipeJoint22: TiPipeJoint;
    iPipeJoint23: TiPipeJoint;
    iPipeJoint24: TiPipeJoint;
    iPipeJoint25: TiPipeJoint;
    iPipeJoint26: TiPipeJoint;
    iPipeJoint27: TiPipeJoint;
    iPipeJoint28: TiPipeJoint;
    iPipeJoint29: TiPipeJoint;
    iPipeJoint30: TiPipeJoint;
    iPipeJoint31: TiPipeJoint;
    iPipeJoint32: TiPipeJoint;
    iPipeJoint33: TiPipeJoint;
    iPipeJoint34: TiPipeJoint;
    iPipeJoint35: TiPipeJoint;
    iPipeJoint36: TiPipeJoint;
    iPipeJoint37: TiPipeJoint;
    iPipeJoint38: TiPipeJoint;
    iPipeJoint39: TiPipeJoint;
    iPipeJoint40: TiPipeJoint;
    iPipeJoint41: TiPipeJoint;
    iPipeJoint42: TiPipeJoint;
    iPipeJoint43: TiPipeJoint;
    iPipeJoint44: TiPipeJoint;
    iPipeJoint45: TiPipeJoint;
    iPipeJoint46: TiPipeJoint;
    iPipeJoint47: TiPipeJoint;
    iPipeJoint48: TiPipeJoint;
    iPipeJoint49: TiPipeJoint;
    iPipeJoint50: TiPipeJoint;
    iPipeJoint51: TiPipeJoint;
    iPipeJoint52: TiPipeJoint;
    iPipeJoint53: TiPipeJoint;
    iPipeJoint54: TiPipeJoint;
    iPipeJoint55: TiPipeJoint;
    iPipeJoint56: TiPipeJoint;
    iPipeJoint57: TiPipeJoint;
    iPipeJoint58: TiPipeJoint;
    iPipeJoint59: TiPipeJoint;
    iPipeJoint60: TiPipeJoint;
    iPipeJoint61: TiPipeJoint;
    iPipeJoint62: TiPipeJoint;
    iPipeJoint63: TiPipeJoint;
    iPipeJoint64: TiPipeJoint;
    iPipeJoint65: TiPipeJoint;
    iPipeJoint66: TiPipeJoint;
    iPipeJoint67: TiPipeJoint;
    iPipeJoint68: TiPipeJoint;
    iPipeJoint69: TiPipeJoint;
    iPipeJoint70: TiPipeJoint;
    iPipeJoint71: TiPipeJoint;
    iPipeJoint72: TiPipeJoint;
    iPipeJoint73: TiPipeJoint;
    iPipeJoint74: TiPipeJoint;
    iPipeJoint75: TiPipeJoint;
    iPipeJoint76: TiPipeJoint;
    iPipeJoint77: TiPipeJoint;
    iPipeJoint78: TiPipeJoint;
    iPipeJoint79: TiPipeJoint;
    iPipeJoint80: TiPipeJoint;
    iPipeJoint81: TiPipeJoint;
    iPipeJoint15: TiPipeJoint;
    Panel10: TPanel;
    iPipe68: TiPipe;
    iPipeJoint14: TiPipeJoint;
    Image4: TImage;
    iPipe79: TiPipe;
    iPipeJoint82: TiPipeJoint;
    Label34: TLabel;
    iPipe80: TiPipe;
    iPipe32: TiPipe;
    iPipe81: TiPipe;
    iPipe82: TiPipe;
    iPipe83: TiPipe;
    iPipe84: TiPipe;
    iPipe85: TiPipe;
    iPipe86: TiPipe;
    iPipeJoint13: TiPipeJoint;
    iPipeJoint83: TiPipeJoint;
    AdvTabSheet3: TAdvTabSheet;
    AdvScrollBox2: TAdvScrollBox;
    AdvPageControl2: TAdvPageControl;
    AdvTabSheet4: TAdvTabSheet;
    AdvTabSheet5: TAdvTabSheet;
    AdvTabSheet6: TAdvTabSheet;
    AdvScrollBox4: TAdvScrollBox;
    AdvScrollBox5: TAdvScrollBox;
    Image32: TImage;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Panel13: TPanel;
    Panel16: TPanel;
    AdvScrollBox6: TAdvScrollBox;
    Panel14: TPanel;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image57: TImage;
    Image63: TImage;
    Image64: TImage;
    Image65: TImage;
    Image66: TImage;
    Image67: TImage;
    Image68: TImage;
    Image69: TImage;
    Panel21: TPanel;
    Label35: TLabel;
    Image58: TImage;
    Label36: TLabel;
    Image62: TImage;
    Label38: TLabel;
    Panel32: TPanel;
    Panel33: TPanel;
    Image59: TImage;
    Label39: TLabel;
    Image70: TImage;
    Label40: TLabel;
    Image60: TImage;
    Image61: TImage;
    Image71: TImage;
    Image72: TImage;
    Image73: TImage;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel9: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel11: TJvLabel;
    JvLabel12: TJvLabel;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image16: TImage;
    Image17: TImage;
    Image28: TImage;
    Image29: TImage;
    Image30: TImage;
    Image31: TImage;
    Image33: TImage;
    Image34: TImage;
    Image35: TImage;
    Image36: TImage;
    Image37: TImage;
    Image38: TImage;
    Image39: TImage;
    Image40: TImage;
    Image41: TImage;
    Image42: TImage;
    Image43: TImage;
    Image44: TImage;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label72: TLabel;
    Image46: TImage;
    Image47: TImage;
    Image48: TImage;
    Image45: TImage;
    Image49: TImage;
    Image50: TImage;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label80: TLabel;
    Image51: TImage;
    Image52: TImage;
    Image53: TImage;
    Image54: TImage;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Image18: TImage;
    Image19: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Label46: TLabel;
    Label47: TLabel;
    Image23: TImage;
    Label48: TLabel;
    Image24: TImage;
    Label49: TLabel;
    Image25: TImage;
    Label50: TLabel;
    Image26: TImage;
    iPipe87: TiPipe;
    Label51: TLabel;
    Image56: TImage;
    Label78: TLabel;
    Panel12: TPanel;
    Panel17: TPanel;
    Panel19: TPanel;
    Panel22: TPanel;
    iPipe88: TiPipe;
    iPipe89: TiPipe;
    iPipeJoint84: TiPipeJoint;
    iPipe91: TiPipe;
    iPipe94: TiPipe;
    iPipe90: TiPipe;
    iPipe92: TiPipe;
    iPipe93: TiPipe;
    iPipeJoint85: TiPipeJoint;
    iPipeJoint86: TiPipeJoint;
    iPipeJoint87: TiPipeJoint;
    iPipeJoint88: TiPipeJoint;
    Image74: TImage;
    Panel35: TPanel;
    Image75: TImage;
    Panel36: TPanel;
    Image76: TImage;
    Panel48: TPanel;
    Image77: TImage;
    Panel49: TPanel;
    Image78: TImage;
    Panel51: TPanel;
    Image79: TImage;
    Panel52: TPanel;
    Image80: TImage;
    Panel53: TPanel;
    Image81: TImage;
    Panel54: TPanel;
    Image82: TImage;
    iPipeJoint89: TiPipeJoint;
    Panel56: TPanel;
    Image83: TImage;
    Panel57: TPanel;
    Image84: TImage;
    iPipe49: TiPipe;
    iPipe52: TiPipe;
    iPipe53: TiPipe;
    iPipe54: TiPipe;
    iPipeJoint90: TiPipeJoint;
    iPipeJoint91: TiPipeJoint;
    iPipeJoint92: TiPipeJoint;
    iPipeJoint93: TiPipeJoint;
    iPipeJoint94: TiPipeJoint;
    iPipe95: TiPipe;
    iPipe97: TiPipe;
    iPipe98: TiPipe;
    iPipeJoint95: TiPipeJoint;
    iPipeJoint96: TiPipeJoint;
    iPipe96: TiPipe;
    iPipeJoint97: TiPipeJoint;
    iPipeJoint98: TiPipeJoint;
    iPipeJoint99: TiPipeJoint;
    Image85: TImage;
    Bevel1: TBevel;
    Panel30: TPanel;
    Bevel2: TBevel;
    Panel37: TPanel;
    Image86: TImage;
    Bevel3: TBevel;
    Panel15: TPanel;
    Bevel4: TBevel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Bevel5: TBevel;
    Panel27: TPanel;
    Bevel6: TBevel;
    Panel18: TPanel;
    Panel20: TPanel;
    Image87: TImage;
    Bevel7: TBevel;
    Panel29: TPanel;
    Panel47: TPanel;
    Bevel8: TBevel;
    iPipe99: TiPipe;
    iPipeJoint6: TiPipeJoint;
    iPipe100: TiPipe;
    iPipeJoint7: TiPipeJoint;
    iPipe101: TiPipe;
    iPipeJoint100: TiPipeJoint;
    AdvPanel1: TAdvPanel;
    AdvPanel2: TAdvPanel;
    iPipe66: TiPipe;
    iPipeJoint101: TiPipeJoint;
    Panel9: TPanel;
    Panel34: TPanel;
    Panel50: TPanel;
    Panel55: TPanel;
    iPipe102: TiPipe;
    iPipeJoint102: TiPipeJoint;
    iPipe103: TiPipe;
    iPipeJoint103: TiPipeJoint;
    iPipe104: TiPipe;
    iPipeJoint104: TiPipeJoint;
    iPipe105: TiPipe;
    iPipeJoint105: TiPipeJoint;
    Image94: TImage;
    Image95: TImage;
    Image96: TImage;
    Image97: TImage;
    Image98: TImage;
    Image99: TImage;
    Image100: TImage;
    Image101: TImage;
    Image102: TImage;
    Image103: TImage;
    Image104: TImage;
    Image105: TImage;
    Image106: TImage;
    Image107: TImage;
    Image108: TImage;
    Image109: TImage;
    Image110: TImage;
    Image111: TImage;
    Image112: TImage;
    Image113: TImage;
    Image116: TImage;
    Image117: TImage;
    Image118: TImage;
    Image119: TImage;
    Image121: TImage;
    Image124: TImage;
    Image125: TImage;
    Image126: TImage;
    Image127: TImage;
    Image128: TImage;
    Image129: TImage;
    Image130: TImage;
    Image131: TImage;
    Image132: TImage;
    Image133: TImage;
    Image134: TImage;
    Image135: TImage;
    Image136: TImage;
    Image137: TImage;
    Image138: TImage;
    Image139: TImage;
    Image140: TImage;
    Image141: TImage;
    Image142: TImage;
    Image143: TImage;
    Image144: TImage;
    Image145: TImage;
    Image146: TImage;
    Image147: TImage;
    Image148: TImage;
    Image149: TImage;
    Image150: TImage;
    Image151: TImage;
    Image152: TImage;
    Image153: TImage;
    Image154: TImage;
    Image155: TImage;
    Image156: TImage;
    Image157: TImage;
    Image158: TImage;
    Image159: TImage;
    Image160: TImage;
    Image161: TImage;
    Image162: TImage;
    Image163: TImage;
    Image164: TImage;
    Image165: TImage;
    Image166: TImage;
    Image1: TImage;
    Label2: TLabel;
    WORKSTATION1: TImage;
    WORKSTATION2: TImage;
    Image88: TImage;
    WORKSTATION3: TImage;
    Image90: TImage;
    WORKSTATION4: TImage;
    Image92: TImage;
    WORKSTATION5: TImage;
    WORKSTATION6: TImage;
    iPipeJoint12: TiPipeJoint;
    AdvPanel3: TAdvPanel;
    iPipe106: TiPipe;
    iPipeJoint106: TiPipeJoint;
    iPipe107: TiPipe;
    iPipeJoint107: TiPipeJoint;
    procedure CN0073Click(Sender: TObject);
    procedure LOADBANKPLC1Clic(Sender: TObject);
    procedure HUB0Click(Sender: TObject);
    procedure Image32Click(Sender: TObject);
    procedure Image20Click(Sender: TObject);
    procedure AdvPanel1Click(Sender: TObject);


  private
    { Private declarations }
    FEquipNo:String;
    FNetWork_Frm : TNetWork_Frm;
  public
    { Public declarations }
    procedure Network_IP_edit(aEquipno: string);
    procedure FindIPComponent(AEquipNo: string);
  end;

var
  NetWork_Frm: TNetWork_Frm;
  function Create_Network_IP(aEquipNo:String):Boolean;

implementation
uses
DataModule_Unit,
Panel_Unit,
Network_Sub_Unit,
Elect_Trance_Unit,
NetWork_Sub_Ip_Unit;


{$R *.dfm}

function Create_Network_IP(aEquipNo:String):Boolean;
begin
  Result := False;
  NetWork_Frm := TNetWork_Frm.Create(nil);
  try
    with NetWork_Frm do
    begin
      if aEquipNo <> '' then
      begin
        FEquipNo := aEquipNo;
        Network_IP_edit(FEquipNo);

      end;
      Show;
//      ShowModal;
//
//      if ModalResult = mrOk then
//        Result := True;

    end;
  finally
//    FreeAndNil(NetWork_Frm);
  end;
end;


procedure TNetWork_Frm.AdvPanel1Click(Sender: TObject);
var
  LHint : String;
begin  if Sender is TAdvPanel then
  begin
    with TAdvPanel(Sender) do
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

procedure TNetWork_Frm.CN0073Click(Sender: TObject);
var
  LHint : String;
begin
  if Sender is TImage then
  begin
    with TImage(Sender) do
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

procedure TNetWork_Frm.FindIPComponent(AEquipNo: string);
var
  i: integer;
begin
  for i := 0 to Self.ComponentCount -1 do
  begin
    if Self.Components[i] is TPanel then
    begin
      if TPanel(Self.Components[i]).Hint = AEquipNo then
        TPanel(Self.Components[i]).Color := clRed
        //ShowMessage(Self.Components[i].Name);
    end
    else
    if Self.Components[i] is TImage then
      if TImage(Self.Components[i]).Hint = AEquipNo then
        TImage(Self.Components[i]).Visible := False;
  end;
end;

procedure TNetWork_Frm.HUB0Click(Sender: TObject);
{var
  LForm : TNetwork_sub_frm;
  LHint : String;}

begin
  {if Sender is TImage then
  begin
    with TImage(Sender) do
    begin
      lHint := Hint;
      try
        LForm := TNetwork_sub_frm.Create(self);
        with LForm do
        begin
          FOwner := Self;
          NAMEPanel.Caption := lHint;

          ShowModal;
        end;
      finally
        FreeAndNil(LForm);
      end;
    end;
  end;}
end;

procedure TNetWork_Frm.Image20Click(Sender: TObject);
var
  LHint : String;
begin
  if Sender is TImage then
  begin
    with TImage(Sender) do
    begin
      try
        if Create_Eelec_Trance_Frm(Hint) then
        begin

        end;
      finally
      end;
    end;
  end;
end;

procedure TNetWork_Frm.Image32Click(Sender: TObject);
var
  LHint : String;
begin
  if Sender is TImage then
  begin
    with TImage(Sender) do
    begin
      lHint := Hint;
      try
        if Create_Panel_Frm(LHint) then
        begin

        end;
      finally
      end;
    end;
  end;
end;

procedure TNetWork_Frm.LOADBANKPLC1Clic(Sender: TObject);
var
  LHint : String;
begin  if Sender is TPanel then
  begin
    with TPanel(Sender) do
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

procedure TNetWork_Frm.Network_IP_edit(aEquipno: string);
begin

end;

end.
