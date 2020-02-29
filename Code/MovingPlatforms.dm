#ifdef JUMP
Platforms
	parent_type=/obj
	base_layer=MOB_LAYER
	//movement_dir can be NORTH,SOUTH,EAST,WEST, along an arc or UP/DOWN
	//travel_distance will be used to control how far the platform will go

	PixelMove(x_move, y_move,d,speed)
		if(!d)	d=dir
		if(!speed)	speed=step_size
		if(x_move||y_move)
			. = Move(loc, d, step_x + x_move, step_y + y_move)
			step_size=speed
			for(var/mob/M in bounds(src))
				if(!M.mid_air && M.under!=src && M._height==_height)
					M.PixelMove(x_move,y_move,M.dir,speed)
		else
			return 0

	StillPlatform
		icon='Box2.dmi'
		icon_state="platform"
		dir=SOUTH
		max_travel_distance=192
		elevation=32
		step_size=5
		pixel_y=-4
		bound_width=64
		bound_height=64
		layer_add=1
		move_trigger="start"

	Cross(atom/movable/o)//IS RAN FOR EVERY MOVEMENT OPERATION INSIDE BOUNDS
		if(move_trigger=="cross")
			var/r=CrossCheck(o)
			if(r == 2)	BeginMovement()
			return r
		else
			return CrossCheck(o)

	New()
		..()
		LocationUpdate()
		if(elevation)
			mid_air=1
			_height+=elevation
			pixel_z+=_height
			elevation=0
			if(move_trigger=="start")	BeginMovement()

	proc
		BeginMovement()
			set waitfor=0
			sleep(10)
			travel_distance=max_travel_distance
			while(travel_distance>0)
				if(Step(dir,step_size))
					travel_distance-=step_size
				sleep(world.tick_lag)
			dir=BehindDir(dir)
			if(move_trigger=="start")	BeginMovement()

#endif