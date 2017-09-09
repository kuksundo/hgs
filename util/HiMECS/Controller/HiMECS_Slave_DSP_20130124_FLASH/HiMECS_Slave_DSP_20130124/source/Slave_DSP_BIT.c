// ====================================================================== //
//				HiMECS Slave DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_BIT.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for Slave DSP Built In Test
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2011-07-22:	Draft
// ====================================================================== //


// ====================================================================== //
//	Includes
// ====================================================================== //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"

#include "Slave_DSP_External_Interface.h"
#include "Slave_DSP_Parameter.h"
#include "Slave_DSP_Debug_SCI.h"
#include "Slave_DSP_BIT.h"
#include "Slave_DSP_Digital_IO.h"



// ====================================================================== //
//	Functions
// ====================================================================== //


// ====================================================================== //
//	Function: System_Hold
//		- if this function is called, the system will be HOLD and STOP.
//		  This is totally different with System Reset, 
//		  this function hold all of value.(ex. memory, register, etc.)
// ---------------------------------------------------------------------- //
void System_Hold (void)
{
	asm ("      ESTOP0");
  	for(;;);
}
// ====================================================================== //



// ====================================================================== //
//	Function: Memory_BIT
//		- This function test SRAM Memory space and Address line.
// ---------------------------------------------------------------------- //
int Memory_BIT (Uint32 base_address, Uint32 memory_size)
{
	Uint32 i = 0;
	unsigned int temp = 0;
	
	int test_result1 = PASS, test_result2 = PASS, test_result3 = PASS;
	int test_result = PASS;
	int other_mem_test_result = PASS;
	
	volatile unsigned int *p_address = (unsigned int *)(base_address);

	/*
	// Step 1. Save count value to every memory in Zone 7
	
	Memory_Save_Count(SRAM_BASE, SRAM_SIZE);
	Memory_Save_Count(DPRAM_M_BASE, DPRAM_M_SIZE);
	*/
	

	
	// Step 2. Memory Test (0xAAAA Test)
	p_address = (unsigned int *)(base_address);
	
	for (i=0; i<=memory_size; i++)
	{
		// 0xAAAA Test
		*p_address = 0xAAAA;
		//DI_Update();
		//DO_Update();
		temp = *p_address;

		if (temp != 0xAAAA)
		{
			test_result1 = FAIL;
			Print_Memory_Error(base_address+i, 0xAAAA, temp);
		}

		p_address++;
	}	
	


	
	// Step 3. Memory Test (0x5555 Test)
	p_address = (unsigned int *)(base_address);

	for (i=0; i<=memory_size; i++)
	{
		// 0x5555 Test
		*p_address = 0x5555;
		//DI_Update();
		//DO_Update();
		temp = *p_address;

		if (temp != 0x5555)
		{
			test_result2 = FAIL;
			Print_Memory_Error(base_address+i, 0x5555, temp);
		}

		p_address++;
	}
	

	
	
	// Step 4. Address Line Test
	p_address = (unsigned int *)(base_address);
	
	for (i=0; i<=memory_size; i++)
	{
		*p_address = (unsigned int)(i & 0x0000FFFF);
		//DI_Update();
		//DO_Update();		
		p_address++;  
		
	}

	p_address = (unsigned int *)(base_address);
	
	for (i=0; i<=memory_size; i++)
	{
		//DI_Update();
		//DO_Update();
		temp = *p_address;

		if (temp != (unsigned int)(i & 0x0000FFFF))
		{
			test_result3 = FAIL;
			Print_Memory_Error(base_address+i, (unsigned int)(i & 0x0000FFFF), temp);
		}

		p_address++;		
	}
	

	/*
	// Step 5. Test the others Memory data are still OK.
	switch (base_address)
	{
		case SRAM_BASE:
			other_mem_test_result += Memory_Count_Test(DPRAM_M_BASE, DPRAM_M_SIZE);
			break;

		case DPRAM_M_BASE:
			other_mem_test_result += Memory_Count_Test(SRAM_BASE, SRAM_SIZE);
			break;

		default:
			// Test command is wrong. Do nothing.
			break;
	}
	*/

	test_result = test_result1 + test_result2 + test_result3 + other_mem_test_result;


	if ( test_result == PASS )
	{
		return PASS;
	}

	return FAIL;	
}
// ====================================================================== //



// ====================================================================== //
//	Function: Memory_Save_Count
//		- This function saves count value in the memory.
// ---------------------------------------------------------------------- //
void Memory_Save_Count (Uint32 base_address, Uint32 memory_size)
{
	Uint32 i = 0;
	volatile unsigned int *p_address = (unsigned int *)(base_address);
	
	p_address = (unsigned int *)(base_address);
	
	for (i=0; i<=memory_size; i++)
	{
		*p_address = ~((unsigned int)(i & 0x0000FFFF));
		p_address++;		
	}
}
// ====================================================================== //



// ====================================================================== //
//	Function: Memory_Count_Test
//		- This function tests the memory has right count value.
// ---------------------------------------------------------------------- //
int Memory_Count_Test (Uint32 base_address, Uint32 memory_size)
{
	Uint32 i = 0;
	unsigned int temp = 0;
	int test_result = PASS;
	volatile unsigned int *p_address = (unsigned int *)(base_address);

	p_address = (unsigned int *)(base_address);
	
	for (i=0; i<=memory_size; i++)
	{
		temp = *p_address;

		if (temp != ~((unsigned int)(i & 0x0000FFFF)) )
		{
			test_result = FAIL;
		}

		p_address++;		
	}

	return test_result;
}
// ====================================================================== //



// ====================================================================== //
//	Function: Print_Memory_Error
//		- This function prints the error report through Debug SCI.
// ---------------------------------------------------------------------- //
void Print_Memory_Error (Uint32 Address, Uint16 Data_WR, Uint16 Data_RD)
{
	extern Uint32 Timer0TickCount;
	Uint32 Error_Time = 0;
	Uint16 Error_Time_H = 0;
	Uint16 Error_Time_L = 0;
	Uint16 Address_H = 0;
	Uint16 Address_L = 0;

	Error_Time = Timer0TickCount / 10;		// ms

	Error_Time_H = (Uint16)(Error_Time>>16);
	Error_Time_L = (Uint16)(Error_Time & 0x0000FFFF);

	Address_H = (Uint16)(Address>>16);
	Address_L = (Uint16)(Address & 0x0000FFFF);
	
	s_BIT_Info.Mem_BIT_Err_Count++;
	
	Printf("\n\r\n\r-Memory BIT Error: %d",s_BIT_Info.Mem_BIT_Err_Count);
	Printf("\n\r-Time: 0x%4x%4xms",Error_Time_H, Error_Time_L);
	Printf("\n\r-Address: 0x%4x%4x", Address_H, Address_L);
	Printf("\n\r-Expect Data: 0x%4x,   -Read Data:0x%4x\n\r", Data_WR, Data_RD);	
}

// ====================================================================== //


// ====================================================================== //



// ====================================================================== //
// End of file.
// ====================================================================== //




