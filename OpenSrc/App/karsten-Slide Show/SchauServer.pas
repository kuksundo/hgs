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
 * The Original Code is SchauServer.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: SchauServer.pas 130 2008-11-29 05:18:08Z hiisi $ }

{
@abstract COM server for slide shows
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2002/12/28
@cvs $Date: 2008-11-28 23:18:08 -0600 (Fr, 28 Nov 2008) $
}
unit SchauServer;

interface

uses
	Globals, Windows, Classes, Forms, SysUtils, ComObj, ActiveX, AxCtrls, Messages,
	karsten_TLB,sammlung, schaufen, autoserv, StdVcl;

type
	TKarstenSchauServer = class(TKarstenServer, IKarstenSchauServer)
	private
		FSchaufenster: TSchaufenster;
    FModusVorwahl: TAnzeigeModus;
    FMonitorIndex: integer;
		function	GetSchaufenster: TSchaufenster;
	protected
		function	CreateSammlung: TBildersammlung; override;
		function	CreateSchaufenster: TSchaufenster; virtual;
    function  Get_MonitorIndex: Integer; safecall;
    procedure Set_MonitorIndex(Value: Integer); safecall;
		property	Schaufenster: TSchaufenster read GetSchaufenster;
    function  Get_ViewerWindow: LongWord; safecall;
    procedure Set_ViewerWindow(Value: LongWord); safecall;
		procedure SchauStart; safecall;
		procedure SchauStop; safecall;
    property  ModusVorwahl: TAnzeigeModus read FModusVorwahl write FModusVorwahl;
    procedure SchaufensterInvalidWindow(Sender: TObject; E: Exception);
	public
		procedure Initialize; override;
		destructor Destroy; override;
		property  ViewerWindow: LongWord read Get_ViewerWindow write Set_ViewerWindow;
    property  MonitorIndex: Integer read Get_MonitorIndex write Set_MonitorIndex;
	end;

implementation

uses
  ComServ;

procedure TKarstenSchauServer.Set_ViewerWindow(Value: LongWord);
begin
  if value <> Schaufenster.ExternalWindow then
    Schaufenster.ExternalWindow := value;
  if (value <> 0) and IsWindow(value) then
    ModusVorwahl := amExtern
  else
    ModusVorwahl := amNormal;
end;

function TKarstenSchauServer.Get_ViewerWindow: LongWord;
begin
	result := Schaufenster.ExternalWindow;
end;

destructor TKarstenSchauServer.Destroy;
begin
	if Assigned(FSchaufenster) then UnhookOnClose;
	FreeAndNil(FSchaufenster);
	inherited;
end;

function TKarstenSchauServer.GetSchaufenster: TSchaufenster;
begin
	if not Assigned(FSchaufenster) then begin
		FSchaufenster := CreateSchaufenster;
		HookOnClose(FSchaufenster);
    FSchaufenster.OnInvalidWindow := SchaufensterInvalidWindow;
		FSchaufenster.Sammlung := Sammlung;
	end;
	Result := FSchaufenster;
end;

function TKarstenSchauServer.CreateSammlung: TBildersammlung;
begin
	Result := inherited CreateSammlung;
	if Assigned(FSchaufenster) then FSchaufenster.Sammlung := Result;
end;

function TKarstenSchauServer.CreateSchaufenster: TSchaufenster;
begin
	Result := TSchaufenster.Create(Application);
	Result.InhibitPainting := true;
end;

procedure TKarstenSchauServer.SchauStart;
var
  SF: TSchaufenster;
begin
  SF := Schaufenster;
  if (ModusVorwahl in [amNormal, amMaximiert, amMaxVollbild, amRahmenlos]) and (FMonitorIndex > 0) then
    SF.MonitorController.SetMonitor(FMonitorIndex);
  SF.AnzeigeModus := ModusVorwahl;
  SF.Angehalten := false;
  SF.InhibitPainting := false;
end;

procedure TKarstenSchauServer.SchauStop;
begin
	with Schaufenster do begin
		Angehalten := true;
	end;
end;

procedure TKarstenSchauServer.Initialize;
begin
  inherited;
  ModusVorwahl := amNormal;
end;

procedure TKarstenSchauServer.SchaufensterInvalidWindow;
begin
  if Assigned(FSchaufenster) then
    PostMessage(FSchaufenster.Handle, wm_Close, 0, 0);
end;

function TKarstenSchauServer.Get_MonitorIndex: Integer;
begin
  result := FMonitorIndex;
end;

procedure TKarstenSchauServer.Set_MonitorIndex(Value: Integer);
begin
  if Value <> FMonitorIndex then begin
    FMonitorIndex := Value;
    if Assigned(FSchaufenster) then
      FSchaufenster.MonitorController.SetMonitor(FMonitorIndex);
  end;
end;

initialization
	if IsFirstAppInstance then
		TAutoObjectFactory.Create(ComServer, TKarstenSchauServer, Class_KarstenSchauServer,
			ciMultiInstance, tmSingle);
end.
