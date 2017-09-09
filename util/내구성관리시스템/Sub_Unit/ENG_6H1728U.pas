{********************************************************************}
{ TRTFLABEL DEMO                                                     }
{ version 1.2                                                        }
{ for Delphi 4.0,5.0,6.0,7.0 & C++Builder 4.0,5.0,6.0                }
{                                                                    }
{ written by TMS Software                                            }
{            copyright ?1998-2004                                   }
{            Email : info@tmssoftware.com                            }
{            Website : http://www.tmssoftware.com                    }
{********************************************************************}

unit ENG_6H1728U;

interface

uses
  Main_Unit, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, rtflabel, ExtCtrls;

type
  TEng_6H1728U_Frm = class(TForm)
    GroupBox1: TGroupBox;
    RTFLabel1: TRTFLabel;
    GroupBox2: TGroupBox;
    RTFLabel2: TRTFLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ShowTime;
  public
    { Public declarations }
    FOwner : TMain_Frm;
  end;

var
  Eng_6H1728U_Frm: TEng_6H1728U_Frm;

implementation

{$R *.DFM}
procedure TEng_6H1728U_Frm.ShowTime;
begin
 rtflabel2.beginupdate;
 with rtflabel2.rtf do
  begin
   text:='Date is : '+datetostr(now)+#13'Time is :'+timetostr(now);
   selstart:=10;
   sellength:=length(datetostr(now));
   selattributes.color:=clBlue;
   selattributes.style:=[fsBold];
   selstart:=selstart+sellength+10;
   sellength:=length(timetostr(now));
   selattributes.color:=clGreen;
   selattributes.style:=[fsBold];
  end;
 rtflabel2.endupdate;
end;

procedure TEng_6H1728U_Frm.Timer1Timer(Sender: TObject);
begin
 showtime;
end;

procedure TEng_6H1728U_Frm.FormCreate(Sender: TObject);
begin
showtime;
end;

end.
