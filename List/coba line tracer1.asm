
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 11,059200 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _posisi=R4
	.DEF _garis=R7
	.DEF _i=R8
	.DEF _limit_adc=R10
	.DEF __lcd_x=R6
	.DEF __lcd_y=R13
	.DEF __lcd_maxx=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x58:
	.DB  0x32,0x0
_0x0:
	.DB  0x25,0x64,0x25,0x64,0x25,0x64,0x25,0x64
	.DB  0x25,0x64,0x25,0x64,0x25,0x64,0x25,0x64
	.DB  0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0A
	.DW  _0x58*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 16/06/2016
;Author  : FUDOMAS
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 11,059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <stdlib.h>
;#include <delay.h>
;#define maju_kanan   PORTD.7
;#define maju_kiri    PORTD.3
;#define mundur_kanan PORTD.6
;#define mundur_kiri  PORTD.2
;#define kec_kiri     OCR1B
;#define kec_kanan    OCR1A
;char sensor[16];
;int posisi;
;
;unsigned char sen[10], garis;
;int i;
;int adc[10],logic[10];
;int limit_adc=50;
;char s[8];
;char datagelap[8],dataterang[8],range[8],hasilbin[8];
;char tampil[33];
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;#define ADC_VREF_TYPE 0x20
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0035 {

	.CSEG
_read_adc:
; 0000 0036 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 0037 // Delay needed for the stabilization of the ADC input voltage
; 0000 0038 delay_us(10);
	__DELAY_USB 37
; 0000 0039 // Start the AD conversion
; 0000 003A ADCSRA|=0x40;
	SBI  0x6,6
; 0000 003B // Wait for the AD conversion to complete
; 0000 003C while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 003D ADCSRA|=0x10;
	SBI  0x6,4
; 0000 003E return ADCH;
	IN   R30,0x5
	JMP  _0x20C0001
; 0000 003F }
;
;void maju()
; 0000 0042 {
_maju:
; 0000 0043     maju_kanan=1;
	SBI  0x12,7
; 0000 0044     mundur_kanan=0;
	CBI  0x12,6
; 0000 0045     maju_kiri=0;
	RJMP _0x20C0004
; 0000 0046     mundur_kiri=1;
; 0000 0047 
; 0000 0048 }
;void mundur()
; 0000 004A {
_mundur:
; 0000 004B     maju_kanan=0;
	CBI  0x12,7
; 0000 004C     mundur_kanan=1;
	SBI  0x12,6
; 0000 004D     maju_kiri=1;
	RJMP _0x20C0003
; 0000 004E     mundur_kiri=0;
; 0000 004F 
; 0000 0050 }
;
;void belok_kanan()
; 0000 0053 {
_belok_kanan:
; 0000 0054     maju_kanan=0;
	CBI  0x12,7
; 0000 0055     mundur_kanan=1;
	SBI  0x12,6
; 0000 0056     maju_kiri=0;
_0x20C0004:
	CBI  0x12,3
; 0000 0057     mundur_kiri=1;
	SBI  0x12,2
; 0000 0058 }
	RET
;
;void belok_kiri()
; 0000 005B {
_belok_kiri:
; 0000 005C     maju_kanan=1;
	SBI  0x12,7
; 0000 005D     mundur_kanan=0;
	CBI  0x12,6
; 0000 005E     maju_kiri=1;
_0x20C0003:
	SBI  0x12,3
; 0000 005F     mundur_kiri=0;
	CBI  0x12,2
; 0000 0060 }
	RET
