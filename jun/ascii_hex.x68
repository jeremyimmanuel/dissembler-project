*-----------------------------------------------------------
* Title      : Converting the user input string to hex 
* Written by : Jeremy Tandjung, Angie Tserenjav, Jun Zhen
* Date       : 05/16/2020
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
    LEA error_message, A1   ; Display error message
    MOVE.B  #14, D0         ; Trap task #14
    TRAP    #15

DONE
    CLR.L D0

error_message               DC.B 'Invalid Address exception, input was was not valid hex value', CR, LF, 0

START_ADDRESS DS.L 1
END_ADDR      DS.L 1

