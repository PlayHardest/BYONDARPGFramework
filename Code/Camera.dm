Camera
	parent_type=/obj/
	var
		tmp
			client/Player
			atom/movable/Focus

	Create(client/c)
		if(!c)
			loc=null
		Player=c
		c.camera=src
		return
		Focus(c.mob)//specify a starting location if necessary for menus

	proc
		Focus(atom/movable/m)//focuses the camera on the supplied movable
			if(Focus)//if there is already a focus
				Focus.watchers -= src//then we remove the camera from their list of watchers
			m = m ? m : Player//if no movable is supplied to focus then focus the client by default
			if(!m)	return
			Player.eye = src//set the owner of the camera's eye to the camera
			Focus = m//set m as the focus of the camera
			setPosition(m)
			m.watchers += src //acknowledge that the camera is now watching m

		HeightFocus(atom/movable/m,_y,t)
			m = m ? m : (Focus ? Focus : Player)//if no movable is supplied to have their height focused then focus the current Focus if supplied, if not, focus the client
			if(!m||!_y||!t)	return
			step_size=_y/t
			Move(loc,dir,step_x,step_y+_y)
			world<<"camera height shift by [_y] at [step_size]([t])"