;
;
;
;
;void bacasensor()
; 0000 0066          {
_bacasensor:
; 0000 0067 
; 0000 0068 
; 0000 0069 
; 0000 006A          s[0]=read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	STS  _s,R30
; 0000 006B       s[1]=read_adc(1);
	LDI  R26,LOW(1)
	RCALL _read_adc
	__PUTB1MN _s,1
; 0000 006C       s[2]=read_adc(2);
	LDI  R26,LOW(2)
	RCALL _read_adc
	__PUTB1MN _s,2
; 0000 006D       s[3]=read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	__PUTB1MN _s,3
; 0000 006E       s[4]=read_adc(4);
	LDI  R26,LOW(4)
	RCALL _read_adc
	__PUTB1MN _s,4
; 0000 006F       s[5]=read_adc(5);
	LDI  R26,LOW(5)
	RCALL _read_adc
	__PUTB1MN _s,5
; 0000 0070       s[6]=read_adc(6);
	LDI  R26,LOW(6)
	RCALL _read_adc
	__PUTB1MN _s,6
; 0000 0071       s[7]=read_adc(7);
	LDI  R26,LOW(7)
	RCALL _read_adc
	__PUTB1MN _s,7
; 0000 0072       i=0;
	CLR  R8
	CLR  R9
; 0000 0073       while(i<8)
_0x26:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R8,R30
	CPC  R9,R31
	BRLT PC+3
	JMP _0x28
; 0000 0074       {
; 0000 0075       if(s[i]>datagelap[i]) datagelap[i]=s[i];
	CALL SUBOPT_0x0
	LD   R0,X
	LDI  R26,LOW(_datagelap)
	LDI  R27,HIGH(_datagelap)
	ADD  R26,R8
	ADC  R27,R9
	LD   R30,X
	CP   R30,R0
	BRSH _0x29
	MOVW R30,R8
	SUBI R30,LOW(-_datagelap)
	SBCI R31,HIGH(-_datagelap)
	RJMP _0x53
; 0000 0076       else if(s[0]<dataterang[0]) dataterang[i]=s[i];
_0x29:
	LDS  R30,_dataterang
	LDS  R26,_s
	CP   R26,R30
	BRSH _0x2B
	MOVW R30,R8
	SUBI R30,LOW(-_dataterang)
	SBCI R31,HIGH(-_dataterang)
_0x53:
	MOVW R0,R30
	CALL SUBOPT_0x0
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0077 
; 0000 0078       range[i]=((datagelap[i]-dataterang[i])/2)+dataterang[i];
_0x2B:
	MOVW R30,R8
	SUBI R30,LOW(-_range)
	SBCI R31,HIGH(-_range)
	MOVW R22,R30
	LDI  R26,LOW(_datagelap)
	LDI  R27,HIGH(_datagelap)
	ADD  R26,R8
	ADC  R27,R9
	LD   R0,X
	CLR  R1
	LDI  R26,LOW(_dataterang)
	LDI  R27,HIGH(_dataterang)
	ADD  R26,R8
	ADC  R27,R9
	LD   R30,X
	LDI  R31,0
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOV  R0,R30
	LDI  R26,LOW(_dataterang)
	LDI  R27,HIGH(_dataterang)
	ADD  R26,R8
	ADC  R27,R9
	LD   R30,X
	ADD  R30,R0
	MOVW R26,R22
	ST   X,R30
; 0000 0079 
; 0000 007A       if(s[i]<range[i]) hasilbin[i]=0;
	CALL SUBOPT_0x0
	LD   R0,X
	LDI  R26,LOW(_range)
	LDI  R27,HIGH(_range)
	ADD  R26,R8
	ADC  R27,R9
	LD   R30,X
	CP   R0,R30
	BRSH _0x2C
	LDI  R26,LOW(_hasilbin)
	LDI  R27,HIGH(_hasilbin)
	ADD  R26,R8
	ADC  R27,R9
	LDI  R30,LOW(0)
	RJMP _0x54
; 0000 007B       else hasilbin[i]=1;
_0x2C:
	LDI  R26,LOW(_hasilbin)
	LDI  R27,HIGH(_hasilbin)
	ADD  R26,R8
	ADC  R27,R9
	LDI  R30,LOW(1)
_0x54:
	ST   X,R30
; 0000 007C       i++;}
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x26
_0x28:
; 0000 007D 
; 0000 007E       lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 007F       sprintf(tampil,"%d%d%d%d%d%d%d%d",hasilbin[0],hasilbin[1],hasilbin[2],hasilbin[3],hasilbin[3],hasilbin[4],hasilbin[5],hasilbin[6],hasilbin[7]);
	LDI  R30,LOW(_tampil)
	LDI  R31,HIGH(_tampil)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_hasilbin
	CALL SUBOPT_0x1
	__GETB1MN _hasilbin,1
	CALL SUBOPT_0x1
	__GETB1MN _hasilbin,2
	CALL SUBOPT_0x1
	__GETB1MN _hasilbin,3
	CALL SUBOPT_0x1
	__GETB1MN _hasilbin,3
	CALL SUBOPT_0x1
	__GETB1MN _hasilbin,4
	CALL SUBOPT_0x1
	__GETB1MN _hasilbin,5
	CALL SUBOPT_0x1
	__GETB1MN _hasilbin,6
	CALL SUBOPT_0x1
	__GETB1MN _hasilbin,7
	CALL SUBOPT_0x1
	LDI  R24,36
	CALL _sprintf
	ADIW R28,40
; 0000 0080       lcd_puts(tampil);
	LDI  R26,LOW(_tampil)
	LDI  R27,HIGH(_tampil)
	CALL _lcd_puts
; 0000 0081 
; 0000 0082           // untuk mengubah menjadi logic high atau low tinggal
; 0000 0083           // kita buat limitnya
; 0000 0084 
; 0000 0085           }
	RET
