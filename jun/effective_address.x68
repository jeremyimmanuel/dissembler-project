* MOVE_EA
    
Destination_Mode
    JSR     Get_Bit8_to_Bit6
    CMP.B   #$0, D6
    BEQ     Print_DnDr
    CMP.B   #$1, D6
    BEQ     Print_AnDr
    CMP.B   #$2, D6
    BEQ     Print_Indr_AnDr
    CMP.B   #$3, D6
    BEQ     Print_Indr_Plus_AnDr
    CMP.B   #$4, D6
    BEQ     Print_Indr_Minus_AnDr
    CMP.B   #$7, D6
    BEQ     Print_MemAddr
    BNE     DISP_ERROR_MESSAGE

Source_Mode
    JSR     Get_Bit5_to_Bit3
    CMP.B   #$0, D6
    BEQ     Print_DnSr
    CMP.B   #$1, D6
    BEQ     Print_AnSr
    CMP.B   #$2, D6
    BEQ     Print_Indr_AnSr
    CMP.B   #$3, D6
    BEQ     Print_Indr_Plus_AnSr
    CMP.B   #$4, D6
    BEQ     Print_Indr_Minus_AnSr
    CMP.B   #$7, D6
    BEQ     Print_MemAddr
    BNE     DISP_ERROR_MESSAGE

Print_DnDr
    JSR     DISP_Str_Data_Reg
    JSR     Find_DR
    RTS
Print_DnSr
    JSR     DISP_Str_Data_Reg
    JSR     Find_SR
    RTS

Print_AnDr
    JSR     DISP_Str_Addr_Reg
    JSR     Find_DR
    RTS
Print_AnSr
    JSR     DISP_Str_Addr_Reg
    JSR     Find_SR
    RTS

Print_Indr_AnDr
    JSR     DISP_Str_Open_Brack_Symbol
    JSR     DISP_Str_Addr_Reg
    JSR     Find_DR
    JSR     DISP_Str_Close_Brack_Symbol
    RTS
Print_Indr_AnSr
    JSR     DISP_Str_Open_Brack_Symbol
    JSR     DISP_Str_Addr_Reg
    JSR     Find_SR
    JSR     DISP_Str_Close_Brack_Symbol
    RTS

Print_Indr_Plus_AnDr
    JSR     DISP_Str_Open_Brack_Symbol
    JSR     DISP_Str_Addr_Reg
    JSR     Find_DR
    JSR     DISP_Str_Close_Brack_Symbol
    JSR     DISP_Str_Plus_Symbol
    RTS
Print_Indr_Plus_AnSr
    JSR     DISP_Str_Open_Brack_Symbol
    JSR     DISP_Str_Addr_Reg
    JSR     Find_SR
    JSR     DISP_Str_Close_Brack_Symbol
    JSR     DISP_Str_Plus_Symbol
    RTS           

Print_Indr_Minus_AnDr
    JSR     DISP_Str_Minus_Symbol
    JSR     DISP_Str_Open_Brack_Symbol
    JSR     DISP_Str_Addr_Reg
    JSR     Find_DR
    JSR     DISP_Str_Close_Brack_Symbol
    RTS
Print_Indr_Minus_AnSr
    JSR     DISP_Str_Minus_Symbol
    JSR     DISP_Str_Open_Brack_Symbol
    JSR     DISP_Str_Addr_Reg
    JSR     Find_SR
    JSR     DISP_Str_Close_Brack_Symbol
    RTS   

Find_DR
    JSR     Get_Bit11_to_Bit9
    JMP     Print_Num

Find_SR
    JSR     Get_Bit2_to_Bit0
    JMP     Print_Num

Print_MemAddr
    JSR     Get_Bit2_to_Bit0
    CMP.B   #$0, D6
    BEQ     Mem_Word
    CMP.B   #$1, D6
    BEQ     Mem_Long
    CMP.B   #$4, D6
    BEQ     Imme_Data

Mem_Word
    JSR     DISP_Str_Hex_Symbol
    JSR     Imme_Data_Word
    RTS
Mem_Long
    JSR     DISP_Str_Hex_Symbol
    JSR     Imme_Data_Long
    RTS

Imme_Data
    JSR     DISP_Str_Hashtag_Symbol
    JSR     DISP_Str_Hex_Symbol
    CMP.B   #$1, D5       * if equal to 3 that mean its Byte because 01 is 1 in hex
    BEQ     Imme_Data_Byte
    CMP.B   #$3, D5       * if equal to 3 that mean its Word because 11 is 3 in hex
    BEQ     Imme_Data_Word
    CMP.B   #$2, D5       * if equal to 3 that mean its Long because 10 is 2 in hex
    BEQ     Imme_Data_Long
Imme_Data_Byte    
    MOVE.W      (A2)+, D5
    MOVE.W      D5, CURR_NIBBLES_MEM_LOC
    JSR         HEX_2_ASCII
    RTS
Imme_Data_Word
    MOVE.W      (A2)+, D5
    MOVE.W      D5, CURR_NIBBLES_MEM_LOC
    JSR         HEX_2_ASCII
    RTS
Imme_Data_Long
    MOVE.L      (A2)+, D5
    MOVE.L      D5, CURR_NIBBLES_MEM_LOC
    JSR         HEX_2_ASCII
    MOVE.W      D5, CURR_NIBBLES_MEM_LOC
    JSR         HEX_2_ASCII
    RTS

Check_Opmode
    JSR Get_Bit8_to_Bit6
    
Print_Num
    CMP.B   #$0, D6
    BEQ     Print_0
    CMP.B   #$1, D6
    BEQ     Print_1
    CMP.B   #$2, D6
    BEQ     Print_2
    CMP.B   #$3, D6
    BEQ     Print_3
    CMP.B   #$4, D6
    BEQ     Print_4
    CMP.B   #$5, D6
    BEQ     Print_5
    CMP.B   #$6, D6
    BEQ     Print_6
    CMP.B   #$7, D6
    BEQ     Print_7

Print_0
    JSR     DISP_STR_0
    RTS
Print_1 
    JSR     DISP_STR_1
    RTS 
Print_2 
    JSR     DISP_STR_2
    RTS 
Print_3 
    JSR     DISP_STR_3
    RTS 
Print_4 
    JSR     DISP_STR_4
    RTS 
Print_5 
    JSR     DISP_STR_5
    RTS 
Print_6 
    JSR     DISP_STR_6
    RTS 
Print_7 
    JSR     DISP_STR_7
    RTS

* Print_MemAddr

* Destination_Reg
*     MOVEM.L D7, -(SP)
*     LSL.W #8, D7
*     LSL.W #2, D7

*     LSR.W #8, D7
*     LSR.W #4, D7
*     MOVE.B D7, D6
*     MOVEM.L (SP)+, D7

* Source_Mode_Mode
*     MOVEM.L D7, -(SP)
*     LSL.W #8, D7
*     LSL.W #2, D7
*     LSR.W #8, D7
*     LSR.W #4, D7
*     MOVE.B D7, D6
*     MOVEM.L (SP)+, D7

* Source_Reg
*     MOVEM.L D7, -(SP)
*     LSL.W #8, D7
*     LSL.W #2, D7
*     LSR.W #8, D7
*     LSR.W #4, D7
*     MOVE.B D7, D6
*     MOVEM.L (SP)+, D7
