unit SFTConfigCollect;

interface

uses classes, SysUtils;

type
  TSFTCollect = class;
  TSFTItem = class;

  TSFTBase = class(TPersistent)
  private
    FSFTCollect: TSFTCollect;

    FQueryInterval,
    FResponseWaitTime: integer;
    FDownLoadDir: string;
    FDontAskConfirm: Boolean;//다운 받을때 확인 창 띄우기 = False

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure LoadFromFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);
    procedure SaveToFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);
  published
    property SFTCollect: TSFTCollect read FSFTCollect write FSFTCollect;
    property QueryInterval: integer read FQueryInterval write FQueryInterval;
    property ResponseWaitTime: integer read FResponseWaitTime write FResponseWaitTime;
    property DownLoadDir: string read FDownLoadDir write FDownLoadDir;
    property DontAskConfirm: Boolean read FDontAskConfirm write FDontAskConfirm;
  end;

  TSFTItem = class(TCollectionItem)
  private
  public
  end;

  TSFTCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TSFTItem;
    procedure SetItem(Index: Integer; const Value: TSFTItem);
  public
    function  Add: TSFTItem;
    function Insert(Index: Integer): TSFTItem;
    property Items[Index: Integer]: TSFTItem read GetItem  write SetItem; default;
  end;

implementation

uses JvgXMLSerializer_Encrypt;

{ TSFTCollect }

function TSFTCollect.Add: TSFTItem;
begin
  Result := TSFTItem(inherited Add);
end;

function TSFTCollect.GetItem(Index: Integer): TSFTItem;
begin
  Result := TSFTItem(inherited Items[Index]);
end;

function TSFTCollect.Insert(Index: Integer): TSFTItem;
begin
  Result := TSFTItem(inherited Insert(Index));
end;

procedure TSFTCollect.SetItem(Index: Integer; const Value: TSFTItem);
begin
  Items[Index].Assign(Value);
end;


{ TMenuBase }

constructor TSFTBase.Create(AOwner: TComponent);
begin
  FSFTCollect := TSFTCollect.Create(TSFTItem);
end;

destructor TSFTBase.Destroy;
begin
  inherited Destroy;
  FSFTCollect.Free;
end;

procedure TSFTBase.LoadFromFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);
var
  LTJvgXMLSerializer_Encrypt: TJvgXMLSerializer_Encrypt;
begin
  if AFileName <> '' then
  begin
    LTJvgXMLSerializer_Encrypt := TJvgXMLSerializer_Encrypt.Create(nil);
    try
      FSFTCollect.Clear;
      LTJvgXMLSerializer_Encrypt.LoadFromXMLFile(Self,AFileName,APassPhrase,AIsEncrypt);
    finally
      LTJvgXMLSerializer_Encrypt.Free;
    end;
  end
  else
    ;//ShowMessage('File name is empty!');
end;

procedure TSFTBase.SaveToFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);
var
  LTJvgXMLSerializer_Encrypt: TJvgXMLSerializer_Encrypt;
begin
  if AFileName <> '' then
  begin
    LTJvgXMLSerializer_Encrypt := TJvgXMLSerializer_Encrypt.Create(nil);
    try
      FSFTCollect.Clear;
      LTJvgXMLSerializer_Encrypt.SaveToXMLFile(Self,AFileName,APassPhrase,AIsEncrypt);
    finally
      LTJvgXMLSerializer_Encrypt.Free;
    end;
  end
  else
    ;//ShowMessage('File name is empty!');
end;

end.
