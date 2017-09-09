///<summary> implements the interfaces declared in u_dzXmlWriterWinterface </summary> 
unit u_dzXmlWriterEntities;

interface

uses
  SysUtils,
  Classes,
  u_dzXmlWriterInterface;

type
  TdzXmlAttribute = class(TInterfacedObject, IdzXmlAttribute)
  private
    FName: string;
    FValue: string;
  protected
    function Name: string;
    function Value: string;
  public
    constructor Create(const _Name, _Value: string);
  end;

type
  TdzXmlEntity = class(TInterfacedObject, IdzXmlEntity, IdzXmlNode)
  private
    FName: string;
    FAttributes: TStringList;
    FEntities: TInterfaceList;
  protected
    procedure AddAttribute(_Attribute: IdzXmlAttribute);
    procedure AddNode(const _Node: IdzXmlNode);
    procedure Write(const _Writer: IdzXmlWriter);
  public
    constructor Create(const _Name: string);
    destructor Destroy; override;
  end;

type
  TdzXmlCData = class(TInterfacedObject, IdzXmlNode)
  private
    FContent: string;
  protected
    procedure Write(const _Writer: IdzXmlWriter);
  public
    constructor Create(const _Content: string);
  end;

type
  TdzXmlData = class(TInterfacedObject, IdzXmlNode)
  private
    FContent: string;
  protected
    procedure Write(const _Writer: IdzXmlWriter);
  public
    constructor Create(const _Content: string);
  end;

implementation

{ TdzXmlAttribute }

constructor TdzXmlAttribute.Create(const _Name, _Value: string);
begin
  inherited Create;
  FName := _Name;
  FValue := _Value;
end;

function TdzXmlAttribute.Name: string;
begin
  Result := FName;
end;

function TdzXmlAttribute.Value: string;
begin
  Result := FValue;
end;

{ TdzXmlEntity }

constructor TdzXmlEntity.Create(const _Name: string);
begin
  inherited Create;
  FName := _Name;
  FAttributes := TStringList.Create;
  FEntities := TInterfaceList.Create;
end;

destructor TdzXmlEntity.Destroy;
begin
  FAttributes.Free;
  FEntities.Free;
  inherited;
end;

procedure TdzXmlEntity.AddAttribute(_Attribute: IdzXmlAttribute);
begin
  FAttributes.Add(Format('%s=%s', [_Attribute.Name, _Attribute.Value]));
end;

procedure TdzXmlEntity.AddNode(const _Node: IdzXmlNode);
begin
  FEntities.Add(_Node);
end;

procedure TdzXmlEntity.Write(const _Writer: IdzXmlWriter);
var
  i: integer;
begin
  if FEntities.Count = 0 then
    _Writer.WriteEntity2(FName, FAttributes)
  else
    begin
      _Writer.StartEntity2(FName, FAttributes);
      try
        for i := 0 to FEntities.Count - 1 do
          (FEntities[i] as IdzXmlEntity).Write(_Writer);
      finally
        _Writer.EndEntity(FName);
      end;
    end;
end;

{ TdzXmlCData }

constructor TdzXmlCData.Create(const _Content: string);
begin
  inherited Create;
  FContent := _Content;
end;

procedure TdzXmlCData.Write(const _Writer: IdzXmlWriter);
begin
  _Writer.StartCdata;
  _Writer.WriteCdataLine(FContent);
  _Writer.EndCdata;
end;

{ TdzXmlData }

constructor TdzXmlData.Create(const _Content: string);
begin
  inherited Create;
  FContent := _Content;
end;

procedure TdzXmlData.Write(const _Writer: IdzXmlWriter);
begin
  _Writer.WriteLine(FContent);
end;

end.

