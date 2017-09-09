unit u_dzDbCreatorDescription;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Contnrs,
  Variants,
  u_dzTranslator,
  u_dzVariableDescList,
  u_dzLogging;

type
  EdzDbDescription = class(Exception);
  EdzDbCyclicTableReferences = class(EdzDbDescription);
  EdzDbNoSuchColumn = class(EdzDbDescription);
  EdzDbIndexAlreadyExisting = class(EdzDbDescription);
  EdzDbScriptDoesNotExist = class(EdzDbDescription);
  EdzDbNoVariableWithThatName = class(EdzDbDescription);

type
  TIndexType = (itNoIndex, itPrimaryKey, itForeignKey, itUnique, itNotUnique);

  TNullAllowed = (naNotNull, naNull);
  TSortOrder = (soAscending, soDescending);
  TFieldDataType = (dtLongInt, dtDouble, dtText, dtMemo, dtDate, dtGUID);

const
  CHKSUM_FIELD = 'chksum';

function NullAllowedToYesNo(_NullAllowed: TNullAllowed): string;
function YesNoToNullAllowed(const _s: string): TNullAllowed;
function SortOrderToString(_SortOrder: TSortOrder): string;
function StringToSortOrder(const _s: string): TSortOrder;
function DataTypeToString(_DataType: TFieldDataType): string;
function StringToDataType(const _s: string): TFieldDataType;
function BoolToString(const _Bool: Boolean): string;
function StringToBool(const _s: string): Boolean;

type
  PIInterface = ^IInterface;

procedure SetWeak(_InterfaceField: PIInterface; const _Value: IInterface);

type
  IdzDbTableRow = interface ['{29465039-37C5-4C73-8369-81CD27B382C0}']
    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetValue(_Idx: Integer): string;
    procedure SetValue(_Idx: Integer; const _Value: string);
    property Value[_Idx: Integer]: string read GetValue write SetValue; default;
    function IsNull(_Idx: Integer): Boolean;
  end;

type
  IdzDbTableDescription = interface;

  IdzDbColumnDescription = interface ['{4315793D-F2E3-4583-AD15-6EBE2ADBDAD3}']
    function GetName: string;
    function GetDataType: TFieldDataType;
    function GetSize: Integer;
    function GetComment: string;
    function GetAllowNull: TNullAllowed;

    function GetDefaultValue: Variant;
    procedure SetDefaultValue(const _DefaultValue: Variant);

    function GetAutoInc: Boolean;
    procedure SetAutoInc(_AutoInc: Boolean);

    function GetIsForeignKey: Boolean;
    function GetForeignKeyColumn: IdzDbColumnDescription;
    function GetForeignKeyTable: IdzDbTableDescription;
    procedure SetForeignKey(const _ForeignKeyColumn: IdzDbColumnDescription;
      const _ForeignKeyTable: IdzDbTableDescription);

    procedure SetIndexType(_IndexType: TIndexType);
    function GetIsPrimaryKey: Boolean;
    function GetIsUniqueIndex: Boolean;

    function GetData: Pointer;
    procedure SetData(_Data: Pointer);

    function FormatData(_v: Variant; out _s: string): Boolean;
    function GetDefaultString(out _s: string): Boolean;

    function GetStartIdx: Integer;
    procedure AdjustStartIdx(_MaxIdx: Integer);

    property Name: string read GetName;
    property DataType: TFieldDataType read GetDataType;
    property Size: Integer read GetSize;
    property Comment: string read GetComment;
    property AllowNull: TNullAllowed read GetAllowNull;

    property DefaultValue: Variant read GetDefaultValue write SetDefaultValue;
    property AutoInc: Boolean read GetAutoInc write SetAutoInc;
    property IsForeignKey: Boolean read GetIsForeignKey;
    property ForeignKeyTable: IdzDbTableDescription read GetForeignKeyTable;
    property ForeignKeyColumn: IdzDbColumnDescription read GetForeignKeyColumn;
    property IsPrimaryKey: Boolean read GetIsPrimaryKey;
    property IsUniqueIndex: Boolean read GetIsUniqueIndex;
    property Data: Pointer read GetData write SetData;
  end;

  TdzDbColumnDescription = class(TInterfacedObject, IdzDbColumnDescription)
  private
  protected
    // required fields for all data types
    FName: string;
    FDataType: TFieldDataType;

    // required depending on DataType
    FSize: Integer;

    // optional fields with default values
    FAllowNull: TNullAllowed;
    FComment: string;
    FAutoInc: Boolean;
    FDefaultValue: OleVariant;
    FForeignKeyTable: IdzDbTableDescription;
    FForeignKeyColumn: IdzDbColumnDescription;
    FSortOrder: TSortOrder;
    FData: Pointer;
    FStartIdx: Integer;
    FIsForeignKey: Boolean;
    FIndexType: TIndexType;

    function GetName: string; virtual;
    function GetDataType: TFieldDataType; virtual;
    function GetSize: Integer; virtual;
    function GetComment: string; virtual;
    function GetAllowNull: TNullAllowed; virtual;

    function GetDefaultValue: Variant; virtual;
    procedure SetDefaultValue(const _DefaultValue: Variant); virtual;

    function GetAutoInc: Boolean; virtual;
    procedure SetAutoInc(_AutoInc: Boolean); virtual;

    function GetIsPrimaryKey: Boolean;
    function GetIsUniqueIndex: Boolean;
    procedure SetIndexType(_IndexType: TIndexType);

    function GetIsForeignKey: Boolean; virtual;
    function GetForeignKeyColumn: IdzDbColumnDescription; virtual;
    function GetForeignKeyTable: IdzDbTableDescription; virtual;
    procedure SetForeignKey(const _ForeignKeyColumn: IdzDbColumnDescription;
      const _ForeignKeyTable: IdzDbTableDescription); virtual;

    function GetData: Pointer;
    procedure SetData(_Data: Pointer);

    function GetStartIdx: Integer;
    procedure AdjustStartIdx(_MaxIdx: Integer);

    function FormatData(_v: Variant; out _s: string): Boolean;
    function GetDefaultString(out _s: string): Boolean;
  public
    constructor Create(const _Name: string; _DataType: TFieldDataType;
      _Size: Integer; const _Comment: string = '';
      _AllowNull: TNullAllowed = naNull);
    destructor Destroy; override;
  end;

  TdzColumnDescriptionClass = class of TdzDbColumnDescription;

  IdzDbIndexDescription = interface ['{4590F042-1F96-4A59-9CC6-249BEEC8A677}']
    function GetIsUniq: Boolean;
    function GetIsPrimaryKey: Boolean;
    function GetIsForeignKey: Boolean;
    procedure SetRefTable(const _RefTable: string);
    function GetRefTable: string;
    function GetIndexType: TIndexType;
    function GetColumnCount: Integer;
    function GetColumns(_Idx: Integer): IdzDbColumnDescription;
    function GetColumnsSortorder(_Idx: Integer): TSortOrder;
    procedure AlterColumnSortOrder(_ColumnName: string; _SortOrder: TSortOrder);
    procedure AppendColumn(_ColumnName: string; _SortOrder: TSortOrder = soAscending); overload;
    procedure AppendColumn(_Column: IdzDbColumnDescription; _SortOrder: TSortOrder = soAscending); overload;
    function GetName: string;
    procedure SetName(const _Name: string);

    property Name: string read GetName write SetName;
    property IsUniq: Boolean read GetIsUniq;
    property IsPrimaryKey: Boolean read GetIsPrimaryKey;
    property IsForeignKey: Boolean read GetIsForeignKey;
    property RefTable: string read GetRefTable write SetRefTable;
    property ColumnCount: Integer read GetColumnCount;
    property Column[_Idx: Integer]: IdzDbColumnDescription read GetColumns; default;
    property ColumnSortorder[_Idx: Integer]: TSortOrder read GetColumnsSortorder;
  end;

  TdzDbIndexDescription = class(TInterfacedObject, IdzDbIndexDescription)
  private
    FIsForeignKey, FIsPrimaryKey, FIsUniq: Boolean;
    FColumns: TObjectList;
    FTable: IdzDbTableDescription;
    FRefTable: string;
    FName: string;
  protected
    function GetName: string; virtual;
    procedure SetName(const _Name: string);
    function GetIsUniq: Boolean; virtual;
    function GetIsPrimaryKey: Boolean; virtual;
    function GetIsForeignKey: Boolean; virtual;
    function GetIndexType: TIndexType; virtual;
    function GetColumnCount: Integer; virtual;
    function GetColumnsSortorder(_Idx: Integer): TSortOrder;
    procedure SetRefTable(const _RefTable: string);
    function GetRefTable: string;

    function GetColumns(_Idx: Integer): IdzDbColumnDescription; virtual;
    procedure AppendColumn(_ColumnName: string; _SortOrder: TSortOrder = soAscending); overload;
    procedure AppendColumn(_Column: IdzDbColumnDescription; _SortOrder: TSortOrder = soAscending); overload;
    procedure AlterColumnSortOrder(_ColumnName: string; _SortOrder: TSortOrder); virtual;
  public
    constructor Create(const _Table: IdzDbTableDescription; const _Name: string;
      const _IsPrimaryKey, _IsUniq, _IsForeign: Boolean); overload;
    constructor Create(const _Table: IdzDbTableDescription; const _Name: string;
      _IndexType: TIndexType); overload;
    destructor Destroy; override;
  end;

  IdzDbTableDescription = interface ['{7AD81B22-3CB6-47F4-86B4-CE0B526D6E29}']
    function GetName: string;
    function GetComment: string;
    function GetColumnDescClass: TdzColumnDescriptionClass;
    procedure SetColumnDescClass(_ColumnDescClass: TdzColumnDescriptionClass);
    function GetColumns(_Idx: Integer): IdzDbColumnDescription;
    function GetIndices(_Idx: Integer): IdzDbIndexDescription;
    function GetIndiceCount: Integer;
    function GetColumnCount: Integer;
    function GetPrimaryKey: IdzDbIndexDescription;
    function GetData: Pointer;
    procedure SetData(const _Data: Pointer);

    function AppendColumn(const _Name: string; _DataType: TFieldDataType;
      _Size: Integer = 0; const _Comment: string = '';
      _AllowNull: TNullAllowed = naNull): IdzDbColumnDescription;

    ///<summary> deletes a column description but does not check for references,
    ///          USE WITH CARE!
    ///          @param(Idx is the index of the column to delete) </summary>
    procedure DeleteColumn(_Idx: Integer);

    ///<summary> sorts the columns on the following criteria:
    ///          1. primary keys
    ///          2. foreign keys, sorted alphabetically
    ///          3. other columns, sorted alphabetically
    ///          4. the chksum column, if it exists </summary>
    procedure SortColumns;

    function AppendIndex(const _Name: string; const _IsPrimaryKey, _IsUniq, _IsForeign: Boolean): IdzDbIndexDescription; overload;
    function AppendIndex(_IndexType: TIndexType): IdzDbIndexDescription; overload;
    function AppendIndex(const _Index: IdzDbIndexDescription): Integer; overload;
    procedure DeleteIndex(_Idx: Integer);
    function GenerateIndexName(_IndexType: TIndexType): string;

    function ColumnByName(const _Name: string): IdzDbColumnDescription;
    function IndexByName(const _Name: string): IdzDbIndexDescription;
    function ColumnIndex(const _Name: string): Integer;

    function GetRowCount: Integer;
    function AppendRow: IdzDbTableRow;
    function GetRows(_Idx: Integer): IdzDbTableRow;

    property RowCount: Integer read GetRowCount;
    property Rows[_Idx: Integer]: IdzDbTableRow read GetRows;

    property Name: string read GetName;
    property Comment: string read GetComment;
    property ColumnDescClass: TdzColumnDescriptionClass read GetColumnDescClass write SetColumnDescClass;
    property Columns[_Idx: Integer]: IdzDbColumnDescription read GetColumns;
    property Indices[_Idx: Integer]: IdzDbIndexDescription read GetIndices;
    property ColumnCount: Integer read GetColumnCount;
    property IndiceCount: Integer read GetIndiceCount;
    property PrimaryKey: IdzDbIndexDescription read GetPrimaryKey;
    property Data: Pointer read GetData write SetData;
  end;

