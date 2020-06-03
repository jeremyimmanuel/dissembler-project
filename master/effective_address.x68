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
    BEQ     Print_MemAddr_Dr
    BNE     Print_Error_EA

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
    BNE     Print_Error_EA

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
    BEQ     Immedi_Data

Print_MemAddr_Dr
    JSR     Get_Bit11_to_Bit9
    CMP.B   #$0, D6
    BEQ     Mem_Word
    CMP.B   #$1, D6
    BEQ     Mem_Long
    CMP.B   #$4, D6
    BEQ     Immedi_Data

Mem_Word
    JSR     DISP_Str_Hex_Symbol
    JSR     Immedi_Data_Word
    RTS
Mem_Long
    JSR     DISP_Str_Hex_Symbol
    JSR     Immedi_Data_Long
    RTS
Immedi_Data
    JSR     DISP_Str_Hashtag_Symbol
    JSR     DISP_Str_Hex_Symbol
    JSR     Get_First_Nibble
    CMP.B   #$3, D6
    BLE     Size_Move
    BGE     Size_Arthm

Size_Arthm
    JSR     Get_Bit7_to_Bit6
    CMP.B   #$1, D6       * if equal to 3 that mean its Byte because 01 is 1 in hex
    BEQ     Immedi_Data_Byte
    CMP.B   #$3, D6       * if equal to 3 that mean its Word because 11 is 3 in hex
    BEQ     Immedi_Data_Word
    CMP.B   #$2, D6       * if equal to 3 that mean its Long because 10 is 2 in hex
    BEQ     Immedi_Data_Long

Size_Move
    JSR     Get_Bit13_to_Bit12
    CMP.B   #$1, D6       * if equal to 3 that mean its Byte because 01 is 1 in hex
    BEQ     Immedi_Data_Byte
    CMP.B   #$3, D6       * if equal to 3 that mean its Word because 11 is 3 in hex
    BEQ     Immedi_Data_Word
    CMP.B   #$2, D6       * if equal to 3 that mean its Long because 10 is 2 in hex
    BEQ     Immedi_Data_Long
    
Immedi_Data_Byte    
    MOVE.W      (A2)+, D5
    MOVE.W      D5, CURR_NIBBLES_MEM_LOC
    JSR         HEX_2_ASCII
    RTS
Immedi_Data_Word
    MOVE.W      (A2)+, D5
    MOVE.W      D5, CURR_NIBBLES_MEM_LOC
    JSR         HEX_2_ASCII
    RTS
Immedi_Data_Long
    MOVE.L      (A2)+, D5
    MOVE.L      D5, CURR_NIBBLES_MEM_LOC
    JSR         HEX_2_ASCII
    MOVE.W      D5, CURR_NIBBLES_MEM_LOC
    JSR         HEX_2_ASCII
    RTS

Check_Opmode
    JSR     Get_First_Nibble
    CMP.B   #$0, D6
    BEQ     Immedi_Dn

    JSR     Get_Bit8   
    CMP.B   #$0, D6
    BEQ     ea_Dn
    CMP.B   #$1, D6
    BEQ     Dn_ea
    BNE     Print_Error_EA

ea_Dn
    JSR     Source_Mode
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     Print_DnDr
    RTS
Dn_ea
    JSR     Print_DnDr
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     Source_Mode
    RTS

Immedi_Dn
    JSR     DISP_Str_Hashtag_Symbol
    JSR     DISP_Str_Hex_Symbol
    JSR     Print_Arthm_Immedi
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     Source_Mode
    RTS

Print_Arthm_Immedi
    JSR     Get_Bit7_to_Bit6
    CMP.B   #0, D6
    BEQ     Immedi_Data_Byte
    CMP.B   #1, D6
    BEQ     Immedi_Data_Word
    CMP.B   #2, D6
    BEQ     Immedi_Data_Long


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
    CLR     D6
    RTS

Displacement_32_Bit
    JSR     Print_Error_EA
    RTS

