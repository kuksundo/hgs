unit MT210ComConst;

interface

uses Messages;

Const
  INIFILENAME = 'MT210.ini';
  SAVEINIFILENAME = 'MT210_SaveData.ini';
  IPCCLIENTNAME1 = 'MT210';
  WM_RECEIVESTRING = WM_USER + 100;
  WM_MT210DATA = WM_USER + 101;
  WM_SAVEDATA = WM_USER + 102;

  C_ESC_R = Chr(27)+'R';
  C_PU6 = 'PU6';
  C_H1 = 'H1';
  C_DL0 = 'DL0';
  C_OD = 'OD';

implementation

end.
 