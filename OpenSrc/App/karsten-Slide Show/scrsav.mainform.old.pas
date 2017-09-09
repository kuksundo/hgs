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

{ $Id: scrmainform.pas 54 2006-10-15 02:30:45Z hiisi $ }

{
@abstract Screen saver main form
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2000/04/01
@cvs $Date: 2006-10-14 21:30:45 -0500 (Sa, 14 Okt 2006) $

@link(TScrMain) manages the communication to the slide show via COM.
It is invisible since the actual slide show runs in a different window.
}
unit scrmainform;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ComObj, karsten_tlb, StdCtrls, ExtCtrls, ActiveX,
	karstenScrSav_TLB, globals, Grids, AxCtrls, StdVcl;

type
	tSSMode=(ssNormal, ssPreview, ssConfig, ssSetPwd);

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
	private
		KarstenServer: IKarstenServer;
		eventsIID: tIID;
		iEventSink: integer;
		doTerminate: boolean;
		procedure UpdateControls;
		procedure	RunKarsten;
	public
		procedure	Terminate;
	end;

type
	IKarstenServerEventSink = interface(IDispatch)
		['{82B80F4A-BAF9-11D3-A7E5-0000B4812410}']
		procedure UserTerminate; safecall;
	end;

	IKarstenSchauServerEventSink = interface(IKarstenServerEventSink)
		['{6EB7B402-07F2-11D4-A7E5-0000B4812410}']
	end;

	IKarstenSchonerServerEventSink = interface(IKarstenSchauServerEventSink)
		['{6EB7B40E-07F2-11D4-A7E5-0000B4812410}']
	end;

	IKarstenConfigServerEventSink = interface(IKarstenServerEventSink)
		['{6EB7B408-07F2-11D4-A7E5-0000B4812410}']
	end;

	TAutoNotify = class(TAutoObject, IAutoNotify,
		IKarstenServerEventSink, IKarstenSchauServerEventSink,
		IKarstenSchonerServerEventSink, IKarstenConfigServerEventSink)
	public
		ScrControlWin: TScrMain;
		procedure UserTerminate; safecall;
	end;

var
	ScrMain: TScrMain;
	ssMode: tSSMode;
	demoWnd: hWnd;

implementation
uses
  ComServ, gnugettext;

{$R *.DFM}

resourcestring
	SEServerCreate=
		'Karsten screen saver cannot start. '+
		'Please check that the application is installed properly. '#13#10+
		'Error message: %s';

{ TScrMain }

procedure TScrMain.CBServerLoadedClick(Sender: TObject);
begin
	if CBServerLoaded.Checked<>Assigned(KarstenServer) then begin
		if CBServerLoaded.Checked then RunKarsten else KarstenServer:=nil;
		UpdateControls;
	end;
end;

procedure TScrMain.UpdateControls;
var
	viewerWindow:hWnd;
	sWndExists:string;
begin
	CBServerLoaded.Checked:=Assigned(KarstenServer);
	if Assigned(Karstenserver) then begin
		EFScrDoc.Enabled:=true;
		EFScrDoc.Text:=KarstenServer.DocFileName;
		try
			viewerWindow:=(KarstenServer as IKarstenSchauServer).ViewerWindow;
			if IsWindow(viewerWindow) then sWndExists:='(gültig)'
				else sWndExists:='(ungültig)';
			SGDebugInfo.Cells[1,6]:=Format('$%x %s',[viewerWindow,sWndExists]);
		except
			SGDebugInfo.Cells[1,6]:='(kein Schauserver)';
		end;
	end else begin
		EFScrDoc.Enabled:=false;
	end;
	SGDebugInfo.Cells[1,7]:=Format('%u',[iEventSink]);
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
begin
	if Assigned(KarstenServer) then
		KarstenServer.DocFileName:=EFScrDoc.Text;
end;

procedure TScrMain.FormActivate(Sender: TObject);
begin
	UpdateControls;
end;

procedure TScrMain.FormShow(Sender: TObject);
begin
	ShowWindow(Application.Handle,sw_Hide);
	UpdateControls;
end;

procedure TScrMain.FormCreate(Sender: TObject);
var
	oldval:uint;
	sWndExists:string;
begin
  TranslateComponent(Self);
	with SGDebugInfo do begin
		colWidths[0]:=180;
		colWidths[1]:=Width-colWidths[0];
		RowCount:=8;
		Rows[0].CommaText:='Name,Wert';
		Rows[1].CommaText:=Format('win32Platform,%u',[win32Platform]);
		Rows[2].CommaText:='ParamStr(1),'+ParamStr(1);
		Rows[3].CommaText:='ParamStr(2),'+ParamStr(2);
		Rows[4].CommaText:=Format('ssMode,%u',[Ord(ssMode)]);
		if IsWindow(demoWnd) then sWndExists:='(gültig)'
			else sWndExists:='(ungültig)';
		Rows[5].CommaText:=Format('demoWnd,"$%x %s"',[demoWnd,sWndExists]);
		Rows[6].CommaText:='KarstenServer.ViewerWindow,';
		Rows[7].CommaText:='iEventSink,';
	end;
	iEventSink:=0;
	RunKarsten;
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
	if Assigned(KarstenServer) then begin
		if (iEventSink>0) then
			InterfaceDisconnect(KarstenServer,eventsIID,iEventSink);
		if ssMode<>ssConfig then
			(KarstenServer as IKarstenSchauServer).SchauStop;
		KarstenServer:=nil;
	end;
end;

procedure TScrMain.RunKarsten;
var
	ES:TAutoNotify;
begin
	Assert(ssMode in [ssNormal, ssPreview, ssConfig],
		'TScrMain.RunKarsten: Invalid ssMode parameter');
	doTerminate:=false;
	if not Assigned(KarstenServer) then begin
		ES:=TAutoNotify.Create;
		ES.ScrControlWin:=Self;
		try
			case ssMode of
				ssNormal,ssPreview: begin
					KarstenServer:=CoKarstenSchonerServer.Create;
					eventsIID:=DIID_IKarstenSchonerServerEvents;
				end;
				ssConfig: begin
					KarstenServer:=CoKarstenConfigServer.Create;
					eventsIID:=DIID_IKarstenConfigServerEvents;
				end;
			end;
			InterfaceConnect(KarstenServer,eventsIID,ES,iEventSink);
		except
			on E:Exception do begin
				MessageDlg(Format(seServerCreate,[E.Message]),mtError,[mbOK],0);
				ES.Free;
				Terminate;
			end;
		end;
	end;
	if Assigned(KarstenServer) then begin
		if ssMode=ssPreview then
			with (KarstenServer as IKarstenSchonerServer) do begin
				ViewerWindow:=demoWnd;
				PreviewMode:=true;
			end;
		if ssMode<>ssConfig then begin
      (KarstenServer as IKarstenSchauServer).SchauStart;
    end;
	end;
end;

procedure TScrMain.FormIdle(Sender: TObject; var Done: Boolean);
begin
	if doTerminate then Close;
end;

procedure TScrMain.Terminate;
begin
	doTerminate:=true;
	Application.OnIdle:=FormIdle;
end;

{ TAutoNotify }

procedure TAutoNotify.UserTerminate;
begin
	ScrControlWin.Terminate;
end;

initialization
	TAutoObjectFactory.Create(ComServer, TAutoNotify, Class_AutoNotify,
		ciInternal, tmSingle);
end.

