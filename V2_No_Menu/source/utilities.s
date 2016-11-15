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




/* ASCII_To_Address function
 *	converts an ASCII character to the base address of the associated block type
 *	r0 - ASCII character
 *	Returns:
 *		R0- Address of associated block image	
 */
.global ASCII_To_Address
ASCII_To_Address:	

	push	{r4-r10, r14}

	//switch type statements to load the corresponding address into r0 and skip other checks
	cmp		r0, #'E'
	ldreq	r0, =Empty_Block
	beq		end_ASCII_To_Address
	
	cmp		r0, #'W'
	ldreq	r0, =Wall_Block
	beq		end_ASCII_To_Address
	
	cmp		r0, #'C'
	ldreq	r0, =Cyan_Block
	beq		end_ASCII_To_Address
	
	cmp		r0, #'B'
	ldreq	r0, =Blue_Block
	beq		end_ASCII_To_Address
	
	cmp		r0, #'O'
	ldreq	r0, =Orange_Block
	beq		end_ASCII_To_Address
	
	cmp		r0, #'Y'
	ldreq	r0, =Yellow_Block
	beq		end_ASCII_To_Address
	
	cmp		r0, #'G'
	ldreq	r0, =Green_Block
	beq		end_ASCII_To_Address
	
	cmp		r0, #'P'
	ldreq	r0, =Purple_Block
	beq		end_ASCII_To_Address
	
	cmp		r0, #'R'
	ldreq	r0, =Red_Block
	beq		end_ASCII_To_Address
	
	end_ASCII_To_Address:
	pop		{r4-r10, r14}
	bx		lr




.section .data
