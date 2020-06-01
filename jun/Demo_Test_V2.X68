*****************************
*
* Demo_Test.X68
*
* Created 03/08/2020
*
* By Angie, Jeremey, Jun 
*
* Test program for CSS 422 Disassembler Project Demo
*
*****************************

start		EQU	$00009000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

		ORG	start
    OR.B    #$20, D7 * D S
    OR.W    D7, (A4) * S D
    OR.L    $8000, D5* D S
    OR.L    D5, $8000* S D
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

    * Test for Branches 16-bit
    BCC.W     label1


    MOVEM.W   (A1)+,A1-A7
    MOVEM.L   (A1)+,D1-D7
    MOVEM.W   (A1)+,A1/D7
    MOVEM.L   (A1)+,A1/D7
    MOVEM.W   (A1),A1-A7
    MOVEM.L   (A1),D1-D7
    MOVEM.W   (A1),A1/D7
    MOVEM.L   (A1),A1/D7
    MOVEM.W   $12,A1-A7
    MOVEM.L   $12,D1-D7
    MOVEM.W   $12,A1/D7
    MOVEM.L   $12,A1/D7
    MOVEM.W   $1234,A1-A7
    MOVEM.L   $1234,D1-D7
    MOVEM.W   $1234,A1/D7
    MOVEM.L   $1234,A1/D7
    MOVEM.W   $12345678,A1-A7
    MOVEM.L   $12345678,D1-D7
    MOVEM.W   $12345678,A1/D7
    MOVEM.L   $12345678,A1/D7

label1
    RTS
    LEA       $12,A0
    LEA       $1234,A0
    LEA       $12345678,A0

    BCC.W     label0
    move.w    #$9016, d5
    move.w     #$FEE8, d4
    add.b     d4,d5
    
    LSL.B     #$1,D2
    LSL.W     #$2,D2
    LSL.L     #$3,D2
    ASR.B     #$1,D2
    ASR.W     #$2,D2
    ASR.L     #$3,D2
    LSL.W     $12
    LSL.W     $1234
    LSL.W     $12345678
    ASR.W     $12
    ASR.W     $1234
    ASR.W     $12345678
    LSL.B     D1,D2
    LSL.W     D1,D2
    LSL.W     (A1)
    LSL.W     (A1)+
    LSL.W     -(A1)
    LSL.L     D1,D2
    LSR.B     D1,D2 * invalid
    LSR.W     D1,D2 * invalid
    LSR.W     (A1)  * invalid
    LSR.W     (A1)+ * invalid
    LSR.W     -(A1) * invalid
    LSR.L     D1,D2 * invalid   
    ASR.B     D1,D2
    ASR.W     D1,D2
    ASR.W     (A1)
    ASR.W     (A1)+
    ASR.W     -(A1)
    ASR.L     D1,D2
    ASL.B     D1,D2
    ASL.W     D1,D2
    ASL.W     (A1)
    ASL.W     (A1)+
    ASL.W     -(A1)
    ASL.L     D1,D2

    * MOVE.B    #$0023,D0
    * MOVE.W    $8000,D5
    * MOVE.B    D0,D1
    * MOVE.L    #$24422442, D5
    * MOVE.B    #$21, D0
    * LEA       $12121212, A1
    * LEA       (A1), A1
    
    * JSR       (A1)
    * JSR       $7000
    * RTS
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

