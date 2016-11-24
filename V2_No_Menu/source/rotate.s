.section .text

/* Rotate_Tet fuction
 * Rotates the current tetromino
 * Parameters:
 *	r0- 0 if rotating clockwise, 1 if rotating counter-clockwise
 * Returns:
 *	None
 */
.global		Rotate_Tet
Rotate_Tet:

	newRotation  .req r4
	orientation  .req r5
	type		 			.req r6

	push	{r4-r10, r14}				//push registers onto the stack

	//load type of block
	ldr		r1, =Type
	ldrb	type, [r1]

	//dont rotate if tetromino is O type
	cmp		type, #'Y'
	beq		endRotation

	cmp		type, #'C'
	bleq	Rotate_I

	cmp		type, #'G'
	bleq	Rotate_S

	cmp		type, #'R'
	bleq	Rotate_Z

	cmp		type, #'P'
	bleq	Rotate_T

	cmp		type, #'B'
	bleq	Rotate_J

	cmp		type, #'O'
	bleq	Rotate_L













	endRotation:

	//set the tetromino back out to the virtual board
	bl		Set_Tetromino
	bl		Set_Tet_Screen


	.unreq	newRotation
	.unreq	orientation
	.unreq	type

	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine


/* Rotate_L function
 *  rotate L-type tetrominos
 * Parameters:
 *	r0 - 0 if rotating clockwise, 1 if counter-clockwise
 * Returns:
 * 	None
 */
Rotate_L:

	coords				.req r4
	xCoord				.req r5
	yCoord				.req r6
	orientation		.req r7
	newRotation		.req r8

	push	{r4-r10, r14}

	mov		newRotation, r0


	ldr		r1, =Orientation
	ldrb	orientation, [r1]

	ldr		coords, =First

	//clear the tetromino to avoid failed update
	bl		Clear_Tetromino
	bl		Clear_Tet_Screen


	cmp	  newRotation, #0
	bne		cClockWiseL

	//all the cases below take in a 0 (clockwise), or 1 (counterclockwise) as a parameter
	//clockwise cases
	cmp	orientation, #'u'
	moveq	r0, newRotation
	bleq	rotateLUpRight
	cmp	orientation, #'u'
	beq	endRotateL

	cmp	orientation, #'r'
	moveq	r0, newRotation
	bleq	rotateLRightDown
	cmp	orientation, #'r'
	beq	endRotateL

	cmp	orientation, #'d'
	moveq	r0, newRotation
	bleq	rotateLDownLeft
	cmp	orientation, #'d'
	beq	endRotateL

	cmp	orientation, #'l'
	moveq	r0, newRotation
	bleq	rotateLLeftUp

	b endRotateL

	//counter-clockwise cases
	cClockWiseL:

	cmp	orientation, #'u'
	moveq	r0, newRotation
	bleq	rotateLLeftUp
	cmp	orientation, #'u'
	beq		endRotateL

	cmp	orientation, #'r'
	moveq	r0, newRotation
	bleq	rotateLUpRight
	cmp	orientation, #'r'
	beq	endRotateL

	cmp	orientation, #'d'
	moveq	r0, newRotation
	bleq	rotateLRightDown
	cmp	orientation, #'d'
	beq	endRotateL

	cmp	orientation, #'l'
	moveq	r0, newRotation
	bleq	rotateLDownLeft


	endRotateL:

	.unreq	coords
	.unreq	xCoord
	.unreq	yCoord
	.unreq	orientation
	.unreq	newRotation

	pop		{r4-r10, r14}
	bx		lr




/* Rotate_J function
 *  rotate J-type tetrominos
 * Parameters:
 *	r0 - 0 if rotating clockwise, 1 if counter-clockwise
 * Returns:
 * 	None
 */
Rotate_J:

	coords				.req r4
	xCoord				.req r5
	yCoord				.req r6
	orientation		.req r7
	newRotation		.req r8

	push	{r4-r10, r14}

	mov		newRotation, r0


	ldr		r1, =Orientation
	ldrb	orientation, [r1]

	ldr		coords, =First

	//clear the tetromino to avoid failed update
	bl		Clear_Tetromino
	bl		Clear_Tet_Screen


	cmp	  newRotation, #0
	bne		cClockWiseJ

	//all the cases below take in a 0 (clockwise), or 1 (counterclockwise) as a parameter
	//clockwise cases
	cmp	orientation, #'u'
	moveq	r0, newRotation
	bleq	rotateJUpRight
	cmp	orientation, #'u'
	beq	endRotateJ

	cmp	orientation, #'r'
	moveq	r0, newRotation
	bleq	rotateJRightDown
	cmp	orientation, #'r'
	beq	endRotateJ

	cmp	orientation, #'d'
	moveq	r0, newRotation
	bleq	rotateJDownLeft
	cmp	orientation, #'d'
	beq	endRotateJ

	cmp	orientation, #'l'
	moveq	r0, newRotation
	bleq	rotateJLeftUp

	b endRotateJ

	//counter-clockwise cases
	cClockWiseJ:

	cmp	orientation, #'u'
	moveq	r0, newRotation
	bleq	rotateJLeftUp
	cmp	orientation, #'u'
	beq		endRotateJ

	cmp	orientation, #'r'
	moveq	r0, newRotation
	bleq	rotateJUpRight
	cmp	orientation, #'r'
	beq	endRotateJ

	cmp	orientation, #'d'
	moveq	r0, newRotation
	bleq	rotateJRightDown
	cmp	orientation, #'d'
	beq	endRotateJ

	cmp	orientation, #'l'
	moveq	r0, newRotation
	bleq	rotateJDownLeft


	endRotateJ:

	.unreq	coords
	.unreq	xCoord
	.unreq	yCoord
	.unreq	orientation
	.unreq	newRotation

	pop		{r4-r10, r14}
	bx		lr


/* Rotate_T function
 *  rotate T-type tetrominos
 * Parameters:
 *	r0 - 0 if rotating clockwise, 1 if counter-clockwise
 * Returns:
 * 	None
 */
Rotate_T:

	coords				.req r4
	xCoord				.req r5
	yCoord				.req r6
	orientation		.req r7
	newRotation		.req r8

	push	{r4-r10, r14}

	mov		newRotation, r0


	ldr		r1, =Orientation
	ldrb	orientation, [r1]

	ldr		coords, =First

	//clear the tetromino to avoid failed update
	bl		Clear_Tetromino
	bl		Clear_Tet_Screen


	cmp	  newRotation, #0
	bne		cClockWiseT

	//all the cases below take in a 0 (clockwise), or 1 (counterclockwise) as a parameter
	//clockwise cases
	cmp	orientation, #'u'
	moveq	r0, newRotation
	bleq	rotateTUpRight
	cmp	orientation, #'u'
	beq	endRotateT

	cmp	orientation, #'r'
	moveq	r0, newRotation
	bleq	rotateTRightDown
	cmp	orientation, #'r'
	beq	endRotateT

	cmp	orientation, #'d'
	moveq	r0, newRotation
	bleq	rotateTDownLeft
	cmp	orientation, #'d'
	beq	endRotateT

	cmp	orientation, #'l'
	moveq	r0, newRotation
	bleq	rotateTLeftUp

	b endRotateT

	//counter-clockwise cases
	cClockWiseT:

	cmp	orientation, #'u'
	moveq	r0, newRotation
	bleq	rotateTLeftUp
	cmp	orientation, #'u'
	beq		endRotateT

	cmp	orientation, #'r'
	moveq	r0, newRotation
	bleq	rotateTUpRight
	cmp	orientation, #'r'
	beq	endRotateT

	cmp	orientation, #'d'
	moveq	r0, newRotation
	bleq	rotateTRightDown
	cmp	orientation, #'d'
	beq	endRotateT

	cmp	orientation, #'l'
	moveq	r0, newRotation
	bleq	rotateTDownLeft


	endRotateT:

	.unreq	coords
	.unreq	xCoord
	.unreq	yCoord
	.unreq	orientation
	.unreq	newRotation

	pop		{r4-r10, r14}
	bx		lr


/* Rotate_I function
 *  rotate I-type tetrominos
 * Parameters:
 *	r0 - 0 if rotating clockwise, 1 if counter-clockwise
 * Returns:
 * 	None
 */
