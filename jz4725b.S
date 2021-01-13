# vim: set ts=8 shiftwidth=8 :

.text
.set noreorder
.set noat
.globl start

#include "asm.h"

start:
	mtlo	zero
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

	lui	s8,0xb301
	li	v0,3
	mtc0	v0,$16
	nop
	lui	v0,0x2000
	mtc0	v0,$26
	ori	v0,gp,0x0
	ori	v1,v0,0x3fe0
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

_b0090:
	and	a1,v0,a0
	ori	a1,a1,0x1
	mtc0	a1,$28
	cache	Index_Store_Tag_I,0(v0)
	cache	Index_Store_Tag_D,0(v0)
	bne	v0,v1,_b0090
	  addiu	v0,v0,32
	lw	t1,512(sp)
	srl	t1,t1,0x1e
	andi	s5,t1,0x3
	beqz	s5,msc0_boot
	  nop
	li	t0,1
	beq	s5,t0,usb_boot
	  nop
	li	t0,2
	beq	s5,t0,_b0114
	  nop
	b	nand_boot_cs1
	  nop

_b00e0:
	ori	v0,gp,0x0
	add	v1,v0,s3
	addiu	v1,v1,-4

_b00ec:
	lw	a0,0(v0)
	.word	0x4084e001
	cache	0xc,0(v0)
	bne	v0,v1,_b00ec
	  addiu	v0,v0,4
	mtc0	zero,$26
	jalr	s4
	  nop
	b	_b0c88
	  nop

_b0114:
	lui	t1,0x18
	ori	t1,t1,0x7fff
	sw	t1,324(sp)
	sw	t1,344(sp)
	sw	t1,308(sp)
	lui	t1,0x100
	sw	t1,532(sp)
	lui	t1,0x710
	ori	t1,t1,0x3ff
	sw	t1,580(sp)
	sw	t1,600(sp)
	sw	t1,564(sp)
	li	t2,255
	sw	t2,68(sp)
	sw	t2,88(sp)
	sw	t2,52(sp)
	lui	t3,0xfff
	ori	t3,t3,0x7700
	lui	t4,0xa800
	lbu	t0,0(t4)
	beqz	t0,_b0190
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

_b0190:
	sw	t3,32(s8)
	addiu	t4,t4,4
	jr	t4
	  nop

_b01a0:
	.space	0x80

_b0220:
	lw	s4,512(sp)
	srl	s4,s4,0x1b
	andi	s4,s4,0x1
	beqz	s4,_b0220
	  nop
	jr	ra
	  nop

_b023c:
	li	t3,0
	li	t1,1

_b0244:
	and	t2,t0,t1
	beqz	t2,_b0254
	  nop
	addi	t3,t3,1

_b0254:
	li	at,128
	bne	t1,at,_b0244
	  sll	t1,t1,0x1
	addi	t3,t3,-4
	bgtz	t3,_b0278
	  nop
	li	t0,0
	b	_b027c
	  nop

_b0278:
	li	t0,1

_b027c:
	jr	ra
	  nop

_b0284:
	addi	t3,t3,-1
	srl	t1,t3,0x3
	andi	t2,t3,0x7
	add	t1,t1,t4
	lbu	t3,0(t1)
	li	t5,1
	sllv	t5,t5,t2
	xor	t3,t3,t5
	sb	t3,0(t1)
	  jr	ra
	  nop

nand_boot_cs1:
	lui	t6,0xb30d
	li	t1,255
	sw	t1,68(sp)
	sw	t1,88(sp)
	lui	t1,0x8
	sw	t1,324(sp)
	sw	t1,344(sp)
	sw	t1,308(sp)
	lui	t1,0x20
	sw	t1,532(sp)
	lui	t1,0x3020
	ori	t1,t1,0x300
	sw	t1,580(sp)
	sw	t1,600(sp)
	sw	t1,564(sp)
	lui	t1,0x800
	sw	t1,584(sp)
	sw	t1,600(sp)
	sw	t1,616(sp)
	lui	t1,0xfff
	ori	t1,t1,0x7700
	sw	t1,20(s8)
	li	t1,3
	sw	t1,80(s8)
	lui	t8,0xb801
	lui	t9,0xb800
	ori	t9,t9,0x8000
	lui	k0,0xb800
	li	a1,0

_b0324:
	addiu	t1,a1,-256
	bgtz	t1,usb_boot
	  nop
	li	t1,255
	sb	t1,0(t9)
	  jal	_b01a0
	  nop
	li	k1,48
	li	s5,0

_b0348:
	sb	zero,0(t9)
	  li	t1,1
	beqz	s5,_b035c
	  sb	t1,0(t8)
	  sb	zero,0(t8)

