	.text
	.align 2
	.globl _main
_main:
; Prolog----------------------------
	mflr r0
	stw r0,8(r1) ; save LR in linkage area (as it is not preserved by functions we call)
	stwu r1,-64(r1) ; create stack frame for our callee
; ----------------------------
; Load 32 bit address
	addis r3,0,hi16(hw)
	ori r3,r3,lo16(hw)
	bl _puts 
; return value
	li r3,0

; epilog----------------------------
	addi r1,r1,64 ; remove stack frame
	lwz r0,8(r1)
	mtlr r0 ; restore LR (return address) 
	blr
; ----------------------------
	.cstring
hw:	.asciz	"Hello, world."

