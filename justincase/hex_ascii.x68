******
 * The HEX_TO_ASCII_CHANGER subroutine: 
 * --------------------------------------
 * This subroutine is responsible for changing
 * the HEX based stored values that will need
 * to be printed out at this current moment 
 * to ASCII. 
 * 
 * Typically this subroutine is invoked
 * to print out elements such as Address location, 
 * the Absolute short and long, immediate data, 
 * among other elements. 
 *
 * This subroutine will print one nibble (4-bits)
 * at a time while printing out 4 nibbles in total 
 * or about (16 bits). 
 ****
HEX_TO_ASCII_CHANGER
    LEA         JMPTABLE_HEX_CHAR,A4     	 * This instruction will load the address 
											 * of the JMPTABLE_HEX_CHAR to the A4 
											 * register to enable the output of 
											 * ASCII characters. This will be
											 * used with displacement to determine 
											 * appropriate jump with offset
											 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	 * Reload the current four nibbles that 
											 * the disassembler is looking at to D3
											 * NOTE: At this stage D3 serves as a copy 
											 * that will be used for manipulations 
											 * to leave only specific bits that
											 * other subroutines will need for validation. 
											 
    JSR         STORE_FIRST_NIBBLE_IN_D3     * This instruction is a jump to a
											 * subroutine designed specifically for 
											 * getting the first nibble which for our
											 * purposes in the HEX_TO_ASCII_CHANGER 
											 * is the left most HEX character or value
											 * that must be converted
											 
    MULU        #6,D3						 * This instruction performs an unsigned
											 * multiplication on the left most HEX 
											 * character or value which we know from
											 * the previous comment is currently 
											 * stored in D3. This is done to prep it
											 * as a displacement offset for the 
											 * JSR command below. 
											 
    JSR         0(A4,D3)					 * Performs the jump to subroutine to
											 * the JMPTABLE_HEX_CHAR with the D3 
											 * as an offset to determine the 
											 * appropriate print out. 
											 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	 * Reload the current four nibbles that 
											 * the disassembler is looking at to D3
											 * NOTE: At this stage D3 serves as a copy 
											 * that will be used for manipulations 
											 * to leave only specific bits that
											 * other subroutines will need for validation.
											 
    JSR         STORE_SECOND_NIBBLE_IN_D3    * This instruction is a jump to a subroutine designed specifically for getting the second nibble     * This instruction is a jump to a
											 * subroutine designed specifically for 
											 * getting the second nibble which for our
											 * purposes in the HEX_TO_ASCII_CHANGER 
											 * is the second left most HEX character 
											 * or value that must be converted
											 
    MULU        #6,D3						 * This instruction performs an unsigned
											 * multiplication on the left most HEX 
											 * character or value which we know from
											 * the previous comment is currently 
											 * stored in D3. This is done to prep it
											 * as a displacement offset for the 
											 * JSR command below. 
											
    JSR         0(A4,D3)					 * Performs the jump to subroutine to
											 * the JMPTABLE_HEX_CHAR with the D3 
											 * as an offset to determine the 
											 * appropriate print out. 
											 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	 * Reload the current four nibbles that 
											 * the disassembler is looking at to D3
											 * NOTE: At this stage D3 serves as a copy 
											 * that will be used for manipulations 
											 * to leave only specific bits that
											 * other subroutines will need for validation.
											 
    JSR         STORE_THIRD_NIBBLE_IN_D3     * This instruction is a jump to a
											 * subroutine designed specifically for 
											 * getting the second nibble which for our
											 * purposes in the HEX_TO_ASCII_CHANGER 
											 * is the second right most HEX character 
											 * or value that must be converted
											 
    MULU        #6,D3						 * This instruction performs an unsigned
											 * multiplication on the left most HEX 
											 * character or value which we know from
											 * the previous comment is currently 
											 * stored in D3. This is done to prep it
											 * as a displacement offset for the 
											 * JSR command below. 
											 
    JSR         0(A4,D3)					 * Performs the jump to subroutine to
											 * the JMPTABLE_HEX_CHAR with the D3 
											 * as an offset to determine the 
											 * appropriate print out. 
											 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	 * Reload the current four nibbles that 
											 * the disassembler is looking at to D3
											 * NOTE: At this stage D3 serves as a copy 
											 * that will be used for manipulations 
											 * to leave only specific bits that
											 * other subroutines will need for validation.
											 
    JSR         STORE_FOURTH_NIBBLE_IN_D3	 * This instruction is a jump to a
											 * subroutine designed specifically for 
											 * getting the second nibble which for our
											 * purposes in the HEX_TO_ASCII_CHANGER 
											 * is the second right most HEX character 
											 * or value that must be converted
											 
    MULU        #6,D3						 * This instruction performs an unsigned
											 * multiplication on the left most HEX 
											 * character or value which we know from
											 * the previous comment is currently 
											 * stored in D3. This is done to prep it
											 * as a displacement offset for the 
											 * JSR command below. 
											 
    JSR         0(A4,D3)					 * Performs the jump to subroutine to
											 * the JMPTABLE_HEX_CHAR with the D3 
											 * as an offset to determine the 
											 * appropriate print out.
											 
    CLR.W       D3							 * This instruction will clear the D3 
											 * so that it can be used in other spots
											 
    RTS										 * Return to the subroutine that called this function. 

