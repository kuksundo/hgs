unit UnitmORMotUtil;

interface

uses SynCrtSock, SynCommons;

procedure SendPostUsingSynCrt(AUrl: string; AJson: variant);

implementation

{Usage:
var t: variant
begin
  TDocVariant.new(t);
  t.name := 'jhon';
  t.year := 1982;
  SendPostUsingSynCrt('http://servername/resourcename',t);
end}
procedure SendPostUsingSynCrt(AUrl: string; AJson: variant);
begin
  TWinHttp.Post(AUrl, AJson, 'Content-Type: application/json');
end;

end.