Rotate_I:

	coords			.req r4
	xCoord			.req r5
	yCoord			.req r6
	orientation		.req r7

	push	{r4-r10, r14}

	ldr		r1, =Orientation
	ldrb	orientation, [r1]

	ldr		coords, =First

	//clear the tetromino to avoid failed update
	bl		Clear_Tetromino
	bl		Clear_Tet_Screen

	cmp		orientation, #'u'


	// checking if valid move


	//First block
	//xCoord, +/- 1
	ldrb	xCoord, [coords], #1
	addeq	xCoord, #1
	subne	xCoord, #1

	//yCoord, -/+ 1
	ldrb	yCoord, [coords], #1 //move on to pivot
	addne	yCoord, #1
	subeq	yCoord, #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateI

	cmp		orientation, #'u'



	//Second block
	//xCoord
	ldrb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateI

	cmp		orientation, #'u'



	//Third block
	//xCoord, -/+ 1
	ldrb	xCoord, [coords], #1
	addne	xCoord, #1
	subeq	xCoord, #1

	//yCoord, +/- 1
	ldrb	yCoord, [coords], #1
	addeq	yCoord, #1
	subne	yCoord, #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateI

	cmp		orientation, #'u'


	//Fourth block
	//xCoord, -/+ 1
	ldrb	xCoord, [coords], #1
	addne	xCoord, #2
	subeq	xCoord, #2

	//yCoord, +/- 1
	ldrb	yCoord, [coords], #1
	addeq	yCoord, #2
	subne	yCoord, #2

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateI

	cmp		orientation, #'u'


	// actually setting the block

	ldr		coords, =First

	//First block
	//xCoord, +/- 1
	ldrb	xCoord, [coords]
	addeq	xCoord, #1
	subne	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord, -/+ 1
	ldrb	yCoord, [coords]
	addne	yCoord, #1
	subeq	yCoord, #1
	strb	yCoord, [coords], #3  //skip second (pivot), move to third


	//Third block
	//xCoord, -/+ 1
	ldrb	xCoord, [coords]
	addne	xCoord, #1
	subeq	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord, +/- 1
	ldrb	yCoord, [coords]
	addeq	yCoord, #1
	subne	yCoord, #1
	strb	yCoord, [coords], #1


	//Fourth block
	//xCoord, -/+ 1
	ldrb	xCoord, [coords]
	addne	xCoord, #2
	subeq	xCoord, #2
	strb	xCoord, [coords], #1

	//yCoord, +/- 1
	ldrb	yCoord, [coords]
	addeq	yCoord, #2
	subne	yCoord, #2
	strb	yCoord, [coords], #1


	//if orientation u, set it to r, and vice versa
	ldr		r1, =Orientation
	moveq	orientation, #'r'
	movne	orientation, #'u'
	strb	orientation, [r1]

	endRotateI:

	.unreq	coords
	.unreq	xCoord
	.unreq	yCoord
	.unreq	orientation

	pop		{r4-r10, r14}
	bx		lr


/* Rotate_S function
 *  rotate S-type tetrominos
 * Parameters:
 *	r0 - 0 if rotating clockwise, 1 if counter-clockwise
 * Returns:
 * 	None
 */
Rotate_S:

	coords			.req r4
	xCoord			.req r5
	yCoord			.req r6
	orientation		.req r7

	push	{r4-r10, r14}

	ldr		r1, =Orientation
	ldrb	orientation, [r1]

	ldr		coords, =First

	//clear the tetromino to avoid failed update
	bl		Clear_Tetromino
	bl		Clear_Tet_Screen

	cmp		orientation, #'u'


	// *** checking if valid move ***
	//First block
	//xCoord
	ldrb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateS

	cmp		orientation, #'u'





	//Second block
	//xCoord
	ldrb	xCoord, [coords], #1
	addne	xCoord, #1
	subeq	xCoord, #1

	//yCoord
	ldrb	yCoord, [coords], #1
	addeq	yCoord, #1
	subne	yCoord, #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateS

	cmp		orientation, #'u'




	//Third block
	//xCoord
	ldrb	xCoord, [coords], #1
	addeq	xCoord, #2
	subne	xCoord, #2

	//yCoord
	ldrb	yCoord, [coords], #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateS

	cmp		orientation, #'u'


	//Fourth block
	//xCoord
	ldrb	xCoord, [coords], #1
	addeq	xCoord, #1
	subne	xCoord, #1

	//yCoord
	ldrb	yCoord, [coords], #1
	addeq	yCoord, #1
	subne	yCoord, #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateS


	cmp		orientation, #'u'





	// *** actually setting the block ***
	ldr		coords, =First

	//First block
	//xCoord, yCoord
	ldrb	xCoord, [coords], #1
	ldrb	yCoord, [coords], #1



	//Second block
	//xCoord
	ldrb	xCoord, [coords]
	addne	xCoord, #1
	subeq	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord, +/- 1
	ldrb	yCoord, [coords]
	addeq	yCoord, #1
	subne	yCoord, #1
	strb	yCoord, [coords], #1




	//Third block
	//xCoord, -/+ 1
	ldrb	xCoord, [coords]
	addeq	xCoord, #2
	subne	xCoord, #2
	strb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1




	//Fourth block
	//xCoord, -/+ 1
	ldrb	xCoord, [coords]
	addeq	xCoord, #1
	subne	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord, +/- 1
	ldrb	yCoord, [coords]
	addeq	yCoord, #1
	subne	yCoord, #1
	strb	yCoord, [coords], #1 //no need to shift?



	//if orientation u, set it to r, and vice versa
	ldr		r1, =Orientation
	moveq	orientation, #'r'
	movne	orientation, #'u'
	strb	orientation, [r1]


	endRotateS:

	.unreq	coords
	.unreq	xCoord
	.unreq	yCoord
	.unreq	orientation

	pop		{r4-r10, r14}
	bx		lr

