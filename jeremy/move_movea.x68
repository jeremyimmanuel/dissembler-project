MOVE_MOVEA
    * get the Size
    * 00 11 111 000 000 110
    * L2
    * 11 111 000 000 110 00
    * R14
    *
    * Goal: 0000 0000 0000 0011
    MOVE.W D1, D3
    LSL.W #2, D3    * remove trailing first two bits
    LSR.W #8, D3
    LSR.W #6, D3
    MOVE.B D3, D3

    * get destination register
    * 00 11 111 000 000 110
    * L4maybe_move
    *
    * Goal: 0000 0000 0000 0000
    MOVE.W D1, D5
    LSL.W #7, D5
    LSR.W #8, D5
    LSR.W #5, D5
    MOVE.B D5, D5

    * get source mode
    * 00 11 111 000 000 110
    * L10
    * 000 000 000 0000 000
    * R13
    *
    * Goal: 0000 0000 0000 0000
    MOVE.W D1, D6
    LSL.W #8, D6
    LSL.W #2, D6
    LSL.W #8, D6
    LSL.W #5, D6
    MOVE.B D6, D6

    * get source register
    * get destination register
    * 00 11 111 000 000 110
    * L13
    * 110 000 000 000 0000
    * R13
    *
    * Goal: 0000 0000 0000 0110
    MOVE.W D1, D7
    LSL.W #8, D7
    LSL.W #5, D7
    LSR.W #8, D7
    LSR.W #5, D7
    MOVE.B D7, D7


    CMP.B #1, D5    ; if 1 then MOVEA
    BEQ START_MOVEA_SR
    BNE START_MOVE_SR

START_MOVEA_SR:
    JSR DISP_STR_MOVEA
    BRA CHECK_DATA_TYPE

START_MOVE_SR:
    JSR DISP_STR_MOVE   ; prints 'MOVE'
    BRA CHECK_DATA_TYPE

CHECK_DATA_TYPE
    CMP.B #1, D3        ; Byte
    BEQ MOVE_UTIL_DISP_BYTE   ; will branch to CHECK_SOURCE_MODE

    CMP.B #2, D3        ; Long
    BEQ MOVE_UTIL_DISP_LONG   ; will branch to CHECK_SOURCE_MODE
    
    CMP.B #3, D3        ; Word
    BEQ MOVE_UTIL_DISP_WORD   ; will branch to CHECK_SOURCE_MODE inside this sr

PRINT_MOVE_BYTE
    JSR DISP_STR_BYTE
    BRA CHECK_SOURCE_MODE

MOVE_UTIL_DISP_LONG
    JSR DISP_STR_LONG
    BRA CHECK_SOURCE_MODE

MOVE_UTIL_DISP_WORD 
    JSR DISP_STR_WORD
    BRA CHECK_SOURCE_MODE

CHECK_SOURCE_MODE:
    CMP.B #0, D6
    BEQ MOVE_UTIL_SOURCE_MODE_D
    CMP.B #1, D6
    BEQ MOVE_UTIL_SOURCE_MODE_A
    CMP.B #2, D6
    CMP.B #3, D6
    CMP.B #4, D6
    CMP.B #5, D6
    CMP.B #6, D6
    CMP.B #7, D6



DISP_SOURCE_MODE_D
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_D, A1
    JSR TRAP14
    BRA CHECK_SOURCE_REGISTER

DISP_SOURCE_MODE_A
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_A, A1
    JSR TRAP14
    BRA CHECK_SOURCE_REGISTER

CHECK_SOURCE_REGISTER:
    CMP.B #0, D7
    BEQ DISP_SOURCE_REG_0
    CMP.B #1, D7
    BEQ DISP_SOURCE_REG_1
    CMP.B #2, D7
    BEQ DISP_SOURCE_REG_2
    CMP.B #3, D7
    BEQ DISP_SOURCE_REG_3
    CMP.B #4, D7
    BEQ DISP_SOURCE_REG_4
    CMP.B #5, D7
    BEQ DISP_SOURCE_REG_5
    CMP.B #6, D7
    BEQ DISP_SOURCE_REG_6
    CMP.B #7, D7
    BEQ DISP_SOURCE_REG_7
   