_b035c:
	sb	a1,0(t8)
	  srl	t1,a1,0x8
	sb	t1,0(t8)
	  srl	t1,a1,0x10
	sb	t1,0(t8)
	  beqz	s5,_b037c
	  nop
	sb	k1,0(t9)

_b037c:
	jal	_b01a0
	  nop
	lbu	t0,0(k0)
	li	t1,85
	beq	t0,t1,_b03cc
	  nop
	lbu	t0,0(k0)
	li	t1,85
	beq	t0,t1,_b03cc
	  nop
	lbu	t0,0(k0)
	li	t1,85
	beq	t0,t1,_b03cc
	  nop
	beqz	s5,_b03c4
	  nop
	b	_b0324
	  addiu	a1,a1,64

_b03c4:
	b	_b0348
	  li	s5,1

_b03cc:
	li	t1,255
	sw	t1,52(sp)
	sb	zero,0(t9)
	  beqz	s5,_b03e4
	  sb	zero,0(t8)
	  sb	zero,0(t8)

_b03e4:
	sb	a1,0(t8)
	  srl	t1,a1,0x8
	sb	t1,0(t8)
	  srl	t1,a1,0x10
	sb	t1,0(t8)
	  beqz	s5,_b0404
	  nop
	sb	k1,0(t9)

_b0404:
	jal	_b01a0
	  nop
	lbu	t0,0(k0)
	jal	_b023c
	  nop
	move	s7,t0
	bnez	s7,_b0440
	  nop
	lui	t1,0xfff
	ori	t1,t1,0x7740
	sw	t1,20(s8)
	li	t1,0xffff
	sw	t1,68(sp)
	sw	t1,88(sp)
	sw	t1,52(sp)

_b0440:
	sb	zero,0(t9)
	  li	t1,8
	bnez	s7,_b0454
	  nop
	li	t1,4

_b0454:
	beqz	s5,_b0460
	  sb	t1,0(t8)
	  sb	zero,0(t8)

_b0460:
	sb	a1,0(t8)
	  srl	t1,a1,0x8
	sb	t1,0(t8)
	  srl	t1,a1,0x10
	sb	t1,0(t8)
	  beqz	s5,_b0480
	  nop
	sb	k1,0(t9)

_b0480:
	jal	_b01a0
	  nop
	beqz	s7,_b04c8
	  nop
	lbu	t0,0(k0)
	jal	_b023c
	  nop
	move	s6,t0
	lbu	t0,0(k0)
	jal	_b023c
	  nop
	move	s5,t0
	lbu	t0,0(k0)
	jal	_b023c
	  nop
	move	t5,t0
	b	_b04fc
	  nop

_b04c8:
	lhu	a3,0(k0)
	andi	t0,a3,0xff
	jal	_b023c
	  nop
	move	s6,t0
	srl	t0,a3,0x8
	jal	_b023c
	  nop
	move	s5,t0
	lbu	t0,0(k0)
	jal	_b023c
	  nop
	move	t5,t0

_b04fc:
	li	s0,512
	li	s1,1
	li	s2,16
	li	s3,16
	beqz	s5,_b0534
	  nop
	li	s1,4
	li	s2,64
	li	s3,4
	bnez	t5,_b0534
	  nop
	li	s1,8
	li	s2,128
	li	s3,2

_b0534:
	ori	v0,gp,0x0
	addiu	t0,gp,12288
	bnez	s7,_b054c
	  nop
	b	_b08d0
	  nop

_b054c:
	li	a2,1

_b0550:
	li	t1,80
	li	t2,0
	beqz	s5,_b0574
	  nop
	li	t1,0
	li	t2,2048
	bnez	t5,_b0574
	  nop
	li	t2,4096

_b0574:
	sb	t1,0(t9)
	  sb	t2,0(t8)
	beqz	s5,_b0588
	  srl	t2,t2,0x8
	sb	t2,0(t8)

_b0588:
	sb	a1,0(t8)
	  srl	a0,a1,0x8
	beqz	s6,_b05a0
	  sb	a0,0(t8)
	  srl	a0,a1,0x10
	sb	a0,0(t8)

_b05a0:
	beqz	s5,_b05ac
	  nop
	sb	k1,0(t9)

_b05ac:
	jal	_b01a0
	  nop
	li	v1,1
	ori	t1,t0,0x0

