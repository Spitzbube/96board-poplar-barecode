/******************************************************************************
 *    Copyright (C) 2014 Hisilicon STB Development Dept
 *    All rights reserved.
 * ***
 *    Create by Cai Zhiyong
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *   http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Come from : LLVM compiler-rt-master/lib/arm/divsi3.S
 * URL : https://github.com/llvm-mirror/compiler-rt/archive/master.zip
******************************************************************************/

/*===-- divsi3.S - 32-bit signed integer divide ---------------------------===//
 *
 *                     The LLVM Compiler Infrastructure
 *
 * This file is dual licensed under the MIT and the University of Illinois Open
 * Source Licenses. See LICENSE.TXT for details.
 *
 *===----------------------------------------------------------------------===//
 *
 * This file implements the __divsi3 (32-bit signed integer divide) function
 * for the ARM architecture as a wrapper around the unsigned routine.
 *
 *===----------------------------------------------------------------------===*/

#include "assembly.h"

#define ESTABLISH_FRAME \
    push   {r4, r7, lr}    ;\
    add     r7,     sp, #4
#define CLEAR_FRAME_AND_RETURN \
    pop    {r4, r7, pc}

.syntax unified
.align 3
DEFINE_AEABI_FUNCTION_ALIAS(__aeabi_idiv, __divsi3)
DEFINE_COMPILERRT_FUNCTION(__divsi3)
#if __ARM_ARCH_7S__
   tst     r1,r1
   beq     LOCAL_LABEL(divzero)
   sdiv    r0, r0, r1
   bx      lr
LOCAL_LABEL(divzero):
   mov     r0,#0
   bx      lr
#else
ESTABLISH_FRAME
    eor     r4,     r0, r1
    eor     r2,     r0, r0, asr #31
    eor     r3,     r1, r1, asr #31
    sub     r0,     r2, r0, asr #31
    sub     r1,     r3, r1, asr #31
    bl      SYMBOL_NAME(__udivsi3)
    eor     r0,     r0, r4, asr #31
    sub     r0,     r0, r4, asr #31
    CLEAR_FRAME_AND_RETURN
#endif
