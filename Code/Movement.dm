
client
	perspective = EDGE_PERSPECTIVE
	show_popup_menus = 0
	//edge_limit="SOUTHWEST to NORTHEAST"
	//control_freak=1
	fps=50

	var
		active=1

	proc
		ResetDirs()
			north=0
			south=0
			east=0
			west=0


		ClearMovementKeys()
			var/list/directional_keys=list("numpad1","numpad2","numpad3","numpad4","numpad5","numpad6","numpad7","numpad8","numpad9",controls.up,controls.down,controls.left,controls.right)
			north=0
			south=0
			east=0
			west=0
			for(var/v in directional_keys)
				keys[v]=0

	Northeast()
	Northwest()
	Southeast()
	Southwest()
	North()
	South()
	East()
	West()
	Center()



mob
	EndAutoMovement()
		ingame=1
		step_size=GetSpeed()
		move_x=0
		move_y=0
		x_loc=0
		y_loc=0
		travel_distance=0
		shadow?.SwitchMode(world.tick_lag)
		end_movement_action=""
		bump_movement_action=""

	GetSpeed()
		var/retval
		if(run)
			retval=run_speed
		else
			retval=walk_speed
		retval=retval+(speed_alter*retval)
		retval*=speed_multiplier
		return round(retval,1)


	proc
		Run_Toggle(manual=1)
			if(!ingame || (mid_air && manual && !run))	return
			run = !run
			step_size=GetSpeed()


		#ifdef JUMP
		Jump(jump_height=JUMP_ACCEL)
			if(!ingame||mid_air)
				if(!can_wall_bounce)
					return
			IncreaseHeight(jump_height)//12
		#endif


		#ifdef JUMP
		IncreaseHeight(dist)
			set waitfor=0
			if(can_wall_bounce)
				if(mid_air)
					can_wall_bounce=0
					if(wall_bounces<=0)	return
					wall_bounces--
					wallgrabbed=null
					if(run)
						run=0
						step_size=GetSpeed()
					DoubleJumpfx(src)
			if(run)
				dist/=1.5
			height_accel=dist
			if(client)	client.keys["[client.controls.jump]"]=0
			mid_air=1
			ascend=1
			walk(src,0)
			var/jump_dist,divider=1
			while(height_accel>0)
				StateMachine()
				divider=1
				jump_dist=abs(height_accel)
				jump_dist=round((jump_dist*gravity)/divider,1)
				jump_dist=jump_dist+_height > CEILING ? CEILING - _height : jump_dist
				if(under)	jump_dist=jump_dist+_height > under._height ? under._height - _height : jump_dist
				_height+=jump_dist
				height_gained+=jump_dist
				if(slope_obj)	height_gained=0
				shadow.SwitchMode()
				animate(src,pixel_z=_height,time=1)//,flags=ANIMATION_END_NOW)
				if(client)	animate(client,pixel_z=_height,time=1)//,flags=ANIMATION_END_NOW)
				if(CancelHeightIncrease())
					height_accel=0
					shadow.SwitchMode()
					break
				if (world.tick_usage > 90)
					lagstopsleep()
				else
					sleep(1)//42 - walk, 20 - run
			height_decline=2
			ascend=0

		CancelHeightIncrease()
			var/retval=0
			if(hangtime>0||(can_wall_bounce && wall_bounces==max_wall_bounces)||(gravity==2 && run)||_height==CEILING)
				retval=1
			return retval

		DelayHeightDecrease()
			var/retval=0
			if(wallgrabbed)
				if(!(GetMovementDirection() == wallgrabbed_dir))
					wallgrabbed=null
					wallgrabbed_dir=0
				retval=1
			if(hangtime>0)
				shadow.SwitchMode()
				height_accel=height_decline
				retval=1
			if(!gravity)
				retval=1
			return retval

		Gravity()
			if(mid_air)
				if(DelayHeightDecrease())
					return
				StateMachine()
				if(height_accel>0)
					ascend=1
					height_accel=round(max(height_accel-height_decline*gravity,0),1)
				else
					if(_height>elevation)
						descend=1
						height_accel=round(height_accel-height_decline*gravity,1)
						if(abs(height_accel)>_height)	height_accel=-_height
						var/jump_dist=abs(height_accel),divider=1//,x_moved=0,y_moved=0
						jump_dist=max(round((jump_dist*gravity)/divider,1),0)
						_height-=jump_dist
						height_gained-=jump_dist
						if(slope_obj)	height_gained=0
						_height=max(elevation,_height)
						height_gained=max(0,height_gained)
						animate(src,pixel_z=_height,time=1)
						if(client)	animate(client,pixel_z=_height,time=1)
						shadow.SwitchMode()
					else
						//travel_distance=0//stop all automated movement when landing
						climb_limit=max_climb_limit
						ascend=0
						set_h_accel=0
						hangtime=0
						descend=0
						last_slope_height=_height
						height_gained=0
						gravity=1
						height_accel=0
						height_decline=2
						wall_bounces=max_wall_bounces
						can_wall_bounce=0
						mid_air=0
						step_size=GetSpeed()
						shadow.SwitchMode()
						if(!elevation)
							collide_layer=1
		#endif




		MoveLoop()
			set waitfor=0
			if(!ActivateProc("MoveLoop"))	return
			while(client.keys["numpad1"]||client.keys["numpad2"]||client.keys["numpad3"]||client.keys["numpad4"]||client.keys["numpad5"]||client.keys["numpad6"]||client.keys["numpad7"]||client.keys["numpad8"]||client.keys["numpad9"]||client.keys[client.controls.up]||client.keys[client.controls.down]||client.keys[client.controls.right]||client.keys[client.controls.left])
				if(!ingame)	break
				Movement()
				if (world.tick_usage > 90)
					lagstopsleep()//sleep(0.1)
				else
					sleep(world.tick_lag)
			ActivateProc("MoveLoop",1)


		Movement()
			if(!ActivateProc("Movement"))	return
			if(canMove && client && ingame && !no_move && !travel_distance)
				var/d=GetMovementDirection()
				Step(d,step_size,set_dir=1,slide=1)
			ActivateProc("Movement",1)


		#ifdef JUMP
		#ifdef WALLCLIMB
		ClimbWall()
			if(wallgrabbed)
				if(_height<wallgrabbed._height)
					if(climb_limit>0)
						StepHeightIncrease(round(run_speed/2,1))//go up wall
						if(climb_limit<max_climb_limit*0.5)
							if(run)	Run_Toggle(0)
						climb_limit-=round(run_speed/2,1)
					else
						climb_limit=0
						wallgrabbed=null
						wallgrabbed_dir=0
						return
				if(_height>=wallgrabbed._height)
					wallgrabbed=null
					wallgrabbed_dir=0
					mid_air=0
					Jump(jump_height=6)
		#endif
		#endif