type
  TdzDbTableDescription = class(TInterfacedObject, IdzDbTableDescription)
  private
    function CompareColumns(_Idx1, _Idx2: Integer): Integer;
    procedure SwapColumns(_Idx1, _Idx2: Integer);
    function UniqueKeyCount: Integer;
  protected
    FName: string;
    FComment: string;
    FColumns: TInterfaceList;
    FIndices: TInterfaceList;
    FColumnDescClass: TdzColumnDescriptionClass;
    FData: Pointer;
    FRows: TInterfaceList;
    function AppendColumn(const _Name: string; _DataType: TFieldDataType;
      _Size: Integer; const _Comment: string = '';
      _AllowNull: TNullAllowed = naNull): IdzDbColumnDescription;
    procedure DeleteColumn(_Idx: Integer);
    ///<summary> sorts the columns on the following criteria:
    ///          1. primary keys
    ///          2. foreign keys, sorted alphabetically
    ///          3. other columns, sorted alphabetically
    ///          4. the chksum column, if it exists </summary>
    procedure SortColumns;

    function GetName: string; virtual;
    function GetComment: string; virtual;
    function GetColumnDescClass: TdzColumnDescriptionClass; virtual;
    procedure SetColumnDescClass(_ColumnDescClass: TdzColumnDescriptionClass); virtual;
    function GetColumns(_Idx: Integer): IdzDbColumnDescription; virtual;
    function GetColumnCount: Integer; virtual;
    function GetPrimaryKey: IdzDbIndexDescription; virtual;
    function GetData: Pointer; virtual;
    procedure SetData(const _Data: Pointer); virtual;
    function ColumnByName(const _Name: string): IdzDbColumnDescription;
    function IndexByName(const _Name: string): IdzDbIndexDescription;
    function ColumnIndex(const _Name: string): Integer;
    function GetRowCount: Integer;
    function AppendRow: IdzDbTableRow;
    function GetRows(_Idx: Integer): IdzDbTableRow;
    function AppendIndex(const _Name: string;
      const _IsPrimaryKey, _IsUniq, _IsForeign: Boolean): IdzDbIndexDescription; overload;
    function AppendIndex(_IndexType: TIndexType): IdzDbIndexDescription; overload;
    function AppendIndex(const _Index: IdzDbIndexDescription): Integer; overload;
    procedure DeleteIndex(_Idx: Integer);
    function GetIndiceCount: Integer;
    function GetIndices(_Idx: Integer): IdzDbIndexDescription;
    function HasPrimaryKey: Boolean;
    function ForeignKeyCount: Integer;
    function GenerateIndexName(_IndexType: TIndexType): string;
  public
    constructor Create(const _Name: string; const _Comment: string = '');
    destructor Destroy; override;
  end;

  TdzTableDescriptionClass = class of TdzDbTableDescription;

  //type
  //  IdzDbUserDescription = interface ['{89051F40-4CAC-4E42-B311-4247E2C60AC3}']
  //    function GetName: string;
  //    function GetPassword: string;
  //    property Name: string read GetName;
  //    property Password: string read GetPassword;
  //  end;
  //
  //type
  //  TdzDbUserDescription = class(TInterfacedObject, IdzDbUserDescription)
  //  protected
  //    fName: string;
  //    fPassword: string;
  //    function GetName: string; virtual;
  //    function GetPassword: string; virtual;
  //  public
  //    constructor Create(const _Name, _Password: string);
  //  end;
  //
  //type
  //  TdzDbUserDescriptionClass = class of TdzDbUserDescription;

type
  TdzDbVariableDescription = class(TInterfacedObject, IdzDbVariableDescription)
  private
    FName: string;
    FValue: string;
    FDeutsch: string;
    FEnglish: string;
    FTag: string;
    FValType: string;
    FEditable: Boolean;
    FAdvanced: Boolean;
  protected
    function GetName: string;
    function GetValue: string;
    procedure SetValue(const _Value: string);
    function GetEnglish: string;
    function GetDeutsch: string;
    function GetTag: string;
    function GetValType: string;
    function GetEditable: Boolean;
    function GetAdvanced: Boolean;
  public
    constructor Create(const _Name, _Value, _Deutsch, _English, _Tag, _ValType: string;
      const _Editable, _Advanced: Boolean);
    destructor Destroy; override;
  end;

const
  SCRIPT_NAME_CREATETABLES = 'createtables';
  SCRIPT_NAME_DROPTABLES = 'droptables';
  SCRIPT_NAME_INSERTDATA = 'insertdata';

type
  IdzDbScriptDescription = interface ['{4DDB0C34-BE68-4399-AB2C-4004AF014516}']
    function GetName: string;
    procedure GetStatements(_Statements: TStringList);
    procedure AppendStatement(const _Statement: string);
    function GetEnglish: string;
    function GetDeutsch: string;
    function GetMandatory: Boolean;
    function GetActive: Boolean;
    procedure SetActive(_Active: Boolean);

    property Active: Boolean read GetActive write SetActive;
    property Mandatory: Boolean read GetMandatory;
    property Deutsch: string read GetDeutsch;
    property English: string read GetEnglish;
    property Name: string read GetName;
  end;

type
  TdzDbScriptDescription = class(TInterfacedObject, IdzDbScriptDescription)
  private
    FName: string;
    FStatements: TStringList;
    FDeutsch: string;
    FEnglish: string;
    FActive: Boolean;
    FMandatory: Boolean;
  protected
    function GetName: string;
    procedure GetStatements(_Statements: TStringList);
    procedure AppendStatement(const _Statement: string);
    function GetEnglish: string;
    function GetDeutsch: string;
    function GetActive: Boolean;
    procedure SetActive(_Active: Boolean);
    function GetMandatory: Boolean;
  public
    constructor Create(const _Name, _Deutsch, _English: string;
      const _Active, _Mandatory: Boolean);
    destructor Destroy; override;
  end;

type
  IdzDbVariableDefaultDescription = interface ['{064A8E6E-0A86-483A-8309-FD8EB5E169E9}']
    function GetName: string;
    function GetValue: string;

    property Value: string read GetValue;
    property Name: string read GetName;
  end;

type
  TdzDbVariableDefaultDescription = class(TInterfacedObject, IdzDbVariableDefaultDescription)
  private
    FName: string;
    FValue: string;
  protected
    function GetName: string;
    function GetValue: string;
  public
    constructor Create(const _Name, _Value: string);
    destructor Destroy; override;
  end;

type
  IdzDbDefaultTypeDescription = interface ['{67B80A84-9E62-4ECD-A3F2-4371EC0F68E6}']
    function AppendVariableDefault(const _Name, _Value: string): IdzDbVariableDefaultDescription;
    function GetName: string;
    function GetVariableDefaults(_Idx: Integer): IdzDbVariableDefaultDescription;
    function GetVariableDefaultsCount: Integer;
    function VariableDefaultByName(_Name: string): IdzDbVariableDefaultDescription;
    function Clone: IdzDbDefaultTypeDescription;
    property VariableDefaults[_Idx: Integer]: IdzDbVariableDefaultDescription read GetVariableDefaults;
    property VariableDefaultsCount: Integer read GetVariableDefaultsCount;
    property Name: string read GetName;
  end;

type
  TdzDbDefaultTypeDescription = class(TInterfacedObject, IdzDbDefaultTypeDescription)
  private
    FName: string;
    FVariabeDefaults: TInterfaceList;
  protected
    function AppendVariableDefault(const _Name, _Value: string): IdzDbVariableDefaultDescription;
    function GetName: string;
    function VariableDefaultByName(_Name: string): IdzDbVariableDefaultDescription;
    function GetVariableDefaults(_Idx: Integer): IdzDbVariableDefaultDescription;
    function GetVariableDefaultsCount: Integer;
    function Clone: IdzDbDefaultTypeDescription;
  public
    constructor Create(const _Name: string);
    destructor Destroy; override;
  end;

