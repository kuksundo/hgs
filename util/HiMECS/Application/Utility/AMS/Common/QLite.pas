unit QLite;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes;

const
  S_Off = 0;
  S_Fire = 1;
  S_Emergency = 2;
  S_Embulance = 3;
  S_PI = 4;


procedure Usb_Qu_Open()  cdecl ; external 'Quvc_dll.dll';
procedure Usb_Qu_Close()  cdecl ; external 'Quvc_dll.dll';
function  Usb_Qu_Getstate(): integer cdecl ; external 'Quvc_dll.dll';
function Usb_Qu_write(Qu_index : byte;  Qu_type : byte; var pData): bool cdecl ; external 'Quvc_dll.dll';

function _SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundIndex: integer): string;

implementation

function _SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundIndex: integer): string;
const
  C_index       =	0;
  C_type	      = 0;     {    Sound 5ea model  }
//  C_dont	      = 100;   {  // Don't care  // Do not change before state }
//  C_off         = 0;
//  C_on          = 1;
//  C_onoff       = 2;
var
  iStat : integer;
  m_str : string;
  bret : bool;
  cData:array [0..6] of Byte;
begin
  if Usb_Qu_Getstate > 0 then
  begin
    cData[0] := ARedLamp;         { Red lamp }
    cData[1] := AYellowLamp;      { Yellow lamp }
    cData[2] := AGreenLamp;       { Green lamp }
    cData[3] := A_dont;
    cData[5] := ASoundIndex;      { Sound Select 0-5;   0-off }

    bret := Usb_Qu_write(C_index, C_type, cData[0]);

    if bret then
    begin
      iStat :=  Usb_Qu_Getstate();
      m_str := ' Read Connect Usb ';

      if (iStat and $1) = $1	then
        m_str := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now) + m_str +'[Send Success]Lamp'
      else
        m_str := m_str + '[Send Error]';

      Result := m_str;
    end;
  end;
end;

end.
