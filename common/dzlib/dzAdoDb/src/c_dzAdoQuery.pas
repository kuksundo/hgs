unit c_dzAdoQuery;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Db,
  ADODB;

type
  ///<summary> This TADOQuery descendant solves the problem of Queries staying open
  ///          when opened in the designer. The Active property will never be saved to
  ///          the .DFM file and therefore always be false. }
  TdzAdoQuery = class(TADOQuery)
  private
  protected
  public
    procedure Prepare;
    procedure Unprepare;
  published
    property Active stored false;
  end;

implementation

{ TdzAdoQuery }

procedure TdzAdoQuery.Prepare;
begin
  Prepared := true;
end;

procedure TdzAdoQuery.Unprepare;
begin
  Prepared := false;
end;

end.

