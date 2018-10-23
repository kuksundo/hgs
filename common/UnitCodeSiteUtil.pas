unit UnitCodeSiteUtil;

interface

uses System.SysUtils, System.Classes,
 {$IFDEF USECODESITE} CodeSiteLogging, {$ENDIF}
 System.DateUtils;

procedure CodeSiteLog(AFuncName, AValue: string);

implementation

procedure CodeSiteLog(AFuncName, AValue: string);
begin
  {$IFDEF USECODESITE}
  CodeSite.EnterMethod(DateTimeToStr(now) + ': ' + AFuncName + ' ===> ');
  try
    CodeSite.send(AValue);
  finally
    CodeSite.ExitMethod(DateTimeToStr(now) + ': ' + AFuncName + ' <=== ');
  end;
  {$ENDIF}
end;

end.
