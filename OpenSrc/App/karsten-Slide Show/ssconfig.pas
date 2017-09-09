(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is ssconfig.pas of Karsten Bilderschau, version 3.2.12.
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

{ $Id: ssconfig.pas 111 2007-02-25 19:29:39Z hiisi $ }

{
@abstract Screen saver configuration dialog box
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2000/04/01
@cvs $Date: 2007-02-25 13:29:39 -0600 (So, 25 Feb 2007) $
}
unit ssconfig;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, Buttons, FileCtrl, KarsReg, ComCtrls;

type
  { Enumeration type of the user profile types used for screen saver configuration }
	TUserProfile = (
    upCurrent, //< Current user
    upDefault  //< Default user, typically available for administrator only
    );

type
  { @abstract Screen saver configuration dialog box
    The screen saver configuration depends on the OS version:
    @definitionList(
      @itemLabel(Win95/98/ME)
      @item(The screen saver program is set in the system.ini file
        and is thus the same for all users.
        The default user profile can be modified by every user.)
      @itemLabel(WinNT/2K/XP)
      @item(The screen saver program can be set independently for each user.
        The default user profile can be modified only by administrators.)
    )
    The karsten screen saver document is set under the karsten registry tree,
    and can be set independently by each user.

    The registration details are implemented in @link(TUserRegistry).
    Here, we just check whether we have access to the default profile.
    The registration is read in @link(FormCreate) and
    written in @link(FormClose), if the modal result is OK. }
	TSSConfigForm = class(TForm)
		BOk: TBitBtn;
		BCancel: TBitBtn;
		CBInstallScr: TCheckBox;
		GBSSDoc: TGroupBox;
		EFSSDocPath: TEdit;
		BFindSSDocPath: TBitBtn;
		BSelectCurDoc: TBitBtn;
		OpenSSDocDialog: TOpenDialog;
		PCUsers: TPageControl;
		TSCurrentUser: TTabSheet;
		TSDefaultUser: TTabSheet;
    BHelp: TBitBtn;
		procedure BSelectCurDocClick(Sender: TObject);
		procedure BFindSSDocPathClick(Sender: TObject);
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure PCUsersChanging(Sender: TObject; var AllowChange: Boolean);
		procedure PCUsersChange(Sender: TObject);
		procedure EFSSDocPathChange(Sender: TObject);
		procedure CBInstallScrClick(Sender: TObject);
    procedure BControlPanel(Sender: TObject);
	private
		FCurrentBildersammlung: string;
		oldInstallScreenSaver: array[TUserProfile] of boolean;
		FInstallScreenSaver: array[TUserProfile] of boolean;
		FScreenSaverDoc: array[TUserProfile] of string;
		FTabModified: array[TUserProfile] of boolean;
		UserRegistry: array[TUserProfile] of TUserRegistry;
		FRegPrivilege: array[TUserProfile] of boolean;
		procedure SetCurrentBildersammlung(const Value: string);
		procedure SetInstallScreenSaver(user: TUserProfile; const Value: boolean);
		procedure SetScreenSaverDoc(user: TUserProfile; const Value: string);
		function GetInstallScreenSaver(user: TUserProfile): boolean;
		function GetScreenSaverDoc(user: TUserProfile): string;
	protected
		function	GetActiveUserTab: TUserProfile;
	public
    { Switch karsten's screen saver on or off
      for the given user profile.
      This property is linked to the corresponding dialog control. }
		property InstallScreenSaver[user: TUserProfile]: boolean
			read GetInstallScreenSaver write SetInstallScreenSaver;
    { Select karsten's document
      for the given user profile.
      This property is linked to the corresponding dialog control. }
		property ScreenSaverDoc[user: TUserProfile]: string
			read GetScreenSaverDoc write SetScreenSaverDoc;
    { Collection document that is set when the user clicks the "Current Document" button. }
		property CurrentBildersammlung: string
			read FCurrentBildersammlung write SetCurrentBildersammlung;
	end;

var
	SSConfigForm: TSSConfigForm;

implementation
uses
  registry, gnugettext, jclSysInfo;

{$R *.DFM}

resourcestring
	SWarningNotAKBS = 'The selected file is not a Karsten Slide Collection (.kbs).';
	SWarningFileNotFound = 'The selected file name is invalid.';

{ TSSConfigForm }

function TSSConfigForm.GetActiveUserTab: TUserProfile;
begin
	result := TUserProfile(PCUsers.ActivePage.PageIndex);
end;

procedure TSSConfigForm.PCUsersChanging(Sender: TObject;
	var AllowChange: Boolean);
begin
	FInstallScreenSaver[GetActiveUserTab] := CBInstallScr.Checked;
	FScreenSaverDoc[GetActiveUserTab] := EFSSDocPath.Text;
end;

procedure TSSConfigForm.PCUsersChange(Sender: TObject);
var
	aut: TUserProfile;
begin
	aut := GetActiveUserTab;
	CBInstallScr.Checked := FInstallScreenSaver[aut];
	EFSSDocPath.Text := FScreenSaverDoc[aut];
end;

procedure TSSConfigForm.SetCurrentBildersammlung(const Value: string);
begin
	FCurrentBildersammlung := Value;
	BSelectCurDoc.Enabled := Length(value)>0;
end;

procedure TSSConfigForm.SetInstallScreenSaver;
begin
	FInstallScreenSaver[user] := value;
	if GetActiveUserTab=user then CBInstallScr.Checked := value;
end;

function TSSConfigForm.GetInstallScreenSaver;
begin
	FInstallScreenSaver[GetActiveUserTab] := CBInstallScr.Checked;
	result := FInstallScreenSaver[user];
end;

procedure TSSConfigForm.SetScreenSaverDoc;
begin
	FScreenSaverDoc[user] := value;
	if GetActiveUserTab=user then EFSSDocPath.Text := value;
end;

function TSSConfigForm.GetScreenSaverDoc;
begin
	FScreenSaverDoc[GetActiveUserTab] := EFSSDocPath.Text;
	result := FScreenSaverDoc[user];
end;

procedure TSSConfigForm.BSelectCurDocClick(Sender: TObject);
begin
	EFSSDocPath.Text := FCurrentBildersammlung;
end;

procedure TSSConfigForm.BControlPanel(Sender: TObject);
var
  CmdLine: string;
  CurDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  CmdLine := 'rundll32.exe desk.cpl,InstallScreenSaver "' + KarstenScrPath + '"';
  CurDir := GetWindowsSystemFolder;
  FillMemory(@StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.cb := SizeOf(StartupInfo);
  FillMemory(@ProcessInfo, SizeOf(ProcessInfo), 0);
  if CreateProcess(nil, PChar(CmdLine), nil, nil, false, 0, nil,
    PChar(CurDir), StartupInfo, ProcessInfo)
  then begin
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end else begin
    RaiseLastOSError;
  end;
end;

procedure TSSConfigForm.BFindSSDocPathClick(Sender: TObject);
var
	neuDir, altDir: string;

	function SetNeuDir(value: string):boolean;
	begin
		result := (value <> '') and DirectoryExists(value);
		if result then neuDir := value;
	end;
begin
	with OpenSSDocDialog do begin
		if not SetNeuDir(ExtractFilePath(EFSSDocPath.Text)) then
			if not SetNeuDir(altDir) then
				if not SetNeuDir(ExtractFilePath(ScreenSaverDoc[GetActiveUserTab])) then
					if not SetNeuDir(ExtractFilePath(CurrentBildersammlung)) then
						neuDir := '';
		FileName := '';
		InitialDir := neuDir;
		Options := Options-[ofExtensionDifferent];
		if Execute then begin
			InitialDir := ExtractFileDir(FileName);
			EFSSDocPath.Text := FileName;
		end else begin
			InitialDir := altDir;
		end;
	end;
end;

procedure TSSConfigForm.EFSSDocPathChange(Sender: TObject);
begin
	FTabModified[GetActiveUserTab] := true;
end;

procedure TSSConfigForm.CBInstallScrClick(Sender: TObject);
begin
	FTabModified[GetActiveUserTab] := true;
end;

procedure TSSConfigForm.FormCreate;
const
	RegClass: array[TUserProfile] of TUserRegistryClass =
		(TUserRegistry, TDefUserRegistry);
var
	uidx: TUserProfile;
begin
  TranslateComponent(Self);
	for uidx := Low(TUserProfile) to High(TUserProfile) do begin
		FRegPrivilege[uidx] := true;
		try
			UserRegistry[uidx] := RegClass[uidx].Create;
		except
			on ERegistryException do begin
				FRegPrivilege[uidx] := false;
				PCUsers.Pages[Ord(uidx)].TabVisible := false;
			end;
		end;
		if FRegPrivilege[uidx] then begin
			ScreenSaverDoc[uidx] := UserRegistry[uidx].ScrDokument;
			oldInstallScreenSaver[uidx] := UserRegistry[uidx].ScrActive;
			InstallScreenSaver[uidx] := oldInstallScreenSaver[uidx];
		end;
		FTabModified[uidx] := false;
	end;
end;

procedure TSSConfigForm.FormDestroy;
var
	uidx: TUserProfile;
begin
	for uidx := Low(TUserProfile) to High(TUserProfile) do
    UserRegistry[uidx].Free;
end;

procedure TSSConfigForm.FormCloseQuery;
var
	uidx: TUserProfile;
begin
	if ModalResult = mrOk then begin
		for uidx := Low(TUserProfile) to High(TUserProfile) do begin
			if InstallScreenSaver[uidx] then begin
				if not FileExists(ScreenSaverDoc[uidx]) then begin
					PCUsers.ActivePage := PCUsers.Pages[Ord(uidx)];
					MessageDlg(sWarningFileNotFound, mtWarning, [mbOk], 0);
					CanClose := false;
				end else begin
					if not SameText(ExtractFileExt(ScreenSaverDoc[uidx]),
						OpenSSDocDialog.DefaultExt)
          then begin
            PCUsers.ActivePage := PCUsers.Pages[Ord(uidx)];
            MessageDlg(sWarningNotAKBS, mtWarning, [mbOk], 0);
            CanClose := false;
          end;
				end;
			end;
    end;
	end;
end;

procedure TSSConfigForm.FormClose;
var
	uidx: TUserProfile;
begin
	if ModalResult = mrOk then begin
		for uidx := Low(TUserProfile) to High(TUserProfile) do begin
			if FRegPrivilege[uidx] and FTabModified[uidx] then begin
        UserRegistry[uidx].Access := KEY_READ or KEY_WRITE;
				if InstallScreenSaver[uidx] then
					UserRegistry[uidx].ScrDokument := ScreenSaverDoc[uidx];
				if InstallScreenSaver[uidx] <> oldInstallScreenSaver[uidx] then
					UserRegistry[uidx].ScrActive := InstallScreenSaver[uidx];
			end;
    end;
	end;
end;

end.

