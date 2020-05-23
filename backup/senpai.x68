*-----------------------------------------------------------
* Title      : CSS 422 68k Disassembler
* Written by : Pratit Vithalani, Aaron Handjojo, Nathan Phan
* Date       : June 6th, 2019
* Description: Load a test file, enter starting and ending address. Press enter to see it disassemble every screen limit
*-----------------------------------------------------------

****
 * REFERENCE:
 * ----------
 * The address register 'A2' is used to represent the starting address that will be iterated until the ending adrress
 * The address register 'A3' is used to represent the ending address
 * The data register 'D7' is used as the toggle for MOVEM '/' output 
 **

BEGINNING_ADDRESS           EQU    $100 * This address in the memory will store the inputted user starting address
FINISHING_ADDRESS           EQU    $150 * This address in the memory will store the inputted user ending address
CURRENT_FOUR_NIBBLES_VAR    EQU    $200 * This variable will represent '4' nibbles which are used for reading purposes
DEST_HOLDER                 EQU    $250 * This variable represents the address number of the destination which are typically the [11-9th bit]
DEST_MODE_VAR               EQU    $300 * This variable represents the destination mode which are typically the [8-6 bit]
SRC_MODE_HOLDER             EQU    $350 * This variable represents the source mode which are typically the [5-3]
SRC_HOLDER                  EQU    $400 * This variable represents the address number of the source which are typically the [2-0 bit]
UTILITY_VAR                 EQU    $550 * This variable is used throughout the program as a temporary variable manipulated by various subroutines to store data. 
A1_COPY_ONE                 EQU    $600 * This variable was specified as a copy of (A1) as to avoid overwriting the value in (A1) when obtaining the end address
A1_COPY_TWO                 EQU    $650 * This variable was specified as a copy of (A1) as to avoid overwriting the value in (A1) when obtaining the starting address
CURRENT_TWO_NIBBLES_VAR     EQU    $750 * This variable will represent '2' nibbles which are used for reading purposes 

    ORG    $1000                        * 'ORG'ing the program at $1000, so that the program starts at memory $1000
START:                  ; first instruction of program AKA the program starts here.

*************
 * The beginning of the program will commence
 * with getting the starting and ending addresses
 * for the OpCodes that we will parse
 ********

****
 * The GET_BEGIN_ADDR subroutine:
 * ------------------------------
 * Responsible for prompting the user for the starting address. 
 * Start the program by asking the user for the starting address
 * Accomplished largely by loading the message into A1
 * Printing out the message using the TRAP TASK #13
 * Then the registers of 'D0','D1','A1' are 
 * prepared for the invocation of the ' ASCII_TO_HEX_CHANGER ' subroutine
 ***
GET_BEGIN_ADDR
    LEA         GET_START_ADDR,A1       * This message will welcome the user to the program
    MOVE.B      #13,D0                  * Formatting with Carriage Return and Line Feed
    TRAP        #15                     * Execute the TRAP task
    MOVEA.L     #0,A1                   * Preemptively clear the values in A1 register for the starting address 
    LEA         A1_COPY_TWO,A1          * Load the A1_COPY_TWO into A1, so that override won't occur when we read a string.
    CLR         D0                      * Clear the D0 register to enable manipulation and use
    CLR         D1                      * Clear the D1 register to enable manipulation and use
    MOVE.B      #2,D0                   * Reads a string input to represent the starting address for the user. 
    TRAP        #15                     * Execute the TRAP task
    BRA         ASCII_TO_HEX_CHANGER    * Invoke the ASCII to HEX conversion subroutine 

****
 * The GET_FINISH_ADDR subroutine:
 * -------------------------------
 * Responsible for prompting the user for the ending address. 
 * Ask the user for the ending address that they want us to parse up to
 * Accomplished largely by loading the message into A1
 * Printing out the message using the TRAP TASK #13
 * Then the registers of 'D0' and 'A1' are 
 * prepared for the invocation of the ' ASCII_TO_HEX_CHANGER ' subroutine
 ***
