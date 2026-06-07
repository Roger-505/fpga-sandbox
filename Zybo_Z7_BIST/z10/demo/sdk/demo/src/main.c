/******************************************************************************
 * @file main.c
 * This is the main function's definition file for the Arty Z7 -Z20 demo.
 *
 * @authors Elod Gyorgy
 *
 * @date 2016-Dec-21
 *
 * @copyright
 * (c) 2016 Copyright Digilent Incorporated
 * All Rights Reserved
 *
 * This program is free software; distributed under the terms of BSD 3-clause
 * license ("Revised BSD License", "New BSD License", or "Modified BSD License")
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name(s) of the above-listed copyright holder(s) nor the names
 *    of its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 * @desciption
 * It is a simple demo that controls the LEDs to make sure Zynq boots up. Buttons,
 * switches modify the behavior of the LEDs.
 * HDMI input will be forwarded unchanged to HDMI output.
 * Audio output plays a pre-recorded soundtrack loaded from the boot image.
 *
 * @note
 *
 * UART setup:		In order to successfully communicate you must set your
 * 					terminal to 115200 Baud, 8 data bits, 1 stop bit, no parity.
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who          Date        Changes
 * ----- ------------ ----------- --------------------------------------------
 * 1.00  Elod Gyorgy 2016-Dec-21 First release
 *
 * </pre>
 *
 *****************************************************************************/

/***************************** Include Files *********************************/
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <xstatus.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "xil_exception.h"

#include "verbose/verbose.h"
#include "platform/platform.h"
#include "intc/intc.h"
#include "user_io/user_io.h"
#include "Audio/SSM2603/ssm2603.h"
#include "Audio/I2S/di2s.h"
#include "dma/dma.h"
#include "xgpiops.h"
#include "xttcps.h"

/************************** Constant Definitions *****************************/

/********************* Global Variable Definitions ***************************/
static XAxiDma sAxiDma;
DI2s I2S;
XTtcPs pwm;

/****************** Static Global Variable Definitions ***********************/


const ivt_t ivt[] =
{
	//{XPAR_XQSPIPS_0_INTR, (Xil_InterruptHandler)XQspiPs_InterruptHandler, &sQSpi},
	{XPAR_FABRIC_AUDIO_DMA_MM2S_INTROUT_INTR, (XInterruptHandler)fnMM2SInterruptHandler, &sAxiDma},
	{XPAR_XTTCPS_0_INTR, (XInterruptHandler)ttcInterruptHandler, &pwm}
};

/************************** Function Prototypes ******************************/
u32 ALSinGenerator(u32 *pu32SinArray, u32 u32NrSamples, u32 u32SinFreq, u32 u32SamplingFreq, u32 u32Amplitude);

/************************** Function Definitions *****************************/
int main() {
	XStatus Status, fInitSuccess;
	static XScuGic sIntc;
	u8 btn;

	init_platform();

	SET_VERBOSE_FLAG();

	//This might not be printed properly, if CmdInit below uses the same UART as stdout
	VERBOSE("Initializing...");
	fInitSuccess = XST_SUCCESS;

	{
		// Initialize the interrupt controller
		Status = fnInitInterruptController(&sIntc);
		if(Status != XST_SUCCESS) {
			VERBOSE("err:irpt");
			fInitSuccess = XST_FAILURE;
			goto endinit;
		}

		//Initialise Audio
		{
			//Init the I2S core
			Status = DI2s_Initialize(&I2S);
			if (Status != XST_SUCCESS)
			{
				VERBOSE("err:DI2s");
				return 1;
			}
			//Set Sampling rate
			DI2s_SetClockOptions(&I2S, DI2S_SAMPLING_RATE_48KHZ, DI2S_MASTER_MODE);

			//Set codec
			Status = SSM2603_InitAudio();
			if (Status != XST_SUCCESS)
			{
				VERBOSE("err:audio_i2c");
				return 1;
			}

		    // Avoid blocking the DMA in certain conditions
		    DI2s_StopI2sStream(&I2S, DI2S_RECEIVE | DI2S_TRANSMIT);

			// Initialize DMA
			Status = fnConfigDma(&sAxiDma);
			if (Status != XST_SUCCESS)
			{
				VERBOSE("err:dma");
				return 1;
			}

			//Unmute codec
			Xil_Out8(XPAR_AUDIO_MUTE_BASEADDR, 0x01);
		}

		Status = GpioPsInit();
		if(Status != XST_SUCCESS)
		{
			VERBOSE("err:ps_gpio");
			return 1;
		}

		Status = TTC_Init(&pwm);
		if(Status != XST_SUCCESS)
		{
			VERBOSE("err:ttc");
			return 1;
		}

		//Init rest of drivers here

		// Enable all interrupts in our interrupt vector table
		// Make sure all driver instances using this IVT are initialized first
		fnEnableInterrupts(&sIntc, &ivt[0], sizeof(ivt)/sizeof(ivt[0]));
		fnEnableInterrupts(&sIntc, &ivt[1], sizeof(ivt)/sizeof(ivt[1]));

		VERBOSE("init:done");

endinit:
		fInitSuccess = fInitSuccess; //Have to add an instruction for the label
	}

	VERBOSE("Zybo Z7-10 Rev. B Demo Image\r\n");

	XTtcPs_Start(&pwm);

	while(1) {
		btn = Xil_In8(XPAR_AUDIO_BTN_BASEADDR);
		if (btn)
		{
		    DI2s_SetNrSamples(&I2S, NR_AUDIO_SAMPLES);
			DI2s_DmaPlayBack(&I2S, &sAxiDma, NR_AUDIO_SAMPLES, AUDIO_SAMPLES_ADDR);
		}

		u8 btn4 = readMIO_Button(50);
		u8 btn5 = readMIO_Button(51);
		if(btn4 == 1 && btn5 == 0)
		{
			XTtcPs_Stop(&pwm);
			turnMIO_LedOn();
		}
		else
			if(btn4 == 0 && btn5 == 1)
			{
				XTtcPs_Stop(&pwm);
				turnMIO_LedOff();
			}
			else
				XTtcPs_Start(&pwm);
	}

	cleanup_platform();
	return 0;
}
