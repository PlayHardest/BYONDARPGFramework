world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default
	mob=/mob/Player
	view = 6		// show up to 6 tiles outward from center (13x13 view)

	New()
		..()
		Effect_Prep()



proc
	lagstopsleep()
		var/tickstosleep = 1
		do
			sleep(world.tick_lag*tickstosleep)
			tickstosleep *= 2 //increase the amount we sleep each time since sleeps are expensive (5-15 proc calls)
		while(world.tick_usage > 75 && (tickstosleep*world.tick_lag) < 32) //stop if we get to the point where we sleep for seconds at a time


proc
	Trim(msg,char)//remove char from the edges of text received
		var/back_edge=findtext(msg,char,-1) ? findtext(msg,char,-1) : 0
		var/front_edge=findtext(msg,char,1,2) ? findtext(msg,char,1,2)+1 : 1
		if(front_edge>length(msg))
			return ""
		while(back_edge||front_edge>1)
			msg=copytext(msg,front_edge,back_edge)
			back_edge=findtext(msg,char,-1) ? findtext(msg,char,-1) : 0
			front_edge=findtext(msg,char,1,2) ? findtext(msg,char,1,2)+1 : 1
		return msg


	BehindDir(direction)
		if(!direction)	return
		switch(direction)
			if(NORTH)	return SOUTH
			if(SOUTH)	return NORTH
			if(EAST)	return WEST
			if(WEST)	return EAST
			if(NORTHEAST)	return SOUTHWEST
			if(NORTHWEST)	return SOUTHEAST
			if(SOUTHEAST)	return NORTHWEST
			if(SOUTHWEST)	return NORTHEAST

	sqr(n)
		if(!isnum(n))	return 0
		return n*n

	GetDist(atom/movable/o,atom/movable/ref,polarity=0,xloc=0,yloc=0,h=0)//o is user, ref is target
		if(!o||!ref)	return 0
		ref.LocationUpdate()
		o.LocationUpdate()
		var/opp,adj,retval
		opp=ref.gx-o.gx
		adj=(ref.gy+(h ? ref._height : 0))-(o.gy+(h==1 ? o._height : 0))
		if(xloc||yloc)
			opp=ref.gx-xloc
			adj=(ref.gy+(h ? ref._height : 0))-(yloc+(h==1 ? o._height : 0))
		retval=sqrt(sqr(opp)+sqr(adj))
		if(polarity)
			var/angle=Get_Angle(o,ref,perspective="source")
			if(angle>90||angle<-90)
				retval = -retval
		return retval

	GetDir(atom/a,atom/ref,angle)
		var/dirlist=list(NORTH,SOUTH,EAST,WEST)
		var/retval
		if(ref)
			retval=get_dir(a,ref)
			if(!angle)	angle=Get_Angle(a,ref,perspective="-")
		if(!(retval in dirlist))
			if(angle>=ACW_WEST_ANGLE && angle<=ACW_SOUTH_ANGLE)
				if(angle>=ACW_WEST_ANGLE && angle<=ACW_SOUTHWEST_ANGLE)
					retval=WEST
				else
					retval=SOUTH
			if(angle>=ACW_SOUTH_ANGLE && angle<=ACW_EAST_ANGLE)
				if(angle>=ACW_SOUTH_ANGLE && angle<=ACW_SOUTHEAST_ANGLE)
					retval=SOUTH
				else
					retval=EAST

			if(angle>=ACW_EAST_ANGLE && angle<=ACW_NORTH_ANGLE)
				if(angle>=ACW_EAST_ANGLE && angle<=ACW_NORTHEAST_ANGLE)
					retval=EAST
				else
					retval=NORTH

			if(angle>=ACW_NORTH_ANGLE && angle<=ACW_NORTH_ANGLE+90)
				if(angle>=ACW_NORTH_ANGLE && angle<=ACW_NORTHWEST_ANGLE)
					retval=NORTH
				else
					retval=WEST
		return retval

	DenseInBox(atom/movable/o,bx,by,_gx,_gy,_z,self=0)
		if(isobj(o))	return
		var/obj/O=Object_Pool(/obj)
		var/retval=0
		O.bound_width=bx
		O.bound_height=by
		O.setPosition(_gx,_gy,_z,no_box=1)
		if(self)
			self=o
		else
			self=null
		for(var/atom/movable/M in bounds(O)-self)
			if(M.density && M.collide_layer>=o.collide_layer)//==EDGE_CLAYER)
				if(o.bound_height>=abs(o._height-M._height))
					retval=M
					break
		del O
		return retval



	Get_Angle(atom/movable/o,atom/movable/ref,perspective="source",anti_clockwise=1,_x_loc,_y_loc,d,x_val,y_val,_move_h=0)//increases in an anti clockwise fashion
		//0 lies on WEST||o = source, ref = target,
		var/retval=0
		if((o || (_x_loc && _y_loc)) && ref)
			ref.LocationUpdate()
			if(o)	o.LocationUpdate()
			var/val1,val2,_dir
			if(_x_loc && _y_loc)
				val1=_x_loc-ref.gx
				val2=_y_loc-ref.gy + (_move_h ? (o._height-ref._height) : 0)
				retval = atan2(val1,val2)
				_dir= d ? d : o.dir
			else
				val1=o.gx-ref.gx
				val2=o.gy-ref.gy + (_move_h ? (o._height-ref._height) : 0)
				if(x_val || y_val)
					val1 = x_val
					val2 = y_val
				if(o.z==ref.z)
					retval = atan2(val1,val2)
				else
					return 0
				_dir= d ? d : o.dir
			switch(perspective)
				if("north")
					retval+=NORTH_ANGLE
					anti_clockwise=0
					if(retval>359)	retval-=360
				if("east")
					retval+=EAST_ANGLE
					anti_clockwise=0
					if(retval>359)	retval-=450
				if("south")
					retval+=SOUTH_ANGLE
					anti_clockwise=0
					if(retval>359)	retval-=540
				if("west")
					anti_clockwise=0
				if("northeast")
					retval+=NORTHEAST_ANGLE
					anti_clockwise=0
					if(retval>359)	retval-=405
				if("northwest")
					retval+=NORTHWEST_ANGLE
					anti_clockwise=0
					if(retval>359)	retval-=315
				if("southeast")
					retval+=SOUTHEAST_ANGLE
					anti_clockwise=0
					if(retval>359)	retval-=495
				if("southwest")
					retval+=SOUTHWEST_ANGLE
					anti_clockwise=0
					if(retval>359)	retval-=585
				if("source")
					if(!o)	return
					switch(_dir)
						if(NORTH)
							retval+=90
							if(retval>359)	retval-=360
						if(SOUTH)
							retval-=90
							if(retval<0)	retval+=360
						if(EAST)
							retval-=180
							if(retval<0)	retval+=360
						if(NORTHEAST)
							retval+=135
							if(retval>359)	retval-=360
						if(NORTHWEST)
							retval+=45
							if(retval>359)	retval-=360
						if(SOUTHEAST)
							retval-=135
							if(retval<0)	retval+=360
						if(SOUTHWEST)
							retval-=45
							if(retval<0)	retval+=360
					if(retval>180)
						retval-=360
		if(!anti_clockwise)	retval=-retval
		return retval

	Object_Pool(typepath,string,obj/s=null,default=1,creation_params=null,_new=0)//generation_string - var name || StringGenerate() - proc name
		//generationstring is used to fetch a unique item, will see more use with items and prototyping
		if(s)
			if(obj_pool.len>200)
				s.destroy=1
				s.loc=null
				return 0
			if(s.destroy)	return 0
			walk(s,0)
			s.angle_move=0
			var/list/l=obj_pool[s.type]
			if(!l)
				l = list()
			s.loc=null
			s.generation_string=s.StringGenerate()
			if(s in l)	return 1
			l+=s
			obj_pool[s.type]=l
			s.expire_time=world.realtime+6000
			s.DelayedDestroy()
		else
			var/atom/movable/i
			if(typepath)
				if(!ispath(typepath))	return null
				var/list/o=obj_pool[typepath]
				if(o && o.len>=1)
					if(string)
						for(var/atom/a in o)
							if(string==a.generation_string)
								i=a
								o-=i
					else
						i=o[o.len]//o[max(1,o.len-1)]
						o[o.len]=null
			if(i)
				world<<i.type
				var/list/l=obj_pool[i.type]
				l-=i
				if(default)	i.Default()
				if(creation_params)
					if(_new)
						i.New(creation_params)
					else
						i.Create(creation_params)
			else
				if(ispath(typepath))
					if(creation_params)
						if(_new)
							i=new typepath(arglist(creation_params))
						else
							i=new typepath
							i.Create(creation_params)
					else
						i=new typepath
			return i


