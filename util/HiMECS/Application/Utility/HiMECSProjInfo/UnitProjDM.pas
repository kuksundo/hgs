unit UnitProjDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, MemDS, DBAccess, Ora,
  OraTransaction, OraCall, NxGrid, VesselBaseClass;

type
  TDM1 = class(TDataModule)
    OraSession1: TOraSession;
    OraTransaction1: TOraTransaction;
    OraQuery1: TOraQuery;
    OraQuery2: TOraQuery;
  private
    { Private declarations }
  public
    procedure GetProjInfoFromODAC(AGrid: TNextGrid; AShipNo: string); overload;
    procedure GetProjInfoFromODAC(AClass: TVesselInfo; AShipNo: string); overload;
  end;

var
  DM1: TDM1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM1 }

procedure TDM1.GetProjInfoFromODAC(AGrid: TNextGrid; AShipNo: string);
var
  i,j: integer;
begin
  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from EBOM.SVW_TKCBA001 where ' +
            'SHIPNO = :shipno ' // --호선번호
    );
    ParamByName('shipno').AsString := AShipNo;
    Open;

    if RecordCount > 0 then
    begin
      AGrid.BeginUpdate;
      try
        for i := 0 to RecordCount - 1 do
        begin
          j := AGrid.AddRow();
          AGrid.CellsByName['ShipNo', j] := FieldByName('SHIPNO').AsString;
          AGrid.CellsByName['ProjNo', j] := FieldByName('PROJNO').AsString;
          AGrid.CellsByName['RevNo', j] := FieldByName('REVNO').AsString;
          AGrid.CellsByName['ProjName', j] := FieldByName('WKNAME').AsString;
          AGrid.CellsByName['ShipOwner', j] := FieldByName('OOWNER').AsString;
          AGrid.CellsByName['ShipClass', j] := FieldByName('GDSC').AsString;
          AGrid.CellsByName['DeliveryDate', j] := FieldByName('DELDATE').AsString;
          AGrid.CellsByName['EngType', j] := FieldByName('JPTYPE').AsString;
          AGrid.CellsByName['MCR', j] := FieldByName('MCR').AsString;
          AGrid.CellsByName['EngCount', j] := FieldByName('QTY').AsString;
          AGrid.CellsByName['RPM', j] := FieldByName('RPM').AsString;
          AGrid.CellsByName['EngUse', j] := FieldByName('ENG_USE').AsString;

          Next;
        end;
      finally
        AGrid.EndUpdate;
      end;
//      Result := FieldByName('COLM2').AsString;
    end;
  end;
end;

procedure TDM1.GetProjInfoFromODAC(AClass: TVesselInfo; AShipNo: string);
var
  i,j: integer;
  LProjectInfoItem: TProjectInfoItem;
  LEngUse: string;
begin
  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from EBOM.SVW_TKCBA001 where ' +
            'SHIPNO = :shipno ' // --호선번호
    );
    ParamByName('shipno').AsString := AShipNo;
    Open;

    if RecordCount > 0 then
    begin
      try
        for i := 0 to RecordCount - 1 do
        begin
          AClass.ShipNo := FieldByName('SHIPNO').AsString;
          LProjectInfoItem := AClass.ProjectInfoCollect.Add;
          LProjectInfoItem.ProjectNo := FieldByName('PROJNO').AsString;
          LProjectInfoItem.ProjectSeqNo := FieldByName('REVNO').AsString;
          LProjectInfoItem.ProjectName := FieldByName('WKNAME').AsString;
          AClass.ShipOwner := FieldByName('OOWNER').AsString;
          LProjectInfoItem.ClassSociety := FieldByName('GDSC').AsString;
//          LProjectInfoItem.DeliveryDate := StrToDate(FieldByName('DELDATE').AsString);
          LProjectInfoItem.EngType := FieldByName('JPTYPE').AsString;
//          LProjectInfoItem. := FieldByName('MCR').AsString;
          LEngUse := FieldByName('ENG_USE').AsString;

          if LEngUse = '보기' then
          begin
            AClass.GenEngineCount := FieldByName('QTY').AsString;
//            LProjectInfoItem.
          end
          else
          if LEngUse = '주기' then
          begin
            AClass.MainEngineCount := FieldByName('QTY').AsString;
          end;

          AGrid.CellsByName['RPM', j] := FieldByName('RPM').AsString;
          AGrid.CellsByName['EngUse', j] :=

          Next;
        end;
      finally
      end;
    end;
  end;
end;

end.
