unit UnitMacroRecorderMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, HotKeyManager,
  Vcl.ComCtrls, JvExComCtrls, JvHotKey, Vcl.Menus, System.Contnrs,//System.Generics.Collections,//
  Vcl.ExtCtrls, Vcl.StdCtrls, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, NxColumns, NxColumnClasses, Vcl.ImgList,
  OtlTask,
  OtlCollections,
  OtlParallel,
  OtlSync,
  OtlComm,
  OtlCommon,
  SynCommons, mORMot, thundax.lib.actions,
  UnitMacroListClass, UnitNextGridFrame, Vcl.Buttons, Vcl.ToolWin, UnitAction;

type
  TMacroManageF = class(TForm)
    HotKeyManager1: THotKeyManager;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Macro1: TMenuItem;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    PopupMenu1: TPopupMenu;
    AddRow1: TMenuItem;
    ImageList1: TImageList;
    NGFrame: TFrame1;
    Execute1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Panel4: TPanel;
    Button3: TButton;
    Splitter2: TSplitter;
    Button1: TButton;
    Label1: TLabel;
    MacroNameEdit: TEdit;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Panel5: TPanel;
    ActionLB: TListBox;
    Panel6: TPanel;
    Button6: TButton;
    btnSequence: TSpeedButton;
    btnStop: TSpeedButton;
    Panel7: TPanel;
    NextGrid2: TNextGrid;
    seq: TNxTextColumn;
    Macroname: TNxTextColumn;
    IsExecute: TNxCheckBoxColumn;
    RepeatCount: TNxTextColumn;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Panel8: TPanel;
    Panel9: TPanel;
    ListBox1: TListBox;
    Edit1: TEdit;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure HotKeyManager1HotKeyPressed(HotKey: Cardinal; Index: Word);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure NGFrameToolButton21Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure NGFramebtnAddRowClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnSequenceClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure NextGrid2SelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure ActionLBDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure IsExecuteSetCell(Sender: TObject; ACol, ARow: Integer;
      CellRect: TRect; CellState: TCellState);
    procedure RepeatCountSetCell(Sender: TObject; ACol, ARow: Integer;
      CellRect: TRect; CellState: TCellState);
    procedure NextGrid2AfterEdit(Sender: TObject; ACol, ARow: Integer;
      Value: WideString);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
  private
    FMacroCancelToken: IOmniCancellationToken;
    FMacroStepQueue    : TOmniMessageQueue;
    FActionStepQueue    : TOmniMessageQueue;
    FMacroStepHandles: array of THandle;
    FMacroStepWaiter : TWaitFor;
    FActionStepHandles: array of THandle;
    FActionStepWaiter : TWaitFor;
    FActionStepEnable,
    FMacroStepEnable: boolean;
    FBreak : Boolean;
    FLBpos: Integer;

    procedure InitHotKey;
    procedure CreateEvents(manualReset: boolean; ANoOfEvent: integer);
    procedure DestroyEvents;
    procedure WaitForAll(AStepWait: TWaitFor; timeout_ms: cardinal; expectedResult: TWaitFor.TWaitForResult;
      const msg: string);
    procedure WaitForAny(AStepWait: TWaitFor; timeout_ms: cardinal; expectedResult: TWaitFor.TWaitForResult;
      const msg: string; checkHandle: integer = -1);

    procedure AddActionFromForm;

    procedure AddMacroTest1;
    procedure AddMacroTest2;
    function IsExistMacroName(AName: string): boolean;

  public
    FWorker  : IOmniParallelLoop<integer>;
    FWorker2  : IOmniParallelLoop<pointer>;
    FfrmActions: TfrmActions;
    FMacroManageList: TMacroManagements;

    procedure ShowMacroManageListCount;
    procedure AssignActionData2Form(ASrcActColl, ADestActColl: TActionCollection;
      var ADestActList: TActionList);

    procedure PlayMacro;
    procedure PlayMacro2;
    procedure _PlaySequence(AIdx: integer);
    procedure PlaySequence(AActionList: TActionList; ATimes: integer);
    procedure StopMacro;

    procedure CreateNewMacro;
    procedure ClearMacro;
    procedure ClearMacroFromGrid;
    procedure AddMacroName(AName: string='');
    procedure DeleteMacroname(AIdx: integer);
    procedure SaveMacroToFile(AFileName: string);
    procedure LoadMacroFromFile(AFileName: string);
    procedure DisplayMacroToGrid(AName: string = '');

    procedure AddMacroItemName(AName: string);
    procedure DeleteMacroItemName(AIdx: integer = -1);
    procedure SelectMacroItem(AIdx: integer);
    procedure SelectMacroCollect(AIdx: integer);
    procedure SelectActionCollect(AIdx: integer);
    procedure GetMsgFromGrid(AIndex: integer; var AMsg: string);
  end;

var
  MacroManageF: TMacroManageF;

implementation

uses UnitNameEdit;

{$R *.dfm}

procedure TMacroManageF.ActionLBDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do
  begin
    if FLBpos = Index then
    begin
      Brush.Color := cllime;
      DrawFocusRect(Rect);
    end;

    FillRect(Rect);
    TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
  end;

end;

procedure TMacroManageF.AddActionFromForm;
var
  LMacroManagement: TMacroManagement;
  LMacroItem: TMacroItem;
  LActionItem: TActionItem;
  i: integer;
begin
  FfrmActions := TfrmActions.Create(nil);
  try
    with FfrmActions do
    begin
      i := NextGrid2.SelectedRow;
      
      if i < 0 then
        exit;
        
      LMacroManagement := FMacroManageList.Items[i] as TMacroManagement;
      AssignActionData2Form(LMacroManagement.ActionCollect,FActionCollection,
        list); 
      ListBox1.Items.Assign(ActionLB.Items);

      if ShowModal = mrOK then
      begin
        AssignActionData2Form(FActionCollection,LMacroManagement.ActionCollect,
          LMacroManagement.FActionList);
//  CopyActionCollect(FActionCollection, LMacroManagement.ActionCollect);
//
//  for i := 0 to FActionCollection.Count - 1 do
//  begin
//    if not Assigned(LMacroManagement.FActionList) then
//      LMacroManagement.FActionList := TActionList.Create;
//            
//    AddAction2List(LMacroManagement.FActionList, FActionCollection.Item[i].ActionItem);
//  end;

//        CopyActionList(LMacroManagement.FActionList);
          
        ActionLB.Clear;
        ActionLB.Items.Assign(ListBox1.Items);
      end;
    end;
  finally
    FreeAndNil(FfrmActions);
  end;
end;

procedure TMacroManageF.AddMacroItemName(AName: string);
begin
  if AName = '' then
    AName := IntToStr(Random(100));

  ListBox1.Items.Add(AName);
end;

procedure TMacroManageF.AddMacroName(AName: string);
var
  LMacroManagement: TMacroManagement;
  LMacroItem: TMacroItem;
  LActionItem: TActionItem;
  LRow: integer;
begin
  if IsExistMacroName(AName) then
  begin
    ShowMessage('동일한 매크로 이름이 존재합니다.');
    exit;
  end
  else
  begin
    if AName = '' then
      AName := 'Noname Macro1';

    LMacroManagement := TMacroManagement.Create;
    LMacroManagement.MacroName := AName;
    LMacroManagement.FActionList := TActionList.Create;
    FMacroManageList.Add(LMacroManagement);
    LRow := NextGrid2.AddRow;
    NextGrid2.CellByName['Macroname', LRow].AsString := AName;
    NextGrid2.CellByName['IsExecute', LRow].AsBoolean := True;
    NextGrid2.CellByName['RepeatCount', LRow].AsInteger := 1;
  end;
end;

procedure TMacroManageF.AddMacroTest1;
var
  LMacroManagements: TMacroManagements;
  LMacroManagement: TMacroManagement;
  LMacroItem: TMacroItem;
  LActionItem: TActionItem;
  LJson: RawUTF8;
  LValid: Boolean;
//  LList: TObjectList;
  LVar: TDocVariantData;
  LP: PUtf8Char;
