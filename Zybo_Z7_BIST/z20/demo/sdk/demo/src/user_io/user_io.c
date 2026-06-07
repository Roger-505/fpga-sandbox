/*
 * user_io.c
 *
 *  Created on: May 25, 2017
 *      Author: bdeac
 */


/***************************** Include Files *********************************/

#include "user_io.h"

/************************** Constant Definitions *****************************/

/************************** Variable Definitions *****************************/
static XGpioPs PsIO;
static u32 ledStatus = 0x0;
static volatile int dutyCycleIncrement = 0;
static volatile u16 intensity = 10;
static volatile int direction = 1;
static volatile int turnOffIncrement = 0;
static volatile int turnOffFlag = 0;

/************************** Function Prototypes ******************************/

/************************** Function Definitions *****************************/

/******************************************************************************
 * This function initializes the PS GPIO
 *
 * @param	void
 *
 * @return	XST_SUCCESS or XST_FAIL
 *
 *****************************************************************************/
XStatus GpioPsInit()
{
	XStatus Status;
	XGpioPs_Config *GpioPS_Config;
	GpioPS_Config = XGpioPs_LookupConfig(XPAR_PS7_GPIO_0_DEVICE_ID);
	Status = XGpioPs_CfgInitialize(&PsIO, GpioPS_Config, GpioPS_Config->BaseAddr);

	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Set the 8th (MIO7 LED) pin from the gpio as output. The rest of the pins are input
	XGpioPs_SetDirection(&PsIO, BANK_0, 0x00000080);
	XGpioPs_SetDirection(&PsIO, BANK_1, 0x00000080);
	// Set the MIO50 and MIO51 as input pins
	XGpioPs_SetDirectionPin(&PsIO, 50, 0x0);
	XGpioPs_SetDirectionPin(&PsIO, 51, 0x0);

	return XST_SUCCESS;
}

/******************************************************************************
 * This function initializes the TTC (Triple Time Counter)
 *
 * @param	XTtcPs pwm is the instance of TTC
 *
 * @return	XST_SUCCESS or XST_FAIL
 *
 *****************************************************************************/
XStatus TTC_Init(XTtcPs *pwm)
{
	XStatus Status;
	XTtcPs_Config *Config;
	Config = XTtcPs_LookupConfig(XPAR_XTTCPS_0_DEVICE_ID);
	if (NULL == Config) {
		return XST_FAILURE;
	}
	Status = XTtcPs_CfgInitialize(pwm, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	XTtcPs_SetOptions(pwm, XTTCPS_OPTION_INTERVAL_MODE | XTTCPS_OPTION_WAVE_DISABLE | XTTCPS_OPTION_MATCH_MODE);
	XInterval Interval;
	u8 Prescaler;
	XTtcPs_CalcIntervalFromFreq(pwm, PWM_PERIOD, &Interval, &Prescaler);
	XTtcPs_SetInterval(pwm, Interval);
	XTtcPs_SetPrescaler(pwm, Prescaler);
	XTtcPs_SetMatchValue(pwm, 0, intensity);
	XTtcPs_EnableInterrupts(pwm, XTTCPS_IXR_INTERVAL_MASK | XTTCPS_IXR_MATCH_0_MASK);

	return XST_SUCCESS;
}

/******************************************************************************
 * This is the interrupt handler for TTC
 *
 * @param	XTtcPs pwm is the instance of TTC
 *
 * @return	XST_SUCCESS or XST_FAIL
 *
 *****************************************************************************/
void ttcInterruptHandler(void *Callback)
{
	u32 IrqStatus;
	XTtcPs *pwmInst = (XTtcPs *)Callback;
	// Read interrupts
	IrqStatus = XTtcPs_GetInterruptStatus(pwmInst);
	XTtcPs_ClearInterruptStatus(pwmInst, IrqStatus);

	if (0 != (XTTCPS_IXR_INTERVAL_MASK & IrqStatus))
	{
		if(turnOffFlag)
		{
			turnOffIncrement++;
			XGpioPs_WritePin(&PsIO, 7, 0x00000000);
			if(turnOffIncrement == TURN_OFF_PERIOD)
			{
				turnOffIncrement = 0;
				turnOffFlag = 0;
				intensity += PWM_INCREASE;
			}
		}
		else
		{
			XGpioPs_WritePin(&PsIO, 7, 0x00000001);
			dutyCycleIncrement++;
			if(dutyCycleIncrement == DUTY_CYCLE_PERIOD)
			{
				dutyCycleIncrement = 0;
				if(intensity < 34000 && intensity > 10)
				{
					if(direction == 1)
					{
						intensity += PWM_INCREASE;
						XTtcPs_SetMatchValue(pwmInst, 0, intensity);
					}
					else
					{
						intensity -= PWM_INCREASE;
						XTtcPs_SetMatchValue(pwmInst, 0, intensity);
					}
				}
				else
					if(intensity >= 34000)
					{
						direction = 0;
						intensity -= PWM_INCREASE;
						XTtcPs_SetMatchValue(pwmInst, 0, intensity);
					}
					else
						if(intensity <= 10)
						{
							direction = 1;
							intensity += PWM_INCREASE;
							XTtcPs_SetMatchValue(pwmInst, 0, intensity);
							turnOffFlag = 1;
						}
			}
		}
	}

	if(0 != (XTTCPS_IXR_MATCH_0_MASK & IrqStatus))
	{
		XGpioPs_WritePin(&PsIO, 7, 0x00000000);
	}
}

/******************************************************************************
 * This function reads a MIO button
 *
 * @param	int pin  (valid values 50 and 51)
 *
 * @return	u8 the actual value of the pin
 *
 *****************************************************************************/
u8 readMIO_Button(int pin)
{
	u8 btn;
	btn = XGpioPs_ReadPin(&PsIO, pin);

	return btn;
}

/******************************************************************************
 * This function turns the MIO led on
 *
 * @param	void
 *
 * @return	void
 *
 *****************************************************************************/
void turnMIO_LedOn()
{
	XGpioPs_WritePin(&PsIO, 7, 0x1);
}

/******************************************************************************
 * This function turns the MIO led off
 *
 * @param	void
 *
 * @return	void
 *
 *****************************************************************************/
void turnMIO_LedOff()
{
	XGpioPs_WritePin(&PsIO, 7, 0x0);
}
