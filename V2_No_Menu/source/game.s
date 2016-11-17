.section .text


/* Game_Display function
 *	Draws the main game to the screen
 */
.global Game_Display
Game_Display:

	push	{r4-r10, r14}
	
//***************************************************** REPLACE WITH FULL IMAGE ONCE DONE
	ldr		r0, =Board
	bl		Draw_Image
	
	pop		{r4-r10, r14}
	bx		lr
	
	
	
/* Game_Test function
 *	global function to test implementation of individual functions within the game package
 */
.global	Game_Test
Game_Test:

	push	{r4-r10, r14}
	
	bl		Redraw_Board
	//bl		Check_Rows
	
	//mov		r0, #0
	//bl		Clear_Row
	//bl		Redraw_Board
	
	//mov		r0, #0
	//bl		Clear_Move
	//bl		Redraw_Board
	
	//ldr		r0, =Score
	//ldrb	r1, [r0]
	
	//bl			Clear_Rows
	//bl			Redraw_Board
	
	
	testing:
	
	bl		Clear_Rows
	
	//test spawning
	bl		Spawn_Tetromino
	cmp		r0, #0
	bleq	Quit
	
		moveIt:
			ldr		r1, =Delay
			ldrb	r0, [r1]
			lsl		r0, #11
			bl		User_Turn
			
			bl		Move_Down
			
			cmp		r0, #0
			beq		testing
			
			b		moveIt
	
	pop		{r4-r10, r14}
	bx		lr


/*User_Turn function
 * allows user input for a set amount of time
 *	r0 - delay
 */
User_Turn:

	button	.req r0
	basTim	.req r1
	curTim	.req r2
	timReg	.req r4
	reqTim	.req r5
	maskLe	.req r6
	maskRi	.req r7
	maskUp	.req r8
	maskDo	.req r9
	maskSt	.req r10

	push	{r4-r10, r14}				

	//add offset to current time to for loop guard
	ldr		timReg, =0x3F003004			
	ldr		basTim, [timReg]			
	add		reqTim, basTim, r0		
	
	//setup bit masks
	mov		r0, #1
	mov		maskLe, #64
	mov		maskRi, #128

	//loop until the current time == required time
	delayLoop:	
	
		//read in the SNES input
		bl		Get_SNES
		
		//check if left was pressed, and attempt move
		and		r1, maskLe, button
		cmp		r1, #0
		blne	Move_Left
		
		//check if right was pressed, and attempt move
		and		r1, maskRi, button 
		cmp		r1, #0
		blne	Move_Right
		
		//loop until delay is reached
		ldr		curTim, [timReg]		
		cmp		curTim, reqTim			
		blo		delayLoop
				
	endDelayLoop:

	.unreq	button
	.unreq	timReg
	.unreq	basTim
	.unreq	reqTim
	.unreq	curTim
	.unreq	maskLe
	.unreq	maskRi
	.unreq	maskUp
	.unreq	maskDo
	.unreq	maskSt

	
	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine




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
	//bl		Score_Update
	
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
		lsr		r0, #1
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



/*Set_Tetromino function
 *	sets the current tetromino to its type blocks in the virtual board
 */
.global Set_Tetromino
Set_Tetromino:

	tetAdd	.req r1
	xCoord	.req r2
	yCoord	.req r3
	boaAdd	.req r4
	celAdd	.req r5
	index	.req r6
	type	.req r7
	length	.req r8

	push	{r4-r10, r14}

	//get the base address for the coordinates and the virtual board
	ldr		tetAdd, =First
	ldr		boaAdd, =Virtual_Board
	
	//retrieve the type of the current tetromino
	ldr		type, =Type
	ldrb	type, [type]

	//set up loop index
	mov		index, #0
	mov		length, #12

	setLoop:
	
		//check loop guard
		cmp		index, #4
		bge		endSetLoop

		//get the (x,y) coords 
		ldrb	xCoord, [tetAdd], #1
		ldrb	yCoord, [tetAdd], #1
		mul		yCoord, length
		
		//calculate the offset and set the cell
		add		celAdd, xCoord, yCoord
		add		celAdd, boaAdd
		strb	type, [celAdd]
		
		//incerement loop counter
		add		index, #1
		b		setLoop

	endSetLoop:

	.unreq	tetAdd
	.unreq	xCoord
	.unreq	yCoord
	.unreq	boaAdd
	.unreq	celAdd
	.unreq	index
	.unreq	type
	.unreq	length
	
	pop		{r4-r10, r14}
	bx		lr



