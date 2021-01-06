# vim: set ts=8 :

.text
.set noreorder
.set noat
.globl start

#include "asm.h"

start:
	mtlo	zero

_b0004:
	mflo	t0
	addi	t0,t0,1
	mtlo	t0
	li	at,11
	bne	t0,at,intc_mask_irqs
	  nop

rtc_poweroff:
	/* Power OFF the SoC */
	lui	t1,0xb000
	ori	t1,t1,0x3020
	li	t0,1
	sw	t0,0(t1)

intc_mask_irqs:
	/* Mask IRQs (write 0xffffffff to ICMSR0. ICMSR1 not written) */
	lui	t1,0xb000
	ori	t1,t1,0x1008
	lui	t0,0xffff
	ori	t0,t0,0xffff
	sw	t0,0(t1)

	/* $gp contains the cache address */
	lui	gp,0x8000

	/* $sp contains the base address for GPIO/pinctrl registers */
	lui	sp,0xb001

	/* $s8 contains the base address for NEMC registers */
	lui	s8,0xb341
	lui	t1,0xe

	/* Disable pull-over registers on boot_sel[2,1,0] pins */
	sw	t1,824(sp)

	/* Read boot_sel[2,1,0] pins to s5 */
	lw	t1,768(sp)
	srl	t1,t1,0x11
	andi	s5,t1,0x7

	/* If boot_sel[2,1,0] == 3 -> NOR boot, SPI CS #4 */
	li	t1,3
	beq	s5,t1,spi0_boot_cs4
	  nop

	/*
	 * Set KSEG0 cacheability:
	 * cacheable, non-coherent, write-back, write-allocate
	 */
	li	v0,3
	mtc0	v0,$16
	nop

	/*
	 * Set CP0.ErrCtl.SPR bit to enable CACHE accesses to the optional
	 * scratchpad RAMs. When this bit is set, Index Load Tag, Index Store Tag,
	 * and Index Store Data CACHE instructions will send reads or writes to the
	 * scratchpad RAM port. The effects of these operations are dependent on
	 * the particular scratchpad implementation.
	 */
	lui	v0,0x2000
	mtc0	v0,$26

	ori	v0,gp,0x0
	ori	v1,v0,0x3fe0

	/* Clear CP0.Taglo register */
	mtc0	zero,$28
	.word	0x4080e001

l1_cache_prepare_loop:
	cache	Index_Store_Tag_I,0(v0)
	cache	Index_Store_Tag_D,0(v0)
	bne	v0,v1,l1_cache_prepare_loop
	  addiu	v0,v0,32
	ori	v0,gp,0x0
	ori	v1,v0,0x3fe0
	lui	a0,0x1fff
	ori	a0,a0,0xf000

_b00b0:
	and	a1,v0,a0
	ori	a1,a1,0x1
	mtc0	a1,$28
	cache	Index_Store_Tag_I,0(v0)
	cache	Index_Store_Tag_D,0(v0)
	bne	v0,v1,_b00b0
	  addiu	v0,v0,32

	/* If boot_sel[2,1,0] == 4 -> NAND boot, CS #1 */
	li	t0,7
	beq	s5,t0,nand_boot_cs1
	  nop

	/* If boot_sel[2,1,0] == 4 -> SD boot, MSC0 */
	li	t0,4
	beq	s5,t0,msc0_boot
	  nop

	/* If boot_sel[2,1,0] == 5 -> NOR boot, SPI CS #0 */
	li	t0,5
	beq	s5,t0,spi0_boot_cs0
	  nop
	b	usb_boot
	  nop

_b00f8:
	ori	v0,gp,0x0
	add	v1,v0,s3
	addiu	v1,v1,-4

_b0104:
	lw	a0,0(v0)
	.word	0x4084e001
	cache	0xc,0(v0)
	bne	v0,v1,_b0104
	  addiu	v0,v0,4
	mtc0	zero,$26
	jalr	s4
	  nop
	b	_b1240
	  nop

spi0_boot_cs4:
	lui	t1,0x40
	sw	t1,20(sp)
	lui	t1,0x843
	ori	t1,t1,0xff
	sw	t1,68(sp)
	sw	t1,88(sp)
	sw	t1,52(sp)
	li	t1,63
	sw	t1,324(sp)
	sw	t1,344(sp)
	sw	t1,308(sp)
	lui	t3,0xfff
	ori	t3,t3,0x7700
	lui	t4,0xb800
	lbu	t0,0(t4)
	beqz	t0,_b0194
	  nop
	li	t1,16
	bne	t1,t0,usb_boot
	  nop
	li	t2,0xffff
	sw	t2,68(sp)
	sw	t2,88(sp)
	sw	t2,52(sp)
	lui	t3,0xfff
	ori	t3,t3,0x7740

_b0194:
	sw	t3,24(s8)
	addiu	t4,t4,4
	jr	t4
	  nop

ssi0_disable:
	/* Enable pull-over resistors for ssi0-a (PA18->PA21) */
	lui	t1,0x3c
	sw	t1,56(sp)

	/* Disable SSI0 (clear bit 15 of SSICR0) */
	lhu	t1,4(k1)
	li	t0,32767
	and	t1,t1,t0
	sh	t1,4(k1)
	jr	ra
	  nop

spi0_wait_rfifo_empty:
	li	t0,0xffff

_b01c8:
	/* Wait for the SPI0 receive FIFO to be empty */
	beqz	t0,_b01e0
	  addi	t0,t0,-1
	lw	t1,12(k1)
	andi	t1,t1,0x10
	bnez	t1,_b01c8
	  nop

_b01e0:
	jr	ra
	  nop

spi0_boot_cs0:
	lui	k1,0xb004
	ori	k1,k1,0x3000
	lui	t1,0x2c
	sw	t1,68(sp)
	sw	t1,116(sp)
	sw	t1,88(sp)
	lui	t1,0x10
	sw	t1,68(sp)
	sw	t1,120(sp)
	sw	t1,84(sp)
	li	t1,11
	sw	t1,24(k1)
	lui	t1,0x3c00
	ori	t1,t1,0x60
	sw	t1,8(k1)
	li	t1,0x8086
	sw	t1,4(k1)
	lui	t1,0x3c
	sw	t1,52(sp)
	lw	t1,8(k1)
	lui	t0,0x80
	or	t0,t0,t1
	sw	t0,8(k1)
	li	t1,3
	sb	t1,0(k1)
	sb	zero,0(k1)
	sb	zero,0(k1)
	sb	zero,0(k1)
	sb	zero,0(k1)
	li	a3,0xffff

