unit uConfig;

interface

uses
  uXMLConfig;

type
  TConfig = class(TXMLConfig)
  private
    FTest: string;
  public
  published
    property Test: string read FTest write FTest;
  end;

var
  Config: TConfig;

implementation

{ TConfig }

end.