_b05bc:
	lbu	a0,0(k0)
	sb	a0,0(t1)
	  addiu	t1,t1,1
	bne	v1,s2,_b05bc
	  addiu	v1,v1,1
	sw	zero,80(s8)
	li	t1,3
	sw	t1,80(s8)
	nop
	nop
	sb	zero,0(t9)
	  beqz	s5,_b05f4
	  sb	zero,0(t8)
	  sb	zero,0(t8)

_b05f4:
	sb	a1,0(t8)
	  srl	a0,a1,0x8
	beqz	s6,_b060c
	  sb	a0,0(t8)
	  srl	a0,a1,0x10
	sb	a0,0(t8)

_b060c:
	beqz	s5,_b0618
	  nop
	sb	k1,0(t9)

_b0618:
	jal	_b01a0
	  nop
	li	a3,1
	li	v1,1

_b0628:
	lui	t1,0xffff
	ori	t1,t1,0xffff
	sw	t1,36(t6)
	li	t1,7
	sw	t1,4(t6)
	li	t1,8
	sw	t1,8(t6)
	nop
	nop

_b064c:
	lbu	a0,0(k0)
	sb	a0,0(v0)
	  addiu	v0,v0,1
	bne	v1,s0,_b064c
	  addiu	v1,v1,1
	sub	t2,v0,s0

_b0664:
	lbu	t1,0(t2)
	sb	t1,16(t6)
	  addiu	t2,t2,1
	bne	t2,v0,_b0664
	  nop
	li	t1,13
	addiu	t2,a3,-1
	.word	0x71495002
	addiu	t2,t2,3
	add	t2,t0,t2

_b068c:
	lbu	t3,0(t2)
	sb	t3,16(t6)
	  addiu	t2,t2,1
	addi	t1,t1,-1
	bgtz	t1,_b068c
	  nop

_b06a4:
	lw	t1,36(t6)
	andi	t1,t1,0x8
	beqz	t1,_b06a4
	  nop
	li	t1,1
	sw	t1,8(t6)
	lw	t1,36(t6)
	andi	t2,t1,0x1
	beqz	t2,_b08b0
	  nop
	andi	t2,t1,0x2
	bnez	t2,_b0868
	  nop
	srl	t1,t1,0x1c
	beqz	t1,_b08b0
	  nop
	addi	t2,t1,-8
	beqz	t2,_b0740
	  nop
	addi	t2,t1,-7
	beqz	t2,_b0764
	  nop
	addi	t2,t1,-6
	beqz	t2,_b0788
	  nop
	addi	t2,t1,-5
	beqz	t2,_b07ac
	  nop
	addi	t2,t1,-4
	beqz	t2,_b07d0
	  nop
	addi	t2,t1,-3
	beqz	t2,_b07f4
	  nop
	addi	t2,t1,-2
	beqz	t2,_b0818
	  nop
	b	_b083c
	  nop

_b0740:
	lw	t1,52(t6)
	srl	t3,t1,0x10
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b0764
	  nop
	jal	_b0284
	  nop

_b0764:
	lw	t1,52(t6)
	srl	t3,t1,0x0
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b0788
	  nop
	jal	_b0284
	  nop

_b0788:
	lw	t1,48(t6)
	srl	t3,t1,0x10
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b07ac
	  nop
	jal	_b0284
	  nop

_b07ac:
	lw	t1,48(t6)
	srl	t3,t1,0x0
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b07d0
	  nop
	jal	_b0284
	  nop

_b07d0:
	lw	t1,44(t6)
	srl	t3,t1,0x10
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b07f4
	  nop
	jal	_b0284
	  nop

_b07f4:
	lw	t1,44(t6)
	srl	t3,t1,0x0
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b0818
	  nop
	jal	_b0284
	  nop

_b0818:
	lw	t1,40(t6)
	srl	t3,t1,0x10
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b083c
	  nop
	jal	_b0284
	  nop

_b083c:
	lw	t1,40(t6)
	srl	t3,t1,0x0
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b08b0
	  nop
	jal	_b0284
	  nop
	b	_b08b0
	  nop

_b0868:
	li	t2,16
	beqz	s5,_b0884
	  nop
	li	t2,4
	bnez	t5,_b0884
	  nop
	li	t2,2

_b0884:
	ori	v0,gp,0x0
	andi	t1,a1,0x1f
	sub	t1,t2,t1
	  bgtz	t1,_b054c
	  or	a1,a1,t2
	lui	t1,0xffff
	ori	t1,t1,0xffe0
	and	a1,a1,t1
	addiu	a1,a1,64
	b	_b0324
	  nop

_b08b0:
	li	v1,1
	bne	a3,s1,_b0628
	  addiu	a3,a3,1
	addiu	a1,a1,1
	bne	a2,s3,_b0550
	  addiu	a2,a2,1
	b	_b0c54
	  nop

