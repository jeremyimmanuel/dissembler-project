* move.x68
OPCODE_MOVE_UTILITY
    MOVE.W      CURR_NIBBLES_MEM_LOC, D3	* Reload the current four nibbles that 
    JSR         UPDATE_DEST_SRC_VAR			* This subroutine will update the Destination Source Variable. 
    CMP         #%001, DEST_MODE_VAR		* If it's #%001 then it's MOVEA 
    BEQ         MOVEA_OUTPUT
    BRA         OUTPUT_MOVE					* It's MOVE otherwise 
    RTS

MOVEA_OUTPUT
    LEA         STR_MOVEA, A1
    JSR         UTILITY_MOVE_TWO_OP

OUTPUT_MOVE
    LEA         STR_MOVE, A1
    JSR         UTILITY_MOVE_TWO_OP

UPDATE_DEST_SRC_VAR
    MOVE.W      CURR_NIBBLES_MEM_LOC, D3	* Reload the current four nibbles that 
										    * other subroutines will need for validation. 
    LSL         #4,D3                       * Get rid of left most nibble 
    LSR         #4,D3                       * Manipulate D3 so that we can find 
											* the destination mode, mode, source. 
											* This part will focus on getting the destination first
    LSR         #8,D3                       * After the manipulations the D3 holds the destination
    LSR         #1,D3
    MOVE.W      D3,DEST_HOLDER				* Copy the Destination to the DEST_HOLDER
    MOVE.W      CURR_NIBBLES_MEM_LOC,D3	* Reload the current four nibbles that 
    LSL         #7,D3
    LSR         #7,D3
    LSR         #6,D3
    MOVE.W      D3,DEST_MODE_VAR			* Now has DEST_MODE_VAR so copy to it
    MOVE.W      CURR_NIBBLES_MEM_LOC,D3	* Reload the current four nibbles that 
										
    LSL         #8,D3
    LSL         #2,D3
    LSR         #8,D3
    LSR         #2,D3
    LSR         #3,D3
    MOVE.W      D3,SRC_MODE_HOLDER          * After manipulation copy source mode over
											* finally get the source itself
    MOVE.W      CURR_NIBBLES_MEM_LOC,D3	* Reload the current four nibbles that 
											
    LSL         #8,D3
    LSL         #5,D3
    LSR         #8,D3
    LSR         #5,D3
    MOVE.W      D3,SRC_HOLDER				* Copy over the source 
    MOVE.W      CURR_NIBBLES_MEM_LOC,D3	* Reload the current four nibbles that 										
    RTS

UTILITY_MOVE_TWO_OP
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    LEA         OUTPUT_SIZE_OF_MOVE_JMPTABLE,A6  * Load address of jump tables for determining size of MOVE commands
    MOVE.W      CURR_NIBBLES_MEM_LOC,D3	* Reload the current four nibbles that 
    JSR         STORE_FIRST_NIBBLE_IN_D3	* This instruction is a jump to a								
    MULU        #6,D3						* Multiply unsigned by D3 to use it as an offset for JSR 
    JSR         0(A6,D3)					* Jumps to subroutine for the size with offset. 
    JSR         OUTPUT_DATA_MODE_SOURCE		* This subroutine will output the data mode source.
    JSR         OUTPUT_COMMA				* This invokes a subroutine that will output a comma
    JSR         DISP_STR_SPACE			* Invokes subroutine to print a space
    JSR         OUTPUT_DATA_MODE_DEST		* This method will output the data stored in the 12-7 bits
    BSR         PRESS_ENTER_CHECK			* Branch to the PRESS_ENTER_CHECK subroutine to see if a new screen of more output is ready.
    BRA         DERIVING_OPCODE				* Branch to the subroutine for checking the next word and parsing it to see if it's an OpCode.
    RTS

OUTPUT_DATA_MODE_SOURCE         
    LEA         JMPTABLE_FINDING_REG_MODE,A6	* Loads the address of the jump table for determining register mode 
    MOVE.W      SRC_HOLDER, UTILITY_VAR			* Stores the SRC_HOLDER in the UTILITY_VAR for arithmetic 
    MOVE        SRC_MODE_HOLDER,D3				* Store the SRC_MODE_HOLDER in D3 for arithmetic 
    MULU        #6,D3							* Multiply unsigned by D3 to use it as an offset for JSR		
    JSR         0(A6,D3)       					* Go to the jump table with appropraite offset to find the source mode
    RTS

OUTPUT_COMMA
    LEA         STR_COMMA,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    RTS

OUTPUT_DATA_MODE_DEST
    LEA         JMPTABLE_FINDING_REG_MODE,A6	* Loads the address of the jump table for determining register mode 
    MOVE.W      DEST_HOLDER, UTILITY_VAR        * Used in process of finding which type of register to output
    MOVE.W      DEST_MODE_VAR,D3			* Stores the DEST_MODE_VAR in D3 for arithmetic 
    MULU        #6,D3						* Multiply unsigned by D3 to use it as an offset for JSR
    JSR         0(A6,D3)					* Go to the jump table with appropraite offset to find the destination mode
    RTS


