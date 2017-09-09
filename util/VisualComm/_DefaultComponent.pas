unit _DefaultComponent;

interface

uses PlugInBase;

type
  TpjhDefaultPlugIn = class (TBasePlugIn)
  protected
  public
    function GetPlugInName:string; override;
    // the functions below should be taken from base class and
    // overriden, so that functions would work...
    function ProcessFile(FileName:string):string; override;
  end;

  TpjhDefaultPlugIn2 = class (TBasePlugIn)
  protected
  public
    function GetPlugInName:string; override;
    function ProcessFile(FileName:string):string; override;
  end;

implementation

end.
