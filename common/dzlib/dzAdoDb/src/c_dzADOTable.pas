unit c_dzADOTable;

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
  ///<summary> This TADOTable descendant solves the problem of Queries staying open
  ///          when opened in the designer. The Active property will never be saved to
  ///          the .DFM file and therefore always be false. }
  TdzADOTable = class(TADOTable)
  private
  protected
  public
  published
    property Active stored false;
  end;

implementation

end.

