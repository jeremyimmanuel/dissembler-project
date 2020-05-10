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
                MOVE.B #3, D0
                TRAP #15
                JSR STRING_TO_HEX

                LEA         NEWLINE, A1
                MOVE.B      #14, D0
                TRAP        #15

printEndAddr    MOVE.L endAddr, D1
                MOVE.B #2, D0
                ;JSR PRINTHEX
                JSR STRING_TO_HEX

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


    DS.W bruh 0 ;force even-word alignment

    END START

