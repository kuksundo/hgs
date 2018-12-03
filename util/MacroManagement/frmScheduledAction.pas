(*
  * Copyright (c) 2013-2016 Thundax Macro Actions
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are
  * met:
  *
  * * Redistributions of source code must retain the above copyright
  *   notice, this list of conditions and the following disclaimer.
  *
  * * Redistributions in binary form must reproduce the above copyright
  *   notice, this list of conditions and the following disclaimer in the
  *   documentation and/or other materials provided with the distribution.
  *
  * * Neither the name of 'Thundax Macro Actions' nor the names of its contributors
  *   may be used to endorse or promote products derived from this software
  *   without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
  * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
  * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*)

unit frmScheduledAction;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, StdCtrls, thundax.lib.actions, ExtCtrls,
  Vcl.Samples.Spin, Vcl.Menus, ralarm;

type
  TfrmActions = class(TForm)
    btnAddAction: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    btnSequence: TSpeedButton;
    edtX: TEdit;
    edtY: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    cmbStrokes: TComboBox;
    Label5: TLabel;
    edtFreeText: TEdit;
    Label6: TLabel;
    ListBox1: TListBox;
    Timer1: TTimer;
    btnDelete: TSpeedButton;
    btnUp: TSpeedButton;
    btnDown: TSpeedButton;
    Label7: TLabel;
    TabSheet3: TTabSheet;
    Label8: TLabel;
    edtTime: TSpinEdit;
    Label9: TLabel;
    btnStop: TSpeedButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    AlarmFromTo1: TAlarmFromTo;
    BeginTimePicker: TDateTimePicker;
    BeginTimeCheck: TCheckBox;
    Label10: TLabel;
    Edit1: TEdit;
    procedure btnSequenceClick(Sender: TObject);
    procedure btnAddActionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure Timer1Timer(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure BeginTimeCheckClick(Sender: TObject);
    procedure BeginTimePickerChange(Sender: TObject);
    procedure AlarmFromTo1AlarmBegin(Sender: TObject);
  private
    function GetActionType(description: string): TActionType;
    procedure PlaySequence;
  public
    FBreak : Boolean;
  end;

var
  frmActions: TfrmActions;
  list: TActionList;
  pos: Integer;

implementation

{$R *.dfm}

procedure TfrmActions.btnSequenceClick(Sender: TObject);
begin
  PlaySequence;
end;

procedure TfrmActions.btnStopClick(Sender: TObject);
begin
  FBreak := true;
end;

procedure TfrmActions.AlarmFromTo1AlarmBegin(Sender: TObject);
begin
  PlaySequence;
end;

procedure TfrmActions.BeginTimeCheckClick(Sender: TObject);
begin
  BeginTimePicker.Enabled := BeginTimeCheck.Checked;

  if BeginTimeCheck.Checked then
    AlarmFromTo1.AlarmTimeBegin := FormatDateTime('hh:nn:ss', BeginTimePicker.Time);

  AlarmFromTo1.ActiveBegin := BeginTimeCheck.Checked;
end;

procedure TfrmActions.BeginTimePickerChange(Sender: TObject);
begin
  AlarmFromTo1.AlarmTimeBegin := FormatDateTime('hh:nn:ss', BeginTimePicker.Time);
end;

procedure TfrmActions.btnAddActionClick(Sender: TObject);
var
  action: IAction;
  descAction: string;
  actionType: TActionType;
  x, y: Integer;
begin
  if ComboBox1.Text = '' then
    Exit;
  descAction := ComboBox1.Text;
  actionType := GetActionType(descAction);

  case actionType of
    tMousePos:
      begin
        if (edtX.Text = '') or (edtY.Text = '') then
          raise Exception.Create('Fields must contain valid coordinates');
        x := StrToInt(edtX.Text);
        y := StrToInt(edtY.Text);
        action := TAction<Integer>.Create(actionType, TParameters<Integer>.Create(x, y));
      end;
    TMouseLClick, TMouseLDClick, TMouseRClick, TMouseRDClick:
      action := TAction<String>.Create(actionType, TParameters<String>.Create('', ''));
    TKey:
      begin
        if (cmbStrokes.Text = '') then
          raise Exception.Create('Fields must contain valid coordinates');
        action := TAction<String>.Create(actionType, TParameters<String>.Create(cmbStrokes.Text, ''));
      end;
    TMessage:
      begin
        if (edtFreeText.Text = '') then
          raise Exception.Create('Fields must contain valid coordinates');
        action := TAction<String>.Create(actionType, TParameters<String>.Create(edtFreeText.Text, ''));
      end;
    TWait:
      begin
        if (edtTime.Value = 0) then
          raise Exception.Create('Field must contain time greater than zero');
        action := TAction<Integer>.Create(actionType, TParameters<Integer>.Create(edtTime.Value, 0));
      end;
  end;

  list.Add(action);
  ListBox1.Items.Add(action.toString);
end;

procedure TfrmActions.FormCreate(Sender: TObject);
begin
  list := TActionList.Create;
end;

procedure TfrmActions.FormDestroy(Sender: TObject);
begin
  FreeAndNil(list);
end;

function TfrmActions.GetActionType(description: string): TActionType;
var
  actionType: TActionType;
begin
  actionType := tMousePos;
  if description = 'Mouse position' then
    actionType := tMousePos;
  if description = 'Mouse Left Click' then
    actionType := TMouseLClick;
  if description = 'Mouse Left Double Click' then
    actionType := TMouseLDClick;
  if description = 'Mouse Right Click' then
    actionType := TMouseRClick;
  if description = 'Mouse Right Double Click' then
    actionType := TMouseRDClick;
  if description = 'Press special key' then
    actionType := TKey;
  if description = 'Type message' then
    actionType := TMessage;
  if description = 'Wait (s)' then
    actionType := TWait;
  result := actionType;
end;

procedure TfrmActions.ListBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do
  begin
    if pos = Index then
    begin
      Brush.Color := cllime;
      DrawFocusRect(Rect);
    end;

    FillRect(Rect);
    TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;

procedure TfrmActions.PlaySequence;
var
  i, j: Integer;
  action: IAction;
  numTimes: Integer;
begin
  numTimes := StrToInt(Edit3.Text);

  if numTimes > 0 then
  begin
  for j := 0 to numTimes - 1 do
  begin
    for i := 0 to ListBox1.Items.Count - 1 do
    begin
      pos := i;
      action := list[i];
      action.Execute;
      Sleep(200);
      ListBox1.SetFocus;
      Application.ProcessMessages;
      if FBreak then
        break;
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
      pos := i;
      action := list[i];
      action.Execute;
      Sleep(200);
      ListBox1.SetFocus;
      Application.ProcessMessages;
      Sleep(200);
      inc(i);
      if (i > (ListBox1.Items.Count - 1)) then
        i := 0;
    end;
  end;
end;

procedure TfrmActions.btnDeleteClick(Sender: TObject);
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    list.Remove(list.Items[ListBox1.ItemIndex]);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
  end;
end;

procedure TfrmActions.btnUpClick(Sender: TObject);
var
  CurrIndex: Integer;
begin
  with ListBox1 do
    if ItemIndex > 0 then
    begin
      CurrIndex := ItemIndex;
      list.Move(ItemIndex, (CurrIndex - 1));
      Items.Move(ItemIndex, (CurrIndex - 1));
      ItemIndex := CurrIndex - 1;
    end;
end;

procedure TfrmActions.ComboBox1Change(Sender: TObject);
var
  descAction: string;
  actionType: TActionType;
begin
  descAction := ComboBox1.Text;
  actionType := GetActionType(descAction);

  edtX.Enabled := True;
  edtY.Enabled := True;
  cmbStrokes.Enabled := True;
  edtFreeText.Enabled := True;
  edtTime.Enabled := True;
  btnAddAction.Enabled := True;

  case actionType of
    tMousePos:
      begin
        cmbStrokes.Enabled := false;
        edtFreeText.Enabled := false;
        edtTime.Enabled := false;
        PageControl1.ActivePageIndex := 0;
      end;
    TMouseLClick, TMouseLDClick, TMouseRClick, TMouseRDClick:
      begin
        edtX.Enabled := false;
        edtY.Enabled := false;
        cmbStrokes.Enabled := false;
        edtFreeText.Enabled := false;
        edtTime.Enabled := false;
        PageControl1.ActivePageIndex := 0;
      end;
    TKey:
      begin
        edtX.Enabled := false;
        edtY.Enabled := false;
        edtFreeText.Enabled := false;
        edtTime.Enabled := false;
        PageControl1.ActivePageIndex := 1;
      end;
    TMessage:
      begin
        edtX.Enabled := false;
        edtY.Enabled := false;
        cmbStrokes.Enabled := false;
        edtTime.Enabled := false;
        PageControl1.ActivePageIndex := 1;
      end;
    TWait:
      begin
        edtX.Enabled := false;
        edtY.Enabled := false;
        cmbStrokes.Enabled := false;
        edtTime.Enabled := true;
        PageControl1.ActivePageIndex := 2;
      end;
  end;
end;

procedure TfrmActions.btnDownClick(Sender: TObject);
var
  CurrIndex, LastIndex: Integer;
begin
  with ListBox1 do
  begin
    CurrIndex := ItemIndex;
    LastIndex := Items.Count;
    if ItemIndex <> -1 then
    begin
      if CurrIndex + 1 < LastIndex then
      begin
        list.Move(ItemIndex, (CurrIndex + 1));
        Items.Move(ItemIndex, (CurrIndex + 1));
        ItemIndex := CurrIndex + 1;
      end;
    end;
  end;
end;

procedure TfrmActions.Timer1Timer(Sender: TObject);
var
  pt: TPoint;
begin
  Application.ProcessMessages;
  GetCursorPos(pt);
  Label7.caption := 'Mouse Position (x,y) (' + IntToStr(pt.x) + ',' + IntToStr(pt.y) + ')';
end;

end.