;
;void logika()
; 0000 0088 {
_logika:
; 0000 0089         garis=(hasilbin[7]*128)+(hasilbin[6]*64)+(hasilbin[5]*32)+(hasilbin[4]*16)+(hasilbin[3]*8)+(hasilbin[2]*4)+(hasilbin[1]*2)+(hasilbin[0]*1);
	__GETB1MN _hasilbin,7
	LDI  R26,LOW(128)
	MULS R30,R26
	MOV  R22,R0
	__GETB1MN _hasilbin,6
	LDI  R26,LOW(64)
	MULS R30,R26
	MOVW R30,R0
	ADD  R22,R30
	__GETB1MN _hasilbin,5
	LDI  R26,LOW(32)
	MULS R30,R26
	MOVW R30,R0
	ADD  R22,R30
	__GETB1MN _hasilbin,4
	LDI  R26,LOW(16)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R22
	ADD  R26,R30
	__GETB1MN _hasilbin,3
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R26,R30
	__GETB1MN _hasilbin,2
	LSL  R30
	LSL  R30
	ADD  R26,R30
	__GETB1MN _hasilbin,1
	LSL  R30
	ADD  R30,R26
	LDS  R26,_hasilbin
	ADD  R30,R26
	MOV  R7,R30
; 0000 008A }
	RET
