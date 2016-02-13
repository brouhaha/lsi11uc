; DEC LSI-11 DIS microcode, MICROMs CP1631-25 and CP1631-26
; Reverse-engineered source code
; Copyright 2016 Eric Smith <spacewar@gmail.com>

; Reverse-engineering in progress:
;   There are probably many errors.
;   There is no existing assembler that can assemble this file as-is.

; Note that there are jumps and subroutine returns that occur on
; microinstructions that aren't explicit flow control instructions, due
; to the translation PLAs in the control chip. These PLAs have not yet
; been dumped. From study of the code one may be able to infer where some
; of these translations occur.

	org	0x000
illegal_instruction:

	org	0x301
L301:


	org	0x400

	jmp	illegal_instruction


L401:	cl	0x4,rirh
	jc8f	L404
L403:	jmp	L6a1

L404:	tl	0xff,gh
	jzbf	L409
	jmp	L498


L407:	mi	rpswl,rirh
	jmp	L56c


L409:	jsr	L6d3
	jmp	L7e7


L40b:	ll	0x0,rsrcl
	jsr	L6c6
	mb	rdsth,rbal
	tl	0x1,rirh
	jzbt	L412
	ll	0x40,rirh
	xb	rirh,rbal
L412:	ll	0x2,rsrcl
	jsr	L6c6
	slbf	rdsth,rdsth
	orb	rdsth,rbal
	ll	0x4,rsrcl
	jsr	L6c6
	ll	0x2,rsrcl
	lgl	rsrcl
	icb1	rbah,gh
	jsr	L6d2		; overrides EII translation, octal 2033
	mb	rbal,rirh
	jnbf	L41f
	ll	0x8,rpswh
L41f:	al	0x40,rirh
	jnbf	L456
	nl	0x8,rpswh
	al	0x74,rpswh
	lgl	rpswl
	al	0x2,gh
L425:	jsr	L6e5
	sbcf	rdsth,rdstl
	cad	rsrcl,rdstl
	nl	0xf,rdstl
	al	0x30,rdstl
	lgl	rpswl
	tb	gl,gl
	jzbt	L42e
	jmp	L6dd

L42e:	tl	0x1,rpswh
	jzbf	L491
	lgl	rbal
	tb	gl,gl
	jzbf	L474
	lgl	rsrcl
	tb	gl,gl
	jzbf	L474
	tl	0x10,rpswh
	jzbf	L473
	jct	L47b
	tl	0x40,rpswh
	jzbf	L43e		; overrides EII translation, octal 2072
	jmp	L43c		; why?
L43c:	ll	0x2,rdsth
	orb	rdsth,rpswh
L43e:	lgl	rsrcl
	mb	gh,rdstl
	jzbt	L445
	lgl	rpswl
	mb	rdstl,gl
	lgl	rsrch
	icw1	gl,gl
L445:	tl	0x4,rpswh
	jzbt	L448
	nl	0xf7,rpswh
L448:	lcf	0xe,rpswh
	jnf	L452
	ll	0x4,rsrcl
	jsr	L6c6
	r	gh,gl
	sb	rbah,gl
	ib	0x6,rsrcl
	cdb	gh
	al	0x40,rsrcl
	ob	rsrcl,rsrcl
L452:	lcf	0x1,spl
	jsr	L6a4		; overrides PSW translation, octal 2123
L454:	sw	gl,gl
	jmp	L672


L456:	al	0x4,rpswh
	lgl	rpswl
	al	0x1,gh
L459:	jsr	L6e5
	al	0xf6,rdstl
	abcf	rdsth,rdstl
	cad	rsrcl,rdstl
	nl	0xf,rdstl
	al	0x30,rdstl
	lgl	rpswl
	tb	gl,gl
	jzbt	L463
	jmp	L6dd


L463:	lgl	rbal
	mb	gl,rdsth
	lgl	rsrcl
	orb	gl,rdsth
	jzbt	L46d
	cl	0x30,rdstl
	jzbt	L459
	ll	0x2,rdstl
	orb	rdstl,rpswh
	jmp	L459


L46d:	jct	L470
	cl	0x30,rdstl
	jzbt	L43e
L470:	ll	0x2,rdstl
	orb	rdstl,rpswh
	jmp	L43e


