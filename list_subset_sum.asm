.globl list_subset_sum
# .eqv OK 1 -> zullen we hier geen gebruik van maken
.eqv UNINITIALIZED_LIST 0 #-1, 0 werd gevraagd als error value
#.eqv OUT_OF_MEMORY -2 -> niet relevant hier 
.eqv INDEX_OUT_OF_BOUNDS 0 #-3, 0 werd hier gevraagd als value
# .eqv UNINITIALIZED_RETVAL -4, niet relevant hier 

.text
list_subset_sum:
	addi sp, sp, -16
	sw ra, (sp)
	sw a0, 4(sp) #Storing the list-adress
	sw a1, 8(sp) #Storing the index-list 
	sw a2, 12(sp) #Storing the indice-size
	beqz a0, uninitialized_list 
	beqz a1, uninitialized_list 
	
	jal list_length # list-length will use the a0-input, since it only will make sense to calculate the length of the given list, since the index length is given.  
	
	# a0 has now the length of the given list. We store it in a7. 
	mv a7,a0
	
	lw ra, (sp)
	lw a1, 8(sp)  
	lw a2,12(sp)
	 #Since  we consider a sum of the subset, the indice-size has to be smaller or equal in length with the given list 
	bge a7, a2, index_out_of_bounds
	
	lw a0, 4(sp) # We store the list pointer in a0, because we are going to use t0 as value for our subset-sum. 
	
	li t0, 0 #Subset sum 
	li t2, 0 #Counter to see if the end of indice-size has been reached. 
	
	lw t1, (a1) 
	# first index is stored in t1 
	
	addi sp,sp,16
	
	bnez a2, validcheck  
	mv a0,t0 # We put the value zero in the return-reg because we are dealing with an empty list.  
	j leave

validcheck:
        addi t2,t2,1
	bge a7, t1,   index_out_of_bounds
	blt t1, zero, index_out_of_bounds
	j loop	

loop:
        #Here we need to put a0 (list-pointer), t0 (sum), t1 (main index value), t2 (index-counter) a2 (index-length), a7(list-length) 
	addi sp,sp,-28
	sw ra,0(sp)
	sw a0,4(sp)
	sw t0,8(sp)
	sw t1,12(sp)
	sw t2,16(sp)
	sw a2,20(sp)
	sw a7,24(sp)
	
	# a0 is already available as the present list 
	mv a1,t1
	# a2 is the adress where the list-value will be stored
	
	jal list_get
	
	lw ra,0(sp)
	lw a0,4(sp)
	
	lw t0,8(sp)
	add t0,t0,a2
	
	lw t1,12(sp)
	lw t2,16(sp)
	lw a2,20(sp)
	lw a7,24(sp)
	addi sp,sp,28
	
	lw t3, 4(t1)
	beq t2, a2, endloop        # Kijken of einde van de lijst is bereikt
	mv t1, t3
	j validcheck 	
	

endloop:
        mv a0,t0
	beqz t3,leave # double-check


uninitialized_list:
	li a0, UNINITIALIZED_LIST 
	j leave
	
index_out_of_bounds:
	li a0, INDEX_OUT_OF_BOUNDS
	j leave

leave:
	ret
