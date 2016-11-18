.section .text


/* Spawn_Tetromino function
 *	attempts to spawn a new block into the virtual board
 *	r0- number from 0 to 6 to signify which block to spawn:
 *		0-	I
 *		1-	J
 *		2-	L
 *		3-	O
 *		4-	S
 *		5-	T
 *		6-	Z
 *	returns:
 *		r0 - success=1, fail=0
 */
.global Spawn_Tetromino
Spawn_Tetromino:

	xCoord	.req r0
	yCoord	.req r1
	coord	.req r4
	value	.req r5
	index	.req r6
	result	.req r7
	varAdd	.req r9


	push	{r4-r10, r14}
	
	//call random number generator to get a random tetromino
	bl		Get_Random_Tetromino
	mov		r4, r0

	//switch statement to branch to each case to initialize tetromino in spawn area
	cmp		r4, #0
	blle	Spawn_I
	cmp		r4, #0
	ble		startSpawn

	cmp		r4, #1
	bleq	Spawn_J
	cmp		r4, #1
	beq		startSpawn

	cmp		r4, #2
	bleq	Spawn_L
	cmp		r4, #2
	beq		startSpawn

	cmp		r4, #3
	bleq	Spawn_O
	cmp		r4, #3
	beq		startSpawn

	cmp		r4, #4
	bleq	Spawn_S
	cmp		r4, #4
	beq		startSpawn

	cmp		r4, #5
	bleq	Spawn_T
	cmp		r4, #5
	beq		startSpawn

	cmp		r4, #6
	bleq	Spawn_Z
	cmp		r4, #6
	beq		startSpawn
	
										//bl		Spawn_Imp

	startSpawn:
	
	//set up loop index
	mov		index, #0
	mov		result, #1	
	
	spawnLoop:
	
		//check loop guard
		cmp		index, #2
		bge		endSpawnLoop
		
		//attempt to move the block down, and exit if it cannot be moved
		bl		Move_Down
		cmp		r0, #0
		beq		endSpawnLoop
	
		add		index, #1
		b		spawnLoop
	
	endSpawnLoop:

	//check if the index is still 0, in which case the game has ended, return 0 for fail
	cmp		index, #0
	moveq	result, #0
	beq		endSpawn
	
	//update spawn flag
	ldr		varAdd, =Spawn_Flag
	mov		value, #0
	strb	value, [varAdd]
	
	//reset orientation
	ldr		varAdd, =Orientation
	mov		value, #'u'
	strb	value, [varAdd]


	endSpawn:
	
	//set the result to return
	mov		r0, result
	
	.unreq	xCoord
	.unreq	yCoord
	.unreq	coord
	.unreq	index
	.unreq	result
	.unreq	value
	.unreq	varAdd
	
	pop		{r4-r10, r14}
	bx		lr

/* Spawn_Imp function
 *  spawns an impossible shape for testing
 */
Spawn_Imp:

	coord	.req r4
	value	.req r5
	typAdd	.req r6
	type	.req r7

	push	{r4-r10, r14}

	ldr		coord, =First
		
	//set up first
	mov		value, #4
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
	
	//set up second
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
		
	//set up third
	mov		value, #6
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
		
	//set up fourth
	mov		value, #7
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
	
	//set the type of the tetromino
	ldr		typAdd, =Type
	mov		type, #'C'
	strb	type, [typAdd]

	.unreq	coord
	.unreq	value
	.unreq	typAdd
	.unreq	type

	pop		{r4-r10, r14}
	bx		lr








/* Spawn_I function
 *  sets default imaginary spawn location for I tetrominos
 */
Spawn_I:

	coord	.req r4
	value	.req r5
	typAdd	.req r6
	type	.req r7

	push	{r4-r10, r14}

	ldr		coord, =First
		
	//set up first
	mov		value, #4
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
	
	//set up second
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
		
	//set up third
	mov		value, #6
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
		
	//set up fourth
	mov		value, #7
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
	
	//set the type of the tetromino
	ldr		typAdd, =Type
	mov		type, #'C'
	strb	type, [typAdd]

	.unreq	coord
	.unreq	value
	.unreq	typAdd
	.unreq	type

	pop		{r4-r10, r14}
	bx		lr
	

/* Spawn_J function
 *  sets default imaginary spawn location for J tetrominos
 */
