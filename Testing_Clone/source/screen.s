.section .text


/* Draw_Pixel function
 *	Draws one pixel to the screen
 *  r0 - x-coordinate
 *  r1 - y-coordinate
 *  r2 - color in hexadecimal
 */
.global Draw_Pixel
Draw_Pixel:

	offset	.req r4

	push	{r4}

	// offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r0, r1, lsl #10
	
	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1

	// store the colour (half word) at framebuffer pointer + offset

	ldr	r0, =FrameBufferPointer
	ldr	r0, [r0]
	strh	r2, [r0, offset]

	.unreq	offset

	pop		{r4}
	bx		lr



/* Draw_LineH function
 *	Draws one horizontal line to the screen
 *  r0 - leftmost x-coordinate
 *  r1 - leftmost y-coordinate
 *  r2 - color in hexadecimal
 *	r3 - length
 */
.global Draw_LineH
Draw_LineH:

	xCoord	.req r4
	yCoord	.req r5
	color	.req r6
	length	.req r7
	index	.req r8

	push	{r4-r10, r14}

	//copy the passed values into safe registers
	mov		xCoord, r0
	mov		yCoord, r1
	mov		color,	r2
	mov		length,	r3
	
	//setup loop index
	mov		index,	#1
	
	lineHLoop:
		
		//check loop guard
		cmp		index, length
		bhi		endLineHLoop
		
		//call Draw_Pixel with the current pixel
		mov		r0, xCoord
		mov		r1, yCoord
		mov		r2, color
		bl		Draw_Pixel
		
		//increment index and x-value
		add		index, #1
		add		xCoord, #1
		b		lineHLoop
		
	endLineHLoop:

	.unreq	xCoord
	.unreq	yCoord
	.unreq	color
	.unreq	length
	.unreq	index

	pop		{r4-r10, r14}
	bx		lr
	
	
	
/* Draw_Box function
 *	Draws one Box to the screen
 *  r0 - leftmost x-coordinate
 *  r1 - leftmost y-coordinate
 *  r2 - color in hexadecimal
 *	r3 - length
 *  r4 - height
 */
.global Draw_Box
Draw_Box:

	xCoord	.req r5
	yCoord	.req r6
	color	.req r7
	length	.req r8
	height  .req r9
	index	.req r10

	push	{r4-r10, r14}

	//copy the passed values into safe registers
	mov		xCoord, r0
	mov		yCoord, r1
	mov		color,	r2
	mov		length,	r3
	mov		height,	r4
	
	
	//setup loop index
	mov		index,	#1
	
	lineVLoop:
		
		//check loop guard
		cmp		index, height
		bhi		endLineVLoop
		
		//call Draw_Line with the current y-value
		mov		r0, xCoord
		mov		r1, yCoord
		mov		r2, color
		mov		r3, length
		bl		Draw_LineH
		
		//increment index and y-value
		add		index, #1
		add		yCoord, #1
		b		lineVLoop
	
	endLineVLoop:

	.unreq	xCoord
	.unreq	yCoord
	.unreq	color
	.unreq	length
	.unreq	height
	.unreq	index

	pop		{r4-r10, r14}
	bx		lr
	
	
	
	
	
/* Draw_Image function
 *	Draws an image to the screen
 *  r0 - memory address of image to be drawn
 */
.global Draw_Image
Draw_Image:

	imgAdd	.req r4
	xCoord	.req r5
	yCoord	.req r6
	length	.req r7
	height  .req r8
	outInd	.req r9
	innInd	.req r10
	
	push	{r4-r10, r14}

	//set up outer loop
	mov		imgAdd, r0
	ldrh	xCoord, [imgAdd], #2
	ldrh	yCoord, [imgAdd], #2
	ldrh	length, [imgAdd], #2
	ldrh	height, [imgAdd], #2
	mov		outInd, #0
	
	outerImageLoop:
	
		//check loop guard
		cmp		outInd, height
		bhs		endOuterImageLoop
	
		//set up inner loop
		mov		innInd, #0
	
		innerImageLoop:
		
			//check loop guard
			cmp		innInd, length
			bhs		endInnerImageLoop
		
		
			//call Draw_Pixel with the current x-value
			mov		r0, xCoord
			mov		r1, yCoord
			ldrh	r2, [imgAdd], #2
			bl		Draw_Pixel
			
			//increment index
			add		innInd, #1
			add		xCoord, #1
			b		innerImageLoop
		
		
		endInnerImageLoop:
		
		//increment index
		add		outInd, #1
		add		yCoord, #1
		sub		xCoord, length
		b		outerImageLoop
	
	endOuterImageLoop:
	
	.unreq	imgAdd
	.unreq	xCoord
	.unreq	yCoord
	.unreq	length
	.unreq	height
	.unreq	outInd
	.unreq	innInd

	pop		{r4-r10, r14}
	bx		lr
	
	

/* Draw_Block function
 *	Draws a block to the screen using the game board dimensions
 *  r0 - memory address of image to be drawn
 *	r1 - x coordinate (in terms of game board)
 *	r2 - y coordinate (in terms of game board)
 */
.global Draw_Block
Draw_Block:

	imgAdd	.req r4
	xCoord	.req r5
	yCoord	.req r6
	length	.req r7
	height  .req r8
	outInd	.req r9
	innInd	.req r10
	
	push	{r4-r10, r14}

	//copy the image address
	mov		imgAdd, r0

	//set up the length of the block
	mov		length, #32
	mov		height, #32

	//get actual screen position from game board
	mov		xCoord, r1
	mul		xCoord, length				//multiply the board coordinates by the pixel size
	//ldr		r0, =Board				//get the base address of the game board
	ldrh	r1, [r0], #2				//get the x offset from the address
	add		xCoord, r1					//add the offset to the x coordinate
	
	//repeat for the y value
	mov		yCoord, r2
	mul		yCoord, length
	ldrh	r1, [r0]
	add		yCoord, r1

	//set up outer loop
	mov		outInd, #0
	
	outerBlockLoop:
	
		//check loop guard
		cmp		outInd, height
		bhs		endOuterBlockLoop
	
		//set up inner loop
		mov		innInd, #0
	
		innerBlockLoop:
		
			//check loop guard
			cmp		innInd, length
			bhs		endInnerBlockLoop
		
		
			//call Draw_Pixel with the current x-value
			mov		r0, xCoord
			mov		r1, yCoord
			ldrh	r2, [imgAdd], #2
			bl		Draw_Pixel
			
			//increment index
			add		innInd, #1
			add		xCoord, #1
			b		innerBlockLoop
		
		
		endInnerBlockLoop:
		
		//increment index
		add		outInd, #1
		add		yCoord, #1
		sub		xCoord, length
		b		outerBlockLoop
	
	endOuterBlockLoop:
	
	.unreq	imgAdd
	.unreq	xCoord
	.unreq	yCoord
	.unreq	length
	.unreq	height
	.unreq	outInd
	.unreq	innInd

	pop		{r4-r10, r14}
	bx		lr



.section .data
