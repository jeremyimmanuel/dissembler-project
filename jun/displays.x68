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

DISP_STR_LSLm
    LEA STR_LSLm, A1
    JSR TRAP14
    RTS

DISP_STR_LSLr
    LEA STR_LSLr, A1
    JSR TRAP14
    RTS

DISP_STR_ASRm
    LEA STR_ASRm, A1
    JSR TRAP14
    RTS

DISP_STR_ASRr
    LEA STR_ASRr, A1
    JSR TRAP14
    RTS

******************************************
DISP_STR_COMMA
    MOVEA.L #0, A1
    LEA STR_COMMA, A1
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
    LEA STR_8, A1
    JSR TRAP14
    RTS

DISP_STR_9
    LEA STR_9, A1
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
    