unit UnitEngineBaseClassUtil;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Rtti,
  NxPropertyItems, NxPropertyItemClasses,
  NxScrollControl, NxInspector, EngineBaseClass_Old, EngineBaseClass, EngineConst;

  function AddItemsToInspector(AInspector: TNextInspector; ANxItemClass: TNxItemClass;
              AParentNode: TNxPropertyItem; AName, ACaption, AValue: string):TNxPropertyItem;overload;
  function AddItemsToInspector(AInspector: TNextInspector; ANxItemClass: TNxItemClass;
              ABaseIndex: integer; AName, ACaption, AValue: string):TNxPropertyItem;overload;

  procedure EngineInfoInspector2Class(AInspector: TNextInspector;
    AClass: TICEngine; AIsObjClear: Boolean=false);
  procedure EngineInfoClass2Inspector(AClass: TICEngine;
    AInspector: TNextInspector; AProjIndex: integer;
    AEvent: TNxItemNotifyEvent; AIsAdd2Combo: Boolean = True);

  procedure EngineInfoInspector2Class_Old(AInspector: TNextInspector;
    AClass: TInternalCombustionEngine);
  procedure EngineInfoClass2Inspector_Old(AClass: TInternalCombustionEngine;
    AInspector: TNextInspector; AProjIndex: integer;
    AEvent: TNxItemNotifyEvent);

  procedure AssignOldToNewClass(AOld: TInternalCombustionEngine; ANew: TICEngine);

  procedure SetBasicEngineInfoItem(AInspector: TNextInspector);
  procedure InitEngineInfoItem(AInspector: TNextInspector);
  function AddNullComponentToInspector(AClass: TICEngine;
    AInspector: TNextInspector; APartName: string; AKind: integer): TNxPropertyItem;
  procedure SetInpectorToClassValue(ANx: TNxPropertyItem; AObj: TICEnginePartItem);

implementation

//AName: ANxItemClass name
//ACaption: 왼쪽 Text
//AValue: 오른쪽 Text
function AddItemsToInspector(AInspector: TNextInspector; ANxItemClass: TNxItemClass;
            AParentNode: TNxPropertyItem; AName, ACaption, AValue: string):TNxPropertyItem;
begin
  Result := nil;
  Result := AInspector.Items.AddChild(AParentNode, ANxItemClass);

  if Result <> nil then
  begin
    if AName <> '' then
      Result.Name := AName;

    if ACaption <> '' then
      Result.Caption := ACaption;

    if AValue <> '' then
      Result.AsString := AValue;
  end;

  AInspector.Invalidate;
end;

function AddItemsToInspector(AInspector: TNextInspector; ANxItemClass: TNxItemClass;
  ABaseIndex: integer; AName, ACaption, AValue: string):TNxPropertyItem;overload;
begin
  Result := nil;
  Result := AInspector.Items.AddChild(AInspector.Items[ABaseIndex], ANxItemClass);

  if Result <> nil then
  begin
    if AName <> '' then
      Result.Name := AName;

    if ACaption <> '' then
      Result.Caption := ACaption;

    if AValue <> '' then
      Result.AsString := AValue;
  end;

  AInspector.Invalidate;
end;

procedure EngineInfoInspector2Class(AInspector: TNextInspector;
  AClass: TICEngine; AIsObjClear: Boolean);
var
  i:integer;
  LICEnginePartItem: TICEnginePartItem;
  LICEngineComponentItem: TICEngineComponentItem;
  LPropertyItem, LPropertyItem2: TNxPropertyItem;

  procedure SetPropertyItem2Class(AProperty: TNxPropertyItem);
  var
    j, LParentIdx: integer;
    LPropertyItem3: TNxPropertyItem;
  begin
    if AProperty.Tag = 1 then //Component
    begin
      if AIsObjClear then
        LICEngineComponentItem := AClass.ICEngineComponentCollect.Add
      else
        LICEngineComponentItem := TICEngineComponentItem(AInspector.Items[i].ObjectReference);

      LICEngineComponentItem.ComponentName := AProperty.Caption;

      for j := 0 to AProperty.Count - 1 do
      begin
        LPropertyItem3 := AProperty.Item[j];
        SetPropertyItem2Class(LPropertyItem3);
      end;
    end
    else
    if AProperty.Tag = 2 then //Part
    begin
      if AIsObjClear then
        LICEnginePartItem := AClass.ICEnginePartCollect.Add
      else
        LICEnginePartItem := TICEnginePartItem(AInspector.Items[i].ObjectReference);

      LParentIdx := AProperty.ParentItem.NodeIndex;

      if Assigned(AInspector.Items[LParentIdx].ObjectReference) then
        LICEnginePartItem.ComponentIndex :=
          TICEngineComponentItem(AInspector.Items[LParentIdx].ObjectReference).Index
      else
        LICEnginePartItem.ComponentIndex := -1;
      //컴포넌트 각 Part root Item을 가져옴
      SetInpectorToClassValue(AProperty,LICEnginePartItem);
    end;
  end;
