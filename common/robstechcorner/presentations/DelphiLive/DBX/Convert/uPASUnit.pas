unit uPASUnit;

interface
uses
  Sysutils, Classes, Contnrs, mwPasLex,mwPasLexTypes;

type

//TUnitSection = class(usInterface,usImplementation,usInitialization,usFinalization,usProgram,usOther);
// Example of usOther could be the tokens between unit and interface section.

TTokenItem = class(TObject)
  private
  protected
    FTokenValue: String;
    FTokenKind: TptTokenKind;
    FLineNo: integer;
    procedure SetTokenKind(const Value: TptTokenKind);
    procedure SetTokenValue(const Value: String);

    function GetIsJunk : Boolean;
    function GetIsSpace : Boolean;
  public
    constructor Create(aPasLex:TmwPasLex); overload; //(aTokenKind : TptTokenKind;aTokenValue : String);
    constructor Create(aTokenKind : TptTokenKind;aTokenValue : String); overload;
    property TokenKind : TptTokenKind read FTokenKind write SetTokenKind;
    property TokenValue : String read FTokenValue write SetTokenValue;
    property OrigLineNo : integer read FLineNo;
    property IsJunk : Boolean read GetIsJunk;
    property IsSpace : Boolean read GetIsSpace;
end;



TTokenList = class(Tobject)
  private
    function GetItem(Index: Integer): TTokenItem;
    function GetItemCount: Integer;
    procedure SetItem(Index: Integer; const Value: TTokenItem);
  protected
    FTokenList : TObjectList;
    FParsePastEndPeriod : Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(aItem : TTokenItem) : Integer;
    procedure Insert(Index: Integer; aItem: TTokenItem);
    procedure Extract(aItem: TTokenItem);
    procedure Move(CurIndex, NewIndex: Integer);
    function IndexOf(aItem: TTokenItem): Integer;
    function Remove(aItem: TTokenItem): Integer;
    procedure Delete(Index : Integer);


    procedure Parse(Input : TMemoryStream);
    procedure SaveToStream(Output : TStream);
    property ParsePastEndPeriod : Boolean read FParsePastEndPeriod write FParsePastEndPeriod;

    property ItemCount : Integer read GetItemCount;
    property Item[Index : Integer] : TTokenItem read GetItem write SetItem;


end;

implementation

{ TTokenItem }

constructor TTokenItem.Create(aPasLex:TmwPasLex);  //(aTokenKind: TptTokenKind;
  //aTokenValue: String);
begin
  FTokenKind := aPasLex.TokenID;  //aTokenKind;
  FTokenValue := aPasLex.Token;  //aTokenValue;
  FLineNo := aPasLex.LineNumber;
end;

constructor TTokenItem.Create(aTokenKind: TptTokenKind; aTokenValue: String);
begin
  FTokenKind := aTokenKind;
  FTokenValue := aTokenValue;
end;

function TTokenItem.GetIsJunk: Boolean;
begin
  Result:= fTokenKind in  [ptAnsiComment, ptBorComment, ptCRLF, ptCRLFCo, ptSlashesComment, ptSpace];
end;

function TTokenItem.GetIsSpace: Boolean;
begin
  Result:= fTokenKind in [ptCRLF, ptSpace];
end;

procedure TTokenItem.SetTokenKind(const Value: TptTokenKind);
begin
  FTokenKind := Value;
end;

procedure TTokenItem.SetTokenValue(const Value: String);
begin
  FTokenValue := Value;
end;



{ TTokenList }

function TTokenList.Add(aItem: TTokenItem): Integer;
begin
 result :=  FTokenList.Add(aItem);
end;

constructor TTokenList.Create;
begin
  FTokenList := TObjectList.Create(True);
  FParsePastEndPeriod := false;
end;

procedure TTokenList.Delete(Index: Integer);
begin
  FTokenList.Delete(Index);
end;

destructor TTokenList.Destroy;
begin
  FTokenList.Free;
  inherited;
end;

procedure TTokenList.Extract(aItem: TTokenItem);
begin
  FTokenList.Extract(aItem);
end;

function TTokenList.GetItem(Index: Integer): TTokenItem;
begin
  Result := (FTokenList.Items[index] as TTokenItem);
end;

function TTokenList.GetItemCount: Integer;
begin
 result := FTokenList.Count;
end;

function TTokenList.IndexOf(aItem: TTokenItem): Integer;
begin
  result := FTokenList.IndexOf(aItem);
end;

procedure TTokenList.Insert(Index: Integer; aItem: TTokenItem);
begin
  FTokenList.Insert(Index,aItem);
end;

procedure TTokenList.Move(CurIndex, NewIndex: Integer);
begin
  FTokenList.Move(CurIndex,NewIndex);
end;

procedure TTokenList.Parse(Input: TMemoryStream);
var
 Lex : TmwPasLex;
 SS : TStringStream;
 S : string;
begin
  SS := TStringStream.Create('');
  try
  SS.CopyFrom(Input,Input.Size);
  S := SS.DataString;
  finally
    SS.Free;
  end;
  Lex := TmwPasLex.Create;
  try
    Lex.Origin := PChar(S);
    While Lex.TokenID <> ptNull do
    begin
        //Add(TTokenItem.Create(Lex.TokenID,Lex.Token));
        Add(TTokenItem.Create(Lex));
        if (not FParsePastEndPeriod) and (Lex.TokenID = ptTheEnd) then Break;
        Lex.Next;
    end;
  finally
    Lex.Free;
  end;
end;

function TTokenList.Remove(aItem: TTokenItem): Integer;
begin
  result := FTokenList.Remove(aItem);
end;

procedure TTokenList.SaveToStream(Output: TStream);
var
 I : Integer;
 UTF8 : UTF8String;
begin
 for I := 0 to ItemCount -1 do
 begin
   UTF8 := UTF8String(Item[I].TokenValue);
   Output.Write(UTF8[1],Length(UTF8));
 end;

end;

procedure TTokenList.SetItem(Index: Integer; const Value: TTokenItem);
begin
 FTokenList.Items[index] := Value;
end;

end.
