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
	bne	t0,at,_b0054
	  nop


	lui	t1,0xb000
	ori	t1,t1,0x303c
	li	t0,0xa55a
	sw	t0,0(t1)

_b002c:
	lui	t1,0xb000
	ori	t1,t1,0x3000
	lw	t0,0(t1)
	andi	t0,t0,0x80
	beqz	t0,_b002c
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x3020
	li	t0,1
	sw	t0,0(t1)

_b0054:
	lui	t1,0xb000
	ori	t1,t1,0x1008
	lui	t0,0xffff
	ori	t0,t0,0xffff
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x1028
	lui	t0,0xffff
	ori	t0,t0,0xffff
	sw	t0,0(t1)
	lui	gp,0x8000
	lui	sp,0xb001
	lui	s8,0xb341
	lui	t1,0x400
	sw	t1,24(sp)
	sw	t1,40(sp)
	sw	t1,56(sp)
	sw	t1,68(sp)
	lui	t1,0xe
	sw	t1,888(sp)
	lw	t1,768(sp)
	srl	t1,t1,0x11
	andi	s5,t1,0x7
	li	t1,3
	beq	s5,t1,_b0188
	  nop
	li	v0,3
	mtc0	v0,$16
	nop
	lui	v0,0x2000
	mtc0	v0,$26
	ori	v0,gp,0x0
	ori	v1,v0,0x3fe0
	mtc0	zero,$28
	.word	0x4080e001

_b00e0:
	cache	0x8,0(v0)
	cache	0x9,0(v0)
	bne	v0,v1,_b00e0
	  addiu	v0,v0,32
	ori	v0,gp,0x0
	ori	v1,v0,0x3fe0
	lui	a0,0x1fff
	ori	a0,a0,0xf000

_b0100:
	and	a1,v0,a0
	ori	a1,a1,0x1
	mtc0	a1,$28
	cache	0x8,0(v0)
	cache	0x9,0(v0)
	bne	v0,v1,_b0100
	  addiu	v0,v0,32
	li	t0,7
	beq	s5,t0,_b06d4
	  nop
	li	t0,4
	beq	s5,t0,_b1af4
	  nop
	li	t0,5
	beq	s5,t0,_b025c
	  nop
	li	t0,0
	beq	s5,t0,_b1ecc
	  nop
	b	_b0f98
	  nop

_b0154:
	ori	v0,gp,0x0
	add	v1,v0,s3
	addiu	v1,v1,-4

_b0160:
	lw	a0,0(v0)
	.word	0x4084e001
	cache	0xc,0(v0)
	bne	v0,v1,_b0160
	  addiu	v0,v0,4
	mtc0	zero,$26
	jalr	s4
	  nop
	b	_b128c
	  nop

_b0188:
	lui	t1,0x40
	sw	t1,68(sp)
	lui	t1,0x843
	ori	t1,t1,0xff
	sw	t1,24(sp)
	sw	t1,40(sp)
	sw	t1,56(sp)
	sw	t1,72(sp)
	sw	t1,116(sp)
	li	t1,63
	sw	t1,280(sp)
	sw	t1,296(sp)
	sw	t1,312(sp)
	sw	t1,328(sp)
	sw	t1,372(sp)
	lui	t3,0xfff
	ori	t3,t3,0x7700
	lui	t4,0xb800
	lbu	t0,0(t4)
	beqz	t0,_b0208
	  nop
	li	t1,16
	bne	t1,t0,_b0f98
	  nop
	li	t2,0xffff
	sw	t2,24(sp)
	sw	t2,40(sp)
	sw	t2,56(sp)
	sw	t2,72(sp)
	sw	t2,116(sp)
	lui	t3,0xfff
	ori	t3,t3,0x7740

_b0208:
	sw	t3,24(s8)
	addiu	t4,t4,4
	jr	t4
	  nop

_b0218:
	lui	t1,0x3c
	sw	t1,120(sp)
	lhu	t1,4(k1)
	li	t0,32767
	and	t1,t1,t0
	sh	t1,4(k1)
	jr	ra
	  nop

_b0238:
	li	t0,0xffff

_b023c:
	beqz	t0,_b0254
	  addi	t0,t0,-1
	lw	t1,12(k1)
	andi	t1,t1,0x10
	bnez	t1,_b023c
	  nop

_b0254:
	jr	ra
	  nop

_b025c:
	lui	k1,0xb004
	ori	k1,k1,0x3000
	lui	t1,0x2c
	sw	t1,24(sp)
	sw	t1,40(sp)
	sw	t1,52(sp)
	sw	t1,72(sp)
	lui	t1,0x10
	sw	t1,24(sp)
	sw	t1,40(sp)
	sw	t1,56(sp)
	sw	t1,68(sp)
	li	t1,11
	sw	t1,24(k1)
	lui	t1,0x3c00
	ori	t1,t1,0x60
	sw	t1,8(k1)
	li	t1,0x8086
	sw	t1,4(k1)
	lui	t1,0x3c
	sw	t1,116(sp)
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

_b02dc:
	beqz	a3,_b034c
	  addi	a3,a3,-1
	lw	t1,12(k1)
	srl	t1,t1,0x8
	andi	t1,t1,0xff
	li	t0,5
	bne	t1,t0,_b02dc
	  nop
	lw	t1,4(k1)
	ori	t1,t1,0x6
	sw	t1,4(k1)

_b0308:
	lw	t1,12(k1)
	andi	t1,t1,0x10
	beqz	t1,_b0308
	  nop
	sb	zero,0(k1)
	  jal	_b0238
	  nop
	lbu	v1,0(k1)
	li	t0,4
	beq	v1,t0,_b035c
	  nop
	li	t0,3
	beq	v1,t0,_b036c
	  nop
	li	t0,2
	beq	v1,t0,_b037c
	  nop

_b034c:
	jal	_b0218
	  nop
	b	_b0f98
	  nop

_b035c:
	sb	zero,0(k1)
	  jal	_b0238
	  nop
	lbu	t1,0(k1)

_b036c:
	sb	zero,0(k1)
	  jal	_b0238
	  nop
	lbu	t1,0(k1)

