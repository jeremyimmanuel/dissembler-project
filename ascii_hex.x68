*-----------------------------------------------------------
* Title      : Input Branch
* Written by : Jeremy Tandjung
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
    CLR.L D0
    CLR.L D1
    CLR.L D2            ; Clear D2
    CLR.L D3
    
    LEA     start_addr_instruction, A1
    MOVE.B  #14, D0     ; Trap task #14
    TRAP    #15
    MOVEA.L #0, A1      ; Clear A1
    
    MOVE.B  #2, D0      ; Trap task #2 
    TRAP    #15         ; Stores string from keyboard to (A1)
                        ; it will also store the bit count in D1

    JSR ASCII_2_HEX
    JSR MOVE_START_ADDR_REGISTER

END_ADDR_PROMPT
    CLR.L D0
    CLR.L D1
    CLR.L D2            ; Clear D2
    CLR.L D3
    
    LEA     end_addr_instruction, A1
    MOVE.B  #14, D0     ; Trap task #14
    TRAP    #15
    MOVEA.L #0, A1      ; Clear A1
    
    MOVE.B  #2, D0      ; Trap task #2 
    TRAP    #15         ; Stores string from keyboard to (A1)
                        ; it will also store the bit count in D1
    
    JSR ASCII_2_HEX
    JSR MOVE_END_ADDR_REGISTER

    BRA DONE

    
; HEX 0 - F
ASCII_2_HEX
    CMP #0, D1              ; check for counter if 0 stop
    BEQ EXIT_ASCII_2_HEX
    LSL.L   #4, D3              ; Shifting -> 0000 0080
    MOVE.B (A1)+, D2    ; move to register to save time
          

    * 41 30 30 30
    * Range check for numerical
NUMBER_CHECK    
    CMP.B   #'0', D2          ; if less than 0, error
    BLT     ERROR
    CMP.B   #'9', D2          ; if greater than 9, error
    BGT     LETTER_CHECK

    
    SUB.B   #'0', D2          ; converting to hex
    ADD.B   D2, D3              ; 0000 0008
    
    LSR.L   #8, D2               ; right shift D2 here
    SUBI    #1, D1              ; count--
    BRA     ASCII_2_HEX

    * Range check for A-F
LETTER_CHECK    
    CMP.B   #'A', D2          ; if less than A, error
    BLT     ERROR
    CMP.B   #'F', D2          ; if greater than F, error
    BGT     ERROR

    SUB.B   #'7', D2          ; if got here then valid letter
    ADD.B   D2, D3
    
    LSR.L   #8, D2            ; right shift D2 here
    SUBI    #1, D1              ; count--   

    BRA ASCII_2_HEX
    


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

DONE
    CLR.L D0

start_addr_instruction     DC.B 'Enter starting address (in hex):', CR, LF, 0
end_addr_instruction       DC.B 'Enter ending address (in hex):', CR, LF, 0

START_ADDRESS DS.L 1
END_ADDR      DS.L 1


    END START
