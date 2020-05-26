DERIVING_OPCODE
    JSR         OUTPUT_ADDR_LOC                  * Jumps to the Sub Routine ' OUTPUT_ADDR_LOC '
    JSR         D3_GET_NEXT_FOUR_NIB             * Once returned back, jump to ' D3_GET_NEXT_FOUR_NIB '
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR,D3		 * Reload the current four nibbles that      
												 * Copy the CURRENT_FOUR_NIBBLES_VAR to 'D3' since that's used by most subroutines
    JSR         STORE_FIRST_NIBBLE_IN_D3         * Once copy is complete jump to ' STORE_FIRST_NIBBLE_IN_D3 '
    MULU        #6,D3                            * The multiply unsigned operation will manipulate 'D3' to get the index of the first nibble
    JSR         0(A0,D3)   

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
    RTS	

PRESS_ENTER_CONT_CHECK
    MOVE        #0,D6		* Reset the counter which is D6
    MOVE.B      #5,D0		* Load TRAP TASK #5	
    TRAP        #15			* Execute the TRAP TASK
    RTS						* Rerturn to the subroutine.

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
												* it to see if it's an OpCod
 OUTPUT_RTS
    LEA         STR_RTS,A1                  * Loads the string for RTS for output
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
											 
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode. 											 
    RTS										* Return to the subroutine  

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
OUTPUT_ADDR_LOC
    MOVE.L      A2,D5 							* Store the current address that the disassembler is at					
    MOVE.L      D5,CURRENT_FOUR_NIBBLES_VAR     * Copy the long address in its entirety 
    JSR         HEX_TO_ASCII_CHANGER			* Output the 8 bit data field
    MOVE.W      A2,D5							* Store the current address that the disassembler is at
    MOVE.W      D5,CURRENT_FOUR_NIBBLES_VAR		* Copy the long address in its entirety 
    JSR         HEX_TO_ASCII_CHANGER		* Output the 8 bit data field
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS