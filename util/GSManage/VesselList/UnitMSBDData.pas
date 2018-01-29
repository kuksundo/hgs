unit UnitMSBDData;

interface

uses System.Classes, Vcl.StdCtrls;

type
  TMSBD_Panel_Type = (mptNone, mptGE1, mptGE2, mptGE3, mptGE4, mptGE5,
    mptBow1, mptBow2, mptStern1, mptStern2, mptGrpStart1, mptGrpStart2, mptMainLO1, mptMainLO2,
    mptBWTS, mptSynchro, mptAMPCOP, mptAMPIncomming,
    mptBusTie, mptRefer1, mptRefer2,  mptRefer3, mptRefer4, mptRefer5,
    mptRefer6, mptTR, mptFinal);

const
  R_MSBD_Panel_Type : array[mptNone..mptFinal] of record
    Description, VCode : string;
    Value       : TMSBD_Panel_Type;
  end = ((Description : ''; VCode : ''; Value : mptNone),
         (Description : 'G/E #1 Panel';
                  VCode : 'GE#1';   Value : mptGE1),
         (Description : 'G/E #2 Panel';
                  VCode : 'GE#2';   Value : mptGE2),
         (Description : 'G/E #3 Panel';
                  VCode : 'GE#3';   Value : mptGE3),
         (Description : 'G/E #4 Panel';
                  VCode : 'GE#4';   Value : mptGE4),
         (Description : 'G/E #5 Panel';
                  VCode : 'GE#5';   Value : mptGE5),
         (Description : 'Bow Thruster #1 Panel';
                  VCode : 'Bow#1';   Value : mptBow1),
         (Description : 'Bow Thruster #2 Panel';
                  VCode : 'Bow#2';   Value : mptBow2),
         (Description : 'Stern Thruster #1 Panel';
                  VCode : 'Stern#1';   Value : mptStern1),
         (Description : 'Stern Thruster #2 Panel';
                  VCode : 'Stern#2';   Value : mptStern2),
         (Description : 'Group Starter #1 Panel';
                  VCode : 'GS#1';   Value : mptGrpStart1),
         (Description : 'Group Starter #2 Panel';
                  VCode : 'GS#2';   Value : mptGrpStart2),
         (Description : 'Main L.O.#1 Panel';
                  VCode : 'MainLO#1';   Value : mptMainLO1),
         (Description : 'Main L.O.#2 Panel';
                  VCode : 'MainLO#2';   Value : mptMainLO2),
         (Description : 'BWTS Panel';
                  VCode : 'BWTS';   Value : mptBWTS),
         (Description : 'Synchro Panel';
                  VCode : 'Synchro';   Value : mptSynchro),
         (Description : 'AMP Change Over Panel';
                  VCode : 'AMPCOP';   Value : mptAMPCOP),
         (Description : 'AMP Incomming Panel';
                  VCode : 'AMPInComming';   Value : mptAMPIncomming),
         (Description : 'Bus Tie Panel';
                  VCode : 'Bus-Tie';   Value : mptBusTie),
         (Description : 'Refer #1 Panel';
                  VCode : 'Refer#1';   Value : mptRefer1),
         (Description : 'Refer #2 Panel';
                  VCode : 'Refer#2';   Value : mptRefer2),
         (Description : 'Refer #3 Panel';
                  VCode : 'Refer#3';   Value : mptRefer3),
         (Description : 'Refer #4 Panel';
                  VCode : 'Refer#4';   Value : mptRefer4),
         (Description : 'Refer #5 Panel';
                  VCode : 'Refer#5';   Value : mptRefer5),
         (Description : 'Refer #6 Panel';
                  VCode : 'Refer#6';   Value : mptRefer6),
         (Description : 'TR Panel';
                  VCode : 'TR';   Value : mptTR),
         (Description : ''; VCode : '';   Value : mptFinal)
  );

function MSBDPT2Desc(AMSBDPT:TMSBD_Panel_Type) : string;
function Desc2MSBDPT(AMSBDPT:string): TMSBD_Panel_Type;
function MSBDPT2VCode(AMSBDPT:TMSBD_Panel_Type) : string;
function VCode2MSBDPT(AMSBDPT:string): TMSBD_Panel_Type;
procedure MSBDPT2Combo(AComboBox:TComboBox);

implementation

function MSBDPT2Desc(AMSBDPT:TMSBD_Panel_Type) : string;
begin
  if AMSBDPT <= High(TMSBD_Panel_Type) then
    Result := R_MSBD_Panel_Type[AMSBDPT].Description;
end;

function Desc2MSBDPT(AMSBDPT:string): TMSBD_Panel_Type;
var Li: TMSBD_Panel_Type;
begin
  for Li := Low(TMSBD_Panel_Type) to High(TMSBD_Panel_Type) do
  begin
    if R_MSBD_Panel_Type[Li].Description = AMSBDPT then
    begin
      Result := R_MSBD_Panel_Type[Li].Value;
      exit;
    end;
  end;
end;

function MSBDPT2VCode(AMSBDPT:TMSBD_Panel_Type) : string;
begin
  if AMSBDPT <= High(TMSBD_Panel_Type) then
    Result := R_MSBD_Panel_Type[AMSBDPT].VCode;
end;

function VCode2MSBDPT(AMSBDPT:string): TMSBD_Panel_Type;
var Li: TMSBD_Panel_Type;
begin
  for Li := Low(TMSBD_Panel_Type) to High(TMSBD_Panel_Type) do
  begin
    if R_MSBD_Panel_Type[Li].VCode = AMSBDPT then
    begin
      Result := R_MSBD_Panel_Type[Li].Value;
      exit;
    end;
  end;
end;

procedure MSBDPT2Combo(AComboBox:TComboBox);
var Li: TMSBD_Panel_Type;
begin
  AComboBox.Clear;

  for Li := Low(TMSBD_Panel_Type) to Pred(High(TMSBD_Panel_Type)) do
  begin
    if Li = Low(TMSBD_Panel_Type) then
      AComboBox.Items.Add(R_MSBD_Panel_Type[Li].Description)
    else
      AComboBox.Items.Add(R_MSBD_Panel_Type[Li].Description);
//      AComboBox.Items.Add(R_MSBD_Panel_Type[Li].VCode + ' : ' + R_MSBD_Panel_Type[Li].Description);
  end;
end;

end.
