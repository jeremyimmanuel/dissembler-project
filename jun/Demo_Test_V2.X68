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
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source