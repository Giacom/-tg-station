/mob/verb/consolesubmit(var/params as text)
	set name = ".consolesubmit"
	set hidden = 1

	var/params_list = params2list(params)

	var/input = winget(src, "console.console_input", "text")

	var/datum/interface/console_interface
	if(params_list["console_interface"])
		console_interface = locate(params_list["console_interface"])

	if(input && istype(console_interface))
		console_interface.on_input(input)
	winset(src, "console.console_input", "text=\"\"")

/obj/item/weapon/book/manual/programming_instructions_manual // Get it? Instructions manual! Hehe
	name = "Programming Instructions Manual"
	icon_state ="bookParticleAccelerator"

/obj/item/weapon/book/manual/programming_instructions_manual/attack_self(var/mob/user)
	if(!dat)
		load_instructions()
	..()

/obj/item/weapon/book/manual/programming_instructions_manual/proc/load_instructions()

	dat = "<h1>Table of Contents</h1>"

	dat += "<ol>"

	var/datum/instruction/original = new /datum/instruction()
	dat += "<li><a href='#[original.get_instruction_name()]'>[original.get_instruction_name()]</a></li>"
	var/list/all_instructions = get_instructions(/datum/instruction)

	dat += "</ol>"

	for(var/datum/instruction/I in all_instructions)
		var/instruction_name = I.get_instruction_name()
		var/heading
		if(I.token)
			heading = "h4"
		else
			heading = "h2"

		dat += "<BR><[heading]><a id='[instruction_name]'>[instruction_name]</a></[heading]>"
		dat += "<p>[I.help]</p>"

/obj/item/weapon/book/manual/programming_instructions_manual/proc/get_instructions(var/type)
	. = list()

	var/index = 0
	for(var/instruction_type in typesof(type) - type)
		if(!index)
			dat += "<ol>"
		index++
		var/datum/instruction/I = new instruction_type()
		if(I.parent_type != type)
			continue

		var/instruction_name = I.get_instruction_name()
		. += I
		dat += "<li><a href='#[instruction_name]'>[instruction_name]</a></li>"
		. += get_instructions(I.type)

	if(index)
		dat += "</ol>"