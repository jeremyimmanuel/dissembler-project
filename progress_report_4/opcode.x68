DERIVING_OPCODE
    JSR         OUTPUT_ADDR_LOC                  
    JSR         D3_GET_NEXT_FOUR_NIB             
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3		 
    JSR         STORE_FIRST_NIBBLE_IN_D3         
    MULU        #6, D3                            
    JSR         0(A0, D3)                         
    SIMHALT

HEX_TO_ASCII_CHANGER
    LEA         JMPTABLE_HEX_CHAR, A4     	 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	 
    JSR         STORE_FIRST_NIBBLE_IN_D3     
    MULU        #6, D3						 
    JSR         0(A4, D3)					 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	 
    JSR         STORE_SECOND_NIBBLE_IN_D3    
    MULU        #6, D3						 
    JSR         0(A4, D3)					 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	 
    JSR         STORE_THIRD_NIBBLE_IN_D3     
    MULU        #6, D3						 
    JSR         0(A4, D3)					 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	 
    JSR         STORE_FOURTH_NIBBLE_IN_D3	 
    MULU        #6, D3						 
    JSR         0(A4, D3)					 
    CLR.W       D3							 
    RTS										 

HEX_TO_ASCII_CHANGER_FULLSIZE					
    MOVE.L      D4, CURRENT_FOUR_NIBBLES_VAR     
    JSR         HEX_TO_ASCII_CHANGER			
    MOVE.W      D4, CURRENT_FOUR_NIBBLES_VAR		
    JSR         HEX_TO_ASCII_CHANGER		
    JSR         OUTPUT_EMPTY_SPACE			
    RTS

PRESS_ENTER_CHECK
    ADD         #1, D6					
    CMP         #30, D6 					
    BEQ         PRESS_ENTER_CONT_CHECK	
    LEA         STR_SPACE, A1			
    MOVE        #13, D0					
    TRAP        #15						
    RTS									

PRESS_ENTER_CONT_CHECK
    MOVE        #0, D6		
    MOVE.B      #5, D0		
    TRAP        #15			
    RTS						

INVALID_OPCODE
    LEA         STR_DATA, A1						
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_HEX_SYMBOL				
    JSR         HEX_TO_ASCII_CHANGER            
    LEA         STR_SPACE, A1 					
    MOVE.B      #14, D0							
    TRAP        #15								
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
OUTPUT_NOT
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	 
    JSR         D3_STORE_NORM_SIZE			 
    CMP         #%11, D3						 											 
    BEQ         INVALID_OPCODE                
    LEA         STR_NOT, A1                  
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         SUFFIX_OUTPUT_JMP			 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	 
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         OUTPUT_DATA_MODE_SOURCE		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS										 
OUTPUT_NOP
    LEA         STR_NOP, A1                   
    JSR         WHOLE_MESSAGE_OUTPUT		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS										 
OUTPUT_RTS
    LEA         STR_RTS, A1                  
    JSR         WHOLE_MESSAGE_OUTPUT		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS										
OUTPUT_ORI
    LEA         STR_ORI, A1                  
    JSR         WHOLE_MESSAGE_OUTPUT		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS										
OUTPUT_JSR
    LEA         STR_JSR, A1					
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         OUTPUT_EMPTY_SPACE			
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         OUTPUT_DATA_MODE_SOURCE		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
OUTPUT_CMPI
    LEA         STR_CMPI, A1                  
    JSR         WHOLE_MESSAGE_OUTPUT		
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	 
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         SUFFIX_OUTPUT_JMP			 
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_EA_IMMI_DATA_SYMBOL	
    JSR         D3_STORE_NORM_SIZE           
	LSR         #1,  D3                       
    MOVE.W      D3,  UTILITY_VAR				 
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         REG_MODE_111                 
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_DATA_MODE_SOURCE		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS										 
OUTPUT_ADDI
    LEA         STR_DATA, A1                  
    JSR         WHOLE_MESSAGE_OUTPUT		
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	 
    JSR         D3_STORE_NORM_SIZE           
	LSR         #1,  D3                       
    MOVE.W      D3,  UTILITY_VAR				 
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         REG_MODE_111                 
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS										 
SPECIAL_SUFFIX_OUTPUT_JMP
    LEA         JMPTABLE_USUAL_CASE_SIZE, A4	 
    MULU        #6, D3						 
    JSR         0(A4, D3)					 
    CLR         D3							 
    RTS										 
SUFFIX_OUTPUT_JMP
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	    
    JSR         D3_STORE_NORM_SIZE				
    LEA         JMPTABLE_USUAL_CASE_SIZE, A4     
    CMP         #%11, D3                         
    BEQ         INVALID_OPCODE					
    MULU        #6, D3							
    JSR         0(A4, D3)                        
    RTS											
REGISTER_NUM_OUTPUT
    LEA         JMPTABLE_HEX_CHAR, A4    
    MOVE.W      UTILITY_VAR, D3			
    MULU        #6, D3					
    JSR         0(A4, D3)				
    CLR.W       UTILITY_VAR				
    CLR.W       D3						
    RTS									
OUTPUT_LEA
    LEA         STR_LEA, A1					
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         OUTPUT_EMPTY_SPACE			
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         OUTPUT_DATA_MODE_SOURCE		
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_ADDR_REG             
    MOVE.W      DEST_HOLDER, UTILITY_VAR     
    JSR         REGISTER_NUM_OUTPUT			
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS										
OUTPUT_ADDQ
    LEA         STR_ADDQ, A1					
    BRA         UTILITY_ADDQ_SUBQ			
OUTPUT_SUBQ
    LEA         STR_SUBQ, A1					
    BRA         UTILITY_ADDQ_SUBQ			