begin
  if AIsObjClear then
  begin
    AClass.ICEngineComponentCollect.Clear;
    AClass.ICEnginePartCollect.Clear;
    AClass.Clear;
  end;

  AClass.CylinderCount := AInspector.items.ItemByName['CylinderCount'].AsInteger;
  AClass.Bore := AInspector.items.ItemByName['Bore'].AsInteger;
  AClass.Stroke := AInspector.items.ItemByName['Stroke'].AsInteger;
  AClass.FuelType := String2FuelType(AInspector.items.ItemByName['FuelType'].AsString);
  AClass.CylinderConfiguration := String2CylinderConfiguration(AInspector.items.ItemByName['CylinderConfiguration'].AsString);
  AClass.RatedSpeed := AInspector.items.ItemByName['MCR'].AsInteger;
  AClass.BMEP := AInspector.items.ItemByName['BMEP'].AsFloat;
  AClass.SFOC := AInspector.items.ItemByName['SFOC'].AsInteger;
  AClass.Frequency := AInspector.items.ItemByName['Frequency'].AsFloat;
  AClass.RatedPower_Engine := AInspector.items.ItemByName['Eng_kW'].AsFloat;
  AClass.RatedPower_Generator := AInspector.items.ItemByName['Gen_kW'].AsFloat;

  AClass.Dimension_A := AInspector.items.ItemByName['A'].AsFloat;
  AClass.Dimension_B := AInspector.items.ItemByName['B'].AsFloat;
  AClass.Dimension_C := AInspector.items.ItemByName['C'].AsFloat;
  AClass.Dimension_D := AInspector.items.ItemByName['D'].AsFloat;

  AClass.EngineWeight := AInspector.items.ItemByName['Engine_Weight'].AsFloat;
  AClass.GensetWeight := AInspector.items.ItemByName['Genset_Weight'].AsFloat;

  AClass.FiringOrdder := AInspector.items.ItemByName['Firing_Order'].AsString;
  AClass.IVO := AInspector.items.ItemByName['IVO'].AsInteger;
  AClass.IVC := AInspector.items.ItemByName['IVC'].AsInteger;
  AClass.EVO := AInspector.items.ItemByName['EVO'].AsInteger;
  AClass.EVC := AInspector.items.ItemByName['EVC'].AsInteger;

//  j := 4;
  LPropertyItem := AInspector.items.ItemByName['FComponents'];
//  k := LPropertyItem.NodeIndex + 1;

  for i := 0 to LPropertyItem.Count - 1 do
  begin
    LPropertyItem2 := LPropertyItem.Item[i];
    SetPropertyItem2Class(LPropertyItem2);

//    LICEnginePartItem.PartName :=
//                            AInspector.Items[i*j+k].Caption;
//    LICEnginePartItem.Maker :=
//                            AInspector.Items[i*j+k+1].AsString;
//    LICEnginePartItem.FFType :=
//                            AInspector.Items[i*j+k+2].AsString;
//    LICEnginePartItem.SerialNo :=
//                            AInspector.Items[i*j+k+3].AsString;
  end;
end;

procedure SetInpectorToClassValue(ANx: TNxPropertyItem; AObj: TICEnginePartItem);
var
  i: integer;
  ctx: TRttiContext;
  rt: TRttiType;
  Prop: TRttiProperty;
  LData: string;
  LValue: TValue;
