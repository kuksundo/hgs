unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MathClass;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button7: TButton;
    GroupBox1: TGroupBox;
    Edit2: TEdit;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
    FMath : TMath;
    procedure SetDisplayValue(Value : Double);
    procedure UpdateDisplay;
    procedure SetInitalValue(Str : String);
  public
     constructor Create(AOwner : TComponent); override;
     destructor Destroy; override;
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

{ TForm3 }

procedure TForm3.Button10Click(Sender: TObject);
begin
  FMath.Multiply(StrToFloat(Edit2.Text));
  UpdateDisplay;

end;

procedure TForm3.Button11Click(Sender: TObject);
begin
  FMath.Subtract(StrToFloat(Edit2.Text));
  UpdateDisplay;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  SetInitalValue(Edit1.text);
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  FMath.DoubleIt;
  UpdateDisplay;
end;

procedure TForm3.Button7Click(Sender: TObject);
begin
  FMath.Truncate;
  UpdateDisplay;
end;

procedure TForm3.Button8Click(Sender: TObject);
begin
  FMath.Add(StrToFloat(Edit2.Text));
  UpdateDisplay;
end;

procedure TForm3.Button9Click(Sender: TObject);
begin
  FMath.Divide(StrToFloat(Edit2.Text));
  UpdateDisplay;

end;

constructor TForm3.Create(AOwner: TComponent);
begin
  inherited;
  FMath := TMath.Create;
end;

destructor TForm3.Destroy;
begin
  FMath.Free;
  inherited;
end;

procedure TForm3.SetDisplayValue(Value: Double);
begin
  Edit1.Text := FloatToStr(Value);
end;

procedure TForm3.SetInitalValue(Str: String);
begin
  FMath.Value := StrToFloat(Str);
end;

procedure TForm3.UpdateDisplay;
begin
  SetDisplayValue(FMath.Value);
end;

end.