DISP_SOURCE_REG_0
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_0, A1
    MOVE.B #14, D0
    TRAP #15
    BRA CHECK_DES_MODE

DISP_SOURCE_REG_1
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_1, A1
    MOVE.B #14, D0
    TRAP #15
    BRA CHECK_DES_MODE

DISP_SOURCE_REG_2
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_2, A1
    MOVE.B #14, D0
    TRAP #15
    BRA CHECK_DES_MODE

DISP_SOURCE_REG_3
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_3, A1
    MOVE.B #14, D0
    TRAP #15
    BRA CHECK_DES_MODE

DISP_SOURCE_REG_4
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_4, A1
    MOVE.B #14, D0
    TRAP #15
    BRA CHECK_DES_MODE

DISP_SOURCE_REG_5
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_5, A1
    MOVE.B #14, D0
    TRAP #15
    BRA CHECK_DES_MODE

DISP_SOURCE_REG_6
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_6, A1
    MOVE.B #14, D0
    TRAP #15
    BRA CHECK_DES_MODE

DISP_SOURCE_REG_7
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_7, A1
    MOVE.B #14, D0
    TRAP #15
    BRA CHECK_DES_MODE

CHECK_DES_MODE:
    JSR DISP_STR_COMMA
    CMP.B #0, D5
    BEQ DISP_DES_MODE_D
    CMP.B #1, D5
    BEQ DISP_DES_MODE_A
    CMP.B #2, D5
    CMP.B #3, D5
    CMP.B #4, D5
    CMP.B #5, D5
    CMP.B #6, D5
    CMP.B #7, D5
    RTS

DISP_DES_MODE_D
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_D, A1
    MOVE.B #14, D0
    TRAP #15
    BRA CHECK_DES_REGISTER

DISP_DES_MODE_A
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_A, A1
    MOVE.B #14, D0
    TRAP #15
    BRA CHECK_DES_REGISTER

CHECK_DES_REGISTER:
    CMP.B #0, D4
    BEQ DISP_DES_REG_0
    CMP.B #1, D4
    BEQ DISP_DES_REG_1
    CMP.B #2, D4
    BEQ DISP_DES_REG_2
    CMP.B #3, D4
    BEQ DISP_DES_REG_3
    CMP.B #4, D4
    BEQ DISP_DES_REG_4
    CMP.B #5, D4
    BEQ DISP_DES_REG_5
    CMP.B #6, D4
    BEQ DISP_DES_REG_6
    CMP.B #7, D4
    BEQ DISP_DES_REG_7

DISP_DES_REG_0
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_0, A1
    MOVE.B #14, D0
    TRAP #15
    BRA DONE

DISP_DES_REG_1
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_1, A1
    MOVE.B #14, D0
    TRAP #15
    BRA DONE

DISP_DES_REG_2
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_2, A1
    MOVE.B #14, D0
    TRAP #15
    BRA DONE

DISP_DES_REG_3
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_3, A1
    MOVE.B #14, D0
    TRAP #15
    BRA DONE

DISP_DES_REG_4
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_4, A1
    MOVE.B #14, D0
    TRAP #15
    BRA DONE

DISP_DES_REG_5
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_5, A1
    MOVE.B #14, D0
    TRAP #15
    BRA DONE

DISP_DES_REG_6
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_6, A1
    MOVE.B #14, D0
    TRAP #15
    BRA DONE

DISP_DES_REG_7
    MOVEA.L #0, A1      ; Clear A1
    LEA STR_7, A1
    MOVE.B #14, D0
    TRAP #15
    BRA DONE

DONE:
    CLR.L D0
