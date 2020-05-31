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

WHOLE_MESSAGE_OUTPUT
    MOVE.B #14, D0
    TRAP #15
    RTS

******************************************************************
* Constant String that is used to print out the data is stored here
******************************************************************


TOGGLE                  DS.W        1           * Allocate 1 word of uninitialized storage
CR EQU $0D
LF EQU $0A


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

DISP_D					DC.W        'D', 0
DISP_I					DC.W 		'I', 0

    