_b08d0:
	li	a2,1

_b08d4:
	li	t1,80
	li	t2,0
	beqz	s5,_b08f8
	  nop
	li	t1,0
	li	t2,1024
	bnez	t5,_b08f8
	  nop
	li	t2,2048

_b08f8:
	sb	t1,0(t9)
	  sb	t2,0(t8)
	beqz	s5,_b090c
	  srl	t2,t2,0x8
	sb	t2,0(t8)

_b090c:
	sb	a1,0(t8)
	  srl	a0,a1,0x8
	beqz	s6,_b0924
	  sb	a0,0(t8)
	  srl	a0,a1,0x10
	sb	a0,0(t8)

_b0924:
	beqz	s5,_b0930
	  nop
	sb	k1,0(t9)

_b0930:
	jal	_b01a0
	  nop
	li	v1,2
	ori	t1,t0,0x0

_b0940:
	lhu	a0,0(k0)
	sh	a0,0(t1)
	addiu	t1,t1,2
	bne	v1,s2,_b0940
	  addiu	v1,v1,2
	sw	zero,80(s8)
	li	t1,3
	sw	t1,80(s8)
	nop
	nop
	sb	zero,0(t9)
	  beqz	s5,_b0978
	  sb	zero,0(t8)
	  sb	zero,0(t8)

_b0978:
	sb	a1,0(t8)
	  srl	a0,a1,0x8
	beqz	s6,_b0990
	  sb	a0,0(t8)
	  srl	a0,a1,0x10
	sb	a0,0(t8)

_b0990:
	beqz	s5,_b099c
	  nop
	sb	k1,0(t9)

_b099c:
	jal	_b01a0
	  nop
	li	a3,1
	li	v1,2

_b09ac:
	lui	t1,0xffff
	ori	t1,t1,0xffff
	sw	t1,36(t6)
	li	t1,7
	sw	t1,4(t6)
	li	t1,8
	sw	t1,8(t6)
	nop
	nop

_b09d0:
	lhu	a0,0(k0)
	sh	a0,0(v0)
	addiu	v0,v0,2
	bne	v1,s0,_b09d0
	  addiu	v1,v1,2
	sub	t2,v0,s0

_b09e8:
	lbu	t1,0(t2)
	sb	t1,16(t6)
	  addiu	t2,t2,1
	bne	t2,v0,_b09e8
	  nop
	li	t1,13
	addiu	t2,a3,-1
	.word	0x71495002
	addiu	t2,t2,3
	add	t2,t0,t2

_b0a10:
	lbu	t3,0(t2)
	sb	t3,16(t6)
	  addiu	t2,t2,1
	addi	t1,t1,-1
	bgtz	t1,_b0a10
	  nop

_b0a28:
	lw	t1,36(t6)
	andi	t1,t1,0x8
	beqz	t1,_b0a28
	  nop
	li	t1,1
	sw	t1,8(t6)
	lw	t1,36(t6)
	andi	t2,t1,0x1
	beqz	t2,_b0c34
	  nop
	andi	t2,t1,0x2
	bnez	t2,_b0bec
	  nop
	srl	t1,t1,0x1c
	beqz	t1,_b0c34
	  nop
	addi	t2,t1,-8
	beqz	t2,_b0ac4
	  nop
	addi	t2,t1,-7
	beqz	t2,_b0ae8
	  nop
	addi	t2,t1,-6
	beqz	t2,_b0b0c
	  nop
	addi	t2,t1,-5
	beqz	t2,_b0b30
	  nop
	addi	t2,t1,-4
	beqz	t2,_b0b54
	  nop
	addi	t2,t1,-3
	beqz	t2,_b0b78
	  nop
	addi	t2,t1,-2
	beqz	t2,_b0b9c
	  nop
	b	_b0bc0
	  nop

_b0ac4:
	lw	t1,52(t6)
	srl	t3,t1,0x10
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b0ae8
	  nop
	jal	_b0284
	  nop

_b0ae8:
	lw	t1,52(t6)
	srl	t3,t1,0x0
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b0b0c
	  nop
	jal	_b0284
	  nop

_b0b0c:
	lw	t1,48(t6)
	srl	t3,t1,0x10
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b0b30
	  nop
	jal	_b0284
	  nop

_b0b30:
	lw	t1,48(t6)
	srl	t3,t1,0x0
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b0b54
	  nop
	jal	_b0284
	  nop

_b0b54:
	lw	t1,44(t6)
	srl	t3,t1,0x10
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b0b78
	  nop
	jal	_b0284
	  nop