begin
  ctx := TRttiContext.Create;
  try
    rt := ctx.GetType(AObj.ClassType);
    i := 0;

    for prop in rt.GetProperties do
    begin
      if i < ANx.Count then
      begin
        LData := ANx.Item[i].AsString;
        LValue := prop.GetValue(AObj);
        RttiSetValue(LData, LValue);
        prop.SetValue(AObj,LValue);
        Inc(i);
      end;
    end;
  finally
    ctx.Free;
  end;

  for i := 0 to ANx.Count - 1 do
  begin

  end;
end;

procedure EngineInfoClass2Inspector(AClass: TICEngine;
  AInspector: TNextInspector; AProjIndex: integer; AEvent: TNxItemNotifyEvent;
  AIsAdd2Combo: Boolean);
var
  LStr: string;
  i,j,LNodeIndex,LLastIndex: integer;
  LPropertyItem: TNxPropertyItem;
  LComboItem: TNxComboBoxItem;
  LICEnginePartItem: TICEnginePartItem;
  LICEngineComponentItem: TICEngineComponentItem;
  LStrList: TStringList;
begin
  AInspector.BeginUpdate;
  try
    InitEngineInfoItem(AInspector);

    LStr := AClass.GetEngineType;

    if AIsAdd2Combo then
      TNxComboBoxItem(AInspector.items.ItemByName['SelectEngineCombo']).Lines.Add(LStr);

    LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, 1, 'EngineType', 'Type', LStr);
    AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex, 'CylinderCount', 'Cyl. Count', IntToStr(AClass.CylinderCount));
    LComboItem := TNxComboBoxItem(AddItemsToInspector(AInspector, TNxComboBoxItem, LPropertyItem.NodeIndex, 'CylinderConfiguration', 'Cyl. Config', CylinderConfiguration2String(AClass.CylinderConfiguration)));
    FillCylinderConfiguration2NxCombo(LComboItem);
    AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex, 'Bore', 'Bore', IntToStr(AClass.Bore));
    AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex, 'Stroke', 'Stroke', IntToStr(AClass.Stroke));
    LComboItem := TNxComboBoxItem(AddItemsToInspector(AInspector, TNxComboBoxItem, LPropertyItem.NodeIndex, 'FuelType', 'Fuel Type', FuelType2String(AClass.FuelType)));
    FillFuelType2NxCombo(LComboItem);
    LPropertyItem.Expanded := False;
    LPropertyItem.ReadOnly := True;

    AddItemsToInspector(AInspector, TNxTextItem, 1, 'MCR', 'MCR(rpm)', IntToStr(AClass.RatedSpeed));
    AddItemsToInspector(AInspector, TNxTextItem, 1, 'BMEP', 'BMEP(bar)', FloatToStr(AClass.BMEP));
    AddItemsToInspector(AInspector, TNxTextItem, 1, 'SFOC', 'SFOC(g/kWh)', FloatToStr(AClass.SFOC));
    AddItemsToInspector(AInspector, TNxTextItem, 1, 'Frequency', 'Frequency(Hz)', FloatToStr(AClass.Frequency));
    AddItemsToInspector(AInspector, TNxTextItem, 1, 'Eng_kW', 'Eng.kW', FloatToStr(AClass.RatedPower_Engine));
    LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, 1, 'Gen_kW', 'Gen.kW', FloatToStr(AClass.RatedPower_Generator));

    //Dimension
    LNodeIndex := LPropertyItem.NodeIndex+1;

    if LNodeIndex > -1 then
    begin
      AInspector.Items[LNodeIndex].Clear;
      AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'A', 'A', FloatToStr(AClass.Dimension_A));
      AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'B', 'B', FloatToStr(AClass.Dimension_B));
      AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'C', 'C', FloatToStr(AClass.Dimension_C));
      LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'D', 'D', FloatToStr(AClass.Dimension_D));
    end;

    //Dry Mass
    LNodeIndex := LPropertyItem.NodeIndex+1;

    if LNodeIndex > -1 then
    begin
      AInspector.Items[LNodeIndex].Clear;
      AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'Engine_Weight', 'Engine Weight', FloatToStr(AClass.EngineWeight));
      LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'Genset_Weight', 'Genset Weight', FloatToStr(AClass.GensetWeight));
    end;

    //Cam Profile
    LNodeIndex := LPropertyItem.NodeIndex+1;
    if LNodeIndex > -1 then
    begin
      AInspector.Items[LNodeIndex].Clear;
      AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'Firing_Order', 'Firing Order', AClass.FiringOrdder);
      AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'IVO', 'IVO', FloatToStr(AClass.IVO));
      AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'IVC', 'IVC', FloatToStr(AClass.IVC));
      AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'EVO', 'EVO', FloatToStr(AClass.EVO));
      LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'EVC', 'EVC', FloatToStr(AClass.EVC));
    end;

    //Components