atom
	movable
		proc
			Create()
			Initialize()


			Default()
				for(var/v in vars)
					if(!issaved(vars[v]))	continue
					if(vars[v]!=initial(vars[v]))
						vars[v]=initial(vars[v])
				for(var/s in reset_vars)
					if(islist(vars[s]))
						vars[s]=list()
					else
						vars[s]=initial(vars[s])



			StringGenerate()



obj
	proc
		Activate()
		DeActivate()


		DelayedDestroy()//CONVERT THIS INTO A GLOBAL PROC PLEASE
			set waitfor=0
			destroy=1
			while(world.realtime<expire_time)
				if(!(src in obj_pool[type]) && !(src in visual_effects))
					destroy=0
					break
				sleep(world.tick_lag)
				sleep(-1)
			if(destroy)
				if(src in visual_effects)
					visual_effects-=src
				else
					var/list/l=obj_pool[type]
					if(l)
						l-=src
						obj_pool[type]=l
					else
						obj_pool-=src
				loc=null

mob
	proc
		AnimationPlay(newstate,playspeed=1,states)
			set waitfor=0
			if(play_anim && !cancel_anim)	return
			if(play_anim && cancel_anim)
				while(play_anim)
					sleep(world.tick_lag)
					sleep(-1)
			play_anim=1
			no_state=1
			cancel_anim=0
			cur_anim=newstate
			var/exit=0
			for(var/i = 1 to states)
				if(cancel_anim)
					cancel_anim=0
					exit=1
					break
				animate(src,icon_state="[cur_anim][i]",time=0)
				sleep(playspeed)
			if(!exit && last_frame_static>0)
				for(var/i=1 to last_frame_static)
					if(cancel_anim)
						cancel_anim=0
						break
					sleep(1)
				last_frame_static=0
			no_state=0
			play_anim=0


		ActivateProc(_proc,remove=0)
			if(!remove)
				if(activeprocs[_proc])	return 0
				activeprocs[_proc]=1
				return 1
			else
				if(activeprocs[_proc])
					activeprocs[_proc]=0
					activeprocs-=_proc


		StateMachine(_time=30,over_ride=0)
			set waitfor=0
			if(!over_ride)
				active_time=min(MAX_ACTIVE_TIME,active_time+_time)
			else
				active_time=_time
			if(old_state)
				return
			if(!ActivateProc("StateMachine"))	return
			while(src)
				LocationUpdate()
				#ifdef JUMP
				Gravity()
				#endif
				if(active_time<=0)
					active_time=0
					no_state=0
					old_state=""
					break
				if(!no_state)
					var/newstate="idle"
					if(moved)
						if(run)
							newstate="run"
						else
							newstate="walk"
					if(mid_air)
						if(ascend)
							newstate="ascend"
						if(descend)
							newstate="descend"
						if(run)
							newstate="dash"
					if(newstate in animationstates)
						no_state=1
						AnimationPlay(newstate,animationspeed[newstate],animationstates[newstate])
						active_time = active_time < animationstates[newstate] ? animationstates[newstate] : active_time
					else
						if(old_state!=newstate)
							old_state=newstate
							animate(src,icon_state=newstate,time=0)
				active_time--
				if (world.tick_usage > 90)
					lagstopsleep()//sleep(0.1)
				else
					sleep(1)
			ActivateProc("StateMachine",1)
