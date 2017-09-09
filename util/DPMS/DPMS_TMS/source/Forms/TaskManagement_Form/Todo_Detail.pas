unit Todo_Detail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, DateUtils;

type
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

var
  ToDoDetailF: TToDoDetailF;

implementation

uses CommonUtil_Unit, HiTEMS_TMS_CONST;

{$R *.dfm}

procedure TToDoDetailF.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TToDoDetailF.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrOK;
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

end.
