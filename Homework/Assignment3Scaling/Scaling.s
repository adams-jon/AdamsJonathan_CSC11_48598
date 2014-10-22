/* 
Adams, Jonathan
September 29th, 2014
Scaling for Division
r0 = counter for a/b
r1 = remainder, set by flag
r2 = a
r3 = b
r4 = flag
r5 = temp for swap of flag
r6 = preset scale value of 10
r7 = scale factor (r3*r6) to subtract
r8 = shift factor 10
r9 = shift test r7*r8
*/

.global main

main:
	@initialize
		@numbers being divided:
	mov r2, #256  @numerator
	mov r3, #12  @denominator
		@other variables
	mov r0, #0
	mov r1, r2
	mov r4, #0
	mov r5, #0
	mov r6, #0
	mov r7, #0
	mov r8, #10
	mov r9, #0
	@is division necessarry? 
	cmp r1, r3
	@yes, division is necessarry; perform first scale operation
	bge scale	
	BX LR @division not possible


check:
	cmp r6, #1  @Has scale gone down to 1?
	bgt scale   @If not, go back to scale to find next factor to divide by
	ble exit    @If Yes, division is complete, go to exit


divider:
	add r0, r0, r6  @Add our scale to the counter
	sub r1, r1, r7  @Subtract value from numerator
	cmp r1, r7      @Is numerator still larger than value subtracted?
	bge divider     @If so, try to subtract one more factor
	blt check       @If not, go to check
	

scale:
	mov r6, #1 	@start/reset scale at 1
	mul r7, r3, r6  @multiple scale by denominator
	mul r9, r7, r8  @multiple above result by 10, to be compared to numerator
	cmp r1, r9	@Is numerator larger than our scale(x10) AKA Can we scale further?
	bgt scaleup     @If yes, then go to scale up
	ble divider     @If no, begin division
	
	scaleup:
	mov r10, r6          @Placeholder of r6 value, to use in mul
	mul r6, r10, r8      @Multiple actual scale factor by 10
	mul r7, r3, r6       @Now multiple new scale factor by numerator
	mul r9, r7, r8       @Multiply by 10 again, to see if possible to divide into numerator
	cmp r1, r9           @Compare numerator to new test(r9)
	bgt scaleup          @If yes, then repeat scaleup process
	ble divider          @If no, begin division with multi scaled up #


exit:
	cmp r1, #0      @Did r1 get to zero?
	beq wholenum	@If yes, the numerator was divisible by the denominator and the division answer is a whole #
	bne remainder   @If no, there was a remainder


wholenum:
	BX LR  @Exit with division wholenumber solution stored in r0


remainder:
        @Store remainder value into r0, while also storing the wholenum value into r1
	mov r5, r0
	mov r0, r1
	mov r1, r5
	BX LR	
