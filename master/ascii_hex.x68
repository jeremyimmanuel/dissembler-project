*-----------------------------------------------------------
* Title      : ascii_hex.x68
* Written by : Jeremy Tandjung, Angie Tserenjav, Jun Zhen
* Date       : May 16th, 2020
* Description: This file handles converting ascii values from 
*               user input to hex so that easy68k can use it 
*-----------------------------------------------------------
    
ASCII_2_HEX:
    CMP     #8, D1              ; if user inputs a string more than
                                ; 8 bits, bad input
    BGT     Bad_Input_Handler

    LSL.L   #4, D3              ; Shifting one hexabit at holder
    MOVE.B (A1)+, D0            ; move to register 

Number_Check    
    CMP.B   #'0', D0            ; if less than 0, error
    BLT     Bad_Input_Handler
    CMP.B   #'9', D0            ; if greater than 9, maybe letter
    BGT     Letter_Check        ; branch to LETTER_CHECK

    SUB.B   #'0', D0            ; converting to hex
    
    BRA Finish_Converting

Letter_Check    
    CMP.B   #'A', D0            ; if less than A, error
    BLT     Bad_Input_Handler
    CMP.B   #'F', D0            ; if greater than F, error
    BGT     Bad_Input_Handler

    SUB.B   #'7', D0            ; if got here then valid letter 

    BRA     Finish_Converting

Finish_Converting
    ADD.B   D0, D3              ; Add byte from D2 to D3
    
    LSR.L   #8, D0              ; right shift D2 by two hexabits, 
                                ; to get rid of the prev hexabits
    
    SUBI    #1, D1              ; count--   
    CMP     #0, D1              ; check for counter if 0 stop
    BEQ     Validate_Start_Addr

    BRA     ASCII_2_HEX         ; loop back


Place_Start_Addr_To_Memory
    MOVE.L      D3, START_ADDR_MEM_LOC
    RTS
    
Place_End_Addr_To_Memory
    MOVE.L      D3, END_ADDR_MEM_LOC
    RTS

Validate_Start_Addr
    CMP         #1, D2  
    BEQ         Validate_End_Addr               ; If D2 is 1 then we already validated START_ADDRESS          
    ADDI        #1, D2                          ; if initially 0 then we add 1 to toggle it to Validate End Addr

    BTST        #0, D3                          ; Check if even number
    BNE         Invalid_Start_Addr_Handler      ; if not equal -> odd number; error
    
    JSR         Place_Start_Addr_To_Memory      ; MOVE starting address we converted in D3
                                                ; to the defined memory location
    CLR         D3                              ; Clear D3
    BRA         Get_End_Addr                    ; Ask user for ending address; 'get_input.x68'

Validate_End_Addr
    BTST        #0, D3                          ; if equal then even
    BNE         Invalid_End_Addr_Handler        ; if not equal then odd; error
    
    CMP.L       START_ADDR_MEM_LOC, D3          ; check if starting address is less than or equal to ending address
    BLE         Invalid_End_Addr_Handler        ; if yes, then error because start < end
    
    CLR.W       D2                              ; Clear D2
    JSR         Place_End_Addr_To_Memory        ; Move our ending address in D3 to defined 
                                                ; memory location
    CLR.W       D3	                            ; Clear D3
    
    BRA         Load_Addr

Invalid_Start_Addr_Handler                      ; HANDLING_INVALID_START_ADDR
    MOVEA.L     #0, A1                          ; Clear A1
    LEA         Error_Message, A1               ; Load error message
    MOVE.B      #13, D0                         ; Trap task #13
    TRAP        #15	
    CLR         D3                              ; Clear D3
    BRA         Get_Start_Addr                  ; Ask for starting address again
  

Invalid_End_Addr_Handler                        ; Invalid_End_Addr_Handler
    MOVEA.L     #0, A1                          ; Clear A1
    LEA         Error_Message, A1	            
    MOVE.B      #13, D0				            
    TRAP        #15	             
    
    CLR         D3	
    BRA         Get_End_Addr


Bad_Input_Handler
    CMP         #1, D2				            ; if toggle at D2 is 1 then Ending address error
    BEQ         Invalid_End_Addr_Handler 
    BRA         Invalid_Start_Addr_Handler	    ; else starting address error

Load_Addr
    CLR.L       D2
    MOVE.L      START_ADDR_MEM_LOC, A2
    MOVE.L      END_ADDR_MEM_LOC, A3
    JSR         Loop                            ; parse_opcode.x68