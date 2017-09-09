unit uTranslate;

{-------------------------------------------------------------------------------
POPTRAYU
Copyright (C) 2001-2005  Renier Crause
Copyright (C) 2012 Jessica Brown
All Rights Reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

The GNU GPL can be found at:
  http://www.gnu.org/copyleft/gpl.html
-------------------------------------------------------------------------------}

{$DEFINE TRANSLATE_DEBUG}

interface
uses
  Forms, Dialogs, StdCtrls, Vcl.Controls, System.Classes, Vcl.ComCtrls,
  Vcl.ActnPopup, Vcl.Menus;

type
  TLangDirection = (ToEnglish,FromEnglish);

  // translation
  function TranslateDir(st : string; LangDirection : TLangDirection) : string;
  procedure TranslateComponent(component : TComponent);
  procedure TranslateComponentDir(component : TComponent; LangDirection : TLangDirection);
  procedure ReadTranslateStrings;
  procedure SetProp(obj : TObject; PropName : string; ToEnglish : boolean=False);
  procedure GetLanguages;
  procedure RefreshLanguages;
  function TranslateToEnglish(phrase: string): string;
  function Translate(english: string): string;
  procedure TranslateTreeNode(node : TTreeNode; lastLanguage : Integer);
  procedure TranslateForm(form : TForm);
  function TranslateMsg(const Msg: string; DlgType: TMsgDlgType;
    Buttons: TMsgDlgButtons; HelpCtx: Integer) : TForm;
  function ShowTranslatedDlg(const Msg: string; DlgType: TMsgDlgType;
    Buttons: TMsgDlgButtons; HelpCtx: Integer;
    DialogCaption : string = '' ): Integer;
  procedure ChangeComboBoxListItem(cmb : TComboBox; item : integer; st : string);
  procedure SetWinControlBiDi(Control: TWinControl);
  procedure SetPreviousLanguage(const oldlang : integer);
  procedure TranslateComponentFromEnglish(component : TComponent);
  procedure TranslateComponentToEnglish(component : TComponent);
  procedure TranslateTMenuItem(menuItem : TMenuItem; const LangDirection : TLangDirection; const recursive : boolean = true);
//  function ShowCustomOkCancelDialog(const DlgTitle : String; const DlgMsg : String; DlgType: TMsgDlgType;
//    HelpCtx: Integer; Button1Caption : String; Button2Caption : String): Integer;
  function ShowVistaConfirmDialog(DlgTitle: string; DlgHeading: string;
    DlgMsg: string; YesBtnCaption:string; NoBtnCaption: string): integer;

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------
implementation

uses
  uGlobal, sysutils, StrUtils,
  Windows, uMain, uFrameDefaults, uDM, uRCUtils, TypInfo, Vcl.Buttons,
  uTranslateDebugWindow, Math, SynTaskDialog;
const
  WS_EX_NOINHERITLAYOUT = $00100000; // Disable inheritence of mirroring by children
  WS_EX_LAYOUTRTL = $00400000; // Right to left mirroring

  LANGUAGE_UNDEFINED = -1;
  LANGUAGE_ENGLISH = 0;

var
  FTranslateStrings : TStringList;
  FLastLanguage : integer;
  {$IFDEF TRANSLATE_DEBUG}
  DebugOutputWindow : TTranslateDebugWindow;
  {$ENDIF}


procedure SetPreviousLanguage(const oldlang : integer);
var
  i : integer;
begin
  FLastLanguage := oldlang;

  // this isn't the ideal place to put translating the language names. but since
  // they don't have a .tag field, this is the easist place to do it.
  if (oldlang <> 0) then
  for i := 0 to Length(Options.Languages)-1 do
    Options.Languages[i] := TranslateDir(Options.Languages[i],ToEnglish);

  if (oldlang <> Options.Language) then
  for i := 0 to Length(Options.Languages)-1 do
    Options.Languages[i] := TranslateDir(Options.Languages[i],FromEnglish);
end;

procedure SetWinControlBiDi(Control: TWinControl);
var
  ExStyle: Longint;
begin
  ExStyle := GetWindowLong(Control.Handle, GWL_EXSTYLE);
  SetWindowLong(Control.Handle, GWL_EXSTYLE, ExStyle or WS_EX_RTLREADING or WS_EX_RIGHT
    or WS_EX_LAYOUTRTL or WS_EX_NOINHERITLAYOUT );
end;


procedure ReadTranslateStrings;
var
  fname : string;
  i : integer;
  newLang : string;