L473:	nl	0xef,rpswh
L474:	cl	0x39,rdstl
	jzbt	L477
	nl	0xdf,rpswh
L477:	cl	0x30,rdstl
	jzbt	L47a
	nl	0xbf,rpswh
L47a:	jmp	L425		; overrides PSW translation, octal 2172


L47b:	lgl	rsrcl
	mb	gh,rdstl
	lgl	rbal
	mb	rdstl,gl
	sbf	rdsth,rdsth
	lgl	rpswl
	mb	rdstl,gl
	lgl	rsrch
	aw	rdstl,gl
	mw	gl,rdstl
	lgl	rbah
	mw	rdstl,gl
	tl	0x4,rpswh
	jzbt	L48d
	tl	0x40,rpswh
	jzbf	L48d
	ll	0x2,rdstl
	orb	rdstl,rpswh
L48d:	orb	rpswl,rpswh
	al	0x1,rpswh
	jmp	L425


	jmp	illegal_instruction	; overrides FII translation, octal 2220


L491:	tl	0x20,rpswh
	jzbf	L495
	ll	0x2,rdsth
	orb	rdsth,rpswh
L495:	ll	0x8,rdstl
	xb	rdstl,rpswh
	jmp	L43e


L498:	lgl	rpswh
	tb	gl,gl
	jzbt	L403
	ll	0x1,rdstl
	jmp	L53f


L49d:	ll	0x3,rirh
	ll	0x89,rpswh
	ll	0x0,rbal
	lgl	rbal
	mb	gl,rbal
	ll	0x2,rirl
	lgl	rirl
	cb	rbal,gl
	jzbt	L4b8
	jc8f	L4e6
	sb	rbal,gl
	mb	gl,rirl
	ll	0x0,rbal
	lgl	rbal
	mb	gl,rbal
	jmp	L4ad		; overrides FII translation, octal 2254


L4ad:	lgl	rpswl
	al	0x4,gh
	lgl	rirh
L4b0:	riw1	gh,gl
	ib	0x2,rdstl
	tl	0xf,rdstl
	jzbf	L4f8
	si	i6
	db1,rsvc	rirl,rirl	; end macroinstruction
	ri	i6


L4b7:	jzbf	L4b0
L4b8:	lgl	rpswl
	nl	0xf0,gh
	al	0x3,gh
L4bb:	lgl	rpswh
	jmp	L4bd		; overrides FII translation, 2274


L4bd:	si	i6
	db1f,rsvc	rbal,rbal	; end macroinstruction
	ri	i6


	jct	L4ff
	riw1	gh,gl
	lgl	rirh
	ib	0x2,rdsth
	nl	0xf,rdsth
	jzbt	L4c7
	nl	0x7f,rpswh
L4c7:	riw1	gh,gl
	lgl	rpswh
	ib	0x2,rdstl
	nl	0xf,rdstl
	jzbt	L4cd
	nl	0x7f,rpswh
L4cd:	cb	rdstl,rdsth
	jzbt	L4bd
	jnbt	L4f5
	jmp	L4d1		; overrides FII translation, octal 2320
L4d1:	ll	0x1,rirl
L4d2:	db1	rirl,rirl
	dw1	gl,gl
	ab	rbal,gl
	cib	gh
	ab	rirl,gl
	cib	gh
	r	gh,gl
	ll	0x0,rirl
	ib	0x2,rdstl
	lcf	0xf,rirl
	tl	0x40,rpswh
	jzbf	L4df
	al	0x40,rdstl
L4df:	nl	0x40,rdstl
	jzbf	L4e2
	lcf	0x8,rpswh
L4e2:	tl	0x80,rpswh
	jnbf	L4e5
	sbf	rirl,rirl
L4e5:	jmp	L452


L4e6:	sb	gl,rbal
	mb	rbal,rirl
	mb	gl,rbal
	lgl	rpswl
	al	0x5,gh
	lgl	rpswh
L4ec:	riw1	gh,gl
	ib	0x2,rdsth
	tl	0xf,rdsth
	jzbf	L4fa
	si	i6
	db1,rsvc	rirl,rirl	; end macroinstruction
	ri	i6


L4f3:	jzbf	L4ec
	jmp	L4b8


