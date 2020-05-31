HEX_2_ASCII
    LEA         JMPTABLE_HEX_CHAR, A4           ; Moving a subroutine to A4
    MOVE.W      CURR_NIBBLES_MEM_LOC,D3         ; go to the constant var we declared
    JSR         STORE_FIRST_NIBBLE_IN_D3        ;
    MULU        #6,D3
    JSR         0(A4,D3)
    MOVE.W      CURR_NIBBLES_MEM_LOC,D3
    JSR         STORE_SECOND_NIBBLE_IN_D3
    MULU        #6,D3
    JSR         0(A4,D3)
    MOVE.W      CURR_NIBBLES_MEM_LOC,D3
    JSR         STORE_THIRD_NIBBLE_IN_D3
    MULU        #6,D3
    JSR         0(A4,D3)
    MOVE.W      CURR_NIBBLES_MEM_LOC,D3
    JSR         STORE_FOURTH_NIBBLE_IN_D3
    MULU        #6,D3
    JSR         0(A4,D3)
    CLR.W       D3
    RTS

HEX_TO_ASCII_CHANGER_FULLSIZE			        ; HEX_TO_ASCII_CHANGER_FULLSIZE		
    MOVE.L      D4, CURR_NIBBLES_MEM_LOC     * Copy the long address in its entirety 
    JSR         HEX_2_ASCII			            * Output the 8 bit data field
    MOVE.W      D4, CURR_NIBBLES_MEM_LOC		* Copy the long address in its entirety 
    JSR         HEX_2_ASCII		                * Output the 8 bit data field
    JSR         DISP_STR_SPACE			        * Invokes subroutine to print a space
    RTS
    
STORE_FIRST_NIBBLE_IN_D3                        ; STORE_FIRST_NIBBLE_IN_D3
    LSR         #8,D3   * Shift 2 nibbles to the rights
    LSR         #4,D3   * Shift 1 nibbles to the right. Now left most nibble is now the right-most nibble
    RTS

STORE_SECOND_NIBBLE_IN_D3                       ; STORE_SECOND_NIBBLE_IN_D3
    LSL         #4,D3    * Shift the left most nibble to go away
    LSR         #4,D3    * Return the original place
    LSR         #8,D3    * Push the 2 right-most nibbles out of the way
    RTS

STORE_THIRD_NIBBLE_IN_D3                        ; STORE_THIRD_NIBBLE_IN_D3
    LSL         #8,D3     * Shift out the 2 left-most nibbles
    LSR         #8,D3     * Shift bits back to original position 
    LSR         #4,D3     * Shift out the least Significant Nibble 
    RTS
STORE_FOURTH_NIBBLE_IN_D3                       ;STORE_FOURTH_NIBBLE_IN_D3
    LSL         #8,D3	* Shift out two most sig nibbles
    LSL         #4,D3	* Shift out third most sig nibble
    LSR         #8,D3	* Return to original position 
    LSR         #4,D3
    RTS

JMPTABLE_HEX_CHAR
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