_b0260:
	beqz	a3,_b02d0
	  addi	a3,a3,-1
	lw	t1,12(k1)
	srl	t1,t1,0x8
	andi	t1,t1,0xff
	li	t0,5
	bne	t1,t0,_b0260
	  nop
	lw	t1,4(k1)
	ori	t1,t1,0x6
	sw	t1,4(k1)

_b028c:
	lw	t1,12(k1)
	andi	t1,t1,0x10
	beqz	t1,_b028c
	  nop
	sb	zero,0(k1)
	jal	spi0_wait_rfifo_empty
	  nop
	lbu	v1,0(k1)
	li	t0,4
	beq	v1,t0,_b02e0
	  nop
	li	t0,3
	beq	v1,t0,_b02f0
	  nop
	li	t0,2
	beq	v1,t0,_b0300
	  nop

_b02d0:
	jal	ssi0_disable
	  nop
	b	usb_boot
	  nop

_b02e0:
	sb	zero,0(k1)
	jal	spi0_wait_rfifo_empty
	  nop
	lbu	t1,0(k1)

_b02f0:
	sb	zero,0(k1)
	jal	spi0_wait_rfifo_empty
	  nop
	lbu	t1,0(k1)

_b0300:
	sb	zero,0(k1)
	jal	spi0_wait_rfifo_empty
	  nop
	lbu	t1,0(k1)
	li	t0,85
	bne	t1,t0,_b02d0
	  nop
	sb	zero,0(k1)
	jal	spi0_wait_rfifo_empty
	  nop
	lbu	t1,0(k1)
	li	t0,170
	bne	t1,t0,_b02d0
	  nop
	sb	zero,0(k1)
	jal	spi0_wait_rfifo_empty
	  nop
	lbu	t1,0(k1)
	li	t0,85
	bne	t1,t0,_b02d0
	  nop
	sb	zero,0(k1)
	jal	spi0_wait_rfifo_empty
	  nop
	lbu	t1,0(k1)
	li	t0,170
	bne	t1,t0,_b02d0
	  nop
	sb	zero,0(k1)
	jal	spi0_wait_rfifo_empty
	  nop
	lbu	t2,0(k1)
	jal	ssi0_disable
	  nop
	sb	t2,24(k1)
	lhu	t1,4(k1)
	li	t0,0x8000
	or	t1,t1,t0
	sh	t1,4(k1)
	lui	t1,0x3c
	sw	t1,52(sp)
	li	t1,3
	sb	t1,0(k1)
	sb	zero,0(k1)
	sb	zero,0(k1)
	li	t0,2
	beq	v1,t0,_b03d4
	  nop
	sb	zero,0(k1)
	li	t0,3
	beq	v1,t0,_b03d4
	  nop
	sb	zero,0(k1)

_b03d4:
	lw	t1,12(k1)
	srl	t1,t1,0x8
	andi	t1,t1,0xff
	addi	t0,v1,1
	bne	t1,t0,_b03d4
	  nop
	lw	t1,4(k1)
	ori	t1,t1,0x6
	sw	t1,4(k1)

_b03f8:
	lw	t1,12(k1)
	andi	t1,t1,0x10
	beqz	t1,_b03f8
	  nop
	move	v0,gp
	li	a3,63

_b0410:
	li	t2,128

_b0414:
	sw	zero,0(k1)
	nop
	addi	t2,t2,-1
	bnez	t2,_b0414
	  nop

_b0428:
	lw	t1,12(k1)
	srl	t1,t1,0x8
	andi	t1,t1,0xff
	li	t0,128
	bne	t1,t0,_b0428
	  nop
	li	t2,127

_b0444:
	lbu	t1,0(k1)
	sb	t1,0(v0)
	addi	v0,v0,1
	bnez	t2,_b0444
	  addi	t2,t2,-1
	bnez	a3,_b0410
	  addi	a3,a3,-1
	jal	ssi0_disable
	  nop
	li	s3,8192
	b	_b00f8
	  ori	s4,gp,0x8

_b0474:
.skip	0x80

_b04f4:
	lw	s4,0(sp)
	srl	s4,s4,0x14
	andi	s4,s4,0x1
	beqz	s4,_b04f4
	  nop
	jr	ra
	  nop

_b0510:
	li	t0,0
	ori	t1,t5,0x0
	bnez	s7,_b0544
	  nop

_b0520:
	lbu	t2,0(k0)
	sb	t2,0(t1)
	addi	t1,t1,1
	addi	t0,t0,1
	li	at,160
	bne	t0,at,_b0520
	  nop
	b	_b0560
	  nop

_b0544:
	lhu	t2,0(k0)
	sh	t2,0(t1)
	addi	t1,t1,2
	addi	t0,t0,2
	li	at,160
	bne	t0,at,_b0544
	  nop

_b0560:
	jr	ra
	  nop

_b0568:
	li	t0,0
	li	t3,0
	li	t4,0
	add	t1,t5,a3

_b0578:
	lbu	t2,0(t1)
	li	at,85
	bne	t2,at,_b058c
	  nop
	addi	t3,t3,1

_b058c:
	li	at,170
	bne	t2,at,_b059c
	  nop
	addi	t4,t4,1

_b059c:
	addi	t0,t0,1
	addi	t1,t1,1
	li	at,32
	bne	t0,at,_b0578
	  nop
	addi	t3,t3,-7
	bgtz	t3,_b05d4
	  nop
	addi	t4,t4,-7
	bgtz	t4,_b05e0
	  nop
	li	t7,255
	jr	ra
	  nop

_b05d4:
	li	t7,85
	jr	ra
	  nop

_b05e0:
	li	t7,170
	jr	ra
	  nop

_b05ec:
	srl	t1,t3,0x1
	sll	t1,t1,0x2
	addi	t1,t1,60
	add	t1,t1,t6
	lw	t2,0(t1)
	andi	t1,t3,0x1
	beqz	t1,_b0610
	  nop
	srl	t2,t2,0x10

_b0610:
	andi	t2,t2,0x1fff
	addiu	t1,t2,-2048
	bgtz	t1,_b0650
	  nop
	beqz	t2,_b0650
	  nop
	addi	t2,t2,-1
	srl	t1,t2,0x3
	andi	t2,t2,0x7
	sub	t4,v0,s0
	add	t1,t1,t4
	lbu	t3,0(t1)
	li	t5,1
	sllv	t5,t5,t2
	xor	t3,t3,t5
	sb	t3,0(t1)

_b0650:
	jr	ra
	  nop

