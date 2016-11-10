.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
	//initialize peripherals
    mov     sp, #0x8000
	bl		EnableJTAG
	bl		InitFrameBuffer
	bl		Init_SNES
	
	mainLoop:
		
		//display and run the menu
		bl		Menu_Display
		bl		Menu_Run
    
		//check if quite game was selected
		cmp		r0, #0
		bleq	Quit
    
		//otherwise, start the game
		//bl		Game_Display
		//bl		Game_Start
    
		b mainLoop
    
    
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


