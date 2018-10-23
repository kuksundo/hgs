unit FrmFileOpen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UnitGSFileOpenConfigOptionClass,
  UnitMSWordUtil, UnitExcelUtil;

type
  TForm7 = class(TForm)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
  private
    FCommandLine: TGSFileOpenCommandLineOption;
    function CommandLineParse(var AErrMsg: string): boolean;
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

uses GpCommandLineParser;

{$R *.dfm}

{ TForm7 }

function TForm7.CommandLineParse(var AErrMsg: string): boolean;
var
  LStr: string;
begin
  AErrMsg := '';
  FCommandLine := TGSFileOpenCommandLineOption.Create;
  try
    Result := CommandLineParser.Parse(FCommandLine);
  except
    on E: ECLPConfigurationError do begin
      AErrMsg := '*** Configuration error ***' + #13#10 +
        Format('%s, position = %d, name = %s',
          [E.ErrorInfo.Text, E.ErrorInfo.Position, E.ErrorInfo.SwitchName]);
      Exit;
    end;
  end;

  if not Result then
  begin
    AErrMsg := Format('%s, position = %d, name = %s',
      [CommandLineParser.ErrorInfo.Text, CommandLineParser.ErrorInfo.Position,
       CommandLineParser.ErrorInfo.SwitchName]) + #13#10;
    for LStr in CommandLineParser.Usage do
      AErrMsg := AErrMSg + LStr + #13#10;
  end
  else
  begin
  end;
end;

procedure TForm7.FormCreate(Sender: TObject);
var
  LErrMsg: string;
begin
  CommandLineParse(LErrMsg);
end;

end.