atom
	movable
		New()
			..()


		proc
			GetSpeed()
			EndAutoMovement()

			CrossCheck()

			UncrossedCheck()

			LocationFind(_z)//discover size of instance here
				switch(_z)
					if(1)
						MAP_X=50
						MAP_Y=50
				maxgx=MAP_X*TILE_WIDTH
				maxgy=MAP_Y*TILE_HEIGHT


			Center(atom/movable/M,specs="center")
				if(!M)	return
				var/_gx,_gy
				_gx=M.gx+((M.bound_width-bound_width)/2)
				_gy=M.gy+((M.bound_height-bound_height)/2)
				if(specs=="center-front")
					if(M.dir & NORTH)	_gy=M.gy+M.bound_height+1
					if(M.dir & SOUTH)	_gy=M.gy-bound_height-1
					if(M.dir & EAST)	_gx=M.gx+M.bound_width+1
					if(M.dir & WEST)	_gx=M.gx-bound_width-1
				if(specs=="center-back")
					if(M.dir & NORTH)	_gy=M.gy-bound_height-1
					if(M.dir & SOUTH)	_gy=M.gy+M.bound_height+1
					if(M.dir & EAST)	_gx=M.gx-bound_width-1
					if(M.dir & WEST)	_gx=M.gx+M.bound_width+1
				if(specs=="center-random-right")
					if(M.dir & NORTH)	_gx=M.gx+rand(M.bound_width*0.5,M.bound_width)
					if(M.dir & SOUTH)	_gx=M.gx+rand(0,M.bound_width*0.5)
					if(M.dir & EAST)	_gy=M.gy+rand(0,M.bound_height*0.5)
					if(M.dir & WEST)	_gy=M.gy+rand(M.bound_height*0.5,M.bound_height)
				if(specs=="center-random-left")
					if(M.dir & NORTH)	_gx=M.gx+rand(0,M.bound_width*0.5)
					if(M.dir & SOUTH)	_gx=M.gx+rand(M.bound_width*0.5,M.bound_width)
					if(M.dir & EAST)	_gy=M.gy+rand(M.bound_height*0.5,M.bound_height)
					if(M.dir & WEST)	_gy=M.gy+rand(0,M.bound_height*0.5)
				setPosition(floor(_gx),floor(_gy),M.z)


			setPosition(loc1,loc2,loc3,d,no_box=0,glow=null,__height ,_height_gained,height_adjust=1)
				set waitfor=0
				if(ismovable(loc1))
					var/atom/movable/O=loc1
					O.LocationUpdate()
					if(loc2)	d=loc2
					loc1=O.gx
					loc2=O.gy
					loc3=O.z
					if(istype(src,/visual_fx))
						pixel_z=O._height
					else
						if(O._height && height_adjust)
							if(ismovable(src))
								var/atom/movable/M=src
								M.mid_air=1
								M._height=O._height
								M.height_gained=O.height_gained
								M.pixel_z=O._height
								M.shadow.SwitchMode()
								if(ismob(M))
									var/mob/m=src
									if(m.client)	m.client.pixel_z=O._height
					if(d)	dir=d
				if(!no_box && !(istype(src,/visual_fx/)))
					var/atom/movable/pushloc=DenseInBox(src,bound_width,bound_height,loc1,loc2,loc3)
					if(pushloc && _height<=pushloc._height)
						world<<"[src] is being placed on top of [pushloc]"
						switch(pushloc.dir)
							if(NORTH)
								loc2+=pushloc.bound_height+2
								if(pushloc.bound_height>bound_height*2)	return
							if(SOUTH)
								loc2-=pushloc.bound_height+2//+bound_height
								if(pushloc.bound_height>bound_height*2)	return
							if(EAST)
								loc1+=pushloc.bound_width+2//+bound_width
								if(pushloc.bound_width>bound_width*2)	return
							if(WEST)
								loc1-=pushloc.bound_width+2//+bound_width
								if(pushloc.bound_width>bound_width*2)	return
				LocationFind(loc3)
				loc1=min(maxgx-bound_width,loc1)
				loc1=max(1,loc1)
				loc2=min(maxgy-bound_height,loc2)
				loc2=max(1,loc2)
				var/val1=round(loc1/TILE_WIDTH,1)
				var/val2=round(loc2/TILE_HEIGHT,1)
				val1=min(MAP_X,val1)
				val1=max(1,val1)
				val2=min(MAP_Y,val2)
				val2=max(1,val2)
				var/x_step=loc1-((val1-1)*TILE_WIDTH)
				var/y_step=loc2-((val2-1)*TILE_HEIGHT)
				x_step=max(0,x_step)
				y_step=max(0,y_step)
				x=val1
				y=val2
				z=loc3
				step_x=x_step
				step_y=y_step
				if(d)	dir=d
				if(__height && height_adjust)
					if(istype(src,/visual_fx))
						pixel_z+=__height
					else
						if(ismovable(src))
							var/atom/movable/M=src
							M.mid_air=1
							M._height=__height
							M.height_gained=_height_gained ? _height_gained : __height
							M.pixel_z=__height
							M.shadow.SwitchMode()
							if(ismob(M))
								var/mob/m=src
								if(m.client)	m.client.pixel_z=__height
				LocationUpdate()
				if(grabbed)	grabbed.setPosition(src)

			GetStep(atom/movable/m,d=dir,keepdir=0,returnval=0)
				set waitfor=0
				if(!m)	return
				m.LocationUpdate()
				var/xloc=m.gx,yloc=m.gy
				if(d & NORTH)
					yloc+=bound_height+5
				else if(d & SOUTH)
					yloc-=m.bound_height+5
				else if(d & EAST)
					xloc+=bound_width+5
				else if(d & WEST)
					xloc-=m.bound_width+5
				if(!returnval)
					setPosition(xloc,yloc,m.z,__height=m._height)
					if(!keepdir)
						if(m)	dir=get_dir(src,m)
				else
					x_loc=xloc
					y_loc=yloc
					return

			LocationUpdate(BH=1)
				set waitfor=0
				sleep()
				gx=TILE_WIDTH*(x-1)
				gy=TILE_HEIGHT*(y-1)
				gx+=step_x
				gy+=step_y
				oppositedir=BehindDir(dir)
				if(ismovable(src))
					if(!(istype(src,/visual_fx)))
						if(BH)
							layer=base_layer + 1-(y + y_plus + (step_y + bound_y + bound_height)/TILE_HEIGHT)/world.maxy
						else
							layer=base_layer + 1-(y + y_plus + (step_y + bound_y)/TILE_HEIGHT)/world.maxy
						layer+=layer_add
				var/updatemoved=1
				if(shadow)	shadow.SwitchMode()
				if(ismob(src))
					var/mob/m=src
					if(m.check_move_inputs)
						moved=0
						updatemoved=0
						if(m.client)
							if(m.client.keys["numpad1"]||m.client.keys["numpad2"]||m.client.keys["numpad3"]||m.client.keys["numpad4"]||m.client.keys["numpad5"]||m.client.keys["numpad6"]||m.client.keys["numpad7"]||m.client.keys["numpad8"]||m.client.keys["numpad9"]||m.client.keys[m.client.controls.up]||m.client.keys[m.client.controls.down]||m.client.keys[m.client.controls.right]||m.client.keys[m.client.controls.left])
								updatemoved=1
						else
							if(angle_move||walking)
								updatemoved=1
				if(updatemoved)
					if(gx==lx && gy==ly)
						moved=0
					else
						moved=1
				lx=gx
				ly=gy


			GetDirectionalStep(atom/movable/m,rotation=0,speed=0,readjust=0,user_move=0,loc_only=0,fx=0)
				if(!m)	return
				speed = !speed ? GetSpeed() : speed
				if(travel_distance && travel_distance<speed)	speed=travel_distance
				step_size=speed
				if(!rotation)
					dir=GetDir(src,m)
				else
					var/matrix/M=matrix()
					dir=NORTH
					animate(src,transform=turn(M,Get_Angle(src,m,"north",anti_clockwise=0)),time=1,flags=ANIMATION_LINEAR_TRANSFORM)
				if(loc_only)
					x_loc = x_loc ? x_loc : m.gx+(m.bound_width/2)
					y_loc = y_loc ? y_loc : m.gy+(m.bound_height/2)
					move_x=x_loc-gx
					move_y=y_loc-gy
				else
					move_x=m.gx-gx
					move_y=m.gy-gy
				if(readjust)
					switch(GetDir(src,m))
						if(NORTH,SOUTH)
							move_x/=2
						if(EAST,WEST)
							move_y/=2
				var/x_alter=0,y_alter=0
				/*if(ismob(src))
					var/mob/M=src
					if(user_move)//////////////////////
						var/d=M.GetMovementDirection()
						if(d && M.client)
							switch(GetDir(M,m))
								if(NORTH,SOUTH)
									switch(d)
										if(EAST)
											//M.move_x+=floor(M.step_size/user_move)
											x_alter=floor(M.step_size/user_move)
										if(WEST)
											//M.move_x-=floor(M.step_size/user_move)
											x_alter=-floor(M.step_size/user_move)
								if(EAST,WEST)
									switch(d)
										if(NORTH)
											//M.move_y+=floor(M.step_size/user_move)
											y_alter=floor(M.step_size/user_move)
										if(SOUTH)
											//M.move_y-=floor(M.step_size/user_move)
											y_alter=-floor(M.step_size/user_move)*/
				var/dist=sqrt(move_x*move_x + move_y*move_y)//check against this
				var/scale=step_size/dist
				move_x+=x_alter
				move_y+=y_alter
				move_x*=scale
				move_y*=scale
				if(fx)	Blur(src,-move_x,-move_y,_t=1)


			Move_To(atom/movable/m,_rotation=0,_speed=0,homing=0,_readjust=0,t_dist=0,d_i=0,_loc=0,_fx=0,height_adjust=0)
				set waitfor=0
				if(angle_move)
					if(!travel_distance)	return
					travel_distance=0
					while(angle_move)
						sleep(0)
						sleep(world.tick_lag)
						sleep(-1)
					angle_move=0
				if(!m)	return
				if(ismob(src))
					var/mob/o=src
					o.ingame=0
				_speed = !_speed ? GetSpeed() : _speed
				angle_move=Get_Angle(src,m,"north",anti_clockwise=0)
				travel_distance = !t_dist ? GetDist(src,m) : t_dist
				if(_loc)
					x_loc=0
					y_loc=0
					//travel_distance = GetDist(src,m)
				GetDirectionalStep(m,_rotation,_speed,user_move=d_i,fx=_fx)
				ingame=0
				while(travel_distance>0)
					if(!angle_move)	break
					#ifdef JUMP
					if(height_adjust && (m.mid_air||mid_air) && (m._height!=_height))
						height_adjust=step_size
						if(m._height < _height+height_adjust)	height_adjust = m._height - _height
						StepHeightIncrease(height_adjust)
					#endif
					PixelMove(move_x,move_y)
					travel_distance-=step_size
					if(homing)
						GetDirectionalStep(m,_rotation,_speed,_readjust,d_i,_loc,_fx)
					if (world.tick_usage > 90)
						lagstopsleep()//sleep(0.1)
					else
						sleep(world.tick_lag)
				angle_move=0
				if(_fx)
					RemoveBlur(src)
				EndAutoMovement()

			Grab(atom/movable/m)
				if(grabbed)	UnGrab()
				grabbed=m
				m.grabbedby=src

			UnGrab()
				if(grabbed)
					grabbed.grabbedby=null
					grabbed=null

			PixelMove(x_move, y_move,d)
				if(grabbedby)	return 0
				if(!d)	d=dir
				if(x_move||y_move)
					if(step_size<x_move || step_size<y_move)
						step_size=(max(abs(x_move),abs(y_move)))
					if(x_move>0 && !y_move)	movement_dir = EAST
					if(x_move<0 && !y_move)	movement_dir = WEST
					if(!x_move && y_move>0)	movement_dir = NORTH
					if(!x_move && y_move<0)	movement_dir = SOUTH
					if(x_move>0 && y_move>0)	movement_dir = NORTHEAST
					if(x_move<0 && y_move>0)	movement_dir = NORTHWEST
					if(x_move>0 && y_move<0)	movement_dir = SOUTHEAST
					if(x_move<0 && y_move<0)	movement_dir = SOUTHWEST
					#ifdef JUMP
					SlopeTravel()
					#endif
					//step_size=speed
					. = Move(loc, d, step_x + x_move, step_y + y_move)
					if(grabbed)
						grabbed.PixelMove(x_move,y_move,d)
				else
					return 0

			PixelSlide(x_move, y_move,d)//FOR SLIDING AROUND DENSE OBJECTS
				if(!d)	d=dir
				if(x_move||y_move)
					. = max(PixelMove(x_move,0,d),PixelMove(0 ,y_move,d))//try moving horizontally then vertically separately
				else
					return 0

			Step(_dir,speed,set_dir=1,slide=0,_fx=0)
				if(set_dir)	dir=_dir
				var/_x=0,_y=0
				if(_dir & NORTH)
					_y=1
				if(_dir & SOUTH)
					_y=-1
				if(_dir & EAST)
					_x=1
				if(_dir & WEST)
					_x=-1
				_x*=speed
				_y*=speed
				if(_fx)	Blur(src,-_x,-_y,_t=1)
				if(slide)
					return PixelSlide(_x,_y)
				else
					return PixelMove(_x,_y)

			Walk(dist,d,speed,height_follow=0,height_stop=0,falloff_height=0,height_step)//will not stop walking until _height is 0
				set waitfor=0
				if(!dist)	return
				if(walking)
					if(!travel_distance)	return
					travel_distance=0
					while(walking)
						sleep(0)
						sleep(world.tick_lag)
						sleep(-1)
					walking=0
				speed = speed ? speed : step_size
				dir = d ? d : dir
				walking=1
				travel_distance=dist
				if(falloff_height)//if falloff is enabled
					if(mid_air)//if the caller is mid air
						falloff_height=dist//specify the falloff distance
						gravity=0//and disallow height deductions until the gravity is 0
					else//otherwise disable the flag
						falloff_height=0
				step_size=speed
				ingame=0
				while(travel_distance>0)
					if(!walking)	break
					if(height_follow)//if the movement is set to follow the height of the caller
						if(falloff_height>0)//if a falloff distance is specified
							falloff_height-=step_size//decrease it
							if(falloff_height<=0)//when it reaches zero
								gravity=1//allow height deductions
								//height_follow=0//disable the flag which allows delayed distance reduction
						if(mid_air)//once the caller is mid air
							travel_distance+=step_size//prevent the caller's distance to travel from decreasing
						else//otherwise
							if(height_stop)//if the height_stop flag is activated then stop automated movement when the caller lands
								travel_distance=step_size
								height_follow=0
							else
								height_follow=0//otherwise let the caller continue moving unabated
					#ifdef JUMP
					if(height_step)	StepHeightIncrease(height_step,_time=world.tick_lag)
					#endif
					if(travel_distance>0 && travel_distance<speed)
						step_size=travel_distance
					travel_distance-=step_size
					Step(dir,step_size)
					if (world.tick_usage > 90)
						lagstopsleep()//sleep(0.1)
					else
						sleep(world.tick_lag)
				if(!gravity)	gravity=1
				walking=0
				EndAutoMovement()

			#ifdef JUMP
			StepHeightIncrease(speed,air_borne=1,_height_gained=1,_time=1,cap=0,end_now=0)
				if(!speed)	return
				speed = cap ? (speed>cap? step_size : speed) : speed
				speed = speed+_height > CEILING ? CEILING - _height : speed
				speed = speed+_height < 0 ? 0 - _height : speed
				_height+=speed
				height_gained= _height_gained? height_gained + speed : height_gained
				height_gained=max(0,height_gained)
				shadow.SwitchMode(_time)
				if(!_height)
					mid_air=0
				else
					mid_air=air_borne
				if(ismob(src))
					var/mob/m=src
					m.StateMachine()
					if(m.client)
						if(end_now)
							animate(m.client,pixel_z=_height,time=_time,flags=ANIMATION_END_NOW)
						else
							animate(m.client,pixel_z=_height,time=_time)
				if(end_now)
					animate(src,pixel_z=_height,time=_time,flags=ANIMATION_END_NOW)
				else
					animate(src,pixel_z=_height,time=_time)
			#endif

			EdgeCheck(obj/O)
				if(!O)
					y_plus=0
					on_edge=0
					return
				if(!(src in bounds(O)))
					y_plus=0
					on_edge=0
					return
				var/boundary_y=O.gy+O.bound_height,boundary_x=O.gx+O.bound_width,_gx,_gy
				_gx=(TILE_WIDTH*(x-1))+step_x
				_gy=(TILE_HEIGHT*(y-1))+step_y

				//FOR NORTH
				if(_gy>boundary_y-bound_height)
					on_edge=NORTH
					y_plus=-1
					//world<<"north edge"
				//FOR WEST
				else if(_gx<O.gx)
					on_edge=WEST
					//world<<"west edge"
				//FOR SOUTH
				else if(_gy<O.gy)
					on_edge=SOUTH
					//world<<"south edge"
				//FOR EAST
				else if(_gx>boundary_x-bound_width)
					on_edge=EAST
					//world<<"east edge"
				else
					//world<<"center"
					on_edge=0
					y_plus=0


		Move()
			var/_move=0
			if(canMove)
				_move=1
			if(grabbedby)	return
			if(_move)
				.=..()
				if(ismob(src))
					var/mob/m=src
					m.EdgeCheck(m.occupying)
				movement_dir=0
				if(grabbed)
					if(!mid_air)	grabbed.setPosition(src,no_box=1,height_adjust=0)


		Uncross(atom/movable/m)
			.=m.on_uncross(src,..())


	proc
		on_cross(atom/obstacle,r)
			return r

		on_uncross(atom/obstacle,r)
			return r