/*Clear_Tetromino function
 *	sets the current tetromino to background blocks in the virtual board
 */
.global Clear_Tetromino
Clear_Tetromino:

	tetAdd	.req r1
	xCoord	.req r2
	yCoord	.req r3
	boaAdd	.req r4
	celAdd	.req r5
	index	.req r6
	clear	.req r7
	length	.req r8

	push	{r4-r10, r14}

	//get the base address for the coordinates and the virtual board
	ldr		tetAdd, =First
	ldr		boaAdd, =Virtual_Board

	//set up loop index
	mov		index, #0
	mov		clear, #'E'
	mov		length, #12

	clearLoop:
	
		//check loop guard
		cmp		index, #4
		bge		endClearLoop

		//get the (x,y) coords 
		ldrb	xCoord, [tetAdd], #1
		ldrb	yCoord, [tetAdd], #1
		mul		yCoord, length
		
		//calculate the offset and clear the cell
		add		celAdd, xCoord, yCoord
		add		celAdd, boaAdd
		strb	clear, [celAdd]
		
		//incerement loop counter
		add		index, #1
		b		clearLoop

	endClearLoop:

	.unreq	tetAdd
	.unreq	xCoord
	.unreq	yCoord
	.unreq	boaAdd
	.unreq	celAdd
	.unreq	index
	.unreq	clear
	.unreq	length
	
	pop		{r4-r10, r14}
	bx		lr


/*Set_Tet_Screen function
 * Draw out just Tetromino block to the display
 */
.global Set_Tet_Screen
Set_Tet_Screen:

	push	{r4-r10, r14}
	
	type	.req r4
	tetAdd	.req r5
	xCoord	.req r6
	yCoord	.req r7
	typAdd	.req r8
	index	.req r9
	
	//get the type of the current tetromino, and get address of block image
	ldr		typAdd, =Type
	ldrb	r0, [typAdd]
	bl		ASCII_To_Address
	mov		type, r0
	
	//set up index
	mov		index, #0
	ldr		tetAdd, =First
	
	setTetLoop:
	
		//check loop guard
		cmp		index, #4
		bge		endSetTetLoop
	
		//get x and y coordinates
		ldrb	xCoord, [tetAdd], #1
		ldrb	yCoord, [tetAdd], #1
		
		//call draw block
		mov		r0, type
		mov		r1, xCoord
		mov		r2, yCoord
		bl		Draw_Block
		
		//increment index
		add		index, #1
		b		setTetLoop
	
	endSetTetLoop:
	
	.unreq	type
	.unreq	tetAdd
	.unreq	xCoord
	.unreq	yCoord
	.unreq	typAdd
	.unreq	index
	
	pop		{r4-r10, r14}
	bx		lr
	
	
	
/*Clear_Tet_Screen function
 * Draw out just Tetromino block to the display
 */
.global Clear_Tet_Screen
Clear_Tet_Screen:

	push	{r4-r10, r14}
	
	type	.req r4
	tetAdd	.req r5
	xCoord	.req r6
	yCoord	.req r7
	index	.req r8
	
	//set the empty block character for the type
	mov		r0, #'E'
	bl		ASCII_To_Address
	mov		type, r0
	
	//set up index
	mov		index, #0
	ldr		tetAdd, =First
	
	clearTetLoop:
	
		//check loop guard
		cmp		index, #4
		bge		endClearTetLoop
	
		//get x and y coordinates
		ldrb	xCoord, [tetAdd], #1
		ldrb	yCoord, [tetAdd], #1
		
		//call draw block
		mov		r0, type
		mov		r1, xCoord
		mov		r2, yCoord
		bl		Draw_Block
		
		//increment index
		add		index, #1
		b		clearTetLoop
	
	endClearTetLoop:
	
	.unreq	type
	.unreq	tetAdd
	.unreq	xCoord
	.unreq	yCoord
	.unreq	index
	
	pop		{r4-r10, r14}
	bx		lr	






