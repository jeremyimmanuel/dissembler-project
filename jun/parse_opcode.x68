*-----------------------------------------------------------
* Title      : parse_opcode.x68
* Written by : Jeremy Tandjung, Angie Tserenjav, Jun Zhen
* Date       : 05/16/2020
* Description: 
*-----------------------------------------------------------

* Read one word from memory at a time and store it in D7.
* D7 is gonna be the primary storage for data(opcode) retrieved from memory.

* D5 is gonan be the size like .B, .W, .L
Loop
    CMPA.L  A3, A2
    BGE     Prompt_Exit_or_Restart

Parse_Start
    BSR     Check_Full_Screen
    JSR     DISP_ADDR_LOC
    MOVE.W  (A2)+, D7   *Testing for MOVE
    * JSR DISP_Current_Addr
    JSR     Search_Opcode
    JMP     Loop

Search_Opcode
    * Get the first nibble
    CMP.L   #$4E75,D7    * RTS
    BEQ     Print_RTS
    MOVEM.L D7, -(SP)
    LSR.W   #8, D7
    LSR.W   #4, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    CMP.B   #$1, D6
    BEQ     Bit_Equal_0000 * MOVE, MOVEA
    CMP.B   #$2, D6
    BEQ     Bit_Equal_0000 * MOVE, MOVEA
    CMP.B   #$3, D6
    BEQ     Bit_Equal_0000 * MOVE, MOVEA
    CMP.B   #$4,D6  
    BEQ     Bit_Equal_0100 * MOVEM, LEA, JSR, RTS
    CMP.B   #$6,D6  
    BEQ     Bit_Equal_0110 * BCC, BGT, BLE
    CMP.B   #$8,D6  
    BEQ     Bit_Equal_1000 * OR
    CMP.B   #$9,D6  
    BEQ     Bit_Equal_1001 * SUB
    CMP.B   #$B,D6  
    BEQ     Bit_Equal_1011 * CMP
    CMP.B   #$C,D6  
    BEQ     Bit_Equal_1100 * AND
    CMP.B   #$D,D6  
    BEQ     Bit_Equal_1101 * ADD
    CMP.B   #$E,D6  
    BEQ     Bit_Equal_1110 * LSLm, LSLr, ASRm,ASRr
    BNE     Print_Error

Bit_Equal_0000          * two bit is 00~~, the opcode is either MOVE or MOVEA
    JSR     Get_Bit8_to_Bit6
    CMP.B   #$1, D6       * if the destination mode is 1 then it is MOVEA
    BEQ     Print_MOVEA
    BNE     Print_MOVE

Bit_Equal_0100            * nibble is 0100, the opcode is either MOVEM, LEA, or JSR
    JSR     Get_Bit11_to_Bit6
    CMP.W   #$3A, D6
    BEQ     Print_JSR
    JSR     Get_Bit8_to_Bit6
    CMP.B   #$7, D6
    BEQ     Print_LEA
    JSR     Get_Bit15_to_Bit8
    CMP.B   #$4C, D6
    BEQ     Print_MOVEM
    CMP.B   #$48, D6
    BEQ     Confirm_Movem
    BNE     Print_Error

Confirm_Movem
    JSR     Get_Bit5_to_Bit3
    CMP.B   #$0, D6
    BEQ     Print_Error
    BNE     Print_MOVEM

Bit_Equal_0110            * nibble is 0110, the opcode is either BCC, BGT, or BLE
    MOVEM.L D7, -(SP)
    LSL.W   #4, D7
    LSR.W   #8, D7
    LSR.W   #4, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    CMP.B   #$4, D6
    BEQ     Print_BCC
    CMP.B   #$E, D6
    BEQ     Print_BGT
    CMP.B   #$F, D6
    BEQ     Print_BLE

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
    JSR     Get_Bit11_to_Bit6
    CMP.B   #$0F,D6
    BEQ     Print_LSLm
    CMP.B   #$03,D6
    BEQ     Print_ASRm
    CMP.B   #$0B,D6
    BEQ     Print_Error
    CMP.B   #$07,D6
    BEQ     Print_Error
    JSR     Get_Bit4_to_Bit3
    CMP.B   #$1, D6
    BEQ     Check_Left_Only
    CMP.B   #$0, D6
    BEQ     Check_Right_Only
    BNE     Print_Error

Check_Left_Only
    JSR     Get_Bit8
    CMP.B   #$1, D6
    BEQ     Print_LSLr
    BNE     Print_Error

Check_Right_Only
    JSR     Get_Bit8
    CMP.B   #$0, D6
    BEQ     Print_ASRr
    BNE     Print_Error

Get_Size_For_Move_Movea   * Now check the size (bit-13 to bit-12)
    MOVEM.L D7, -(SP) 
    LSL.W   #2, D7
    LSR.W   #8, D7
    LSR.W   #6, D7
    MOVE.B  D7, D5
    MOVEM.L (SP)+, D7 
    CMP.B   #$1, D5       * if equal to 3 that mean its Byte because 01 is 1 in hex
    BEQ     Print_Size_Byte
    CMP.B   #$3, D5       * if equal to 3 that mean its Word because 11 is 3 in hex
    BEQ     Print_Size_Word
    CMP.B   #$2, D5       * if equal to 3 that mean its Long because 10 is 2 in hex
    BEQ     Print_Size_Long
    BNE     Print_Error

Get_Size_For_OR_SUB_CMP_AND_ADD  * Now check the size (bit-13 to bit-12)
    JSR     Get_Bit8_to_Bit6
    CMP.B   #$0, D6
    BEQ     Print_Size_Byte
    CMP.B   #$1, D6
    BEQ     Print_Size_Word
    CMP.B   #$2, D6
    BEQ     Print_Size_Long
    CMP.B   #$4, D6
    BEQ     Print_Size_Byte
    CMP.B   #$5, D6
    BEQ     Print_Size_Word
    CMP.B   #$6, D6
    BEQ     Print_Size_Long
    BNE     Print_Error

Get_Size_For_LSL_ASR
    JSR     Get_Bit7_to_Bit6
    CMP.B   #$0, D6
    BEQ     Print_Size_Byte
    CMP.B   #$1, D6
    BEQ     Print_Size_Word
    CMP.B   #$2, D6
    BEQ     Print_Size_Long
    BNE     Print_Error

Get_Size_For_MOVEM
    JSR     Get_Bit6
    CMP.B   #$0, D6
    BEQ     Print_Size_Word
    CMP.B   #$1, D6
    BEQ     Print_Size_Long
    BNE     Print_Error

Print_MOVE
    JSR     DISP_STR_MOVE
    JSR     Get_Size_For_Move_Movea
    JSR     Source_Mode
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     Destination_Mode
    JSR     DISP_NEW_LINE
    RTS
Print_MOVEA
    JSR     DISP_STR_MOVEA
    JSR     Get_Size_For_Move_Movea
    JSR     Source_Mode
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     Destination_Mode
    JSR     DISP_NEW_LINE
    RTS
Print_MOVEM
    JSR     DISP_STR_MOVEM
    JSR     Get_Size_For_MOVEM
    JSR     Transfer_Direction
    JSR     DISP_NEW_LINE
    RTS
Print_LEA
    JSR     DISP_STR_LEA
    JSR     DISP_STR_SPACE
    JSR     Source_Mode
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     Print_AnDr
    JSR     DISP_NEW_LINE
    RTS
Print_JSR
    JSR     DISP_STR_JSR
    JSR     DISP_STR_SPACE
    JSR     Source_Mode
    JSR     DISP_NEW_LINE
    RTS
Print_RTS
    JSR     DISP_STR_RTS
    JSR     DISP_NEW_LINE
    RTS
Print_BCC
    JSR     DISP_STR_BCC
    JSR     Get_Bit7_to_Bit0
    JSR     Check_Displacement
    JSR     DISP_NEW_LINE
    RTS    
Print_BGT
    JSR     DISP_STR_BGT
    JSR     Get_Bit7_to_Bit0
    JSR     Check_Displacement
    JSR     DISP_NEW_LINE
    RTS
Print_BLE
    JSR     DISP_STR_BLE
    JSR     Get_Bit7_to_Bit0
    JSR     Check_Displacement
    JSR     DISP_NEW_LINE
    RTS
Print_OR
    JSR     DISP_STR_OR
    JSR     Get_Size_For_OR_SUB_CMP_AND_ADD
    JSR     DISP_STR_SPACE
    JSR     Check_Opmode
    JSR     DISP_NEW_LINE
    RTS
