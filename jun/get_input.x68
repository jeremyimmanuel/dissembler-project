*-----------------------------------------------------------
* Title      : get_input.x68
* Written by : Jeremy, Angie, Jun
* Date       : June 8th, 2020
* Description: Handles prompting user to input starting
*               and ending addresses
*               Will jump to ascii_hex.68
*-----------------------------------------------------------

Get_Start_Addr:                          ; Prompt user for starting address
    LEA     Start_Addr_Instruction, A1  ; Display promp for starting address
    JSR     TRAP14
    MOVEA.L #0, A1                      ; Clear A1
    LEA     A1_COPY_TWO_MEM_LOC, A1     ; Move our memory location constants so that 
                                        ; it can be stored there
    
    MOVE.B  #2, D0                      ; Trap task #2 
    TRAP    #15                         ; Stores string from keyboard to (A1)
                                        ; it will also store the bit count in D1
    
    CLR     D2                          ; clear starting/ending address toggle 
    
    BRA     ASCII_2_HEX                 ; ascii_hex.x68

Get_End_Addr:
    LEA     End_Addr_Instruction, A1    ; Display promp for starting address
    JSR     TRAP14
    MOVEA.L #0, A1                      ; Clear A1 
    LEA     A1_COPY_ONE_MEM_LOC, A1     ; Move our memory location constants so that 
                                        ; it can be stored there
    
    MOVE.B  #2, D0                      ; Trap task #2 
    TRAP    #15                         ; Stores string from keyboard to (A1)
                                        ; it will also store the bit count in D1
    
    BRA     ASCII_2_HEX                 ; ascii_hex.x68