_b0b78:
	lw	t1,44(t6)
	srl	t3,t1,0x0
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b0b9c
	  nop
	jal	_b0284
	  nop

_b0b9c:
	lw	t1,40(t6)
	srl	t3,t1,0x10
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b0bc0
	  nop
	jal	_b0284
	  nop

_b0bc0:
	lw	t1,40(t6)
	srl	t3,t1,0x0
	andi	t3,t3,0x1fff
	sub	t4,v0,s0
	  addiu	t1,t3,-4096
	bgtz	t1,_b0c34
	  nop
	jal	_b0284
	  nop
	b	_b0c34
	  nop

_b0bec:
	li	t2,16
	beqz	s5,_b0c08
	  nop
	li	t2,4
	bnez	t5,_b0c08
	  nop
	li	t2,2

_b0c08:
	ori	v0,gp,0x0
	andi	t1,a1,0x1f
	sub	t1,t2,t1
	  bgtz	t1,_b054c
	  or	a1,a1,t2
	lui	t1,0xffff
	ori	t1,t1,0xffe0
	and	a1,a1,t1
	addiu	a1,a1,64
	b	_b0324
	  nop

_b0c34:
	li	v1,2
	bne	a3,s1,_b09ac
	  addiu	a3,a3,1
	addiu	a1,a1,1
	bne	a2,s3,_b08d4
	  addiu	a2,a2,1
	b	_b0c54
	  nop

_b0c54:
	sw	zero,80(s8)
	li	s3,8192
	b	_b00e0
	  addiu	s4,gp,12

usb_boot:
	lui	t1,0xb000
	lui	t0,0x722
	ori	t0,t0,0x2220
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x10
	lui	t0,0xe00
	ori	t0,t0,0x120
	sw	t0,0(t1)

_b0c88:
	lui	t1,0xb000
	ori	t1,t1,0x24
	lw	t0,0(t1)
	ori	t0,t0,0x40
	sw	t0,0(t1)
	lui	k1,0xb304
	sb	zero,11(k1)
	  sh	zero,6(k1)
	sh	zero,8(k1)
	li	t1,97
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
	bnez	t5,_b0d40
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x20e8
	lw	t0,0(t1)
	lui	t1,0x1
	ori	t1,t1,0xc9c3
	subu	t0,t0,t1
	bltz	t0,_b0d40
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x2018
	li	t0,0x8000
	sh	t0,0(t1)
	j	0x1fc00004
	  nop

_b0d40:
	lbu	t1,10(k1)
	andi	t1,t1,0x4
	beqz	t1,_b0da8
	  nop
	li	t5,1
	lui	t1,0xb000
	ori	t1,t1,0x2018
	li	t0,0x8000
	sh	t0,0(t1)
	lbu	t1,1(k1)
	andi	t1,t1,0x10
	bnez	t1,_b0d78
	  li	t1,512
	li	t1,64

_b0d78:
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

_b0da8:
	lhu	t2,2(k1)
	andi	t1,t2,0x1
	beqz	t1,_b1114
	  nop
	sb	zero,14(k1)
	  lbu	t3,18(k1)
	andi	t1,t3,0x4
	beqz	t1,_b0dd8
	  nop
	andi	t1,t3,0xdb
	sb	t1,18(k1)
	  li	s6,0

_b0dd8:
	andi	t1,t3,0x10
	beqz	t1,_b0df0
	  nop
	ori	t1,t3,0x80
	sb	t1,18(k1)
	  li	s6,0

_b0df0:
	bnez	s6,_b10a8
	  nop
	andi	t1,t3,0x1
	beqz	t1,_b1114
	  nop
	lw	t9,32(k1)
	lw	k0,32(k1)
	andi	t1,t9,0x60
	beqz	t1,_b0f34
	  nop
	li	s6,0
	li	s7,1
	andi	t1,t9,0xff00
	srl	t1,t1,0x8
	beqz	t1,_b0e60
	  addi	t0,t1,-1
	beqz	t0,_b0e7c
	  addi	t0,t1,-2
	beqz	t0,_b0e94
	  addi	t0,t1,-3
	beqz	t0,_b0eb4
	  addi	t0,t1,-4
	beqz	t0,_b0eec
	  addi	t0,t1,-5
	beqz	t0,_b0f0c
	  nop
	b	_b108c
	  nop

_b0e60:
	lui	s4,0xbfc0
	addiu	s4,s4,4796
	li	s5,8
	li	s6,1
	li	s7,0
	b	_b108c
	  nop

_b0e7c:
	lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s4,t1,t0
	b	_b108c
	  nop

_b0e94:
	lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s5,t1,t0
	li	t1,72
	sb	t1,18(k1)
	  b	_b1120
	nop