L4f5:	al	0x40,rpswh
	lgl	rirh
	jmp	L4d1


L4f8:	al	0xc0,rpswh
	jmp	L4d2


L4fa:	nl	0x7f,rpswh
	jmp	L4d2


L4fc:	cl	0x2b,rdstl
	jzbt	L403
	jmp	L570


L4ff:	tl	0x80,rpswh
	jzbt	L507
	sbf	rirh,rirh
	jmp	L452


L503:	r	gh,gl
	ib	0x2,rdstl
	jmp	L4fc


L506:	jmp	L403		; overrides FII translation, octal 2406


L507:	lgl	rirh
	dw1	gl,gl
	r	gh,gl
	lgl	rpswh
	ib	0x2,rdstl
	dw1	gl,gl
	r	gh,gl
	nl	0x40,rdstl
	ib	0x2,rdsth
	nl	0x40,rdsth
	cbf	rdsth,rdstl
	jmp	L452


L513:	tb	gl,gl
	jzbt	L506
L515:	lgl	rpswl
	mb	rpswh,gh
	jmp	L407


L518:	mb	gl,rsrch
L519:	mbf	rdsth,rpswh
	jnf	L51c
	tcw	rdstl,rdstl
L51c:	tbf	rdsth,rdsth
	jzf	L523
	mb	rdstl,rpswl
	mb	rsrcl,rdsth
	mb	rsrch,rdstl
	mb	rpswl,rsrch
	ll	0x0,rsrcl
L523:	ll	0x10,rpswl
L524:	srbcf	rsrch,rsrch
L525:	caw	rdstl,rbal
	srwf	rbah,rbah
	srbcf	rsrch,rsrch		; EII translation, octal 2447

	caw	rdstl,rbal
	srwf	rbah,rbah
	srbcf	rsrch,rsrch
	slb	rpswl,rpswl
	jc8f	L525
	jnbt	L536
	mb	rsrch,rpswl
	mbf	rsrcl,rsrch
	mb	rpswl,rsrcl
	ll	0x18,rpswl
	jzf	L524
	mb	rbal,rsrch
	mb	rbah,rbal
	ll	0x0,rbah
L536:	tb	rpswh,rpswh
	jnbf	L54b
	ocw	rbal,rbal
	tcw	rsrcl,rsrcl
	cib	rbal
	cib	rbah
	jmp	L54b


L53d:	icb1	rbal,rbal
	jmp	L4bb


L53f:	lgl	rdstl
	jmp	L503		; overrides EII translation, octal 2500


L541:	al	0x6,gh
L542:	ll	0x0,rsrcl
	jsr	L6b7
	mb	rdsth,rpswh
	ll	0x2,rdstl
	lgl	rdstl
	sw	gl,gl
	ll	0x3,rdstl
	lgl	rdstl
	jmp	L7a2


L54b:	mw	rbal,gl
	nl	0x6,rirl
	al	0x1,rirl
	lgl,lrr	rirl		; PSW translation, octal 2516

	ll	0x0,rpswl
	mw	rsrcl,gl
	jnbt	L554
	tcwf,rsvc	rbal,rdstl	; end macroinstruction
	orwf	rsrcl,rbal


L554:	ocw	rbal,rdstl
	tcwf,rsvc	rdstl,rdstl	; end macroinstruction
	orbf	rirl,rbah


L557:	slbf	rirh,rbah
	slbc	rirl,rirl
	slbf	rbah,rbah
	slbc	rirl,rirl
	lgl	rirl
	tl	0x10,rirl
	jzbf	L57f
	sw	rbal,rbal
	mb	gh,rsrcl
	jnbf	L518		; may override EII translation, octal 2540

	tcw	gl,rsrch
	tcwf	rdstl,rdstl
	jvf	L519
	ll	0x0,rpswh
	jmp	L523


L566:	ltr	rpswh,rpswh
	jmp	L557


	ll	0x0,rpswh		; RET translation, octal 2550

	ll	0x10,rpswh		; RET translation, octal 2551

	ll	0x80,rpswh		; RET translation, octal 2552

	ll	0x90,rpswh		; RET translation, octal 2553