nand_boot_cs1:
	lui	t6,0xb34d
	li	t1,255
	sw	t1,68(sp)
	sw	t1,88(sp)
	lui	t1,0x2c
	sw	t1,68(sp)
	sw	t1,88(sp)
	sw	t1,52(sp)
	li	t1,3
	sw	t1,324(sp)
	sw	t1,344(sp)
	sw	t1,308(sp)
	lui	t1,0x10
	sw	t1,72(sp)
	sw	t1,88(sp)
	sw	t1,104(sp)
	lui	t1,0xfff
	ori	t1,t1,0x7700
	sw	t1,20(s8)
	li	t1,3
	sw	t1,80(s8)
	lui	t8,0xba80
	lui	t9,0xba40
	lui	k0,0xba00
	li	a1,0

_b06bc:
	addiu	t1,a1,-1280
	bgtz	t1,usb_boot
	  nop
	li	t1,255
	sb	t1,0(t9)
	jal	_b0474
	  nop
	li	k1,48
	li	s5,0
	li	s7,0
	lui	t5,0x8000
	ori	t5,t5,0x2800

_b06ec:
	sb	zero,0(t9)
	beqz	s5,_b06fc
	  sb	zero,0(t8)
	sb	zero,0(t8)

_b06fc:
	sb	a1,0(t8)
	srl	t1,a1,0x8
	sb	t1,0(t8)
	srl	t1,a1,0x10
	sb	t1,0(t8)
	beqz	s5,_b071c
	  nop
	sb	k1,0(t9)

_b071c:
	jal	_b0474
	  nop
	jal	_b0510
	  nop
	li	a3,0
	jal	_b0568
	  nop
	li	at,85
	beq	t7,at,_b0768
	  nop
	li	at,170
	beq	t7,at,_b0774
	  nop
	beqz	s5,_b0760
	  nop
	b	_b06bc
	  addiu	a1,a1,64

_b0760:
	b	_b06ec
	  li	s5,1

_b0768:
	li	s7,0
	b	_b0778
	  nop

_b0774:
	li	s7,1

_b0778:
	beqz	s7,_b07d8
	  nop
	lui	t1,0xfff
	ori	t1,t1,0x7740
	sw	t1,20(s8)
	li	t1,0xffff
	sw	t1,68(sp)
	sw	t1,88(sp)
	sb	zero,0(t9)
	beqz	s5,_b07a8
	  sb	zero,0(t8)
	sb	zero,0(t8)

_b07a8:
	sb	a1,0(t8)
	srl	t1,a1,0x8
	sb	t1,0(t8)
	srl	t1,a1,0x10
	sb	t1,0(t8)
	beqz	s5,_b07c8
	  nop
	sb	k1,0(t9)

_b07c8:
	jal	_b0474
	  nop
	jal	_b0510
	  nop

_b07d8:
	li	a3,64
	jal	_b0568
	  nop
	li	at,170
	beq	t7,at,_b07fc
	  nop
	li	s6,0
	b	_b0800
	  nop

_b07fc:
	li	s6,1

_b0800:
	li	a3,96
	jal	_b0568
	  nop
	addu	s0,t7,zero
	li	a3,128
	jal	_b0568
	  nop
	li	at,170
	beq	s0,at,_b084c
	  nop
	li	at,170
	beq	t7,at,_b0840
	  nop
	li	s5,0
	b	_b0868
	  nop

_b0840:
	li	s5,1
	b	_b0868
	  nop

_b084c:
	li	at,170
	beq	t7,at,_b0864
	  nop
	li	s5,2
	b	_b0868
	  nop

_b0864:
	li	s5,3

_b0868:
	b	_b0870
	  nop

_b0870:
	li	s0,256
	li	s1,2
	li	s2,78
	li	s3,16
	beqz	s5,_b08c4
	  nop
	li	s1,8
	li	s2,312
	li	s3,4
	li	at,1
	beq	s5,at,_b08c4
	  nop
	li	s1,16
	li	s2,624
	li	s3,2
	li	at,2
	beq	s5,at,_b08c4
	  nop
	li	s1,32
	li	s2,1248
	li	s3,1

_b08c4:
	ori	v0,gp,0x0
	addiu	t0,gp,12288
	beqz	s7,_b08dc
	  nop
	b	_b0be4
	  nop

_b08dc:
	li	a2,1

_b08e0:
	sb	zero,0(t9)
	beqz	s5,_b08f0
	  sb	zero,0(t8)
	sb	zero,0(t8)

_b08f0:
	addi	t1,a1,1
	sb	t1,0(t8)
	srl	a0,t1,0x8
	beqz	s6,_b090c
	  sb	a0,0(t8)
	srl	a0,t1,0x10
	sb	a0,0(t8)

_b090c:
	beqz	s5,_b0918
	  nop
	sb	k1,0(t9)

_b0918:
	jal	_b0474
	  nop
	li	v1,1
	ori	t1,t0,0x0
	li	t2,3
	sw	t2,256(s8)

_b0930:
	lbu	a0,0(k0)
	sb	a0,0(t1)
	addiu	t1,t1,1
	bne	v1,s2,_b0930
	  addiu	v1,v1,1
	sw	zero,256(s8)
	sw	zero,80(s8)
	li	t1,3
	sw	t1,80(s8)
	nop
	nop
	sb	zero,0(t9)
	beqz	s5,_b096c
	  sb	zero,0(t8)
	sb	zero,0(t8)

_b096c:
	sb	a1,0(t8)
	srl	a0,a1,0x8
	beqz	s6,_b0984
	  sb	a0,0(t8)
	srl	a0,a1,0x10
	sb	a0,0(t8)

_b0984:
	beqz	s5,_b0990
	  nop
	sb	k1,0(t9)

_b0990:
	jal	_b0474
	  nop
	li	a3,1
	li	v1,1

_b09a0:
	lui	t1,0xffff
	ori	t1,t1,0xffff
	sw	t1,108(t6)
	li	t1,43
	sw	t1,4(t6)
	li	t1,4
	sw	t1,8(t6)
	nop
	nop
	lui	t1,0x24e
	sw	t1,12(t6)
	li	at,1
	bne	a2,at,_b09e4
	  nop
	li	at,1
	beq	a3,at,_b09ec
	  nop

_b09e4:
	li	t2,3
	sw	t2,256(s8)

_b09ec:
	lbu	a0,0(k0)
	sb	a0,0(v0)
	addiu	v0,v0,1
	bne	v1,s0,_b09ec
	  addiu	v1,v1,1
	sw	zero,256(s8)
	sub	t2,v0,s0