begin
//  LMacroManagement := TMacroManagement.Create(nil);
//  LMacroManagement.MacroName := 'Test1 Name';
//  LMacroManagement.MacroDesc := 'Test1 Desc';
//  LMacroItem := LMacroManagement.MacroCollect.Add;
//  LMacroItem.ItemName := 'Test1 Item Name';
//  LMacroItem.ItemValue := 'Test1 Item Value';
//  LActionItem := LMacroManagement.ActionCollect.Add;
//  LActionItem.ActionCode := 'Test1 Action Code';
//  LActionItem := LMacroManagement.ActionCollect.Add;
//  LActionItem.ActionCode := 'Test2 Action Code';
//
//  TJSONSerializer.RegisterClassForJSON([TMacroManagement,TActionCollect<TActionItem>, TMacroCollect<TMacroItem>,TActionItem, TMacroItem]);
//  LMacroManagements := TObjectList.Create;
//  LMacroManagements.Add(LMacroManagement);
////  Memo1.Text := ObjectToJSON(LMacroManagement, [woHumanReadable, woObjectListWontStoreClassName]);
//  Memo1.Text := ObjectToJSON(LMacroManagements, [woHumanReadable,woStoreClassName]);
////  TMacroManagement(LMacroManagements.Items[0]).Free;
//  LMacroManagements.Delete(0);
//  LMacroManagements.Extract(LMacroManagement);
//  LMacroManagements.Free;
////  LMacroManagement.Free;
//
////  ObjArraySetLength(LMacroManagements, 1);
////  TJSONSerializer.RegisterObjArrayForJSON([TypeInfo(TMacroManagements), TMacroManagement]);
////  ObjArrayAdd(LMacroManagements, LMacroManagement);
////  Memo1.Text := ObjArrayToJSON(LMacroManagements, [woHumanReadable, woObjectListWontStoreClassName]);
////  ObjArrayClear(LMacroManagements);
////
////  ObjArraySetLength(LMacroManagements, 1);
//  LJson := Memo1.Text;
////  LVar := _Safe(_JSONFast(LJson))^;
//  LMacroManagements := TObjectList.Create;
////  DocVariantToObjArray(LVar, LMacroManagements, TMacroManagement);
//  LP := @LJson[1];
//  JsonToObject(LMacroManagements, LP,LValid, TMacroManagement,[j2oIgnoreUnknownProperty]);
////  LMacroManagements := JsonToNewObject(LP,LValid);
////  LMacroManagement := LMacroManagements[0];
//  ShowMessage(IntToStr(LMacroManagements.Count));
//  LMacroManagements.Free;
////  LMacroManagement := LMacroManagements.Items[0] as TMacroManagement;
////  Memo1.Lines.Clear;
////  Memo1.Lines.Add(LMacroManagement.MacroName);
//
////  AddMacroName(MacroNameEdit.Text);
end;

procedure TMacroManageF.AddMacroTest2;
var
  LMacroManagements: TMacroManagements;
  LMacroManagement: TMacroManagement;
  LMacroItem: TMacros;
  LActionItem: TActions;
  LJson: RawUTF8;
  LValid: Boolean;
  LVar: TDocVariantData;
  LP: PUtf8Char;
begin
  LMacroManagement := TMacroManagement.Create;
  LMacroManagement.MacroName := 'Test1 Name';
  LMacroManagement.MacroDesc := 'Test1 Desc';
//  LMacroItem := LMacroManagement.MacroCollect.Add;
  LMacroItem := LMacroManagement.MacroArrayAdd;
  LMacroItem.MacroItem.ItemName := 'Test1 Item Name';
  LMacroItem.MacroItem.ItemValue := 'Test1 Item Value';
  LActionItem := LMacroManagement.ActionCollect.Add;
  LActionItem.ActionItem.ActionCode := 'Test1 Action Code';
  LActionItem := LMacroManagement.ActionCollect.Add;
  LActionItem.ActionItem.ActionCode := 'Test2 Action Code';

//  TJSONSerializer.RegisterClassForJSON([TMacroManagement,TActions, TMacros,TActionItem, TMacroItem]);
  LMacroManagements := TMacroManagements.Create;
  LMacroManagements.OwnsObjects := True;
  LMacroManagements.Add(LMacroManagement);
//  Memo1.Text := ObjectToJSON(LMacroManagements, [woHumanReadable,woStoreClassName]);
  LMacroManagements.Delete(0);
//  LMacroManagements.Extract(LMacroManagement);
  LMacroManagements.Free;

//  LJson := Memo1.Text;
  LMacroManagements := TMacroManagements.Create;
  LP := @LJson[1];
  JsonToObject(LMacroManagements, LP,LValid, TMacroManagement,[j2oIgnoreUnknownProperty]);
//  Memo2.Text := ObjectToJSON(LMacroManagements, [woHumanReadable,woStoreClassName]);
  LMacroManagements.Free;

//  AddMacroName(MacroNameEdit.Text);
end;

procedure TMacroManageF.AssignActionData2Form(ASrcActColl,
  ADestActColl: TActionCollection; var ADestActList: TActionList);
var
  i: integer;
begin
  if Assigned(ADestActColl) then
  begin
    ADestActColl.Clear;
    CopyActionCollect(ASrcActColl, ADestActColl);
  end;

  for i := 0 to ASrcActColl.Count - 1 do
  begin
    TfrmActions.AddAction2List(ADestActList, ASrcActColl.Item[i].ActionItem);
  end;
end;

procedure TMacroManageF.btnSequenceClick(Sender: TObject);
begin
  PlayMacro;
end;

procedure TMacroManageF.btnStopClick(Sender: TObject);
begin
  StopMacro;
end;

procedure TMacroManageF.Button1Click(Sender: TObject);
begin
  AddMacroName(MacroNameEdit.Text);
//  AddMacroTest2;
end;

