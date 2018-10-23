unit FrmSelectProductType;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGroupBox,
  AdvOfficeButtons, Vcl.ExtCtrls, Vcl.Buttons, CommonData;

type
  TSelectProductTypeF = class(TForm)
    Panel1: TPanel;
    ProductTypesGrp: TAdvOfficeCheckGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    procedure LoadProductType2CheckGrpFromCommaStr(ABusinessAreas: TBusinessAreas; ACommaStr: string);
    function GetCommaStrFromProductTypeGrp : string;
    procedure FillInProductTypesGrp(ABusinessAreas: TBusinessAreas);
  end;

function EditProductType(ABusinessAreas: TBusinessAreas; AProductList: string): string;

var
  SelectProductTypeF: TSelectProductTypeF;

implementation

uses UnitVesselData, UnitEngineMasterData;

{$R *.dfm}

function EditProductType(ABusinessAreas: TBusinessAreas; AProductList: string): string;
var
  LSelectProductTypeF: TSelectProductTypeF;
begin//AProductList: 콤마로 분리된 Product list임
  LSelectProductTypeF := TSelectProductTypeF.Create(nil);
  try
    with LSelectProductTypeF do
    begin
      LoadProductType2CheckGrpFromCommaStr(ABusinessAreas, AProductList);

      if ShowModal = mrOK then
      begin
        Result := GetCommaStrFromProductTypeGrp;
      end
      else
        Result := 'No Change';
    end;
  finally
    LSelectProductTypeF.Free;
  end;
end;

procedure TSelectProductTypeF.FillInProductTypesGrp(ABusinessAreas: TBusinessAreas);
var
  i: TElecProductDetailType;
begin
  ProductTypesGrp.Items.Clear;

  if ABusinessAreas = [] then
  begin
    ShipProductType2List(ProductTypesGrp.Items);
  end
  else
  begin
    if baShip in ABusinessAreas then
    begin
      ShipProductType2List(ProductTypesGrp.Items);
    end;

    if baEngine in ABusinessAreas then
    begin
      EngineProductType2List(ProductTypesGrp.Items);
    end;

    if baElectric in ABusinessAreas then
    begin
      for i := Succ(epdtNull) to Pred(epdtFinal) do
        ProductTypesGrp.Items.Add(R_ElecProductDetailType[i].Description);
    end;
  end;
end;

function TSelectProductTypeF.GetCommaStrFromProductTypeGrp: string;
var
  i: integer;
begin
  Result := '';

  for i := 0 to ProductTypesGrp.Items.Count - 1  do
  begin
    if ProductTypesGrp.Checked[i] then
    begin
      Result := Result + ProductTypesGrp.Items.Strings[i] + ',';
    end;
  end;

  Delete(Result, Length(Result), 1); //마지막 ',' 삭제
end;

procedure TSelectProductTypeF.LoadProductType2CheckGrpFromCommaStr(
  ABusinessAreas: TBusinessAreas; ACommaStr: string);
var
  LStrList: TStringList;
  i,j: integer;
begin
  FillInProductTypesGrp(ABusinessAreas);

  LStrList := TStringList.Create;
  try
    LStrList.CommaText := ACommaStr;

    for i := 0 to LStrList.Count - 1 do
    begin
      for j := 0 to ProductTypesGrp.Items.Count - 1  do
      begin
        if ProductTypesGrp.Items.Strings[j] = LStrList.Strings[i] then
        begin
          ProductTypesGrp.Checked[j] := True;
          break;
        end;
      end;
    end;
  finally
    LStrList.Free;
  end;
end;

end.