_b0a08:
	lbu	t1,0(t2)
	sb	t1,16(t6)
	addiu	t2,t2,1
	bne	t2,v0,_b0a08
	  nop
	li	t1,39
	addiu	t2,a3,-1
	.word	0x71495002
	add	t2,t0,t2

_b0a2c:
	lbu	t3,0(t2)
	sb	t3,16(t6)
	addiu	t2,t2,1
	addi	t1,t1,-1
	bgtz	t1,_b0a2c
	  nop

_b0a44:
	lw	t1,108(t6)
	andi	t1,t1,0x8
	beqz	t1,_b0a44
	  nop
	li	t1,1
	sw	t1,8(t6)
	lw	t1,108(t6)
	andi	t2,t1,0x1
	beqz	t2,_b0bc4
	  nop
	andi	t2,t1,0x2
	bnez	t2,_b0bac
	  nop
	srl	t1,t1,0x1b
	beqz	t1,_b0bc4
	  nop
	li	t3,23
	jal	_b05ec
	  nop
	li	t3,22
	jal	_b05ec
	  nop
	li	t3,21
	jal	_b05ec
	  nop
	li	t3,20
	jal	_b05ec
	  nop
	li	t3,19
	jal	_b05ec
	  nop
	li	t3,18
	jal	_b05ec
	  nop
	li	t3,17
	jal	_b05ec
	  nop
	li	t3,16
	jal	_b05ec
	  nop
	li	t3,15
	jal	_b05ec
	  nop
	li	t3,14
	jal	_b05ec
	  nop
	li	t3,13
	jal	_b05ec
	  nop
	li	t3,12
	jal	_b05ec
	  nop
	li	t3,11
	jal	_b05ec
	  nop
	li	t3,10
	jal	_b05ec
	  nop
	li	t3,9
	jal	_b05ec
	  nop
	li	t3,8
	jal	_b05ec
	  nop
	li	t3,7
	jal	_b05ec
	  nop
	li	t3,6
	jal	_b05ec
	  nop
	li	t3,5
	jal	_b05ec
	  nop
	li	t3,4
	jal	_b05ec
	  nop
	li	t3,3
	jal	_b05ec
	  nop
	li	t3,2
	jal	_b05ec
	  nop
	li	t3,1
	jal	_b05ec
	  nop
	li	t3,0
	jal	_b05ec
	  nop
	b	_b0bc4
	  nop

_b0bac:
	lui	t1,0xffff
	ori	t1,t1,0xffe0
	and	a1,a1,t1
	addiu	a1,a1,64
	b	_b06bc
	  nop

_b0bc4:
	li	v1,1
	bne	a3,s1,_b09a0
	  addiu	a3,a3,1
	addiu	a1,a1,2
	bne	a2,s3,_b08e0
	  addiu	a2,a2,1
	b	_b0eec
	  nop

_b0be4:
	li	a2,1

_b0be8:
	sb	zero,0(t9)
	beqz	s5,_b0bf8
	  sb	zero,0(t8)
	sb	zero,0(t8)

_b0bf8:
	addi	t1,a1,1
	sb	t1,0(t8)
	srl	a0,t1,0x8
	beqz	s6,_b0c14
	  sb	a0,0(t8)
	srl	a0,t1,0x10
	sb	a0,0(t8)

_b0c14:
	beqz	s5,_b0c20
	  nop
	sb	k1,0(t9)

_b0c20:
	jal	_b0474
	  nop
	li	v1,2
	ori	t1,t0,0x0
	li	t2,3
	sw	t2,256(s8)

_b0c38:
	lhu	a0,0(k0)
	sh	a0,0(t1)
	addiu	t1,t1,2
	bne	v1,s2,_b0c38
	  addiu	v1,v1,2
	sw	zero,256(s8)
	sw	zero,80(s8)
	li	t1,3
	sw	t1,80(s8)
	nop
	nop
	sb	zero,0(t9)
	beqz	s5,_b0c74
	  sb	zero,0(t8)
	sb	zero,0(t8)

_b0c74:
	sb	a1,0(t8)
	srl	a0,a1,0x8
	beqz	s6,_b0c8c
	  sb	a0,0(t8)
	srl	a0,a1,0x10
	sb	a0,0(t8)

_b0c8c:
	beqz	s5,_b0c98
	  nop
	sb	k1,0(t9)

_b0c98:
	jal	_b0474
	  nop
	li	a3,1
	li	v1,2

_b0ca8:
	lui	t1,0xffff
	ori	t1,t1,0xffff
	sw	t1,108(t6)
	li	t1,43
	sw	t1,4(t6)
	li	t1,4
	sw	t1,8(t6)
	nop
	nop
	lui	t1,0x24e
	sw	t1,12(t6)
	li	at,1
	bne	a2,at,_b0cec
	  nop
	li	at,1
	beq	a3,at,_b0cf4
	  nop

_b0cec:
	li	t2,3
	sw	t2,256(s8)

_b0cf4:
	lhu	a0,0(k0)
	sh	a0,0(v0)
	addiu	v0,v0,2
	bne	v1,s0,_b0cf4
	  addiu	v1,v1,2
	sw	zero,256(s8)
	sub	t2,v0,s0

_b0d10:
	lbu	t1,0(t2)
	sb	t1,16(t6)
	addiu	t2,t2,1
	bne	t2,v0,_b0d10
	  nop
	li	t1,39
	addiu	t2,a3,-1
	.word	0x71495002
	add	t2,t0,t2

_b0d34:
	lbu	t3,0(t2)
	sb	t3,16(t6)
	addiu	t2,t2,1
	addi	t1,t1,-1
	bgtz	t1,_b0d34
	  nop

