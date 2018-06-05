unit UnitMAPSMacro;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,// Vcl.Dialogs,
  thundax.lib.actions, UnitMacroRecorderMain,
  UnitMacroListClass;

const
  QTN_INPUT_MACRO_FILE_NAME = '.\Macro\QTN_Input.macro';
  QTN_INPUT_COMPAMYCODE_MACRO_FILE_NAME = '.\Macro\QTN_Input_CompanyCode.macro';

procedure QTN_Input;
procedure QTN_Input_CompanyCode(ADoc: variant);
procedure Key_Input_CompanyCode(ACompanyCode: string);
procedure Key_Input_RFQ(ARFQ: string);
procedure Sel_CurrencyKind(AKind: integer);
procedure QTN_Key_Input_Content(AContent: string);
procedure Sel_DeliveryCondition(ADeliveryCondition: integer);
procedure Sel_EstimateType(AEstimateType: integer);
procedure Sel_TermsOfPayment(ATermsOfPayment: integer);

procedure Macro_MouseMove(Ax, Ay: integer);
procedure Macro_MouseLClick;

var
  g_MacroManageF: TMacroManageF;

implementation

uses Clipbrd;

procedure QTN_Input;
var
  LActionList: TActionList;
  i: integer;
begin
  if not FileExists(QTN_INPUT_MACRO_FILE_NAME) then
    exit;

  if Assigned(g_MacroManageF) then
    g_MacroManageF.Free;

  g_MacroManageF := TMacroManageF.Create(nil);
  try
    g_MacroManageF.LoadMacroFromFile(QTN_INPUT_MACRO_FILE_NAME);

    for i := 0 to g_MacroManageF.FMacroManageList.Count - 1 do
    begin
      g_MacroManageF.AssignActionData2Form(
        TMacroManagement(g_MacroManageF.FMacroManageList.Items[i]).ActionCollect,
        nil,
        TMacroManagement(g_MacroManageF.FMacroManageList.Items[i]).FActionList);
    end;

    g_MacroManageF.PlayMacro;
  finally

  end;
end;

procedure QTN_Input_CompanyCode(ADoc: variant);
var
  LMacroManageF: TMacroManageF;
begin
  if not FileExists(QTN_INPUT_COMPAMYCODE_MACRO_FILE_NAME) then
    exit;

  LMacroManageF := TMacroManageF.Create(nil);
  try
    LMacroManageF.LoadMacroFromFile(QTN_INPUT_COMPAMYCODE_MACRO_FILE_NAME);
    LMacroManageF.PlayMacro;
  finally
    LMacroManageF.Free;
  end;
end;

procedure Key_Input_CompanyCode(ACompanyCode: string);
var
  LAction: IAction;
begin
  LAction := TAction<String>.Create(TMessage, TParameters<String>.Create(ACompanyCode, ''), '');
  try
    LAction.Execute;
  finally
    LAction := nil;
  end;
end;

procedure Key_Input_RFQ(ARFQ: string);
var
  LAction: IAction;
begin
  LAction := TAction<String>.Create(TMessage, TParameters<String>.Create(ARFQ, ''), '');
  try
    LAction.Execute;
  finally
    LAction := nil;
  end;
end;

procedure Sel_CurrencyKind(AKind: integer);
var
  LAction: IAction;
  i: integer;
begin
  for i := 0 to AKind do
  begin
    LAction := TAction<String>.Create(TKey, TParameters<String>.Create('DOWN', ''), '');
    try
      LAction.Execute;
      Sleep(500);
    finally
      LAction := nil;
    end;
  end;

  LAction := TAction<String>.Create(TKey, TParameters<String>.Create('RETURN', ''), '');
  try
    LAction.Execute;
      Sleep(200);
  finally
    LAction := nil;
  end;
end;

procedure QTN_Key_Input_Content(AContent: string);
begin
  Clipboard.AsText := AContent;
  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(Ord('V'), 0, 0, 0);
  keybd_event(Ord('V'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
end;

procedure Sel_DeliveryCondition(ADeliveryCondition: integer);
var
  LAction: IAction;
  i: integer;
begin
  for i := 0 to ADeliveryCondition do
  begin
    LAction := TAction<String>.Create(TKey, TParameters<String>.Create('DOWN', ''), '');
    try
      LAction.Execute;
      Sleep(500);
    finally
      LAction := nil;
    end;
  end;

  LAction := TAction<String>.Create(TKey, TParameters<String>.Create('RETURN', ''), '');
  try
    LAction.Execute;
      Sleep(200);
  finally
    LAction := nil;
  end;
end;

procedure Sel_EstimateType(AEstimateType: integer);
var
  LAction: IAction;
  i: integer;
begin
  for i := 0 to AEstimateType do
  begin
    LAction := TAction<String>.Create(TKey, TParameters<String>.Create('DOWN', ''), '');
    try
      LAction.Execute;
      Sleep(500);
    finally
      LAction := nil;
    end;
  end;

  LAction := TAction<String>.Create(TKey, TParameters<String>.Create('RETURN', ''), '');
  try
    LAction.Execute;
      Sleep(200);
  finally
    LAction := nil;
  end;
end;

procedure Sel_TermsOfPayment(ATermsOfPayment: integer);
var
  LAction: IAction;
  i: integer;
begin
  for i := 0 to ATermsOfPayment do
  begin
    LAction := TAction<String>.Create(TKey, TParameters<String>.Create('DOWN', ''), '');
    try
      LAction.Execute;
      Sleep(500);
    finally
      LAction := nil;
    end;
  end;

  LAction := TAction<String>.Create(TKey, TParameters<String>.Create('RETURN', ''), '');
  try
    LAction.Execute;
      Sleep(200);
  finally
    LAction := nil;
  end;
end;

procedure Macro_MouseMove(Ax, Ay: integer);
var
  LAction: IAction;
begin
  LAction := TAction<Integer>.Create(tMousePos, TParameters<Integer>.Create(Ax, Ay), '');
  try
    LAction.Execute;
    Sleep(200);
  finally
    LAction := nil;
  end;
end;

procedure Macro_MouseLClick;
var
  LAction: IAction;
begin
  LAction := TAction<String>.Create(TMouseLClick, TParameters<String>.Create('', ''), '');
  try
    LAction.Execute;
    Sleep(200);
  finally
    LAction := nil;
  end;
end;

initialization

finalization
  if Assigned(g_MacroManageF) then
    g_MacroManageF.Free;

end.
