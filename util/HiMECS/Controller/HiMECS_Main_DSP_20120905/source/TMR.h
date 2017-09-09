/*
*********************************************************************************************************
*                                  Embedded Systems Building Blocks
*                               Complete and Ready-to-Use Modules in C
*
*                                             Timer Manager
*
*                            (c) Copyright 1999, Jean J. Labrosse, Weston, FL
*                                           All Rights Reserved
*
* Filename   : TMR.H
* Programmer : Jean J. Labrosse
* Translated by : Won-Ho, Sung
*********************************************************************************************************
*/

/*
*********************************************************************************************************
*                                                 상수
*********************************************************************************************************
*/
//#include "def28x_define.h"
#define     FALSE	0
#define     TRUE	!FALSE
#define     false	0
#define     true	!false
#define		NULL	(void *)0
#define 	HIGH	1
#define 	LOW		0
#define 	LF		0x0A	// Line feed
#define 	CR		0x0D	// Carrage return

typedef	unsigned char	BOOLEAN;
typedef	unsigned char	INT8U;
typedef	unsigned int	INT16U;

#define  NUL				0		
#define  TMR_MAX_TMR        6
#define  TIMERSCALE			1000
#define  TIMER_FREQUENCY     1000   // 1000us timer

#ifdef  TMR_GLOBALS
#define TMR_EXT
#else
#define TMR_EXT  extern
#endif

/*
*********************************************************************************************************
*                                              데이터 타입
*********************************************************************************************************
*/

typedef struct tmr {                             /* 타이머 데이터 구조체                               */
    BOOLEAN   TmrEn;                             /* 타이머가 활성화 되었는지를 알려주는 프래그         */
    unsigned long    TmrCtr;                            /* 타이머의 현재 값 (카운트 다운)                     */
    unsigned long    TmrInit;                           /* 타이머의 초기 값 (타이머가 세트될 때)              */
    void    (*TmrFnct)(void *);                  /* 만료될 때 실행될 함수                              */
    void     *TmrFnctArg;                        /* 사용자 정의 함수로 전달되는 인자                   */
} TMR;

/*
*********************************************************************************************************
*                                                전역변수
*********************************************************************************************************
*/

TMR_EXT  TMR       TmrTbl[TMR_MAX_TMR];          /* 이 모듈에서 관리되는 타이머 테이블                 */

/*
*********************************************************************************************************
*                                                함수원형
*********************************************************************************************************
*/

void    TmrCfgFnct(INT8U n, void (*fnct)(void *), void *arg);
INT16U  TmrChk(INT8U n);

void    TmrInit(void);

void    TmrReset(INT8U n);

void    TmrSetMST(INT8U n, INT8U min, INT8U sec, INT8U tenths);
void    TmrSetT(INT8U n, INT16U tenths);
void    TmrStart(INT8U n);
void    TmrStop(INT8U n);
