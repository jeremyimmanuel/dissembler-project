*-----------------------------------------------------------
* Title      : CSS 422  Disassembler
* Written by : Jeremy, Angie, Jun
* Date       : June 8th, 2020
* Description: 
*-----------------------------------------------------------

START_ADDR_MEM_LOC          EQU    $400     ; store starting address in this memory location 
END_ADDR_MEM_LOC            EQU    $450     ; store ending address in this memory location 
CURR_NIBBLES_MEM_LOC        EQU    $500     ; store first four bits 
DEST_MEM_LOC                EQU    $550     ; store destination address in this memory location 
DEST_MODE_MEM_LOC           EQU    $600     ; store destination mode
SRC_MODE_MEM_LOC            EQU    $650     ; store source mode 
SRC_MEM_LOC                 EQU    $700     ; store source address
STORAGE_MEM_LOC             EQU    $750     ; temporary storage for data
A1_COPY_ONE_MEM_LOC         EQU    $800     ; store copy of end address to avoid overwriting 
A1_COPY_TWO_MEM_LOC         EQU    $850     ; store copy of start address to avoid overwriting 
STORE_TWO_NIBBLES_MEM_LOC   EQU    $900     ; store two nibbles 
    
    ORG $1000
START:
    JSR DISP_BANNER
    INCLUDE 'get_input.x68' ; get user input for starting address and ending address
    INCLUDE 'ascii_hex.x68' ; convert user input from ASCII values to hex values
    
    SIMHALT
    
    INCLUDE 'hex_ascii.x68'
    INCLUDE 'constants.x68'
    INCLUDE 'displays.x68'

    INCLUDE 'effective_address.x68'
    INCLUDE 'clean_up.x68'
    INCLUDE 'parse_opcode.x68'

EXIT    MOVE.B      #9, D0 
        TRAP        #15
    END START