*****************************
*
* demo_test.X68
*
* Created 03/08/2017
*
* Test program for CSS 422 Disassembler Project Demo
*
*****************************

start		EQU	$00009000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

		ORG	start

NOP
    * Test for RTS
    RTS
    RTS

    * Test for LEA
    LEA     (A0),A0
    LEA     (A5),A0
    LEA     (A7),A0
    LEA     (A0),A7
    LEA     (A5),A7
    LEA     (A7),A7

    * Test for MOVE
    MOVE.B    D0,D1
    MOVE.B    D0,(A0)
    MOVE.B    D0,(A0)+
    MOVE.B    D0,-(A0)
    MOVE.B    (A0),D0
    MOVE.B    (A0),(A1)
    MOVE.B    (A0),(A1)+
    MOVE.B    (A0),-(A1)
    MOVE.B    (A0)+,D0
    MOVE.B    (A0)+,(A1)
    MOVE.B    (A0)+,(A1)+
    MOVE.B    (A0)+,-(A1)
    MOVE.B    -(A0),D0
    MOVE.B    -(A0),(A1)
    MOVE.B    -(A0),(A1)+
    MOVE.B    -(A0),-(A1)
    MOVE.W    D0,D1
    MOVE.W    D0,(A0)
    MOVE.W    D0,(A0)+
    MOVE.W    D0,-(A0)
    MOVE.W    A0,D0
    MOVE.W    A0,(A1)
    MOVE.W    A0,(A1)+
    MOVE.W    A0,-(A1)
    MOVE.W    (A0),D0
    MOVE.W    (A0),(A1)
    MOVE.W    (A0),(A1)+
    MOVE.W    (A0),-(A1)
    MOVE.W    (A0)+,D0
    MOVE.W    (A0)+,(A1)
    MOVE.W    (A0)+,(A1)+
    MOVE.W    (A0)+,-(A1)
    MOVE.W    -(A0),D0
    MOVE.W    -(A0),(A1)
    MOVE.W    -(A0),(A1)+
    MOVE.W    -(A0),-(A1)
    MOVE.L    D0,D1
    MOVE.L    D0,(A0)
    MOVE.L    D0,(A0)+
    MOVE.L    D0,-(A0)
    MOVE.L    A0,D0
    MOVE.L    A0,(A1)
    MOVE.L    A0,(A1)+
    MOVE.L    A0,-(A1)
    MOVE.L    (A0),D0
    MOVE.L    (A0),(A1)
    MOVE.L    (A0),(A1)+
    MOVE.L    (A0),-(A1)
    MOVE.L    (A0)+,D0
    MOVE.L    (A0)+,(A1)
    MOVE.L    (A0)+,(A1)+
    MOVE.L    (A0)+,-(A1)
    MOVE.L    -(A0),D0
    MOVE.L    -(A0),(A1)
    MOVE.L    -(A0),(A1)+
    MOVE.L    -(A0),-(A1)
    
    * MOVEM.W   A1-A7,-(A1)
    * MOVEM.L   D1-D7,-(A1)
    * MOVEM.W   A1/D7,-(A1)
    * MOVEM.L   A1/D7,-(A1)
    * MOVEM.W   A1-A7,(A1)
    * MOVEM.L   D1-D7,(A1)
    * MOVEM.W   A1/D7,(A1)
    * MOVEM.L   A1/D7,(A1)
    * MOVEM.W   (A1)+,A1-A7
    * MOVEM.L   (A1)+,D1-D7
    * MOVEM.W   (A1)+,A1/D7
    * MOVEM.L   (A1)+,A1/D7
    * MOVEM.W   (A1),A1-A7
    * MOVEM.L   (A1),D1-D7
    * MOVEM.W   (A1),A1/D7
    * MOVEM.L   (A1),A1/D7

    * Test for MOVEA
    MOVEA.W    D0,A0
    MOVEA.W    A0,A0
    MOVEA.W    (A0),A0
    MOVEA.W    (A0)+,A0
    MOVEA.W    -(A0),A0
    MOVEA.L    D0,A0
    MOVEA.L    A0,A0
    MOVEA.L    (A0),A0
    MOVEA.L    (A0)+,A0
    MOVEA.L    -(A0),A0  

    * Test for ADD
    ADD.B     D1,D2
    ADD.B     D1,(A1)
    ADD.B     D1,(A1)+
    ADD.B     D1,-(A1)
    ADD.B     (A1),D1
    ADD.B     (A1)+,D1
    ADD.B     -(A1),D1
    ADD.W     D1,D2
    ADD.W     D1,(A1)
    ADD.W     D1,(A1)+
    ADD.W     D1,-(A1)
    ADD.W     (A1),D1
    ADD.W     (A1)+,D1
    ADD.W     -(A1),D1
    ADD.L     D1,D2
    ADD.L     D1,(A1)
    ADD.L     D1,(A1)+
    ADD.L     D1,-(A1)
    ADD.L     (A1),D1
    ADD.L     (A1)+,D1
    ADD.L     -(A1),D1
    
    * Test for SUB
    SUB.B     D1,D2
    SUB.B     D1,(A1)
    SUB.B     D1,(A1)+
    SUB.B     D1,-(A1)
    SUB.B     (A1),D1
    SUB.B     (A1)+,D1
    SUB.B     -(A1),D1
    SUB.W     D1,D2
    SUB.W     D1,A1
    SUB.W     D1,(A1)
    SUB.W     D1,(A1)+
    SUB.W     D1,-(A1)
    SUB.W     A1,D1
    SUB.W     (A1),D1
    SUB.W     (A1)+,D1
    SUB.W     -(A1),D1
    SUB.L     D1,D2
    SUB.L     D1,A1
    SUB.L     D1,(A1)
    SUB.L     D1,(A1)+
    SUB.L     D1,-(A1)
    SUB.L     A1,D1
    SUB.L     (A1),D1
    SUB.L     (A1)+,D1
    SUB.L     -(A1),D1    

    * Test for AND
    AND.B     D1,D2
    AND.B     D1,(A1)
    AND.B     D1,(A1)+
    AND.B     D1,-(A1)
    AND.B     (A1),D1
    AND.B     (A1)+,D1
    AND.B     -(A1),D1
    AND.W     D1,D2
    AND.W     D1,(A1)
    AND.W     D1,(A1)+
    AND.W     D1,-(A1)
    AND.W     (A1),D1
    AND.W     (A1)+,D1
    AND.W     -(A1),D1
    AND.L     D1,D2
    AND.L     D1,(A1)
    AND.L     D1,(A1)+
    AND.L     D1,-(A1)
    AND.L     (A1),D1
    AND.L     (A1)+,D1
    AND.L     -(A1),D1

    * Test for OR
    OR.B     D1,D2
    OR.B     D1,(A1)
    OR.B     D1,(A1)+
    OR.B     D1,-(A1)
    OR.B     (A1),D1
    OR.B     (A1)+,D1
    OR.B     -(A1),D1
    OR.W     D1,D2
    OR.W     D1,(A1)
    OR.W     D1,(A1)+
    OR.W     D1,-(A1)
    OR.W     (A1),D1
    OR.W     (A1)+,D1
    OR.W     -(A1),D1
    OR.L     D1,D2
    OR.L     D1,(A1)
    OR.L     D1,(A1)+
    OR.L     D1,-(A1)
    OR.L     (A1),D1
    OR.L     (A1)+,D1
    OR.L     -(A1),D1

    * Test for LSL
    LSL.B     D1,D2
    LSL.W     D1,D2
    LSL.W     (A1)
    LSL.W     (A1)+
    LSL.W     -(A1)
    LSL.L     D1,D2
    
    * Test for ARS
    ASR.B     D1,D2
    ASR.W     D1,D2
    ASR.W     (A1)
    ASR.W     (A1)+
    ASR.W     -(A1)
    ASR.L     D1,D2
    
    * Test for CMP
    CMP.B    D0,D1
    CMP.B    (A0),D1
    CMP.B    -(A0),D1
    CMP.B    (A0)+,D1
    CMP.W    D0,D1
    CMP.W    A0,D1
    CMP.W    (A0),D1
    CMP.W    -(A0),D1
    CMP.W    (A0)+,D1
    CMP.L    D0,D1
    CMP.L    A0,D1
    CMP.L    (A0),D1
    CMP.L    -(A0),D1
    CMP.L    (A0)+,D1

    * Test for Branches 8-bit
    BCC.B     label1
    BCC.B     label2
    BGT.B     label1
    BGT.B     label2
    BLE.B     label1
    BLE.B     label2

    * Test for Branches 16-bit
    BCC.W     label1
    BCC.W     label2
    BCC.W     label3
    BGT.W     label1
    BGT.W     label2
    BGT.W     label3
    BLE.W     label1
    BLE.W     label2
    BLE.W     label3

    * Test for JSR
    JSR       (A0)
    JSR       $1234
    JSR       $12345678
    JSR       label1
    JSR       label2
    JSR       label3
    RTS

label1
    RTS
    LEA       $12,A0
    LEA       $1234,A0
    LEA       $12345678,A0

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
