*-----------------------------------------------------------
* Title      : constants.x68
* Written by : Jeremy, Angie, Jun
* Date       : June 8th, 2020
* Description: Stores every string constatnts used in program
*-----------------------------------------------------------

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

Str_LSL                    DC.W   'LSL', 0
Str_ASR                    DC.W   'ASR', 0

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
Str_Empty                   DC.W '', 0

* Intro Banner
Banner       DC.B    '************************************************************************',CR,LF     
             DC.B    '*                        W E L C O M E ',CR,LF,CR,LF
             DC.B    '*                            TO ',CR,LF,CR,LF
             DC.B    '*                     D I S S A S E M B L E R ',CR,LF,CR,LF
             DC.B    '*  TEAM: GROUP 1',CR,LF,CR,LF
             DC.B    '*  TEAM MEMBERS: JEREMY TANDJUNG, ANGIE TSERENJAV, JUN ZHEN',CR,LF,CR,LF
             DC.B    '************************************************************************',CR,LF,CR,LF,0


* Error message
Str_ERROR                   DC.L 'Invalid Opcode', 0
Str_ERROR_EA                DC.L 'Invalid Effective Address', 0
Error_Message               DC.B 'Invalid Address exception, input was was not valid hex value', CR, LF, 0

* Prompts
Start_Addr_Instruction      DC.B 'Enter starting address (in hex, Capital letters and numbers only):', CR, LF, 0
End_Addr_Instruction        DC.B 'Enter ending address (in hex, Capital letters and numbers only):', CR, LF, 0
Press_Enter_Instruction     DC.B 'Press Enter to continue', 0
Restart_Instruction         DC.B 'Please enter 0 to exit the program, or 1 to restart the program ', 0
