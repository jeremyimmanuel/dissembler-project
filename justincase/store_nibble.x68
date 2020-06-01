
*****
 * The STORE_FIRST_NIBBLE_IN_D3 subroutine:
 * ---------------------
 * This subroutine is responsible for leaving
 * only the first nibble. 
 * 
 * This function should only be invoked 
 * when the full word of data has already 
 * been copied to D3 
 ***
STORE_FIRST_NIBBLE_IN_D3
    LSR         #8,D3   * Shift 2 nibbles to the rights
    LSR         #4,D3   * Shift 1 nibbles to the right. Now left most nibble is now the right-most nibble
    RTS

STORE_FIRST_NIBBLE_IN_D2
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D2
    LSR         #8,D2   * Shift 2 nibbles to the rights
    LSR         #4,D2   * Shift 1 nibbles to the right. Now left most nibble is now the right-most nibble
    RTS

STORE_THIRD_NIBBLE_IN_D2
	MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D2
    LSL         #8,D2   * Shift 2 nibbles to the left
    LSR         #8,D2   * Shift 2 nibbles to the right return to original position 
	LSR			#4,D2	* Shift 1 nibbles to the left leave only 
    RTS
	
STORE_FOURTH_NIBBLE_IN_D2
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D2
    LSL         #8,D2   * Shift 2 nibbles to the rights
    LSL         #4,D2   * Shift 1 nibbles to the right. Now left most nibble is now the right-most nibble
	LSR			#8,D2
	LSR 		#4,D2
    RTS

*****
 * The STORE_SECOND_NIBBLE_IN_D3 subroutine:
 * ---------------------
 * This subroutine is responsible for leaving
 * only the second nibble. 
 * 
 * This function should only be invoked 
 * when the full word of data has already 
 * been copied to D3 
 ***
STORE_SECOND_NIBBLE_IN_D3
    LSL         #4,D3    * Shift the left most nibble to go away
    LSR         #4,D3    * Return the original place
    LSR         #8,D3    * Push the 2 right-most nibbles out of the way
    RTS

*****
 * The STORE_THIRD_NIBBLE_IN_D3 subroutine:
 * ---------------------
 * This subroutine is responsible for leaving
 * only the third nibble. 
 * 
 * This function should only be invoked 
 * when the full word of data has already 
 * been copied to D3 
 ***
STORE_THIRD_NIBBLE_IN_D3
    LSL         #8,D3     * Shift out the 2 left-most nibbles
    LSR         #8,D3     * Shift bits back to original position 
    LSR         #4,D3     * Shift out the least Significant Nibble 
    RTS

*****
 * The STORE_FOURTH_NIBBLE_IN_D3 subroutine:
 * ---------------------
 * This subroutine is responsible for leaving
 * only the fourth nibble. 
 * 
 * This function should only be invoked 
 * when the full word of data has already 
 * been copied to D3 
 ***
STORE_FOURTH_NIBBLE_IN_D3
    LSL         #8,D3	* Shift out two most sig nibbles
    LSL         #4,D3	* Shift out third most sig nibble
    LSR         #8,D3	* Return to original position 
    LSR         #4,D3
    RTS