/* Redraw_Board function
 *	Redraws the contents of the board to the screen (to be used after a board), excluding the top spawn area
 */
 .global Redraw_Board
Redraw_Board:

	offset	.req r4
	block	.req r0
	xCoord	.req r6
	yCoord	.req r7
	outInd	.req r8
	innInd	.req r9

	push	{r4-r10, r14}

	//set up loop to display board
	ldr		offset, =Virtual_Board
	mov		xCoord, #0
	mov		yCoord, #0
	mov		outInd,	#0
	mov		innInd, #0
	
	redrawOuterLoop:
	
		//check loop guard
		cmp		yCoord, #22
		bge		endRedrawOuterLoop
	
		redrawInnerLoop:
		
			//check loop guard
			cmp		xCoord, #12
			bge		endRedrawInnerLoop
		
			//get the address from ascii for each block
			ldrb	block, [offset], #1
			
			//skip until the 2rd line
			cmp		yCoord, #1
			ble		incRedrawInnerLoop
			
			bl		ASCII_To_Address
			
			//draw the block at the corresponding spot on the screen
			mov		r1, xCoord
			mov		r2, yCoord
			bl		Draw_Block
		
			incRedrawInnerLoop:
			//increment the x coordinate
			add		xCoord, #1
			b		redrawInnerLoop
		
		endRedrawInnerLoop:
		
		//increment the y coordinate and reset x
		add		yCoord, #1
		mov		xCoord, #0
		b		redrawOuterLoop
	
	endRedrawOuterLoop:

	.unreq	offset
	.unreq	block
	.unreq	xCoord
	.unreq	yCoord
	.unreq	outInd
	.unreq	innInd

	pop		{r4-r10, r14}
	bx		lr






/* Check_Empty function
 *	checks to see that a specific cell is empty
 *	r0 - x coordinate
 *	r1 - y coordinate
 *	Returns:
 *		r0- 1 if empty, 0 otherwise	
 */
.global Check_Empty
Check_Empty:

	xCoord	.req r0
	yCoord	.req r1
	offset	.req r2
	block	.req r3
	length	.req r4
	

	push	{r4-r10, r14}

	//calculate the offset of the specific cell
	ldr		offset, =Virtual_Board
	mov		length, #12
	mul		yCoord, length
	add		offset, xCoord
	add		offset, yCoord
	
	//get the ascii value from the virtual board and check its value
	ldrb	block, [offset]
	cmp		block, #'E'
	moveq	r0, #1
	movne	r0, #0

	.unreq	xCoord	
	.unreq	yCoord	
	.unreq	offset	
	.unreq	block	
	.unreq	length

	pop		{r4-r10, r14}
	bx		lr



.section .data


//Variable to determine if a new tetromino is needed (set when a tetromino settles)
.global Spawn_Flag
Spawn_Flag:
.byte	1

//variable for how long the user can take their turn
.global Delay
Delay:
.byte	50

//Variables to keep track of the location of the current tetromino block (default to negative spawn space)
.global First, Second, Third, Fourth, Type, Orientation
First:	.byte	4, 1
Second:	.byte	5, 1
Third:	.byte	6, 1
Fourth:	.byte	7, 1
Type:	.byte	'C'
/*Byte to keep track of the tetromino rotation. possible contents include:
 *'u'	117		up
 *'r'	114		right
 *'d'	100		down
 *'l'	108		left
 */
Orientation:	.byte	'u'

/*Virtual game board to preform game actions on. possible contents include:
 *'E'	69		Empty
 *'W'	87		Wall
 *'C'	67		Cyan
 *'B'	66		Blue
 *'O'	79		Orange
 *'Y'	89		Yellow
 *'G'	71		Green
 *'P'	80		Purple
 *'R'	82		Red
 */
Virtual_Board:
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'	//spawn area
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'	//spawn area (upper wall is here)
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'W'
.byte	'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'