Check_Count_Or_Register
    JSR     Get_Bit5
    CMP.B   #$0, D6
    BEQ     Shift_Count
    CMP.B   #$1, D6
    BEQ     Shift_Register
    BNE     Print_Error_EA

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
    BNE     Print_Error_EA

* example: MOVEM.W   A1-A7, (A1)+
Reg_To_Mem
    JSR     Get_Bit5_to_Bit3
    CMP.B   #$2, D6
    BEQ     Print_Indr_Movem_RM
    CMP.B   #$4, D6
    BEQ     Print_Indr_Minus_Movem_RM
    CMP.B   #$7, D6
    BEQ     Print_MemAddr_RM
    BNE     Print_Error_EA  
Print_Indr_Movem_RM
    MOVE.W  (A2), D7
    JSR     Postincrement_Movem
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     DISP_Str_Open_Brack_Symbol
    MOVE.W  -(A2), D7
    JSR     DISP_Str_Addr_Reg
    JSR     Find_SR
    JSR     DISP_Str_Close_Brack_Symbol
    ADDA    #$4, A2
    RTS  
Print_Indr_Minus_Movem_RM
    MOVE.W  (A2), D7
    JSR     Predecrement_Movem
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     DISP_Str_Minus_Symbol
    JSR     DISP_Str_Open_Brack_Symbol
    MOVE.W  -(A2), D7
    JSR     DISP_Str_Addr_Reg
    JSR     Find_SR
    JSR     DISP_Str_Close_Brack_Symbol
    ADDA    #$4, A2
    RTS  
Print_MemAddr_RM
    JSR     Get_Bit2_to_Bit0
    CMP.B   #$0, D6
    BEQ     Mem_Word_RM
    CMP.B   #$1, D6
    BEQ     Mem_Long_RM
    BNE     Print_Error_EA
Mem_Word_RM
    MOVE.W  (A2)+, D7
    JSR     Postincrement_Movem
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     DISP_Str_Hex_Symbol
    JSR     Immedi_Data_Word
    RTS
Mem_Long_RM
    MOVE.W  (A2)+, D7
    JSR     Postincrement_Movem
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    JSR     DISP_Str_Hex_Symbol
    JSR     Immedi_Data_Long
    RTS

* example: MOVEM.W   (A1),A1-A7
Mem_to_Reg
    JSR     Get_Bit5_to_Bit3
    CMP.B   #$2, D6
    BEQ     Print_Indr_Movem_MR
    CMP.B   #$3, D6
    BEQ     Print_Indr_Plus_Movem_MR
    CMP.B   #$7, D6
    BEQ     Print_MemAddr_MR
    BNE     Print_Error_EA  
Print_Indr_Movem_MR
    JSR     DISP_Str_Open_Brack_Symbol
    JSR     DISP_Str_Addr_Reg
    JSR     Find_SR
    JSR     DISP_Str_Close_Brack_Symbol
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    MOVE.W  (A2)+, D7
    JSR     Postincrement_Movem
    RTS  
Print_Indr_Plus_Movem_MR
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
Print_MemAddr_MR
    JSR     Get_Bit2_to_Bit0
    CMP.B   #$0, D6
    BEQ     Mem_Word_MR
    CMP.B   #$1, D6
    BEQ     Mem_Long_MR
    BNE     Print_Error_EA
Mem_Word_MR
    JSR     DISP_Str_Hex_Symbol
    ADDA    #$2, A2
    JSR     Immedi_Data_Word
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    SUBA    #$2, A2
    MOVE.W  -(A2), D7
    JSR     Postincrement_Movem
    ADDA    #$4, A2
    RTS
Mem_Long_MR
    JSR     DISP_Str_Hex_Symbol
    ADDA    #$2, A2
    JSR     Immedi_Data_Long
    JSR     DISP_STR_COMMA
    JSR     DISP_STR_SPACE
    SUBA    #$4, A2
    MOVE.W  -(A2), D7
    JSR     Postincrement_Movem
    ADDA    #$6, A2
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