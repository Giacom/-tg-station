/obj/machinery/computer/programmable
	name = "programmable computer console"
	icon_state = "command"
	circuit = /obj/item/weapon/circuitboard/programmable
	var/datum/interface/console_interface
	var/obj/item/weapon/disk/data/console/data_disk

/obj/machinery/computer/programmable/New()
	..()
	console_interface = new(src)

/obj/machinery/computer/programmable/Del()
	console_interface.delete()
	..()

/obj/machinery/computer/programmable/attack_hand(var/mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/computer/programmable/interact(user)
	console_interface.show_screen(user)

/obj/machinery/computer/programmable/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/disk/program_disk))
		var/obj/item/weapon/disk/program_disk/diskette = I
		console_interface.virtual_machine.load(diskette.program_data)
		user << "<span class='notice'>You load the disk data onto the computer.</span>"
	else if(istype(I, /obj/item/device/multitool))
		console_interface.virtual_machine.debugging = user
		user << "<span class='notice'>You start debugging the program.</span>"
	else
		..()

/obj/machinery/computer/programmable/power_change()
	..()
	if(stat & NOPOWER)
		console_interface.virtual_machine.stop()