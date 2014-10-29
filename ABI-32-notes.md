Writing PowerPC assembler for OS X

ABI compatibility

Register use

* parameters are passed in GPR3-10, FPR1-13, V2-13
** UNLESS return type is composite (non-scalar), in which case GPR3 is a pointer to space for the returned value, and parameters start at GPR4
* additional parameters are passed in stack frame
* callee can choose to use the linkage area to preserve LR, CR, SP
* return value is placed in GPR3 if scalar
* long long values are returned in GPR3/GPR4
* floating point values are returned in FPR1

X = preserve. If function wants to use this register, store in stack frame (or red zone if leaf),
    and restore on exit. (Because the highest numbered registers are preserved, the
    lmw and stmw instructions can be used to store multiple consecutive registers.)
P = parameter. Not preserved. Use freely.
- = scratch. Use freely.

GPR  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
     -  X  - P*  P  P  P  P  P  P  P X*  -  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X
FPR  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
     -  P  P  P  P  P  P  P  P  P  P  P  P  P  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X
V    0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
     -  -  P  P  P  P  P  P  P  P  P  P  P  P  -  -  -  -  -  -  X  X  X  X  X  X  X  X  X  X  X  X
CR   0  1  2  3  4  5  6  7
     -  -  X  X  X  -  -  -
Not preserved: LR, CTR, XER

Stack frame
* Leaf functions (those that make no calls) can use the 224 byte "red zone" under SP for local variables, and to preserve registers
* If they need more than that, they need a stack frame
* Ordinary functions must setup a stack frame for callees


