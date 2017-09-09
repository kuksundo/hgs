unit tmctl_h;
{*************************************************************************
=> Project->option->delphi compiler->conditional defines = WT500 ÇÒ °Í

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

(* Control setting
					GPIB:				              wire = TM_CTL_GPIB(1)
					RS232:				            wire = TM_CTL_RS232(2)
					USB:				              wire = TM_CTL_USB(3)
					Ethernet:			            wire = TM_CTL_ETHER(4)
					USBTMC(DL9000):			      wire = TM_CTL_USBTMC(5)
					EthernetUDP:			        wire = TM_CTL_ETHERUDP(6)
					USBTMC(excluding DL9000):	wire = TM_CTL_ETHERUDP(7)
					VXI-11:				            wire = TM_CTL_VXI11(8)
*)
const	TM_NO_CONTROL =	0;
const	TM_CTL_GPIB =		1;
const	TM_CTL_RS232 =	2;
const	TM_CTL_USB =		3;
const	TM_CTL_ETHER =	4;
const	TM_CTL_USBTMC =	5;
const	TM_CTL_ETHERUDP	= 6;
const	TM_CTL_USBTMC2 = 7;				// 2007/01/19 add
const	TM_CTL_VXI11 = 8;				// 2007/01/19 add
const	TM_CTL_USB2	= 9;
(* GPIB *)

(* RS232 *)
const	TM_RS_1200 =	'0';
const	TM_RS_2400 =	'1';
const	TM_RS_4800 =	'2';
const	TM_RS_9600 =	'3';
const	TM_RS_19200 =	'4';
const	TM_RS_38400 =	'5';
const	TM_RS_57600 =	'6';
const TM_RS_115200 = '7';

const	TM_RS_8N =	'0';
const	TM_RS_7E =	'1';
const	TM_RS_7O =	'2';
const	TM_RS_8O =	'3';
const	TM_RS_7N5 =	'4';

const	TM_RS_NO =	'0';
const	TM_RS_XON =	'1';
const	TM_RS_HARD =	'2';

(* USB *)
const TM_USB_CHECK_OK	= 0;
const TM_USB_CHECK_NOTOPEN = 1;
const TM_USB_CHECK_NODEVICE = 2;

const	TM_USB_READPIPE = 0;
const	TM_USB_WRITEPIPE = 1;
const	TM_USB_STATUSPIPE = 2;

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
const	TMCTL_NOT_SUPPORTED	=		    $00004000;	  (* this feature not supportred *)
const	TMCTL_INSUFFICIENT_BUFFER	= $00008000;	  (* unsufficient buffer size *)

// L2 Error Number */
const	TMCTL2_NO_ERROR	=			$00000;			//* No error */
const	TMCTL2_TIMEOUT	=			$10001;			//* Timeout */
const	TMCTL2_NO_DEVICE =			$10002;			//* Device Not Found */
const	TMCTL2_FAIL_OPEN =			$10003;		 	//* Open Port Error */
const	TMCTL2_NOT_OPEN	=			$10004;			//* Device Not Open */
const	TMCTL2_DEVICE_ALREADY_OPEN =	$10005;			//* Device Already Open */
const	TMCTL2_NOT_CONTROL =			$10006;			//* Controller Not Found */
const	TMCTL2_ILLEGAL_PARAMETER =	$10007;			//* Parameter is illegal */
const	TMCTL2_SEND_ERROR	=		$10008;			//* Send Error */
const	TMCTL2_RECV_ERROR	=		$10009;			//* Receive Error */
const	TMCTL2_NOT_BLOCK =			$10010;			//* Data is not Block Data */
const	TMCTL2_SYSTEM_ERROR	=		$10011;			//* System Error */
const	TMCTL2_ILLEGAL_ID	=		$10012;			//* Device ID is Illegal */
const	TMCTL2_NOT_SUPPORTED =		$10013;			//* this feature not supportred */
const	TMCTL2_INSUFFICIENT_BUFFER =	$10014;			//* unsufficient buffer size */

//{$IFDEF WT500}
const DLL_NAME = 'tmctl_wt500.dll';
//{$ELSE}
//const DLL_NAME = 'tmctl_wt1600.dll';
//{$ENDIF}
(* Functions *)
(*		Purpose:	Initializes and opens a connection to the specified device
		Parameters:	int   wire  connection types
				char* adr   the address of the connection
				int*  id    special device ID used by other functions
		Return value:	0 = OK, 1 = ERROR
		Details:
			Description of Parameters
			  int wire
				Set this parameter to the type of connection through which the device will be
				controlled.
				The settings for each type of interface are shown below.
					GPIB:				wire = TM_CTL_GPIB(1)
					RS232:				wire = TM_CTL_RS232(2)
					USB:				wire = TM_CTL_USB(3)
					Ethernet:			wire = TM_CTL_ETHER(4)
					USBTMC(DL9000):			wire = TM_CTL_USBTMC(5)
					EthernetUDP:			wire = TM_CTL_ETHERUDP(6)
					USBTMC(excluding DL9000):	wire = TM_CTL_ETHERUDP(7)
					VXI-11:				wire = TM_CTL_VXI11(8)
			  char* adr
				Use a character string to set this parameter to the GPIB address or RS-232
				settings of the device to be controlled.
				The following shows how the settings for each interface.
				GPIB:  adr = "1"-"30" (the GPIB address value of the device)
				RS232: adr = "port number, baud rate number, bit specification, handshaking number"
					port number		1 = COM1
								2 = COM2
								3 = COM3
					baud rate number	0 = 1200
								1 = 2400
								2 = 4800
								3 = 9600
								4 = 19200
								5 = 38400
								6 = 57600
					bit specifications	0 = 8 bits, no parity, 1 stop bit
								1 = 7 bits, even parity, 1 stop bit
								2 = 7 bits, odd parity, 1 stop bit
					handshaking number	0 = NO-NO
								1 = XON-XON
								2= CTS-RTS
				USB: adr = "1"-"127" (the unique USB ID for the device)
				Ethernet: adr =	"server name, user name, password"
					sever name		The server name or IP address of the DL
					user name		The user name
					password		The password
								When the user name is anonymous,
								a password is not required.
								(A delimiting comma "," is required.)
				USBTMC(DL9000): adr = "serial number"
					Serial number	The instrument serial number
				USBTMC(GS200 and GS820): adr = "serial number"
					Serial number	The instrument serial number
				USBTMC(GS610): adr = "serial number" + "C"
					Serial number	The instrument serial number
				USBTMC (other than the DL9000 and GS series):  adr = the number
				encoded by TmcEncodeSerialNumber using "serial number"
					 Serial number	The instrument serial number
				VXI-11: adr = "IP address"

			  int* id
				Allocates the device ID passed to each function after initialization to the storage
				buffer.
				If initialization succeeds and a connection is opened, an integer equal to or greater
				than 0 is returned for the ID.

				If initialization succeeds, the return value is 0. If a connection could not be opened,
				the return value is 1.
				Regardless of the type of connection, the settings below take effect if initialization
				is successful.
				- Terminator: LF (LF or EOI for GPIB)
				- Timeout: 30 seconds
*)
	function  TmcInitialize(wire: integer; adr: PAnsiChar; id: Pinteger ): integer;stdcall; external DLL_NAME;

	function  TmcSetIFC(id: integer; tm: integer ): integer;stdcall; external DLL_NAME;
	function  TmcDeviceClear(id: integer ): integer;stdcall; external DLL_NAME;

(*
		Purpose:	Sends a message to a device.
		Parameters:	int   id  device ID
				char* msg message character string
		Return value:	 0 = OK, 1 = ERROR

		Details:
			Description of Parameters
			  int id
				Set this parameter to the ID of the device to which the message will be sent.
			  char* msg
				For this parameter, enter the character string for the message itself.

			Sends an ASCII character string to the device specified by the ID.
			When sending binary data, use "TmcSendByLength".
			Also, when dividing up a message to be sent, use "TmcSendSetup" and "TmcSendOnly".
*)
	function  TmcSend(id: integer; msg: PAnsiChar ): integer;stdcall; external DLL_NAME;
	function  TmcSendByLength(id: integer; msg: PAnsiChar; len: integer ): integer;stdcall; external DLL_NAME;
	function  TmcSendSetup(id: integer ): integer;stdcall; external DLL_NAME;
	function  TmcSendOnly(id: integer; msg: PAnsiChar; len: integer; end1: integer ): integer;stdcall; external DLL_NAME;
	function  TmcReceive(id: integer; buff: PAnsiChar; blen: integer; rlen: Pinteger ): integer;stdcall; external DLL_NAME;
	function  TmcReceiveSetup(id: integer ): integer;stdcall; external DLL_NAME;
	function  TmcReceiveOnly(id: integer; buff: PAnsiChar; blen: integer; rlen: Pinteger ): integer;stdcall; external DLL_NAME;
	function  TmcReceiveBlockHeader(id: integer; len: Pinteger ): integer;stdcall; external DLL_NAME;
	function  TmcReceiveBlockData(id: integer; buff: PAnsiChar; blen: integer; rlen: Pinteger; end1: Pinteger ): integer;stdcall; external DLL_NAME;
	function  TmcSetCmd(id: integer; cmd: PAnsiChar ): integer;stdcall; external DLL_NAME;
	function  TmcSetRen(id: integer; flag: integer ): integer;stdcall; external DLL_NAME;
	function  TmcGetLastError(id: integer ): integer;stdcall; external DLL_NAME;
	function  TmcGetDetailLastError(id: integer ): integer;stdcall; external DLL_NAME;
	function  TmcCheckError(id: integer; sts: integer; msg: PAnsiChar; err: PAnsiChar ): integer;stdcall; external DLL_NAME;
	function  TmcSetTerm(id: integer; eos: integer; eot: integer ): integer;stdcall; external DLL_NAME;
	function  TmcSetEos(id: integer; eos: Byte ): integer;stdcall; external DLL_NAME;
	function  TmcSetTimeout(id: integer; tmo: integer ): integer;stdcall; external DLL_NAME;
	function  TmcSetDma(id: integer; flg: integer ): integer;stdcall; external DLL_NAME;
	function  TmcGetStatusByte(id: integer; sts: PByte ): integer;stdcall; external DLL_NAME;
	function  TmcFinish(id: integer ): integer;stdcall; external DLL_NAME;

  //function TmReceive(id: integer; buf: PAnsiChar; blen: integer; rlen: Pinteger):

implementation

end.


