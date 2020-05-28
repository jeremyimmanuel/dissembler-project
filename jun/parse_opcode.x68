* Read one word from memory at a time and store it in D7.
* D7 is gonna be the primary storage for data(opcode) retrieved from memory.
* 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
* [0][0][0][0][0][0][0][0][0][0][0][0][0][0][0][0]
Parse_Start
    * MOVE.W #$3E3C, D7   *Testing for MOVE
    * MOVE.W #$327C, D7   *Testing for MOVEA
    * MOVE.W #$4E92, D7   *Testing for JSR
    * MOVE.W #$41D0, D7   *Testing for LEA
    * MOVE.W #$48A1, D7   *Testing for MOVEM
    MOVE.W #$8401, D7   *Testing for OR
    * MOVE.W #$9249, D7   *Testing for SUB
    * MOVE.W #$D401, D7   *Testing for ADD
    * MOVE.W #$B200, D7   *Testing for CMP
    * MOVE.W #$C338, D7   *Testing for AND
    
    CMP.L #$4E75,D7
    BEQ DISP_STR_RTS
    
    * Check Bit-15
    MOVEM.L D7, -(SP)
    LSR.W #8, D7
    LSR.W #6, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    CMP.B #$00,D6        * If Bit-15 == 1 RTS to OR/SUB....
    BEQ Bit_Equal_00  * If Bit-15 == 0 JRS to MOVE/MOVEA....
    CMP.B #$01,D6
    BEQ Bit_Equal_01
    CMP.B #$10,D6
    BEQ Bit_Equal_10
    CMP.B #$11,D6
    BEQ Bit_Equal_11

Bit_Equal_00          * Since first two bit is 00, the opcode is either MOVE or MOVEA
    MOVEM.L D7, -(SP) 
    LSL.W #7, D7
    LSR.W #8, D7
    LSR.W #5, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    CMP.B #$1, D6
    BEQ Print_MOVEA
    BNE Print_MOVE

Bit_Equal_01            
    MOVEM.L D7, -(SP)
    LSL.W #2, D7
    LSR.W #8, D7
    LSR.W #7, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    CMP.B #$0,D6
    BEQ Bit_Equal_0100
    CMP.B #$1,D6
    BEQ Bit_Equal_0110

Bit_Equal_10            
    MOVEM.L D7, -(SP)
    LSL.W #2, D7
    LSR.W #8, D7
    LSR.W #6, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    CMP.B #$0, D6 
    BEQ Print_OR

Bit_Equal_11            
    MOVEM.L D7, -(SP)
    LSL.W #2, D7
    LSR.W #8, D7
    LSR.W #7, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7

Bit_Equal_0100            * Since first two bit is 0100, the opcode is either MOVEM, LEA, or JSR
    MOVEM.L D7, -(SP)
    LSL.W #4, D7
    LSR.W #8, D7
    LSR.W #2, D7
    MOVE.W D7, D6
    MOVEM.L (SP)+, D7
    CMP.W #$3A, D6
    BEQ Print_JSR
    MOVEM.L D7, -(SP)
    LSL.W #7, D7
    LSR.W #8, D7
    LSR.W #5, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    CMP.B #$7, D6
    BEQ Print_LEA
    BNE Print_MOVEM
    

Bit_Equal_0110            * Since first two bit is 011, the opcode is either BCC, BGT, or BLE
    MOVEM.L D7, -(SP)
    LSL.W #2, D7
    LSR.W #8, D7
    LSR.W #7, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7

Get_Size_For_Move_Movea   * Now check the size (bit-13 to bit-12)
    MOVEM.L D7, -(SP) 
    LSL.W #2, D7
    LSR.W #8, D7
    LSR.W #6, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7 
    CMP.B #$3, D6       * if equal to 3 that mean its word because 11 is 3 in hex
    BEQ Print_Size_Byte
    RTS

Print_Size_Byte
    JSR DISP_STR_BYTE
    RTS
Print_Size_Word
    JSR DISP_STR_WORD
    RTS
Print_Size_Long
    JSR DISP_STR_LONG
    RTS

Print_MOVE
    JSR DISP_STR_MOVE
    JMP Get_Size_For_Move_Movea
Print_MOVEA
    JSR DISP_STR_MOVEA
    JMP Get_Size_For_Move_Movea

Print_JSR
    JSR DISP_STR_JSR
    JMP EXIT
Print_LEA
    JSR DISP_STR_LEA
    JMP EXIT
Print_MOVEM
    JSR DISP_STR_MOVEM
    JMP EXIT

Print_OR
    JSR DISP_STR_OR
    JMP EXIT
Print_SUB
    JSR DISP_STR_SUB
    JMP EXIT
Print_CMP
    JSR DISP_STR_CMP
    JMP EXIT
Print_AND
    JSR DISP_STR_AND
    JMP EXIT
Print_ADD
    JSR DISP_STR_ADD
    JMP EXIT
