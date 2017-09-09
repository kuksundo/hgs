{ *********************************************************************** }
{                                                                         }
{ ParseErrors                                                             }
{                                                                         }
{ Copyright (c) 2006 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit ParseErrors;

{$B-}

interface

uses
  SysUtils;

type
  EParserError = class(Exception);

const
  ErrorMessage = '%s: "%s"';
  AMutualExcessError = 'Function "%s" requires expression after itself, function "%s" requires expression before itself';
  BMutualExcessError = 'Function "%s" does not require expression after itself, function "%s" does not require expression before itself';
  BracketError = 'Bracket character expected';
  EmptyTextError = 'Empty text';
  FunctionHandleError = 'Function handle error: "%s"';
  FunctionExpectError = 'Function expected: "%s"';
  ElementError = 'Unknown element: "%s"';
  RExcessError = '"%s" does not require expression after itself';
  LTextExcessError = 'Function "%s" does not require expression before itself';
  LTextExpectError = 'Function "%s" requires expression before itself';
  DefinitionError = '"%s" cannot start with a number';
  AParameterExcessError = 'Function "%s" does not require parameters';
  BParameterExcessError = 'Too much parameters for function "%s"';
  AParameterExpectError = 'Function "%s" requires parameters';
  BParameterExpectError = 'Not enough parameters for function "%s"';
  ReserveError = 'Text "%s" contains reserved character: "%s"';
  RTextExcessError = 'Function "%s" does not require expression after itself';
  RTextExpectError = 'Function "%s" requires expression after itself';
  ScriptError = 'Script error';
  StringError = '"%s" cannot be the part of math expression';
  StringTypeError = '"%s" cannot have type of string';
  TextError = 'Expression expected: "%s"';

function Error(const Message: string): Exception; overload;
function Error(const Message: string; const Arguments: array of const): Exception; overload;
function Error(const Text, Message: string): Exception; overload;
function Error(const Text, Message: string; const Arguments: array of const): Exception; overload;

implementation

function Error(const Message: string): Exception;
begin
  Result := Error(Message, []);
end;

function Error(const Message: string; const Arguments: array of const): Exception;
begin
  Result := EParserError.CreateFmt(Message, Arguments);
end;

function Error(const Text, Message: string): Exception;
begin
  Result := Error(Text, Message, []);
end;

function Error(const Text, Message: string; const Arguments: array of const): Exception;
begin
  Result := Error(Format(ErrorMessage, [Format(Message, Arguments), Text]));
end;

end.