UTILITY_ADDQ_SUBQ
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         SUFFIX_OUTPUT_JMP			
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_EA_IMMI_DATA_SYMBOL	
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    CMP         #0,  DEST_HOLDER             
    BEQ         UTILITY_SUBQ_HANDLER        
    MOVE.W      DEST_HOLDER, UTILITY_VAR     
    JSR         REGISTER_NUM_OUTPUT			
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_DATA_MODE_SOURCE		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS										
UTILITY_SUBQ_HANDLER                        
    MOVE.W      #8,  UTILITY_VAR				
    JSR         REGISTER_NUM_OUTPUT			
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_DATA_MODE_SOURCE		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS										
OUTPUT_CMP
    LEA         STR_CMP, A1					
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         SUFFIX_OUTPUT_JMP			
    JSR         OUTPUT_EMPTY_SPACE			
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         OUTPUT_DATA_MODE_SOURCE		
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_DATA_REG             
    MOVE.W      DEST_HOLDER, UTILITY_VAR		
    JSR         REGISTER_NUM_OUTPUT			
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS										
OUTPUT_MOVEQ
    LEA         STR_MOVEQ, A1				
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         OUTPUT_LONG_SIZE_USUAL      
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D1 
    JSR         OUTPUT_EA_IMMI_DATA_SYMBOL	
    JSR         OUTPUT_HEX_SYMBOL			
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    LSL         #8, D3						
    LSR         #8, D3						
    MOVE.W      D3,  CURRENT_FOUR_NIBBLES_VAR 
    JSR         HEX_TO_ASCII_CHANGER         
    MOVE.W      D1,  CURRENT_FOUR_NIBBLES_VAR 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         OUTPUT_DATA_REG             
    MOVE.W      DEST_HOLDER,  UTILITY_VAR    
    JSR         REGISTER_NUM_OUTPUT			
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
OUTPUT_SUBA
    LEA         STR_SUBA, A1					
    BRA         UTILITY_SUBA_ADDA_HANDLER	
OUTPUT_ADDA
    LEA         STR_ADDA, A1					
    BRA         UTILITY_SUBA_ADDA_HANDLER	
UTILITY_SUBA_ADDA_HANDLER
    JSR         WHOLE_MESSAGE_OUTPUT		
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         STORE_SECOND_NIBBLE_IN_D3   
    LSL         #8, D3                       
    LSL         #7, D3
    LSR         #7, D3
    LSR         #8, D3
    ADD         #1, D3                       
    JSR         SPECIAL_SUFFIX_OUTPUT_JMP   
    JSR         OUTPUT_DATA_MODE_SOURCE		
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_ADDR_REG             
    MOVE.W      DEST_HOLDER,  UTILITY_VAR    
    JSR         REGISTER_NUM_OUTPUT			
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS
OR_OUTPUT
    LEA         STR_OR, A1					
    BRA         UTILITY_ADD_SUB_HANDLER     
ADD_OUTPUT           
    LEA         STR_ADD, A1					
    BRA         UTILITY_ADD_SUB_HANDLER		
AND_OUTPUT
 LEA         STR_AND, A1						
 BRA         UTILITY_ADD_SUB_HANDLER  		
OUTPUT_SUB
    LEA         STR_SUB, A1					
    BRA         UTILITY_ADD_SUB_HANDLER		
UTILITY_ADD_SUB_HANDLER
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         SUFFIX_OUTPUT_JMP
    JSR         OUTPUT_EMPTY_SPACE			
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    CMP         #0,  SRC_MODE_HOLDER			
    BNE         UTILITY_SUB_HANDLER         
    JSR         OUTPUT_DATA_MODE_SOURCE		
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_DATA_REG				
    MOVE.W      DEST_HOLDER,  UTILITY_VAR	
    JSR         REGISTER_NUM_OUTPUT			
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS
UTILITY_SUB_HANDLER
    CLR         D7
    JSR         STORE_FOURTH_NIBBLE_IN_D3
    MOVE.W      D3, D7
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    MOVE.W      DEST_HOLDER, D3				
    MOVE.W      SRC_HOLDER, DEST_HOLDER		
    MOVE.W      D3, SRC_HOLDER				
    MOVE.W      DEST_MODE_VAR, D3			
    MOVE.W      SRC_MODE_HOLDER, DEST_MODE_VAR	
    MOVE.W      D3, SRC_MODE_HOLDER				
    MOVE.W      SRC_MODE_HOLDER,  D3				
    MOVE.W      SRC_HOLDER,  UTILITY_VAR         
    LSR         #2, D3							
    CMP         #0, D3                           
    BEQ         REG_TO_MEM_SUB_UTILITY		
    JSR         REG_MODE_000                
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_DATA_MODE_DEST		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS
REG_TO_MEM_SUB_UTILITY
    MOVE.W      DEST_HOLDER,  UTILITY_VAR
    JSR         OUTPUT_DATA_MODE_DEST		
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    CMP         #$C, D7
    BNE         REG_TO_MEM_SUB_NON_IMM
    CLR         D7
    MOVE.W      DEST_HOLDER,  UTILITY_VAR
    BRA         REG_TO_MEM_SUB_NEXT
REG_TO_MEM_SUB_NON_IMM
    CLR         D7
    MOVE.W      SRC_HOLDER,  UTILITY_VAR		
REG_TO_MEM_SUB_NEXT    
    JSR         REG_MODE_000				
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS
BRANCH_BYTE_SIZE_BRANCHCODE        
    JSR         OUTPUT_BYTE_SUFFIX       
    JSR         OUTPUT_HEX_SYMBOL		 
    MOVE.L      A2, D4                    
    BRA         NEGATIVE_DISPLACEMENT_CHECK   
NEGATIVE_DISPLACEMENT_CHECK
    CMP.W       #$FF, D3                    
    BGT         INVALID_OPCODE
    CMP.W       #$80, D3                    
    BLT         ADD_THE_BRANCH_DISPLACEMENT
    CMP.W       #$80, D3                    
    BGE         HANDLING_NEGATIVE_DISPLACEMENT
