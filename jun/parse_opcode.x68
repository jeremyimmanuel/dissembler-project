* Read one word from memory at a time and store it in D7.
* D7 is gonna be the primary storage for data(opcode) retrieved from memory.
Parse_Start
    MOVE.W #$3E3C, D7   *Testing for MOVE
    JSR Search_Opcode
    MOVE.W #$327C, D7   *Testing for MOVEA
    JSR Search_Opcode
    MOVE.W #$48A1, D7   *Testing for MOVEM
    JSR Search_Opcode
    MOVE.W #$41D0, D7   *Testing for LEA
    JSR Search_Opcode
    MOVE.W #$4E92, D7   *Testing for JSR
    JSR Search_Opcode
    MOVE.W #$4E75, D7   *Testing for RTS
    JSR Search_Opcode
    MOVE.W #$6450, D7   *Testing for BCC
    JSR Search_Opcode
    MOVE.W #$6E00, D7   *Testing for BGT
    JSR Search_Opcode
    MOVE.W #$6F00, D7   *Testing for BLE
    JSR Search_Opcode
    MOVE.W #$8401, D7   *Testing for OR
    JSR Search_Opcode
    MOVE.W #$9249, D7   *Testing for SUB
    JSR Search_Opcode
    MOVE.W #$B200, D7   *Testing for CMP
    JSR Search_Opcode
    MOVE.W #$C338, D7   *Testing for AND
    JSR Search_Opcode
    MOVE.W #$D401, D7   *Testing for ADD
    JSR Search_Opcode
    MOVE.W #$E3F8, D7   *Testing for LSLm
    JSR Search_Opcode
    MOVE.W #$E54A, D7   *Testing for LSLr
    JSR Search_Opcode
    MOVE.W #$E0F8, D7   *Testing for ASRm
    JSR Search_Opcode
    MOVE.W #$E442, D7   *Testing for ASRr
    JSR Search_Opcode
    
    JMP EXIT

Search_Opcode
    * Get the first nibble
    CMP.L #$4E75,D7    * for RTS
    BEQ Print_RTS
    MOVEM.L D7, -(SP)
    LSR.W #8, D7
    LSR.W #4, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    CMP.B #$3, D6
    BLE Bit_Equal_0000 * MOVE, MOVEA
    CMP.B #$4,D6  
    BEQ Bit_Equal_0100 * MOVEM, LEA, JSR, RTS
    CMP.B #$6,D6  
    BEQ Bit_Equal_0110 * BCC, BGT, BLE
    CMP.B #$8,D6  
    BEQ Bit_Equal_1000 * OR
    CMP.B #$9,D6  
    BEQ Bit_Equal_1001 * SUB
    CMP.B #$B,D6  
    BEQ Bit_Equal_1011 * CMP
    CMP.B #$C,D6  
    BEQ Bit_Equal_1100 * AND
    CMP.B #$D,D6  
    BEQ Bit_Equal_1101 * ADD
    CMP.B #$E,D6  
    BEQ Bit_Equal_1110 * LSLm, LSLr, ASRm,ASRr

Bit_Equal_0000          * two bit is 00~~, the opcode is either MOVE or MOVEA
    MOVEM.L D7, -(SP) 
    LSL.W #7, D7
    LSR.W #8, D7
    LSR.W #5, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    CMP.B #$1, D6
    BEQ Print_MOVEA
    BNE Print_MOVE

Bit_Equal_0100            * nibble is 0100, the opcode is either MOVEM, LEA, or JSR
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

Bit_Equal_0110            * nibble is 0110, the opcode is either BCC, BGT, or BLE
    MOVEM.L D7, -(SP)
    LSL.W #4, D7
    LSR.W #8, D7
    LSR.W #4, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    CMP.B #$4, D6
    BEQ Print_BCC
    CMP.B #$E, D6
    BEQ Print_BGT
    CMP.B #$F, D6
    BEQ Print_BLE


Bit_Equal_1000            * nibble is 1000, the opcode is OR
    BRA Print_OR

Bit_Equal_1001            * nibble is 1001, the opcode is SUB
    BRA Print_SUB

Bit_Equal_1011            * nibble is 1011, the opcode is CMP
    BRA Print_CMP

Bit_Equal_1100            * nibble is 1100, the opcode is AND
    BRA Print_AND

Bit_Equal_1101            * nibble is 1101, the opcode is ADD
    BRA Print_ADD

Bit_Equal_1110            * nibble is 1110, the opcode is either LSLm, LSLr, ASRm, or ASRr
    MOVEM.L D7, -(SP) 
    LSL.W #7, D7
    LSR.W #8, D7
    LSR.W #5, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7 
    CMP.B #$7,D6
    BEQ Print_LSLm
    CMP.B #$3,D6
    BEQ Print_ASRm
    CMP.B #$4,D6
    BGE Print_LSLr
    CMP.B #$2,D6
    BLE Print_ASRr

Get_Size_For_Move_Movea   * Now check the size (bit-13 to bit-12)
    MOVEM.L D7, -(SP) 
    LSL.W #2, D7
    LSR.W #8, D7
    LSR.W #6, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7 
    CMP.B #$3, D6       * if equal to 3 that mean its word because 11 is 3 in hex
    BEQ Print_Size_Byte

Print_Size_Byte
    JSR DISP_STR_BYTE
    JSR DISP_NEW_LINE
    RTS
Print_Size_Word
    JSR DISP_STR_WORD
    JSR DISP_NEW_LINE
    RTS
Print_Size_Long
    JSR DISP_STR_LONG
    JSR DISP_NEW_LINE
    RTS

Print_MOVE
    JSR DISP_STR_MOVE
    JMP Get_Size_For_Move_Movea
Print_MOVEA
    JSR DISP_STR_MOVEA
    JMP Get_Size_For_Move_Movea

Print_MOVEM
    JSR DISP_STR_MOVEM
    JSR DISP_NEW_LINE
    RTS
Print_LEA
    JSR DISP_STR_LEA
    JSR DISP_NEW_LINE
    RTS
Print_JSR
    JSR DISP_STR_JSR
    JSR DISP_NEW_LINE
    RTS
Print_RTS
    JSR DISP_STR_RTS
    JSR DISP_NEW_LINE
    RTS

Print_BCC
    JSR DISP_STR_BCC
    JSR DISP_NEW_LINE
    RTS    
Print_BGT
    JSR DISP_STR_BGT
    JSR DISP_NEW_LINE
    RTS
Print_BLE
    JSR DISP_STR_BLE
    JSR DISP_NEW_LINE
    RTS

Print_OR
    JSR DISP_STR_OR
    JSR DISP_NEW_LINE
    RTS
Print_SUB
    JSR DISP_STR_SUB
    JSR DISP_NEW_LINE
    RTS
Print_CMP
    JSR DISP_STR_CMP
    JSR DISP_NEW_LINE
    RTS
Print_AND
    JSR DISP_STR_AND
    JSR DISP_NEW_LINE
    RTS
Print_ADD
    JSR DISP_STR_ADD
    JSR DISP_NEW_LINE
    RTS    
Print_LSLm
    JSR DISP_STR_LSLm
    JSR DISP_NEW_LINE
    RTS
Print_LSLr
    JSR DISP_STR_LSLr
    JSR DISP_NEW_LINE
    RTS
Print_ASRm
    JSR DISP_STR_ASRm
    JSR DISP_NEW_LINE
    RTS        
Print_ASRr
    JSR DISP_STR_ASRr
    JSR DISP_NEW_LINE
    RTS