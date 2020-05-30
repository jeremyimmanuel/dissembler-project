*-----------------------------------------------------------
* Title      : CSS 422 68k Disassembler
* Written by : Pratit Vithalani, Aaron Handjojo, Nathan Phan
* Date       : June 6th, 2019
* Description: Load a test file, enter starting and ending address. Press enter to see it disassemble every screen limit
*-----------------------------------------------------------

****
 * The DERIVING_OPCODE subroutine:
 * -------------------------------
 * Responsible for going through the first 4 bits of the OpCode to
 * figure out where in the program to branch to for further processing.
 * Jumps to ' OUTPUT_ADDR_LOC ', ' D3_GET_NEXT_FOUR_NIB ',
 * and ' STORE_FIRST_NIBBLE_IN_D3 ' subroutine. 
 * These jumps in conjunction with the manipulation of D3 to get the index
 * of the first nibble will allow a proper jump to the right
 * ' FIRST_NIBBLE_IS_ ' subroutine in the jump table. 
 ***
DERIVING_OPCODE
    JSR         OUTPUT_ADDR_LOC                  * Jumps to the Sub Routine ' OUTPUT_ADDR_LOC '
    JSR         D3_GET_NEXT_FOUR_NIB             * Once returned back, jump to ' D3_GET_NEXT_FOUR_NIB '
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3		 * Reload the current four nibbles that      
												 * Copy the CURRENT_FOUR_NIBBLES_VAR to 'D3' since that's used by most subroutines
    JSR         STORE_FIRST_NIBBLE_IN_D3         * Once copy is complete jump to ' STORE_FIRST_NIBBLE_IN_D3 '
    MULU        #6,D3                            * The multiply unsigned operation will manipulate 'D3' to get the index of the first nibble
    JSR         0(A0,D3)                         * Using the index of the first nibble jump to the table
    SIMHALT

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



******
 * The PRESS_ENTER_CHECK subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * checking if the user is able to 
 * press enter yet. 
 * This will be ran 30 or so times 
 * to represent the 30 statements 
 * that will be printed out before
 * an entire screen of output is complete.
 * If 30 hasn't been reached then it will 
 * just print a space and then return to
 * the subroutine that invoked it. 
 * If 30 has been reached then 
 * branch to the PRESS_ENTER_CONT_CHECK
 * to allow input of an enter. 
 ****
PRESS_ENTER_CHECK
    ADD         #1,D6					* D6 is used as the counter for number of 
										* statements printed out. 
    CMP         #30,D6 					* Since the screen is about 30 statements 
										* in height, then this counter needs 
										* to reach 30 before the user can press enter. 
    BEQ         PRESS_ENTER_CONT_CHECK	* If 30 has been reached let the user enter. 
    LEA         STR_SPACE,A1			* If not then just print a string.
    MOVE        #13,D0					* Loads TRAP TASK #13
    TRAP        #15						* Execute TRAP TASK
    RTS									* Return to the subroutine

******
 * The PRESS_ENTER_CONT_CHECK subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * allowing the user to press enter.
 * This will in turn allow the print out
 * of additional instructions to the screen.
 ****
PRESS_ENTER_CONT_CHECK
    MOVE        #0,D6		* Reset the counter which is D6
    MOVE.B      #5,D0		* Load TRAP TASK #5	
    TRAP        #15			* Execute the TRAP TASK
    RTS						* Rerturn to the subroutine.

********************************************************************************
 * This section of the disassembler is focused on disassembling 
 * the OpCode and data in the memory for output to the console.
 * 
 * The logic for the majority of these operations will be 
 * contained in this section 
 *******************************************************************************

******
 * The INVALID_OPCODE subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * handling cases of identified invalid OpCodes. 
 *
 * Used in cases of: Invalid Instructions or 
 * Invalid Data Accessing Mode
 * 
 * Where it will just print out 'DATA' followed by
 * a space and then a hex symbol then the OpCode 
 * in HEX format following it. 
 *        Address 'DATA $OPCODEINHEX'
 * After it's complete the subroutine will 
 * continue checking to see if it should 
 * allow the user to press ENTER. 
 * 
 * Subsequently it will branch to 
 * get the next four nibbles 
 * of a potential opcode. 
 ****
INVALID_OPCODE
    LEA         STR_DATA,A1						* This instruction will load 
												* the string 'DATA' for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1			* Invokes subroutine to print the DATA
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space				* Invokes subroutine to print a space 
    JSR         OUTPUT_HEX_SYMBOL				* Invokes subroutine to print '$'				* Invokes subroutine to print '$'
    JSR         HEX_TO_ASCII_CHANGER            * This instruction will print the 
												* invalid OpCode in HEX format
    LEA         STR_SPACE,A1 					* Loads a space for print out 
												* This is done to move to the next line
    MOVE.B      #14,D0							* Load up TRAP CODE #14
    TRAP        #15								* Execute the TRAP TASK
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.				* Branch to the PRESS_ENTER_CHECK 
												* subroutine to see if a new screen
												* of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.                 * Branch to the subroutine for 
												* checking the next word and parsing
												* it to see if it's an OpCode.

******
 * The OUTPUT_NOT subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the NOT instruction when 
 * there is only one subsequent operand. 
 ****
OUTPUT_NOT
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	 * Reload the current four nibbles that 
											 * the disassembler is looking at to D3
											 * NOTE: At this stage D3 serves as a copy 
											 * that will be used for manipulations 
											 * to leave only specific bits that
											 * other subroutines will need for validation.
											 
    JSR         D3_STORE_NORM_SIZE			 * Jumps to the subroutine that will 
											 * manipulate the nibble to only store
											 * the bits for 4th and 5th bits 
											 * which typically indicate the size 
											 
    CMP         #%11,D3						 * Checks to see if a strange size suffix
											 * was indicated. 
											 
    BEQ         INVALID_OPCODE               * If there is one, then it's an invalid opcode
											 * as NOT may only use normal sizes of: 01,00,10
											 
    LEA         STR_NOT,A1                   * Loads the string for NOT for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1		 * Prints the string loaded in A1 
    JSR         SUFFIX_OUTPUT_JMP			 * Jumps to the SUFFIX_OUTPUT_JMP to determine
											 * the appropriate suffix for print out.
											 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	 * Reload the current four nibbles that 
											 * the disassembler is looking at to D3
											 * NOTE: At this stage D3 serves as a copy 
											 * that will be used for manipulations 
											 * to leave only specific bits that
											 * other subroutines will need for validation.	
											 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable.           * This subroutine will update the 
											 * Destination Source Variable
											 
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.		 * This subroutine will output the data
											 * data mode source. 
											 
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.		     * Branch to the PRESS_ENTER_CHECK 
											 * subroutine to see if a new screen
											 * of more output is ready. 
											 
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.              * Branch to the subroutine for 
										     * checking the next word and parsing
											 * it to see if it's an OpCode.
											 
    RTS										 * Return to the subroutine

******
 * The OUTPUT_NOP subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the NOP instruction when 
 * there are no subsequent operand(s). 
 ****
OUTPUT_NOP
    LEA         STR_NOP,A1                   * Loads the string for NOP for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1		 * Prints the string loaded in A1 
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.		     * Branch to the PRESS_ENTER_CHECK 
											 * subroutine to see if a new screen
											 * of more output is ready. 
											 
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.              * Branch to the subroutine for 
										     * checking the next word and parsing
											 * it to see if it's an OpCode.
											 
    RTS										 * Return to the subroutine

******
 * The OUTPUT_RTS subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the RTS instruction when 
 * there are no subsequent operand(s). 
 ****
OUTPUT_RTS
    LEA         STR_RTS,A1                  * Loads the string for RTS for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
											 
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode. 											 
    RTS										* Return to the subroutine

******
 * The OUTPUT_ORI subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the ORI instruction when 
 * there are two subsequent opearnds 
 * This hasn't been implemented completely.
 ****
OUTPUT_ORI
    LEA         STR_ORI,A1                  * Loads the string for ORI for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1		 * Prints the string loaded in A1 
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.													 
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.              											 
    RTS										* Return to the subroutine

******
 * The OUTPUT_JSR subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the JSR instruction it will 
 * be followed by the actual address 
 * instead of just the displacement.
 ****
OUTPUT_JSR
    LEA         STR_JSR,A1					* Loads the string for JSR for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1         
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space            
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.	
											 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 			 
											* This subroutine will update the 
											* Destination Source Variable
											 
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.      
											* This subroutine will output the data
											* data mode source. Which will include
											* outputting the M & N of the last 6-bits.
	
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
											* subroutine to see if a new screen
											* of more output is ready. 
											 
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.              
											* Branch to the subroutine for 
										    * checking the next word and parsing
											* it to see if it's an OpCode.

******
 * The OUTPUT_CMPI subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the CMPI instruction.
 * This subroutine will involve updating
 * the DEST_SRC_VAR, printing out the suffix
 * among other subroutine jumps. 
 ****
OUTPUT_CMPI
    LEA         STR_CMPI,A1                  * Loads the string for CMPI for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1         * Prints the string loaded in A1
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	 * Reload the current four nibbles that 
											 * the disassembler is looking at to D3
											 * NOTE: At this stage D3 serves as a copy 
											 * that will be used for manipulations 
											 * to leave only specific bits that
											 * other subroutines will need for validation.
											 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 			 * This subroutine will update the 
											 * Destination Source Variable
											 
    JSR         SUFFIX_OUTPUT_JMP			 * Jumps to the SUFFIX_OUTPUT_JMP to determine
											 * the appropriate suffix for print out.
											 
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space           * Invokes subroutine to print a space 
    JSR         OUTPUT_EA_IMMI_DATA_SYMBOL	* Outputs the '#' symbol	 * Outputs the '#' symbol 
    JSR         D3_STORE_NORM_SIZE           * Jumps to the subroutine that will 
											 * manipulate the nibble to only store
											 * the bits for 4th and 5th bits 
											 * which typically indicate the size 
											 * In this case we're trying to find 
											 * the size of the operation in order
											 * to find out how how many bytes
											 * the disassembler should advance by. 
    
	LSR         #1, D3                       * In thise case CMPI.B and CMPI.W 
											 * will map to (xxx).S so the print out should only be for 4
											 
    MOVE.W      D3, UTILITY_VAR				 * Moves the value stored in D3 to the temporary variable. 
	
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable.           * This subroutine will update the 
											 * Destination Source Variable. In this case now the
											 * byte and word sizes will be printing out 4 spaces 
											 * whereas a long size will print out 5 spaces. 
											 
    JSR         REG_MODE_111                 * Jumps to the REG_MODE_111 subroutine 
											 * This will precipitate the output of the immediate value
											 
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma				 * This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space			 * Invokes subroutine to print a space 
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.		 * This subroutine will output the data
											 * data mode source.
											 
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready. 			 * Branch to the PRESS_ENTER_CHECK 
											 * subroutine to see if a new screen
											 * of more output is ready. 
											 
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.				 * Branch to the subroutine for 
										     * checking the next word and parsing
											 * it to see if it's an OpCode.
    RTS										 * Return to the subroutine


