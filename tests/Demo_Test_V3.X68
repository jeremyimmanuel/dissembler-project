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
    CMP.B     $12,D1
    CMP.B     $1234,D1
    CMP.B     $12345678,D1
    CMP.B     #$12,D1
    CMP.W     $12,D1
    CMP.W     $1234,D1
    CMP.W     $12345678,D1
    CMP.W     #$1234,D1
    CMP.L     $12,D1
    CMP.L     $1234,D1
    CMP.L     $12345678,D1
    CMP.L     #$12345678,D1
    BCC.W     $00009028
    BCC.W     $00009218
    BCC.W     $00009228
    BGT.W     $00009028
    BGT.W     $00009218
    BGT.W     $00009228
    BLE.W     $00009028
    BLE.W     $00009218
    BLE.W     $00009228
    JSR       $00009028
    JSR       $00009218
    JSR       $00009228
    MOVEA     D1,A1
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