_b037c:
	sb	zero,0(k1)
	  jal	_b0238
	  nop
	lbu	t1,0(k1)
	li	t0,85
	bne	t1,t0,_b034c
	  nop
	sb	zero,0(k1)
	  jal	_b0238
	  nop
	lbu	t1,0(k1)
	li	t0,170
	bne	t1,t0,_b034c
	  nop
	sb	zero,0(k1)
	  jal	_b0238
	  nop
	lbu	t1,0(k1)
	li	t0,85
	bne	t1,t0,_b034c
	  nop
	sb	zero,0(k1)
	  jal	_b0238
	  nop
	lbu	t1,0(k1)
	li	t0,170
	bne	t1,t0,_b034c
	  nop
	sb	zero,0(k1)
	  jal	_b0238
	  nop
	lbu	t2,0(k1)
	jal	_b0218
	  nop
	sb	t2,24(k1)
	  lhu	t1,4(k1)
	li	t0,0x8000
	or	t1,t1,t0
	sh	t1,4(k1)
	lui	t1,0x3c
	sw	t1,116(sp)
	li	t1,3
	sb	t1,0(k1)
	  sb	zero,0(k1)
	sb	zero,0(k1)
	  li	t0,2
	beq	v1,t0,_b0450
	  nop
	sb	zero,0(k1)
	  li	t0,3
	beq	v1,t0,_b0450
	  nop
	sb	zero,0(k1)

_b0450:
	lw	t1,12(k1)
	srl	t1,t1,0x8
	andi	t1,t1,0xff
	addi	t0,v1,1
	bne	t1,t0,_b0450
	  nop
	lw	t1,4(k1)
	ori	t1,t1,0x6
	sw	t1,4(k1)

_b0474:
	lw	t1,12(k1)
	andi	t1,t1,0x10
	beqz	t1,_b0474
	  nop
	move	v0,gp
	li	a3,63

_b048c:
	li	t2,128

_b0490:
	sw	zero,0(k1)
	nop
	addi	t2,t2,-1
	bnez	t2,_b0490
	  nop

_b04a4:
	lw	t1,12(k1)
	srl	t1,t1,0x8
	andi	t1,t1,0xff
	li	t0,128
	bne	t1,t0,_b04a4
	  nop
	li	t2,127

_b04c0:
	lbu	t1,0(k1)
	sb	t1,0(v0)
	  addi	v0,v0,1
	bnez	t2,_b04c0
	  addi	t2,t2,-1
	bnez	a3,_b048c
	  addi	a3,a3,-1
	jal	_b0218
	  nop
	li	s3,8192
	b	_b0154
	  ori	s4,gp,0x8

_b04f0:
	.space	0x80

_b0570:
	lw	s4,0(sp)
	srl	s4,s4,0x14
	andi	s4,s4,0x1
	beqz	s4,_b0570
	  nop
	jr	ra
	  nop

_b058c:
	li	t0,0
	ori	t1,t5,0x0
	bnez	s7,_b05c0
	  nop

_b059c:
	lbu	t2,0(k0)
	sb	t2,0(t1)
	  addi	t1,t1,1
	addi	t0,t0,1
	li	at,160
	bne	t0,at,_b059c
	  nop
	b	_b05dc
	  nop

_b05c0:
	lhu	t2,0(k0)
	sh	t2,0(t1)
	addi	t1,t1,2
	addi	t0,t0,2
	li	at,160
	bne	t0,at,_b05c0
	  nop

_b05dc:
	jr	ra
	  nop

_b05e4:
	li	t0,0
	li	t3,0
	li	t4,0
	add	t1,t5,a3

_b05f4:
	lbu	t2,0(t1)
	li	at,85
	bne	t2,at,_b0608
	  nop
	addi	t3,t3,1

_b0608:
	li	at,170
	bne	t2,at,_b0618
	  nop
	addi	t4,t4,1

_b0618:
	addi	t0,t0,1
	addi	t1,t1,1
	li	at,32
	bne	t0,at,_b05f4
	  nop
	addi	t3,t3,-7
	bgtz	t3,_b0650
	  nop
	addi	t4,t4,-7
	bgtz	t4,_b065c
	  nop
	li	t7,255
	jr	ra
	  nop

_b0650:
	li	t7,85
	jr	ra
	  nop

_b065c:
	li	t7,170
	jr	ra
	  nop

_b0668:
	srl	t1,t3,0x1
	sll	t1,t1,0x2
	addi	t1,t1,60
	add	t1,t1,t6
	lw	t2,0(t1)
	andi	t1,t3,0x1
	beqz	t1,_b068c
	  nop
	srl	t2,t2,0x10

_b068c:
	andi	t2,t2,0x1fff
	addiu	t1,t2,-2048
	bgtz	t1,_b06cc
	  nop
	beqz	t2,_b06cc
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

_b06cc:
	jr	ra
	  nop

_b06d4:
	lui	t6,0xb34d
	li	t1,255
	sw	t1,24(sp)
	sw	t1,40(sp)
	sw	t1,56(sp)
	sw	t1,72(sp)
	lui	t1,0x2c
	sw	t1,24(sp)
	sw	t1,40(sp)
	sw	t1,56(sp)
	sw	t1,72(sp)
	sw	t1,116(sp)
	li	t1,3
	sw	t1,280(sp)
	sw	t1,296(sp)
	sw	t1,312(sp)
	sw	t1,328(sp)
	sw	t1,372(sp)
	lui	t1,0x10
	sw	t1,24(sp)
	sw	t1,36(sp)
	sw	t1,52(sp)
	lui	t1,0xfff
	ori	t1,t1,0x7700
	sw	t1,20(s8)
	li	t1,3
	sw	t1,80(s8)
	lui	t8,0xba80
	lui	t9,0xba40
	lui	k0,0xba00
	li	a1,0

_b0750:
	addiu	t1,a1,-1280
	bgtz	t1,_b0f98
	  nop
	li	t1,255
	sb	t1,0(t9)
	  jal	_b04f0
	  nop
	li	k1,48
	li	s5,0
	li	s7,0
	lui	t5,0x8000
	ori	t5,t5,0x2800

_b0780:
	sb	zero,0(t9)
	  beqz	s5,_b0790
	  sb	zero,0(t8)
	  sb	zero,0(t8)

_b0790:
	sb	a1,0(t8)
	  srl	t1,a1,0x8
	sb	t1,0(t8)
	  srl	t1,a1,0x10
	sb	t1,0(t8)
	  beqz	s5,_b07b0
	  nop
	sb	k1,0(t9)