//    LNodeIndex := LPropertyItem.NodeIndex+1;
    LNodeIndex := AInspector.Items.ItemByName['FComponents'].NodeIndex;

    if LNodeIndex > -1 then
    begin
      AInspector.Items[LNodeIndex].Clear;

      for i := 0 to AClass.ICEngineComponentCollect.Count - 1 do
      begin
        LICEngineComponentItem := AClass.ICEngineComponentCollect.Items[i];

        LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'Components'+IntToStr(i),
                          LICEngineComponentItem.ComponentName,'');
        LPropertyItem.Tag := 1; //Component인지 알기 위해 사용됨
        LPropertyItem.ObjectReference := LICEngineComponentItem;
        LICEngineComponentItem.FNxPropertyItem := LPropertyItem;
      end;

      for i := 0 to AClass.ICEnginePartCollect.Count - 1 do
      begin
        LICEnginePartItem := AClass.ICEnginePartCollect.Items[i];

        if LICEnginePartItem.ComponentIndex = -1 then
          LPropertyItem := AddItemsToInspector(AInspector, TNxButtonItem, LNodeIndex, 'Parts'+IntToStr(i),
                          LICEnginePartItem.PartName,'')
        else
        begin
          LICEngineComponentItem := AClass.ICEngineComponentCollect.Items[LICEnginePartItem.ComponentIndex];
          LPropertyItem := AddItemsToInspector(AInspector, TNxButtonItem,
            LICEngineComponentItem.FNxPropertyItem, 'Parts'+IntToStr(i),
            LICEnginePartItem.PartName,'');
        end;

        LPropertyItem.Tag := 2; //Part인지 알기 위해 사용됨
        LPropertyItem.ObjectReference := LICEnginePartItem;
        LICEnginePartItem.FNxPropertyItem := LPropertyItem;
        TNxButtonItem(LPropertyItem).ButtonCaption := '...';
        TNxButtonItem(LPropertyItem).OnButtonClick := AEvent;
        LPropertyItem.Expanded := False;
        AInspector.Items[LPropertyItem.NodeIndex].Clear;

        LStrList := nil;
        LStrList := GetPropertyNameValueList(AClass.ICEnginePartCollect.Items[i]);

        if Assigned(LStrList) then
        begin
          try
            //Default Property가 추가되므로 마지막 4개를 뺌
            //Collection, ID, Index, DisplayName
            for j := 0 to LStrList.Count - 5 do
            begin
              LStr := LStrList.Names[j]; //Property Name List

              AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex,
                                    LStr+IntToStr(LPropertyItem.NodeIndex), LStr,
                                      LStrList.ValueFromIndex[j]);
            end;
          finally
            LStrList.Free;
          end;
        end;
      end;
//      ShowMessage(IntToStr(AClass.ICEnginePartCollect.Count) + ':' + IntToStr(AInspector.Items.ItemByName['FComponents'].Count));
    end;//if LNodeIndex > -1 then
  finally
    AInspector.EndUpdate;
  end;
end;

procedure SetBasicEngineInfoItem(AInspector: TNextInspector);
var
  LStr: string;
  i,LNodeIndex,LLastIndex: integer;
  LPropertyItem: TNxPropertyItem;
  LComboItem: TNxComboBoxItem;
