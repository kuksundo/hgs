unit WT1600Demo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, tmctl_h, WT1600Connection;

const
    //AutoRange item
    CrangeListAuto = 'AUTO';
	  CDirect = 'DIRECT';
	  CSensor = 'SENSOR';

type
  TDynaArray = array of char;

  TForm1 = class(TForm)
    Label1: TLabel;
    Bevel1: TBevel;
    ElementRadio: TRadioGroup;
    Label2: TLabel;
    Bevel2: TBevel;
    Label3: TLabel;
    Bevel3: TBevel;
    Label4: TLabel;
    Bevel4: TBevel;
    VoltageCombo: TComboBox;
    CurrentCombo: TComboBox;
    Button1: TButton;
    Label5: TLabel;
    Bevel5: TBevel;
    UpdateRateCombo: TComboBox;
    Button2: TButton;
    Label6: TLabel;
    Bevel6: TBevel;
    Button3: TButton;
    Label7: TLabel;
    Bevel7: TBevel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    NormalRadio: TRadioButton;
    HarmonicsRadio: TRadioButton;
    Label8: TLabel;
    Bevel8: TBevel;
    ItemCountCombo: TComboBox;
    ASCIIRadio: TRadioButton;
    BinRadio: TRadioButton;
    Button7: TButton;
    Button8: TButton;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    FunctionCombo1: TComboBox;
    ElememtCombo1: TComboBox;
    OrderCombo1: TComboBox;
    DataEdit1: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    FunctionCombo6: TComboBox;
    ElememtCombo6: TComboBox;
    OrderCombo6: TComboBox;
    DataEdit6: TEdit;
    Label18: TLabel;
    FunctionCombo2: TComboBox;
    ElememtCombo2: TComboBox;
    OrderCombo2: TComboBox;
    DataEdit2: TEdit;
    Label19: TLabel;
    FunctionCombo7: TComboBox;
    ElememtCombo7: TComboBox;
    OrderCombo7: TComboBox;
    DataEdit7: TEdit;
    Label20: TLabel;
    FunctionCombo3: TComboBox;
    ElememtCombo3: TComboBox;
    OrderCombo3: TComboBox;
    DataEdit3: TEdit;
    Label21: TLabel;
    FunctionCombo8: TComboBox;
    ElememtCombo8: TComboBox;
    OrderCombo8: TComboBox;
    DataEdit8: TEdit;
    Label22: TLabel;
    FunctionCombo4: TComboBox;
    ElememtCombo4: TComboBox;
    OrderCombo4: TComboBox;
    DataEdit4: TEdit;
    Label23: TLabel;
    FunctionCombo9: TComboBox;
    ElememtCombo9: TComboBox;
    OrderCombo9: TComboBox;
    DataEdit9: TEdit;
    Label24: TLabel;
    FunctionCombo5: TComboBox;
    ElememtCombo5: TComboBox;
    OrderCombo5: TComboBox;
    DataEdit5: TEdit;
    Label25: TLabel;
    FunctionCombo10: TComboBox;
    ElememtCombo10: TComboBox;
    OrderCombo10: TComboBox;
    DataEdit10: TEdit;
    Label26: TLabel;
    GetDataButton_S: TButton;
    Button10: TButton;
    Button11: TButton;
    Edit11: TEdit;
    Label27: TLabel;
    Bevel9: TBevel;
    DataSaveCheckBox: TCheckBox;
    Label28: TLabel;
    Edit12: TEdit;
    Label29: TLabel;
    Bevel10: TBevel;
    Label30: TLabel;
    Bevel11: TBevel;
    Button12: TButton;
    SendMemo: TMemo;
    Label31: TLabel;
    Bevel12: TBevel;
    Button13: TButton;
    RecvMemo: TMemo;
    Button14: TButton;
    Button15: TButton;
    IPAddrEdit: TEdit;
    UserEdit: TEdit;
    Edit15: TEdit;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Button16: TButton;
    TestEdit: TEdit;
    ErrMemo: TMemo;
    ModelEdit: TEdit;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ElementRadioClick(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure GetDataButton_SClick(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  protected
    function QueryData(AMaxLength: integer; AMsg: string; var Abuf: TDynaArray):Boolean;
    procedure DispError(AErrNo: integer); overload;
    procedure DispError(AErrMsg: string); overload;
    procedure InitVar;
    procedure InitErrorMsg;
    procedure InitFunctionList;
    function CutLeft(const ASymbol: string; var AInData: string): string;
    procedure SetSendMonitor(const AMsg: string);
    procedure SetReceiveMonitor(const AMsg: string);
    procedure ReadItemSettings(ADataType: integer = 0);
    procedure GetUpdateRate(var AMsg: Ansistring);
    function GetRanges(ANo: integer): boolean;
    procedure OnRadioHar;
    procedure OnRadioNml;
    procedure OnSelchangeComboItems;
    procedure SendItemSettings;
    procedure GetItemData;
  public
    FFileName: string;

    FWT1600Connection: TWT1600Connection;
    FNormalFunctionList: TStringList;
    FHarmonicFunctionList: TStringList;
    FErrorMessage: TStringList;
    FUpdateRateList: TStringList;
    FVoltageList_3: TStringList;
    FVoltageList_6: TStringList;
    FElementList: TStringList;
    FOrderList: TStringList;

    FCurrentAry: array[0..3,0..12] of string;

    FRestFactor: string;
    FLastElement: integer;

  end;

var
  Form1: TForm1;

implementation

uses WT1600_Util, WT1600Const;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FWT1600Connection := TWT1600Connection.Create(0,'');
  FErrorMessage := TStringList.Create;
  FNormalFunctionList := TStringList.Create;
  FHarmonicFunctionList := TStringList.Create;
  FUpdateRateList := TStringList.Create;
  FVoltageList_3 := TStringList.Create;
  FVoltageList_6 := TStringList.Create;
  FElementList := TStringList.Create;
  FOrderList := TStringList.Create;

  InitErrorMsg;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FWT1600Connection.Finish;
  
  FElementList.Free;
  FOrderList.Free;
  FVoltageList_3.Free;
  FVoltageList_6.Free;

  FUpdateRateList.Free;
  FHarmonicFunctionList.Free;
  FNormalFunctionList.Free;
  FErrorMessage.Free;
  FWT1600Connection.Free;
end;

procedure TForm1.Button16Click(Sender: TObject);
var
  LMsg: string;
  LBuf: TDynaArray;
  LModel: string;
begin

  FWT1600Connection.ConnectAddress := AnsiString(IPAddrEdit.Text);
  FWT1600Connection.ConnectType := 8;
  if FWT1600Connection.Initialize = 0 then
    Showmessage('Connect Success')
  else
  begin
    FWT1600Connection.Finish;
    Showmessage('Connect Failed');
    exit;
  end;//else

{  LBuf := nil;
  LMsg := '*IDN?';
  SetSendMonitor(LMsg);
  QueryData(30, LMsg, LBuf);
  LModel := String(LBuf);
  SetReceiveMonitor(LModel);

  LBuf := nil;
  LMsg := ':INPUT:CFACTOR?';
  SetSendMonitor(LMsg);
  QueryData(20, LMsg, LBuf);
  FRestFactor := String(LBuf);
  SetReceiveMonitor(FRestFactor);
}
  InitVar;
end;

function TForm1.QueryData(AMaxLength: integer; AMsg: string; var Abuf: TDynaArray):Boolean;
var
  Li: integer;
  LRealLength: integer;
begin
  //Send Command.
  Li := FWT1600Connection.Send(AMsg);

  if Li <> 0 then
  begin
    DispError(Li);
    Result := False;
    exit;
  end;//if

  //Queries Data.
  SetLength(Abuf, AMaxLength);
  Li := FWT1600Connection.Receive(@Abuf[0], AMaxLength,@LRealLength );

  if Li <> 0 then
  begin
    DispError(Li);
    Result := False;
    exit;
  end;//if
  Result := True;
end;

procedure TForm1.DispError(AErrNo: integer);
var
  Li: integer;
begin
  Li := 0;

  if AErrNo = 0 then
    ErrMemo.Lines.Add('getting detail error failed.')
  else
  begin
    while ((2 shl Li) <> AErrNo) do
      inc(Li);

    ErrMemo.Lines.Add(FErrorMessage.Strings[Li]);
  end;

end;


procedure TForm1.DispError(AErrMsg: string);
begin
  ErrMemo.Lines.Add(AErrMsg);
end;

procedure TForm1.InitErrorMsg;
begin
  FErrorMessage.Add('Device not found: Check the wiring.');
  FErrorMessage.Add('Connection to device failed: Check the wiring.');
  FErrorMessage.Add('Device not connected: Connect the device using the initialization function.');
  FErrorMessage.Add('Device already connected: Two connections cannot be opened.');
  FErrorMessage.Add('Incompatible PC: Check the hardware you are using.');
  FErrorMessage.Add('Illegal parameter: Check parameter type etc.');
  FErrorMessage.Add('');
  FErrorMessage.Add('Send error: Check the wiring, address, and ID.');
  FErrorMessage.Add('Receive error: Check whether an error occurred on the device.');
  FErrorMessage.Add('Received data not block data');
  FErrorMessage.Add('System error: There is a problem with the operating environment.');
  FErrorMessage.Add('Illegal device ID: Use the ID of the device acquired by the initialization function.');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Li: integer;
  LMsg: string;
  LValue: Ansistring;
  LBuf: TDynaArray;
begin
  //InitErrorMsg;
  //for Li := 0 to FErrorMessage.Count - 1 do
    //ErrMemo.Lines.Add(FErrorMessage.Strings[Li]);

  LMsg := ':HARMONICS:STATE?';
  SetSendMonitor(LMsg);
  QueryData(30, LMsg, LBuf);
  LValue := String(LBuf);
  SetReceiveMonitor(LValue);
  GetToken(LValue, ' ');
  if LValue = '1' then
  begin
    UpdateRateCombo.Clear;
    DispError('Can not set update rate in harmonics mode!');
  end
  else
  begin
    //Send Command.
    LValue := UpdateRateCombo.Text;
    LMsg := ':RATE ' + LValue;
    SetSendMonitor(LMsg);

    Li := FWT1600Connection.Send(LMsg);

    if Li <> 0 then
    begin
      DispError(FWT1600Connection.GetLastError());
      //when setting failed, resume the original value.
      GetUpdateRate(LValue);
    end;

    GetUpdateRate(LValue);
  end;
end;

procedure TForm1.InitFunctionList;
begin
    //==============================
    ///Normal Data Function List
    //==============================
    ///to get more about the command
    ///of a function, see 5.5 in the
    ///communication manual.
    //==============================
    FNormalFunctionList.Add('URMS'); //"Urms"        0]
    FNormalFunctionList.Add('UMN'); //"Umean"        1]
    FNormalFunctionList.Add('UDC'); //"Udc"          2]
    FNormalFunctionList.Add('UAC'); //"Uac"          3]
    FNormalFunctionList.Add('IRMS'); //"Irms"        4]
    FNormalFunctionList.Add('IMN'); //"Imean"        5]
    FNormalFunctionList.Add('IDC'); //"Idc"          6]
    FNormalFunctionList.Add('IAC'); //"Iac"          7]
    FNormalFunctionList.Add('P'); //                   8]
    FNormalFunctionList.Add('S'); //                   9]
    FNormalFunctionList.Add('Q'); //                   10
    FNormalFunctionList.Add('LAMBDA'); //"ƒÉ"        11
    FNormalFunctionList.Add('PHI'); //"ƒÓ"           12
    FNormalFunctionList.Add('FU'); //"FreqU"         13
    FNormalFunctionList.Add('FI'); //"FreqI"         14
    FNormalFunctionList.Add('UPPEAK'); //"U +peak"   15
    FNormalFunctionList.Add('UMPEAK'); //"U -peak"   16
    FNormalFunctionList.Add('IPPEAK'); //"i +peak"   17
    FNormalFunctionList.Add('IMPEAK'); //"i -peak"   18
    FNormalFunctionList.Add('CFU'); //"CfU"          19
    FNormalFunctionList.Add('CFI'); //"CfI"          20
    FNormalFunctionList.Add('FFU'); //"FfU"          21
    FNormalFunctionList.Add('FFI'); //"FfI"          22
    FNormalFunctionList.Add('Z');  //                  23
    FNormalFunctionList.Add('RS'); //"Rs"            24
    FNormalFunctionList.Add('XS'); //"Xs"            25
    FNormalFunctionList.Add('RP'); //"Rp"            26
    FNormalFunctionList.Add('XP'); //"Xp"            27
    FNormalFunctionList.Add('PC'); //"Pc"            28
    FNormalFunctionList.Add('TIME'); //"i -Time"     29
    FNormalFunctionList.Add('WH'); //"Wp"            30
    FNormalFunctionList.Add('WHP'); //"Wp+"          31
    FNormalFunctionList.Add('WHM'); //"Wp-"          32
    FNormalFunctionList.Add('AH'); //"q"             33
    FNormalFunctionList.Add('AHP'); //"q+"           34
    FNormalFunctionList.Add('AHM'); //"q-"           35
    //NO ELEMENT SETTINGS BELOW                      LE
    FNormalFunctionList.Add('ETA'); //"ƒÅ"           36
    FNormalFunctionList.Add('SETA'); //"1/ƒÅ"        37
    //(Motor)
    FNormalFunctionList.Add('PM'); //"Pm"            38
    FNormalFunctionList.Add('TORQUE'); //"Torque"    39
    FNormalFunctionList.Add('SPEED'); //"Speed"      40
    FNormalFunctionList.Add('SLIP'); //"Slip"        41
    FNormalFunctionList.Add('SYNC'); //"Sync"        42
    FNormalFunctionList.Add('MAETA'); //"ƒÅmA"       43
    FNormalFunctionList.Add('MBETA'); //"ƒÅmB"       44
    //(ƒ¢1~ƒ¢4)
    FNormalFunctionList.Add('DURMS'); //"ƒ¢Urms"     45
    FNormalFunctionList.Add('DUMN'); //"ƒ¢Umn"       46
    FNormalFunctionList.Add('DUDC'); //"ƒ¢Udc"       47
    FNormalFunctionList.Add('DUAC'); //"ƒ¢Uac"       48
    FNormalFunctionList.Add('DIRMS'); //"ƒ¢Irms"     49
    FNormalFunctionList.Add('DIMN'); //"ƒ¢Imn"       50
    FNormalFunctionList.Add('DIDC'); //"ƒ¢Idc"       51
    FNormalFunctionList.Add('DIAC'); //"ƒ¢Iac"       52
    FNormalFunctionList.Add('');    //                 53

    //============================
    ///Harmonics Data Function List
    //============================
    //E1~E9,ORDER
    FHarmonicFunctionList.Add('U');//                       0]
    FHarmonicFunctionList.Add('I');//                       1]
    FHarmonicFunctionList.Add('P');//;                       2]
    FHarmonicFunctionList.Add('S');//                       3]
    FHarmonicFunctionList.Add('Q');//                       4]
    FHarmonicFunctionList.Add('LAMBDA'); //"ƒÉ"           5]
    FHarmonicFunctionList.Add('PHI'); //"ƒÓ"              6]
    FHarmonicFunctionList.Add('PHIU'); //"ƒÓU"            7]
    FHarmonicFunctionList.Add('PHII'); //"ƒÓI"            8]
    FHarmonicFunctionList.Add('Z');   //                    9]
    FHarmonicFunctionList.Add('RS'); //"Rs"              10
    FHarmonicFunctionList.Add('XS'); //"Xs"              11
    FHarmonicFunctionList.Add('RP'); //"Rp"              12
    FHarmonicFunctionList.Add('XP'); //"Xp"              13
    FHarmonicFunctionList.Add('UHDF'); //"Uhdf"          14
    FHarmonicFunctionList.Add('IHDF'); //"Ihdf"          15
    FHarmonicFunctionList.Add('PHDF'); //"Phdf"          16
    //NO ORDER SETTINGS «
    FHarmonicFunctionList.Add('UTHD'); //"Uthd"          17
    FHarmonicFunctionList.Add('ITHD'); //"Ithd"          18
    FHarmonicFunctionList.Add('PTHD'); //"Pthd"          19
    FHarmonicFunctionList.Add('UTHF'); //"Uthf"          20
    FHarmonicFunctionList.Add('ITHF'); //"Ithf"          21
    FHarmonicFunctionList.Add('UTIF'); //"Utif"          22
    FHarmonicFunctionList.Add('ITIF'); //"Itif"          23
    FHarmonicFunctionList.Add('HVF'); //"Hvf"            24
    FHarmonicFunctionList.Add('HCF'); //"Hcf"            25
    FHarmonicFunctionList.Add('FU'); //"fU"              26
    FHarmonicFunctionList.Add('FI'); //"fI"              27
    //E7~E9
    FHarmonicFunctionList.Add('PHI_U1U2'); //"ƒÓU1-U2"   28
    FHarmonicFunctionList.Add('PHI_U1U3'); //"ƒÓU1-U3"   29
    FHarmonicFunctionList.Add('PHI_U1I1'); //"ƒÓU1-I1"   30
    FHarmonicFunctionList.Add('PHI_U1I2'); //"ƒÓU1-I2"   31
    FHarmonicFunctionList.Add('PHI_U1I3'); //"ƒÓU1-I3"   32
    //CUSTEM FUNCTIONS
    FHarmonicFunctionList.Add('F1'); //"F1"              33
    FHarmonicFunctionList.Add('F2'); //"F2"              34
    FHarmonicFunctionList.Add('F3');//"F3"              35
    FHarmonicFunctionList.Add('F4');//"F4"              36
    FHarmonicFunctionList.Add('');//                    37

    //===========================
    ///UpdateRate List
    //===========================
    FUpdateRateList.Add('50ms');   //0
    FUpdateRateList.Add('100ms');   //1
    FUpdateRateList.Add('200ms');   //2
    FUpdateRateList.Add('500ms');   //3
    FUpdateRateList.Add('1s');   //4
    FUpdateRateList.Add('2s');   //5
    FUpdateRateList.Add('5s');   // 6
    FUpdateRateList.Add('');   //7

    //===========================
    ///Voltage Range List
    //===========================
    //CrestFactor = 3
    FVoltageList_3.Add('1.5V');//     0]
    FVoltageList_3.Add('3V');//       1]
    FVoltageList_3.Add('6V');//       2]
    FVoltageList_3.Add('10V');//      3]
    FVoltageList_3.Add('15V');//      4]
    FVoltageList_3.Add('30V');//      5]
    FVoltageList_3.Add('60V');//      6]
    FVoltageList_3.Add('100V');//     7]
    FVoltageList_3.Add('150V');//     8]
    FVoltageList_3.Add('300V');//     9]
    FVoltageList_3.Add('600V');//    10
    FVoltageList_3.Add('1000V');//   11
    FVoltageList_3.Add('');//     12
    //CrestFact:= 6                6
    FVoltageList_6.Add('0.75V');//    0]
    FVoltageList_6.Add('1.5V');//     1]
    FVoltageList_6.Add('3V');//       2]
    FVoltageList_6.Add('5V');//       3]
    FVoltageList_6.Add('7.5V');//     4]
    FVoltageList_6.Add('15V');//      5]
    FVoltageList_6.Add('30V');//      6]
    FVoltageList_6.Add('50V');//      7]
    FVoltageList_6.Add('75V');//      8]
    FVoltageList_6.Add('150V');//     9]
    FVoltageList_6.Add('300V');//    10
    FVoltageList_6.Add('500V');//    11
    FVoltageList_6.Add('');//    12

    //===========================
    ///Current Range List
    //===========================
    //CrestFactor = 3, Direct
    FCurrentAry[0][0] := '10mA';
    FCurrentAry[0][1] := '20mA';
    FCurrentAry[0][2] := '50mA';
    FCurrentAry[0][3] := '100mA';
    FCurrentAry[0][4] := '200mA';
    FCurrentAry[0][5] := '500mA';
    FCurrentAry[0][6] := '1A';
    FCurrentAry[0][7] := '2A';
    FCurrentAry[0][8] := '5A';
    FCurrentAry[0][9] := '10A';
    FCurrentAry[0][10] := '20A';
    FCurrentAry[0][11] := '50A';
    FCurrentAry[0][12] := '';

    //CrestFactor := 6, Direct
    FCurrentAry[1][0] := '5mA';
    FCurrentAry[1][1] := '10mA';
    FCurrentAry[1][2] := '25mA';
    FCurrentAry[1][3] := '50mA';
    FCurrentAry[1][4] := '100mA';
    FCurrentAry[1][5] := '250mA';
    FCurrentAry[1][6] := '500mA';
    FCurrentAry[1][7] := '1A';
    FCurrentAry[1][8] := '2.5A';
    FCurrentAry[1][9] := '5A';
    FCurrentAry[1][10] := '10A';
    FCurrentAry[1][11] := '25A';
    FCurrentAry[1][12] := '';

    //CrestFactor := 3, Sensor
    FCurrentAry[2][0] := '50mV';
    FCurrentAry[2][1] := '100mV';
    FCurrentAry[2][2] := '250mV';
    FCurrentAry[2][3] := '500mV';
    FCurrentAry[2][4] := '1V';
    FCurrentAry[2][5] := '2.5V';
    FCurrentAry[2][6] := '5V';
    FCurrentAry[2][7] := '10V';
    FCurrentAry[2][8] := '';
    FCurrentAry[2][9] := '';
    FCurrentAry[2][10] := '';
    FCurrentAry[2][11] := '';
    FCurrentAry[2][12] := '';

    //CrestFactor := 6, Sensor
    FCurrentAry[3][0] := '25mV';
    FCurrentAry[3][1] := '50mV';
    FCurrentAry[3][2] := '125mV';
    FCurrentAry[3][3] := '250mV';
    FCurrentAry[3][4] := '500mV';
    FCurrentAry[3][5] := '1.25V';
    FCurrentAry[3][6] := '2.5V';
    FCurrentAry[3][7] := '5V';
    FCurrentAry[3][8] := '';
    FCurrentAry[3][9] := '';
    FCurrentAry[3][10] := '';
    FCurrentAry[3][11] := '';
    FCurrentAry[3][12] := '';

    //===========================
    ///Element List
    //===========================
    FElementList.Add('1');//     0
    FElementList.Add('2');//     1
    FElementList.Add('3');//     2
    FElementList.Add('4');//     3
    FElementList.Add('5');//     4
    FElementList.Add('6');//     5
    FElementList.Add('SGMA');//  6
    FElementList.Add('SGMB');//  7
    FElementList.Add('SGMC');//  8
    FElementList.Add('');//   9

    //===========================
    ///Order List
    //===========================
    FOrderList.Add('TOTAL');//    0]
    FOrderList.Add('DC');//       1]
    FOrderList.Add('1');//        2]
    FOrderList.Add('2');//        3]
    FOrderList.Add('3');//        4]
    FOrderList.Add('4');//        5]
    FOrderList.Add('5');//        6]
    FOrderList.Add('6');//        7]
    FOrderList.Add('7');//        8]
    FOrderList.Add('8');//        9]
    FOrderList.Add('9');//       10]
    FOrderList.Add('10');//      11]
    FOrderList.Add('11');//      12]
    FOrderList.Add('12');//      13]
    FOrderList.Add('13');//      14]
    FOrderList.Add('14');//      15]
    FOrderList.Add('15');//      16]
    FOrderList.Add('16');//      17]
    FOrderList.Add('17');//      18]
    FOrderList.Add('18');//      19]
    FOrderList.Add('19');//      20]
    FOrderList.Add('20');//      21]
    FOrderList.Add('21');//      22]
    FOrderList.Add('22');//      23]
    FOrderList.Add('23');//      24]
    FOrderList.Add('24');//      25]
    FOrderList.Add('25');//      26]
    FOrderList.Add('26');//      27]
    FOrderList.Add('27');//      28]
    FOrderList.Add('28');//      29]
    FOrderList.Add('29');//      30]
    FOrderList.Add('30');//      31]
    FOrderList.Add('31');//      32]
    FOrderList.Add('32');//      33]
    FOrderList.Add('33');//      34]
    FOrderList.Add('34');//      35]
    FOrderList.Add('35');//      36]
    FOrderList.Add('36');//      37]
    FOrderList.Add('37');//      38]
    FOrderList.Add('38');//      39]
    FOrderList.Add('39');//      40]
    FOrderList.Add('40');//      41]
    FOrderList.Add('41');//      42]
    FOrderList.Add('42');//      43]
    FOrderList.Add('43');//      44]
    FOrderList.Add('44');//      45]
    FOrderList.Add('45');//      46]
    FOrderList.Add('46');//      47]
    FOrderList.Add('47');//      48]
    FOrderList.Add('48');//      49]
    FOrderList.Add('49');//      50]
    FOrderList.Add('50');//      51]
    FOrderList.Add('51');//      52]
    FOrderList.Add('52');//      53]
    FOrderList.Add('53');//      54]
    FOrderList.Add('54');//      55]
    FOrderList.Add('55');//      56]
    FOrderList.Add('56');//      57]
    FOrderList.Add('57');//      58]
    FOrderList.Add('58');//      59]
    FOrderList.Add('59');//      60]
    FOrderList.Add('60');//      61]
    FOrderList.Add('61');//      62]
    FOrderList.Add('62');//      63]
    FOrderList.Add('63');//      64]
    FOrderList.Add('64');//      65]
    FOrderList.Add('65');//      66]
    FOrderList.Add('66');//      67]
    FOrderList.Add('67');//      68]
    FOrderList.Add('68');//      69]
    FOrderList.Add('69');//      70]
    FOrderList.Add('70');//      71]
    FOrderList.Add('71');//      72]
    FOrderList.Add('72');//      73]
    FOrderList.Add('73');//      74]
    FOrderList.Add('74');//      75]
    FOrderList.Add('75');//      76]
    FOrderList.Add('76');//      77]
    FOrderList.Add('77');//      78]
    FOrderList.Add('78');//      79]
    FOrderList.Add('79');//      80]
    FOrderList.Add('80');//      81]
    FOrderList.Add('81');//      82]
    FOrderList.Add('82');//      83]
    FOrderList.Add('83');//      84]
    FOrderList.Add('84');//      85]
    FOrderList.Add('85');//      86]
    FOrderList.Add('86');//      87]
    FOrderList.Add('87');//      88]
    FOrderList.Add('88');//      89]
    FOrderList.Add('89');//      90]
    FOrderList.Add('90');//      91]
    FOrderList.Add('91');//      92]
    FOrderList.Add('92');//      93]
    FOrderList.Add('93');//      94]
    FOrderList.Add('94');//      95]
    FOrderList.Add('95');//      96]
    FOrderList.Add('96');//      97]
    FOrderList.Add('97');//      98]
    FOrderList.Add('98');//      99]
    FOrderList.Add('99');//     100
    FOrderList.Add('100');//    101
    FOrderList.Add('');//    102


end;

function TForm1.CutLeft(const ASymbol: string;
  var AInData: string): string;
var
  Li: integer;
begin
  if AInData = '' then
  begin
    Result := '';
    exit;
  end;

  Li := Pos(ASymbol, AInData);

  if Li > 0 then
  begin
    Result := Copy(AInData, 1, Li-1);
    Delete(AInData,1,Li);
  end
  else
  begin
    Result := AInData;
    AInData := '';
  end;end;

procedure TForm1.SetReceiveMonitor(const AMsg: string);
begin
  RecvMemo.Lines.Add(AMsg);
end;

procedure TForm1.SetSendMonitor(const AMsg: string);
begin
  SendMemo.Lines.Add(AMsg);
end;

//=============================================//
///<summary>
///Function: ReadItemSettings
///</summary>
///<param>
///0(recheck), 1(normal), 2(harmonics)
///</param>
//=============================================//
procedure TForm1.ReadItemSettings(ADataType: integer);
var
  LMsg, LMsg2: Ansistring;
  LBuf: TDynaArray;
  Li: integer;
begin
  if ADataType = 0 then
  begin
    //----------------------#get NORMAL/HARMONICS#
    LBuf := nil;
    LMsg := ':HARMONICS:STATE?';
    SetSendMonitor(LMsg);
    if not QueryData(20, LMsg, LBuf) then
      exit;
    LMsg := String(LBuf);
    SetReceiveMonitor(LMsg);
    //----------------------#get update rate#
    GetUpdateRate(LMsg);
    //----------------------#set normal/harmonics option#
    if LMsg = '1' then
    begin //check harmonics option
      HarmonicsRadio.Checked := True;
      NormalRadio.Checked := False;
      OnRadioHar();
      exit;
    end
    else
    begin //check normal option
      HarmonicsRadio.Checked := False;
      NormalRadio.Checked := True;
      OnRadioNml();
      exit;
    end;
  end;//if

  //----------------------#get ASCII/BINARY#
  LBuf := nil;
  LMsg := ':NUMERIC:FORMAT?';
  SetSendMonitor(LMsg);
  if not QueryData(30, LMsg, LBuf) then
    exit;
  LMsg := String(LBuf);
  SetReceiveMonitor(LMsg);

  if Pos('ASC', LMsg) > 0 then
  begin
    ASCIIRadio.Checked := True;
    BinRadio.Checked := False;
  end
  else
  begin
    ASCIIRadio.Checked := False;
    BinRadio.Checked := True;
  end;

  //----------------------#get item count#
  if ADataType = 1 then
    LMsg := ':NUMERIC:NORMAL:NUMBER?'
  else
    LMsg := ':NUMERIC:HARMONICS:NUMBER?';

  SetSendMonitor(LMsg);
  if not QueryData(30, LMsg, LBuf) then
    exit;
  LMsg := String(LBuf);
  SetReceiveMonitor(LMsg);

  //----------------------#set item count combo#
  Li := StrToInt(LMsg);
  if Li > MAX_ITEM then
    ItemCountCombo.Items.SetText(PChar(IntToStr(MAX_ITEM)))
  else
    ItemCountCombo.Items.SetText(PChar(LMsg));

  OnSelchangeComboItems();

  //----------------------#get item settings#
  if ADataType = 1 then
    LMsg := ':NUMERIC:NORMAL?'
  else
    LMsg := ':NUMERIC:HARMONICS?';

  //###:NUM:NUM 6;ITEM IMN,6;ITEM2 IDC,5;ITEM3 IAC,4;ITEM4 P,3;ITEM5 S,2;ITEM6 URMS,1###
  SetSendMonitor(LMsg);
  if not QueryData(30 + 30*Li, LMsg, LBuf) then
    exit;
  LMsg := String(LBuf);
  SetReceiveMonitor(LMsg);
  //cut off the item number(item count) portion.
  GetToken(LMsg, ';');
  //display as "LAMB" when received a "LAMBDA"(Functions).
  replaceString(LMsg, 'LAMB,', 'LAMBDA,', True);
  replaceString(LMsg, 'PP,', 'PPEAK,', True);
  replaceString(LMsg, 'MP,', 'MPEAK,', True);
  replaceString(LMsg, 'TORQ,', 'TORQUE,', True);
  replaceString(LMsg, 'SPE,', 'SPEED,', True);
  replaceString(LMsg, 'ET,', 'ETA,', True);
  //display as "SGM" when received a "SIGM"(Elements).
  replaceString(LMsg, 'SIGM,', 'SGM,', True);
  //----------------------#set item settings to be display#
  for Li := 1 to StrToInt(ItemCountCombo.Text) do
  begin
    LMsg2 := GetToken(LMsg, ';');
    //#set function.#
    with TComboBox(FindComponent('FunctionCombo' + IntToStr(Li))) do
      Text := GetToken(LMsg2, ',');
    //#set element.#
    LMsg2 := GetToken(LMsg2, ',');
    if pos('SGM',LMsg2) > 0 then
      //display as "SGMA"
      LMsg2 := 'SGMA';

    with TComboBox(FindComponent('ElememtCombo' + IntToStr(Li))) do
      Text := LMsg2;

    //#set order when harmonics.#
    if ADataType = 2 then
    begin
      if Pos('TOT', LMsg) > 0 then
        //display "TOT" as "TOTAL"
        LMsg2 := 'TOTAL';

      with TComboBox(FindComponent('OrderCombo' + IntToStr(Li))) do
        Text := LMsg2;
    end;//if
  end;//for
end;

procedure TForm1.GetUpdateRate(var AMsg: Ansistring);
var
  LMsg: string;
  LBuf: TDynaArray;
  LRate: double;
begin
  if AMsg = '' then
  begin
    LMsg := ':HARMONICS:STATE?';
    SetSendMonitor(LMsg);
    if not QueryData(20, LMsg, LBuf) then
      exit;
    AMsg := String(LBuf);
    SetReceiveMonitor(AMsg);
  end;//if

  UpdateRateCombo.Clear;
  if AMsg = '1' then
  begin
    UpdateRateCombo.Enabled := False;
    Button2.Enabled := False;
    exit;
  end//if
  else
  begin
    UpdateRateCombo.Enabled := True;
    Button2.Enabled := True;
    UpdateRateCombo.Items := FUpdateRateList;
  end;//else

  LMsg := ':RATE?';
  SetSendMonitor(LMsg);
  if not QueryData(30, LMsg, LBuf) then
    exit;
  AMsg := String(LBuf);
  SetReceiveMonitor(AMsg);

  AMsg := GetToken(AMsg, #10);
  LRate := StrToFloat(AMsg);
  if LRate < 1.0 then
  begin
    AMsg := format('%.0f', [LRate * 1000]);
    UpdateRateCombo.Text := AMsg + 'ms';
  end
  else
  begin
    AMsg := format('%.0f', [LRate]);
    UpdateRateCombo.Text := AMsg + 's';
  end;

end;

procedure TForm1.Button14Click(Sender: TObject);
var
  LMsg: string;
  Li: integer;
begin
  if MessageDlg('System will be All Reset, continue?',mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    LMsg := '*RST';
    SetSendMonitor(LMsg);
    Li := FWT1600Connection.Send(LMsg);
    if Li <> 0 then
      DispError(FWT1600Connection.GetLastError())
    else
    begin
      GetRanges(ElementRadio.ItemIndex + 1);
      ReadItemSettings(0);//0: set normal/harmonics option according to the instrument.
    end;
  end;
end;

function TForm1.GetRanges(ANo: integer): boolean;
var
  Li: integer;
  LMsg: Ansistring;
  LBuf: TDynaArray;
  LTerminal: string;
  LModule: string;
  LRange: Ansistring;
  Doublerange: double;
begin
  VoltageCombo.Clear;
  CurrentCombo.Clear;

  LBuf := nil;
  LMsg := ':INPUT:CURRENT:TERMINAL?';
  SetSendMonitor(LMsg);

  if not QueryData(150, LMsg, LBuf) then
  begin
    Result := false;
    exit;
  end;//if

  //find the terminal that is checked now
  LMsg := string(LBuf);
  //Format:"INPUT:CURRENT:TERMINAL:ELEMENT1 DIRECT;ELEMENT2 SENSOR;..."
  for Li := 1 to ANo - 1 do
    LTerminal := GetToken(Lmsg, ';');
  SetReceiveMonitor(string(LBuf));

  LBuf := nil;
  LMsg := format(':INPUT:MODULE? %d', [ANo]);
  SetSendMonitor(LMsg);

  if not QueryData(150, LMsg, LBuf) then
  begin
    Result := false;
    exit;
  end;//if
  
  LModule := string(LBuf);
  SetReceiveMonitor(LModule);

  //----------------------#Set the Range Lists#
  //when crest factor == 3, set ranges.
  if FrestFactor = '3' then
  begin
    VoltageCombo.Items := FVoltageList_3;
    VoltageCombo.Items.Append(CrangeListAuto);
    ///#set current list#
    if LModule = '50' then // when 50A's terminal
    begin
      for Li := 6 to 12 do
        CurrentCombo.Items.Add(FCurrentAry[0][Li]);
    end
    else if LModule = '5' then // when 5A's terminal
    begin
      for Li := 0 to 9 do
        CurrentCombo.Items.Add(FCurrentAry[0][Li]);
    end;

    for Li := 0 to 7 do
      CurrentCombo.Items.Add(FCurrentAry[2][Li]);

    CurrentCombo.Items.Append(CrangeListAuto);
  end
  else
  if FrestFactor = '6' then //when crest factor == 6, set ranges.
  begin
    ///#set voltage list#
    VoltageCombo.Items := FVoltageList_6;
    VoltageCombo.Items.Append(CrangeListAuto);

    ///#set current list#
    if LModule = '50' then // when 50A's terminal
    begin
      for Li := 6 to 12 do
        CurrentCombo.Items.Add(FCurrentAry[1][Li]);
    end
    else if LModule = '5' then // when 5A's terminal
    begin
      for Li := 0 to 9 do
        CurrentCombo.Items.Add(FCurrentAry[1][Li]);
    end;

    for Li := 0 to 7 do
      CurrentCombo.Items.Add(FCurrentAry[3][Li]);

    CurrentCombo.Items.Append(CrangeListAuto);
  end;//if '6'

  //----------------------#Get Voltage Range Settings#
  //###":VOLT:RANG:ELEM1 3.00E+00;ELEM2 1.00E+03"###
  LBuf := nil;
  LMsg := format(':INPUT:VOLTAGE:RANGE:ELEMENT%d?', [ANo]);
  SetSendMonitor(LMsg);

  if not QueryData(60, LMsg, LBuf) then
  begin
    Result := false;
    exit;
  end;//if

  LRange := string(LBuf);
  SetReceiveMonitor(LRange);

  if LRange = CrangeListAuto then
    VoltageCombo.Text := LRange
  else
  begin
    //Doublerange := StrToFloat(LRange);
    //LRange := format('%f',[LRange]);
    LRange := GetToken(LRange, #10);
    //range.TrimRight("0");
    //range.TrimRight(".");
    VoltageCombo.Text := LRange + 'V';
  end;

  //----------------------#Get Current Range Settings#
  //###":CURR:RANG:ELEM5 3.00E+00;ELEM6 1.00E-03"###
  LBuf := nil;
  LMsg := format(':INPUT:CURRENT:RANGE:ELEMENT%d?', [ANo]);
  SetSendMonitor(LMsg);

  if not QueryData(60, LMsg, LBuf) then
  begin
    Result := false;
    exit;
  end;//if

  LRange := string(LBuf);
  SetReceiveMonitor(LRange);

  if LRange = CrangeListAuto then
    CurrentCombo.Text := LRange
  else
  begin
    LRange := GetToken(LRange, #10);
    Doublerange := StrToFloat(LRange);
    if Doublerange < 1 then
    begin
      LRange := format('%f',[Doublerange * 1000]);//when "mA/mV" unit, multiply 1k.
      //range.TrimRight("0");
      //range.TrimRight(".");
      if Pos('DIR',LTerminal) > 0 then
        CurrentCombo.Text := LRange + 'mA'
      else
        CurrentCombo.Text := LRange + 'mV';
    end
    else
    begin
      //###1.5V, 0.75V, 2.5A, ...###
      LRange := format('%f',[Doublerange]);//when "mA/mV" unit, multiply 1k.
      //range.TrimRight("0");
      //range.TrimRight(".");

      if Pos('DIR',LTerminal) > 0 then
        CurrentCombo.Text := LRange + 'A'
      else
        CurrentCombo.Text := LRange + 'V';

    end;
  end;

  Result := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Li: integer;
  LMsg: string;
  LBuf: TDynaArray;
  LRange: string;
begin
  LRange := VoltageCombo.Text;
  LMsg := Format(':INPUT:VOLTAGE:RANGE:ELEMENT%d %s', [ElementRadio.ItemIndex + 1, LRange]);
  SetSendMonitor(LMsg);
  Li := FWT1600Connection.Send(LMsg);

  if Li <> 0 then
  begin
    DispError(FWT1600Connection.GetLastError());
    //when setting failed, resume the original value.
    GetRanges(ElementRadio.ItemIndex + 1);
    exit;
  end;

	//----------------------#Send Current Range#
	//----------------------#Send Current Range#
  LRange := CurrentCombo.Text;
  if Pos('V', LRange) > 0 then
    LMsg := Format(':INPUT:CURRENT:TERMINAL:ELEMENT%d SENSOR', [ElementRadio.ItemIndex + 1, LRange])
  else if Pos('A', LRange) > 0 then
    LMsg := Format(':INPUT:CURRENT:TERMINAL:ELEMENT%d DIRECT', [ElementRadio.ItemIndex + 1, LRange]);

  SetSendMonitor(LMsg);
  Li := FWT1600Connection.Send(LMsg);

  if Li <> 0 then
  begin
    DispError(FWT1600Connection.GetLastError());
    //when setting failed, resume the original value.
    GetRanges(ElementRadio.ItemIndex + 1);
    exit;
  end;

  LMsg := Format(':INPUT:CURRENT:RANGE:ELEMENT%d %s', [ElementRadio.ItemIndex + 1, LRange]);
  SetSendMonitor(LMsg);
  Li := FWT1600Connection.Send(LMsg);

  if Li <> 0 then
  begin
    DispError(FWT1600Connection.GetLastError());
    //when setting failed, resume the original value.
    GetRanges(ElementRadio.ItemIndex + 1);
    exit;
  end;

  GetRanges(ElementRadio.ItemIndex + 1);

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Li: integer;
  LMsg: string;
  LBuf: TDynaArray;
begin
  if TestEdit.Text = '' then
    exit;

  SetSendMonitor(TestEdit.Text);

  if Pos('?',TestEdit.Text) > 0 then
  begin
    Li := FWT1600Connection.Send(LMsg);
    if Li <> 0 then
      DispError(FWT1600Connection.GetLastError());
  end
  else
  begin
    if not QueryData(1000, LMsg, LBuf) then
    begin
      exit;
    end;//if

    SetReceiveMonitor(LMsg);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  Li: integer;
  LMsg: string;
  LBuf: TDynaArray;
begin
  LMsg := ':STATUS:ERROR?';
  SetSendMonitor(LMsg);

  if not QueryData(150, LMsg, LBuf) then
  begin
    exit;
  end;//if

  LMsg := String(LBuf);
  SetReceiveMonitor(LMsg);
  DispError(LMsg);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  Li: integer;
  LMsg: string;
  LBuf: TDynaArray;
begin
  LMsg := ':COMMUNICATE:HEADER?';
  SetSendMonitor(LMsg);

  if not QueryData(25, LMsg, LBuf) then
  begin
    exit;
  end;//if

  LMsg := String(LBuf);
  SetReceiveMonitor(LMsg);

  if LMsg = '1' then
    LMsg := ':COMMUNICATE:HEADER OFF'
  else
    LMsg := ':COMMUNICATE:HEADER ON';

  SetSendMonitor(LMsg);
  Li := FWT1600Connection.Send(LMsg);

  if Li <> 0 then
  begin
    DispError(FWT1600Connection.GetLastError());
    exit;
  end;

end;

procedure TForm1.Button6Click(Sender: TObject);
var
  Li: integer;
  LMsg: string;
  LBuf: TDynaArray;
begin
  LMsg := ':COMMUNICATE:VERBOSE?';
  SetSendMonitor(LMsg);

  if not QueryData(25, LMsg, LBuf) then
  begin
    exit;
  end;//if

  LMsg := String(LBuf);
  SetReceiveMonitor(LMsg);

  if LMsg = '1' then
    LMsg := ':COMMUNICATE:VERBOSE OFF'
  else
    LMsg := ':COMMUNICATE:VERBOSE ON';

  SetSendMonitor(LMsg);
  Li := FWT1600Connection.Send(LMsg);

  if Li <> 0 then
  begin
    DispError(FWT1600Connection.GetLastError());
    exit;
  end;

end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  SendMemo.Clear;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  RecvMemo.Clear;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  ReadItemSettings(0);
end;

procedure TForm1.OnRadioHar;
var
  LitemIndex: integer;
  Li: integer;
begin
  for Li := 1 to MAX_ITEM do
  begin
    //----------------------#set function comboBoxes#
    with TComboBox(FindComponent('FunctionCombo' + IntToStr(Li))) do
    begin
      Items.Clear;
      Items.AddStrings(FHarmonicFunctionList);
    end;

    //----------------------#set elememt comboBoxes#
    with TComboBox(FindComponent('ElememtCombo' + IntToStr(Li))) do
    begin
      Items.Clear;
      Items.AddStrings(FElementList);
    end;

    //----------------------#set order comboBoxes#
    with TComboBox(FindComponent('OrderCombo' + IntToStr(Li))) do
    begin
      Items.Clear;
      Items.AddStrings(FOrderList);
    end;

    //----------------------#set data editBoxes#
    with TEdit(FindComponent('DataEdit' + IntToStr(Li))) do
    begin
      Text := '';
    end;
  end;//for

  //----------------------#get settings from instrument#
  ReadItemSettings(2);
end;

//==========================================//
///Items Count Changed
//==========================================//
procedure TForm1.OnSelchangeComboItems;
var
  Li: integer;
begin
  //----------------------#set to ReadOnly(true/false)#
  for Li := 1 to StrToInt(ItemCountCombo.Text) do
  begin
    //----------------------#set function comboBoxes#
    with TComboBox(FindComponent('FunctionCombo' + IntToStr(Li))) do
      Enabled := True;

    with TComboBox(FindComponent('ElememtCombo' + IntToStr(Li))) do
      Enabled := True;

    if not NormalRadio.Checked then
      with TComboBox(FindComponent('OrderCombo' + IntToStr(Li))) do
        Enabled := True;

    with TEdit(FindComponent('DataEdit' + IntToStr(Li))) do
      Enabled := True;
  end;//for

  while Li < MAX_ITEM do
  begin
    with TComboBox(FindComponent('FunctionCombo' + IntToStr(Li))) do
      Enabled := False;

    with TComboBox(FindComponent('ElememtCombo' + IntToStr(Li))) do
      Enabled := False;

    if not NormalRadio.Checked then
      with TComboBox(FindComponent('OrderCombo' + IntToStr(Li))) do
        Enabled := False;

    with TEdit(FindComponent('DataEdit' + IntToStr(Li))) do
      Enabled := False;

    inc(Li);
  end;//while
end;

//==========================================//
///Normal Checked
//==========================================//
procedure TForm1.OnRadioNml;
var
  LitemIndex: integer;
  Li: integer;
  LMsg: string;
  LBuf: TDynaArray;
  LOpt: string;
begin
  LMsg := '*OPT?';
  SetSendMonitor(LMsg);

  if not QueryData(20, LMsg, LBuf) then
  begin
    exit;
  end;//if

  LOpt := String(LBuf);
  SetReceiveMonitor(LOpt);

  for Li := 1 to MAX_ITEM do
  begin
    //----------------------#set function comboBoxes#
    with TComboBox(FindComponent('FunctionCombo' + IntToStr(Li))) do
    begin
      Items.Clear;
      Items.AddStrings(FHarmonicFunctionList);
    end;//with
  end;//for

end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  SendItemSettings;
end;

procedure TForm1.SendItemSettings;
var
  Li: integer;
  LMsg: string;
  LBuf: TDynaArray;
  LState: Ansistring;
begin
  //----------------------#get Normal/Harmonics' setting#
  LMsg := ':HARMONICS:STATE?';
  //###:HARMONICS:STATE 1/ :HARM 1/ 1###
  SetSendMonitor(LMsg);

  if not QueryData(20, LMsg, LBuf) then
  begin
    exit;
  end;//if

  LState := String(LBuf);
  SetReceiveMonitor(LState);

  //----------------------#send Normal/Harmonics' setting#
  LMsg := '';
  if NormalRadio.Checked and (LState = '1')then
  begin
    LMsg := ':HARMONICS:STATE OFF';
    LState := '0';
  end
  else if HarmonicsRadio.Checked and (LState = '0') then
  begin
    LMsg := ':HARMONICS:STATE ON';
    LState := '1';
  end;

  if LMsg <> '' then
  begin
    SetSendMonitor(LMsg);
    Li := FWT1600Connection.Send(LMsg);

    if Li <> 0 then
    begin
      DispError(FWT1600Connection.GetLastError());
      exit;
    end;
  end;//if

  //----------------------#get UpdateRate#
  //when normal/harmonics changed,
  //refresh updateRate displays.
  GetUpdateRate(LState);
  //----------------------#set ASCII/Float(Binary)#
  if ASCIIRadio.Checked then
    LMsg := ':NUMERIC:FORMAT ASCII'
  else
    LMsg := ':NUMERIC:FORMAT FLOAT';

  SetSendMonitor(LMsg);
  Li := FWT1600Connection.Send(LMsg);

  if Li <> 0 then
  begin
    DispError(FWT1600Connection.GetLastError());
    exit;
  end;

  //----------------------#set items number#
  if NormalRadio.Checked then
    LMsg := ':NUMERIC:NORMAL:NUMBER ' + ItemCountCombo.Text
  else
    LMsg := ':NUMERIC:HARMONICS:NUMBER ' + ItemCountCombo.Text;

  SetSendMonitor(LMsg);
  Li := FWT1600Connection.Send(LMsg);

  if Li <> 0 then
  begin
    DispError(FWT1600Connection.GetLastError());
    exit;
  end;

  //----------------------#send message detail#
  if NormalRadio.Checked then
    LMsg := ':NUMERIC:NORMAL:'
  else
    LMsg := ':NUMERIC:HARMONICS:';

  for Li := 1 to StrToInt(ItemCountCombo.Text) do
  begin
    //set function parameter into message.
    with TComboBox(FindComponent('FunctionCombo' + IntToStr(Li))) do
      LMsg := LMsg + 'ITEM' + IntToStr(Li) + ' ' + Text;

    //set element parameter into message.
    with TComboBox(FindComponent('ElememtCombo' + IntToStr(Li))) do
      LMsg := LMsg + ',' + Text;

    //set order parameter into message, if have.
    with TComboBox(FindComponent('OrderCombo' + IntToStr(Li))) do
      if Text <> '' then
        LMsg := LMsg + ',' + Text;

    //set separator into message.
    if Li <> StrToInt(ItemCountCombo.Text) then
      LMsg := LMsg + ';';

  end;//for

  LMsg := replaceString(LMsg, 'SGM', 'SIGM', False);
  SetSendMonitor(LMsg);
  Li := FWT1600Connection.Send(LMsg);

  if Li <> 0 then
  begin
    DispError(FWT1600Connection.GetLastError());
    exit;
  end;

end;

//==========================================//
/// <summary> Function: GetData </summary>
//==========================================//
procedure TForm1.GetItemData;
var
  Li: integer;
  LMaxLength: integer;
  LRecvLength: integer;
  LAryChar: array of char;
  LValue: string;
  LMsg: string;
  LRealValue: real;
  LEnd: integer;
begin
  //----------------------#print title(Function) when getting data once#
  if (DataSaveCheckBox.Checked) and (FFileName <> '') and GetDataButton_S.Enabled then
  begin
    //print titles(function) when saveBox is checked.
    ;
  end;//if

  //----------------------#get data#
  if NormalRadio.Checked then
    LMsg := ':NUMERIC:NORMAL:VALUE?'
  else
    LMsg := ':NUMERIC:HARMONICS:VALUE?';

  //----------------------#send message#
  SetSendMonitor(LMsg);
  //###ASCII:TmcSend(); FLOAT:TmcSendBuLength()###
  if ASCIIRadio.Checked then
    Li := FWT1600Connection.Send(LMsg)
  else
    Li := FWT1600Connection.SendByLength(LMsg,Length(LMsg));

  if Li <> 0 then
  begin
    DispError(FWT1600Connection.GetLastError());
    exit;
  end;

  //----------------------#receive values#
  if ASCIIRadio.Checked then
  begin
    //----------------------#receive values by ASCII#
    //###ASCII:TmcReceive()###
    LMaxLength := 15 * StrToInt(ItemCountCombo.Text);
    SetLength(LAryChar, LMaxLength);
    Li := FWT1600Connection.Receive(@LAryChar[0], LMaxLength, @LRecvLength);
    LValue := String(LAryChar);
    LAryChar := nil;

    if Li <> 0 then
    begin
      DispError(FWT1600Connection.GetLastError());
      exit;
    end;//if

    SetReceiveMonitor(LValue);
  end
  else
  begin //----------------------#receive values by Float#
    //###FLOAT:TmcReceiveBlock()###
    FWT1600Connection.ReceiveBlockHeader(@LMaxLength);

    if LMaxLength < 1 then
      exit;

    Inc(LMaxLength);//see tmctl's help
    SetLength(LAryChar, LMaxLength);
    LEnd := 0;

    while ( LEnd = 0 ) do
    begin
      Li := FWT1600Connection.ReceiveBlockData(@LAryChar[0], LMaxLength, @LRealValue, @LEnd);
      if Li <> 0 then
      begin
        LAryChar := nil;
        DispError(FWT1600Connection.GetLastError());
        exit;
      end;

      for Li := 1 to Round(LRealValue) do
      begin
        ;
      end;//for
    end;//while

  end;
end;

procedure TForm1.InitVar;
var
  LModel: string;
  LMsg: Ansistring;
  Li: integer;
  LBuf: TDynaArray;
begin
  InitErrorMsg;
  InitFunctionList;

  LMsg := FWT1600Connection.ConnectModel;
  //----------------------#set ModelType display#
  ModelEdit.Text := LMsg;
  //check model.
  GetToken(LMsg, ',');
  LModel := GetToken(LMsg, '-');

  if LModel <> MODEL then
    DispError('it seems not WT1600, program may run incorrectly!');

  //----------#set unuse element RadioBox disable#
  LModel := GetToken(LMsg, ',');
  FLastElement := StrToInt(LModel);
  //----------------------#Queries the Model(eql to CConnection::m_sName)#
  LMsg := '*IDN?';
  SetSendMonitor(LMsg);
  if not QueryData(30, LMsg, LBuf) then
    exit;
  LMsg := String(LBuf);
  SetReceiveMonitor(LMsg);
  //----------------------#Queries the CrestFactor#
  LMsg := ':INPUT:CFACTOR?';
  SetSendMonitor(LMsg);
  if not QueryData(20, LMsg, LBuf) then
    exit;
  LMsg := String(LBuf);
  LMsg := GetToken(LMsg, #10);
  SetReceiveMonitor(LMsg);

  if FLastElement > 0 then
    ElementRadio.ItemIndex := 0;

  //get current item settings from instrument.
  ReadItemSettings(0);
  ElementRadioClick(Self);
  
end;

procedure TForm1.ElementRadioClick(Sender: TObject);
begin
  GetRanges(ElementRadio.ItemIndex + 1);
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.GetDataButton_SClick(Sender: TObject);
begin
  SendItemSettings();
  GetItemData();
end;

//==========================================//
///GetData by UpdateRate
//==========================================//
procedure TForm1.Button10Click(Sender: TObject);
var
  LMsg: string;
  Li: integer;
  LBuf: TDynaArray;
begin
  if Button10.Caption = 'STOP' then
  begin
    Timer1.Enabled := False;
    Button10.Caption := 'Get Data (Update Rate)';
    //EnableItems;
  end
  else//----------------------#getting datas#
  begin
    SendItemSettings;
    LMsg := ':STATUS:FILTER1 FALL';
    SetSendMonitor(LMsg);
    Li := FWT1600Connection.Send(LMsg);

    if Li <> 0 then
    begin
      DispError(FWT1600Connection.GetLastError());
      exit;
    end;

    //clear eesr
    LMsg := ':STATUS:EESR?';
    SetSendMonitor(LMsg);
    if not QueryData(20, LMsg, LBuf) then
      exit;
    LMsg := String(LBuf);
    SetReceiveMonitor(LMsg);

    Button10.Caption := 'STOP';
    Timer1.Interval := 20;
    Timer1.Enabled := true;
  end;//Button10.Caption = 'STOP'
end;

end.
