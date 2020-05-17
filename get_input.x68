    ORG $400

START_ADDR_PROMPT       ; Prompt user for starting address
    CLR.L D0            ; Clear D0, for trap task num
    CLR.L D1            ; Clear D1, for string length
    CLR.L D2            ; Clear D2, for reading each bytes
    CLR.L D3            ; Clear D3, for holding the address
    
    LEA     start_addr_instruction, A1  ; Display promp for starting address
    MOVE.B  #14, D0     ; Trap task #14
    TRAP    #15

    MOVEA.L #0, A1      ; Clear A1, so that trap task #2 stores it here
                        ; which is $0000 0000 by default
    
    MOVE.B  #2, D0      ; Trap task #2 
    TRAP    #15         ; Stores string from keyboard to (A1)
                        ; it will also store the bit count in D1

    JSR ASCII_2_HEX
    JSR MOVE_START_ADDR_REGISTER

END_ADDR_PROMPT
    CLR.L D0            ; Clear D0, for trap task num
    CLR.L D1            ; Clear D1, for string length
    CLR.L D2            ; Clear D2, for reading each bytes
    CLR.L D3            ; Clear D3, for holding the address
    
    LEA     end_addr_instruction, A1  ; Display promp for starting address
    MOVE.B  #14, D0     ; Trap task #14
    TRAP    #15

    MOVEA.L #0, A1      ; Clear A1, so that trap task #2 stores it here
                        ; which is $0000 0000 by default
    
    MOVE.B  #2, D0      ; Trap task #2 
    TRAP    #15         ; Stores string from keyboard to (A1)
                        ; it will also store the bit count in D1

    JSR ASCII_2_HEX
    JSR MOVE_END_ADDR_REGISTER

    BRA DONE

start_addr_instruction     DC.B 'Enter starting address (in hex, Capital letters and numbers only):', CR, LF, 0
end_addr_instruction       DC.B 'Enter ending address (in hex, Capital letters and numbers only):', CR, LF, 0