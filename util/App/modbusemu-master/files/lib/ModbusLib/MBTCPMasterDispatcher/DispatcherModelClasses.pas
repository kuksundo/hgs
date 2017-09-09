unit DispatcherModelClasses;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, contnrs,
     LoggerItf,
     DispatcherModelObjectClasses, DispatcherModbusItf, DispatcherModbusDeviceClasses,
     MBDefine,
     NativeXml;
type

  { TDispatcherModel }

  TDispatcherModel = class(TComponentLogged)
  private
    FModelObjects : TObjectList;
    function GetObjectCount: Integer;
    function GetObjects(Index : Integer): TDispatcherModelObject;
  protected
    procedure SetLogger(const AValue: IDLogger); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    function  IndexOf(AID : String) : Integer;

    function  GetDevice(AObjectID, ADeviceID : String) : TDispatcherModbusDevice;
    function  GetDeviceItf(AObjectID, ADeviceID : String) : IMBDispDeviceTCPItf;
    function  GetDeviceSection(AObjectID, ADeviceID, ASectionID : String) : TDeviceRangeItem;

    function  AddObjectModel(AID,AName,AType : String; APlgItrvl : Integer = 500;
                                                       APlgReconItvl : Integer = 10000;
                                                       APlgTimeOut : Integer = 5000): TDispatcherModelObject;

    function  AddDevice(AObjectID,AObgectName,AObjectType : String;
                        ADeviceID,ADeviceCaption : String;
                        ADeviceNum : Byte;
                        APlgItrvl : Integer = 500;
                        APlgReconItvl : Integer = 10000;
                        APlgTimeOut : Integer = 5000): TDispatcherModbusDevice;

    procedure AddRangeToDevice(AObjectID,ADeviceID   : String;
                               ARangeType            : TRegMBTypes;
                               ARegStart,ARegQuantity : Word);

    procedure Clear;

    property ObjectCount              : Integer read GetObjectCount;
    property Objects[Index : Integer] : TDispatcherModelObject read GetObjects;

    // подписка устройства на получение данных от диспетчера
    procedure SubscribeToUpdates(ADispetcherItf : IMBDispatcherItf);
    // снятие подписки устройства на получение данных от диспетчера
    procedure UnsubscribeToUpdates;
    // загрузка параметров объекта из конфигурационного файла
    // AObjectListTag - тег списка объектов тренсмиттера
    procedure LoadFromXML(AObjectListTag : TXmlNode); virtual;
  end;

implementation

uses {Библиотека MiscFunctions}
     XMLConsts,
     ExceptionsTypes;

{ TDispatcherModel }

constructor TDispatcherModel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FModelObjects := TObjectList.Create(True) ;
end;

destructor TDispatcherModel.Destroy;
begin
  FreeAndNil(FModelObjects);
  inherited Destroy;
end;

function TDispatcherModel.IndexOf(AID: String): Integer;
var i,Count : Integer;
begin
  Result := -1;
  Count := FModelObjects.Count-1;
  for i := 0 to Count do
   begin
    if SameText(AID,TDispatcherModelObject(FModelObjects.Items[i]).ObjectID) then
     begin
      Result := i;
      Break;
     end;
   end;
end;

function TDispatcherModel.GetDevice(AObjectID, ADeviceID: String): TDispatcherModbusDevice;
var i : Integer;
    TempObj : TDispatcherModelObject;
begin
  Result := nil;
  if (AObjectID = '') or (ADeviceID = '') then Exit;
  i := IndexOf(AObjectID);
  if i = -1 then Exit;
  TempObj := Objects[i];
  i := TempObj.IndexOf(ADeviceID);
  if i = -1 then Exit;
  Result := TempObj.Devices[i];
end;

function TDispatcherModel.GetDeviceItf(AObjectID, ADeviceID: String): IMBDispDeviceTCPItf;
var TempDev : TDispatcherModbusDevice;
begin
  Result := nil;
  TempDev := GetDevice(AObjectID,ADeviceID);
  if not Assigned(TempDev) then Exit;
  Result := TempDev as IMBDispDeviceTCPItf;
end;

function TDispatcherModel.GetDeviceSection(AObjectID, ADeviceID, ASectionID: String): TDeviceRangeItem;
var TempDev : TDispatcherModbusDevice;
begin
  Result.RegType := rgNone;
  if ASectionID = '' then Exit;
  TempDev := GetDevice(AObjectID,ADeviceID);
  if not Assigned(TempDev) then Exit;
  Result := TempDev.SearchRangeItem(ASectionID);
