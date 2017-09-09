unit u_dzScriptPositionList;

interface

uses
  Classes,
  u_dzTranslator,
  u_dzQuickSort;

type
  // Note: The order of these constants is important, because the objects can be dependent on each other
  TScriptPosition = (
    spUseDatabase,
    spDropReferences,
    spDropPrimaryKeys,
    spDropIndices,
    spDropTables,
    spDropSequences,
    spCreateSequences,
    spCreateTables,
    spCreateIndices,
    spCreatePrimaryKeys,
    spCreateReferences,
    spInsertData
    );

type
  TScriptPositionDesc = class
  protected
    FPosition: TScriptPosition;
    FScriptSection: string;
    FStatements: TStringList;
    FBuffer: TStringList;
  public
    constructor Create(_Position: TScriptPosition; _ScriptSection: string);
    destructor Destroy; override;
    procedure Clear;
    procedure AddStatement(const _Statement: string);
    procedure AddTermStatement(const _Statement: string);
    property Position: TScriptPosition read FPosition;
    property ScriptSection: string read FScriptSection;
    property Statements: TStringList read FStatements;
    property Buffer: TStringList read FBuffer;
  end;

{$DEFINE __DZ_SORTED_OBJECT_LIST_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TObject;
  _ITEM_TYPE_ = TScriptPositionDesc;
  _KEY_TYPE_ = TScriptPosition;
{$INCLUDE 't_dzSortedObjectListTemplate.tpl'}

type
  ///<summary> List for storing TScriptPositionDesc items sorted by Integer </summary>
  TScriptPositionDescList = class(_DZ_SORTED_OBJECT_LIST_TEMPLATE_)
  protected
    ///<summary> return the key of an item for comparison </summary>
    function KeyOf(const _Item: TScriptPositionDesc): TScriptPosition; override;
    ///<summary> compare the keys of two items, must return a value
    ///          < 0 if Key1 < Key2, = 0 if Key1 = Key2 and > 0 if Key1 > Key2 </summary>
    function Compare(const _Key1, _Key2: TScriptPosition): Integer; override;
  end;

implementation

{$INCLUDE 't_dzSortedObjectListTemplate.tpl'}

function TScriptPositionDescList.KeyOf(const _Item: TScriptPositionDesc): TScriptPosition;
begin
  Result := _Item.FPosition;
end;

function TScriptPositionDescList.Compare(const _Key1, _Key2: TScriptPosition): Integer;
begin
  Result := Ord(_Key1) - Ord(_Key2);
end;

{ TScriptPositionDesc }

constructor TScriptPositionDesc.Create(_Position: TScriptPosition; _ScriptSection: string);
begin
  inherited Create;
  FPosition := _Position;
  FScriptSection := _ScriptSection;
  FStatements := TStringList.Create;
  FBuffer := TStringList.Create;
end;

destructor TScriptPositionDesc.Destroy;
begin
  FBuffer.Free;
  FStatements.Free;
  inherited;
end;

procedure TScriptPositionDesc.Clear;
begin
  FStatements.Clear;
  FBuffer.Clear;
end;

procedure TScriptPositionDesc.AddStatement(const _Statement: string);
begin
  FBuffer.Append(_Statement);
end;

procedure TScriptPositionDesc.AddTermStatement(const _Statement: string);
begin
  AddStatement(_Statement);

  FStatements.Add(FBuffer.Text);
  FBuffer.Clear;
end;

end.