type
  IdzDbVersionNTypeAncestor = interface ['{4EE70315-5D2A-43E0-AAE6-A7E4C1769178}']
    procedure ApplyDefault(_Default: IdzDbDefaultTypeDescription);

    function AppendDefault(_Name: string): IdzDbDefaultTypeDescription;
    function AppendVariable(const _Name, _Value, _Deutsch, _English, _Tag, _ValType: string;
      const _Editable, _Advanced: Boolean): IdzDbVariableDescription;
    function AppendScript(const _Name, _Deutsch, _English: string;
      const _Active, _Mandatory: Boolean): IdzDbScriptDescription;
    function PrependScript(const _Name, _Deutsch, _English: string;
      const _Active, _Mandatory: Boolean): IdzDbScriptDescription;

    function DefaultByName(_Name: string): IdzDbDefaultTypeDescription;
    function VariableByName(_Name: string): IdzDbVariableDescription;
    function ScriptByName(_Name: string): IdzDbScriptDescription;

    function GetDefaults(_Idx: Integer): IdzDbDefaultTypeDescription;
    function GetDefaultsCount: Integer;

    function GetVariables(_Idx: Integer): IdzDbVariableDescription;
    function GetVariablesCount: Integer;

    function GetScripts(_Idx: Integer): IdzDbScriptDescription;
    function GetScriptsCount: Integer;

    function GetName: string;
    function GetEnglish: string;
    function GetDeutsch: string;
    function GetDbTypeName: string;
    function GetVersionName: string;

    property Variables[_Idx: Integer]: IdzDbVariableDescription read GetVariables;
    property VariablesCount: Integer read GetVariablesCount;

    property Scripts[_Idx: Integer]: IdzDbScriptDescription read GetScripts;
    property ScriptsCount: Integer read GetScriptsCount;

    property Defaults[_Idx: Integer]: IdzDbDefaultTypeDescription read GetDefaults;
    property DefaultsCount: Integer read GetDefaultsCount;

    property Name: string read GetName;
    property English: string read GetEnglish;
    property Deutsch: string read GetDeutsch;
    property DbTypeName: string read GetDbTypeName;
    property VersionName: string read GetVersionName;

  end;

type
  TdzDbVersionNTypeAncestor = class(TInterfacedObject, IdzDbVersionNTypeAncestor)
  private
    FDbTypeName: string;
    FEnglish: string;
    FDeutsch: string;
  protected
    FDefaultTypes: TInterfaceList;
    FVariables: TdzDbVariableDescriptionList;
    FScripts: TInterfaceList;

    procedure ApplyDefault(_Default: IdzDbDefaultTypeDescription);

    function AppendDefault(_Name: string): IdzDbDefaultTypeDescription;
    function AppendVariable(const _Name, _Value, _Deutsch, _English, _Tag, _ValType: string;
      const _Editable, _Advanced: Boolean): IdzDbVariableDescription;
    function AppendScript(const _Name, _Deutsch, _English: string;
      const _Active, _Mandatory: Boolean): IdzDbScriptDescription;

    function PrependScript(const _Name, _Deutsch, _English: string;
      const _Active, _Mandatory: Boolean): IdzDbScriptDescription;

    function DefaultByName(_Name: string): IdzDbDefaultTypeDescription;
    function VariableByName(_Name: string): IdzDbVariableDescription;
    function ScriptByName(_Name: string): IdzDbScriptDescription;

    function GetDefaults(_Idx: Integer): IdzDbDefaultTypeDescription;
    function GetDefaultsCount: Integer;

    function GetVariables(_Idx: Integer): IdzDbVariableDescription;
    function GetVariablesCount: Integer;

    function GetScripts(_Idx: Integer): IdzDbScriptDescription;
    function GetScriptsCount: Integer;

    function GetName: string;
    function GetEnglish: string;
    function GetDeutsch: string;
    function GetDbTypeName: string; virtual;
    function GetVersionName: string; virtual;
  public
    constructor Create(const _DbTypeName, _English, _Deutsch: string);
    destructor Destroy; override;
  end;

type
  IdzDbVersionDescription = interface(IdzDbVersionNTypeAncestor)['{46DBD9D8-F384-453F-823F-755094C68146}']
  end;

type
  TdzDbVersionDescription = class(TdzDbVersionNTypeAncestor, IdzDbVersionDescription)
  private
    FVersionName: string;
  protected
    function GetVersionName: string; override;
    function AppendDefault(_Name: string): IdzDbDefaultTypeDescription;
    function AppendVariable(const _Name, _Value, _Deutsch, _English, _Tag, _ValType: string;
      const _Editable, _Advanced: Boolean): IdzDbVariableDescription;
    function AppendScript(const _Name, _Deutsch, _English: string;
      const _IsDefault, _Mandatory: Boolean): IdzDbScriptDescription;
  public
    constructor Create(const _VersionName, _English, _Deutsch: string; const _Parent: IdzDbVersionNTypeAncestor);
    destructor Destroy; override;
  end;

type
  IdzDbTypeDescription = interface(IdzDbVersionNTypeAncestor)['{70DE35FC-7550-4770-81D5-8D9DA957305A}']
    function AppendVersion(const _Name, _English, _Deutsch: string): IdzDbVersionDescription;
    function GetVersions(_Idx: Integer): IdzDbVersionDescription;
    function GetVersionsCount: Integer;

    property Versions[_Idx: Integer]: IdzDbVersionDescription read GetVersions;
    property VersionsCount: Integer read GetVersionsCount;
  end;

type
  TdzDbTypeDescription = class(TdzDbVersionNTypeAncestor, IdzDbTypeDescription)
  private
    FVersions: TInterfaceList;
  protected
    function AppendVersion(const _Name, _English, _Deutsch: string): IdzDbVersionDescription;
    function GetVersions(_Idx: Integer): IdzDbVersionDescription;
    function GetVersionsCount: Integer;
  public
    constructor Create(const _Name, _English, _Deutsch: string);
    destructor Destroy; override;
  end;

type
  IdzDbDescription = interface ['{D80C6BD0-A25E-4964-A431-AD8FED0B6C92}']
    function CreateTable(const _Name: string; const _Comment: string = ''): IdzDbTableDescription;
    function AppendTable(const _Name: string; const _Comment: string = ''): IdzDbTableDescription;
    function AppendDbType(const _Name, _English, _Deutsch: string): IdzDbTypeDescription;
    //    function AppendUser(const _Name, _Password: string): IdzDbUserDescription;
    function GetTables(_Idx: Integer): IdzDbTableDescription;
    function GetTopologicalSortedTables(_Idx: Integer): IdzDbTableDescription;
    function GetTableCount: Integer;
    function GetUserCount: Integer;
    //    function GetUsers(_Idx: integer): IdzDbUserDescription;
    function GetColumnDescClass: TdzColumnDescriptionClass;
    function GetName: string;
    procedure SetName(_Name: string);
    function GetPrefix: string;
    procedure SetPrefix(_Prefix: string);
    function GetTableDescClass: TdzTableDescriptionClass;
    //    function GetUserDescClass: TdzDbUserDescriptionClass;
    procedure SetColumnDescClass(const _ColumnDescClass: TdzColumnDescriptionClass);
    procedure SetTableDescClass(const _TableDescClass: TdzTableDescriptionClass);
    //    procedure SetUserDescClass(const _UserDescClass: TdzDbUserDescriptionClass);
    function GetSqlStatements: TStrings;
    function TableByName(const _Name: string): IdzDbTableDescription;
    function DbTypeByName(const _Name: string): IdzDbTypeDescription;
    procedure SetProgramm(const _Identifier, _Name: string);
    function GetProgName: string;
    function GetProgIdentifier: string;
    function GetDbTypes(_Idx: Integer): IdzDbTypeDescription;
    function GetDbTypesCount: Integer;

    function GetHasTables: Boolean;
    function GetHasData: Boolean;
    property Name: string read GetName write SetName;
    property Prefix: string read GetPrefix write SetPrefix;
    property Tables[_Idx: Integer]: IdzDbTableDescription read GetTables;
    property TopologicalSortedTables[_Idx: Integer]: IdzDbTableDescription read GetTopologicalSortedTables;
    property TableCount: Integer read GetTableCount;
    //    property Users[_Idx: integer]: IdzDbUserDescription read GetUsers;
    property UserCount: Integer read GetUserCount;
    property TableDescClass: TdzTableDescriptionClass read GetTableDescClass write SetTableDescClass;
    property ColumnDescClass: TdzColumnDescriptionClass read GetColumnDescClass write SetColumnDescClass;
    //    property UserDescClass: TdzDbUserDescriptionClass read GetUserDescClass write SetUserDescClass;
    property SqlStatements: TStrings read GetSqlStatements;
    property ProgName: string read GetProgName;
    property ProgIdentifier: string read GetProgIdentifier;
    property DbTypes[_Idx: Integer]: IdzDbTypeDescription read GetDbTypes;
    property DbTypesCount: Integer read GetDbTypesCount;
    property HasTables: Boolean read GetHasTables;
    property HasData: Boolean read GetHasData;
  end;

