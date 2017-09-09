unit UnitNotifyScheduleEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, DateUtils, UnitNotifyScheduleClass, AdvOfficeButtons;

type
  TNotifyScheduleEditF = class(TForm)
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
    ComboBox1: TComboBox;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    MonCB: TAdvOfficeCheckBox;
    TueCB: TAdvOfficeCheckBox;
    WedCB: TAdvOfficeCheckBox;
    ThuCB: TAdvOfficeCheckBox;
    FriCB: TAdvOfficeCheckBox;
    SatCB: TAdvOfficeCheckBox;
    SunCB: TAdvOfficeCheckBox;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    FNotifyScheduleInfo: TNotifyScheduleInfo;

    procedure SetNotifyScheduleInfo(ANSI: TNotifyScheduleInfo);
    procedure SetDaysCB(ADays: TpjhNotifyDays);
  public
    property NotifyScheduleInfo: TNotifyScheduleInfo read FNotifyScheduleInfo write SetNotifyScheduleInfo;
  end;

function Create_NotifyScheduleEdit_Frm(ANotifyScheduleInfo: TNotifyScheduleInfo) : String;

var
  NotifyScheduleEditF: TNotifyScheduleEditF;

implementation

uses CommonUtil_Unit;

{$R *.dfm}

function Create_NotifyScheduleEdit_Frm(ANotifyScheduleInfo: TNotifyScheduleInfo) : String;
begin
  NotifyScheduleEditF := TNotifyScheduleEditF.Create(nil);
  try
    with NotifyScheduleEditF do
    begin
      SetNotifyScheduleInfo(ANotifyScheduleInfo);

    end;
  finally
    FreeAndNil(NotifyScheduleEditF);
  end;
end;

procedure TNotifyScheduleEditF.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TNotifyScheduleEditF.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TNotifyScheduleEditF.Button1Click(Sender: TObject);
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

procedure TNotifyScheduleEditF.ComboBox1Change(Sender: TObject);
var
  ADays: TpjhNotifyDays;
begin
  dt_begin.Enabled := ComboBox1.ItemIndex = 4;
  dt_end.Enabled := ComboBox1.ItemIndex = 4;

  case ComboBox1.ItemIndex of
    0: ;
    1: SetDaysCB([Mon,Tue,Wed,Thu,Fri,Sat,Sun]);//概老
    2: SetDaysCB([Mon,Tue,Wed,Thu,Fri]);//概林
    3: SetDaysCB([Sat,Sun]);//概林富
  end;
end;

procedure TNotifyScheduleEditF.FormCreate(Sender: TObject);
begin
  dt_begin.DateTime := now;
  Time_Begin.DateTime := now;
  dt_end.DateTime := now;
  Time_end.DateTime := now;
end;

procedure TNotifyScheduleEditF.SetDaysCB(ADays: TpjhNotifyDays);
begin
  MonCB.Checked := [Mon] in ADays;
  TueCB.Checked := [Tue] in ADays;
  WedCB.Checked := [Wed] in ADays;
  ThuCB.Checked := [Thu] in ADays;
  FriCB.Checked := [Fri] in ADays;
  SatCB.Checked := [Sat] in ADays;
  SunCB.Checked := [Sun] in ADays;
end;

procedure TNotifyScheduleEditF.SetNotifyScheduleInfo(ANSI: TNotifyScheduleInfo);
begin
  FNotifyScheduleInfo := ANSI;
end;

end.