mob
	Bump(atom/movable/o)
		//switch(movement_bump_action)
		#ifdef JUMP
		if(isobj(o))
			var/obj/O=o
			if(!O.active)
				#ifdef WALLBOUNCE
				if(mid_air && wall_bounces>0)
					if((run || wallgrabbed) || wall_bounces!=max_wall_bounces)
						can_wall_bounce=1
				if(run && !wallgrabbed)
					switch(dir)//check to make sure your the object is wide enough to accomodate the player
						if(NORTH,SOUTH)
							if(gx>=O.gx && (gx+bound_width)<=O.gx+O.bound_width)
								wallgrabbed=O
								wallgrabbed_dir=dir
						if(EAST,WEST)
							if(gy>=O.gy && (gy+bound_height)<=O.gy+O.bound_height)
								wallgrabbed=O
								wallgrabbed_dir=dir
				#endif

				#ifdef WALLCLIMB
				if(wallgrabbed == O)
					if(slope_obj && (movement_dir & slope_obj.slope_dir))
						if(_height<slope_obj._height||slope_obj._height>=wallgrabbed._height)
							wallgrabbed=null
							wallgrabbed_dir=0
							return
					ClimbWall()
				#endif
				..()
		#endif

	on_cross(atom/O,r)//O is the obstacle
		var/retval=r
		if(O.collide_layer==collide_layer)
			if(O.density)
				retval=0
			else
				retval=1
		else if(collide_layer>O.collide_layer)
			retval=1
		else
			retval=0
		if(ismob(O))
			var/mob/m=O
			if(bound_height>=abs(_height-m._height))
				retval=0
			else
				retval=1
			if(phase_through)
				phase_through=max(phase_through-1,0)
				retval=1
			if(m.phase_through)
				retval=1
		if(isobj(O))
			var/obj/o=O
			if(o.density)
				if(o.power)
					if(bound_height>=abs(_height-o._height))
						retval=0
					else
						retval=1
			else
				retval=1
		if(O.collide_layer==EDGE_CLAYER)
			retval=0
		if(no_dense)	retval=1
		return retval

	on_uncross(atom/O,r)
		var/retval
		if(O.collide_layer==EDGE_CLAYER)
			retval=0
		else
			retval=1
		return retval