begin
  LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, 1, 'EngineType', 'Type', '');
  AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex, 'CylinderCount', 'Cyl. Count', '');
  LComboItem := TNxComboBoxItem(AddItemsToInspector(AInspector, TNxComboBoxItem, LPropertyItem.NodeIndex, 'CylinderConfiguration', 'Cyl. Config',''));
  FillCylinderConfiguration2NxCombo(LComboItem);
  AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex, 'Bore', 'Bore', '');
  AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex, 'Stroke', 'Stroke', '');
  LComboItem := TNxComboBoxItem(AddItemsToInspector(AInspector, TNxComboBoxItem, LPropertyItem.NodeIndex, 'FuelType', 'Fuel Type', FuelType2String(ftDF)));
  FillFuelType2NxCombo(LComboItem);
  LPropertyItem.Expanded := False;
  LPropertyItem.ReadOnly := True;

  AddItemsToInspector(AInspector, TNxTextItem, 1, 'Speed', 'Speed', '900');
  AddItemsToInspector(AInspector, TNxTextItem, 1, 'SFOC', 'SFOC(g/kWh)', '1.0');
  AddItemsToInspector(AInspector, TNxTextItem, 1, 'Frequency', 'Frequency', '60');
  AddItemsToInspector(AInspector, TNxTextItem, 1, 'Eng_kW', 'Eng.kW', '1000');
  LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, 1, 'Gen_kW', 'Gen.kW', '999');

  //Dimension
  LNodeIndex := LPropertyItem.NodeIndex+1;

  if LNodeIndex > -1 then
  begin
    AInspector.Items[LNodeIndex].Clear;
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'A', 'A', '');
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'B', 'B', '');
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'C', 'C', '');
    LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'D', 'D', '');
  end;

  //Dry Mass
  LNodeIndex := LPropertyItem.NodeIndex+1;

  if LNodeIndex > -1 then
  begin
    AInspector.Items[LNodeIndex].Clear;
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'Engine_Weight', 'Engine Weight', '');
    LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'Genset_Weight', 'Genset Weight', '');
  end;

  //Cam Profile
  LNodeIndex := LPropertyItem.NodeIndex+1;
  if LNodeIndex > -1 then
  begin
    AInspector.Items[LNodeIndex].Clear;
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'Firing_Order', 'Firing Order', '');
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'IVO', 'IVO', '');
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'IVC', 'IVC', '');
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'EVO', 'EVO', '');
    LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'EVC', 'EVC', '');
  end;

  //Components
  LNodeIndex := LPropertyItem.NodeIndex+1;
  if LNodeIndex > -1 then
  begin
    AInspector.Items[LNodeIndex].Clear;
    LPropertyItem := AddItemsToInspector(AInspector, TNxButtonItem, LNodeIndex, 'Components'+IntToStr(i),
                      'PartName','');
    TNxButtonItem(LPropertyItem).ButtonCaption := '...';
    TNxButtonItem(LPropertyItem).OnButtonClick := nil;
    LPropertyItem.Expanded := False;
    AInspector.Items[LPropertyItem.NodeIndex].Clear;
    AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex,
                          'Maker'+IntToStr(LPropertyItem.NodeIndex), 'Maker',
                            '');
    AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex,
                          'Type'+IntToStr(LPropertyItem.NodeIndex), 'Type',
                            '');
    AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex,
                          'Serial_No'+IntToStr(LPropertyItem.NodeIndex), 'Serial No',
                            '');
  end;
end;

procedure InitEngineInfoItem(AInspector: TNextInspector);
var
  LPropertyItem: TNxPropertyItem;
  i: integer;
begin
//  AInspector.Items.Clear;
  //TNxComboBoxItem 를 동적으로 생성하면 화면에 안보이므로 TNxComboBoxItem를 제외한 나머지 Item 삭제
  for i := AInspector.Items.Count - 1 downto 1 do
    AInspector.Items.Delete(i);

//  LPropertyItem := AInspector.Items.AddChild(nil, TNxComboBoxItem, 'Select Engine');
//  LPropertyItem.Name := 'SelectEngineCombo';
//  LPropertyItem.Color := clBlack;
  AInspector.Items.AddChild(nil, TNxTextItem, 'Basic Spec.');
  AInspector.Items.AddChild(nil, TNxTextItem, 'Dimension(mm)');
  AInspector.Items.AddChild(nil, TNxTextItem, 'Dry Mass(ton)');
  AInspector.Items.AddChild(nil, TNxTextItem, 'CAM Profile');
  AInspector.Items.AddChild(nil, TNxTextItem, 'Components').Name := 'FComponents';
  AInspector.Items.AddChild(nil, TNxTextItem, 'IP Address');
end;

procedure EngineInfoInspector2Class_Old(AInspector: TNextInspector;
  AClass: TInternalCombustionEngine);
var
  i,j,k:integer;
