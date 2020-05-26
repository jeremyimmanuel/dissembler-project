****************************
* Universal Constants File *
****************************

* Instruction strings
STR_MOVE    DC.W 'MOVE', 0
STR_MOVEA   DC.W 'MOVEA', 0
STR_MOVEM   DC.W 'MOVEM', 0
STR_LEA     DC.W 'LEA', 0
STR_JSR     DC.W 'RTS', 0
STR_BCC     DC.W 'BCC', 0
STR_BGT     DC.W 'BGT', 0
STR_BLE     DC.W 'BLE', 0

* Data size
STR_BYTE    DC.W '.B ', 0
STR_WORD    DC.W '.W ', 0
STR_LONG    DC.W '.L ', 0

* Numbers
STR_0      DC.W '0', 0
STR_1      DC.W '1', 0
STR_2      DC.W '2', 0
STR_3      DC.W '3', 0
STR_4      DC.W '4', 0
STR_5      DC.W '5', 0
STR_6      DC.W '6', 0
STR_7      DC.W '7', 0
STR_8      DC.W '8', 0
STR_9      DC.W '9', 0


* Letters
STR_A      DC.W 'A', 0
STR_B      DC.W 'B', 0
STR_C      DC.W 'C', 0
STR_D      DC.W 'D', 0
STR_E      DC.W 'E', 0
STR_F      DC.W 'F', 0

* Comma
STR_COMMA  DC.W ', ', 0

* Space
STR_SPACE   DC.W ' ', 0

* Error message
STR_ERROR   DC.L 'Invalid Opcode', 0
error_message               DC.B 'Invalid Address exception, input was was not valid hex value', CR, LF, 0

* Prompts
start_addr_instruction     DC.B 'Enter starting address (in hex, Capital letters and numbers only):', CR, LF, 0
end_addr_instruction       DC.B 'Enter ending address (in hex, Capital letters and numbers only):', CR, LF, 0