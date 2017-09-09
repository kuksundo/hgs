unit formChennelRSWindowsAdd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, MBDeviceClasses, ChennelClasses,
  LoggerItf;

type

  { TfrmChennelRSAddWin }

  TfrmChennelRSAddWin = class(TForm)
    btCancel          : TButton;
    btOk              : TButton;
    cmbBaudRate       : TComboBox;
    cmbByteSize       : TComboBox;
    cmbParitet        : TComboBox;
    cmbStopBits       : TComboBox;
    edChennalName     : TEdit;
    lbTotalConst      : TLabel;
    lbTotalMulti      : TLabel;
    lbPackRupt        : TLabel;
    lbPrefixName      : TLabel;
    lbBaudRate        : TLabel;
    lbByteSize        : TLabel;
    lbName            : TLabel;
    lbParitet         : TLabel;
    lbPortNum         : TLabel;
    lbPrefix          : TLabel;
    lbStopBits        : TLabel;
    spePortNum        : TSpinEdit;
    spTotalConst      : TSpinEdit;
    spTotalMulti      : TSpinEdit;
    spIntervalTimeout : TSpinEdit;

    procedure btOkClick(Sender : TObject);
   private
    FChennalName   : String;
    FChennalObj    : TChennelBase;
    FChennelList   : TStrings;
    FDevArray      : PDeviceArray;
    FIsChennalEdit : Boolean;
    FLogger        : IDLogger;
    procedure SetChennalObj(const AValue : TChennelBase);
    procedure SetIsChennalEdit(const AValue : Boolean);
   public
    property ChennelList   : TStrings read FChennelList write FChennelList;
    property DevArray      : PDeviceArray read FDevArray write FDevArray;
    property Logger        : IDLogger read FLogger write FLogger;
    property IsChennalEdit : Boolean read FIsChennalEdit write SetIsChennalEdit;
    property ChennalObj    : TChennelBase read FChennalObj write SetChennalObj;
    property ChennalName   : String read FChennalName write FChennalName;
  end;

implementation

uses ChennelRSClasses,
     COMPortParamTypes,
     ModbusEmuResStr;

{$R *.lfm}

{ TfrmChennelRSAddWin }

procedure TfrmChennelRSAddWin.btOkClick(Sender : TObject);
var TempChen : TChennelRS;
    OldName  : String;
begin
  if not FIsChennalEdit then
    begin
     TempChen := TChennelRS.Create;
     TempChen.Logger      := FLogger;
     TempChen.DeviceArray := FDevArray;

     TempChen.PortPrefix := pptWindows;
    end
   else
    begin
     TempChen := TChennelRS(FChennalObj);
     OldName  := TempChen.Name;
    end;

  TempChen.PortNum    := spePortNum.Value;
  TempChen.BaudRate   := TComPortBaudRate(cmbBaudRate.ItemIndex);
  TempChen.ByteSize   := TComPortDataBits(cmbByteSize.ItemIndex);
  TempChen.Parity     := TComPortParity(cmbParitet.ItemIndex);
  TempChen.StopBits   := TComPortStopBits(cmbStopBits.ItemIndex);
  TempChen.Name       := edChennalName.Text;
  TempChen.PackRuptureTime   := spIntervalTimeout.Value;
  TempChen.TimeoutMultiplier := spTotalMulti.Value;
  TempChen.TimeoutConst      := spTotalConst.Value;

  if not FIsChennalEdit then
    begin
     Tag := FChennelList.AddObject(TempChen.Name,TempChen);
     FLogger.info(rsAddChennel, Format(rsAddChennel1,[edChennalName.Text]));
    end
  else
   begin
    FChennalName := edChennalName.Text;
    FLogger.info(rsEditChennel1, Format(rsEditChennel3,[OldName]));
    Caption      := rsAddChennel4;
    btOk.Caption := rsAddChennel3;
   end;
end;

procedure TfrmChennelRSAddWin.SetChennalObj(const AValue : TChennelBase);
begin
  if FChennalObj = AValue then Exit;
  FChennalObj := AValue;

  edChennalName.Text    := FChennalObj.Name;
  spePortNum.Value      := TChennelRS(FChennalObj).PortNum;
  cmbBaudRate.ItemIndex := Integer(TChennelRS(FChennalObj).BaudRate);
  cmbByteSize.ItemIndex := Integer(TChennelRS(FChennalObj).ByteSize);
  cmbParitet.ItemIndex  := Integer(TChennelRS(FChennalObj).Parity);
  cmbStopBits.ItemIndex := Integer(TChennelRS(FChennalObj).StopBits);
  spIntervalTimeout.Value := TChennelRS(FChennalObj).PackRuptureTime;
  spTotalMulti.Value      := TChennelRS(FChennalObj).TimeoutMultiplier;
  spTotalConst.Value      := TChennelRS(FChennalObj).TimeoutConst;
end;

procedure TfrmChennelRSAddWin.SetIsChennalEdit(const AValue : Boolean);
begin
  if FIsChennalEdit = AValue then Exit;
  FIsChennalEdit := AValue;

  if FIsChennalEdit then
   begin
    Caption      := rsEditChennel4;
    btOk.Caption := rsEditChennel2;
   end
  else
   begin
    Caption      := rsAddChennel4;
    btOk.Caption := rsAddChennel3;
   end;
end;

end.

