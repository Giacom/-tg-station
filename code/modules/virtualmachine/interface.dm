var/const/BUFFER_HEIGHT = 16
var/const/BUFFER_WIDTH = 48

/datum/interface
	var/screen_buffer[BUFFER_HEIGHT][BUFFER_WIDTH] // What the screen shows.
	var/text_buffer[BUFFER_HEIGHT][BUFFER_WIDTH] //If an instruction loads a buffer then it copies the text buffer to the screen buffer.
	var/buffer_pointer_x = 1
	var/buffer_pointer_y = 1

	var/background_colour = "#000000"
	var/foreground_colour = "#FFFFFF"
	var/font = "Courier New"

	var/datum/virtual_machine/virtual_machine
	var/obj/machinery/holder

/datum/interface/New(var/new_holder)
	..()
	holder = new_holder
	set_virtual_machine()

/datum/interface/proc/set_virtual_machine()
	virtual_machine = new(src)

// Loading related procs

/datum/interface/proc/get_html()
	. = {"
	<HTML>
		[load_options()]
		[load_buffer()]
		</BODY>
	</HTML>
	"}


/datum/interface/proc/load_options()
	. = {"
		<HEAD>
		[load_javascript()]
		</HEAD>
		<BODY bgcolor='[background_colour]' onKeyPress='onInput(event);'>
	"}


/datum/interface/proc/load_javascript()
	. = {"<script type='text/javascript'>
		function onInput(event) {
			document.location.href = '?src=\ref[src];input=' + event.keyCode;
		}
	</script>"}


/datum/interface/proc/load_buffer()
	. = "<font color='[foreground_colour]' face='[font]'>"
	for(var/y = 1; y <= BUFFER_HEIGHT; y++)
		for(var/x = 1; x <= BUFFER_WIDTH; x++)
			var/value = screen_buffer[y][x]
			if(value)
				. += html_encode(value)
			else
				. += " "
		. += "<BR>"
	. += "</font>"


/datum/interface/proc/show_screen(var/mob/user)
	if(!user.client)
		return
	winshow(user, "console")
	var/output = list("console_interface" = "\ref[src]")
	winset(user, "console.console_submit", "command=\".consolesubmit [list2params(output)]\"")
	user << browse(get_html(), "window=console.console_screen")


/datum/interface/proc/clear_screen()
	buffer_pointer_x = 1
	buffer_pointer_y = 1
	clear_text_buffer()
	clear_screen_buffer()
	holder.updateDialog()

/datum/interface/proc/clear_text_buffer()
	var/new_text_buffer[BUFFER_HEIGHT][BUFFER_WIDTH]
	text_buffer = new_text_buffer

/datum/interface/proc/clear_screen_buffer()
	var/new_screen_buffer[BUFFER_HEIGHT][BUFFER_WIDTH]
	screen_buffer = new_screen_buffer

// Access related procs

/datum/interface/proc/set_buffer(var/value)
	text_buffer[buffer_pointer_y][buffer_pointer_x] = value

/datum/interface/proc/read_buffer()
	var/value = text_buffer[buffer_pointer_y][buffer_pointer_x]
	return isnull(value) ? 0 : text2ascii(value)


/datum/interface/proc/refresh_buffer()
	for(var/y = 1; y <= BUFFER_HEIGHT; y++)
		for(var/x = 1; x <= BUFFER_WIDTH; x++)
			screen_buffer[y][x] = text_buffer[y][x]
	holder.updateDialog()

/datum/interface/proc/set_pointer(var/x, var/y)
	buffer_pointer_x = Clamp(x, 1, BUFFER_WIDTH)
	buffer_pointer_y = Clamp(y, 1, BUFFER_HEIGHT)


// Access input related procs

/datum/interface/Topic(href, href_list)
	..()
	//if(href_list["input"])
		//on_input(text2num(href_list["input"]))


/datum/interface/proc/on_input(var/input_text)
	virtual_machine.on_input(input_text)

/datum/interface/proc/delete()
	virtual_machine.delete()
	holder = null

