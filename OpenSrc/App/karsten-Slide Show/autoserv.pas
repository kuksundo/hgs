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
 * The Original Code is autoserv.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: autoserv.pas 52 2006-10-14 05:48:55Z hiisi $ }

{
@abstract Implements TKarstenServer class
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 1999/12/25
@cvs $Date: 2006-10-14 00:48:55 -0500 (Sa, 14 Okt 2006) $
}
unit autoserv;

interface

uses
	ComObj, ActiveX, AxCtrls, karsten_TLB, Windows, Forms, SysUtils,
	ComServ, Globals, sammlung, StdVcl;

type
	TKarstenServer = class(TAutoObject, IConnectionPointContainer, IKarstenServer)
	private
		FConnectionPoints: TConnectionPoints;
		FEvents: IKarstenServerEvents;
		FOriginalOnClose: TCloseEvent;
		FHookedForm: TForm;
		fDocFileName: widestring;
		FSammlung: TBildersammlung;
		function	GetSammlung: TBildersammlung; virtual;
	protected
		property ConnectionPoints: TConnectionPoints read FConnectionPoints
			implements IConnectionPointContainer;
		procedure EventSinkChanged(const EventSink: IUnknown); override;
		procedure	HookOnClose(const AutomatedForm: TForm); virtual;
		procedure	UnhookOnClose; virtual;
		function	Get_DocFileName: WideString; virtual; safecall;
		procedure Set_DocFileName(const Value: WideString); virtual; safecall;
		function	CreateSammlung: TBildersammlung; virtual;
		{ This method hooks into the OnClose event of the automated form.
      Use @link(HookOnclose) and @link(UnhookOnClose) to set/remove the hook. }
		procedure FormClose(Sender: TObject; var Action: TCloseAction); virtual;
	public
		procedure Initialize; override;
		destructor Destroy; override;
		property	DocFileName: widestring read Get_DocFileName write Set_DocFileName;
		property	Sammlung: TBildersammlung read GetSammlung;
	end;

implementation

{ TKarstenServer }

function TKarstenServer.Get_DocFileName: WideString;
begin
	result := fDocFileName;
end;

procedure TKarstenServer.Set_DocFileName(const Value: WideString);
begin
	if value<>fDocFileName then begin
		if Assigned(FSammlung) then FSammlung.FreeAll;
		Sammlung.LoadFromFile(value);
		fDocFileName := value;
	end;
end;

function TKarstenServer.GetSammlung: TBildersammlung;
begin
	if not Assigned(FSammlung) then FSammlung := CreateSammlung;
	Result := FSammlung;
end;

function TKarstenServer.CreateSammlung: TBildersammlung;
begin
	Result := TBildersammlung.Create;
end;

destructor TKarstenServer.Destroy;
begin
	FHookedForm := nil;
	FOriginalOnClose := nil; // oder besser ein richtiges UnHook??? -> erben
	FSammlung.Free; FSammlung := nil;
	inherited;
end;

procedure TKarstenServer.EventSinkChanged(const EventSink: IUnknown);
begin
	FEvents := EventSink as IKarstenServerEvents;
end;

procedure TKarstenServer.FormClose(Sender: TObject;
	var Action: TCloseAction);
begin
	if Assigned(FOriginalOnClose) then FOriginalOnClose(Sender, Action);
	if Assigned(FEvents) then begin
    FEvents.UserTerminate;
    action := caNone;
  end else begin
    action := caFree;
  end;
end;

procedure TKarstenServer.HookOnClose(const AutomatedForm: TForm);
begin
	if Assigned(AutomatedForm) then begin
		UnhookOnClose;
		FOriginalOnClose := AutomatedForm.OnClose;
		AutomatedForm.OnClose := FormClose;
		FHookedForm := AutomatedForm;
	end;
end;

procedure TKarstenServer.UnhookOnClose;
begin
	try
		FHookedForm.OnClose := FOriginalOnClose;
	except
	end;
	FHookedForm := nil;
	FOriginalOnClose := nil;
end;

procedure TKarstenServer.Initialize;
var
	CE:TConnectEvent;
	CP1,CP2:IConnectionPoint;
begin
	inherited Initialize;
	CE := EventConnect;
	FConnectionPoints := TConnectionPoints.Create(Self);
	if AutoFactory.EventTypeInfo <> nil then begin
		CP1 := FConnectionPoints.CreateConnectionPoint(DIID_IKarstenServerEvents,ckSingle,CE);
		CP2 := FConnectionPoints.CreateConnectionPoint(AutoFactory.EventIID,ckSingle,CE);
	end;
end;

initialization
	if IsFirstAppInstance then
		TAutoObjectFactory.Create(ComServer, TKarstenServer, Class_KarstenServer,
			ciMultiInstance, tmApartment);
end.