begin
  AClass.CylinderCount := AInspector.items.ItemByName['CylinderCount'].AsInteger;
  AClass.Bore := AInspector.items.ItemByName['Bore'].AsInteger;
  AClass.Stroke := AInspector.items.ItemByName['Stroke'].AsInteger;
  AClass.FuelType := String2FuelType(AInspector.items.ItemByName['FuelType'].AsString);
  AClass.CylinderConfiguration := String2CylinderConfiguration(AInspector.items.ItemByName['CylinderConfiguration'].AsString);
  AClass.RatedSpeed := AInspector.items.ItemByName['Speed'].AsInteger;
  AClass.SFOC := AInspector.items.ItemByName['SFOC'].AsInteger;
  AClass.Frequency := AInspector.items.ItemByName['Frequency'].AsFloat;
  AClass.RatedPower_Engine := AInspector.items.ItemByName['Engine.Output'].AsFloat;
  AClass.RatedPower_Generator := AInspector.items.ItemByName['Gen.Output'].AsFloat;

  AClass.Dimension_A := AInspector.items.ItemByName['A'].AsFloat;
  AClass.Dimension_B := AInspector.items.ItemByName['B'].AsFloat;
  AClass.Dimension_C := AInspector.items.ItemByName['C'].AsFloat;
  AClass.Dimension_D := AInspector.items.ItemByName['D'].AsFloat;

  AClass.EngineWeight := AInspector.items.ItemByName['Engine_Weight'].AsFloat;
  AClass.GensetWeight := AInspector.items.ItemByName['Genset_Weight'].AsFloat;

  AClass.FiringOrdder := AInspector.items.ItemByName['Firing_Order'].AsString;
  AClass.IVO := AInspector.items.ItemByName['IVO'].AsInteger;
  AClass.IVC := AInspector.items.ItemByName['IVC'].AsInteger;
  AClass.EVO := AInspector.items.ItemByName['EVO'].AsInteger;
  AClass.EVC := AInspector.items.ItemByName['EVC'].AsInteger;

  j := 4;
  k := AInspector.items.ItemByName['ComponentsNxItem'].NodeIndex + 1;

  for i := 0 to AClass.ICEngineCollect.Count - 1 do
  begin
    AClass.ICEngineCollect.Items[i].PartName :=
                            AInspector.Items[i*j+k].Caption;
    AClass.ICEngineCollect.Items[i].Maker :=
                            AInspector.Items[i*j+k+1].AsString;
    AClass.ICEngineCollect.Items[i].FFType :=
                            AInspector.Items[i*j+k+2].AsString;
    AClass.ICEngineCollect.Items[i].SerialNo :=
                            AInspector.Items[i*j+k+3].AsString;
  end;
end;

procedure EngineInfoClass2Inspector_Old(AClass: TInternalCombustionEngine;
  AInspector: TNextInspector; AProjIndex: integer; AEvent: TNxItemNotifyEvent);
var
  LStr: string;
  i,LNodeIndex,LLastIndex: integer;
  LPropertyItem: TNxPropertyItem;
  LComboItem: TNxComboBoxItem;