type
  TdzDbDescription = class(TInterfacedObject, IdzDbDescription)
  protected
    FLogger: ILogger;
    FPrefix: string;
    FName: string;
    FConfig: string;
    FTables: TInterfaceList;
    FDbTypes: TInterfaceList;
    FUsers: TInterfaceList;
    FProgName: string;
    FProgIdentifier: string;
    FTopologicalTableOrder: array of Integer;

    FTableDescClass: TdzTableDescriptionClass;
    //    FUserDescClass: TdzDbUserDescriptionClass;
    FColumnDescClass: TdzColumnDescriptionClass;
    fSqlStatements: TStringList;

    function CreateTable(const _Name: string; const _Comment: string = ''): IdzDbTableDescription; virtual;
    function AppendTable(const _Name: string; const _Comment: string = ''): IdzDbTableDescription; virtual;
    //    function AppendUser(const _Name, _Password: string): IdzDbUserDescription; virtual;
    function AppendDbType(const _Name, _English, _Deutsch: string): IdzDbTypeDescription;
    function GetTables(_Idx: Integer): IdzDbTableDescription; virtual;
    function GetTopologicalSortedTables(_Idx: Integer): IdzDbTableDescription;
    function GetTableCount: Integer; virtual;
    function GetUserCount: Integer; virtual;
    //    function GetUsers(_Idx: integer): IdzDbUserDescription; virtual;
    function GetColumnDescClass: TdzColumnDescriptionClass; virtual;
    function GetName: string; virtual;
    procedure SetName(_Name: string);
    function GetPrefix: string; virtual;
    procedure SetPrefix(_Prefix: string);
    function GetTableDescClass: TdzTableDescriptionClass; virtual;
    //    function GetUserDescClass: TdzDbUserDescriptionClass; virtual;
    procedure SetColumnDescClass(const _ColumnDescClass: TdzColumnDescriptionClass); virtual;
    procedure SetTableDescClass(const _TableDescClass: TdzTableDescriptionClass); virtual;
    //    procedure SetUserDescClass(const _UserDescClass: TdzDbUserDescriptionClass); virtual;
    function GetSqlStatements: TStrings;
    function TableByName(const _Name: string): IdzDbTableDescription;
    function DbTypeByName(const _Name: string): IdzDbTypeDescription;
    procedure SetProgramm(const _Identifier, _Name: string);
    function GetProgName: string;
    function GetProgIdentifier: string;
    function GetDbTypes(_Idx: Integer): IdzDbTypeDescription;
    function GetDbTypesCount: Integer;
    function GetHasTables: Boolean;
    function GetHasData: Boolean;

  public
    constructor Create(const _Name, _Prefix: string; _Logger: ILogger = nil);
    destructor Destroy; override;
  end;

implementation

uses
  u_dzVariantUtils,
  u_dzQuickSort;

type
  TdzDbColNSortorder = class
  public
    FColumn: IdzDbColumnDescription;
    FSortOrder: TSortOrder;
    constructor Create(const _Column: IdzDbColumnDescription; const _SortOrder: TSortOrder);
    destructor Destroy; override;
  end;

type
  TdzTableRow = class(TInterfacedObject, IdzDbTableRow)
  private
    FStrings: array of string;
    FNull: array of Boolean;
  protected
    function GetCount: Integer;
    function GetValue(_Idx: Integer): string;
    procedure SetValue(_Idx: Integer; const _Value: string);
    function IsNull(_Idx: Integer): Boolean;
    constructor Create(_ColCount: Integer);
  end;

function NullAllowedToYesNo(_NullAllowed: TNullAllowed): string;
begin
  case _NullAllowed of
    naNotNull: Result := 'no';
    naNull: Result := 'yes';
  else
    raise EConvertError.Create(_('Invalid TNullAllowed value'));
  end;
end;

function YesNoToNullAllowed(const _s: string): TNullAllowed;
begin
  if AnsiSameText('yes', _s) then
    Result := naNull
  else if AnsiSameText('no', _s) then
    Result := naNotNull
  else
    raise EConvertError.CreateFmt(_('%s is not in ''yes''/''no'''), [_s]);
end;

function SortOrderToString(_SortOrder: TSortOrder): string;
begin
  case _SortOrder of
    soAscending: Result := 'Ascending';
    soDescending: Result := 'Descending';
  else
    raise EConvertError.Create(_('Invalid TSortOrder value'));
  end;
end;

function StringToSortOrder(const _s: string): TSortOrder;
begin
  if AnsiSameText('Ascending', _s) or (_s = '') then
    Result := soAscending
  else if AnsiSameText('Descending', _s) then
    Result := soDescending
  else
    raise EConvertError.CreateFmt(_('%s is not a valid TSortOrder name'), [_s]);
end;

function DataTypeToString(_DataType: TFieldDataType): string;
begin
  case _DataType of
    dtLongInt: Result := 'LongInt';
    dtDouble: Result := 'Double';
    dtText: Result := 'Text';
    dtMemo: Result := 'Memo';
    dtDate: Result := 'Date';
    dtGUID: Result := 'GUID';
  else
    raise EConvertError.Create(_('Invalid TFieldDataType value'));
  end;
end;

function StringToDataType(const _s: string): TFieldDataType;
begin
  if AnsiSameText(_s, 'LongInt') then
    Result := dtLongInt
  else if AnsiSameText(_s, 'Double') then
    Result := dtDouble
  else if AnsiSameText(_s, 'Text') then
    Result := dtText
  else if AnsiSameText(_s, 'Memo') then
    Result := dtMemo
  else if AnsiSameText(_s, 'Date') then
    Result := dtDate
  else if AnsiSameText(_s, 'GUID') then
    Result := dtGUID
  else
    raise EConvertError.CreateFmt(_('%s is not a valid TFieldDataType name'), [_s]);
end;

function BoolToString(const _Bool: Boolean): string;
begin
  if _Bool then
    Result := 'true'
  else
    Result := 'false'
end;

function StringToBool(const _s: string): Boolean;
begin
  if (_s = '0') or (_s = '') or AnsiSameText(_s, 'false') or AnsiSameText(_s, 'no') then
    Result := False
  else if (_s = '1') or AnsiSameText(_s, 'true') or AnsiSameText(_s, 'yes') then
    Result := True
  else
    raise EConvertError.Create(_('Invalid boolean value'));
end;

// Implementation from http://blog.synopse.info/post/2012/06/18/Circular-reference-and-zeroing-weak-pointers
// NOTE: If you use this to initialize an interface pointer, you must also use it to assign NIL
//       to it later on, otherwise bad things will happen.

procedure SetWeak(_InterfaceField: PIInterface; const _Value: IInterface);
begin
  PPointer(_InterfaceField)^ := Pointer(_Value);
end;

{ TdzDbColumnDescription }

constructor TdzDbColumnDescription.Create(const _Name: string;
  _DataType: TFieldDataType; _Size: Integer; const _Comment: string;
  _AllowNull: TNullAllowed);
begin
  inherited Create;
  FName := _Name;
  FDataType := _DataType;
  FSize := _Size;
  FAllowNull := _AllowNull;
  FComment := _Comment;
  FAutoInc := False;
  FDefaultValue := Null;
  FStartIdx := 1;
  FIsForeignKey := False;
end;

destructor TdzDbColumnDescription.Destroy;
begin
  MethodTrack(ClassName + '(' + FName + ').Destroy');

  SetWeak(@FForeignKeyTable, nil);
  SetWeak(@FForeignKeyColumn, nil);

  inherited;
end;

function TdzDbColumnDescription.GetAllowNull: TNullAllowed;
begin
  Result := FAllowNull;
end;

function TdzDbColumnDescription.GetAutoInc: Boolean;
begin
  Result := FAutoInc;
end;

function TdzDbColumnDescription.GetComment: string;
begin
  Result := FComment;
end;

function TdzDbColumnDescription.GetDataType: TFieldDataType;
begin
  Result := FDataType;
end;

function TdzDbColumnDescription.GetDefaultValue: Variant;
begin
  Result := FDefaultValue;
end;

function TdzDbColumnDescription.GetForeignKeyTable: IdzDbTableDescription;
begin
  Result := FForeignKeyTable;
end;

procedure TdzDbColumnDescription.SetForeignKey(const _ForeignKeyColumn: IdzDbColumnDescription;
  const _ForeignKeyTable: IdzDbTableDescription);
begin
  Assert(Assigned(_ForeignKeyColumn), 'ForeignKeyColumn must not be NIL');
  Assert(Assigned(_ForeignKeyTable), 'ForeignKeyTable must not be NIL');

  FIsForeignKey := True;
  SetWeak(@FForeignKeyTable, _ForeignKeyTable);
  SetWeak(@FForeignKeyColumn, _ForeignKeyColumn);

  Assert(GetDataType = FForeignKeyColumn.DataType, _('Data type of foreign key and primary key of referenced table do not match'));
end;

function TdzDbColumnDescription.GetName: string;
begin
  Result := FName;
end;

function TdzDbColumnDescription.GetSize: Integer;
begin
  Result := FSize;
end;

procedure TdzDbColumnDescription.SetAutoInc(_AutoInc: Boolean);
begin
  FAutoInc := _AutoInc;
end;

procedure TdzDbColumnDescription.SetDefaultValue(const _DefaultValue: Variant);
begin
  if not VarIsNull(_DefaultValue) and not VarIsEmpty(_DefaultValue) then
    FDefaultValue := _DefaultValue
  else
    FDefaultValue := Null;
end;

function TdzDbColumnDescription.GetData: Pointer;
begin
  Result := FData;
end;

procedure TdzDbColumnDescription.SetData(_Data: Pointer);
begin
  FData := _Data;
end;

function TdzDbColumnDescription.GetStartIdx: Integer;
begin
  Result := FStartIdx;
end;

procedure TdzDbColumnDescription.AdjustStartIdx(_MaxIdx: Integer);
begin
  if FStartIdx <= _MaxIdx then
    FStartIdx := _MaxIdx + 1;
end;

function TdzDbColumnDescription.FormatData(_v: Variant; out _s: string): Boolean;
begin
  Result := not VarIsNull(_v) or VarIsEmpty(_v);
  case FDataType of
    dtDate:
      _s := Var2DateTimeStr(_v);
    dtText:
      _s := Var2Str(_v, '');
    dtLongInt:
      _s := Var2IntStr(_v);
    dtDouble:
      _s := Var2DblStr(_v, '');
  else
    { TODO -otwm -ccheck : Ob das bei Memos so funktioniert, ist mehr als zweifelhaft. }
    _s := Var2Str(_v, '');
  end;
end;

function TdzDbColumnDescription.GetDefaultString(out _s: string): Boolean;
begin
  Result := FormatData(FDefaultValue, _s);