procedure TMacroManageF.Button3Click(Sender: TObject);
var
  i: integer;
  LNameEditF: TNameEditF;
  LMacroManagement: TMacroManagement;
begin
  i := NextGrid2.SelectedRow;

  if i < 0 then
    exit;

  LNameEditF := TNameEditF.Create(nil);
  try
    LNameEditF.Edit1.Text := NextGrid2.CellByName['Macroname', i].AsString;

    if LNameEditF.ShowModal = mrOK then
    begin
      LMacroManagement := FMacroManageList.Items[i] as TMacroManagement;
      LMacroManagement.MacroName := LNameEditF.Edit1.Text;
      NextGrid2.CellByName['Macroname', i].AsString := LNameEditF.Edit1.Text;
    end;

  finally
    LNameEditF.Free;
  end;
end;

procedure TMacroManageF.Button6Click(Sender: TObject);
begin
  AddActionFromForm;
end;

procedure TMacroManageF.ClearMacro;
begin
  FMacroManageList.ClearObject;
  ClearMacroFromGrid;
end;

procedure TMacroManageF.ClearMacroFromGrid;
begin
  NextGrid2.ClearRows;
  ListBox1.Clear;
  NGFrame.NextGrid1.ClearRows;
  ActionLB.Clear;
end;

procedure TMacroManageF.CreateEvents(manualReset: boolean; ANoOfEvent: integer);
var
  i: integer;
begin
  SetLength(FMacroStepHandles, ANoOfEvent);
  SetLength(FActionStepHandles, ANoOfEvent);

  for i := Low(FMacroStepHandles) to High(FMacroStepHandles) do
    FMacroStepHandles[i] := CreateEvent(nil, manualReset, false, nil);
  FMacroStepWaiter := TWaitFor.Create(FMacroStepHandles);

  for i := Low(FActionStepHandles) to High(FActionStepHandles) do
    FActionStepHandles[i] := CreateEvent(nil, manualReset, false, nil);
  FActionStepWaiter := TWaitFor.Create(FActionStepHandles);

end;

procedure TMacroManageF.CreateNewMacro;
begin
  if FMacroManageList.Count > 0 then
  begin
    if MessageDlg('Are you sure to create new Macro?', mtConfirmation, mbOKCancel, 0) = mrCancel then
    begin
      exit;
    end;
  end;

  ClearMacro;
  AddMacroName;
end;

procedure TMacroManageF.DeleteMacroItemName(AIdx: integer);
begin
  if ListBox1.ItemIndex >= 0 then
  begin
//    list.Remove(list.Items[ListBox1.ItemIndex]);
//    FActionCollection.Delete(ListBox1.ItemIndex);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
  end;
end;

procedure TMacroManageF.DeleteMacroname(AIdx: integer);
var
  LMacroManagement: TMacroManagement;
begin
  if MessageDlg('Are you sure to delete selected Macro?', mtConfirmation, mbOKCancel, 0) = mrOK then 
  begin
    LMacroManagement := FMacroManageList.Items[AIdx] as TMacroManagement;
//    LMacroManagement.MacroCollect.Free;
//    LMacroManagement.ActionCollect.Free;
    LMacroManagement.FActionList.Free;
    FMacroManageList.Delete(AIdx);
//    LMacroManagement.Free;
    NextGrid2.DeleteRow(AIdx);
    NGFrame.NextGrid1.ClearRows;
    ActionLB.Items.Clear;
  end;
end;

procedure TMacroManageF.DestroyEvents;
var
  i: integer;
begin
  FreeAndNil(FMacroStepWaiter);
  FreeAndNil(FActionStepWaiter);

  for i := Low(FMacroStepHandles) to High(FMacroStepHandles) do
    if FMacroStepHandles[i] <> 0 then
      Win32Check(CloseHandle(FMacroStepHandles[i]));

  for i := Low(FActionStepHandles) to High(FActionStepHandles) do
    if FActionStepHandles[i] <> 0 then
      Win32Check(CloseHandle(FActionStepHandles[i]));
end;

procedure TMacroManageF.DisplayMacroToGrid(AName: string);
var
  i, LRow: integer;
  LMacroManagement: TMacroManagement;
begin
  NextGrid2.BeginUpdate;
  try
    NextGrid2.ClearRows;
    NGFrame.NextGrid1.ClearRows;
    ActionLB.Items.Clear;

    for i := 0 to FMacroManageList.Count - 1 do
    begin
      LMacroManagement := FMacroManageList.Items[i] as TMacroManagement;
      LRow := NextGrid2.AddRow;
      NextGrid2.CellByName['Macroname', LRow].AsString := LMacroManagement.MacroName;
      NextGrid2.CellByName['IsExecute', LRow].AsBoolean := LMacroManagement.IsExecute;
      NextGrid2.CellByName['RepeatCount', LRow].AsInteger := LMacroManagement.IterateCount;
      AssignActionData2Form(LMacroManagement.ActionCollect,nil,
        LMacroManagement.FActionList); 
    end;
  finally
    NextGrid2.EndUpdate;
  end;
