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
STR_NOT_SUPPORTED		DC.W 		'NOT SUPPORTED', 0