OUTPUT_ADDI
    LEA         STR_DATA,A1                  * Loads the string for CMPI for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1         * Prints the string loaded in A1
    LEA         STR_NOT_SUPPORTED, A1
    JSR         WHOLE_MESSAGE_OUTPUT
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	 * Reload the current four nibbles that 
											
											 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 			 * This subroutine will update the 
											 * Destination Source Variable
											 
    JSR         SUFFIX_OUTPUT_JMP			 * Jumps to the SUFFIX_OUTPUT_JMP to determine
											 * the appropriate suffix for print out.
											 
    * JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space           * Invokes subroutine to print a space 
    * JSR         OUTPUT_EA_IMMI_DATA_SYMBOL	* Outputs the '#' symbol	 * Outputs the '#' symbol 
    JSR         D3_STORE_NORM_SIZE           * Jumps to the subroutine that will 
											
    
	LSR         #1, D3                       * In thise case CMPI.B and CMPI.W 
											 * will map to (xxx).S so the print out should only be for 4
											 
    MOVE.W      D3, UTILITY_VAR				 * Moves the value stored in D3 to the temporary variable. 
	
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable.           * This subroutine will update the 
											 * Destination Source Variable. In this case now the
											 * byte and word sizes will be printing out 4 spaces 
											 * whereas a long size will print out 5 spaces. 
											 
    JSR         REG_MODE_111                 * Jumps to the REG_MODE_111 subroutine 
											 * This will precipitate the output of the immediate value
											 
    * JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma				 * This invokes a subroutine that will output a comma
    * JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space			 * Invokes subroutine to print a space 
    * JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.		 * This subroutine will output the data
	* 										 * data mode source.
											 
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready. 			 * Branch to the PRESS_ENTER_CHECK 
											 * subroutine to see if a new screen
											 * of more output is ready. 
											 
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.				 * Branch to the subroutine for 
										     * checking the next word and parsing
											 * it to see if it's an OpCode.
    RTS										 * Return to the subroutine
    

******
 * The SPECIAL_SUFFIX_OUTPUT_JMP subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the suffix that reflects
 * the size stored in the OpCode. 
 * It should only be used for MOVE and MOVEM
 * since their sizes are byte, word, long
 * and reflected by bits 01,11,10 respectively
 ****
SPECIAL_SUFFIX_OUTPUT_JMP
    LEA         JMPTABLE_USUAL_CASE_SIZE,A4	 * This instruction will load the address 
											 * of the JMPTABLE_USUAL_CASE_SIZE to the A4 
											 * register to enable the output of 
											 * the right size. This will be
											 * used with displacement to determine 
											 * appropriate jump with offset
											 
    MULU        #6,D3						 * This instruction performs an unsigned
											 * multiplication on the left most HEX 
											 * character or value which we know from
											 * the previous comment is currently 
											 * stored in D3. This is done to prep it
											 * as a displacement offset for the 
											 * JSR command below. 
											 
    JSR         0(A4,D3)					 * Performs the jump to subroutine to
											 * the JMPTABLE_USUAL_CASE_SIZE with the D3 
											 * as an offset to determine the 
											 * appropriate print out.
											 
    CLR         D3							 * Clear the D3 register which is used
											 * as a storage of the hex addresses.
    RTS										 * Return to the subroutine

******
 * The SUFFIX_OUTPUT_JMP subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the suffix that reflects
 * the size stored in the OpCode. 
 * It uses the typical format that stores
 * the size in the typical area which is 
 * the first 2 bits of the third nibble
 * or bits 4-5 of the word. 
 *
 * NOTE: Byte (00), Word (01), Long (10)
 ****
SUFFIX_OUTPUT_JMP
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	    * Reload the current four nibbles that 
												* the disassembler is looking at to D3
												* NOTE: At this stage D3 serves as a copy 
												* that will be used for manipulations 
												* to leave only specific bits that
												* other subroutines will need for validation.
												
    JSR         D3_STORE_NORM_SIZE				* Jumps to the subroutine that will 
												* manipulate the nibble to only store
												* the bits for 4th and 5th bits 
												* which typically indicate the size 
												* In this case we're trying to find 
												* the size of the operation in order
												* to find out how how many bytes
												* the disassembler should advance by.
												
    LEA         JMPTABLE_USUAL_CASE_SIZE,A4     * This instruction will load the address 
											    * of the JMPTABLE_USUAL_CASE_SIZE to the A4 
											    * register to enable the output of 
											    * the right size. This will be
											    * used with displacement to determine 
											    * appropriate jump with offset
												
    CMP         #%11,D3                         * Checks to see if a strange size suffix
												* was indicated. In this typical instance #%11 isn't used. 
												
    BEQ         INVALID_OPCODE					* If there is one, then it's an invalid opcode
											    * as NOT may only use normal sizes of: 01,00,10
												
    MULU        #6,D3							* This instruction performs an unsigned
												* multiplication on the left most HEX 
												* character or value which we know from
												* the previous comment is currently 
												* stored in D3. This is done to prep it
												* as a displacement offset for the 
												* JSR command below. 
												
    JSR         0(A4,D3)                        * Performs the jump to subroutine to
												* the JMPTABLE_USUAL_CASE_SIZE with the D3 
												* as an offset to determine the 
												* appropriate print out. 
    RTS											* Return to the subroutine

******
 * The REGISTER_NUM_OUTPUT subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the register number (An) or (Dn)
 * This subroutine has a precondition that
 * the register number was stored in the
 * UTILITY_VAR before executing this subroutine.
 * The Data Source or Data Destination may
 * invoke this subroutine. 
 ****
REGISTER_NUM_OUTPUT
    LEA         JMPTABLE_HEX_CHAR,A4    * This instruction will load the address 
										* of the JMPTABLE_HEX_CHAR to the A4 
										* register to enable the output of 
										* ASCII characters. This will be
										* used with displacement to determine 
										* appropriate jump with offset
										
    MOVE.W      UTILITY_VAR,D3			* Assuming that the register number
										* has been loaded into the UTILITY_VAR
										* move it to D3 for manipulation.
										
    MULU        #6,D3					* This instruction performs an unsigned
										* multiplication on the left most HEX 
										* character or value which we know from
										* the previous comment is currently 
										* stored in D3. This is done to prep it
										* as a displacement offset for the 
										* JSR command below. 
										
    JSR         0(A4,D3)				* Performs the jump to subroutine to
										* the JMPTABLE_HEX_CHAR with the D3 
										* as an offset to determine the 
										* appropriate print out. 
	
    CLR.W       UTILITY_VAR				* Clear the UTILITY_VAR for future use
    CLR.W       D3						* Clear the D3 register which is used
										* as a storage of the hex addresses.
    RTS									* Return to the subroutine

******
 * The OUTPUT_LEA subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the LEA instruction. 
 ****
OUTPUT_LEA
    LEA         STR_LEA,A1					* Loads the string for LEA for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1		* Prints the string loaded in A1
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space			* Invokes subroutine to print a space 
	
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
											
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 			* This subroutine will update the 
											* Destination Source Variable. In this case now the
											* byte and word sizes will be printing out 4 spaces 
											* whereas a long size will print out 5 spaces.
											
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.		* This subroutine will output the data
											* data mode source.
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space			* Invokes subroutine to print a space 
    JSR         OUTPUT_ADDR_REG             * This instruction will automatically jump to the OUTPUT_ADDR_REG subroutine because LEA can only use Address register.             * This instruction will automatically jump to 
											* the OUTPUT_ADDR_REG subroutine because LEA 
											* can only use Address register.
    MOVE.W      DEST_HOLDER,UTILITY_VAR     * Move the destination register number to 
											* the utility_var for printing 
											
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8			* This subroutine is responsible for 
											* outputting the register number (An) or (Dn)
											
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.			* Branch to the PRESS_ENTER_CHECK 
											* subroutine to see if a new screen
											* of more output is ready. 
											
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.				* Branch to the subroutine for 
										    * checking the next word and parsing
											* it to see if it's an OpCode.
    RTS										* Return to the subroutine

******
 * The OUTPUT_ADDQ subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the ADDQ instruction. 
 ****
OUTPUT_ADDQ
    LEA         STR_ADDQ,A1					* Loads the string for ADDQ for output
    BRA         UTILITY_ADDQ_SUBQ			* Branches to the utility function

******
 * The OUTPUT_ADDQ subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the ADDQ instruction. 
 * Utilizes the same helper method as ADDQ
 * Since it's needed for both. 
 ****
OUTPUT_SUBQ
    LEA         STR_SUBQ,A1					* Loads the string for SUBQ for output
    BRA         UTILITY_ADDQ_SUBQ			* Branches to the utility function

******
 * The UTILITY_ADDQ_SUBQ subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * helping the output of ADDQ and SUBQ
 ****
UTILITY_ADDQ_SUBQ
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1		* Prints the string loaded in A1
    JSR         SUFFIX_OUTPUT_JMP			* Jumps to the SUFFIX_OUTPUT_JMP to determine
											* the appropriate suffix for print out.
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space			* Invokes subroutine to print a space 
    JSR         OUTPUT_EA_IMMI_DATA_SYMBOL	* Outputs the '#' symbol	* Outputs the '#' symbol
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the 
											* Destination Source Variable. In this case now the
											* byte and word sizes will be printing out 4 spaces 
											* whereas a long size will print out 5 spaces.
    CMP         #0, DEST_HOLDER             * Since DEST_VAR will be 000 for 8 we need to check handle print 8
    BEQ         UTILITY_SUBQ_HANDLER        * In this instance, branch to another helper to move 8 directly to the var.
    MOVE.W      DEST_HOLDER,UTILITY_VAR     * Save the value to output from print register number
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space 
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.		* This subroutine will output the data
											* data mode source.
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK 
											* subroutine to see if a new screen
											* of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.				* Branch to the subroutine for 
										    * checking the next word and parsing
											* it to see if it's an OpCode.
    RTS										* Return to the subroutine

******
 * The UTILITY_SUBQ_HANDLER subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * helping the output of ADDQ and SUBQ
 * solely in the case of outputting data 
 * for register 8 for SUBQ and ADDQ 
 ****
UTILITY_SUBQ_HANDLER                        
    MOVE.W      #8, UTILITY_VAR				* In this instance, branch to another helper to move 8 directly to the var.
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space 
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.		* This subroutine will output the data
											* data mode source.
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK 
											* subroutine to see if a new screen
											* of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.				* Branch to the subroutine for 
										    * checking the next word and parsing
											* it to see if it's an OpCode.
    RTS										* Return to the subroutine

******
 * The OUTPUT_CMP subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the CMP instruction 
 ****
OUTPUT_CMP
    LEA         STR_CMP,A1					* Loads the string for CMP for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1		* Prints the string loaded in A1
    JSR         SUFFIX_OUTPUT_JMP			* Jumps to the SUFFIX_OUTPUT_JMP to determine
											* the appropriate suffix for print out
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space			* Invokes subroutine to print a space 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 			* This subroutine will update the Destination Source Variable. 
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.		* This subroutine will output the data mode source.
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space			* Invokes subroutine to print a space
    JSR         OUTPUT_DATA_REG             * This instruction will automatically jump to 
											* the OUTPUT_DATA_REG subroutine because CMP 
											* can only use Data register.
    MOVE.W      DEST_HOLDER,UTILITY_VAR		* Save the value to output from print register number
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8			* Output the data from 1-8
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.				
    RTS										* Return to the subroutine

