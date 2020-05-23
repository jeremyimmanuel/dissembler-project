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