; jump table, from routine at L407
L56c:	jmp	L40b
	jmp	L40b
	jmp	L49d
	jmp	L541


L570:	cl	0x2d,rdstl
	jzbt	L506
	cl	0x3,rirh
	jmp	L593


L574:	ll	0x2,rbah
	ll	0x0,rpswl
	jmp	L5d4


L577:	ltr	rpswh,rpswh
	jmp	L59d


	mb	gh,rsrch	; DMW translation, octal 2571


L57a:	mw	gl,rdstl
	jmp	L577


	jmp	L57a


	mw	gl,rdstl
	jmp	L566


L57f:	slb	rdstl,rdstl
	slb	rdstl,rdstl
	jnbf	L589
	slbf	rsrch,rdsth
	jmp	L585


L584:	srwc	rsrch,rsrch		; EII translation, octal 2604


L585:	al	0x4,rdstl
	jzbf	L584
	srwcf,rsvc	rsrch,rsrch	; end macroinstruction
	mwf	rsrcl,gl


L589:	sbf	rdsth,rdsth
L58a:	al	0xfc,rdstl
	jnbt	L590
	slwf	rsrcl,rsrcl		; EII translation, octal 2614

	jvf	L58a
	ll	0x2,rdsth
	jmp	L58a


L590:	mwf,rsvc	rsrcl,gl	; end macroinstruction
	lcf	0x2,rdsth


	jmp	illegal_instruction	; overrides PSW translation, octal 2622


L593:	jzbt	L515
	ll	0x2,rdstl
	lgl	rdstl
	jmp	L513


L597:	dw1f	rdstl,rdstl
L598:	ll,lrr	0x2,rsrch	; PSW translation, octal 2622
	lcf,rsvc	0xe,rsrch	; end macroinstruction
	ll	0x0,rpswl


L59b:	mwf,rsvc	rbal,gl		; end macroinstruction
	ll	0x0,rpswl


L59d:	slbf	rirh,rpswh
	slbc	rirl,rirl
	slbf	rpswh,rpswh
	slb	rirl,rpswh
	al	0x1,rpswh
	lgl	rpswh
	slbc	rirl,rirl
	mw	gl,rbal		; EII translation, octal 2644
	tl	0x10,rirl
	jzbf	L5da
	nl	0x3f,rirh
	tb	rsrch,rsrch
	jnbf	L5af
	ocw	rsrcl,rsrcl
	tcw	rbal,rbal
	cib	rsrcl		; EII translation, octal 2654
	cib	rsrch
	al	0xc0,rirh
L5af:	tb	rdsth,rdsth
	jnbf	L5b3
	tcw	rdstl,rdstl
	al	0x80,rirh
L5b3:	cwf	rdstl,rsrcl
	jcf	L597
	tcw	rdstl,rpswl
	dw1	rdstl,rdstl
	nl	0x6,rirl
	slwf	rbal,rbal
L5b9:	slwc	rsrcl,rsrcl
	cwf	rsrcl,rdstl
	caw	rpswl,rsrcl
	slwcf	rbal,rbal
	slwc	rsrcl,rsrcl
	cwf	rsrcl,rdstl
	caw	rpswl,rsrcl
	slwcf	rbal,rbal	; EII translation, octal 2700
	al	0x20,rirl
	jc8f	L5b9
	tl	0x40,rirh
	jzbt	L5c6
	tcw	rsrcl,rsrcl
L5c6:	mb	rirh,rpswh
	jnbf	L5ca
	tcw	rbal,rbal	; EII translation, octal 2710
	jzbt	L5cc
L5ca:	xb	rbah,rpswh
	jnbt	L598
L5cc:	mw,lrr	rsrcl,gl	; PSW translation, octal 2714
	lgl	rirl
	jmp	L59b


	lgl,lrr	rirh		; PSW translation, octal 2717
	slb	rirh,rirh
	slb	rirh,rirh
	slbf	rirh,rirh
	jmp	L574


L5d4:	jnf	L5d8
	jct	L5d7
	sw	rbah,gl
L5d7:	cabf	rbah,rbah
L5d8:	caw,rsvc	rbah,gl		; end macroinstruction
	sw	rbah,pcl


L5da:	slb	rdstl,rdstl
	sbf	rpswl,rpswl
	slb	rdstl,rdstl
	jnbt	L5e5
