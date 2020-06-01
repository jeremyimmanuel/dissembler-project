*****************************
*
* Demo_Test.X68
*
* Created 03/08/2020
*
* By Angie, Jeremey, Jun 
*
* Test program for CSS 422 Disassembler Project Demo
*
*****************************

start		EQU	$00009000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

		ORG	start

    MOVE.B    D0,D1
    MOVE.W    D5,D4
    MOVE.L    D5,D2
    
    MOVE.W    D5,A4
    MOVE.L    D5,A2

    MOVE.B    D0,(A1)
    MOVE.W    D5,(A4)
    MOVE.L    D5,(A2)
    
    MOVE.B    D0,(A1)+
    MOVE.W    D5,(A4)+
    MOVE.L    D5,(A2)+

    MOVE.B    D0,-(A1)
    MOVE.W    D5,-(A4)
    MOVE.L    D5,-(A2)
    
    MOVE.B    #$0023,D0
    MOVE.W    $8000,D5
    MOVE.B    D0,D1
    MOVE.L    #$24422442, D5
    MOVE.B    #$21, D0
    LEA       $12121212, A1
    LEA       (A1), A1
    
    JSR       (A1)
    JSR       $7000
    RTS

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

