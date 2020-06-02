Get_Start_Addr          ; Prompt user for starting address
    LEA     Start_Addr_Instruction, A1  ; Display promp for starting address
    MOVE.B  #14, D0
    TRAP    #15
    MOVEA.L #0, A1      ; Clear A1, so that trap task #2 stores it here
                        ; which is $0000 0000 by default
    LEA     A1_COPY_TWO_MEM_LOC, A1
    MOVE.B  #2, D0      ; Trap task #2 
    TRAP    #15         ; Stores string from keyboard to (A1)
                        ; it will also store the bit count in D1
    CLR     D2          ; clear starting/ending address toggle 
    BRA     ASCII_2_HEX ; ascii_hex.x68

Get_End_Addr
    LEA     End_Addr_Instruction, A1  ; Display promp for starting address
    MOVE.B  #14, D0
    TRAP    #15
    MOVEA.L #0, A1      ; Clear A1, so that trap task #2 stores it here
                        ; which is $0000 0000 by default
    LEA     A1_COPY_ONE_MEM_LOC, A1
    MOVE.B  #2, D0      ; Trap task #2 
    TRAP    #15         ; Stores string from keyboard to (A1)
                        ; it will also store the bit count in D1
    BRA     ASCII_2_HEX     ; ascii_hex.x68
