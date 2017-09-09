unit LEDAlarmlistLampGen_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, AdvScrollBox,System.DateUtils;

type
  TLEDAlarmlistLampGen_Frm = class(TForm)
    AdvScrollBox1: TAdvScrollBox;
    Label2: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel2: TPanel;
    Panel9: TPanel;
    Panel4: TPanel;
    Panel3: TPanel;
    Panel10: TPanel;
    Panel6: TPanel;
    Panel5: TPanel;
    Panel11: TPanel;
    Panel7: TPanel;
    Panel1: TPanel;
    Image1: TImage;
    Panel8: TPanel;
    Image2: TImage;
    Panel12: TPanel;
    Image3: TImage;
    Panel13: TPanel;
    Image4: TImage;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel20: TPanel;
    Button5: TButton;
    Panel21: TPanel;
    Button4: TButton;
    Panel22: TPanel;
    Button6: TButton;
    Panel23: TPanel;
    Button2: TButton;
    edit1: TEdit;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel28: TPanel;
    procedure Panel2Click(Sender: TObject);
    procedure Panel9Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel10Click(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button6Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Panel11Click(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
    procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel9MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel10MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel6MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel11MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel11MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel7MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);

  private
    FLamp_Red: Integer;
    FEngineStatus: Integer;
    FEngineStatus2: Integer;
    FEngineStatus3: Integer;
    FEngineStatus4: Integer;
    FEngineStatus5: Integer;
    FEngineStatus6: Integer;
    FEngineStatus7: Integer;
    FLamp_Green: Integer;
    FLamp_Yellow: Integer;
    FSoundIndex: Integer;
    procedure SetGreenLamp(aIndex:Integer);
    procedure SetRedLamp(aIndex:Integer);
    procedure SetSoundIndex(aIndex:Integer);
    procedure SetYellowLamp(aIndex:Integer);
    procedure SetEngineStatus(aIndex:Integer);
    procedure SetEngineStatus2(aIndex:Integer);
    procedure SetEngineStatus6(aIndex:Integer);
    procedure SetEngineStatus7(aIndex:Integer);
    procedure EngineRunning_18H25V_Shoutdown;
    procedure EngineRunning_18H32V_Shoutdown;
    procedure EngineRunning_20H32V_Shoutdown;
    procedure EngineRunning_6H17U_Shoutdown;
    { Private declarations }
  public
    { Public declarations }
    property SoundIndex : Integer Read FSoundIndex write SetSoundIndex;
    property RedLamp : Integer Read FLamp_Red write SetRedLamp;
    property YellowLamp : Integer Read FLamp_Yellow write SetYellowLamp;
    property GreenLamp : Integer Read FLamp_Green write SetGreenLamp;

    property EngineStatus : Integer Read FEngineStatus write SetEngineStatus;
    property EngineStatus2 : Integer Read FEngineStatus2 write SetEngineStatus2;
    property EngineStatus6 : Integer Read FEngineStatus6 write SetEngineStatus6;
    property EngineStatus7 : Integer Read FEngineStatus7 write SetEngineStatus7;



    procedure Alarm_Generation;
    procedure Alarm_Generation2;
    procedure Alarm_Generation6;
    procedure Alarm_Generation7;
     //18H25V, 18H32V, 20H32V, 12H17V, 20H17V, 18H46V GEneration
    procedure EngineRunning_6H17U_Start;
    procedure EngineRunning_18H25V_Start;
    procedure EngineRunning_18H32V_Start;
    procedure EngineRunning_20H32V_Start;
     //18H25V, 18H32V, 20H32V, 12H17V, 20H17V, 18H46V START
    procedure EngineRunning_6H17U_Continue;
    procedure EngineRunning_18H25V_Continue;
    procedure EngineRunning_18H32V_Continue;
    procedure EngineRunning_20H32V_Continue;
     //18H25V, 18H32V, 20H32V, 12H17V, 20H17V, 18H46V CONTINUE
    procedure EngineRunning_6H17U_Stop;
    procedure EngineRunning_18H25V_Stop;
    procedure EngineRunning_18H32V_Stop;
    procedure EngineRunning_20H32V_Stop;
     //18H25V, 18H32V, 20H32V, 12H17V, 20H17V, 18H46V STOP
    procedure EngineRunning_6H17U_Shutdown;
    procedure EngineRunning_18H25V_Shutdown;
    procedure EngineRunning_18H32V_Shutdown;
    procedure EngineRunning_20H32V_Shutdown;
     //18H25V, 18H32V, 20H32V, 12H17V, 20H17V, 18H46V SHUTDOWN
    procedure Engine_6H17U_else;
    procedure Engine_18H25V_else;
    procedure Engine_18H32V_else;
    procedure Engine_20H32V_else;
     //18H25V, 18H32V, 20H32V, 12H17V, 20H17V, 18H46V ELSE

    procedure LAmp_On;
    procedure Sound_On;

  end;

var
  LEDAlarmlistLampGen_Frm: TLEDAlarmlistLampGen_Frm;

implementation
uses
DataModule_Unit;

procedure Usb_Qu_Open()  cdecl ; external 'Quvc_dll.dll';
procedure Usb_Qu_Close()  cdecl ; external 'Quvc_dll.dll';
function  Usb_Qu_Getstate(): integer cdecl ; external 'Quvc_dll.dll';
function Usb_Qu_write(Qu_index : byte;  Qu_type : byte; var pData): bool cdecl ; external 'Quvc_dll.dll';


{$R *.dfm}

procedure TLEDAlarmlistLampGen_Frm.Alarm_Generation;
const
  C_index       =	0;
  C_type	      = 0;     {    Sound 5ea model  }
  { C_type      = 3;     {    Sound 25ea model group Select 0-4 }

  C_dont	      = 100;   {  // Don't care  // Do not change before state }
  C_off         = 0;
  C_on          = 1;
  C_onoff       = 2;
var
  iStat : integer;
  m_str : string;
  bret : bool;
  cData:array [0..6] of Byte;
  i: Integer;

begin
  iStat := Usb_Qu_Getstate;
  if iStat > 0 then
  begin
//  EngineStatus = 1 엔진 작동중
    if (GreenLamp > 0) AND (EngineStatus = 1) then
    begin
      SetSoundIndex(0);
      cData[0] := RedLamp;          { lamp  1 }
      cData[1] := YellowLamp;       { lamp  2 }
      cData[2] := GreenLamp;        { lamp  3 }
      cData[3] := C_dont;
      cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }

      bret := Usb_Qu_write(C_index, C_type, cData[0]);
    end;

    //최초 실행시
    if (GreenLamp > 0) AND (EngineStatus = 0) then
    begin
      SetEngineStatus(1);

      cData[0] := RedLamp;          { lamp  1 }
      cData[1] := YellowLamp;       { lamp  2 }
      cData[2] := GreenLamp;        { lamp  3 }
      cData[3] := C_dont;
      cData[5] := SoundIndex;          { Sound Select 0-5;   0-off }
      bret := Usb_Qu_write(C_index, C_type, cData[0]);
      try
        Sleep(3000);
        SetSoundIndex(0);
      finally
        SetSoundIndex(0);
        cData[0] := RedLamp;          { lamp  1 }
        cData[1] := YellowLamp;       { lamp  2 }
        cData[2] := GreenLamp;        { lamp  3 }
        cData[3] := C_dont;
        cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }
        bret := Usb_Qu_write(C_index, C_type, cData[0]);
      end;
    end;

    //정상종료
    if (GreenLamp = 0) AND (YellowLamp = 0) AND (RedLamp = 0) AND (SoundIndex = 4) AND (EngineStatus = 0) then
    begin
      cData[0] := RedLamp;          { lamp  1 }
      cData[1] := YellowLamp;       { lamp  2 }
      cData[2] := GreenLamp;        { lamp  3 }
      cData[3] := C_dont;
      cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }
      bret := Usb_Qu_write(C_index, C_type, cData[0]);
      try
        SetSoundIndex(4);
        Sleep(3000);
        SetGreenLamp(0);
        SetSoundIndex(0);
      finally
        SetGreenLamp(0);
        SetSoundIndex(0);
        cData[0] := RedLamp;          { lamp  1 }
        cData[1] := YellowLamp;       { lamp  2 }
        cData[2] := GreenLamp;        { lamp  3 }
        cData[3] := C_dont;
        cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }
        bret := Usb_Qu_write(C_index, C_type, cData[0]);
      end;
    end;


    if GreenLamp > 0 then
    begin
      case GreenLamp of
        1 : m_str := ' Green Lamp On ';
        2 : m_str := ' Green Lamp Blink ';
      end;
    end else
    if RedLamp > 0 then
    begin
      case RedLamp of
        1 : m_str := ' Red Lamp On ';
        2 : m_str := ' Red Lamp Blink ';
      end;
    end;

    if bret = TRUE then
    begin
      iStat :=  Usb_Qu_Getstate();
