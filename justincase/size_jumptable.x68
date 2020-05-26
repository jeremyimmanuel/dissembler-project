* size_jumptable.x68

OUTPUT_SIZE_OF_MOVE_JMPTABLE
    JMP         INVALID_MOVE_SIZE
    JMP         OUTPUT_BYTE_SUFFIX
    JMP         OUTPUT_LONG_SUFFIX
    JMP         OUTPUT_WORD_SUFFIX

INVALID_MOVE_SIZE
    BRA         INVALID_OPCODE
    RTS

OUTPUT_BYTE_SUFFIX
    LEA         STR_BYTE_SUFFIX,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

OUTPUT_LONG_SUFFIX
    LEA         STR_LONG_SUFFIX,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS

OUTPUT_WORD_SUFFIX
    LEA         STR_WORD_SUFFIX,A1
    JSR         WHOLE_MESSAGE_OUTPUT		* Prints the string loaded in A1
    JSR         OUTPUT_EMPTY_SPACE			* Invokes subroutine to print a space
    RTS