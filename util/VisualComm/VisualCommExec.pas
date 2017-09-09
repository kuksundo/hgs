unit VisualCommExec;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SerialCommLogic, UtilUnit, StartButton, SerialComPort, FAMemMan_pjh,
  FANumEdit, FAGauges, FANumLabel;

type
  TFrmDoc = class(TpjhLogicPanel)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    function LoadFromFile(AFileName: string): integer;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateDocument(AOwner: TComponent; AFileName: string);
  end;

var
  FrmDoc: TFrmDoc;

implementation

{$R *.dfm}

constructor TFrmDoc.Create(AOwner: TComponent);
begin
  inherited;

end;

constructor TFrmDoc.CreateDocument(AOwner: TComponent; AFileName: string);
begin
  Create(AOwner);
  LoadFromFile(AFileNAme);
  //FFileName := AFileNAme;
  Caption := ExtractFileName(AFileName);
end;

procedure TFrmDoc.FormCreate(Sender: TObject);
begin
  //ReadDFM(TForm(Self), '.\FileReceive.lfm');
end;

function TFrmDoc.LoadFromFile(AFileName: string): integer;
begin
  Result := ReadDFM(TForm(Self), AFileName);
end;

procedure TFrmDoc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmDoc.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  With VertScrollbar do
    Position := Position - WheelDelta;
end;

procedure TFrmDoc.FormDestroy(Sender: TObject);
begin
;
end;

procedure TFrmDoc.FormActivate(Sender: TObject);
begin
;
end;

initialization
  ForceCurrentDirectory := True;
  
  RegisterClasses(
            [ TpjhLogicPanel,   TpjhProcess,      TpjhProcess2,
              TpjhIfControl ,   TpjhGotoControl,  TpjhStartControl,
              TpjhStopControl,  TpjhStartButton,  TPjhComLed, TpjhWriteComport,
              TpjhReadComport, TpjhDelay, TpjhWriteFile, TpjhFAMemMan ,TFAGauge,
              TFANumberEdit, TFANumLabel, TpjhWriteFAMem, TpjhIFTimer, TpjhSetTimer
             ]);

end.
