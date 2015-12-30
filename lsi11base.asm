; DEC LSI-11 microcode, MICROMs CP1631-10 and CP1631-07
; Reverse-engineered source code
; Copyright 2015 Eric Smith <spacewar@gmail.com>

; Reverse-engineering in progress:
;   There are probably many errors.
;   There is no existing assembler that can assemble this file as-is.

; Note that there are jumps and subroutine returns that occur on
; microinstructions that aren't explicit flow control instructions, due
; to the translation PLAs in the control chip. These PLAs have not yet
; been dumped. From study of the code one may be able to infer where some
; of these translations occur.

; register assignments:

                    
; direct  indirect  name        description
; ------  --------  ----------  --------------------------------
; r3:2              rba         bus address
; r5:4              rsrc        source
; r7:6		    rdst        desitantion
; r9:8              rir         instruction register
; rb:a              rpsw        program status word
; rd:c    g=6       sp          stack pointer
; rf:e    g=7       pc          program counter

;         g=0       10
;         g=1       r1
;         g=2       r2
;         g=3       r3
;         g=4       r4
;         g=5       r5


; interrupt register
;     i6:  interrupt handling by microcode at 0x604 (for both event and device)
;     i5:  interrupt enable when 1 (for both event and device)
;     i4:  trace trap
;     i3:  device interrupt
;     i2:  event interrupt (line time clock)
;     i1:  power fail, fault (distinguish by a FAST DATA IN cycle)
;     i0:  memory refresh


; PDP-11 PSW
; bits stored in rpswh:
;     bit 7:      interrupt priority - 0 = enable, 1 = disable, see interrupt reg i5
;     bits 6..5:  reserved (interrupt priority bits on other PDP-11 models)
;     bit 4:      trace trap       - also see interrupt enable i4

; bits stored in condition code hardware:
;     bit 3:     N - negative
;     bit 2:     Z - zero
;     bit 1:     V - overflow
;     bit 0:     C - carry


; TTL control field:
; 0x1 - rsv1
; 0x9 - ifclr - IFCLR + SRUN L
; 0xa - tfclr - TFCLR L
; 0xb - rfset - RFSET L
; 0xc - initset - INITIALIZE SET
; 0xd - fastdin - FAST DIN
; 0xe - pfclr - PFCLR L
; 0xf - efclr - EFCLR L

	org	0x000

L000:	jmp	L15e

	jmp	reset

	mb	rirh,rsrcl
	mb	rirl,rsrch
	slw	rsrcl,rsrcl
	slw	rsrcl,rsrcl
	lgl	rsrch
	al	0xfe,spl
	cdb	sph
	w	sph,spl
	ow	gh,gl
	mw	pcl,gl,rsvc
	mw	rbal,pcl


L00d:	cl	0x90,rirl
	jmp	L06e


L00f:	jzbt	L04d
	rtsr
	jmp	L10b


	al	0xfe,spl
	cdb	sph
	w	sph,spl
	ow	pch,pcl
	mb	rbal,pcl,rsvc
	mb	rbah,pch


L018:	jmp	op_halt		; HALT  inst 000000
	jmp	op_wait		; WAIT  inst 000001
	jmp	op_illegal	; RTI   inst 000002
	jmp	op_bpt		; BPT   inst 000003
	jmp	op_iot		; IOT   inst 000004
	jmp	op_reset	; RESET inst 000005
	jmp	op_illegal	; RTT   inst 000006
	jmp	op_illegal	; undef inst 000007

	mi	rirl,rirh
	jmp	L018


L022:	ll	0xa,rdstl,,initset
L023:	db1	rdstl,rdstl
	jzbf	L023
	ll	0x53,rdstl,,ifclr
L026:	db1	rdstl,rdstl
	jzbf	L026
	rfs
	riw2	sph,spl,,rsv1
	iw	0x0,pcl

	ri	i5		; clear interrupt enable
	riw2	sph,spl		; read PSW from stack
	ib	0x1,rpswh
	jnbt	L030		; test PSW interrupt priority
	si	i5		; set interrupt enable

L030:	tl	0x10,rpswh
	jzbt	L033
	jmp	L1bc

L033:	lcf	0xf,rpswh,rsvc	; load hardware condition codes
	nop


	slw	rirh,rsrcl, rsvc
	cawi	rsrcl,pcl


	lgl	rirh
	mb	rirh,rirl
	nl	0xf8,rirl
	cl	0x88,rirl
	jzbt	L0ee
	jmp	L00d


	al	0x40,rirh
	jnbf	L041
L03f:	jmp	op_illegal