GET_FINISH_ADDR
    LEA         GET_END_ADDR,A1         * Similar message prompting for the end address
    MOVE.B      #13,D0					* Formatting with Carriage Return and Line Feed 
    TRAP        #15						* Execute the TRAP task
    LEA         A1_COPY_ONE,A1          * Store the end address in the A1 address 
    MOVE.B      #2,D0					* Reads a string input to represent the starting address for the user.
    TRAP        #15						* Execute the TRAP task
    BRA         ASCII_TO_HEX_CHANGER	* Invoke the ASCII to HEX conversion subroutine 

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

*****
 * The ASCII_TO_HEX_CHANGER subroutine: 
 * ------------------------------------
 * This subroutine is invoked during the first phase of the 
 * disassembler as a key component of I/O. It's used to 
 * turn the inputted start and end addresses to HEX format
 * from ASCII, so that the disassembler can understand.
 * 
 * Converts 0-9 and A-F in ASCII to HEX Value
 * Credit to: http://www.asciitable.com/
 * For providing the ASCII Table which we used.
 ***
ASCII_TO_HEX_CHANGER
    MOVE.B      (A1)+,D0					* Reads through each byte of the address
	
    CMP.B       #$30,D0                     * A comparison is made with #$30 because 
											* Valid ASCII numbers and Letters have:
											* $30 - $39 for [0-9] and $41 - $46 for [A-F]
											
    BLT         SWITCH_BAD_INPUT			* If it's less than #$30, then it can't be
											* a proper ASCII number or letter
											
    CMP.B       #$39,D0                     * A comparison is made with #$39 to see 
											* if the value is a ASCII number. 
											
    BGT         ASCII_TO_HEX_CHAR_CHANGER	* If it's greater then branch to 
											* the ASCII CHAR subroutine for further checks
											
    SUB.B       #$30,D0                     * If it's still here then it's a number
											* therefore it's a ASCII number between [0-9]
											* You subtract #$30 to convert it to HEX.
											
    ADD.L       D0,D3						* Add the value to D3 since it stores the 
											* HEX version of the address. 
											
    SUBI        #1,D1                       * By subtracting '1' from D1 this will 
											* serve to decrement the counter of the 
											* length of the examined address
											
    CMP.B       #0,D1						* Check if the counter is 0, if it is 
											* begin the process of validating the
											* address that was just converted.
											
    BEQ         VALIDATING_BEG_ADDRESS		* Appropriate branch for condition above.
	
    LSL.L       #4,D3                       * Performing a 4 bit shift to the left
										    * will leave room for the next nibble 
											* of the address. After all if we're here
											* then that means there's still some 
											* address to be read in. 
											
    BRA         ASCII_TO_HEX_CHANGER		* Branches back to the beginning of the 
											* subroutine this is done since the
											* counter hasn't reached 0 yet, so 
											* we still have some more characters
											* to convert for the address. 

*****
 * The ASCII_TO_HEX_CHAR_CHANGER subroutine: 
 * -----------------------------------------
 * This subroutine is invoked during the first phase of the 
 * disassembler as a key component of I/O. It's an extension
 * of the primary ASCII_TO_HEX_CHANGER that handles 
 * ASCII input that may possibly be a letter. This 
 * subroutine will check to see if it's a letter 
 * and handle the input appropriately. 
 * 
 * Converts 0-9 and A-F in ASCII to HEX Value
 * Credit to: http://www.asciitable.com/
 * For providing the ASCII Table which we used.
