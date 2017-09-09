unit formChennelTCPAdd;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
     MBDeviceClasses, LoggerItf, ChennelClasses;

type

  { TfrmChennelTCPAdd }

  TfrmChennelTCPAdd = class(TForm)
    btOk      : TButton;
    btCancel  : TButton;
    edAddress : TEdit;
    edPort    : TEdit;
    edName    : TEdit;
    lbPort    : TLabel;
    lbAddress : TLabel;
    lbName    : TLabel;
    procedure btOkClick(Sender : TObject);
   private
    FChennalName   : String;
    FChennalObj    : TChennelBase;
    FChennelList   : TStrings;
    FDevArray      : PDeviceArray;
    FIsChennalEdit : Boolean;
    FLogger        : IDLogger;
    function  IsChannelExist : Boolean;
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

var frmChennelTCPAdd : TfrmChennelTCPAdd;

implementation

uses ChennelTCPClasses, SocketMisc,
     ModbusEmuResStr;

{$R *.lfm}

{ TfrmChennelTCPAdd }

procedure TfrmChennelTCPAdd.btOkClick(Sender : TObject);
var TempChen : TChennelTCP;
    TempAddr : Cardinal;
    TempPort : Word;
    OldName  : String;
begin
  Tag := -1;
  if (edName.Text = '') or (edAddress.Text = '') or (edPort.Text = '') then raise Exception.Create(rsFrmAddTCPChannel2);
  try
   TempAddr := GetIPFromStr(edAddress.Text);
  except
   on E : Exception do
    begin
     FLogger.debug(rsFrmAddTCPChannel1,Format(rsFrmAddTCPChannel3,[edAddress.Text]));
     raise Exception.CreateFmt(rsFrmAddTCPChannel4,[edAddress.Text]);
    end;
  end;
  try
   TempPort := StrToInt(edPort.Text);
  except
   on E : Exception do
    begin
     FLogger.debug(rsFrmAddTCPChannel1,Format(rsFrmAddTCPChannel5,[edPort.Text]));
     raise Exception.CreateFmt(rsFrmAddTCPChannel6,[edPort.Text]);
    end;
  end;
  try

   if not FIsChennalEdit then
    if IsChannelExist then raise Exception.CreateFmt(rsFrmAddTCPChannel7,[edName.Text,edAddress.Text,edPort.Text]);

   if not FIsChennalEdit then
    begin
     TempChen := TChennelTCP.Create;
     TempChen.Logger      := FLogger;
     TempChen.DeviceArray := FDevArray;
    end
   else
    begin
     TempChen := TChennelTCP(FChennalObj);
     OldName  := TempChen.Name;
    end;

   TempChen.BindAddress := edAddress.Text;
   TempChen.Port        := TempPort;
   TempChen.Name        := edName.Text;

   if not FIsChennalEdit then
    begin
     Tag := FChennelList.AddObject(edName.Text,TempChen);
     FLogger.info(rsFrmAddTCPChannel1,Format(rsFrmAddTCPChannel8,[edName.Text,edAddress.Text,TempPort]));
    end
   else
    begin
     FChennalName := edName.Text;
     FLogger.info(rsEditChennel1,Format(rsEditChennel3,[OldName]));
     Caption      := rsAddChennel2;
     btOk.Caption := rsAddChennel3;
    end;

  except
    on E : Exception do
     begin
      if not FIsChennalEdit then FLogger.error(rsFrmAddTCPChannel1,Format(rsFrmAddTCPChannel9,[E.Message]))
       else FLogger.error(rsEditChennel1,Format(rsFrmAddTCPChannel9,[E.Message]));
      Exit;
     end;
  end;

end;

function TfrmChennelTCPAdd.IsChannelExist : Boolean;
var i,Count : Integer;
    TempChen : TChennelTCP;
    TempID,NewID : String;
begin
  Result := False;
  NewID  := Format('%s:%s',[edAddress.Text,edPort.Text]);
  Count := FChennelList.Count-1;
  for i := 0 to Count do
   begin
    if FChennelList.Objects[i].ClassType <> TChennelTCP then Continue;
    TempChen := TChennelTCP(FChennelList.Objects[i]);
    TempID := Format('%s:%d',[TempChen.BindAddress,TempChen.Port]);
    if SameText(TempID,NewID) then
     begin
      Result := True;
      Break;
     end;
   end;
end;

procedure TfrmChennelTCPAdd.SetChennalObj(const AValue : TChennelBase);
begin
  if FChennalObj = AValue then Exit;
  FChennalObj := AValue;

  edName.Text    := FChennalObj.Name;
  edAddress.Text := TChennelTCP(FChennalObj).BindAddress;
  edPort.Text    := IntToStr(TChennelTCP(FChennalObj).Port);
end;

procedure TfrmChennelTCPAdd.SetIsChennalEdit(const AValue : Boolean);
begin
  if FIsChennalEdit = AValue then Exit;
  FIsChennalEdit := AValue;

  if FIsChennalEdit then
   begin
    Caption      := rsEditChennel1;
    btOk.Caption := rsEditChennel2;
   end
  else
   begin
    Caption      := rsAddChennel2;
    btOk.Caption := rsAddChennel3;
   end;
end;

end.

