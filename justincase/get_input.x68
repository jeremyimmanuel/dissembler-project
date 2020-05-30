GET_BEGIN_ADDR       ; Prompt user for starting address
    LEA     GET_START_ADDR, A1  ; Display promp for starting address
    MOVE.B #14, D0
    TRAP #15

    MOVEA.L #0, A1      ; Clear A1, so that trap task #2 stores it here
                        ; which is $0000 0000 by default
    
    LEA     A1_COPY_TWO, A1
    MOVE.B  #2, D0      ; Trap task #2 
    TRAP    #15         ; Stores string from keyboard to (A1)
                        ; it will also store the bit count in D1

    BRA ASCII_TO_HEX_CHANGER

GET_FINISH_ADDR
    LEA     GET_END_ADDR, A1  ; Display promp for starting address
    MOVE.B #14, D0
    TRAP #15

    MOVEA.L #0, A1      ; Clear A1, so that trap task #2 stores it here
                        ; which is $0000 0000 by default
    
    LEA     A1_COPY_ONE, A1
    MOVE.B  #2, D0      ; Trap task #2 
    TRAP    #15         ; Stores string from keyboard to (A1)
                        ; it will also store the bit count in D1

    BRA ASCII_TO_HEX_CHANGER
