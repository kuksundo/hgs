unit DesignFormConfigClass;

interface

uses classes, BaseConfigCollect, HiMECSConst;

type
  TDesignFormConfigCollect = class;
  TDesignFormConfigItem = class;

  TDesignFormConfig = class(TpjhBase)
  private
    FDesignFormConfigCollect: TDesignFormConfigCollect;
    FMainFormCaption: string;
    FBorderStyle: integer;
    FTabHeight: integer;//Tab ¼û±â±â = 0
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

  published
    property DesignFormConfigCollect: TDesignFormConfigCollect read FDesignFormConfigCollect write FDesignFormConfigCollect;
    property MainFormCaption: string read FMainFormCaption write FMainFormCaption;
    property BorderStyle: integer read FBorderStyle write FBorderStyle;
    property TabHeight: integer read FTabHeight write FTabHeight;
  end;

  TDesignFormConfigItem = class(TCollectionItem)
  private
    FBplFileList: string;  //bpl file name list(csv) for component
    FDesignFormFileName: string;  //DFM File Name
    FDesignFormCaption: string;
    FDesignFormIndex: integer;  //page index
  published
    property BplFileList: string read FBplFileList write FBplFileList;
    property DesignFormFileName: string read FDesignFormFileName write FDesignFormFileName;
    property DesignFormCaption: string read FDesignFormCaption write FDesignFormCaption;
    property DesignFormIndex: integer read FDesignFormIndex write FDesignFormIndex;
  end;

  TDesignFormConfigCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TDesignFormConfigItem;
    procedure SetItem(Index: Integer; const Value: TDesignFormConfigItem);
  public
    function  Add: TDesignFormConfigItem;
    function Insert(Index: Integer): TDesignFormConfigItem;
    property Items[Index: Integer]: TDesignFormConfigItem read GetItem  write SetItem; default;
  end;

implementation

{ TDesignFormConfig }

constructor TDesignFormConfig.Create(AOwner: TComponent);
begin
  FDesignFormConfigCollect := TDesignFormConfigCollect.Create(TDesignFormConfigItem);
end;

destructor TDesignFormConfig.Destroy;
begin
  FDesignFormConfigCollect.Free;

  inherited Destroy;
end;

{ TDesignFormConfigCollect }

function TDesignFormConfigCollect.Add: TDesignFormConfigItem;
begin
  Result := TDesignFormConfigItem(inherited Add);
end;

function TDesignFormConfigCollect.GetItem(
  Index: Integer): TDesignFormConfigItem;
begin
  Result := TDesignFormConfigItem(inherited Items[Index]);
end;

function TDesignFormConfigCollect.Insert(Index: Integer): TDesignFormConfigItem;
begin
  Result := TDesignFormConfigItem(inherited Insert(Index));
end;

procedure TDesignFormConfigCollect.SetItem(Index: Integer;
  const Value: TDesignFormConfigItem);
begin
  Items[Index].Assign(Value);
end;

end.
