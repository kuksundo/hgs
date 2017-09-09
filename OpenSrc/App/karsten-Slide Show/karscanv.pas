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
 * The Original Code is karscanv.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: karscanv.pas 53 2006-10-14 05:52:07Z hiisi $ }

{
@abstract Extended canvas classes
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 1999/12/30
@cvs $Date: 2006-10-14 00:52:07 -0500 (Sa, 14 Okt 2006) $
}
unit KarsCanv;

interface

uses
  Windows, Classes, SysUtils, Graphics, Forms, globals;

type
	TKarstenCanvasKlasse = class of TKarstenCanvas;

  { @abstract Base class for slide show canvasses
    For display operations,
    ultimately a device context handle is needed.
    Depending on the slide show mode this handle is retrieved in different ways
    by classes that descend from this one.
    They essentially have to implement @link(CreateHandle)
    (which is declared in TCanvas) and @link(ReleaseHandle).

    Note: TCanvas is not truly polymorphic because @link(Handle)
    and its setter/getter are static methods.
    Be careful with this!
    The way we are using canvas classes in karsten is:
    For drawing on our own forms, @classname behaves just as if it were
    a TCanvas, so that it can be passed to functions that ask for a TCanvas.
    For drawing on other drawing surfaces where we don't have a TCanvas
    but only a window or DC handle, descendants of @classname provide
    the DC handle, and we must not call functions that ask for a TCanvas
    as parameter.  }
	TKarstenCanvas = class(TCanvas)
	private
		FOwner: TForm;
		FWindowHandle: HWnd;
		FPaintRefCount: integer;
		FHandleValid: boolean;
		function GetZeichenflaeche: tRect; virtual;
		function GetHandle: HDC; virtual;
		procedure SetHandle(Value: HDC); virtual;
		procedure SetWindowHandle(Value: HWnd); virtual;
	protected
    { Get a device context handle and assign it to the @link(Handle) property.
      The method is called by @link(BeginPaint) and @link(GetHandle)
      when a handle is required.
      This method must be implemented by descending classes.
      They don't need to call inherited. }
    procedure CreateHandle; override;
    { Releases the device context and sets @link(Handle) to 0.
      If the device context @link(Handle) has been created by @link(CreateHandle)
      it must be destroyed. }
		procedure ReleaseHandle; virtual;
		{ The owner form as specified in the constructor. }
		property Owner: TForm read FOwner;
		{ Window handle for display. Default: Owner.Handle }
		property WindowHandle: HWnd read FWindowHandle write SetWindowHandle;
	public
		constructor Create(AnOwner: TForm); virtual;
		destructor Destroy; override;
    { Prepare for painting and get a device context.
      Call this method before painting. }
		procedure BeginPaint; virtual;
    { End painting and release device context.
      Call this method after painting is done. }
		procedure EndPaint; virtual;

    { Return coordinates of the output rectangle. }
		property Zeichenflaeche: TRect read GetZeichenflaeche;
    { Handle of the device context.
      This property declaration hides the one declared in TCanvas,
      and sets the setter and getter of this class.
      Note that these methods are not declared virtual in TCanvas.
      @classname cannot be assigned to a TCanvas
      because TCanvas is not truly polymorphic in this respect. }
		property Handle: HDC read GetHandle write SetHandle;
	end;

  { @abstract Paints in the owner's client area }
	TClientCanvas = class(TKarstenCanvas)
	private
		function GetZeichenflaeche: tRect; override;
	protected
		procedure CreateHandle; override;
		procedure ReleaseHandle; override;
	end;

  { @abstract Paints in the owner's window by handle }
	TWindowCanvas = class(TKarstenCanvas)
	protected
		procedure CreateHandle; override;
		procedure ReleaseHandle; override;
	end;

  { @abstract Paints on the desktop }
	TDesktopCanvas = class(TKarstenCanvas)
	protected
		procedure CreateHandle; override;
		procedure ReleaseHandle; override;
	public
		constructor Create(Owner: TForm); override;
	end;

  { @abstract Paints in an external window specified by @link(WindowHandle)
    This is for windows that are not based on a Delphi TForm. }
	TExternalCanvas = class(TKarstenCanvas)
	protected
    { Creates a device context handle for the window.
      @raises @link(EInvalidWindowHandle)
      if the handle is invalid or the window is not visible. }
		procedure CreateHandle; override;
		procedure ReleaseHandle; override;
	public
    { Owner can be @nil in this class }
		constructor Create(Owner: TForm); override;
    { Handle of the display window
      Assign this property after construction and before painting
      (@link(BeginPaint)). }
		property WindowHandle;
	end;

	EInvalidWindowHandle = class(EKarstenException);

implementation
uses
  Dialogs;

resourcestring
	sInvalidDesktopHandle = 'Access to the desktop wallpaper is denied.';
	sInvalidWindowHandle = 'Invalid window handle %x.';
	sInvalidDCHandle = 'Invalid device context handle %x.';

{ TKarstenCanvas }

constructor TKarstenCanvas.Create;
begin
	inherited Create;
	fHandleValid:=false;
	FOwner:=AnOwner;
	fWindowHandle:=FOwner.Handle;
	fPaintRefCount:=0;
end;

function TKarstenCanvas.GetZeichenflaeche: tRect;
begin
	result:=ClipRect;
end;

procedure TKarstenCanvas.BeginPaint;
begin
	Inc(fPaintRefCount);
end;

procedure TKarstenCanvas.EndPaint;
begin
	if fPaintRefCount>0 then begin
		Dec(fPaintRefCount);
	end;
	if (fPaintRefCount=0) and fHandleValid then begin
		ReleaseHandle;
		fHandleValid:=false;
	end;
end;

procedure TKarstenCanvas.CreateHandle;
begin
  inherited;
end;

procedure TKarstenCanvas.ReleaseHandle;
begin
	fHandleValid:=false;
end;

destructor TKarstenCanvas.Destroy;
begin
	if fHandleValid then begin
		ReleaseHandle;
		fHandleValid:=false;
	end;
	inherited;
end;

procedure TKarstenCanvas.SetHandle;
begin
	inherited Handle:=value;
	fHandleValid:=value<>0;
end;

function TKarstenCanvas.GetHandle;
begin
	result:=inherited Handle;
	fHandleValid:=true;
end;

procedure TKarstenCanvas.SetWindowHandle(value: hWnd);
begin
	fWindowHandle:=value;
end;

{ TWindowCanvas }

procedure TWindowCanvas.CreateHandle;
begin
	if IsWindow(WindowHandle) then Handle:=GetWindowDC(WindowHandle);
end;

procedure TWindowCanvas.ReleaseHandle;
begin
	ReleaseDC(WindowHandle,Handle);
	Handle:=0;
end;

{ TDesktopCanvas }

constructor TDesktopCanvas.Create;
begin
	inherited;
	WindowHandle:=GetDesktopWindow;
	if WindowHandle=0 then
		raise EInvalidWindowHandle.Create(sInvalidDesktopHandle);
end;

procedure TDesktopCanvas.CreateHandle;
begin
	if IsWindow(WindowHandle) then Handle:=GetWindowDC(WindowHandle);
end;

procedure TDesktopCanvas.ReleaseHandle;
begin
	try
		ReleaseDC(WindowHandle,Handle);
	finally
		Handle:=0;
	end;
end;

{ TClientCanvas }

procedure TClientCanvas.CreateHandle;
begin
	Handle:=Owner.Canvas.Handle;
end;

procedure TClientCanvas.ReleaseHandle;
begin
	Handle:=0;
end;

function TClientCanvas.GetZeichenflaeche: tRect;
begin
	result:=Owner.ClientRect;
end;

{ TExternalCanvas }

constructor TExternalCanvas.Create(Owner: TForm);
begin
	inherited;
	fWindowHandle:=0;
end;

procedure TExternalCanvas.CreateHandle;
begin
	if IsWindow(WindowHandle) and IsWindowVisible(WindowHandle)
		then Handle:=GetDC(WindowHandle)
		else raise EInvalidWindowHandle.CreateFmt(sInvalidWindowHandle,[WindowHandle]);
	if Handle=0 then
		raise EInvalidWindowHandle.CreateFmt(sInvalidDCHandle,[Handle]);
end;

procedure TExternalCanvas.ReleaseHandle;
begin
	try
		ReleaseDC(WindowHandle,Handle);
	finally
		Handle:=0;
	end;
end;

end.
