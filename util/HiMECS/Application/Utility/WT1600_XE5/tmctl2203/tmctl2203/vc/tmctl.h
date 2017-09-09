/*STARTM------------------------------------------------------------------
+       Module Name     : tmctl.h                                        +
+       Abstract        : Yokogawa T&M Remote Control functions.         +
+       Revision History:                                                +
+       Rev.    Date.          Notes.                                    +
+       --------------------------------------------------------------   +
+       2.0		20070309	USBTMC2 VXI11 supported. thread safe support +
+       2.1		20080508	RS232C expand                                +
+       2.2		20080704	Add TmcGetInitializeError.                   +
-ENDM-------------------------------------------------------------------*/

#ifndef	_TMCTL_H
#define	_TMCTL_H	1

/* Control setting */
#define	TM_NO_CONTROL	0
#define	TM_CTL_GPIB		1
#define	TM_CTL_RS232	2
#define	TM_CTL_USB		3
#define	TM_CTL_ETHER	4
#define	TM_CTL_USBTMC	5
#define	TM_CTL_ETHERUDP	6
#define	TM_CTL_USBTMC2	7				// 2007/01/19 add
#define	TM_CTL_VXI11	8				// 2007/01/19 add
#define	TM_CTL_USB2		9

/* GPIB */

/* RS232 */
#define	TM_RS_1200		'0'
#define	TM_RS_2400		'1'
#define	TM_RS_4800		'2'
#define	TM_RS_9600		'3'
#define	TM_RS_19200		'4'
#define	TM_RS_38400		'5'
#define	TM_RS_57600		'6'
#define	TM_RS_115200	'7'			// Ver2.1

#define	TM_RS_8N		'0'
#define	TM_RS_7E		'1'
#define	TM_RS_7O		'2'
#define	TM_RS_8O		'3'			// Ver2.1 8bit,odd,onestopbit
#define	TM_RS_7N5		'4'			// Ver2.1 7bit,noparity,one5stopbit

#define	TM_RS_NO		'0'
#define	TM_RS_XON		'1'
#define	TM_RS_HARD		'2'

/* USB */
#define TM_USB_CHECK_OK				0
#define TM_USB_CHECK_NOTOPEN		1
#define TM_USB_CHECK_NODEVICE		2

#define	TM_USB_READPIPE				0
#define	TM_USB_WRITEPIPE			1
#define	TM_USB_STATUSPIPE			2

/* Error Number */
#define	TMCTL_NO_ERROR				0x00000000		/* No error */
#define	TMCTL_TIMEOUT				0x00000001		/* Timeout */
#define	TMCTL_NO_DEVICE				0x00000002		/* Device Not Found */
#define	TMCTL_FAIL_OPEN				0x00000004		/* Open Port Error */
#define	TMCTL_NOT_OPEN				0x00000008		/* Device Not Open */
#define	TMCTL_DEVICE_ALREADY_OPEN	0x00000010		/* Device Already Open */
#define	TMCTL_NOT_CONTROL			0x00000020		/* Controller Not Found */
#define	TMCTL_ILLEGAL_PARAMETER		0x00000040		/* Parameter is illegal */
#define	TMCTL_SEND_ERROR			0x00000100		/* Send Error */
#define	TMCTL_RECV_ERROR			0x00000200		/* Receive Error */
#define	TMCTL_NOT_BLOCK				0x00000400		/* Data is not Block Data */
#define	TMCTL_SYSTEM_ERROR			0x00001000		/* System Error */
#define	TMCTL_ILLEGAL_ID			0x00002000		/* Device ID is Illegal */
#define	TMCTL_NOT_SUPPORTED			0x00004000		/* this feature not supportred */
#define	TMCTL_INSUFFICIENT_BUFFER	0x00008000		/* unsufficient buffer size */

/* L2 Error Number */
#define	TMCTL2_NO_ERROR				(00000)			/* No error */
#define	TMCTL2_TIMEOUT				(10001)			/* Timeout */
#define	TMCTL2_NO_DEVICE			(10002)			/* Device Not Found */
#define	TMCTL2_FAIL_OPEN			(10003)			/* Open Port Error */
#define	TMCTL2_NOT_OPEN				(10004)			/* Device Not Open */
#define	TMCTL2_DEVICE_ALREADY_OPEN	(10005)			/* Device Already Open */
#define	TMCTL2_NOT_CONTROL			(10006)			/* Controller Not Found */
#define	TMCTL2_ILLEGAL_PARAMETER	(10007)			/* Parameter is illegal */
#define	TMCTL2_SEND_ERROR			(10008)			/* Send Error */
#define	TMCTL2_RECV_ERROR			(10009)			/* Receive Error */
#define	TMCTL2_NOT_BLOCK			(10010)			/* Data is not Block Data */
#define	TMCTL2_SYSTEM_ERROR			(10011)			/* System Error */
#define	TMCTL2_ILLEGAL_ID			(10012)			/* Device ID is Illegal */
#define	TMCTL2_NOT_SUPPORTED		(10013)			/* this feature not supportred */
#define	TMCTL2_INSUFFICIENT_BUFFER	(10014)			/* unsufficient buffer size */

