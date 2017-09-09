unit UnitSelectTagName;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls;

type
  TTagInfoEditorDlg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ListView1: TListView;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    RadioGroup1: TRadioGroup;
    WholeWordCB: TCheckBox;
    SearchEdit: TEdit;
    BitBtn3: TBitBtn;
    CaseCB: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure SearchEditKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn3Click(Sender: TObject);
  private
  public
    FParamIndex: integer;

    procedure GetTagList(ATagNameList, ADescriptList, AValueList, AIndexList: TStrings);
    procedure IndicateTagList(ATagName, ADescript: string);
    procedure IndicateTagListFromTagInfo;
    procedure FindCaptionLV(AListView: TListView; AStratIdx: integer; AFindStr: string);
    function FindListViewItem(lv: TListView; const S: string; column: Integer): TListItem;
    procedure LV_FindAndSelectItems(lv: TListView; const S: string;
      column: Integer; AWholeWord: Boolean = False; ACaseSensitive: Boolean = False);
    procedure ListViewFindAnsSelect(lv: TListView; const S: string;
      column: integer; AWholeWord: Boolean = False; ACaseSensitive: Boolean = False);
    function Execute: Boolean;
  published
  end;

var
  TagInfoEditorDlg: TTagInfoEditorDlg;

implementation

{$R *.dfm}

{ TForm1 }

procedure TTagInfoEditorDlg.BitBtn3Click(Sender: TObject);
begin
//  LV_FindAndSelectItems(ListView1, SearchEdit.Text, RadioGroup1.ItemIndex, WholeWordCB.Checked);
  ListViewFindAnsSelect(ListView1, SearchEdit.Text, RadioGroup1.ItemIndex,
    WholeWordCB.Checked, CaseCB.Checked);
end;

procedure TTagInfoEditorDlg.Button1Click(Sender: TObject);
begin
//  GetTagNames4Test;
end;

procedure TTagInfoEditorDlg.SearchEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then
  begin
//    LV_FindAndSelectItems(ListView1, SearchEdit.Text, RadioGroup1.ItemIndex, WholeWordCB.Checked);
    ListViewFindAnsSelect(ListView1, SearchEdit.Text, RadioGroup1.ItemIndex,
      WholeWordCB.Checked, CaseCB.Checked);
  end;
end;

function TTagInfoEditorDlg.Execute: Boolean;
var
  LItem: TListItem;
begin
  Result := False;

  if ShowModal = mrOk then
  begin
    LItem := ListView1.Selected;
    if not Assigned(LItem) then
      LItem := ListView1.Items[0];

    FParamIndex := StrToInt(LItem.SubItems[2]);

//    FTagName.TagName := LItem.Caption;
//    FTagName.Description := LItem.SubItems.Strings[0];
//    FTagName.ParamIndex := LItem.Index;
    Result := True;
  end;
end;

procedure TTagInfoEditorDlg.FindCaptionLV(AListView: TListView;
  AStratIdx: integer; AFindStr: string);
var
  lvItem: TListItem;
begin
  lvItem := AListView.FindCaption(AStratIdx,  // StartIndex: Integer;
                                  AFindStr,   // Search string: string;
                                  True,       // Partial,
                                  True,       // Inclusive
                                  False);     // Wrap  : boolean;
  if lvItem <> nil then
  begin
    AListView.Selected := lvItem;
    lvItem.MakeVisible(True);
    AListView.SetFocus;
  end;
end;

{
  Search for text in a listview item
  @Param lv is the listview, supposed to be in vaReport mode
  @Param S is the text to search for
  @Param column is the column index for the column to search , 0-based
  @Returns the found listview item, or Nil if none was found
  @Precondition  lv  nil, lv in report mode if column  0, S not empty
  @Desc The search is case-insensitive and will only match on the
  complete column content. Use AnsiContainsText instead of AnsiCompareText
  to match on a substring in the columns content.
  Created 14.10.2001 by P. Below
//»ç¿ë¹ý
  procedure TForm1.Button1Click(Sender: TObject);
  var
    lvItem: TListItem;
  begin
    // Search subitem[0] for text from edit1
    // in der Spalte subitem[0] den Text aus Edit1 suchen
    lvItem := FindListViewItem(ListView1, Edit1.Text, 1);
    // if found, then show the item
    // falls item gefunden, dann anzeigen
    if lvItem <> nil then
    begin
      ListView1.Selected := lvItem;
      lvItem.MakeVisible(True);
      ListView1.SetFocus;
    end;
  end;

}
function TTagInfoEditorDlg.FindListViewItem(lv: TListView; const S: string;
  column: Integer): TListItem;
var
  i: Integer;
  found: Boolean;
begin
  Assert(Assigned(lv));
  Assert((lv.viewstyle = vsReport) or (column = 0));
  Assert(S <> '');
  for i := 0 to lv.Items.Count - 1 do
  begin
    Result := lv.Items[i];
    if column = 0 then
      found := AnsiCompareText(Result.Caption, S) = 0
    else if column > 0 then
      found := AnsiCompareText(Result.SubItems[column - 1], S) = 0
    else
      found := False;
    if found then
      Exit;
  end;
  // No hit if we get here
  Result := nil;