_b0d4c:
	lw	t1,108(t6)
	andi	t1,t1,0x8
	beqz	t1,_b0d4c
	  nop
	li	t1,1
	sw	t1,8(t6)
	lw	t1,108(t6)
	andi	t2,t1,0x1
	beqz	t2,_b0ecc
	  nop
	andi	t2,t1,0x2
	bnez	t2,_b0eb4
	  nop
	srl	t1,t1,0x1b
	beqz	t1,_b0ecc
	  nop
	li	t3,23
	jal	_b05ec
	  nop
	li	t3,22
	jal	_b05ec
	  nop
	li	t3,21
	jal	_b05ec
	  nop
	li	t3,20
	jal	_b05ec
	  nop
	li	t3,19
	jal	_b05ec
	  nop
	li	t3,18
	jal	_b05ec
	  nop
	li	t3,17
	jal	_b05ec
	  nop
	li	t3,16
	jal	_b05ec
	  nop
	li	t3,15
	jal	_b05ec
	  nop
	li	t3,14
	jal	_b05ec
	  nop
	li	t3,13
	jal	_b05ec
	  nop
	li	t3,12
	jal	_b05ec
	  nop
	li	t3,11
	jal	_b05ec
	  nop
	li	t3,10
	jal	_b05ec
	  nop
	li	t3,9
	jal	_b05ec
	  nop
	li	t3,8
	jal	_b05ec
	  nop
	li	t3,7
	jal	_b05ec
	  nop
	li	t3,6
	jal	_b05ec
	  nop
	li	t3,5
	jal	_b05ec
	  nop
	li	t3,4
	jal	_b05ec
	  nop
	li	t3,3
	jal	_b05ec
	  nop
	li	t3,2
	jal	_b05ec
	  nop
	li	t3,1
	jal	_b05ec
	  nop
	li	t3,0
	jal	_b05ec
	  nop
	b	_b0ecc
	  nop

_b0eb4:
	lui	t1,0xffff
	ori	t1,t1,0xffe0
	and	a1,a1,t1
	addiu	a1,a1,64
	b	_b06bc
	  nop

_b0ecc:
	li	v1,2
	bne	a3,s1,_b0ca8
	  addiu	a3,a3,1
	addiu	a1,a1,2
	bne	a2,s3,_b0be8
	  addiu	a2,a2,1
	b	_b0eec
	  nop

_b0eec:
	sw	zero,80(s8)
	li	s3,8192
	b	_b00f8
	  addiu	s4,gp,160

usb_boot:
	mflo	a0

	/* If boot_sel[2,1,0] == 6 -> USB boot, EXCLK=12 MHz */
	li	t0,6
	beq	s5,t0,usb_boot_12mhz
	  nop

	/* If boot_sel[2,1,0] == 0 -> USB boot, EXCLK=13 MHz */
	li	t0,0
	beq	s5,t0,usb_boot_13mhz
	  nop

	/* If boot_sel[2,1,0] == 1 -> USB boot, EXCLK=26 MHz */
	li	t0,1
	beq	s5,t0,usb_boot_26mhz
	  nop

	/* If boot_sel[2,1,0] == 2 -> USB boot, EXCLK=19.2 MHz */
	li	t0,2
	beq	s5,t0,usb_boot_19_2mhz
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x24
	lw	t0,0(t1)
	ori	t0,t0,0x4
	sw	t0,0(t1)
	lui	t1,0xb000
	sw	zero,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x10
	li	t0,800
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x204c
	li	t0,530
	sh	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x2044
	li	t0,0xffff
	sh	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x2040
	li	t0,0xffff
	sh	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x2048
	sh	zero,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x20ec
	li	t0,0x8201
	sh	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x20e0
	lui	t0,0xffff
	ori	t0,t0,0xffff
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x20e8
	sw	zero,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x2014
	li	t0,0x8001
	sh	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x20e8

_b0fe0:
	lw	t0,0(t1)
	lui	v0,0x4
	ori	v0,v0,0x1eb0
	slt	t0,t0,v0
	bnez	t0,_b0fe0
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x2048
	lh	t0,0(t1)
	addi	t0,t0,-5
	bltz	t0,_b1108
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x20e8
	sw	zero,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x2048
	sh	zero,0(t1)
	lui	s1,0xb000
	ori	s1,s1,0x20e8
	lh	t0,0(t1)

_b1034:
	lh	v0,0(t1)
	beq	v0,t0,_b1034
	  nop
	lh	v0,0(t1)
	addi	t0,v0,100
	lw	t7,0(s1)

_b104c:
	lh	v0,0(t1)
	bne	t0,v0,_b104c
	  nop
	lw	t5,0(s1)
	sub	v0,t5,t7
	li	t0,100
	bnez	t0,_b1070
	  div	zero,v0,t0
	break	0x7

_b1070:
	li	at,-1
	bne	t0,at,_b1088
	  lui	at,0x8000
	bne	v0,at,_b1088
	  nop
	break	0x6

_b1088:
	mflo	v0
	mflo	v0
	li	t0,2048
	.word	0x70481002
	lui	t0,0x7
	ori	t0,t0,0xa120
	add	v0,v0,t0
	lui	t0,0xf
	ori	t0,t0,0x4240
	bnez	t0,_b10b8
	  div	zero,v0,t0
	break	0x7

_b10b8:
	li	at,-1
	bne	t0,at,_b10d0
	  lui	at,0x8000
	bne	v0,at,_b10d0
	  nop
	break	0x6

_b10d0:
	mflo	v0
	mflo	v0
	li	at,12
	beq	v0,at,usb_boot_12mhz
	  nop
	li	at,13
	beq	v0,at,usb_boot_13mhz
	  nop
	li	at,19
	beq	v0,at,usb_boot_19_2mhz
	  nop
	li	at,26
	beq	v0,at,usb_boot_26mhz
	  nop

_b1108:
	lui	t1,0xb000
	ori	t1,t1,0x24
	lw	t0,0(t1)
	li	at,-5
	and	t0,t0,at
	sw	t0,0(t1)

usb_boot_12mhz:
	li	v1,12
	lui	t1,0xb000
	lui	t0,0x121
	ori	t0,t0,0x1110
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x10
	lui	t0,0x300a
	ori	t0,t0,0x120
	sw	t0,0(t1)
	b	_b1214
	  nop

usb_boot_13mhz:
	li	v1,13
	lui	t1,0xb000
	lui	t0,0x121
	ori	t0,t0,0x1110
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x50
	lui	t0,0x8000
	ori	t0,t0,0xc
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x10
	lui	t0,0x300a
	ori	t0,t0,0x120
	sw	t0,0(t1)
	b	_b1214
	  nop

usb_boot_26mhz:
	li	v1,26
	lui	t1,0xb000
	lui	t0,0x121
	ori	t0,t0,0x1110
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x50
	lui	t0,0x8000
	ori	t0,t0,0xc
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x10
	lui	t0,0x180a
	ori	t0,t0,0x120
	sw	t0,0(t1)
	b	_b1214
	  nop

usb_boot_19_2mhz:
	li	v1,19
	lui	t1,0xb000
	lui	t0,0x121
	ori	t0,t0,0x1110
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x50
	lui	t0,0x8000
	ori	t0,t0,0xf
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x10
	lui	t0,0x280a
	ori	t0,t0,0x120
	sw	t0,0(t1)

