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

	result	  	.req r0
	mask				.req r4
	rand				.req r5


	push			{r4-r10, r14}				//push registers onto the stack

	mov	mask, #15

	bl	Random_Number_Generator

	and	result, mask

	cmp	result, #13
	subhi	result, #9
	bhi		endGetRandomTet

	cmp	result, #6
	subhi	result, #7
	bhi		endGetRandomTet

	endGetRandomTet:

	.unreq	result
	.unreq	mask
	.unreq	rand

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
	
	cmp		r0, #'F'
	ldreq	r0, =Value_Pack_Fast
	beq		end_ASCII_To_Address
	
	cmp		r0, #'I'
	ldreq	r0, =Value_Pack_Invisible
	beq		end_ASCII_To_Address

	end_ASCII_To_Address:
	pop		{r4-r10, r14}
	bx		lr
	
	
	
/* Digit_To_Address function
 *	converts an digit to the base address of the associated number
 *	r0 - digit
 *	Returns:
 *		R0- Address of associated number image
 */
.global Digit_To_Address
Digit_To_Address:

	push	{r4-r10, r14}

	//switch type statements to load the corresponding address into r0 and skip other checks
	cmp		r0, #0
	ldreq	r0, =Char_0
	beq		end_Digit_To_Address

	cmp		r0, #1
	ldreq	r0, =Char_1
	beq		end_Digit_To_Address

	cmp		r0, #2
	ldreq	r0, =Char_2
	beq		end_Digit_To_Address

	cmp		r0, #3
	ldreq	r0, =Char_3
	beq		end_Digit_To_Address

	cmp		r0, #4
	ldreq	r0, =Char_4
	beq		end_Digit_To_Address

	cmp		r0, #5
	ldreq	r0, =Char_5
	beq		end_Digit_To_Address

	cmp		r0, #6
	ldreq	r0, =Char_6
	beq		end_Digit_To_Address

	cmp		r0, #7
	ldreq	r0, =Char_7
	beq		end_Digit_To_Address

	cmp		r0, #8
	ldreq	r0, =Char_8
	beq		end_Digit_To_Address
	
	cmp		r0, #9
	ldreq	r0, =Char_9
	beq		end_Digit_To_Address

	end_Digit_To_Address:
	pop		{r4-r10, r14}
	bx		lr
	
	
	


/* Number_To_Bit function
 *	calculates which bit of a register is the first one set
 *	r0 - number, as a power of 2 (so only up to one bit is set)
 *	Returns:
 *		r0- the index of the bit set
 */
.global Number_To_Bit
Number_To_Bit:

	index	.req r4
	mask	.req r5
	bit		.req r6

	push	{r4-r10, r14}

	//set up the loop index
	mov		index, #0
	mov		mask, #1

	numberToBitLoop:
	
		//check loop guard
		cmp		index, #32
		bge		endNumberToBitLoop
		
		//get the state of the current bit
		and		bit, mask, r0
	
		//check if the bit is set, and exit if so
		cmp		bit, #0
		bne		endNumberToBitLoop
		
		//otherwise, increment the index and shift the mask
		add		index, #1
		lsl		mask, #1
		b		numberToBitLoop
	
	endNumberToBitLoop:
	
	//if not bits were found, return 0
	cmp		index, #32
	movge		index, #0
	
	//move the index out to the result
	mov		r0, index
	
	.unreq	index
	.unreq	mask
	.unreq	bit
	
	pop		{r4-r10, r14}
	bx		lr
	
	
	

/* Isolate_Digits function
 *	isolates the digit of the hundreds, tens, and ones spot of a number
 *	r0 - number to be split
 *	Returns:
 *		r0 - digit in hundreds spot
 *		r1 - digit in tens spot
 *		r2 - digit in ones spot
 */
.global Isolate_Digits
Isolate_Digits:


	push	{r4-r10, r14}

	number	.req r4
	index	.req r5

	//take a copy of the original number and set up the loop index
	mov		number, r0
	mov		index, #0


	hundredsLoop:	
	
		//subtract 100 until number <100 to count how many hundreds compose the number
		cmp 	number, #100					
		subhs 	number, #100					
		addhs	index, #1					
		bhs 	hundredsLoop	
	
	endHundredsLoop:
	
	//move the hundreds digit to the return register and reset the index
	mov		r0, index
	mov 	index, #0
	
	tensLoop:
	
		//subtract 10 until number <10 to count how many tens compose the number
		cmp number, #10	
		subhs number, #10	
		addhs index, #1		
		bhs tensLoop		
	
	endTensLoop:
	
	//move the tens and ones digits to the return registers
	mov		r1, index
	mov		r2, number 
	
	.unreq	number
	.unreq	index
		
	pop		{r4-r10, r14}
	bx		lr
	

.section .data
