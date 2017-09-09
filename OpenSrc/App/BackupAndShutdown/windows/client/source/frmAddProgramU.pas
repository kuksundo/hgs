{-----------------------------------------------------------------------------
 Unit Name: frmAddProgramU
 Author: Tristan Marlow
 Purpose: Backup and Shutdown Add Active Application to Shutdown.

 ----------------------------------------------------------------------------
 License
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU Library General Public License as
 published by the Free Software Foundation; either version 2 of
 the License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Library General Public License for more details.
 ----------------------------------------------------------------------------

 History: 04/05/2007 - First Release.

-----------------------------------------------------------------------------}
unit frmAddProgramU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Buttons, ExtCtrls, ActnList, System.UITypes, System.Actions;

type
  TfrmAddProgram = class(TForm)
    pnlBottom: TPanel;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    pnlActivePrograms: TPanel;
    pnlProgramDetails: TPanel;
    GroupBoxProgramDetails: TGroupBox;
    lblWindowTitle: TLabel;
    editWindowTitle: TEdit;
    lblWindowClass: TLabel;
    editWindowClass: TEdit;
    lbActivePrograms: TListBox;
    Label3: TLabel;
    PopupMenuActivePrograms: TPopupMenu;
    mnuRefresh: TMenuItem;
    mnuAdd: TMenuItem;
    ActionList1: TActionList;
    ActionOk: TAction;
    ActionCancel: TAction;
    ActionRefresh: TAction;
    ActionAddDetails: TAction;
    pnlTop: TPanel;
    imgHeader: TImage;
    imgBackground: TImage;
    lblHeader: TLabel;
    BitBtn1: TBitBtn;
    procedure ActionOkExecute(Sender: TObject);
    procedure ActionCancelExecute(Sender: TObject);
    procedure ActionRefreshExecute(Sender: TObject);
    procedure ActionAddDetailsExecute(Sender: TObject);
  private
    procedure UpdateActivePrograms;
    procedure SetWindowName(AWindowName : String);
    procedure SetWindowClass(AWindowClass : String);
    function GetWindowName : String;
    function GetWindowClass : String;
  public
    function Execute : Boolean;
    procedure GetWindowList(AWindowList : TStrings);
    property WindowName : String read GetWindowName write SetWindowName;
    property WindowClass : String read GetWindowClass write SetWindowClass;
  end;

var
  frmAddProgram: TfrmAddProgram;

implementation

{$R *.dfm}

procedure TfrmAddProgram.GetWindowList(AWindowList : TStrings);
var
  szWindowTitle: array[0..255] of char;
  szClassName: array[0..255] of char;
  Hwnd : THandle;
begin
  hWnd := GetWindow(Application.MainForm.Handle, GW_HWNDFIRST);
  while hWnd <> 0 do
   begin
      GetClassName(Hwnd,szClassName,256);
      GetWindowText(hWnd, szWindowTitle, 256);
      if (IsWindowVisible(hWnd)) and (GetWindow(hWnd, GW_OWNER)=0) then
        begin
          if StrPas(szWindowTitle) <> '' then
            begin
             AWindowList.Add(StrPas(szWindowTitle)+'='+StrPas(szClassName));
            end;
        end;
      hWnd := GetWindow(hWnd, GW_HWNDNEXT);
   end;
end;

procedure TfrmAddProgram.UpdateActivePrograms;
begin
  lbActivePrograms.Clear;
  GetWindowList(lbActivePrograms.Items);
end;

procedure TfrmAddProgram.SetWindowName(AWindowName : String);
begin
  editWindowTitle.Text := AWindowName;
end;

procedure TfrmAddProgram.SetWindowClass(AWindowClass : String);
begin
  editWindowClass.Text := AWindowClass;
end;

function TfrmAddProgram.GetWindowName : String;
begin
  Result := editWindowTitle.Text;
end;

function TfrmAddProgram.GetWindowClass : String;
begin
  Result := editWindowClass.Text;
end;

function TfrmAddProgram.Execute : Boolean;
begin
  UpdateActivePrograms;
  Result := Self.ShowModal = mrOk;
end;

procedure TfrmAddProgram.ActionOkExecute(Sender: TObject);
begin
  if (editWindowTitle.Text <> '') then
    begin
      Self.ModalResult := mrOk;
    end else
    begin
      MessageDlg('You must specify a window name.', mtError, [mbOK], 0);
    end;
end;

procedure TfrmAddProgram.ActionCancelExecute(Sender: TObject);
begin
  UpdateActivePrograms;
  Self.ModalResult := mrCancel;
end;

procedure TfrmAddProgram.ActionRefreshExecute(Sender: TObject);
begin
  UpdateActivePrograms;
end;

procedure TfrmAddProgram.ActionAddDetailsExecute(Sender: TObject);
begin
  if lbActivePrograms.ItemIndex <> -1 then
    begin
      editWindowTitle.Text := lbActivePrograms.Items.Names[lbActivePrograms.ItemIndex];
      editWindowClass.Text := lbActivePrograms.Items.ValueFromIndex[lbActivePrograms.ItemIndex];
    end;
end;

end.