_b1214:
	lui	t1,0xb000
	ori	t1,t1,0x14
	lw	t0,0(t1)
	srl	t0,t0,0x1d
	andi	t0,t0,0x1
	beqz	t0,_b1214
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x2018
	li	t0,0x8001
	sh	t0,0(t1)

_b1240:
	lui	t1,0xb000
	ori	t1,t1,0x24
	lw	t0,0(t1)
	ori	t0,t0,0x80
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x3c
	lui	t2,0xffff
	ori	t2,t2,0xffc0
	lw	t0,0(t1)
	and	t0,t0,t2
	ori	t0,t0,0x35
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x3c
	li	t2,1
	sll	t2,t2,0x16
	lw	t0,0(t1)
	or	t0,t0,t2
	sw	t0,0(t1)
	li	t0,40

_b1294:
	bnez	t0,_b1294
	  addi	t0,t0,-1
	lui	t1,0xb000
	ori	t1,t1,0x3c
	li	t2,1
	sll	t2,t2,0x16
	lw	t0,0(t1)
	xor	t0,t0,t2
	sw	t0,0(t1)
	li	t0,2000

_b12bc:
	bnez	t0,_b12bc
	  addi	t0,t0,-1
	lui	t1,0xb000
	ori	t1,t1,0x3c
	li	t2,1
	sll	t2,t2,0x18
	lw	t0,0(t1)
	or	t0,t0,t2
	sw	t0,0(t1)
	lui	k1,0xb344
	sb	zero,11(k1)
	sh	zero,6(k1)
	sh	zero,8(k1)
	li	t1,96
	sb	t1,1(k1)
	li	s6,0
	li	s7,1
	li	t5,0
	lui	t1,0xb000
	ori	t1,t1,0x20ec
	li	t0,0x822c
	sh	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x20e0
	lui	t0,0xffff
	ori	t0,t0,0xffff
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x20e8
	sw	zero,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x2014
	li	t0,0x8000
	sh	t0,0(t1)
	li	s1,0

_b1348:
	bnez	t5,_b138c
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x20e8
	lw	t0,0(t1)
	li	t1,9766
	.word	0x71234802
	subu	t0,t0,t1
	bltz	t0,_b138c
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x2018
	li	t0,0x8000
	sh	t0,0(t1)
	mtlo	a0
	j	_b0004
	nop

_b138c:
	lbu	t1,10(k1)
	andi	t1,t1,0x4
	beqz	t1,_b13f4
	  nop
	li	t5,1
	lui	t1,0xb000
	ori	t1,t1,0x2018
	li	t0,0x8000
	sh	t0,0(t1)
	lbu	t1,1(k1)
	andi	t1,t1,0x10
	bnez	t1,_b13c4
	  li	t1,512
	li	t1,64

_b13c4:
	li	t0,1
	sb	t0,14(k1)
	sh	t1,16(k1)
	sb	zero,19(k1)
	sh	t1,20(k1)
	sb	zero,23(k1)
	li	t0,72
	sb	t0,18(k1)
	li	t0,144
	sb	t0,22(k1)
	li	s6,0
	li	s7,1

_b13f4:
	lhu	t2,2(k1)
	andi	t1,t2,0x1
	beqz	t1,_b176c
	  nop
	sb	zero,14(k1)
	lbu	t3,18(k1)
	andi	t1,t3,0x4
	beqz	t1,_b1424
	  nop
	andi	t1,t3,0xdb
	sb	t1,18(k1)
	li	s6,0

_b1424:
	andi	t1,t3,0x10
	beqz	t1,_b143c
	  nop
	ori	t1,t3,0x80
	sb	t1,18(k1)
	li	s6,0

_b143c:
	bnez	s6,_b1700
	  nop
	beqz	s1,_b1454
	  nop
	sb	s1,0(k1)
	addu	s1,zero,zero

_b1454:
	andi	t1,t3,0x1
	beqz	t1,_b176c
	  nop
	lw	t9,32(k1)
	lw	k0,32(k1)
	andi	t1,t9,0x60
	beqz	t1,_b1590
	  nop
	li	s6,0
	li	s7,1
	andi	t1,t9,0xff00
	srl	t1,t1,0x8
	beqz	t1,_b14bc
	  addi	t0,t1,-1
	beqz	t0,_b14d8
	  addi	t0,t1,-2
	beqz	t0,_b14f0
	  addi	t0,t1,-3
	beqz	t0,l1_cache_invalidate
	  addi	t0,t1,-4
	beqz	t0,_b1548
	  addi	t0,t1,-5
	beqz	t0,_b1568
	  nop
	b	_b16e4
	  nop

_b14bc:
	lui	s4,0xbfc0
	addiu	s4,s4,6420
	li	s5,8
	li	s6,1
	li	s7,0
	b	_b16e4
	  nop

_b14d8:
	lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s4,t1,t0
	b	_b16e4
	  nop

_b14f0:
	lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s5,t1,t0
	li	t1,72
	sb	t1,18(k1)
	b	_b1778
	  nop

l1_cache_invalidate:
	lui	t0,0x8000
	addi	t1,t0,16352

_b1518:
	cache	Index_Invalidate_I,0(t0)
	cache	Index_Writeback_Inv_D,0(t0)
	bne	t0,t1,_b1518
	  addiu	t0,t0,32
	sync
	.word	0x40088007
	nop
	ori	t0,t0,0x2
	.word	0x40888007
	nop
	b	_b16e4
	  nop

_b1548:
	li	t1,72
	sb	t1,18(k1)
	lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s4,t1,t0
	b	_b00f8
	  li	s3,16384

_b1568:
	li	t1,72
	sb	t1,18(k1)
	lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s4,t1,t0
	jalr	s4
	  nop
	b	_b1240
	  nop

_b1590:
	andi	t4,t9,0xff00
	srl	t4,t4,0x8
	addi	t1,t4,-5
	bnez	t1,_b15b4
	  nop
	srl	s1,t9,0x10
	li	s7,1
	b	_b16e4
	  nop

_b15b4:
	addi	t1,t4,-9
	bnez	t1,_b15cc
	  nop
	li	s7,1
	b	_b16e4
	  nop

_b15cc:
	addi	t1,t4,-6
	bnez	t1,_b16e4
	  li	s7,1
	li	s7,0
	srl	t1,t9,0x18
	addi	t0,t1,-1
	beqz	t0,_b1610
	  srl	s5,k0,0x10
	addi	t0,t1,-2
	beqz	t0,_b1658
	  addi	t0,t1,-3
	beqz	t0,_b1694
	  addi	t0,t1,-6
	beqz	t0,_b1634
	  nop
	b	_b16e4
	  nop

