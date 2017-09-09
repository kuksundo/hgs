unit CodeGenMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Memo1: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    DecCheck: TCheckBox;
    Edit3: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Edit4: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label8: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses RegCodes, Encrypt, Registrations;

{$R *.DFM}

var
  FBase:  array[0..crgMaxGroup-1] of integer;
  FCodes: array[0..crgMaxGroup-1] of string[4];
  AStartCode,
  AEndCode: integer;

procedure TForm1.Button1Click(Sender: TObject);
var
  i,j,
  TempVal: integer;
  ALine: string;
  AValueN, AValue1, AValue2, AValue3: integer;
begin

  AStartCode:=StrToInt(Edit1.Text);
  AEndCode:=StrToInt(Edit2.Text);

  // Output
  Memo1.Lines.Clear;

  for i:=AStartCode to AEndCode do begin
    TempVal:=i;
    // Determine base
    for j:=0 to crgMaxGroup-1 do begin
      FBase[j] := (TempVal mod crgMaxBase);
      TempVal  := (TempVal div crgMaxBase);
    end;

    // Determine codes
    for j:=0 to crgMaxGroup-1 do
      FCodes[j]:=crgRegCodes[FBase[j], j];

    // Decrypt
    if DecCheck.Checked then
      for j:=0 to crgMaxGroup-1 do
        FCodes[j]:=DecryptStr(FCodes[j]);

    ALine:='';
    for j:=0 to crgMaxGroup-1 do begin
      ALine:=ALine+FCodes[j];
      if j < crgMaxGroup-1 then
        ALine:=ALine+Edit3.Text;
    end;

    // Final Hussle
    AValue1:=Ord(ALine[1])-Ord('0');
    AValue2:=Ord(ALine[2])-Ord('0');
    AValue3:=Ord(Aline[3])-Ord('0');
    for j:=4 to length(ALine) do begin
      case ALine[j] of
      '0'..'9': // A number
        begin
          // Formula bias footprint - how does that sound!
          AValueN:=AValue1 + 2*AValue2 + 3*AValue3 + 7;

          // Add AValueN to the new item ALine[j]
          ALine[j]:=chr((((ord(ALine[j])-ord('0')+AValueN) mod 10)+ord('0')));

          // Slide through
          AValue1:=AValue2;
          AValue2:=AValue3;
          AValue3:=ord(ALine[j])-Ord('0');
        end;
      end;//case
    end;

    // Add to output
    Memo1.Lines.Add(ALine);

  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  RegDialog.ShowModal;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  RegCode: string;
  SeqNo: integer;
begin
  // quick and dirty test
  // Check if we only have numeric input
  if NumbersOnly(Edit4.Text, RegCode)=false then begin
    Label8.Caption := 'Numbers only please';
    exit;
  end;

  // Check code length
  if length(RegCode)<> 4*crgMaxGroup then begin
    Label8.Caption := 'Incorrect no of digits';
    exit;
  end;

  // Check actual registration
  if CheckRegistrationKey(RegCode, SeqNo) <> cResultOK then begin
    Label8.Caption := 'Incorrect key';
    exit;
  end;

  // Registration succeeded
  Label8.Caption:=Format('Correct key, no. %d',[SeqNo]);

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption:=Format('RegCode generator for product %s',[crgProduct]);
end;

end.