HANDLING_NEGATIVE_DISPLACEMENT
    NOT.B       D3       
    ADDQ.W      #1, D3    
    SUB         D3, D4    
    MOVE.L      D4,  CURRENT_FOUR_NIBBLES_VAR    
    JSR         HEX_TO_ASCII_CHANGER_FULLSIZE	
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
ADD_THE_BRANCH_DISPLACEMENT
    ADD         D3, D4                          
    MOVE.L      D4,  CURRENT_FOUR_NIBBLES_VAR   
    JSR         HEX_TO_ASCII_CHANGER_FULLSIZE  
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
BRANCH_WORD_SIZE_BRANCHCODE
    JSR         OUTPUT_WORD_SUFFIX             
    JSR         OUTPUT_HEX_SYMBOL				
    MOVE.L      A2, D4                          
    JSR         D3_GET_NEXT_FOUR_NIB           
    ADD         D3, D4                          
    MOVE.L      D4,  CURRENT_FOUR_NIBBLES_VAR   
    JSR         HEX_TO_ASCII_CHANGER_FULLSIZE  
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
BRANCH_LONG_SIZE_BRANCHCODE
    JSR         OUTPUT_WORD_SUFFIX       
    JSR         OUTPUT_HEX_SYMBOL				
    MOVE.L      A2, D4                    
    JSR         D3_GET_NEXT_FOUR_NIB     
    ADD         D3, D4                    
    JSR         D3_GET_NEXT_FOUR_NIB     
    ADD         D3, D4                    
    MOVE.L      D4,  CURRENT_FOUR_NIBBLES_VAR  
    JSR         HEX_TO_ASCII_CHANGER_FULLSIZE 
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
CHECK_BRANCH_SIZE_SUFFIX
	MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
	JSR         D3_KEEP_THIRD_FOURTH_NIB      
	CMP         #%00000000, D3                 
	BEQ         BRANCH_WORD_SIZE_BRANCHCODE   
	CMP         #%11111111, D3                 
	BEQ         BRANCH_LONG_SIZE_BRANCHCODE   
	BRA         BRANCH_BYTE_SIZE_BRANCHCODE   
OUTPUT_BRA
    LEA         STR_BRA, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         CHECK_BRANCH_SIZE_SUFFIX
BSR_OUTPUT
    LEA         STR_BSR, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         CHECK_BRANCH_SIZE_SUFFIX
BEQ_OUTPUT
    LEA         STR_BEQ, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         CHECK_BRANCH_SIZE_SUFFIX
BGT_OUTPUT
    LEA         STR_BGT, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         CHECK_BRANCH_SIZE_SUFFIX
BLE_OUTPUT
    LEA         STR_BLE, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         CHECK_BRANCH_SIZE_SUFFIX
LOG_SHIFT_MEM_OUTPUT
    LEA         STR_LS, A1					
    JSR         UTILITY_ASD_LSD_ROD_SHIFT	
    RTS
ASX_SHIFT_MEM_OUTPUT
    LEA         STR_AS, A1					
    JSR         UTILITY_ASD_LSD_ROD_SHIFT	
    RTS
UTILITY_ASD_LSD_ROD_SHIFT
    JSR         WHOLE_MESSAGE_OUTPUT		
    LEA         JMPTABLE_R_OR_L, A6          
	MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         STORE_SECOND_NIBBLE_IN_D3   
    LSL         #8, D3
    LSL         #7, D3
    LSR         #7, D3
    LSR         #8, D3
    MULU        #6, D3
    JSR         0(A6, D3)                    
    JSR         OUTPUT_WORD_SIZE_USUAL		
    MOVE.W      SRC_HOLDER,  UTILITY_VAR     
    JSR         OUTPUT_DATA_MODE_SOURCE		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS
ROD_MEM_OUTPUT
    LEA         STR_RO, A1					
    JSR         UTILITY_ASD_LSD_ROD_SHIFT	
    RTS
ASD_LSD_OUTPUT                                
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_FOURTH_NIBBLE_IN_D3	
    LSR         #3, D3						
    CMP         #0, D3						
    BEQ         ASD_OUTPUT                  
    BRA         LSD_OUTPUT                  
    RTS
ASD_OUTPUT
    LEA         STR_AS, A1					
    JSR         UTILITY_HELPER_ASD_LSD_ROD	
    RTS
LSD_OUTPUT
    LEA         STR_LS, A1					
    JSR         UTILITY_HELPER_ASD_LSD_ROD	
    RTS
ROX_OUTPUT
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_FOURTH_NIBBLE_IN_D3	
    LSR         #3, D3						
    CMP         #1, D3						
    BNE         INVALID_OPCODE              
    LEA         STR_RO, A1					
    JSR         UTILITY_HELPER_ASD_LSD_ROD	
    RTS
UTILITY_HELPER_ASD_LSD_ROD   
    JSR         WHOLE_MESSAGE_OUTPUT		
    LEA         JMPTABLE_R_OR_L, A6          
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         STORE_SECOND_NIBBLE_IN_D3   
    LSL         #8, D3
    LSL         #7, D3
    LSR         #8, D3
    LSR         #7, D3						
    MULU        #6, D3						
    JSR         0(A6, D3)                    
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         SUFFIX_OUTPUT_JMP           
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_THIRD_NIBBLE_IN_D3	
    LSL         #8, D3
    LSL         #6, D3
    LSR         #8, D3
    LSR         #7, D3                       
    LEA         JMPTABLE_SHIFT_OP_IMMI_OR_REG, A6	
    MULU        #6, D3						
    JSR         0(A6, D3)					
    JSR         OUTPUT_DATA_REG				
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    MOVE.W      SRC_HOLDER, UTILITY_VAR       
    JSR         REGISTER_NUM_OUTPUT			
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS
OPCODE_MOVE_UTILITY
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    CMP         #%001,  DEST_MODE_VAR		
    BEQ         MOVEA_OUTPUT
    BRA         OUTPUT_MOVE					
    RTS
MOVEA_OUTPUT
    LEA         STR_MOVEA, A1
    JSR         UTILITY_MOVE_TWO_OP
OUTPUT_MOVE
    LEA         STR_MOVE, A1
    JSR         UTILITY_MOVE_TWO_OP
UTILITY_MOVE_TWO_OP
    JSR         WHOLE_MESSAGE_OUTPUT		
    LEA         OUTPUT_SIZE_OF_MOVE_JMPTABLE, A6  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_FIRST_NIBBLE_IN_D3	
    MULU        #6, D3						
    JSR         0(A6, D3)					
    JSR         OUTPUT_DATA_MODE_SOURCE		
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_DATA_MODE_DEST		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS
MOVEM_OUTPUT
   LEA          STR_MOVEM, A1
   JSR          UTILITY_MOVEM_HANDLER
UTILITY_MOVEM_HANDLER
    JSR         WHOLE_MESSAGE_OUTPUT		
    CMP         #%011, DEST_MODE_VAR
    BEQ         MOVEM_LONG_SUFFIX
    CMP         #%010, DEST_MODE_VAR
    BEQ         MOVEM_WORD_SUFFIX
    BRA         INVALID_OPCODE
    RTS
MOVEM_NEXT
    CMP         #%100, DEST_HOLDER
    BEQ         MOVEM_TO_MEM
    CMP         #%110, DEST_HOLDER
    BEQ         MOVEM_TO_REG
    BRA         INVALID_OPCODE
MOVEM_TO_REG
    JSR         STORE_THIRD_NIBBLE_IN_D3
    CMP         #$B, D3
    BEQ         MOVEM_TO_REG_IMM
    CMP         #$F, D3
    BEQ         MOVEM_TO_REG_IMM
    BRA         MOVEM_TO_REG_NON_IMM
MOVEM_TO_REG_IMM
    JSR         D3_GET_NEXT_FOUR_NIB
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D7
    MOVE.W      D7, D3
    JSR         OUTPUT_DATA_MODE_SOURCE
    MOVE.W      D7, D3
    BRA         MOVEM_TO_REG_CONT
MOVEM_TO_REG_NON_IMM
    JSR         OUTPUT_DATA_MODE_SOURCE		
    JSR         D3_GET_NEXT_FOUR_NIB
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
MOVEM_TO_REG_CONT
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    MOVE.W      #0, D7
    JSR         REG_15       
    MOVE.W      #0, D7
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS  
REG_15    
    BTST        #15, D3
    BEQ         REG_14
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_7
    MOVE.W      #1, D7
REG_14
    BTST        #14, D3
    BEQ         REG_13
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_6
    MOVE.W      #1, D7
REG_13
    BTST        #13, D3
    BEQ         REG_12
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_5
    MOVE.W      #1, D7
REG_12
    BTST        #12, D3
    BEQ         REG_11
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_4
    MOVE.W      #1, D7
REG_11
    BTST        #11, D3
    BEQ         REG_10
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_3
    MOVE.W      #1, D7
REG_10
    BTST        #10, D3
    BEQ         REG_9
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_2
    MOVE.W      #1, D7
REG_9
    BTST        #9, D3
    BEQ         REG_8
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_1
    MOVE.W      #1, D7
REG_8
    BTST        #8, D3
    BEQ         REG_7
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_0
    MOVE.W      #1, D7
REG_7
    BTST        #7, D3
    BEQ         REG_6
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_7
    MOVE.W      #1, D7
REG_6
    BTST        #6, D3
    BEQ         REG_5
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_6
    MOVE.W      #1, D7
REG_5
    BTST        #5, D3
    BEQ         REG_4
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_5
    MOVE.W      #1, D7
REG_4
    BTST        #4, D3
    BEQ         REG_3
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_4
    MOVE.W      #1, D7
REG_3
    BTST        #3, D3
    BEQ         REG_2
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_3
    MOVE.W      #1, D7
REG_2
    BTST        #2, D3
    BEQ         REG_1
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_2
    MOVE.W      #1, D7
REG_1
    BTST        #1, D3
    BEQ         REG_0
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_1
    MOVE.W      #1, D7
REG_0
    BTST        #0, D3
    BEQ         REG_END
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_0
    MOVE.W      #1, D7
REG_END   
    RTS
MOVEM_TO_MEM
    JSR         STORE_THIRD_NIBBLE_IN_D3
    MOVE.W      D3, D7
    JSR         D3_GET_NEXT_FOUR_NIB
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    CMP         #$9, D7
    BEQ         IMM_CASE
    CMP         #$D, D7
    BEQ         IMM_CASE
    CMP         #$B, D7
    BEQ         IMM_CASE
    CMP         #$F, D7
    BEQ         IMM_CASE
    BRA         NON_IMM_CASE
TO_MEM_CONT
    MOVE.W      #0, D7
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    JSR         OUTPUT_DATA_MODE_SOURCE		
    BSR         PRESS_ENTER_CHECK			
    BRA         DERIVING_OPCODE				
    RTS  
IMM_CASE
    MOVE.W      #0, D7
    JSR         REG_15
    BRA         TO_MEM_CONT
NON_IMM_CASE
    MOVE.W      #0, D7
    JSR         MEM_15
    BRA         TO_MEM_CONT
MEM_15    
    BTST        #15, D3
    BEQ         MEM_14
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_0
    MOVE.W      #1, D7
MEM_14
    BTST        #14, D3
    BEQ         MEM_13
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_1
    MOVE.W      #1, D7
MEM_13
    BTST        #13, D3
    BEQ         MEM_12
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_2
    MOVE.W      #1, D7
MEM_12
    BTST        #12, D3
    BEQ         MEM_11
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_3
    MOVE.W      #1, D7
MEM_11
    BTST        #11, D3
    BEQ         MEM_10
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_4
    MOVE.W      #1, D7
MEM_10
    BTST        #10, D3
    BEQ         MEM_9
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_5
    MOVE.W      #1, D7
MEM_9
    BTST        #9, D3
    BEQ         MEM_8
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_6
    MOVE.W      #1, D7
MEM_8
    BTST        #8, D3
    BEQ         MEM_7
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_D
    JSR         OUTPUT_HEX_7
    MOVE.W      #1, D7
MEM_7
    BTST        #7, D3
    BEQ         MEM_6
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_0
    MOVE.W      #1, D7