begin
  InitEngineInfoItem(AInspector);

  LStr := AClass.GetEngineType(AProjIndex);
  LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, 1, 'EngineType', 'Type', LStr);
  AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex, 'CylinderCount', 'Cyl. Count', IntToStr(AClass.CylinderCount));
  LComboItem := TNxComboBoxItem(AddItemsToInspector(AInspector, TNxComboBoxItem, LPropertyItem.NodeIndex, 'CylinderConfiguration', 'Cyl. Config', CylinderConfiguration2String(AClass.CylinderConfiguration)));
  FillCylinderConfiguration2NxCombo(LComboItem);
  AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex, 'Bore', 'Bore', IntToStr(AClass.Bore));
  AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex, 'Stroke', 'Stroke', IntToStr(AClass.Stroke));
  LComboItem := TNxComboBoxItem(AddItemsToInspector(AInspector, TNxComboBoxItem, LPropertyItem.NodeIndex, 'FuelType', 'Fuel Type', FuelType2String(AClass.FuelType)));
  FillFuelType2NxCombo(LComboItem);
  LPropertyItem.Expanded := False;
  LPropertyItem.ReadOnly := True;

  AddItemsToInspector(AInspector, TNxTextItem, 1, 'Speed', 'Speed', IntToStr(AClass.RatedSpeed));
  AddItemsToInspector(AInspector, TNxTextItem, 1, 'SFOC', 'SFOC(g/kWh)', FloatToStr(AClass.SFOC));
  AddItemsToInspector(AInspector, TNxTextItem, 1, 'Frequency', 'Frequency', FloatToStr(AClass.Frequency));
  AddItemsToInspector(AInspector, TNxTextItem, 1, 'Eng_kW', 'Eng.kW', FloatToStr(AClass.RatedPower_Engine));
  LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, 1, 'Gen_kW', 'Gen.kW', FloatToStr(AClass.RatedPower_Generator));

  //Dimension
  LNodeIndex := LPropertyItem.NodeIndex+1;

  if LNodeIndex > -1 then
  begin
    AInspector.Items[LNodeIndex].Clear;
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'A', 'A', FloatToStr(AClass.Dimension_A));
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'B', 'B', FloatToStr(AClass.Dimension_B));
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'C', 'C', FloatToStr(AClass.Dimension_C));
    LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'D', 'D', FloatToStr(AClass.Dimension_D));
  end;

  //Dry Mass
  LNodeIndex := LPropertyItem.NodeIndex+1;

  if LNodeIndex > -1 then
  begin
    AInspector.Items[LNodeIndex].Clear;
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'Engine_Weight', 'Engine Weight', FloatToStr(AClass.EngineWeight));
    LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'Genset_Weight', 'Genset Weight', FloatToStr(AClass.GensetWeight));
  end;

  //Cam Profile
  LNodeIndex := LPropertyItem.NodeIndex+1;
  if LNodeIndex > -1 then
  begin
    AInspector.Items[LNodeIndex].Clear;
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'Firing_Order', 'Firing Order', AClass.FiringOrdder);
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'IVO', 'IVO', FloatToStr(AClass.IVO));
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'IVC', 'IVC', FloatToStr(AClass.IVC));
    AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'EVO', 'EVO', FloatToStr(AClass.EVO));
    LPropertyItem := AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex, 'EVC', 'EVC', FloatToStr(AClass.EVC));
  end;

  //Components
  LNodeIndex := LPropertyItem.NodeIndex+1;
  if LNodeIndex > -1 then
  begin
    AInspector.Items[LNodeIndex].Clear;

    for i := 0 to AClass.ICEngineCollect.Count - 1 do
    begin
      LPropertyItem := AddItemsToInspector(AInspector, TNxButtonItem, LNodeIndex, 'Components'+IntToStr(i),
                        AClass.ICEngineCollect.Items[i].PartName,'');
      TNxButtonItem(LPropertyItem).ButtonCaption := '...';
      TNxButtonItem(LPropertyItem).OnButtonClick := AEvent;
      LPropertyItem.Expanded := False;
      AInspector.Items[LPropertyItem.NodeIndex].Clear;

      AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex,
                            'Maker'+IntToStr(LPropertyItem.NodeIndex), 'Maker',
                              AClass.ICEngineCollect.Items[i].Maker);
      AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex,
                            'Type'+IntToStr(LPropertyItem.NodeIndex), 'Type',
                              AClass.ICEngineCollect.Items[i].FFType);
      AddItemsToInspector(AInspector, TNxTextItem, LPropertyItem.NodeIndex,
                            'Serial_No'+IntToStr(LPropertyItem.NodeIndex), 'Serial No',
                              AClass.ICEngineCollect.Items[i].SerialNo);
    end;
  end;
end;

procedure AssignOldToNewClass(AOld: TInternalCombustionEngine; ANew: TICEngine);
var
  i: integer;
  LICEnginePartItem: TICEnginePartItem;
