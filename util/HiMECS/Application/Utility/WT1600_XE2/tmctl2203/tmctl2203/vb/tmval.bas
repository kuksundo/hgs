Attribute VB_Name = "tmval"
Option Explicit

'Control Setting
Global Const CTL_OK = 0
Global Const CTL_ERROR = 1

Global Const SET_TRUE = 1
Global Const SET_FALSE = 0

Global Const TERM_CRLF = 0
Global Const TERM_CR = 1
Global Const TERM_LF = 2
Global Const TERM_EOI = 3

Global Const SEND_END = 0
Global Const SEND_REMAIN = 1
Global Const RECV_NONE = 0
Global Const RECV_END = 1

'GPIB

'RS232

Global Const RS_COM1 = "1"
Global Const RS_COM2 = "2"
Global Const RS_COM3 = "3"

Global Const RS_RATE_1200 = "0"
Global Const RS_RATE_2400 = "1"
Global Const RS_RATE_4800 = "2"
Global Const RS_RATE_9600 = "3"
Global Const RS_RATE_19200 = "4"
Global Const RS_RATE_38400 = "5"
Global Const RS_RATE_57600 = "6"
Global Const RS_RATE_115200 = "7"

Global Const RS_8N = "0"
Global Const RS_7E = "1"
Global Const RS_7O = "2"
Global Const RS_8O = "3"
Global Const RS_7N5 = "4"

Global Const RS_NO = "0"
Global Const RS_XON = "1"
Global Const RS_HARD = "2"

'USB

