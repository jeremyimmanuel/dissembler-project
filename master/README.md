# CSS 422 - Disassembler Project

by Jeremy Tandjung, Angie Tserenjav, and Jun Zhen

## File Organization

We decided to split up the source code into multiple files, to make it cleaner and avoid merge conflicts.
The following are the files and short explanations:

* main.x68; Main file where we INCLUDE every other file
* get_input.x68; Handles prompting user to get user input
* ascii_hex.x68; ASCII to hex conversion
* hex_ascii.x68; Hex to ASCII conversion
* parse_opcode.x68; Opcode parsing/disassembling
* effective_address.x68; EA parsing/disassembling
* clean_up.x68; Actions when at the end of the program
* constants.x68; Houses all of the program's constants
* displays.x68; Houses all constant printing subroutines
* test/test.x68; test file to open when running simulation

## Instructions

This section talks about program instructions

### Starting the program

To run this program, user only needs to open **main.x68** as everything else is included in the file.
After running **main.x68** user should load desired .S68 data to the simulator.

### Inputting Starting and Ending Addresses

User will be prompted to input starting and ending address.
Some contraints for starting address and ending address:

* Must be between 1 - 8 bit places
* Both addresses must be an even address
* Starting address has to be less than the ending address
* Only capilal hex letters (A - F) and numbers (0 - 9) are accepted

### Printing >30 Lines of output

For every 30 lines of output, user will be prompted to press enter
to continue as easy68k's simulation output doesn't let user
scroll up.

### Restarting or Terminating Program

When finishing parsing, user will be prompted to either
restart or terminate program by inputting:

* 0 for terminate program
* 1 for restart program