_b0eb4:
	lui	t0,0x8000
	addi	t1,t0,16352

_b0ebc:
	cache	Index_Invalidate_I,0(t0)
	cache	Index_Writeback_Inv_D,0(t0)
	bne	t0,t1,_b0ebc
	  addiu	t0,t0,32
	sync
	.word	0x40088007
	nop
	ori	t0,t0,0x2
	.word	0x40888007
	nop
	b	_b108c
	  nop

_b0eec:
	li	t1,72
	sb	t1,18(k1)
	  lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s4,t1,t0
	b	_b00e0
	  li	s3,16384

_b0f0c:
	li	t1,72
	sb	t1,18(k1)
	  lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s4,t1,t0
	jalr	s4
	  nop
	b	_b0c88
	  nop

_b0f34:
	andi	t4,t9,0xff00
	srl	t4,t4,0x8
	addi	t1,t4,-5
	bnez	t1,_b0f5c
	  nop
	srl	t1,t9,0x10
	sb	t1,0(k1)
	  li	s7,1
	b	_b108c
	  nop

_b0f5c:
	addi	t1,t4,-9
	bnez	t1,_b0f74
	  nop
	li	s7,1
	b	_b108c
	  nop

_b0f74:
	addi	t1,t4,-6
	bnez	t1,_b108c
	  li	s7,1
	li	s7,0
	srl	t1,t9,0x18
	addi	t0,t1,-1
	beqz	t0,_b0fb8
	  srl	s5,k0,0x10
	addi	t0,t1,-2
	beqz	t0,_b1000
	  addi	t0,t1,-3
	beqz	t0,_b103c
	  addi	t0,t1,-6
	beqz	t0,_b0fdc
	  nop
	b	_b108c
	  nop

_b0fb8:
	lui	s4,0xbfc0
	addiu	s4,s4,4632
	li	s6,1
	addi	t0,s5,-18
	blez	t0,_b108c
	  nop
	li	s5,18
	b	_b108c
	  nop

_b0fdc:
	lui	s4,0xbfc0
	addiu	s4,s4,4652
	li	s6,1
	addi	t0,s5,-10
	blez	t0,_b108c
	  nop
	li	s5,10
	b	_b108c
	  nop

_b1000:
	lui	s4,0xbfc0
	addiu	s4,s4,4696
	lbu	t0,1(k1)
	andi	t0,t0,0x10
	beqz	t0,_b1020
	  nop
	lui	s4,0xbfc0
	addiu	s4,s4,4664

_b1020:
	li	s6,1
	addi	t0,s5,-32
	blez	t0,_b108c
	  nop
	li	s5,32
	b	_b108c
	  nop

_b103c:
	li	s6,1
	srl	t1,t9,0x10
	andi	t1,t1,0xff
	addi	t0,t1,-1
	beqz	t0,_b106c
	  addi	t0,t1,-2
	beqz	t0,_b107c
	  nop
	lui	s4,0xbfc0
	addiu	s4,s4,4728
	b	_b108c
	  li	s5,4

_b106c:
	lui	s4,0xbfc0
	addiu	s4,s4,4732
	b	_b108c
	  li	s5,16

_b107c:
	lui	s4,0xbfc0
	addiu	s4,s4,4748
	b	_b108c
	  li	s5,46

_b108c:
	li	t1,64
	beqz	s7,_b109c
	  nop
	ori	t1,t1,0x8

_b109c:
	sb	t1,18(k1)
	  beqz	s6,_b1114
	  nop

_b10a8:
	addi	t1,s6,-1
	bnez	t1,_b1114
	  nop
	addi	t1,s5,-64
	blez	t1,_b10c4
	  ori	s3,s5,0x0
	li	s3,64

_b10c4:
	beqz	s3,_b10f0
	  ori	s2,s3,0x0
	sub	s5,s5,s3

_b10d0:
	lbu	t1,0(s4)
	sb	t1,32(k1)
	  addi	s3,s3,-1
	bnez	s3,_b10d0
	  addi	s4,s4,1
	addi	t1,s2,-64
	beqz	t1,_b1104
	  nop

_b10f0:
	li	t1,10
	sb	t1,18(k1)
	  li	s6,0
	b	_b1114
	  nop

_b1104:
	li	t1,2
	sb	t1,18(k1)
	  b	_b1114
	nop

_b1114:
	andi	t1,t2,0x2
	beqz	t1,_b11a0
	  nop