end;

function TdzDbColumnDescription.GetForeignKeyColumn: IdzDbColumnDescription;
begin
  Result := FForeignKeyColumn;
end;

function TdzDbColumnDescription.GetIsForeignKey: Boolean;
begin
  Result := FIsForeignKey
end;

function TdzDbColumnDescription.GetIsPrimaryKey: Boolean;
begin
  Result := (FIndexType = itPrimaryKey);
end;

function TdzDbColumnDescription.GetIsUniqueIndex: Boolean;
begin
  Result := (FIndexType = itUnique);
end;

procedure TdzDbColumnDescription.SetIndexType(_IndexType: TIndexType);
begin
  case _IndexType of
    itPrimaryKey:
      FIndexType := _IndexType;
    itUnique:
      if FIndexType in [itNoIndex, itNotUnique] then
        FIndexType := _IndexType;
    itNotUnique:
      if FIndexType = itNoIndex then
        FIndexType := _IndexType;
  end;
end;

{ TdzDbTableDescription }

constructor TdzDbTableDescription.Create(const _Name, _Comment: string);
begin
  MethodTrack(ClassName + '.Create(Name: ' + _Name + ')');
  inherited Create;
  FName := _Name;
  FComment := _Comment;
  FColumns := TInterfaceList.Create;
  FIndices := TInterfaceList.Create;
  FColumnDescClass := TdzDbColumnDescription;
  FRows := TInterfaceList.Create;
end;

destructor TdzDbTableDescription.Destroy;
begin
  MethodTrack(ClassName + '(' + FName + ').Destroy');
  FRows.Free;
  FIndices.Free;
  FColumns.Free;
  inherited;
end;

function TdzDbTableDescription.AppendColumn(const _Name: string;
  _DataType: TFieldDataType; _Size: Integer; const _Comment: string;
  _AllowNull: TNullAllowed): IdzDbColumnDescription;
begin
  Result := FColumnDescClass.Create(_Name, _DataType, _Size, _Comment, _AllowNull);
  FColumns.Add(Result);
end;

function TdzDbTableDescription.GetColumnDescClass: TdzColumnDescriptionClass;
begin
  Result := FColumnDescClass;
end;

function TdzDbTableDescription.GetComment: string;
begin
  Result := FComment;
end;

function TdzDbTableDescription.GetName: string;
begin
  Result := FName;
end;

procedure TdzDbTableDescription.SetColumnDescClass(_ColumnDescClass: TdzColumnDescriptionClass);
begin
  FColumnDescClass := _ColumnDescClass;
end;

function TdzDbTableDescription.GetColumnCount: Integer;
begin
  Result := FColumns.Count;
end;

function TdzDbTableDescription.GetColumns(_Idx: Integer): IdzDbColumnDescription;
begin
  Result := FColumns[_Idx] as IdzDbColumnDescription;
end;

function TdzDbTableDescription.ColumnByName(const _Name: string): IdzDbColumnDescription;
var
  i: Integer;
begin
  for i := 0 to FColumns.Count - 1 do begin
    Result := FColumns[i] as IdzDbColumnDescription;
    if AnsiSameText(Result.Name, _Name) then
      Exit;
  end;
  Result := nil;
end;

function TdzDbTableDescription.ColumnIndex(const _Name: string): Integer;
var
  i: Integer;
  Column: IdzDbColumnDescription;
begin
  for i := 0 to FColumns.Count - 1 do begin
    Column := FColumns[i] as IdzDbColumnDescription;
    if AnsiSameText(Column.Name, _Name) then begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure TdzDbTableDescription.DeleteColumn(_Idx: Integer);
begin
  FColumns.Delete(_Idx);
end;

function TdzDbTableDescription.GetPrimaryKey: IdzDbIndexDescription;
var
  i: Integer;
begin
  for i := 0 to GetIndiceCount - 1 do begin
    Result := GetIndices(i);
    if Result.IsPrimaryKey then
      Exit;
  end;
  Result := nil;
end;

function CompareBool(_Bool1, _Bool2: Boolean): Integer;
begin
  Result := 0;
  if _Bool1 then begin
    if not _Bool2 then
      Result := -1;
  end else if _Bool2 then
    Result := 1;
end;

function TdzDbTableDescription.CompareColumns(_Idx1, _Idx2: Integer): Integer;
var
  Col1, Col2: IdzDbColumnDescription;
begin
  Col1 := FColumns[_Idx1] as IdzDbColumnDescription;
  Col2 := FColumns[_Idx2] as IdzDbColumnDescription;

  Result := CompareBool(Col1.IsPrimaryKey, Col2.IsPrimaryKey);
  if Result <> 0 then
    Exit;

  Result := CompareBool(Col1.IsForeignKey, Col2.IsForeignKey);
  if Result <> 0 then
    Exit;

  Result := CompareBool(Col1.Name <> CHKSUM_FIELD, Col2.Name <> CHKSUM_FIELD);
  if Result <> 0 then
    Exit;

  Result := AnsiCompareText(Col1.Name, Col2.Name);
end;

procedure TdzDbTableDescription.SwapColumns(_Idx1, _Idx2: Integer);
begin
  FColumns.Exchange(_Idx1, _Idx2);
end;

procedure TdzDbTableDescription.SortColumns;
begin
  QuickSort(0, FColumns.Count - 1, Self.CompareColumns, Self.SwapColumns);
end;

function TdzDbTableDescription.GetData: Pointer;
begin
  Result := FData;
end;

procedure TdzDbTableDescription.SetData(const _Data: Pointer);
begin
  FData := _Data;
end;

function TdzDbTableDescription.AppendRow: IdzDbTableRow;
begin
  Result := TdzTableRow.Create(GetColumnCount);
  FRows.Add(Result);
end;

function TdzDbTableDescription.GetRows(_Idx: Integer): IdzDbTableRow;
begin
  Result := FRows[_Idx] as IdzDbTableRow;
end;

function TdzDbTableDescription.GetRowCount: Integer;
begin
  Result := FRows.Count;
end;

procedure TdzDbTableDescription.DeleteIndex(_Idx: Integer);
begin
  FIndices.Delete(_Idx);
end;

function TdzDbTableDescription.AppendIndex(
  const _Name: string; const _IsPrimaryKey, _IsUniq, _IsForeign: Boolean): IdzDbIndexDescription;
begin
  if _IsPrimaryKey and HasPrimaryKey then
    raise EdzDbIndexAlreadyExisting.CreateFmt(
      _('Could not append index %s. Table %s already has a primary key.'),
      [_Name, FName]);

  if Assigned(IndexByName(_Name)) then
    raise EdzDbIndexAlreadyExisting.CreateFmt(
      _('Could not append index %s. Table %s already has a index with that name.'),
      [_Name, FName]);

  Result := TdzDbIndexDescription.Create(Self, _Name, _IsPrimaryKey, _IsUniq, _IsForeign);
  FIndices.Add(Result);
end;

function TdzDbTableDescription.GenerateIndexName(_IndexType: TIndexType): string;
begin
  case _IndexType of
    itPrimaryKey:
      Result := Format('PK_%s_PRIMARY', [Self.GetName]);
    itUnique:
      Result := Format('IX_%s_UNIQUE%d', [Self.GetName, Self.UniqueKeyCount]);
    itForeignKey:
      Result := Format('FK_%s_FOREIGN_%d', [Self.GetName, Self.ForeignKeyCount]);
  else
    Result := Format('IX_%s_%d', [Self.GetName, Self.GetIndiceCount]);
  end;
end;

function TdzDbTableDescription.AppendIndex(_IndexType: TIndexType): IdzDbIndexDescription;
var
  IndexName: string;
begin
  IndexName := GenerateIndexName(_IndexType);
  Result := TdzDbIndexDescription.Create(Self, IndexName, _IndexType);
  FIndices.Add(Result);
end;

function TdzDbTableDescription.AppendIndex(const _Index: IdzDbIndexDescription): Integer;
begin
  Result := FIndices.Count;
  FIndices.Add(_Index);
end;

function TdzDbTableDescription.HasPrimaryKey: Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 0 to GetIndiceCount - 1 do
    if GetIndices(i).IsPrimaryKey then begin
      Result := True;
      Break;
    end;
end;

function TdzDbTableDescription.ForeignKeyCount: Integer;
var
  i: Integer;
begin
  Result := 0;

  for i := 0 to GetIndiceCount - 1 do
    if GetIndices(i).IsForeignKey then
      Inc(Result);
end;

function TdzDbTableDescription.UniqueKeyCount: Integer;
var
  i: Integer;
begin
  Result := 0;

  for i := 0 to GetIndiceCount - 1 do
    if GetIndices(i).IsUniq then
      Inc(Result);
end;

function TdzDbTableDescription.GetIndices(_Idx: Integer): IdzDbIndexDescription;
begin
  Result := FIndices[_Idx] as IdzDbIndexDescription;
end;

function TdzDbTableDescription.GetIndiceCount: Integer;
begin
  Result := FIndices.Count;
end;

function TdzDbTableDescription.IndexByName(const _Name: string): IdzDbIndexDescription;
var
  i: Integer;
begin
  for i := 0 to FIndices.Count - 1 do begin
    Result := GetIndices(i);
    if AnsiSameText(Result.Name, _Name) then
      Exit;
  end;
  Result := nil;
end;

//{ TdzDbUserDescription }
//
//constructor TdzDbUserDescription.Create(const _Name, _Password: string);
//begin
//  inherited Create;
//  fName := _Name;
//  fPassword := _Password;
//end;
//
//function TdzDbUserDescription.GetName: string;
//begin
//  Result := fName;
//end;
//
//function TdzDbUserDescription.GetPassword: string;
//begin
//  Result := fPassword;
//end;

{ TdzDbDescription }

