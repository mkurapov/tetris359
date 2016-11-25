.section .text




/* Menu_Display function
 *	Draws the menu to the screen
 */
.global Menu_Display
Menu_Display:

	push	{r4-r10, r14}

	ldr		r0, =Main_Menu
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
	
	bl		Clear_Game_Running_Flag
	bl		Menu_Display

	//set the default selected option to 1
	mov		select, #1

	//setup bit masks
	mov		r0, #1
	mov		maskUp, #16
	mov		maskDow, #32
	mov		maskA, #256

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
		movne	select, #1
		ldrne	r0, = Block_Start
		blne	Draw_Image
		
		//check if down was pressed, and update selected if needed 
		and		button, maskDow, r0
		cmp		button, #0
		movne	select, #0
		ldrne	r0, = Block_Quit
		blne	Draw_Image

		b		menuDisplayLoop

	endMenuDisplayLoop:

	mov		r0, select

	.unreq	maskA
	.unreq	maskUp
	.unreq	maskDow
	.unreq	button
	.unreq	select


	pop		{r4-r10, r14}
	bx		lr
	
	
	
	
/* Pause_Display function
 *	Draws the pause menu to the screen
 */
.global Pause_Display
Pause_Display:

	push	{r4-r10, r14}

	ldr		r0, =Pause_Menu_Image
	mov		r1, #202
	strh	r1, [r0]
	bl		Draw_Image

	pop		{r4-r10, r14}
	bx		lr



/* Pause_Run function
 *	Runs the interactive pause menu
 */
.global Pause_Run
Pause_Run:

	maskA	.req r4
	maskUp	.req r5
	maskDow	.req r6
	maskSt	.req r7
	button	.req r8
	select	.req r9

	push	{r4-r10, r14}
	
	bl		Pause_Display
	bl		Clear_Game_Running_Flag

	//set the default selected option to 1
	mov		select, #1

	//setup bit masks
	mov		r0, #1
	mov		maskUp, #16
	mov		maskDow, #32
	mov		maskA, #256
	mov		maskSt, #8

	pauseDisplayLoop:
	
		//read in the SNES input
		bl		Get_SNES
		
		//check if A was pressed, and return the selected button
		and		button, maskA, r0
		cmp		button, #0
		bne		endPauseDisplayLoop
		
		//check if up was pressed, and update selected if needed 
		and		button, maskUp, r0
		cmp		button, #0
		movne	select, #1
		ldrne	r0, = Pause_Restart
		blne	Draw_Image
		
		//check if down was pressed, and update selected if needed 
		and		button, maskDow, r0
		cmp		button, #0
		movne	select, #0
		ldrne	r0, = Pause_Quit
		blne	Draw_Image
		
		//check if start was pressed, and exit the pause menu if so 
		and		button, maskSt, r0
		cmp		button, #0
		movne	select, #2
		bne		endPauseDisplayLoop
		
		b		pauseDisplayLoop

	endPauseDisplayLoop:
	
	//if the pause menu was exited normally, redraw the screen and continue
	cmp		select, #2
	bleq	Pause_Clear
	cmp		select, #2
	beq		endPause
		
	//if restart was selected, reset the game
	cmp		select, #1
	bleq	Game_Reset
	cmp		select, #1
	bleq	Game_Test 						//Game_Run once done
	
	//otherwise, return to main menu (restart above should fall through to this function call if it somehow returns)
	bl	Game_Reset
	bl	Main_Loop
	
	endPause:
	
	bl		Set_Game_Running_Flag
	bl		Value_Pack_Draw

	.unreq	maskA
	.unreq	maskUp
	.unreq	maskDow
	.unreq	maskSt
	.unreq	button
	.unreq	select


	pop		{r4-r10, r14}
	bx		lr




/*Pause_Clear function
 *	redraws the game board over top of the pause menu
 */
.global Pause_Clear
Pause_Clear:

	push	{r4-r10, r14}

	//clear the left overlap of the pause menu
	ldr		r0, =Pause_Clear_Left
	bl		Draw_Image
	
	//clear the right overlap of the pause menu
	ldr		r0, =Pause_Clear_Right
	bl		Draw_Image
	
	//redraw the game board overtop of the middle of the pause menu
	bl		Redraw_Board


	pop		{r4-r10, r14}
	bx		lr

.section .data


