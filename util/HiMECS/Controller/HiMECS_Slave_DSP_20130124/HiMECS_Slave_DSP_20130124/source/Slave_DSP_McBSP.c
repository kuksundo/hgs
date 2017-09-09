// ====================================================================== //
//				HiMECS Salve DSP Program
// ====================================================================== //
//	- Author: Taewan Kim (System Control Lab.)
//	- Copyright: Hyundai Heavy Industries Co., Ltd. 
// ====================================================================== //
//	- File: Slave_DSP_McBSP.c
// ---------------------------------------------------------------------- //
//	- Description: 
//		Source file for McBSP Communication as SPI.
// ---------------------------------------------------------------------- //
//	- Revision History -
// ---------------------------------------------------------------------- //
//		2012-07-02:	Draft
// ====================================================================== //




// ====================================================================== //
//	Includes
// ====================================================================== //
#include "DSP2833x_Device.h"	
#include "DSP2833x_Examples.h"
#include "Slave_DSP_McBSP.h"




// ====================================================================== //
//	Functions
// ====================================================================== //

// ====================================================================== //
//	Function: McBSP_A_GPIO_Init
//		- GPIO 
// ---------------------------------------------------------------------- //
void McBSP_A_GPIO_Init(void)
{
	EALLOW;

	/* Configure McBSP-A pins using GPIO regs*/
	// This specifies which of the possible GPIO pins will be McBSP functional pins.
	// Comment out other unwanted lines.
	GpioCtrlRegs.GPAMUX2.bit.GPIO20 = 2;		// GPIO20 is MDXA pin
	GpioCtrlRegs.GPAMUX2.bit.GPIO21 = 2;		// GPIO21 is MDRA pin
    GpioCtrlRegs.GPAMUX2.bit.GPIO22 = 2;		// GPIO22 is MCLKXA pin
    //GpioCtrlRegs.GPAMUX1.bit.GPIO7 = 2;		// GPIO7 is MCLKRA pin (Comment as needed)
	//GpioCtrlRegs.GPBMUX2.bit.GPIO58 = 1;		// GPIO58 is MCLKRA pin (Comment as needed)
    //GpioCtrlRegs.GPAMUX2.bit.GPIO23 = 2;		// GPIO23 is MFSXA pin
    //GpioCtrlRegs.GPAMUX1.bit.GPIO5 = 2;		// GPIO5 is MFSRA pin (Comment as needed)
	//GpioCtrlRegs.GPBMUX2.bit.GPIO59 = 1;		// GPIO59 is MFSRA pin (Comment as needed)

	/* Enable internal pull-up for the selected pins */
	// Pull-ups can be enabled or disabled by the user.
	// This will enable the pullups for the specified pins.
	// Comment out other unwanted lines.
	GpioCtrlRegs.GPAPUD.bit.GPIO20 = 0;			// Enable pull-up on GPIO20 (MDXA)
	GpioCtrlRegs.GPAPUD.bit.GPIO21 = 0;			// Enable pull-up on GPIO21 (MDRA)
	GpioCtrlRegs.GPAPUD.bit.GPIO22 = 0;			// Enable pull-up on GPIO22 (MCLKXA)
	//GpioCtrlRegs.GPAPUD.bit.GPIO7 = 0;		// Enable pull-up on GPIO7 (MCLKRA) (Comment as needed)
	//GpioCtrlRegs.GPBPUD.bit.GPIO58 = 0;		// Enable pull-up on GPIO58 (MCLKRA) (Comment as needed)
	//GpioCtrlRegs.GPAPUD.bit.GPIO23 = 0;		// Enable pull-up on GPIO23 (MFSXA)
	//GpioCtrlRegs.GPAPUD.bit.GPIO5 = 0;		// Enable pull-up on GPIO5 (MFSRA) (Comment as needed)
	//GpioCtrlRegs.GPBPUD.bit.GPIO59 = 0;		// Enable pull-up on GPIO59 (MFSRA) (Comment as needed)

	/* Set qualification for selected input pins to asynch only */
	// This will select asynch (no qualification) for the selected pins.
	// Comment out other unwanted lines.
    GpioCtrlRegs.GPAQSEL2.bit.GPIO21 = 3;		// Asynch input GPIO21 (MDRA)
    GpioCtrlRegs.GPAQSEL2.bit.GPIO22 = 3;		// Asynch input GPIO22 (MCLKXA)
    //GpioCtrlRegs.GPAQSEL1.bit.GPIO7 = 3;		// Asynch input GPIO7 (MCLKRA) (Comment as needed)
    //GpioCtrlRegs.GPBQSEL2.bit.GPIO58 = 3;		// Asynch input GPIO58(MCLKRA) (Comment as needed)
    //GpioCtrlRegs.GPAQSEL2.bit.GPIO23 = 3;		// Asynch input GPIO23 (MFSXA)
    //GpioCtrlRegs.GPAQSEL1.bit.GPIO5 = 3;		// Asynch input GPIO5 (MFSRA) (Comment as needed)
    //GpioCtrlRegs.GPBQSEL2.bit.GPIO59 = 3;		// Asynch input GPIO59 (MFSRA) (Comment as needed)

	EDIS;
}

