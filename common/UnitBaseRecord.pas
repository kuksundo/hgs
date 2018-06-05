unit UnitBaseRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot;

type
  TSQLBaseRecord = class(TSQLRecord)
  private
    fUpdateDate: TTimeLog;
  public
    fIsUpdate: Boolean;
    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
  published
    property UpdateDate: TTimeLog read fUpdateDate write fUpdateDate;
  end;

implementation

end.