constructor TdzDbDescription.Create(const _Name, _Prefix: string; _Logger: ILogger);
begin
  if not Assigned(_Logger) then
    FLogger := TNoLogging.Create
  else
    FLogger := _Logger;

  FLogger.MethodTrack(ClassName + '.Create(Name: ' + _Name + ', Prefix: ' + _Prefix + ')');
  inherited Create;

  FName := _Name;
  FPrefix := _Prefix;
  FTableDescClass := TdzDbTableDescription;
  //  fUserDescClass := TdzDbUserDescription;
  FColumnDescClass := TdzDbColumnDescription;

  fSqlStatements := TStringList.Create;
  FTables := TInterfaceList.Create;
  FUsers := TInterfaceList.Create;
  FDbTypes := TInterfaceList.Create;
end;

destructor TdzDbDescription.Destroy;
begin
  if Assigned(FLogger) then
    FLogger.MethodTrack(ClassName + '(' + FName + ').Destroy');

  FSqlStatements.Free;
  FUsers.Free;
  FTables.Free;
  FDbTypes.Free;

  inherited;
end;

function TdzDbDescription.CreateTable(const _Name, _Comment: string): IdzDbTableDescription;
begin
  Result := TdzDbTableDescription.Create(_Name, _Comment);
  Result.ColumnDescClass := FColumnDescClass;
end;

function TdzDbDescription.AppendTable(const _Name, _Comment: string): IdzDbTableDescription;
begin
  Result := CreateTable(_Name, _Comment);
  FTables.Add(Result);
end;

function TdzDbDescription.GetTableCount: Integer;
begin
  Result := FTables.Count;
end;

function TdzDbDescription.GetTables(_Idx: Integer): IdzDbTableDescription;
begin
  Result := FTables[_Idx] as IdzDbTableDescription;
end;

function TdzDbDescription.TableByName(const _Name: string): IdzDbTableDescription;
var
  i: Integer;
begin
  for i := 0 to FTables.Count - 1 do begin
    Result := FTables[i] as IdzDbTableDescription;
    if AnsiSameText(Result.Name, _Name) then
      Exit;
  end;
  Result := nil;
end;

//function TdzDbDescription.AppendUser(const _Name, _Password: string): IdzDbUserDescription;
//begin
//  Result := fUserDescClass.Create(_Name, _Password);
//  fUsers.Add(Result);
//end;

function TdzDbDescription.GetUserCount: Integer;
begin
  Result := FUsers.Count;
end;

//function TdzDbDescription.GetUsers(_Idx: integer): IezDbUserDescription;
//begin
//  Result := fUsers[_Idx] as IdzDbUserDescription;
//end;

function TdzDbDescription.GetColumnDescClass: TdzColumnDescriptionClass;
begin
  Result := FColumnDescClass;
end;

function TdzDbDescription.GetName: string;
begin
  Result := FName;
end;

procedure TdzDbDescription.SetName(_Name: string);
begin
  FName := _Name;
end;

function TdzDbDescription.GetPrefix: string;
begin
  Result := FPrefix;
end;

procedure TdzDbDescription.SetPrefix(_Prefix: string);
begin
  FPrefix := _Prefix;
end;

function TdzDbDescription.GetTableDescClass: TdzTableDescriptionClass;
begin
  Result := FTableDescClass;
end;

//function TdzDbDescription.GetUserDescClass: TdzDbUserDescriptionClass;
//begin
//  Result := fUserDescClass;
//end;

procedure TdzDbDescription.SetColumnDescClass(const _ColumnDescClass: TdzColumnDescriptionClass);
begin
  FColumnDescClass := _ColumnDescClass;
end;

procedure TdzDbDescription.SetTableDescClass(const _TableDescClass: TdzTableDescriptionClass);
begin
  FTableDescClass := _TableDescClass;
end;

//procedure TdzDbDescription.SetUserDescClass(const _UserDescClass: TdzDbUserDescriptionClass);
//begin
//  fUserDescClass := _UserDescClass;
//end;

function TdzDbDescription.GetSqlStatements: TStrings;
begin
  Result := fSqlStatements;
end;

procedure TdzDbDescription.SetProgramm(const _Identifier, _Name: string);
begin
  FProgIdentifier := _Identifier;
  FProgName := _Name;
end;

function TdzDbDescription.GetProgIdentifier: string;
begin
  Result := FProgIdentifier;
end;

function TdzDbDescription.GetProgName: string;
begin
  Result := FProgName;
end;

{ TTableRow }

constructor TdzTableRow.Create(_ColCount: Integer);
var
  i: Integer;
begin
  SetLength(FStrings, _ColCount);
  SetLength(FNull, _ColCount);
  for i := 0 to _ColCount - 1 do
    FNull[i] := True;
end;

function TdzTableRow.GetCount: Integer;
begin
  Result := Length(FStrings);
end;

function TdzTableRow.GetValue(_Idx: Integer): string;
begin
  if FNull[_Idx] then
    Result := ''
  else
    Result := FStrings[_Idx];
end;

function TdzTableRow.IsNull(_Idx: Integer): Boolean;
begin
  Result := FNull[_Idx];
end;

procedure TdzTableRow.SetValue(_Idx: Integer; const _Value: string);
begin
  FStrings[_Idx] := _Value;
  FNull[_Idx] := False;
end;

function TdzDbDescription.GetTopologicalSortedTables(_Idx: Integer): IdzDbTableDescription;

var
  TableCount: Integer;
  Child, Parent, order, Idx: Integer;
  Outdegree: array of Integer;
  Pre: array of array of Boolean;
  Table: IdzDbTableDescription;
  Index: IdzDbIndexDescription;
begin
  if 0 = _Idx then begin
    TableCount := GetTableCount;

    SetLength(FTopologicalTableOrder, TableCount);
    SetLength(Outdegree, TableCount);
    SetLength(Pre, TableCount);

    for Child := 0 to TableCount - 1 do begin
      FTopologicalTableOrder[Child] := Child;
      Outdegree[Child] := 0;
      SetLength(Pre[Child], TableCount);
      for Parent := 0 to TableCount - 1 do
        Pre[Child][Parent] := False;
    end;

      // We are interested in Child to Parent references.

    for Child := 0 to TableCount - 1 do begin
      Table := FTables[Child] as IdzDbTableDescription;
      for Idx := 0 to Table.IndiceCount - 1 do begin
        Index := Table.Indices[Idx];
        if Index.IsForeignKey then
          for Parent := 0 to TableCount - 1 do
            if (not Pre[Child][Parent]) and
              ((FTables[Parent] as IdzDbTableDescription).Name = Index.RefTable) then begin
              Inc(Outdegree[Child]);
              Pre[Child][Parent] := True;
              Break;
            end;
      end;
    end;

    // Now the following is true:
    // Pre[Child][Parent]      iff  Parent is referenced by Child
    // Outdegree[Child]         =   The amount of parents the child references
    for order := 0 to TableCount - 1 do begin
      Parent := -1;
      for Idx := 0 to TableCount - 1 do
        if 0 = Outdegree[Idx] then begin
          Parent := Idx;
          Break;
        end;

      if Parent = -1 then begin
        FLogger.Error(_('Cyclic table references detected'));
        raise EdzDbCyclicTableReferences.Create(_('Cyclic table references detected'));
      end;

      for Child := 0 to TableCount - 1 do
        if Pre[Child][Parent] then
          Dec(Outdegree[Child]);

      Outdegree[Parent] := -1;
      FTopologicalTableOrder[order] := Parent;
    end;

    FLogger.Debug('Default Order:');
    for Idx := 0 to TableCount - 1 do
      FLogger.Debug(Format('Idx %d, Name %s', [Idx, (FTables[Idx] as IdzDbTableDescription).Name]));

    FLogger.Debug('Topological Order:');
    for Idx := 0 to TableCount - 1 do
      FLogger.Debug(Format('TopologicalIdx %d, DefaultIdx %d, Name %s', [Idx, FTopologicalTableOrder[Idx], (FTables[FTopologicalTableOrder[Idx]] as IdzDbTableDescription).Name]));
  end;

  Result := FTables[FTopologicalTableOrder[_Idx]] as IdzDbTableDescription;
end;

function TdzDbDescription.GetDbTypes(_Idx: Integer): IdzDbTypeDescription;
begin
  Result := FDbTypes[_Idx] as IdzDbTypeDescription;
end;

function TdzDbDescription.GetDbTypesCount: Integer;
begin
  Result := FDbTypes.Count;
end;

function TdzDbDescription.AppendDbType(
  const _Name, _English, _Deutsch: string): IdzDbTypeDescription;
begin
  Result := TdzDbTypeDescription.Create(_Name, _English, _Deutsch);
  FDbTypes.Add(Result);
end;

function TdzDbDescription.DbTypeByName(
  const _Name: string): IdzDbTypeDescription;
var
  i: Integer;
begin
  for i := 0 to FDbTypes.Count - 1 do begin
    Result := FDbTypes[i] as IdzDbTypeDescription;
    if AnsiSameText(Result.Name, _Name) then
      Exit;
  end;
  Result := nil;
end;

function TdzDbDescription.GetHasData: Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 0 to FTables.Count - 1 do
    if GetTables(i).RowCount > 0 then begin
      Result := True;
      Break;
    end;
end;

function TdzDbDescription.GetHasTables: Boolean;
begin
  Result := FTables.Count > 0;
end;

{ TdzDbIndexDescription }

procedure TdzDbIndexDescription.AlterColumnSortOrder(_ColumnName: string; _SortOrder: TSortOrder);
var
  ci: Integer;
  wrap: TdzDbColNSortorder;
  found: Boolean;
begin
  found := False;
  for ci := 0 to FColumns.Count - 1 do begin
    wrap := TdzDbColNSortorder(FColumns[ci]);
    if _ColumnName = wrap.FColumn.Name then begin
      wrap.FSortOrder := _SortOrder;
      found := True;
      Break;
    end;
  end;
  if not found then
    raise EdzDbNoSuchColumn.CreateFmt(_('Table has no column with name "%s"'), [_ColumnName]);
end;

procedure TdzDbIndexDescription.AppendColumn(_ColumnName: string; _SortOrder: TSortOrder = soAscending);
var
  Column: IdzDbColumnDescription;