end;

procedure TMacroManageF.IsExecuteSetCell(Sender: TObject; ACol, ARow: Integer;
  CellRect: TRect; CellState: TCellState);
var
  LMacroManagement: TMacroManagement;
begin
  LMacroManagement := FMacroManageList.Items[ARow] as TMacroManagement;
  LMacroManagement.IsExecute := NextGrid2.CellByName['IsExecute', ARow].AsBoolean;
end;

procedure TMacroManageF.FormCreate(Sender: TObject);
begin
  InitHotKey;
  FMacroStepQueue := TOmniMessageQueue.Create(1);
  FActionStepQueue := TOmniMessageQueue.Create(1);
  CreateEvents(False, 2); //0: Macro Step, 1: Action Step
  FMacroManageList := TMacroManagements.Create;
  FMacroManageList.OwnsObjects := True;
  TJSONSerializer.RegisterClassForJSON([TMacroManagement, TActions, TMacros, TActionItem, TMacroItem]);
  g_DynGetMessage := GetMsgFromGrid;
end;

procedure TMacroManageF.FormDestroy(Sender: TObject);
begin
  FMacroManageList.ClearObject;
  FMacroManageList.Free;

  FreeAndNil(FMacroStepQueue);
  FreeAndNil(FActionStepQueue);
  DestroyEvents;
end;

procedure TMacroManageF.GetMsgFromGrid(AIndex: integer; var AMsg: string);
begin
  if AIndex > 0  then
  begin
    Dec(AIndex);
    AMsg := NGFrame.NextGrid1.CellByName['Value', AIndex].AsString;
  end;
end;

procedure TMacroManageF.HotKeyManager1HotKeyPressed(HotKey: Cardinal; Index: Word);
var
  s: string;
  LMsg: TOmniMessage;
begin
  s := HotKeyManager1.GetCommand(Index);

  if s = MACRO_MOUSE_POS then
  begin
    if Assigned(FfrmActions) then
    begin
      if FfrmActions.FCurrentActionType = tMousePos then
      begin
        FfrmActions.FIsUpdateMousePos := not FfrmActions.FIsUpdateMousePos;
//        ShowMessage('FIsUpdateMousePos is ' + BoolToStr(FfrmActions.FIsUpdateMousePos));
      end;
    end;
  end
  else
  if s = MACRO_START then
  begin

  end
  else
  if s = MACRO_ONE_STEP then
  begin
    WinApi.Windows.PulseEvent(FActionStepHandles[0]);

    if FActionStepEnable then
    begin
      LMsg.MsgID := 1;
      LMSg.MsgData.AsInteger := 1;
      FActionStepQueue.Enqueue(TOmniMessage.Create(LMsg.MsgID, LMsg.MsgData));
    end;
  end
  else
  if s = MACRO_STOP then
  begin
    StopMacro;
  end;
end;

procedure TMacroManageF.InitHotKey;
var
  HotKeyVar: Cardinal;
  Modifiers: Word;
begin
  //Ctrl + Alt + F5 = Macro Start
  HotKeyVar := HotKeyManager.GetHotKey(MOD_CONTROL + MOD_ALT, VK_F5);
  HotKeyManager1.AddHotKey(HotKeyVar, MACRO_START);

  //Ctrl + Alt + F6 = Macro Start One-Step
  HotKeyVar := HotKeyManager.GetHotKey(MOD_CONTROL + MOD_ALT, VK_F6);
  HotKeyManager1.AddHotKey(HotKeyVar, MACRO_ONE_STEP);

  //Ctrl + Alt + F7 = Macro Stop
  HotKeyVar := HotKeyManager.GetHotKey(MOD_CONTROL + MOD_ALT, VK_F7);
  HotKeyManager1.AddHotKey(HotKeyVar, MACRO_STOP);

  //Ctrl + Space = Mouse Move Update Stop
  HotKeyVar := HotKeyManager.GetHotKey(MOD_CONTROL, VK_SPACE);
  HotKeyManager1.AddHotKey(HotKeyVar, MACRO_MOUSE_POS);
end;

function TMacroManageF.IsExistMacroName(AName: string): boolean;
var
  i: integer;
  LMacroManagement: TMacroManagement;
begin
  Result := False;

  if AName = '' then
    exit;
    
  for i := 0 to FMacroManageList.Count - 1 do
  begin
    LMacroManagement := FMacroManageList.Items[i] as TMacroManagement;

    if LMacroManagement.MacroName = AName then
    begin
      Result := True;
      break;
    end;
  end;
