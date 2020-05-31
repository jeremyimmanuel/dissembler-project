*-----------------------------------------------------------
* Title      : CSS 422  Disassembler
* Written by : Jeremy, Angie, Jun
* Date       : May 30th, 2020
* Description: 
*-----------------------------------------------------------

BEGINNING_ADDRESS           EQU    $100 * to store starting address
FINISHING_ADDRESS           EQU    $150 * to store ending address
CURRENT_FOUR_NIBBLES_VAR    EQU    $200 * to store first nibble
DEST_HOLDER                 EQU    $250 * address to hold destination register
A1_COPY_ONE                 EQU    $300 
A1_COPY_TWO                 EQU    $350 
CURRENT_TWO_NIBBLES_VAR     EQU    $400 
    
    ORG $1000
START:
    INCLUDE 'get_input.x68' ; get user input for starting address and ending address
    INCLUDE 'ascii_hex.x68' ; convert user input from ASCII values to hex values
                            ; starting address saved in A2
                            ; ending address saved in A3
    INCLUDE 'opcode.x68'


    INCLUDE 'constants.x68'     ; constants file
    * INCLUDE 'displays.x68'

    END START