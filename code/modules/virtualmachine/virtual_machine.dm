var/const/START_TEXT_INDICATOR = 2
var/const/END_TEXT_INDICATOR = 3

var/const/COMMENT_CHARACTER = "#"

/datum/virtual_machine
	var/stack/bytecode/memory_stack
	var/stack/bytecode/input_stack
	var/stack/bytecode/jump_stack
	var/program_text
	var/running = 0
	var/sleep_until_input = 0

	var/instruction_pointer = 1
	var/list/program_bytecode = list()

	var/list/jump_points = list()
	var/list/registers = list()

	var/list/all_instructions = list()
	var/datum/interface/console_interface

	var/tick_rate = 1
	var/execute_batch_amount = 5
	var/program_count = 1
	var/mob/debugging = null


/datum/virtual_machine/New(var/datum/interface/new_interface)
	..()
	memory_stack = new()
	input_stack = new()
	jump_stack = new()
	set_interface(new_interface)
	initialize_instructions()

/datum/virtual_machine/proc/set_interface(var/datum/interface/new_interface)
	console_interface = new_interface

/datum/virtual_machine/proc/delete()
	stop()
	program_bytecode.Cut()
	all_instructions.Cut()

/datum/virtual_machine/proc/initialize_instructions()
	all_instructions.Cut()
	for(var/instruction_type in typesof(/datum/instruction))
		var/datum/instruction/instruction = new instruction_type(src, console_interface)
		if(instruction.token)
			all_instructions[instruction.token] = instruction
		else
			instruction.delete()

/datum/virtual_machine/proc/load(var/new_program)
	program_text = new_program
	read()
	start()


/datum/virtual_machine/proc/read()
	program_bytecode.Cut()
	stop()
	var/list/program_lines = text2list(program_text)
	for(var/line in program_lines)
		read_line(line)
	preprocessor_run()

/datum/virtual_machine/proc/read_line(var/line)
	line = trim(line)
	if(length(line) <= 0)
		return
	var/comment_found = findchar(line, COMMENT_CHARACTER) // Ignore comments
	if(comment_found > 0)
		if(comment_found == 1)
			return
		line = copytext(line, 1, comment_found - 1)
		line = trim(line)

	var/list/tokens = text2list(line, " ")
	read_tokens(tokens)


/datum/virtual_machine/proc/read_tokens(var/list/tokens)
	var/datum/instruction/instruction
	var/value
	// Read instruction
	if(tokens.len >= 1)
		instruction = get_instruction(tokens[1])

	// Read values
	if(tokens.len >= 2)
		value = tokens[2]

	if(instruction)
		program_bytecode += new /datum/instruction_value_pair(instruction, value)


/datum/virtual_machine/proc/preprocessor_run()
	for(var/datum/instruction_value_pair/IVP in program_bytecode)
		IVP.instruction.preprocessor(IVP.value)
		instruction_pointer++
	instruction_pointer = 1

/datum/virtual_machine/proc/start()
	if(!program_bytecode.len)
		return
	if(running)
		return
	var/current_program_count = program_count++
	running = current_program_count
	instruction_pointer = 1
	spawn()
		while(running == current_program_count)
			tick()
			sleep(tick_rate)


/datum/virtual_machine/proc/stop()
	running = 0
	instruction_pointer = 1
	sleep_until_input = 0
	console_interface.clear_screen()
	clear_memory()


/datum/virtual_machine/proc/clear_memory()
	memory_stack.Clear()
	input_stack.Clear()
	jump_points.Cut()
	registers.Cut()


/datum/virtual_machine/proc/tick()
	for(var/i = 0; i < execute_batch_amount; i++)
		if(running)
			if(program_bytecode.len < instruction_pointer)
				stop() // End of program.
				return
			if(sleep_until_input)
				if(input_stack.Length())
					sleep_until_input = 0
				else
					return
			execute_instruction_value(program_bytecode[instruction_pointer])
			instruction_pointer++

/datum/virtual_machine/proc/execute_instruction_value(var/datum/instruction_value_pair/instruction_value_pair)
	var/datum/instruction/executing_instruction = instruction_value_pair.instruction
	executing_instruction.execute(instruction_value_pair.value)
	print_debug(executing_instruction.token, instruction_value_pair.value)

/datum/virtual_machine/proc/print_debug(var/token, var/value)
	if(isliving(debugging))
		if(!in_range(console_interface.holder, debugging))
			debugging = null
			return

		var/dat = "<span class='notice'> ----</span>\n"
		dat += "Executing [token] [value]\n"
		dat += "Result Memory Stack: \[[list2text(memory_stack.contents, ", ")]\]\n"
		debugging.show_message(dat, 1)


/datum/virtual_machine/proc/on_input(var/input_text)

	var/list/char_codes = text2listascii(input_text)
	input_stack.Push(END_TEXT_INDICATOR) // End of text indicator

	// Push it in reverse so they can be popped in the correct order.
	for(var/char in reverselist(char_codes))
		input_stack.Push(char)
	// Push the start of text indicator.

	input_stack.Push(START_TEXT_INDICATOR)

/datum/virtual_machine/proc/add_jump_point(var/label)
	jump_points[label] = instruction_pointer


/datum/virtual_machine/proc/get_jump_point(var/label)
	return jump_points[label]


/datum/virtual_machine/proc/set_instruction_pointer(var/new_point)
	instruction_pointer = Clamp(1, new_point, program_bytecode.len)


/datum/virtual_machine/proc/get_instruction_pointer()
	return instruction_pointer

/datum/virtual_machine/proc/get_instruction(var/instruction_token)
	if(instruction_token && all_instructions[instruction_token])
		. = all_instructions[instruction_token]