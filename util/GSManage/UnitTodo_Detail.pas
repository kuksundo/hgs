unit UnitTodo_Detail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, DateUtils;

type
  ALARM_INTERVAL = (aiNone, ai0Min,ai5Min,ai10Min,ai15Min,ai30Min,
                ai1Hour,ai2Hour,ai3Hour,ai4Hour,ai5Hour,ai6Hour,ai7Hour,ai8Hour,
                ai9Hour,ai10Hour,ai11Hour,ai18Hour,ai1Day,ai2Day,ai3Day,
                ai4Day,ai1Week,ai2Week);

  TToDoDetailF = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    SubjectEdit: TEdit;
    NoteMemo: TMemo;
    Panel6: TPanel;
    Label2: TLabel;
    dt_begin: TDateTimePicker;
    Time_Begin: TDateTimePicker;
    Label3: TLabel;
    dt_end: TDateTimePicker;
    Time_End: TDateTimePicker;
    Label4: TLabel;
    AlarmCombo: TComboBox;
    Button1: TButton;
    Label5: TLabel;
    MsgCB: TCheckBox;
    NoteCB: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetAlarmInterval(AInterval: integer): longint;
  function GetAlarmComboIndex(AAlarmMinute: integer): integer;
var
  ToDoDetailF: TToDoDetailF;

implementation

uses UnitDateUtil;

{$R *.dfm}

procedure TToDoDetailF.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TToDoDetailF.BitBtn2Click(Sender: TObject);
begin
//  ModalResult := mrOK;
end;

procedure TToDoDetailF.Button1Click(Sender: TObject);
var
  myHour, myMin, mySec, myMilli : Word;
  myYear, myMonth, myDay : Word;
  Ldt: TDateTime;
  LMin: integer;
begin
  DecodeDate(dt_begin.Date,myYear, myMonth, myDay);
  DecodeTime(Time_Begin.Time, myHour, myMin, mySec, myMilli);
  Ldt := EncodeDateTime(myYear, myMonth, myDay, myHour, myMin, mySec, myMilli);
  LMin := GetAlarmInterval(AlarmCombo.ItemIndex);
  Ldt := DateTimeMinusInteger(Ldt, LMin, 2, '-');
  dt_end.date := Ldt;
  DecodeTime(Ldt, myHour, myMin, mySec, myMilli);
  Time_End.Time := EncodeTime(myHour, myMin, mySec, myMilli);
end;

procedure TToDoDetailF.FormCreate(Sender: TObject);
begin
  dt_begin.DateTime := now;
  Time_Begin.DateTime := now;
  dt_end.DateTime := now;
  Time_end.DateTime := now;
end;

//분단위 숫자 반환
function GetAlarmInterval(AInterval: integer): longint;
begin
  case ALARM_INTERVAL(AInterval) of
    aiNone: Result := -1;
    ai0Min: Result := 0;
    ai5Min: Result := 5;
    ai10Min: Result := 10;
    ai15Min: Result := 15;
    ai30Min: Result := 30;
    ai1Hour: Result := 60;
    ai2Hour: Result := 120;
    ai3Hour: Result := 180;
    ai4Hour: Result := 240;
    ai5Hour: Result := 300;
    ai6Hour: Result := 360;
    ai7Hour: Result := 420;
    ai8Hour: Result := 480;
    ai9Hour: Result := 540;
    ai10Hour: Result := 600;
    ai11Hour: Result := 660;
    ai18Hour: Result := 1080;
    ai1Day: Result := 1440;
    ai2Day: Result := 2880;
    ai3Day: Result := 4320;
    ai4Day: Result := 5760;
    ai1Week: Result := 10080;
    ai2Week: Result := 20160;
  end;
end;

function GetAlarmComboIndex(AAlarmMinute: integer): integer;
begin
  case AAlarmMinute of
    -1 : Result := ord(aiNone);
    0: Result := ord(ai0Min);
    5: Result := ord(ai5Min);
    10: Result := ord(ai10Min);
    15: Result := ord(ai15Min);
    30: Result := ord(ai30Min);
    60: Result := ord(ai1Hour);
    120: Result := ord(ai2Hour);
    180: Result := ord(ai3Hour);
    240: Result := ord(ai4Hour);
    300: Result := ord(ai5Hour);
    360: Result := ord(ai6Hour);
    420: Result := ord(ai7Hour);
    480: Result := ord(ai8Hour);
    540: Result := ord(ai9Hour);
    600: Result := ord(ai10Hour);
    660: Result := ord(ai11Hour);
    1080: Result := ord(ai18Hour);
    1440: Result := ord(ai1Day);
    2880: Result := ord(ai2Day);
    4320: Result := ord(ai3Day);
    5760: Result := ord(ai4Day);
    10080: Result := ord(ai1Week);
    20160: Result := ord(ai2Week);
  end;
end;

end.
