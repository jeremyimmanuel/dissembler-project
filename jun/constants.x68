****************************
* Universal Constants File *
****************************

* Instruction strings
CR                          EQU     $0D
LF                          EQU     $0A
STR_MOVE                    DC.W    'MOVE', 0
STR_MOVEA                   DC.W    'MOVEA', 0
STR_MOVEM                   DC.W    'MOVEM', 0
STR_LEA                     DC.W    'LEA', 0
STR_RTS                     DC.W    'RTS', 0
STR_JSR                     DC.W    'JSR', 0
STR_BCC                     DC.W    'BCC', 0
STR_BGT                     DC.W    'BGT', 0
STR_BLE                     DC.W    'BLE', 0
STR_OR                      DC.W    'OR',  0
STR_SUB                     DC.W    'SUB', 0
STR_CMP                     DC.W    'CMP', 0
STR_AND                     DC.W    'AND', 0
STR_ADD                     DC.W    'ADD', 0

STR_LSLm                    DC.W   'LSLm', 0
STR_LSLr                    DC.W   'LSLr', 0
STR_ASRm                    DC.W   'ASRm', 0
STR_ASRr                    DC.W   'ASRr', 0

STR_OPEN_BRACK         	    DC.W    '(', 0   * Symbol used for formatting 
STR_CLOSE_BRACK             DC.W    ')', 0   * Symbol used for formatting 
MOVEM_SLASH                 DC.W    '/', 0   * Symbol used for formatting 
STR_PLUS               	    DC.W    '+', 0   * Symbol used for formatting 
STR_MINUS              	    DC.W    '-', 0   * Symbol used for formatting 
STR_DATA_REG           	    DC.W    'D', 0   * Symbol used for formatting 
STR_ADDR_REG        	    DC.W    'A', 0   * Symbol used for formatting 
STR_COMMA                   DC.W    ',', 0   * Symbol used for formatting 
STR_SPACE                   DC.W    ' ', 0   * Symbol used for formatting 
STR_BIN_SYMBOL              DC.W    '%', 0   * Symbol used for formatting 
STR_HEX_SYMBOL              DC.W    '$', 0   * Symbol used for formatting 
EA_IMMI_DATA_SYMBOL   	    DC.W    '#', 0   * Symbol used for formatting 

* Data size                
STR_BYTE                    DC.W '.B ', 0
STR_WORD                    DC.W '.W ', 0
STR_LONG                    DC.W '.L ', 0

* Numbers                   
STR_0                       DC.W '0', 0
STR_1                       DC.W '1', 0
STR_2                       DC.W '2', 0
STR_3                       DC.W '3', 0
STR_4                       DC.W '4', 0
STR_5                       DC.W '5', 0
STR_6                       DC.W '6', 0
STR_7                       DC.W '7', 0
STR_8                       DC.W '8', 0
STR_9                       DC.W '9', 0

* Letters                   
STR_A                       DC.W 'A', 0
STR_B                       DC.W 'B', 0
STR_C                       DC.W 'C', 0
STR_D                       DC.W 'D', 0
STR_E                       DC.W 'E', 0
STR_F                       DC.W 'F', 0

* Comma                 
STR_COMMA                   DC.W ', ', 0

* Space
NEW_LINE                    DC.B CR,LF, 0
STR_SPACE                   DC.W ' ', 0

* Error message
STR_ERROR                   DC.L 'Invalid Opcode', 0
error_message               DC.B 'Invalid Address exception, input was was not valid hex value', CR, LF, 0

* Prompts
start_addr_instruction      DC.B 'Enter starting address (in hex, Capital letters and numbers only):', CR, LF, 0
end_addr_instruction        DC.B 'Enter ending address (in hex, Capital letters and numbers only):', CR, LF, 0