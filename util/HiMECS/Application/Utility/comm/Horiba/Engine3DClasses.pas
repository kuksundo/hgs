{******************************************************************

                   Himsen Engine 3D Animation Properties

 Copyright (C) 2010 HHI

 Original author: J.H.Park [kuksundo@hhi.co.kr]

 The contents of this file are used with permission, subject to
 the Mozilla Public License Version 1.1 (the "License"); you may  
 not use this file except in compliance with the License. You may 
 obtain a copy of the License at
 http://www.mozilla.org/MPL/MPL-1_1Final.html

 Software distributed under the License is distributed on an
 "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   
 implied. See the License for the specific language governing
 rights and limitations under the License.

******************************************************************}

unit Engine3DClasses;

interface

uses
  Classes, VectorGeometry, GLMisc;

type
  TAnimationCollect = class;
  TAnimationItem = class;

  THimsenAnimation = class(TPersistent)
  private
    F3DModelData: TAnimationCollect;
    FFooter: string;
    FHeader: string;  //Engine Type
    FAniFileName: string;
    FCurrentIndex: integer;//Unique index for D3ModelData
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure AddDefaultPartProperties;
  published
    property Header: string read FHeader write FHeader;
    property AniFileName: string read FAniFileName write FAniFileName;
    property D3ModelData: TAnimationCollect read F3DModelData write F3DModelData;
    property Footer: string read FFooter write FFooter;
    property CurrentIndex: integer read FCurrentIndex write FCurrentIndex;
  end;

  TAnimationItem = class(TCollectionItem)
  private
    FDocIndex: integer;
    FModelFileName: string;
    FPartName: string;
    FPosition: string;//x,y,z
    FCameraRoute: string;//array of vector seperated semicolon
    FAdditionalInformation: string;
    FVersion: string;
    //procedure SetPosition(APosition : TGLCoordinates);
  public
    //property Position: TGLCoordinates read FPosition write SetPosition;
  published
    property DocIndex: integer read FDocIndex write FDocIndex;
    property ModelFileName: string read FModelFileName write FModelFileName;
    property PartName: string read FPartName write FPartName;
    property Position: string read FPosition write FPosition;
    property CameraRoute: string read FCameraRoute write FCameraRoute;
    property Version: string read FVersion write FVersion;
    property AdditionalInformation: string read FAdditionalInformation write FAdditionalInformation;
  end;

  TAnimationCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TAnimationItem;
    procedure SetItem(Index: Integer; const Value: TAnimationItem);
  public
    function  Add: TAnimationItem;
    function Insert(Index: Integer): TAnimationItem;
    property Items[Index: Integer]: TAnimationItem read GetItem  write SetItem; default;
  end;

implementation

{ TAnimationItem }

function TAnimationCollect.Add: TAnimationItem;
begin
  Result := TAnimationItem(inherited Add);
end;

function TAnimationCollect.GetItem(Index: Integer): TAnimationItem;
begin
  Result := TAnimationItem(inherited Items[Index]);
end;

function TAnimationCollect.Insert(Index: Integer): TAnimationItem;
begin
  Result := TAnimationItem(inherited Insert(Index));
end;

procedure TAnimationCollect.SetItem(Index: Integer; const Value: TAnimationItem);
begin
  Items[Index].Assign(Value);
end;

{ TAnimationItem }

//procedure TAnimationItem.SetPosition(APosition: TGLCoordinates);
//begin
//  FPosition.SetPoint(APosition.DirectX, APosition.DirectY, APosition.DirectZ);
//end;

{ THimsenAnimation }

procedure THimsenAnimation.AddDefaultPartProperties;
begin
  with D3ModelData.Add do
  begin
    CurrentIndex := CurrentIndex + 1;
    DocIndex := CurrentIndex;
    ModelFileName := 'Default ModelFileName';
    PartName := 'Default PartName';
    Position := '(0.0,0.0,0.0)';
    //Position.X := 0.0;
    //Position.Y := 1.0;
    //Position.Z := 2.0;
    CameraRoute := '(0.0,0.0,0.0)';
    //Version := DateTimeToStr(Now);
    AdditionalInformation := 'AdditionalInformation';
  end;//with
end;

constructor THimsenAnimation.Create(AOwner: TComponent);
begin
  D3ModelData := TAnimationCollect.Create(TAnimationItem);
end;

destructor THimsenAnimation.Destroy;
begin
  inherited Destroy;
  D3ModelData.Free;
end;


end.
