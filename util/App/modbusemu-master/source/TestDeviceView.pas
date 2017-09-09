unit TestDeviceView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, syncobjs,
  MBDeviceClasses;

type

  { TTestThread }

  TTestThread = class(TThread)
  private
    FCSection : TCriticalSection;
    FDevice : TMBDevice;
   protected
    procedure Execute; override;
   public
    property Device   : TMBDevice read FDevice write FDevice;
    property CSection : TCriticalSection read FCSection write FCSection;
  end;


  { TformTestDevView }

  TformTestDevView = class(TForm)
    btCoilWrite    : TButton;
    btDiscretWrite : TButton;
    btHoldingWrite : TButton;
    btInputWrite   : TButton;
    btThreadStart : TButton;
    btThreadStop : TButton;
    procedure btCoilWriteClick(Sender : TObject);
    procedure btDiscretWriteClick(Sender : TObject);
    procedure btHoldingWriteClick(Sender : TObject);
    procedure btInputWriteClick(Sender : TObject);
    procedure btThreadStartClick(Sender : TObject);
    procedure btThreadStopClick(Sender : TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
  private
   FCSection : TCriticalSection;
   FDevice   : TMBDevice;
   FThread   : TTestThread;
  public
   property Device   : TMBDevice read FDevice write FDevice;
   property CSection : TCriticalSection read FCSection write FCSection;
  end;

var
  formTestDevView : TformTestDevView;

implementation

{$R *.lfm}

{ TTestThread }

procedure TTestThread.Execute;
var TempVal : Integer;
begin
  TempVal := 1;
  while not Terminated do
   begin
    FCSection.Enter;
    try
     FDevice.BeginPacketUpdate;
     try
      FDevice.Holdings[1].Value := TempVal+1;
      FDevice.Holdings[3].Value := TempVal+2;
      FDevice.Holdings[5].Value := TempVal+3;
      FDevice.Holdings[7].Value := TempVal+4;
      FDevice.Holdings[9].Value := TempVal+5;
     finally
      FDevice.EndPacketUpdate;
     end;
    finally
     FCSection.Leave;
    end;
    Inc(TempVal);
    Sleep(5000);
   end;
end;

{ TformTestDevView }

procedure TformTestDevView.btCoilWriteClick(Sender : TObject);
begin
  FDevice.BeginPacketUpdate;
  try
   FDevice.Coils[1].Value := True;
   FDevice.Coils[3].Value := True;
   FDevice.Coils[5].Value := True;
   FDevice.Coils[7].Value := True;
   FDevice.Coils[9].Value := True;
  finally
   FDevice.EndPacketUpdate;
  end;
end;

procedure TformTestDevView.btDiscretWriteClick(Sender : TObject);
begin
  FDevice.BeginPacketUpdate;
  try
   FDevice.Discrets[1].ServerSideSetValue(True);
   FDevice.Discrets[3].ServerSideSetValue(True);
   FDevice.Discrets[5].ServerSideSetValue(True);
   FDevice.Discrets[7].ServerSideSetValue(True);
   FDevice.Discrets[9].ServerSideSetValue(True);
  finally
   FDevice.EndPacketUpdate;
  end;
end;

procedure TformTestDevView.btHoldingWriteClick(Sender : TObject);
begin
  FDevice.BeginPacketUpdate;
  try
   FDevice.Holdings[1].Value := 1;
   FDevice.Holdings[3].Value := 2;
   FDevice.Holdings[5].Value := 3;
   FDevice.Holdings[7].Value := 4;
   FDevice.Holdings[9].Value := 5;
  finally
   FDevice.EndPacketUpdate;
  end;
end;

procedure TformTestDevView.btInputWriteClick(Sender : TObject);
begin
  FDevice.BeginPacketUpdate;
  try
   FDevice.Inputs[1].ServerSideSetValue(1);
   FDevice.Inputs[3].ServerSideSetValue(2);
   FDevice.Inputs[5].ServerSideSetValue(3);
   FDevice.Inputs[7].ServerSideSetValue(4);
   FDevice.Inputs[9].ServerSideSetValue(5);
  finally
   FDevice.EndPacketUpdate;
  end;
end;

procedure TformTestDevView.btThreadStartClick(Sender : TObject);
begin
  FThread := TTestThread.Create(True,65535);
  FThread.Device   := FDevice;
  FThread.CSection := FCSection;
  FThread.Start;

  btThreadStart.Enabled := False;
  btThreadStop.Enabled  := True;
end;

procedure TformTestDevView.btThreadStopClick(Sender : TObject);
begin
  try
   FThread.Terminate;
   FThread.WaitFor;
   FreeAndNil(FThread);
  except
  end;

  btThreadStart.Enabled := True;
  btThreadStop.Enabled  := False;
end;

procedure TformTestDevView.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  CloseAction := caFree;
end;

end.

