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
			
			mov		r4, r0
			cmp		r4, #0
			bleq	Clear_Rows
			cmp		r4, #0
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
.byte	100

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
.global	Virtual_Board
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
