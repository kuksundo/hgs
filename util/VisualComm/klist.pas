unit klist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  Tkeylist = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  keylist: Tkeylist;

implementation

{$R *.dfm}

procedure Tkeylist.Button1Click(Sender: TObject);
begin
close;
end;

end.
