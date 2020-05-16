    ORG $400

startAddr   DS.L    1
endAddr     DS.L    1

move_first2     EQU %00
movem_first4    EQU %0100
add_first4      EQU %1101
sub_first4      EQU %1001
lea_first4      EQU %0100
and_first4      EQU %1100
or_first4       EQU %1000
shifts_first4   EQU %1110
cmp_first4      EQU %1011
bcc_first4      EQU %0110
jsr_first4      EQU %0100
rts_first4      EQU %0100

* for mode and reg\
zero            EQU $0000
one             EQU $0001
two             EQU $0010
three           EQU $0011
four            EQU $0100
five            EQU $0101
six             EQU $0110
seven           EQU $0111

* 1.I/O person prompts user (me) for 
* a starting and 
* ending address in memory
START:


DISPLAY_START_ADDR_PROMPT   LEA     START_ADDR_PROMPT, A1
                            MOVE.B  #14, D0
                            TRAP    #15
                            BSR saveStartAddr
                            BRA printStartAddr

DISPLAY_END_ADDR_PROMPT     LEA     END_ADDR_PROMPT, A1
                            MOVE.B  #14, D0
                            TRAP    #15
                            BSR saveEndAddr


saveStartAddr   MOVE.B  #4, D0                  * User Trap Task #4 ( Read a number from the keyboard into D1.L.)
                TRAP    #15
                MOVE.L D1, startAddr
                RTS

saveEndAddr     MOVE.B  #4, D0
                TRAP    #15
                MOVE.L D1, endAddr
                RTS

printStartAddr  MOVE.L startAddr, D1
                MOVE.B #4, D5
                JSR PRINTHEX

                LEA         NEWLINE, A1
                MOVE.B      #14, D0
                TRAP        #15

printEndAddr    MOVE.L endAddr, D1
                MOVE.B #4, D5
                JSR PRINTHEX
                

PRINTHEX    CMP.B #0, D5
            BEQ ESCAPEFROMPRINTHEX
            MOVE.B (A1),D3
            MOVE.B (A1)+,D4
            
            LSR.B #4, D3
            LSL.B #4, D4
            LSR.B #4, D4
            
            CLR D6
            MOVE.B D3,D1
            CMP.B #10,D3
            BLT PRINTNUM
            BRA PRINTLET


PRINTNUM    ADD.B #$30, D1
            MOVE.B #6, D0
            TRAP #15
            
            CMP.B #0, D6
            BEQ SWAP
            
            SUB.B #1, D5
            BRA PRINTHEX

PRINTLET    SUB.B #9, D1
            ADD.B #$40, D1
            MOVE.B #6, D0
            TRAP #15
            
            CMP.B #0, D6
            BEQ SWAP
            
            SUB.B #1, D5
            BRA PRINTHEX

SWAP        MOVE.B #1, D6
            BRA PRINTSEC

; OPCODE STUFFF

; $24 11 (0011 0100 00 010 001)
; 0000 00 -> 0011 01000 = 0000 0000
; 0000 -> 0011 01000 = 0000 0011
GET_NIBBLE     MOVE.B (A5)+,D7
               LSR #6,D7


GET_TWO_BITS    MOVE.B  (A5)+, D1
                * if D1 == 00, it's either MOVE or MOVEA
                *   branch to MOVE_OPCODE
                * else:
                *   branch GET_NEXT_GET_TWO_BITS

GET_NEXT_GET_TWO_BITS   MOVE.B (A5)+, D2
                        * check if first4 is equal to ADD 
                        * branch to add
                        BRA GET_NEXT_GET_TWO_BITS

                
    INCLUDE 'test.x68'
    INCLUDE 'string2hex.x68'


filename    dc.b    'text.txt', 0
START_ADDR_PROMPT   DC.L 'Enter starting address in hex : ', 0
END_ADDR_PROMPT     DC.L 'Enter ending address in hex : ', 0 
CR              EQU         $0D
LF              EQU         $0A
newLine         DC.B        CR,LF,0


    DS.W 0 ;force even-word alignment

    END START

