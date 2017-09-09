{*******************************************************}
{                                                       }
{       OPC Data Access 2.0  Custom Interface           }
{                                                       }
{       Delphi Sample - Callback Interface              }
{*******************************************************}

unit OPCCallback;

interface

uses
  Windows, ActiveX, Variants, OPCDA;

type
  // class to receive IConnectionPointContainer data change callbacks
  TOPCDataCallback = class(TInterfacedObject, IOPCDataCallback)
  public
    function OnDataChange(dwTransid: DWORD; hGroup: OPCHANDLE;
      hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD;
      phClientItems: POPCHANDLE; pvValues: POleVariant; pwQualities: PWORD;
      pftTimeStamps: PFileTime; pErrors: PHResult): HResult; stdcall;
    function OnReadComplete(dwTransid: DWORD; hGroup: OPCHANDLE;
      hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD;
      phClientItems: POPCHANDLE; pvValues: POleVariant; pwQualities: PWORD;
      pftTimeStamps: PFileTime; pErrors: PHResult): HResult; stdcall;
    function OnWriteComplete(dwTransid: DWORD; hGroup: OPCHANDLE;
      hrMastererr: HResult; dwCount: DWORD; pClienthandles: POPCHANDLE;
      pErrors: PHResult): HResult; stdcall;
    function OnCancelComplete(dwTransid: DWORD; hGroup: OPCHANDLE):
      HResult; stdcall;
  end;

implementation

uses UnitServerMain;  // To write data to the Form

// TOPCDataCallback methods

function TOPCDataCallback.OnDataChange(dwTransid: DWORD;
  hGroup: OPCHANDLE; hrMasterquality: HResult; hrMastererror: HResult;
  dwCount: DWORD; phClientItems: POPCHANDLE; pvValues: POleVariant;
  pwQualities: PWORD; pftTimeStamps: PFileTime; pErrors: PHResult): HResult;
var
  ClientItems: POPCHANDLEARRAY;
  Values: POleVariantArray;
  Qualities: PWORDARRAY;
  I: Integer;

begin
  Result := S_OK;
  ClientItems := POPCHANDLEARRAY(phClientItems);
  Values := POleVariantArray(pvValues);
  Qualities := PWORDARRAY(pwQualities);
  for I := 0 to dwCount - 1 do
    if Qualities[I] = OPC_QUALITY_GOOD then
    begin
      ServerMainF.SetTagData2Grid(ClientItems[I]-1, VarToSTr(Values[I]));
      ServerMainF.FOPCServer.FTagList.Item[ClientItems[I]-1].TagValue := VarToSTr(Values[I]);
//        case ClientItems[I] of
//        // Write Actual Temperature Value in Text Box
//        1: ServerMainF.TxtActualTemp.Text:= VarToSTr(Values[I]);
//        // Write Actual Niveau Value in Text Box
//        2: ServerMainF.TxtActualNiveau.Text:= VarToSTr(Values[I]);
//        // Check or Uncheck Check Box of Inlet_Valve_1
//        3: if Values[I] then
//             ServerMainF.InletValve1.Checked := TRUE
//           else
//             ServerMainF.InletValve1.Checked := FALSE;
//        // Check or Uncheck Check Box of Inlet_Valve_2
//        4: if Values[I] then
//             ServerMainF.InletValve2.Checked := TRUE
//           else
//             ServerMainF.InletValve2.Checked := FALSE;
//        // Check or Uncheck Check Box of Outlet_Valve
//        5: if Values[I] then
//             ServerMainF.OutletValve.Checked := TRUE
//           else
//             ServerMainF.OutletValve.Checked := FALSE;
//        // Check or Uncheck Check Box of Heater
//        6: if Values[I] then
//             ServerMainF.Heater.Checked := TRUE
//           else
//              ServerMainF.Heater.Checked := FALSE;
//        // Check or Uncheck Check Box of Cooler
//        7: if Values[I] then
//              ServerMainF.Cooler.Checked := TRUE
//           else
//              ServerMainF.Cooler.Checked := FALSE;
//        // Check or Uncheck Check Box of Mixer
//        8: if Values[I] then
//             ServerMainF.Mixer.Checked := TRUE
//           else
//             ServerMainF.Mixer.Checked := FALSE;
//        // Write Temperature_Max Value in Text Box
//        9: ServerMainF.TxtTemp_Max.Text := VarToSTr(Values[I]);
//        // Write Temperature_Out Value in Text Box
//        10: ServerMainF.TxtTemp_Out.Text := VarToSTr(Values[I]);
//        // Write Niveau_1 Value in Text Box
//        11: ServerMainF.TxtNiveau_1.Text := VarToSTr(Values[I]);
//        // Write Niveau_2 Value in Text Box
//        12: ServerMainF.TxtNiveau_2.Text := VarToSTr(Values[I]);
//        end;
    end;
end;


function TOPCDataCallback.OnReadComplete(dwTransid: DWORD;
  hGroup: OPCHANDLE; hrMasterquality: HResult; hrMastererror: HResult;
  dwCount: DWORD; phClientItems: POPCHANDLE; pvValues: POleVariant;
  pwQualities: PWORD; pftTimeStamps: PFileTime; pErrors: PHResult): HResult;
begin
//  Result := OnDataChange(dwTransid, hGroup, hrMasterquality, hrMastererror,
//    dwCount, phClientItems, pvValues, pwQualities, pftTimeStamps, pErrors);
end;

function TOPCDataCallback.OnWriteComplete(dwTransid: DWORD;
  hGroup: OPCHANDLE; hrMastererr: HResult; dwCount: DWORD;
  pClienthandles: POPCHANDLE; pErrors: PHResult): HResult;
begin
  // we don't use this facility
  Result := S_OK;
end;

function TOPCDataCallback.OnCancelComplete(dwTransid: DWORD;
  hGroup: OPCHANDLE): HResult;
begin
  // we don't use this facility
  Result := S_OK;
end;

end.

