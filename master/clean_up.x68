*-----------------------------------------------------------
* Title      : clean_up.x68
* Written by : Jeremy, Angie, Jun
* Date       : June 8th, 2020
* Description: Clears all memory and prompts user to 
*               either restart or end the program
*-----------------------------------------------------------

Clear_all:
    * Clearing Data registers
    CLR.L       D0
    CLR.L       D1
    CLR.L       D2
    CLR.L       D3
    CLR.L       D4
    CLR.L       D5
    CLR.L       D6
    CLR.L       D7

    * Clearing Address registers
    MOVEA.L     #0, A0
    MOVEA.L     #0, A1
    MOVEA.L     #0, A2
    MOVEA.L     #0, A3
    MOVEA.L     #0, A4
    MOVEA.L     #0, A5
    MOVEA.L     #0, A6
    MOVEA.L     #0, A7

    * Clearing memory locations used for variables
    CLR.L       START_ADDR_MEM_LOC
    CLR.L       END_ADDR_MEM_LOC
    CLR.L       CURR_NIBBLES_MEM_LOC
    CLR.L       A1_COPY_ONE_MEM_LOC
    CLR.L       A1_COPY_TWO_MEM_LOC
    
    BRA         START

Prompt_Exit_or_Restart                      ; Prompts user to restart or end the program
    LEA         Restart_Instruction, A1     ; Displays prompt
    JSR         TRAP14
    MOVE.B      #4, D0                      ; Trap task #4 to get user input (digit)
    TRAP        #15  
    
    CMP.B       #1, D1                      ; if user inputs 1, restart program
    BEQ         Clear_all
    CMP.B       #0, D1                      ; if 0, end program
    BNE         Prompt_Exit_or_Restart      ; if neither, prompt again
    SIMHALT         ; TODO: should this me BRA EXIT instead?