/* Rotate_Z function
 *  rotate Z-type tetrominos
 * Parameters:
 *	r0 - 0 if rotating clockwise, 1 if counter-clockwise
 * Returns:
 * 	None
 */
Rotate_Z:

	coords			.req r4
	xCoord			.req r5
	yCoord			.req r6
	orientation		.req r7

	push	{r4-r10, r14}

	ldr		r1, =Orientation
	ldrb	orientation, [r1]

	ldr		coords, =First

	//clear the tetromino to avoid failed update
	bl		Clear_Tetromino
	bl		Clear_Tet_Screen

	cmp		orientation, #'u'


	// *** checking if valid move ***




	//First block
	//xCoord, +/- 1
	ldrb	xCoord, [coords], #1
	addeq xCoord, #1
	subne	xCoord, #1

	//yCoord, -/+ 1
	ldrb	yCoord, [coords], #1
	addne yCoord, #1
	subeq	yCoord, #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateZ

	cmp		orientation, #'u'





	//Second block
	//xCoord
	ldrb	xCoord, [coords], #1
	addne	xCoord, #1
	subeq	xCoord, #1

	//yCoord
	ldrb	yCoord, [coords], #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateZ

	cmp		orientation, #'u'




	//Third block
	//xCoord
	ldrb	xCoord, [coords], #1


	//yCoord
	ldrb	yCoord, [coords], #1
	addne	yCoord, #1
	subeq	yCoord, #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateZ

	cmp		orientation, #'u'


	//Fourth block
	//xCoord, -/+ 1
	ldrb	xCoord, [coords], #1
	addne	xCoord, #2
	subeq	xCoord, #2

	//yCoord, +/- 1
	ldrb	yCoord, [coords], #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateZ


	cmp		orientation, #'u'





	// *** actually setting the block ***
	ldr		coords, =First

	//First block
	//xCoord, +/- 1
	ldrb	xCoord, [coords]
	addeq xCoord, #1
	subne	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord, -/+ 1
	ldrb	yCoord, [coords]
	addne yCoord, #1
	subeq	yCoord, #1
	strb  yCoord, [coords], #1




	//Second block
	//xCoord
	ldrb	xCoord, [coords]
	addne	xCoord, #1
	subeq	xCoord, #1
	strb  xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1






	//Third block
	//xCoord
	ldrb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords]
	addne	yCoord, #1
	subeq	yCoord, #1
	strb  yCoord, [coords], #1





	//Fourth block
	//xCoord, -/+ 1
	ldrb	xCoord, [coords]
	addne	xCoord, #2
	subeq	xCoord, #2
	strb  xCoord, [coords], #1

	//yCoord, +/- 1
	ldrb	yCoord, [coords], #1






	//if orientation u, set it to r, and vice versa
	ldr		r1, =Orientation
	moveq	orientation, #'r'
	movne	orientation, #'u'
	strb	orientation, [r1]


	endRotateZ:

	.unreq	coords
	.unreq	xCoord
	.unreq	yCoord
	.unreq	orientation

	pop		{r4-r10, r14}
	bx		lr



.section .data