L040:	mb	gh,rsrch
L041:	nop
	mb	rirh,rirl
	al	0x40,rirl
	jc8t	L040
	jnbt	L03f
	jmp	L0c1


	db1	gl,gl
	r	gh,gl
	iw	0x0,rsrcl
	ib	0x2,rsrcl
	dw1	gl,gl
	jzbf	L075

L04d:	nop	,rsvc
	nop


L04f:	jmp	L373


	riw2	gh,gl
	iw	0x0,rsrcl
	ib	0x2,rsrcl
	dw1	gl,gl


; reset mode 1, execute from octal 173000
reset_mode_1:
	ll	0xf6,pch
	jmp	L086


L056:	jzbt	L067
	jmp	op_illegal


	riw2	gh,gl
	iw	0x0,rbal
	r	rbah,rbal
	iw	0x0,rsrcl
	icb1	gl,gl
	cib	gh
	r	gh,gl
	ib	0x2,rsrcl
	al	0xfe,gl
	cdb	gh
	r	gh,gl
	iw	0x0,rsrcl
	mw	gl,pcl
	riw2	sph,spl,rsvc
	iw	0x0,gl


L067:	jmp	L603		; opcodes 075040-075777


	al	0xfe,gl
	cdb	gh
	r	gh,gl
	iw	0x0,rbal
	r	rbah,rbal
	iw	0x0,rsrcl
L06e:	jzbf	L03f

	jmp	L600


	riw2	pch,pcl
	iw	0x0,rbal
	aw	gl,rbal
	r	rbah,rbal
	iw	0x0,rsrcl
L075:	slb	rirh,rirh
	nl	0x7f,rirh,rsvc


	sw	rirh,pcl
	riw2	pch,pcl
	iw	0x0,rbal
	aw	gl,rbal
	r	rbah,rbal
	iw	0x0,rbal
	r	rbah,rbal
	iw	0x0,rsrcl
	lgl	rirh
	lgl	rirh

	ra	rpswl,rpswh	; read interrupt vector from device
	al	0x01,rpswl
	iw	0x00,rsrcl
	nl	0x40,rpswl
	jmp	trap16


L086:	ll	0x80,rpswh
	jmp	L04d


	lgl	rirh
	r	gh,gl
	iw	0x4,rdstl
L08b:	jzbf	L04f
	lgl	rirl
	ll	0x80,rsrcl
L08e:	orb	rsrcl,rpswl
	jmp	L359


	lgl	rirh
	riw2	gh,gl
	iw	0x4,rdstl
L093:	ll	0x20,rirl
	jsr	L2e6
	ll	0x10,rirl
	orb	rirl,rpswl
	jmp	L359


	lgl	rirh
	riw2	gh,gl
	iw	0x0,rbal
	r	rbah,rbal
	iw	0x4,rdstl

	ll	0x1c,rsrcl	; vector 024 - power fail
	jmp	trap


	jmp	L000


	lgl	rirh
	al	0xfe,gl
	cdb	gh
	r	gh,gl
	iw	0x4,rdstl

op_iot:
	ll	0x20,rsrcl	; vector 020 - IOT inst
	jmp	trap


	jmp	L000


	lgl	rirh
	al	0xfe,gl
	cdb	gh
	r	gh,gl
	iw	0x0,rbal
	r	rbah,rbal
	iw	0x4,rdstl

	jmp	L000


	lgl	rirh
	riw2	pch,pcl
	iw	0x0,rbal
	aw	gl,rbal
	r	rbah,rbal
	iw	0x4,rdstl

	ll	0x18,rsrcl	; vector 030 - EMT inst (104000..104377)
	jmp	trap


	lgl	rirh
	riw2	pch,pcl
	iw	0x0,rbal
	aw	gl,rbal
	r	rbah,rbal
	iw	0x0,rbal
	r	rbah,rbal
	iw	0x4,rdstl
	jmp	L337


L0c1:	slb	rirh,rirh
	aw	rirh,pcl
	r	pch,pcl
	iw	0x0,rdstl
	icw2	pcl,spl
	jmp	L0dc


	jmp	L000


	mw	gl,rbal
	mb	rbal,pcl,rsvc
	mb	rbah,pch


L0cb:	ll	0x1,rirl
	w	pch,pcl
	ob	rirl,rirl
	nl	0xfe,pcl
	jmp	L2cc


	mw	gl,rbal
	icw2	gl,gl
	mb	rbal,pcl,rsvc
	mb	rbah,pch


L0d4:	al	0x8,rpswl
	ll	0xff,rsrch
	jsr	L3d5
	jmp	L355


	riw2	gh,gl
	iw	0x0,rbal
	mb	rbal,pcl,rsvc
	mb	rbah,pch