end;

procedure TMacroManageF.LoadMacroFromFile(AFileName: string);
begin
  if AFileName = '' then
    exit;

  FMacroManageList.LoadFromJSONFile(AFileName);
end;

procedure TMacroManageF.NextGrid2AfterEdit(Sender: TObject; ACol, ARow: Integer;
  Value: WideString);
begin
;
end;

procedure TMacroManageF.NextGrid2SelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  Idx: integer;
begin
  Idx := NextGrid2.SelectedRow;

  if Idx >= 0 then
    SelectMacroItem(idx);
end;

procedure TMacroManageF.NGFramebtnAddRowClick(Sender: TObject);
begin
  if NextGrid2.SelectedRow < 0 then
  begin
    ShowMessage('Select Macro Name first!');
    exit;
  end;

  NGFrame.btnAddRowClick(Sender);
  NGFrame.NextGrid1.EditCell(0, NGFrame.NextGrid1.LastAddedRow);
end;

procedure TMacroManageF.NGFrameToolButton21Click(Sender: TObject);
var
  i, j, LRow: integer;
  LMacroManagement: TMacroManagement;
  LMacros: TMacros;
  LActions: TActions;
begin
  j := NextGrid2.SelectedRow;

  if j < 0 then
    exit
  else
  begin
    LMacroManagement := FMacroManageList.Items[j] as TMacroManagement;
//    LMacroManagement.MacroCollect.Clear;
  end;

  for i := 0 to NGFrame.NextGrid1.RowCount - 1 do
  begin
//    LMacros := LMacroManagement.MacroCollect.Add;
    LMacros.MacroItem.ItemName := NGFrame.NextGrid1.CellByName['Itemname', i].AsString;
    LMacros.MacroItem.ItemValue := NGFrame.NextGrid1.CellByName['Value', i].AsString;
  end;
end;

procedure TMacroManageF.PlayMacro;
var
  LActionList: TActionList;
  LMsg: TOmniMessage;
  Li, LTimes: integer;
begin
  btnSequence.Enabled := false;
  FMacroCancelToken := CreateOmniCancellationToken;
  FWorker := Parallel.ForEach(0,FMacroManageList.Count-1)
    .CancelWith(FMacroCancelToken)
    .NumTasks(1)
    .PreserveOrder
    .NoWait
    .OnStop(
      procedure (const task: IOmniTask)
      begin
        // because of NoWait, OnStop delegate is invoked from the worker code; we must not destroy the worker at that point or the program will block
        task.Invoke(
          procedure begin
            btnSequence.Enabled := true;
            ShowMessage('Macro Stopped!');
          end
        );
      end
    );

  FWorker.Execute(
    procedure (const task: IOmniTask; const i: integer)
    var
      Li: integer;
    begin
      if TMacroManagement(FMacroManageList.Items[i]).IsExecute then
      begin
        LActionList := TMacroManagement(FMacroManageList.Items[i]).FActionList;
        LTimes := TMacroManagement(FMacroManageList.Items[i]).IterateCount;
        ShowMessage(TMacroManagement(FMacroManageList.Items[i]).MacroName+':'+IntToStr(i));
        if Assigned(LActionList) then
          PlaySequence(LActionList,LTimes);

        if FMacroStepQueue.TryDequeue(LMsg) then
        begin
          if LMsg.MsgData.AsInteger = 1 then //0: No Step, 1: Macro Step
            WaitForAny(FMacroStepWaiter, 10000, waAwaited, '');
        end;
      end;
    end
  );
end;

procedure TMacroManageF.PlayMacro2;
var
  LActionList: TActionList;
  LMsg: TOmniMessage;
  Li, LTimes: integer;
begin
//  btnSequence.Enabled := false;
//  FMacroCancelToken := CreateOmniCancellationToken;
//  FWorker2 := Parallel.ForEach<pointer>(FMacroManageList.GetEnumerator)
//    .CancelWith(FMacroCancelToken)
//    .NoWait
//    .OnStop(
//      procedure (const task: IOmniTask)
//      begin
//        task.Invoke(
//          procedure begin
//            btnSequence.Enabled := true;
//            ShowMessage('Macro Stopped!');
//          end
//        );
//      end
//    );
//
//  FWorker2.Execute(
//    procedure (const task: IOmniTask; const AObj: pointer)
//    var
//      Li: integer;
//    begin
//      if TMacroManagement(AObj).IsExecute then
//      begin
//        LActionList := TMacroManagement(AObj).FActionList;
//        LTimes := TMacroManagement(AObj).IterateCount;
//        ShowMessage(TMacroManagement(AObj).MacroName+':'+IntToStr(i));
//        if Assigned(LActionList) then
//          PlaySequence(LActionList,LTimes);
//
//        if FMacroStepQueue.TryDequeue(LMsg) then
//        begin
//          if LMsg.MsgData.AsInteger = 1 then //0: No Step, 1: Macro Step
//            WaitForAny(FMacroStepWaiter, 10000, waAwaited, '');
//        end;
//      end;
//    end
//  );
end;

