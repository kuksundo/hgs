unit InitFont;

interface

function ChangeDefFontData: Boolean;

implementation

uses Windows, Graphics;

function ChangeDefFontData: Boolean;
var
  LogFont: TLogFont;
begin
  Result := False;
  if SystemParametersInfo(SPI_GETICONTITLELOGFONT, SizeOf(LogFont), @LogFont, 0) then
  begin
    Result := (DefFontData.Name <> AnsiString(LogFont.lfFaceName)) or
      (DefFontData.Height <> LogFont.lfHeight);
    if Result then
    begin
      DefFontData.Name := AnsiString(LogFont.lfFaceName);
      DefFontData.Height := LogFont.lfHeight;
    end;
  end;
end;

initialization
  ChangeDefFontData;
end.
 