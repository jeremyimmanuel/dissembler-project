    ORG    $9000
    MOVE.l A2,D2 ; $2411 (0011 010 000 010 001)
    MOVE.l D2,A2
    
        
    MOVE.L      $AAAAAAAA, $55555555 
    ADDI.B      #$42,D2  
    ADDI.L      #$24422442,D3
    ADDI.W      #$2442,D4
     
    
    ADD.B       D0,D1
    ADD.W       D1,D0
    ADD.L       $00001234,D1
    ADD         D1,$00001234
    ADD.L       $FFFF1234,D1
    ADD.B       D2, $FFFF1234
    ADD.B        #1,D5
    ADD.W        #10,D6
    ADDA        #5,A1
    ADDA.W      $0001234,A2
    ADDA.L      $FFFF1234,A0
    MOVE.L      $AAAAAAAA, $55555555
    ADDI        #10,D4
    SUBI        #10,D4
    CMPI        #3,D3
    ANDI        #4,D6
    ORI.L       #4090900909,D5
    MOVE.L      #4090900909,D5
    OR.L        #4090900909,D5
    EORI.L      #4090900909,D5

    LEA         $3333+24,A4
    LEA         $FFFFFFF,A5
    
    ASL.B       D1,D2
    ASL.W       D1,D2
    ASL.L       D3,D4
    ASL.B       #8,D5
    ASL.W       #4,D6
    ASL.L       #1,D1  
    
    ASL         $00001234
    ASL         $FFFF1123
    ASR         $00001234
    ASR         $FFFF1123
    ASR         (A1)+
    ASR         -(A2) 

    BRA $A060
    BEQ $9F42
    BLT $A000
    BLE $8002
    BGE $9E34
    BGT $3000
    BHI $7865
    BLS $5767
    BCC $6887
    BCS $7659
    BNE $6589
    BEQ $7688
    BVC $8767
    BVS $6756
    BPL $9999
    BPL $A876
    BGE $6798
    BGT $9987
    BLE $CCCC   
    
  
    NOP *NEW
    RTS
    JSR         (A2)
    JSR         $00123658
    LEA         $00001234, A5
    LEA         (A4),A5
    OR          D1,D2
    OR          D1, $00001234
    OR          D2, (A1)
    OR          (A1),D3
    OR          D1, (A2)+
    OR          -(A2),D3
    OR          D3, 0(A3,D5) * One known bug, the data is interpretted as ADDQ
    OR          D3, 0(A3,D5)
    SUB.B       D5,D4
    SUB.W       D5,D4
    SUB.L       D5,D4
    SUB.L       D1,$00001234
    SUB.L       $00001234,D1
    SUB.L       D1, $FFFF1234
    SUB.L       $FFFF1234,D1
    SUB         (A0),D3
    SUB         D1, (A1)
    SUB         -(A1),D3
    SUB         D4, 0(A3,D5) * One known bug, data is interpretted as ADDQ
    SUB         D4, 0(A3,D5) * P.S: Not a bug, a feature    
    MULS        #45,D1
    MULS        $00001234,D7
    MULS        $FFFF1000, D2  
*DIVU
    
    SIMHALT
    EOR.B #5,D2
    
    MOVEM D1/D4-D5/D7/A0/A2/A5-A6,-(SP)
    MOVEM (SP)+,D1/D4-D5/D7/A0/A2/A5-A6
    MOVEM D0-D7/A0-A7,-(SP)
    MOVEM (SP)+,D0-D7/A0-A7
    
    MOVEM $4032,A0-A4/A6
    MOVEM D1-D4,($56C4)
    
    MOVEM ($A000),D0
    MOVEM D0,($A000)

    DIVU        #45,D1
    DIVU        $00001234,D7
    DIVU        $FFFF1000, D2    
    NOT         D2 *NEW
    ROL         $00001234
    ROL         $FFFF1123
    ROR         $00001234
    ROR         $FFFF1123
    ROR         (A1)+
    ROR         -(A2)    
    ROL.B       D1,D2
    ROL.W       D1,D2
    ROL.L       D3,D4
    ROL.B       #8,D5
    ROL.W       #4,D6
    ROL.L       #1,D1     
    LSL         $00001234
    LSL         $FFFF1123
    LSR         $00001234
    LSR         $FFFF1123
    LSR         (A1)+
    LSR         -(A2)    
    LSL.B       D1,D2
    LSL.W       D1,D2
    LSL.L       D3,D4
    LSL.B       #8,D5
    LSL.W       #4,D6
    LSL.L       #1,D1  

    MOVE        D1,$00001234
    MOVE.L      $00001234,D0
    MOVE.W      D1, $00001234
    MOVE.B      $FFFF1234,D5
    MOVE.B      (A1),$000012134
    MOVE.W      -(A2),$FFFF1234
    MOVE.L      (A1)+, D5
    MOVE.W      A2,D3
    MOVE.W      #123, D5
    MOVE.B      #12,D6
    MOVE.L      #14,D5
    MOVE.L      #20, D7
    MOVEA.W     $00001234,A1
    MOVEA.L     $FFFF1234,A2
    MOVEA.W     (A2),A1
    MOVEA.L     (A2)+,A3
    MOVEA.W     -(A3),A3
    MOVEA.W     -(SP),A3
    MOVEA.W     -(A7),A4

    NOT         D2
    *   JUST NOW IMPLEMENTED
    ADDQ.B       #8,D1
    ADDQ.W       #08,A1
    ADDQ.L       #00000008,D1
    ADDQ         #1,D1
    NOP
    
    SIMHALT             ; halt simulator
TEST
    MOVE.W      #0,D1
    RTS  
NO_TEST
    MOVE.W     #4,D2
    RTS