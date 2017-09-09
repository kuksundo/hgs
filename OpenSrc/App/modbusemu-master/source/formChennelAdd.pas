unit formChennelAdd;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
     MBDeviceClasses, LoggerItf;

type
  TformChenAdd = class(TForm)
    btAddRSChennel  : TButton;
    btAddTCPChennel : TButton;
    btCancel        : TButton;
    procedure btAddRSChennelClick(Sender : TObject);
    procedure btAddTCPChennelClick(Sender : TObject);
   private
    FChennelList : TStrings;
    FDevArray    : PDeviceArray;
    FLogger      : IDLogger;
   public
    property ChennelList : TStrings read FChennelList write FChennelList;
    property DevArray    : PDeviceArray read FDevArray write FDevArray;
    property Logger      : IDLogger read FLogger write FLogger;
  end;

var formChenAdd : TformChenAdd;

implementation

uses {$IFDEF UNIX}formChennelRSLinuxAdd{$ELSE}formChennelRSWindowsAdd{$ENDIF}, formChennelTCPAdd, ModbusEmuResStr;

{$R *.lfm}

{ TformChenAdd }

procedure TformChenAdd.btAddRSChennelClick(Sender : TObject);
var TempForm : {$IFDEF UNIX}TfrmChennelRSAdd{$ELSE}TfrmChennelRSAddWin{$ENDIF};
    TempRes  : TModalResult;
begin
  TempRes := mrCancel;
  TempForm := {$IFDEF UNIX}TfrmChennelRSAdd{$ELSE}TfrmChennelRSAddWin{$ENDIF}.Create(Self);
  try
    TempForm.Logger             := FLogger;
    TempForm.edChennalName.Text := rsDefChannelRSName;
    TempForm.ChennelList        := FChennelList;
    TempForm.DevArray           := FDevArray;

    TempForm.ShowModal;
    TempRes := TempForm.ModalResult;
    Tag := TempForm.Tag;
  finally
   FreeAndNil(TempForm);
  end;
  ModalResult := TempRes;
end;

procedure TformChenAdd.btAddTCPChennelClick(Sender : TObject);
var TempForm : TfrmChennelTCPAdd;
    TempRes  : TModalResult;
begin
  TempRes := mrCancel;
  TempForm := TfrmChennelTCPAdd.Create(Self);
  try
    TempForm.Logger := FLogger;
    TempForm.edName.Text := rsDefChannelTCPName;
    TempForm.ChennelList := FChennelList;
    TempForm.DevArray := FDevArray;
    TempForm.ShowModal;
    TempRes := TempForm.ModalResult;
    Tag := TempForm.Tag;
  finally
   FreeAndNil(TempForm);
  end;
  ModalResult := TempRes;
end;

end.