_b1120:
	li	t1,1
	sb	t1,14(k1)
	  lbu	t1,18(k1)
	andi	t0,t1,0x2
	bnez	t0,_b11a0
	  nop
	lhu	t1,16(k1)
	sub	t0,s5,t1
	  blez	t0,_b114c
	  ori	s3,s5,0x0
	ori	s3,t1,0x0

_b114c:
	beqz	s3,_b11a0
	  nop
	sub	s5,s5,s3
	  srl	a1,s3,0x2
	andi	a2,s3,0x3
	beqz	a1,_b117c
	  nop

_b1168:
	lw	t1,0(s4)
	sw	t1,36(k1)
	addi	a1,a1,-1
	bnez	a1,_b1168
	  addiu	s4,s4,4

_b117c:
	beqz	a2,_b1198
	  nop

_b1184:
	lbu	t1,0(s4)
	sb	t1,36(k1)
	  addi	a2,a2,-1
	bnez	a2,_b1184
	  addiu	s4,s4,1

_b1198:
	li	t1,1
	sb	t1,18(k1)

_b11a0:
	lhu	t1,4(k1)
	andi	t1,t1,0x2
	beqz	t1,_b1210
	  nop
	li	t1,1
	sb	t1,14(k1)
	  lbu	t1,22(k1)
	andi	t1,t1,0x1
	beqz	t1,_b1210
	  nop
	lhu	s3,24(k1)
	srl	a1,s3,0x2
	andi	a2,s3,0x3
	beqz	a1,_b11f0
	  nop

_b11dc:
	lw	t1,36(k1)
	sw	t1,0(s4)
	addi	a1,a1,-1
	bnez	a1,_b11dc
	  addiu	s4,s4,4

_b11f0:
	beqz	a2,_b120c
	  nop

_b11f8:
	lbu	t1,36(k1)
	sb	t1,0(s4)
	  addi	a2,a2,-1
	bnez	a2,_b11f8
	  addiu	s4,s4,1

_b120c:
	sb	zero,22(k1)

_b1210:
	.word	0x1000febb
	.word	0x00000000
	.word	0x02000112
	.word	0x40000000
	.word	0x4750601a
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
	.word	0x00350037
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
	.word	0x31563035

_b12c4:
	li	t0,1
	sh	t0,0(s4)

_b12cc:
	lui	t3,0xb002
	ori	t3,t3,0x1004
	lw	t4,0(t3)
	andi	t4,t4,0x100
	beqz	t4,_b1300
	  nop
	nop
	nop
	nop
	nop
	nop
	b	_b12cc
	  nop

_b1300:
	sb	s5,44(s4)
	  sw	s6,48(s4)
	sw	s7,12(s4)
	li	t0,0xfffb
	sw	t0,36(s4)
	li	t2,6
	sh	t2,0(s4)

_b131c:
	lw	t3,4(s4)
	andi	t3,t3,0x800
	beqz	t3,_b131c
	  nop
	li	t1,4
	sh	t1,40(s4)
	beqz	t8,_b1350
	  nop
	lui	t0,0xb002
	ori	t0,t0,0x1034
	lh	t9,0(t0)
	lh	k0,0(t0)
	lh	k1,0(t0)

_b1350:
	jr	ra
	  nop

_b1358:
	addu	a1,a0,zero
	lui	at,0x4d53
	ori	at,at,0x504c
	sub	a1,a1,at
	  bnez	a1,usb_boot
	  nop
	b	_b1384
	  nop

_b1378:
	addi	t1,t1,-16
	beqz	t1,_b1358
	  nop

_b1384:
	addi	t1,t1,16
	b	_b1414
	  nop

_b1390:
	li	s5,16
	li	s6,512
	li	s7,1
	li	t8,1
	jal	_b12c4
	  nop
	li	t5,512
	sh	t5,24(s4)
	li	t5,16
	sh	t5,28(s4)
	li	s5,18
	li	s6,0
	li	s7,9
	li	t8,1
	jal	_b12c4
	  nop
	ori	v0,gp,0x0
	li	s0,8192
	li	v1,0
	li	s1,2048

_b13e0:
	beqz	s1,_b1490
	  nop
	lui	t2,0xb002
	ori	t2,t2,0x1028
	lw	t3,0(t2)
	andi	t3,t3,0x20
	beqz	t3,_b13e0
	  nop
	li	t1,16

_b1404:
	lw	a0,56(s4)
	addi	s1,s1,-2048
	beqz	s1,_b1378
	  nop

_b1414:
	addi	s1,s1,2048
	sw	a0,0(v0)
	addiu	v0,v0,4
	addi	t1,t1,-1
	bnez	t1,_b1404
	  nop
	addi	s1,s1,-16
	addi	v1,v1,64
	bne	v1,s0,_b13e0
	  nop
	li	s5,12
	li	s6,0
	li	s7,65
	li	t8,1
	jal	_b12c4
	  nop
	li	t0,1
	sh	t0,0(s4)