Print_SUB
    JSR     DISP_STR_SUB
    JSR     Get_Size_For_OR_SUB_CMP_AND_ADD
    JSR     DISP_STR_SPACE
    JSR     Check_Opmode
    JSR     DISP_NEW_LINE
    RTS
Print_CMP
    JSR     DISP_STR_CMP
    JSR     Get_Size_For_OR_SUB_CMP_AND_ADD
    JSR     DISP_STR_SPACE
    JSR     Check_Opmode
    JSR     DISP_NEW_LINE
    RTS
Print_AND
    JSR     DISP_STR_AND
    JSR     Get_Size_For_OR_SUB_CMP_AND_ADD
    JSR     DISP_STR_SPACE
    JSR     Check_Opmode
    JSR     DISP_NEW_LINE
    RTS
Print_ADD
    JSR     DISP_STR_ADD
    JSR     Get_Size_For_OR_SUB_CMP_AND_ADD
    JSR     DISP_STR_SPACE
    JSR     Check_Opmode
    JSR     DISP_NEW_LINE
    RTS    
Print_LSLm
    JSR     DISP_STR_LSL
    JSR     Print_Size_Word
    JSR     Source_Mode
    JSR     DISP_NEW_LINE
    RTS
Print_LSLr
    JSR     DISP_STR_LSL
    JSR     Get_Size_For_LSL_ASR
    JSR     Check_Count_Or_Register
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     Print_DnSr
    JSR     DISP_NEW_LINE
    RTS
Print_ASRm
    JSR     DISP_STR_ASR
    JSR     Print_Size_Word
    JSR     Source_Mode
    JSR     DISP_NEW_LINE
    RTS        
Print_ASRr
    JSR     DISP_STR_ASR
    JSR     Get_Size_For_LSL_ASR
    JSR     Check_Count_Or_Register
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     Print_DnSr
    JSR     DISP_NEW_LINE
    RTS
Print_Error
    JSR     DISP_ERROR_MESSAGE
    JSR     DISP_NEW_LINE
    RTS
Print_Size_Byte
    JSR     DISP_STR_BYTE
    RTS
Print_Size_Word
    JSR     DISP_STR_WORD
    RTS
Print_Size_Long
    JSR     DISP_STR_LONG
    RTS

Get_Bit4_to_Bit3 
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSL.W   #3, D7
    LSR.W   #8, D7
    LSR.W   #6, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS

Get_Bit5_to_Bit3
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSL.W   #2, D7
    LSR.W   #8, D7
    LSR.W   #5, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS

Get_Bit2_to_Bit0 * source register
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSL.W   #5, D7
    LSR.W   #8, D7
    LSR.W   #5, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS

Get_Bit8_to_Bit6 * destination mode
    MOVEM.L D7, -(SP)
    LSL.W   #7, D7
    LSR.W   #8, D7
    LSR.W   #5, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
    
Get_Bit11_to_Bit9 * destination register
    MOVEM.L D7, -(SP)
    LSL.W   #4, D7
    LSR.W   #8, D7
    LSR.W   #5, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS

Get_Bit7_to_Bit0 
    CLR.W   D6
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSR.W   #8, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS    

Get_Bit11_to_Bit6
    MOVEM.L D7, -(SP)
    LSL.W   #4, D7
    LSR.W   #8, D7
    LSR.W   #2, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit15_to_Bit8
    MOVEM.L D7, -(SP)
    LSR.W   #8, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS    
Get_Bit7_to_Bit6
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSR.W   #8, D7
    LSR.W   #6, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS    

Get_Bit0
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSL.W   #7, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit1
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSL.W   #6, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit2
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSL.W   #5, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit3
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSL.W   #4, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit4
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSL.W   #3, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit5
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSL.W   #2, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit6
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSL.W   #1, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit7
    MOVEM.L D7, -(SP)
    LSL.W   #8, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit8    
    MOVEM.L D7, -(SP)
    LSL.W   #7, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit9
    MOVEM.L D7, -(SP)
    LSL.W   #6, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit10
    MOVEM.L D7, -(SP)
    LSL.W   #5, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit11
    MOVEM.L D7, -(SP)
    LSL.W   #4, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit12
    MOVEM.L D7, -(SP)
    LSL.W   #3, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit13
    MOVEM.L D7, -(SP)
    LSL.W   #2, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit14
    MOVEM.L D7, -(SP)
    LSL.W   #1, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS
Get_Bit15
    MOVEM.L D7, -(SP)
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    RTS