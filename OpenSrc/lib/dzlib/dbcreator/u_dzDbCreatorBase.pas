///<summary> interface declarations for creating a database. To be implemented by
///          classes that create different database types, e.g. Access databases </summary>

unit u_dzDbCreatorBase;

interface

uses
  u_dzdbcreatorDescription;

type
  IdzColumnCreator = interface ['{718FABAE-276E-4B97-8D14-5D75D18E7F5F}']
    function GetDefaultValue: OleVariant;
    procedure SetDefaultValue(_DefaultValue: OleVariant);
    function GetName: string;
    function GetDataType: TFieldDataType;
    function GetSize: integer;
    function GetAutoInc: boolean;
    procedure SetAutoInc(_AutoInc: boolean);
  end;

  IdzReferenceCreator = interface ['{E20C1C92-4BEB-438C-A502-788C0DF996A4}']
  end;

  IdzIndexCreator = interface ['{51D35A50-6543-4457-A675-639B1DD24C6C}']

  end;

  IdzTableCreator = interface ['{9588C014-C483-431B-8100-42CB4F5EAC9A}']
    function GetName: string;
    function AppendColumn(const _Name: string; _Type: TFieldDataType; _Size: integer;
      _AllowNull: TNullAllowed = naNotNull; const _Description: string = ''): IdzColumnCreator;
    function AppendReference(_ReferenceTable: IdzTableCreator; _ReferencED, _ReferencING: IdzColumnCreator): IdzReferenceCreator;
    function AppendIndex(_Column: IdzColumnCreator; _Unique: TIndexType = itUnique;
      _SortOrder: TSortOrder = soAscending): IdzIndexCreator;
    function SetPrimaryKey(_Column: IdzColumnCreator;
      _SortOrder: TSortOrder = soAscending): IdzIndexCreator;
  end;

type
  IdzDbCreator = interface ['{A49B8113-9911-4BDC-A87E-4C137FEFFE7B}']
    procedure WriteDbDesc(const _DbDescription: IdzDbDescription; const _Version: IdzDbVersionNTypeAncestor; _CreateOnlyNewObjectTables: Boolean);
  end;

implementation

end.