ASCII_TO_HEX_CHAR_CHANGER
    CMP.B       #$41,D0                     * A comparison is made with #$41 because
											* this subroutine would only be branched to 
											* if and only if the inputted value is 
											* greater than #$39 meaning it can't be a 
											* number, but we still need to check to 
											* see what it is. 
											
    BLT         SWITCH_BAD_INPUT            * If the value is less than #$41 then
											* it's not a letter. And since the numbers 
											* were already checked for it's an ASCII 
											* that isn't relevent to the disassembler
											* Remember values #$41 - #$46 are [A-F] 
											* which are the only valid HEX chars
											
    CMP.B       #$46,D0						* Check to see if it's a letter 
											* greater than 'F'
											
    BGT         SWITCH_BAD_INPUT            * If it's greater than #$46, then the 
											* ASCII checked is not in hexadecimalGreater
											* therefore it's invalid
											
    SUB.B       #$37,D0                     * We subtract #$37 from the value to 
											* convert it from ASCII letter to 
											* the hexadecimal letter
											
    ADD.L       D0,D3                       * Now that we have it we're going 
											* to store it in register D3 which
											* in this stage of the disassembler 
											* will be used to store the 
											* converted addresses
											
    SUBI        #1,D1                       * By subtracting '1' from D1 this will 
											* serve to decrement the counter of the 
											* length of the examined address
											
    CMP.B       #0,D1						* Check if the counter is 0, if it is 
											* begin the process of validating the
											* address that was just converted.
    
	BEQ         VALIDATING_BEG_ADDRESS		* Appropriate branch for condition above.
	
    LSL.L       #4,D3                       * Performing a 4 bit shift to the left
										    * will leave room for the next nibble 
											* of the address. After all if we're here
											* then that means there's still some 
											* address to be read in. 
    
	BRA         ASCII_TO_HEX_CHANGER		* Branches back to the beginning of the 
											* subroutine this is done since the
											* counter hasn't reached 0 yet, so 
											* we still have some more characters
											* to convert for the address. 

******
 * The VALIDATING_BEG_ADDRESS subroutine: 
 * --------------------------------------
 * This subroutine is responsible for checking to 
 * see if the starting address is valid or not.
 * If it's not then it'll branch to a subroutine 
 * that will handle invalid start addresses. 
 * If it didn't fail then check if this address 
 * is actually a finishing address by comparing 
 * with D2. If the starting address was already
 * validated it would've added a #1 to D2 as a 
 * toggle of sorts. If it isn't equal to #1 then
 * continue on and add #1 to signal the toggle. 
 * Then move the contents of D3 to the 
 * BEGINNING_ADDRESS variable and then clear 
 * the D3 data register. Once this is complete
 * the disassembler is ready to get the 
 * ending address.
 ****
VALIDATING_BEG_ADDRESS
    BTST        #0,D3						* By performing a BTST on the 0 bit of D3
											* the program is in effect testing the 
											* converted HEX version of the address 
											* which is stored in data register D3 
											* to see if it has an odd address. 
											* Remember BTST will check to see if 
											* the bit is 0. Therefore we use BNE
											* below to leave since it'll mean that
											* the address ends in an odd number. 
											
    BNE         HANDLING_INVALID_BEG_ADDR	* If it's an odd number it's an invalid 
											* beginning address and that means the
											* program must shift control to the 
											* subroutine that handles invalid
											* beginning addresses. 
											
    CMP         #1,D2                       * If you look below you'll see that this
											* subroutine will add #1 to D2. Think of 
											* D2 as a toggle at this stage of the 
											* disassembler. It will be 0 if the 
											* starting address hasn't been validated yet. 
											* Therefore we check to see if it's worth 1 
											* here to see if we should be doing the 
											* starting address or ending address. 
											* This design will always go through here
											* first for starting and ending addresses
    
	BEQ         VALIDATING_FINISH_ADDRESS	* If it is equal to 1, then the program 
											* already has a validated starting address
											* therefore we shift control to the 
											* ending address validation subroutine. 
											
    ADDI        #1,D2                       * As mentioned earlier this is the toggle
											* of sorts that will indicate that the 
											* starting address has been validated 
											* already. If it's 1 then this subroutine 
											* will know to branch to the ending address
											* subroutine instead of overwriting the 
											* starting address with a new one. 
											
    MOVE.L      D3,BEGINNING_ADDRESS		* This will move the contents of the
											* now verified HEX version of the 
											* starting address to the BEGINNING_ADDRESS
											* variable for storage. 
    
	CLR         D3							* The program is now ready to clear the
											* D3 register, so that it can be used by
											* the disassembler to store the HEX
											* version of the ending address. 
											
    BRA         GET_FINISH_ADDR				* Now that beginning address is complete
											* it's time to get the ending address. 