L5de:	al	0xfc,rdstl
	jnbt	L5ea
	slwf	rbal,rbal	; EII translation, octal 2740
	slwcf	rsrcl,rsrcl
	jvf	L5de
	ll	0x2,rpswl
	jmp	L5de

L5e5:	slbf	rsrch,rdsth
	srwcf	rsrch,rsrch
	srwcf	rbah,rbah
	al	0x4,rdstl	; EII translation, octal 2750
	jzbf	L5e5
L5ea:	lgl	rirl
	mwf	rsrcl,gl
	lgl,lrr	rpswh		; PSW translation, octal 2754
	mw	rbal,gl
	jzbt	L5f0
	lcf	0x6,rpswl
L5f0:	lcf,rsvc	0x2,rpswl	; end macroinstruction
	ll	0x0,rpswl


L5f2:	lgl	rirh
	tb	rirl,rirl
	jmp	L4b7


L5f5:	lgl	rpswh
	tb	rirl,rirl
	jmp	L4f3


L5f8:	jmp	L401


L5f9:	ltr	rpswh,rpswh
	ow	rdsth,rdstl
	jmp	L59d


	jmp	L5f9


	ltr	rpswh,rpswh
	ow	rdsth,rdstl
	jmp	L557


; entry points from base microcode
L600:	jmp	illegal_instruction	; instructions 000220..000227
	jmp	op_076xxx		; instructions 076000..076777
	jmp	illegal_instruction	; power-up mode 3
	jmp	illegal_instruction	; instructions 075040..075777

	lgl	rpswl		; external device and event line interrupts
	mb	gh,rpswl
	nl	0xf,rpswl
	cl	0xb,rpswl
	jzbf	L619
	jsr	L6d9
	ow	rdsth,rpswh
	mb	gh,rpswh
	nl	0xf0,rpswh
	lgl	rpswh
	mw	rsrcl,gl
	ll	0x1,rdstl
	lgl	rdstl
	mw	rbal,gl
	icb1	rdstl,rdstl
	lgl	rdstl
	mw	rirl,gl
L615:	ri	i4
	al	0xfe,pcl
	cdb,rsvc	pch	; end macroinstruction
	ll	0x0,rpswl


L619:	jsr	L6d9
	ow	rirh,rirl
	jsr	L6d9
	ow	rpswh,rbal
	mb	gh,rpswh
	nl	0xf0,rpswh
	jmp	L615


op_076xxx:
	srw	rirl,rsrch
	nl	0x90,rpswh
	nl	0x7,rirh
	ll	0x4,rpswl
	nl	0xfc,rsrcl
	cl	0xc,rsrcl
	jzbt	L62e

	lgl	rpswl
	cl	0x10,rsrcl
	jzbf	L62b
	jmp	L6fb

L62b:	cl	0x14,rsrcl
	jzbf	L6a1
	jmp	L5f8

L62e:	cl	0x2,rirh
	jc8t	L6a1
	mb	rirh,rdstl
	mw	gl,rsrcl
	ll	0x1,rirl
	lgl	rirl
	mw	gl,rbal
	ll	0x2,rirl
	lgl	rirl
	mw	gl,rirl
	al	0xb,rpswh
	lgl	rpswl
	tb	gh,gh
	jzbt	L642
	riw2	sph,spl
	iw	0x0,rdstl
	mb	rdstl,rpswh
	jsr	L6b3
	mi	rpswl,rpswh
	jmp	L700


L642:	mb	rpswh,gh
	lgl	rpswh
	cwf	rirl,rsrcl
	tw	rirl,rirl
	jzbt	L670
	tw	rsrcl,rsrcl
	jzbt	L653
	srb	rdstl,rdstl
	jc8t	L65d
	cw	gl,rbal
	jc8f	L655
	jsr	L6ac
L64e:	ll	0x50,rdsth
	jmp	L677


L650:	jcf	L670
L651:	ll	0x70,rdsth
	jmp	L681


L653:	tcw	rirl,rsrcl
	jmp	L651


L655:	jsr	L6aa
	jcf	L65b
	ll	0x59,rdsth
	jmp	L68a


	ll	0x70,rdsth
	jmp	L694


