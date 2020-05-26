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
    LSL.L   #4, D3          ; Shifting one hexabit at holder
    MOVE.B (A1)+, D0        ; move to register to save time
          

NUMBER_CHECK    
    CMP.B   #'0', D0          ; if less than 0, error
    BLT     ERROR
    CMP.B   #'9', D0          ; if greater than 9, maybe letter
    BGT     LETTER_CHECK      ; branch to LETTER_CHECK

    
    SUB.B   #'0', D0          ; converting to hex
    ADD.B   D0, D3            ; Add byte D2, to D3
    
    LSR.L   #8, D0            ; right shift D2 by two hexabits, 
                              ; to get rid of the prev hexabits

    SUBI    #1, D1            ; count--
    
    CMP #0, D1              ; check for counter if 0 stop
    BEQ VALIDATE_START_ADDR    ; when done, exit
    

    BRA     ASCII_2_HEX       ; loop

    * Range check for A-F
LETTER_CHECK    
    CMP.B   #'A', D0          ; if less than A, error
    BLT     ERROR
    CMP.B   #'F', D0          ; if greater than F, error
    BGT     ERROR

    SUB.B   #'7', D0          ; if got here then valid letter
    ADD.B   D0, D3            ; Add byte from D2 to D3
    
    LSR.L   #8, D0            ; right shift D2 by two hexabits, 
                              ; to get rid of the prev hexabits
    
    SUBI    #1, D1            ; count--   
    CMP #0, D1              ; check for counter if 0 stop
    * BEQ VALIDATE_START_ADDR    ; when done, exit 

    BRA     ASCII_2_HEX       ; loop
    
EXIT_ASCII_2_HEX
    RTS

MOVE_START_ADDR_REGISTER
    MOVE.L D3, START_ADDR_MEM_LOC
    RTS

MOVE_END_ADDR_REGISTER
    MOVE.L D3, END_ADDR_MEM_LOC
    RTS

VALIDATE_START_ADDR
    BTST        #0,D3
    BNE         HANDLING_INVALID_BEG_ADDR               
    CMP         #1,D2  
    BEQ         VALIDATING_FINISH_ADDRESS               
    ADDI        #1,D2 
    
    JSR         MOVE_START_ADDR_REGISTER
    
    CLR         D3
    BRA         END_ADDR_PROMPT             ; 'in get_input.x68'

VALIDATING_FINISH_ADDRESS
    BTST        #0,D3 
    BNE         HANDLING_INVALID_FINISH_ADDR 
    CMP.L       START_ADDR_MEM_LOC, D3
    BLE         HANDLING_INVALID_FINISH_ADDR
    CLR.W       D2
    
    JSR         MOVE_END_ADDR_REGISTER

    CLR.W       D3	
    LEA         STR_SPACE, A1
    MOVE.B      #13,D0	
    TRAP        #15
    * BRA         LOADING_ADDRESSES
    BRA DONE

HANDLING_INVALID_BEG_ADDR
    MOVEA.L     #0,A1
    LEA         error_message, A1
    MOVE.B      #13,D0
    TRAP        #15	
    CLR         D3
    BRA         START_ADDR_PROMPT

HANDLING_INVALID_FINISH_ADDR
    MOVEA.L     #0,A1
    LEA         error_message, A1
    MOVE.B      #13,D0
    TRAP        #15
    CLR         D3	
    BRA         END_ADDR_PROMPT


ERROR
    CMP         #1,D0				* Checks the D2 register to see if 
									* the starting address has already
									* been verified.
    BEQ         HANDLING_INVALID_FINISH_ADDR * If it's equal to 1 then  										 * must have been invalid. 
    BRA         HANDLING_INVALID_BEG_ADDR	* If it's 0 then beginning address was wrong. 
    
    *CLR.L D0
    *MOVE #$FFFFFFFF, D7
    *LEA error_message, A1   ; Display error message
    *MOVE.B  #14, D0         ; Trap task #14
    *TRAP    #15

DONE
    CLR.L D0


* START_ADDRESS DS.L 1
* END_ADDR      DS.L 1


