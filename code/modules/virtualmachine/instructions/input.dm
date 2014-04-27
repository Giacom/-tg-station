/datum/instruction/input
	help = {"Instructions for the input stack, which you can't push values to.
	The input stack is formatted like this when a user types hello:
	\[3, 111, 108, 108, 101, 104, 2\]
	Which means:
	\[end text indicator, o, l, l, e, h, start text indicator\]
	You can use INPUT_POP to move the top of the input stack to the top of the memory stack, and you could convert it or print it from there.
	"}

/datum/instruction/input/proc/input_pop()
	. = holder_machine.input_stack.Pop()

/datum/instruction/input/proc/input_clear()
	holder_machine.input_stack.Clear()

/datum/instruction/input/proc/input_mem_length()
	. = holder_machine.input_stack.Length()



/datum/instruction/input/clear
	token = "INPUT_CLEAR"
	help = "Clears the input stack."

/datum/instruction/input/clear/execute()
	input_clear()



/datum/instruction/input/pop
	token = "INPUT_POP"
	help = "Removes the value on top of the input stack and puts it into the memory stack."

/datum/instruction/input/pop/execute()
	push(input_pop())



/datum/instruction/input/stack_len
	token = "INPUT_STACK_LEN"
	help = "Calculates the length of the input stack and pushes the result on top of the memory stack.."

/datum/instruction/input/stack_len
	push(input_mem_length())




/datum/instruction/input/sleep_until_input
	token = "SLEEP_UNTIL_INPUT"
	help = "Makes the virtual machine sleep until input is given."

/datum/instruction/input/sleep_until_input/execute()
	holder_machine.sleep_until_input = 1