_b07b0:
	jal	_b04f0
	  nop
	jal	_b058c
	  nop
	li	a3,0
	jal	_b05e4
	  nop
	li	at,85
	beq	t7,at,_b07fc
	  nop
	li	at,170
	beq	t7,at,_b0808
	  nop
	beqz	s5,_b07f4
	  nop
	b	_b0750
	  addiu	a1,a1,64

_b07f4:
	b	_b0780
	  li	s5,1

_b07fc:
	li	s7,0
	b	_b080c
	  nop

_b0808:
	li	s7,1

_b080c:
	beqz	s7,_b0874
	  nop
	lui	t1,0xfff
	ori	t1,t1,0x7740
	sw	t1,20(s8)
	li	t1,0xffff
	sw	t1,24(sp)
	sw	t1,40(sp)
	sw	t1,56(sp)
	sw	t1,72(sp)
	sb	zero,0(t9)
	  beqz	s5,_b0844
	  sb	zero,0(t8)
	  sb	zero,0(t8)

_b0844:
	sb	a1,0(t8)
	  srl	t1,a1,0x8
	sb	t1,0(t8)
	  srl	t1,a1,0x10
	sb	t1,0(t8)
	  beqz	s5,_b0864
	  nop
	sb	k1,0(t9)

_b0864:
	jal	_b04f0
	  nop
	jal	_b058c
	  nop

_b0874:
	li	a3,64
	jal	_b05e4
	  nop
	li	at,170
	beq	t7,at,_b0898
	  nop
	li	s6,0
	b	_b089c
	  nop

_b0898:
	li	s6,1

_b089c:
	li	a3,96
	jal	_b05e4
	  nop
	addu	s0,t7,zero
	li	a3,128
	jal	_b05e4
	  nop
	li	at,170
	beq	s0,at,_b08e8
	  nop
	li	at,170
	beq	t7,at,_b08dc
	  nop
	li	s5,0
	b	_b0904
	  nop

_b08dc:
	li	s5,1
	b	_b0904
	  nop

_b08e8:
	li	at,170
	beq	t7,at,_b0900
	  nop
	li	s5,2
	b	_b0904
	  nop

_b0900:
	li	s5,3

_b0904:
	b	_b090c
	  nop

_b090c:
	li	s0,256
	li	s1,2
	li	s2,78
	li	s3,16
	beqz	s5,_b0960
	  nop
	li	s1,8
	li	s2,312
	li	s3,4
	li	at,1
	beq	s5,at,_b0960
	  nop
	li	s1,16
	li	s2,624
	li	s3,2
	li	at,2
	beq	s5,at,_b0960
	  nop
	li	s1,32
	li	s2,1248
	li	s3,1

_b0960:
	ori	v0,gp,0x0
	addiu	t0,gp,12288
	beqz	s7,_b0978
	  nop
	b	_b0c80
	  nop

_b0978:
	li	a2,1

_b097c:
	sb	zero,0(t9)
	  beqz	s5,_b098c
	  sb	zero,0(t8)
	  sb	zero,0(t8)

_b098c:
	addi	t1,a1,1
	sb	t1,0(t8)
	  srl	a0,t1,0x8
	beqz	s6,_b09a8
	  sb	a0,0(t8)
	  srl	a0,t1,0x10
	sb	a0,0(t8)

_b09a8:
	beqz	s5,_b09b4
	  nop
	sb	k1,0(t9)

_b09b4:
	jal	_b04f0
	  nop
	li	v1,1
	ori	t1,t0,0x0
	li	t2,3
	sw	t2,256(s8)

_b09cc:
	lbu	a0,0(k0)
	sb	a0,0(t1)
	  addiu	t1,t1,1
	bne	v1,s2,_b09cc
	  addiu	v1,v1,1
	sw	zero,256(s8)
	sw	zero,80(s8)
	li	t1,3
	sw	t1,80(s8)
	nop
	nop
	sb	zero,0(t9)
	  beqz	s5,_b0a08
	  sb	zero,0(t8)
	  sb	zero,0(t8)

_b0a08:
	sb	a1,0(t8)
	  srl	a0,a1,0x8
	beqz	s6,_b0a20
	  sb	a0,0(t8)
	  srl	a0,a1,0x10
	sb	a0,0(t8)

_b0a20:
	beqz	s5,_b0a2c
	  nop
	sb	k1,0(t9)

_b0a2c:
	jal	_b04f0
	  nop
	li	a3,1
	li	v1,1

_b0a3c:
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
	bne	a2,at,_b0a80
	  nop
	li	at,1
	beq	a3,at,_b0a88
	  nop

_b0a80:
	li	t2,3
	sw	t2,256(s8)

_b0a88:
	lbu	a0,0(k0)
	sb	a0,0(v0)
	  addiu	v0,v0,1
	bne	v1,s0,_b0a88
	  addiu	v1,v1,1
	sw	zero,256(s8)
	sub	t2,v0,s0

_b0aa4:
	lbu	t1,0(t2)
	sb	t1,16(t6)
	  addiu	t2,t2,1
	bne	t2,v0,_b0aa4
	  nop
	li	t1,39
	addiu	t2,a3,-1
	.word	0x71495002
	add	t2,t0,t2

_b0ac8:
	lbu	t3,0(t2)
	sb	t3,16(t6)
	  addiu	t2,t2,1
	addi	t1,t1,-1
	bgtz	t1,_b0ac8
	  nop

