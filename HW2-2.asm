#     When Harry Met Sally
#
# Your Name: Nishalini Shanmugan	
# Date: 9/13/19
#
#
# This program finds the earliest point at which Harry and Sally lived in the
# same city.
#
#  required output register usage:
#  $2: earliest year in same city
#
	
.data
Harry:  .alloc  10            # allocate static space for 5 duration-city pairs
Sally:  .alloc  10            # allocate static space for 5 duration-city pairs

.text
WhenMet:	addi  $1, $0, Harry     # set memory base
        	swi     597             # create timelines and store them

		# your code goes here
			       addi $4,$0,1990                    #Harry_start_year
			       addi $5,$0,1990                    #Harry_end_year
			       addi $6,$0,1990                    #Sally_start_year
			       addi $7,$0,1990                    #Sally_end_year

		#Outer For Loop
			       addi  $1,$0,0                        #i
		OuterLoop: slti  $2,$1,10                       #2 = i<10
	               beq   $2,$0,Exit                     #if i is greater than 10 exit the loop

			       addi $4,$5,0			                #Harry_start_year = Harry_end_year

			       addi $19,$0,4                        #Add 4 to $19
			       mult $19,$1                          #Multiply $19 and $1 
			       mflo $19                             #Multiflo to $19
			       lw $17, Harry($19)                   #HarryTimeline[i]
			       add $5,$5,$17		                #Add Harry_end_year to HarryTimeline[i]

				   addi $6,$0,1990                      #Sally_start_year
			       addi $7,$0,1990                      #Sally_end_year

		#Inner For Loop
				   addi  $8,$0,0                         #j
		InnerLoop: slti  $9,$8,10                        #2 = j<10 
				   beq   $9,$0,AfterInnerLoop            #if j is greater than 10 exit the loop

			       addi $6,$7,0                         #Sally_start_year = Harry_end_year

			       addi $12,$0,4                        #Add 4 to $12
			       mult $12,$8                          #Multiply $12 and $8
			       mflo $12                             #Multiflo to $12
			       lw $18, Sally($12)                   #SallyTimeline[j]
			       add $7,$7,$18		                #Add Sally_end_year to SallyTimeline[j] 

		#First If statement
			       addi $19,$0,4
			       mult $19,$1
			       mflo $19	
			       lw  $17,Harry($19)                   #HarryTimeline[i]
			       addi $20,$19,4		      
			       lw  $10,Harry($20)                   #HarryTimeline[i+1]
			
			       addi $12,$0,4
			       mult $12,$8
			       mflo $12
			       lw $18,Sally($12)                    #SallyTimeline[j] 
			       addi $20,$12,4
			       lw $11,Sally($20) 			        #SallyTimeline[j+1]		              
						              

			       bne $10,$11,PastIf	               #If HarryTimeline[i+1]=SallyTimeline[j+1]

		#Second If statement
				   slt $13,$6,$4	 				   #Harry_start_year <= Sally_start_year
				   bne $13,$0,ThirdIf					  
				   slt $14,$6,$5	 				   #Sally_start_year < Harry_end_year
				   beq $14,$0,ThirdIf
				   addi $2,$6,0				           #Year= Sally_start_year
				   j End									   

		#Third If statement
		ThirdIf:   slt $15,$4,$6			           #Sally_start_year <= Harry_start_year
				   bne $15,$0,PastIf
				   slt $16,$4,$7					   #Harry_start_year < Sally_end_year
				   beq $16,$0,PastIf	  
			       addi $2,$4,0				           #Year=Harry_start_year
			       j End

		Exit: addi $2,$2,0
			  j End	

		PastIf:          addi $8,$8,2
						 j InnerLoop
													   
		AfterInnerLoop:   addi $1,$1,2
						  j OuterLoop

		AfterOuterLoop:   addi  $2, $0, 0		# TEMP: (guess answer=0) REPLACE THIS

		End:			  swi   587		          # give answer
                		  jr    $31               # return to caller
