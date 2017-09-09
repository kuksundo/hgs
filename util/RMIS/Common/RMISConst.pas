unit RMISConst;

interface

uses Windows, Classes, StdCtrls;

type
  TParameterSource = (psUnKnown, psBWQry);
  TDisplayMessage = procedure(msg: string) of object;
  TDisplayMessage2 = procedure(msg: string; ADest: integer) of object;
  TClearMessage = procedure of object;
  TSetFormCaption = procedure(ACaption: string) of object;
  TGetFormCaption = function: string of object;

const
  ParameterSourceCOUNT = integer(High(TParameterSource))+1;
  R_ParameterSource : array[0..ParameterSourceCOUNT-1] of record
    Description : string;
    Value       : TParameterSource;
    SharedMemName: string;
  end = ((Description : 'UnKnown'; Value : psUnKnown; SharedMemName:'UnKnown'),
          (Description : 'BW Query'; Value : psBWQry; SharedMemName:'BWQry')
         );

  function ParameterSource2String(AParameterSource:TParameterSource) : string;
  function String2ParameterSource(AParameterSource:string): TParameterSource;
  function ParameterSource2SharedMN(AParameterSource:TParameterSource) : string;
  procedure ParameterSource2Combo(AComboBox:TComboBox);
  procedure ParameterSource2Strings(AStrings: TStrings);

var
  g_DisplayMessage2MainForm: TDisplayMessage;
  g_DisplayMessage2FCS: TDisplayMessage2;
  g_ClearMessage: TClearMessage;
  g_SetFormCaption: TSetFormCaption;
  g_GetFormCaption: TGetFormCaption;
  g_GetCellDataAllRunning: Boolean;

implementation

function ParameterSource2String(AParameterSource:TParameterSource) : string;
begin
  Result := R_ParameterSource[ord(AParameterSource)].Description;
end;

function String2ParameterSource(AParameterSource:string): TParameterSource;
var Li: integer;
begin
  for Li := 0 to ParameterSourceCOUNT - 1 do
  begin
    if R_ParameterSource[Li].Description = AParameterSource then
    begin
      Result := R_ParameterSource[Li].Value;
      exit;
    end;
  end;
end;

function ParameterSource2SharedMN(AParameterSource:TParameterSource) : string;
begin
  Result := R_ParameterSource[ord(AParameterSource)].SharedMemName;
end;

procedure ParameterSource2Combo(AComboBox:TComboBox);
var Li: integer;
begin
  for Li := 0 to ParameterSourceCOUNT - 1 do
  begin
    AComboBox.Items.Add(R_ParameterSource[Li].Description);
  end;
end;

procedure ParameterSource2Strings(AStrings: TStrings);
var Li: integer;
begin
  for Li := 0 to ParameterSourceCOUNT - 1 do
  begin
    AStrings.Add(R_ParameterSource[Li].Description);
  end;
end;

end.

