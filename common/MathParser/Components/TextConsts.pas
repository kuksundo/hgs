{ *********************************************************************** }
{                                                                         }
{ TextConsts                                                              }
{                                                                         }
{ Copyright (c) 2007 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit TextConsts;

interface

const
  Ampersand = '&';
  Asterisk = '*';
  AtSign = '@';
  Backslash = '\';
  Colon = ':';
  Comma = ',';
  CarriageReturn = #13;
  CR = CarriageReturn;
  Dollar = '$';
  Dot = '.';
  DoubleQuote = '"';
  DoubleSlash = '//';
  Equal = '=';
  Exclamation = '!';
  Greater = '>';
  Inquiry = '?';
  LeftBrace = '{';
  LeftBracket = '[';
  LeftParenthesis = '(';
  Less = '<';
  LineFeed = #10;
  LF = LineFeed;
  Minus = '-';
  Percent = '%';
  Pipe = '|';
  Plus = '+';
  Pound = '#';
  Quote = '''';
  RightBrace = '}';
  RightBracket = ']';
  RightParenthesis = ')';
  Semicolon = ';';
  Slash = '/';
  Space = ' ';
  Tilde = '~';

  Blanks = [Space, CarriageReturn, LineFeed];
  Breaks = [CarriageReturn, LineFeed];

implementation

end.