L65b:	sw	rsrcl,rbal
	jmp	L66a


L65d:	aw	rsrcl,rbal
	aw	rirl,gl
	cw	gl,rbal
	jc8f	L669
	sw	rsrcl,rbal
	sw	rirl,gl
	jsr	L6ac
	jcf	L66e
	ll	0x67,rdsth
	jmp	L681


	ll	0x70,rdsth
	jmp	L677


L669:	jsr	L6ac
L66a:	ll	0x6c,rdsth
	jmp	L694


	aw	rsrcl,gl
	jmp	L650


L66e:	aw	rsrcl,rbal
	jmp	L64e


L670:	jsr	L6a4
	mw	rsrcl,gl
L672:	lgl	rpswl
	mb	gh,rpswh
	nl	0xf0,rpswh
	ll,rsvc	0x0,rpswl		; end macroinstruction
	sb	gh,gh


L677:	ll	0x9c,rpswh
L678:	riw1	rbah,rbal
	ib	0x2,rdstl
	wiw1	gh,gl
	ob	rdstl,rdstl
	si	i6
	dw1,rsvc	rirl,rirl	; end macroinstruction
	ri	i6


L67f:	jzbf	L678
	jmp	L69f


L681:	ll	0x9e,rpswh
	jsr	L6b3
L683:	wiw1	gh,gl
	ob	rdstl,rdstl
	si	i6
	icw1,rsvc	rsrcl,rsrcl	; end macroinstruction
	ri	i6


L688:	jzbf	L683
	jmp	L69f


L68a:	ll	0xa0,rpswh
	jsr	L6b3
L68c:	dw1	gl,gl
	w	gh,gl
	ob	rdstl,rdstl
	si	i6
	icw1,rsvc	rsrcl,rsrcl	; end macroinstruction
	ri	i6


L692:	jzbf	L68c
	jmp	L69f


L694:	ll	0xe5,rpswh
L695:	dw1	rbal,rbal
	r	rbah,rbal
	ib	0x2,rdstl
	dw1	gl,gl
	w	gh,gl
	ob	rdstl,rdstl
	si	i6
	dw1,rsvc	rirl,rirl	; end macroinstruction
	ri	i6


L69e:	jzbf	L695
L69f:	mi	rpswl,rdsth
	jmp	L600


L6a1:	ll	0x0,rpswl
	ll	0x8,rsrcl
	jmp	L301


L6a4:	ll	0x3,rdstl
L6a5:	lgl	rdstl
	sw	gl,gl
	db1	rdstl,rdstl
	jnbf	L6a5
	rfs


L6aa:	aw	rsrcl,rbal
	aw	rirl,gl
L6ac:	sw	rirl,rsrcl
	jc8t	L6b2
	tb	rirh,rirh
	jnbf	L6b1
	tcw	rsrcl,rsrcl
L6b1:	aw	rsrcl,rirl
L6b2:	rfs


L6b3:	lgl	rpswl
	mb	gl,rdstl
	lgl	gh
	rfs


L6b7:	lgl	rsrcl
	icb1	rsrcl,rsrch
	si	i6
	tb,rsvc	gl,gl			; end macroinstruction
	ri	i6


	jzbt	L6c8
	lgl	rsrch
	r	gh,gl
	ib	0x2,rirl
	tl	0xf,rirl
	jzbf	L6c6
	icw1	gl,gl
	lgl	rsrcl
	db1	gl,gl
	jmp	L6b7

L6c6:	lgl	rsrcl
	icb1	rsrcl,rsrch
L6c8:	ll	0x0,rdsth
	db1	gl,rbah
	jc8f	L6d1
	lgl	rsrch
	ab	rbah,gl
	cib	gh
	r	gh,gl
	ib	0x2,rdsth
	nl	0x40,rdsth
L6d1:	rfs


L6d2:	nl	0xf8,rbal
L6d3:	ll	0x1,rbah
	ll	0xaa,rsrcl
	ll	0x3,rdstl
	ll	0x5,rsrch
	ll	0x4,rpswl
	rfs


L6d9:	al	0xfe,spl
	cdb	sph
	w	sph,spl
	rfs


