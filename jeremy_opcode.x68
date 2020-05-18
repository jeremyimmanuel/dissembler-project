    ORG $400

START:
    * d2 d3 d4  d5  d6  d7
    * 00 11 111 000 000 110
    * 00 03 07 00 00 06
    * MOVE.W D6, D7
    MOVE.W #$00003E06, D1 * reserve D1 for original input 
    MOVE.W D1, D2
    
    * get the OP
    MOVE.W D1, D2
    LSR.W #8, D2
    LSR.W #6, D2 
    MOVE.B D2, D2  

    CMP.B #0, D2            ; if equal to 0 definatly MOVE/MOVEA
    BEQ MAYBE_MOVE

COMPARE_SOURCE_MODE
    CMP.B #0, D6
    BEQ DISP_STR_D
    CMP.B #1, D6
    BEQ DISP_STR_A
    CMP.B #2, D6
    CMP.B #3, D6
    CMP.B #4, D6
    CMP.B #5, D6
    CMP.B #6, D6
    CMP.B #7, D6
    RTS

COMPARE_SOURCE_REGISTER
    CMP.B #0, D7
    BEQ DISP_STR_0
    CMP.B #1, D7
    BEQ DISP_STR_1
    CMP.B #2, D7
    BEQ DISP_STR_2
    CMP.B #3, D7
    BEQ DISP_STR_1
    CMP.B #4, D7
    BEQ DISP_STR_4
    CMP.B #5, D7
    BEQ DISP_STR_5
    CMP.B #6, D7
    BEQ DISP_STR_6
    CMP.B #7, D7
    BEQ DISP_STR_7
    RTS

COMPARE_DESTINATION_MODE
    CMP.B #0, D5
    BEQ DISP_STR_D
    CMP.B #1, D5
    BEQ DISP_STR_A
    CMP.B #2, D5
    CMP.B #3, D5
    CMP.B #4, D5
    CMP.B #5, D5
    CMP.B #6, D5
    CMP.B #7, D5
    RTS

COMPARE_DESTINATION_REGISTER
    CMP.B #0, D4
    BEQ DISP_STR_0
    CMP.B #1, D4
    BEQ DISP_STR_1
    CMP.B #2, D4
    BEQ DISP_STR_2
    CMP.B #3, D4
    BEQ DISP_STR_1
    CMP.B #4, D4
    BEQ DISP_STR_4
    CMP.B #5, D4
    BEQ DISP_STR_5
    CMP.B #6, D4
    BEQ DISP_STR_6
    CMP.B #7, D4
    BEQ DISP_STR_7
    RTS

MAYBE_MOVE
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
    * L4
    * 111 000 000 110 0000
    * R13
    *
    * Goal: 0000 0000 0000 0111
    MOVE.W D1, D4
    LSL.W #4, D4
    LSR.W #8, D4
    LSR.W #5, D4
    MOVE.B D4, D4


    * get destination mode
    * 00 11 111 000 000 110
    * L7
    * 000 000 110 0000 000
    * R13
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
    BEQ MOVEA_SR

    JSR DISP_STR_MOVE

    CMP.B #1, D3        ; Byte
    BEQ DISP_STR_BYTE

    CMP.B #2, D3        ; Long
    BEQ DISP_STR_LONG
    
    CMP.B #3, D3        ; Word
    BEQ DISP_STR_WORD

    CMP.B #0, D6
    BEQ DISP_STR_D

    JSR COMPARE_SOURCE_MODE
    JSR COMPARE_SOURCE_REGISTER

    JSR COMPARE_DESTINATION_MODE
    JSR COMPARE_DESTINATION_REGISTER


    INCLUDE 'constants.x68'
    INCLUDE 'displays.x68'

MOVEA_SR
    END START