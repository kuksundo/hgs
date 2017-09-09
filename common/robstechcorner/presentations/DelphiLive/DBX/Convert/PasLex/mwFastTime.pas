{--------------------------------------------------------------------}
{ mwFastTime V 1.2                                                     }
{ Written by Martin Waldenburg 1996.                                 }
{ Copyright by Martin Waldenburg 1996. All rights reserved.          }
{ This is FreeWare.                                                  }
{ It's provided as is, without a warranty of any kind.               }
{ You use it at your own risc.                                       }
{ You may use and distribute it freely.                              }
{ But You may not say it's your work                                 }
{ If you distribute it you must provide all Files.                   }
{--------------------------------------------------------------------}

unit mwFastTime;

interface

uses
  SysUtils, Windows, Classes;

type
  TmwFastTime = class(TComponent)
  private
    c, n1, n2: TLargeInteger;
    function GetElapsedTime: ShortString;
    function GetElapsed: Extended;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Property Elapsed: Extended read GetElapsed;
    Property ElapsedTime: ShortString read GetElapsedTime;
    Procedure Start;
    Procedure Stop;
  published
    Property Name;
    Property Tag;
  end;

procedure Register;


implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

procedure Register;
begin
  RegisterComponents('mw', [TmwFastTime]);
end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

constructor TmwFastTime.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  QueryPerformanceFrequency(c);
end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

destructor TmwFastTime.Destroy;
begin
  inherited Destroy;
end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function TmwFastTime.GetElapsed: Extended;
begin
{$IFDEF VER120}
  Result:= (_LARGE_INTEGER(n2).QuadPart - _LARGE_INTEGER(n1).QuadPart) / _LARGE_INTEGER(c).QuadPart;
{$ELSE}
  Result:= (n2.QuadPart - n1.QuadPart) / c.QuadPart;
{$ENDIF}
end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function TmwFastTime.GetElapsedTime: ShortString;
begin
{$IFDEF VER120}
  Result := format('Seconds: %g', [GetElapsed]);
{$ELSE}
  Result := format('Seconds: %g', [GetElapsed]);
{$ENDIF}
end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Procedure TmwFastTime.Start;
begin
  QueryPerformanceCounter(n1);
end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Procedure TmwFastTime.Stop;
begin
  QueryPerformanceCounter(n2);
end;

end.

{------------------------------------------------------------}
{ Martin Waldenburg                                          }
{ Landaeckerstrasse 27                                       }
{ 71642 Ludwigsburg                                          }
{ Germany                                                    }
{                                                            }
{ Sugestions, improvements and code of any kind are welcome  }
{ Thanks for trying my code.                                 }
{------------------------------------------------------------}