L0dc:	ll	0x5,rsrcl
	lgl	rsrcl
	mw	gl,pcl,rsvc
	mw	rdstl,gl


	al	0xfe,gl
	cdb	gh
	mw	gl,rbal
	mb	rbal,pcl,rsvc
	mb	rbah,pch


	ccf	rirl
	orb	rirh,rirl,rsvc
	lcf	0xf,rirl


	al	0xfe,gl
	cdb	gh
	r	gh,gl
	iw	0x0,rbal
	mb	rbal,pcl,rsvc
	mb	rbah,pch


L0ee:	wiw2	gh,gl
	jmp	L1ca


	riw2	pch,pcl
	iw	0x0,rbal
	aw	gl,rbal
	mb	rbal,pcl,rsvc
	mb	rbah,pch

; BPT 000003
op_bpt:	ll	0x0c,rsrcl	; vector 014 - BPT inst (000003) or trace trap
	jmp	trap


	jmp	L000


	riw2	pch,pcl
	iw	0x0,rbal
	aw	gl,rbal
	r	rbah,rbal
	iw	0x0,rbal
	mb	rbal,pcl,rsvc
	mb	rbah,pch


	jmp	L000


	lgl	rirh

; HALT 000000
op_halt:	tl	0x40,rpswl
	jzbf	L127

L103:	nl	0xf0,rpswh
	jmp	L175


L105:	jsr	L2de
	mw	pcl,rdstl
	jmp	L1c6


	lgl	rirh
	r	gh,gl
	ib	0x6,rdstl
L10b:	riw2	pch,pcl
	iw	0x2,rirh,,ifclr
	mb	gl,rsrcl
	cl	0x7b,rirl
	jmp	L056


	lgl	rirh
	riw1	gh,gl
	ib	0x6,rdstl
	icw1	gl,gl
	ib	0x6,rdstl

L115:	ll	0x40,rpswl

	ll	0x14,rsrcl,,pfclr	; vector 024 - power fail
	jmp	trap


	lgl	rirh
	riw2	gh,gl
	iw	0x0,rbal
	r	rbah,rbal
	ib	0x6,rdstl
	ccf	rirl
	ncb	rirh,rirl,rsvc
	lcf	0xf,rirl


	lgl	rirh
	dw1	gl,gl
	r	gh,gl
	ib	0x6,rdstl
	dw1	gl,gl
	r	gh,gl
	ib	0x6,rdstl
L127:	jmp	L33f


	lgl	rirh
	al	0xfe,gl
	cdb	gh
	r	gh,gl
	iw	0x0,rbal
	r	rbah,rbal
	ib	0x6,rdstl


	jmp	L000


	lgl	rirh
	riw2	pch,pcl
	iw	0x0,rbal
	aw	gl,rbal
	r	rbah,rbal
	ib	0x6,rdstl
L136:	jsr	L3fa
	jmp	L355


	lgl	rirh
	riw2	pch,pcl
	iw	0x0,rbal
	aw	gl,rbal
	r	rbah,rbal
	iw	0x0,rbal
	r	rbah,rbal
	ib	0x6,rdstl
	ccf	rirl
	slbf	gh,rdstl
	mb	gl,gh,rsvc
	srbcf	rdstl,gl


L144:	orb	rdstl,rpswh

	jnbt	L147		; test PSW interrupt priority
	si	i5		; enable interrupts
L147:	rfs


	cwf	gl,rsrcl	; 148 - CMP instruction 02ssdd


L149:	r	sph,spl
	ib	0x1,rirl
	rfs


	twf	rsrcl,gl	; 14c - BIT instruction 03ssdd


L14d:	ll	0x4,rirl
	ll	0x0,rirh
	jmp	L155


	ncwf	rsrcl,gl	; 150 - BIC instruction 04ssdd


L151:	ll	0x0,pcl
	ll	0xe0,pch
	jmp	L3b2


	orwf	rsrcl,gl	; 154 - BIS instruction 05ssdd


L155:	riw2	rirh,rirl
	ib	0x1,rirl,,fastdin
	rfs	,,fastdin


	awf	rsrcl,gl	; 158 - ADD instruction 06ssdd


L159:	dw1	rbal,rbal
	dw1	rbal,rbal
	jmp	L38e


	xwf	rsrcl,gl


	jmp	L000


L15e:	ll	0x4,rpswl
	jmp	op_illegal


	ccf	rirl		; 160


; WAIT 000001
op_wait:
	ll	0x8,rpswl
L162:	nop
	jmp	L162


	mb	rsrcl,rsrch,rsvc	; 164 - MOVB instruction 11ssdd
	mwf	rsrch,gl


L166:	orbf	rpswh,rdstl,rsvc
	ob	rdstl,rdstl


	cbf	gl,rsrcl	; 168 - CMPB instruction 12ssdd


L169:	ll	0xa8,rpswl
	jsr	L3ce
	jmp	L16d


	tbf	rsrcl,gl	; 16c - BITB instruction 13ssdd


