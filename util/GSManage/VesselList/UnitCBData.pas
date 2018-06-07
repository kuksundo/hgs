unit UnitCBData;

interface

uses System.Classes, System.SysUtils, System.StrUtils, Vcl.StdCtrls, UnitEnumHelper;

type
  TCBKind = (ckNull, ckACB, ckVCB, ckVCS, ckFinal);

const
  R_CBKind : array[Low(TCBKind)..High(TCBKind)] of string =
    ('', 'ACB' ,'VCB' ,'VCS', '');

var
  g_CBKind: TLabelledEnum<TCBKind>;

implementation

initialization
  g_CBKind.InitArrayRecord(R_CBKind);

finalization

end.