begin
  Column := FTable.ColumnByName(_ColumnName);
  if not Assigned(Column) then
    raise EdzDbNoSuchColumn.CreateFmt(_('Table has no column with name "%s"'), [_ColumnName]);
  FColumns.Add(TdzDbColNSortorder.Create(Column, _SortOrder));
end;

procedure TdzDbIndexDescription.AppendColumn(_Column: IdzDbColumnDescription; _SortOrder: TSortOrder);
begin
  Assert(Assigned(_Column), 'Column must not be NIL');

  // workaround
  // Wenn die Spalte einem Index hinzugefügt wird
  // der einen Primary Key beschreibt, dann muss
  // die Spalte ebenfalls als PrimaryKey markiert werden
  if Self.FIsPrimaryKey then
    _Column.SetIndexType(itPrimaryKey)
  else if Self.FIsForeignKey and (not _Column.IsPrimaryKey) then
    _Column.SetIndexType(itForeignKey)
  else if Self.FIsUniq and (not _Column.IsPrimaryKey) and (not _Column.IsUniqueIndex) then
    _Column.SetIndexType(itUnique);

  FColumns.Add(TdzDbColNSortorder.Create(_Column, _SortOrder));
end;

constructor TdzDbIndexDescription.Create(const _Table: IdzDbTableDescription;
  const _Name: string; const _IsPrimaryKey, _IsUniq, _IsForeign: Boolean);
begin
  MethodTrack(ClassName + '.Create(Name: ' + _Name + ')');
  inherited Create;
  FColumns := TObjectList.Create;

  SetWeak(@FTable, _Table);
  FName := _Name;

  FIsPrimaryKey := _IsPrimaryKey;
  FIsUniq := _IsUniq;
  FIsForeignKey := _IsForeign;
end;

constructor TdzDbIndexDescription.Create(const _Table: IdzDbTableDescription;
  const _Name: string; _IndexType: TIndexType);
begin
  Create(_Table, _Name, itPrimaryKey = _IndexType, itUnique = _IndexType, itForeignKey = _IndexType);
end;

destructor TdzDbIndexDescription.Destroy;
begin
  MethodTrack(ClassName + '(' + FName + ').Destroy');

  SetWeak(@FTable, nil);

  FColumns.Free;
  inherited;
end;

function TdzDbIndexDescription.GetColumnCount: Integer;
begin
  Result := FColumns.Count;
end;

function TdzDbIndexDescription.GetColumns(_Idx: Integer): IdzDbColumnDescription;
begin
  Result := (TdzDbColNSortorder(FColumns[_Idx])).FColumn;
end;

function TdzDbIndexDescription.GetColumnsSortorder(
  _Idx: Integer): TSortOrder;
begin
  Result := (TdzDbColNSortorder(FColumns[_Idx])).FSortOrder;
end;

function TdzDbIndexDescription.GetIndexType: TIndexType;
begin
  if FIsPrimaryKey then
    Result := itPrimaryKey
  else if FIsForeignKey then
    Result := itForeignKey
  else if FIsUniq then
    Result := itUnique
  else
    Result := itNotUnique;
end;

function TdzDbIndexDescription.GetIsForeignKey: Boolean;
begin
  Result := FIsForeignKey;
end;

function TdzDbIndexDescription.GetIsPrimaryKey: Boolean;
begin
  Result := FIsPrimaryKey;
end;

function TdzDbIndexDescription.GetIsUniq: Boolean;
begin
  Result := FIsUniq or FIsPrimaryKey;
end;

function TdzDbIndexDescription.GetName: string;
begin
  Result := FName;
end;

procedure TdzDbIndexDescription.SetName(const _Name: string);
begin
  FName := _Name;
end;

function TdzDbIndexDescription.GetRefTable: string;
begin
  Result := FRefTable;
end;

procedure TdzDbIndexDescription.SetRefTable(const _RefTable: string);
begin
  FRefTable := _RefTable;
end;

{ TdzDbColNSortorder }

constructor TdzDbColNSortorder.Create(const _Column: IdzDbColumnDescription;
  const _SortOrder: TSortOrder);
begin
  MethodTrack(ClassName + '.Create');
  inherited Create;
  SetWeak(@FColumn, _Column);
  FSortOrder := _SortOrder;
end;

destructor TdzDbColNSortorder.Destroy;
begin
  MethodTrack(ClassName + '.Destroy');
  SetWeak(@FColumn, nil);

  inherited;
end;

{ TdzDbVersionNTypeAncestor }

function TdzDbVersionNTypeAncestor.AppendDefault(
  _Name: string): IdzDbDefaultTypeDescription;
begin
  Result := TdzDbDefaultTypeDescription.Create(_Name);
  FDefaultTypes.Add(Result);
end;

function TdzDbVersionNTypeAncestor.AppendScript(const _Name, _Deutsch,
  _English: string; const _Active, _Mandatory: Boolean): IdzDbScriptDescription;
begin
  Result := TdzDbScriptDescription.Create(_Name, _Deutsch,
    _English, _Active, _Mandatory);
  FScripts.Add(Result);
end;

function TdzDbVersionNTypeAncestor.AppendVariable(
  const _Name, _Value, _Deutsch, _English, _Tag, _ValType: string;
  const _Editable, _Advanced: Boolean): IdzDbVariableDescription;
begin
  Result := TdzDbVariableDescription.Create(_Name, _Value, _Deutsch, _English, _Tag,
    _ValType, _Editable, _Advanced);
  FVariables.Add(Result);
  GetDefaults(0).AppendVariableDefault(_Name, _Value);
end;

procedure TdzDbVersionNTypeAncestor.ApplyDefault(_Default: IdzDbDefaultTypeDescription);

  procedure RealApplyDefault(_Default: IdzDbDefaultTypeDescription);
  var
    i: Integer;
    variable: IdzDbVariableDescription;
    vardefault: IdzDbVariableDefaultDescription;
  begin
    for i := 0 to _Default.VariableDefaultsCount - 1 do begin
      vardefault := _Default.VariableDefaults[i];
      variable := VariableByName(vardefault.Name);
      if not Assigned(variable) then
        raise EdzDbNoVariableWithThatName.CreateFmt(
          _('Can not apply default %s, no variable with that name.'), [vardefault.Name]);
      variable.Value := vardefault.Value;
    end;
  end;
begin
  RealApplyDefault(GetDefaults(0));
  RealApplyDefault(_Default);
end;

constructor TdzDbVersionNTypeAncestor.Create(const _DbTypeName, _English, _Deutsch: string);
begin
  MethodTrack(ClassName + '.Create(Name: ' + _DbTypeName + ')');
  inherited Create;
  FDbTypeName := _DbTypeName;
  FEnglish := _English;
  FDeutsch := _Deutsch;

  FDefaultTypes := TInterfaceList.Create;
  FVariables := TdzDbVariableDescriptionList.Create;
  FScripts := TInterfaceList.Create;
  AppendDefault('');
end;

function TdzDbVersionNTypeAncestor.DefaultByName(
  _Name: string): IdzDbDefaultTypeDescription;
var
  i: Integer;
begin
  for i := 0 to FDefaultTypes.Count - 1 do begin
    Result := FDefaultTypes[i] as IdzDbDefaultTypeDescription;
    if AnsiSameText(Result.Name, _Name) then
      Exit;
  end;
  Result := nil;
end;

destructor TdzDbVersionNTypeAncestor.Destroy;
begin
  MethodTrack(ClassName + '(' + FDbTypeName + ').Destroy');

  FDefaultTypes.Free;
  FVariables.Free;
  inherited;
end;

function TdzDbVersionNTypeAncestor.GetDbTypeName: string;
begin
  Result := FDbTypeName;
end;

function TdzDbVersionNTypeAncestor.GetDefaults(
  _Idx: Integer): IdzDbDefaultTypeDescription;
begin
  Result := FDefaultTypes[_Idx] as IdzDbDefaultTypeDescription;
end;

function TdzDbVersionNTypeAncestor.GetDefaultsCount: Integer;
begin
  Result := FDefaultTypes.Count;
end;

function TdzDbVersionNTypeAncestor.GetDeutsch: string;
begin
  Result := FDeutsch;
end;

function TdzDbVersionNTypeAncestor.GetEnglish: string;
begin
  Result := FEnglish;
end;

function TdzDbVersionNTypeAncestor.GetName: string;
begin
  if '' = GetVersionName then
    Result := GetDbTypeName
  else
    Result := Format('%s %s', [GetDbTypeName, GetVersionName]);
end;

function TdzDbVersionNTypeAncestor.GetScripts(
  _Idx: Integer): IdzDbScriptDescription;
begin
  Result := FScripts[_Idx] as IdzDbScriptDescription;
end;

function TdzDbVersionNTypeAncestor.GetScriptsCount: Integer;
begin
  Result := FScripts.Count;
end;

function TdzDbVersionNTypeAncestor.GetVariables(
  _Idx: Integer): IdzDbVariableDescription;
begin
  Result := FVariables[_Idx] as IdzDbVariableDescription;
end;

function TdzDbVersionNTypeAncestor.GetVariablesCount: Integer;
begin
  Result := FVariables.Count;
end;

{ TdzDbDefaultTypeDescription }

function TdzDbVersionNTypeAncestor.GetVersionName: string;
begin
  Result := '';
end;

function TdzDbVersionNTypeAncestor.PrependScript(const _Name, _Deutsch,
  _English: string; const _Active,
  _Mandatory: Boolean): IdzDbScriptDescription;
begin
  Result := TdzDbScriptDescription.Create(_Name, _Deutsch,
    _English, _Active, _Mandatory);
  FScripts.Insert(0, Result);
end;

function TdzDbVersionNTypeAncestor.ScriptByName(
  _Name: string): IdzDbScriptDescription;
var
  i: Integer;
begin
  for i := 0 to FScripts.Count - 1 do begin
    Result := FScripts[i] as IdzDbScriptDescription;
    if AnsiSameText(Result.Name, _Name) then
      Exit;
  end;
  Result := nil;
