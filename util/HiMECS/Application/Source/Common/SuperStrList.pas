{------------------------------------------------------------------------------}
{ TSuperStringList v1.00 (c) 1998 Y-Tech Corporation       December 13th, 1998 }
{------------------------------------------------------------------------------}
{ TSuperStringList is a Free Delphi Class. You may modify it, distribute it    }
{ and generally do with it what you want. There are no warranties of any kind. }
{                                                                              }
{ Please visit our Web Site: http://www.igather.com/components to try out the  }
{ many freeware and shareware components and classes available there.          }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{ What's so "Super" about it?                                                  }
{------------------------------------------------------------------------------}
{ - Well it's "Super" as in "SuperSet" of TStringList as are all objects       }
{   descended from it of course :) Aside from that it is a simple class        }
{   which has one goal; to let you store non-string data in a StringList very  }
{   easily.                                                                    }
{ - Currently there are two types of methods: Add & Get.                       }
{ - "Add" will add a non-string value to the string list.                      }
{ - "Get" will read a non-string value from the string list.                   }
{ - To see what data types are currently supported, just have a look at the    }
{   class declaration below.                                                   }
{ - When using "Get" the Index parameter is the index of the the item you want }
{   to get from the string list.                                               }
{ - Aside from the Add & Get methods, usage if exactly the same as a regular   }
{   TStringList.                                                               }
{ - Enjoy!                                                                     }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{ Questions & Comments                                                         }
{------------------------------------------------------------------------------}
{ All questions and comments should be sent to ytech-comp@hotpop.com           }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{ Usage                                                                        }
{------------------------------------------------------------------------------}
{ It should be straightforward, just look at the source. AddInteger(5) would   }
{ for instance add 5 to the StringList and GetInteger(2) would return the      }
{ results of the 3rd String in the StringList (the one with an index of 2).    }
{ Make sure that you use GetInteger only on a String containing an Integer,    }
{ the same goes for the other Get functions as well                            }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{ Revision History                                                             }
{------------------------------------------------------------------------------}
{ 1.00: + Initial Release (100% Bug-Free!!! - my code anyways, can't vouch     }
{         for the Delphi functions I call, but they should be ok :)            } 
{------------------------------------------------------------------------------}

unit SuperStrList;

interface

uses Classes, Graphics;

type
  TSuperStringList = class(TStringList)
  public
    // *** Add Data Type Procedures ***
    procedure AddInteger(Value: Integer);
    procedure AddFloat(Value: Extended);
    procedure AddBoolean(Value: Boolean);
    procedure AddColor(Value: TColor);

    // *** Get Data Type Functions ***
    function GetInteger(Index: Integer): Integer;
    function GetFloat(Index: Integer): Extended;
    function GetBoolean(Index: Integer): Boolean;
    function GetColor(Index: Integer; DefaultColor: TColor): TColor;

  end;

implementation

uses SysUtils;

// *** Add Data Type Procedures ***

procedure TSuperStringList.AddInteger(Value: Integer);
begin
  Add(IntToStr(Value));
end;

procedure TSuperStringList.AddFloat(Value: Extended);
begin
  Add(FloatToStr(Value));
end;

procedure TSuperStringList.AddBoolean(Value: Boolean);
begin
  Add(IntToStr(Ord(Value)));
end;

procedure TSuperStringList.AddColor(Value: TColor);
begin
  Add(ColorToString(Value));
end;

// *** Get Data Type Functions ***

function TSuperStringList.GetInteger(Index: Integer): Integer;
begin
  Result := StrToInt(Strings[Index]);
end;

function TSuperStringList.GetFloat(Index: Integer): Extended;
begin
  Result := StrToFloat(Strings[Index]);
end;

function TSuperStringList.GetBoolean(Index: Integer): Boolean;
begin
  Result := Boolean(StrToInt(Strings[Index]));
end;

function TSuperStringList.GetColor(Index: Integer; DefaultColor: TColor): TColor;
begin
  try
    Result := StringToColor(Strings[Index]);
  except
    on EConvertError do Result := DefaultColor;
    else raise;
  end;
end;

end.
