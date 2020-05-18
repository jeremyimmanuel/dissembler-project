    ORG $400

START:
    INCLUDE 'get_input.x68' ; get user input for starting address and ending address
    INCLUDE 'ascii_hex.x68' ; convert user input from ASCII values to hex values
                            ; starting address saved in A2
                            ; ending address saved in A3
        

    END START
    