Spawn_J:

	coord	.req r4
	value	.req r5
	typAdd	.req r6
	type	.req r7

	push	{r4-r10, r14}

	ldr		coord, =First
		
	//set up first
	mov		value, #4
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
	
	//set up second
	mov		value, #4
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
		
	//set up third
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
		
	//set up fourth
	mov		value, #6
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
	
	//set the type of the tetromino
	ldr		typAdd, =Type
	mov		type, #'B'
	strb	type, [typAdd]

	.unreq	coord
	.unreq	value
	.unreq	typAdd
	.unreq	type

	pop		{r4-r10, r14}
	bx		lr
	
	
	
	
/* Spawn_L function
 *  sets default imaginary spawn location for L tetrominos
 */
Spawn_L:

	coord	.req r4
	value	.req r5
	typAdd	.req r6
	type	.req r7

	push	{r4-r10, r14}

	ldr		coord, =First
		
	//set up first
	mov		value, #4
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
	
	//set up second
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
		
	//set up third
	mov		value, #6
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
		
	//set up fourth
	mov		value, #6
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
	
	//set the type of the tetromino
	ldr		typAdd, =Type
	mov		type, #'O'
	strb	type, [typAdd]

	.unreq	coord
	.unreq	value
	.unreq	typAdd
	.unreq	type

	pop		{r4-r10, r14}
	bx		lr
	
	
	
/* Spawn_O function
 *  sets default imaginary spawn location for 0 tetrominos
 */
Spawn_O:

	coord	.req r4
	value	.req r5
	typAdd	.req r6
	type	.req r7

	push	{r4-r10, r14}

	ldr		coord, =First
		
	//set up first
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
	
	//set up second
	mov		value, #6
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
		
	//set up third
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
		
	//set up fourth
	mov		value, #6
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
	
	//set the type of the tetromino
	ldr		typAdd, =Type
	mov		type, #'Y'
	strb	type, [typAdd]

	.unreq	coord
	.unreq	value
	.unreq	typAdd
	.unreq	type

	pop		{r4-r10, r14}
	bx		lr


/* Spawn_S function
 *  sets default imaginary spawn location for S tetrominos
 */
Spawn_S:

	coord	.req r4
	value	.req r5
	typAdd	.req r6
	type	.req r7

	push	{r4-r10, r14}

	ldr		coord, =First
		
	//set up first
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
	
	//set up second
	mov		value, #6
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
		
	//set up third
	mov		value, #4
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
		
	//set up fourth
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
	
	//set the type of the tetromino
	ldr		typAdd, =Type
	mov		type, #'G'
	strb	type, [typAdd]

	.unreq	coord
	.unreq	value
	.unreq	typAdd
	.unreq	type

	pop		{r4-r10, r14}
	bx		lr
	
	
/* Spawn_T function
 *  sets default imaginary spawn location for T tetrominos
 */
Spawn_T:

	coord	.req r4
	value	.req r5
	typAdd	.req r6
	type	.req r7

	push	{r4-r10, r14}

	ldr		coord, =First
		
	//set up first
	mov		value, #4
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
	
	//set up second
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
		
	//set up third
	mov		value, #6
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
		
	//set up fourth
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
	
	//set the type of the tetromino
	ldr		typAdd, =Type
	mov		type, #'P'
	strb	type, [typAdd]

	.unreq	coord
	.unreq	value
	.unreq	typAdd
	.unreq	type

	pop		{r4-r10, r14}
	bx		lr
	
	
/* Spawn_Z function
 *  sets default imaginary spawn location for Z tetrominos
 */
Spawn_Z:

	coord	.req r4
	value	.req r5
	typAdd	.req r6
	type	.req r7

	push	{r4-r10, r14}

	ldr		coord, =First
		
	//set up first
	mov		value, #4
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
	
	//set up second
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #0
	strb	value, [coord], #1
		
	//set up third
	mov		value, #5
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
		
	//set up fourth
	mov		value, #6
	strb	value, [coord], #1
	mov		value, #1
	strb	value, [coord], #1
	
	//set the type of the tetromino
	ldr		typAdd, =Type
	mov		type, #'R'
	strb	type, [typAdd]

	.unreq	coord
	.unreq	value
	.unreq	typAdd
	.unreq	type

	pop		{r4-r10, r14}
	bx		lr
	
	
	
	
.section .data