L16d:	mb	rirl,rbah
	jsr	L3ce
	jmp	L171


	ncbf	rsrcl,gl	; 170 - BICB instruction 14ssdd


L171:	mb	rirl,rbal
L172:	riw1	rbah,rbal
	jmp	L18d


	orbf	rsrcl,gl	; 174 - BISB instruction 15ssdd


L175:	ll	0x8,rirh
	orb	rirh,rpswl
	jmp	L105


	swf	rsrcl,gl	; 178 - BISB instruction 16ssdd


	jmp	L000


L17a:	lgl	rbal
	ll	0x52,rirl
	jsr	L2e6
	mb	rbal,rirl
	jmp	L1a9


	jmp	L000


	ccf	rirl
	slbf	rdsth,rdsth
	srbcf	rdsth,rdsth,rsvc
	ow	rdstl,rdsth


	jsr	L14d
	tl	0x8,rirl
	jzbf	L115
	jmp	op_halt


	cwf	rdstl,rsrcl	; 188


L189:	ri	i5		; disable interrupts
	nl	0x10,rpswh
	jmp	L144


	twf	rsrcl,rdstl	; 18c


L18d:	ib	0x2,rirl
	jsr	L2e6
	jmp	L1a1


	ncwf	rsrcl,rdstl,rsvc	; 190
	ow	rdsth,rdstl


op_illegal:
	ll	0x08,rsrcl		; vector 010 - illegal or reserved inst
	jmp	trap


	orwf	rsrcl,rdstl,rsvc	; 194
	ow	rdsth,rdstl


L196:	ri	i4			; clear trace interrupt enable
	jmp	L19a


	awf	rsrcl,rdstl,rsvc	; 198
	ow	rdsth,rdstl


L19a:	si	i5			; enable interrupts
	jmp	op_reset


	xwf	rsrcl,rdstl,rsvc	; 19c
	ow	rdsth,rdstl


; RESET - 000005
op_reset:
	jsr	L022
	jmp	L04d


	ccf	rirl	; 1a0


L1a1:	al	0xf0,rpswl
	tl	0xf0,rpswl
	jmp	L1a6


	mbf	rsrcl,rsrcl,rsvc	; 1a4
	ob	rsrcl,rsrcl


L1a6:	jzbf	L172
	jmp	L355


	cbf	rdstl,rsrcl	; 1a8


L1a9:	jsr	L2e6
	ll	0x2f,rirl
	jmp	L292


	tbf	rsrcl,rdstl	; 1ac


L1ad:	iw	0x0,rdstl
	aw	rdstl,rbal
	jmp	L38d


	ncbf	rsrcl,rdstl,rsvc	; 1b0
	ob	rdstl,rdstl


L1b2:	orb	rdstl,rpswh,rsvc
	mwf	rpswh,gl


	orbf	rsrcl,rdstl,rsvc
	ob	rdstl,rdstl


L1b6:	jsr	L2e6
	jmp	L37a


	swf	rsrcl,rdstl,rsvc
	ow	rdsth,rdstl


	ll	0x0c,rsrcl	; vector 014 - BPT inst (000003) or trace trap
	jmp	trap


L1bc:	si	i4		; set trace interrupt enable
	lcf	0xf,rpswh
	tl	0x4,rirh
	jmp	L00f


	sbf	gl,gl,rsvc
	nop


	ll	0x40,rsrcl,,efclr	; vector 100 - line time clock
	jmp	trap


	icb1f	gl,gl,rsvc
	lcf	0x1,rirl


L1c6:	jsr	print_octal_word
	jmp	L352


	ocbf	gl,gl,rsvc
	nop


L1ca:	ow	rbah,rbal
	jmp	L1ce


	db1f	gl,gl,rsvc
	lcf	0x1,rirl


L1ce:	wiw2	gh,gl
	jmp	L1d2


	tcbf	gl,gl,rsvc
	nop


L1d2:	ow	rsrch,rsrcl
	jmp	L1d6


	ll	0x0,rsrcl,rsvc
	sbcf	rsrcl,gl


L1d6:	wiw2	gh,gl
	jmp	L1da


	ll	0x0,rsrcl,rsvc
	abcf	rsrcl,gl


L1da:	ow	rdsth,rdstl
	jmp	L1de


	slbf	gl,gl,rsvc
	srbcf	gl,gl


L1de:	wiw2	gh,gl
	jmp	L1ea


	srbcf	gl,gl
	srbcf	gl,gl,rsvc
	slbcf	gl,gl


	jmp	L000


	slbcf	gl,rsrcl
	srbcf	gl,gl
	srbcf	gl,gl,rsvc
	slbcf	gl,gl


	slbcf	gl,gl


	jmp	L000


