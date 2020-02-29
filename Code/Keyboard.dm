Controls
	var
		up = K_UP
		down = K_DOWN
		left = K_LEFT
		right = K_RIGHT
		jump = K_JUMP


mob
	proc
		KeyDir()
			directional_keys["numpad1"]=SOUTHWEST
			directional_keys["numpad2"]=SOUTH
			directional_keys["numpad3"]=SOUTHEAST
			directional_keys["numpad4"]=WEST
			directional_keys["numpad5"]=SOUTH//CENTER
			directional_keys["numpad6"]=EAST
			directional_keys["numpad7"]=NORTHWEST
			directional_keys["numpad8"]=NORTH
			directional_keys["numpad9"]=NORTHEAST
			directional_keys["[client.controls.up]"]=NORTH
			directional_keys["[client.controls.down]"]=SOUTH
			directional_keys["[client.controls.left]"]=WEST
			directional_keys["[client.controls.right]"]=EAST
			movement_keys=list("numpad1","numpad2","numpad3","numpad4","numpad5","numpad6","numpad7","numpad8","numpad9","[client.controls.up]","[client.controls.down]","[client.controls.right]","[client.controls.left]")

		GetMovementDirection()
			var/retval=0
			if(client)
				if(!movement_keys.len)	KeyDir()
				for(var/v in movement_keys)
					if(client.keys[v])
						retval=directional_keys[v]
						break
				if(client.keys["[client.controls.up]"] && client.keys["[client.controls.left]"])
					retval=NORTHWEST
				if(client.keys["[client.controls.up]"] && client.keys["[client.controls.right]"])
					retval=NORTHEAST
				if(client.keys["[client.controls.down]"] && client.keys["[client.controls.left]"])
					retval=SOUTHWEST
				if(client.keys["[client.controls.down]"] && client.keys["[client.controls.right]"])
					retval=SOUTHEAST

				if(client.keys["numpad8"] && client.keys["numpad4"])
					retval=NORTHWEST
				if(client.keys["numpad8"] && client.keys["numpad6"])
					retval=NORTHEAST
				if(client.keys["numpad2"] && client.keys["numpad4"])
					retval=SOUTHWEST
				if(client.keys["numpad2"] && client.keys["numpad6"])
					retval=SOUTHEAST
			else
				retval=dir
			return retval


	proc
		KeyTimeout(k)
			set waitfor=0
			var/timeout=5
			while(timeout>0)
				timeout--
				if(client.lastpressed!=k)	break
				sleep(1)
			if(client.lastpressed==k)	client.lastpressed=null