end;

function TDispatcherModel.AddObjectModel(AID, AName, AType: String; APlgItrvl: Integer; APlgReconItvl: Integer; APlgTimeOut: Integer): TDispatcherModelObject;
var i : Integer;
begin
  i := IndexOf(AID);
  if i <> -1 then
   begin
    Result := Objects[i];
    Exit;
   end;
  Result := TDispatcherModelObject.Create(nil);
  Result.ObjectID   := AID;
  Result.ObjectName := AName;
  Result.ObjectType := AType;
  Result.PoolingInterval := APlgItrvl;
  Result.PoolingReconnectInterval := APlgReconItvl;
  Result.PoolingInterval := APlgItrvl;
  Result.PoolingTimeOut  := APlgTimeOut;
  FModelObjects.Add(Result);
end;

function TDispatcherModel.AddDevice(AObjectID, AObgectName,AObjectType: String;
                                    ADeviceID, ADeviceCaption: String; ADeviceNum: Byte;
                                    APlgItrvl: Integer; APlgReconItvl: Integer; APlgTimeOut: Integer
                                    ): TDispatcherModbusDevice;
var TempObj : TDispatcherModelObject;
begin
  TempObj := AddObjectModel(AObjectID,AObgectName,AObjectType,APlgItrvl,APlgReconItvl,APlgTimeOut);
  Result := TempObj.AddObjectModel(ADeviceID,ADeviceCaption);
  Result.Device.DeviceNum := ADeviceNum;
end;

procedure TDispatcherModel.AddRangeToDevice(AObjectID, ADeviceID: String; ARangeType: TRegMBTypes; ARegStart, ARegQuantity: Word);
var i : Integer;
    TempObj : TDispatcherModelObject;
begin
  i := IndexOf(AObjectID);
  if i = -1 then Exit;
  TempObj := Objects[i];
  i := TempObj.IndexOf(ADeviceID);
  if i = -1 then Exit;
  TempObj.Devices[i].AddRange(ARangeType,ARegStart,ARegQuantity);
end;

procedure TDispatcherModel.Clear;
begin
  FModelObjects.Clear;
end;

function TDispatcherModel.GetObjectCount: Integer;
begin
  Result := FModelObjects.Count;
end;

function TDispatcherModel.GetObjects(Index : Integer): TDispatcherModelObject;
begin
  Result := TDispatcherModelObject(FModelObjects.Items[Index]);
end;

procedure TDispatcherModel.SetLogger(const AValue: IDLogger);
var i, Count : Integer;
begin
  inherited SetLogger(AValue);
  Count := FModelObjects.Count-1;
  for i := 0 to Count do TDispatcherModelObject(FModelObjects.Items[i]).Logger := Logger;
end;

procedure TDispatcherModel.SubscribeToUpdates(ADispetcherItf: IMBDispatcherItf);
var i, Count : Integer;
begin
  Count := FModelObjects.Count-1;
  for i := 0 to Count do
   begin
    TDispatcherModelObject(FModelObjects.Items[i]).SubscribeToUpdates(ADispetcherItf);
   end;
end;

procedure TDispatcherModel.UnsubscribeToUpdates;
var i, Count : Integer;
begin
  Count := FModelObjects.Count-1;
  for i := 0 to Count do
   begin
    TDispatcherModelObject(FModelObjects.Items[i]).UnsubscribeToUpdates;
   end;
end;

procedure TDispatcherModel.LoadFromXML(AObjectListTag: TXmlNode);
var TempNode     : TXmlNode;
    i,Count      : Integer;
    TempModelObj : TDispatcherModelObject;
begin
  if not Assigned(AObjectListTag) then raise EObjectListNotAssigned.Create(csXMLObjectList);
  if AObjectListTag.Name <> csXMLObjectList then raise EObjectListParamInvalid.Create(csXMLObjectList);
  if AObjectListTag.Parent.Name <> csXMLTrasmitterSNMP then raise EObjectParamInvalid.Create(csXMLObjectList);

  Count := AObjectListTag.NodeCount-1;
  for i := 0 to Count do
   begin
    TempNode := AObjectListTag.Nodes[i];
    if TempNode.ElementType <> xeElement then Continue;
    if not SameText(TempNode.Name,csXMLObject) then Continue; // тег не объект

    TempModelObj := TDispatcherModelObject.Create(nil);
    TempModelObj.Logger := Logger;
    TempModelObj.LoadFromXML(TempNode);

    FModelObjects.Add(TempModelObj);
   end;
end;

end.

