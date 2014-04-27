
// Abstract
/datum/instruction
	var/token
	var/help = "An instruction is a command you tell the computer. Some instructions uses the memory stack as arguments while some will let you put the value next to them as arguments."
	var/datum/virtual_machine/holder_machine
	var/datum/interface/holder_interface

/datum/instruction/New(var/datum/virtual_machine/new_holder_machine, var/datum/interface/new_holder_interface)
	..()
	holder_machine = new_holder_machine
	holder_interface = new_holder_interface

/datum/instruction/proc/get_instruction_name()
	var/instruction_name
	if(token)
		instruction_name = token
	else
		instruction_name = capitalize(get_type_name(type))
	return instruction_name

/datum/instruction/proc/delete()
	holder_machine = null
	holder_interface = null

/datum/instruction/proc/push(var/value)
	holder_machine.memory_stack.Push(value)

/datum/instruction/proc/pop()
	. = holder_machine.memory_stack.Pop()

/datum/instruction/proc/clear()
	holder_machine.memory_stack.Clear()

/datum/instruction/proc/swap(var/value)
	holder_machine.memory_stack.Swap(value)

/datum/instruction/proc/mem_length()
	. = holder_machine.memory_stack.Length()

/datum/instruction/proc/execute(var/value)
	error("[src.token] should have an overriden execute()")
	return

/datum/instruction/proc/preprocessor(var/value)
	return