******
 * The VALIDATING_FINISH_ADDRESS subroutine: 
 * --------------------------------------
 * This subroutine is responsible for checking to 
 * see if the ending address is valid or not.
 * If it's not then it'll branch to a subroutine 
 * that will handle invalid start addresses. 
 * These checks include if it's an odd address,
 * and if it's before the beginning address. 
 * 
 * Once those checks are completed, it will 
 * clear the D2 register that was previously 
 * used as a toggle to indicate that the
 * STARTING address was already verified.
 *
 * Then it will load the address into the 
 * ending address variable. Then a space
 * will be printed out for formatting. 
 *
 * Finally this subroutine will branch 
 * to the LOADING_ADDRESSES subroutine
 * for further advancement in the disassembler.
 ****
VALIDATING_FINISH_ADDRESS
    BTST        #0,D3                       * By performing a BTST on the 0 bit of D3
											* the program is in effect testing the 
											* converted HEX version of the address 
											* which is stored in data register D3 
											* to see if it has an odd address. 
											* Remember BTST will check to see if 
											* the bit is 0. Therefore we use BNE
											* below to leave since it'll mean that
											* the address ends in an odd number. 
											
    BNE         HANDLING_INVALID_FINISH_ADDR * If it's an odd number it's an invalid 
											 * ending address and that means the
											 * program must shift control to the 
											 * subroutine that handles invalid
											 * ending addresses.
											 
    CMP.L       BEGINNING_ADDRESS, D3       * By performing a CMP.L on the D3 with 
											* the beginnging address the source 
											* we are checking to see if the ending 
											* address which we have stored in D3 
											* is less than or equal to starting 
											* address provided by the user. 
											
    BLE         HANDLING_INVALID_FINISH_ADDR * If it's less than or equal to the 
											 * starting address then the ending 
											 * address is not valid and we should 
											 * shift control to the subroutine 
											 * that handles invalid ending addresses. 
											 
    CLR.W       D2                          * Once those checks are completed, it will 
											* clear the D2 register that was previously 
											* used as a toggle to indicate that the
											* STARTING address was already verified.
	
    MOVE.L      D3,FINISHING_ADDRESS		* This will move the contents of the
											* now verified HEX version of the 
											* starting address to the FINISHING_ADDRESS
											* variable for storage. 
											
    CLR.W       D3							* The program is now ready to clear the
											* D3 register, so that it can be used by
											* the disassembler to store the HEX
											* version of the ending address. 
											
    LEA         STR_SPACE,A1				* Loads a space into the buffer for printout. 
    MOVE.B      #13,D0						* Loads the trap code #13 for printout 
    TRAP        #15							* Executes the TRAP task. 
	
    BRA         LOADING_ADDRESSES			* Finally this subroutine will branch 
											* to the LOADING_ADDRESSES subroutine
											* for further advancement in the disassembler.
    SIMHALT

******
 * The HANDLING_INVALID_BEG_ADDR subroutine: 
 * --------------------------------------
 * This subroutine is responsible for displaying
 * to the user that the provided beginning 
 * address is invalid and that the user 
 * must enter a new beginning address. 
 ****
HANDLING_INVALID_BEG_ADDR
    MOVEA.L     #0,A1				* Clears the A1 address for future usage. 
    LEA         BAD_INPUT_MSG,A1	* Loads the message about bad input to A1
    MOVE.B      #13,D0				* Preps the TRAP TASK #13
    TRAP        #15					* Executes the TRAP task. 
    CLR         D3					* Clear the D3 register which is used
									* as a storage of the hex addresses. 
    BRA         GET_BEGIN_ADDR		* Branch to the subroutine that will
									* get the user input. 

******
 * The HANDLING_INVALID_FINISH_ADDR subroutine: 
 * --------------------------------------
 * This subroutine is responsible for displaying
 * to the user that the provided finishing 
 * address is invalid and that the user 
 * must enter a new finishing address. 
 ****
