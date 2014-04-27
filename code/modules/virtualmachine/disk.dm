/obj/item/weapon/disk/program_disk
	name = "program data disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0"
	item_state = "card-id"
	w_class = 1.0
	var/program_data = "#This is a comment."

/obj/item/weapon/disk/program_disk/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/device/multitool))
		write_data(I, user)
	else
		..()

/obj/item/weapon/disk/program_disk/proc/write_data(var/obj/item/device/multitool/I, var/mob/user)
	var/input_data = input(user, "Create your program here.", "Enter your program.", program_data) as message
	if(in_range(user, src) && user.get_active_hand() == I)
		program_data = input_data
		user << "<span class='notice'>You wrote the program into the disk.</span>"


/obj/item/weapon/disk/storage_disk
	name = "storage data disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0"
	item_state = "card-id"
	w_class = 1.0
	var/stack/bytecode/storage_stack

/obj/item/weapon/disk/storage_disk/New()
	..()
	storage_stack = new()