MEM_6
    BTST        #6, D3
    BEQ         MEM_5
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_1
    MOVE.W      #1, D7
MEM_5
    BTST        #5, D3
    BEQ         MEM_4
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_2
    MOVE.W      #1, D7
MEM_4
    BTST        #4, D3
    BEQ         MEM_3
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_3
    MOVE.W      #1, D7
MEM_3
    BTST        #3, D3
    BEQ         MEM_2
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_4
    MOVE.W      #1, D7
MEM_2
    BTST        #2, D3
    BEQ         MEM_1
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_5
    MOVE.W      #1, D7
MEM_1
    BTST        #1, D3
    BEQ         MEM_0
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_6
    MOVE.W      #1, D7
MEM_0
    BTST        #0, D3
    BEQ         MEM_END
    JSR         PRINT_SLASH
    JSR         OUTPUT_HEX_A
    JSR         OUTPUT_HEX_7
    MOVE.W      #1, D7
MEM_END 
    RTS
PRINT_SLASH
        CMP         #1, D7
        BNE         NO_SLASH
        LEA         MOVEM_SLASH, A1
        JSR         WHOLE_MESSAGE_OUTPUT		
NO_SLASH
        RTS
WHOLE_MESSAGE_OUTPUT
    MOVE.B      #14, D0
    TRAP        #15
    RTS
OUTPUT_DATA_MODE_SOURCE         
    LEA         JMPTABLE_FINDING_REG_MODE, A6	
    MOVE.W      SRC_HOLDER,  UTILITY_VAR			
    MOVE        SRC_MODE_HOLDER, D3				
    MULU        #6, D3							
    JSR         0(A6, D3)       					
    RTS
OUTPUT_DATA_MODE_DEST
    LEA         JMPTABLE_FINDING_REG_MODE, A6	
    MOVE.W      DEST_HOLDER,  UTILITY_VAR        
    MOVE.W      DEST_MODE_VAR, D3			
    MULU        #6, D3						
    JSR         0(A6, D3)					
    RTS
OUTPUT_ADDR_LOC
    MOVE.L      A2, D5 							
    MOVE.L      D5, CURRENT_FOUR_NIBBLES_VAR     
    JSR         HEX_TO_ASCII_CHANGER			
    MOVE.W      A2, D5							
    MOVE.W      D5, CURRENT_FOUR_NIBBLES_VAR		
    JSR         HEX_TO_ASCII_CHANGER		
    JSR         OUTPUT_EMPTY_SPACE			
    RTS
OUTPUT_COMMA
    LEA         STR_COMMA, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_ADDR_REG
    LEA         STR_ADDR_REG, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_DATA_REG
    LEA         STR_DATA_REG, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_OPEN_BRACKET
    LEA         STR_OPEN_BRACK, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_CLOSE_BRACKET
    LEA         STR_CLOSE_BRACK, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_PLUS_SIGN
    LEA         STR_PLUS, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_MINUS_SIGN
    LEA         STR_MINUS, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_SYMBOL
    LEA         STR_HEX_SYMBOL, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_EMPTY_SPACE
    LEA         STR_SPACE, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_EA_IMMI_DATA_SYMBOL
    LEA         EA_IMMI_DATA_SYMBOL, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
STORE_FIRST_NIBBLE_IN_D3
    LSR         #8, D3   
    LSR         #4, D3   
    RTS
STORE_FIRST_NIBBLE_IN_D2
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D2
    LSR         #8, D2   
    LSR         #4, D2   
    RTS
STORE_THIRD_NIBBLE_IN_D2
	MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D2
    LSL         #8, D2   
    LSR         #8, D2   
	LSR			#4, D2	
    RTS
STORE_FOURTH_NIBBLE_IN_D2
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D2
    LSL         #8, D2   
    LSL         #4, D2   
	LSR			#8, D2
	LSR 		#4, D2
    RTS
STORE_SECOND_NIBBLE_IN_D3
    LSL         #4, D3    
    LSR         #4, D3    
    LSR         #8, D3    
    RTS
STORE_THIRD_NIBBLE_IN_D3
    LSL         #8, D3     
    LSR         #8, D3     
    LSR         #4, D3     
    RTS
STORE_FOURTH_NIBBLE_IN_D3
    LSL         #8, D3	
    LSL         #4, D3	
    LSR         #8, D3	
    LSR         #4, D3
    RTS
D3_GET_NEXT_FOUR_NIB
    MOVE.W      (A2)+, D3							
    MOVE.W      D3,  CURRENT_FOUR_NIBBLES_VAR        
    CMPA.L      A2, A3                               
    BLT         RESTART_OR_FINISH					
    RTS
D3_KEEP_THIRD_FOURTH_NIB
        LSL                        #8, D3
        LSR                        #8, D3
        RTS
D3_GET_NEXT_TWO_NIB
    MOVE.B      (A2)+, D3                            
    MOVE.B      D3,  CURRENT_TWO_NIBBLES_VAR			
    RTS
D3_STORE_NORM_SIZE
    JSR         UPDATE_DEST_SRC_VAR			
    MOVE.W      DEST_MODE_VAR, D3			
    LSL         #8, D3
    LSL         #6, D3
    LSR         #8, D3
    LSR         #6, D3
    RTS
EA_IMMI_D3_STORE_NORM_SIZE_VER
	JSR         UPDATE_DEST_SRC_VAR			
    MOVE.W      DEST_MODE_VAR, D3			
	RTS
