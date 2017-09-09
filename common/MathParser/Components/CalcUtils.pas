{ *********************************************************************** }
{                                                                         }
{ CalcUtils                                                               }
{                                                                         }
{ Copyright (c) 2008 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit CalcUtils;

{$B-}

interface

uses
  Calculator, DB, ValueTypes;

function AsValue(const Text: string): TValue;
function AsByte(const Text: string): Byte;
function AsShortint(const Text: string): Shortint;
function AsWord(const Text: string): Word;
function AsSmallint(const Text: string): Smallint;
function AsLongword(const Text: string): Longword;
function AsInteger(const Text: string): Integer;
function AsInt64(const Text: string): Int64;
function AsSingle(const Text: string): Single;
function AsDouble(const Text: string): Double;
function AsExtended(const Text: string): Extended;
function AsBoolean(const Text: string): Boolean;
function AsPointer(const Text: string): Pointer;
function AsString(const Text: string): string;

function CalcDataSet(const DataSet: TDataSet; const FormulaFieldName,
  OutputFieldName: string): Boolean;

var
  ACalculator: TCalculator;

implementation

function AsValue(const Text: string): TValue;
begin
  Result := ACalculator.AsValue(Text);
end;

function AsByte(const Text: string): Byte;
begin
  Result := ACalculator.AsByte(Text);
end;

function AsShortint(const Text: string): Shortint;
begin
  Result := ACalculator.AsShortint(Text);
end;

function AsWord(const Text: string): Word;
begin
  Result := ACalculator.AsWord(Text);
end;

function AsSmallint(const Text: string): Smallint;
begin
  Result := ACalculator.AsSmallint(Text);
end;

function AsLongword(const Text: string): Longword;
begin
  Result := ACalculator.AsLongword(Text);
end;

function AsInteger(const Text: string): Integer;
begin
  Result := ACalculator.AsInteger(Text);
end;

function AsInt64(const Text: string): Int64;
begin
  Result := ACalculator.AsInt64(Text);
end;

function AsSingle(const Text: string): Single;
begin
  Result := ACalculator.AsSingle(Text);
end;

function AsDouble(const Text: string): Double;
begin
  Result := ACalculator.AsDouble(Text);
end;

function AsExtended(const Text: string): Extended;
begin
  Result := ACalculator.AsExtended(Text);
end;

function AsBoolean(const Text: string): Boolean;
begin
  Result := ACalculator.AsBoolean(Text);
end;

function AsPointer(const Text: string): Pointer;
begin
  Result := ACalculator.AsPointer(Text);
end;

function AsString(const Text: string): string;
begin
  Result := ACalculator.AsString(Text);
end;

function CalcDataSet(const DataSet: TDataSet; const FormulaFieldName,
  OutputFieldName: string): Boolean;
begin
  Result := ACalculator.CalcDataSet(DataSet, FormulaFieldName, OutputFieldName);
end;

initialization
  ACalculator := TCalculator.Create(nil);

finalization
  ACalculator.Free;

end.
