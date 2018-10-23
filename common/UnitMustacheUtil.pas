unit UnitMustacheUtil;

interface

uses System.Classes, Dialogs, System.Rtti,
  SynCommons, mORMot, SynMustache;

function GetMustacheJSONFromFile(ADoc: variant; AMustacheFile: string): string;
function GetMustacheJSONFromStr(ADoc: variant; AMustacheStr: string): string;

implementation

function GetMustacheJSONFromFile(ADoc: variant;
  AMustacheFile: string): string;
var
  LJSON: RawUTF8;
  LMustache: TSynMustache;
  LFile: RawByteString;
begin
  LJSON := Utf8ToString(VariantSaveJson(ADoc));
  LFile := StringFromFile(AMustacheFile);
  LMustache := TSynMustache.Parse(LFile);
  Result := Utf8ToString(BinToBase64(LMustache.RenderJSON(LJSON)));
end;

function GetMustacheJSONFromStr(ADoc: variant; AMustacheStr: string): string;
var
  LJSON: RawUTF8;
  LMustache: TSynMustache;
//  LStr: RawUTF8;
begin
  LJSON := Utf8ToString(VariantSaveJson(ADoc));
  LMustache := TSynMustache.Parse(AMustacheStr);
  Result := LMustache.RenderJSON(LJSON);
end;

end.
