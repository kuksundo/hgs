unit MapUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DeCAL_pjh, StdCtrls;

type
  PDoublePoint = ^TDoublePoint;
  TDoublePoint = class(TObject)
    X: Double;
    Y: Double;
  end;

  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    FBoostPressMap: DMultiMap;//BoostPressPoint List(BoostPress Position + AFR)
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  LDoublePoint : TDoublePoint;
  LMep: double;
begin
  LDoublePoint := TDoublePoint.Create;
  LMep := 1.0;
  LDoublePoint.X := 1.0;
  LDoublePoint.Y := LMep;
  FBoostPressMap.putPair([LMep, LDoublePoint]);

  LDoublePoint := TDoublePoint.Create;
  LMep := 2.0;
  LDoublePoint.X := 2.0;
  LDoublePoint.Y := LMep;
  FBoostPressMap.putPair([LMep, LDoublePoint]);

  LDoublePoint := TDoublePoint.Create;
  LMep := 3.0;
  LDoublePoint.X := 3.0;
  LDoublePoint.Y := LMep;
  FBoostPressMap.putPair([LMep, LDoublePoint]);

  LDoublePoint := TDoublePoint.Create;
  LMep := 4.0;
  LDoublePoint.X := 4.0;
  LDoublePoint.Y := LMep;
  FBoostPressMap.putPair([LMep, LDoublePoint]);
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  Li: Integer;
  it: DIterator;
  pMap: TDoublePoint;
begin
  it := FBoostPressMap.locate( [1.0] );
  SetToValue(it);
  
  while not atEnd(it) do
  begin
    pMap := GetObject(it) as TDoublePoint;
    Memo1.Lines.Add(FloatToStr(pMap.X)+' : '+ FloatToStr(pMap.Y));
    Advance(it);
  end;
end;

procedure TForm3.Button3Click(Sender: TObject);
var
  LDoublePoint : TDoublePoint;
  LMep: double;
  pMap: TDoublePoint;
  it: DIterator;
begin
  LMep := 4.0;
  it := FBoostPressMap.locate([LMep]);
  pMap := GetObject(it) as TDoublePoint;
  
  if Assigned(pMap) then
  begin
    pMap.X := 4.2;
  end
  else
  begin
    LDoublePoint := TDoublePoint.Create;
    LDoublePoint.X := 4.3;
    LDoublePoint.Y := LMep;
    FBoostPressMap.putPair([LMep, LDoublePoint]);
  end;
end;

procedure TForm3.Button4Click(Sender: TObject);
var
  it: DIterator;
  pMap: TDoublePoint;
begin
  it := FBoostPressMap.locate([2.0]);
  pMap := GetObject(it) as TDoublePoint;
  if not Assigned(pMap) then
    ShowMessage('Not Assigned')
  else
    Memo1.Lines.Add(FloatToStr(pMap.X)+' : '+ FloatToStr(pMap.Y));
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ObjFree(FBoostPressMap);
  FBoostPressMap.Free;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  FBoostPressMap := DMultiMap.create;
end;

end.
