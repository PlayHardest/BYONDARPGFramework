datum
	proc
		key_up(k, client/c)
		key_down(k, client/c)

proc
	KeyToDir(key="south")
		if(!key)	return 0
		switch(key)
			if("south","numpad2")	return SOUTH
			if("north","numpad8")	return NORTH
			if("west","numpad4")	return WEST
			if("east","numpad6")	return EAST
			if("northeast","numpad9")	return NORTHEAST
			if("northwest","numpad7")	return NORTHWEST
			if("southeast","numpad3")	return SOUTHEAST
			if("southwest","numpad1")	return SOUTHWEST

client
	var
		list/keys = list()//ALL_KEYS

		input_lock = 0

		datum/focus

		use_numpad = 1

		capslock = 0

		// 1 = translate numpad4 to 4
		// 0 = leave numpad4 as "numpad4"
		translate_numpad_to_numbers = 0

		list/__numpad_mappings = list("numpad0" = "0", "numpad1" = "1", "numpad2" = "2", "numpad3" = "3", "numpad4" = "4", "numpad5" = "5", "numpad6" = "6", "numpad7" = "7", "numpad8" = "8", "numpad9" = "9", "divide" = "/", "multiply" = "*", "subtract" = "-", "add" = "+", "decimal" = ".")

	proc
		lock_input()
			input_lock = 1

		unlock_input()
			input_lock = 0

		clear_input(unlock_input = 1)
			if(unlock_input)
				unlock_input()

			for(var/k in keys)
				keys[k] = 0

	// These verbs are called for all key press, release, and repeat events.
	verb
		KeyDown(k as text)
			set hidden = 1
			set instant = 0

			if(input_lock) return
			if(!use_numpad)
				if(k == "northeast")
					k = "page up"
				else if(k == "southeast")
					k = "page down"
				else if(k == "northwest")
					k = "home"
				else if(k == "southwest")
					k = "end"

			// convert numpad keys to their actual symbols
			if(translate_numpad_to_numbers)
				if(k in __numpad_mappings)
					k = __numpad_mappings[k]
			if(k=="Capslock")	capslock=!capslock
			k=lowertext(k)
			keys[k] = 1
			if(focus)
				focus.key_down(k, src)


		KeyUp(k as text)
			set hidden = 1
			set instant = 0

			k=lowertext(k)

			if(!use_numpad)
				if(k == "northeast")
					k = "page up"
				else if(k == "southeast")
					k = "page down"
				else if(k == "northwest")
					k = "home"
				else if(k == "southwest")
					k = "end"

			// convert numpad keys to their actual symbols
			if(translate_numpad_to_numbers)
				if(k in __numpad_mappings)
					k = __numpad_mappings[k]


			keys[k] = 0
			if(input_lock) return
			if(focus)	focus.key_up(k, src)


	New()
		focus = src
		.=..()
