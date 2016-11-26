.section .text


/* rotateLUpRight function
 *  handle rotation from up <---> right of the L block
 * Parameters:
 *	r0 - 0 if rotating clockwise, 1 if counter-clockwise
 * Returns:
 * 	None
 */
.global	rotateLUpRight
rotateLUpRight:


	coords				.req r4
	xCoord				.req r5
	yCoord				.req r6
	orientation		.req r7
	newRotation		.req r8


	push	{r4-r10, r14}

	mov	newRotation, r0
	//set flag to see if clockwise or counter-clockwise
	cmp	newRotation, #0

	ldr		coords, =First

	//check to see if move is legal
	//First block
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
	beq	endRotateLUpRight
	cmp	newRotation, #0





	//Second block
	//xCoord
	ldrb	xCoord, [coords], #1
	addeq	xCoord, #1
	subne	xCoord, #1

	//yCoord
	ldrb	yCoord, [coords], #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateLUpRight
	cmp	newRotation, #0




	//Third block
	//xCoord
	ldrb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1
	addeq	yCoord, #1
	subne	yCoord, #1


	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateLUpRight
	cmp	newRotation, #0






	//Fourth block
	//xCoord
	ldrb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1
	addeq	yCoord, #1
	subne	yCoord, #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateLUpRight
	cmp	newRotation, #0






	//actually set the pieces
	ldr		coords, =First

	//First block
	//xCoord
	ldrb	xCoord, [coords]
	addne	xCoord, #1
	subeq	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1



	//Second block
	//xCoord
	ldrb	xCoord, [coords]
	addeq	xCoord, #1
	subne	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1




	//Third block
	//xCoord
	ldrb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords]
	addeq	yCoord, #1
	subne	yCoord, #1
	strb	yCoord, [coords], #1






	//Fourth block
	//xCoord
	ldrb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords]
	addeq	yCoord, #1
	subne	yCoord, #1
	strb	yCoord, [coords], #1




	cmp	newRotation, #0

	//if going clockwise, set it to r, if cclockwise, set it to u
	ldr		r1, =Orientation
	moveq	orientation, #'r'
	movne	orientation, #'u'
	strb	orientation, [r1]


	endRotateLUpRight:

	.unreq	coords
	.unreq	xCoord
	.unreq	yCoord
	.unreq	orientation
	.unreq  newRotation

	pop		{r4-r10, r14}
	bx		lr




/* rotateLRightDown function
 *  handle rotation from right <---> down of the L block
 * Parameters:
 *	r0 - 0 if rotating clockwise, 1 if counter-clockwise
 * Returns:
 * 	None
 */
.global	rotateLRightDown
rotateLRightDown:


	coords				.req r4
	xCoord				.req r5
	yCoord				.req r6
	orientation		.req r7
	newRotation		.req r8


	push	{r4-r10, r14}

	mov	newRotation, r0
	//set flag to see if clockwise or counter-clockwise
	cmp	newRotation, #0

	ldr		coords, =First

	//check to see if move is legal
	//First block
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
	beq	endRotateLRightDown
	cmp	newRotation, #0





	//Second block
	//xCoord
	ldrb	xCoord, [coords], #1
	//yCoord
	ldrb	yCoord, [coords], #1


	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateLRightDown
	cmp	newRotation, #0





	//Third block
	//xCoord
	ldrb	xCoord, [coords], #1
	addeq	xCoord, #1
	subne	xCoord, #1

	//yCoord
	ldrb	yCoord, [coords], #1
	addne 	yCoord, #1
	subeq	yCoord, #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateLRightDown
	cmp	newRotation, #0






	//Fourth block
	//xCoord
	ldrb	xCoord, [coords], #1
	addne	xCoord, #2
	subeq	xCoord, #2

	//yCoord
	ldrb	yCoord, [coords], #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateLRightDown
	cmp	newRotation, #0






	//actually set the pieces
	ldr		coords, =First

	//First block
	//xCoord
	ldrb	xCoord, [coords]
	addne	xCoord, #1
	subeq	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords]
	addeq	yCoord, #1
	subne	yCoord, #1
	strb	yCoord, [coords], #1



	//Second block
	//xCoord
	ldrb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1



	//Third block
	//xCoord
	ldrb	xCoord, [coords]
	addeq	xCoord, #1
	subne	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords]
	addne	yCoord, #1
	subeq	yCoord, #1
	strb	yCoord, [coords], #1



	//Fourth block
	//xCoord
	ldrb	xCoord, [coords]
	addne	xCoord, #2
	subeq	xCoord, #2
	strb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1






	cmp	newRotation, #0

	//if going clockwise, set it to d, if cclockwise, set it to r
	ldr		r1, =Orientation
	moveq	orientation, #'d'
	movne	orientation, #'r'
	strb	orientation, [r1]


	endRotateLRightDown:

	.unreq	coords
	.unreq	xCoord
	.unreq	yCoord
	.unreq	orientation
	.unreq  newRotation

	pop		{r4-r10, r14}
	bx		lr





