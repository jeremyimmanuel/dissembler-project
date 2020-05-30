*-----------------------------------------------------------
* Title      : CSS 422  Disassembler
* Written by : Jeremy, Angie, Jun
* Date       : June 8th, 2020
* Description: 
*-----------------------------------------------------------

START_ADDR_MEM_LOC          EQU    $400     ; BEGINING_ADDRESS
END_ADDR_MEM_LOC            EQU    $450     ; FINISHING_ADDRESS
CURR_NIBBLES_MEM_LOC        EQU    $500     ; CURRENT_FOUR_NIBBLES_VAR
DEST_MEM_LOC                EQU    $550     ; DEST_HOLDER
DEST_MODE_MEM_LOC           EQU    $600     ; DEST_MODE_VAR
SRC_MODE_MEM_LOC            EQU    $650     ; SRC_MODE_HOLDER
SRC_MEM_LOC                 EQU    $700     ; SRC_HOLDER
STORAGE_MEM_LOC             EQU    $750     ; UTILITY_VAR 
A1_COPY_ONE_MEM_LOC         EQU    $800     ; A1_COPY_ONE 
A1_COPY_TWO_MEM_LOC         EQU    $850     ; A1_COPY_TWO
STORE_TWO_NIBBLES_MEM_LOC   EQU    $900    ; CURRENT_TWO_NIBBLES_VAR
    
    ORG $1000
START:
    JSR PARSE_START
    * INCLUDE 'get_input.x68' ; get user input for starting address and ending address
    * INCLUDE 'ascii_hex.x68' ; convert user input from ASCII values to hex values
    *                         ; starting address saved in A2
    *                         ; ending address saved in A3
    * INCLUDE 'hex_ascii.x68'
    SIMHALT
    INCLUDE 'parse_opcode.x68'
    INCLUDE 'constants.x68'
    INCLUDE 'displays.x68'

EXIT    MOVE.B      #9, D0 
        TRAP        #15
    END START

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

*****
 * The D3_GET_NEXT_FOUR_NIB subroutine:
 * ---------------------
 * This subroutine is responsible for moving the 
 * current address of the assembler by 
 * one word or about 4 nibbles and copying 
 * it to the D3 register and CURRENT_FOUR_NIBBLES_VAR 
 *
 * It will also check if we're past the ending address
 * and it will branch appropriately 
 ***
D3_GET_NEXT_FOUR_NIB
    MOVE.W      (A2)+,D3							* Move to the next word in the address
    MOVE.W      D3, CURRENT_FOUR_NIBBLES_VAR        * Move the value into the CURRENT_FOUR_NIBBLES_VAR
    CMPA.L      A2,A3                               * Check to see if we're past the ending address
    BLT         RESTART_OR_FINISH					* Branch to RESTART_OR_FINISH if we are. 
    RTS

*******
 * Get the third and fourth nibbles from the left
 * Used to get the size of the Bcc and BRA opcodes.
 ******
D3_KEEP_THIRD_FOURTH_NIB
        LSL                        #8,D3
        LSR                        #8,D3
        RTS