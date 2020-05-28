* Display Subroutines
* All these DISPLAY subroutines must be called via
* a BSR / JSR because of the RTS
TRAP14
    MOVE.B #14, D0
    TRAP #15
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

DISP_STR_D 
    LEA STR_D, A1
    JSR TRAP14
    RTS

DISP_STR_A 
    LEA STR_A, A1
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

DISP_ERROR_MESSAGE
    LEA STR_ERROR, A1
    JSR TRAP14
    RTS