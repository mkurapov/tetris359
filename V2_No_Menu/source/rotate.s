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
	type		 .req r6

	push	{r4-r10, r14}				//push registers onto the stack

	//load type of block
	ldr		r1, =Type
	ldrb	type, [r1]

	//dont rotate if tetromino is O type
	cmp		type, #'O'
	b		endRotation

	cmp		type, #'C'
	bleq	Rotate_I
	// add branch to endrotation?












	endRotation:




	.unreq	newRotation

	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine


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

	cmp		orientation, #u

	//First block
	//xCoord, +/- 1
	ldrb	xCoord, [coord]
	addeq	xCoord, #1
	subne	xCoord, #1
	strb	xCoord, [coord], #1

	//yCoord, -/+ 1
	ldrb	yCoord, [coord]
	addne	yCoord, #1
	subeq	yCoord, #1
	strb	yCoord, [coord], #3  //skip second (pivot), move to third



	//Third block
	//xCoord, -/+ 1
	ldrb	xCoord, [coord]
	addne	xCoord, #1
	subeq	xCoord, #1
	strb	xCoord, [coord], #1

	//yCoord, +/- 1
	ldrb	yCoord, [coord]
	addeq	yCoord, #1
	subne	yCoord, #1
	strb	yCoord, [coord], #1





	//Fourth block
	//xCoord, -/+ 1
	ldrb	xCoord, [coord]
	addne	xCoord, #2
	subeq	xCoord, #2
	strb	xCoord, [coord], #1

	//yCoord, +/- 1
	ldrb	yCoord, [coord]
	addeq	yCoord, #2
	subne	yCoord, #2
	strb	yCoord, [coord], #1




	.unreq	coord
	.unreq	value
	.unreq	typAdd
	.unreq	type

	pop		{r4-r10, r14}
	bx		lr

.section .data
