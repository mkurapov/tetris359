.section .text




/* Menu_Display function
 *	Draws the menu to the screen
 */
.global Menu_Display
Menu_Display:

	push	{r4-r10, r14}

	//ldr		r0, =Main_Menu
	bl		Draw_Image

	pop		{r4-r10, r14}
	bx		lr



/* Menu_Run function
 *	Runs the interactive menu
 *	Returns:
 *		r0- state chose, 1 = start game, 0 = quit game
 */
.global Menu_Run
Menu_Run:

	maskA	.req r4
	maskUp	.req r5
	maskDow	.req r6
	button	.req r7
	select	.req r8

	push	{r4-r10, r14}

	//set the default selected option to 1
	mov		select, #1

	//setup bit masks
	mov		r0, #1
	mov		maskUp, r1, lsl #4
	mov		maskDow, r1, lsl #5
	mov		maskA, r1, lsl #8

	menuDisplayLoop:
	
		//read in the SNES input
		bl		Get_SNES
		
		//check if A was pressed, and return the selected button
		and		button, maskA, r0
		cmp		button, #0
		bne		endMenuDisplayLoop
		
		//check if up was pressed, and update selected if needed 
		and		button, maskUp, r0
		cmp		button, #0
		//ldrne	r0, = Main_Start
		//blne	Draw_Image
		movne	select, #1
		
		//check if down was pressed, and update selected if needed 
		and		button, maskDow, r0
		cmp		button, #0
		//ldrne	r0, = Main_Quit
		//blne	Draw_Image
		movne	select, #0

		b		menuDisplayLoop

	endMenuDisplayLoop:

	mov		r0, select

	pop		{r4-r10, r14}
	bx		lr




.section .data