******
 * The OUTPUT_MOVEQ subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the MOVEQ instruction 
 ****
OUTPUT_MOVEQ
    LEA         STR_MOVEQ,A1				* Loads the string for MOVEQ for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1		* Prints the string loaded in A1
    JSR         OUTPUT_LONG_SIZE_USUAL      * Since MOVEQ can only use the long suffix output it
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D1 * Copy the current opcode to D1 for storage 
    JSR         OUTPUT_EA_IMMI_DATA_SYMBOL	* Outputs the '#' symbol	
    JSR         OUTPUT_HEX_SYMBOL			* Invokes subroutine to print '$'
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    LSL         #8,D3						* Get rid of the Most-Sig 8-bits
    LSR         #8,D3						* Return to original position. 
    MOVE.W      D3, CURRENT_FOUR_NIBBLES_VAR * The last 8-bits represent the data to output
    JSR         HEX_TO_ASCII_CHANGER         * Output the 8 bit data field
    MOVE.W      D1, CURRENT_FOUR_NIBBLES_VAR * Reset the CURRENT_FOUR_NIBBLES  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         OUTPUT_DATA_REG             * Since MOVEQ can only use Data Register just output Data reg.
    MOVE.W      DEST_HOLDER, UTILITY_VAR    * Store the register number to output
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.

******
 * The OUTPUT_SUBA subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the SUBA instruction 
 ****
OUTPUT_SUBA
    LEA         STR_SUBA,A1					* Loads the string for SUBA for output
    BRA         UTILITY_SUBA_ADDA_HANDLER	* Branch to the utility method. 

******
 * The OUTPUT_ADDA subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the ADDA instruction 
 ****
OUTPUT_ADDA
    LEA         STR_ADDA,A1					* Loads the string for ADDA for output
    BRA         UTILITY_SUBA_ADDA_HANDLER	* Branch to the utility method. 

******
 * The UTILITY_SUBA_ADDA_HANDLER subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * complenting the OUTPUT_SUBA and
 * OUTPUT_ADDA routines. 
 ****
UTILITY_SUBA_ADDA_HANDLER
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         STORE_SECOND_NIBBLE_IN_D3   * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    LSL         #8,D3                       * Performs shifts to get specific bit for testing size for ADDA and SUBA
    LSL         #7,D3
    LSR         #7,D3
    LSR         #8,D3
    ADD         #1,D3                       * We add one because the bit remaining is either 
											* 0 for word or 1 for long. By adding 1 
											* the bit there will turn to 01 and 10, 
											* which represent word and long for normal size nomenclature
    JSR         SPECIAL_SUFFIX_OUTPUT_JMP   * Branch to output either .W or .L specifically
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    JSR         OUTPUT_ADDR_REG             * This instruction will automatically jump to the OUTPUT_ADDR_REG subroutine because LEA can only use Address register.
    MOVE.W      DEST_HOLDER, UTILITY_VAR    * Moving DEST_HOLDER to UTILITY_VAR will save print out number for Address register
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
    RTS

******
 * The OR_OUTPUT subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the OR instruction. 
 ****
OR_OUTPUT
    LEA         STR_OR,A1					* Loads the string for OR for output
    BRA         UTILITY_ADD_SUB_HANDLER     * Since OR has a similar structure use the ADD_SUB helper

******
 * The ADD_OUTPUT subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the AND instruction. 
 ****
ADD_OUTPUT           
    LEA         STR_ADD,A1					* Loads the string for AND for output
    BRA         UTILITY_ADD_SUB_HANDLER		* Since AND has a similar structure use the ADD_SUB helper

******
 * The AND_OUTPUT subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the ADD instruction. 
 ****
AND_OUTPUT
 LEA         STR_AND,A1						* Loads the string for ADD for output
 BRA         UTILITY_ADD_SUB_HANDLER  		* Since ADD has a similar structure use the ADD_SUB helper

******
 * The OUTPUT_SUB subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the SUB instruction. 
 ****
OUTPUT_SUB
    LEA         STR_SUB,A1					* Loads the string for SUB for output
    BRA         UTILITY_ADD_SUB_HANDLER		* Since SUB has a similar structure use the ADD_SUB helper


******
 * The UTILITY_ADD_SUB_HANDLER subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * assisting in the function of the SUB and ADD
 * subroutines. It should be noted that the 
 * SUB function will always be odd and have 
 * the Dn registers in the front. 
 * 
 * As a result this function will check 
 * the source mode bits and compare it 
 * with #%000. This is the few instance
 * where source and destination are in 
 * the correct bit positions 
 * 
 * This method will be invokoed when 
 * the source and destination are both
 * data registers. 
 ****
UTILITY_ADD_SUB_HANDLER
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         SUFFIX_OUTPUT_JMP
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    CMP         #0, SRC_MODE_HOLDER			* Checks to see if SRC_MODE_HOLDER is %000
    BNE         UTILITY_SUB_HANDLER         * If it's not then branch to the subroutine for unusual source modes
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    JSR         OUTPUT_DATA_REG				* Output the data registers 
    MOVE.W      DEST_HOLDER, UTILITY_VAR	* Move the DEST_HOLDER to the UTILITY_VAR for manipulation 
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
    RTS
    
******
 * The UTILITY_SUB_HANDLER subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * assisting in the function of the SUB and ADD
 * subroutines. In this case it will
 * assist cases involving the data register.
 *
 * It should be noted that data register 
 * info is by convention the first 3 bits in the second nibble. 
 * However, it can serve as the source or destination.
 * 
 * This subroutine will be invoked when
 * SUB and ADD don't have both a data source 
 * data destination for registers. 
 ****
UTILITY_SUB_HANDLER
    CLR         D7
    JSR         STORE_FOURTH_NIBBLE_IN_D3
    MOVE.W      D3,D7
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.     
											* Need for a swap places for output
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    MOVE.W      DEST_HOLDER,D3				* Copy the DEST_HOLDER to D3 for swapping
    MOVE.W      SRC_HOLDER,DEST_HOLDER		* Move the source holder to destination holder
    MOVE.W      D3,SRC_HOLDER				* Move the old destination holder to the source holder. 
    MOVE.W      DEST_MODE_VAR,D3			* Copy the DEST_MODE_VAR to D3 
    MOVE.W      SRC_MODE_HOLDER,DEST_MODE_VAR	* Reset the DEST_MODE_VAR 
    MOVE.W      D3,SRC_MODE_HOLDER				* Bring the DEST_MODE_VAR to SRC_MODE_HELPER
    MOVE.W      SRC_MODE_HOLDER, D3				* Reset the D3 to have the DEST_MODE_VAR 
    MOVE.W      SRC_HOLDER, UTILITY_VAR         * Save the variable to print out from register
    LSR         #2,D3							* Get rid of 2 Least Sig bits 
    CMP         #0,D3                           * All that should be left is the direction bits that show which order to output
    BEQ         REG_TO_MEM_SUB_UTILITY		* Invokes method that outputs info from registers to the memory 
    JSR         REG_MODE_000                * Need to find a way to switch the places
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    JSR         OUTPUT_DATA_MODE_DEST		* This method will output the data stored in the 12-7 bits
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
    RTS

******
 * The REG_TO_MEM_SUB_UTILITY subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * assisting in the assisting in the
 * output of information from the 
 * register to the memory. 
 ****
REG_TO_MEM_SUB_UTILITY
    MOVE.W      DEST_HOLDER, UTILITY_VAR
    JSR         OUTPUT_DATA_MODE_DEST		* This method will output the data stored in the 12-7 bits
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    CMP         #$C,D7
    BNE         REG_TO_MEM_SUB_NON_IMM
    CLR         D7
    MOVE.W      DEST_HOLDER, UTILITY_VAR
    BRA         REG_TO_MEM_SUB_NEXT
    
REG_TO_MEM_SUB_NON_IMM
    CLR         D7
    MOVE.W      SRC_HOLDER, UTILITY_VAR		* Save the variable to print out from register
REG_TO_MEM_SUB_NEXT    
    JSR         REG_MODE_000				* Need to find a way to switch the places
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
    RTS
    
    
    
******
 * The BRANCH_BYTE_SIZE_BRANCHCODE subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the when BRA, B(cc) size is ' .B '
 ****
BRANCH_BYTE_SIZE_BRANCHCODE        
    JSR         OUTPUT_BYTE_SUFFIX       * If it's not any of the above then it's '.B' size. Reusing OUTPUT_WORD_SUFFIX to print the '.W'                        
    JSR         OUTPUT_HEX_SYMBOL		 * Print out the '$' symbol for the address 
    MOVE.L      A2,D4                    * Save the current address we are at
    BRA         NEGATIVE_DISPLACEMENT_CHECK   * Check if the displacement on last two nibbles is negative 

******
 * The NEGATIVE_DISPLACEMENT_CHECK subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * checking if THIRD_AND_FOURTH_NIBBLE are negative
 ****
NEGATIVE_DISPLACEMENT_CHECK
    CMP.W       #$FF,D3                    * If it's greater than #$FF then it's invalid
    BGT         INVALID_OPCODE
    CMP.W       #$80,D3                    * Check if it's less than #$80 if it is then it's not negative
    BLT         ADD_THE_BRANCH_DISPLACEMENT
    CMP.W       #$80,D3                    * Check if it's greater than #$80 if it is then it's NEGATIVE 
    BGE         HANDLING_NEGATIVE_DISPLACEMENT
        
******
 * The NEGATIVE_DISPLACEMENT_CHECK subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * handling when 8-bit displacement is negative
 * or 80 to FF
 ****
HANDLING_NEGATIVE_DISPLACEMENT
    NOT.B       D3       * Ones complement
    ADDQ.W      #1,D3    * Make it a twos complement
    SUB         D3,D4    * Current address + displacement => address we are suppose to jump to
    MOVE.L      D4, CURRENT_FOUR_NIBBLES_VAR    * Prepare the address to print out in hex
    JSR         HEX_TO_ASCII_CHANGER_FULLSIZE	* Output the 8 bit data field
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode. 

******
 * The ADD_THE_BRANCH_DISPLACEMENT subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * printing the address for normal .B 
 * displacement for the BRA and B(cc)
 ****
ADD_THE_BRANCH_DISPLACEMENT
    ADD         D3,D4                          * Current address + displacement => address we are suppose to jump to
    MOVE.L      D4, CURRENT_FOUR_NIBBLES_VAR   * Prepare the address to print out in hex
    JSR         HEX_TO_ASCII_CHANGER_FULLSIZE  * Output the 8 bit data field
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
        
******
 * The BRANCH_WORD_SIZE_BRANCHCODE subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the when BRA, B(cc) size is ' .W '
 ****
BRANCH_WORD_SIZE_BRANCHCODE
    JSR         OUTPUT_WORD_SUFFIX             * If it's not any of the above then it's '.B' size. Reusing OUTPUT_WORD_SUFFIX to print the '.W'                        
    JSR         OUTPUT_HEX_SYMBOL				* Invokes subroutine to print '$'              * Print out the '$' symbol for the address 
    MOVE.L      A2,D4                          * Save the current address we are at
    JSR         D3_GET_NEXT_FOUR_NIB           * Get the displacement we are suppose to branch to
    ADD         D3,D4                          * Current address + displacement => address we are suppose to jump to
    MOVE.L      D4, CURRENT_FOUR_NIBBLES_VAR   * Prepare the address to print out in hex
    JSR         HEX_TO_ASCII_CHANGER_FULLSIZE  * Output the 8 bit data field
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
        
