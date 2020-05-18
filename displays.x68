* Display Subroutines


DISP_STR_MOVE
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_MOVE, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_MOVEA
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_MOVEA, A1   
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_BYTE
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_BYTE, A1   
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_WORD
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_WORD, A1   
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_LONG
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_LONG, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_COMMA
    MOVEA.L #0, A1
    LEA STR_COMMA, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_D
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_D, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_A
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_A, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_0
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_0, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_1
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_1, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_2
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_2, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_3
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_3, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_4
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_4, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_5
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_5, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_6
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_6, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

DISP_STR_7
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_7, A1
    MOVE.B #14, D0
    TRAP #15
    RTS