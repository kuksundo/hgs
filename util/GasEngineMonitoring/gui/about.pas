unit about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, BGVersion;

type
  TAboutF = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    VersionLavel: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TAboutF.FormCreate(Sender: TObject);
var
  LVersion: TBGVersion;
begin
  LVersion := TBGVersion.Create;
  try
    VersionLavel.Caption := 'Version : ' + LVersion.GetInstance.ToString;
  finally
    LVersion.Free;
  end;
end;

end.
