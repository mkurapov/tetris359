.section	.text



/*Value_Pack_Spawn function
 *	spawns in a new value pack after deleting the current value pack
 */
.global	Value_Pack_Spawn
Value_Pack_Spawn:

	vpAddr	.req r4
	xCoord	.req r5
	yCoord	.req r6

	push	{r4-r10, r14}
	
	bl		Value_Pack_Clear
	
	//get a random x y value until an empty cell is found
	randomSpawnLoop:
	
		//copy a y coord into r1 and an x coord into r0
		bl	 	Get_Random_Y
		add		r0, #2		//add 2 to ignore the spawn area
		mov	 	yCoord, r0
		bl		Get_Random_X
		add		r0, #1		//add 1 to ignore the left wall
		mov		xCoord, r0
		mov		r1, yCoord

		//call check empty, and return if a full block was found
		bl 		Check_Empty
		cmp		r0, #1
		bne		randomSpawnLoop

	//once a free block is found, spawn in the vp
	ldr		vpAddr, =Value_Pack
	strb 	xCoord, [vpAddr], #1
	strb 	yCoord, [vpAddr]
	
	//get a value pack type from the random number generator
	//bl		Get_Random_Tetromino
	
	//set up the possible types of the vp
	ldr		vpAddr, =Value_Pack_Type
	mov		r2, #'F'
	//mov		r3, #'I'

	//take the first bit of the random number, and set the type based on the result
	//and		r0, #1
	//cmp		r0, #0
	strb	r2, [vpAddr]
	//strneb	r3, [vpAddr]
	
	bl Value_Pack_Draw
	
	.unreq	vpAddr
	.unreq	xCoord
	.unreq	yCoord
	
	pop		{r4-r10, r14}
	bx		lr







/*Value_Pack_Clear function
 *	resets the value pack to its default location and redraws an empty block (for when a new vp is spawned)
 */
.global Value_Pack_Clear
Value_Pack_Clear:

	vpAddr	.req r4
	coord	.req r5
	
	push	{r0-r10, r14}
	
	//draw an empty block over the value pack
	ldr		vpAddr, =Value_Pack
	mov		r0, #'E'
	bl		ASCII_To_Address
	ldrb	r1, [vpAddr], #1
	ldrb	r2, [vpAddr]
	bl		Draw_Block
	
	//set the value pack coords to its default value
	ldr		vpAddr, =Value_Pack
	mov		coord, #1
	strb	coord, [vpAddr], #1
	mov		coord, #0
	strb	coord, [vpAddr], #1
	mov		coord, #'F'
	strb	coord, [vpAddr]
	
	.unreq	vpAddr
	.unreq	coord
	
	pop		{r0-r10, r14}
	bx		lr
	
	
	
/*Value_Pack_Reset function
 *	resets the value pack to its default location (for when a vp is picked up)
 */
.global Value_Pack_Reset
Value_Pack_Reset:

	vpAddr	.req r4
	coord	.req r5
	
	push	{r4-r10, r14}
	
	//set the value pack coords to its default value
	ldr		vpAddr, =Value_Pack
	mov		coord, #1
	strb	coord, [vpAddr], #1
	mov		coord, #0
	strb	coord, [vpAddr], #1
	mov		coord, #'F'
	strb	coord, [vpAddr]
	
	.unreq	vpAddr
	.unreq	coord
	
	pop		{r4-r10, r14}
	bx		lr
	
	
	
	
/*Value_Pack_Draw function
 *	draws the current value pack out to the screen
 */
.global Value_Pack_Draw
Value_Pack_Draw:

	vpAddr	.req r4

	push	{r4-r10, r14}

	//get the address of the block type into r0
	ldr		vpAddr, =Value_Pack_Type
	ldrb	r0, [vpAddr]
	bl		ASCII_To_Address
	
	//get the x y coords into r1 and r2
	ldr		vpAddr, =Value_Pack
	ldrb	r1, [vpAddr], #1
	ldrb	r2, [vpAddr]
	
	//draw the block out to the screen
	bl		Draw_Block
	
	.unreq	vpAddr

	pop		{r4-r10, r14}
	bx		lr
	
	
	
/*Value_Pack_Check function
 *	checks to see if the current tetromino has a block that matches location with the vp and applies the effect
 */
