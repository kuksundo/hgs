unit MyPropertyUnit;

interface

uses Controls;

Type
  TMySizeConstraints = class(TSizeConstraints)
  protected
    function GetMaxHeight: TConstraintSize;
    function GetMaxWidth: TConstraintSize;
    function GetMinHeight: TConstraintSize;
    function GetMinWidth: TConstraintSize;
  published
    property MaxHeight: TConstraintSize read GetMaxHeight;
    property MaxWidth: TConstraintSize read GetMaxWidth;
    property MinHeight: TConstraintSize read GetMinHeight;
    property MinWidth: TConstraintSize read GetMinWidth;
  end;
implementation

{ TMySizeConstraints }

function TMySizeConstraints.GetMaxHeight: TConstraintSize;
begin
  Result := inherited MaxHeight;
end;

function TMySizeConstraints.GetMaxWidth: TConstraintSize;
begin
  Result := inherited MaxWidth;
end;

function TMySizeConstraints.GetMinHeight: TConstraintSize;
begin
  Result := inherited MinHeight;
end;

function TMySizeConstraints.GetMinWidth: TConstraintSize;
begin
  Result := inherited MinWidth;
end;

end.
 