_b0ae0:
	lw	t1,108(t6)
	andi	t1,t1,0x8
	beqz	t1,_b0ae0
	  nop
	li	t1,1
	sw	t1,8(t6)
	lw	t1,108(t6)
	andi	t2,t1,0x1
	beqz	t2,_b0c60
	  nop
	andi	t2,t1,0x2
	bnez	t2,_b0c48
	  nop
	srl	t1,t1,0x1b
	beqz	t1,_b0c60
	  nop
	li	t3,23
	jal	_b0668
	  nop
	li	t3,22
	jal	_b0668
	  nop
	li	t3,21
	jal	_b0668
	  nop
	li	t3,20
	jal	_b0668
	  nop
	li	t3,19
	jal	_b0668
	  nop
	li	t3,18
	jal	_b0668
	  nop
	li	t3,17
	jal	_b0668
	  nop
	li	t3,16
	jal	_b0668
	  nop
	li	t3,15
	jal	_b0668
	  nop
	li	t3,14
	jal	_b0668
	  nop
	li	t3,13
	jal	_b0668
	  nop
	li	t3,12
	jal	_b0668
	  nop
	li	t3,11
	jal	_b0668
	  nop
	li	t3,10
	jal	_b0668
	  nop
	li	t3,9
	jal	_b0668
	  nop
	li	t3,8
	jal	_b0668
	  nop
	li	t3,7
	jal	_b0668
	  nop
	li	t3,6
	jal	_b0668
	  nop
	li	t3,5
	jal	_b0668
	  nop
	li	t3,4
	jal	_b0668
	  nop
	li	t3,3
	jal	_b0668
	  nop
	li	t3,2
	jal	_b0668
	  nop
	li	t3,1
	jal	_b0668
	  nop
	li	t3,0
	jal	_b0668
	  nop
	b	_b0c60
	  nop

_b0c48:
	lui	t1,0xffff
	ori	t1,t1,0xffe0
	and	a1,a1,t1
	addiu	a1,a1,64
	b	_b0750
	  nop

_b0c60:
	li	v1,1
	bne	a3,s1,_b0a3c
	  addiu	a3,a3,1
	addiu	a1,a1,2
	bne	a2,s3,_b097c
	  addiu	a2,a2,1
	b	_b0f88
	  nop

_b0c80:
	li	a2,1

_b0c84:
	sb	zero,0(t9)
	  beqz	s5,_b0c94
	  sb	zero,0(t8)
	  sb	zero,0(t8)

_b0c94:
	addi	t1,a1,1
	sb	t1,0(t8)
	  srl	a0,t1,0x8
	beqz	s6,_b0cb0
	  sb	a0,0(t8)
	  srl	a0,t1,0x10
	sb	a0,0(t8)

_b0cb0:
	beqz	s5,_b0cbc
	  nop
	sb	k1,0(t9)

_b0cbc:
	jal	_b04f0
	  nop
	li	v1,2
	ori	t1,t0,0x0
	li	t2,3
	sw	t2,256(s8)

_b0cd4:
	lhu	a0,0(k0)
	sh	a0,0(t1)
	addiu	t1,t1,2
	bne	v1,s2,_b0cd4
	  addiu	v1,v1,2
	sw	zero,256(s8)
	sw	zero,80(s8)
	li	t1,3
	sw	t1,80(s8)
	nop
	nop
	sb	zero,0(t9)
	  beqz	s5,_b0d10
	  sb	zero,0(t8)
	  sb	zero,0(t8)

_b0d10:
	sb	a1,0(t8)
	  srl	a0,a1,0x8
	beqz	s6,_b0d28
	  sb	a0,0(t8)
	  srl	a0,a1,0x10
	sb	a0,0(t8)

_b0d28:
	beqz	s5,_b0d34
	  nop
	sb	k1,0(t9)

_b0d34:
	jal	_b04f0
	  nop
	li	a3,1
	li	v1,2

_b0d44:
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
	bne	a2,at,_b0d88
	  nop
	li	at,1
	beq	a3,at,_b0d90
	  nop

_b0d88:
	li	t2,3
	sw	t2,256(s8)

_b0d90:
	lhu	a0,0(k0)
	sh	a0,0(v0)
	addiu	v0,v0,2
	bne	v1,s0,_b0d90
	  addiu	v1,v1,2
	sw	zero,256(s8)
	sub	t2,v0,s0

_b0dac:
	lbu	t1,0(t2)
	sb	t1,16(t6)
	  addiu	t2,t2,1
	bne	t2,v0,_b0dac
	  nop
	li	t1,39
	addiu	t2,a3,-1
	.word	0x71495002
	add	t2,t0,t2

_b0dd0:
	lbu	t3,0(t2)
	sb	t3,16(t6)
	  addiu	t2,t2,1
	addi	t1,t1,-1
	bgtz	t1,_b0dd0
	  nop

_b0de8:
	lw	t1,108(t6)
	andi	t1,t1,0x8
	beqz	t1,_b0de8
	  nop
	li	t1,1
	sw	t1,8(t6)
	lw	t1,108(t6)
	andi	t2,t1,0x1
	beqz	t2,_b0f68
	  nop
	andi	t2,t1,0x2
	bnez	t2,_b0f50
	  nop
	srl	t1,t1,0x1b
	beqz	t1,_b0f68
	  nop
	li	t3,23
	jal	_b0668
	  nop
	li	t3,22
	jal	_b0668
	  nop
	li	t3,21
	jal	_b0668
	  nop
	li	t3,20
	jal	_b0668
	  nop
	li	t3,19
	jal	_b0668
	  nop
	li	t3,18
	jal	_b0668
	  nop
	li	t3,17
	jal	_b0668
	  nop
	li	t3,16
	jal	_b0668
	  nop
	li	t3,15
	jal	_b0668
	  nop
	li	t3,14
	jal	_b0668
	  nop
	li	t3,13
	jal	_b0668
	  nop
	li	t3,12
	jal	_b0668
	  nop
	li	t3,11
	jal	_b0668
	  nop
	li	t3,10
	jal	_b0668
	  nop
	li	t3,9
	jal	_b0668
	  nop
	li	t3,8
	jal	_b0668
	  nop
	li	t3,7
	jal	_b0668
	  nop
	li	t3,6
	jal	_b0668
	  nop
	li	t3,5
	jal	_b0668
	  nop
	li	t3,4
	jal	_b0668
	  nop
	li	t3,3
	jal	_b0668
	  nop
	li	t3,2
	jal	_b0668
	  nop
	li	t3,1
	jal	_b0668
	  nop
	li	t3,0
	jal	_b0668
	  nop
	b	_b0f68
	  nop

_b0f50:
	lui	t1,0xffff
	ori	t1,t1,0xffe0
	and	a1,a1,t1
	addiu	a1,a1,64
	b	_b0750
	  nop

_b0f68:
	li	v1,2
	bne	a3,s1,_b0d44
	  addiu	a3,a3,1
	addiu	a1,a1,2
	bne	a2,s3,_b0c84
	  addiu	a2,a2,1
	b	_b0f88
	  nop

_b0f88:
	sw	zero,80(s8)
	li	s3,8192
	b	_b0154
	  addiu	s4,gp,160

_b0f98:
	mflo	a0
	lw	t1,768(sp)
	srl	t1,t1,0x11
	andi	s5,t1,0x7
	li	t0,6
	beq	s5,t0,_b11b0
	  nop
	li	t0,1
	beq	s5,t0,_b11e0
	  nop
	li	t0,2
	beq	s5,t0,_b1224
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
	li	t0,544
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
	ori	t1,t1,0x20e4
	sw	zero,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x2014
	li	t0,0x8001
	sh	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x20e4

_b107c:
	lw	t0,0(t1)
	lui	v0,0x4
	ori	v0,v0,0x1eb0
	slt	t0,t0,v0
	bnez	t0,_b107c
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x2048
	lh	t0,0(t1)
	addi	t0,t0,-5
	bltz	t0,_b1198
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x20e4
	sw	zero,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x2048
	sh	zero,0(t1)
	lui	s1,0xb000
	ori	s1,s1,0x20e4
	lh	t0,0(t1)

_b10d0:
	lh	v0,0(t1)
	beq	v0,t0,_b10d0
	  nop
	lh	v0,0(t1)
	addi	t0,v0,100
	lw	t7,0(s1)

_b10e8:
	lh	v0,0(t1)
	bne	t0,v0,_b10e8
	  nop
	lw	t5,0(s1)
	sub	v0,t5,t7
	  li	t0,50
	bnez	t0,_b110c
	  div	zero,v0,t0
	break	0x7

_b110c:
	li	at,-1
	bne	t0,at,_b1124
	  lui	at,0x8000
	bne	v0,at,_b1124
	  nop
	break	0x6

_b1124:
	mflo	v0
	mflo	v0
	li	t0,2048
	.word	0x70481002
	lui	t0,0x7
	ori	t0,t0,0xa120
	add	v0,v0,t0
	lui	t0,0xf
	ori	t0,t0,0x4240
	bnez	t0,_b1154
	  div	zero,v0,t0
	break	0x7

_b1154:
	li	at,-1
	bne	t0,at,_b116c
	  lui	at,0x8000
	bne	v0,at,_b116c
	  nop
	break	0x6

_b116c:
	mflo	v0
	mflo	v0
	li	at,12
	beq	v0,at,_b11b0
	  nop
	li	at,19
	beq	v0,at,_b1224
	  nop
	li	at,26
	beq	v0,at,_b11e0
	  nop

_b1198:
	lui	t1,0xb000
	ori	t1,t1,0x24
	lw	t0,0(t1)
	li	at,-5
	and	t0,t0,at
	sw	t0,0(t1)

_b11b0:
	li	v1,12
	lui	t1,0xb000
	lui	t0,0x101
	ori	t0,t0,0x1110
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x10
	lui	t0,0x2f02
	ori	t0,t0,0x120
	sw	t0,0(t1)
	b	_b1260
	  nop

_b11e0:
	li	v1,26
	lui	t1,0xb000
	lui	t0,0x101
	ori	t0,t0,0x1110
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x50
	lui	t0,0x8000
	ori	t0,t0,0xc
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x10
	lui	t0,0xb01
	ori	t0,t0,0x120
	sw	t0,0(t1)
	b	_b1260
	  nop

_b1224:
	li	v1,19
	lui	t1,0xb000
	lui	t0,0x101
	ori	t0,t0,0x1110
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x50
	lui	t0,0x8000
	ori	t0,t0,0xf
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x10
	lui	t0,0x1301
	ori	t0,t0,0x120
	sw	t0,0(t1)

_b1260:
	lui	t1,0xb000
	ori	t1,t1,0x14
	lw	t0,0(t1)
	srl	t0,t0,0x1d
	andi	t0,t0,0x1
	beqz	t0,_b1260
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x2018
	li	t0,0x8001
	sh	t0,0(t1)

_b128c:
	lui	t1,0xb000
	ori	t1,t1,0x24
	lw	t0,0(t1)
	ori	t0,t0,0x80
	sw	t0,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x3c
	li	t2,1
	sll	t2,t2,0x16
	lw	t0,0(t1)
	or	t0,t0,t2
	sw	t0,0(t1)
	li	t0,40

_b12c0:
	bnez	t0,_b12c0
	  addi	t0,t0,-1
	lui	t1,0xb000
	ori	t1,t1,0x3c
	li	t2,1
	sll	t2,t2,0x16
	lw	t0,0(t1)
	xor	t0,t0,t2
	sw	t0,0(t1)
	li	t0,2000

_b12e8:
	bnez	t0,_b12e8
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
	ori	t1,t1,0x20e4
	sw	zero,0(t1)
	lui	t1,0xb000
	ori	t1,t1,0x2014
	li	t0,0x8000
	sh	t0,0(t1)
	li	s1,0

_b1374:
	bnez	t5,_b13b8
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x20e4
	lw	t0,0(t1)
	li	t1,9766
	.word	0x71234802
	subu	t0,t0,t1
	bltz	t0,_b13b8
	  nop
	lui	t1,0xb000
	ori	t1,t1,0x2018
	li	t0,0x8000
	sh	t0,0(t1)
	mtlo	a0
	j	0x1fc00004
	  nop

_b13b8:
	lbu	t1,10(k1)
	andi	t1,t1,0x4
	beqz	t1,_b1420
	  nop
	li	t5,1
	lui	t1,0xb000
	ori	t1,t1,0x2018
	li	t0,0x8000
	sh	t0,0(t1)
	lbu	t1,1(k1)
	andi	t1,t1,0x10
	bnez	t1,_b13f0
	  li	t1,512
	li	t1,64

_b13f0:
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

_b1420:
	lhu	t2,2(k1)
	andi	t1,t2,0x1
	beqz	t1,_b1798
	  nop
	sb	zero,14(k1)
	  lbu	t3,18(k1)
	andi	t1,t3,0x4
	beqz	t1,_b1450
	  nop
	andi	t1,t3,0xdb
	sb	t1,18(k1)
	  li	s6,0

_b1450:
	andi	t1,t3,0x10
	beqz	t1,_b1468
	  nop
	ori	t1,t3,0x80
	sb	t1,18(k1)
	  li	s6,0