HANDLING_INVALID_FINISH_ADDR
    MOVEA.L     #0,A1				* Clears the A1 address for future usage. 
    LEA         BAD_INPUT_MSG,A1	* Loads the message about bad input to A1
    MOVE.B      #13,D0				* Preps the TRAP TASK #13
    TRAP        #15					* Executes the TRAP task. 
    CLR         D3					* Clear the D3 register which is used
									* as a storage of the hex addresses.
    BRA         GET_FINISH_ADDR		* Branch to the subroutine that will
									* get the user input.

******
 * The SWITCH_BAD_INPUT subroutine: 
 * --------------------------------------
 * This subroutine is responsible for changing
 * the control of the program to the appropriate
 * subroutine for handling specific cases 
 * of bad address input. 
 * This subroutine will use the D2 data register 
 * to check since if it's value is 1 then the 
 * toggle has been set and the beginning
 * address has been verified, so then 
 * the ending address must be invalid. 
 ****
SWITCH_BAD_INPUT
    CMP         #1,D2				* Checks the D2 register to see if 
									* the starting address has already
									* been verified.
    BEQ         HANDLING_INVALID_FINISH_ADDR * If it's equal to 1 then 
											 * starting address has 
											 * already been verified
											 * so the ending address
											 * must have been invalid. 
    BRA         HANDLING_INVALID_BEG_ADDR	* If it's 0 then beginning address was wrong. 

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
 * The LOADING_ADDRESSES subroutine: 
 * --------------------------------------
 * This subroutine is responsible for loading 
 * the values stored in the BEGINNING_ADDRESS
 * and FINISHING_ADDRESS to the A2 + A3 
 * addresses since the disassembler 
 * uses the A2 to track its current position
 * of examined spaces in memory while A3 
 * is used to compare to ensure that 
 * the disassembler didn't disassemble 
 * past it's expected ending address. 
 *
 * This subroutine is only invoked once
 * the disassembler has completed all 
 * subroutines that verified that the 
 * starting and ending addresses were
 * entered and converted properly.  
 ****
LOADING_ADDRESSES
    LEA         CHECK_FIRST_NIB_JMPTABLE,A0  * This instruction will load the address 
											 * of the CHECK_FIRST_NIB_JMPTABLE to the A0 
											 * register to enable the decoding 
											 * of the first nibble. 
											 
    MOVE.L      BEGINNING_ADDRESS,A2		 * This instruction is loading the BEGINNING_ADDRESS
											 * variable to a more permanent A2 register
											 * which will be used to track the current position
											 * of the disassembler. 
											 
    MOVE.L      FINISHING_ADDRESS,A3		 * This instruction is loading the FINISHING_ADDRESS
											 * variable to a more permanent A3 register
											 * which will be used to ensure the disassembler
											 * doesn't go past it's ending address. 
											 
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.              * This instruction will begin the 
	                                         * process of parsing the opcode now

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


******************************************************************
* Constant String that is used to print out the data is stored here
******************************************************************
TOGGLE                  DS.W        1           * Allocate 1 word of uninitialized storage
CR EQU $0D
LF EQU $0A

GET_START_ADDR          DC.W        'Please enter starting address',0
GET_END_ADDR            DC.W        'Please enter ending address',0
BAD_INPUT_MSG           DC.W        'INVALID_OPCODE ADDRESS ENTERED',0
FINISH                  DC.W        'Finish Dissassembling. Starting address has reached or passed ending address',0
ENDING_P1       		DC.B        'The given range has been parsed.',CR, LF
						DC.W        'Please enter 0 to end the program or 1 to restart the program.',CR, LF,0
