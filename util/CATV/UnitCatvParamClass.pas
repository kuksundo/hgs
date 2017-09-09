unit UnitCatvParamClass;

interface

uses classes, GpCommandLineParser;

type
  TCatvParameter = class
    FDisplayFileName,
    FDirName: string;
  public
    [CLPName('f'), CLPLongName('file'), CLPDescription('Display File Name'), CLPDefault('')]//, '<path>'
    property DisplayFileName: string read FDisplayFileName write FDisplayFileName;
    [CLPName('d'), CLPLongName('directory'), CLPDescription('Directory Name'), CLPDefault('')]
    property DirName: string read FDirName write FDirName;
  end;

implementation

end.