begin
  if Options.Language <> -1 then
  begin
    if not assigned(FTranslateStrings) then
      FTranslateStrings := TStringList.Create;
    newLang := TranslateToEnglish(Options.Languages[Options.Language]);
    fname := ExtractFilePath(Application.ExeName)+'languages\'+
             newLang +'.ptlang';
    if FileExists(fname) then
    begin
      FTranslateStrings.LoadFromFile(fname); //use current ANSI codepage OR utf8

      // strip comments
      i := 0;
      while i <= FTranslateStrings.Count-1 do
      begin
        if (Copy(Trim(FTranslateStrings[i]),1,1)='#') or (Pos('=',FTranslateStrings[i]) = 0) then
          FTranslateStrings.Delete(i)
        else
          Inc(i);
      end;

      if (AnsiCompareStr(newLang, 'Hebrew') = 0) or
         (AnsiCompareStr(newLang, 'Arabic') = 0) then
      begin
        Application.BiDiMode := bdRightToLeft;
      end else begin
        Application.BiDiMode := bdLeftToRight;
      end;
    end;
  end;
end;


function Translate(english: string): string;
var
  lookup : string;
  {$IFDEF TRANSLATE_DEBUG}
  origEnglish : string;
  {$ENDIF}
begin
  // if english then do nothing
  if Options.Language = 0 then
    Result := english
  else begin
    {$IFDEF TRANSLATE_DEBUG}
    origEnglish := english;
    {$ENDIF}
    // otherwise translate it
    if not Assigned(FTranslateStrings) or (english='') then begin
      Result := english;
      {$IFDEF TRANSLATE_DEBUG}
      if (DebugOutputWindow <> nil) then
        if (english <> '') and (english <> '-') then
          DebugOutputWindow.Memo1.Lines.Add(origEnglish);
      {$ENDIF}
    end else begin
      lookup := AnsiReplaceStr(english,'&','');
      lookup := AnsiReplaceStr(lookup,#13#10,'~');
      Result := FTranslateStrings.Values[lookup];
      Result := AnsiReplaceStr(Result,'~',#13#10);

      if Result = '' then begin
        Result := english;
        {$IFDEF TRANSLATE_DEBUG}
        if (DebugOutputWindow <> nil) then
          if (english <> '') and (english <> '-') then
            DebugOutputWindow.Memo1.Lines.Add(origEnglish);
        {$ENDIF}
      end;
    end;
  end;
end;


function TranslateToEnglish(phrase: string): string;
var
  i,P : integer;
  S : string;
begin
  phrase := AnsiReplaceStr(phrase,'&','');
  Result := phrase;
  if (phrase = '') or (not(Assigned(FTranslateStrings))) then Exit;
  for i := 0 to FTranslateStrings.Count-1 do
  begin
    S := FTranslateStrings[i];
    P := AnsiPos('=', S);
    if (P <> 0) and (AnsiCompareText(Copy(S, P+1, Length(S)), phrase) = 0) then
    begin
      Result := FTranslateStrings.Names[i];
      Exit;
    end;
  end;
end;

//procedure TranslateFrame(frame : TFrame);
//begin
//  TranslateComponent(frame);
//end;


procedure TranslateComponent(component : TComponent);
begin
  if (component.Tag <> Options.Language) then
  begin
    if component.Tag <> 0 then begin
      //DebugOutputWindow.Memo1.Lines.Add('TranslateComponent TO ENGLISH ('+IntToStr(Options.Language)+'<-'+IntToStr(component.tag)+'): '+component.Name);
      TranslateComponentDir(component,ToEnglish);
    end;

    if Options.Language <> 0 then begin
      //DebugOutputWindow.Memo1.Lines.Add('TranslateComponent TO LANG ('+IntToStr(Options.Language)+'<-'+IntToStr(component.tag)+'): '+component.Name);
      TranslateComponentDir(component,FromEnglish);
    end;

  end
  else begin
    //DebugOutputWindow.Memo1.Lines.Add('TranslateComponent does not need to translate ('+IntToStr(component.tag)+'): '+component.Name);
  end;
end;

// This is for translating frames, etc. on their creation, regardless of the
// fact that we have not changed the language recently so FLastLanguage is
// going to be the same as the current langage
procedure TranslateComponentFromEnglish(component : TComponent);
begin
  if Options.Language <> 0 then begin
    //DebugOutputWindow.Memo1.Lines.Add('TranslateComponentFromEnglish TO LANG ('+IntToStr(Options.Language)+'<-'+IntToStr(component.tag)+'): '+component.Name);
    TranslateComponentDir(component,FromEnglish);
  end;
end;

procedure TranslateComponentToEnglish(component : TComponent);
begin
  if component.Tag <> 0 then begin
    //DebugOutputWindow.Memo1.Lines.Add('TranslateComponentToEnglish TO LANG ('+IntToStr(Options.Language)+'<-'+IntToStr(component.tag)+'): '+component.Name);
    TranslateComponentDir(component,ToEnglish);
  end;
end;

procedure TranslateForm(form : TForm);
begin
  //DebugOutputWindow.Memo1.Lines.Add('TranslateForm TO LANG ('+IntToStr(Options.Language)+'<-'+IntToStr(form.tag)+'): '+form.Name);

  if (form.tag <> Options.Language) {or (form <> frmPopUMain)} then
  begin
    TranslateComponent(form);
  end;
end;

//not used
procedure TranslateTreeNode(node : TTreeNode; lastLanguage : Integer);
begin
  if lastLanguage <> 0 then   //FLastLanguage
    node.Text := TranslateDir(node.Text,ToEnglish);

  if Options.Language <> 0 then
    node.Text := TranslateDir(node.Text,FromEnglish);

end;


function TranslateMsg(const Msg: string; DlgType: TMsgDlgType;
                                  Buttons: TMsgDlgButtons; HelpCtx: Integer) : TForm;
////////////////////////////////////////////////////////////////////////////////
// Non-Modal message.
var
  i : integer;
begin
  Result := CreateMessageDialog(Msg, DlgType, Buttons);
  with Result do
  begin
    HelpContext := HelpCtx;
    Position := poScreenCenter;
    FormStyle := fsStayOnTop;
    TranslateForm(Result);
    Caption := Translate(Caption);
    OnClose := frmPopUMain.OnCloseFree;
    for i := 0 to Result.ComponentCount-1 do
      if (Result.Components[i] is TButton) then
        (Result.Components[i] as TButton).OnClick := frmPopUMain.OnClickClose;
    Show;
    SetForegroundWindow(Handle);
  end;
end;

procedure TranslateComponentDir(component : TComponent; LangDirection : TLangDirection);
var
  i,j : integer;
  TransToEnglish : boolean;
  listView : TListView;
  tCombo : TComboBox;
  tTree : TTreeView;
  actionBar : TPopupActionBar;
begin
  TransToEnglish := LangDirection = ToEnglish;

  if (component.Tag = Options.Language) then begin
    //DebugOutputWindow.Memo1.Lines.Add('not translating ('+IntToStr(component.tag)+'): '+component.Name +' ToEnglish: '+BoolToStr(TransToEnglish));
    exit;
  end;

  SetProp(component,'Caption',TransToEnglish);
  SetProp(component,'Hint',TransToEnglish);


  if (component is TListView)  then
  begin
    listView := (component as TListView);
    for j := 0 to listView.Columns.Count-1 do  // column headers
      SetProp(listView.Column[j],'Caption',TransToEnglish);
  end
  else
  if component is TComboBox then
  begin
    tCombo := component as TComboBox;
    for j := 0 to tCombo.Items.Count-1 do
      ChangeComboBoxListItem(tCombo,j,TranslateDir(tCombo.Items[j],LangDirection));
  end
  else if component is TTreeView then
  begin
    tTree := component as TTreeView;
    for i := 0 to tTree.Items.Count-1 do
    begin
      tTree.Items[i].Text := TranslateDir(tTree.Items[i].Text,LangDirection);
      //SetProp(ttree.Items[i],'Text',TransToEnglish);
    end;

    // put images on correct side depending on RTL or LTR language
    if (Application.BiDiMode = bdRightToLeft) then begin
      tTree.Align := alRight;
    end else begin
      tTree.Align := alLeft;
    end;

    tTree.Refresh;
  end
  else if component is TPopupActionBar then
  begin
    actionBar := component as TPopupActionBar;
    for i := 0 to actionBar.Items.Count-1 do
      TranslateTMenuItem(actionBar.Items[i], LangDirection, true);
  end;

  // sub-components
  for i := 0 to component.ComponentCount-1 do
  begin
    TranslateComponentDir(component.Components[i],LangDirection);
    //component.Components[i].Tag := Options.Language;
  end;

  if (LangDirection = ToEnglish) then
    component.Tag := LANGUAGE_ENGLISH
  else
    component.Tag := Options.Language;

end;

// recursively translates menu items.
procedure TranslateTMenuItem(menuItem : TMenuItem; const LangDirection : TLangDirection; const recursive : boolean = true);
var
  j : integer;
begin
  if (menuItem.Tag <> Options.Language) then begin
    menuItem.Caption := TranslateDir(menuItem.Caption,LangDirection);

    if recursive and (menuItem.Count > 0) then
    begin
      for j := 0 to menuItem.Count-1 do
      begin
        TranslateTMenuItem(menuItem.Items[j], LangDirection, recursive);
      end;
    end;

    if (LangDirection = ToEnglish) then
      menuItem.Tag := LANGUAGE_ENGLISH
    else
      menuItem.Tag := Options.Language;
  end;
end;


procedure GetLanguages;
var
  sr : TSearchRec;
  res,i : integer;
  fname,old : string;
begin
  // save selected language
  if Options.Language < Length(Options.Languages) then
    old := Options.Languages[Options.Language];
  SetLength(Options.Languages,1);
  Options.Languages[0] := 'English';
  // get ptlang files from PopTray directory
  res := FindFirst(ExtractFilePath(Application.ExeName)+'languages\*.ptlang',faAnyFile,sr);
  while res = 0 do
  begin
    fname := ChangeFileExt(sr.Name,'');
    if (lowercase(fname) <> 'blank') and (lowercase(fname) <> 'language') then
    begin
      SetLength(Options.Languages,Length(Options.Languages)+1);
      Options.Languages[Length(Options.Languages)-1] := fname;
    end;
    res := FindNext(sr);
  end;
  SysUtils.FindClose(sr);
  // reset to selected language
  for i := 0 to Length(Options.Languages)-1 do
    if Options.Languages[i] = old then begin
      Options.Language := i;
      break;
    end;
end;



function TranslateDir(st : string; LangDirection : TLangDirection) : string;
begin
  if LangDirection = ToEnglish then
    Result := TranslateToEnglish(st)
  else
    Result := Translate(st);
end;

{procedure TranslateFormDir(form : TForm; LangDirection : TLangDirection);
var
  i,j,k : integer;
  TransToEnglish : boolean;
  tCombo : TComboBox;
  listView : TListView;
begin
  TransToEnglish := LangDirection = ToEnglish;

  TranslateComponentDir(form, LangDirection);
 (* for i := 0 to form.ComponentCount-1 do
  begin
    SetProp(form.Components[i],'Caption',TransToEnglish);
    SetProp(form.Components[i],'Hint',TransToEnglish);
    // list view headers
    if (form.Components[i] is TListView)  then
    begin
      listView := (form.Components[i] as TListView);
      for j := 0 to listView.Columns.Count-1 do  // column headers
        SetProp(listView.Column[j],'Caption',TransToEnglish);
    end
    else
    if form.Components[i] is TComboBox then
    begin
      tCombo := form.Components[i] as TComboBox;
      for j := 0 to tCombo.Items.Count-1 do
        ChangeItem(tCombo,j,TranslateDir(tCombo.Items[j],LangDirection));
    end
    else if form.Components[i] is TScrollBox then
    begin
      TranslateComponentDir(form.Components[i], LangDirection);
      //tScroll := form.Components[i] as TScrollBox;
      //for j := 0 to tScroll.Items.Count-1 do

    end;
  end;
 *)
  if form = frmPopUMain.RulesForm then
    frmPopUMain.RulesForm.UpdateComponentSizes();

  if form = frmPopUMain then
  with frmPopUMain do
  begin
    // constant strings
    FKB := Translate(FKB);

    // languages
    for i := 0 to Length(Options.Languages)-1 do
      Options.Languages[i] := TranslateDir(Options.Languages[i],LangDirection);

    // options treeview
//    for i := 0 to tvOptions.Items.Count-1 do
//      tvOptions.Items[i].Text := TranslateDir(tvOptions.Items[i].Text,LangDirection);
//    tvOptions.Refresh;

    // active frame
//    if Assigned(frmPopUMain.frame) then
//    begin
//      TranslateFrameDir(frame,LangDirection);
//      if (frmPopUMain.frame is TframeDefaults) then
//        (frmPopUMain.frame as TframeDefaults).ShowLanguages;
//    end;


    if (Application.BiDiMode = bdRightToLeft) then begin
      frmPopUMain.ActionManager.ActionBars[1].GlyphLayout := blGlyphRight;
    end else begin
      frmPopUMain.ActionManager.ActionBars[1].GlyphLayout := blGlyphLeft;
    end;
  end;
end;
}

procedure SetProp(obj: TObject; PropName: string; ToEnglish : boolean=False);
var
  pi,pi2 : PPropInfo;
  cap,newcap : string;
  tag1 : longint;
begin
  pi := GetPropInfo(obj.ClassInfo,PropName);
  if Assigned(pi) then
  begin
    pi2 := GetPropInfo(obj.ClassInfo,'Tag');
    tag1 := 0;
    if Assigned(pi2) then
     tag1 := GetOrdProp(obj,'Tag');
    if (tag1 = 999) then
       // ignore where tag=999
    else begin
      cap := GetStrProp(obj,PropName);
      if ToEnglish then begin
        newcap := TranslatetoEnglish(cap);
      end
      else
        newcap := Translate(cap);
      if newcap <> '' then
      begin
        SetStrProp(obj,PropName,newcap);
      end;

    end;
  end;
end;

//-------------------------------------------------------------- translation ---

procedure ChangeComboBoxListItem(cmb : TComboBox; item : integer; st : string);
var
  tmp : integer;
begin
  tmp := cmb.ItemIndex;
  cmb.Items[item] := st;
  cmb.ItemIndex := tmp;
end;

procedure RefreshLanguages;
begin
  GetLanguages;
  // translate it
  FLastLanguage := -1;

  frmPopUMain.OnSetLanguage;
end;

// Asks a vista style yes/no prompt with custom labels
// returns mrYes or mrNo
function ShowVistaConfirmDialog(DlgTitle: string; DlgHeading: string;
  DlgMsg: string; YesBtnCaption:
  string; NoBtnCaption: string): integer;
var
  Task: TSynTaskDialog;
begin
  Task.Caption := DlgTitle;
  Task.Title := DlgHeading;
  Task.Text := DlgMsg;
  Task.Buttons := YesBtnCaption+#13#10+NoBtnCaption;
  if Task.Execute([],101{=no,thedefault},[],tiQuestion) = 100{=Yes} then
    Result := mrYes else Result := mrNo;
end;

function ShowCustomOkCancelDialog(const DlgTitle : String; const DlgMsg : String; DlgType: TMsgDlgType;
  HelpCtx: Integer; Button1Caption : String; Button2Caption : String) : Integer;
var
  dlg : TForm;
  button1, button2 : TButton;
begin
  dlg := CreateMessageDialog(DlgMsg, DlgType, [mbOk, mbCancel]);
  with dlg do
  begin
    try
      HelpContext := HelpCtx;
      Position := poScreenCenter;
      TranslateForm(dlg);

      if (DlgTitle <> '') then
        Caption := Translate(DlgTitle)
      else Caption := Translate(Caption);

      button1 := TButton(FindComponent('OK'));
      button1.Caption := Button1Caption;
      button1.Width := Max(Canvas.TextWidth(button1.Caption)+10, 70);

      button2 := TButton(FindComponent('Cancel'));
      button2.Caption := Button2Caption;
      button2.Width := Max(Canvas.TextWidth(button2.Caption)+10, 70);
      button2.Left := button1.Width + button1.Left;


      Result := ShowModal();
    finally
      Free;
    end;
  end;
end;

//******************************************************************************
// Creates and shows a modal dialog box (eg: for error messages) including
// translating the caption
//******************************************************************************
function ShowTranslatedDlg(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Integer; DialogCaption : string = '' ): Integer;
var
  dlg : TForm;
begin
  dlg := CreateMessageDialog(Msg, DlgType, Buttons);
  with dlg do
  begin
    try
      HelpContext := HelpCtx;
      Position := poScreenCenter;
      TranslateForm(dlg);

	  //TODO: should we set popup parent and mode?
      //dlg.PopupParent := frmPopUMain;
      //dlg.PopupMode := pmAuto;

      // If a title for the dialog was passed in as a parameter, use it,
      // otherwise, show the default dialog title for the specified dialog
      // type (eg: "Error")
      if (DialogCaption <> '')
        then Caption := Translate(DialogCaption) //use provided dialog title
        else Caption := Translate(Caption);
      Result := ShowModal();
    finally
      Free;
    end;
  end;
end;


initialization
  FLastLanguage := LANGUAGE_ENGLISH;
  {$IFDEF TRANSLATE_DEBUG}
  if ParamSwitch('TRANSLATE') then begin
    DebugOutputWindow := TTranslateDebugWindow.Create(nil);
    DebugOutputWindow.Show;
    DebugOutputWindow.Memo1.Lines.Add('Welcome to the Translation Debug Window. This window lists English strings that may need translation to the current language. Some strings appearing in this window should not be translated. Remove ampersands before translating.');
    DebugOutputWindow.Memo1.Lines.Add('------------------------------------------------------------------------------');

  end;
  {$ENDIF}
end.