//      m_str := ' Read Connect Usb ';

      if (iStat and $1) = $1	then
        m_str := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now) + m_str +'18H2533[Send Success]'
      else
        m_str := m_str + '[Send Error]';

      edit1.Text := m_str;
    end;
  end;
end;

procedure TLEDAlarmlistLampGen_Frm.Alarm_Generation2;
const
  C_index       =	0;
  C_type	      = 0;     {    Sound 5ea model  }
  { C_type      = 3;     {    Sound 25ea model group Select 0-4 }

  C_dont	      = 100;   {  // Don't care  // Do not change before state }
  C_off         = 0;
  C_on          = 1;
  C_onoff       = 2;
var
  iStat : integer;
  m_str : string;
  bret : bool;
  cData:array [0..6] of Byte;
  i: Integer;

begin
  iStat := Usb_Qu_Getstate;
  if iStat > 0 then
  begin
    if (GreenLamp > 0) AND (EngineStatus2 = 1) then
    begin
      SetSoundIndex(0);
      cData[0] := RedLamp;          { lamp  1 }
      cData[1] := YellowLamp;       { lamp  2 }
      cData[2] := GreenLamp;        { lamp  3 }
      cData[3] := C_dont;
      cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }

      bret := Usb_Qu_write(C_index, C_type, cData[0]);
    end;

    //최초 실행시
    if (GreenLamp > 0) AND (EngineStatus2 = 0) then
    begin
      SetEngineStatus2(1);

      cData[0] := RedLamp;          { lamp  1 }
      cData[1] := YellowLamp;       { lamp  2 }
      cData[2] := GreenLamp;        { lamp  3 }
      cData[3] := C_dont;
      cData[5] := SoundIndex;          { Sound Select 0-5;   0-off }
      bret := Usb_Qu_write(C_index, C_type, cData[0]);
      try
        Sleep(3000);
        SetSoundIndex(0);
      finally
        SetSoundIndex(0);
        cData[0] := RedLamp;          { lamp  1 }
        cData[1] := YellowLamp;       { lamp  2 }
        cData[2] := GreenLamp;        { lamp  3 }
        cData[3] := C_dont;
        cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }
        bret := Usb_Qu_write(C_index, C_type, cData[0]);
      end;
    end;

    //정상종료
    if (GreenLamp = 0) AND (YellowLamp = 0) AND (RedLamp = 0) AND (SoundIndex = 4) AND (EngineStatus2 = 0) then
    begin
      SetSoundIndex(0);
      cData[0] := RedLamp;          { lamp  1 }
      cData[1] := YellowLamp;       { lamp  2 }
      cData[2] := GreenLamp;        { lamp  3 }
      cData[3] := C_dont;
      cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }
      bret := Usb_Qu_write(C_index, C_type, cData[0]);
      try
        SetSoundIndex(4);
        Sleep(3000);
        SetGreenLamp(0);
        SetSoundIndex(0);
      finally
        SetGreenLamp(0);
        SetSoundIndex(0);
        cData[0] := RedLamp;          { lamp  1 }
        cData[1] := YellowLamp;       { lamp  2 }
        cData[2] := GreenLamp;        { lamp  3 }
        cData[3] := C_dont;
        cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }
        bret := Usb_Qu_write(C_index, C_type, cData[0]);
      end;
    end;


    if GreenLamp > 0 then
    begin
      case GreenLamp of
        1 : m_str := ' Green Lamp On ';
        2 : m_str := ' Green Lamp Blink ';
      end;
    end else
    if RedLamp > 0 then
    begin
      case RedLamp of
        1 : m_str := ' Red Lamp On ';
        2 : m_str := ' Red Lamp Blink ';
      end;
    end;

    if bret = TRUE then
    begin
      iStat :=  Usb_Qu_Getstate();
