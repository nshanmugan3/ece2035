# HW1-3
# Student Name: Nishalini Shanmugan
# Date: 09/05/19
#
# This program computes the Intersection over Union of two rectangles
# as a percent:
#                 Area(Intersection of R1 and R2) * 100
#  IoU =    -----------------------------------------------------
#           Area(R1) + Area(R2) - Area(Intersection of R1 and R2)
#
# Input: two bounding boxes, each specified as (Tx, Ty, Bx, By), where
#	 (Tx, Ty) is the upper left corner point and
#	 (Bx, By) is the lower right corner point.
# Output: IoU (an integer, 0 <= IoU < 100).
#
# In images, the origin (0,0) is located at the left uppermost pixel,
# x increases to the right and y increases downward.
# So in our bounding box representation, it will always be true that:
#         Tx < Bx and Ty < By.
#
# Assume images are 640x480 and bounding boxes fit within these bounds and
# are always of size at least 1x1.
#
# IoU should be specified as an integer (only the whole part of the division),
# i.e., round down to the nearest whole number between 0 and 100 inclusive.
#
# FOR FULL CREDIT (on all assignments in this class), BE SURE TO TRY
# MULTIPLE TEST CASES and DOCUMENT YOUR CODE.

.data
# DO NOT change the following three labels (you may change the initial values):
#               Tx, Ty,  Bx, By	
R1:	.word	120, 100, 450, 400  
R2:	.word	215, 250, 300, 300 
IoU:	.alloc  1

# Also, for HW1 (only), do not write values to registers $0, $29, $30, or $31
# and do NOT use helper functions or function calls (JAL).

.text
	# write your code here...
	addi $2, $0, R1	  # $1 holds base address of array R1
	lw   $3, 0($2)	  # $3: R1[0]
	lw   $4, 4($2)	  # $4: R1[1]
	lw   $5, 8($2)	  # $5: R1[2]
	lw   $6, 12($2)   # $6: R1[3]
	
	addi $2, $0, R2	   # $2 holds base address of array R2
	lw   $7, 0($2)	   # $7: R2[0]
	lw   $8, 4($2)	   # $8: R2[1]
	lw   $9, 8($2)	   # $9: R2[2]
	lw   $10, 12($2)   # $10: R2[3]

	#Area1 of the Rectangle1
	sub $11,$5,$3      # width1 = R1[2]-R1[0]
	sub $12,$6,$4      # height1 = R1[3]-R1[1]
	mult $11,$12       # width1 times height1 = Area1
	mflo $11           #Area1

	#Area2 of the Rectangle2 
	sub $13,$9,$7       # width2 = R2[2]-R2[0]
	sub $14,$10,$8      # height2 = R2[3]-R2[1]
	mult $13,$14        # width2 times height = Area2
	mflo $13            # Area2

	#Find the max value 
	addi $14,$0,1       # $13 = 1
	slt $15,$7,$3       # is (R2[0]< R1[0])?
	beq $14,$15,Skip1   # if they are, branch to Skip1
	Skip2: add $16,$0,$7  #if it is not,then R2[0] is the max
	j Skip3
	Skip1: add $16,$0,$3  #if it is, then R1[0] is the max or width2

	Skip3: slt $17,$8,$4      # is (R2[1]<R1[1])?
	beq $14,$17,Skip4          
	Skip5: add $18,$0,$8      # if it is not,then R2[1] is the max
	j Skip6                   
	Skip4: add $18,$0,$4      # if it is, then R1[1] is the max or height2

	#Find the min value
	Skip6: slt $19,$9,$5      #is (R2[2]<R1[2])?
	beq $14,$19,Skip8        
	Skip7: add $20,$0,$5      #if it is not,then R1[2] is the min
	j Skip9
	Skip8: add $20,$0,$9      #is it is,then R2[2] is the min or width1

	Skip9: slt $21,$10,$6     #is (R2[3]<R1[3])?
	beq $14,$21,Skip10
	Skip11: add $22,$0,$6     #if it is not,then R1[3] is the min
	j Skip12
	Skip10: add $22,$0,$10    #if it is,then R2[3] is the min or height1

    #AreaInter
	Skip12: sub $23,$20,$16   #interwidth = width1-width2 
	sub $25,$22,$18           #interheight = height1-height2
	mult $25,$23              #interheight times interwidth
	mflo $25                  #AreaInter =  interheight * interwidth

	addi $26,$0,100           #$26 = 0
	mult $25,$26              #Numerator = AreaInter * 100
	mflo $23                  #Numerator
	add $11,$11,$13           #Area1+Area2
	sub $27,$11,$25           #Denominator = Area1+Area2-AreaInter
	slt $4,$27,$0             # if Denominator is less than 0, then set it equal to $4
	beq $4,$0,Skip13          # if the Denominator is not less than 0,then go to Skip13
	addi $11,$0,-1            #if $11 is equal to -1
	mult $27,$11              #Denominator times -1
	mflo $27                  #Changes the Denominator sign from negative to positive 
	Skip13: div $23,$27       #IoU is Numerator/Denominator 
	mflo $25                  #IoU

	#Checking the case in which it is 0
	slt $9,$9,$3              #if (R2[2] is less than R1[0]),then store it in $9
	beq $9,$14,Skip16         # if $9 = 1, then Skip16    
	slt $10,$10,$4            #if (R2[3] is less than R1[1]),then store it in $10
	beq $10,$14,Skip16        # if $10 = 1, then Skip16 
	slt $7,$5,$7              #if (R1[2] is less than R2[0]),then store it in $10
	beq $7,$14,Skip16         # if $7 = 1, then Skip16 
	slt $8,$6,$8              #if (R1[3] is less than R2[1]),then store it in $10
	beq $8,$14,Skip16      # if $8 = 1, then Skip16 
	Skip15: add $28,$0,$25    # IoU = $28
	j Skip14                  #Jump to the End 
	Skip16: add $28,$0,$0     # $28 = 0

	Skip14: sw $28, IoU($0)
	End:	jr $31	     			# return to OS















   
	

