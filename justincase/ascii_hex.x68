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

    
ASCII_TO_HEX_CHANGER
    LSL.L   #4, D3          ; Shifting one hexabit at holder
    MOVE.B (A1)+, D0        ; move to register to save time
          

NUMBER_CHECK    
    CMP.B   #'0', D0          ; if less than 0, error
    BLT     SWITCH_BAD_INPUT
    CMP.B   #'9', D0          ; if greater than 9, maybe letter
    BGT     ASCII_TO_HEX_CHAR_CHANGER      ; branch to LETTER_CHECK

    SUB.B   #'0', D0          ; converting to hex
    
    BRA FINISH_CONVERTING

    * Range check for A-F
ASCII_TO_HEX_CHAR_CHANGER    
    CMP.B   #'A', D0          ; if less than A, error
    BLT     SWITCH_BAD_INPUT
    CMP.B   #'F', D0          ; if greater than F, error
    BGT     SWITCH_BAD_INPUT

    SUB.B   #'7', D0          ; if got here then valid letter 

    BRA     FINISH_CONVERTING

FINISH_CONVERTING
    ADD.B   D0, D3            ; Add byte from D2 to D3
    
    LSR.L   #8, D0            ; right shift D2 by two hexabits, 
                              ; to get rid of the prev hexabits
    
    SUBI    #1, D1            ; count--   
    CMP     #0, D1              ; check for counter if 0 stop
    BEQ     VALIDATING_BEG_ADDRESS

    BRA     ASCII_TO_HEX_CHANGER       ; loop

    
MOVE_START_ADDR_REGISTER
    MOVE.L D3, BEGINNING_ADDRESS
    RTS
    
MOVE_END_ADDR_REGISTER
    MOVE.L D3, FINISHING_ADDRESS
    RTS

VALIDATING_BEG_ADDRESS              ;VALIDATE_START_ADDR
    BTST        #0,D3                           ; Check if even number
    BNE         HANDLING_INVALID_BEG_ADDR      ; if not equal -> odd number; error
    
    CMP         #1,D2  
    BEQ         VALIDATING_FINISH_ADDRESS        ; If D2 is 1 then we already validated START_ADDRESS          
    ADDI        #1,D2                           ; if initially 0 then we add 1 to toggle it to Validate End Addr
    
    JSR         MOVE_START_ADDR_REGISTER        ; MOVE starting address we converted in D3
                                                ; to the defined memory location
    CLR         D3                              ; Clear D3
    BRA         GET_FINISH_ADDR                 ; Ask user for ending address; 'get_input.x68'

VALIDATING_FINISH_ADDRESS                       ; VALIDATING_FINISH_ADDRESS
    BTST        #0,D3                           ; if equal then even
    BNE         HANDLING_INVALID_FINISH_ADDR                ; if not equal then odd; error
    
    CMP.L       BEGINNING_ADDRESS, D3          ; check if starting address is less than or equal to ending address
    BLE         HANDLING_INVALID_FINISH_ADDR                ; if yes, then error because start < end
    
    CLR.W       D2                              ; Clear D2
    JSR         MOVE_END_ADDR_REGISTER          ; Move our ending address in D3 to defined 
                                                ; memory location
    CLR.W       D3	                            ; Clear D3
    
   * LEA         STR_SPACE, A1                   ;
    * MOVE.B      #13,D0	
    * TRAP        #15
    BRA         LOADING_ADDRESSES

HANDLING_INVALID_BEG_ADDR     ; HANDLING_INVALID_START_ADDR
    MOVEA.L     #0, A1                           ; Clear A1
    LEA         BAD_INPUT_MSG, A1               ; Load error message
    MOVE.B      #13, D0                          ; Trap task #13
    TRAP        #15	
    CLR         D3                              ; Clear D3
    BRA         GET_BEGIN_ADDR               ; Ask for starting address again
  

HANDLING_INVALID_FINISH_ADDR        ; HANDLING_INVALID_FINISH_ADDR
    MOVEA.L     #0, A1                           ; Clear A1
    LEA         BAD_INPUT_MSG, A1	* Loads the message about bad input to A1
    MOVE.B      #13, D0				* Preps the TRAP TASK #13
    TRAP        #15	             
    
    CLR         D3	
    BRA         GET_FINISH_ADDR


SWITCH_BAD_INPUT
    CMP         #1, D2				* Checks the D2 register to see if 
									* the starting address has already
									* been verified.
    BEQ         HANDLING_INVALID_FINISH_ADDR * If it's equal to 1 then  										 * must have been invalid. 
    BRA         HANDLING_INVALID_BEG_ADDR	* If it's 0 then beginning address was wrong. 

LOADING_ADDRESSES
    LEA         CHECK_FIRST_NIB_JMPTABLE, A0            ; Storing address of subroutine in A0
    MOVE.L      BEGINNING_ADDRESS, A2
    MOVE.L      FINISHING_ADDRESS, A3
    BRA         DERIVING_OPCODE	                        ; JSR to opcode.x68


