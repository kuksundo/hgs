unit DammenEval;

interface

uses
  Windows, Forms, Classes;

type

{ TEvalThread }

  TEvalThread = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

implementation

{ TEvalThread }

constructor TEvalThread.Create;
begin
  inherited Create(False);
  Priority := tpLower;
  FreeOnTerminate := True;
end;

{ The Execute method is called when the thread starts }

procedure TEvalThread.Execute;
begin
  repeat
    Sleep(100);
    Application.ProcessMessages;
  until Terminated;
end;

end.
