unit LocalHostNetIfoBaseClass;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, contnrs;

type
  TIPInfoObj = class
  private
    FIP   : String;
    FMask : String;
  public
   constructor Create(aIP : String; aMask : String);
   function GetIPAsCardinal : Cardinal;
   function GetMaskAsCardinal : Cardinal;
   property IP   : String read FIP;
   property Mask : String read FMask;
  end;

  {
   Абстрактный класс - описатель сетевого интерфейса
  }
  TNetItfInfoBase = class(TPersistent)
  private
   FIPList     : TObjectList;
  protected
   property IPList : TObjectList read FIPList;
   function GetIPAddress(index: Integer): TIPInfoObj; virtual;
   function GetIPCount: Integer; virtual;

   function GetItfIndex:Cardinal; virtual; abstract;
   function GetItfDescription: String; virtual; abstract;
   function GetItfName: String; virtual; abstract;
  public
   constructor Create; virtual;
   destructor  Destroy; override;
   function GetItfInfoAsString : String; virtual; abstract;
   property ItfIndex       : Cardinal read GetItfIndex;
   property ItfName        : String read GetItfName;
   property ItfDescription : String read GetItfDescription;
   property ItfIPCount     : Integer read GetIPCount;
   property ItfIPAddress[index : Integer]: TIPInfoObj read GetIPAddress;
  end;

  {
    Абстрактный класс-контейнер поддерживает информацию по по всем адаптерам имеющимся в
    системе
  }
  TLocalHostNetInfoBase = class(TComponent)
  protected
   FHostName        : String;
   FItfList         : TObjectList;

   function  GetInterfaces(index: Cardinal): TNetItfInfoBase;
   function  GetItfCount: Cardinal;
  public
   constructor Create(AOwner : TComponent); override;
   destructor  Destroy; override;
   // обновление информации по интерфейсам в системе
   procedure Update; virtual; abstract;
   // очистка списка
   procedure Clear; virtual; abstract;
   // получение объекта информации о интерфейсе по его индексу в системе
   function  GetItfInfoByIndex(index : Cardinal): TNetItfInfoBase;
   // заполняет переданный список перечнем IP адресов имеющихся на локальной машине
   procedure GetIPListStrings(DestStrins : TStrings; IsClearDest : Boolean = True); virtual; abstract;

   property HostName : String read FHostName;
   // количество интерфейсов в системе
   property ItfCount  : Cardinal read GetItfCount;
   // массив объектов информации по интерфейсам
   property Interfaces[index : Cardinal] : TNetItfInfoBase read GetInterfaces;
  end;

implementation

uses SocketMisc;

{ TNetItfInfoBase }

function TNetItfInfoBase.GetIPAddress(index: Integer): TIPInfoObj;
begin
  Result := TIPInfoObj(FIPList.Items[index]);
end;

function TNetItfInfoBase.GetIPCount: Integer;
begin
  Result := FIPList.Count;
end;

constructor TNetItfInfoBase.Create;
begin
  FIPList := TObjectList.create;
end;

destructor TNetItfInfoBase.Destroy;
begin
  FIPList.Free;
  inherited Destroy;
end;

constructor TLocalHostNetInfoBase.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  if AOwner <> nil then ChangeName(format('LocalHostNetBaseInfo%d',[AOwner.ComponentCount+1]))
   else ChangeName(format('LocalHostNetBaseInfo%d',[0]));
  FItfList  := TObjectList.Create(True);
end;

destructor TLocalHostNetInfoBase.Destroy;
begin
  FreeAndNil(FItfList);
  inherited Destroy;
end;

function  TLocalHostNetInfoBase.GetItfInfoByIndex(index : Cardinal): TNetItfInfoBase;
var i, Count : Integer;
begin
  Result := nil;
  Count:= FItfList.Count-1;
  for i:= Count downto 0 do
  begin
    if TNetItfInfoBase(FItfList.Items[i]).ItfIndex = index then
     begin
       Result:= TNetItfInfoBase(FItfList.Items[i]);
       Break;
     end;
  end;
end;

function TLocalHostNetInfoBase.GetInterfaces(index: Cardinal): TNetItfInfoBase;
begin
  Result := TNetItfInfoBase(FItfList.Items[index]);
end;

function TLocalHostNetInfoBase.GetItfCount: Cardinal;
begin
  Result := FItfList.Count;
end;

{ TIPInfoObj }

constructor TIPInfoObj.Create(aIP, aMask: String);
begin
  FIP   := aIP;
  FMask := aMask;
end;

function TIPInfoObj.GetIPAsCardinal: Cardinal;
begin
  Result := GetIPFromStr(FIP);
end;

function TIPInfoObj.GetMaskAsCardinal: Cardinal;
begin
  Result := GetIPFromStr(FMask);
end;

end.