_b1610:
	lui	s4,0xbfc0
	addiu	s4,s4,6256
	li	s6,1
	addi	t0,s5,-18
	blez	t0,_b16e4
	  nop
	li	s5,18
	b	_b16e4
	  nop

_b1634:
	lui	s4,0xbfc0
	addiu	s4,s4,6276
	li	s6,1
	addi	t0,s5,-10
	blez	t0,_b16e4
	  nop
	li	s5,10
	b	_b16e4
	  nop

_b1658:
	lui	s4,0xbfc0
	addiu	s4,s4,6320
	lbu	t0,1(k1)
	andi	t0,t0,0x10
	beqz	t0,_b1678
	  nop
	lui	s4,0xbfc0
	addiu	s4,s4,6288

_b1678:
	li	s6,1
	addi	t0,s5,-32
	blez	t0,_b16e4
	  nop
	li	s5,32
	b	_b16e4
	  nop

_b1694:
	li	s6,1
	srl	t1,t9,0x10
	andi	t1,t1,0xff
	addi	t0,t1,-1
	beqz	t0,_b16c4
	  addi	t0,t1,-2
	beqz	t0,_b16d4
	  nop
	lui	s4,0xbfc0
	addiu	s4,s4,6352
	b	_b16e4
	  li	s5,4

_b16c4:
	lui	s4,0xbfc0
	addiu	s4,s4,6356
	b	_b16e4
	  li	s5,16

_b16d4:
	lui	s4,0xbfc0
	addiu	s4,s4,6372
	b	_b16e4
	  li	s5,46

_b16e4:
	li	t1,64
	beqz	s7,_b16f4
	  nop
	ori	t1,t1,0x8

_b16f4:
	sb	t1,18(k1)
	beqz	s6,_b176c
	  nop

_b1700:
	addi	t1,s6,-1
	bnez	t1,_b176c
	  nop
	addi	t1,s5,-64
	blez	t1,_b171c
	  ori	s3,s5,0x0
	li	s3,64

_b171c:
	beqz	s3,_b1748
	  ori	s2,s3,0x0
	sub	s5,s5,s3

_b1728:
	lbu	t1,0(s4)
	sb	t1,32(k1)
	addi	s3,s3,-1
	bnez	s3,_b1728
	  addi	s4,s4,1
	addi	t1,s2,-64
	beqz	t1,_b175c
	  nop

_b1748:
	li	t1,10
	sb	t1,18(k1)
	li	s6,0
	b	_b176c
	  nop

_b175c:
	li	t1,2
	sb	t1,18(k1)
	b	_b176c
	  nop

_b176c:
	andi	t1,t2,0x2
	beqz	t1,_b17f8
	  nop

_b1778:
	li	t1,1
	sb	t1,14(k1)
	lbu	t1,18(k1)
	andi	t0,t1,0x2
	bnez	t0,_b17f8
	  nop
	lhu	t1,16(k1)
	sub	t0,s5,t1
	blez	t0,_b17a4
	  ori	s3,s5,0x0
	ori	s3,t1,0x0

_b17a4:
	beqz	s3,_b17f8
	  nop
	sub	s5,s5,s3
	srl	a1,s3,0x2
	andi	a2,s3,0x3
	beqz	a1,_b17d4
	  nop

_b17c0:
	lw	t1,0(s4)
	sw	t1,36(k1)
	addi	a1,a1,-1
	bnez	a1,_b17c0
	  addiu	s4,s4,4

_b17d4:
	beqz	a2,_b17f0
	  nop

_b17dc:
	lbu	t1,0(s4)
	sb	t1,36(k1)
	addi	a2,a2,-1
	bnez	a2,_b17dc
	  addiu	s4,s4,1

_b17f0:
	li	t1,1
	sb	t1,18(k1)

_b17f8:
	lhu	t1,4(k1)
	andi	t1,t1,0x2
	beqz	t1,_b1868
	  nop
	li	t1,1
	sb	t1,14(k1)
	lbu	t1,22(k1)
	andi	t1,t1,0x1
	beqz	t1,_b1868
	  nop
	lhu	s3,24(k1)
	srl	a1,s3,0x2
	andi	a2,s3,0x3
	beqz	a1,_b1848
	  nop

_b1834:
	lw	t1,36(k1)
	sw	t1,0(s4)
	addi	a1,a1,-1
	bnez	a1,_b1834
	  addiu	s4,s4,4

_b1848:
	beqz	a2,_b1864
	  nop

_b1850:
	lbu	t1,36(k1)
	sb	t1,0(s4)
	addi	a2,a2,-1
	bnez	a2,_b1850
	  addiu	s4,s4,1

_b1864:
	sb	zero,22(k1)

_b1868:
	b	_b1348
	  nop

	.word	0x02000112
	.word	0x40000000
	.word	0x4760601a
	.word	0x02010100
	.word	0x00000100
	.word	0x0200060a
	.word	0x40000000
	.word	0x00000001
	.word	0x00200209
	.word	0xc0000101
	.word	0x00040901
	.word	0x00ff0200
	.word	0x05070050
	.word	0x02000201
	.word	0x81050700
	.word	0x00020002
	.word	0x00200209
	.word	0xc0000101
	.word	0x00040901
	.word	0x00ff0200
	.word	0x05070050
	.word	0x00400201
	.word	0x81050700
	.word	0x00004002
	.word	0x04090304
	.word	0x00490310
	.word	0x0067006e
	.word	0x006e0065
	.word	0x00630069
	.word	0x004a032e
	.word	0x0034005a
	.word	0x00360037
	.word	0x00200030
	.word	0x00530055
	.word	0x00200042
	.word	0x006f0042
	.word	0x0074006f
	.word	0x00440020
	.word	0x00760065
	.word	0x00630069
	.word	0x00000065
	.word	0x37345a4a
	.word	0x31563036

_b191c:
	li	t0,1
	sh	t0,0(s4)

_b1924:
	lui	t3,0xb002
	ori	t3,t3,0x1004
	lw	t4,0(t3)
	andi	t4,t4,0x100
	beqz	t4,_b1958
	  nop
	nop
	nop
	nop
	nop
	nop
	b	_b1924
	  nop

_b1958:
	sb	s5,44(s4)
	sw	s6,48(s4)
	sw	s7,12(s4)
	li	t0,0xfffb
	sw	t0,36(s4)
	li	t2,6
	sh	t2,0(s4)

