unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, iSevenSegmentDisplay, iSevenSegmentInteger,
  iProgressComponent, iLedBar, iPositionComponent, iScaleComponent,
  iGaugeComponent, iAngularGauge, iAnalogDisplay, StdCtrls, iLedArrow,
  iComponent, iVCLComponent, iCustomComponent, iLed, iLedRectangle,
  JvExControls, JvSpeedButton, ComCtrls, SBPro;

type
  TForm1 = class(TForm)
    StatusBarPro1: TStatusBarPro;
    Panel5: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel7: TPanel;
    Label19: TLabel;
    JvSpeedButton1: TJvSpeedButton;
    JvSpeedButton2: TJvSpeedButton;
    Panel8: TPanel;
    iLedRectangle18: TiLedRectangle;
    iLedRectangle19: TiLedRectangle;
    iLedRectangle20: TiLedRectangle;
    iLedRectangle21: TiLedRectangle;
    iLedRectangle22: TiLedRectangle;
    iLedRectangle23: TiLedRectangle;
    iLedRectangle24: TiLedRectangle;
    iLedRectangle25: TiLedRectangle;
    iLedRectangle26: TiLedRectangle;
    Panel9: TPanel;
    iLedRectangle27: TiLedRectangle;
    iLedRectangle1: TiLedRectangle;
    iLedRectangle2: TiLedRectangle;
    iLedRectangle3: TiLedRectangle;
    iLedRectangle4: TiLedRectangle;
    iLedRectangle5: TiLedRectangle;
    iLedRectangle6: TiLedRectangle;
    iLedRectangle7: TiLedRectangle;
    iLedRectangle8: TiLedRectangle;
    iLedArrow1: TiLedArrow;
    Panel10: TPanel;
    Label20: TLabel;
    Image1: TImage;
    Image2: TImage;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel18: TPanel;
    Panel17: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel34: TPanel;
    Panel19: TPanel;
    Panel35: TPanel;
    iLedRectangle9: TiLedRectangle;
    iLedRectangle10: TiLedRectangle;
    iLedRectangle11: TiLedRectangle;
    iLedRectangle12: TiLedRectangle;
    iLedRectangle13: TiLedRectangle;
    iLedRectangle14: TiLedRectangle;
    iLedRectangle15: TiLedRectangle;
    iLedRectangle16: TiLedRectangle;
    iLedRectangle17: TiLedRectangle;
    StaticText5: TStaticText;
    iAnalogDisplay2: TiAnalogDisplay;
    StaticText6: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    Gen_B: TiAnalogDisplay;
    Gen_T: TiAnalogDisplay;
    Gen_S: TiAnalogDisplay;
    Gen_R: TiAnalogDisplay;
    TabSheet2: TTabSheet;
    Panel36: TPanel;
    AI_TC_A_RPM: TPanel;
    Panel37: TPanel;
    Panel38: TPanel;
    Panel39: TPanel;
    AI_FOPRESSINLET_N: TPanel;
    Panel40: TPanel;
    AI_CAPRESS_N: TPanel;
    Panel41: TPanel;
    AI_TC_B_RPM: TPanel;
    AI_ENGINERPM: TPanel;
    Panel42: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    Label2: TLabel;
    AI_MAINBERGTEMP_1: TiSevenSegmentInteger;
    AI_MAINBERGTEMP_2: TiSevenSegmentInteger;
    AI_MAINBERGTEMP_3: TiSevenSegmentInteger;
    AI_MAINBERGTEMP_4: TiSevenSegmentInteger;
    AI_MAINBERGTEMP_5: TiSevenSegmentInteger;
    AI_MAINBERGTEMP_6: TiSevenSegmentInteger;
    AI_MAINBERGTEMP_7: TiSevenSegmentInteger;
    AI_MAINBERGTEMP_8: TiSevenSegmentInteger;
    AI_MAINBERGTEMP_9: TiSevenSegmentInteger;
    AI_MAINBERGTEMP_10: TiSevenSegmentInteger;
    AI_MAINBERGTEMP_11: TiSevenSegmentInteger;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    AI_FOTEMPINLET: TiAnalogDisplay;
    AI_LOTEMPINLET: TiAnalogDisplay;
    StaticText1: TStaticText;
    StaticText4: TStaticText;
    StaticText7: TStaticText;
    AI_CAPRESS: TiAnalogDisplay;
    AI_FOFILTERINLETPRESS: TiAnalogDisplay;
    AI_LOFILTERPRESSINLET: TiAnalogDisplay;
    StaticText8: TStaticText;
    AI_CATEMP: TiAnalogDisplay;
    StaticText9: TStaticText;
    AI_FOPRESSINLET: TiAnalogDisplay;
    StaticText10: TStaticText;
    AI_HTTEMPINLET: TiAnalogDisplay;
    StaticText14: TStaticText;
    AI_HTTEMPOUTLET: TiAnalogDisplay;
    StaticText15: TStaticText;
    AI_LOPRESSINLET: TiAnalogDisplay;
    StaticText16: TStaticText;
    AI_LOTC_A_PRESS: TiAnalogDisplay;
    StaticText17: TStaticText;
    AI_LTPRESSINLET: TiAnalogDisplay;
    StaticText18: TStaticText;
    AI_LTTEMPINLET: TiAnalogDisplay;
    StaticText19: TStaticText;
    AI_LTTEMPOUTLET: TiAnalogDisplay;
    StaticText20: TStaticText;
    AI_TC_B_LOPRESS: TiAnalogDisplay;
    StaticText21: TStaticText;
    AI_CAPRESSINLET: TiAnalogDisplay;
    StaticText22: TStaticText;
    StaticText23: TStaticText;
    StaticText24: TStaticText;
    StaticText25: TStaticText;
    iAnalogDisplay1: TiAnalogDisplay;
    iAnalogDisplay3: TiAnalogDisplay;
    iAnalogDisplay4: TiAnalogDisplay;
    iAnalogDisplay5: TiAnalogDisplay;
    AI_EXH_A_1: TiSevenSegmentInteger;
    AI_EXH_A_2: TiSevenSegmentInteger;
    AI_EXH_A_3: TiSevenSegmentInteger;
    AI_EXH_A_4: TiSevenSegmentInteger;
    AI_EXH_A_5: TiSevenSegmentInteger;
    AI_EXH_A_6: TiSevenSegmentInteger;
    AI_EXH_A_7: TiSevenSegmentInteger;
    AI_EXH_A_8: TiSevenSegmentInteger;
    AI_EXH_A_9: TiSevenSegmentInteger;
    AI_EXH_A_10: TiSevenSegmentInteger;
    AI_EXH_A_Avg: TiSevenSegmentInteger;
    AI_EXH_A_TCINTLET_A: TiSevenSegmentInteger;
    AI_EXH_A_TCOUTLET: TiSevenSegmentInteger;
    AI_EXH_B_TEMP_1: TiSevenSegmentInteger;
    AI_EXH_B_TEMP_2: TiSevenSegmentInteger;
    AI_EXH_B_TEMP_3: TiSevenSegmentInteger;
    AI_EXH_B_TEMP_4: TiSevenSegmentInteger;
    AI_EXH_B_TEMP_5: TiSevenSegmentInteger;
    AI_EXH_B_TEMP_6: TiSevenSegmentInteger;
    AI_EXH_B_TEMP_7: TiSevenSegmentInteger;
    AI_EXH_B_TEMP_8: TiSevenSegmentInteger;
    AI_EXH_B_TEMP_9: TiSevenSegmentInteger;
    AI_EXH_B_TEMP_10: TiSevenSegmentInteger;
    AI_EXH_B_Avg: TiSevenSegmentInteger;
    AI_EXH_B_TC_A_INLETTEMP: TiSevenSegmentInteger;
    AI_EXH_B_TC_OUTLETTEMP: TiSevenSegmentInteger;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    SetConfig1: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
