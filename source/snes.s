.section    .init
    
.section .text


/* Get_SNES fuction
 *Return encoding of newly pressed buttons
 *Parameters:
 *	None
 *Returns:
 *	r0- encoding of buttons pressed, 1 encodes button on, 0 encodes button off (in the following order):
 *			bit 0: B
 *			bit 1: Y
 *			bit 2: Select
 *			bit 3: Start
 *			bit 4: D-pad up
 *			bit 5: D-pad down
 *			bit 6: D-pad left
 *			bit 7: D-pad right
 *			bit 8: A
 *			bit 9: X
 *			bit 10: L
 *			bit 11: R
 *			bit 12- 31: unused
 */
.global		Get_SNES
Get_SNES:

	preAdd	.req r4
	preCon	.req r5
	preNeg	.req r6
	curCon	.req r7
	return	.req r8

	//push registers onto the stack
	push	{r4-r10, r14}

	ldr		preAdd, =previous
	ldrh	preCon, [preAdd]

	bl		Read_SNES
	
	//compare to previous snapshot and keep only buttons which were newly pressed
	mov		curCon, r0					//take a copy of the current snapshot
	mvn		preNeg, preCon				//take the negation of the previous snapshot
	and		r0, preNeg					//and the current snapshot to remove any held buttons
	mov		return, r0
	
	//move the current snapshot to be next iteration's previous
	strh	curCon, [preAdd]

	//delay to prevent double press from sticky controllers
	mov		r0, #4000
	bl		Wait
	
	mov		r0, return
	
	.unreq	preAdd
	.unreq	preCon
	.unreq	preNeg
	.unreq	curCon
	
	//pop registers off of the stack
	pop		{r4-r10, r14}
	bx		lr





/* Init_SNES fuction
 *Itializes a the GPIO Lines of the SNES controller
 *Parameters:
 *	None
 *Returns:
 *	None
 */
.global		Init_SNES
Init_SNES:

	line	.req r0
	func	.req r1
	preAdd	.req r2
	preCon	.req r3

	//push registers onto the stack
	push	{r4-r10, r14}

	//set the latch line to output
	mov		line, #9
	mov		func, #1
	bl		Init_GPIO
	
	//set the clock line to output
	mov		line, #11
	mov		func, #1
	bl		Init_GPIO
	
	//set the data line to input
	mov		line, #10
	mov		func, #0
	bl		Init_GPIO
	
	//initialize previous snapshot to be 0
	ldr		preAdd, =previous
	mov		preCon, #0
	strh	preCon, [preAdd]

	.unreq	line
	.unreq	func
	.unreq	preAdd
	.unreq	preCon

	//pop registers off of the stack
	pop		{r4-r10, r14}
	bx		lr





/* Read_SNES fuction
 *Reads input from the SNES controler
 *Parameters:
 *	None
 *Returns:
 *	r0- encoding of buttons pressed (as the complement of the latch register)
 * 		1 encodes button on, 0 encodes button off (in the following order):
 *			bit 0: B
 *			bit 1: Y
 *			bit 2: Select
 *			bit 3: Start
 *			bit 4: D-pad up
 *			bit 5: D-pad down
 *			bit 6: D-pad left
 *			bit 7: D-pad right
 *			bit 8: A
 *			bit 9: X
 *			bit 10: L
 *			bit 11: R
 *			bit 12- 31: unused
 */
Read_SNES:

	output	.req r0
	funcIn	.req r0
	buttIn	.req r0
	butSna	.req r4
	index	.req r5
	bitMas	.req r6
	
	push	{r4-r10, r14}				//push registers onto the stack

	//write 1 to the clock for first rising edge
	mov		funcIn, #1					//set r0 to contain a 1
	bl		Write_Clock					//call Write_Clock subroutine with input 1
	
	//write 1 to the latch
	mov		funcIn, #1					//set r0 to contain a 1
	bl		Write_Latch					//call Write_Latch subroutine with input 1
	
	//wait for 12 microseconds for latch to be written
	mov		funcIn, #12					//set r0 to contain 12
	bl		Wait						//call Wait subrouine with input 12

	//write 0 to the latch
	mov		funcIn, #0					//set r0 to contain a 0
	bl		Write_Latch					//call Write_Latch subroutine with input 0
	
	
	//set up loop index
	mov		butSna, #0					//set the button snapshot to start as 0
	mov		index, #0					//set the loop index to start at 0
	mov		bitMas, #1					//set the bit mask to start with lsb set
	
	//loop 16 times to read buttons into button snapshot register (r4)
	pulseLoop:
	
		//check loop guard
		cmp		index, #16				//compare the index to the loop guard
		bhs		endPulseLoop			//branch on >= to end of loop
	
		//wait for 6 microseconds for the clock
		mov		funcIn, #6				//set r0 to contain 6
		bl		Wait					//call Wait subrouine with input 6
	
		//write 0 to the clock for falling edge
		mov		funcIn, #0				//set r0 to contain a 0
		bl		Write_Clock				//call Write_Clock subroutine with input 0
		
		//wait for 6 microseconds for the clock
		mov		funcIn, #6				//set r0 to contain 6
		bl		Wait					//call Wait subrouine with input 6

		//read the bit of current button index
		bl		Read_Data				//content returned in r0

		//add the button content to the button snapshot
		cmp		buttIn, #0				//check to see what was read from the line
		orreq	butSna, bitMas			//and the bit mask with the button snapshot if input was 0
		
		//write 1 to the clock for rising edge, new cycle
		mov		funcIn, #1				//set r0 to contain a 1
		bl		Write_Clock				//call Write_Clock subroutine with input 1
		
		//update index and bit mask
		lsl		bitMas, #1				//move the 1 in the bitMask one to the left
		add		index, #1				//increment the index
		b pulseLoop						//return to top of the loop
		
	endPulseLoop:
	
	//set up return value
	mov		output, butSna				//move the button snapshot to the output register
	
	.unreq 	output
	.unreq 	funcIn
	.unreq 	buttIn	
	.unreq 	butSna	
	.unreq 	index
	.unreq 	bitMas

	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine
	
	
	
	
	
