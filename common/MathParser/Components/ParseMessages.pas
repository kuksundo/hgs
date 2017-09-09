{ *********************************************************************** }
{                                                                         }
{ ParseMessages                                                           }
{                                                                         }
{ Copyright (c) 2007 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit ParseMessages;

{$B-}

interface

uses
  Messages, ValueTypes;

type
  TVariableData = record
    Name: string;
    Optimizable, Whole: Boolean;
    ReturnType: TValueType;
  end;
  PVariableData = ^TVariableData;

const
  WM_NOTIFY = WM_USER;
  WM_ADDFUNCTION = WM_USER + 1;
  WM_ADDVARIABLE = WM_USER + 2;

function VariableData(const AName: string; const AOptimizable, AWhole: Boolean;
  const AReturnType: TValueType): TVariableData;

implementation

function VariableData(const AName: string; const AOptimizable, AWhole: Boolean;
  const AReturnType: TValueType): TVariableData;
begin
  with Result do
  begin
    Name := AName;
    Optimizable := AOptimizable;
    Whole := AWhole;
    ReturnType := AReturnType;
  end;
end;

end.
