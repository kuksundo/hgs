unit Demo1Form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniPersistent, StdCtrls, Mask, Spin;

type
  TDemoClass1 = class;

  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    edtStr: TEdit;
    speInt: TSpinEdit;
    medFloat: TMaskEdit;
    cbxEnum: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbBool: TCheckBox;
    Button1: TButton;
    Button4: TButton;
    GroupBox2: TGroupBox;
    memDisplay: TMemo;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  protected
     Demo : TDemoClass1;
     procedure LoadVisualElements;
     procedure SaveVisualElements;
     procedure LoadINIFile;
     procedure SaveINIFile;
     procedure SetupEnumComboBox;
  public
    { Public declarations }
    function IniFileName : String;
  end;

  TDemoEnum = (deOne,deTwo,deThree);

  TDemoClass1 = class(TAbstractINIPersistent)
  private
    FInt: Integer;
    FStr: String;
    FBool: Boolean;
    FEnum: TDemoEnum;
    FFloat: Double;
  published
    property Int : Integer read FInt write FInt;
    property Bool : Boolean read FBool write FBool;
    property Str : String read FStr write FStr;
    property Float : Double read FFloat write FFloat;
    property Enum : TDemoEnum read FEnum write FEnum;
  end;
var
  Form3: TForm3;

implementation
uses TypInfo;

{$R *.dfm}


procedure TForm3.Button1Click(Sender: TObject);
begin
   LoadINIFile;
   Demo.LoadFromFile(IniFileName);
   LoadVisualElements;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
 SaveINIFile;
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
   SaveVisualElements;
   Demo.SaveToFile(IniFileName);
   LoadINIFile;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
   Demo := TDemoClass1.Create;
   Demo.Name := 'Demo1';
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  Demo.Free;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
   SetupEnumComboBox;
   LoadVisualElements;
end;

function TForm3.IniFileName: String;
begin
  result := ExtractFilePath(Application.ExeName) + 'demo1.ini';
end;

procedure TForm3.LoadINIFile;
begin
  if FileExists(IniFileName) then
     memDisplay.Lines.LoadFromFile(IniFileName)
  else
     memDisplay.Lines.Clear;
end;

procedure TForm3.LoadVisualElements;
begin
  edtStr.text := Demo.Str;
  speInt.Value := Demo.Int;
  medFloat.Text := FormatFloat('###.00',Demo.Float);
// Two basic ways to do this.
// The first requires an object the second does not.
// 1.
  cbxEnum.ItemIndex := cbxEnum.Items.IndexOf(
                          GetEnumProp(Demo,'Enum'));
// 2.
  cbxEnum.ItemIndex := cbxEnum.Items.IndexOf(
                          GetEnumName(TypeInfo(TDemoEnum),Ord(Demo.Enum)));

  cbBool.Checked := Demo.Bool;

end;

procedure TForm3.SaveINIFile;
begin
   memDisplay.Lines.SaveToFile(IniFileName);
end;

procedure TForm3.SaveVisualElements;
begin
  Demo.Str := edtStr.text;
  Demo.Int := speInt.Value;
  Demo.Float := StrToFloat(medFloat.text);

// Two Basic Ways to do this
// The first requires an object the second does not.
// 1.
  SetEnumProp(Demo,'Enum',cbxEnum.Text);
// 2.
  Demo.Enum := TDemoEnum(GetEnumValue(TypeInfo(TDemoEnum),cbxEnum.text));

  Demo.Bool := cbBool.Checked;
end;

procedure TForm3.SetupEnumComboBox;
var
  EnumVal : TDemoEnum;
begin
  cbxEnum.Items.Clear;
  for Enumval := Low(TDemoEnum) to High(TDemoEnum) do
  begin
    cbxEnum.Items.Add(GetEnumName(TypeInfo(TDemoEnum),ord(EnumVal)));
  end;
end;

end.
