.section .text

/* Random_Number_Generator function
* Generates a random number and returns it
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

	cmp		result, #14
	subls	result, #14
	bls		endGetRandomTet

	cmp		result, #7
	subls	result, #7
	bls		endGetRandomTet

	endGetRandomTet:

	.unreq	result
	.unreq	mask
	.unreq	rand

	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine


/* Get_Random_Y function
 * Generates a random number from 0 to 18
 * Parameters:
 *	None
 *Returns:
 *	r0 - rand(0,18)
 */
.global	Get_Random_Y
Get_Random_Y:

	result	  	.req r0
	mask				.req r4
	rand				.req r5


	push			{r4-r10, r14}				//push registers onto the stack

	mov	mask, #127

	bl	Random_Number_Generator

	and	result, mask

	cmp		result, #114
	subls	result, #114
	bls		endGetRandomY

	cmp		result, #95
	subls	result, #95
	bls		endGetRandomY

	cmp		result, #76
	subls	result, #76
	bls		endGetRandomY

	cmp		result, #57
	subls	result, #57
	bls		endGetRandomY

	cmp		result, #38
	subls	result, #38
	bls		endGetRandomY

	cmp		result, #19
	subls	result, #19
	bls		endGetRandomY

	endGetRandomX:

	.unreq	result
	.unreq	mask
	.unreq	rand

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

	result	  	.req r0
	mask				.req r4
	rand				.req r5


	push			{r4-r10, r14}				//push registers onto the stack

	mov	mask, #63

	bl	Random_Number_Generator

	and	result, mask

	cmp		result, #60
	subls	result, #60
	bls		endGetRandomX

	cmp		result, #50
	subls	result, #50
	bls		endGetRandomX

	cmp		result, #40
	subls	result, #40
	bls		endGetRandomX

	cmp		result, #30
	subls	result, #30
	bls		endGetRandomX

	cmp		result, #20
	subls	result, #20
	bls		endGetRandomX

	cmp		result, #10
	subls	result, #10
	bls		endGetRandomX

	endGetRandomX:

	.unreq result
	.unreq mask
	.unreq rand

	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine
