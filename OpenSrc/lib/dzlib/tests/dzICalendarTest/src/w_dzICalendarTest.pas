unit w_dzICalendarTest;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls;

type
  TForm1 = class(TForm)
    b_Start: TButton;
    lv_Events: TListView;
    rb_FeiertageNRW: TRadioButton;
    rb_Example: TRadioButton;
    rb_Dummzeuch: TRadioButton;
    procedure b_StartClick(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  u_dzFileUtils,
  u_dzVclUtils,
  u_dzNullableDate,
  u_dzNullableDateTime,
  u_dzICalendar,
  u_dzICalParser;

procedure TForm1.b_StartClick(Sender: TObject);
const
  Feiertage = 'feiertage_deutschland-2010-2013.ics';
  Example = 'example.ics';
  dummzeuch = 'dummzeuch@gmail.com_dummzeuch@gmail.com.ics';
var
  ICal: TdzICalendar;
  Parser: TDzIcalendarParser;
  i: Integer;
  li: TListItem;
  Event: TdzICalendarEvent;
  IcsFile: string;
begin
  if rb_FeiertageNRW.Checked then
    IcsFile := Feiertage
  else if rb_Example.Checked then
    IcsFile := Example
  else
    IcsFile := dummzeuch;
  ICal := TdzICalendar.Create;
  try
    Parser := TDzIcalendarParser.Create;
    try
      Parser.ICalendar := ICal;
      Parser.ParseFile(itpd(TApplication_GetExePath) + IcsFile);
    finally
      FreeAndNil(Parser);
    end;

    if rb_FeiertageNRW.Checked then begin
      for i := ICal.Count - 1 downto 0 do begin
        Event := ICal[i];
      // remove years <>2011
        if Event.DTStart.Date.Year <> 2011 then
          ICal.Delete(i)
      // remove holidays that are not valid vor NRW
        else if Pos('NRW', Event.Description) = 0 then
          ICal.Delete(i);
      end;
    end;

    ICal.Sort;

    lv_Events.Items.BeginUpdate;
    try
      for i := 0 to ICal.Count - 1 do begin
        Event := ICal[i];
        li := lv_Events.Items.Add;
        if Event.DTStart.IsValid then
          li.Caption := string(Event.DTStart)
        else
          li.Caption := '';
        if Event.DTEnd.IsValid then
          li.SubItems.Add(string(Event.DTEnd))
        else
          li.SubItems.Add('');
        if Event.Duration.IsValid then
          li.SubItems.Add(string(Event.Duration))
        else
          li.SubItems.Add('');
        li.SubItems.Add(Event.Summary);
        li.SubItems.Add(Event.Description);
      end;
    finally
      lv_Events.Items.EndUpdate;
    end;
  finally
    FreeAndNil(ICal);
  end;
end;

end.