void McBSP_B_GPIO_Init(void)
{
    EALLOW;
	
	/* Configure McBSP-A pins using GPIO regs*/
	// This specifies which of the possible GPIO pins will be McBSP functional pins.
	// Comment out other unwanted lines.
	//GpioCtrlRegs.GPAMUX1.bit.GPIO12 = 3;	// GPIO12 is MDXB pin (Comment as needed)
	GpioCtrlRegs.GPAMUX2.bit.GPIO24 = 3;	// GPIO24 is MDXB pin (Comment as needed)
	//GpioCtrlRegs.GPAMUX1.bit.GPIO13 = 3;	// GPIO13 is MDRB pin (Comment as needed)
	GpioCtrlRegs.GPAMUX2.bit.GPIO25 = 3;	// GPIO25 is MDRB pin (Comment as needed)
	//GpioCtrlRegs.GPAMUX1.bit.GPIO14 = 3;	// GPIO14 is MCLKXB pin (Comment as needed)
	GpioCtrlRegs.GPAMUX2.bit.GPIO26 = 3;	// GPIO26 is MCLKXB pin (Comment as needed)
	//GpioCtrlRegs.GPAMUX1.bit.GPIO3 = 3;		// GPIO3 is MCLKRB pin (Comment as needed)
	//GpioCtrlRegs.GPBMUX2.bit.GPIO60 = 1;	// GPIO60 is MCLKRB pin (Comment as needed)
	//GpioCtrlRegs.GPAMUX1.bit.GPIO15 = 3;	// GPIO15 is MFSXB pin (Comment as needed)
	//GpioCtrlRegs.GPAMUX2.bit.GPIO27 = 3;	// GPIO27 is MFSXB pin (Comment as needed)
	//GpioCtrlRegs.GPAMUX1.bit.GPIO1 = 3;		// GPIO1 is MFSRB pin (Comment as needed)
	//GpioCtrlRegs.GPBMUX2.bit.GPIO61 = 1;	// GPIO61 is MFSRB pin (Comment as needed)

	/* Enable internal pull-up for the selected pins */
	// Pull-ups can be enabled or disabled by the user.
	// This will enable the pullups for the specified pins.
	// Comment out other unwanted lines.
	GpioCtrlRegs.GPAPUD.bit.GPIO24 = 0;	    // Enable pull-up on GPIO24 (MDXB) (Comment as needed)
	//GpioCtrlRegs.GPAPUD.bit.GPIO12 = 0;	// Enable pull-up on GPIO12 (MDXB) (Comment as needed)
	GpioCtrlRegs.GPAPUD.bit.GPIO25 = 0;	    // Enable pull-up on GPIO25 (MDRB) (Comment as needed)
	//GpioCtrlRegs.GPAPUD.bit.GPIO13 = 0;	// Enable pull-up on GPIO13 (MDRB) (Comment as needed)
	GpioCtrlRegs.GPAPUD.bit.GPIO26 = 0;	    // Enable pull-up on GPIO26 (MCLKXB) (Comment as needed)
	//GpioCtrlRegs.GPAPUD.bit.GPIO14 = 0;	// Enable pull-up on GPIO14 (MCLKXB) (Comment as needed)
	//GpioCtrlRegs.GPAPUD.bit.GPIO3 = 0;		// Enable pull-up on GPIO3 (MCLKRB) (Comment as needed)
	//GpioCtrlRegs.GPBPUD.bit.GPIO60 = 0;	// Enable pull-up on GPIO60 (MCLKRB) (Comment as needed)
	//GpioCtrlRegs.GPAPUD.bit.GPIO27 = 0;	    // Enable pull-up on GPIO27 (MFSXB) (Comment as needed)
	//GpioCtrlRegs.GPAPUD.bit.GPIO15 = 0;	// Enable pull-up on GPIO15 (MFSXB) (Comment as needed)
	//GpioCtrlRegs.GPAPUD.bit.GPIO1 = 0;		// Enable pull-up on GPIO1 (MFSRB) (Comment as needed)
	//GpioCtrlRegs.GPBPUD.bit.GPIO61 = 0;	// Enable pull-up on GPIO61 (MFSRB) (Comment as needed)


	/* Set qualification for selected input pins to asynch only */
	// This will select asynch (no qualification) for the selected pins.
	// Comment out other unwanted lines.
     GpioCtrlRegs.GPAQSEL2.bit.GPIO25 = 3;   // Asynch input GPIO25 (MDRB) (Comment as needed)
    //GpioCtrlRegs.GPAQSEL1.bit.GPIO13 = 3; // Asynch input GPIO13 (MDRB) (Comment as needed)
    GpioCtrlRegs.GPAQSEL2.bit.GPIO26 = 3;   // Asynch input GPIO26(MCLKXB) (Comment as needed)
    //GpioCtrlRegs.GPAQSEL1.bit.GPIO14 = 3; // Asynch input GPIO14 (MCLKXB) (Comment as needed)
    //GpioCtrlRegs.GPAQSEL1.bit.GPIO3 = 3;    // Asynch input GPIO3 (MCLKRB) (Comment as needed)
    //GpioCtrlRegs.GPBQSEL2.bit.GPIO60 = 3; // Asynch input GPIO60 (MCLKRB) (Comment as needed)
    //GpioCtrlRegs.GPAQSEL2.bit.GPIO27 = 3;   // Asynch input GPIO27 (MFSXB) (Comment as needed)
	//GpioCtrlRegs.GPAQSEL1.bit.GPIO15 = 3; // Asynch input GPIO15 (MFSXB) (Comment as needed)
	//GpioCtrlRegs.GPAQSEL1.bit.GPIO1 = 3;    // Asynch input GPIO1 (MFSRB) (Comment as needed)
	//GpioCtrlRegs.GPBQSEL2.bit.GPIO61 = 3; // Asynch input GPIO61 (MFSRB) (Comment as needed)

	EDIS;
}


