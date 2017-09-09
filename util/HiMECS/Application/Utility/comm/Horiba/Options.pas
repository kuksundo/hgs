{******************************************************************

                   Horiba Options Properties

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

unit Options;

interface

uses
  Classes, SysUtils, BaseConfigCollect;

type
  TOptionCollect = class;
  TOptionItem = class;

  TOptionComponent = class(TpjhBase)
  private
    FOption: TOptionCollect;
    FFooter: string;
    FHeader: string;  //Engine Type
    FFileName: string;
    FIPAddress: string;
    FTCPPort: integer;
    FUDPPort: integer;
    FSendInterval: integer;
    FUseUDP: Boolean;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure AddDefautProperties;
    function GetListIndexByComponentCode(ACode: integer): integer;
    procedure MRDF_Proc(AResponse: string);
    function MRMD_Proc(AResponse: string): string;
  published
    property Header: string read FHeader write FHeader;
    property ParamFileName: string read FFileName write FFileName;
    property Option: TOptionCollect read FOption write FOption;
    property Footer: string read FFooter write FFooter;
    property TCPPort: integer read FTCPPort write FTCPPort;
    property UDPPort: integer read FUDPPort write FUDPPort;
    property IPAddress: string read FIPAddress write FIPAddress;
    property SendInterval: integer read FSendInterval write FSendInterval;
    property UseUDP: Boolean read FUseUDP write FUseUDP;
  end;

  TOptionItem = class(TCollectionItem)
  private
    FGroupNo: string;
    FSerialNo: string;
    FComponentCode: string;
    FSamplingCount: string;
    FDataStatus: string;
    FValue: string;
  published
    property GroupNo: string read FGroupNo write FGroupNo;
    property SerialNo: string read FSerialNo write FSerialNo;
    property ComponentCode: string read FComponentCode write FComponentCode;
    property SamplingCount: string read FSamplingCount write FSamplingCount;
    property DataStatus: string read FDataStatus write FDataStatus;
    property Value: string read FValue write FValue;
  end;

  TOptionCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TOptionItem;
    procedure SetItem(Index: Integer; const Value: TOptionItem);
  public
    function  Add: TOptionItem;
    function Insert(Index: Integer): TOptionItem;
    property Items[Index: Integer]: TOptionItem read GetItem  write SetItem; default;
  end;

implementation

uses ConfigUtil;

{ TOptionItem }

function TOptionCollect.Add: TOptionItem;
begin
  Result := TOptionItem(inherited Add);
end;

function TOptionCollect.GetItem(Index: Integer): TOptionItem;
begin
  Result := TOptionItem(inherited Items[Index]);
end;

function TOptionCollect.Insert(Index: Integer): TOptionItem;
begin
  Result := TOptionItem(inherited Insert(Index));
end;

procedure TOptionCollect.SetItem(Index: Integer; const Value: TOptionItem);
begin
  Items[Index].Assign(Value);
end;

{ TOptionItem }

procedure TOptionComponent.AddDefautProperties;
begin
  with FOption.Add do
  begin
    IPAddress := '192.168.0.70';
    TCPPort := 7700;
    FUDPPort := 7701;
//    ParamFileName := '';
  end;//with

end;

constructor TOptionComponent.Create(AOwner: TComponent);
begin
  FOption := TOptionCollect.Create(TOptionItem);
end;

destructor TOptionComponent.Destroy;
begin
  inherited Destroy;
  FOption.Free;
end;

function TOptionComponent.GetListIndexByComponentCode(ACode: integer): integer;
var
  Li: integer;
begin
  Result := -1;

  for Li := 0 to Option.Count - 1 do
    if StrToInt(Option.Items[Li].FComponentCode) = ACode then
    begin
      Result := Li;
      exit;
    end;
end;

procedure TOptionComponent.MRDF_Proc(AResponse: string);
var
  LStr: string;
  Li, Lj: integer;
begin
  LStr := GetToken(AResponse, ','); //00: Error Code
  LStr := GetToken(AResponse, ','); //01: Repeat Count
  Li := StrToIntDef(LStr,0);

  if Li > 0 then
  begin
    Option.Clear;

    for Lj := 0 to Li - 1 do
    begin
      Option.Add;
      Option.Items[Lj].GroupNo := LTrimZero(GetToken(AResponse, ',')); //01: Group_num
      Option.Items[Lj].SerialNo := LTrimZero(GetToken(AResponse, ',')); //02: Serial_num
      Option.Items[Lj].ComponentCode := LTrimZero((GetToken(AResponse, ','))); //01: Component Code
      Option.Items[Lj].SamplingCount := '1';
    end;
  end;
end;

function TOptionComponent.MRMD_Proc(AResponse: string): string;
var
  LStr: string;
  Li, Lj, Lk, Lm: integer;
begin
  LStr := GetToken(AResponse, ','); //00: Error Code
  Result := LStr;
  
  if LStr <> '00' then
  begin
    Result := 'Error:' + LStr;
    exit;
  end;

  LStr := GetToken(AResponse, ','); //01: Repeat Count

  if LStr = '00' then
  begin
    Result := 'Sampling Error:' + LStr;
    exit;
  end;

  LStr := GetToken(AResponse, ','); //08282: Sequential Number
  LStr := GetToken(AResponse, ','); //07: Repeat Count
  Li := StrToIntDef(LStr,0);

  if Li > 0 then
  begin
    for Lj := 0 to Li - 1 do
    begin
      //LStr := GetToken(AResponse, ','); //01: Group Number
      if Option.Items[Lj].GroupNo = LTrimZero(GetToken(AResponse, ',')) then //01: Group_num
      begin
        if Option.Items[Lj].SerialNo = LTrimZero(GetToken(AResponse, ',')) then //02: Serial_num
        begin
          LStr := GetToken(AResponse, ','); //01: Number of MRMD data block
          Lm := StrToIntDef(LStr,0);
          for Lk := 1 to Lm do
          begin
            Option.Items[Lj].DataStatus := GetToken(AResponse, ','); //00: Data Status
            if Option.Items[Lj].DataStatus = '00' then
              Option.Items[Lj].Value := GetToken(AResponse, ',') //00: Data Status
            else
              Result := 'Data Status: ' + Option.Items[Lj].DataStatus;
          end;
        end;
      end;
    end;
  end;
end;

end.
