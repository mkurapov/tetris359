.section .text


/*Move_Down function
 *	attempts to move the current tetromino downward (may set spawn flag)
 *	return:
 *		r0 - success=1, fail=0				
 */
.global	Move_Down
Move_Down:

	tetAdd	.req r4
	xCoord	.req r5
	yCoord	.req r6
	index	.req r7
	result	.req r8
	flgAdd	.req r9
	length	.req r10


	push	{r4-r10, r14}

	//clear the tetromino to avoid failed update
	bl		Clear_Tetromino
	bl		Clear_Tet_Screen
	
	//get the base address for the coordinates and the virtual board
	ldr		tetAdd, =First

	//set up loop index
	mov		index, #0
	mov		length, #12

	downTestLoop:
	
		//check loop guard
		cmp		index, #4
		bge		endDownTestLoop

		//get the base (x,y+ 1) coords 
		ldrb	xCoord, [tetAdd], #1
		ldrb	yCoord, [tetAdd], #1
		add		yCoord, #1
		
		//check if the cell is empty
		mov		r0, xCoord
		mov		r1, yCoord
		bl		Check_Empty
		
		//if the cell is not clear, set the spawn flag and end
		cmp		r0, #1
		strneb	result, [flgAdd]
		movne	result, #0
		bne		endDownLoop
		
		//incerement loop counter
		add		index, #1
		b		downTestLoop

	endDownTestLoop:
	
	//if the move is valid, preform the move.
	mov		index, #0
	mov		length, #12
	
	//get the y-value address from First
	ldr		tetAdd, =First
	add		tetAdd, #1
	
	downLoop:
	
		//check loop guard
		cmp		index, #4
		bge		endDownLoop
	
		//update the y-value (increment address by 2 for next y-value)
		ldrb	yCoord, [tetAdd]
		add		yCoord, #1
		strb	yCoord, [tetAdd], #2
	
		//incerement loop counter
		add		index, #1
		b		downLoop
	
	endDownLoop:
	
	//set the tetromino back out to the virtual board
	bl		Set_Tetromino
	bl		Set_Tet_Screen
	
	//increment the score if the block has reached the bottom
	cmp		result, #0
	bleq	Score_Increment
	
	//set return value
	mov		r0, result

	pop		{r4-r10, r14}
	bx		lr

	.unreq	tetAdd
	.unreq	xCoord
	.unreq	yCoord
	.unreq	index
	.unreq	result
	.unreq	flgAdd
	.unreq	length







/*Move_Right function
 *	attempts to move the current tetromino right				
 */
.global	Move_Right
Move_Right:

	tetAdd	.req r4
	xCoord	.req r5
	yCoord	.req r6
	index	.req r7
	length	.req r8


	push	{r4-r10, r14}

	//clear the tetromino to avoid failed update
	bl		Clear_Tetromino
	bl		Clear_Tet_Screen
	
	//get the base address for the coordinates and the virtual board
	ldr		tetAdd, =First

	//set up loop index
	mov		index, #0
	mov		length, #12

	rightTestLoop:
	
		//check loop guard
		cmp		index, #4
		bge		endRightTestLoop

		//get the base (x+1,y) coords 
		ldrb	xCoord, [tetAdd], #1
		add		xCoord, #1
		ldrb	yCoord, [tetAdd], #1
		
		//check if the cell is empty
		mov		r0, xCoord
		mov		r1, yCoord
		bl		Check_Empty
		
		//if the cell is not clear branch to end
		cmp		r0, #1
		bne		endRightLoop
		
		//incerement loop counter
		add		index, #1
		b		rightTestLoop

	endRightTestLoop:
	
	//if the move is valid, preform the move.
	mov		index, #0
	mov		length, #12
	
	//get the x-value address from First
	ldr		tetAdd, =First
	
	rightLoop:
	
		//check loop guard
		cmp		index, #4
		bge		endRightLoop
	
		//update the x-value (increment address by 2 for next x-value)
		ldrb	xCoord, [tetAdd]
		add		xCoord, #1
		strb	xCoord, [tetAdd], #2
	
		//incerement loop counter
		add		index, #1
		b		rightLoop
	
	endRightLoop:
	
	//set the tetromino back out to the virtual board
	bl		Set_Tetromino
	bl		Set_Tet_Screen
	
	//check if the tetromino intersects with a value pack
	//bl		Value_Pack_Check

	pop		{r4-r10, r14}
	bx		lr

	.unreq	tetAdd
	.unreq	xCoord
	.unreq	yCoord
	.unreq	index
	.unreq	length







/*Move_Left function
 *	attempts to move the current tetromino left				
 */
.global	Move_Left
Move_Left:

	tetAdd	.req r4
	xCoord	.req r5
	yCoord	.req r6
	index	.req r7
	length	.req r8


	push	{r4-r10, r14}

	//clear the tetromino to avoid failed update
	bl		Clear_Tetromino
	bl		Clear_Tet_Screen
	
	//get the base address for the coordinates and the virtual board
	ldr		tetAdd, =First

	//set up loop index
	mov		index, #0
	mov		length, #12

	leftTestLoop:
	
		//check loop guard
		cmp		index, #4
		bge		endLeftTestLoop

		//get the base (x-1,y) coords 
		ldrb	xCoord, [tetAdd], #1
		sub		xCoord, #1
		ldrb	yCoord, [tetAdd], #1
		
		//check if the cell is empty
		mov		r0, xCoord
		mov		r1, yCoord
		bl		Check_Empty
		
		//if the cell is not clear branch to end
		cmp		r0, #1
		bne		endLeftLoop
		
		//incerement loop counter
		add		index, #1
		b		leftTestLoop

	endLeftTestLoop:
	
	//if the move is valid, preform the move.
	mov		index, #0
	mov		length, #12
	
	//get the x-value address from First
	ldr		tetAdd, =First
	
	leftLoop:
	
		//check loop guard
		cmp		index, #4
		bge		endLeftLoop
	
		//update the x-value (increment address by 2 for next x-value)
		ldrb	xCoord, [tetAdd]
		sub		xCoord, #1
		strb	xCoord, [tetAdd], #2
	
		//incerement loop counter
		add		index, #1
		b		leftLoop
	
	endLeftLoop:
	
	//set the tetromino back out to the virtual board
	bl		Set_Tetromino
	bl		Set_Tet_Screen
	
	//check if the tetromino intersects with a value pack
	//bl		Value_Pack_Check
	

	pop		{r4-r10, r14}
	bx		lr

	.unreq	tetAdd
	.unreq	xCoord
	.unreq	yCoord
	.unreq	index
	.unreq	length










.section .data