//      m_str := ' Read Connect Usb ';

      if (iStat and $1) = $1	then
        m_str := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now) + m_str +'6H1728[Send Success]'
      else
        m_str := m_str + '[Send Error]';

      edit1.Text := m_str;
    end;
  end;
end;

procedure TLEDAlarmlistLampGen_Frm.Alarm_Generation6;
const
  C_index       =	0;
  C_type	      = 0;     {    Sound 5ea model  }
  { C_type      = 3;     {    Sound 25ea model group Select 0-4 }

  C_dont	      = 100;   {  // Don't care  // Do not change before state }
  C_off         = 0;
  C_on          = 1;
  C_onoff       = 2;
var
  iStat : integer;
  m_str : string;
  bret : bool;
  cData:array [0..6] of Byte;
  i: Integer;

begin
  iStat := Usb_Qu_Getstate;
  if iStat > 0 then
  begin
    if (GreenLamp > 0) AND (EngineStatus6 = 1) then
    begin
      SetSoundIndex(0);
      cData[0] := RedLamp;          { lamp  1 }
      cData[1] := YellowLamp;       { lamp  2 }
      cData[2] := GreenLamp;        { lamp  3 }
      cData[3] := C_dont;
      cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }

      bret := Usb_Qu_write(C_index, C_type, cData[0]);
    end;

    //최초 실행시
    if (GreenLamp > 0) AND (EngineStatus6 = 0) then
    begin
      SetEngineStatus6(1);

      cData[0] := RedLamp;          { lamp  1 }
      cData[1] := YellowLamp;       { lamp  2 }
      cData[2] := GreenLamp;        { lamp  3 }
      cData[3] := C_dont;
      cData[5] := SoundIndex;          { Sound Select 0-5;   0-off }
      bret := Usb_Qu_write(C_index, C_type, cData[0]);
      try
        Sleep(3000);
        SetSoundIndex(0);
      finally
        SetSoundIndex(0);
        cData[0] := RedLamp;          { lamp  1 }
        cData[1] := YellowLamp;       { lamp  2 }
        cData[2] := GreenLamp;        { lamp  3 }
        cData[3] := C_dont;
        cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }
        bret := Usb_Qu_write(C_index, C_type, cData[0]);
      end;
    end;

    //정상종료
    if (GreenLamp = 0) AND (YellowLamp = 0) AND (RedLamp = 0) AND (SoundIndex = 4) AND (EngineStatus6 = 0) then
    begin
      bret := Usb_Qu_write(C_index, C_type, cData[0]);
      try
        SetSoundIndex(4);
        Sleep(3000);
        SetGreenLamp(0);
        SetSoundIndex(0);
      finally
        SetGreenLamp(0);
        SetSoundIndex(0);
        cData[0] := RedLamp;          { lamp  1 }
        cData[1] := YellowLamp;       { lamp  2 }
        cData[2] := GreenLamp;        { lamp  3 }
        cData[3] := C_dont;
        cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }
        bret := Usb_Qu_write(C_index, C_type, cData[0]);
      end;
    end;


    if GreenLamp > 0 then
    begin
      case GreenLamp of
        1 : m_str := ' Green Lamp On ';
        2 : m_str := ' Green Lamp Blink ';
      end;
    end else
    if RedLamp > 0 then
    begin
      case RedLamp of
        1 : m_str := ' Red Lamp On ';
        2 : m_str := ' Red Lamp Blink ';
      end;
    end;

    if bret = TRUE then
    begin
      iStat :=  Usb_Qu_Getstate();
//      m_str := ' Read Connect Usb ';

      if (iStat and $1) = $1	then
        m_str := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now) + m_str +'18H3240[Send Success]'
      else
        m_str := m_str + '[Send Error]';

      edit1.Text := m_str;
    end;
  end;
end;

procedure TLEDAlarmlistLampGen_Frm.Alarm_Generation7;
const
  C_index       =	0;
  C_type	      = 0;     {    Sound 5ea model  }
  { C_type      = 3;     {    Sound 25ea model group Select 0-4 }

  C_dont	      = 100;   {  // Don't care  // Do not change before state }
  C_off         = 0;
  C_on          = 1;
  C_onoff       = 2;
var
  iStat : integer;
  m_str : string;
  bret : bool;
  cData:array [0..6] of Byte;
  i: Integer;

begin
  iStat := Usb_Qu_Getstate;
  if iStat > 0 then
  begin
    if (GreenLamp > 0) AND (EngineStatus7 = 1) then
    begin
      SetSoundIndex(0);
      cData[0] := RedLamp;          { lamp  1 }
      cData[1] := YellowLamp;       { lamp  2 }
      cData[2] := GreenLamp;        { lamp  3 }
      cData[3] := C_dont;
      cData[5] := SoundIndex;       { Sound Select 0-5;   0-off }

      bret := Usb_Qu_write(C_index, C_type, cData[0]);
    end;

    //최초 실행시
    if (GreenLamp > 0) AND (EngineStatus7 = 0) then
    begin
      SetEngineStatus7(1);

      cData[0] := RedLamp;          { lamp  1 }
      cData[1] := YellowLamp;       { lamp  2 }
      cData[2] := GreenLamp;        { lamp  3 }
      cData[3] := C_dont;
      cData[5] := SoundIndex;          { Sound Select 0-5;   0-off }
      bret := Usb_Qu_write(C_index, C_type, cData[0]);
      try
        Sleep(3000);
        SetSoundIndex(0);
      finally
        SetSoundIndex(0);
        cData[0] := RedLamp;          { lamp  1 }
        cData[1] := YellowLamp;       { lamp  2 }
        cData[2] := GreenLamp;        { lamp  3 }
        cData[3] := C_dont;
        cData[5] := SoundIndex;          { Sound Select 0-5;   0-off }
        bret := Usb_Qu_write(C_index, C_type, cData[0]);
      end;
    end;

    //정상종료
    if (GreenLamp = 0) AND (YellowLamp = 0) AND (RedLamp = 0) AND (SoundIndex = 4) AND (EngineStatus7 = 0) then
    begin
      SetSoundIndex(0);
      cData[0] := RedLamp;          { lamp  1 }
      cData[1] := YellowLamp;       { lamp  2 }
      cData[2] := GreenLamp;        { lamp  3 }
      cData[3] := C_dont;
      cData[5] := SoundIndex;
      bret := Usb_Qu_write(C_index, C_type, cData[0]);
      try
        SetSoundIndex(0);
        Sleep(3000);
        SetGreenLamp(0);
        SetSoundIndex(0);
      finally
        SetGreenLamp(0);
        SetSoundIndex(0);
        cData[0] := RedLamp;          { lamp  1 }
        cData[1] := YellowLamp;       { lamp  2 }
        cData[2] := GreenLamp;        { lamp  3 }
        cData[3] := C_dont;
        cData[5] := SoundIndex;
        bret := Usb_Qu_write(C_index, C_type, cData[0]);
      end;
    end;


    if GreenLamp > 0 then
    begin
      case GreenLamp of
        1 : m_str := ' Green Lamp On ';
        2 : m_str := ' Green Lamp Blink ';
      end;
    end else
    if RedLamp > 0 then
    begin
      case RedLamp of
        1 : m_str := ' Red Lamp On ';
        2 : m_str := ' Red Lamp Blink ';
      end;
    end;

    if bret = TRUE then
    begin
      iStat :=  Usb_Qu_Getstate();
//      m_str := ' Read Connect Usb ';

      if (iStat and $1) = $1	then
        m_str := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now) + m_str +'20H3240[Send Success]'
      else
        m_str := m_str + '[Send Error]';

      edit1.Text := m_str;
    end;
  end;
end;

procedure TLEDAlarmlistLampGen_Frm.Button2Click(Sender: TObject);
begin
  SetSoundIndex(0);
  Sound_On;
  Usb_Qu_Close();
end;

procedure TLEDAlarmlistLampGen_Frm.Button4Click(Sender: TObject);
const
  C_index       =	0;
  C_type	      = 0;     {    Sound 5ea model  }
  { C_type      = 3;     {    Sound 25ea model group Select 0-4 }

  C_dont	      = 100;   {  // Don't care  // Do not change before state }
  C_off         = 0;
  C_on          = 1;
  C_onoff       = 2;
var 
  bret : bool;
  cData:array [0..6] of Byte;
begin
  SetSoundIndex(0);
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(0);

  if Usb_Qu_Getstate > 0 then
  begin
    cData[0] := RedLamp;          { lamp  1 }
    cData[1] := YellowLamp;       { lamp  2 }
    cData[2] := GreenLamp;        { lamp  3 }
    cData[3] := C_dont;
    cData[5] := SoundIndex;

    bret := Usb_Qu_write(C_index, C_type, cData[0]);

    Edit1.Text := ' ';
    Usb_Qu_Close();
  end;
end;

procedure TLEDAlarmlistLampGen_Frm.Button5Click(Sender: TObject);
var
  iStat, i : integer;
  m_str : string;
begin
  iStat :=  Usb_Qu_Getstate();
  m_str := ' Read Connect ';
	if EngineStatus = 1 then  m_str := m_str + '18H25/33V ENGINE' ;
  if EngineStatus2 = 1	then    m_str := m_str + '6H17/28U ENGINE';
 	if EngineStatus6 = 1	then    m_str := m_str + '18H32/40V ENGINE' ;
  if EngineStatus7 = 1	then    m_str := m_str + '20H32/40U ENGINE'
	else
    m_str := m_str + 'Index0(X), ';
    edit1.Text := m_str;
end;

procedure TLEDAlarmlistLampGen_Frm.Button6Click(Sender: TObject);
begin
  Usb_Qu_Close();
  close;
end;
procedure TLEDAlarmlistLampGen_Frm.EngineRunning_18H25V_Continue;
begin
  SetEngineStatus(1);
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(2);
  SetSoundIndex(0);
  Alarm_Generation;
end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_18H25V_Shoutdown;
begin

end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_18H25V_Shutdown;
begin

end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_18H25V_Start;
begin
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(2);
  SetSoundIndex(4);
  Alarm_Generation;
end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_18H25V_Stop;
begin
  SetEngineStatus(0);
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(0);
  SetSoundIndex(4);
  Alarm_Generation;
end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_18H32V_Continue;
begin
  SetEngineStatus6(1);
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(2);
  SetSoundIndex(0);
  Alarm_Generation6;
end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_18H32V_Shoutdown;
begin

end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_18H32V_Shutdown;
begin

end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_18H32V_Start;
begin

  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(2);
  SetSoundIndex(4);
  Alarm_Generation6;
end;


procedure TLEDAlarmlistLampGen_Frm.EngineRunning_18H32V_Stop;
begin
  SetEngineStatus6(0);
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(0);
  SetSoundIndex(4);
  Alarm_Generation6;
end;
procedure TLEDAlarmlistLampGen_Frm.EngineRunning_20H32V_Continue;
begin
  SetEngineStatus7(1);
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(2);
  SetSoundIndex(0);
  Alarm_Generation7;
end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_20H32V_Stop;
begin
  SetEngineStatus7(0);
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(0);
  SetSoundIndex(4);
  Alarm_Generation7;
end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_20H32V_Shoutdown;
begin

end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_20H32V_Shutdown;
begin

end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_20H32V_Start;
begin
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(2);
  SetSoundIndex(4);
  Alarm_Generation7;
end;


procedure TLEDAlarmlistLampGen_Frm.EngineRunning_6H17U_Continue;
begin
  SetEngineStatus2(1);
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(2);
  SetSoundIndex(0);
  Alarm_Generation2;
end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_6H17U_Shoutdown;
begin

end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_6H17U_Shutdown;
begin

end;

procedure TLEDAlarmlistLampGen_Frm.EngineRunning_6H17U_Start;
begin
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(2);
  SetSoundIndex(4);
  Alarm_Generation2;
end;


procedure TLEDAlarmlistLampGen_Frm.EngineRunning_6H17U_Stop;
begin
  SetEngineStatus(0);
  SetRedLamp(0);
  SetYellowLamp(0);
  SetGreenLamp(0);
  SetSoundIndex(4);
  Alarm_Generation2;
end;

procedure TLEDAlarmlistLampGen_Frm.Engine_18H25V_else;
begin
  SetEngineStatus(0);

  if EngineStatus = 1 then
 begin
   SetEngineStatus(0);
   SetRedLamp(0);
   SetYellowLamp(0);
   SetGreenLamp(0);
   SetSoundIndex(0);
   Alarm_Generation;
 end;

  if (RedLamp > 0) or (YellowLamp > 0) or (GreenLamp > 0) or (SoundIndex > 0) then
  begin
    SetRedLamp(0);
    SetYellowLamp(0);
    SetGreenLamp(0);
    SetSoundIndex(0);

   Alarm_Generation;

  end;
end;

procedure TLEDAlarmlistLampGen_Frm.Engine_18H32V_else;
begin
  SetEngineStatus6(0);

  if EngineStatus6 = 1 then
 begin
   SetEngineStatus(0);
   SetRedLamp(0);
   SetYellowLamp(0);
   SetGreenLamp(0);
   SetSoundIndex(0);
   Alarm_Generation6;
 end;

  if (RedLamp > 0) or (YellowLamp > 0) or (GreenLamp > 0) or (SoundIndex > 0) then
  begin
    SetRedLamp(0);
    SetYellowLamp(0);
    SetGreenLamp(0);
    SetSoundIndex(0);

   Alarm_Generation6;

  end;
end;

procedure TLEDAlarmlistLampGen_Frm.Engine_20H32V_else;
begin
  SetEngineStatus7(0);

  if EngineStatus7 = 1 then
 begin
   SetEngineStatus7(0);
   SetRedLamp(0);
   SetYellowLamp(0);
   SetGreenLamp(0);
   SetSoundIndex(0);
   Alarm_Generation7;
 end;

  if (RedLamp > 0) or (YellowLamp > 0) or (GreenLamp > 0) or (SoundIndex > 0) then
  begin
    SetRedLamp(0);
    SetYellowLamp(0);
    SetGreenLamp(0);
    SetSoundIndex(0);

   Alarm_Generation7;

  end;
end;

procedure TLEDAlarmlistLampGen_Frm.Engine_6H17U_else;
begin
  SetEngineStatus2(0);

  if EngineStatus2 = 1 then
 begin
   SetEngineStatus2(0);
   SetRedLamp(0);
   SetYellowLamp(0);
   SetGreenLamp(0);
   SetSoundIndex(0);
   Alarm_Generation2;
 end;

  if (RedLamp > 0) or (YellowLamp > 0) or (GreenLamp > 0) or (SoundIndex > 0) then
  begin
    SetRedLamp(0);
    SetYellowLamp(0);
    SetGreenLamp(0);
    SetSoundIndex(0);

   Alarm_Generation2;

  end;
end;

procedure TLEDAlarmlistLampGen_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Usb_Qu_Close();
  Close;
end;

procedure TLEDAlarmlistLampGen_Frm.Image1Click(Sender: TObject);
begin
  SetSoundIndex(1);
  Sound_On;
  Usb_Qu_Close();
end;

procedure TLEDAlarmlistLampGen_Frm.Image2Click(Sender: TObject);
begin
  SetSoundIndex(2);
  Sound_On;
  Usb_Qu_Close();  
end;

procedure TLEDAlarmlistLampGen_Frm.Image3Click(Sender: TObject);
begin
  SetSoundIndex(3);
  Sound_On;
  Usb_Qu_Close();  
end;

procedure TLEDAlarmlistLampGen_Frm.Image4Click(Sender: TObject);
begin
  SetSoundIndex(4);
  Sound_On;
  Usb_Qu_Close();
end;

procedure TLEDAlarmlistLampGen_Frm.Panel10Click(Sender: TObject);
begin   
  SetYellowLamp(2);
  SetSoundIndex(0);
  LAmp_On;
  Usb_Qu_Close();
end;

procedure TLEDAlarmlistLampGen_Frm.Panel10MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel10.Color := $002DC6D2;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel10MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel10.Color := $0025ADDA;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel11Click(Sender: TObject);
begin 
  SetGreenLamp(2);
  SetSoundIndex(0);
  LAmp_On;
  Usb_Qu_Close();
end;

procedure TLEDAlarmlistLampGen_Frm.Panel11MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel11.Color := $001B6526;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel11MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel11.Color := $00097735;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel2Click(Sender: TObject);
begin
  SetRedLamp(1);
  SetSoundIndex(0);
  LAmp_On;
  Usb_Qu_Close();
end;

procedure TLEDAlarmlistLampGen_Frm.Panel2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel2.Color := $002243DD;     
end;

procedure TLEDAlarmlistLampGen_Frm.Panel2MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin 
  Panel2.Color := clRed;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel3Click(Sender: TObject);
begin    
  SetYellowLamp(1);
  SetSoundIndex(0);
  LAmp_On;
  Usb_Qu_Close();
end;

procedure TLEDAlarmlistLampGen_Frm.Panel3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel3.Color := $002DC6D2;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel3MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel3.Color := $0025ADDA;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel4Click(Sender: TObject);
begin
  SetRedLamp(0);
  SetSoundIndex(0);
  LAmp_On;
  Usb_Qu_Close();
end;

procedure TLEDAlarmlistLampGen_Frm.Panel4MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel4.Color := $002243DD;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel4MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel4.Color := clRed;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel5Click(Sender: TObject);
begin      
  SetGreenLamp(1);
  SetSoundIndex(0);
  LAmp_On;
  Usb_Qu_Close();
end;

procedure TLEDAlarmlistLampGen_Frm.Panel5MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel5.Color := $001B6526;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel5MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel5.Color := $00097735;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel6Click(Sender: TObject);
begin  
  SetYellowLamp(0);
  SetSoundIndex(0);
  LAmp_On;
  Usb_Qu_Close();
end;

procedure TLEDAlarmlistLampGen_Frm.Panel6MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel6.Color := $002DC6D2;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel6MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel6.Color := $0025ADDA;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel7Click(Sender: TObject);
begin    
  SetGreenLamp(0);
  SetSoundIndex(0);
  LAmp_On;
  Usb_Qu_Close();
end;

procedure TLEDAlarmlistLampGen_Frm.Panel7MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel7.Color := $001B6526;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel7MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel7.Color := $00097735;
end;

procedure TLEDAlarmlistLampGen_Frm.Panel9Click(Sender: TObject);
begin        
  SetRedLamp(2);
  SetSoundIndex(0);
  LAmp_On;
  Usb_Qu_Close();
end; 

procedure TLEDAlarmlistLampGen_Frm.Panel9MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel9.Color := $002243DD; 
end;

procedure TLEDAlarmlistLampGen_Frm.Panel9MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Panel9.Color := clRed;
end;

procedure TLEDAlarmlistLampGen_Frm.LAmp_On;
const
  C_index       =	0;
  C_type	      = 0;     {    Sound 5ea model  }
  C_dont	      = 100;   {  // Don't care  // Do not change before state }
  C_off         = 0;
  C_on          = 1;
  C_onoff       = 2;
var
  iStat : integer;
  m_str : string;
  bret : bool;
  cData:array [0..6] of Byte;
begin
  if Usb_Qu_Getstate > 0 then
  begin
    cData[0] := RedLamp;         { lamp  1 }
    cData[1] := YellowLamp;      { lamp  2 }
    cData[2] := GreenLamp;       { lamp  3 }
    cData[3] := C_dont;
    cData[5] := SoundIndex;      { Sound Select 0-5;   0-off }

    bret := Usb_Qu_write(C_index, C_type, cData[0]);

    if bret = TRUE then
    begin
    iStat :=  Usb_Qu_Getstate();
    m_str := ' Read Connect Usb ';
    if (iStat and $1) = $1	then
    m_str := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now) + m_str +'[Send Success]Lamp'
    else
      m_str := m_str + '[Send Error]';

    edit1.Text := m_str;
    end;
  end;
end;
procedure TLEDAlarmlistLampGen_Frm.SetEngineStatus(aIndex: Integer);
begin
  FEngineStatus := aIndex;
end;

procedure TLEDAlarmlistLampGen_Frm.SetEngineStatus2(aIndex: Integer);
begin
  FEngineStatus2 := aIndex;
end;
procedure TLEDAlarmlistLampGen_Frm.SetEngineStatus6(aIndex: Integer);
begin
  FEngineStatus6 := aIndex;
end;

procedure TLEDAlarmlistLampGen_Frm.SetEngineStatus7(aIndex: Integer);
begin
  FEngineStatus7 := aIndex;
end;

procedure TLEDAlarmlistLampGen_Frm.SetGreenLamp(aIndex: Integer);
begin
  FLamp_Green := aIndex;
end;

procedure TLEDAlarmlistLampGen_Frm.SetRedLamp(aIndex: Integer);
begin
  FLamp_Red := aIndex;
end;

procedure TLEDAlarmlistLampGen_Frm.SetSoundIndex(aIndex: Integer);
begin
  FSoundIndex := aIndex;
end;

procedure TLEDAlarmlistLampGen_Frm.SetYellowLamp(aIndex: Integer);
begin
  FLamp_Yellow := aIndex;
end;

procedure TLEDAlarmlistLampGen_Frm.Sound_On;
const
  C_index       =	0;
  C_type	      = 0;     {    Sound 5ea model  }
  C_dont	      = 100;   {  // Don't care  // Do not change before state }
  C_off         = 0;
  C_on          = 1;
  C_onoff       = 2;
var
  iStat : integer;
  m_str : string;
  bret : bool;
  cData:array [0..6] of Byte;
begin
  if Usb_Qu_Getstate > 0 then
  begin
    cData[0] := RedLamp;         { lamp  1 }
    cData[1] := YellowLamp;      { lamp  2 }
    cData[2] := GreenLamp;       { lamp  3 }
    cData[3] := C_dont;
    cData[5] := SoundIndex;      { Sound Select 0-5;   0-off }

    bret := Usb_Qu_write(C_index, C_type, cData[0]);

    if bret = TRUE then
    begin
    iStat :=  Usb_Qu_Getstate();
    m_str := ' Read Connect Usb ';
    if (iStat and $1) = $1	then
    m_str := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now) + m_str +'[Send Success]Sound'
    else
      m_str := m_str + '[Send Error]';

    edit1.Text := m_str;
    end;
  end;
end;
end.
