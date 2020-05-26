*-----------------------------------------------------------
* Title      : CSS 422  Disassembler
* Written by : Jeremy, Angie, Jun
* Date       : June 8th, 2020
* Description: 
*-----------------------------------------------------------

START_ADDR_MEM_LOC          EQU    $400     ; BEGINING_ADDRESS
END_ADDR_MEM_LOC            EQU    $450     ; FINISHING_ADDRESS
CURR_NIBBLES_MEM_LOC        EQU    $500     ; CURRENT_FOUR_NIBBLES_VAR
DEST_MEM_LOC                EQU    $550     ; DEST_HOLDER
DEST_MODE_MEM_LOC           EQU    $600     ; DEST_MODE_VAR
SRC_MODE_MEM_LOC            EQU    $650     ; SRC_MODE_HOLDER
SRC_MEM_LOC                 EQU    $700     ; SRC_HOLDER
STORAGE_MEM_LOC             EQU    $750     ; UTILITY_VAR 
A1_COPY_ONE_MEM_LOC         EQU    $800     ; A1_COPY_ONE 
A1_COPY_TWO_MEM_LOC         EQU    $850     ; A1_COPY_TWO
STORE_TWO_NIBBLES_MEM_LOC   EQU    $900    ; CURRENT_TWO_NIBBLES_VAR
    
    ORG $1000
START:
    INCLUDE 'get_input.x68' ; get user input for starting address and ending address
    INCLUDE 'ascii_hex.x68' ; convert user input from ASCII values to hex values
                            ; starting address saved in A2
                            ; ending address saved in A3

    
    INCLUDE 'constants.x68'
    INCLUDE 'displays.x68'

    END START