UPDATE_DEST_SRC_VAR
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    LSL         #4, D3                       
    LSR         #4, D3                       
    LSR         #8, D3                       
    LSR         #1, D3
    MOVE.W      D3, DEST_HOLDER				
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    LSL         #7, D3
    LSR         #7, D3
    LSR         #6, D3
    MOVE.W      D3, DEST_MODE_VAR			
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    LSL         #8, D3
    LSL         #2, D3
    LSR         #8, D3
    LSR         #2, D3
    LSR         #3, D3
    MOVE.W      D3, SRC_MODE_HOLDER          
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    LSL         #8, D3
    LSL         #5, D3
    LSR         #8, D3
    LSR         #5, D3
    MOVE.W      D3, SRC_HOLDER				
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    RTS
FIRST_TWO_NIBS_4_E
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    LSL         #8, D3                       
    LSR         #8, D3                       
    CMP.B       #$71, D3                     
    BEQ         INVALID_OPCODE
    CMP.B       #$75, D3                     
    BEQ         OUTPUT_RTS
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_THIRD_NIBBLE_IN_D3    
    LSR         #2,  D3						
    CMP         #%10,  D3					
    BEQ         OUTPUT_JSR                  
    BRA         INVALID_OPCODE				
    RTS
CHECK_FIRST_NIB_JMPTABLE                  
    JMP         FIRST_NIB_0               
    JMP         FIRST_NIB_1               
    JMP         FIRST_NIB_2               
    JMP         FIRST_NIB_3               
    JMP         FIRST_NIB_4               
    JMP         FIRST_NIB_5               
    JMP         FIRST_NIB_6               
    JMP         FIRST_NIB_7               
    JMP         FIRST_NIB_8               
    JMP         FIRST_NIB_9               
    JMP         FIRST_NIB_A               
    JMP         FIRST_NIB_B               
    JMP         FIRST_NIB_C               
    JMP         FIRST_NIB_D               
    JMP         FIRST_NIB_E               
    JMP         FIRST_NIB_F               
FIRST_NIB_0
    BRA         INVALID_OPCODE				
    RTS
FIRST_NIB_1 
    JSR         OPCODE_MOVE_UTILITY			
    SIMHALT
FIRST_NIB_2 
    JSR         OPCODE_MOVE_UTILITY		
    SIMHALT
FIRST_NIB_3 
    JSR         OPCODE_MOVE_UTILITY		
    SIMHALT
FIRST_NIB_4  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_SECOND_NIBBLE_IN_D3   
    CMP.B       #$E, D3						
    BEQ         FIRST_TWO_NIBS_4_E          
    CMP.B       #6, D3                       
    BEQ         INVALID_OPCODE			    
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    CMP         #%111, DEST_MODE_VAR			
    BEQ         OUTPUT_LEA                  
    CMP         #%110, DEST_HOLDER			
    BEQ         MOVEM_OUTPUT
    CMP         #%100, DEST_HOLDER			
    BEQ         MOVEM_OUTPUT
    BRA         INVALID_OPCODE				
    RTS
FIRST_NIB_5  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         D3_STORE_NORM_SIZE          
    CMP         #%11, D3						
    BEQ         INVALID_OPCODE				
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_SECOND_NIBBLE_IN_D3   
    LSL         #8, D3                       
    LSL         #7, D3                       
    LSR         #8, D3
    LSR         #7, D3
    CMP         #0, D3                       
    BEQ         OUTPUT_ADDQ                 
    BRA         OUTPUT_SUBQ
    RTS
    SIMHALT
FIRST_NIB_6  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_SECOND_NIBBLE_IN_D3   
    CMP         #%0000, D3                   
    BEQ         OUTPUT_BRA
    CMP         #%0001, D3					
    BEQ         BSR_OUTPUT
    CMP         #%1110, D3					
    BEQ         BGT_OUTPUT			
    CMP         #%0111, D3					
    BEQ         BEQ_OUTPUT
    CMP         #%1111, D3					
    BEQ         BLE_OUTPUT
    BRA         INVALID_OPCODE
    RTS
    SIMHALT
FIRST_NIB_7  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_SECOND_NIBBLE_IN_D3   
    LSL         #8, D3
    LSL         #7, D3
    LSR         #8, D3
    LSR         #7, D3
    CMP         #0, D3						
    BEQ         OUTPUT_MOVEQ				
    BRA         INVALID_OPCODE				
    SIMHALT
FIRST_NIB_8  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    CMP         #%111,  DEST_MODE_VAR		
    BEQ         INVALID_OPCODE
    CMP         #%011,  DEST_MODE_VAR
    BEQ         INVALID_OPCODE       		
    BRA         OR_OUTPUT					
    RTS
    SIMHALT
FIRST_NIB_9  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         D3_STORE_NORM_SIZE			
    CMP         #%11, D3						
    BEQ         OUTPUT_SUBA              	
    BRA         OUTPUT_SUB
    SIMHALT
FIRST_NIB_A  
    BRA         INVALID_OPCODE
    SIMHALT
FIRST_NIB_B  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         D3_STORE_NORM_SIZE			
    CMP         #%11,  D3					
    BEQ         INVALID_OPCODE              
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_SECOND_NIBBLE_IN_D3   
    LSL         #8, D3                       
    LSL         #7, D3
    LSR         #7, D3
    LSR         #8, D3
    CMP         #0, D3                       
    BNE         INVALID_OPCODE
    BRA         OUTPUT_CMP					
    SIMHALT
FIRST_NIB_C 
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         D3_STORE_NORM_SIZE			
    CMP         #%111,  DEST_MODE_VAR		
    BEQ         INVALID_OPCODE              
    CMP         #%011,  DEST_MODE_VAR		
    BEQ         INVALID_OPCODE              
    BRA         AND_OUTPUT					
    RTS
    SIMHALT
FIRST_NIB_D
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         D3_STORE_NORM_SIZE			
    CMP         #%11, D3						
    BEQ         OUTPUT_ADDA					
    BRA         ADD_OUTPUT					
    RTS
    SIMHALT
FIRST_NIB_E  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         D3_STORE_NORM_SIZE			
    CMP         #%11, D3						
    BEQ         FINDING_SHIFT_MEM_TYPE      
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         STORE_THIRD_NIBBLE_IN_D3    
    LSL         #8, D3                       
    LSL         #7, D3
    LSR         #7, D3
    LSR         #8, D3
    CMP         #0, D3
    BEQ         ASD_LSD_OUTPUT
    BRA         ROX_OUTPUT                  
    RTS
FIRST_NIB_F 
    BRA         DERIVING_OPCODE
    RTS
    SIMHALT
