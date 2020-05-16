*-----------------------------------------------------------
* Title      : Input Branch
* Written by : Jeremy Tandjung
* Date       : 04/09/2020
* Description:
*-----------------------------------------------------------

; MOVEA.L D1, A0


CR EQU $0D
LF EQU $0A
    ORG $1000
START:
    
START_ADDR_PROMPT   ; Prompt user for starting address
    LEA     instructions, A1
    MOVE.B  #14, D0     ; Trap task #14
    TRAP    #15
    MOVEA.L #0, A1      ; Clear A1
    
    MOVE.B  #2, D0      ; Trap task #2 
    TRAP    #15         ; Stores string from keyboard to (A1)
                        ; it will also store the bit count in D1

    
    CLR.L D2

    
    
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
    
    

    * convert
    


EXIT_ASCII_2_HEX
    RTS

ERROR
    CLR.L D0
    MOVE #$FFFFFFFF, D7

instructions    DC.B 'Hello Professor', CR, LF
                DC.B 'Enter starting address', CR, LF, 0


    END START
