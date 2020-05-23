    ORG $400

START:
    * d2 d3 d4  d5  d6  d7
    * 00 11 111 000 000 110
    * 00 03 07 00 00 06
    * MOVE.W D6, D7
    MOVE.W #$00003E06, D1 * reserve D1 for original input 
    MOVE.W D1, D2
    
    * move first two BITS to D2
    MOVE.W D1, D2
    LSR.W #8, D2
    LSR.W #6, D2 
    MOVE.B D2, D2  

    CMP.B #0, D2            ; if equal to 0 definatly MOVE/MOVEA
    BEQ MOVE_MOVEA          ; defined in move_movea.x68

    CMP.B #1, D2            ; if equal to 1 movem, lea, jsr, rts, branches
    * BEQ LEA_JSR_RTS_BCC     ; defined in lea_jsr_rts_bcc.x68

    INCLUDE 'move_movea/move_movea.x68'
    * INCLUDE 'lea_jsr_rts_bcc.x68'
    INCLUDE 'constants.x68'
    INCLUDE 'displays.x68'

DONE:
    CLR.L D0

    END START