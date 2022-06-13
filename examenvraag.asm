.eqv OK 1

.globl list_subset_sum 
list_subset_sum:
      beqz a0,uninit_list
      beqz a1,uninit_list
      beqz a2,emptylist 
      
      addi sp,sp,-16
      sw ra,0(sp)
      sw a0,4(sp)
      sw a1,8(sp)
      sw a2,12(sp)
      
      #We willen de lengte van de gegeven lijst om te testen of de index binnen de juiste grenzen ligt. 
      jal list_length
      
      lw a4,(a0) #Lengte zit in a0 en we verplaatsen deze naar a4 voor verder gebruik 
      
      lw ra,0(sp)
      lw a0,4(sp)
      lw a1,8(sp)
      lw a2,12(sp)
      addi sp,sp,16
      
     
      
      li a3,0 #initialiseren van sum
      
      lw t0,(a1) #We vragen hier de pointer naar first op
      lw t0,(t0) #We krijgen hier de eerste index
      
      
loop: 
      addi a2,a2,-1
      
      blez t0,outofbounce
      bge t0,a4,outofbounce
      
      
      addi sp,sp,-20
      sw a0,0(sp) #original list
      sw a2,4(sp) #indexcounter
      sw a3,8(sp) #sum
      sw a4,12(sp)# length of original list
      sw t0,16(sp)# pointer to node in progress of the index list
      
      #a0 staat op de juiste plek
      lw a1,(t1) #indexvalue staat op a1
      #waarde zal op a2 gezet worden. 
      
      jal list_get 
      
      lw a3,12(sp) #load the sum 
      add a3,a3,a2 #update the sum with the new value on a2
      
      lw t0,16(sp) #get the node
      lw t0,4(t0) #We krijgen hier de volgende index
      
      lw a2,4(sp) #get the index counter
      lw a4,12(sp) #get the length of the list
      
      addi sp,sp, 20 #update the pc
      
      beqz a2,endloop #if we are through the loop we end the loop
      j loop 

endloop: 
      lw a0,(a3)
      j leave

emptylist: 
      li a0, 0
      j leave

uninit_list: 
      sw zero,(a0)
      j leave
outofbounce: 
      sw zero,(a0)
      j leave
leave: 
      lw ra,(sp)
      addi sp,sp,4
      ret 