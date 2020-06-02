*-----------------------------------------------------------
* Title      : ascii_hex.68
* Written by : Jeremy Tandjung, Angie Tserenjav, Jun Zhen
* Date       : 05/16/2020
* Description: This file handles converting ascii values from 
*               user input to hex so that easy68k can use it 
*-----------------------------------------------------------

HEX_2_ASCII:
    LEA         HEX_Jump_Table, A4           ; Moving a subroutine to A4
    
    MOVE.W      CURR_NIBBLES_MEM_LOC, D3        
    JSR         Shift_To_First_Nibble_D3        
    MULU        #6, D3
    JSR         0(A4,D3)
    
    MOVE.W      CURR_NIBBLES_MEM_LOC, D3
    JSR         Shift_To_Second_Nibble_D3
    MULU        #6, D3
    JSR         0(A4, D3)
    
    MOVE.W      CURR_NIBBLES_MEM_LOC, D3
    JSR         Shift_To_Third_Nibble_D3
    MULU        #6, D3
    JSR         0(A4, D3)
    
    MOVE.W      CURR_NIBBLES_MEM_LOC, D3
    JSR         Shift_To_Fourth_Nibble_D3
    MULU        #6, D3
    JSR         0(A4, D3)
    
    CLR.W       D3
    RTS

Shift_To_First_Nibble_D3    ; Shift_To_First_Nibble_D3
    LSR         #8, D3      ; Shift 2 nibbles to the rights
    LSR         #4, D3      ; Shift 1 nibbles to the right. Now left most nibble is now the right-most nibble
    RTS

Shift_To_Second_Nibble_D3   ; Shift_To_Second_Nibble_D3
    LSL         #4, D3      ; Shift out left most nibble 
    LSR         #4, D3      ; Return the original place
    LSR         #8, D3      ; Shift out two rightmost nibble
    RTS

Shift_To_Third_Nibble_D3    ; Shift_To_Third_Nibble_D3
    LSL         #8, D3      ; Shift out the two left most nibbles
    LSR         #8, D3      ; Shift bits back to original position 
    LSR         #4, D3      ; Shift out rightmost nibble
    RTS

Shift_To_Fourth_Nibble_D3   ; Shift_To_Fourth_Nibble_D3
    LSL         #8, D3	    ; Shift out two left most nibbles
    LSL         #4, D3	    ; Shift out third left most nibble
    LSR         #8, D3	    ; Return to original position 
    LSR         #4, D3
    RTS

HEX_Jump_Table
    JMP         DISP_STR_0
    JMP         DISP_STR_1
    JMP         DISP_STR_2
    JMP         DISP_STR_3
    JMP         DISP_STR_4
    JMP         DISP_STR_5
    JMP         DISP_STR_6
    JMP         DISP_STR_7
    JMP         DISP_STR_8
    JMP         DISP_STR_9
    JMP         DISP_STR_A
    JMP         DISP_STR_B
    JMP         DISP_STR_C
    JMP         DISP_STR_D
    JMP         DISP_STR_E
    JMP         DISP_STR_F