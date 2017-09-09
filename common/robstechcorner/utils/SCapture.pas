unit SCapture;
// MIT License
//
// Copyright (c) 2009 - Robert Love
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//
//  Many thanks to Zarko Gajic, for this article as it was my starting point.
//  http://delphi.about.com/od/adptips2006/qt/captureactive.htm
interface
uses
  Windows, SysUtils, Graphics, MultiMon;

type
  EMonitorCaptureException = class(Exception);

// TCaptureContext Enumerated values and meanings.
//   ccActiveWindow: Capture an image of the ActiveWindow only.
// ccDesktopMonitor: Capture an image of the first / primary monitor
//                   Note: Avoids MultiMon calls, so it would be faster
//                         than ccSpecificMonitor with index of 1
//  ccActiveMonitor: Capture an image of the monitor with the active window on
//                   it.  If the active window is on more than one monitor it
//                   will pick the monitor that has the larger portion of the
//                   window on it.   If the active window is not in the visible
//                   space of any monitor, it will pick the closest one.
//ccSpecificMonitor: Capture an Image of a Specific Monitor specified by
//                   the aMonitorNum parameter.  Note: aMonitorNum the first
//                   monitor is 1.   You can use the MonitorCount function
//                   to determine the valid range of monitors.
//                   An EMonitorCaptureException will occur if you select a
//                   monitor number outside the valid range.
//    ccAllMonitors: Capture a single image of all the monitors.
  TCaptureContext = (ccActiveWindow,ccDesktopMonitor,ccActiveMonitor,
                     ccSpecificMonitor,ccAllMonitors);


// Return the Number of Monitors user has.
// Note: This can change during a windows Session
//       Example: Remote Desktop Session, Laptop/Projector Settings
function MonitorCount : Integer;

// This captures Screen with the given TCaptureContext into the destBitmap
procedure CaptureScreen(aCaptureContext : TCaptureContext; destBitmap : TBitmap;aMonitorNum : Integer = 1);

procedure CaptureRect(aCaptureRect : TRect;destBitMap : TBitmap); inline;

procedure CaptureDeviceContext(SrcDC: HDC;aCaptureRect : TRect;destBitMap : TBitmap); inline;

function GetMonInfoByIdx(MonIdx : Integer) : MONITORINFO;

implementation


type
  MonIndex = record
    Idx : Integer;
    Cnt : Integer;
    MonInfo : MONITORINFO;
  end;
  PMonIndex = ^MonIndex;


// Callback function in function MonitorCount
function MonCountCB(hm: HMONITOR; dc: HDC; r: PRect; l: LPARAM): Boolean; stdcall;
begin
  inc(Integer(pointer(l)^));
  result := true;
end;

function MonitorCount : Integer;
begin
  result := 0;
  EnumDisplayMonitors(0,nil,MonCountCB, Integer(@result));
end;

// Callback function in function GetMonInfoByIdx
function MonInfoCB(hm: HMONITOR; dc: HDC; r: PRect; l: LPARAM): Boolean; stdcall;
var
 MI : PMonIndex;
begin
  MI := PMonIndex(pointer(l));
  Inc(MI.Cnt);
  if MI.Cnt = MI.Idx then
     GetMonitorInfo(hm,@(MI.MonInfo));
  result := true;
end;

function GetMonInfoByIdx(MonIdx : Integer) : MONITORINFO;
var
 MI : MonIndex;
begin
  MI.MonInfo.cbSize := SizeOf(MI.MonInfo);
  MI.Idx := MonIdx;
  MI.Cnt := 0;
  EnumDisplayMonitors(0,nil,MonInfoCB, Integer(@MI));
  result := MI.MonInfo;
end;


procedure CaptureScreen(aCaptureContext : TCaptureContext; destBitmap : TBitmap;aMonitorNum : Integer);
var
   DC : HDC;
   h  : HWND;
   Mon : HMONITOR;
   MonInfo : MONITORINFO;
   lCapRect : TRect;
begin
  Assert(Assigned(destBitMap));
  h := 0;
  FillMemory(@lCapRect,SizeOf(TRect),0);
  dc := CreateDC('DISPLAY',nil,nil,nil);
  try
    // Determine the Rect to Clip for the Capture
    case aCaptureContext of
      ccActiveWindow:
      begin
        h   := GetForegroundWindow;
        GetWindowRect(h,lCapRect);
      end;
      ccDesktopMonitor:
      begin
       // This gets only the first/primary monitor
        lCapRect.Right  := GetDeviceCaps (DC, HORZRES);
        lCapRect.Bottom := GetDeviceCaps (DC, VERTRES);
      end;
      ccActiveMonitor:
      begin
        h  := GetForegroundWindow;
        Mon := MonitorFromWindow(h,MONITOR_DEFAULTTONEAREST);
        MonInfo.cbSize := SizeOf(MonInfo);
        GetMonitorInfo(Mon,@MonInfo);
        lCapRect := MonInfo.rcMonitor;
      end;
      ccSpecificMonitor:
      begin
        if (MonitorCount < aMonitorNum) or (aMonitorNum < 1) then
           raise EMonitorCaptureException.CreateFmt('Monitor Index out of Bounds [%d]',[aMonitorNum]);
        MonInfo := GetMonInfoByIdx(aMonitorNum);
        lCapRect := MonInfo.rcMonitor;
      end;
      ccAllMonitors:
      begin
        lCapRect.Right  := GetSystemMetrics(SM_CXVIRTUALSCREEN);
        lCapRect.Bottom := GetSystemMetrics(SM_CYVIRTUALSCREEN);
      end;
    end;
    CaptureDeviceContext(dc,lCapRect,destBitmap);
  finally
    ReleaseDC(h, DC) ;
   end;
end;

procedure CaptureDeviceContext(SrcDC: HDC;aCaptureRect : TRect;destBitMap : TBitmap);
begin
// This is just in case you want to capture from a Device Context
// that is not the screen, or you already have the Device Context Handle
    destBitmap.Width := aCaptureRect.Right - aCaptureRect.Left;
    destBitmap.Height := aCaptureRect.Bottom - aCaptureRect.Top;
    BitBlt(destBitmap.Canvas.Handle,
           0,
           0,
           destBitmap.Width,
           destBitmap.Height,
           SrcDC,
           aCaptureRect.Left,
           aCaptureRect.Top,
           SRCCOPY) ;
end;

procedure CaptureRect(aCaptureRect : TRect;destBitMap : TBitmap); inline;
var
 dc : HDC;
begin
  dc := CreateDC('DISPLAY',nil,nil,nil);
  try
     CaptureDeviceContext(dc,aCaptureRect,destBitMap);
  finally
    ReleaseDC(0,dc);
  end;
end;



end.