_b1974:
	lw	t3,4(s4)
	andi	t3,t3,0x800
	beqz	t3,_b1974
	  nop
	li	t1,4
	sh	t1,40(s4)
	beqz	t8,_b19a8
	  nop
	lui	t0,0xb002
	ori	t0,t0,0x1034
	lh	t9,0(t0)
	lh	k0,0(t0)
	lh	k1,0(t0)

_b19a8:
	jr	ra
	  nop

_b19b0:
	li	s5,16
	li	s6,512
	li	s7,1
	li	t8,1
	jal	_b191c
	  nop
	li	t5,512
	sh	t5,24(s4)
	li	t5,16
	sh	t5,28(s4)
	li	s5,18
	li	s6,0
	li	s7,9
	li	t8,1
	jal	_b191c
	  nop
	ori	v0,gp,0x0
	li	s0,8192
	li	v1,0
	li	s1,2048

_b1a00:
	beqz	s1,_b1aa0
	  nop
	lui	t2,0xb002
	ori	t2,t2,0x1028
	lw	t3,0(t2)
	andi	t3,t3,0x20
	beqz	t3,_b1a00
	  nop
	li	t1,16

_b1a24:
	lw	a0,56(s4)
	sw	a0,0(v0)
	addiu	v0,v0,4
	addi	t1,t1,-1
	bnez	t1,_b1a24
	  nop
	addi	s1,s1,-16
	addi	v1,v1,64
	bne	v1,s0,_b1a00
	  nop
	li	s5,12
	li	s6,0
	li	s7,65
	li	t8,1
	jal	_b191c
	  nop
	li	t0,1
	sh	t0,0(s4)

_b1a6c:
	lui	t3,0xb002
	ori	t3,t3,0x1004
	lw	t4,0(t3)
	andi	t4,t4,0x100
	beqz	t4,_b1aa0
	  nop
	nop
	nop
	nop
	nop
	nop
	b	_b1a6c
	  nop

_b1aa0:
	ori	v0,gp,0x0
	addiu	v0,v0,512
	lw	a0,0(v0)
	lui	at,0x4d53
	ori	at,at,0x504c
	sub	a0,a0,at
	bnez	a0,usb_boot
	  nop
	b	_b1d8c
	  nop

msc0_boot:
	lui	t1,0xc
	sw	t1,68(sp)
	sw	t1,120(sp)
	sw	t1,84(sp)
	sw	t1,52(sp)
	lui	t1,0x10
	sw	t1,68(sp)
	sw	t1,120(sp)
	sw	t1,88(sp)
	sw	t1,52(sp)
	lui	s4,0xb002
	ori	s4,s4,0x1000
	li	t2,8
	sh	t2,0(s4)

_b1b00:
	lui	t3,0xb002
	ori	t3,t3,0x1004
	lw	t4,0(t3)
	andi	t4,t4,0x8000
	bnez	t4,_b1b00
	  nop
	li	t2,0xffff
	sw	t2,36(s4)
	li	t3,0xffff
	sh	t3,40(s4)
	li	t2,7
	sh	t2,8(s4)
	li	s5,12
	li	s6,0
	li	s7,65
	li	t8,1
	jal	_b191c
	  nop
	li	s5,0
	li	s6,0
	li	s7,128
	li	t8,0
	jal	_b191c
	  nop
	li	s5,8
	li	s6,426
	li	s7,1
	li	t8,1
	jal	_b191c
	  nop
	li	s5,55
	li	s6,0
	li	s7,1
	li	t8,1
	jal	_b191c
	  nop
	andi	t0,k1,0x20
	beqz	t0,_b1be0
	  nop
	srl	t0,t9,0x8
	li	t1,55
	bne	t0,t1,_b1be0
	  nop
	li	s5,41
	lui	s6,0x40ff
	ori	s6,s6,0x8000
	li	s7,3
	li	t8,3
	jal	_b191c
	  nop
	srl	t0,t9,0x8
	li	t1,63
	beq	t0,t1,_b1c94
	  nop
	b	_b1be0
	  nop

_b1be0:
	li	s5,1
	lui	s6,0x40ff
	ori	s6,s6,0x8000
	li	s7,3
	li	t8,3
	jal	_b191c
	  nop
	andi	t6,t9,0x80
	bnez	t6,_b1c20
	  nop
	li	t2,5500

_b1c0c:
	addi	t2,t2,-1
	bnez	t2,_b1c0c
	  nop
	b	_b1be0
	  nop

_b1c20:
	li	s5,2
	li	s6,0
	li	s7,2
	li	t8,2
	jal	_b191c
	  nop
	li	s5,3
	li	s6,16
	li	s7,1
	li	t8,1
	jal	_b191c
	  nop
	li	t2,2
	sw	t2,8(s4)
	li	s5,7
	li	s6,16
	li	s7,1
	li	t8,1
	jal	_b191c
	  nop
	li	s5,6
	lui	s6,0x3b7
	ori	s6,s6,0x1
	li	s7,1
	li	t8,1
	jal	_b191c
	  nop
	jal	_b19b0
	  nop

_b1c94:
	li	s5,55
	li	s6,0
	li	s7,1
	li	t8,1
	jal	_b191c
	  nop
	li	s5,41
	lui	s6,0x40ff
	ori	s6,s6,0x8000
	li	s7,3
	li	t8,3
	jal	_b191c
	  nop
	andi	t6,t9,0x80
	bnez	t6,_b1cec
	  nop
	li	t2,5500

_b1cd8:
	addi	t2,t2,-1
	bnez	t2,_b1cd8
	  nop
	b	_b1c94
	  nop

_b1cec:
	li	s5,2
	li	s6,0
	li	s7,2
	li	t8,2
	jal	_b191c
	  nop
	li	s5,3
	li	s6,0
	li	s7,6
	li	t8,1
	jal	_b191c
	  nop
	andi	t9,t9,0xff
	sll	t9,t9,0x8
	andi	k0,k0,0xffff
	srl	k0,k0,0x8
	or	s3,t9,k0
	sll	s3,s3,0x10
	li	t2,2
	sw	t2,8(s4)
	li	s5,7
	ori	s6,s3,0x0
	li	s7,65
	li	t8,1
	jal	_b191c
	  nop
	li	s5,55
	ori	s6,s3,0x0
	li	s7,1
	li	t8,1
	jal	_b191c
	  nop
	li	s5,6
	li	s6,0
	li	s7,1
	li	t8,1
	jal	_b191c
	  nop
	jal	_b19b0
	  nop

_b1d8c:
	li	s3,8192
	b	_b00f8
	  addiu	s4,gp,516

.data
.section .data.1ffc
	.word	0xd49d
