* Instruction strings
CR                          EQU     $0D
LF                          EQU     $0A
Str_MOVE                    DC.W    'MOVE', 0
Str_MOVEA                   DC.W    'MOVEA', 0
Str_MOVEM                   DC.W    'MOVEM', 0
Str_LEA                     DC.W    'LEA', 0
Str_RTS                     DC.W    'RTS', 0
Str_JSR                     DC.W    'JSR', 0
Str_BCC                     DC.W    'BCC', 0
Str_BGT                     DC.W    'BGT', 0
Str_BLE                     DC.W    'BLE', 0
Str_OR                      DC.W    'OR',  0
Str_SUB                     DC.W    'SUB', 0
Str_CMP                     DC.W    'CMP', 0
Str_AND                     DC.W    'AND', 0
Str_ADD                     DC.W    'ADD', 0

Str_LSLm                    DC.W   'LSLm', 0
Str_LSLr                    DC.W   'LSLr', 0
Str_ASRm                    DC.W   'ASRm', 0
Str_ASRr                    DC.W   'ASRr', 0

Str_Open_Brack_Symbol       DC.W    '(', 0  
Str_Close_Brack_Symbol      DC.W    ')', 0  
Str_Slash_Symbol            DC.W    '/', 0  
Str_Plus_Symbol             DC.W    '+', 0  
Str_Minus_Symbol            DC.W    '-', 0  
Str_Data_Reg           	    DC.W    'D', 0  
Str_Addr_Reg        	    DC.W    'A', 0  
Str_Comma_Symbol            DC.W    ',', 0  
Str_Bin_Symbol              DC.W    '%', 0  
Str_Hex_Symbol              DC.W    '$', 0  
Str_Hashtag_Symbol   	    DC.W    '#', 0  

* Data size                
Str_BYTE                    DC.W '.B ', 0
Str_WORD                    DC.W '.W ', 0
Str_LONG                    DC.W '.L ', 0

* Numbers                   
Str_0                       DC.W '0', 0
Str_1                       DC.W '1', 0
Str_2                       DC.W '2', 0
Str_3                       DC.W '3', 0
Str_4                       DC.W '4', 0
Str_5                       DC.W '5', 0
Str_6                       DC.W '6', 0
Str_7                       DC.W '7', 0
Str_8                       DC.W '8', 0
Str_9                       DC.W '9', 0

* Dn
Str_D0                       DC.W 'D0', 0
Str_D1                       DC.W 'D1', 0
Str_D2                       DC.W 'D2', 0
Str_D3                       DC.W 'D3', 0
Str_D4                       DC.W 'D4', 0
Str_D5                       DC.W 'D5', 0
Str_D6                       DC.W 'D6', 0
Str_D7                       DC.W 'D7', 0
Str_D8                       DC.W 'D8', 0
Str_D9                       DC.W 'D9', 0

* An
Str_A0                       DC.W 'A0', 0
Str_A1                       DC.W 'A1', 0
Str_A2                       DC.W 'A2', 0
Str_A3                       DC.W 'A3', 0
Str_A4                       DC.W 'A4', 0
Str_A5                       DC.W 'A5', 0
Str_A6                       DC.W 'A6', 0
Str_A7                       DC.W 'A7', 0
Str_A8                       DC.W 'A8', 0
Str_A9                       DC.W 'A9', 0

* (An) 
Str_Indr_A0                      DC.W '(A0)', 0
Str_Indr_A1                      DC.W '(A1)', 0
Str_Indr_A2                      DC.W '(A2)', 0
Str_Indr_A3                      DC.W '(A3)', 0
Str_Indr_A4                      DC.W '(A4)', 0
Str_Indr_A5                      DC.W '(A5)', 0
Str_Indr_A6                      DC.W '(A6)', 0
Str_Indr_A7                      DC.W '(A7)', 0
Str_Indr_A8                      DC.W '(A8)', 0
Str_Indr_A9                      DC.W '(A9)', 0

* (An)+
Str_PlusIndr_A0                      DC.W '(A0)', 0
Str_PlusIndr_A1                      DC.W '(A1)', 0
Str_PlusIndr_A2                      DC.W '(A2)', 0
Str_PlusIndr_A3                      DC.W '(A3)', 0
Str_PlusIndr_A4                      DC.W '(A4)', 0
Str_PlusIndr_A5                      DC.W '(A5)', 0
Str_PlusIndr_A6                      DC.W '(A6)', 0
Str_PlusIndr_A7                      DC.W '(A7)', 0
Str_PlusIndr_A8                      DC.W '(A8)', 0
Str_PlusIndr_A9                      DC.W '(A9)', 0

* -(An) 
Str_MinusIndr_A0                      DC.W '(A0)', 0
Str_MinusIndr_A1                      DC.W '(A1)', 0
Str_MinusIndr_A2                      DC.W '(A2)', 0
Str_MinusIndr_A3                      DC.W '(A3)', 0
Str_MinusIndr_A4                      DC.W '(A4)', 0
Str_MinusIndr_A5                      DC.W '(A5)', 0
Str_MinusIndr_A6                      DC.W '(A6)', 0
Str_MinusIndr_A7                      DC.W '(A7)', 0
Str_MinusIndr_A8                      DC.W '(A8)', 0
Str_MinusIndr_A9                      DC.W '(A9)', 0

* Letters                   
Str_A                       DC.W 'A', 0
Str_B                       DC.W 'B', 0
Str_C                       DC.W 'C', 0
Str_D                       DC.W 'D', 0
Str_E                       DC.W 'E', 0
Str_F                       DC.W 'F', 0

* Space
New_Line                    DC.B CR,LF, 0
Str_Space                   DC.W ' ', 0

* Error message
Str_ERROR                   DC.L 'Invalid Opcode', 0
Error_Message               DC.B 'Invalid Address exception, input was was not valid hex value', CR, LF, 0

* Prompts
Start_Addr_Instruction      DC.B 'Enter starting address (in hex, Capital letters and numbers only):', CR, LF, 0
End_Addr_Instruction        DC.B 'Enter ending address (in hex, Capital letters and numbers only):', CR, LF, 0