;
;
;
;
;
;
;
;
;
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 0099 {
_main:
; 0000 009A // Declare your local variables here
; 0000 009B 
; 0000 009C // Input/Output Ports initialization
; 0000 009D // Port A initialization
; 0000 009E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 009F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A0 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00A1 DDRA=0x00;
	OUT  0x1A,R30
; 0000 00A2 
; 0000 00A3 // Port B initialization
; 0000 00A4 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A5 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A6 PORTB=0x00;
	OUT  0x18,R30
; 0000 00A7 DDRB=0x00;
	OUT  0x17,R30
; 0000 00A8 
; 0000 00A9 // Port C initialization
; 0000 00AA // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00AB // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00AC PORTC=0x00;
	OUT  0x15,R30
; 0000 00AD DDRC=0x00;
	OUT  0x14,R30
; 0000 00AE 
; 0000 00AF // Port D initialization
; 0000 00B0 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00B1 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00B2 PORTD=0x00;
	OUT  0x12,R30
; 0000 00B3 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00B4 
; 0000 00B5 // Timer/Counter 0 initialization
; 0000 00B6 // Clock source: System Clock
; 0000 00B7 // Clock value: Timer 0 Stopped
; 0000 00B8 // Mode: Normal top=0xFF
; 0000 00B9 // OC0 output: Disconnected
; 0000 00BA TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00BB TCNT0=0x00;
	OUT  0x32,R30
; 0000 00BC OCR0=0x00;
	OUT  0x3C,R30
; 0000 00BD 
; 0000 00BE // Timer/Counter 1 initialization
; 0000 00BF // Clock source: System Clock
; 0000 00C0 // Clock value: 10,800 kHz
; 0000 00C1 // Mode: Fast PWM top=0x00FF
; 0000 00C2 // OC1A output: Non-Inv.
; 0000 00C3 // OC1B output: Non-Inv.
; 0000 00C4 // Noise Canceler: Off
; 0000 00C5 // Input Capture on Falling Edge
; 0000 00C6 // Timer1 Overflow Interrupt: Off
; 0000 00C7 // Input Capture Interrupt: Off
; 0000 00C8 // Compare A Match Interrupt: Off
; 0000 00C9 // Compare B Match Interrupt: Off
; 0000 00CA TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 00CB TCCR1B=0x0D;
	LDI  R30,LOW(13)
	OUT  0x2E,R30
; 0000 00CC TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00CD TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00CE ICR1H=0x00;
	OUT  0x27,R30
; 0000 00CF ICR1L=0x00;
	OUT  0x26,R30
; 0000 00D0 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00D1 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00D2 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00D3 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00D4 
; 0000 00D5 // Timer/Counter 2 initialization
; 0000 00D6 // Clock source: System Clock
; 0000 00D7 // Clock value: Timer2 Stopped
; 0000 00D8 // Mode: Normal top=0xFF
; 0000 00D9 // OC2 output: Disconnected
; 0000 00DA ASSR=0x00;
	OUT  0x22,R30
; 0000 00DB TCCR2=0x00;
	OUT  0x25,R30
; 0000 00DC TCNT2=0x00;
	OUT  0x24,R30
; 0000 00DD OCR2=0x00;
	OUT  0x23,R30
; 0000 00DE 
; 0000 00DF // External Interrupt(s) initialization
; 0000 00E0 // INT0: Off
; 0000 00E1 // INT1: Off
; 0000 00E2 // INT2: Off
; 0000 00E3 MCUCR=0x00;
	OUT  0x35,R30
; 0000 00E4 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 00E5 
; 0000 00E6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00E7 TIMSK=0x00;
	OUT  0x39,R30
; 0000 00E8 
; 0000 00E9 // USART initialization
; 0000 00EA // USART disabled
; 0000 00EB UCSRB=0x00;
	OUT  0xA,R30
; 0000 00EC 
; 0000 00ED // Analog Comparator initialization
; 0000 00EE // Analog Comparator: Off
; 0000 00EF // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00F0 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00F1 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00F2 
; 0000 00F3 // ADC initialization
; 0000 00F4 // ADC Clock frequency: 691,200 kHz
; 0000 00F5 // ADC Voltage Reference: AREF pin
; 0000 00F6 // ADC Auto Trigger Source: ADC Stopped
; 0000 00F7 // Only the 8 most significant bits of
; 0000 00F8 // the AD conversion result are used
; 0000 00F9 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 00FA ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 00FB 
; 0000 00FC // SPI initialization
; 0000 00FD // SPI disabled
; 0000 00FE SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00FF 
; 0000 0100 // TWI initialization
; 0000 0101 // TWI disabled
; 0000 0102 TWCR=0x00;
	OUT  0x36,R30
; 0000 0103 
; 0000 0104 // Alphanumeric LCD initialization
; 0000 0105 // Connections are specified in the
; 0000 0106 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0107 // RS - PORTB Bit 0
; 0000 0108 // RD - PORTB Bit 1
; 0000 0109 // EN - PORTB Bit 2
; 0000 010A // D4 - PORTB Bit 4
; 0000 010B // D5 - PORTB Bit 5
; 0000 010C // D6 - PORTB Bit 6
; 0000 010D // D7 - PORTB Bit 7
; 0000 010E // Characters/line: 16
; 0000 010F lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0110 
; 0000 0111 
; 0000 0112 
; 0000 0113 
; 0000 0114 
; 0000 0115 while (1)
_0x2E:
; 0000 0116       {
; 0000 0117 
; 0000 0118             logika();
	RCALL _logika
; 0000 0119 
; 0000 011A             bacasensor();
	RCALL _bacasensor
; 0000 011B 
; 0000 011C             switch(garis)
	MOV  R30,R7
	LDI  R31,0
; 0000 011D             {
; 0000 011E             case 0b01111111:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x34
; 0000 011F             {
; 0000 0120 
; 0000 0121             belok_kanan();
	CALL SUBOPT_0x2
; 0000 0122             kec_kiri=40;
; 0000 0123             kec_kanan=40;}
	RJMP _0x55
; 0000 0124             break;
; 0000 0125 
; 0000 0126             case 0b00111111:
_0x34:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0x35
; 0000 0127             {
; 0000 0128 
; 0000 0129             belok_kanan();
	CALL SUBOPT_0x2
; 0000 012A             kec_kiri=40;
; 0000 012B             kec_kanan=40;}
	RJMP _0x55
; 0000 012C             break;
; 0000 012D 
; 0000 012E             case 0b00011111:
_0x35:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0x36
; 0000 012F             {
; 0000 0130             belok_kanan();
	CALL SUBOPT_0x2
; 0000 0131             kec_kiri=40;
; 0000 0132             kec_kanan=40;}
	RJMP _0x55
; 0000 0133             break;
; 0000 0134 
; 0000 0135             case 0b00001111:
_0x36:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x37
; 0000 0136             {
; 0000 0137             belok_kanan();
	CALL SUBOPT_0x2
; 0000 0138             kec_kiri=40;
; 0000 0139             kec_kanan=40;}
	RJMP _0x55
; 0000 013A             break;
; 0000 013B 
; 0000 013C             case 0b00000111:
_0x37:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x38
; 0000 013D             {posisi=-9;
	LDI  R30,LOW(65527)
	LDI  R31,HIGH(65527)
	MOVW R4,R30
; 0000 013E             belok_kanan();
	CALL SUBOPT_0x2
; 0000 013F             kec_kiri=40;
; 0000 0140             kec_kanan=40;}
	RJMP _0x55
; 0000 0141             break;
; 0000 0142 
; 0000 0143             case 0b00000001:
_0x38:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x39
; 0000 0144             {posisi=-9;
	LDI  R30,LOW(65527)
	LDI  R31,HIGH(65527)
	MOVW R4,R30
; 0000 0145             belok_kanan();
	RCALL _belok_kanan
; 0000 0146             kec_kiri=75;
	CALL SUBOPT_0x3
; 0000 0147             kec_kanan=10;}
	RJMP _0x55
; 0000 0148             break;
; 0000 0149 
; 0000 014A             case 0b00000011:
_0x39:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x3A
; 0000 014B             {posisi=-9;
	CALL SUBOPT_0x4
; 0000 014C             maju();
; 0000 014D             kec_kiri=75;
	CALL SUBOPT_0x3
; 0000 014E             kec_kanan=10;}
	RJMP _0x55
; 0000 014F             break;
; 0000 0150 
; 0000 0151             case 0b00000010:
_0x3A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3B
; 0000 0152             { posisi=-9;
	CALL SUBOPT_0x5
; 0000 0153             kec_kiri=100;
; 0000 0154             kec_kanan=15;}
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	RJMP _0x55
; 0000 0155             break;
; 0000 0156 
; 0000 0157             case 0b00000110:
_0x3B:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x3C
; 0000 0158             {posisi=-9;
	CALL SUBOPT_0x5
; 0000 0159             kec_kiri=100;
; 0000 015A             kec_kanan=30;}
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP _0x55
; 0000 015B             break;
; 0000 015C 
; 0000 015D             case 0b00000100:
_0x3C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3D
; 0000 015E             {posisi=-9;
	CALL SUBOPT_0x4
; 0000 015F             maju();
; 0000 0160             kec_kiri=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0161             kec_kanan=30;}
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP _0x55
; 0000 0162             break;
; 0000 0163 
; 0000 0164             case 0b00001100:
_0x3D:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x3E
; 0000 0165             {posisi=-9;
	CALL SUBOPT_0x4
; 0000 0166             maju();
; 0000 0167             kec_kiri=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP _0x56
; 0000 0168             kec_kanan=50;}
; 0000 0169             break;
; 0000 016A 
; 0000 016B             case 0b00001000:
_0x3E:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x3F
; 0000 016C             {
; 0000 016D             maju();
	RCALL _maju
; 0000 016E             kec_kiri=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 016F             kec_kanan=80;}
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x55
; 0000 0170             break;
; 0000 0171 
; 0000 0172             case 0b00011000:
_0x3F:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x40
; 0000 0173             {maju();
	RCALL _maju
; 0000 0174             kec_kiri=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0175             kec_kanan=20;}
	RJMP _0x55
; 0000 0176             break;  //kondisi tengah
; 0000 0177 
; 0000 0178             case 0b00010000:
_0x40:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x41
; 0000 0179             {
; 0000 017A             maju();
	RCALL _maju
; 0000 017B             kec_kiri=80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x6
; 0000 017C             kec_kanan=100;}
	RJMP _0x55
; 0000 017D             break;
; 0000 017E 
; 0000 017F             case 0b00110000:
_0x41:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x42
; 0000 0180             {
; 0000 0181             maju();
	RCALL _maju
; 0000 0182             kec_kiri=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x6
; 0000 0183             kec_kanan=100;}
	RJMP _0x55
; 0000 0184             break;
; 0000 0185 
; 0000 0186             case 0b00100000:
_0x42:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x43
; 0000 0187             {posisi=9;
	CALL SUBOPT_0x7
; 0000 0188             maju();
; 0000 0189             kec_kiri=40;
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x6
; 0000 018A             kec_kanan=100;}
	RJMP _0x55
; 0000 018B             break;
; 0000 018C 
; 0000 018D             case 0b01100000:
_0x43:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x44
; 0000 018E             {posisi=9;
	CALL SUBOPT_0x7
; 0000 018F             maju();
; 0000 0190             kec_kiri=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x6
; 0000 0191             kec_kanan=100;
	RJMP _0x55
; 0000 0192             }
; 0000 0193             break;
; 0000 0194 
; 0000 0195             case 0b01000000:
_0x44:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x45
; 0000 0196             {posisi=9;
	CALL SUBOPT_0x7
; 0000 0197             maju();
; 0000 0198             kec_kiri=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x6
; 0000 0199             kec_kanan=100;
	RJMP _0x55
; 0000 019A             }
; 0000 019B             break;
; 0000 019C 
; 0000 019D             case 0b11000000:
_0x45:
	CPI  R30,LOW(0xC0)
	LDI  R26,HIGH(0xC0)
	CPC  R31,R26
	BRNE _0x46
; 0000 019E             {posisi=9;
	CALL SUBOPT_0x7
; 0000 019F             maju();
; 0000 01A0             kec_kiri=10;
	CALL SUBOPT_0x8
; 0000 01A1             kec_kanan=75;
	RJMP _0x55
; 0000 01A2             }
; 0000 01A3             break;
; 0000 01A4 
; 0000 01A5             case 0b10000000:
_0x46:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x47
; 0000 01A6             {posisi=9;
	CALL SUBOPT_0x9
; 0000 01A7             belok_kiri();
; 0000 01A8             kec_kiri=10;
	CALL SUBOPT_0x8
; 0000 01A9             kec_kanan=75;
	RJMP _0x55
; 0000 01AA             }
; 0000 01AB             break;
; 0000 01AC 
; 0000 01AD             case 0b11100000:
_0x47:
	CPI  R30,LOW(0xE0)
	LDI  R26,HIGH(0xE0)
	CPC  R31,R26
	BRNE _0x48
; 0000 01AE             {posisi=9;
	CALL SUBOPT_0x9
; 0000 01AF             belok_kiri();
; 0000 01B0             kec_kiri=40;
	CALL SUBOPT_0xA
; 0000 01B1             kec_kanan=40;
	RJMP _0x55
; 0000 01B2             }
; 0000 01B3             break;
; 0000 01B4 
; 0000 01B5             case 0b11110000:
_0x48:
	CPI  R30,LOW(0xF0)
	LDI  R26,HIGH(0xF0)
	CPC  R31,R26
	BRNE _0x49
; 0000 01B6             {posisi=9;
	CALL SUBOPT_0x9
; 0000 01B7             belok_kiri();
; 0000 01B8             kec_kiri=40;
	CALL SUBOPT_0xA
; 0000 01B9             kec_kanan=40;
	RJMP _0x55
; 0000 01BA             }break;
; 0000 01BB 
; 0000 01BC             case 0b11111000:
_0x49:
	CPI  R30,LOW(0xF8)
	LDI  R26,HIGH(0xF8)
	CPC  R31,R26
	BRNE _0x4A
; 0000 01BD             {belok_kiri();
	CALL SUBOPT_0xB
; 0000 01BE             kec_kiri=40;
; 0000 01BF             kec_kanan=40;
	RJMP _0x55
; 0000 01C0             }
; 0000 01C1             break;
; 0000 01C2 
; 0000 01C3             case 0b11111100:
_0x4A:
	CPI  R30,LOW(0xFC)
	LDI  R26,HIGH(0xFC)
	CPC  R31,R26
	BRNE _0x4B
; 0000 01C4             {belok_kiri();
	CALL SUBOPT_0xB
; 0000 01C5             kec_kiri=40;
; 0000 01C6             kec_kanan=40;
	RJMP _0x55
; 0000 01C7             }
; 0000 01C8             break;
; 0000 01C9 
; 0000 01CA             case 0b11111110:
_0x4B:
	CPI  R30,LOW(0xFE)
	LDI  R26,HIGH(0xFE)
	CPC  R31,R26
	BRNE _0x4C
; 0000 01CB             {belok_kiri();
	CALL SUBOPT_0xB
; 0000 01CC             kec_kiri=40;
; 0000 01CD             kec_kanan=40;
	RJMP _0x55
; 0000 01CE             }
; 0000 01CF             break;
; 0000 01D0 
; 0000 01D1             case 0b00000000:
_0x4C:
	SBIW R30,0
	BRNE _0x4D
; 0000 01D2             {if(posisi<0)
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0x4E
; 0000 01D3             {
; 0000 01D4             belok_kanan();
	RCALL _belok_kanan
; 0000 01D5             kec_kiri=40;
	RJMP _0x57
; 0000 01D6             kec_kanan=40;
; 0000 01D7             }
; 0000 01D8             else if(posisi>0)
_0x4E:
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BRGE _0x50
; 0000 01D9             {belok_kiri();
	RCALL _belok_kiri
; 0000 01DA             kec_kiri=40;
_0x57:
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01DB             kec_kanan=40;}
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 01DC 
; 0000 01DD             }
_0x50:
; 0000 01DE             break;
	RJMP _0x33
; 0000 01DF 
; 0000 01E0             case 0b11111111:
_0x4D:
	CPI  R30,LOW(0xFF)
	LDI  R26,HIGH(0xFF)
	CPC  R31,R26
	BRNE _0x33
; 0000 01E1             {
; 0000 01E2             mundur();
	RCALL _mundur
; 0000 01E3             kec_kiri=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
_0x56:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01E4             kec_kanan=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
_0x55:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 01E5             break;}
; 0000 01E6 
; 0000 01E7             }
_0x33:
; 0000 01E8 
; 0000 01E9 
; 0000 01EA 
; 0000 01EB }
	RJMP _0x2E
; 0000 01EC    }
_0x52:
	RJMP _0x52
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G100:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0xC
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0xC
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0xD
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xE
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0xD
	CALL SUBOPT_0xF
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0xD
	CALL SUBOPT_0xF
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0xD
	CALL SUBOPT_0x10
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0xD
	CALL SUBOPT_0x10
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0xC
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0xC
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xE
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0xC
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xE
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x11
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x11
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 7
	SBI  0x18,2
	__DELAY_USB 18
	CBI  0x18,2
	__DELAY_USB 18
	RJMP _0x20C0001
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 184
	RJMP _0x20C0001
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R6,Y+1
	LDD  R13,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	CALL SUBOPT_0x12
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x12
	LDI  R30,LOW(0)
	MOV  R13,R30
	MOV  R6,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040005
	CP   R6,R12
	BRLO _0x2040004
