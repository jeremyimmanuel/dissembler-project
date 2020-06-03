*-----------------------------------------------------------
* Title      : constants.x68
* Written by : Jeremy, Angie, Jun
* Date       : June 8th, 2020
* Description: Stores every display/print statements used 
*               in this program. When calling DISPS, please
*               use JSR or BSR so that it can RTS
*-----------------------------------------------------------
TRAP13              ; print(content of A1)
    MOVE.B #13, D0
    TRAP #15
    RTS

TRAP14              ; println(content of A1)
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_BANNER                     ; Displayes introduction banner
    MOVEA.L #0, A1              ; Clear A1
    LEA Banner, A1
    JSR TRAP14
    RTS

DISP_START_ADDR_PROMPT
    MOVEA.L #0, A1                      ; Clear A1
    LEA     start_addr_instruction, A1  ; Display promp for starting address
    JSR     TRAP14
    RTS

Check_Full_Screen
    ADD         #1, D2					; uses D2 as a line counter									
    CMP         #31, D2 				; one full screen of easy68k sim terminal
                                        ; is 30 lines, we use 31 to accomodate the
                                        ; press enter to continue prompt
										
    BGE         Press_Enter_To_Continue	; if 31 lines have been reached, display the press enter check
    LEA         Str_Empty, A1			
    JSR         TRAP14
    RTS									

Press_Enter_To_Continue
    JSR         DISP_PRESS_ENTER        ; Display press enter prompt
    MOVE        #0, D2		            ; Reset line counter at D2
    MOVE.B      #5, D0
    TRAP        #15	
    RTS					

DISP_ADDR_LOC
    MOVE.L      A2, D5 							; Store the current address to D5 
    MOVE.L      D5, CURR_NIBBLES_MEM_LOC        ; Move current address value to memory
    JSR         HEX_2_ASCII			            ; Displays the first four hexabits
    MOVE.W      A2, D5							; Repeat but word to get last four hexabits
    MOVE.W      D5, CURR_NIBBLES_MEM_LOC		
    JSR         HEX_2_ASCII		        
    JSR         DISP_STR_SPACE			        ; Display space
    RTS

DISP_INVALID_ADDRESS_ERROR
    LEA         error_message, A1                ; Load error message
    JSR         TRAP13
    RTS

DISP_NEW_LINE
    LEA NEW_LINE, A1                   
    JSR TRAP14
    RTS

DISP_PRESS_ENTER
    LEA Press_Enter_Instruction, A1
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

********* Data size ***********

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

********* Numbers ****************

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

********* Letters ****************

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