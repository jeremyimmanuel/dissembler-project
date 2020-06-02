*-----------------------------------------------------------
* Title      : effective_address.68
* Written by : Jeremy Tandjung, Angie Tserenjav, Jun Zhen
* Date       : 05/16/2020
* Description: 
*-----------------------------------------------------------
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
    MOVEM.L D7, -(SP)
    LSL.W   #7, D7
    LSR.W   #8, D7
    LSR.W   #7, D7
    MOVE.B  D7, D6
    MOVEM.L (SP)+, D7
    CMP.B   #$0, D6
    BEQ     DesSou
    CMP.B   #$1, D6
    BEQ     SouDes
    BNE     Print_Error

DesSou
    JSR     Source_Mode
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     Print_DnDr
    RTS
SouDes
    JSR     Print_DnDr
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     Source_Mode
    RTS

Check_Displacement
    CMP.B   #$00, D6
    BEQ     Displacement_16_Bit
    CMP.B   #$FF, D6
    BEQ     Displacement_32_Bit
    BNE     Displacement_8_Bit

Displacement_8_Bit  * D6 = EA
    JSR     Print_Size_Byte
    JSR     DISP_Str_Hex_Symbol * D5 = 9016
    MOVE.B  D5, D4  * D4 = 16
    SUB.B   D4, D5  * D5 = 9000
    ADD.B   #$2, D4 * D4 = 1A
    ADD.B   D4, D6  * 1A + EA = 56
    ADD.B   D6, D5  * D5 = 9056
    MOVE.W  D5, CURR_NIBBLES_MEM_LOC
    JSR     HEX_2_ASCII
    RTS
    
Displacement_16_Bit
    JSR     Print_Size_Word
    JSR     DISP_Str_Hex_Symbol * D5 = 9018
    ADD.B   #$2, D5             * D5 = 901A
    MOVE.W  (A2)+, D6           * D6 = 8FE6
    ADD.W   D6, D5
    MOVE.W  D5, CURR_NIBBLES_MEM_LOC
    JSR     HEX_2_ASCII
    RTS

Displacement_32_Bit
    JSR     Print_Error
    RTS

Check_Count_Or_Register
    JSR     Get_Bit5
    CMP.B   #$0, D6
    BEQ     Shift_Count
    CMP.B   #$1, D6
    BEQ     Shift_Register
    BNE     Print_Error

Shift_Count
    JSR     DISP_Str_Hashtag_Symbol
    JSR     DISP_Str_Hex_Symbol
    JSR     Get_Bit11_to_Bit9
    MOVE.W  D6, CURR_NIBBLES_MEM_LOC
    JSR     HEX_2_ASCII
    RTS

Shift_Register
    JSR     Print_DnDr
    RTS

Transfer_Direction
    JSR     Get_Bit10
    CMP.B   #$0, D6
    BEQ     Reg_To_Mem
    CMP.B   #$1, D6
    BEQ     Mem_to_Reg
    BNE     Print_Error

Reg_To_Mem    
    JSR     Movem_Source_Mode
    RTS
* example: MOVEM.W   (A1)+,A1-A7
Mem_to_Reg
    JSR     Movem_Source_Mode
    RTS

Movem_Source_Mode
    JSR     Get_Bit5_to_Bit3
    CMP.B   #$2, D6
    BEQ     Print_Indr_Movem
    CMP.B   #$3, D6
    BEQ     Print_Indr_Plus_Movem
    CMP.B   #$4, D6
    BEQ     Print_Indr_Minus_Movem
    CMP.B   #$7, D6
    BEQ     Print_MemAddr_Movem
    BNE     DISP_ERROR_MESSAGE    
Print_Indr_Movem
    JSR     DISP_Str_Open_Brack_Symbol
    JSR     DISP_Str_Addr_Reg
    JSR     Find_SR
    JSR     DISP_Str_Close_Brack_Symbol
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    MOVE.W  (A2)+, D7
    JSR     Postincrement_Movem
    RTS  
Print_Indr_Plus_Movem
    JSR     DISP_Str_Open_Brack_Symbol
    JSR     DISP_Str_Addr_Reg
    JSR     Find_SR
    JSR     DISP_Str_Close_Brack_Symbol
    JSR     DISP_Str_Plus_Symbol
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    MOVE.W  (A2)+, D7
    JSR     Postincrement_Movem
    RTS
Print_Indr_Minus_Movem
    JSR     DISP_Str_Minus_Symbol
    JSR     DISP_Str_Open_Brack_Symbol
    JSR     DISP_Str_Addr_Reg
    JSR     Find_SR
    JSR     DISP_Str_Close_Brack_Symbol
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     Predecrement_Movem
    RTS   
Print_MemAddr_Movem
    JSR     Get_Bit2_to_Bit0
    CMP.B   #$0, D6
    BEQ     Mem_Word_Movem
    CMP.B   #$1, D6
    BEQ     Mem_Long_Movem
    BNE     Print_Error
Mem_Word_Movem
    JSR     DISP_Str_Hex_Symbol
    ADDA    #$2, A2
    JSR     Imme_Data_Word
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    SUBA    #$2, A2
    MOVE.W  -(A2), D7
    JSR     Postincrement_Movem
    ADDA    #$4, A2
    RTS