INVALID_ENDING          DC.W        'The given value is not 0 or 1. Please try again.',0
STR_NOP               	DC.W        'NOP',0     * Required
STR_RTS               	DC.W        'RTS',0     * Required
STR_ORI               	DC.W        'ORI',0     * Unfinished
STR_JSR               	DC.W        'JSR',0     * Required
STR_LEA               	DC.W        'LEA',0     * Required
STR_NOT               	DC.W        'NOT',0     * Required
STR_CMPI              	DC.W        'CMPI',0    * Requested
STR_CMP               	DC.W        'CMP',0     * Required
STR_SUB               	DC.W        'SUB',0     * Required
STR_SUBA              	DC.W        'SUBA',0    * Extra
STR_SUBQ              	DC.W        'SUBQ',0    * Requested
STR_DIVS              	DC.W        'DIVS',0    * Requested
STR_BRA               	DC.W        'BRA',0     * Requested
STR_BSR               	DC.W        'BSR',0     * Extra
STR_BEQ               	DC.W        'BEQ',0     * Required
STR_BGT               	DC.W        'BGT',0     * Required
STR_BLE               	DC.W        'BLE',0     * Required
STR_ADD               	DC.W        'ADD',0     * Required
STR_ADDA              	DC.W        'ADDA',0    * Required
STR_ADDQ              	DC.W        'ADDQ',0    * Required
STR_AND               	DC.W        'AND',0     * Required
STR_AS                	DC.W        'AS',0      * Required ASR, ASL
STR_LS                	DC.W        'LS',0      * Required LSR, LSL
STR_RO                	DC.W        'RO',0      * Required ROR, ROL
STR_LEFT          		DC.W        'L',0		* Used for direction print outs for the shift operations above.
STR_RIGHT         		DC.W        'R',0		* Used for direction print outs for the shift operations above.
STR_OR                	DC.W        'OR',0      * Required
STR_MOVEA             	DC.W        'MOVEA',0   * Required
STR_MOVE              	DC.W        'MOVE',0    * Required
STR_MOVEQ             	DC.W        'MOVEQ',0   * Required
STR_MOVEM             	DC.W        'MOVEM',0   * Required
STR_DATA              	DC.W        'DATA',0	* Used to indicate invalid OpCodes
SP_VALUE                DC.W        'SP',0		* Used in the case of SP usage. 
STR_OPEN_BRACK         	DC.W        '(',0		* Symbol used for formatting 
STR_CLOSE_BRACK         DC.W        ')',0		* Symbol used for formatting 
MOVEM_SLASH             DC.W        '/',0		* Symbol used for formatting 
STR_PLUS               	DC.W        '+',0		* Symbol used for formatting 
STR_MINUS              	DC.W        '-',0		* Symbol used for formatting 
STR_DATA_REG           	DC.W        'D',0		* Symbol used for formatting 
STR_ADDR_REG        	DC.W        'A',0		* Symbol used for formatting 
STR_COMMA               DC.W        ',',0		* Symbol used for formatting 
STR_SPACE               DC.W        ' ',0		* Symbol used for formatting 
STR_BIN_SYMBOL          DC.W        '%',0		* Symbol used for formatting 
STR_HEX_SYMBOL          DC.W        '$',0		* Symbol used for formatting 
EA_IMMI_DATA_SYMBOL   	DC.W        '#',0		* Symbol used for formatting 
STR_BYTE_SUFFIX         DC.W        '.B',0		* Symbol used for formatting 
STR_WORD_SUFFIX         DC.W        '.W',0		* Symbol used for formatting 
STR_LONG_SUFFIX         DC.W        '.L',0		* Symbol used for formatting 
STR_ZERO                DC.W        '0',0		* Symbol used for formatting 
STR_ONE                 DC.W        '1',0		* Symbol used for formatting 
STR_TWO                 DC.W        '2',0		* Symbol used for formatting 
STR_THREE               DC.W        '3',0		* Symbol used for formatting 
STR_FOUR                DC.W        '4',0		* Symbol used for formatting 
STR_FIVE                DC.W        '5',0		* Symbol used for formatting 
STR_SIX                 DC.W        '6',0		* Symbol used for formatting 
STR_SEVEN               DC.W        '7',0		* Symbol used for formatting 
STR_EIGHT               DC.W        '8',0		* Symbol used for formatting 
STR_NINE                DC.W        '9',0		* Symbol used for formatting 
STR_A                   DC.W        'A',0		* Symbol used for formatting 
STR_B                   DC.W        'B',0		* Symbol used for formatting 
STR_C                   DC.W        'C',0		* Symbol used for formatting 
STR_D                   DC.W        'D',0		* Symbol used for formatting		 
STR_E                   DC.W        'E',0		* Symbol used for formatting 
STR_F                   DC.W        'F',0		* Symbol used for formatting 


    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
*~Font name~Courier New~





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