_b1468:
	bnez	s6,_b172c
	  nop
	beqz	s1,_b1480
	  nop
	sb	s1,0(k1)
	  addu	s1,zero,zero

_b1480:
	andi	t1,t3,0x1
	beqz	t1,_b1798
	  nop
	lw	t9,32(k1)
	lw	k0,32(k1)
	andi	t1,t9,0x60
	beqz	t1,_b15bc
	  nop
	li	s6,0
	li	s7,1
	andi	t1,t9,0xff00
	srl	t1,t1,0x8
	beqz	t1,_b14e8
	  addi	t0,t1,-1
	beqz	t0,_b1504
	  addi	t0,t1,-2
	beqz	t0,_b151c
	  addi	t0,t1,-3
	beqz	t0,_b153c
	  addi	t0,t1,-4
	beqz	t0,_b1574
	  addi	t0,t1,-5
	beqz	t0,_b1594
	  nop
	b	_b1710
	  nop

_b14e8:
	lui	s4,0xbfc0
	addiu	s4,s4,6464
	li	s5,8
	li	s6,1
	li	s7,0
	b	_b1710
	  nop

_b1504:
	lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s4,t1,t0
	b	_b1710
	  nop

_b151c:
	lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s5,t1,t0
	li	t1,72
	sb	t1,18(k1)
	  b	_b17a4
	nop

_b153c:
	lui	t0,0x8000
	addi	t1,t0,16352

_b1544:
	cache	0x0,0(t0)
	cache	0x1,0(t0)
	bne	t0,t1,_b1544
	  addiu	t0,t0,32
	sync
	.word	0x40088007
	nop
	ori	t0,t0,0x2
	.word	0x40888007
	nop
	b	_b1710
	  nop

_b1574:
	li	t1,72
	sb	t1,18(k1)
	  lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s4,t1,t0
	b	_b0154
	  li	s3,16384

_b1594:
	li	t1,72
	sb	t1,18(k1)
	  lui	t1,0xffff
	and	t1,t9,t1
	andi	t0,k0,0xffff
	or	s4,t1,t0
	jalr	s4
	  nop
	b	_b128c
	  nop

_b15bc:
	andi	t4,t9,0xff00
	srl	t4,t4,0x8
	addi	t1,t4,-5
	bnez	t1,_b15e0
	  nop
	srl	s1,t9,0x10
	li	s7,1
	b	_b1710
	  nop

_b15e0:
	addi	t1,t4,-9
	bnez	t1,_b15f8
	  nop
	li	s7,1
	b	_b1710
	  nop

_b15f8:
	addi	t1,t4,-6
	bnez	t1,_b1710
	  li	s7,1
	li	s7,0
	srl	t1,t9,0x18
	addi	t0,t1,-1
	beqz	t0,_b163c
	  srl	s5,k0,0x10
	addi	t0,t1,-2
	beqz	t0,_b1684
	  addi	t0,t1,-3
	beqz	t0,_b16c0
	  addi	t0,t1,-6
	beqz	t0,_b1660
	  nop
	b	_b1710
	  nop

_b163c:
	lui	s4,0xbfc0
	addiu	s4,s4,6300
	li	s6,1
	addi	t0,s5,-18
	blez	t0,_b1710
	  nop
	li	s5,18
	b	_b1710
	  nop

_b1660:
	lui	s4,0xbfc0
	addiu	s4,s4,6320
	li	s6,1
	addi	t0,s5,-10
	blez	t0,_b1710
	  nop
	li	s5,10
	b	_b1710
	  nop

_b1684:
	lui	s4,0xbfc0
	addiu	s4,s4,6364
	lbu	t0,1(k1)
	andi	t0,t0,0x10
	beqz	t0,_b16a4
	  nop
	lui	s4,0xbfc0
	addiu	s4,s4,6332

_b16a4:
	li	s6,1
	addi	t0,s5,-32
	blez	t0,_b1710
	  nop
	li	s5,32
	b	_b1710
	  nop

_b16c0:
	li	s6,1
	srl	t1,t9,0x10
	andi	t1,t1,0xff
	addi	t0,t1,-1
	beqz	t0,_b16f0
	  addi	t0,t1,-2
	beqz	t0,_b1700
	  nop
	lui	s4,0xbfc0
	addiu	s4,s4,6396
	b	_b1710
	  li	s5,4

_b16f0:
	lui	s4,0xbfc0
	addiu	s4,s4,6400
	b	_b1710
	  li	s5,16

_b1700:
	lui	s4,0xbfc0
	addiu	s4,s4,6416
	b	_b1710
	  li	s5,46

_b1710:
	li	t1,64
	beqz	s7,_b1720
	  nop
	ori	t1,t1,0x8

_b1720:
	sb	t1,18(k1)
	  beqz	s6,_b1798
	  nop

_b172c:
	addi	t1,s6,-1
	bnez	t1,_b1798
	  nop
	addi	t1,s5,-64
	blez	t1,_b1748
	  ori	s3,s5,0x0
	li	s3,64

_b1748:
	beqz	s3,_b1774
	  ori	s2,s3,0x0
	sub	s5,s5,s3

_b1754:
	lbu	t1,0(s4)
	sb	t1,32(k1)
	  addi	s3,s3,-1
	bnez	s3,_b1754
	  addi	s4,s4,1
	addi	t1,s2,-64
	beqz	t1,_b1788
	  nop

_b1774:
	li	t1,10
	sb	t1,18(k1)
	  li	s6,0
	b	_b1798
	  nop

_b1788:
	li	t1,2
	sb	t1,18(k1)
	  b	_b1798
	nop

_b1798:
	andi	t1,t2,0x2
	beqz	t1,_b1824
	  nop

_b17a4:
	li	t1,1
	sb	t1,14(k1)
	  lbu	t1,18(k1)
	andi	t0,t1,0x2
	bnez	t0,_b1824
	  nop
	lhu	t1,16(k1)
	sub	t0,s5,t1
	  blez	t0,_b17d0
	  ori	s3,s5,0x0
	ori	s3,t1,0x0

_b17d0:
	beqz	s3,_b1824
	  nop
	sub	s5,s5,s3
	  srl	a1,s3,0x2
	andi	a2,s3,0x3
	beqz	a1,_b1800
	  nop

