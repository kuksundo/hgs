{******************************************************************

                   Horiba Component Properties

 Copyright (C) 2010 HHI

 Original author: J.H.Park [kuksundo@hhi.co.kr]

 The contents of this file are used with permission, subject to
 the Mozilla Public License Version 1.1 (the "License"); you may  
 not use this file except in compliance with the License. You may 
 obtain a copy of the License at
 http://www.mozilla.org/MPL/MPL-1_1Final.html

 Software distributed under the License is distributed on an
 "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   
 implied. See the License for the specific language governing
 rights and limitations under the License.

******************************************************************}

unit HoribaComponentClasses;

interface

uses
  Classes;

type
  TMEXA7000Collect = class;
  TMEXA7000Item = class;

  THoribaComponent = class(TPersistent)
  private
    FMEXA7000: TMEXA7000Collect;
    FFooter: string;
    FHeader: string;  //Engine Type
    FFileName: string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure AddDefautProperties;
    function GetComponentNameByCode(ACode: integer): string;
  published
    property Header: string read FHeader write FHeader;
    property FileName: string read FFileName write FFileName;
    property MEXA7000: TMEXA7000Collect read FMEXA7000 write FMEXA7000;
    property Footer: string read FFooter write FFooter;
  end;

  TMEXA7000Item = class(TCollectionItem)
  private
    FGroupNo: integer;
    FSerialNo: integer;
    FComponentName: string;
    FComponentCode: integer;
  published
    property GroupNo: integer read FGroupNo write FGroupNo;
    property SerialNo: integer read FSerialNo write FSerialNo;
    property ComponentName: string read FComponentName write FComponentName;
    property ComponentCode: integer read FComponentCode write FComponentCode;
  end;

  TMEXA7000Collect = class(TCollection)
  private
    function GetItem(Index: Integer): TMEXA7000Item;
    procedure SetItem(Index: Integer; const Value: TMEXA7000Item);
  public
    function  Add: TMEXA7000Item;
    function Insert(Index: Integer): TMEXA7000Item;
    property Items[Index: Integer]: TMEXA7000Item read GetItem  write SetItem; default;
  end;

implementation

{ TMEXA7000Item }

function TMEXA7000Collect.Add: TMEXA7000Item;
begin
  Result := TMEXA7000Item(inherited Add);
end;

function TMEXA7000Collect.GetItem(Index: Integer): TMEXA7000Item;
begin
  Result := TMEXA7000Item(inherited Items[Index]);
end;

function TMEXA7000Collect.Insert(Index: Integer): TMEXA7000Item;
begin
  Result := TMEXA7000Item(inherited Insert(Index));
end;

procedure TMEXA7000Collect.SetItem(Index: Integer; const Value: TMEXA7000Item);
begin
  Items[Index].Assign(Value);
end;

{ TMEXA7000Item }

procedure THoribaComponent.AddDefautProperties;
begin
  with FMEXA7000.Add do
  begin
    ComponentName := 'CO(L)';
    ComponentCode := 1;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'CO(H)';
    ComponentCode := 2;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'CO2';
    ComponentCode := 3;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'HC(L)';
    ComponentCode := 4;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'HC(H)';
    ComponentCode := 5;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'THC';
    ComponentCode := 6;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'NO';
    ComponentCode := 7;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'NOX';
    ComponentCode := 8;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'NO(AS)';
    ComponentCode := 9;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'O2';
    ComponentCode := 10;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'CH4';
    ComponentCode := 11;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := '---';
    ComponentCode := 12;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'SO2';
    ComponentCode := 13;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'non-CH4';
    ComponentCode := 14;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'N2O';
    ComponentCode := 15;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'H2';
    ComponentCode := 16;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'SF6';
    ComponentCode := 17;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'NO2';
    ComponentCode := 18;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'H2O';
    ComponentCode := 19;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'AFR';
    ComponentCode := 20;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'EGR';
    ComponentCode := 21;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'Lamda';
    ComponentCode := 22;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'NH3';
    ComponentCode := 101;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'NOy';
    ComponentCode := 102;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'Methanol';
    ComponentCode := 103;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'Ethanol';
    ComponentCode := 104;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'Toluene';
    ComponentCode := 105;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'R134A';
    ComponentCode := 106;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'SUM';
    ComponentCode := 107;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'H2S';
    ComponentCode := 108;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'Total-S';
    ComponentCode := 109;
  end;//with

  with FMEXA7000.Add do
  begin
    ComponentName := 'C3H6';
    ComponentCode := 110;
  end;//with

end;

constructor THoribaComponent.Create(AOwner: TComponent);
begin
  FMEXA7000 := TMEXA7000Collect.Create(TMEXA7000Item);
end;

destructor THoribaComponent.Destroy;
begin
  inherited Destroy;
  FMEXA7000.Free;
end;

function THoribaComponent.GetComponentNameByCode(ACode: integer): string;
var
  Li: integer;
begin
  Result := '';

  for Li := 0 to FMEXA7000.Count - 1 do
    if FMEXA7000.Items[Li].FComponentCode = ACode then
    begin
      Result := FMEXA7000.Items[Li].FComponentName;
      exit;
    end;
end;

end.