obj
	on_cross(atom/O,r)//O is the obstacle
		var/retval=r
		if(O.collide_layer==collide_layer)
			if(O.density)
				retval=0
			else
				retval=1
		else if(collide_layer>O.collide_layer)
			retval=1
		else
			retval=0
		if(ismob(O))
			var/mob/m=O
			if(m.bound_height>=abs(m._height-_height))//m is bumping into src
				//grab ledge execution here
				retval=0
			else
				retval=1
			if(phase_through)
				phase_through=max(phase_through-1,0)
				retval=1
			if(m.phase_through)
				retval=1
		if(isobj(O))
			var/obj/o=O
			if(o.density)
				if(o.power)
					if(bound_height>=abs(_height-o._height))
						retval=0
					else
						retval=1
			else
				retval=1
		if(O.collide_layer==EDGE_CLAYER)
			retval=0
		return retval

	on_uncross(atom/O,r)
		var/retval
		if(O.collide_layer==EDGE_CLAYER)
			retval=0
		else
			retval=1
		return retval

atom
	movable
		Cross(atom/movable/o)//IS RAN FOR EVERY MOVEMENT OPERATION INSIDE BOUNDS
			return CrossCheck(o)

		Crossed(atom/movable/o)
			return ..()

		CrossCheck(atom/movable/o,h_alter=1)//IS RAN FOR EVERY MOVEMENT OPERATION INSIDE BOUNDS||returns 1 for any object we can pass through, returns 2 for any object we
			//can land upon(src is the object being entered, o is the object entering)
			var/retval=o.on_cross(src,..())
			if(o.no_dense)	return retval
			#ifdef JUMP
			if(ismob(src))
				var/mob/m=src
				if(isobj(o))
					var/obj/O=o
					if(O.move_trigger)
						if(O._height<=_height)
							O.CrossCheck(m)
						else
							m.under=O
				return retval
			var/h_gained_alter=h_alter
			if(_height>0 && can_enter)
				if(ismob(o))
					var/mob/m=o//CHECK THIS AGAINST THE LOCATION WHERE THE MOB SHOULD BE
					if(m._height>=RelHeightLoc(src,m,elevated=1))//if the mob's total _height is more than that of the elev obj
						if(m.occupying)//if the mob is occupying an elev obj
							h_gained_alter=0
							if(src in bounds(m.occupying))//if the mob is within the bounds of the elev obj
								if(gy>=m.occupying.gy)//if the occupied elev obj is higher up on the map than the active obj (i.e - on top of it)
									m.height_gained=max(0,m.height_gained-RelHeightLoc(src,m))//alter the appropriate variables to register the mob as on top of the  active obj
									m.elevation=RelHeightLoc(src,m,elevated=1)
									m.occupying=src
									if(m.shadow)	m.shadow.SwitchMode()
									retval=2
								return retval
							if(m.occupying._height>_height)//if the user is already occupying something, don't fully register them as having fully stepped off until the
								//user fully leaves the bounds of the occupied item
								m.on_edge=1
								retval=2//bug caused by this workaround
								//world<<"[m] is standing over [src] at the edge of [m.occupying]"
								return retval
							else
								h_gained_alter=1
						if(h_gained_alter)
							m.height_gained=max(0,m.height_gained-RelHeightLoc(src,m,elevated=1))//alter the appropriate variables to register the mob as on top of the  active obj
						m.elevation=RelHeightLoc(src,m,elevated=1)
						if(m._height>m.elevation)	m.mid_air=1
						if(slope_start>=0)
							m.slope_obj=src
							m.SlopeTravel()
						m.occupying=src
						if(mid_air)
							m.layer_add=layer_add+1
							m.check_move_inputs=1
						retval=2
					else
						if(mid_air)//if the obj the mob is trying to enter is airborne
							if(m.bound_height>=abs(m._height-_height))//if the mob's bound_height is less thanthe difference of the two heights then that means the mob is
							//high enough to hit into the platform, in which case we deny entry
								retval=0
							else//otherwise
								retval=1//we allow entry, but at the basic level. Do not alter the mob's height vars
								m.under=src//set the mob to be under it, so that it will be able to tell that normal uncross behaviour is not necessary when exiting
							return retval
						else
							retval=0//otherwise, the mob cant enter the object
						retval=0
					if(m.shadow)	m.shadow.SwitchMode()
					m.on_edge=0
			#endif
			return retval



		UncrossedCheck(atom/movable/o)//o is the atom leaving, src is the object being left
			var/retval=1
			if(o.no_dense)	return retval
			#ifdef JUMP
			var/mid_activate=0
			if(o?.slope_obj==src)
				o?.slope_obj=null
				o.height_gained=0
			if(!ismob(o) && ismob(src))//if you're not a mob and you're crossing into a mob
				o.UncrossedCheck(src)
			if(_height>0 && can_enter)
				if(ismob(o))
					var/mob/m=o
					var/obj/s_o=m.slope_obj
					if(m.under==src)
						m.under=null
					if(m.elevation>=RelHeightLoc(src,m,elevated=1)||s_o?._height<=_height)
						if(m.occupying!=src)
							return 0
						m.height_gained+=m.elevation//RelHeightLoc(src,m,elevated=0)
						m.elevation-=RelHeightLoc(src,m,elevated=0)
						m.elevation=max(0,m.elevation)
						m.occupying=null
						m.slope_obj=null
						m.last_slope_height=0
						mid_activate=1
						for(var/atom/movable/l in obounds(m)-src)//check for anything to fall on below the movable
							var/result=l.CrossCheck(m)
							if(result==2)//if we are higher or at the same height as the new spot
								if(m._height>RelHeightLoc(l,m,elevated=1))//if we are higher than the new spot
									mid_activate=1//fall
									break
								else//otherwise
									mid_activate=0//dont fall
									break
						m.mid_air = mid_activate
						if(mid_air)
							m.layer_add=0
							m.check_move_inputs=0
					if(m.shadow)	m.shadow.SwitchMode()
			#endif
			return retval

		Uncrossed(atom/movable/o)//IS RAN WHEN LEAVING BOUNDS
			return UncrossedCheck(o)