procedure TMacroManageF.PlaySequence(AActionList: TActionList; ATimes: integer);
var
  i, j: Integer;
  action: IAction;
  LMsg: TOmniMessage;
  LIsStep: Boolean;
begin
  LIsStep := False;

  if ATimes > 0 then
  begin
    for j := 0 to ATimes - 1 do
    begin
      for i := 0 to AActionList.Count - 1 do
      begin
        FLBpos := i;

        if (LIsStep) and (action.GetActionType = TWait) then
            continue;

        action := AActionList.Items[i];
        action.Execute;
        Sleep(200);
//        ListBox1.SetFocus;
//        Application.ProcessMessages;
        if FBreak then
          break;

        if FActionStepQueue.TryDequeue(LMsg) then
        begin
          LIsStep := LMsg.MsgData.AsInteger = 1;//0: No Step, 1: Action Step

          if LIsStep then
          begin
            WaitForAny(FActionStepWaiter, 10000, waAwaited, '');
          end;
        end;
      end;
      if FBreak then
        break;
    end;
  end
  else
  begin
    i := 0;
    while not FBreak do
    begin
      FLBpos := i;
      action := AActionList.Items[i];
      action.Execute;
      Sleep(200);
//      ListBox1.SetFocus;
//      Application.ProcessMessages;
      Sleep(200);
      inc(i);
//      if (i > (ListBox1.Items.Count - 1)) then
//        i := 0;
    end;
  end;
end;

procedure TMacroManageF.RepeatCountSetCell(Sender: TObject; ACol, ARow: Integer;
  CellRect: TRect; CellState: TCellState);
var
  LMacroManagement: TMacroManagement;
begin
  LMacroManagement := FMacroManageList.Items[ARow] as TMacroManagement;
  LMacroManagement.IterateCount := NextGrid2.CellByName['RepeatCount', ARow].AsInteger;
end;

procedure TMacroManageF.SaveMacroToFile(AFileName: string);
var
  LJson: RawUTF8;
begin
  if AFileName = '' then
    exit;

//  LJson := ObjectToJSON(FMacroManageList, [woHumanReadable,woStoreClassName]);
  FMacroManageList.SaveToJSONFile(AFileName);
end;

procedure TMacroManageF.SelectActionCollect(AIdx: integer);
var
  j: integer;
  LMacroManagement: TMacroManagement;
begin
  ActionLB.Items.BeginUpdate;
  try
    ActionLB.Items.Clear;

    LMacroManagement := FMacroManageList.Items[AIdx] as TMacroManagement;

    for j := 0 to LMacroManagement.ActionCollect.Count - 1 do
    begin
      ActionLB.Items.Add(LMacroManagement.ActionCollect.Item[j].ActionItem.ActionDesc);
    end;
  finally
    ActionLB.Items.EndUpdate;
  end;
end;

procedure TMacroManageF.SelectMacroCollect(AIdx: integer);
var
  j, LRow: integer;
  LMacroManagement: TMacroManagement;
begin
  NGFrame.NextGrid1.BeginUpdate;
  try
    NGFrame.NextGrid1.ClearRows;

    LMacroManagement := FMacroManageList.Items[AIdx] as TMacroManagement;

//    for j := 0 to LMacroManagement.MacroCollect.Count - 1 do
//    begin
//      LRow := NGFrame.NextGrid1.AddRow;
//      NGFrame.NextGrid1.CellByName['Itemname',LRow].AsString := LMacroManagement.MacroCollect.Item[j].MacroItem.ItemName;
//      NGFrame.NextGrid1.CellByName['Value',LRow].AsString := LMacroManagement.MacroCollect.Item[j].MacroItem.ItemValue;
//    end;
  finally
    NGFrame.NextGrid1.EndUpdate;
  end;
end;

procedure TMacroManageF.SelectMacroItem(AIdx: integer);
begin
  SelectMacroCollect(AIdx);
  SelectActionCollect(AIdx);
end;

procedure TMacroManageF.ShowMacroManageListCount;
begin
  ShowMessage(IntToStr(FMacroManageList.Count));
end;

procedure TMacroManageF.SpeedButton1Click(Sender: TObject);
var
  LMsg: TOmniMessage;
