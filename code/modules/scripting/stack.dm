/stack
	var/list
		contents=new
	proc
		Push(value)
			contents+=value

		Pop()
			if(!contents.len) return null
			. = contents[contents.len]
			contents.len--

		Top() //returns the item on the top of the stack without removing it
			if(!contents.len) return null
			return contents[contents.len]

		Copy()
			var/stack/S=new()
			S.contents=src.contents.Copy()
			return S

		Clear()
			contents.Cut()

		Length()
			return contents.len

		Swap(value)
			if(value)
				if(value > contents.len)
					return 0
				if(value <= 0)
					return 0
				var/temp = contents[value]
				contents[value] = Top()
				contents[contents.len] = temp
			else
				var/top = Pop()
				var/second_top = Pop()
				Push(top)
				Push(second_top)


/stack/bytecode
	var/limit = 128

/stack/bytecode/Push(value)
	if(limit <= Length())
		return
	..(value)

/stack/bytecode/Pop()
	. = ..()
	if(!.)
		. = 0

/stack/bytecode/Top()
	. = ..()
	if(!.)
		. = 0