// ====================================================================== //
//	Function: McBSP_Init_SPI
//		- Analog I/O uses McBSP as SPI communication.
//		  This Function initializes McBSP registers for SPI communication.
// ---------------------------------------------------------------------- //
void McBSP_Init_SPI(void)
{
	// McBSP GPIO Setting.
	McBSP_A_GPIO_Init();
	McBSP_B_GPIO_Init();
	
	EALLOW;
	
     // McBSP-A register settings
    McbspaRegs.SPCR2.all=0x0000;			// Reset FS generator, sample rate generator & transmitter
	McbspaRegs.SPCR1.all=0x0000;			// Reset Receiver, Right justify word, Digital loopback dis.
    McbspaRegs.PCR.all=0x0F08;				//(CLKXM=CLKRM=FSXM=FSRM= 1, FSXP = 1)
    McbspaRegs.SPCR1.bit.DLB = 0;			// Loopback Disable.		
    McbspaRegs.SPCR1.bit.CLKSTP = 2;		// Clock Stop mode(for SPI), without clock delay.
	McbspaRegs.PCR.bit.CLKXP = 1;			// Tx data is sampled on the falling edge of CLKX.
	McbspaRegs.PCR.bit.CLKRP = 1;			// Rx data is sampled on the rising edge of CLKX.
    McbspaRegs.RCR2.bit.RDATDLY=1;			// FSX setup time 1 in master mode. 0 for slave mode (Receive)
    McbspaRegs.XCR2.bit.XDATDLY=1;			// FSX setup time 1 in master mode. 0 for slave mode (Transmit)

	McbspaRegs.RCR1.bit.RWDLEN1=0;		    // Rx Data length 8-bit word
    McbspaRegs.XCR1.bit.XWDLEN1=0;			// Tx Data lengrh 8-bit word

    McbspaRegs.SRGR2.all=0x2000;			// CLKSM=1, FPER = 1 CLKG periods
    McbspaRegs.SRGR1.all= 0x000A;			// Frame Width = 1 CLKG period, CLKGDV=10

    McbspaRegs.SPCR2.bit.GRST=1;			// Enable the sample rate generator
    
	McBSP_delay_loop();						// Wait at least 2 SRG clock cycles
	
	McbspaRegs.SPCR2.bit.XRST=1;			// Release TX from Reset
	McbspaRegs.SPCR1.bit.RRST=1;			// Release RX from Reset
    McbspaRegs.SPCR2.bit.FRST=1;			// Frame Sync Generator reset


	// McBSP-B register settings
    McbspbRegs.SPCR2.all=0x0000;			// Reset FS generator, sample rate generator & transmitter
	McbspbRegs.SPCR1.all=0x0000;			// Reset Receiver, Right justify word, Digital loopback dis.
    McbspbRegs.PCR.all=0x0F08;				//(CLKXM=CLKRM=FSXM=FSRM= 1, FSXP = 1)
   
    McbspbRegs.SPCR1.bit.DLB = 0;			// Loopback Disable.		
    McbspbRegs.SPCR1.bit.CLKSTP = 3;		// Clock Stop mode(for SPI), without clock delay.
	McbspbRegs.PCR.bit.CLKXP = 1;			// Tx data is sampled on the falling edge of CLKX.
	McbspbRegs.PCR.bit.CLKRP = 1;			// Rx data is sampled on the falling edge of CLKX.
    McbspbRegs.RCR2.bit.RDATDLY=1;			// FSX setup time 1 in master mode. 0 for slave mode (Receive)
    McbspbRegs.XCR2.bit.XDATDLY=1;			// FSX setup time 1 in master mode. 0 for slave mode (Transmit)

	McbspbRegs.RCR1.bit.RWDLEN1=2;		    // Rx Data length 16-bit word
    McbspbRegs.XCR1.bit.XWDLEN1=2;			// Tx Data lengrh 16-bit word

    McbspbRegs.SRGR2.all=0x2000;			// CLKSM=1, FPER = 1 CLKG periods
    McbspbRegs.SRGR1.all= 0x0002;			// Frame Width = 1 CLKG period, CLKGDV=10

    McbspbRegs.SPCR2.bit.GRST=1;			// Enable the sample rate generator
    
	McBSP_delay_loop();						// Wait at least 2 SRG clock cycles
	
	McbspbRegs.SPCR2.bit.XRST=1;			// Release TX from Reset
	McbspbRegs.SPCR1.bit.RRST=1;			// Release RX from Reset
    McbspbRegs.SPCR2.bit.FRST=1;			// Frame Sync Generator reset

	EDIS;
}
// ====================================================================== //



