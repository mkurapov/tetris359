.section .text


/*Score_Increment function
 * adds 1 to the score, for use after a successful spawn
 */
.global	Score_Increment
Score_Increment:

	scrAdd	.req r0
	score	.req r1

	push	{r4-r10, r14}

	ldr		scrAdd, =Score
	ldrb	score, [scrAdd]
	add		score, #1
	strb	score, [scrAdd]
	
	.unreq	scrAdd
	.unreq	score

	pop		{r4-r10, r14}
	bx		lr
	
	
/*Score_Update function
 * updates the score based on the number of rows cleared
 *		r0 - encoding of which rows need to be cleared, in reverse order (for convinients), 1 = full, 0 otherwise
 *				bit 0 	- row 19
 *				bit 1 	- row 18
 *				...
 *				bit	18	- row 0
 */
.global	Score_Update
Score_Update:

	scrAdd	.req r4
	score	.req r5
	index	.req r6
	rowCou	.req r7
	mask	.req r8
	row		.req r9
	multip	.req r10

	push	{r4-r10, r14}

	//set up loop guard
	mov		index, #0
	mov		rowCou, #0
	mov		mask, #1
	
	scoreUpdateLoop:
	
		//check the loop guard
		cmp		index, #19
		bge		endScoreUpdateLoop
		
		//get the least significant bit
		and		row, r0, mask
		
		//check if it was a 1, and update the row count if so
		cmp		row, #0
		addne	rowCou, #1
		
		//increment the index, and shift the mask over for the next bit
		add		index, #1
		lsl		mask, #1
		b		scoreUpdateLoop
	
	endScoreUpdateLoop:

	//calculate the specific score to add
	cmp		rowCou, #1
	moveq	multip, #10
	movne	multip, #15
	mul		rowCou, multip
	
	//update the score
	ldr		scrAdd, =Score
	ldrb	score, [scrAdd]
	add		score, rowCou
	strb	score, [scrAdd]
	
	.unreq	scrAdd
	.unreq	score
	.unreq	index
	.unreq	rowCou
	.unreq	mask
	.unreq	row	

	pop		{r4-r10, r14}
	bx		lr


.section .data

.global Score
Score:
.byte	0