L1ea:	ow	rpswh,rpswl
	jmp	L1ee


	slbf	gl,gl
	jmp	L000


L1ee:	wiw2	gh,gl
	jmp	L206,rsvc


	mb	gl,rdstl


	ri	i5			; disable interrupts
	nl	0x10,rpswh
	nl	0xef,rdstl
	orb	rdstl,rpswh
	jnbt	L1f7			; test PSW interrupt priority
	si	i5			; enable interrupts
L1f7:	lcf	0xf,rdstl,rsvc
	nop


L1f9:	ll	0xd,rirl		; carriage return
	al	0x8,rpswh
	jmp	L3e5			; output character to SLU


	ccf	rdstl
	nl	0xf0,rpswh
	nl	0xf,rdstl
	jmp	L1b2


	swf	gl,gl


	jmp	L000


L202:	ll	0xff,gl,rsvc
	mbf	gl,gh


	icw1f	gl,gl,rsvc
	lcf	0x1,rirl


L206:	ow	rirl,rirh


	jmp	L000


	ocwf	gl,gl,rsvc
	nop


L20a:	w	rbah,rbal
	jmp	L21a


	dw1f	gl,gl,rsvc
	lcf	0x1,rirl


	jmp	L000
	jmp	L000


	tcwf	gl,gl,rsvc
	nop


L212:	nl	0xe0,rdstl
	jmp	L189


	ll	0x0,rsrch,rsvc
	swcf	rsrch,gl


L216:	mw	rdstl,gl
	rfs


	ll	0x0,rsrch,rsvc
	awcf	rsrch,gl


L21a:	ow	rdsth,rdstl
L21b:	rfs


	sbf	rirl,rirl,rsvc
	mwf	gl,gl


L21e:	jc8t	L252
	jmp	L20a


	srwcf	gh,gh
	srwcf	gh,gh,rsvc
	slwcf	gl,gl


	jmp	L000


	slbcf	gh,rsrcl
	srwcf	gh,gh
	srwcf	gh,gh,rsvc
	slwcf	gl,gl


	slwcf	gl,gl


L229:	srw	rdsth,rdsth
	srw	rdsth,rdsth
	jmp	L279


	slwf	gl,gl


L22d:	slw	rdstl,rdstl
	slw	rdstl,rdstl
	slw	rdstl,rdstl
	ab	rirl,rdstl
	ll	0x20,rirl
	orb	rirl,rpswl
	jmp	L35a


L234:	jsr	L2de
	jsr	L3fa
	tl	0x80,rpswl
	jzbt	L23a
	nl	0x3f,rpswl
	jmp	L355


L23a:	r	rbah,rbal
	jmp	L1ad


	jnt	L202
	ll	0x0,gl,rsvc
	mbf	gl,gh


	jmp	L000


	sbf	rdstl,rdstl,rsvc
	ob	rdstl,rdstl


L242:	jsr	L2e6
	jmp	L35a


	icb1f	rdstl,rdstl
	lcf	0x1,rirl,rsvc
	ob	rdstl,rdstl


	jmp	L000


	ocbf	rdstl,rdstl,rsvc
	ob	rdstl,rdstl


L24a:	lcf	0xf,rdstl
	jmp	L212


	db1f	rdstl,rdstl
	lcf	0x1,rirl,rsvc
	ob	rdstl,rdstl


	jmp	L000


	tcbf	rdstl,rdstl,rsvc
	ob	rdstl,rdstl


L252:	jnbt	L24a
	jmp	L216


	ll	0x0,rsrcl
	sbcf	rsrcl,rdstl,rsvc
	ob	rdstl,rdstl


L257:	jmp	L359


	ll	0x0,rsrcl
	abcf	rsrcl,rdstl,rsvc
	ob	rdstl,rdstl


L25b:	jmp	L39c


	sbf	rirl,rirl,rsvc
	mbf	rdstl,rdstl


L25e:	slb	rpswl,rsrcl
	jmp	L21e


L260:	srbcf	rdstl,rdstl
	srbcf	rdstl,rdstl
	slbcf	rdstl,rdstl,rsvc
	ob	rdstl,rdstl


	slbcf	rdstl,rsrcl
	jmp	L260


L266:	jzbt	L21b
	jmp	L25e


	slbcf	rdstl,rdstl,rsvc
	ob	rdstl,rdstl


L26a:	tl	0x20,rpswl
	jmp	L266


	slbf	rdstl,rdstl,rsvc
	ob	rdstl,rdstl


L26e:	nl	0xef,rpswl
	jmp	L26a


	ob	rdstl,rdstl
	ri	i5			; disable interrupts
	nl	0x10,rpswh
	nl	0xef,rdstl
	orb	rdstl,rpswh
	jnbt	L277			; test PSW interrupt priority
	si	i5			; enable interrupts
