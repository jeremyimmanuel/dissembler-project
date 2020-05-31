HEX_TO_ASCII_CHANGER
    LEA         JMPTABLE_HEX_CHAR, A4
    
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3
    JSR         STORE_FIRST_NIBBLE_IN_D3
    MULU        #6,D3
    JSR         0(A4,D3)

    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3
    JSR         STORE_SECOND_NIBBLE_IN_D3
    MULU        #6,D3
    JSR         0(A4,D3)

    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3
    JSR         STORE_THIRD_NIBBLE_IN_D3
    MULU        #6,D3
    JSR         0(A4,D3)
    
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3
    JSR         STORE_FOURTH_NIBBLE_IN_D3
    MULU        #6,D3
    JSR         0(A4,D3)

    CLR.W       D3
    RTS

STORE_FIRST_NIBBLE_IN_D3
    LSR         #8,D3   * Shift 2 nibbles to the rights
    LSR         #4,D3   * Shift 1 nibbles to the right. Now left most nibble is now the right-most nibble
    RTS

STORE_SECOND_NIBBLE_IN_D3
    LSL         #4,D3    * Shift the left most nibble to go away
    LSR         #4,D3    * Return the original place
    LSR         #8,D3    * Push the 2 right-most nibbles out of the way
    RTS

STORE_THIRD_NIBBLE_IN_D3
    LSL         #8,D3     * Shift out the 2 left-most nibbles
    LSR         #8,D3     * Shift bits back to original position 
    LSR         #4,D3     * Shift out the least Significant Nibble 
    RTS


STORE_FOURTH_NIBBLE_IN_D3
    LSL         #8,D3	* Shift out two most sig nibbles
    LSL         #4,D3	* Shift out third most sig nibble
    LSR         #8,D3	* Return to original position 
    LSR         #4,D3
    RTS