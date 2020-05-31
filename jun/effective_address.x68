* MOVE_EA

OUTPUT_ADDR_LOC
    MOVE.L      A2,D5 							* Store the current address that the disassembler is at					
    MOVE.L      D5,CURR_NIBBLES_MEM_LOC     * Copy the long address in its entirety 
    JSR         HEX_2_ASCII			* Output the 8 bit data field
    MOVE.W      A2,D5							* Store the current address that the disassembler is at
    MOVE.W      D5,CURR_NIBBLES_MEM_LOC		* Copy the long address in its entirety 
    JSR         HEX_2_ASCII		* Output the 8 bit data field
    JSR         DISP_STR_SPACE			* Invokes subroutine to print a space
    RTS
    
Destination_Mode
    MOVEM.L D7, -(SP)
    LSL.W #7, D7
    LSR.W #8, D7
    LSR.W #5, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    CMP.B #$0, D6
    BEQ Find_DMR
    * CMP.B #$2, D6
    * BEQ Print_Indr_An
    * CMP.B #$3, D6
    * BEQ Print_Indr_Plus_An
    * CMP.B #$4, D6
    * BEQ Print_Indr_Minus_An
    * CMP.B #$7, D6
    * BEQ Print_MemAddr
    BNE DISP_ERROR_MESSAGE

Source_Mode
    MOVEM.L D7, -(SP)
    LSL.W #8, D7
    LSL.W #2, D7
    LSR.W #8, D7
    LSR.W #5, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    CMP.B #$0, D6
    BEQ Find_SMR
    BNE DISP_ERROR_MESSAGE

* Destination_Reg
*     MOVEM.L D7, -(SP)
*     LSL.W #8, D7
*     LSL.W #2, D7

*     LSR.W #8, D7
*     LSR.W #4, D7
*     MOVE.B D7, D6
*     MOVEM.L (SP)+, D7

* Source_Mode_Mode
*     MOVEM.L D7, -(SP)
*     LSL.W #8, D7
*     LSL.W #2, D7
*     LSR.W #8, D7
*     LSR.W #4, D7
*     MOVE.B D7, D6
*     MOVEM.L (SP)+, D7

* Source_Reg
*     MOVEM.L D7, -(SP)
*     LSL.W #8, D7
*     LSL.W #2, D7
*     LSR.W #8, D7
*     LSR.W #4, D7
*     MOVE.B D7, D6
*     MOVEM.L (SP)+, D7

Find_DMR
    MOVEM.L D7, -(SP)
    LSL.W #4, D7
    LSR.W #8, D7
    LSR.W #5, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    BRA Print_Dn

Find_SMR
    MOVEM.L D7, -(SP)
    LSL.W #8, D7
    LSL.W #5, D7
    LSR.W #8, D7
    LSR.W #5, D7
    MOVE.B D7, D6
    MOVEM.L (SP)+, D7
    BRA Print_Dn
    
Print_Dn
    CMP.B #$0, D6
    BEQ Print_D0
    CMP.B #$1, D6
    BEQ Print_D1
    CMP.B #$2, D6
    BEQ Print_D2
    CMP.B #$3, D6
    BEQ Print_D3
    CMP.B #$4, D6
    BEQ Print_D4
    CMP.B #$5, D6
    BEQ Print_D5
    CMP.B #$6, D6
    BEQ Print_D6
    CMP.B #$5, D6
    BEQ Print_D6
    CMP.B #$7, D6
    BEQ Print_D7

Print_D0
    JSR DISP_STR_D0
    RTS
Print_D1
    JSR DISP_STR_D1
    RTS
Print_D2
    JSR DISP_STR_D2
    RTS
Print_D3
    JSR DISP_STR_D3
    RTS
Print_D4
    JSR DISP_STR_D4
    RTS
Print_D5
    JSR DISP_STR_D5
    RTS
Print_D6
    JSR DISP_STR_D6
    RTS
Print_D7
    JSR DISP_STR_D7
    RTS




* Print_An
* Print_Indr_An
* Print_Indr_Plus_An
* Print_Indr_Minus_An
* Print_MemAddr