_0x2040005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R13
	MOV  R26,R13
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040007
	RJMP _0x20C0001
_0x2040007:
_0x2040004:
	INC  R6
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x20C0001
_lcd_puts:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2040008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x204000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040008
_0x204000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LDD  R12,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 276
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strlen:
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG
_s:
	.BYTE 0x8
_datagelap:
	.BYTE 0x8
_dataterang:
	.BYTE 0x8
_range:
	.BYTE 0x8
_hasilbin:
	.BYTE 0x8
_tampil:
	.BYTE 0x21
__seed_G101:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	ADD  R26,R8
	ADC  R27,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2:
	CALL _belok_kanan
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	OUT  0x28+1,R31
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	OUT  0x28+1,R31
	OUT  0x28,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(65527)
	LDI  R31,HIGH(65527)
	MOVW R4,R30
	JMP  _maju

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(65527)
	LDI  R31,HIGH(65527)
	MOVW R4,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	OUT  0x28+1,R31
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	OUT  0x28+1,R31
	OUT  0x28,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R4,R30
	JMP  _maju

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	OUT  0x28+1,R31
	OUT  0x28,R30
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R4,R30
	JMP  _belok_kiri

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	OUT  0x28+1,R31
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL _belok_kiri
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G102
	__DELAY_USW 276
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
