unit frmSDIDocUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, pjhLogicPanelUnitNoBpl;

type
  TfrmSDIDoc = class(TpjhLogicPanel)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FFileName: string;
    FModified: Boolean;
    FISDesignMode: Boolean;

    function LoadFromFile(AFileName: string): integer;
    procedure SaveToFile(AFileName: string);
    procedure WriteDFM(Form:TForm;FormName:string);
  public
    { Public declarations }
    //FpjhLogicPanel: TpjhLogicPanel;
    //CreateDocument 함수를 이용하여 폼을 생성하면 true(TpjhLogicPanel 을 자동 생성하기 위함)
    //FIsCreateDocument: Bool;

    constructor Create(AOwner: TComponent); override;
    constructor CreateDocument(AOwner: TComponent; AFileName: string);
    procedure Save;
    procedure SaveAs(AFileName: string);
    procedure Modify;
    property FileName: string read FFileName;
    property Modified: Boolean read FModified;
    property IsDesignMode: Boolean read FIsDesignMode write FIsDesignMode;
  end;

var
  //frmSDIDoc: TfrmSDIDoc;
  FormWasClosed: Boolean;

implementation

{$R *.dfm}

uses frmMainUnit, pjhObjectInspector, frmConst, UtilUnit;

{ TfrmSDIDoc }

constructor TfrmSDIDoc.Create(AOwner: TComponent);
begin
  inherited;

  Caption := UniqueName(Self);
  Name := Caption;
end;

constructor TfrmSDIDoc.CreateDocument(AOwner: TComponent; AFileName: string);
begin
  Create(AOwner);
  LoadFromFile(AFileNAme);
  FFileName := AFileNAme;
  Caption := ExtractFileName(AFileName);
end;

procedure TfrmSDIDoc.FormActivate(Sender: TObject);
begin
  frmProps.Doc := TForm(Self);
  frmMain.AdjustChangeSelection;
end;

procedure TfrmSDIDoc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if Modified then
    case MessageDlg('Save document "' + Caption + '"?', mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        if FileName <> '' then
          frmMain.Save(TForm(Self))
        else
          if not frmMain.SaveAs(TForm(Self)) then Action := caNone;
      mrNo: {Do nothind};
      mrCancel: Action := caNone;
    end;

  FormWasClosed := Action = caFree;
  frmProps.ClearObjOfCombo();
end;

procedure TfrmSDIDoc.FormCreate(Sender: TObject);
begin
  FISDesignMode := True;
end;

procedure TfrmSDIDoc.FormDestroy(Sender: TObject);
begin
  DestroyComponents;
  if frmProps.Doc = TForm(Self) then frmProps.Doc := nil;
end;

procedure TfrmSDIDoc.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  With VertScrollbar do
    Position := Position - WheelDelta;
end;

procedure TfrmSDIDoc.FormShow(Sender: TObject);
begin
  frmProps.Doc := TForm(Self);
  frmMain.AdjustChangeSelection;
end;

function TfrmSDIDoc.LoadFromFile(AFileName: string): integer;
begin
  //Result := ReadDFM(TForm(Self), AFileName);
  Result := 0;
  LoadFromDFM(AFileName, TForm(Self));
end;

procedure TfrmSDIDoc.Modify;
begin
  Repaint;
  FModified := True;
end;

procedure TfrmSDIDoc.Save;
begin
  SaveToFile(FFileName);
  FModified := False;
end;

procedure TfrmSDIDoc.SaveAs(AFileName: string);
begin
  SaveToFile(AFileName);
  FFileName := AFileName;
  Caption := ExtractFileName(AFileName);
  FModified := False;
end;

procedure TfrmSDIDoc.SaveToFile(AFileName: string);
begin
  //WriteDFM(TForm(Self), AFileName);
  SaveToDFM(AFileName, TForm(Self));
end;

procedure TfrmSDIDoc.WriteDFM(Form: TForm; FormName: string);
var
  Output: TFileStream;
  ResName:string;
  I, Po:Integer;
  Writer:TWriter;
  HeaderSize: Integer;
  Origin, ImageSize: Longint;
  Header: array[0..79] of Char;
  LI: Longint;
  LB: Byte;
begin
  ResName:= Form.ClassName;
  // ResName:= FormName;
  try
    //Form.FormStyle := fsNormal;
    if FileExists(FormName) then
      Output:= TFileStream.Create(FormName, fmOpenReadWrite)
    else
      Output:= TFileStream.Create(FormName, fmCreate);
    //LI := Longint(Signature);
    //Output.Write(LI, SizeOf(Longint));
    //LB := $03;
    //Output.Write(LB, SizeOf(Byte));
    Byte((@Header[0])^) := $FF;
    Word((@Header[1])^) := 10;
    HeaderSize := StrLen(StrUpper(StrPLCopy(@Header[3], ResName, 63))) + 10;
    Word((@Header[HeaderSize - 6])^) := $1030;
    Longint((@Header[HeaderSize - 4])^) := 0;
    Output.WriteBuffer(Header, HeaderSize);
    Po:= Output.Position;
    Writer:= TWriter.Create(Output, 4096);
    Writer.Position:= Po;
    Writer.WriteRootComponent(Form);
    // write dfm file size
    ImageSize := Writer.Position - Po;
    Writer.Position := Po - 4;
    Writer.Write(ImageSize, SizeOf(ImageSize));
    Writer.Position := Po + ImageSize;
  finally
    Writer.Free;
    Output.Free;
    //Form.FormStyle := fsMDIChild;
  end;
end;

end.
