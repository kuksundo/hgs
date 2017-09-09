unit dlgAddDatabaseU;

interface

uses
  CommonU,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  ZAbstractConnection, ZConnection;

type
  TdlgAddDatabase = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ActionList: TActionList;
    ImageList: TImageList;
    ActionOk: TAction;
    ActionCancel: TAction;
    comboDatabase: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure ActionCancelExecute(Sender: TObject);
    procedure ActionOkUpdate(Sender: TObject);
    procedure ActionOkExecute(Sender: TObject);
  private
    procedure UpdateDatabaseList(AHostname: string; APort: Integer;
      AUsername: string; APassword: string);
  public
    function Execute(AHostname: string; APort: Integer; AUsername: string;
      APassword: string; var ADatabase: string): Boolean;
  end;

implementation

{$R *.dfm}

procedure TdlgAddDatabase.ActionCancelExecute(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TdlgAddDatabase.ActionOkExecute(Sender: TObject);
begin
  Self.ModalResult := mrOk;
end;

procedure TdlgAddDatabase.ActionOkUpdate(Sender: TObject);
begin
  ActionOk.Enabled := not IsEmptyString(StringReplace(comboDatabase.Text, '*',
    '', [rfReplaceAll, rfIgnoreCase]));
end;

procedure TdlgAddDatabase.UpdateDatabaseList(AHostname: string; APort: Integer;
  AUsername: string; APassword: string);
var
  ZConnection: TZConnection;
begin
  comboDatabase.Items.Clear;
  ZConnection := TZConnection.Create(nil);
  try
    try
      ZConnection.HostName := AHostname;
      ZConnection.User := AUsername;
      ZConnection.Password := APassword;
      ZConnection.Port := APort;
      ZConnection.Protocol := 'mysql';
      ZConnection.Connect;
      ZConnection.GetCatalogNames(comboDatabase.Items);
      ZConnection.Disconnect;
    except

    end;

  finally
    FreeAndNil(ZConnection);
  end;
end;

function TdlgAddDatabase.Execute(AHostname: string; APort: Integer;
  AUsername: string; APassword: string; var ADatabase: string): Boolean;
begin
  Result := False;
  UpdateDatabaseList(AHostname, APort, AUsername, APassword);
  if Self.ShowModal = mrOk then
  begin
    ADatabase := Trim(comboDatabase.Text);
    Result := True;
  end;
end;

end.
