	.global _start
_start:
	MOV R1, #35
        MOV R2, #5
	MOV R3, #0
loop:
	MOV R4, R1
	SUBS R1, R1, R2
	ADD R3, R3, #1
	BMI sremain
	BEQ szero
	BNE loop
szero:
	MOV R0, R3
	MOV R7, #1
	SWI 0
sremain:
	MOV R0, R4
	MOV R7, #1
	SWI 0
	