_b17ec:
	lw	t1,0(s4)
	sw	t1,36(k1)
	addi	a1,a1,-1
	bnez	a1,_b17ec
	  addiu	s4,s4,4

_b1800:
	beqz	a2,_b181c
	  nop

_b1808:
	lbu	t1,0(s4)
	sb	t1,36(k1)
	  addi	a2,a2,-1
	bnez	a2,_b1808
	  addiu	s4,s4,1

_b181c:
	li	t1,1
	sb	t1,18(k1)

_b1824:
	lhu	t1,4(k1)
	andi	t1,t1,0x2
	beqz	t1,_b1894
	  nop
	li	t1,1
	sb	t1,14(k1)
	  lbu	t1,22(k1)
	andi	t1,t1,0x1
	beqz	t1,_b1894
	  nop
	lhu	s3,24(k1)
	srl	a1,s3,0x2
	andi	a2,s3,0x3
	beqz	a1,_b1874
	  nop

_b1860:
	lw	t1,36(k1)
	sw	t1,0(s4)
	addi	a1,a1,-1
	bnez	a1,_b1860
	  addiu	s4,s4,4

_b1874:
	beqz	a2,_b1890
	  nop

_b187c:
	lbu	t1,36(k1)
	sb	t1,0(s4)
	  addi	a2,a2,-1
	bnez	a2,_b187c
	  addiu	s4,s4,1

_b1890:
	sb	zero,22(k1)

_b1894:
	b	_b1374
	  nop
	.word 0x2000112
	mfc0	zero,$0
	c1	0x170a108
	.word 0x2010100
	sll	zero,zero,0x4
	.word 0x200060a
	mfc0	zero,$0
	.word 0x1
	.word 0x200209
	ll	zero,257(zero)
	.word 0x40901
	.word 0xff0200
	.word 0x5070050
	.word 0x2000201
	lb	a1,1792(t0)
	  srl	zero,v0,0x0
	.word 0x200209
	ll	zero,257(zero)
	.word 0x40901
	.word 0xff0200
	.word 0x5070050
	.word 0x400201
	lb	a1,1792(t0)
	  srl	t0,zero,0x0
	tgeiu	zero,772
	.word 0x490310
	.word 0x67006e
	.word 0x6e0065
	.word 0x630069
	.word 0x4a032e
	.word 0x34005a
	.word 0x370037
	tge	at,zero
	.word 0x530055
	.word 0x200042
	.word 0x6f0042
	.word 0x74006f
	add	zero,v0,a0
	.word 0x760065
	.word 0x630069
	.word 0x65
	ori	s4,t9,0x5a4a
	andi	s6,t2,0x3037

_b1948:
	li	t0,1
	sh	t0,0(s4)

_b1950:
	lui	t3,0xb002
	ori	t3,t3,0x1004
	lw	t4,0(t3)
	andi	t4,t4,0x100
	beqz	t4,_b1984
	  nop
	nop
	nop
	nop
	nop
	nop
	b	_b1950
	  nop

_b1984:
	sb	s5,44(s4)
	  sw	s6,48(s4)
	sw	s7,12(s4)
	li	t0,0xfffb
	sw	t0,36(s4)
	li	t2,6
	sh	t2,0(s4)

_b19a0:
	lw	t3,4(s4)
	andi	t3,t3,0x800
	beqz	t3,_b19a0
	  nop
	li	t1,4
	sh	t1,40(s4)
	beqz	t8,_b19d4
	  nop
	lui	t0,0xb002
	ori	t0,t0,0x1034
	lh	t9,0(t0)
	lh	k0,0(t0)
	lh	k1,0(t0)

_b19d4:
	jr	ra
	  nop

_b19dc:
	li	s5,16
	li	s6,512
	li	s7,1
	li	t8,1
	jal	_b1948
	  nop
	li	t5,512
	sh	t5,24(s4)
	li	t5,16
	sh	t5,28(s4)
	li	s5,18
	li	s6,0
	li	s7,16393
	li	t8,1
	jal	_b1948
	  nop
	ori	v0,gp,0x0
	li	s0,8192
	li	v1,0
	li	s1,2048

_b1a2c:
	beqz	s1,_b1acc
	  nop
	lui	t2,0xb002
	ori	t2,t2,0x1028
	lw	t3,0(t2)
	andi	t3,t3,0x20
	beqz	t3,_b1a2c
	  nop
	li	t1,16

_b1a50:
	lw	a0,56(s4)
	sw	a0,0(v0)
	addiu	v0,v0,4
	addi	t1,t1,-1
	bnez	t1,_b1a50
	  nop
	addi	s1,s1,-16
	addi	v1,v1,64
	bne	v1,s0,_b1a2c
	  nop
	li	s5,12
	li	s6,0
	li	s7,65
	li	t8,1
	jal	_b1948
	  nop
	li	t0,1
	sh	t0,0(s4)

_b1a98:
	lui	t3,0xb002
	ori	t3,t3,0x1004
	lw	t4,0(t3)
	andi	t4,t4,0x100
	beqz	t4,_b1acc
	  nop
	nop
	nop
	nop
	nop
	nop
	b	_b1a98
	  nop

_b1acc:
	ori	v0,gp,0x0
	addiu	v0,v0,512
	lw	a0,0(v0)
	lui	at,0x4d53
	ori	at,at,0x504c
	sub	a0,a0,at
	  bnez	a0,_b0f98
	  nop
	b	_b1dd8
	  nop

_b1af4:
	lui	t1,0xc
	sw	t1,24(sp)
	sw	t1,40(sp)
	sw	t1,56(sp)
	sw	t1,68(sp)
	sw	t1,116(sp)
	lui	t1,0x10
	sw	t1,24(sp)
	sw	t1,40(sp)
	sw	t1,56(sp)
	sw	t1,72(sp)
	sw	t1,116(sp)
	lui	s4,0xb002
	ori	s4,s4,0x1000
	li	t2,8
	sh	t2,0(s4)

