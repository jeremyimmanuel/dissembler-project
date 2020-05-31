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
    
    MOVE.B    D0,A1
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


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source