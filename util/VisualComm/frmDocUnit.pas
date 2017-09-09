{*******************************************************}
{                                                       }
{       Report Designer                                 }
{       Extension Library example of                    }
{       TELDesigner, TELDesignPanel                     }
{                                                       }
{       (c) 2001, Balabuyev Yevgeny                     }
{       E-mail: stalcer@rambler.ru                      }
{                                                       }
{*******************************************************}

unit frmDocUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ELDsgnr, ExtCtrls, ELControls, Menus, ELUtils, StdCtrls, Buttons,
  CustomLogicNoBpl, frmDocInterface; //StartButton2,

type
  TfrmDoc = class(TCustomLogicPanel)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
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

    //for IbplDocInterface
    function ICreateDocument(AOwner: TComponent; AFileName: string): TForm;
    function IGetDocument: TForm;

    function GetFileName: String;
    procedure SetFileName(AValue: String);
    function GetModified: Boolean;
    procedure SetModified(AValue: Boolean);
    procedure Save;
    function SaveAs(AFileName: string): Boolean;
    procedure Modify;

    property FileName: string read GetFileName write SetFileName;
    property Modified: Boolean read GetModified write SetModified;
    //for IbplDocInterface
    //property FileName: string read FFileName;
    //property Modified: Boolean read FModified;
    property IsDesignMode: Boolean read FIsDesignMode write FIsDesignMode;
  end;

var
  //frmDoc: TfrmDoc;
  FormWasClosed: Boolean;

implementation

uses frmMainUnit, pjhObjectInspector, frmConst, UtilUnit;

{$R *.dfm}

{ TForm3 }

procedure TfrmDoc.FormClose(Sender: TObject; var Action: TCloseAction);
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

//  if Assigned(FpjhLogicPanel) then
//    FpjhLogicPanel.Free;
end;

procedure TfrmDoc.FormDestroy(Sender: TObject);
begin
  //ELDesigner1.SelectedControls.Clear;
  //ELDesigner1.Active := False;
  //frmMain.Designer.SelectedControls.Clear;
  //frmMain.Designer.Active := False;

  DestroyComponents;
  if frmProps.Doc = TForm(Self) then frmProps.Doc := nil;
end;

procedure TfrmDoc.FormActivate(Sender: TObject);
begin
  frmProps.Doc := TForm(Self);
  frmMain.AdjustChangeSelection;
end;

constructor TfrmDoc.CreateDocument(AOwner: TComponent; AFileName: string);
begin
  //FIsCreateDocument := True;
  Create(AOwner);
  //FIsCreateDocument := False;
  LoadFromFile(AFileNAme);
  FFileName := AFileNAme;
  Caption := ExtractFileName(AFileName);
end;

procedure TfrmDoc.Save;
begin
  SaveToFile(FFileName);
  FModified := False;
end;

function TfrmDoc.SaveAs(AFileName: string): Boolean;
begin
  SaveToFile(AFileName);
  FFileName := AFileName;
  Caption := ExtractFileName(AFileName);
  FModified := False;
end;

function TfrmDoc.LoadFromFile(AFileName: string): integer;
begin
  Result := ReadDFM(TForm(Self), AFileName);
end;

procedure TfrmDoc.SaveToFile(AFileName: string);
begin

  WriteDFM(TForm(Self), AFileName);
end;

procedure TfrmDoc.SetFileName(AValue: String);
begin
  FFileName := AValue;
end;

procedure TfrmDoc.SetModified(AValue: Boolean);
begin
  FModified := AValue;
end;

constructor TfrmDoc.Create(AOwner: TComponent);
//var
  //LLabel: TLabel;
  //LpjhLogicPanel: TpjhLogicPanel;
begin
  inherited;

//  FpjhLogicPanel := nil;

{  if not FIsCreateDocument then
  begin
    LpjhLogicPanel := TpjhLogicPanel.Create(Self);
    LpjhLogicPanel.Align := alClient;
    LpjhLogicPanel.Name := UniqueName(LpjhLogicPanel);
    LpjhLogicPanel.Parent := Self;
    LpjhLogicPanel.BevelKind := bkNone;
    LpjhLogicPanel.BorderStyle := bsNone;
  end;
}
  Caption := UniqueName(Self);
  Name := Caption;

  //LLabel := TLabel.Create(Self);
  //LLabel.Left := Self.Width + 100;
  //LLabel.Top := Self.Height + 100;
  //LLabel.Parent := Self;
end;

procedure TfrmDoc.Modify;
begin
  Repaint;
  FModified := True;
end;

procedure TfrmDoc.WriteDFM(Form: TForm; FormName: string);
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
    //HeaderSize := StrLen(StrUpper(StrPLCopy(@Header[3], ResName, 63))) + 10;
    HeaderSize := StrLen(StrPLCopy(@Header[3], ResName, 63)) + 10;
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

procedure TfrmDoc.FormCreate(Sender: TObject);
begin
  FISDesignMode := True;
end;

procedure TfrmDoc.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  With VertScrollbar do
    Position := Position - WheelDelta;
end;

function TfrmDoc.GetFileName: String;
begin
  Result := FFileName;
end;

function TfrmDoc.GetModified: Boolean;
begin
  Result := FModified;
end;

function TfrmDoc.ICreateDocument(AOwner: TComponent; AFileName: string): TForm;
begin
  //Result := CreateDocument(AOwner, AFileName);
end;

function TfrmDoc.IGetDocument: TForm;
begin
  //Result := Self;
end;

end.
