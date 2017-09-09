unit tmctl_h;
{*************************************************************************

->	Converted with C to Pascal Converter 1.0
->	Release: 1.5.11.2008
->	Email: al_gun@ncable.net.au
->	Updates: http://cc.codegear.com/Author/302259
->	Copyright ¨Ï 2005-2008 Ural Gunaydin, All rights reserved.

*************************************************************************}

interface

uses
	Windows, Messages, SysUtils, Classes;

(*STARTM-----------------------------------------------------------------
+       Module Name     : tmctl.h                                       +
+       Abstract        : Yokogawa T and M Remote Control functions.        +
+       Revision History:                                               +
+       Rev.    Date.          Notes.                                   +
+       --------------------------------------------------------------  +
+       0       2001.04.01                                              +
+       ^1      2005.03.03     USBTMC                                   +
-ENDM-------------------------------------------------------------------*)

(* Control setting *)
const	TM_NO_CONTROL =	0;
const	TM_CTL_GPIB =		1;
const	TM_CTL_RS232 =	2;
const	TM_CTL_USB =		3;
const	TM_CTL_ETHER =	4;
const	TM_CTL_USBTMC =	5;

(* GPIB *)

(* RS232 *)
const	TM_RS_1200 =	'0';
const	TM_RS_2400 =	'1';
const	TM_RS_4800 =	'2';
const	TM_RS_9600 =	'3';
const	TM_RS_19200 =	'4';
const	TM_RS_38400 =	'5';
const	TM_RS_57600 =	'6';

const	TM_RS_8N =	'0';
const	TM_RS_7E =	'1';
const	TM_RS_7O =	'2';

const	TM_RS_NO =	'0';
const	TM_RS_XON =	'1';
const	TM_RS_HARD =	'2';

(* USB *)

(* Error Number *)
const	TMCTL_NO_ERROR =				    $00000000;		(* No error *)
const	TMCTL_TIMEOUT =				      $00000001;		(* Timeout *)
const	TMCTL_NO_DEVICE =				    $00000002;		(* Device Not Found *)
const	TMCTL_FAIL_OPEN =				    $00000004;		(* Open Port Error *)
const	TMCTL_NOT_OPEN =				    $00000008;		(* Device Not Open *)
const	TMCTL_DEVICE_ALREADY_OPEN =	$00000010;		(* Device Already Open *)
const	TMCTL_NOT_CONTROL =			    $00000020;		(* Controller Not Found *)
const	TMCTL_ILLEGAL_PARAMETER =		$00000040;		(* Parameter is illegal *)
const	TMCTL_SEND_ERROR =			    $00000100;		(* Send Error *)
const	TMCTL_RECV_ERROR =			    $00000200;		(* Receive Error *)
const	TMCTL_NOT_BLOCK =				    $00000400;		(* Data is not Block Data *)
const	TMCTL_SYSTEM_ERROR =			  $00001000;		(* System Error *)
const	TMCTL_ILLEGAL_ID =			    $00002000;		(* Device ID is Illegal *)

(* Functions *)
	function  TmcInitialize(wire: integer; adr: PAnsiChar; id: Pinteger ): integer;stdcall; external 'tmctl.dll';
	function  TmcSetIFC(id: integer; tm: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcDeviceClear(id: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcSend(id: integer; msg: PAnsiChar ): integer;stdcall; external 'tmctl.dll';
	function  TmcSendByLength(id: integer; msg: PAnsiChar; len: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcSendSetup(id: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcSendOnly(id: integer; msg: PAnsiChar; len: integer; end1: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcReceive(id: integer; buff: PAnsiChar; blen: integer; rlen: Pinteger ): integer;stdcall; external 'tmctl.dll';
	function  TmcReceiveSetup(id: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcReceiveOnly(id: integer; buff: PAnsiChar; blen: integer; rlen: Pinteger ): integer;stdcall; external 'tmctl.dll';
	function  TmcReceiveBlockHeader(id: integer; len: Pinteger ): integer;stdcall; external 'tmctl.dll';
	function  TmcReceiveBlockData(id: integer; buff: PAnsiChar; blen: integer; rlen: Pinteger; end1: Pinteger ): integer;stdcall; external 'tmctl.dll';
	function  TmcSetCmd(id: integer; cmd: PAnsiChar ): integer;stdcall; external 'tmctl.dll';
	function  TmcSetRen(id: integer; flag: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcGetLastError(id: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcGetDetailLastError(id: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcCheckError(id: integer; sts: integer; msg: PAnsiChar; err: PAnsiChar ): integer;stdcall; external 'tmctl.dll';
	function  TmcSetTerm(id: integer; eos: integer; eot: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcSetEos(id: integer; eos: Byte ): integer;stdcall; external 'tmctl.dll';
	function  TmcSetTimeout(id: integer; tmo: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcSetDma(id: integer; flg: integer ): integer;stdcall; external 'tmctl.dll';
	function  TmcGetStatusByte(id: integer; sts: PByte ): integer;stdcall; external 'tmctl.dll';
	function  TmcFinish(id: integer ): integer;stdcall; external 'tmctl.dll';

  //function TmReceive(id: integer; buf: PAnsiChar; blen: integer; rlen: Pinteger):

implementation

end.


