/datum/instruction/output
	help = {"Instructions which can manipulate the output screen.
	A print instruction will print a character to the current buffer pointer Y and X.
	The Y buffer pointer counts from the top side of the screen.
	The X buffer pointer counts from the left side of the screen.
	By default, the buffer pointer starts at (1, 1); the top left start of the screen.
	"}


/datum/instruction/output/print_char
	token = "PRINT_CHAR"
	help = "Uses the adjacent value to print a character into the buffer. USAGE: PRINT_CHAR c"

/datum/instruction/output/print_stack/execute(var/value)
	if(value && length(value) > 0)
		var/char = copytext(value, 1, 2)
		holder_interface.set_buffer(char)



/datum/instruction/output/print_stack
	token = "PRINT_STACK"
	help = "Takes a single value on top of the stack and prints its ASCII value into the current buffer pointer. Useful for printing the input stack, see: INPUT_POP."

/datum/instruction/output/print_stack/execute()
	var/char = ascii2text(pop())
	holder_interface.set_buffer(char)



/datum/instruction/output/clear_buffer
	token = "CLEAR_BUFFER"
	help = "Clears the interface screen's buffer. Use LOAD_BUFFER to refresh the screen with the results."

/datum/instruction/output/clear_buffer/execute()
	holder_interface.clear_text_buffer()


/datum/instruction/output/read
	token = "READ"
	help = "Reads the character that the buffer pointer is set to and pushes the result on top of the memory stack. 0 is null."

/datum/instruction/output/read/execute()
	push(holder_interface.read_buffer())




/datum/instruction/output/set_buffer_pointer_x
	token = "SET_BUFFER_POINTER_X"
	help = "Takes the top value ontop of the memory stack and sets the buffer pointer X value to it, allowing you to print there using PRINT_CHAR."

/datum/instruction/output/set_buffer_pointer_x/execute()
	holder_interface.set_pointer(pop(), holder_interface.buffer_pointer_y)





/datum/instruction/output/set_buffer_pointer_y
	token = "SET_BUFFER_POINTER_Y"
	help = "Takes two top value ontop of the memory stack and sets the buffer pointer Y value to it, allowing you to print there using PRINT_CHAR."

/datum/instruction/output/set_buffer_pointer_y/execute()
	holder_interface.set_pointer(holder_interface.buffer_pointer_x, pop())





/datum/instruction/output/get_buffer_pointer_x
	token = "GET_BUFFER_POINTER_X"
	help = "Pushes the X value of the buffer pointer to the memory stack."

/datum/instruction/output/get_buffer_pointer_x/execute()
	push(holder_interface.buffer_pointer_x)





/datum/instruction/output/get_buffer_pointer_y
	token = "GET_BUFFER_POINTER_Y"
	help = "Pushes the Y value of the buffer pointer to the memory stack."

/datum/instruction/output/get_buffer_pointer_y/execute()
	push(holder_interface.buffer_pointer_y)



/datum/instruction/output/load_buffer
	token = "LOAD_BUFFER"
	help = "Loads the buffer to the screen."

/datum/instruction/output/load_buffer/execute()
	holder_interface.refresh_buffer()




/datum/instruction/output/get_max_buffer_x
	token = "GET_MAX_BUFFER_X"
	help = "Pushes the max buffer X value to the memory stack."

/datum/instruction/output/get_max_buffer_x/execute()
	push(BUFFER_WIDTH)




/datum/instruction/output/get_max_buffer_y
	token = "GET_MAX_BUFFER_Y"
	help = "Pushes the max buffer Y value to the memory stack."

/datum/instruction/output/get_max_buffer_y/execute()
	push(BUFFER_HEIGHT)