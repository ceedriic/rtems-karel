/**
 * @file
 *
 * @ingroup mpc55xx_asm
 *
 * @brief Flash configuration.
 */

/*
 * Copyright (c) 2008-2015 embedded brains GmbH.  All rights reserved.
 *
 * The license and distribution terms for this file may be
 * found in the file LICENSE in this distribution or at
 * http://www.rtems.org/license/LICENSE.
 */

#include <libcpu/powerpc-utility.h>
#include <mpc55xx/reg-defs.h>

	.section	".bsp_start_text", "ax"

#if MPC55XX_CHIP_FAMILY == 551

/* MPC5510 Microcontroller Family Data Sheet, Rev. 3, Table 16, Num 7 */
.equ FLASH_CLOCK_0, 25000000
.equ FLASH_CLOCK_1, 50000000
.equ FLASH_CLOCK_2, 80000000
.equ FLASH_CLOCK_3, FLASH_CLOCK_2
.equ FLASH_SETTINGS_0, FLASH_BUICR_CPU_PREFTCH | FLASH_BUICR_APC_0 | FLASH_BUICR_RWSC_0 | FLASH_BUICR_WWSC_1 | FLASH_BUICR_DPFEN_1 | FLASH_BUICR_IPFEN_1 | FLASH_BUICR_PFLIM_2 | FLASH_BUICR_BFEN
.equ FLASH_SETTINGS_1, FLASH_BUICR_CPU_PREFTCH | FLASH_BUICR_APC_1 | FLASH_BUICR_RWSC_1 | FLASH_BUICR_WWSC_1 | FLASH_BUICR_DPFEN_1 | FLASH_BUICR_IPFEN_1 | FLASH_BUICR_PFLIM_2 | FLASH_BUICR_BFEN
.equ FLASH_SETTINGS_2, FLASH_BUICR_CPU_PREFTCH | FLASH_BUICR_APC_2 | FLASH_BUICR_RWSC_2 | FLASH_BUICR_WWSC_1 | FLASH_BUICR_DPFEN_1 | FLASH_BUICR_IPFEN_1 | FLASH_BUICR_PFLIM_2 | FLASH_BUICR_BFEN
.equ FLASH_SETTINGS_3, FLASH_SETTINGS_2

#else

/* Optimized flash configurations (Table 13-15 [MPC5567 Microcontroller Reference Manual]) */
.equ FLASH_CLOCK_0, 82000000
.equ FLASH_CLOCK_1, 102000000
.equ FLASH_CLOCK_2, 132000000
.equ FLASH_CLOCK_3, 264000000
.equ FLASH_SETTINGS_0, FLASH_BUICR_CPU_PREFTCH | FLASH_BUICR_APC_1 | FLASH_BUICR_RWSC_1 | FLASH_BUICR_WWSC_1 | FLASH_BUICR_DPFEN_3 | FLASH_BUICR_IPFEN_3 | FLASH_BUICR_PFLIM_6 | FLASH_BUICR_BFEN
.equ FLASH_SETTINGS_1, FLASH_BUICR_CPU_PREFTCH | FLASH_BUICR_APC_1 | FLASH_BUICR_RWSC_2 | FLASH_BUICR_WWSC_1 | FLASH_BUICR_DPFEN_3 | FLASH_BUICR_IPFEN_3 | FLASH_BUICR_PFLIM_6 | FLASH_BUICR_BFEN
.equ FLASH_SETTINGS_2, FLASH_BUICR_CPU_PREFTCH | FLASH_BUICR_APC_2 | FLASH_BUICR_RWSC_3 | FLASH_BUICR_WWSC_1 | FLASH_BUICR_DPFEN_3 | FLASH_BUICR_IPFEN_3 | FLASH_BUICR_PFLIM_6 | FLASH_BUICR_BFEN
.equ FLASH_SETTINGS_3, 0x01716B15

#endif

/**
 * @fn void mpc55xx_start_flash()
 * @brief Optimized flash configuration.
 * @warning Code will be copied and executed on the stack.
 */
GLOBAL_FUNCTION mpc55xx_start_flash
#if !defined(MPC55XX_NEEDS_LOW_LEVEL_INIT) \
  || MPC55XX_CHIP_FAMILY == 564 \
  || MPC55XX_CHIP_FAMILY == 566
	blr
#else
	.equ	stack_size, 20
	.equ	lr_offset, 28

	/* Reserve stack frame */
	stwu	r1, -stack_size(r1)
	mflr	r0
	stw	r0, lr_offset(r1)

	/* Flash settings dependent on system clock */
	bl	mpc55xx_get_system_clock
	LWI	r4, FLASH_CLOCK_0
	cmpw	r3, r4
	ble	clock_0
	LWI	r4, FLASH_CLOCK_1
	cmpw	r3, r4
	ble	clock_1
	LWI	r4, FLASH_CLOCK_2
	cmpw	r3, r4
	ble	clock_2
	LWI	r4, FLASH_CLOCK_3
	cmpw	r3, r4
	ble	clock_3

	/*
	 * In case we don't have the right flash settings for the system clock
	 * value, then rely on the BAM settings.
	 */
	blr

clock_0:
	LWI	r3, FLASH_SETTINGS_0
	b	settings_done
clock_1:
	LWI	r3, FLASH_SETTINGS_1
	b	settings_done
clock_2:
	LWI	r3, FLASH_SETTINGS_2
	b settings_done
clock_3:
	LWI	r3, FLASH_SETTINGS_3
	b	settings_done
settings_done:

	/* Copy store code on the stack */
	LA	r4, store_start
	lwz	r6, 0(r4)
	lwz	r7, 4(r4)
	lwz	r8, 8(r4)
	stw	r6, 8(r1)
	stw	r7, 12(r1)
	stw	r8, 16(r1)

	/* Execute store code */
	LA	r4, FLASH_BIUCR
	addi	r5, r1, 8
	mtctr	r5
	bctrl

	/* Return */
	lwz	r0, lr_offset(r1)
	addi	r1, r1, stack_size
	mtlr	r0
	blr

/*
 * Store flash settings
 */

store_start:

	stw	r3, 0(r4)
	isync
	blr

#endif