******
 * The BRANCH_LONG_SIZE_BRANCHCODE subroutine: 
 * --------------------------------------
 * This subroutine is responsible for 
 * outputting the when BRA, B(cc) size is ' .L '
 ****
BRANCH_LONG_SIZE_BRANCHCODE
    JSR         OUTPUT_WORD_SUFFIX       * If it's not any of the above then it's '.B' size. Reusing OUTPUT_WORD_SUFFIX to print the '.W'                        
    JSR         OUTPUT_HEX_SYMBOL				* Invokes subroutine to print '$'        * Print out the '$' symbol for the address 
    MOVE.L      A2,D4                    * Save the current address we are at
    JSR         D3_GET_NEXT_FOUR_NIB     * Get the first word displacement we are suppose to branch to
    ADD         D3,D4                    * Current address + displacement => address we are suppose to jump to
    JSR         D3_GET_NEXT_FOUR_NIB     * Get the second word displacement we are suppose to branch to
    ADD         D3,D4                    * Current address + displacement => address we are suppose to jump to
    MOVE.L      D4, CURRENT_FOUR_NIBBLES_VAR  * Prepare the address to print out in hex
    JSR         HEX_TO_ASCII_CHANGER_FULLSIZE * Output the 8 bit data field
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
        
*******
 * The CHECK_BRANCH_SIZE_SUFFIX subroutine: 
 * --------------------------------------
 * Control flow depending on size
 * of the BRA or B(cc) it will
 * check the last 8-bits of the
 * first word to see what kinda 
 * branch it is.  
 ****
CHECK_BRANCH_SIZE_SUFFIX
	MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.    
											* Have to bring back full word before using D3_KEEP_THIRD_FOURTH_NIB
	JSR         D3_KEEP_THIRD_FOURTH_NIB      * Alter D3 to only have last 8-bits this will be used for finding the size
	CMP         #%00000000,D3                 * This is .W size since it will have last two nibbles be '00' to signal '.W'
	BEQ         BRANCH_WORD_SIZE_BRANCHCODE   * If it is .W size then branch to the subroutine that handles word size.
	CMP         #%11111111,D3                 * This is .L size since it will have last two nibbles be 'FF' to signal '.L'
	BEQ         BRANCH_LONG_SIZE_BRANCHCODE   * If it is .L size then branch to the subroutine that handles long size.
	BRA         BRANCH_BYTE_SIZE_BRANCHCODE   * If it isn't .L or .W then it's .B size, so we'll branch to that
 
*******
 * The OUTPUT_BRA subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting the BRA instruction 
 * then shifting control depending 
 * on the size of the BRA. 
 ****
OUTPUT_BRA
    LEA         STR_BRA,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         CHECK_BRANCH_SIZE_SUFFIX

*******
 * The BSR_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting the BSR instruction 
 * then shifting control depending 
 * on the size of the BSR. 
 ****
BSR_OUTPUT
    LEA         STR_BSR,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         CHECK_BRANCH_SIZE_SUFFIX

*******
 * The BEQ_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting the BEQ instruction 
 * then shifting control depending 
 * on the size of the BEQ. 
 ****
BEQ_OUTPUT
    LEA         STR_BEQ,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         CHECK_BRANCH_SIZE_SUFFIX

*******
 * The BGT_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting the BGT instruction 
 * then shifting control depending 
 * on the size of the BGT. 
 ****
BGT_OUTPUT
    LEA         STR_BGT,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         CHECK_BRANCH_SIZE_SUFFIX

*******
 * The BLE_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting the BLE instruction 
 * then shifting control depending 
 * on the size of the BLE. 
 ****
BLE_OUTPUT
    LEA         STR_BLE,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         CHECK_BRANCH_SIZE_SUFFIX

*******
 * The LOG_SHIFT_MEM_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting for the logical shift
 * when there is only one operand 
 * for memory <ea> 
 ****
LOG_SHIFT_MEM_OUTPUT
    LEA         STR_LS,A1					* Loads the string for 'LS'
    JSR         UTILITY_ASD_LSD_ROD_SHIFT	* Invokes the utility function for ASD LSD and ROD shifts	
    RTS

*******
 * The ASX_SHIFT_MEM_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting for the arithmetic shift
 * when there is only one operand 
 * for memory <ea> 
 ****
ASX_SHIFT_MEM_OUTPUT
    LEA         STR_AS,A1					* Loads the string for 'AS'
    JSR         UTILITY_ASD_LSD_ROD_SHIFT	* Invokes the utility function for ASD LSD and ROD shifts
    RTS

***
* Helper method for ASd, LSd, ROd
***
UTILITY_ASD_LSD_ROD_SHIFT
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    LEA         JMPTABLE_R_OR_L,A6          * Print the direction, left or right
	MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         STORE_SECOND_NIBBLE_IN_D3   * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    LSL         #8,D3
    LSL         #7,D3
    LSR         #7,D3
    LSR         #8,D3
    MULU        #6,D3
    JSR         0(A6,D3)                    * Jumps to the subroutine with appropriate offset to determine output left or right
    JSR         OUTPUT_WORD_SIZE_USUAL		* Jumps to the subroutine for handling word size in general instances. 
    MOVE.W      SRC_HOLDER, UTILITY_VAR     * Save the variable of register number to print out from register
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
    RTS

*******
 * The ROD_MEM_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting for the rotation
 * when there is only one operand 
 * for memory <ea> 
 ****
ROD_MEM_OUTPUT
    LEA         STR_RO,A1					* Loads the string for 'RO'
    JSR         UTILITY_ASD_LSD_ROD_SHIFT	* Invokes the utility function for ASD LSD and ROD shifts
    RTS

*******
 * The ASD_LSD_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting for the ASd and LSd when
 * there are unusual EA such as Dx, Dy 
 * for ASR or even ASR #<data>, Dy 
 *
 * Thankfully the first bit of the last
 * nibble can be used to determine 
 * which case to follow 
 ****
ASD_LSD_OUTPUT                                
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         STORE_FOURTH_NIBBLE_IN_D3	* This instruction is a jump to a
											* subroutine designed specifically for 
											* getting the second nibble which for our
											* purposes in the HEX_TO_ASCII_CHANGER 
											* is the second right most HEX character 
											* or value that must be converted
    LSR         #3,D3						* Gets rid of all bit last bit 
    CMP         #0,D3						* Checks to see if it's 0 or 1
    BEQ         ASD_OUTPUT                  * If the LSB is 0 then OpCode is ASd
    BRA         LSD_OUTPUT                  * If it's not then it's LSd 
    RTS

*******
 * The ASD_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting for the ASd for unusual
 * EA cases such as:
 *
 * ASR Dx, Dy
 * ASR #<data>, Dy 
 ****
ASD_OUTPUT
    LEA         STR_AS,A1					* Loads the string for 'AS'
    JSR         UTILITY_HELPER_ASD_LSD_ROD	* Invokes the helper for ASd, LSd, and ROd instructions that have source and destination as two operands	
    RTS

*******
 * The LSD_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting for the LSd for unusual
 * EA cases such as:
 *
 * LSR Dx, Dy
 * LSR #<data>, Dy 
 ****
LSD_OUTPUT
    LEA         STR_LS,A1					* Loads the string for 'LS'
    JSR         UTILITY_HELPER_ASD_LSD_ROD	* Invokes the helper for ASd, LSd, and ROd instructions that have source and destination as two operands
    RTS

*******
 * The ROX_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting for the ROR for unusual
 * EA cases such as:
 *
 * ROR Dx, Dy
 * ROR #<data>, Dy 
 ****
ROX_OUTPUT
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         STORE_FOURTH_NIBBLE_IN_D3	* This instruction is a jump to a
											* subroutine designed specifically for 
											* getting the second nibble which for our
											* purposes in the HEX_TO_ASCII_CHANGER 
											* is the second right most HEX character 
											* or value that must be converted
    LSR         #3,D3						* Gets rid of all bit last third bit
    CMP         #1,D3						* Checks to see if it's 1 since ROd only works if it has 1 as the fourth nibbles MSB
    BNE         INVALID_OPCODE              * Branch to deal with invalid case 
    LEA         STR_RO,A1					* Loads the string for 'RO'
    JSR         UTILITY_HELPER_ASD_LSD_ROD	* Invokes the helper for ASd, LSd, and ROd instructions that have source and destination as two operands
    RTS

*******
 * The UTILITY_HELPER_ASD_LSD_ROD subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * handling cases for ASd, LSd, and ROd 
 * where there are source and destination operands. 
 ****
UTILITY_HELPER_ASD_LSD_ROD   
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    LEA         JMPTABLE_R_OR_L,A6          * Print the direction, left or right
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         STORE_SECOND_NIBBLE_IN_D3   * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    LSL         #8,D3
    LSL         #7,D3
    LSR         #8,D3
    LSR         #7,D3						* These shifts leave only LSB 
    MULU        #6,D3						* Multiply Unsigned to use as displacement 
    JSR         0(A6,D3)                    * Print out left or right
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         SUFFIX_OUTPUT_JMP           * Print out .B, .W or .L
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.   
											* Copy done to find out if it's an immediate or register rotation
    JSR         STORE_THIRD_NIBBLE_IN_D3	* This instruction is a jump to a
											* subroutine designed specifically for 
											* getting the second nibble which for our
											* purposes in the HEX_TO_ASCII_CHANGER 
											* is the second right most HEX character 
											* or value that must be converted
    LSL         #8,D3
    LSL         #6,D3
    LSR         #8,D3
    LSR         #7,D3                       * Now the third bit will be at the last position
    LEA         JMPTABLE_SHIFT_OP_IMMI_OR_REG,A6	* Load the Shift OpCode Immediate or Register check subroutine
    MULU        #6,D3						* Multiply the third bit by #6 unsigned to use as offset 
    JSR         0(A6,D3)					* Determine if it's an immediate or register 
    JSR         OUTPUT_DATA_REG				* Output the data registers				
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    MOVE.W      SRC_HOLDER,UTILITY_VAR       * Save the register number to print out
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
    RTS

*******
 * The OPCODE_MOVE_UTILITY subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * changing the flow of the program 
 * to decide if it's a MOVEA or MOVE to 
 * be printed out. 
 *
 * It will check the destination mode bits
 * to decide. 
 ****
OPCODE_MOVE_UTILITY
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    CMP         #%001, DEST_MODE_VAR		* If it's #%001 then it's MOVEA 
    BEQ         MOVEA_OUTPUT
    BRA         OUTPUT_MOVE					* It's MOVE otherwise 
    RTS

*******
 * The MOVEA_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting MOVEA it will 
 * use a utility method for 
 * the back end. 
 ****
MOVEA_OUTPUT
    LEA         STR_MOVEA,A1
    JSR         UTILITY_MOVE_TWO_OP

*******
 * The OUTPUT_MOVE subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting MOVE it will 
 * use a utility method for 
 * the back end. 
 ****
OUTPUT_MOVE
    LEA         STR_MOVE,A1
    JSR         UTILITY_MOVE_TWO_OP

