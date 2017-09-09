{ *********************************************************************** }
{                                                                         }
{ ParseValidator                                                          }
{                                                                         }
{ Copyright (c) 2006 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit ParseValidator;

{$B-}
{$I Directives.inc}

interface

uses
  ParseTypes, SysUtils, Types, TextConsts;

type
  TReserveType = (rtName, rtText);

  EValidatorError = class(Exception);

  TValidator = class
  protected
    function Error(const Message: string): Exception; overload; virtual;
    function Error(const Message: string; const Arguments: array of const): Exception; overload; virtual;
  public
    procedure Check(const AText: string; const AType: TReserveType); virtual;
  end;

var
  Validator: TValidator;
  Reserve: array[TReserveType] of string;

implementation

uses
  NumberConsts, ParseErrors, ParseUtils, TextUtils;

{ TValidator }

{$WARNINGS OFF}
procedure TValidator.Check(const AText: string; const AType: TReserveType);
var
  LockArray: TLockArray;
  I: Integer;
begin
  if AType = rtText then LockArray := GetLockArray(AText, ParseUtils.LockChar);
  try
    for I := 1 to Length(AText) do
      if ((AType <> rtText) or not Locked(I, LockArray)) and Contains(Reserve[AType], AText[I]) then
        raise Error(ReserveError, [AText, Reserve[AType][I]]);
  finally
    LockArray := nil;
  end;
  if (AType = rtName) and (Length(AText) > 0) and Number(AText[1]) then
    raise Error(DefinitionError, [AText]);
end;
{$WARNINGS ON}

function TValidator.Error(const Message: string): Exception;
begin
  Result := Error(Message, []);
end;

function TValidator.Error(const Message: string;
  const Arguments: array of const): Exception;
begin
  Result := EValidatorError.CreateFmt(Message, Arguments);
end;

initialization
  Validator := TValidator.Create;
  Reserve[rtName] := LeftBrace + RightBrace + LeftParenthesis + RightParenthesis +
    LeftBracket + RightBracket + Comma + {$IFDEF DELPHI_XE}FormatSettings.DecimalSeparator{$ELSE}DecimalSeparator{$ENDIF} +
    DoubleQuote + Minus + Plus + Quote + Semicolon + Space;
  Reserve[rtText] := LeftBrace + RightBrace;

finalization
  Validator.Free;

end.