end;

procedure TTagInfoEditorDlg.GetTagList(ATagNameList, ADescriptList, AValueList, AIndexList: TStrings);
var
  i: integer;
  LItem: TListItem;
begin
  if ListView1.Items.Count > 0 then
    ListView1.Clear;

  for i := 0 to ATagNameList.Count - 1 do
  begin
    LItem := ListView1.Items.Add;
    LItem.Caption := ATagNameList.Strings[i];
    LItem.SubItems.Add(ADescriptList.Strings[i]);
    LItem.SubItems.Add(AValueList.Strings[i]);
    LItem.SubItems.Add(AIndexList.Strings[i]);
  end;
end;

procedure TTagInfoEditorDlg.IndicateTagList(ATagName, ADescript: string);
var
  i: integer;
  LItem: TListItem;
begin
  for i := 0 to ListView1.Items.Count - 1 do
  begin
    LItem := ListView1.Items[i];
    if LItem.Caption = ATagName then
    begin
      if LItem.SubItems.Strings[0] = ADescript then
      begin
        Litem.Selected := True;
        LItem.MakeVisible(False);
        LItem.Focused := True;
        //ListView1.Selected.Focused := True;
        break;
      end;
    end;
  end;
end;

procedure TTagInfoEditorDlg.IndicateTagListFromTagInfo;
begin
//  IndicateTagList(FTagName.TagName, FTagName.Description);
end;

{
  procedure TForm1.Button1Click(Sender: TObject);
  var
    lvItem: TListItem;
  begin
    // in der Spalte subitem[0] den Text aus Edit1 suchen
    LV_FindAndSelectItems(ListView1, Edit1.Text, 1);
    ListView1.SetFocus;
  end;
}

procedure TTagInfoEditorDlg.ListViewFindAnsSelect(lv: TListView;
  const S: string; column: integer; AWholeWord, ACaseSensitive: Boolean);
var
  i, LIndex: Integer;
  found, LFalse: Boolean;
  lvItem: TListItem;
  LSubStr, LSrcStr: string;
begin
  Assert(Assigned(lv));
  Assert((lv.ViewStyle = vsReport) or (column = 0));
  Assert(S <> '');

  if Assigned(lv.Selected) then
  begin
    LIndex := lv.Selected.Index;

    if LIndex = (lv.Items.Count -1) then
      LIndex := 0
    else
      Inc(LIndex);
  end
  else
    LIndex := 0;

  LFalse := False;
  LSubStr := S;

  if not ACaseSensitive then
    LSubStr := Uppercase(LSubStr);

  for i := LIndex to lv.Items.Count - 1 do
  begin
    lvItem := lv.Items[i];

    if column = 0 then
      LSrcStr := lvItem.Caption
    else if column > 0 then
    begin
      if lvItem.SubItems.Count >= Column then
        LSrcStr := lvItem.SubItems[column - 1]
      else
        LFalse := True;
    end
    else
      LFalse := True;

    if not ACaseSensitive then
      LSrcStr := Uppercase(LSrcStr);

    if LFalse then
      found := False
    else
    if AWholeWord then
      found := AnsiCompareText(LSrcStr, LSubStr) = 0
    else
      found := Pos(LSubStr, LSrcStr) > 0;

    if found then
    begin
      lv.Selected := lvItem;
      lvItem.MakeVisible(True);
      lv.SetFocus;
      break;
    end;

    if i = (lv.Items.Count - 1) then
      lv.Items.Item[0].MakeVisible(True);
  end;//for
end;

procedure TTagInfoEditorDlg.LV_FindAndSelectItems(lv: TListView;
  const S: string; column: Integer; AWholeWord: Boolean; ACaseSensitive: Boolean);
var
  i, LIndex: Integer;
  found: Boolean;
  lvItem: TListItem;
begin
  Assert(Assigned(lv));
  Assert((lv.ViewStyle = vsReport) or (column = 0));
  Assert(S <> '');

  if Assigned(lv.Selected) then
  begin
    LIndex := lv.Selected.Index;

    if LIndex = (lv.Items.Count -1) then
      LIndex := 0
    else
      Inc(LIndex);
  end
  else
    LIndex := 0;

  for i := LIndex to lv.Items.Count - 1 do
  begin
    lvItem := lv.Items[i];

    if AWholeWord then
    begin
      if column = 0 then
        found := AnsiCompareText(lvItem.Caption, S) = 0
      else if column > 0 then
      begin
        if lvItem.SubItems.Count >= Column then
          found := AnsiCompareText(lvItem.SubItems[column - 1], S) = 0
        else
          found := False;
      end
      else
        found := False;
    end
    else
    begin
      if column = 0 then
        found := Pos(S, lvItem.Caption) > 0
      else if column > 0 then
      begin
        if lvItem.SubItems.Count >= Column then
          found := Pos(S, lvItem.SubItems[column - 1]) > 0
        else
          found := False;
      end
      else
        found := False;
    end;

    if found then
    begin
      lv.Selected := lvItem;
      lvItem.MakeVisible(True);
      lv.SetFocus;
      break;
    end;
  end;//for
end;

end.




