unit zNPointTransform;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls;

type
  TfrmNPointTransform = class(TForm)
    btnTest1: TButton;
    lblResult: TLabel;
    memResults: TMemo;
    btnTest2: TButton;
    procedure btnTest1Click(Sender: TObject);
    procedure btnTest2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNPointTransform: TfrmNPointTransform;

implementation

{$R *.dfm}

uses sdNPointTransform, sdPoints3D;

procedure TfrmNPointTransform.btnTest1Click(Sender: TObject);
const
  apnRobotPositions: array [0..6] of TsdPoint3D = (
    (X: 8193.3988; Y: 1136.8238; Z:	2699.1753),
    (X: 8184.7431; Y: 1112.1619; Z:	2710.0897),
    (X: 8306.6878; Y: 1034.8582; Z:	2738.9910),
    (X: 8354.6938; Y: 958.2890; Z: 2768.5843),
    (X: 8461.5903; Y: 885.3489; Z: 2797.8497),
    (X: 8600.6170; Y: 770.3601; Z: 2847.7038),
    (X: 8707.0989; Y: 644.7212; Z: 2902.3416)
  );

  apnNominalPositions: array [0..6] of TsdPoint3D = (
    (X: 8192.3960; Y: 1136.2820; Z: 2698.5860),
    (X: 8184.0180; Y: 1111.7330; Z: 2709.5920),
    (X: 8305.8720; Y: 1034.7650; Z: 2738.4070),
    (X: 8354.1200; Y: 958.0580; Z: 2768.1620),
    (X: 8461.3390; Y: 885.1600; Z: 2797.3370),
    (X: 8600.1010; Y: 770.2140; Z: 2847.2500),
    (X: 8706.7410; Y: 644.4870; Z: 2902.1380)
  );

var
  trTransform: TsdMatrix3x4;
  trTransform_i: TsdMatrix3x4;
  dError: Double;

  liCounter: LongInt;
  liCounter2: LongInt;

begin
  NPointTransform(@apnRobotPositions[0], @apnNominalPositions[0], Length(apnRobotPositions), trTransform, dError, 1e-12);
  Matrix3x4Inverse(trTransform, trTransform_i);

  lblResult.Caption := FloatToStr(dError);

  memResults.Lines.Add('Robot-to-Nominal');
  for liCounter := 0 to 2 do begin
    memResults.Lines.Add(Format('  %2.6f   %2.6f   %2.6f   %8.4f', [
      trTransform[liCounter, 0],
      trTransform[liCounter, 1],
      trTransform[liCounter, 2],
      trTransform[liCounter, 3]
    ]));
  end;

  memResults.Lines.Add('Nominal-to-Robot');
  for liCounter := 0 to 2 do begin
    memResults.Lines.Add(Format('  %2.6f   %2.6f   %2.6f   %8.4f', [
      trTransform_i[liCounter, 0],
      trTransform_i[liCounter, 1],
      trTransform_i[liCounter, 2],
      trTransform_i[liCounter, 3]
    ]));
  end;
end;

procedure TfrmNPointTransform.btnTest2Click(Sender: TObject);
const
  apnRobotPositions: array [0..5] of TsdPoint3D = (
    (X: 7380.7374; Y: 1501.7335; Z: 2521.3320),
    (X: 7375.5727; Y: 1563.7793; Z: 2321.3217),
    (X: 7377.1538; Y: 1407.7738; Z: 1969.9305),
    (X: 7379.5856; Y: 1349.9106; Z: 2596.5415),
    (X: 7377.4213; Y: 1404.7823; Z: 2569.1975),
    (X: 7378.9711; Y: 1458.6530; Z: 2542.6378)
  );

  apnNominalPositions: array [0..5] of TsdPoint3D = (
    (X: 7380.9380; Y: 1501.1780; Z: 2520.5650),
    (X: 7376.1370; Y: 1563.1330; Z: 2321.3480),
    (X: 7377.3340; Y: 1406.7200; Z: 1969.3140),
    (X: 7379.4990; Y: 1348.9970; Z: 2596.1270),
    (X: 7377.2390; Y: 1403.7010; Z: 2568.3440),
    (X: 7378.9770; Y: 1457.7960; Z: 2541.5960)
  );

var
  trTransform: TsdMatrix3x4;
  trTransform_i: TsdMatrix3x4;
  dError: Double;

  liCounter: LongInt;
  liCounter2: LongInt;

begin
  {
    The only change I've made to NPointTransform(...) is to set

      cMaxIter = 100;

    We had some problems with the routine dropping out a early in another project and giving odd results

  }

  NPointTransform(@apnRobotPositions[0], @apnNominalPositions[0], Length(apnRobotPositions), trTransform, dError, 1e-12);
  Matrix3x4Inverse(trTransform, trTransform_i);

  lblResult.Caption := FloatToStr(dError);

  memResults.Lines.Add('Robot-to-Nominal');
  for liCounter := 0 to 2 do begin
    memResults.Lines.Add(Format('  %2.6f   %2.6f   %2.6f   %8.4f', [
      trTransform[liCounter, 0],
      trTransform[liCounter, 1],
      trTransform[liCounter, 2],
      trTransform[liCounter, 3]
    ]));
  end;

  memResults.Lines.Add('Nominal-to-Robot');
  for liCounter := 0 to 2 do begin
    memResults.Lines.Add(Format('  %2.6f   %2.6f   %2.6f   %8.4f', [
      trTransform_i[liCounter, 0],
      trTransform_i[liCounter, 1],
      trTransform_i[liCounter, 2],
      trTransform_i[liCounter, 3]
    ]));
  end;
end;

end.