FINDING_SHIFT_MEM_TYPE  
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         UPDATE_DEST_SRC_VAR			
    JSR         STORE_SECOND_NIBBLE_IN_D3   
    LSR         #1, D3
    CMP         #1, D3
    BEQ         LOG_SHIFT_MEM_OUTPUT        
    CMP         #0, D3
    BEQ         ASX_SHIFT_MEM_OUTPUT        
    CMP         #%11, D3
    BEQ         ROD_MEM_OUTPUT              
    BRA         INVALID_OPCODE              
    RTS
JMPTABLE_FINDING_REG_MODE
    JMP         REG_MODE_000                       
    JMP         REG_MODE_001                       
    JMP         REG_MODE_010                       
    JMP         REG_MODE_011                       
    JMP         REG_MODE_100                       
    JMP         REG_MODE_101                       
    JMP         REG_MODE_110                       
    JMP         REG_MODE_111                       
REG_MODE_000                                       
    JSR         OUTPUT_DATA_REG				
    JSR         REGISTER_NUM_OUTPUT			
    RTS
REG_MODE_001   
    JSR         OUTPUT_ADDR_REG             
    JSR         REGISTER_NUM_OUTPUT			
    RTS
REG_MODE_010 	
    JSR         OUTPUT_OPEN_BRACKET
    JSR         REG_MODE_001
    JSR         OUTPUT_CLOSE_BRACKET
    RTS
REG_MODE_011    
    JSR         REG_MODE_010
    JSR         OUTPUT_PLUS_SIGN
    RTS
REG_MODE_100
    JSR         OUTPUT_MINUS_SIGN
    JSR         REG_MODE_010
    RTS
REG_MODE_101    
    BRA         INVALID_OPCODE
    RTS
REG_MODE_110    
    BRA         INVALID_OPCODE
    RTS
REG_MODE_111    
    LEA         JMPTABLE_111_REG, A4    
    MOVE.W      UTILITY_VAR, D3		   
    MULU        #6, D3				   
    JSR         0(A4, D3)			   
    LEA         OUTPUT_SHORT_OR_LONG, A4  
    MOVE.W      UTILITY_VAR, D3			 
    MULU        #6, D3                    
    JSR         0(A4, D3)                 
    RTS
OUTPUT_SHORT_OR_LONG              
    JMP         SHORT_ABSOLUTE    
    JMP         LONG_ABSOLUTE     
    JMP         CNTR_DISPLMNT     
    JMP         CNTR_INDEX        
    JMP         EA_IMMI_DATA      
SHORT_ABSOLUTE                        
    JSR         D3_GET_NEXT_FOUR_NIB  
    JSR         HEX_TO_ASCII_CHANGER	
    RTS
    SIMHALT
LONG_ABSOLUTE                         
    JSR         SHORT_ABSOLUTE        
    JSR         SHORT_ABSOLUTE        
    RTS
    SIMHALT
CNTR_DISPLMNT                         
    BRA         INVALID_OPCODE
    SIMHALT
CNTR_INDEX                                   
    BRA         INVALID_OPCODE
    SIMHALT
EA_IMMI_DATA
    CLR         D2
    JSR         STORE_FIRST_NIBBLE_IN_D2
    JSR         EA_IMMI_D3_STORE_NORM_SIZE_VER  
    CMP         #$D, D2
    BEQ         EA_IMMI_ADDA_CASE
	CMP			#$2, D2
	BEQ			CHECK_MOVEM_OR_MOVE
	BRA			EA_IMMI_AND_CASE
CHECK_MOVEM_OR_MOVE
	CLR			D2
	JSR			STORE_THIRD_NIBBLE_IN_D2
	CMP			#$7, D2
	BEQ			EA_IMMI_NEXT
	CMP			#$3, D2
	BEQ			MOVE_L_CASE 	
	BRA			EA_IMMI_NEXT
MOVE_L_CASE
	JSR 		LONG_ABSOLUTE
	CLR			D2
	RTS
EA_IMMI_AND_CASE
    LSR         #1, D3                           
    BRA         EA_IMMI_NEXT
EA_IMMI_ADDA_CASE
    LSR         #2, D3
EA_IMMI_NEXT                                    
    LEA         OUTPUT_SHORT_OR_LONG, A4         
    MULU        #6, D3                           
    JSR         0(A4, D3)                        
    CLR         D2
    RTS
JMPTABLE_111_REG
    JMP         OUTPUT_SHORT_SYMBOL
    JMP         OUTPUT_LONG_SYMBOL
    JMP         DUMMY_THIRD_OPTION 
    JMP         DUMMY_FOURTH_OPTION
    JMP         PRINT_EA_IMMI_DATA_AND_HEX
OUTPUT_SHORT_SYMBOL
    JSR         OUTPUT_HEX_SYMBOL				
    RTS
OUTPUT_LONG_SYMBOL
    JSR         OUTPUT_HEX_SYMBOL				
    RTS
DUMMY_THIRD_OPTION
    BRA         INVALID_OPCODE
    SIMHALT
DUMMY_FOURTH_OPTION
    BRA        INVALID_OPCODE
    SIMHALT
PRINT_EA_IMMI_DATA_AND_HEX
    JSR         OUTPUT_EA_IMMI_DATA_SYMBOL	
    JSR         OUTPUT_HEX_SYMBOL			
    RTS
JMPTABLE_HEX_CHAR
    JMP         OUTPUT_HEX_0
    JMP         OUTPUT_HEX_1
    JMP         OUTPUT_HEX_2
    JMP         OUTPUT_HEX_3
    JMP         OUTPUT_HEX_4
    JMP         OUTPUT_HEX_5
    JMP         OUTPUT_HEX_6
    JMP         OUTPUT_HEX_7
    JMP         OUTPUT_HEX_8
    JMP         OUTPUT_HEX_9
    JMP         OUTPUT_HEX_A
    JMP         OUTPUT_HEX_B
    JMP         OUTPUT_HEX_C
    JMP         OUTPUT_HEX_D
    JMP         OUTPUT_HEX_E
    JMP         OUTPUT_HEX_F
