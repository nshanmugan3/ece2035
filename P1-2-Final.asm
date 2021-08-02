#     T o p  o f  P i l e
#
#
# This routine finds the color of the part on top of a pile.
#
# Name: Nishalini Shanmugan
# Date: 9/27/19

.data
Pile:  .alloc	1024
CrossOut: .word 0x01010100, 0x01010101 

.text

TopOfPile:	addi	$1, $0, Pile		# point to array base
		swi	545			# generate pile

	        # SWI 547 is useful for debugging. Remove calls to it in
		# final program submission.
		# TEMP: remove the lines between **********
		#addi    $2, $0, 101		# TEMP: set a random offset into pile
		#swi     547			# TEMP: highlight that position
		#addi    $2, $0, 165		# TEMP: set another offset into pile
		#swi     547			# TEMP: highlight that position
		#addi    $2, $0, 229		# TEMP: set another offset into pile
		#swi     547			# TEMP: highlight that position	
		# *****************************************
                # your code goes here

                     addi $1,$1,130							    #i = 130
                     addi $7,$0,6                               #int count
        Increment2:  addi $1,$1,2
         WhileLoop:  lb $2, 0($1)                              #Pile[i]
                     beq $2,$0, Increment2                      #Pile[i] != 0  
                     lb $3, -1($1)                             #prev = Pile[i-1]         		
                     lb $4, 1($1)                              #after = Pile[i+1]  
                     #lbu $5, -64($1)                           #top = Pile[i+64] 						
                     lb $6, 64($1)                             #bottom = Pile[i-64]
                     lbu $8,CrossOut($3)
                     beq $8,$0,SecondIf                         #Flagmap[prev] = 1
                     bne $3,$4,ThirdIf                          #prev == after
         		     beq $3,$2,SecondIf					        #prev != curr
         		     bne $6,$2,SecondIf						    #bottom == curr
                     j Count                   
         SecondIf:   lb $3, -64($1)                            #top = Pile[i+64]
                     lbu $8, CrossOut($3)                       
                     beq $8,$0,ThirdIf                          #FlagMap[top]=1
         		     beq $3,$2,ThirdIf						    #top != curr
         		     bne $3,$6,ThirdIf						    #top == bottom
         		     bne $4,$2,ThirdIf						    #after == curr 
          Count:     sb $0, CrossOut($3)                        #Flagmap[top] = 0
                     addi $7,$7,-1                              #count--
        ThirdIf:     addi $1,$1,1                               #i++
                     bne $7,$0,WhileLoop                        #if count == 0, then go to WhileLoop
           Break:    add $2,$0,$0                               #TopColor == 0 
      SecondLoop:    lbu $4, CrossOut($2)                       #Flagmap[TopColor] 
                     bne $4,$0,End                              #Flagmap[TopColor] == 1
                     addi $2,$2,1                               #TopColor++ 
                     j SecondLoop


	
		# TEMP: replace this line to give your answer
   End:              add    $2, $0, $2               # TEMP: guess the first color
 	                swi	546			# submit answer and check
			        jr	$31			# return to caller
