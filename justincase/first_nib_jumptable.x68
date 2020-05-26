* first_nib_jumptable.x68
CHECK_FIRST_NIB_JMPTABLE                  * Based on the first byte of the op code then jump on what is possible
    JMP         FIRST_NIB_0               * NOT SUPPORTED
    JMP         FIRST_NIB_1               * MOVE.B
    JMP         FIRST_NIB_2               * MOVEA.L, MOVE.L
    JMP         FIRST_NIB_3               * MOVE.W, MOVEA.W
    JMP         FIRST_NIB_4               * MOVEM, LEA, JSR, RTS
    JMP         FIRST_NIB_5               * NOT SUPPORTED
    JMP         FIRST_NIB_6               * BCC, BGT, BLE
    JMP         FIRST_NIB_7               * NOT SUPPORTED
    JMP         FIRST_NIB_8               * OR
    JMP         FIRST_NIB_9               * SUB
    JMP         FIRST_NIB_A               * NOT SUPPORTED
    JMP         FIRST_NIB_B               * CMP
    JMP         FIRST_NIB_C               * AND
    JMP         FIRST_NIB_D               * ADD
    JMP         FIRST_NIB_E               * LSL, ASR
    JMP         FIRST_NIB_F               * NOT SUPPORTED

FIRST_NIB_0
    BRA INVALID_OPCODE			; invalid opcodes
    SIMHALT

* MOVE.B
FIRST_NIB_1 
    JSR         OPCODE_MOVE_UTILITY			; Have the OPCODE_MOVE_UTILITY handle it
                                            ; move.x68
    SIMHALT

FIRST_NIB_2 
    JSR         OPCODE_MOVE_UTILITY		* Have the OPCODE_MOVE_UTILITY handle it 
    SIMHALT

FIRST_NIB_3 
    JSR         OPCODE_MOVE_UTILITY		* Have the OPCODE_MOVE_UTILITY handle it 
    SIMHALT

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

FIRST_NIB_7  * This is MOVEQ
    BRA         INVALID_OPCODE				* Branch to Invalid OpCode if it's not 
    SIMHALT

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

FIRST_NIB_A  
    BRA         INVALID_OPCODE
    SIMHALT

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


FIRST_NIB_D *ADD
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

FIRST_NIB_F 
    BRA         RESTART_OR_FINISH
    RTS
    SIMHALT