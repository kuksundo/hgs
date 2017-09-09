unit uXMLConfig;

interface

uses
  Classes, XMLIntf;

type
  EncryptedString = class(TCustomAttribute);

  TXMLConfigNode  = class(TPersistent);

  TXMLConfigNodes = class
  private
    FClass: TClass;
    FList: TList;
    function GetXMLConfigNode(const Index: integer): TXMLConfigNode;
    function GetCount: integer;
  public
    constructor Create(const ItemClass: TClass);
    destructor Destroy; override;

    function Add(const XMLConfigNode: TXMLConfigNode): TXMLConfigNode;

    procedure Clear;

    property Items[const Index: integer]: TXMLConfigNode read GetXMLConfigNode;
    property Count: integer read GetCount;
  end;

  TXMLConfig = class(TXMLConfigNode)
  private
    FXMLFilePath: string;
    FApplicationName: string;
    FRootNodeName: string;
    FVersion: byte;

    function isEncryptedString(const oObject: TObject; const Propertie: string): boolean;

    function EncryptString(const sInput: string): string;
    function DecryptString(const sInput: string): string;
  protected
    procedure SaveClass(oObject: TObject; Node: IXMLNode);
    procedure LoadClass(oObject: TObject; Node: IXMLNode);

    procedure SaveObjects(oObject: TXMLConfigNodes; Node: IXMLNode);
    procedure LoadObjects(oObject: TXMLConfigNodes; Node: IXMLNode);
  public
    constructor Create(const AppName, XMLFilePath: string; RootNodeName: string = 'config');

    procedure Initialize; virtual; abstract;

    procedure Load;
    procedure Save;

    procedure LoadDefaults; virtual; abstract;

    property ApplicationName: string read FApplicationName write FApplicationName;
    property RootNodeName: string read FRootNodeName;
    property Version: byte read FVersion write FVersion default 1;
  end;

implementation

uses
  TypInfo, XMLDoc, SysUtils, Windows, Rtti, EncdDecd;

resourcestring
  rsApplication = 'app';
  rsFormat = 'ver';
  rsPasswordField = 'password';

{ TXMLConfig }

{$REGION 'Initialization'}
constructor TXMLConfig.Create(const AppName, XMLFilePath: string; RootNodeName: string = 'config');
begin
  Initialize;

  FApplicationName := AppName;
  FXMLFilePath := XMLFilePath;
  FRootNodeName := RootNodeName;

  LoadDefaults;
end;

procedure TXMLConfig.LoadObjects(oObject: TXMLConfigNodes; Node: IXMLNode);
var
  i: integer;
  TempObject: TXMLConfigNode;
begin
  oObject.Clear;

  for i := 0 to Node.ChildNodes.Count - 1 do
  begin
    TempObject := TXMLConfigNode(AllocMem(oObject.FClass.InstanceSize));
    oObject.FClass.InitInstance(TempObject);

    LoadClass(TempObject, Node.ChildNodes.Nodes[i]);

    oObject.Add(TempObject);
  end;
end;
{$ENDREGION}

{$REGION 'Loading'}
procedure TXMLConfig.LoadClass(oObject: TObject; Node: IXMLNode);

  procedure GetProperty(PropInfo: PPropInfo);
  var
    sValue: string;
    TempNode: IXMLNode;
    LObject: TObject;
  begin
    TempNode := Node.ChildNodes.FindNode(String(PropInfo.Name));
    if TempNode = nil then
      exit;

    if PropInfo.PropType^.Kind <> tkClass then
      sValue := TempNode.Text;

    case PropInfo.PropType^.Kind of
      tkEnumeration:
        if GetTypeData(PropInfo.PropType^).BaseType = TypeInfo(Boolean)
          then SetPropValue(oObject, PropInfo, Boolean(StrToBool(sValue)))
          else SetPropValue(oObject, PropInfo, StrToInt(sValue));
      tkInteger, tkChar, tkWChar, tkSet:
        SetPropValue(oObject, PropInfo, StrToInt(sValue));
      tkFloat:
        SetPropValue(oObject, PropInfo, StrToFloat(sValue));
      tkString, tkUString, tkLString, tkWString:
        if isEncryptedString(oObject, String(PropInfo.Name))
          then SetPropValue(oObject, PropInfo, DecryptString(sValue))
          else SetPropValue(oObject, PropInfo, sValue);
      tkClass:
        begin
          LObject := GetObjectProp(oObject, PropInfo);
          if LObject <> nil then
            LoadClass(LObject, TempNode);
        end;
    end;
  end;

