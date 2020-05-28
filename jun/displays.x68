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
    LEA STR_SPACE, A1                   
    JSR TRAP13
    RTS

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

DISP_STR_LEA
    LEA STR_LEA, A1
    JSR TRAP14
    RTS

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

DISP_STR_A 
    LEA STR_A, A1
    JSR TRAP14
    RTS
DISP_STR_D 
    LEA STR_D, A1
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
    