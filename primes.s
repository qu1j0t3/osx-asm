;    This file is part of osx-asm, PowerPC assembler experiments
;    Copyright (C) 2014 Toby Thain, toby@telegraphics.com.au
;
;    This program is free software; you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation; either version 2 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program; if not, write to the Free Software
;    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

; Knuth's primes, Algorithm P from TAOCP Vol. 1
	.text
	.align 2
	.globl _main
	nprimes = 500
	cols = 10
	rows = 50
_main:
; Prolog----------------------------
	mflr r0
	stw r0,8(r1) ; save LR in linkage area (as it is not preserved by functions we call)
; ----------------------------
; Variables
; r31: N
; r30: J
; r29: base register to index PRIMES array (500 halfwords)
; r28: pointer to PRIMES[J-1]
; r27: pointer to PRIMES[K-1]
;      local stack must be allocated above callee stack frame
	addi r1,r1,-nprimes*2
	mr r29,r1
	mr r28,r1
; ----------------------------
	stwu r1,-64(r1) ; create stack frame for callees
; ----------------------------
; P1. Start table.
	li r0,2
	sthu r0,2(r28) ; "pre-increment" and store halfword 
	li r31,3
	li r30,1
; P2. N is prime.
p2:
	addi r30,r30,1
	sthu r31,2(r28)
; P3. All found?
	cmpwi r30,nprimes
	beq p9
; P4. Advance N.
p4:
	addi r31,r31,2
; P5. K <- 2.
	mr r27,r29
	addi r27,r27,2
; P6. PRIME[K]\N?
p6:
	lhzu r4,2(r27) ; load PRIMES[K] into r4
	divwu r5,r31,r4 ; quotient is in r5
	mullw r6,r5,r4 ; multiply quotient by N
	cmpw r6,r31 ; if it was a divisor, these will be equal (zero remainder)
	beq p4
; P7. PRIME[K] large?
	cmpw r5,r4
	ble p2
; P8. Advance K (r27 was already updated, so nothing to do)
	b p6

; P9. Print title
; From now on we are going to cheat horribly, using stdlib for IO
p9:
	addis r3,0,hi16(title)
	ori r3,r3,lo16(title)
	bl _puts 

; Set up nested loops. Must use preserved registers
; because we make subroutine calls.
	li r31,1 ; row counter
row:
	li r30,0 ; column counter
col:
	; compute index into PRIMES array
	; PRIMES[ r + c*rows ]
	li r6,rows
	mullw r6,r6,r30
	add r6,r6,r31
	add r6,r6,r6 ; *2 to address by halfwords
	
	addis r3,0,hi16(fmt)
	ori r3,r3,lo16(fmt)
	lhzx r4,r29,r6
	bl _printf

	addi r30,r30,1
	cmpwi r30,cols
	blt col

; finished row
	li r3,012 ; newline
	bl _putchar

	addi r31,r31,1
	cmpwi r31,rows
	ble row

; ----------------------------
; Program exit status
	li r3,0

; epilog----------------------------
	addi r1,r1,64+2*nprimes ; pop stack frame
	lwz r0,8(r1)
	mtlr r0 ; restore LR (return address) 
	blr
; ----------------------------
	.cstring
title:	.asciz "First five hundred primes"
fmt:	.asciz "%04d "

