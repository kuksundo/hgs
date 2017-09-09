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
 * The Original Code is ConfigServer.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: ConfigServer.pas 52 2006-10-14 05:48:55Z hiisi $ }

{
@abstract COM server for screen saver configuration
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2000/04/04
@cvs $Date: 2006-10-14 00:48:55 -0500 (Sa, 14 Okt 2006) $
}
unit ConfigServer;

interface

uses
	ComObj, ActiveX, AxCtrls, Forms, SysUtils,
	globals, karsten_TLB, autoserv, sammlung, sammelfen, StdVcl;

type
	TKarstenConfigServer = class(TKarstenServer, IKarstenConfigServer)
	private
		FSammlungsfenster: TCollectionForm;
		function	GetSammlungsfenster: TCollectionForm;
	protected
    { Retrieve the file name of the document that is currently selected for the
      screen saver from the registry. }
		function	GetScrDocName: string;
    { Write the file name of the document to be selected for the
      screen saver to the registry. }
    procedure SetScrDocName(const Value: string);
		function	CreateSammlung: TBildersammlung; override;
		{ This method hooks into the OnClose event of the automated form.
      Use @link(HookOnclose) and @link(UnhookOnClose) to set/remove the hook. }
		procedure FormClose(Sender: TObject; var Action: TCloseAction); override;
    { Implements @link(IKarstenConfigServer.Get_DocFileName) }
		function	Get_DocFileName: WideString; override; safecall;
    { Implements @link(IKarstenConfigServer.Set_DocFileName) }
		procedure Set_DocFileName(const Value: WideString); override; safecall;
	public
		procedure Initialize; override;
		destructor	Destroy; override;
		property  Sammlungsfenster: TCollectionForm read GetSammlungsfenster;
	end;

implementation

uses
  ComServ, KarsReg;

procedure TKarstenConfigServer.Initialize;
begin
	inherited;
	DocFileName := GetScrDocName;
	if FileExists(DocFilename) then Sammlungsfenster.FileOpen(DocFilename);
	Sammlungsfenster.Show;
end;

function TKarstenConfigServer.GetScrDocName;
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

procedure TKarstenConfigServer.SetScrDocName;
var
	Reg: TUserRegistry;
begin
	Reg := TUserRegistry.Create;
	try
		Reg.ScrDokument := Value;
	finally
		Reg.Free;
	end;
end;

function TKarstenConfigServer.GetSammlungsfenster;
begin
	if not Assigned(FSammlungsfenster) then begin
		FSammlungsfenster := TCollectionForm.Create(Application);
		HookOnClose(FSammlungsfenster);
		FSammlungsfenster.Sammlung := Sammlung;
    FSammlungsfenster.ScreenSaverConfigMode := true;
	end;
	Result := FSammlungsfenster;
end;

function TKarstenConfigServer.CreateSammlung;
begin
	Result := inherited CreateSammlung;
	if Assigned(FSammlungsfenster) then FSammlungsfenster.Sammlung := Result;
end;

function TKarstenConfigServer.Get_DocFileName;
begin
	if Assigned(FSammlungsfenster) then begin
		result := FSammlungsfenster.Filename;
	end else
		result := inherited Get_DocFilename;
end;

procedure TKarstenConfigServer.Set_DocFileName;
begin
	inherited;
	if Assigned(FSammlungsfenster) then FSammlungsfenster.FileOpen(value);
end;

procedure TKarstenConfigServer.FormClose;
begin
  SetScrDocName(DocFileName);
  inherited;
end;

destructor TKarstenConfigServer.Destroy;
begin
	FreeAndNil(FSammlungsfenster);
	inherited;
end;

initialization
	if IsFirstAppInstance then
		TAutoObjectFactory.Create(ComServer, TKarstenConfigServer, Class_KarstenConfigServer,
			ciMultiInstance, tmSingle);
end.