*******
 * The UTILITY_MOVE_TWO_OP subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * assisting the MOVE and MOVEA output
 * subroutines. In there other outputs. 
 ****
UTILITY_MOVE_TWO_OP
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    LEA         OUTPUT_SIZE_OF_MOVE_JMPTABLE,A6  * Load address of jump tables for determining size of MOVE commands
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         STORE_FIRST_NIBBLE_IN_D3	* This instruction is a jump to a
											* subroutine designed specifically for 
											* getting the first nibble which for our
											* purposes in the HEX_TO_ASCII_CHANGER 
											* is the left most HEX character or value
											* that must be converted
    MULU        #6,D3						* Multiply unsigned by D3 to use it as an offset for JSR 
    JSR         0(A6,D3)					* Jumps to subroutine for the size with offset. 
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    JSR         OUTPUT_DATA_MODE_DEST		* This method will output the data stored in the 12-7 bits
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
    RTS

*******
 * The MOVEM_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting the MOVEM instruction 
 ****
MOVEM_OUTPUT
   LEA          STR_MOVEM,A1
   JSR          UTILITY_MOVEM_HANDLER
 
*******
 * The UTILITY_MOVEM_HANDLER subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting the MOVEM size of the MOVEM
 * instruction 
 ****
UTILITY_MOVEM_HANDLER
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    CMP         #%011,DEST_MODE_VAR
    BEQ         MOVEM_LONG_SUFFIX
    CMP         #%010,DEST_MODE_VAR
    BEQ         MOVEM_WORD_SUFFIX
    BRA         INVALID_OPCODE
    RTS

*******
 * The UTILITY_MOVEM_HANDLER subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * checking if MOVEM is going to memory
 * or to register
 ****
MOVEM_NEXT
    CMP         #%100,DEST_HOLDER
    BEQ         MOVEM_TO_MEM
    CMP         #%110,DEST_HOLDER
    BEQ         MOVEM_TO_REG
    BRA         INVALID_OPCODE

MOVEM_TO_REG
    JSR         STORE_THIRD_NIBBLE_IN_D3
    CMP         #$B,D3
    BEQ         MOVEM_TO_REG_IMM
    CMP         #$F,D3
    BEQ         MOVEM_TO_REG_IMM
    BRA         MOVEM_TO_REG_NON_IMM
    
MOVEM_TO_REG_IMM
    JSR         D3_GET_NEXT_FOUR_NIB
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D7
    MOVE.W      D7,D3
    JSR         OUTPUT_DATA_MODE_SOURCE
    MOVE.W      D7,D3
    BRA         MOVEM_TO_REG_CONT

MOVEM_TO_REG_NON_IMM
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.
    JSR         D3_GET_NEXT_FOUR_NIB
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.        
MOVEM_TO_REG_CONT
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    MOVE.W      #0,D7
    JSR         REG_15       
    MOVE.W      #0,D7
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
    RTS  


***
* Reg Handler
***
REG_15    
    BTST        #15,D3
    BEQ         REG_14
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_7
    MOVE.W      #1,D7
REG_14
    BTST        #14,D3
    BEQ         REG_13
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_6
    MOVE.W      #1,D7
REG_13
    BTST        #13,D3
    BEQ         REG_12
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_5
    MOVE.W      #1,D7
REG_12
    BTST        #12,D3
    BEQ         REG_11
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_4
    MOVE.W      #1,D7
REG_11
    BTST        #11,D3
    BEQ         REG_10
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_3
    MOVE.W      #1,D7
REG_10
    BTST        #10,D3
    BEQ         REG_9
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_2
    MOVE.W      #1,D7
REG_9
    BTST        #9,D3
    BEQ         REG_8
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_1
    MOVE.W      #1,D7
REG_8
    BTST        #8,D3
    BEQ         REG_7
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_0
    MOVE.W      #1,D7
REG_7
    BTST        #7,D3
    BEQ         REG_6
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_7
    MOVE.W      #1,D7
REG_6
    BTST        #6,D3
    BEQ         REG_5
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_6
    MOVE.W      #1,D7
REG_5
    BTST        #5,D3
    BEQ         REG_4
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_5
    MOVE.W      #1,D7
REG_4
    BTST        #4,D3
    BEQ         REG_3
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_4
    MOVE.W      #1,D7
REG_3
    BTST        #3,D3
    BEQ         REG_2
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_3
    MOVE.W      #1,D7
REG_2
    BTST        #2,D3
    BEQ         REG_1
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_2
    MOVE.W      #1,D7
REG_1
    BTST        #1,D3
    BEQ         REG_0
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_1
    MOVE.W      #1,D7
REG_0
    BTST        #0,D3
    BEQ         REG_END
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_0
    MOVE.W      #1,D7
REG_END   
    RTS




MOVEM_TO_MEM
    JSR         STORE_THIRD_NIBBLE_IN_D3
    MOVE.W      D3,D7
    JSR         D3_GET_NEXT_FOUR_NIB
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    CMP         #$9,D7
    BEQ         IMM_CASE
    CMP         #$D,D7
    BEQ         IMM_CASE
    CMP         #$B,D7
    BEQ         IMM_CASE
    CMP         #$F,D7
    BEQ         IMM_CASE
    BRA         NON_IMM_CASE
TO_MEM_CONT
    MOVE.W      #0,D7
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
    RTS  

IMM_CASE
    MOVE.W      #0,D7
    JSR         REG_15
    BRA         TO_MEM_CONT
    
NON_IMM_CASE
    MOVE.W      #0,D7
    JSR         MEM_15
    BRA         TO_MEM_CONT
    
***
* Mem Handler
***
MEM_15    
    BTST        #15,D3
    BEQ         MEM_14
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_0
    MOVE.W      #1,D7
MEM_14
    BTST        #14,D3
    BEQ         MEM_13
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_1
    MOVE.W      #1,D7
MEM_13
    BTST        #13,D3
    BEQ         MEM_12
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_2
    MOVE.W      #1,D7
MEM_12
    BTST        #12,D3
    BEQ         MEM_11
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_3
    MOVE.W      #1,D7
MEM_11
    BTST        #11,D3
    BEQ         MEM_10
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_4
    MOVE.W      #1,D7
MEM_10
    BTST        #10,D3
    BEQ         MEM_9
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_5
    MOVE.W      #1,D7
MEM_9
    BTST        #9,D3
    BEQ         MEM_8
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_6
    MOVE.W      #1,D7
MEM_8
    BTST        #8,D3
    BEQ         MEM_7
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_7
    MOVE.W      #1,D7
MEM_7
    BTST        #7,D3
    BEQ         MEM_6
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_0
    MOVE.W      #1,D7
MEM_6
    BTST        #6,D3
    BEQ         MEM_5
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_1
    MOVE.W      #1,D7
MEM_5
    BTST        #5,D3
    BEQ         MEM_4
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_2
    MOVE.W      #1,D7
MEM_4
    BTST        #4,D3
    BEQ         MEM_3
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_3
    MOVE.W      #1,D7
MEM_3
    BTST        #3,D3
    BEQ         MEM_2
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_4
    MOVE.W      #1,D7
MEM_2
    BTST        #2,D3
    BEQ         MEM_1
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_5
    MOVE.W      #1,D7
MEM_1
    BTST        #1,D3
    BEQ         MEM_0
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_6
    MOVE.W      #1,D7
MEM_0
    BTST        #0,D3
    BEQ         MEM_END
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_7
    MOVE.W      #1,D7
MEM_END 
    RTS

***
* Movem slashes
***
PRINT_SLASH
        CMP         #1,D7
        BNE         NO_SLASH
        LEA         MOVEM_SLASH,A1
        JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
NO_SLASH
        RTS

*******
 * The WHOLE_MESSAGE_OUTPUT subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * printing out the message stored 
 * in the A1 address register. 
 ****
WHOLE_MESSAGE_OUTPUT
    MOVE.B      #14,D0
    TRAP        #15
    RTS

*******
 * The OUTPUT_DATA_MODE_SOURCE subroutine: 
 * --------------------------------------
 * This function is responsible for 
 * outputting the data stored in the 
 * last six bits of the OpCode word. 
 *
 * These may include the Destination variable
 * the destination mode, the source mode and 
 * even the source variable. 
 *
 * It should print out Dn, An, (An) 
 * based on what mode it is. 
 ****
OUTPUT_DATA_MODE_SOURCE         
    LEA         JMPTABLE_FINDING_REG_MODE,A6	* Loads the address of the jump table for determining register mode 
    MOVE.W      SRC_HOLDER, UTILITY_VAR			* Stores the SRC_HOLDER in the UTILITY_VAR for arithmetic 
    MOVE        SRC_MODE_HOLDER,D3				* Store the SRC_MODE_HOLDER in D3 for arithmetic 
    MULU        #6,D3							* Multiply unsigned by D3 to use it as an offset for JSR		
    JSR         0(A6,D3)       					* Go to the jump table with appropraite offset to find the source mode
    RTS

*****
 * The OUTPUT_DATA_MODE_DEST subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * data stored in the 12-7 bits of the OpCode. 
 * This data can be Destination variable, Destination mode
 * Source Mode, and Source variable. 
 ***
OUTPUT_DATA_MODE_DEST
    LEA         JMPTABLE_FINDING_REG_MODE,A6	* Loads the address of the jump table for determining register mode 
    MOVE.W      DEST_HOLDER, UTILITY_VAR        * Used in process of finding which type of register to output
    MOVE.W      DEST_MODE_VAR,D3			* Stores the DEST_MODE_VAR in D3 for arithmetic 
    MULU        #6,D3						* Multiply unsigned by D3 to use it as an offset for JSR
    JSR         0(A6,D3)					* Go to the jump table with appropraite offset to find the destination mode
    RTS

*****
 * The OUTPUT_ADDR_LOC subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * current address that the disassembler is disassembling
 * 
 * Format is: 00XX YYYY as the current address location 
 ***
OUTPUT_ADDR_LOC
    MOVE.L      A2,D5 							* Store the current address that the disassembler is at					
    MOVE.L      D5,CURRENT_FOUR_NIBBLES_VAR     * Copy the long address in its entirety 
    JSR         HEX_TO_ASCII_CHANGER			* Output the 8 bit data field
    MOVE.W      A2,D5							* Store the current address that the disassembler is at
    MOVE.W      D5,CURRENT_FOUR_NIBBLES_VAR		* Copy the long address in its entirety 
    JSR         HEX_TO_ASCII_CHANGER		* Output the 8 bit data field
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

*****
 * The OUTPUT_COMMA subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * outputting a comma to the console. ','  
 ***
OUTPUT_COMMA
    LEA         STR_COMMA,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

*****
 * The OUTPUT_ADDR_REG subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * outputting an 'A' to the console.
 ***
OUTPUT_ADDR_REG
    LEA         STR_ADDR_REG,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

*****
 * The OUTPUT_DATA_REG subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * outputting an 'D' to the console.
 ***
OUTPUT_DATA_REG
    LEA         STR_DATA_REG,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

*****
 * The OUTPUT_OPEN_BRACKET subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * outputting an '(' to the console.
 ***
OUTPUT_OPEN_BRACKET
    LEA         STR_OPEN_BRACK,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

