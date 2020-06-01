* Clear everything to start like new
Clear_all:
    CLR.L       D0
    CLR.L       D1
    CLR.L       D2
    CLR.L       D3
    CLR.L       D4
    CLR.L       D5
    CLR.L       D6
    CLR.L       D7
    MOVEA.L     #0, A0
    MOVEA.L     #0, A1
    MOVEA.L     #0, A2
    MOVEA.L     #0, A3
    MOVEA.L     #0, A4
    MOVEA.L     #0, A5
    MOVEA.L     #0, A6
    MOVEA.L     #0, A7
    CLR.L       START_ADDR_MEM_LOC
    CLR.L       END_ADDR_MEM_LOC
    CLR.L       CURR_NIBBLES_MEM_LOC
    CLR.L       DEST_MEM_LOC
    CLR.L       DEST_MODE_MEM_LOC
    CLR.L       SRC_MODE_MEM_LOC
    CLR.L       SRC_MEM_LOC
    CLR.L       STORAGE_MEM_LOC
    CLR.L       A1_COPY_ONE_MEM_LOC
    CLR.L       A1_COPY_TWO_MEM_LOC
    CLR.L       STORE_TWO_NIBBLES_MEM_LOC
    BRA         START

Prompt_Exit_or_Restart
    LEA         Restart_Instruction, A1
    JSR         TRAP14
    MOVE.B      #4, D0
    TRAP        #15  
    CMP.B       #1, D1
    BEQ         Clear_all
    CMP.B       #0, D1
    BNE         Prompt_Exit_or_Restart
    SIMHALT

