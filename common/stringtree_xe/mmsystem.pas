unit MMSystem;

interface

uses winapi.Windows;

type
  TFNTimeCallBack = procedure(uTimerID, uMessage: UINT; 
    dwUser, dw1, dw2: DWORD) stdcall;
  MMRESULT = UINT;              

function timeSetEvent(uDelay, uResolution: UINT;
  lpFunction: TFNTimeCallBack; dwUser: DWORD; uFlags: UINT): UINT; stdcall;

function timeKillEvent(uTimerID: UINT): UINT; stdcall;
function timeBeginPeriod(uPeriod: UINT): MMRESULT; stdcall;
function timeEndPeriod(uPeriod: UINT): MMRESULT; stdcall;

const
    mmsyst = 'winmm.dll';
    TIME_PERIODIC   = 1;   
implementation


function timeKillEvent; external mmsyst name 'timeKillEvent';
function timeSetEvent; external mmsyst name 'timeSetEvent';
function timeBeginPeriod; external mmsyst name 'timeBeginPeriod';
function timeEndPeriod; external mmsyst name 'timeEndPeriod';

end.
