.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
	//initialize peripherals
    bl		Interrupt_Install_Table
	bl		EnableJTAG
	bl		InitFrameBuffer
	bl		Init_SNES
	bl		Interuphack
	
	//branch to main loop
	bl		Main_Loop





 /*Main_Loop function
 *Main game loop to run the menu and game
 */
.global Main_Loop	
Main_Loop:
		
	push	{r4-r10, r14}
		
		mainLoopRun:
			//display and run the menu
			bl		Menu_Run
    
			//check if quit game was selected
			cmp		r0, #0
			bleq	Quit

			//otherwise, start the game
			bl		Game_Start
    
			//once the game has ended, rerun the menu
			b mainLoopRun
		
	pop		{r4-r10, r14}
	bx		lr
		
    
    
/* Quit function
 *	clears the screen and exits the game
 */  
.global Quit
Quit: 

	bl		Clear_Screen
	b		haltLoop$





    
haltLoop$:
	b		haltLoop$

.section .data


