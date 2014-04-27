/datum/instruction/operator
	help = "Operators which will take the two top values in the memory stack and push its result back on top."

/datum/instruction/operator/add
	token = "ADD"
	help = "Takes and adds the top two values in the stack and then pushes it back on top."

/datum/instruction/operator/add/execute()
	push(pop() + pop())



/datum/instruction/operator/mult
	token = "MULT"
	help = "Takes and multiplies the top two values in the stack and then pushes it back on top."

/datum/instruction/operator/mult/execute()
	push(pop() * pop())



/datum/instruction/operator/mult
	token = "DIV"
	help = "Takes and divides the top two values in the stack and then pushes it back on top. If dividing by zero, it will return a zero."

/datum/instruction/operator/mult/execute()
	var/a = pop()
	var/b = pop()
	if(a != 0 && b != 0) // Damn divide by zero errors.
		push(a / b)
	else
		push(0)


/datum/instruction/operator/sub
	token = "SUB"
	help = "Takes and subtracts the top two values in the stack and then pushes it back on top."

/datum/instruction/operator/execute()
	push(pop() - pop())



/datum/instruction/operator/modulo
	token = "MODULO"
	help = "Takes and modulos the top two values in the stack and then pushes it back on top."

/datum/instruction/operator/modulo/execute()
	push(pop() % pop())