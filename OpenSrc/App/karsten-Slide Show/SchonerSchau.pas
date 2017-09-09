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
 * The Original Code is SchonerSchau.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: SchonerSchau.pas 130 2008-11-29 05:18:08Z hiisi $ }

{
@abstract Screen saver slide show
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2000/04/23
@cvs $Date: 2008-11-28 23:18:08 -0600 (Fr, 28 Nov 2008) $

@link(TSchonerSchauFenster) runs a slide show as screen saver.
}
unit SchonerSchau;

//pendenzen
//-bildschirmblinken beim preview-start vermeiden

//test
//-konsistente implementation
//-preview/schoner-unterscheidung

interface

uses
	Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
	schaufen,Globals,karsreg, ExtCtrls, ImgList, Menus, StdCtrls, JvComponentBase,
  JvScreenSaveSuppress, ActnList, PngImageList, ActnPopup, AppEvnts;

type
	TSchonerSchauFenster = class(TSchaufenster)
    SchonerApplicationEvents: TApplicationEvents;
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SchonerApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure SchonerApplicationEventsMessage(var Msg: tagMSG;
      var Handled: Boolean);
	private
		FMouseThreshold: cardinal;
		FHookDeadTime: cardinal;
		LastMousePos: TPoint;
		LastCloseQueryTime: cardinal;
		FPreviewMode: boolean;
		FMessageHookActive: boolean;
		pwdLibName,pwdProcName: string;
		FOldProcessPriorityClass: cardinal;
		procedure SetPreviewMode(value:boolean);
	protected
		procedure	HookActivate(active: boolean);
		property	MessageHookActive: boolean read FMessageHookActive write HookActivate;
	public
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;
		property	PreviewMode: boolean read FPreviewMode write SetPreviewMode;
    { Minimum distance in pixels the mouse has to move before the screen saver exits. }
		property	MouseThreshold: cardinal read FMouseThreshold write FMouseThreshold;
    { Minimum delay in milliseconds between start and exit of the screen saver. }
		property	HookDeadTime: cardinal read FHookDeadTime write FHookDeadTime;
	end;

var
	SchonerSchauFenster: TSchonerSchauFenster;

implementation
uses
  gnugettext;

{$R *.DFM}

constructor TSchonerSchauFenster.Create(AOwner: TComponent);
var
	Reg: TUserRegistry;
begin
	inherited;
	Reg := TUserRegistry.Create;
	try
		FMouseThreshold := Reg.ScrMouseThreshold;
		FHookDeadTime := Reg.ScrHookDeadTime;
	finally
		Reg.Free;
	end;
	pwdLibName := 'password.cpl';
	pwdProcName := 'VerifyScreenSavePwd';
	OnCloseQuery := FormCloseQuery;
	{$ifndef debugging}
	FormStyle := fsStayOnTop;
	{$endif}
	FOldProcessPriorityClass := GetPriorityClass(GetCurrentProcess);
	SetPriorityClass(GetCurrentProcess, IDLE_PRIORITY_CLASS);
end;

destructor TSchonerSchauFenster.Destroy;
begin
	SetPriorityClass(GetCurrentProcess, FOldProcessPriorityClass);
	inherited;
end;

procedure TSchonerSchauFenster.SetPreviewMode;
begin
	if value <> FPreviewMode then begin
		FPreviewMode  :=  Value;
    HookActivate(not FPreviewMode);
	end;
end;

procedure TSchonerSchaufenster.HookActivate;
begin
	active := active and not PreviewMode {and platformID=VER_PLATFORM_WIN32_WINDOWS};
	if active <> FMessageHookActive then begin
		if active then begin
			Screen.Cursor := crNone;
		end else begin
			Screen.Cursor := crDefault;
		end;
		FMessageHookActive := active;
		GetCursorPos(LastMousePos);
		LastCloseQueryTime := GetTickCount;
	end;
end;

procedure TSchonerSchauFenster.SchonerApplicationEventsMessage;
	procedure SSQuit;
	begin
		PostMessage(Handle,wm_Close,0,0);
	end;
begin
	if FMessageHookActive and
		(cardinal(Abs(integer(GetTickCount) - integer(LastCloseQueryTime))) > HookDeadTime)
	then with msg do begin
		if
      (message = wm_ActivateApp) or (message = wm_Activate) or
			(message = wm_NCActivate) or
			((message >= wm_keyFirst) and (message <= wm_keyLast)) or
			((message >= wm_MouseFirst) and (message <= wm_MouseLast))
    then begin
      case message of
        wm_MouseMove: begin
          if cardinal(Sqr(LastMousePos.x - LoWord(msg.lParam))) +
            cardinal(Sqr(LastMousePos.y - HiWord(msg.lParam))) > Sqr(MouseThreshold)
          then
            SSQuit
          else begin
            LastMousePos.x := LoWord(msg.lParam);
            LastMousePos.y := HiWord(msg.lParam);
          end;
        end;
        else SSQuit;
      end;
      Handled := true;
    end;
	end;
end;

procedure TSchonerSchauFenster.FormCloseQuery;
type
	TVerifyScreenSavePwdProc=function(wnd:hWnd):wordbool; stdcall;
var
	hpwdcpl:tHandle;
	VerifySSPwd:TVerifyScreenSavePwdProc;
begin
	HookActivate(false);
	inherited;
	if canClose and not PreviewMode and (win32Platform=VER_PLATFORM_WIN32_WINDOWS) then begin
		try
			hpwdcpl := LoadLibrary(pChar(pwdLibName));
			try
				if hpwdcpl <> 0 then begin
					VerifySSPwd := GetProcAddress(hPwdCpl,pChar(pwdProcName));
					if @VerifySSPwd<>nil then canClose := VerifySSPwd(Handle);
				end;
			finally
				FreeLibrary(hPwdCpl);
			end;
		except
			on EExternal do canClose := true;
		end;
	end;
	if not canClose then HookActivate(true);
	LastCloseQueryTime := GetTickCount;
end;

procedure TSchonerSchauFenster.SchonerApplicationEventsIdle;
begin
  Done := true;
  inherited;
  if FPreviewMode then begin
    if not IsWindowVisible(ExternalWindow) then begin
      if Assigned(OnInvalidWindow) then
        OnInvalidWindow(Self, nil)
      else
        PostMessage(Handle, wm_Close, 0, 0);
    end else
      done := false;
  end else begin
    if not FMessageHookActive then HookActivate(true);
  end;
end;

end.