var
  i, iCount: integer;
  PropInfo: PPropInfo;
  PropList: PPropList;
begin
  if not (oObject is TXMLConfigNodes) then
  begin
    iCount := GetTypeData(oObject.ClassInfo).PropCount;

    if iCount > 0 then
    begin
      GetMem(PropList, iCount * SizeOf(Pointer));

      GetPropInfos(oObject.ClassInfo, PropList);
      try
        for i := 0 to iCount - 1 do
        begin
          PropInfo := PropList[i];
          if PropInfo = nil then
            break;

          GetProperty(PropInfo);
        end;
      finally
        FreeMem(PropList, iCount * SizeOf(Pointer));
      end;
    end;
  end else
    LoadObjects(oObject as TXMLConfigNodes, Node);
end;

function getEncryptionKey: word;
var
  Count: dword;
  sName: string;
  i: integer;
begin
  Result := 0;

  Count := 257;
  SetLength(sName, Count);
  if not GetUserName(PChar(sName), Count) then
    sName := 'fakekey';

  for i := 1 to Length(sName) do
  begin
    if sName[i] = #0 then
      break;

    Result := Abs(Result - Ord(sName[i]));
  end;
end;

function TXMLConfig.DecryptString(const sInput: string): string;
begin
  Result := EncdDecd.DecodeString(sInput);
end;

function TXMLConfig.EncryptString(const sInput: string): string;
begin
  Result := EncdDecd.EncodeString(sInput);
end;

function TXMLConfig.isEncryptedString(const oObject: TObject;
  const Propertie: string): boolean;
var
  ctx: TRttiContext;
  ctt: TRttiType;
  ctp: TRttiProperty;
  cta: TCustomAttribute;
begin
  Result := false;

  ctx := TRttiContext.Create;
  try
    ctt := ctx.GetType(oObject.ClassType);

    for ctp in ctt.GetProperties do
      if ctp.Name = Propertie then
      begin
        for cta in ctp.GetAttributes do
          if cta is EncryptedString then
          begin
            Result := true;

            break;
          end;

        break;
      end;
  finally
    ctx.Free;
  end;
end;

procedure TXMLConfig.Load;
var
  XMLRoot: IXMLNode;
  XML: IXMLDocument;
begin
  LoadDefaults;
  if not FileExists(FXMLFilePath) then
    exit;

  try
    XML := LoadXMLDocument(FXMLFilePath);
    XMLRoot := XML.DocumentElement;

    if (XMLRoot.NodeName <> FRootNodeName) or
       (XMLRoot.Attributes[rsApplication] <> FApplicationName) then
      exit;

    FVersion := XMLRoot.Attributes[rsFormat];

    LoadClass(Self, XMLRoot);
  except
    LoadDefaults;
  end;
end;
{$ENDREGION}