L277:	lcf	0xf,rdstl,rsvc
	nop


L279:	srw	rdsth,rdsth
	ll	0x5c,rirl
	jmp	L242


	ccf	rdstl
	nl	0xf0,rpswh
	nl	0xf,rdstl
	jmp	L166


	sbf	rdstl,rdstl,rsvc
	ow	rdstl,rdstl


L282:	jsr	L2e6
	jmp	L355


	icw1f	rdstl,rdstl
	lcf	0x1,rirl,rsvc
	ow	rdsth,rdstl


	jmp	L000


	ocwf	rdstl,rdstl,rsvc
	ow	rdsth,rdstl


L28a:	orb	rpswh,rdstl
	jmp	L37c


	dw1f	rdstl,rdstl
	lcf	0x1,rirl,rsvc
	ow	rdsth,rdstl


	jmp	L000


	tcwf	rdstl,rdstl,rsvc
	ow	rdsth,rdstl


L292:	jsr	L2e6
	jmp	L382


	ll	0x0,rsrch
	swcf	rsrch,rdstl,rsvc
	ow	rdsth,rdstl


	jmp	L000


	ll	0x0,rsrch
	awcf	rsrch,rdstl,rsvc
	ow	rdsth,rdstl


	jmp	L000


	sbf	rirl,rirl,rsvc
	mwf	rdstl,rdstl


L29e:	db1	rbal,rbal
	jmp	L394


	srwcf	rdsth,rdsth
	srwcf	rdsth,rdsth
	slwcf	rdstl,rdstl,rsvc
	ow	rdsth,rdstl


	slbcf	rdsth,rsrcl


	jmp	L000


L2a6:	iw	0x0,rbal
	jmp	L38e


	slwcf	rdstl,rdstl,rsvc
	ow	rdsth,rdstl


L2aa:	jsr	print_octal_word
	jmp	L355


	slwf	rdstl,rdstl,rsvc
	ow	rdsth,rdstl


L2ae:	cl	0x20,rirl
	jzbt	L2cc
	cl	0xb,rirl
	jzbt	L257
	cl	0x22,rirl
	jzbt	L25b
	cl	0x10,rirl
	jzbt	L2d4
	cl	0x2f,rirl
	jzbt	L234
	jmp	L373


L2b9:	ll	0xff,rdstl
	mbf	rdstl,rdstl,rsvc
	ow	rdstl,rdstl


	jnt	L2b9
	ll	0x0,rdstl
	mbf	rdstl,rdstl,rsvc
	ow	rdstl,rdstl


	lgl	rirh,rsvc
	mwf	rsrcl,gl


L2c2:	jzbt	L2c6
	mw	gl,rbal
	nl	0x3f,rpswl
	jmp	L38e


L2c6:	r	rbah,rbal
	jmp	L2a6


	lgl	rirh
	w	gh,gl
	ow	rsrch,rsrcl,rsvc
	mwf	rsrcl,rsrcl


L2cc:	ll	0x0,rpswl
	rtsr
	jmp	L10b


	jmp	L000


	lgl	rirh
	wiw2	gh,gl
	ow	rsrch,rsrcl,rsvc
	mwf	rsrcl,rsrcl


L2d4:	jsr	L2de
	jsr	L3fa
	tl	0x80,rpswl
	jmp	L2c2


	lgl	rirh
	riw2	gh,gl
	iw	0x0,rbal
	w	rbah,rbal
	ow	rsrch,rsrcl,rsvc
	mwf	rsrcl,rsrcl


L2de:	al	0x2,rpswh
	jmp	L1f9


	lgl	rirh
	al	0xfe,gl
	cdb	gh
	w	gh,gl
	ow	rsrch,rsrcl,rsvc
	mwf	rsrcl,rsrcl


L2e6:	al	0x1,rpswh
	jmp	L3e5


	lgl	rirh
	al	0xfe,gl
	cdb	gh
	r	gh,gl
	iw	0x0,rbal
	w	rbah,rbal
	ow	rsrch,rsrcl,rsvc
	mwf	rsrcl,rsrcl


	lgl	rirh
	riw2	pch,pcl
	iw	0x0,rbal
	aw	gl,rbal
	w	rbah,rbal
	ow	rsrch,rsrcl,rsvc
	mwf	rsrcl,rsrcl


	jmp	L000


	lgl	rirh
	riw2	pch,pcl
	iw	0x0,rbal
	aw	gl,rbal
	r	rbah,rbal
	iw	0x0,rbal
	w	rbah,rbal
	ow	rsrch,rsrcl,rsvc
	mwf	rsrcl,rsrcl


