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
	
	
	testSNES:
	
		bl		Get_SNES
		b		testSNES
	
	
	
	
	
	//display and run the menu
	//bl		Menu_Display
	//bl		Menu_Run
    
    
    
haltLoop$:
	b		haltLoop$

.section .data


