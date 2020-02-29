mob
	key_down(k, client/c)
		client.currentkey=k
		if(c?.active_textbox)
			c.keyinput(k)
			return
		if(k=="return")
			if(client.keys["alt"])
				src<< output(null,"browser1:ToggleFullscreen")
			else
				if(!c.active_textbox)
					c.textbox.Activate()
		StateMachine()
		if(!directional_keys.len)
			KeyDir()
		if(k==client.lastpressed)
			if(k in directional_keys)
				if(ingame)
					Run_Toggle()
		if(ingame)
			#ifdef JUMP
			if(k==client.controls.jump)
				Jump()
			#endif
			if(k in directional_keys)
				MoveLoop()

		if(client.lastpressed)
			client.lastpressed=null


	key_up(k, client/c)
		client.currentkey=null
		StateMachine()
		if(ingame)
			if(k in directional_keys)
				can_wall_bounce=0
				var/stillrun=0
				for(var/s in directional_keys)
					if(client.keys[s])
						stillrun=1
						break
				if(run && !stillrun)
					Run_Toggle()
		client.lastpressed=k
		KeyTimeout(k)