unit frmSDIDocBplUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, pjhLogicPanelUnitNoBpl, frmDocInterface, pjhOIInterface;

type
  TfrmSDIDoc = class(TpjhLogicPanel, IbplDocInterface)
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
    FObjectInspector: TForm; //Loadpackage시에 이 변수에 할당해 줘야 함
    FMainForm: TForm;

    constructor Create(AOwner: TComponent); override;
    constructor CreateDocument(AOwner: TComponent; AFileName: string);

    //for IbplDocInterface
    function ICreateDocument(AOwner: TComponent; AFileName: string): TForm;
    function IGetDocument: TForm;

    function GetMainForm: TForm;
    procedure SetMainForm(const Value: TForm);
    function GetFileName: String;
    procedure SetFileName(AValue: String);
    function GetFormCaption: String;
    procedure SetFormCaption(AValue: String);
    function GetModified: Boolean;
    procedure SetModified(AValue: Boolean);
    function GetIsDesignMode: Boolean;
    procedure SetIsDesignMode(AValue: Boolean);
    function GetOIForm: TForm;
    procedure SetOIForm(AValue: TForm);

    procedure Save;
    function SaveAs(AFileName: string): Boolean;
    procedure Modify;

    property MainForm: TForm read GetMainForm write SetMainForm;
    property FileName: string read GetFileName write SetFileName;
    property Modified: Boolean read GetModified write SetModified;
    property FormCaption: string read GetFormCaption write SetFormCaption;
    property IsDesignMode: Boolean read GetIsDesignMode write SetIsDesignMode;
    property OIForm: TForm read GetOIForm write SetOIForm; //Create Document 시에 이 변수에 할당해 줘야 함
  end;

var
  //frmSDIDoc: TfrmSDIDoc;
  FormWasClosed: Boolean;

implementation

{$R *.dfm}

uses frmMainInterface, frmConst, UtilUnit;

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
var
  IbOII : IbplOIInterface;
begin
  if FObjectInspector <> nil then
    if Supports(FObjectInspector, IbplOIInterface, IbOII) then
      IbOII.Doc := TForm(Self);
  //frmMain.AdjustChangeSelection;
end;

procedure TfrmSDIDoc.FormClose(Sender: TObject; var Action: TCloseAction);
var
  IbOII : IbplOIInterface;
  IbMFI : IbplMainInterface;
  label Again;
begin
  Action := caFree;

  if Modified then
    case MessageDlg('Save document "' + Caption + '"?', mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        if FileName <> '' then
        begin
          if not SaveAs(FileName) then
          begin
            Action := caNone;
          end;
        end
        else
        begin
Again:
          if Assigned(MainForm) then
          begin
            if Supports(MainForm, IbplMainInterface, IbMFI) then
            begin
              if IbMFI.SaveDialog.Execute then
              begin
                if FileExists(IbMFI.SaveDialog.FileName) then
                begin
                  case MessageDlg('File is already exist. Are you overwrite?',
                                      mtConfirmation, [mbYes, mbNo], 0) of
                    mrYes: begin
                      FileName := IbMFI.SaveDialog.FileName;
                      Save;
                    end;
                    mrNo: Goto Again;
                    mrCancel: exit;
                  end;
                end
                else
                begin
                  FileName := IbMFI.SaveDialog.FileName;
                  Save;
                end;
              end;
            end;
          end;
        end;
      mrNo: {Do nothind};
      mrCancel: Action := caNone;
    end;

  FormWasClosed := Action = caFree;

  if FObjectInspector <> nil then
    if Supports(FObjectInspector, IbplOIInterface, IbOII) then
      IbOII.ClearObjOfCombo();
end;

procedure TfrmSDIDoc.FormCreate(Sender: TObject);
begin
  FISDesignMode := True;
end;

procedure TfrmSDIDoc.FormDestroy(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  DestroyComponents;

  if FObjectInspector <> nil then
    if Supports(FObjectInspector, IbplOIInterface, IbOII) then
      if IbOII.Doc = TForm(Self) then IbOII.Doc := nil;
end;

procedure TfrmSDIDoc.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  With VertScrollbar do
    Position := Position - WheelDelta;
end;

procedure TfrmSDIDoc.FormShow(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  if FObjectInspector <> nil then
    if Supports(FObjectInspector, IbplOIInterface, IbOII) then
      IbOII.Doc := TForm(Self);
  //frmMain.AdjustChangeSelection;
end;

function TfrmSDIDoc.GetFileName: String;
begin
  Result := FFileName;
end;

function TfrmSDIDoc.GetFormCaption: String;
begin
  Result := Caption;
end;

function TfrmSDIDoc.GetIsDesignMode: Boolean;
begin
  Result := FIsDesignMode;
end;

function TfrmSDIDoc.GetMainForm: TForm;
begin
  Result := FMainForm;
end;

function TfrmSDIDoc.GetModified: Boolean;
begin
  Result := FModified;
end;

function TfrmSDIDoc.GetOIForm: TForm;
begin

end;

function TfrmSDIDoc.ICreateDocument(AOwner: TComponent;
  AFileName: string): TForm;
begin
  Result := CreateDocument(AOwner, AFileName);
end;

function TfrmSDIDoc.IGetDocument: TForm;
begin
  Result := Self;
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

function TfrmSDIDoc.SaveAs(AFileName: string): Boolean;
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

procedure TfrmSDIDoc.SetFileName(AValue: String);
begin

end;

procedure TfrmSDIDoc.SetFormCaption(AValue: String);
begin

end;

procedure TfrmSDIDoc.SetIsDesignMode(AValue: Boolean);
begin

end;

procedure TfrmSDIDoc.SetMainForm(const Value: TForm);
begin
  FMainForm := Value;
end;

procedure TfrmSDIDoc.SetModified(AValue: Boolean);
begin

end;

procedure TfrmSDIDoc.SetOIForm(AValue: TForm);
begin

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
