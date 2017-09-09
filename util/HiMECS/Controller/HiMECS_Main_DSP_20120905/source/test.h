#ifndef	_TEST_H_
#define	_TEST_H_
//	For debugging
#define	TEST_COMMAND_IDLE					0x00
#define	TEST_COMMAND_CURRENT				0x01
#define	TEST_COMMAND_VELOCITY				0x02
#define	TEST_COMMAND_POSITION				0x03
#define	TEST_COMMAND_PWM					0x08

#define	TEST_COMMAND_CONFIG					-1
#define	TEST_COMMAND_COMPLETE				-2

#define	TEST_BUFFER_SIZE	100

extern int g_testBufferIndex;
//extern char g_testCommand;

extern void ConfigTestFunction();
extern void RunTestFunction();
extern void SaveLogData();
#endif	// _TEST_H_