begin
  ANew.Bore := AOld.Bore;
  ANew.Stroke := AOld.Stroke;
  ANew.CylinderCount := AOld.CylinderCount;
  ANew.RatedSpeed := AOld.RatedSpeed;
  ANew.RatedPower_Engine := AOld.RatedPower_Engine;
  ANew.RatedPower_Generator := AOld.RatedPower_Generator;
  ANew.Frequency := AOld.Frequency;

  ANew.BMEP := AOld.BMEP;
  ANew.SFOC := AOld.SFOC;
  ANew.IVO := AOld.IVO;
  ANew.IVC := AOld.IVC;
  ANew.EVO := AOld.EVO;
  ANew.EVC := AOld.EVC;

  ANew.CylinderConfiguration := AOld.CylinderConfiguration;
  ANew.FuelType := AOld.FuelType;
  ANew.FiringOrdder := AOld.FiringOrdder;

  ANew.Dimension_A := AOld.Dimension_A;
  ANew.Dimension_B := AOld.Dimension_B;
  ANew.Dimension_C := AOld.Dimension_C;
  ANew.Dimension_D := AOld.Dimension_D;
  ANew.EngineWeight := AOld.EngineWeight;
  ANew.GensetWeight := AOld.GensetWeight;

  ANew.ICEnginePartCollect.Clear;

  for i := 0 to AOld.ICEngineCollect.Count - 1 do
  begin
    LICEnginePartItem := ANew.ICEnginePartCollect.Add;
    LICEnginePartItem.PartName := AOld.ICEngineCollect.Items[i].PartName;
    LICEnginePartItem.Maker := AOld.ICEngineCollect.Items[i].Maker;
    LICEnginePartItem.FFType := AOld.ICEngineCollect.Items[i].FFType;
    LICEnginePartItem.SerialNo := AOld.ICEngineCollect.Items[i].SerialNo;
  end;
end;

function AddNullComponentToInspector(AClass: TICEngine;
    AInspector: TNextInspector; APartName: string; AKind: integer): TNxPropertyItem;
var
  LStrList: TStringList;
  LNodeIndex: integer;
  LICEnginePartItem: TICEnginePartItem;
  LICEngineComponentItem: TICEngineComponentItem;
  LStr, LValue: string;

  procedure AddDefaultProperty;
  var
    j: integer;
  begin
    if Assigned(LStrList) then
    begin
      try
        //Default Property가 추가되므로 마지막 4개를 뺌
        //Collection, ID, Index, DisplayName
        for j := 0 to LStrList.Count - 5 do
        begin
          LStr := LStrList.Names[j]; //Property Name List

          if LStr = 'PartName' then
            LValue := APartName
          else
            LValue := LStrList.ValueFromIndex[j];

          AddItemsToInspector(AInspector, TNxTextItem, Result.NodeIndex,
                                LStr+IntToStr(Result.NodeIndex), LStr, LValue);
        end;
      finally
        LStrList.Free;
      end;
    end;
  end;
begin
  LStrList := nil;
  LNodeIndex := AInspector.SelectedIndex;//AInspector.Items.ItemByName['FComponents'].NodeIndex;

  if LNodeIndex > -1 then
  begin
    if AKind = 0 then //Component인 경우
    begin
      LICEngineComponentItem := AClass.ICEngineComponentCollect.Add;
      Result := AddItemsToInspector(AInspector, TNxTextItem, LNodeIndex,
        'Components'+IntToStr(AClass.ICEngineComponentCollect.Count), APartName,'');
      Result.Tag := 1; //Component인지 알기 위해 사용됨
      LICEngineComponentItem.FNxPropertyItem := Result;
      Result.ObjectReference := LICEngineComponentItem;
//      LStrList := GetPropertyNameValueList(LICEngineComponentItem);
    end
    else
    if AKind = 1 then //Part인 경우
    begin
      LICEnginePartItem := AClass.ICEnginePartCollect.Add;
      Result := AddItemsToInspector(AInspector, TNxButtonItem, LNodeIndex,
        'Parts'+IntToStr(AClass.ICEnginePartCollect.Count), APartName,'');
      Result.Tag := 2; //Part인지 알기 위해 사용됨
      Result.ObjectReference := LICEnginePartItem;
      LICEnginePartItem.FNxPropertyItem := Result;

      if Assigned(AInspector.Items[LNodeIndex].ObjectReference) then
        LICEnginePartItem.ComponentIndex :=
          TICEngineComponentItem(AInspector.Items[LNodeIndex].ObjectReference).Index
      else
        LICEnginePartItem.ComponentIndex := -1;

      LStrList := GetPropertyNameValueList(LICEnginePartItem);
      TNxButtonItem(Result).ButtonCaption := '...';
      AddDefaultProperty;
    end;
  end;
end;

end.