; trap, 8-bit vector in rsrcl
trap:	ll	0x0,rsrch	; high byte of vector is zero

; trap, 16-bit vector in rsrc
trap16:	ri	i4		; clear trace interrupt enable

	al	0xfe,spl	; sp -= 2
	cdb	sph

	ccf	rirl
	nl	0xf,rirl
	nl	0xf0,rpswh
	orb	rpswh,rirl
	ll	0x0,rirh,,rsv1

	w	sph,spl
	ow	rirh,rirl

	al	0xfe,spl	; *--sp = pc
	cdb	sph
	w	sph,spl
	ow	pch,pcl

	nl	0xdf,rpswl

; fetch new PC and PSW
trapgo:	riw2	rsrch,rsrcl	; fetch new PC
	iw	0x0,pcl

	ri	i5		; disable interrupts

	r	rsrch,rsrcl	; fetch new PSW
	ib	0x1,rpswh
	
	jnbt	L318		; if PSW interrupt priority is zero
	si	i5		;   enable interrupts

L318:	tl	0x10,rpswh	; trace flag?
	jzbt	L31b
	si	i4		; set trace interrupt enable

L31b:	lcf	0xf,rpswh,rsvc
	nl	0x47,rpswl


	tl	0x8,rpswl
	jzbf	L321
	ll	0x0,rsrcl
	al	0x2,rpswl
L321:	ll	0x80,rsrch
	jmp	L324,,rfset

L323:	ib	0x1,rirh
L324:	rib2	rsrcl,rsrch
	jzbf	L323
	ib	0x1,rirh
	tl	0x8,rpswl,,tfclr
	jzbt	L32a
	ll	0xff,rsrch
L32a:	nl	0xfd,rpswl
	jmp	L04d


L32c:	tl	0x10,rpswl,,tfclr
	jzbf	L3b2
	tl	0x8,rpswl
	jzbf	L373
	tl	0x1,rpswl
	jzbf	L33a
	tl	0x2,rpswl
	jzbf	L33a
	tl	0x20,rpswl
	jzbf	L339
	al	0x20,rpswl

L337:	ll	0x04,rsrcl	; vector 004 - timeout & other errors
	jmp	trap


L339:	ll	0x3,rpswl
L33a:	jmp	L103


reset:	jsr	L14d,,ifclr
	tl	0x4,rirl
	jzbf	L32c

	ri	i5|i6|i4
L33f:	jsr	L022
	mw	pcl,spl
	ll	0x88,rpswl
L342:	ltr	rpswl,rpswl
	jsr	L14d
	tl	0x8,rirl
	jzbf	L342
	ll	0x0,rpswl,,pfclr
	nl	0x3,rirl,,efclr
	ll	0x0,pcl
	mi	pcl,rirl
	jmp	L34c


L34b:	jmp	L136


L34c:	jmp	L602		; reset mode 3: microcode at 3002
	jmp	reset_mode_1	; reset mode 1, run from 173000
	jmp	L103		; reset mode 2, ODT

; reset mode 0, load PC from 24, PS from 26
	ll	0x14,rsrcl
	ll	0x00,rsrch
	jmp	trapgo		; treat as trap, except skip stacking PC & PSW


L352:	nl	0xf0,rpswh
	nl	0x7,rpswl
	jmp	L0d4


L355:	sw	rdstl,rdstl
	jsr	L2de

	ll	0x40,rirl	; '@'
	jsr	L2e6

L359:	nl	0xdf,rpswl
L35a:	jsr	L3ce
	jsr	L2e6
	al	0xd0,rirl
	tl	0xf8,rirl
	jzbf	L360
	jmp	L22d

L360:	cl	0x1d,rirl
	jzbt	L3cc
	cl	0x1c,rirl
	jzbt	L3ae
	cl	0xff,rirl
	jzbt	L375
	cl	0xdd,rirl
	jzbt	L34b
	cl	0xda,rirl
	jzbt	L388
	cl	0x2e,rirl
	jzbt	L395
	cl	0xf4,rirl
	jzbt	L39c
	cl	0x17,rirl
	jzbt	L3a7
	cl	0xe3,rirl
	jzbt	L3ff
	jmp	L2ae


L373:	ll	0x3f,rirl
	jmp	L282


L375:	nl	0xef,rpswl
	tl	0x20,rpswl
	jzbf	L37e
	slb	rpswl,rsrcl
	jc8t	L381
L37a:	r	rbah,rbal
	iw	0x0,rdstl
L37c:	jsr	print_octal_word
	jmp	L093

L37e:	mw	rdstl,rbal
	nl	0x3f,rpswl
	jmp	L37a

L381:	jnbt	L384
L382:	mw	gl,rdstl
	jmp	L37c
	
L384:	ccf	rdstl
	nl	0xf,rdstl
	nl	0xf0,rpswh
	jmp	L28a


