/datum/instruction/logic
	help = "Logical instructions which will take and compare values in the stack and then push their results."


/datum/instruction/logic/compare_greater
	token = "CMP_GREATER"
	help = "Takes the two top values from the stack and compares \[ Top > Second-Top \]. Pushes its results as 1 (TRUE) or 0 (FALSE)."

/datum/instruction/logic/compare_greater/execute()
	var/result = (pop() > pop() ? 1 : 0)
	push(result)



/datum/instruction/logic/compare_lesser
	token = "CMP_LESSER"
	help = "Takes the two top values from the stack and compares \[ Top < Second-Top \]. Pushes its results as 1 (TRUE) or 0 (FALSE)."

/datum/instruction/logic/compare_lesser/execute()
	var/result = (pop() < pop() ? 1 : 0)
	push(result)




/datum/instruction/logic/compare_equal
	token = "CMP_EQUAL"
	help = "Takes the two top values from the stack and compares \[ Top == Second-Top \]. Pushes its results as 1 (TRUE) or 0 (FALSE)."

/datum/instruction/logic/compare_equal/execute()
	var/result = (pop() == pop() ? 1 : 0)
	push(result)




/datum/instruction/logic/compare_not_equal
	token = "CMP_NOT_EQUAL"
	help = "Takes the two top values from the stack and compares \[ Top != Second-Top \]. Pushes its results as 1 (TRUE) or 0 (FALSE)."

/datum/instruction/logic/compare_not_equal/execute()
	var/result = (pop() != pop() ? 1 : 0)
	push(result)




/datum/instruction/logic/jump_point
	token = "JUMP_POINT"
	help = "A point declared to be jumped to. The adjacent value will be the label. The label must be a single word. USAGE: JUMP_POINT JumpHere"

/datum/instruction/logic/jump_point/preprocessor(var/value)
	if(value && length(value) > 0)
		holder_machine.add_jump_point(value)

/datum/instruction/logic/jump_point/execute()
	return




/datum/instruction/logic/jump
	token = "JUMP"
	help = "Jumps the instruction pointer to a JUMP_POINT label, for example a JUMP label will jump to where JUMP_POINT label is set."

/datum/instruction/logic/jump/execute(var/value)
	if(value && length(value) > 0)
		var/new_instruction_pointer = holder_machine.get_jump_point(value)
		record_stack()
		holder_machine.set_instruction_pointer(new_instruction_pointer)

/datum/instruction/logic/jump/proc/record_stack()
	return





/datum/instruction/logic/jump/return_
	token = "JUMP_RETURN"
	help = "Like the JUMP command but it records its jump to the JUMP_STACK, allowing you to RETURN to it."

/datum/instruction/logic/jump/return_/record_stack()
	holder_machine.jump_stack.Push(holder_machine.get_instruction_pointer())
	return





/datum/instruction/logic/jump/compare
	token = "JUMP_COMPARE"
	help = "Jumps the instruction pointer to the label or value, if the value taken from the top of the stack is not 0 (FALSE)."

/datum/instruction/logic/jump/compare/execute(var/value)
	if(pop() != 0)
		..(value)





/datum/instruction/logic/jump/compare/return_
	token = "JUMP_COMPARE_RETURN"
	help = "Like the JUMP_RETURN but it will takes and evalulate the top of the stack, if it is not 0 then it will jump."

/datum/instruction/logic/jump/compare/return_/record_stack()
	holder_machine.jump_stack.Push(holder_machine.get_instruction_pointer())
	return





/datum/instruction/logic/jump_return
	token = "RETURN"
	help = "Returns to the last use of the JUMP instruction. If there is no JUMP instruction to jump back to, it stops the program."

/datum/instruction/logic/jump_return/execute()
	var/marker = holder_machine.jump_stack.Pop()
	if(marker == 0)
		holder_machine.stop()
	else
		holder_machine.set_instruction_pointer(marker)



/datum/instruction/logic/jump_return/compare
	token = "RETURN_COMPARE"
	help = "Will return if the popped value of the memory stack isn't 0."

/datum/instruction/logic/jump_return/compare/execute()
	if(pop() != 0)
		..()