/* endrotateLDownLeft function
 *  handle rotation from down <---> left of the L block
 * Parameters:
 *	r0 - 0 if rotating clockwise, 1 if counter-clockwise
 * Returns:
 * 	None
 */
.global	rotateLDownLeft
rotateLDownLeft:


	coords				.req r4
	xCoord				.req r5
	yCoord				.req r6
	orientation		.req r7
	newRotation		.req r8


	push	{r4-r10, r14}

	mov	newRotation, r0
	//set flag to see if clockwise or counter-clockwise
	cmp	newRotation, #0

	ldr		coords, =First

	//check to see if move is legal
	//First block
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
	beq	endRotateLDownLeft
	cmp	newRotation, #0





	//Second block
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
	beq	endRotateLDownLeft
	cmp	newRotation, #0




	//Third block
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
	beq	endRotateLDownLeft
	cmp	newRotation, #0






	//Fourth block
	//xCoord
	ldrb	xCoord, [coords], #1
	addeq	xCoord, #1
	subne	xCoord, #1

	//yCoord
	ldrb	yCoord, [coords], #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateLDownLeft
	cmp	newRotation, #0






	//actually set the pieces
	ldr		coords, =First

	//First block
	//xCoord
	ldrb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords]
	addne	yCoord, #1
	subeq	yCoord, #1
	strb	yCoord, [coords], #1



	//Second block
	//xCoord
	ldrb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords]
	addne	yCoord, #1
	subeq	yCoord, #1
	strb	yCoord, [coords], #1




	//Third block
	//xCoord
	ldrb	xCoord, [coords]
	addne	xCoord, #1
	subeq	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1


	//Fourth block
	//xCoord
	ldrb	xCoord, [coords]
	addeq	xCoord, #1
	subne	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1






	cmp	newRotation, #0

	//if going clockwise, set it to l, if cclockwise, set it to d
	ldr		r1, =Orientation
	moveq	orientation, #'l'
	movne	orientation, #'d'
	strb	orientation, [r1]


	endRotateLDownLeft:

	.unreq	coords
	.unreq	xCoord
	.unreq	yCoord
	.unreq	orientation
	.unreq  newRotation

	pop		{r4-r10, r14}
	bx		lr





/* rotateLLeftUp function
 *  handle rotation from down <---> left of the L block
 * Parameters:
 *	r0 - 0 if rotating clockwise, 1 if counter-clockwise
 * Returns:
 * 	None
 */
.global	rotateLLeftUp
rotateLLeftUp:


	coords				.req r4
	xCoord				.req r5
	yCoord				.req r6
	orientation		.req r7
	newRotation		.req r8


	push	{r4-r10, r14}

	mov	newRotation, r0
	//set flag to see if clockwise or counter-clockwise
	cmp	newRotation, #0

	ldr		coords, =First

	//check to see if move is legal
	//First block
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
	beq	endRotateLLeftUp
	cmp	newRotation, #0





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
	beq	endRotateLLeftUp
	cmp	newRotation, #0




	//Third block
	//xCoord
	ldrb	xCoord, [coords], #1
	//yCoord
	ldrb	yCoord, [coords], #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateLLeftUp
	cmp	newRotation, #0






	//Fourth block
	//xCoord
	ldrb	xCoord, [coords], #1
	addeq	xCoord, #1
	subne	xCoord, #1
	//yCoord
	ldrb	yCoord, [coords], #1
	addne	yCoord, #1
	subeq	yCoord, #1

	mov	r0, xCoord
	mov	r1, yCoord
	bl	Check_Empty
	cmp	r0, #0
	beq	endRotateLLeftUp
	cmp	newRotation, #0






	//actually set the pieces
	ldr		coords, =First

	//First block
	//xCoord
	ldrb	xCoord, [coords]
	addeq	xCoord, #2
	subne	xCoord, #2
	strb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1



	//Second block
	//xCoord
	ldrb	xCoord, [coords]
	addne	xCoord, #1
	subeq	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords]
	addeq	yCoord, #1
	subne	yCoord, #1
	strb	yCoord, [coords], #1



	//Third block
	//xCoord
	ldrb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords], #1



	//Fourth block
	//xCoord
	ldrb	xCoord, [coords]
	addeq	xCoord, #1
	subne	xCoord, #1
	strb	xCoord, [coords], #1

	//yCoord
	ldrb	yCoord, [coords]
	addne	yCoord, #1
	subeq	yCoord, #1
	strb	yCoord, [coords], #1






	cmp	newRotation, #0

	//if going clockwise, set it to l, if cclockwise, set it to d
	ldr		r1, =Orientation
	moveq	orientation, #'u'
	movne	orientation, #'l'
	strb	orientation, [r1]


	endRotateLLeftUp:

	.unreq	coords
	.unreq	xCoord
	.unreq	yCoord
	.unreq	orientation
	.unreq  newRotation

	pop		{r4-r10, r14}
	bx		lr


.section .data
