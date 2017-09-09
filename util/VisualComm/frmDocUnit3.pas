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

unit frmDocUnit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ELDsgnr, ExtCtrls, ELControls, Menus, ELUtils, StdCtrls, Buttons, ScrollPanel,
  Statmach_scroll, StartButton, SerialCommLogic;

type
  TfrmDoc2 = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
    FIsCreateDocument: Bool;

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
  //frmDoc: TfrmDoc;
  FormWasClosed: Boolean;

implementation

uses frmMainUnit, pjhObjectInspector, frmConst, UtilUnit;

{$R *.dfm}

{ TForm3 }

var
  Signature: packed array[0..3] of Char = ('P', 'A', 'R', 'K');

procedure TfrmDoc2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if Modified then
    case MessageDlg('Save document "' + Caption + '"?', mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        if FileName <> '' then
          frmMain.Save(Self)
        else
          if not frmMain.SaveAs(Self) then Action := caNone;
      mrNo: {Do nothind};
      mrCancel: Action := caNone;
    end;
  FormWasClosed := Action = caFree;
  frmProps.ClearObjOfCombo();

//  if Assigned(FpjhLogicPanel) then
//    FpjhLogicPanel.Free;
end;

procedure TfrmDoc2.FormDestroy(Sender: TObject);
begin
  //ELDesigner1.SelectedControls.Clear;
  //ELDesigner1.Active := False;
  //frmMain.Designer.SelectedControls.Clear;
  //frmMain.Designer.Active := False;
  if frmProps.Doc = Self then frmProps.Doc := nil;
end;

procedure TfrmDoc2.FormActivate(Sender: TObject);
begin
  frmProps.Doc := Self;
  frmMain.AdjustChangeSelection;
end;

constructor TfrmDoc2.CreateDocument(AOwner: TComponent; AFileName: string);
begin
  FIsCreateDocument := True;
  Create(AOwner);
  FIsCreateDocument := False;
  LoadFromFile(AFileNAme);
  FFileName := AFileNAme;
  Caption := ExtractFileName(AFileName);
end;

procedure TfrmDoc2.Save;
begin
  SaveToFile(FFileName);
  FModified := False;
end;

procedure TfrmDoc2.SaveAs(AFileName: string);
begin
  SaveToFile(AFileName);
  FFileName := AFileName;
  Caption := ExtractFileName(AFileName);
  FModified := False;
end;

function TfrmDoc2.LoadFromFile(AFileName: string): integer;
begin
  Result := ReadDFM(Self, AFileName);
end;

procedure TfrmDoc2.SaveToFile(AFileName: string);
begin
  WriteDFM(Self, AFileName);
end;

constructor TfrmDoc2.Create(AOwner: TComponent);
var LpjhLogicPanel: TpjhLogicPanel;
begin
  inherited;

//  FpjhLogicPanel := nil;

  if not FIsCreateDocument then
  begin
    LpjhLogicPanel := TpjhLogicPanel.Create(Self);
    LpjhLogicPanel.Align := alClient;
    LpjhLogicPanel.Name := UniqueName(LpjhLogicPanel);
    LpjhLogicPanel.Parent := Self;
    LpjhLogicPanel.BevelKind := bkNone;
    LpjhLogicPanel.BorderStyle := bsNone;
  end;
  Caption := UniqueName(Self);
  Name := Caption;

end;

procedure TfrmDoc2.Modify;
begin
  FModified := True;
end;

procedure TfrmDoc2.WriteDFM(Form: TForm; FormName: string);
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
  end;
end;

procedure TfrmDoc2.FormCreate(Sender: TObject);
begin
  FISDesignMode := True;
end;

end.
