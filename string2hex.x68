
* A1 is the source string address. String is assumed to be 8 digits long
* If a value in the string is invalid, then D0 is 0 and D7 is set to all F's
* D0 is the destination
STRING_TO_HEX:
    CLR.L D0 ; just in case
    MOVE.L #8,D1 ; reverse counter
    CLR.L D2 ; temp storage

CONVERSION_LOOP
    CMP #0,D1
    BEQ EXIT_LOOP
    MOVE.L (A1)+, D2 ; move to register to save time

    CMP #'f',D2 ;lowercase base-36
    BGT ERROR
    CMP #'a',D2 ;lowercase hex
    BGE ALPHA_LOWER
    CMP #'F',D2 ;uppercase base-36
    BGT ERROR
    CMP #'A',D2 ;uppercase hex
    BGE ALPHA_UPPER
    CMP #9,D2 ;some characters in between (9,A)
    BGT ERROR
    CMP #'0',D2 ;numeric hex
    BGE NUMERIC
    BRA ERROR ;some characters between (0,'0')

ALPHA_LOWER
    SUB #'a',D2
    ADD #10,D0
ALPHA_UPPER
    SUB #'A',D2
    ADD #10,D2
NUMERIC
    SUB #'0',D2
    
MOVE_TO_REG
    MOVE.L #4,D3
    MULU #8,D3
    LSR D3,D2
    OR D2,D1

    SUB.B #1,D1
    BRA CONVERSION_LOOP

ERROR
    CLR.L D0
    MOVE #$FFFFFFFF,D7

EXIT_LOOP
    RTS
