/datum/instruction_value_pair
	var/datum/instruction/instruction
	var/value

/datum/instruction_value_pair/New(var/new_instruction, var/new_value)
	instruction = new_instruction
	value = new_value