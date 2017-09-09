unit UnitMacroListClass2;

interface

uses classes, SysUtils, System.Contnrs, mORMot, SynCommons,
  pjhBaseCollect, thundax.lib.actions;//System.Generics.Collections, , Generics.Legacy

const
  MACRO_START = 'MacroStart';
  MACRO_ONE_STEP = 'Macro One-Step';
  MACRO_STOP = 'Macro Stop';

type
  TMacroItem = class(TSynAutoCreateFields)
  private
    FItemName,
    FItemValue: string;
  published
    property ItemName: string read FItemName write FItemName;
    property ItemValue: string read FItemValue write FItemValue;
  end;

type
  TActionItem = class(TSynAutoCreateFields)
  private
    FActionCode,
    FActionDesc: string;
    FActionType: TActionType;
    FXPos, FYPos, FWaitSec, FGridIndex: integer;
    FInputText: string;
  public
    procedure Assign(Source: TSynPersistent); override;
  published
    property ActionCode: string read FActionCode write FActionCode;
    property ActionDesc: string read FActionDesc write FActionDesc;
    property ActionType: TActionType read FActionType write FActionType;
    property XPos: integer read FXPos write FXPos;
    property YPos: integer read FYPos write FYPos;
    property WaitSec: integer read FWaitSec write FWaitSec;
    property GridIndex: integer read FGridIndex write FGridIndex; //1부터 시작함
    property InputText: string read FInputText write FInputText;
  end;

type
  //CHANGE CLASS TYPE HERE FOR TCollectionItemAutoCreateFields
  TMacros = class(TCollectionItemAutoCreateFields)
  private
    FMacroItem : TMacroItem;
//    FActionItem: TActionItem;
  published
    property MacroItem : TMacroItem read FMacroItem;
//    property ActionItem : TActionItem read FActionItem;
  end;

//  TMacroCollect<T: TMacros> = class(Generics.Legacy.TCollection<T>);

  //THIS IS NEW CLASS FOR MANAGE COLLECTION AND ACCESS LIKE AN ARRAY