#define	ADRMAXLEN			(64)

typedef	struct _Devicelist
{
	char	adr[ADRMAXLEN] ;
} DEVICELIST ;

typedef	struct _DevicelistEx
{
	char		adr[ADRMAXLEN] ;
unsigned short	vendorID ;
unsigned short	productID ;
	char		dummy[188] ;
} DEVICELISTEX ;

// コールバックルーチン
typedef void(__stdcall *Hndlr)(int, UCHAR, ULONG, ULONG) ;

/* Functions */
#ifndef	_TMCTL_DEFINES
#ifdef	__cplusplus
extern	"C" {
#endif
extern	int		__stdcall TmcInitialize( int wire, char* adr, int* id ) ;
extern	int		__stdcall TmcSetIFC( int id, int tm ) ;
extern	int		__stdcall TmcDeviceClear( int id ) ;
extern	int		__stdcall TmcSend( int id, char* msg ) ;
extern	int		__stdcall TmcSendByLength( int id, char* msg, int len ) ;
extern	int		__stdcall TmcSendSetup( int id ) ;
extern	int		__stdcall TmcSendOnly( int id, char* msg, int len, int end ) ;
extern	int		__stdcall TmcReceive( int id, char* buff, int blen, int* rlen ) ;
extern	int		__stdcall TmcReceiveSetup( int id ) ;
extern	int		__stdcall TmcReceiveOnly( int id, char* buff, int blen, int* rlen ) ;
extern	int		__stdcall TmcReceiveBlockHeader( int id, int* len ) ;
extern	int		__stdcall TmcReceiveBlockData( int id, char* buff, int blen, int* rlen, int* end ) ;
extern	int		__stdcall TmcCheckEnd( int id ) ;
extern	int		__stdcall TmcSetCmd( int id, char* cmd ) ;
extern	int		__stdcall TmcSetRen( int id, int flag ) ;
extern	int		__stdcall TmcGetLastError( int id ) ;
extern	int		__stdcall TmcGetDetailLastError( int id ) ;
extern	int		__stdcall TmcCheckError( int id, int sts, char* msg, char* err ) ;
extern	int		__stdcall TmcSetTerm( int id, int eos, int eot ) ;
extern	int		__stdcall TmcSetEos( int id, unsigned char eos ) ;
extern	int		__stdcall TmcSetTimeout( int id, int tmo ) ;
extern	int		__stdcall TmcSetDma( int id, int flg ) ;
extern	int		__stdcall TmcGetStatusByte( int id, unsigned char* sts ) ;
extern	int		__stdcall TmcFinish( int id ) ;
extern	int		__stdcall TmcSearchDevices(int wire, DEVICELIST* list, int max, int* num,char* option) ;
extern	int		__stdcall TmcSearchDevicesEx(int wire, DEVICELISTEX* list, int max, int* num,char* option) ;
extern	int		__stdcall TmcWaitSRQ(int id, char* stsbyte, int tout) ;
extern	int		__stdcall TmcAbortWaitSRQ(int id) ;
extern	int		__stdcall TmcSetCallback(int id,Hndlr func, ULONG p1, ULONG p2) ;
extern	int		__stdcall TmcResetCallback(int id) ;
extern	int		__stdcall TmcSendTestData(int id, char* msg, int len ) ;
extern	int		__stdcall TmcReceiveTestData( int id, char* buff, int blen, int* rlen ) ;
extern	int		__stdcall TmcInitiateAbortBulkIn(int id, UCHAR tagNo) ;
extern	int		__stdcall TmcInitiateAbortBulkOut(int id, UCHAR tagNo) ;
extern	int		__stdcall TmcCheckAbortBulkInStatus(int id) ;
extern	int		__stdcall TmcCheckAbortBulkOutStatus(int id) ;
extern	int		__stdcall TmcEncodeSerialNumber(char* encode,size_t len,char* src) ;
extern	int		__stdcall TmcDecodeSerialNumber(char* decode,size_t len,char* src) ;
extern	int		__stdcall TmcGotoLocal( int id ) ;
extern	int		__stdcall TmcLocalLockout(int id) ;
extern  int		__stdcall TmcAbortPipe(int id,long pipeNo) ;
extern  int		__stdcall TmcResetPipe(int id,long pipeNo) ;
extern	int		__stdcall TmcWriteHeader(int id, int blen) ;
extern	int		__stdcall TmcReceiveWithoutWriteHeader(int id, char* buff, int blen, int* rlen, int* end ) ;
extern	int		__stdcall TmcGetTagNo(int id, UCHAR* tag) ;
extern	int		__stdcall TmcSendByLength2( int id, char* msg, int msgSize, int len, CHAR eof) ;
extern	int		__stdcall TmcDeviceChangeNotify(HWND hWnd, BOOL bStart) ;
extern	int		__stdcall TmcCheckUSB(int id) ;
extern	int		__stdcall TmcGetPipeNo(int id,int type,int* pipeNo) ;
extern	int		__stdcall TmcCheckGUID(int lParam) ;
extern	ULONG	__stdcall TmcGetInitializeError() ;

// L2関数
extern	int	__stdcall xTmcSearchDevices(int wire, DEVICELIST* adrlist, int max, int *num,char* option) ;
extern	int	__stdcall xTmcSearchDevicesEx(int wire, DEVICELISTEX* adrlist, int max, int *num,char* option) ;
extern	int	__stdcall xTmcInitialize( int wire, char* adr, int* id ) ;
extern	int	__stdcall xTmcInitializeEx( int wire, char* adr, int* id, int timeout ) ;
extern	int	__stdcall xTmcFinish( int id ) ;
extern	int	__stdcall xTmcSend( int id, char* msg ) ;
extern	int	__stdcall xTmcSendByLength( int id, char* msg, int len ) ;
extern	int	__stdcall xTmcSendSetup( int id ) ;
extern	int	__stdcall xTmcSendOnly( int id, char* msg, int len, int end ) ;
extern	int	__stdcall xTmcReceive( int id, char* buff, int blen, int* rlen ) ;
extern	int	__stdcall xTmcReceiveSetup( int id ) ;
extern	int	__stdcall xTmcReceiveOnly( int id, char* buff, int blen, int* rlen ) ;
extern	int	__stdcall xTmcReceiveBlockHeader( int id, int* length ) ;
extern	int	__stdcall xTmcReceiveBlockData( int id, char* buff, int blen, int* rlen, int* end ) ;
extern	int	__stdcall xTmcCheckEnd( int id ) ;
extern	int	__stdcall xTmcDeviceClear( int id ) ;
extern	int	__stdcall xTmcSetRen( int id, int flag ) ;
extern	int	__stdcall xTmcGetLastError( int id ) ;
extern	int	__stdcall xTmcSetTerm( int id, int eos, int eot ) ;
extern	int	__stdcall xTmcSetTimeout( int id, int tmo ) ;
extern	int	__stdcall xTmcCreateSRQHandler( int id, UINT msgId, HWND hWnd) ;
extern	int	__stdcall xTmcDleateSRQHandler( int id ) ;
extern	int	__stdcall xTmcSetCallback(int id,Hndlr func, ULONG p1, ULONG p2) ;
extern	int	__stdcall xTmcResetCallback(int id) ;
extern	int	__stdcall xTmcSet( int id, char *msg) ;
extern	int	__stdcall xTmcSetBinary( int id, char* msg, char *buf, int size ) ;
extern	int	__stdcall xTmcGet( int id, char *msg, char* buf, int blen, int* rlen ) ;
extern	int __stdcall xTmcGetBinary( int id, char *msg, char* buf, int blen, int* rlen ) ;
extern	int	__stdcall xTmcGetErrorQueue(int id) ;
extern	int	__stdcall xTmcSetNE( int id, char *msg) ;
extern	int	__stdcall xTmcSetBinaryNE( int id, char* msg, char *buf, int size ) ;
extern	int	__stdcall xTmcGetNE( int id, char *msg, char* buf, int blen, int* rlen ) ;
extern	int __stdcall xTmcGetBinaryNE( int id, char *msg, char* buf, int blen, int* rlen ) ;
extern	int	__stdcall xTmcSetNES( int id, char *msg) ;
extern	int	__stdcall xTmcSetBinaryNES( int id, char* msg, char *buf, int size ) ;
extern	int	__stdcall xTmcLock( int id ) ;
extern	int	__stdcall xTmcUnlock( int id ) ;

#ifdef	__cplusplus
}
#endif
#endif

#endif