_b1b34:
	lui	t3,0xb002
	ori	t3,t3,0x1004
	lw	t4,0(t3)
	andi	t4,t4,0x8000
	bnez	t4,_b1b34
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
	jal	_b1948
	  nop
	li	s5,0
	li	s6,0
	li	s7,128
	li	t8,0
	jal	_b1948
	  nop
	li	s5,8
	li	s6,426
	li	s7,1
	li	t8,1
	jal	_b1948
	  nop
	li	s5,55
	li	s6,0
	li	s7,1
	li	t8,1
	jal	_b1948
	  nop
	andi	t0,k1,0x20
	beqz	t0,_b1c14
	  nop
	srl	t0,t9,0x8
	li	t1,55
	bne	t0,t1,_b1c14
	  nop
	li	s5,41
	lui	s6,0x40ff
	ori	s6,s6,0x8000
	li	s7,3
	li	t8,3
	jal	_b1948
	  nop
	srl	t0,t9,0x8
	li	t1,63
	beq	t0,t1,_b1ce0
	  nop
	b	_b1c14
	  nop

_b1c14:
	li	s5,1
	lui	s6,0x40ff
	ori	s6,s6,0x8000
	li	s7,3
	li	t8,3
	jal	_b1948
	  nop
	andi	t6,t9,0x80
	bnez	t6,_b1c54
	  nop
	li	t2,5500

_b1c40:
	addi	t2,t2,-1
	bnez	t2,_b1c40
	  nop
	b	_b1c14
	  nop

_b1c54:
	li	s5,2
	li	s6,0
	li	s7,2
	li	t8,2
	jal	_b1948
	  nop
	li	s5,3
	li	s6,16
	li	s7,1
	li	t8,1
	jal	_b1948
	  nop
	li	t2,2
	sw	t2,8(s4)
	li	s5,7
	li	s6,16
	li	s7,1
	li	t8,1
	jal	_b1948
	  nop
	li	s5,6
	lui	s6,0x3b7
	ori	s6,s6,0x1
	li	s7,65
	li	t8,1
	jal	_b1948
	  nop

_b1cc0:
	lw	t3,4(s4)
	andi	t3,t3,0x2000
	beqz	t3,_b1cc0
	  nop
	li	t1,2
	sh	t1,40(s4)
	jal	_b19dc
	  nop

_b1ce0:
	li	s5,55
	li	s6,0
	li	s7,1
	li	t8,1
	jal	_b1948
	  nop
	li	s5,41
	lui	s6,0x40ff
	ori	s6,s6,0x8000
	li	s7,3
	li	t8,3
	jal	_b1948
	  nop
	andi	t6,t9,0x80
	bnez	t6,_b1d38
	  nop
	li	t2,5500

_b1d24:
	addi	t2,t2,-1
	bnez	t2,_b1d24
	  nop
	b	_b1ce0
	  nop

_b1d38:
	li	s5,2
	li	s6,0
	li	s7,2
	li	t8,2
	jal	_b1948
	  nop
	li	s5,3
	li	s6,0
	li	s7,6
	li	t8,1
	jal	_b1948
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
	jal	_b1948
	  nop
	li	s5,55
	ori	s6,s3,0x0
	li	s7,1
	li	t8,1
	jal	_b1948
	  nop
	li	s5,6
	li	s6,0
	li	s7,1
	li	t8,1
	jal	_b1948
	  nop
	jal	_b19dc
	  nop

_b1dd8:
	li	s3,8192
	b	_b0154
	  addiu	s4,gp,516

_b1de4:
	li	t5,512
	sh	t5,24(s4)
	li	t5,32
	sh	t5,28(s4)
	ori	v0,gp,0x0
	li	s0,16384
	li	v1,0
	li	s1,4096

_b1e04:
	beqz	s1,_b1ea4
	  nop
	lui	t2,0xb002
	ori	t2,t2,0x1028
	lw	t3,0(t2)
	andi	t3,t3,0x20
	beqz	t3,_b1e04
	  nop
	li	t1,16

_b1e28:
	lw	a0,56(s4)
	sw	a0,0(v0)
	addiu	v0,v0,4
	addi	t1,t1,-1
	bnez	t1,_b1e28
	  nop
	addi	s1,s1,-16
	addi	v1,v1,64
	bne	v1,s0,_b1e04
	  nop
	li	s5,0
	li	s6,0
	li	s7,0
	li	t8,0
	jal	_b1948
	  nop
	li	t0,1
	sh	t0,0(s4)

_b1e70:
	lui	t3,0xb002
	ori	t3,t3,0x1004
	lw	t4,0(t3)
	andi	t4,t4,0x100
	beqz	t4,_b1ea4
	  nop
	nop
	nop
	nop
	nop
	nop
	b	_b1e70
	  nop

_b1ea4:
	ori	v0,gp,0x0
	addiu	v0,v0,512
	lw	a0,0(v0)
	lui	at,0x4d53
	ori	at,at,0x504c
	sub	a0,a0,at
	  bnez	a0,_b0f98
	  nop
	b	_b1f94
	  nop

_b1ecc:
	lui	t1,0xc
	sw	t1,24(sp)
	sw	t1,40(sp)
	sw	t1,56(sp)
	sw	t1,68(sp)
	sw	t1,116(sp)
	lui	t1,0x10
	sw	t1,24(sp)
	sw	t1,40(sp)
	sw	t1,56(sp)
	sw	t1,72(sp)
	sw	t1,116(sp)
	lui	s4,0xb002
	ori	s4,s4,0x1000
	li	t2,8
	sh	t2,0(s4)

_b1f0c:
	lui	t3,0xb002
	ori	t3,t3,0x1004
	lw	t4,0(t3)
	andi	t4,t4,0x8000
	bnez	t4,_b1f0c
	  nop
	li	t2,0xffff
	sh	t2,36(s4)
	li	t3,0xffff
	sh	t3,40(s4)
	li	t2,2
	sh	t2,8(s4)
	li	s5,12
	li	s6,0
	li	s7,65
	li	t8,1
	jal	_b1948
	  nop
	li	s5,0
	lui	s6,0xf0f0
	ori	s6,s6,0xf0f0
	li	s7,128
	li	t8,0
	jal	_b1948
	  nop
	li	s5,0
	lui	s6,0xffff
	ori	s6,s6,0xfffa
	li	s7,16392
	li	t8,0
	jal	_b1948
	  nop
	jal	_b1de4
	  nop

_b1f94:
	li	s3,16384
	b	_b0154
	  addiu	s4,gp,516

.data
.section .data.1ffc
	.word	0x00005017
