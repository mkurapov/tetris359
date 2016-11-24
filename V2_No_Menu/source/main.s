.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
	//initialize peripherals
    bl		Interrupt_Install_Table
    //mov		sp, #0x8000
	bl		EnableJTAG
	bl		InitFrameBuffer
	bl		Init_SNES
	//bl		Interrupt_Setup
	bl		Interuphack
	bl		Main_Loop

	b haltLoop$





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
//*****************************************************

			//otherwise, start the game
			bl		Game_Test
			//bl		Game_Start
    
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


