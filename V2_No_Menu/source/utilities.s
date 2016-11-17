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


	/* Random_Number_Generator function
	 * Generates a random number from 0 to 3
	 * Parameters:
	 *	None
	 *Returns:
	 *	r0 - rand(0,3)
	 */
	.global		Random_Number_Generator
	Random_Number_Generator:

		clock	  		.req r0
		clockReg		.req r1
		shiftClock	.req r2
		mask				.req r3

		push			{r4-r10, r14}				//push registers onto the stack

		//set up loop
		ldr		clockReg, =0x3F003004			//get the address for the time counter
		ldr		clock, [clockReg]			//get the base time from the time address

		//lsr		shiftClock, clock, #12
		eor 	clock, clock, lsr #12
		eor 	clock, clock, lsl #25
		eor 	clock, clock, lsr #27

		mov		mask, #3

		and		clock, mask

		.unreq	clockReg
		.unreq	clock
		.unreq	shiftClock
		.unreq	mask

		pop		{r4-r10, r14}				//pop registers off of the stack
		bx		lr							//branch back to the calling subroutine

/* Get_Random_Tetromino function
 * Generates a random number from 0 to 6
 * Parameters:
 *	None
 *Returns:
 *	r0 - rand(0,6)
 */
.global	Get_Random_Tetromino
Get_Random_Tetromino:

	result	  	.req r4
	i						.req r5
	rand				.req r6


	push			{r4-r10, r14}				//push registers onto the stack

	mov	i, #0

	getRandomTetLoop:
			cmp	i, #2
			beq	endRandomTet

			bl	Random_Number_Generator
			add	result, r0

			add	i, #1
			b	getRandomTetLoop

	endRandomTet:

	mov	r0, result

	.unreq	result

	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine


/* Get_Random_Row function
 * Generates a random number from 0 to 18
 * Parameters:
 *	None
 *Returns:
 *	r0 - rand(0,18)
 */
.global	Get_Random_Y
Get_Random_Y:

	result	  	.req r4
	i						.req r5


	push			{r4-r10, r14}				//push registers onto the stack

	mov	i, #0

	//loop random number generator 6 times, max 18
	getRandomRowLoop:
			cmp	i, #6
			beq	endRandomRow

			bl	Random_Number_Generator
			add	result, r0

			add	i, #1
			b	getRandomRowLoop

	endRandomRow:

	mov	r0, result

	.unreq	result
	.unreq	i

	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine


/* Get_Random_X function
 * Generates a random number from 0 to 9
 * Parameters:
 *	None
 *Returns:
 *	r0 - rand(0,9)
 */
.global	Get_Random_X
Get_Random_X:

	result	  	.req r4
	i						.req r5


	push			{r4-r10, r14}				//push registers onto the stack

	mov	i, #0

	//loop random number generator 3 times, max 9
	getRandomColumnLoop:
			cmp	i, #3
			beq	endRandomColumn

			bl	Random_Number_Generator
			add	result, r0

			add	i, #1
			b	getRandomColumnLoop

	endRandomColumn:

	mov	r0, result

	.unreq	result
	.unreq	i

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
