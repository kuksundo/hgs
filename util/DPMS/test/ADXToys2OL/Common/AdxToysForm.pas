unit AdxToysForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, adxAddIn;

type
  TfrmTemplate = class(TForm)
    panBottom: TPanel;
    imgToysLogo: TImage;
    lblADXToys: TLabel;
    lblBuiltOn: TLabel;
    Label1: TLabel;
    panClient: TPanel;
    bvlBottom: TBevel;
    procedure GotoURL(Sender: TObject);
  private
    { Private declarations }
    FAddIn: TadxCOMAddInModule;
  public
    { Public declarations }
    constructor CreateEx(AddInInstance: TadxCOMAddInModule; const AddInVer: string);
    property AddIn: TadxCOMAddInModule read FAddIn;
  end;

implementation

uses ShellAPI, Registry;

{$R *.dfm}

constructor TfrmTemplate.CreateEx(AddInInstance: TadxCOMAddInModule; const AddInVer: string);
begin
  inherited Create(nil);
  FAddIn := AddInInstance;
  lblBuiltOn.Caption := Format(lblBuiltOn.Caption, [axpVersion]);
  lblADXToys.Caption := Format(lblADXToys.Caption, [AddInVer]);
end;

procedure TfrmTemplate.GotoURL(Sender: TObject);
begin
  if Sender is TControl then
    if TControl(Sender).Hint <> '' then
      ShellExecute(Application.Handle , 'open' ,
        PChar(TControl(Sender).Hint), nil , nil , SW_RESTORE);
end;

end.
