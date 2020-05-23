LEA_JSR_RTS_BCC:
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


    CMP.B #0, D3
    BEQ LEA_JSR_RTS_MOVEM

    CMP.B #0, D3
    BEQ BRANCHES            ; defined in branches.x68
    


LEA_JSR_RTS_MOVEM:
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