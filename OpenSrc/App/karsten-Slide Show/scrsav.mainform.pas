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
 * The Original Code is scrmainform.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: scrsav.mainform.pas 130 2008-11-29 05:18:08Z hiisi $ }

{
@abstract Screen saver main form
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2000-04-01
@cvs $Date: 2008-11-28 23:18:08 -0600 (Fr, 28 Nov 2008) $

@link(TScrMain) manages the communication to the slide show via COM.
It is invisible since the actual slide show runs in a different window.
}
unit scrsav.mainform;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ComObj, karsten_tlb, StdCtrls, ExtCtrls, ActiveX, contnrs, Math,
	karstenScrSav_TLB, globals, Grids, AxCtrls, StdVcl, scrsav.client;

type
	TScrMain = class(TForm)
		EFScrDoc: TEdit;
		LScrDoc: TLabel;
		CBServerLoaded: TCheckBox;
		BUpdate: TButton;
		BClose: TButton;
		LDebugInfo: TLabel;
		SGDebugInfo: TStringGrid;
		procedure FormCreate(Sender: TObject);
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure BUpdateClick(Sender: TObject);
		procedure BCloseClick(Sender: TObject);
		procedure EFScrDocChange(Sender: TObject);
		procedure FormActivate(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure CBServerLoadedClick(Sender: TObject);
		procedure	FormIdle(Sender: TObject; var Done: Boolean);
    procedure FormDestroy(Sender: TObject);
	private
    FClients: TObjectList;
		doTerminate: boolean;
    function GetClientCount: integer;
    function GetClients(index: integer): TScrSavClient;
  protected
    property  ClientCount: integer read GetClientCount;
    property  Clients[index: integer]: TScrSavClient read GetClients;
		procedure UpdateControls;
		procedure StartClients;
    procedure StopClients;
		procedure	ClientTerminate(Sender: TObject);
	end;

var
	ScrMain: TScrMain;
	ssMode: TScrSavMode;
	demoWnd: hWnd;

implementation
uses
  gnugettext;

{$R *.DFM}

{ TScrMain }

procedure TScrMain.CBServerLoadedClick(Sender: TObject);
begin
	if CBServerLoaded.Checked <> (FClients.Count > 0) then begin
		if CBServerLoaded.Checked then StartClients else StopClients;
		UpdateControls;
	end;
end;

procedure TScrMain.UpdateControls;
var
  SelClient: TScrSavClient;
	viewerWindow: hWnd;
	sWndExists: string;
begin
	CBServerLoaded.Checked := ClientCount > 0;
	if ClientCount > 0 then begin
    SelClient := Clients[0];
		EFScrDoc.Enabled := true;
		EFScrDoc.Text := SelClient.KarstenServer.DocFileName;
		try
			viewerWindow := (SelClient.KarstenServer as IKarstenSchauServer).ViewerWindow;
			if IsWindow(viewerWindow) then
        sWndExists := _('(valid)')
      else
        sWndExists := _('(invalid)');
			SGDebugInfo.Cells[1,6] := Format('$%x %s', [viewerWindow, sWndExists]);
		except
			SGDebugInfo.Cells[1,6] := _('(no server)');
		end;
  	SGDebugInfo.Cells[1,7] := Format('%u', [SelClient.EventSinkIdx]);
	end else begin
		EFScrDoc.Enabled := false;
	end;
end;

procedure TScrMain.BUpdateClick(Sender: TObject);
begin
	UpdateControls;
end;

procedure TScrMain.BCloseClick(Sender: TObject);
begin
	Close;
end;

procedure TScrMain.EFScrDocChange(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ClientCount - 1 do
    Clients[i].KarstenServer.DocFileName := EFScrDoc.Text;
end;

procedure TScrMain.FormActivate(Sender: TObject);
begin
	UpdateControls;
end;

procedure TScrMain.FormShow(Sender: TObject);
begin
	ShowWindow(Application.Handle, sw_Hide);
	UpdateControls;
end;

procedure TScrMain.FormCreate(Sender: TObject);
var
	oldval: uint;
	sWndExists: string;
begin
  TranslateComponent(Self);
  FClients := TObjectList.Create(true);
	with SGDebugInfo do begin
		colWidths[0] := 180;
		colWidths[1] := Width - colWidths[0];
		RowCount := 8;
		Rows[0].CommaText := _('Name,Value');
		Rows[1].CommaText := Format('win32Platform,%u',[win32Platform]);
		Rows[2].CommaText := 'ParamStr(1),'+ParamStr(1);
		Rows[3].CommaText := 'ParamStr(2),'+ParamStr(2);
		Rows[4].CommaText := Format('ssMode,%u',[Ord(ssMode)]);
		if IsWindow(demoWnd) then
      sWndExists := _('(valid)')
    else
      sWndExists := _('(invalid)');
		Rows[5].CommaText := Format('demoWnd,"$%x %s"', [demoWnd, sWndExists]);
		Rows[6].CommaText := 'KarstenServer.ViewerWindow,';
		Rows[7].CommaText := 'iEventSink,';
	end;
	StartClients;
	{ $ifndef debugging}
	if (ssMode=ssNormal) {and (win32platform=VER_PLATFORM_WIN32_WINDOWS)}
		then SystemParametersInfo(SPI_SCREENSAVERRUNNING,1,@oldval,0);
	{ $endif}
	UpdateControls;
end;

procedure TScrMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
	oldval:uint;
begin
	{ $ifndef debugging}
	if (ssMode=ssNormal) {and (win32platform=VER_PLATFORM_WIN32_WINDOWS)}
		then SystemParametersInfo(SPI_SCREENSAVERRUNNING,0,@oldval,0);
	{ $endif}
  StopClients;
end;

procedure TScrMain.FormDestroy(Sender: TObject);
begin
  StopClients;
  FreeAndNil(FClients);
end;

function TScrMain.GetClientCount;
begin
  result := FClients.Count;
end;

function TScrMain.GetClients;
begin
  result := FClients[index] as TScrSavClient;
end;

procedure TScrMain.StartClients;
var
  n: integer;
  i: integer;
  Client: TScrSavClient;
begin
	Assert(ssMode in [ssNormal, ssPreview, ssConfig],
		'TScrMain.RunKarsten: Invalid ssMode parameter');

  if ssMode = ssNormal then n := Screen.MonitorCount else n := 1;
  if ClientCount = 0 then begin
    for i := 0 to n - 1 do begin
      Client := TScrSavClient.Create;
      Client.OnTerminate := ClientTerminate;
      FClients.Add(Client);
    end;
  end;
  for i := 0 to ClientCount - 1 do begin
    Clients[i].Start(ssMode, demoWnd, Min(i + 1, n));
  end;

  doTerminate := false;
end;

procedure TScrMain.StopClients;
var
  i: integer;
begin
  for i := FClients.Count - 1 downto 0 do begin
    Clients[i].Stop;
    FClients.Delete(i);
  end;
end;

procedure TScrMain.FormIdle(Sender: TObject; var Done: Boolean);
begin
	if doTerminate then Close;
  Done := true;
end;

procedure TScrMain.ClientTerminate;
begin
	doTerminate := true;
	Application.OnIdle := FormIdle;
end;

end.