*****
 * The OUTPUT_CLOSE_BRACKET subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * outputting an ')' to the console.
 ***
OUTPUT_CLOSE_BRACKET
    LEA         STR_CLOSE_BRACK,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

*****
 * The OUTPUT_PLUS_SIGN subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * outputting an '+' to the console.
 ***
OUTPUT_PLUS_SIGN
    LEA         STR_PLUS,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

*****
 * The OUTPUT_MINUS_SIGN subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * outputting an '-' to the console.
 ***
OUTPUT_MINUS_SIGN
    LEA         STR_MINUS,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

*****
 * The OUTPUT_HEX_SYMBOL subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * outputting an '$' to the console.
 ***
OUTPUT_HEX_SYMBOL
    LEA         STR_HEX_SYMBOL,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

*****
 * The OUTPUT_EMPTY_SPACE subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * outputting an ' ' to the console.
 ***
OUTPUT_EMPTY_SPACE
    LEA         STR_SPACE,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

*****
 * The OUTPUT_EA_IMMI_DATA_SYMBOL subroutine:
 * ---------------------
 * This subroutine is responsible for outputting the 
 * outputting an '#' to the console.
 ***
OUTPUT_EA_IMMI_DATA_SYMBOL
    LEA         EA_IMMI_DATA_SYMBOL,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

********************************************************************************
 * This section of the disassembler is focused on 
 * manipulating the bits stored in D3 
 * As such there will be many helper methods here. 
 *******************************************************************************

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
        

*****
 * The D3_GET_NEXT_TWO_NIB subroutine:
 * ---------------------
 * This subroutine is responsible for moving the 
 * current address of the assembler by 
 * one byte or about 2 nibbles and copying 
 * it to the D3 register and CURRENT_TWO_NIBBLES_VAR
 ***
D3_GET_NEXT_TWO_NIB
    MOVE.B      (A2)+,D3                            * Move to the next byte in the address
    MOVE.B      D3, CURRENT_TWO_NIBBLES_VAR			* Move the value to CURRENT_TWO_NIBBLES_VAR
    RTS

*****
 * The D3_STORE_NORM_SIZE subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * finding the size of the OpCode and 
 * done for most cases where this info
 * is stored in the first 2 bits of the
 * third nibble of the opcode. 
 ***
D3_STORE_NORM_SIZE
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    MOVE.W      DEST_MODE_VAR,D3			* Stores the DEST_MODE_VAR in D3 for arithmetic 	
    LSL         #8,D3
    LSL         #6,D3
    LSR         #8,D3
    LSR         #6,D3
    RTS

EA_IMMI_D3_STORE_NORM_SIZE_VER
	JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    MOVE.W      DEST_MODE_VAR,D3			* Stores the DEST_MODE_VAR in D3 for arithmetic 	
	RTS
	
********************************************************************************
 * This section of the disassembler is focused on 
 * finding out what opcode to output and what data to output. 
 *******************************************************************************

*****
 * The UPDATE_DEST_SRC_VAR subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * finding the right source and destination 
 * registers and modes.
 *
 * The Destination holder, destination mode, 
 * source mode and source variable will be updated. 
 ***
UPDATE_DEST_SRC_VAR
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    LSL         #4,D3                       * Get rid of left most nibble 
    LSR         #4,D3                       * Manipulate D3 so that we can find 
											* the destination mode, mode, source. 
											* This part will focus on getting the destination first
    LSR         #8,D3                       * After the manipulations the D3 holds the destination
    LSR         #1,D3
    MOVE.W      D3,DEST_HOLDER				* Copy the Destination to the DEST_HOLDER
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.          
											* Now manipulate D3 to get the destination mode
    LSL         #7,D3
    LSR         #7,D3
    LSR         #6,D3
    MOVE.W      D3,DEST_MODE_VAR			* Now has DEST_MODE_VAR so copy to it
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.          
											* Now manipulate D3 to get the source mode
    LSL         #8,D3
    LSL         #2,D3
    LSR         #8,D3
    LSR         #2,D3
    LSR         #3,D3
    MOVE.W      D3,SRC_MODE_HOLDER          * After manipulation copy source mode over
											* finally get the source itself
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 	
    LSL         #8,D3
    LSL         #5,D3
    LSR         #8,D3
    LSR         #5,D3
    MOVE.W      D3,SRC_HOLDER				* Copy over the source 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.  
    RTS

*****
 * The FIRST_TWO_NIBS_4_E subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first two
 * nibbles of 4EXX
 * 
 * This could be a NOP, a JSR, or an RTS  
 ***
FIRST_TWO_NIBS_4_E
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    LSL         #8,D3                       * Shift to the left to remove the 2 Most Sig Nibbles 
    LSR         #8,D3                       * Return to the original position of those bits. 
    CMP.B       #$71,D3                     * Checks for NOP since it's only 4E71
    BEQ         OUTPUT_NOP
    CMP.B       #$75,D3                     * Checks for RTS since it's only 4E75
    BEQ         OUTPUT_RTS
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable.                  
											* Done to get the DEST_MODE and DEST_REG since this 
											* could be a JSR command. 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         STORE_THIRD_NIBBLE_IN_D3    * According to the manual, the JSR will have #%10 
											* as it's Most Sig two bits of its 3rd nibble 
    LSR         #2, D3						* Isolate those bits 
    CMP         #%10, D3					* Check if it's JSR 
    BEQ         OUTPUT_JSR                  * If it is then output JSR and its following data
    BRA         INVALID_OPCODE				* Otherwise it's not JSR branch to INVALID 
    RTS

********************************************************************************
 * This jump table for branching based on the first nibble 
 * is placed here for logical comprehension. 
 *******************************************************************************
CHECK_FIRST_NIB_JMPTABLE                  * Based on the first byte of the op code then jump on what is possible
    JMP         FIRST_NIB_0               * ORI, CMPI BCLR
    JMP         FIRST_NIB_1               * MOVE.B, MOVEA.B
    JMP         FIRST_NIB_2               * MOVEA.L, MOVE.L
    JMP         FIRST_NIB_3               * MOVE.W    MOVEA.W
    JMP         FIRST_NIB_4               * NOP, LEA, NOT, JSR, RTS
    JMP         FIRST_NIB_5               * SUBQ
    JMP         FIRST_NIB_6               * BCS, BGE, BLT, BVC, BRA
    JMP         FIRST_NIB_7               * NOT SUPPORTED
    JMP         FIRST_NIB_8               * DIVS, OR
    JMP         FIRST_NIB_9               * SUB
    JMP         FIRST_NIB_A               * NOT SUPPORTED
    JMP         FIRST_NIB_B               * EOR, CMP
    JMP         FIRST_NIB_C               * AND
    JMP         FIRST_NIB_D               * ADD, ADDA
    JMP         FIRST_NIB_E               * LSR, LSL, ASR, ASL, ROL, ROR
    JMP         FIRST_NIB_F               * NOT SUPPORTED

*****
 * The FIRST_NIB_0 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of 0XXX
 * 
 * This can be CMPI  
 ***
FIRST_NIB_0
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         STORE_SECOND_NIBBLE_IN_D3   * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    CMP         #$C, D3						* Check to see if second nibbles is #$C 
    BEQ         OUTPUT_CMPI					* If it is then it's CMPI 
    CMP         #$6, D3
    BEQ         OUTPUT_ADDI
    BRA         INVALID_OPCODE				* We don't support other opcodes here so branch to invalid 
    RTS


*****
 * The FIRST_NIB_1 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of 1XXX
 * 
 * This can be MOVE.B, MOVEA.B 
 * Only MOVE since size of MOVE 
 * is determined here. 
 ***
FIRST_NIB_1 
    JSR         OPCODE_MOVE_UTILITY			* Have the OPCODE_MOVE_UTILITY handle it 
    SIMHALT

*****
 * The FIRST_NIB_2 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of 2XXX
 * 
 * This can be MOVE.L, MOVEA.L 
 * Only MOVE since size of MOVE 
 * is determined here. 
 ***
FIRST_NIB_2 
    JSR         OPCODE_MOVE_UTILITY		* Have the OPCODE_MOVE_UTILITY handle it 
    SIMHALT

*****
 * The FIRST_NIB_3 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of 3XXX
 * 
 * This can be MOVE.W, MOVEA.W 
 * Only MOVE since size of MOVE 
 * is determined here. 
 ***
FIRST_NIB_3 
    JSR         OPCODE_MOVE_UTILITY		* Have the OPCODE_MOVE_UTILITY handle it 
    SIMHALT

*****
 * The FIRST_NIB_4 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of 4XXX
 * 
 * This can be NOP, LEA, RTS, JSR, NOT, MOVEM  
 * So we need to check the second nibble 
 ***
FIRST_NIB_4  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.       
											* Done to get the original op code value back.
    JSR         STORE_SECOND_NIBBLE_IN_D3   * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    CMP.B       #$E,D3						* Checks to see if it's 4EXX 
    BEQ         FIRST_TWO_NIBS_4_E          * If it is then it can only be NOP,RTS,JSR
    CMP.B       #6,D3                       * If the second nibble is 6, then it must be NOT
    BEQ         OUTPUT_NOT					* So print out NOT 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    CMP         #%111,DEST_MODE_VAR			* Check the Destination mode 
    BEQ         OUTPUT_LEA                  * Output LEA since only that has destination mode bits of #%111
    CMP         #%110,DEST_HOLDER			* Check the Destination if it's #%110 if it is then it's MOVEM 
    BEQ         MOVEM_OUTPUT
    CMP         #%100,DEST_HOLDER			* Check to see if it's MOVEM 
    BEQ         MOVEM_OUTPUT
    BRA         INVALID_OPCODE				* If it's not any of these it's an invalid opcode. 
    RTS

*****
 * The FIRST_NIB_5 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of 5XXX
 * 
 * This can be SUBQ or ADDQ 
 ***
FIRST_NIB_5  * This is SUBQ and ADDQ
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         D3_STORE_NORM_SIZE          * SUBQ and ADDQ only accept normal size format, so their can't be #%11
    CMP         #%11,D3						* Verify the size to see if it's normal 
    BEQ         INVALID_OPCODE				* If it's not then this is an invalid opcode 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         STORE_SECOND_NIBBLE_IN_D3   * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    LSL         #8,D3                       * Get rid of the first 2 nibbles 
    LSL         #7,D3                       * Return to original position
    LSR         #8,D3
    LSR         #7,D3
    CMP         #0,D3                       * The second nibble last bit will be 1 for SUBQ 
    BEQ         OUTPUT_ADDQ                 * The second nibble last bit will be 0 for SUBQ 
    BRA         OUTPUT_SUBQ
    RTS
    SIMHALT
    
*****
 * The FIRST_NIB_6 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of 6XXX
 * 
 * This can be B(cc) BRA or BSR 
 ***
FIRST_NIB_6  * Bcc and BRA , BSR
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         STORE_SECOND_NIBBLE_IN_D3   * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    CMP         #%0000,D3                   * Only the condition code of BRA is #%0000
    BEQ         OUTPUT_BRA
    CMP         #%0001,D3					* Only the condition code of BSR is #%0001
    BEQ         BSR_OUTPUT
    CMP         #%1110,D3					* Only the condition code of BGT is #%1110
    BEQ         BGT_OUTPUT			
    CMP         #%0111,D3					* Only the condition code of BEQ is #%0111
    BEQ         BEQ_OUTPUT
    CMP         #%1111,D3					* Only the condition code of BLE is #%1111
    BEQ         BLE_OUTPUT
    BRA         INVALID_OPCODE
    RTS
    SIMHALT

