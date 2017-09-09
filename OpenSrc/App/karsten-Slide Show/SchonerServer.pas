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
 * The Original Code is SchonerServer.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: SchonerServer.pas 52 2006-10-14 05:48:55Z hiisi $ }

{
@abstract COM server for slide shows
@author matthias muntwiler <hiisi@users.sourceforge.net>
@cvs $Date: 2006-10-14 00:48:55 -0500 (Sa, 14 Okt 2006) $
}
unit SchonerServer;

interface

uses
	SysUtils, ComObj, ActiveX, AxCtrls, Forms,
	globals, karsten_TLB, SchauServer, SchauFen, SchonerSchau, StdVcl;

type
	TKarstenSchonerServer = class(TKarstenSchauServer, IKarstenSchonerServer)
	private
		FPreviewMode: boolean;
		function	GetScrDocName: string;
	protected
		function	CreateSchaufenster: TSchaufenster; override;
		function	Get_PreviewMode: WordBool; safecall;
		procedure Set_PreviewMode(Value: WordBool); safecall;
	public
		procedure Initialize; override;
		property	PreviewMode: wordbool read Get_PreviewMode write Set_PreviewMode;
	end;

implementation

uses
  ComServ, KarsReg;

function TKarstenSchonerServer.CreateSchaufenster: TSchaufenster;
begin
	Result := TSchonerSchaufenster.Create(Application);
end;

function TKarstenSchonerServer.GetScrDocName: string;
var
	Reg: TUserRegistry;
begin
	Reg := TUserRegistry.Create;
	try
		result := Reg.ScrDokument;
	finally
		Reg.Free;
	end;
end;

function TKarstenSchonerServer.Get_PreviewMode: WordBool;
begin
	result := FPreviewMode;
end;

procedure TKarstenSchonerServer.Initialize;
begin
	inherited;
  ModusVorwahl := amMaxVollbild;
	DocFileName := GetScrDocName;
end;

procedure TKarstenSchonerServer.Set_PreviewMode(Value: WordBool);
begin
	if FPreviewMode xor value then begin
		FPreviewMode := value;
		(Schaufenster as TSchonerSchaufenster).PreviewMode := FPreviewMode;
	end;
end;

initialization
	if IsFirstAppInstance then
		TAutoObjectFactory.Create(ComServer, TKarstenSchonerServer, Class_KarstenSchonerServer,
			ciMultiInstance, tmSingle);
end.