L388:	jsr	L3fa
	ll	0xd,rirl	; carriage return
	jsr	L2e6
	slb	rpswl,rsrcl
	jc8t	L392
L38d:	icw2	rbal,rbal
L38e:	mw	rbal,rdstl
	jsr	print_octal_word
	ll	0x2f,rirl
	jmp	L1b6

L392:	jnbt	L355
	icb1	rbal,rbal
L394:	jmp	L17a

L395:	jsr	L3fa
	jsr	L2de
	slb	rpswl,rsrcl
	jc8t	L39a
	jmp	L159

L39a:	jnbt	L355
	jmp	L29e

L39c:	nl	0x3f,rpswl
	jsr	L3ce
	jsr	L2e6
	cl	0x53,rirl
	jzbt	L3a5
	mb	rirl,rbal
	al	0xd0,rirl
	tl	0xf8,rirl
	jmp	L08b

L3a5:	ll	0xc0,rsrcl
	jmp	L08e

L3a7:	mw	rdstl,pcl
	ll	0x0,rirl
	jsr	L2e6
	jsr	L2e6
	sw	rpswl,rpswl
	lcf	0xf,rpswl
	jmp	L196

L3ae:	icw2	rdstl,spl
	ll	0x18,rpswl
	ltr	rpswl,rpswl
	jmp	L151

L3b2:	al	0xfe,pcl
	cdb	pch
	w	pch,pcl
	ow	rdsth,rdstl
	al	0x10,rpswl
	ltr	rpswl,rpswl
L3b8:	jsr	L3c4
	cl	0xe9,rirl
	jzbt	L3b8
L3bb:	icb1	rirl,pcl
L3bc:	jsr	L3c4
	wib1	pch,pcl
	ob	rirl,rirl
	cl	0xeb,pcl
	jzbt	L3bb
	cl	0xfd,pcl
	jzbf	L3bc
	jmp	L0cb


L3c4:	ll	0x1,rirl
	w	rdsth,rdstl
	ob	rirl,rirl
L3c7:	nop
	r	rdsth,rdstl
	ib	0x1,rirl
	jnbf	L3c7
	jmp	L149


L3cc:	mb	rpswl,rdstl
	jmp	L2aa


; get a receive character from SLU
L3ce:	ll	0x40,rsrch	; load translation register with 0x4040
	ltr	rsrch,rsrch

	ll	0xff,rsrch	; rsrc := RCSR (177560)

L3d1:	ll	0x70,rsrcl	; wait for RCSR receiver done bit set
	r	rsrch,rsrcl
	ib	0x1,rsrcl
	jnbf	L3d1

L3d5:	ll	0x72,rsrcl	; rsrc := RBUF (177562)
	r	rsrch,rsrcl
	ib	0x1,rirl

	nl	0x7f,rirl
	cl	0x7f,rirl
	jzbf	L3f6
	jmp	L229


print_octal_word:
	al	0x6,rpswh	; output six octal digits
	ll	0x0,rsrch	; but only one bit for first octal digit

L3de:	ll	0x0,rirl
L3df:	slb	rirl,rirl
	slw	rdstl,rdstl
	cib	rirl
	db1	rsrch,rsrch
	jnbf	L3df

	al	0x30,rirl	; '0' - convert octal digit in rirl to ASCII

L3e5:	ll	0x60,rsrch	; load translation register with 0x6060
	ltr	rsrch,rsrch

	ll	0xff,rsrch	; rsrc := XCSR (177564)
L3e8:	ll	0x74,rsrcl	; wait for XCSR transmitter empty bit set
	r	rsrch,rsrcl
	ib	0x1,rsrcl
	jnbf	L3e8

	ll	0x76,rsrcl	; write rirl to XBUF (177566)
	w	rsrch,rsrcl
	ob	rirl,rirl

	db1	rpswh,rpswh
	tl	0x7,rpswh
	jzbt	L3f6
	tl	0x8,rpswh
	jzbf	L3f7

	ll	0x2,rsrch	; bit counter for one octal digit (3 bits)
	jmp	L3de		; output another octal digit


L3f6:	rfs


L3f7:	nl	0xf7,rpswh
	ll	0xa,rirl	; line feed char
	jmp	L3e8


L3fa:	tl	0x10,rpswl
	jzbt	L373
	jmp	L26e


	jmp	L000
	jmp	L000


L3ff:	jmp	L169


; microm 3 for expansion by user

	org	0x600
; opcodes 00022x
L600:

	org	0x601
; opcodes 076xxx
L601:

	org	0x602
; reset mode 3, microcode
L602:

	org	0x603
; opcodes 075040-075777
L603:

	org	0x604
; external device and event line interrupts
L604:
