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

unit frmDocBplUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ELDsgnr, ExtCtrls, ELControls, Menus, ELUtils, StdCtrls, Buttons,
  CustomLogicNoBpl, frmDocInterface, pjhOIInterface, pjhFormDesigner; //StartButton2,

type
  TfrmDoc = class(TCustomLogicPanel, IbplDocInterface)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
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
    FObjectInspector: TForm; //Create Document 시에 이 변수에 할당해 줘야 함
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
    //property IsDesignMode: Boolean read FIsDesignMode write FIsDesignMode;
    //property FileName: string read FFileName;
    //property Modified: Boolean read FModified;
  end;

var
  //frmDoc: TfrmDoc;
  FormWasClosed: Boolean;

implementation

uses frmMainInterface, frmConst, UtilUnit;

{$R *.dfm}

function CreateDocument_VisualCommForms(AOwner: TComponent; AFileName: string): TForm;
begin
  Result := TForm(TfrmDoc.CreateDocument(AOwner, AFileName));
end;

function Create_pjhDocPackage: TForm;
begin
  Result := TForm(TfrmDoc.Create(Application));
end;

procedure TfrmDoc.FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TfrmDoc.FormDestroy(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  DestroyComponents;

  if FObjectInspector <> nil then
    if Supports(FObjectInspector, IbplOIInterface, IbOII) then
      if IbOII.Doc = TForm(Self) then IbOII.Doc := nil;
end;

procedure TfrmDoc.FormActivate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  if FObjectInspector <> nil then
    if Supports(FObjectInspector, IbplOIInterface, IbOII) then
      IbOII.Doc := TForm(Self);
  //frmMain.AdjustChangeSelection;
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
  if FileName <> '' then
    SaveToFile(FFileName)
  else
  if not SaveAs(FileName) then
  FModified := False;
end;

function TfrmDoc.SaveAs(AFileName: string): Boolean;
begin
  Result := True;
  SaveToFile(AFileName);
  FFileName := AFileName;
  Caption := ExtractFileName(AFileName);
  FModified := False;
end;

function TfrmDoc.LoadFromFile(AFileName: string): integer;
begin
  //Result := ReadDFM(TForm(Self), AFileName);
  Result := LoadFromDFM(AFileName,TForm(Self));
end;

procedure TfrmDoc.SaveToFile(AFileName: string);
begin
  //WriteDFM(TForm(Self), AFileName);
  SaveToDFM(AFileName, TForm(Self));
end;

procedure TfrmDoc.SetFileName(AValue: String);
begin
  FFileName := AValue;
end;

procedure TfrmDoc.SetFormCaption(AValue: String);
begin
  Caption := AValue;
end;

procedure TfrmDoc.SetIsDesignMode(AValue: Boolean);
begin
  FIsDesignMode := AValue;
end;

procedure TfrmDoc.SetMainForm(const Value: TForm);
begin
  FMainForm := Value;
end;

procedure TfrmDoc.SetModified(AValue: Boolean);
begin
  FModified := AValue;
end;

procedure TfrmDoc.SetOIForm(AValue: TForm);
begin
  FObjectInspector := AValue;
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
  FObjectInspector := nil;
end;

procedure TfrmDoc.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  With VertScrollbar do
    Position := Position - WheelDelta;
end;

procedure TfrmDoc.FormShow(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  if FObjectInspector <> nil then
    if Supports(FObjectInspector, IbplOIInterface, IbOII) then
      IbOII.Doc := TForm(Self);
  //frmMain.AdjustChangeSelection;
end;

function TfrmDoc.GetFileName: String;
begin
  Result := FFileName;
end;

function TfrmDoc.GetFormCaption: String;
begin
  Result := Caption;
end;

function TfrmDoc.GetIsDesignMode: Boolean;
begin
  Result := FIsDesignMode;
end;

function TfrmDoc.GetMainForm: TForm;
begin
  Result := FMainForm;
end;

function TfrmDoc.GetModified: Boolean;
begin
  Result := FModified;
end;

function TfrmDoc.GetOIForm: TForm;
begin
  Result := FObjectInspector;
end;

function TfrmDoc.ICreateDocument(AOwner: TComponent; AFileName: string): TForm;
type TObjectClass = class of TfrmDoc;
begin
  Result := TfrmDoc(TObjectClass(ClassType).CreateDocument(AOwner, AFileName));
end;

function TfrmDoc.IGetDocument: TForm;
begin
  Result := Self;
end;

exports //The export name is Case Sensitive
  Create_pjhDocPackage,
  CreateDocument_VisualCommForms;

initialization
  RegisterClasses([TfrmDoc]);

finalization
  UnRegisterClasses([TfrmDoc]);

end.
