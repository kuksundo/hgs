{-----------------------------------------------------------------------------
 Unit Name: frmActiveApplicationsU
 Author: Tristan Marlow
 Purpose: Backup and Shutdown Shutdown Active Applications.

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
unit frmActiveApplicationsU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, StdCtrls, Buttons, System.UITypes;

type
  TfrmActiveApplications = class(TForm)
    pnlBottom: TPanel;
    btnCancel: TBitBtn;
    pnlTop: TPanel;
    ListViewActiveApplications: TListView;
    PopupMenu: TPopupMenu;
    mnuTerminate: TMenuItem;
    mnuRefresh: TMenuItem;
    btnContinue: TBitBtn;
    RefreshTimer: TTimer;
    mnuClose: TMenuItem;
    N1: TMenuItem;
    imgHeader: TImage;
    lblHeader: TLabel;
    procedure mnuRefreshClick(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure mnuTerminateClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
  private
    FCloseGraceFully : Boolean;
    FProgramList : TStrings;
    procedure UpdateProgramList;
  public
    function Execute(AActivePrograms : TStrings; ACloseGraceFully : Boolean) : Boolean;
  end;

var
  frmActiveApplications: TfrmActiveApplications;

implementation

{$R *.dfm}

procedure TerminateWindow(AHandle : Hwnd);
var
  ProcessHandle: THandle;
  ProcessID,ExitCode: Cardinal;
begin
  GetWindowThreadProcessID(AHandle,@ProcessID);
  ProcessHandle:= OpenProcess(PROCESS_CREATE_THREAD OR PROCESS_VM_OPERATION OR PROCESS_VM_WRITE OR PROCESS_VM_READ OR PROCESS_TERMINATE, FALSE,ProcessID);
  if (ProcessHandle > 0) then
   begin
    GetExitCodeProcess(ProcessHandle,ExitCode);
    TerminateProcess(ProcessHandle,ExitCode);
    CloseHandle(ProcessHandle);
   end;
end;

procedure CloseWindow(AHandle : Hwnd);
begin
  PostMessage(AHandle, WM_CANCELMODE, 0, 0);
  PostMessage(AHandle, WM_CLOSE, 0, 0);
end;

function GetWindowHandle(WindowTitle, WindowClass: string): Hwnd;
begin
  //Result := FindWindow(PChar(WindowClass), PChar(WindowTitle));
  Result := FindWindow(PChar(WindowClass), nil);
  if Result = 0 then Result := FindWindow(nil, PChar(WindowTitle));
  if Result = 0 then Result := FindWindow(PChar(WindowTitle), nil);
  if Result = 0 then Result := FindWindow(PChar(WindowClass), PChar(WindowTitle));
end;

procedure TfrmActiveApplications.UpdateProgramList;
var
  ListItem : TListItem;
  Idx : Integer;
  AppHandle : HWND;
begin
  ListViewActiveApplications.Items.Clear;
  For Idx := 0 to Pred(FProgramList.Count) do
    begin
      AppHandle := GetWindowHandle(FProgramList.Names[Idx],FProgramList.ValueFromIndex[Idx]);
      if AppHandle <> 0 then
        begin
          ListItem := ListViewActiveApplications.Items.Add;
          with ListItem do
            begin
              Caption := FProgramList.Names[Idx];
              SubItems.Add(FProgramList.ValueFromIndex[Idx]);
              if FCloseGraceFully then
                begin
                  SubItems.Add('Closing...');
                  CloseWindow(AppHandle);
                end else
                begin
                  SubItems.Add('Terminating...');
                  TerminateWindow(AppHandle);
                end;
            end;

        end;
    end;
end;

function TfrmActiveApplications.Execute(AActivePrograms : TStrings; ACloseGraceFully : Boolean) : Boolean;
begin
  FProgramList := AActivePrograms;
  FCloseGraceFully := ACloseGraceFully;
  UpdateProgramList;
  if ListViewActiveApplications.Items.Count <> 0 then
    begin
      Result := Self.ShowModal = mrOk;
    end else
    begin
      Result := True;
    end;
end;

procedure TfrmActiveApplications.mnuCloseClick(Sender: TObject);
begin
  if ListViewActiveApplications.ItemIndex <> -1 then
    begin
      CloseWindow(GetWindowHandle('',ListViewActiveApplications.Items[ListViewActiveApplications.ItemIndex].SubItems[0]));
    end;
end;

procedure TfrmActiveApplications.mnuRefreshClick(Sender: TObject);
begin
  UpdateProgramList;
end;

procedure TfrmActiveApplications.mnuTerminateClick(Sender: TObject);
begin
  if ListViewActiveApplications.ItemIndex <> -1 then
    begin
      TerminateWindow(GetWindowHandle('',ListViewActiveApplications.Items[ListViewActiveApplications.ItemIndex].SubItems[0]));
    end;
end;

procedure TfrmActiveApplications.RefreshTimerTimer(Sender: TObject);
begin
  UpdateProgramList;
  if ListViewActiveApplications.Items.Count = 0 then Self.ModalResult := mrOk;
end;

procedure TfrmActiveApplications.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  RefreshTimer.Enabled := False;
end;

procedure TfrmActiveApplications.FormShow(Sender: TObject);
begin
  RefreshTimer.Enabled := True;
  UpdateProgramList;
end;

procedure TfrmActiveApplications.btnContinueClick(Sender: TObject);
begin
  if ListViewActiveApplications.Items.Count = 0 then
    begin
      Self.ModalResult := mrOk;
    end else
    begin
      if MessageDlg('Backup may fail without closing all active applications, are you sure you want to continue?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
        begin
          Self.ModalResult := mrOk;
        end;
    end;
end;

end.