begin
  LMsg.MsgID := 1;
  LMSg.MsgData.AsInteger := 1;
  FMacroStepQueue.Enqueue(TOmniMessage.Create(LMsg.MsgID, LMsg.MsgData));
end;

procedure TMacroManageF.SpeedButton2Click(Sender: TObject);
var
  LMsg: TOmniMessage;
begin
  LMsg.MsgID := 1;
  LMSg.MsgData.AsInteger := 1;
  FActionStepQueue.Enqueue(TOmniMessage.Create(LMsg.MsgID, LMsg.MsgData));
  FActionStepEnable := True;
end;

procedure TMacroManageF.SpeedButton3Click(Sender: TObject);
begin
  if FMacroManageList.Count > 0 then
  begin
    if MessageDlg('Are you sure to load Macro from file?', mtConfirmation, mbOKCancel, 0) = mrCancel then
    begin
      exit;
    end;
  end;

  if OpenDialog1.Execute(Handle) then
  begin
    LoadMacroFromFile(OpenDialog1.FileName);
    DisplayMacroToGrid;
  end;
end;

procedure TMacroManageF.SpeedButton4Click(Sender: TObject);
begin
  if SaveDialog1.Execute(Handle) then
    SaveMacroToFile(SaveDialog1.FileName);
end;

procedure TMacroManageF.SpeedButton5Click(Sender: TObject);
begin
  DeleteMacroname(NextGrid2.SelectedRow);
end;

procedure TMacroManageF.SpeedButton6Click(Sender: TObject);
begin
  AddMacroItemName(Edit1.Text);
end;

procedure TMacroManageF.SpeedButton7Click(Sender: TObject);
begin
  DeleteMacroItemName;
end;

procedure TMacroManageF.SpeedButton8Click(Sender: TObject);
begin
  CreateNewMacro;
end;

procedure TMacroManageF.StopMacro;
begin
  FBreak := true;
  FMacroCancelToken.Signal;
end;

procedure TMacroManageF.ToolButton1Click(Sender: TObject);
var
  i: integer;
begin
  if NextGrid2.SelectedCount > 0 then
  begin
    if NextGrid2.SelectedCount = 1 then
    begin
      if NextGrid2.SelectedRow > 0 then
      begin
        FMacroManageList.Move(NextGrid2.SelectedRow, NextGrid2.SelectedRow - 1);
        NextGrid2.MoveRow(NextGrid2.SelectedRow, NextGrid2.SelectedRow - 1);
        NextGrid2.SelectedRow := NextGrid2.SelectedRow - 1;
      end;
    end
    else
    begin
      for i := 1 to NextGrid2.RowCount - 1 do
      begin
        if NextGrid2.Selected[i] then
        begin
          NextGrid2.MoveRow(i, i - 1);
          NextGrid2.Selected[i] := False;
          NextGrid2.Selected[i-1] := True;
        end;
      end;
    end;
  end;
end;

procedure TMacroManageF.ToolButton2Click(Sender: TObject);
var
  CurrIndex, LastIndex: Integer;
begin
  CurrIndex := NextGrid2.SelectedRow;
  LastIndex := NextGrid2.RowCount;

  if CurrIndex + 1 < LastIndex then
  begin
    FMacroManageList.Move(CurrIndex, CurrIndex + 1);
    NextGrid2.MoveRow(CurrIndex, CurrIndex + 1);
    NextGrid2.SelectedRow := CurrIndex + 1;
  end;
end;

procedure TMacroManageF.WaitForAll(AStepWait: TWaitFor; timeout_ms: cardinal;
  expectedResult: TWaitFor.TWaitForResult; const msg: string);
begin
  if AStepWait.WaitAll(timeout_ms) <> expectedResult then
    raise Exception.Create('WaitAll returned unexpected result');
end;

procedure TMacroManageF.WaitForAny(AStepWait: TWaitFor; timeout_ms: cardinal;
  expectedResult: TWaitFor.TWaitForResult; const msg: string;
  checkHandle: integer);
begin
  if AStepWait.WaitAny(timeout_ms) = expectedResult then begin
    if (checkHandle >= 0) and
       ((Length(AStepWait.Signalled) <> 1) or
        (AStepWait.Signalled[0].Index <> checkHandle))
    then
      raise Exception.Create('WaitAny returned unexpected handle number');
  end
  else
    raise Exception.Create('WaitAny returned unexpected result');
end;

procedure TMacroManageF._PlaySequence(AIdx: integer);
var
  LActionList: TActionList;
begin
  LActionList := TMacroManagement(FMacroManageList.Items[AIdx]).FActionList;

  if Assigned(LActionList) then
    PlaySequence(LActionList,TMacroManagement(FMacroManageList.Items[AIdx]).IterateCount);
end;

end.