// ====================================================================== //
//	Function: McBSP_A_Tx_Data
//		- This function send data 
// ---------------------------------------------------------------------- //
void McBSP_A_Tx_Data(unsigned char data)
{
	// Tx Data
    McbspaRegs.DXR1.all=(Uint16)data;
}
// ====================================================================== //



// ====================================================================== //
//	Function:	McBSP_A_Rx_Data
//		- Rx Data to RTD using SPI
// ---------------------------------------------------------------------- //
unsigned char McBSP_A_Rx_Data (void)
{
	Uint16 temp = 0xFF;
	Uint16 Wait_count = 0;

	// Wait util get Rx data from McBSP.
	while (McbspaRegs.SPCR1.bit.RRDY == 0)
	{
		if (Wait_count > 1000)
		{
			return 0xFF;
		}
		Wait_count++;		
	}

	// Get a Rx data from McBSP.
	temp = McbspaRegs.DRR1.all;
	temp = temp & 0xFF;

	return (unsigned char)temp;
}
// ====================================================================== //



// ====================================================================== //
//	Function: McBSP_B_Tx_Data
//		- This function send data 
// ---------------------------------------------------------------------- //
void McBSP_B_Tx_Data(Uint16 data)
{
	// Tx Data
    McbspbRegs.DXR1.all=(Uint16)data;
}
// ====================================================================== //



// ====================================================================== //
//	Function:	McBSP_B_Rx_Data
//		- Rx Data to RTD using SPI
// ---------------------------------------------------------------------- //
Uint16 McBSP_B_Rx_Data (void)
{
	Uint16 temp = 0xFF;
	Uint16 Wait_count = 0;

	// Wait util get Rx data from McBSP.
	while (McbspbRegs.SPCR1.bit.RRDY == 0)
	{
		if (Wait_count > 1000)
		{
			return 0xFF;
		}
		Wait_count++;		
	}

	// Get a Rx data from McBSP.
	temp = McbspbRegs.DRR1.all;

	return temp;
}
// ====================================================================== //



// ====================================================================== //
//	Function: McBSP_delay_loop
//		- Delay loop for McBSP Initialization.
// ---------------------------------------------------------------------- //
void McBSP_delay_loop(void)
{
    long      i;
    for (i = 0; i < MCBSP_INIT_DELAY; i++) {} //delay in McBsp init. must be at least 2 SRG cycles
}
// ====================================================================== //



// ====================================================================== //



// ====================================================================== //
// End of file.
// ====================================================================== //




