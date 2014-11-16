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