.global Value_Pack_Check
Value_Pack_Check:

	vpAddr	.req r4
	xCoord	.req r5
	yCoord	.req r6
	index	.req r7
	result	.req r8

	push	{r4-r10, r14}

	//get the coords of the vp
	ldr 	vpAddr, =Value_Pack
	ldrb 	xCoord, [vpAddr], #1
	ldrb 	yCoord, [vpAddr]

	//loop over the coords of the current block and check for a match
	mov 	r7, #0
	ldr 	r0, =First
	mov 	r8, #0

	checkValuePackLoop:

		//check loop guard
		cmp 	index, #4
		bge 	endCheckValuePackLoop

		//get the address of the corresponding block
		ldrb 	r1, [r0], #1
		ldrb 	r2, [r0], #1

		//check the X coord
		cmp 	r1, xCoord
		bne 	nextValuePackCheck

		//check the Y coord
		cmp 	r2, yCoord
		bne 	nextValuePackCheck

		//if both the coords matched, set the result to 1
		mov 	result, #1
		b  		endCheckValuePackLoop

		nextValuePackCheck:
		//increment index
		add  	index, #1
		b 		checkValuePackLoop


	endCheckValuePackLoop:

	//if the value pack was obtained, apply the effect
	cmp 	result, #1
	bne 	endCheckValuePack
	
	bl		Value_Pack_Effect

	endCheckValuePack:

	
	.unreq	vpAddr
	.unreq	xCoord
	.unreq	yCoord
	.unreq	index
	.unreq	result

	pop		{r4-r10, r14}
	bx		lr




/*Value_Pack_Effect function
 *applies the effect of the current value pack, then resets the value pack to default
 */
.global Value_Pack_Effect
Value_Pack_Effect:

	push	{r4-r10, r14}
	
	//increment the score
	bl		Score_Increment

	//get the type of the current value pack
	ldr		r0, =Value_Pack_Type
	ldrb	r1, [r0]

	//check to see if the type is 'F'
	cmp		r1, #'F'
	beq		applyFast
	
	//otherwise, apply invisible
	ldr		r0, = Board
	bl		Draw_Image
	bl		Set_Tet_Screen
	
	//branch over the fast effect
	b		endValuePackEffect
	
	
	//set the user turn delay to .1 second
	applyFast:
		ldr 	r0, =Delay
		ldr 	r1, =100000 //.1 seconds
		str 	r1, [r0]
	
	endValuePackEffect:
	
	//set the value pack time to be 3
	ldr		r0, =Value_Pack_Time
	mov		r1, #3
	strb	r1, [r0]
	
	bl		Value_Pack_Reset

	pop		{r4-r10, r14}
	bx		lr




/*Value_Pack_Decrement function
 *	decrements the time the vp is in effect by 1 and removes the effects if time = 0
 */
.global Value_Pack_Decrement
Value_Pack_Decrement:

	push	{r4-r10, r14}

	//decrement the time
	ldr		r0, =Value_Pack_Time
	ldrb	r1, [r0]
	
	//if the effect is not on, skip over
	cmp		r1, #0
	beq 	continueEffect
	
	sub		r1, #1
	strb	r1, [r0]
	
	//check if the effect should still be applied
	cmp		r1, #0
	bhi		continueEffect
	
	
	//if not, get the type of the current value pack
	ldr		r0, =Value_Pack_Type
	ldrb	r1, [r0]

	//check to see if the type is 'F'
	cmp		r1, #'F'
	beq		unapplyFast
	
	//otherwise, apply unapply invisible
	bl		Redraw_Board
	
	//branch over the fast effect
	b		continueEffect
	
	//set the user turn delay to .25 second
	unapplyFast:
		ldr 	r0, =Delay
		ldr 	r1, =350000	//.25 seconds
		str 	r1, [r0]
	
	
	continueEffect:

	pop		{r4-r10, r14}
	bx		lr




.section	.data

.global Value_Pack
Value_Pack:
.byte	1,0			//default x,y coords for vp (unreachable)

.global Value_Pack_Type
Value_Pack_Type:
.byte	'F'			//default value pack type (Fast = F, Invisible = I)

.global Value_Pack_Time
Value_Pack_Time:
.byte	0			//default number of blocks to apply the affect for
