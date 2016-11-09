.section .text


/* Wait fuction
 *Waits for a certain amount of time (micro-seconds)
 *Parameters:
 *	r0- amount of time (in micro-seconds)
 *Returns:
 *	None
 */	
.global		Wait
Wait:

	delay	.req r0
	timReg	.req r1
	basTim	.req r2
	reqTim	.req r3
	curTim	.req r4

	push	{r4-r10, r14}				//push registers onto the stack

	//set up loop
	ldr		timReg, =0x3F003004			//get the address for the time counter
	ldr		basTim, [timReg]			//get the base time from the time address
	add		reqTim, basTim, delay		//set the required time to be the base time plus the delay

	//loop until the current time == required time
	delayLoop:
		ldr		curTim, [timReg]		//get the current time
		cmp		curTim, reqTim			//compare the current time to the required time
		blo		delayLoop				//branch back to loop if value is lower
	endDelayLoop:

	.unreq	delay
	.unreq	timReg
	.unreq	basTim
	.unreq	reqTim
	.unreq	curTim

	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine




.section .data