_b145c:
	lui	t3,0xb002
	ori	t3,t3,0x1004
	lw	t4,0(t3)
	andi	t4,t4,0x100
	beqz	t4,_b1490
	  nop
	nop
	nop
	nop
	nop
	nop
	b	_b145c
	  nop

_b1490:
	b	_b1720
	  nop

msc0_boot:
	lui	t1,0x1000
	ori	t1,t1,0x300
	sw	t1,580(sp)
	sw	t1,632(sp)
	sw	t1,596(sp)
	sw	t1,564(sp)
	lui	s4,0xb002
	ori	s4,s4,0x1000
	li	t2,8
	sh	t2,0(s4)

_b14c0:
	lui	t3,0xb002
	ori	t3,t3,0x1004
	lw	t4,0(t3)
	andi	t4,t4,0x8000
	bnez	t4,_b14c0
	  nop
	li	t2,0xffff
	sw	t2,36(s4)
	li	t3,0xffff
	sh	t3,40(s4)
	li	t2,6
	sh	t2,8(s4)
	li	s5,12
	li	s6,0
	li	s7,65
	li	t8,1
	jal	_b12c4
	  nop
	li	s5,0
	li	s6,0
	li	s7,128
	li	t8,0
	jal	_b12c4
	  nop
	li	s5,8
	li	s6,426
	li	s7,1
	li	t8,1
	jal	_b12c4
	  nop
	li	s5,55
	li	s6,0
	li	s7,1
	li	t8,1
	jal	_b12c4
	  nop
	andi	t0,k1,0x20
	beqz	t0,_b1574
	  nop
	srl	t0,t9,0x8
	li	t1,55
	beq	t0,t1,_b1628
	  nop
	b	_b1574
	  nop

_b1574:
	li	s5,1
	lui	s6,0x40ff
	ori	s6,s6,0x8080
	li	s7,3
	li	t8,3
	jal	_b12c4
	  nop
	andi	t6,t9,0x80
	bnez	t6,_b15b4
	  nop
	li	t2,5500

_b15a0:
	addi	t2,t2,-1
	bnez	t2,_b15a0
	  nop
	b	_b1574
	  nop

_b15b4:
	li	s5,2
	li	s6,0
	li	s7,2
	li	t8,2
	jal	_b12c4
	  nop
	li	s5,3
	li	s6,16
	li	s7,1
	li	t8,1
	jal	_b12c4
	  nop
	li	t2,0
	sw	t2,8(s4)
	li	s5,7
	li	s6,16
	li	s7,1
	li	t8,1
	jal	_b12c4
	  nop
	li	s5,6
	lui	s6,0x3b7
	ori	s6,s6,0x1
	li	s7,1
	li	t8,1
	jal	_b12c4
	  nop
	jal	_b1390
	  nop

_b1628:
	li	s5,55
	li	s6,0
	li	s7,1
	li	t8,1
	jal	_b12c4
	  nop
	li	s5,41
	lui	s6,0x40ff
	ori	s6,s6,0x8000
	li	s7,3
	li	t8,3
	jal	_b12c4
	  nop
	andi	t6,t9,0x80
	bnez	t6,_b1680
	  nop
	li	t2,5500

_b166c:
	addi	t2,t2,-1
	bnez	t2,_b166c
	  nop
	b	_b1628
	  nop

_b1680:
	li	s5,2
	li	s6,0
	li	s7,2
	li	t8,2
	jal	_b12c4
	  nop
	li	s5,3
	li	s6,0
	li	s7,6
	li	t8,1
	jal	_b12c4
	  nop
	andi	t9,t9,0xff
	sll	t9,t9,0x8
	andi	k0,k0,0xffff
	srl	k0,k0,0x8
	or	s3,t9,k0
	sll	s3,s3,0x10
	li	t2,0
	sw	t2,8(s4)
	li	s5,7
	ori	s6,s3,0x0
	li	s7,65
	li	t8,1
	jal	_b12c4
	  nop
	li	s5,55
	ori	s6,s3,0x0
	li	s7,1
	li	t8,1
	jal	_b12c4
	  nop
	li	s5,6
	li	s6,0
	li	s7,1
	li	t8,1
	jal	_b12c4
	  nop
	jal	_b1390
	  nop

_b1720:
	li	s3,8192
	b	_b00e0
	  ori	s4,gp,0x4

.data
.section .data.1ffc
	.word		0x422b
