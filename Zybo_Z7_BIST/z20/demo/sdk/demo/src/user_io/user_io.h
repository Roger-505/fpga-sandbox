/*
 * user_io.h
 *
 *  Created on: May 25, 2017
 *      Author: bdeac
 */

#ifndef SRC_USER_IO_USER_IO_H_
#define SRC_USER_IO_USER_IO_H_

/***************************** Include Files *********************************/

#include "xgpiops.h"
#include "xttcps.h"
#include <xstatus.h>

/************************** Constant Definitions *****************************/

#define NR_AUDIO_SAMPLES		451708*2
#define AUDIO_SAMPLES_ADDR		0x1FE22000
#define BANK_0					0
#define BANK_1					1
#define PWM_PERIOD				50
#define PWM_INCREASE			500
#define DUTY_CYCLE_PERIOD		1
#define TURN_OFF_PERIOD			50

/************************** Variable Definitions *****************************/

/************************** Function Prototypes ******************************/

void ttcInterruptHandler(void *Callback);
XStatus GpioPsInit();
XStatus TTC_Init(XTtcPs *pwm);
u8 readMIO_Button(int pin);
void turnMIO_LedOn();
void turnMIO_LedOff();

#endif /* SRC_USER_IO_USER_IO_H_ */
