	.text
	.align 2
	.globl _main
_main:
; Prolog----------------------------
	mflr r0
	stw r0,8(r1) ; save LR in linkage area (as it is not preserved by functions we call)
	stwu r1,-64(r1) ; create stack frame for our callee
; ----------------------------
	li r31,'A
letter:
	mr r3,r31
	bl _putchar
	cmpli 0,0,r31,'Z
	beq done
	addi r31,r31,1
	b letter
done:
	li r3,012
	bl _putchar
; return value
	li r3,0

; epilog----------------------------
	addi r1,r1,64 ; remove stack frame
	lwz r0,8(r1)
	mtlr r0 ; restore LR (return address) 
	blr
; ----------------------------
