.section	.text


.equ		interrupt_Delay, 20000000

.global Interuphack
Interuphack:

	push {r0-r10,r14}
	
	//DISABLE ALL
	//*0x3f00b21C = *0x3f00b210
	ldr r0, =0x3f00b21C
	ldr r1, =0x3f00b210
	
	ldr r1, [r1]
	str r1, [r0]
	
	// reset the CS timer control status for C1
	ldr		r0, =0x3F003000
	ldr		r2, [r0]
	mov		r1, #2
	str		r1, [r0]
	
	pop {r0-r10,r14}
	bx lr

/*Install_Int_Table function
 *	moves the interrupt table into low memory and sets up the stack pointers
 *	this code was modified slightly from the tutorial 9 solution
 */
 .global Interrupt_Install_Table
Interrupt_Install_Table:

	push 	{r0-r10,r14}

	ldr		r0, =IntTable
	mov		r1, #0x00000000

	// load the first 8 words and store at the 0 address
	ldmia	r0!, {r2-r9}
	stmia	r1!, {r2-r9}

	// load the second 8 words and store at the next address
	ldmia	r0!, {r2-r9}
	stmia	r1!, {r2-r9}

	// switch to IRQ mode and set stack pointer
	mov		r0, #0xD2
	msr		cpsr_c, r0
	mov		sp, #0x8000

	// switch back to Supervisor mode, set the stack pointer
	mov		r0, #0xD3
	msr		cpsr_c, r0
	mov		sp, #0x8000000

	pop		 {r0-r10,r14}
	bx		lr	


/*Install_Int_Table function
 *	moves the interrupt table into low memory and sets up the stack pointers
 *	this code was modified slightly from the tutorial 9 solution
 */
 .global Interrupt_Reinstall_Table
Interrupt_Reinstall_Table:

	push	{r4-r10, r14}

	// Disable IRQ (And FIQ)
	//mrs		r0, cpsr
	//orr		r0, #0xC0
	//msr		cpsr_c, r0


	ldr		r0, =IntTable
	mov		r1, #0x00000000

	// load the first 8 words and store at the 0 address
	ldmia	r0!, {r2-r9}
	stmia	r1!, {r2-r9}

	// load the second 8 words and store at the next address
	ldmia	r0!, {r2-r9}
	stmia	r1!, {r2-r9}
	
	// Enable IRQ
	//mrs		r0, cpsr
	//bic		r0, #0x80
	//msr		cpsr_c, r0

	pop		{r4-r10, r14}
	bx		lr	




/*Interrupt_Setup function
 *	enables interrupts to be sent from the clock
 */
.global Interrupt_Setup
Interrupt_Setup:

	push	{r4-r10, r14}
	
	//set the time for C1
	bl		Interrupt_Update_Time
	
	// enable C1 IRQ lines on Interrupt Controller
	ldr		r0, =0x3F00B210
	mov		r1, #2 					//second bit set
	str		r1, [r0]
	
	// disable all other IRQ lines on Interrupt Controller
	ldr		r0, =0x3F00B214
	mov		r1, #0
	str		r1, [r0]
	
	// Enable IRQ
	mrs		r0, cpsr
	bic		r0, #0x80
	msr		cpsr_c, r0
	
	pop		{r4-r10, r14}
	bx		lr




/*irq function
 *	handler for interrupt sent by the clock to place value pack onto the game board
 */
irq:
	push	{r0-r12, lr}


	irqTest:
	
	// Disable IRQ (and FIQ)
	//mrs		r0, cpsr
	//orr		r0, #0xC0
	//msr		cpsr_c, r0

	// test that the interrupt came from the clock compare line (in pending 1) 
	ldr		r0, =0x3F00B204
	ldr		r1, [r0]
	and		r2, r1, #2
	cmp		r2, #0
	//tst		r1, #2
	beq		irqEnd

	//if the game is paused or in the main menu, do not spawn a value pack
	ldr		r0, =Game_Running_Flag
	ldrb	r1, [r0]
	cmp		r1, #0
	beq		irqEnd
	
	bl		Value_Pack_Spawn
	
	irqEnd:
	
	// reset the CS timer control status for C1
	ldr		r0, =0x3F003000
	ldr		r2, [r0]
	mov		r1, #2
	str		r1, [r0]
	
	// enable C1 IRQ lines on Interrupt Controller
	//ldr		r0, =0x3F00B210
	//mov		r1, #2 					//second bit set
	//str		r1, [r0]
	
	// disable all other IRQ lines on Interrupt Controller
	//ldr		r0, =0x3F00B214
	//mov		r1, #0
	//str		r1, [r0]
	
	//bl		Interrupt_Reinstall_Table
	bl			Interrupt_Setup
	
	// Enable IRQ
	//mrs		r0, cpsr
	//bic		r0, #0x80
	//msr		cpsr_c, r0
	
	pop		{r0-r12, lr}
	subs	pc, lr, #4
	





/*Interrupt_Update_Time function
 *	updates the time to compare in C1 based on the current time
 */
.global Interrupt_Update_Time
Interrupt_Update_Time:

	cmpAdd	.req r0
	cmpCon	.req r1
	clkAdd	.req r2
	clkCon	.req r3
	intDel	.req r4

	push	{r4-r10, r14}
	
	//get the address of the C1 time compare register
	ldr		cmpAdd, =0x3F003010
	
	//set the time to compare to be current + 20 seconds
	ldr		intDel, =interrupt_Delay
	ldr		clkAdd, =0x3F003004
	ldr		clkCon, [clkAdd]
	add		cmpCon, clkCon, intDel 
	str		cmpCon, [cmpAdd]
	
	pop		{r4-r10, r14}
	bx		lr


//if an unknown exception occures, simply ignore it
ignore:
	//subs	pc, r14, #4
	b		ignore
	
ignore1:
	subs	pc, r14, #0
	
ignore2:
	subs	pc, r14, #0
	
ignore3:
	subs	pc, r14, #4
	
ignore4:
	subs	pc, r14, #8
	
ignore5:
	subs	pc, r14, #0
	
ignore6:
	subs	pc, r14, #8



.section	.data
//interupt table from tutorial 9 solution
IntTable:
	// Interrupt Vector Table (16 words)
	ldr		pc, reset_handler
	ldr		pc, undefined_handler
	ldr		pc, swi_handler
	ldr		pc, prefetch_handler
	ldr		pc, data_handler
	ldr		pc, unused_handler
	ldr		pc, irq_handler
	ldr		pc, fiq_handler

reset_handler:		.word Interrupt_Install_Table
undefined_handler:	.word ignore1
swi_handler:		.word ignore2
prefetch_handler:	.word ignore3
data_handler:		.word ignore4
unused_handler:		.word ignore5
irq_handler:		.word irq
fiq_handler:		.word 