*****
 * The FIRST_NIB_7 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of 7XXX
 * 
 * This can be MOVEQ 
 ***
FIRST_NIB_7  * This is MOVEQ
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         STORE_SECOND_NIBBLE_IN_D3   * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    LSL         #8,D3
    LSL         #7,D3
    LSR         #8,D3
    LSR         #7,D3
    CMP         #0,D3						* Check last bit, if it's 0 then it's MOVEQ
    BEQ         OUTPUT_MOVEQ				
    BRA         INVALID_OPCODE				* Branch to Invalid OpCode if it's not 
    SIMHALT

*****
 * The FIRST_NIB_8 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of 8XXX
 * 
 * This can be OR 
 ***
FIRST_NIB_8  * DIVS, Can't recognize SBCD
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    CMP         #%111, DEST_MODE_VAR		* This is DIVS we don't support that 
    BEQ         INVALID_OPCODE
    CMP         #%011, DEST_MODE_VAR
    BEQ         INVALID_OPCODE       		* This is DIVU we don't support that 
    BRA         OR_OUTPUT					* If it's not any of those it should be OR 
    RTS
    SIMHALT

*****
 * The FIRST_NIB_9 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of 9XXX
 * 
 * This can be SUB or SUBA 
 ***
FIRST_NIB_9  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         D3_STORE_NORM_SIZE			* Check the size 
    CMP         #%11,D3						* If it's #%11 then it's SUBA 
    BEQ         OUTPUT_SUBA              	* Else it should be SUB since it can't take #%11 size
    BRA         OUTPUT_SUB
    SIMHALT

*****
 * The FIRST_NIB_A subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of AXXX
 * 
 * Automatically branch to invalid 
 * Since it's not supported 
 ***
FIRST_NIB_A  
    BRA         INVALID_OPCODE
    SIMHALT

*****
 * The FIRST_NIB_B subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of BXXX
 * 
 * This can be CMP  
 ***
FIRST_NIB_B  * CMP
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         D3_STORE_NORM_SIZE			* Have D3 store the NORM size bits 
    CMP         #%11, D3					* Check to see if it's valid 
    BEQ         INVALID_OPCODE              * Since CMP doesn't use size #%11 this is invalid 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         STORE_SECOND_NIBBLE_IN_D3   * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    LSL         #8,D3                       * Get the last bit of the second nibble
    LSL         #7,D3
    LSR         #7,D3
    LSR         #8,D3
    CMP         #0,D3                       * The CMP always has 0 as the last bit in the second nibble
    BNE         INVALID_OPCODE
    BRA         OUTPUT_CMP					* Print as appropriate 
    SIMHALT

*****
 * The FIRST_NIB_C subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of CXXX
 * 
 * This can be AND  
 ***
FIRST_NIB_C * AND
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         D3_STORE_NORM_SIZE			* Have D3 store the NORM size bits
    CMP         #%111, DEST_MODE_VAR		* Since AND doesn't use dest mode #%111 this is invalid 
    BEQ         INVALID_OPCODE              * This is MULS we don't support it so branch to invalid 
    CMP         #%011, DEST_MODE_VAR		* Since AND doesn't use dest mode #%011 this is invalid 
    BEQ         INVALID_OPCODE              * This is MULU we don't support it so branch to invalid 
    BRA         AND_OUTPUT					* Otherwise it's AND 
    RTS
    SIMHALT

*****
 * The FIRST_NIB_D subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of DXXX
 * 
 * This can be ADD or ADDA  
 ***
FIRST_NIB_D
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         D3_STORE_NORM_SIZE			* Have D3 store the NORM size bits
    CMP         #%11,D3						* Check to see if it's #%11 with D3 
    BEQ         OUTPUT_ADDA					* If it is this size then it's ADDA 
    BRA         ADD_OUTPUT					* Otherwise it's ADD 
    RTS
    SIMHALT

*****
 * The FIRST_NIB_E subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * handling the control of the disassembler
 * when it reads memory to have first 
 * nibble of EXXX
 * 
 * This can be LSd, ASd, ROd
 *
 * They can be seperated as LSd <ea> 
 * or other cases. 
 *
 * Differentiate by checking size 
 * if it's #%11 or not 
 ***
FIRST_NIB_E  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         D3_STORE_NORM_SIZE			* Have D3 store the NORM size bits
    CMP         #%11,D3						* Check to see if it's #%11 with D3
    BEQ         FINDING_SHIFT_MEM_TYPE      * Only the instructions with 11 in the size parts deal with <ea> (shift memory)
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         STORE_THIRD_NIBBLE_IN_D3    * For reference the ASd and LSd will have last bit of the third nibble be '0' 
    LSL         #8,D3                       * Manipulate nibble to isolate bit 
    LSL         #7,D3
    LSR         #7,D3
    LSR         #8,D3
    CMP         #0,D3
    BEQ         ASD_LSD_OUTPUT
    BRA         ROX_OUTPUT                  * There could also be ROXD instruction that is unsupported. 
    RTS

*****
 * For the purposes of this disassembler, if the first nibble is 'F'
 * then ' SIMHALT ' has likely been reached, therefore this is the 
 * point when you should get to decide if you want to restart or finish.
 ***
FIRST_NIB_F 
    BRA         RESTART_OR_FINISH
    RTS
    SIMHALT

*****
 * The FINDING_SHIFT_MEM_TYPE subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * finding the memory type used with 
 * ASd, LSd, or ROd or <ea> 
 ***
FINDING_SHIFT_MEM_TYPE  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation. 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    JSR         STORE_SECOND_NIBBLE_IN_D3   * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    LSR         #1,D3
    CMP         #1,D3
    BEQ         LOG_SHIFT_MEM_OUTPUT        * #%001 LSd 
    CMP         #0,D3
    BEQ         ASX_SHIFT_MEM_OUTPUT        * #%000 ASd 
    CMP         #%11,D3
    BEQ         ROD_MEM_OUTPUT              * #%011 ROd 
    BRA         INVALID_OPCODE              * Must be ROXd, UNSUPPORTED
    RTS

********************************************************************************
 * This jump table for determining the EA mode 
 * and which address should be printed.
 *******************************************************************************
JMPTABLE_FINDING_REG_MODE
    JMP         REG_MODE_000                       * Data register mode Dn
    JMP         REG_MODE_001                       * Address register mode   An
    JMP         REG_MODE_010                       * Indirect address register mode (An)
    JMP         REG_MODE_011                       * Address register with increment (An)+
    JMP         REG_MODE_100                       * Address register with decrement -(An)
    JMP         REG_MODE_101                       * Unsupported EA mode 
    JMP         REG_MODE_110                       * Unsupported EA mode 
    JMP         REG_MODE_111                       * #<data> immediate, (xxx).W Absolute Short, (xxx).L 

*****
 * The REG_MODE_000 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * when the register mode or EA 
 * is for data registers, or ' Dn ' 
 ***
REG_MODE_000                                       
    JSR         OUTPUT_DATA_REG				* Output the data registers
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8
    RTS

*****
 * The REG_MODE_001 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * when the register mode or EA 
 * is for address registers, or ' An ' 
 ***
REG_MODE_001   
    JSR         OUTPUT_ADDR_REG             * Output the address registers 
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8
    RTS

*****
 * The REG_MODE_010 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * when the register mode or EA 
 * is for indirect address registers, or ' (An) ' 
 ***
REG_MODE_010 	* (An)
    JSR         OUTPUT_OPEN_BRACKET
    JSR         REG_MODE_001
    JSR         OUTPUT_CLOSE_BRACKET
    RTS

*****
 * The REG_MODE_011 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * when the register mode or EA 
 * is for address registers
 * with post increment, or ' (An)+ ' 
 ***
REG_MODE_011    
    JSR         REG_MODE_010
    JSR         OUTPUT_PLUS_SIGN
    RTS

*****
 * The REG_MODE_100 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * when the register mode or EA 
 * is for address registers
 * with pre decrement, or ' -(An) ' 
 ***
REG_MODE_100
    JSR         OUTPUT_MINUS_SIGN
    JSR         REG_MODE_010
    RTS

*****
 * The REG_MODE_101 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * when the register mode or EA 
 * has Register Mode of 101
 * This will output bad EA 
 * since it's not supported. 
 ***
REG_MODE_101    
    BRA         INVALID_OPCODE
    RTS

*****
 * The REG_MODE_110 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * when the register mode or EA 
 * has Register Mode of 110
 * This will output bad EA 
 * since it's not supported. 
 ***
REG_MODE_110    
    BRA         INVALID_OPCODE
    RTS

*****
 * The REG_MODE_111 subroutine:
 * ---------------------
 * This subroutine is responsible for 
 * when the register mode or EA 
 * is for immediate data, 
 * and absolute long or absolute short  
 ***
REG_MODE_111    
    LEA         JMPTABLE_111_REG,A4    * Will jump later to 111 register table by loading it to A4 
    MOVE.W      UTILITY_VAR,D3		   * Assuming that the register number
									   * has been loaded into the UTILITY_VAR
									   * move it to D3 for manipulation.
    MULU        #6,D3				   * Multiply unsigned by D3 to use it as an offset for JSR
    JSR         0(A4,D3)			   * Jump sub routine with offset 
    LEA         OUTPUT_SHORT_OR_LONG,A4  * Prepare the table to print out the data
    MOVE.W      UTILITY_VAR,D3			 * Assuming that the register number
									     * has been loaded into the UTILITY_VAR
									     * move it to D3 for manipulation.
    MULU        #6,D3                    * Use UTILITY_VAR to store the data we want to output for register mode 111.
                                         * In the code before this, we need to move the appropriate data into this address. Either the destination or the source
    JSR         0(A4,D3)                 * Print out the appropriate long or short value
    RTS

*****
 * The OUTPUT_SHORT_OR_LONG subroutine:
 * ---------------------
 * This jump table is used to 
 * determine if we should output .W or Word suffix 
 * or should we output the .L or Long Suffix 
 * This subroutine is touched when the 
 * register mode is #%111, but not immediate data  
 ***
OUTPUT_SHORT_OR_LONG              
    JMP         SHORT_ABSOLUTE    * Xn index for this is 000
    JMP         LONG_ABSOLUTE     * Xn index for this is 001
    JMP         CNTR_DISPLMNT     * Unsupported EA 
    JMP         CNTR_INDEX        * Unsupported EA 
    JMP         EA_IMMI_DATA      * Print out immediate data as EA 

*****
 * The SHORT_ABSOLUTE subroutine:
 * ---------------------
 * This subroutine is for handling 
 * when the <ea> is <xxx>.W 
 * To handle this case we need to get the 
 * next 4 nibbles as the address for output 
 ***
SHORT_ABSOLUTE                        
    JSR         D3_GET_NEXT_FOUR_NIB  * Got next 4 nibbles to print out as address
    JSR         HEX_TO_ASCII_CHANGER	* Output the 8 bit data field
    RTS
    SIMHALT

