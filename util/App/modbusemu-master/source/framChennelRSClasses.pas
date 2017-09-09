unit framChennelRSClasses;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls,
     ChennelClasses,ChennelRSClasses;

type

  { TframeChennelRS }

  TframeChennelRS = class(TFrame)
    btChennelClose : TButton;
    btChennelStart : TButton;
    btEdit         : TButton;
    lbStopBits     : TLabel;
    lbStopBitsName : TLabel;
    lbBits         : TLabel;
    lbByteSize     : TLabel;
    lbByteSizeName : TLabel;
    lbBaud         : TLabel;
    lbBaudName     : TLabel;
    lbParity       : TLabel;
    lbParityName   : TLabel;
    lbPort         : TLabel;
    lbPortName     : TLabel;
    lbChennelCapt  : TLabel;
    lbChennelName  : TLabel;
    procedure btChennelCloseClick(Sender : TObject);
    procedure btChennelStartClick(Sender : TObject);
   private
    FChennel : TChennelRS;
    function  GetChennel : TChennelBase;
    procedure SetChennel(AValue : TChennelBase);
    procedure ClearInfo;
   public
    procedure UpdateChenInfo;

    property Chennel : TChennelBase read GetChennel write SetChennel;
  end;

implementation

uses COMPortParamTypes,
     ModbusEmuResStr;

{$R *.lfm}

{ TframeChennelRS }

procedure TframeChennelRS.SetChennel(AValue : TChennelBase);
begin
  if FChennel = AValue then Exit;
  FChennel := TChennelRS(AValue);
  if Assigned(FChennel) then UpdateChenInfo
   else ClearInfo;
end;

procedure TframeChennelRS.btChennelStartClick(Sender : TObject);
begin
  FChennel.Active := True;

  if FChennel.Active then FChennel.Logger.info(rsOpenChennel2,Format(rsOpenChennel3,[FChennel.Name]))
   else
    begin
     FChennel.Logger.info(rsOpenChennel2,Format(rsOpenChennel4,[FChennel.Name]));
     Exit;
    end;

  btChennelStart.Enabled := False;
  btChennelClose.Enabled := True;
end;

procedure TframeChennelRS.btChennelCloseClick(Sender : TObject);
begin
  FChennel.Active := False;

  if FChennel.Active then
   begin
    FChennel.Logger.info(rsCloseChennel2,Format(rsCloseChennel3,[FChennel.Name]));
    Exit;
   end
  else FChennel.Logger.info(rsCloseChennel2,Format(rsCloseChennel4,[FChennel.Name]));

  btChennelStart.Enabled := True;
  btChennelClose.Enabled := False;
end;

function TframeChennelRS.GetChennel : TChennelBase;
begin
  Result := TChennelBase(FChennel);
end;

procedure TframeChennelRS.UpdateChenInfo;
begin
  btChennelStart.Visible := True;
  btChennelClose.Visible := True;

  lbChennelName.Caption := FChennel.Name;
  case FChennel.PortPrefix of
   pptLinux   : begin
                 lbPort.Caption := Format('%s%d',[cCOMPrefixPathLinux,FChennel.PortNum]);
                end;
   pptWindows : begin
                 lbPort.Caption := Format('%s%d',[cCOMPrefixPathWindows,FChennel.PortNum]);
                end;
   pptOther   : begin
                 lbPort.Caption := Format('%s%d',[FChennel.PortPrefixOther,FChennel.PortNum]);
                end;
  end;
  lbBaud.Caption     := ComPortBaudRateNames[FChennel.BaudRate];
  lbParity.Caption   := ComPortParityEngNames[FChennel.Parity];
  lbByteSize.Caption := ComPortDataBitsNames[FChennel.ByteSize];
  lbStopBits.Caption := ComPortStopBitsNames[FChennel.StopBits];
  if FChennel.Active then
   begin
    btChennelStart.Enabled := False;
    btChennelClose.Enabled := True;
   end
  else
   begin
    btChennelStart.Enabled := True;
    btChennelClose.Enabled := False;
   end;
end;

procedure TframeChennelRS.ClearInfo;
begin
  lbChennelName.Caption  := '';
  lbPort.Caption         := '';
  lbBaud.Caption         := '';
  lbParity.Caption       := '';
  lbByteSize.Caption     := '';
  lbStopBits.Caption     := '';
  btChennelStart.Visible := False;
  btChennelClose.Visible := False;
end;

end.

