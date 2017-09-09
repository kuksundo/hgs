unit framChennelTCPClasses;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls,
  ChennelClasses,ChennelTCPClasses;

type

  { TframeChennelTCP }

  TframeChennelTCP = class(TFrame)
   btChennelStart   : TButton;
   btChennelClose   : TButton;
   btEdit           : TButton;
   lbPort           : TLabel;
   lbChennelPort    : TLabel;
   lbAddress        : TLabel;
   lbChennelAddress : TLabel;
   lbChennelName    : TLabel;
   lbChennelCapt    : TLabel;
   procedure btChennelCloseClick(Sender : TObject);
   procedure btChennelStartClick(Sender : TObject);
  private
    FChennel : TChennelTCP;
    function  GetChennel : TChennelBase;
    procedure SetChennel(AValue : TChennelBase);
    procedure ClearInfo;
  public
    procedure UpdateChenInfo;

    property Chennel : TChennelBase read GetChennel write SetChennel;
  end;

implementation

//uses LoggerLazarusGtkApplication;

{$R *.lfm}

{ TframeChennelTCP }

procedure TframeChennelTCP.SetChennel(AValue : TChennelBase);
begin
  if FChennel = AValue then Exit;
  FChennel := TChennelTCP(AValue);
  if Assigned(FChennel) then UpdateChenInfo
   else ClearInfo;
end;

procedure TframeChennelTCP.btChennelStartClick(Sender : TObject);
begin
  FChennel.Active := True;
  if not FChennel.Active then Exit;
  btChennelStart.Enabled := False;
  btChennelClose.Enabled := True;
end;

procedure TframeChennelTCP.btChennelCloseClick(Sender : TObject);
begin
  FChennel.Active := False;
  if FChennel.Active then Exit;
  btChennelStart.Enabled := True;
  btChennelClose.Enabled := False;
end;

function TframeChennelTCP.GetChennel : TChennelBase;
begin
  Result := TChennelBase(FChennel);
end;

procedure TframeChennelTCP.UpdateChenInfo;
begin
  btChennelStart.Visible := True;
  btChennelClose.Visible := True;

  lbChennelName.Caption := FChennel.Name;
  lbAddress.Caption     := FChennel.BindAddress;
  lbPort.Caption        := IntToStr(FChennel.Port);
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

procedure TframeChennelTCP.ClearInfo;
begin
  lbChennelName.Caption := '';
  lbAddress.Caption     := '';
  lbPort.Caption        := '';

  btChennelStart.Visible := False;
  btChennelClose.Visible := False;
end;

end.