*****
 * The LONG_ABSOLUTE subroutine:
 * ---------------------
 * This subroutine is for handling 
 * when the <ea> is <xxx>.L  
 * To handle this case we need to get the 
 * next 8 nibbles as the address for output 
 ***
LONG_ABSOLUTE                         
    JSR         SHORT_ABSOLUTE        * Print 4 nibbles
    JSR         SHORT_ABSOLUTE        * Print 4 more nibbles  
    RTS
    SIMHALT

*****
 * The CNTR_DISPLMNT subroutine:
 * ---------------------
 * This <ea> is not supported 
 ***
CNTR_DISPLMNT                         * Not SUPPORTED
    BRA         INVALID_OPCODE
    SIMHALT

*****
 * The CNTR_INDEX subroutine:
 * ---------------------
 * This <ea> is not supported 
 ***
CNTR_INDEX                                   * Not SUPPORTED
    BRA         INVALID_OPCODE
    SIMHALT

*****
 * The EA_IMMI_DATA subroutine:
 * ---------------------
 * This subroutine is for handling 
 * when the <ea> is #<data> 
 * To handle this case we take 
 * advantage of its similar nature
 * to <xxx>.W and <xxx>.L 
 * We have D3 store the normative size bits
 * then we isolate the 2 Most Sig bits of that
 * and then use that as displacement 
 * for the OUTPUT_SHORT_OR_LONG subroutine jump 
 ***
EA_IMMI_DATA
    CLR         D2
    JSR         STORE_FIRST_NIBBLE_IN_D2
    JSR         EA_IMMI_D3_STORE_NORM_SIZE_VER  * Now the first 2 bit of third nibble is on the right most
    CMP         #$D,D2
    BEQ         EA_IMMI_ADDA_CASE
	CMP			#$2,D2
	*BEQ		EA_IMMI_NEXT					* MOVEA 
	BEQ			CHECK_MOVEM_OR_MOVE
	BRA			EA_IMMI_AND_CASE
CHECK_MOVEM_OR_MOVE
	CLR			D2
	JSR			STORE_THIRD_NIBBLE_IN_D2
	CMP			#$7,D2
	BEQ			EA_IMMI_NEXT
	CMP			#$3,D2
	BEQ			MOVE_L_CASE 	
	BRA			EA_IMMI_NEXT
MOVE_L_CASE
	JSR 		LONG_ABSOLUTE
	CLR			D2
	RTS
    
EA_IMMI_AND_CASE
    LSR         #1,D3                           * Byte aand word are mapped to absolute short => 00 and 01 after shift will go to 00
    BRA         EA_IMMI_NEXT
	
EA_IMMI_ADDA_CASE
    LSR         #2,D3

EA_IMMI_NEXT                                    * If the size is long, the it will go to absolute long 10 => 01
    LEA         OUTPUT_SHORT_OR_LONG,A4         * Prepare the table to print out the data
    MULU        #6,D3                           * Use UTILITY_VAR as a place holder for the data we want to print out for register mode 111.
                                                * In the code before this, we need to move the appropriate data into this address. Either the destination or the source
    JSR         0(A4,D3)                        * Print out the appropriate long or short value
    CLR         D2
    RTS

*****
 * The JMPTABLE_111_REG subroutine:
 * ---------------------
 * This jump table is used to determine
 * which character should be printed out 
 * for the <ea> when 111 is the register mode. 
 ***
JMPTABLE_111_REG
    JMP         OUTPUT_SHORT_SYMBOL
    JMP         OUTPUT_LONG_SYMBOL
    JMP         DUMMY_THIRD_OPTION * Won't be reached
    JMP         DUMMY_FOURTH_OPTION
    JMP         PRINT_EA_IMMI_DATA_AND_HEX

*****
 * The OUTPUT_SHORT_SYMBOL subroutine:
 * ---------------------
 * This subroutine will output 
 * the '$' symbol since <xxx>.W is an 
 * address <ea>  
 ***
OUTPUT_SHORT_SYMBOL
    JSR         OUTPUT_HEX_SYMBOL				* Invokes subroutine to print '$'
    RTS

*****
 * The OUTPUT_LONG_SYMBOL subroutine:
 * ---------------------
 * This subroutine will output 
 * the '$' symbol since <xxx>.L is an 
 * address <ea>  
 ***
OUTPUT_LONG_SYMBOL
    JSR         OUTPUT_HEX_SYMBOL				* Invokes subroutine to print '$'
    RTS

*****
 * The DUMMY_THIRD_OPTION subroutine:
 * ---------------------
 * This subroutine will output 
 * an invalid <ea> since this 
 * should not be supported 
 ***
DUMMY_THIRD_OPTION
    BRA         INVALID_OPCODE
    SIMHALT

*****
 * The DUMMY_FOURTH_OPTION subroutine:
 * ---------------------
 * This subroutine will output 
 * an invalid <ea> since this 
 * should not be supported 
 ***
DUMMY_FOURTH_OPTION
    BRA        INVALID_OPCODE
    SIMHALT

*****
 * The PRINT_EA_IMMI_DATA_AND_HEX subroutine:
 * ---------------------
 * This subroutine will output 
 * both a '#' and '$' symbol 
 * to indicate immediate hexadecimal 
 ***
PRINT_EA_IMMI_DATA_AND_HEX
    JSR         OUTPUT_EA_IMMI_DATA_SYMBOL	* Outputs the '#' symbol
    JSR         OUTPUT_HEX_SYMBOL			* Invokes subroutine to print '$'
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

OUTPUT_SIZE_OF_MOVE_JMPTABLE
    JMP         INVALID_MOVE_SIZE
    JMP         OUTPUT_BYTE_SUFFIX
    JMP         OUTPUT_LONG_SUFFIX
    JMP         OUTPUT_WORD_SUFFIX

INVALID_MOVE_SIZE
    BRA         INVALID_OPCODE
    RTS

OUTPUT_BYTE_SUFFIX
    LEA         STR_BYTE_SUFFIX,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

OUTPUT_LONG_SUFFIX
    LEA         STR_LONG_SUFFIX,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

OUTPUT_WORD_SUFFIX
    LEA         STR_WORD_SUFFIX,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

MOVEM_WORD_SUFFIX
    LEA          STR_WORD_SUFFIX,A1
    JSR          WHOLE_MESSAGE_OUTPUT
    JSR          OUTPUT_EMPTY_SPACE
    BRA          MOVEM_NEXT

MOVEM_LONG_SUFFIX
    LEA          STR_LONG_SUFFIX,A1
    JSR          WHOLE_MESSAGE_OUTPUT
    JSR          OUTPUT_EMPTY_SPACE
    BRA          MOVEM_NEXT

JMPTABLE_USUAL_CASE_SIZE
    JMP         OUTPUT_BYTE_SIZE_USUAL
    JMP         OUTPUT_WORD_SIZE_USUAL
    JMP         OUTPUT_LONG_SIZE_USUAL
    JMP         UNUSED_USUAL_SIZE_SUFFIX         * Could be move

OUTPUT_BYTE_SIZE_USUAL
    LEA         STR_BYTE_SUFFIX,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

OUTPUT_WORD_SIZE_USUAL
    LEA         STR_WORD_SUFFIX,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

OUTPUT_LONG_SIZE_USUAL
    LEA         STR_LONG_SUFFIX,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

UNUSED_USUAL_SIZE_SUFFIX
    BRA         INVALID_OPCODE
    RTS

****
 * This jump table is used to decide if 
 * we output Right Direction or Left Direction 
 **
JMPTABLE_R_OR_L
    JMP         OUTPUT_WHEN_R
    JMP         OUTPUT_WHEN_L

*****
 * Output 'R' to indicate that we're going Right 
 ***
OUTPUT_WHEN_R
    LEA         STR_RIGHT,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

*****
 * Output 'L' to indicate that we're going Left 
 ***
OUTPUT_WHEN_L
    LEA         STR_LEFT,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

JMPTABLE_SHIFT_OP_IMMI_OR_REG                * Use for ASd, LSd, ROd operations
    JMP         SHIFT_WITH_IMMI
    JMP         SHIFT_WITH_REGISTER

*****
 * Used in the case of ASd, LSd, ROd with immediate 
 ***
SHIFT_WITH_IMMI
    LEA         EA_IMMI_DATA_SYMBOL,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         STORE_SECOND_NIBBLE_IN_D3    * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    LSR         #1,D3
    CMP         #0,D3
    BEQ         SHIFT_WITH_IMMI_HELPER       * For cases where the immediate is 0, make it 8
    MOVE.W      D3, UTILITY_VAR              * Save the immediate data 1-8 we want to print
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

*****
 * Used in the case of ASd, LSd, ROd with register 
 ***
SHIFT_WITH_REGISTER
    LEA         STR_DATA_REG,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3	* Reload the current four nibbles that 
											* the disassembler is looking at to D3
											* NOTE: At this stage D3 serves as a copy 
											* that will be used for manipulations 
											* to leave only specific bits that
											* other subroutines will need for validation.
    JSR         STORE_SECOND_NIBBLE_IN_D3    * This instruction is a jump to a subroutine designed specifically for getting the second nibble 
    LSR         #1,D3
    MOVE.W      D3,UTILITY_VAR
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

SHIFT_WITH_IMMI_HELPER
    MOVE.W      #8,UTILITY_VAR
    JSR         REGISTER_NUM_OUTPUT			* Output the data from 1-8
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

******
 *	This subroutine is used to see
 *	if the user wants to finish or restart
 * 	the disassembler 
 ****
RESTART_OR_FINISH
    LEA    ENDING_P1, A1
    MOVE.B      #14,D0
    TRAP        #15
    MOVE.B      #4, D0
    TRAP        #15  
    CMP.B       #1, D1
    BEQ         FINAL_CLEANING
    CMP.B       #0, D1
    BNE         INVALID_END
    SIMHALT

******
 *	This subroutine is used in the 
 *	case of an invalid ending input. 
 ****
INVALID_END
    LEA         INVALID_ENDING, A1
    MOVE.B      #14,D0
    TRAP        #15
    BRA         RESTART_OR_FINISH

******
 *	This subroutine is used to 
 * 	clear all variabels and registers
 *	so that a restart can occur cleanly.
 ****
FINAL_CLEANING
    CLR.L       D0
    CLR.L       D1
    CLR.L       D2
    CLR.L       D3
    CLR.L       D4
    CLR.L       D5
    CLR.L       D6
    CLR.L       D7
    MOVEA.L     #0,A0
    MOVEA.L     #0,A1
    MOVEA.L     #0,A2
    MOVEA.L     #0,A3
    MOVEA.L     #0,A4
    MOVEA.L     #0,A5
    MOVEA.L     #0,A6
    MOVEA.L     #0,A7
    CLR.L       BEGINNING_ADDRESS
    CLR.L       FINISHING_ADDRESS
    CLR.L       CURRENT_FOUR_NIBBLES_VAR
    CLR.L       DEST_HOLDER
    CLR.L       DEST_MODE_VAR
    CLR.L       SRC_MODE_HOLDER
    CLR.L       SRC_HOLDER
    CLR.L       UTILITY_VAR
    CLR.L       A1_COPY_ONE
    CLR.L       A1_COPY_TWO
    CLR.L       CURRENT_TWO_NIBBLES_VAR
    BRA         GET_BEGIN_ADDR