type
  TMacroCollection = class(TInterfacedCollection)
  private
    function GetCollItem(aIndex: Integer): TMacros;
  protected
    class function GetClass: TCollectionItemClass; override;
  public
    function Add: TMacros;
    property Item[aIndex: Integer]: TMacros read GetCollItem; default;
  end;

  TActions = class(TCollectionItemAutoCreateFields)
  private
    FActionItem: TActionItem;
  published
    property ActionItem : TActionItem read FActionItem;
  end;

  TActionCollection = class(TInterfacedCollection)
  private
    function GetCollItem(aIndex: Integer): TActions;
  protected
    class function GetClass: TCollectionItemClass; override;
  public
    function Add: TActions;
    property Item[aIndex: Integer]: TActions read GetCollItem; default;
  end;

  TMacroManagement = class(TSynAutoCreateFields)
  private
    FIterateCount : integer;
    FActionDesc: string;
    FMacroName,
    FMacroDesc: string;
    FIsExecute: Boolean;

    FMacroCollection: TMacroCollection;
    FActionCollection: TActionCollection;
  public
    FActionList: TActionList;
  published
    property MacroName: string read FMacroName write FMacroName;
    property MacroDesc: string read FMacroDesc write FMacroDesc;
    property IterateCount : integer read FIterateCount write FIterateCount;
    property IsExecute : Boolean read FIsExecute write FIsExecute;
    property ActionDesc: string read FActionDesc write FActionDesc;

    property MacroCollect: TMacroCollection read FMacroCollection;
    property ActionCollect: TActionCollection read FActionCollection;
  end;

  TMacroManagements = class(TObjectList)
  public
    function LoadFromJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;
    function SaveToJSONFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer; virtual;
    function LoadFromStream(AStream: TStream; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
    function SaveToStream(AStream: TStream; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
  end;

  procedure CopyActionCollect(ASrc, ADest: TActionCollection);
//type
//  TUser = class(TBaseClass)
//  private
//    FUsername: RawUTF8;
//    FFirstName: TNullableUTF8Text;
//    FLastName: TNullableUTF8Text;
//    FGroups: TGroupsCollection;
//    FCanSynchronize: boolean;
//  published
//    property Username : RawUTF8 read FUsername write FUsername;
//    property FirstName : TNullableUTF8Text read FFirstName write FFirstName;
//    property LastName : TNullableUTF8Text read FLastName write FLastName;
//
//    property Groups: TGroupsCollection read FGroups;
//  end;
//
//type
//  TCompany = class(TBaseClass)
//  private
//    FCanSynchronize: boolean;
//    FType: Integer;
//    FName: RawUTF8;
//  published
//    property CanSynchronize : boolean read FCanSynchronize write FCanSynchronize;
//    property Name : RawUTF8 read FName write FName;
//    property Types : Integer read FType write FType;
//  end;
//
//type
//  TSession = class(TBaseClass)
//  private
//    FUserID: RawUTF8;
//    FUser: TUser;
//    FCompanyID: RawUTF8;
//    FCompany: TCompany;
//  published
//    property UserID : RawUTF8 read FUserID write FUserID;
//    property User : TUser read FUser;
//    property CompanyID : RawUTF8 read FCompanyID write FCompanyID;
//    property Company : TCompany read FCompany;
//  end;
//
//type
//  TSessions = class(TSynAutoCreateFields)
//  private
//    FSession: TSession;
//    function GetSession: TSession;
//  published
//    property Session : TSession read FSession;
//  end;

implementation

uses UnitEncrypt;

procedure CopyActionCollect(ASrc, ADest: TActionCollection);
var
  i: integer;
begin
  ADest.Clear;

  for i := 0 to ASrc.Count - 1 do
  begin
    ADest.Add.ActionItem.Assign(ASrc.Item[i].ActionItem);
  end;

//  ASrc.AssignTo(ADest);
end;

{ TMacroCollection }

function TMacroCollection.Add: TMacros;
begin
  Result := TMacros(inherited Add);
end;

class function TMacroCollection.GetClass: TCollectionItemClass;
begin
  Result := TMacros;
end;

function TMacroCollection.GetCollItem(aIndex: Integer): TMacros;
begin
  Result := TMacros(GetItem(aIndex));
end;

{ TActionCollection }

function TActionCollection.Add: TActions;
begin
  Result := TActions(inherited Add);
end;

class function TActionCollection.GetClass: TCollectionItemClass;
begin
  Result := TActions;
end;

function TActionCollection.GetCollItem(aIndex: Integer): TActions;
begin
  Result := TActions(GetItem(aIndex));
end;

{ TMacroManagements }

function TMacroManagements.LoadFromJSONFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
var
  LStrList: TStringList;
  LValid: Boolean;
  LString: RawUTF8;
  Fs: TFileStream;
  LMemStream: TMemoryStream;
begin
  LStrList := TStringList.Create;
  try
    if AIsEncrypt then
    begin
      LMemStream := TMemoryStream.Create;
      Fs := TFileStream.Create(AFileName, fmOpenRead);
      try
        DecryptStream(Fs, LMemStream, APassphrase);
        LMemStream.Position := 0;
        LStrList.LoadFromStream(LMemStream);
      finally
        LMemStream.Free;
        Fs.Free;
      end;

    end
    else
    begin
      LStrList.LoadFromFile(AFileName);
    end;

    SetLength(LString, Length(LStrList.Text));
    LString := StringToUTF8(LStrList.Text);
    JSONToObject(Self, PUTF8Char(LString), LValid, TMacroManagement, [j2oIgnoreUnknownProperty]);
  finally
    LStrList.Free;
  end;
end;

function TMacroManagements.LoadFromStream(AStream: TStream; APassPhrase: string;
  AIsEncrypt: Boolean): integer;
begin

end;

function TMacroManagements.SaveToJSONFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
var
  LStrList: TStringList;
  LMemStream: TMemoryStream;
  Fs: TFileStream;
  LStr: RawUTF8;
begin
  LStrList := TStringList.Create;
  try
    LStr := ObjectToJSON(Self,[woHumanReadable,woStoreClassName]);
    LStrList.Add(UTF8ToString(LStr));

    if AIsEncrypt then
    begin
      LMemStream := TMemoryStream.Create;
      Fs := TFileStream.Create(AFileName, fmCreate);
      try
        LStrList.SaveToStream(LMemStream);
        LMemStream.Position := 0;
        EncryptStream(LMemStream, Fs, APassphrase);
      finally
        Fs.Free;
        LMemStream.Free;
      end;
   end
    else
      LStrList.SaveToFile(AFileName);
  finally
    LStrList.Free;
  end;
end;

function TMacroManagements.SaveToStream(AStream: TStream; APassPhrase: string;
  AIsEncrypt: Boolean): integer;
begin

end;

{ TActionItem }

procedure TActionItem.Assign(Source: TSynPersistent);
begin
//  inherited;

  ActionCode := TActionItem(Source).FActionCode;
  ActionDesc := TActionItem(Source).FActionDesc;
  ActionType := TActionItem(Source).FActionType;
  XPos := TActionItem(Source).FXPos;
  YPos := TActionItem(Source).FYPos;
  WaitSec := TActionItem(Source).FWaitSec;
  InputText := TActionItem(Source).FInputText;
  GridIndex := TActionItem(Source).FGridIndex;
end;

end.
