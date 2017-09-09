unit S7Config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask,
  JvExControls, JvComCtrls, JvExMask, JvToolEdit,
  Vcl.Samples.Spin, IniFiles;

type
  TS7ConfigF = class(TForm)
    PageControl1: TPageControl;
    Tabsheet2: TTabSheet;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    TabSheet1: TTabSheet;
    Label8: TLabel;
    FilenameEdit: TJvFilenameEdit;
    Label16: TLabel;
    SharedNameEdit: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    Protocol: TComboBox;
    MPILocal: TSpinEdit;
    MPIRemote: TSpinEdit;
    CPURack: TSpinEdit;
    CPUSlot: TSpinEdit;
    MPISpeed: TComboBox;
    Timeout: TSpinEdit;
    IPAddress: TEdit;
    Interval: TSpinEdit;
    COMPort: TEdit;
    Label6: TLabel;
    Connection: TEdit;
    Label7: TLabel;
    Description: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure ProtocolChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    IniFile: TIniFile;
  public
    procedure DelConnection(Name: String);
    procedure SetConnection(Name: String);
  end;

var
  S7ConfigF: TS7ConfigF;

implementation

uses HiMECSConst;

{$R *.dfm}

procedure TS7ConfigF.BitBtn1Click(Sender: TObject);
var
  Name: String;
begin
  Name := Connection.Text;

  If Name <> '' then
  begin
    IniFile.WriteString('Connections', Name, Description.Text);
    IniFile.WriteInteger(Name, 'Protocol', Protocol.ItemIndex);
    IniFile.WriteInteger(Name, 'CPURack', CPURack.Value);
    IniFile.WriteInteger(Name, 'CPUSlot', CPUSlot.Value);
    IniFile.WriteString(Name, 'COMPort', COMPort.Text);
    IniFile.WriteString(Name, 'IPAddress', IPAddress.Text);
    IniFile.WriteInteger(Name, 'Timeout', Timeout.Value * 1000);
    IniFile.WriteInteger(Name, 'Interval', Interval.Value);
    IniFile.WriteInteger(Name, 'MPISpeed', MPISpeed.ItemIndex);
    IniFile.WriteInteger(Name, 'MPILocal', MPILocal.Value);
    IniFile.WriteInteger(Name, 'MPIRemote', MPIRemote.Value);
    IniFile.WriteString(Name, 'Modbus Map File Name', FilenameEdit.Filename);
    IniFile.WriteString(Name, 'Shared Name', SharedNameEdit.Text);
    ModalResult:=mrOK;
  end else ModalResult:=mrCancel;
end;

procedure TS7ConfigF.DelConnection(Name: String);
begin
  If Name <> '' then
  begin
    IniFile.DeleteKey('Connections', Name);
    IniFile.EraseSection(Name);
  end;
end;

procedure TS7ConfigF.FormCreate(Sender: TObject);
begin
  IniFile:=TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
end;

procedure TS7ConfigF.FormShow(Sender: TObject);
begin
  If Connection.Enabled then Connection.SetFocus else Protocol.SetFocus;
end;

procedure TS7ConfigF.ProtocolChange(Sender: TObject);
begin
  COMPort.Enabled:=(Protocol.ItemIndex in [0,1,2,3,4,9,10]);
  IPAddress.Enabled:=(Protocol.ItemIndex in [5,6,7,8,11]);
  Timeout.Enabled:=(Protocol.ItemIndex in [5,6,7,8,9,11]);
  MPISpeed.Enabled:=(Protocol.ItemIndex in [0,1,2,3,4,7,8,11]);
  MPILocal.Enabled:=(Protocol.ItemIndex in [0,1,2,3,4,7,8,11]);
  MPIRemote.Enabled:=(Protocol.ItemIndex in [0,1,2,3,4,7,8,9,11]);
end;

procedure TS7ConfigF.SetConnection(Name: String);
begin
  Connection.Text:=Name;
  If Name = '' then
  begin
    Description.Text:='';
    CPURack.Value:=0;
    CPUSlot.Value:=2;
    COMPort.Text:='';
    IPAddress.Text:='';
    Timeout.Value:=100;
    Interval.Value:=1000;
    MPISpeed.ItemIndex:=2;
    MPILocal.Value:=1;
    MPIRemote.Value:=2;
  end
  else
  begin
    Description.Text:=IniFile.ReadString('Connections', Name, '');
    Protocol.ItemIndex:=IniFile.ReadInteger(Name, 'Protocol', 3);
    CPURack.Value:=IniFile.ReadInteger(Name, 'CPURack', 0);
    CPUSlot.Value:=IniFile.ReadInteger(Name, 'CPUSlot', 2);
    COMPort.Text:=IniFile.ReadString(Name, 'COMPort', '');
    IPAddress.Text:=IniFile.ReadString(Name, 'IPAddress', '');
    Timeout.Value:=IniFile.ReadInteger(Name, 'Timeout', 100000) div 1000;
    Interval.Value:=IniFile.ReadInteger(Name, 'Interval', 1000);
    MPISpeed.ItemIndex:=IniFile.ReadInteger(Name, 'MPISpeed', 2);
    MPILocal.Value:=IniFile.ReadInteger(Name, 'MPILocal', 1);
    MPIRemote.Value:=IniFile.ReadInteger(Name, 'MPIRemote', 2);

    FilenameEdit.Filename := IniFile.ReadString(Name, 'Modbus Map File Name', '');
    SharedNameEdit.Text := IniFile.ReadString(Name, 'Shared Name', '');
  end;
  Connection.Enabled:=(Name = '');
  ProtocolChange(Self);
end;

end.