L6dd:	db1	gl,gl
	lgl	rsrch
	tl	0xf,rdstl
	jzbt	L6e2
	nl	0xfb,rpswh
L6e2:	w	gh,gl
	dw1	gl,gl
	ob	rdstl,rdstl
L6e5:	si	i6
	lgl,rsvc	rbal		; end macroinstruction
	ri	i6


	mb	gl,rdsth
	jzbt	L6f0
	db1	gl,gl
	lgl	rbah
	r	gh,gl
	dw1	gl,gl
	ib	0x2,rdsth
	nl	0xf,rdsth
L6f0:	lgl	rsrcl
	mb	gl,rdstl
	jzbt	L6fa
	db1	gl,gl
	ll	0x3,rdstl
	lgl	rdstl
	r	gh,gl
	dw1	gl,gl
	ib	0x2,rdstl
	nl	0xf,rdstl
L6fa:	rfs


L6fb:	cl	0x5,rirh
	jc8t	L6a1
	mb	gl,rbah
	ll	0x1,rdsth
	tl	0xff,gh
L700:	jzbt	L702
	jmp	L7e7

L702:	mb	rpswh,gh
	al	0x8,gh
L704:	sbf	rbal,rbal
	mi	rbal,rirh
	jmp	L7e0


L707:	ll	0x2,rirl
	ll	0x3,rirh
	lgl	rpswh
	mw	gl,rsrcl
	lgl	rirl
	cwf	rsrcl,gl
	jcf	L72c
	mw	gl,rsrcl
	lgl	rpswh
	sw	rsrcl,gl
	lgl	rpswl
	al	0x4,gh
	lgl	rirl
L714:	dw1f	gl,gl
	jct	L749
	lgl	rirh
	riw1	gh,gl
	lgl	rdsth
	ib	0x2,rbal
	riw1	gh,gl
	lgl	rirl
	ib	0x2,rpswh
L71d:	si	i6
	cbf,rsvc	rbal,rpswh	; end macroinstruction
	ri	i6


	jzbt	L714
	lgl	rdsth
	dw1	gl,gl
	lgl	rirl
	icw1	gl,gl
	mw	gl,rsrcl
	ll	0x0,rpswh
	lgl	rpswh
	aw	rsrcl,gl
	lgl	rirh
	dw1	gl,gl
	jmp	L672


L72c:	sw	rsrcl,gl
	lgl	rpswl
	al	0x1,gh
L72f:	ll	0x0,rpswh
	lgl	rpswh
	dw1f	gl,gl
	jct	L75d
	lgl	rdsth
	riw1	gh,gl
	lgl	rirh
	ib	0x2,rbal
	riw1	gh,gl
	lgl	rpswh
	ib	0x2,rpswh
L73a:	si	i6
	cbf,rsvc	rpswh,rbal	; end macroinstruction
	ri	i6


	jzbt	L72f
	lgl	rirh
	dw1	gl,gl
	ll	0x0,rpswh
	lgl	rpswh
	icw1	gl,gl
	mw	gl,rsrcl
	lgl	rirl
	aw	rsrcl,gl
	lgl	rdsth
	dw1	gl,gl
	jmp	L672


L749:	icw1	gl,gl
	lgl	rpswl
	al	0x1,gh
	ll	0x0,rpswh
	lgl	rpswh
L74e:	dw1f	gl,gl
	jct	L770
	lgl	rdsth
	riw1	gh,gl
	lgl	rpswh
	ib	0x2,rbal
L754:	si	i6
	cbf,rsvc	rbah,rbal	; end macroinstruction
	ri	i6


	jzbt	L74e
	lgl	rdsth
	dw1	gl,gl
	lgl	rpswh
	icw1	gl,gl
	jmp	L672


L75d:	icw1	gl,gl
	lgl	rpswl
	al	0x1,gh
	lgl	rirl
L761:	dw1f	gl,gl
	jct	L770
	lgl	rirh
	riw1	gh,gl
	lgl	rirl
	ib	0x2,rbal
L767:	si	i6
	cbf,rsvc	rbal,rbah	; end macroinstruction
	ri	i6


	jzbt	L761
	lgl	rirh
	dw1	gl,gl
	lgl	rirl
	icw1	gl,gl
L76f:	jmp	L672


