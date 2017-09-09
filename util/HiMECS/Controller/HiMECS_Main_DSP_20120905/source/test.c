 
#include "test.h"
 
 	extern volatile float Measured_Speed;
 	extern volatile float 		control_value;
	extern unsigned int uiEngineMode; //Engine OP mode
	extern volatile float 		Speed_Command;

int g_testBufferIndex = -2;
 
long g_testBuffer0[TEST_BUFFER_SIZE] = {0,};
long g_testBuffer1[TEST_BUFFER_SIZE] = {0,};
long g_testBuffer2[TEST_BUFFER_SIZE] = {0,};

//char g_testCommand =-2;
//double g_testValue = 0;
//int buff_cnt=50;

void SaveLogData()
{
  
	if(g_testBufferIndex >= 0 && g_testBufferIndex < TEST_BUFFER_SIZE) {
 
	 
 
			g_testBuffer0[g_testBufferIndex] = Measured_Speed;//VelocityActual[0];
			g_testBuffer1[g_testBufferIndex] = Speed_Command;//CurrentActual;//pid_out;
			g_testBuffer2[g_testBufferIndex] = uiEngineMode;//CurrentActual;//pid_out;

			g_testBufferIndex+=1;
			if(g_testBufferIndex >= (TEST_BUFFER_SIZE-2)) {
 				g_testBufferIndex = -2;
			
			}
	 
	/*	else if(OperationMode == OM_VELOCITY) {
 
			g_testBuffer0[g_testBufferIndex] = pid_out ;//VelocityActual[0];//CurrentDemand;//VelocityActual[0];
			g_testBuffer1[g_testBufferIndex] = CurrentActual;//VelocityActual[0];//CurrentActual;//pid_out;
			g_testBuffer2[g_testBufferIndex] = VelocityActual[0];

			g_testBufferIndex+=1;
			if(g_testBufferIndex >= (TEST_BUFFER_SIZE-5)) {
 				g_testBufferIndex = -2;
			
			}

		}
		else if(OperationMode == OM_POSITION) {
 
			g_testBuffer0[g_testBufferIndex] =AD_Input;//current_velocity;// pid_out ;//VelocityActual[0];//CurrentDemand;//VelocityActual[0];
			g_testBuffer1[g_testBufferIndex] =_averagedCurrent;//VelocityActual[0];//CurrentActual;//uiAD_Input;//_positionControllerPI.error;//VelocityActual[0];//CurrentActual;//pid_out;
			g_testBuffer2[g_testBufferIndex] =PositionActual[0];//adc_a_data[3];//PositionActual[0];
			
			g_testBufferIndex+=1;
			if(g_testBufferIndex >= (TEST_BUFFER_SIZE-5)) {
 				g_testBufferIndex = -2;
			
			}
		}
		else if (OperationMode == OM_PWM_DIRECTION)
		{
			g_testBuffer0[g_testBufferIndex] = pid_out ;//VelocityActual[0];//CurrentDemand;//VelocityActual[0];
			g_testBuffer1[g_testBufferIndex] = PositionActual[0];//VelocityActual[0];//CurrentActual;//pid_out;
			g_testBuffer2[g_testBufferIndex] = CurrentActual;//VelocityActual[0];//CurrentActual
			g_testBufferIndex+=1;
			if(g_testBufferIndex >= (TEST_BUFFER_SIZE-5)) {
 			 		g_testBufferIndex = 1;
					return;
			}


		}
		else if (OperationMode == OM_PROFILE_POSITION)
		{
 
			g_testBuffer0[g_testBufferIndex] = PositionDemand ;//VelocityActual[0];//CurrentDemand;//VelocityActual[0];
			g_testBuffer1[g_testBufferIndex] = PositionActual[0];//VelocityActual[0];//CurrentActual;//pid_out;
			g_testBuffer2[g_testBufferIndex] = VelocityActual[0];
			
			g_testBufferIndex+=1;
			if(g_testBufferIndex >= (TEST_BUFFER_SIZE-5)) {
 				g_testBufferIndex = -2;
			
			}
		}
	*/
	}

 
}




 


