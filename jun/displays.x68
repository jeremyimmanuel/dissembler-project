* Display Subroutines
* All these DISPLAY subroutines must be called via
* a BSR / JSR because of the RTS
TRAP13
    MOVE.B #13, D0
    TRAP #15
    RTS

TRAP14
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_START_ADDR_PROMPT
    MOVEA.L #0, A1      ; Clear A1
    LEA     start_addr_instruction, A1  ; Display promp for starting address
    JSR TRAP14
    RTS

PRESS_ENTER_CHECK
    ADD         #1, D6					* D6 is used as the counter for number of 
										* statements printed out. 
    CMP         #30, D6 					* Since the screen is about 30 statements 
										* in height, then this counter needs 
										* to reach 30 before the user can press enter. 
    BEQ         PRESS_ENTER_CONT_CHECK	* If 30 has been reached let the user enter. 
    LEA         Str_Space, A1			* If not then just print a string.
    MOVE        #13, D0					* Loads TRAP TASK #13
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
    MOVE        #0, D6		* Reset the counter which is D6
    MOVE.B      #5, D0		* Load TRAP TASK #5	
    TRAP        #15			* Execute the TRAP TASK
    RTS						* Rerturn to the subroutine.

* * * * * * * * * * *
* TODO - Implement  *
* * * * * * * * * * *
OUTPUT_ADDR_LOC
    MOVE.L      A2,D5 							* Store the current address that the disassembler is at					
    MOVE.L      D5,CURR_NIBBLES_MEM_LOC     * Copy the long address in its entirety 
    JSR         HEX_2_ASCII			        * Output the 8 bit data field
    MOVE.W      A2,D5							* Store the current address that the disassembler is at
    MOVE.W      D5,CURR_NIBBLES_MEM_LOC		* Copy the long address in its entirety 
    JSR         HEX_2_ASCII		        * Output the 8 bit data field
    JSR         DISP_STR_SPACE			* Invokes subroutine to print a space
    RTS

DISP_INVALID_ADDRESS_ERROR
    LEA         error_message, A1               ; Load error message
    MOVE.B      #13,D0                          ; Trap task 13
    TRAP        #15    
    RTS

DISP_NEW_LINE
    LEA NEW_LINE, A1                   
    JSR TRAP14
    RTS

********************* Op-code *********************
DISP_STR_MOVE
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_MOVE, A1
    JSR TRAP14
    RTS

DISP_STR_MOVEA
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_MOVEA, A1   
    JSR TRAP14
    RTS

DISP_STR_MOVEM
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_MOVEM, A1
    JSR TRAP14
    RTS

DISP_STR_LEA
    LEA STR_LEA, A1
    JSR TRAP14
    RTS

DISP_STR_RTS
    LEA STR_RTS, A1
    JSR TRAP14
    RTS

DISP_STR_JSR
    LEA STR_JSR, A1
    JSR TRAP14
    RTS

DISP_STR_BCC
    LEA STR_BCC, A1
    JSR TRAP14
    RTS
DISP_STR_BGT
    LEA STR_BGT, A1
    JSR TRAP14
    RTS
DISP_STR_BLE
    LEA STR_BLE, A1
    JSR TRAP14
    RTS

DISP_STR_OR
    LEA STR_OR, A1
    JSR TRAP14
    RTS

DISP_STR_SUB
    LEA STR_SUB, A1
    JSR TRAP14
    RTS

DISP_STR_CMP
    LEA STR_CMP, A1
    JSR TRAP14
    RTS

DISP_STR_AND
    LEA STR_AND, A1
    JSR TRAP14
    RTS

DISP_STR_ADD
    LEA STR_ADD, A1
    JSR TRAP14
    RTS

DISP_STR_LSL
    LEA STR_LSL, A1
    JSR TRAP14
    RTS

DISP_STR_ASR
    LEA STR_ASR, A1
    JSR TRAP14
    RTS

DISP_STR_COMMA
    MOVEA.L #0, A1
    LEA Str_Comma_Symbol, A1
    JSR TRAP14
    RTS

DISP_STR_BYTE
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_BYTE, A1   
    JSR TRAP14
    RTS

DISP_STR_WORD
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_WORD, A1   
    JSR TRAP14
    RTS

DISP_STR_LONG
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_LONG, A1
    JSR TRAP14
    RTS

DISP_STR_SPACE
    MOVEA.L #0, A1
    LEA STR_SPACE, A1
    JSR TRAP14
    RTS

DISP_STR_0
    LEA STR_0, A1
    JSR TRAP14
    RTS

DISP_STR_1
    LEA STR_1, A1
    JSR TRAP14
    RTS

DISP_STR_2
    LEA STR_2, A1
    JSR TRAP14
    RTS

DISP_STR_3
    LEA STR_3, A1
    JSR TRAP14
    RTS

DISP_STR_4
    LEA STR_4, A1
    JSR TRAP14
    RTS

DISP_STR_5
    LEA STR_5, A1
    JSR TRAP14
    RTS

DISP_STR_6
    LEA STR_6, A1
    JSR TRAP14
    RTS

DISP_STR_7
    LEA STR_7, A1
    JSR TRAP14
    RTS

DISP_STR_8
    LEA Str_8, A1
    JSR TRAP14
    RTS

DISP_STR_9
    LEA Str_9, A1
    JSR TRAP14
    RTS

DISP_STR_A 
    LEA STR_A, A1
    JSR TRAP14
    RTS

DISP_STR_B 
    LEA STR_B, A1
    JSR TRAP14
    RTS

DISP_STR_C 
    LEA STR_C, A1
    JSR TRAP14
    RTS

DISP_STR_D 
    LEA STR_D, A1
    JSR TRAP14
    RTS

DISP_STR_E 
    LEA STR_E, A1
    JSR TRAP14
    RTS

DISP_STR_F 
    LEA STR_F, A1
    JSR TRAP14
    RTS

DISP_ERROR_MESSAGE
    LEA STR_ERROR, A1
    JSR TRAP14
    RTS

DISP_Str_Data_Reg
    LEA Str_Data_Reg, A1
    JSR TRAP14
    RTS

DISP_Str_Addr_Reg
    LEA Str_Addr_Reg, A1
    JSR TRAP14
    RTS    

DISP_Str_Open_Brack_Symbol
    LEA Str_Open_Brack_Symbol, A1
    JSR TRAP14
    RTS   

DISP_Str_Close_Brack_Symbol
    LEA Str_Close_Brack_Symbol, A1
    JSR TRAP14
    RTS   

DISP_Str_Plus_Symbol
    LEA Str_Plus_Symbol, A1
    JSR TRAP14
    RTS   

DISP_Str_Minus_Symbol
    LEA Str_Minus_Symbol, A1
    JSR TRAP14
    RTS   

DISP_Str_Hex_Symbol
    LEA Str_Hex_Symbol, A1
    JSR TRAP14
    RTS

DISP_Str_Hashtag_Symbol
    LEA Str_Hashtag_Symbol, A1
    JSR TRAP14
    RTS

DISP_Str_Slash_Symbol
    LEA Str_Slash_Symbol, A1
    JSR TRAP14
    RTS