L770:	icw1f	gl,gl
	lcf	0x1,spl
	jmp	L672


L773:	lgl	rirl
	jmp	L71d


L775:	lgl	rpswh
	jmp	L754


L777:	lgl	rirl
	jmp	L767


L779:	jsr	L792
	cb	rbah,rsrcl
	jzbf	L792
L77c:	lgl	rpswh
	icw1	gl,gl
	lgl	rdsth
	dw1	gl,gl
	jmp	L672


L781:	jsr	L792
	cb	rbah,rsrcl
	jzbt	L792
	jmp	L77c


L785:	mb	rirh,rbal
	nl	0x1,rbal
	ll	0x5,rdstl
	ll	0x0,rsrch
	jsr	L792
	lgl	rdstl
	aw	gl,rsrcl
	r	rsrch,rsrcl
	ll	0x0,rsrch
	ib	0x2,rsrcl
	nb	rbah,rsrcl
	mi	rbal,rsrch
	jzbf	L77c
L792:	si	i6
	lgl,rsvc	rpswh		; end macroinstruction
	ri	i6


	twf	gl,gl
	jzt	L76f
	dw1	gl,gl
	lgl	rdsth
	riw1	gh,gl
	ib	0x2,rsrcl
	rfs


	tw	rirl,rirl
	jmp	L67f


	tw	rsrcl,rsrcl
	jmp	L688


	tw	rsrcl,rsrcl
	jmp	L692


L7a2:	sw	gl,gl
	lgl	rpswl
	al	0x1,gh
	ll	0x1,rdsth
	db1	rdsth,rdstl
	lgl	rdstl
	db1	gl,rdstl
	lgl	rdsth
	ll	0x0,rdsth
	sw	rdstl,gl
	ll	0x3,rbal
	ll	0x1,rirl
L7ae:	ll	0x2,rbah
L7af:	si	i6
	lgl,rsvc	rpswh		; end macroinstruction
	ri	i6


	tb	gl,gl
	jzbt	L7cc
	db1	gl,gl
	lgl	rirl
	riw1	gh,gl
	lgl	rbal
	ib	0x2,rirh
	nl	0xf,rirh
	slwf	gl,gl
	mw	gl,rsrcl
	lgl	rbah
	tl	0xf0,gh
	jzbf	L7db
	slwc	gl,gl
	slwf	rsrcl,rsrcl
	slwc	gl,rdstl
	slwf	rsrcl,rsrcl
	slwc	rdstl,rdstl
	lgl	rbal
	awf	rsrcl,gl
	aw	rirh,gl
	lgl	rbah
	cib	gl
	cib	gh
	awc	rdstl,gl
	jmp	L7af


L7cc:	sw	rdstl,rdstl
	slb	rpswh,rirh
	jnbf	L7d4
	lgl	rbal
	tcwf	gl,gl
	lgl	rbah
	awc	rdstl,gl
	tcw	gl,gl
L7d4:	lgl	rbal
	tcwf	gl,rsrcl
	awcf	rdstl,rdstl
	lgl	rbah
	orwf	gl,rdstl
	xb	gh,rirh
	jnbf	L7de
L7db:	lcf	0x3,rbah
	lgl	rpswh
	sw	gl,gl
L7de:	lgl	rirl
	jmp	L454


; jump table, routine at L704
L7e0:	jmp	L779
	jmp	L781
	jmp	L785
	jmp	L785
	jmp	L707
	tw	rirl,rirl
	jmp	L69e
L7e7:	riw2	sph,spl
	mb	gh,rdstl
	iw	0x0,rpswl
	riw2	sph,spl
	mb	rpswl,rbal
	iw	0x0,rirl
	ll	0x4,rpswl


; dispatch based on low four bits of rdstl
; if low four bits are all zero, will result in infinite loop
	nl	0xf,rdstl
	mi	rpswl,rdstl
L7f0:	jmp	L7f0
	jmp	L459
	jmp	L425
	jmp	L53d
	jmp	L5f2
	jmp	L5f5
	jmp	L542
	jmp	L7ae
	jmp	L704
	jmp	L73a
	jmp	L777
	jmp	illegal_instruction
	jmp	L773
	jmp	L775
	jmp	illegal_instruction
	jmp	illegal_instruction
