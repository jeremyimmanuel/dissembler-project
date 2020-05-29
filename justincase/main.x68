*-----------------------------------------------------------
* Title      : CSS 422  Disassembler
* Written by : Jeremy, Angie, Jun
* Date       : June 8th, 2020
* Description: 
*-----------------------------------------------------------

****
 * REFERENCE:
 * ----------
 * The address register 'A2' is used to represent the starting address that will be iterated until the ending adrress
 * The address register 'A3' is used to represent the ending address
 * The data register 'D7' is used as the toggle for MOVEM '/' output 
 **
BEGINNING_ADDRESS           EQU    $100 * This address in the memory will store the inputted user starting address
FINISHING_ADDRESS           EQU    $150 * This address in the memory will store the inputted user ending address
CURRENT_FOUR_NIBBLES_VAR    EQU    $200 * This variable will represent '4' nibbles which are used for reading purposes
DEST_HOLDER                 EQU    $250 * This variable represents the address number of the destination which are typically the [11-9th bit]
DEST_MODE_VAR               EQU    $300 * This variable represents the destination mode which are typically the [8-6 bit]
SRC_MODE_HOLDER             EQU    $350 * This variable represents the source mode which are typically the [5-3]
SRC_HOLDER                  EQU    $400 * This variable represents the address number of the source which are typically the [2-0 bit]
UTILITY_VAR                 EQU    $550 * This variable is used throughout the program as a temporary variable manipulated by various subroutines to store data. 
A1_COPY_ONE                 EQU    $600 * This variable was specified as a copy of (A1) as to avoid overwriting the value in (A1) when obtaining the end address
A1_COPY_TWO                 EQU    $650 * This variable was specified as a copy of (A1) as to avoid overwriting the value in (A1) when obtaining the starting address
CURRENT_TWO_NIBBLES_VAR     EQU    $750 * This variable will represent '2' nibbles which are used for reading purposes 
    
    ORG $1000
START:
    INCLUDE 'get_input.x68' ; get user input for starting address and ending address
    INCLUDE 'ascii_hex.x68' ; convert user input from ASCII values to hex values
                            ; starting address saved in A2
                            ; ending address saved in A3
    INCLUDE 'opcode.x68'
    INCLUDE 'hex_ascii.x68'


    INCLUDE 'constants.x68'     ; constants file
    INCLUDE 'displays.x68'

    END START