{$REGION 'Saving'}
procedure TXMLConfig.SaveClass(oObject: TObject; Node: IXMLNode);

  procedure WriteProperty(PropInfo: PPropInfo);
  var
    sValue: string;
    LObject: TObject;
    TempNode: IXMLNode;
  begin
    case PropInfo.PropType^.Kind of
      tkEnumeration:
        if GetTypeData(PropInfo.PropType^).BaseType = TypeInfo(Boolean)
          then sValue := BoolToStr(Boolean(GetOrdProp(oObject, PropInfo)), true)
          else sValue := IntToStr(GetOrdProp(oObject, PropInfo));
      tkInteger, tkChar, tkWChar, tkSet:
        sValue := IntToStr(GetOrdProp(oObject, PropInfo));
      tkFloat:
        sValue := FloatToStr(GetFloatProp(oObject, PropInfo));
      tkString, tkUString, tkLString, tkWString:
        begin
          if isEncryptedString(oObject, String(PropInfo.Name))
            then sValue := EncryptString(GetUnicodeStrProp(oObject, PropInfo))
            else sValue := GetUnicodeStrProp(oObject, PropInfo);
        end;
      tkClass:
        if Assigned(PropInfo.GetProc) and Assigned(PropInfo.SetProc) then
        begin
          LObject := GetObjectProp(oObject, PropInfo);
          if LObject <> nil then
          begin
            TempNode := Node.AddChild(String(PropInfo.Name));

            SaveClass(LObject, TempNode);
          end;
        end;
    end;

    if PropInfo.PropType^.Kind <> tkClass then
      with Node.AddChild(String(PropInfo.Name)) do
        Text := sValue;
  end;

var
  PropInfo: PPropInfo;
  PropList: PPropList;
  i, iCount: integer;
begin
  if not (oObject is TXMLConfigNodes) then
  begin
    iCount := GetTypeData(oObject.ClassInfo).PropCount;

    if iCount > 0 then
    begin
      GetMem(PropList, iCount * SizeOf(Pointer));
      try
        GetPropInfos(oObject.ClassInfo, PropList);

        for i := 0 to iCount - 1 do
        begin
          PropInfo := PropList[i];
          if PropInfo = nil then
            Break;

          WriteProperty(PropInfo);
        end;
      finally
        FreeMem(PropList, iCount * SizeOf(Pointer));
      end;
    end;
  end else
    SaveObjects(oObject as TXMLConfigNodes, Node);
end;

procedure TXMLConfig.SaveObjects(oObject: TXMLConfigNodes; Node: IXMLNode);
var
  i: integer;
  TempNode: IXMLNode;
begin
  for i := 0 to oObject.Count - 1 do
  begin
    TempNode := Node.AddChild('Item');
    TempNode.Attributes['id'] := i;

    SaveClass(oObject.Items[i], TempNode);
  end;
end;

procedure TXMLConfig.Save;
var
  FRootNode: IXMLNode;
  FBackFileName: string;
  XML: IXMLDocument;
begin
  FBackFileName := ChangeFileExt(FXMLFilePath, '.bak');
  try
    if FileExists(FXMLFilePath) then
      DeleteFile(PChar(FXMLFilePath));

    try
      XML := NewXMLDocument;

      with XML do
      begin
        Encoding := 'UTF-8';
        Version := '1.0';
      end;

      FRootNode := XML.AddChild(FRootNodeName);
      FRootNode.Attributes[rsApplication] := FApplicationName;
      FRootNode.Attributes[rsFormat] := FVersion;

      SaveClass(Self, FRootNode);

      XML.SaveToFile(FXMLFilePath);
    except
      if FileExists(FBackFileName) then
        RenameFile(FBackFileName, FXMLFilePath);
    end;
  finally
    if FileExists(FBackFileName) then
      DeleteFile(PChar(FBackFileName));
  end;
end;
{$ENDREGION}

{ TXMLConfigNodes }

function TXMLConfigNodes.Add(const XMLConfigNode: TXMLConfigNode): TXMLConfigNode;
begin
  FList.Add(XMLConfigNode);

  Result := XMLConfigNode;
end;

procedure TXMLConfigNodes.Clear;
begin
  while Count > 0 do
    FList.Delete(0);
end;

constructor TXMLConfigNodes.Create(const ItemClass: TClass);
begin
  FList := TList.Create;
  FClass := ItemClass;
end;

destructor TXMLConfigNodes.Destroy;
begin
  if Assigned(FList) then
  begin
    Clear;
    FList.Free;
  end;

  inherited;
end;

function TXMLConfigNodes.GetCount: integer;
begin
  Result := FList.Count;
end;

function TXMLConfigNodes.GetXMLConfigNode(const Index: integer): TXMLConfigNode;
begin
  Result := TXMLConfigNode(FList.Items[Index]);
end;

end.