end;

function TdzDbVersionNTypeAncestor.VariableByName(_Name: string): IdzDbVariableDescription;
var
  Idx: Integer;
begin
  if FVariables.Find(_Name, Idx) then
    Result := FVariables[Idx]
  else
    Result := nil;
end;

{ TdzDbVariableDescription }

constructor TdzDbVariableDescription.Create(const _Name, _Value, _Deutsch,
  _English, _Tag, _ValType: string;
  const _Editable, _Advanced: Boolean);
begin
  MethodTrack(ClassName + '.Create(Name: ' + _Name + ')');
  inherited Create;
  FName := _Name;
  FValue := _Value;
  FDeutsch := _Deutsch;
  FEnglish := _English;
  FTag := _Tag;
  FValType := _ValType;
  FEditable := _Editable;
  FAdvanced := _Advanced;
end;

destructor TdzDbVariableDescription.Destroy;
begin
  MethodTrack(ClassName + '(' + FName + ').Destroy');
  inherited;
end;

function TdzDbVariableDescription.GetAdvanced: Boolean;
begin
  Result := FAdvanced;
end;

function TdzDbVariableDescription.GetValType: string;
begin
  Result := FValType;
end;

function TdzDbVariableDescription.GetDeutsch: string;
begin
  Result := FDeutsch;
end;

function TdzDbVariableDescription.GetEditable: Boolean;
begin
  Result := FEditable;
end;

function TdzDbVariableDescription.GetEnglish: string;
begin
  Result := FEnglish;
end;

function TdzDbVariableDescription.GetName: string;
begin
  Result := FName;
end;

function TdzDbVariableDescription.GetTag: string;
begin
  Result := FTag;
end;

function TdzDbVariableDescription.GetValue: string;
begin
  Result := FValue;
end;

procedure TdzDbVariableDescription.SetValue(const _Value: string);
begin
  FValue := _Value;
end;

{ TdzDbDefaultTypeDescription }

function TdzDbDefaultTypeDescription.AppendVariableDefault(const _Name,
  _Value: string): IdzDbVariableDefaultDescription;
begin
  Result := VariableDefaultByName(_Name);
  if Assigned(Result) then
    FVariabeDefaults.Remove(Result);

  Result := TdzDbVariableDefaultDescription.Create(_Name, _Value);
  FVariabeDefaults.Add(Result);
end;

function TdzDbDefaultTypeDescription.Clone: IdzDbDefaultTypeDescription;
var
  Clone: TdzDbDefaultTypeDescription;
  i: Integer;
begin
  Clone := TdzDbDefaultTypeDescription.Create(FName);

  for i := 0 to GetVariableDefaultsCount - 1 do
    Clone.FVariabeDefaults.Add(GetVariableDefaults(i));

  Result := Clone;
end;

constructor TdzDbDefaultTypeDescription.Create(const _Name: string);
begin
  MethodTrack(ClassName + '.Create(Name: ' + _Name + ')');
  inherited Create;
  FName := _Name;
  FVariabeDefaults := TInterfaceList.Create;
end;

destructor TdzDbDefaultTypeDescription.Destroy;
begin
  MethodTrack(ClassName + '(' + FName + ').Destroy');
  FVariabeDefaults.Free;
  inherited;
end;

function TdzDbDefaultTypeDescription.GetName: string;
begin
  Result := FName;
end;

function TdzDbDefaultTypeDescription.GetVariableDefaults(
  _Idx: Integer): IdzDbVariableDefaultDescription;
begin
  Result := FVariabeDefaults[_Idx] as IdzDbVariableDefaultDescription;
end;

function TdzDbDefaultTypeDescription.GetVariableDefaultsCount: Integer;
begin
  Result := FVariabeDefaults.Count;
end;

function TdzDbDefaultTypeDescription.VariableDefaultByName(
  _Name: string): IdzDbVariableDefaultDescription;
var
  i: Integer;
begin
  for i := 0 to FVariabeDefaults.Count - 1 do begin
    Result := FVariabeDefaults[i] as IdzDbVariableDefaultDescription;
    if AnsiSameText(Result.Name, _Name) then
      Exit;
  end;
  Result := nil;
end;

{ TdzDbVariableDefaultDescription }

constructor TdzDbVariableDefaultDescription.Create(const _Name, _Value: string);
begin
  MethodTrack(ClassName + '.Create(Name: ' + _Name + ')');
  inherited Create;
  FName := _Name;
  FValue := _Value;
end;

destructor TdzDbVariableDefaultDescription.Destroy;
begin
  MethodTrack(ClassName + '(' + FName + ').Destroy');
  inherited;
end;

function TdzDbVariableDefaultDescription.GetName: string;
begin
  Result := FName;
end;

function TdzDbVariableDefaultDescription.GetValue: string;
begin
  Result := FValue;
end;

{ TdzDbScriptDescription }

constructor TdzDbScriptDescription.Create(const _Name, _Deutsch,
  _English: string; const _Active, _Mandatory: Boolean);
begin
  MethodTrack(ClassName + '.Create(Name: ' + _Name + ')');
  inherited Create;
  FName := _Name;
  FDeutsch := _Deutsch;
  FEnglish := _English;
  FMandatory := _Mandatory;
  FActive := _Active or _Mandatory;
  FStatements := TStringList.Create;
end;

function TdzDbScriptDescription.GetDeutsch: string;
begin
  Result := FDeutsch;
end;

function TdzDbScriptDescription.GetEnglish: string;
begin
  Result := FEnglish;
end;

function TdzDbScriptDescription.GetActive: Boolean;
begin
  Result := FActive;
end;

function TdzDbScriptDescription.GetMandatory: Boolean;
begin
  Result := FMandatory;
end;

function TdzDbScriptDescription.GetName: string;
begin
  Result := FName;
end;

procedure TdzDbScriptDescription.SetActive(_Active: Boolean);
begin
  FActive := _Active;
end;

procedure TdzDbScriptDescription.GetStatements(_Statements: TStringList);
begin
  _Statements.AddStrings(FStatements);
end;

destructor TdzDbScriptDescription.Destroy;
begin
  MethodTrack(ClassName + '(' + FName + ').Destroy');
  FStatements.Free;
  inherited;
end;

procedure TdzDbScriptDescription.AppendStatement(const _Statement: string);
begin
  FStatements.Append(_Statement);
end;

{ TdzDbTypeDescription }

function TdzDbTypeDescription.AppendVersion(
  const _Name, _English, _Deutsch: string): IdzDbVersionDescription;
begin
  Result := TdzDbVersionDescription.Create(_Name, _English, _Deutsch, Self);
  FVersions.Add(Result);
end;

constructor TdzDbTypeDescription.Create(const _Name, _English, _Deutsch: string);
begin
  MethodTrack(ClassName + '.Create(Name: ' + _Name + ')');
  inherited;
  FVersions := TInterfaceList.Create;
end;

destructor TdzDbTypeDescription.Destroy;
begin
  MethodTrack(ClassName + '(' + FDbTypeName + ').Destroy');
  FVersions.Free;
  inherited;
end;

function TdzDbTypeDescription.GetVersions(
  _Idx: Integer): IdzDbVersionDescription;
begin
  Result := FVersions[_Idx] as IdzDbVersionDescription;
end;

function TdzDbTypeDescription.GetVersionsCount: Integer;
begin
  Result := FVersions.Count;
end;

{ TdzDbVersionDescription }

function TdzDbVersionDescription.AppendDefault(
  _Name: string): IdzDbDefaultTypeDescription;
begin
  Result := DefaultByName(_Name);
  if not Assigned(Result) then
    Result := inherited AppendDefault(_Name);
end;

function TdzDbVersionDescription.AppendScript(const _Name, _Deutsch, _English:
  string; const _IsDefault,
  _Mandatory: Boolean): IdzDbScriptDescription;
var
  oldIdx, newIdx: Integer;
  old: IdzDbScriptDescription;
begin

  old := ScriptByName(_Name);

  if not Assigned(old) then
    raise EdzDbScriptDoesNotExist.CreateFmt(_('There is no script named %s in this db type'), [_Name]);
  ;

  oldIdx := FScripts.IndexOf(old);

  Result := TdzDbScriptDescription.Create(_Name, _Deutsch, _English, _IsDefault, _Mandatory);

  newIdx := FScripts.Add(Result);
  FScripts.Exchange(oldIdx, newIdx);

  FScripts.Remove(old);
end;

function TdzDbVersionDescription.AppendVariable(const _Name, _Value,
  _Deutsch, _English, _Tag, _ValType: string; const _Editable,
  _Advanced: Boolean): IdzDbVariableDescription;
begin
  Result := VariableByName(_Name);
  if Assigned(Result) then
    FVariables.Extract(FVariables.IndexOf(Result));

  Result := inherited AppendVariable(_Name, _Value, _Deutsch, _English, _Tag,
    _ValType, _Editable, _Advanced);
end;

constructor TdzDbVersionDescription.Create(const _VersionName, _English, _Deutsch: string;
  const _Parent: IdzDbVersionNTypeAncestor);
var
  i: Integer;
begin
  MethodTrack(ClassName + '.Create(Name: ' + _VersionName + ')');
  inherited Create(_Parent.Name, _English, _Deutsch);
  FVersionName := _VersionName;

  FDefaultTypes.Clear;
  for i := 0 to _Parent.DefaultsCount - 1 do
    FDefaultTypes.Add(_Parent.Defaults[i].Clone);

  for i := 0 to _Parent.VariablesCount - 1 do
    FVariables.Add(_Parent.Variables[i]);

  for i := 0 to _Parent.ScriptsCount - 1 do
    FScripts.Add(_Parent.Scripts[i]);
end;

destructor TdzDbVersionDescription.Destroy;
begin
  MethodTrack(ClassName + '(' + FVersionName + ').Destroy');
  inherited;
end;

function TdzDbVersionDescription.GetVersionName: string;
begin
  Result := FVersionName;
end;

end.