******
 * The HEX_TO_ASCII_CHANGER_FULLSIZE subroutine: 
 * --------------------------------------
 * This subroutine is responsible for changing
 * the HEX based stored values that will need
 * to be printed out at this current moment 
 * to ASCII. 
 * 
 * Typically this subroutine is invoked
 * to print out elements such as Address location, 
 * the Absolute short and long, immediate data, 
 * among other elements. 
 *
 * This subroutine will print one nibble (4-bits)
 * at a time while printing out 4 nibbles in total 
 * or about (16 bits). 
 ****
HEX_TO_ASCII_CHANGER_FULLSIZE					
    MOVE.L      D4,CURRENT_FOUR_NIBBLES_VAR     * Copy the long address in its entirety 
    JSR         HEX_TO_ASCII_CHANGER			* Output the 8 bit data field
    MOVE.W      D4,CURRENT_FOUR_NIBBLES_VAR		* Copy the long address in its entirety 
    JSR         HEX_TO_ASCII_CHANGER		* Output the 8 bit data field
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

*****
 * The JMPTABLE_HEX_CHAR subroutine:
 * ---------------------
 * This subroutine will output 
 * the valid hexadecimal characters 
 ***
JMPTABLE_HEX_CHAR
    JMP         OUTPUT_HEX_0
    JMP         OUTPUT_HEX_1
    JMP         OUTPUT_HEX_2
    JMP         OUTPUT_HEX_3
    JMP         OUTPUT_HEX_4
    JMP         OUTPUT_HEX_5
    JMP         OUTPUT_HEX_6
    JMP         OUTPUT_HEX_7
    JMP         OUTPUT_HEX_8
    JMP         OUTPUT_HEX_9
    JMP         OUTPUT_HEX_A
    JMP         OUTPUT_HEX_B
    JMP         OUTPUT_HEX_C
    JMP         OUTPUT_HEX_D
    JMP         OUTPUT_HEX_E
    JMP         OUTPUT_HEX_F

OUTPUT_HEX_0
    LEA         STR_ZERO,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_1
    LEA         STR_ONE,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_2
    LEA         STR_TWO,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_3
    LEA         STR_THREE,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_4
    LEA         STR_FOUR,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_5
    LEA         STR_FIVE,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_6
    LEA         STR_SIX,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_7
    LEA         STR_SEVEN,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_8
    LEA         STR_EIGHT,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_9
    LEA         STR_NINE,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_A
    LEA         STR_A,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_B
    LEA         STR_B,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_C
    LEA         STR_C,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_D
    LEA         STR_D,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_E
    LEA         STR_E,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_HEX_F
    LEA         STR_F,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS
