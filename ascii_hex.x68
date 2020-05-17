*-----------------------------------------------------------
* Title      : Converting the user input string to hex 
* Written by : Jeremy Tandjung, Angie Tserenjav, Jun Zhen
* Date       : 04/09/2020
* Description:
*-----------------------------------------------------------

; MOVEA.L D1, A0

* Read byte by byte in (A1)
* Check if number
* Check if letter
* If valid, move to D3 
* When done, move D3 to A2
*


CR EQU $0D
LF EQU $0A
    
    ORG $1000
START:
    
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

    
ASCII_2_HEX
    CMP #0, D1              ; check for counter if 0 stop
    BEQ EXIT_ASCII_2_HEX    ; when done, exit
    LSL.L   #4, D3          ; Shifting one hexabit at holder
    MOVE.B (A1)+, D2        ; move to register to save time
          

NUMBER_CHECK    
    CMP.B   #'0', D2          ; if less than 0, error
    BLT     ERROR
    CMP.B   #'9', D2          ; if greater than 9, maybe letter
    BGT     LETTER_CHECK      ; branch to LETTER_CHECK

    
    SUB.B   #'0', D2          ; converting to hex
    ADD.B   D2, D3            ; Add byte D2, to D3
    
    LSR.L   #8, D2            ; right shift D2 by two hexabits, 
                              ; to get rid of the prev hexabits

    SUBI    #1, D1            ; count--
    BRA     ASCII_2_HEX       ; loop

    * Range check for A-F
LETTER_CHECK    
    CMP.B   #'A', D2          ; if less than A, error
    BLT     ERROR
    CMP.B   #'F', D2          ; if greater than F, error
    BGT     ERROR

    SUB.B   #'7', D2          ; if got here then valid letter
    ADD.B   D2, D3            ; Add byte from D2 to D3
    
    LSR.L   #8, D2            ; right shift D2 by two hexabits, 
                              ; to get rid of the prev hexabits
    
    SUBI    #1, D1            ; count--   
    BRA ASCII_2_HEX           ; loop
    
EXIT_ASCII_2_HEX
    RTS

MOVE_START_ADDR_REGISTER
    MOVEA.L D3, A2
    RTS

MOVE_END_ADDR_REGISTER
    MOVEA.L D3, A3
    RTS

ERROR
    CLR.L D0
    MOVE #$FFFFFFFF, D7
    LEA error_message, A1
    MOVE.B  #14, D0     ; Trap task #14
    TRAP    #15

DONE
    CLR.L D0

start_addr_instruction     DC.B 'Enter starting address (in hex):', CR, LF, 0
end_addr_instruction       DC.B 'Enter ending address (in hex):', CR, LF, 0
error_message               DC.B 'Invalid Address exception, input was was not valid hex value', CR, LF, 0

START_ADDRESS DS.L 1
END_ADDR      DS.L 1


    END START
