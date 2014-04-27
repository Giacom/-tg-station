/datum/instruction/memory
	help = {"Instructions for the memory stack. The memory stack lets you store and collect values, like variables in programming languages.
			It is how the machine uses values in other instructions, as they will typically take the top of the stack as an argument.
			If you want to know how to store values more speficially, look at registers.

			You can only collect and store values on top of the stack. Example:
			\[1, 2\] is our memory stack with 1 on the bottom and 2 on the top. If we use the PUSH instruction
			>PUSH 5
			\[1, 2, 5\] then our memory stack now has 5 on top, 2 in the middle and 1 on the bottom.
			>POP
			\[1, 2\] the POP instruction removed the top value for us.
			>ADD
			\[3\] the ADD instruction then added 1 and 2 and pushed the result, leaving 3.

			The memory stack has a limit of 128 values, you cannot add anymore values when you reach the limit and if you try to pop() an empty stack you will receive 0.
			"}


/datum/instruction/memory/push
	token = "PUSH"
	help = "Pushes a value to the stack. USAGE: PUSH 5"

/datum/instruction/memory/push/execute(var/value)
	push(text2num(value))


/datum/instruction/memory/push/char
	token = "PUSH_CHAR"
	help = "Pushes a char to the stack, in its ASCII code. USAGE: PUSH u"

/datum/instruction/memory/push/char/execute(var/value)
	if(istext(value))
		..(text2ascii(value))



/datum/instruction/memory/clear
	token = "CLEAR"
	help = "Clears the memory stack."

/datum/instruction/memory/clear/execute()
	clear()



/datum/instruction/memory/pop
	token = "POP"
	help = "Removes the value on top of the stack."

/datum/instruction/memory/pop/execute()
	pop()


/datum/instruction/memory/swap
	token = "SWAP"
	help = "Swaps the top two values with each other."

/datum/instruction/memory/swap/execute()
	swap()


/datum/instruction/memory/swap/index
	token = "SWAP_INDEX"
	help = "Pops the top of the stack to get an index to swap with the top of the stack."

/datum/instruction/memory/swap/index/execute()
	swap(pop())


/datum/instruction/memory/copy
	token = "COPY"
	help = "Takes the value on top of the stack and pushes it back the amount of times specified, making additional copies."

/datum/instruction/memory/copy/execute(var/value)
	value = text2num(value)
	if(value)
		var/popped_value = pop()
		for(var/i = 1; i <= value + 1; i++)
			push(popped_value)



/datum/instruction/memory/stack_len
	token = "STACK_LEN"
	help = "Calculates the length of the stack and pushes the result on top."

/datum/instruction/memory/stack_len/execute()
	push(mem_length())


