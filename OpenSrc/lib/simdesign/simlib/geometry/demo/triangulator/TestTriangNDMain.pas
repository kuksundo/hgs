unit TestTriangNDMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sdTriangulateND, sdHelperND;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  V: TsdVertex;
  S: TsdSimplex;
  VL: TsdVertexList;
begin
  VL := TsdVertexList.Create;
  try
    V := TsdVertex.CreateDim(3);
    V.Coords[0] := 0; V.Coords[1] := 0; V.Coords[2] := 0;
    VL.Add(V);
    V := TsdVertex.CreateDim(3);
    V.Coords[0] := 1; V.Coords[1] := 0; V.Coords[2] := 0;
    VL.Add(V);
    V := TsdVertex.CreateDim(3);
    V.Coords[0] := 0; V.Coords[1] := 1; V.Coords[2] := 0;
    VL.Add(V);
    V := TsdVertex.CreateDim(3);
    V.Coords[0] := 0; V.Coords[1] := 0; V.Coords[2] := 1;
    VL.Add(V);
    S := TsdSimplex.CreateDim(3);
    try
      S.Vertices[0] := VL[0];
      S.Vertices[1] := VL[1];
      S.Vertices[2] := VL[2];
      S.Vertices[3] := VL[3];
      Memo1.Lines.Add(FloatToStr(S.Volume));
    finally
      S.Free;
    end;
  finally
    VL.Free;
  end;
end;

end.