OUTPUT_HEX_0
    LEA         STR_ZERO, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_1
    LEA         STR_ONE, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_2
    LEA         STR_TWO, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_3
    LEA         STR_THREE, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_4
    LEA         STR_FOUR, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_5
    LEA         STR_FIVE, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_6
    LEA         STR_SIX, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_7
    LEA         STR_SEVEN, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_8
    LEA         STR_EIGHT, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_9
    LEA         STR_NINE, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_A
    LEA         STR_A, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_B
    LEA         STR_B, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_C
    LEA         STR_C, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_D
    LEA         STR_D, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_E
    LEA         STR_E, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_HEX_F
    LEA         STR_F, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_SIZE_OF_MOVE_JMPTABLE
    JMP         INVALID_MOVE_SIZE
    JMP         OUTPUT_BYTE_SUFFIX
    JMP         OUTPUT_LONG_SUFFIX
    JMP         OUTPUT_WORD_SUFFIX
INVALID_MOVE_SIZE
    BRA         INVALID_OPCODE
    RTS
OUTPUT_BYTE_SUFFIX
    LEA         STR_BYTE_SUFFIX, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         OUTPUT_EMPTY_SPACE			
    RTS
OUTPUT_LONG_SUFFIX
    LEA         STR_LONG_SUFFIX, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         OUTPUT_EMPTY_SPACE			
    RTS
OUTPUT_WORD_SUFFIX
    LEA         STR_WORD_SUFFIX, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         OUTPUT_EMPTY_SPACE			
    RTS
MOVEM_WORD_SUFFIX
    LEA          STR_WORD_SUFFIX, A1
    JSR          WHOLE_MESSAGE_OUTPUT
    JSR          OUTPUT_EMPTY_SPACE
    BRA          MOVEM_NEXT
MOVEM_LONG_SUFFIX
    LEA          STR_LONG_SUFFIX, A1
    JSR          WHOLE_MESSAGE_OUTPUT
    JSR          OUTPUT_EMPTY_SPACE
    BRA          MOVEM_NEXT
JMPTABLE_USUAL_CASE_SIZE
    JMP         OUTPUT_BYTE_SIZE_USUAL
    JMP         OUTPUT_WORD_SIZE_USUAL
    JMP         OUTPUT_LONG_SIZE_USUAL
    JMP         UNUSED_USUAL_SIZE_SUFFIX         
OUTPUT_BYTE_SIZE_USUAL
    LEA         STR_BYTE_SUFFIX, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         OUTPUT_EMPTY_SPACE			
    RTS
OUTPUT_WORD_SIZE_USUAL
    LEA         STR_WORD_SUFFIX, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         OUTPUT_EMPTY_SPACE			
    RTS
OUTPUT_LONG_SIZE_USUAL
    LEA         STR_LONG_SUFFIX, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    JSR         OUTPUT_EMPTY_SPACE			
    RTS
UNUSED_USUAL_SIZE_SUFFIX
    BRA         INVALID_OPCODE
    RTS
JMPTABLE_R_OR_L
    JMP         OUTPUT_WHEN_R
    JMP         OUTPUT_WHEN_L
OUTPUT_WHEN_R
    LEA         STR_RIGHT, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
OUTPUT_WHEN_L
    LEA         STR_LEFT, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    RTS
JMPTABLE_SHIFT_OP_IMMI_OR_REG                
    JMP         SHIFT_WITH_IMMI
    JMP         SHIFT_WITH_REGISTER
SHIFT_WITH_IMMI
    LEA         EA_IMMI_DATA_SYMBOL, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_SECOND_NIBBLE_IN_D3    
    LSR         #1, D3
    CMP         #0, D3
    BEQ         SHIFT_WITH_IMMI_HELPER       
    MOVE.W      D3,  UTILITY_VAR              
    JSR         REGISTER_NUM_OUTPUT			
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    RTS
SHIFT_WITH_REGISTER
    LEA         STR_DATA_REG, A1
    JSR         WHOLE_MESSAGE_OUTPUT		
    MOVE.W      CURRENT_FOUR_NIBBLES_VAR, D3	
    JSR         STORE_SECOND_NIBBLE_IN_D3    
    LSR         #1, D3
    MOVE.W      D3, UTILITY_VAR
    JSR         REGISTER_NUM_OUTPUT			
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    RTS
SHIFT_WITH_IMMI_HELPER
    MOVE.W      #8, UTILITY_VAR
    JSR         REGISTER_NUM_OUTPUT			
    JSR         OUTPUT_COMMA				
    JSR         OUTPUT_EMPTY_SPACE			
    RTS

RESTART_OR_FINISH
    LEA    ENDING_P1,  A1
    MOVE.B      #14, D0
    TRAP        #15
    MOVE.B      #4,  D0
    TRAP        #15  
    CMP.B       #1,  D1
    BEQ         DONE
    CMP.B       #0,  D1
    BNE         INVALID_END
    SIMHALT

INVALID_END
    MOVE.B      #14, D0
    TRAP        #15
    BRA         RESTART_OR_FINISH

DONE
    CLR.L       D0
    CLR.L       D1
    CLR.L       D2
    CLR.L       D3
    CLR.L       D4
    CLR.L       D5
    CLR.L       D6
    CLR.L       D7
    MOVEA.L     #0,  A0
    MOVEA.L     #0,  A1
    MOVEA.L     #0,  A2
    MOVEA.L     #0,  A3
    MOVEA.L     #0,  A4
    MOVEA.L     #0,  A5
    MOVEA.L     #0,  A6
    MOVEA.L     #0,  A7
    CLR.L       BEGINNING_ADDRESS
    CLR.L       FINISHING_ADDRESS
    CLR.L       CURRENT_FOUR_NIBBLES_VAR
    CLR.L       DEST_HOLDER
    CLR.L       UTILITY_VAR
    CLR.L       A1_COPY_ONE
    CLR.L       A1_COPY_TWO