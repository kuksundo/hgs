unit formChennelRSLinuxAdd;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, MBDeviceClasses, ChennelClasses,
  LoggerItf;

type

  { TfrmChennelRSAdd }

  TfrmChennelRSAdd = class(TForm)
    btCancel      : TButton;
    btOk          : TButton;
    cmbPrefix     : TComboBox;
    cmbBaudRate   : TComboBox;
    cmbByteSize   : TComboBox;
    cmbParitet    : TComboBox;
    cmbStopBits   : TComboBox;
    edChennalName : TEdit;
    edPrefixOther : TEdit;
    lbPackRuptureTime : TLabel;
    lbName        : TLabel;
    lbStopBits    : TLabel;
    lbParitet     : TLabel;
    lbByteSize    : TLabel;
    lbBaudRate    : TLabel;
    lbPortNum     : TLabel;
    lbPrefix      : TLabel;
    spePortNum    : TSpinEdit;
    spIntervalTimeout : TSpinEdit;

    procedure btOkClick(Sender : TObject);
    procedure cmbPrefixChange(Sender : TObject);
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

//var frmChennelRSAdd : TfrmChennelRSAdd;

implementation

uses ChennelRSClasses,
     COMPortParamTypes,
     ModbusEmuResStr;

{$R *.lfm}


{ TfrmChennelRSAdd }

procedure TfrmChennelRSAdd.btOkClick(Sender : TObject);
var TempChen : TChennelRS;
    OldName  : String;
begin
  if not FIsChennalEdit then
    begin
     TempChen := TChennelRS.Create;
     TempChen.Logger      := FLogger;
     TempChen.DeviceArray := FDevArray;
    end
   else
    begin
     TempChen := TChennelRS(FChennalObj);
     OldName  := TempChen.Name;
    end;

  if cmbPrefix.ItemIndex = 0 then TempChen.PortPrefix := pptLinux else TempChen.PortPrefix := pptOther;
  if TempChen.PortPrefix = pptOther then TempChen.PortPrefixOther := edPrefixOther.Text;

  TempChen.PortNum  := spePortNum.Value;
  TempChen.BaudRate := TComPortBaudRate(cmbBaudRate.ItemIndex+1);
  TempChen.ByteSize := TComPortDataBits(cmbByteSize.ItemIndex);
  TempChen.Parity   := TComPortParity(cmbParitet.ItemIndex);
  TempChen.StopBits := TComPortStopBits(cmbStopBits.ItemIndex);
  TempChen.Name     := edChennalName.Text;
  TempChen.PackRuptureTime := spIntervalTimeout.Value;

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

procedure TfrmChennelRSAdd.cmbPrefixChange(Sender : TObject);
begin
  if cmbPrefix.ItemIndex = 1 then
   begin
    edPrefixOther.ReadOnly := False;
    edPrefixOther.Text := '/dev/tty';
   end
  else
   begin
    edPrefixOther.Text := '';
    edPrefixOther.ReadOnly := True;
   end;
end;

procedure TfrmChennelRSAdd.SetChennalObj(const AValue : TChennelBase);
begin
  if FChennalObj = AValue then Exit;
  FChennalObj := AValue;

  edChennalName.Text    := FChennalObj.Name;
  if TChennelRS(FChennalObj).PortPrefix = pptLinux then cmbPrefix.ItemIndex := 0
   else
    begin;
     cmbPrefix.ItemIndex := 1;
     edPrefixOther.Text  := TChennelRS(FChennalObj).PortPrefixOther;
    end;
  spePortNum.Value      := TChennelRS(FChennalObj).PortNum;
  cmbBaudRate.ItemIndex := Integer(TChennelRS(FChennalObj).BaudRate)-1;
  cmbByteSize.ItemIndex := Integer(TChennelRS(FChennalObj).ByteSize);
  cmbParitet.ItemIndex  := Integer(TChennelRS(FChennalObj).Parity);
  cmbStopBits.ItemIndex := Integer(TChennelRS(FChennalObj).StopBits);
  spIntervalTimeout.Value := TChennelRS(FChennalObj).PackRuptureTime;
end;

procedure TfrmChennelRSAdd.SetIsChennalEdit(const AValue : Boolean);
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

