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
 * The Original Code is scrsav.client.pas of Karsten Bilderschau, version 3.5.0.
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2008
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

{ $Id: scrsav.client.pas 130 2008-11-29 05:18:08Z hiisi $ }

{
@abstract Screen saver client
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2008-11-28
@cvs $Date: 2008-11-28 23:18:08 -0600 (Fr, 28 Nov 2008) $
}
unit scrsav.client;

interface
uses
	Windows, Messages, SysUtils, Classes, ComObj, ActiveX, Dialogs,
	globals, karsten_tlb, karstenScrSav_TLB, StdVcl;

type
  { Screen saver mode }
	TScrSavMode = (
    ssNormal,   //< Full-screen multi-monitor slide-show
    ssPreview,  //< Preview the slide show in an existing window (e.g. control panel)
    ssConfig,   //< Open the collection window to configure the slides
    ssSetPwd);  //< Display the system change-password dialog

type
  { @abstract Client class to control one karsten server }
	TScrSavClient = class
	private
		FKarstenServer: IKarstenServer;
		FEventsIID: TIID;
		FEventSinkIdx: integer;
    FOnTerminate: TNotifyEvent;
    FMode: TScrSavMode;
    FMonitorIdx: integer;
    FDemoWnd: HWnd;
  protected
    { Triggers the @link(OnTerminate) event.
      The method does not do anything else.
      The owner should call @link(Stop) to end the server. }
		procedure	Terminate;
	public
    { Creates and initializes a client instance.
      Does not connect to the server, this is done by @link(Start). }
    constructor Create;
    { Destroys the client instance.
      @link(Stop) should be called before the client is destroyed. }
    destructor  Destroy; override;
    { Exposes the server for status information.
      This property is assigned by @link(Start)
      and released by @link(Stop). }
    property  KarstenServer: IKarstenServer read FKarstenServer;
    { Exposes the event sink index for status information. }
    property  EventSinkIdx: integer read FEventSinkIdx;
    { Stores the screen saver mode.
      This property is set by @link(Start). }
    property  Mode: TScrSavMode read FMode;
    { Stores the handle of the demo window
      if the screen saver runs in a specific window (@link(Mode) = ssPreview).
      This property is set by @link(Start). }
    property  DemoWnd: HWnd read FDemoWnd;
    { Stores the monitor index + 1 (Screen.Monitors)
      where this slide show runs.
      0 = no specific monitor, 1 = primary monitor, 2 = secondary, etc.
      This is meaningful only if @link(Mode) = ssNormal.
      This property is set by @link(Start). }
    property  MonitorIdx: integer read FMonitorIdx;
    { Creates and starts the karsten server
      according to the arguments.
      @param(AMode server mode)
      @param(ADemoWnd handle of the demo window if AMode = ssPreview)
      @param(AMonitorIdx Index + 1 of the target monitor (Screen.Monitors)
        if AMode = ssNormal.
        0 = no specific monitor, 1 = primary monitor, 2 = secondary, etc.) }
    procedure Start(AMode: TScrSavMode; ADemoWnd: HWnd; AMonitorIdx: integer);
    { Stops and releases the karsten server. }
    procedure Stop;
    { Notifies the owner when the server shuts down.
      The owner should queue a message to the application message queue
      which will call @link(Stop) and destroy the client.
      The client must not be destroyed in the event handler directly. }
    property  OnTerminate: TNotifyEvent read FOnTerminate write FOnTerminate;
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

  { @abstract Event sink for karsten server events }
	TAutoNotify = class(TAutoObject, IAutoNotify,
		IKarstenServerEventSink, IKarstenSchauServerEventSink,
		IKarstenSchonerServerEventSink, IKarstenConfigServerEventSink)
  private
    FClient: TScrSavClient;
	public
    { Creates an instance of the event sink.
      @param(AClient will receive the events dispatched by the server) }
    constructor Create(AClient: TScrSavClient);
    { Exposes the Client that will receive the events. }
		property  Client: TScrSavClient read FClient;
    { Implements @link(IKarstenServerEventSink.UserTerminate).
      Calls @link(Client.Terminate). }
		procedure UserTerminate; safecall;
	end;

implementation
uses
  ComServ;

resourcestring
	SEServerCreate=
		'Karsten screen saver cannot start. '+
		'Please check that the application is installed properly. '#13#10+
		'Error message: %s';

{ TAutoNotify }

constructor TAutoNotify.Create(AClient: TScrSavClient);
begin
  inherited Create;
  FClient := AClient;
end;

procedure TAutoNotify.UserTerminate;
begin
  if Assigned(Client) then Client.Terminate;
end;

{ TScrSavClient }

constructor TScrSavClient.Create;
begin
  inherited Create;
	FEventSinkIdx := 0;
end;

destructor TScrSavClient.Destroy;
begin
  inherited;
end;

procedure TScrSavClient.Start;
var
	ES: TAutoNotify;
begin
	if not Assigned(KarstenServer) then begin
    FMode := AMode;
		ES := TAutoNotify.Create(Self);
		try
			case FMode of
				ssNormal, ssPreview: begin
					FKarstenServer := CoKarstenSchonerServer.Create;
					FEventsIID := DIID_IKarstenSchonerServerEvents;
				end;
				ssConfig: begin
					FKarstenServer := CoKarstenConfigServer.Create;
					FEventsIID := DIID_IKarstenConfigServerEvents;
				end;
			end;
			InterfaceConnect(KarstenServer, FEventsIID, ES, FEventSinkIdx);
		except
			on E: Exception do begin
				MessageDlg(Format(SEServerCreate, [E.Message]), mtError, [mbOK], 0);
				ES.Free;
				Terminate;
			end;
		end;
	end;
	if Assigned(KarstenServer) then begin
    FDemoWnd := ADemoWnd;
    FMonitorIdx := AMonitorIdx;
    case FMode of
      ssNormal: begin
        with KarstenServer as IKarstenSchauServer do begin
          MonitorIndex := FMonitorIdx;
          SchauStart;
        end;
      end;
      ssPreview: begin
        with KarstenServer as IKarstenSchonerServer do begin
          ViewerWindow := FDemoWnd;
          PreviewMode := true;
          SchauStart;
        end;
      end;
      ssConfig: {no further action};
      ssSetPwd: {not supported};
    end;
	end;
end;

procedure TScrSavClient.Stop;
begin
	if Assigned(KarstenServer) then begin
		if (FEventSinkIdx > 0) then
			InterfaceDisconnect(KarstenServer, FEventsIID, FEventSinkIdx);
		if FMode <> ssConfig then
			(KarstenServer as IKarstenSchauServer).SchauStop;
		FKarstenServer := nil;
	end;
end;

procedure TScrSavClient.Terminate;
begin
  if Assigned(FOnTerminate) then FOnTerminate(Self);
end;

initialization
	TAutoObjectFactory.Create(ComServer, TAutoNotify, Class_AutoNotify,
		ciInternal, tmSingle);
end.