Mem_Long_Movem
    JSR     DISP_Str_Hex_Symbol
    ADDA    #$2, A2
    JSR     Imme_Data_Long
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    SUBA    #$4, A2
    MOVE.W  -(A2), D7
    JSR     Postincrement_Movem
    ADDA    #$6, A2
    RTS

Dn_Regs
    CMP.B   #1,D6
    BEQ     Print_Dn_Regs
    RTS

An_Regs
    CMP.B   #1,D6
    BEQ     Print_An_Regs
    RTS

Print_Dn_Regs
    CMP.B   #$01, D1
    BEQ     Is_First_Dn_Reg
    JSR     DISP_Str_Slash_Symbol
    JSR     DISP_Str_Data_Reg
    JSR     Print_NumD5
    RTS

Print_An_Regs
    CMP.B   #$01, D1
    BEQ     Is_First_An_Reg
    JSR     DISP_Str_Slash_Symbol
    JSR     DISP_Str_Addr_Reg
    JSR     Print_NumD5    
    RTS

Is_First_Dn_Reg
    JSR     DISP_Str_Data_Reg
    JSR     Print_NumD5
    CLR.B   D1
    RTS

Is_First_An_Reg
    JSR     DISP_Str_Addr_Reg
    JSR     Print_NumD5
    CLR.B   D1
    RTS

Postincrement_Movem
    CLR.B   D1
    MOVE.B  #$01, D1
    JSR     Get_Bit0
    MOVE.B  #0, D5
    JSR     Dn_Regs
    JSR     Get_Bit1
    MOVE.B  #1, D5
    JSR     Dn_Regs
    JSR     Get_Bit2
    MOVE.B  #2, D5
    JSR     Dn_Regs
    JSR     Get_Bit3
    MOVE.B  #3, D5
    JSR     Dn_Regs
    JSR     Get_Bit4
    MOVE.B  #4, D5
    JSR     Dn_Regs
    JSR     Get_Bit5
    MOVE.B  #5, D5
    JSR     Dn_Regs
    JSR     Get_Bit6
    MOVE.B  #6, D5
    JSR     Dn_Regs
    JSR     Get_Bit7
    MOVE.B  #7, D5
    JSR     Dn_Regs
    JSR     Get_Bit8
    MOVE.B  #0, D5
    JSR     An_Regs
    JSR     Get_Bit9
    MOVE.B  #1, D5
    JSR     An_Regs
    JSR     Get_Bit10
    MOVE.B  #2, D5
    JSR     An_Regs
    JSR     Get_Bit11
    MOVE.B  #3, D5
    JSR     An_Regs
    JSR     Get_Bit12
    MOVE.B  #4, D5
    JSR     An_Regs
    JSR     Get_Bit13
    MOVE.B  #5, D5
    JSR     An_Regs
    JSR     Get_Bit14
    MOVE.B  #6, D5
    JSR     An_Regs
    JSR     Get_Bit15
    MOVE.B  #7, D5
    JSR     An_Regs
    RTS
    
Predecrement_Movem
    CLR.B   D1
    MOVE.B  #$01, D1
    JSR     Get_Bit0
    MOVE.B  #7, D5
    JSR     An_Regs
    JSR     Get_Bit1
    MOVE.B  #6, D5
    JSR     An_Regs
    JSR     Get_Bit2
    MOVE.B  #5, D5
    JSR     An_Regs
    JSR     Get_Bit3
    MOVE.B  #4, D5
    JSR     An_Regs
    JSR     Get_Bit4
    MOVE.B  #3, D5
    JSR     An_Regs
    JSR     Get_Bit5
    MOVE.B  #2, D5
    JSR     An_Regs
    JSR     Get_Bit6
    MOVE.B  #1, D5
    JSR     An_Regs
    JSR     Get_Bit7
    MOVE.B  #0, D5
    JSR     An_Regs
    JSR     Get_Bit8
    MOVE.B  #7, D5
    JSR     Dn_Regs
    JSR     Get_Bit9
    MOVE.B  #6, D5
    JSR     Dn_Regs
    JSR     Get_Bit10
    MOVE.B  #5, D5
    JSR     Dn_Regs
    JSR     Get_Bit11
    MOVE.B  #4, D5
    JSR     Dn_Regs
    JSR     Get_Bit12
    MOVE.B  #3, D5
    JSR     Dn_Regs
    JSR     Get_Bit13
    MOVE.B  #2, D5
    JSR     Dn_Regs
    JSR     Get_Bit14
    MOVE.B  #1, D5
    JSR     Dn_Regs
    JSR     Get_Bit15
    MOVE.B  #0, D5
    JSR     Dn_Regs
    RTS

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

Print_NumD5
    CMP.B   #$0, D5
    BEQ     Print_0
    CMP.B   #$1, D5
    BEQ     Print_1
    CMP.B   #$2, D5
    BEQ     Print_2
    CMP.B   #$3, D5
    BEQ     Print_3
    CMP.B   #$4, D5
    BEQ     Print_4
    CMP.B   #$5, D5
    BEQ     Print_5
    CMP.B   #$6, D5
    BEQ     Print_6
    CMP.B   #$7, D5
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