/* Init_GPIO fuction
 *Itializes a GPIO Line to a function code
 *Parameters:
 *	r0- GPIO line number
 *	r1- Function code
 *Returns:
 *	None
 */
Init_GPIO:
	
	line	.req r0
	func	.req r1
	regAdd	.req r2
	basAdd	.req r3
	regCon	.req r4
	bitMas	.req r5
	num3	.req r6
	
	push	{r4-r10, r14}				//push registers onto the stack
	
	mov		regAdd, #0					//set the loop counter to be 0
	
	lineLoop:
		cmp		line, #9				//check if the line number is greater than 9
		subhi	line, #10				//if so, subtract 10 
		addhi	regAdd, #4				//and keep track of how many times we have subtracted 10 (with offset 4)
		bhi		lineLoop				//and then return back to the loop
	endLineLoop:
	
	//get the parameter line's corresponding register
	ldr		basAdd, =0x3F200000			//get the base address of the GPIO registers
	add		regAdd, basAdd				//add the register offset of the specific line
	ldr		regCon, [regAdd]			//get the content of the corresponding register
	
	//clear the line within the specified register
	mov		num3, #3
	mul		line, num3					//multiply the ones spot of the line number by 3 (for the corresponding line)
	mov		bitMas, #7					//set the bit clear mask into r5
	bic		regCon, bitMas, lsl line	//bit clear the 3 bits of the corresponding line			

	//set the bits of the line to the function code, and store it back
	orr		regCon, func, lsl line		//set the passed function code into the corresponding line
	str		regCon, [regAdd]			//store the result back out to the register
	
	.unreq	line
	.unreq	func
	.unreq	regAdd
	.unreq	basAdd
	.unreq	regCon
	.unreq	bitMas
	
	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine





/* Write_Latch fuction
 *Writes a bit to the latch line (pin 9)
 *Parameters:
 *	r0- bit to be written
 *Returns:
 *	None
 */	
Write_Latch:

	input	.req r0
	pinNum	.req r1
	basAdd	.req r2
	bitMas	.req r3

	push	{r4-r10, r14}				//push registers onto the stack
	
	//set up write values
	mov		pinNum, #9					//move number 9 into the pin number register			
	ldr		basAdd, =0x3F200000			//get the base address of the GPIO registers
	mov		bitMas, #1					//set up the bit mask for writting a value
	lsl		bitMas, pinNum				//align the bit mask with the latch pin bit

	//set the input within the corresponding register
	cmp		input, #0					//check to see if the input is a 0
	streq	bitMas, [basAdd, #40]		//set 1 in GPIOCLR0 if the input was 0
	strne	bitMas, [basAdd, #28]		//set 1 in GPIOSET0 if the input was 1
		
	.unreq	input
	.unreq	pinNum
	.unreq	basAdd
	.unreq	bitMas
		
	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine
	
	
	
	
	
/* Write_Clock fuction
 *Writes a bit to the clock line (pin 11)
 *Parameters:
 *	r0- bit to be written
 *Returns:
 *	None
 */	
Write_Clock:

	input	.req r0
	pinNum	.req r1
	basAdd	.req r2
	bitMas	.req r3

	push	{r4-r10, r14}				//push registers onto the stack
	
	//set up write values
	mov		pinNum, #11					//move number 11 into the pin number register			
	ldr		basAdd, =0x3F200000			//get the base address of the GPIO registers
	mov		bitMas, #1					//set up the bit mask for writting a value
	lsl		bitMas, pinNum				//align the bit mask with the clock pin bit

	//set the input within the corresponding register
	cmp		input, #0					//check to see if the input is a 0
	streq	bitMas, [basAdd, #40]		//set 1 in GPIOCLR0 if the input was 0
	strne	bitMas, [basAdd, #28]		//set 1 in GPIOSET0 if the input was 1
	
	.unreq	input
	.unreq	pinNum
	.unreq	basAdd
	.unreq	bitMas
		
	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine





/* Read_Data fuction
 *Reads a bit from the data line (pin 10)
 *Parameters:
 *	None
 *Returns:
 *	r0- bit read
 */	
Read_Data:

	output	.req r0
	pinNum	.req r1
	dataRe	.req r2
	basAdd	.req r3
	bitMas	.req r4

	push	{r4-r10, r14}				//push registers onto the stack
	
	//set up read values
	mov		pinNum, #10					//move number 10 into the pin number register			
	ldr		basAdd, =0x3F200000			//get the base address of the GPIO registers
	ldr		dataRe, [basAdd, #52]		//get the contents of the GPIOLEV0 register
	mov		bitMas, #1					//set up the bit mask for reading a value
	lsl		bitMas, pinNum				//align the bit mask with the data pin bit

	//read value and return
	and		dataRe, bitMas				//and the GPIOLEV0 register with the data bit mask
	cmp		dataRe, #0					//check to see if the value read is a 0
	moveq	output, #0					//set 0 as output if the value read was 0
	movne	output, #1					//set 1 as output if the value read was 1
		
	.unreq	output
	.unreq	pinNum
	.unreq	dataRe
	.unreq	basAdd
	.unreq	bitMas
		
	pop		{r4-r10, r14}				//pop registers off of the stack
	bx		lr							//branch back to the calling subroutine



.section .data

previous:		.hword
