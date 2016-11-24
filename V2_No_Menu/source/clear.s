.section	.text



/*Clear_Rows function
 *	clears all full rows and moves the board pieces down
 */
.global Clear_Rows
Clear_Rows:

	encode	.req r4
	mask	.req r5
	curRow	.req r6
	top		.req r7

	push	{r4-r10, r14}

	//get which rows need to be cleared, and leave if there are none
	bl		Check_Rows
	cmp		r0, #0
	beq		endClearRows
	
	//take a copy of the encoding, and get the top value
	mov		encode, r0
	mov		top,	#18
	mov		mask,	#1
	
	//update the score
	bl		Score_Update
	
	clearRowsLoop:
	
		//check the loop guard
		cmp		encode, #0
		beq		endClearRowsLoop
	
		//check to see if the current row needs to be cleard
		and		curRow, encode, mask
		
		//if the current row doesnt need to be cleared, skip the clear, and shift the mask
		cmp		curRow, #0
		beq		skipClearAndMove
		
		//if the current row does need to be cleared, copy the mask into r0, and clear the row
		mov		r0, mask
		bl		Number_To_Bit
		bl		Clear_Move
		
		//clear the top line to remove the duplicate
		mov		r0, top
		bl		Clear_Row
		
		//shift the encoding one to the right to match up with all the rows just moved down
		bic		encode, mask
		lsr		encode, #1
		b		clearRowsLoop
	
		skipClearAndMove:	
		lsl		mask, #1
		b		clearRowsLoop

	endClearRowsLoop:
	
	//print the changes out to the screen
	bl		Redraw_Board
	
	endClearRows:

	.unreq	encode
	.unreq	mask
	.unreq	curRow
	.unreq	top


	pop		{r4-r10, r14}
	bx		lr





/*Check_Rows function
 *	checks to see which rows of the game board are full and need to be cleared
 *	returns:
 *		r0 - encoding of which rows need to be cleared, in reverse order (for convinients), 1 = full, 0 otherwise
 *				bit 0 	- row 19
 *				bit 1 	- row 18
 *				...
 *				bit	18	- row 0
 */
.global Check_Rows
Check_Rows:

	xCoord	.req r4
	yCoord	.req r5
	outInd	.req r6
	innInd	.req r7
	mask	.req r8
	result	.req r9

	push	{r4-r10, r14}
	
	//set starting point at bottom right of board (inside of walls)
	mov		xCoord, #11
	mov		yCoord, #20

	//set up rows loop index
	mov		outInd, #0
	mov		result, #0
	
	checkRowsOuterLoop:
	
		//check loop guard for rows
		cmp		outInd, #19
		bhs		endCheckRowsOuterLoop
		
		//set up columns loop index
		mov		innInd, #0
		mov		xCoord, #10
		
		//mask flag for each row, start by assuming the row is full
		mov		mask, #1
	
		checkRowsInnerLoop:
		
			//check loop guard for rows
			cmp		innInd, #10
			bhs		endCheckRowsInnerLoop
		
			//call check empty for the current cell
			mov		r0, xCoord
			mov		r1, yCoord
			bl		Check_Empty
			
			//if an empty cell is found, set the mask to zero, and exit from the current row
			cmp		r0, #1
			moveq	mask, #0		
			beq		endCheckRowsInnerLoop
		
			//increment index and decrement x
			add		innInd, #1
			sub		xCoord, #1
			b		checkRowsInnerLoop
		
		endCheckRowsInnerLoop:
		
		//shift the contents of the mask over to the corresponding bit, and orr it with the results
		lsl		mask, outInd
		orr		result, mask
	
		//increment index, decrement y
		add		outInd, #1
		sub		yCoord, #1
		b		checkRowsOuterLoop
	
	endCheckRowsOuterLoop:
	
	//set the result to r0
	mov		r0, result
	
	.unreq	xCoord
	.unreq	yCoord
	.unreq	outInd
	.unreq	innInd
	.unreq	mask
	.unreq	result

	pop		{r4-r10, r14}
	bx		lr






/*Move_Down_Row function
 *	moves a specific row down by 1, overwriting the row below it
 *		r0 - row to move down (number), in reverse order starting from row 19
 */
.global Move_Down_Row
Move_Down_Row:

	xCoord	.req r4
	row		.req r5
	offset	.req r6
	nxROff	.req r7
	length	.req r8
	index	.req r9
	type	.req r10
	
	push	{r4-r10, r14}

	//calculate the real y from the passed row number
	mov		row, #20
	sub		row, r0
	
	//calculate the base address from the virtual board
	ldr		offset, =Virtual_Board
	mov		length, #12
	mul		row, length
	mov		xCoord, #10
	add		offset, xCoord
	add		offset, row
	
	//set the next row offset from the current row offset
	mov		nxROff,	offset
	add		nxROff,	length
	
	//set up loop index
	mov		index, #0
	
	moveDownRowLoop:
	
		//check the loop guard
		cmp		index, #10
		bge		endMoveDownRowLoop

		//get the type from the current row and store it into the row below
		ldrb	type, [offset], #-1
		strb	type, [nxROff], #-1

		//increment index
		add		index, #1
		b		moveDownRowLoop
	
	endMoveDownRowLoop:

	.unreq	xCoord
	.unreq	row
	.unreq	offset
	.unreq	nxROff
	.unreq	length
	.unreq	index
	.unreq	type

	pop		{r4-r10, r14}
	bx		lr



/*Clear_Row function
 *	sets all blocks in a row to be empty
 *	r0- row to be cleared (number), starting from the bottom of the game board
 */
.global Clear_Row
Clear_Row:

	xCoord	.req r4
	row		.req r5
	offset	.req r6
	length	.req r7
	index	.req r8
	type	.req r9
	
	push	{r4-r10, r14}

	//calculate the real y from the passed row number
	mov		row, #20
	sub		row, r0
	
	//calculate the base address from the virtual board
	ldr		offset, =Virtual_Board
	mov		length, #12
	mul		row, length
	mov		xCoord, #10
	add		offset, xCoord
	add		offset, row
	
	//set up loop index
	mov		index, #0
	mov		type, #'E'
	
	clearRowLoop:
	
		//check the loop guard
		cmp		index, #10
		bge		endClearRowLoop

		//set the cell to by empty, and move to the next block
		strb	type, [offset], #-1

		//increment index
		add		index, #1
		b		clearRowLoop
	
	endClearRowLoop:

	.unreq	xCoord
	.unreq	row
	.unreq	offset
	.unreq	length
	.unreq	index
	.unreq	type

	pop		{r4-r10, r14}
	bx		lr
	
	
	
/* Clear_Move function
 *	clears a specified row, then moves each row above it down by 1
 *		r0- row to be cleared (number), starting from the bottom of the game board
 */
.global Clear_Move
Clear_Move:

	row		.req r5
	max		.req r6
	index	.req r7
	
	
	push	{r4-r10, r14}

	//copy the row number
	mov		row, r0

	//clear the row
	bl		Clear_Row
	
	//determine number of iterations needed, and set up the loop guard
	mov		max, row
	rsb	max, row, #19
	mov		index, #0
	add		row, #1

	clearMoveLoop:

		//check the loop guard
		cmp		index, max
		bge		endClearMoveLoop

		//move the current row down
		mov		r0, row
		bl		Move_Down_Row

		//increment index, and move up to next row
		add		index, #1
		add		row, #1
		b		clearMoveLoop
		
	endClearMoveLoop:


	pop		{r4-r10, r14}
	bx		lr
	
	
	
.section	.data
